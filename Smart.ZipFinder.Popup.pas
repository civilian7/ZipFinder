unit Smart.ZipFinder.Popup;

interface

uses
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.Variants,
  System.Classes,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  Vcl.ComCtrls,
  Vcl.StdCtrls,
  Vcl.ExtCtrls,
  Smart.ZipFinder;

type
  TZipFinderPopup = class(TForm)
    lvZip: TListView;
    pnlSearch: TPanel;
    eText: TLabeledEdit;
    btnSearch: TButton;
    StatusBar1: TStatusBar;

    procedure lvZipDblClick(Sender: TObject);
    procedure lvZipKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure btnSearchClick(Sender: TObject);
    procedure eTextKeyPress(Sender: TObject; var Key: Char);
    procedure FormShow(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    FAddress: string;
    FZipCode: string;
    FZipFinder: IZipFinder;

    procedure FillData;
    function  Find: Boolean;
    procedure SelectItem;
  protected
    property Address: string read FAddress;
    property ZipCode: string read FZipCode;
  public
    constructor Create(AOwner: TComponent); override;

    /// <summary>
    ///  우편번호 검색창을 실행한다
    /// </summary>
    /// <param name="AZipCode">검색된 우편번호</param>
    /// <param name="AAddress">검색된 주소</param>
    /// <returns>자료가 검색된 경우에 True를 반환한다</returns>
    class function Execute(out AZipCode, AAddress: string): Boolean; overload; static;
    /// <summary>
    ///  우편번호 검색창을 실행한다
    /// </summary>
    /// <param name="AKeyword">검색할 우편번호</param>
    /// <param name="AZipCode">검색된 우편번호</param>
    /// <param name="AAddress">검색된 주소</param>
    /// <returns>자료가 검색된 경우에 True를 반환한다</returns>
    class function Execute(const AKeyword: string; out AZipCode, AAddress: string): Boolean; overload; static;
  end;

implementation

{$R *.dfm}

{ TTZipFindPopup }

constructor TZipFinderPopup.Create(AOwner: TComponent);
begin
  inherited;

  FZipFinder := TZipFinder.New;
end;

procedure TZipFinderPopup.eTextKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  begin
    Key := #0;
    Find;
  end;
end;

procedure TZipFinderPopup.btnSearchClick(Sender: TObject);
begin
  Find;
end;

class function TZipFinderPopup.Execute(out AZipCode, AAddress: string): Boolean;
begin
  with TZipFinderPopup.Create(nil) do
  begin
    Position := poMainFormCenter;

    Result := (ShowModal = mrOk);
    if Result then
    begin
      AZipCode := ZipCode;
      AAddress := Address;
    end;
    Free;
  end;
end;

class function TZipFinderPopup.Execute(const AKeyword: string; out AZipCode, AAddress: string): Boolean;
begin
  with TZipFinderPopup.Create(nil) do
  begin
    Position := poMainFormCenter;

    if FZipFinder.Execute(AKeyword) then
    begin
      // 검색 성공
      if FZipFinder.Count = 1 then
      begin
        // 결과가 1건이면 결과를 바로 넘겨준다
        AZipCode := FZipFinder[0].ZipCode;
        AAddress := FZipFinder[0].Address1;
      end
      else
      begin
        StatusBar1.SimpleText := FZipFinder.ErrorMessage;
        eText.Text := AKeyword;
        // 결과가 여러건이면 사용자가 선택하도록 한다
        FillData;

        Result := (ShowModal = mrOk);
        if Result then
        begin
          AZipCode := ZipCode;
          AAddress := Address;
        end;
      end;
    end
    else
    begin
      // 검색 실패시 창을 띄워준다
      eText.Text := AKeyword;
      eText.SelectAll;

      Result := (ShowModal = mrOk);
      if Result then
      begin
        AZipCode := ZipCode;
        AAddress := Address;
      end;
    end;
    Free;
  end;
end;

procedure TZipFinderPopup.FillData;
var
  i: Integer;
  LListItem: TListItem;
begin
  lvZip.Items.BeginUpdate;
  try
    for i := 0 to FZipFinder.Count-1 do
    begin
      LListItem := lvZip.Items.Add;
      LListItem.Caption := FZipFinder[i].ZipCode;
      LListItem.SubItems.Add(FZipFinder.Items[i].Address1);
    end;

    if Active and lvZip.CanFocus then
      lvZip.SetFocus;

    lvZip.ItemIndex := 0;
  finally
    lvZip.Items.EndUpdate;
  end;
end;

function TZipFinderPopup.Find: Boolean;
begin
  StatusBar1.SimpleText := '자료를 검색하고 있습니다...';
  StatusBar1.Refresh;

  lvZip.Items.Clear;
  lvZip.Refresh;

  Result := FZipFinder.Execute(eText.Text);
  if Result then
  begin
    if FZipFinder.Count = 1 then
    begin
      // 결과가 1건이면 결과를 바로 넘겨준다
      FAddress := FZipFinder[0].Address1;
      FZipCode := FZipFinder[0].ZipCode;

      ModalResult := mrOk;
    end
    else
    begin
      // 결과가 여러건이면 사용자가 선택하도록 한다
      FillData;
    end;
  end
  else
    eText.SelectAll;

  StatusBar1.SimpleText := FZipFinder.ErrorMessage;
end;

procedure TZipFinderPopup.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Key = VK_ESCAPE then
  begin
    Key := 0;
    ModalResult := mrCancel;
  end;
end;

procedure TZipFinderPopup.FormShow(Sender: TObject);
begin
  if FZipFinder.Count > 0 then
  begin
    lvZip.ItemIndex := 0;
    lvZip.SetFocus;
  end;
end;

procedure TZipFinderPopup.lvZipDblClick(Sender: TObject);
begin
  SelectItem;
end;

procedure TZipFinderPopup.lvZipKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Key = VK_RETURN then
  begin
    Key := 0;
    SelectItem;
  end;
end;

procedure TZipFinderPopup.SelectItem;
begin
  if lvZip.Selected <> nil then
  begin
    FAddress := FZipFinder[lvZip.ItemIndex].Address1;
    FZipCode := FZipFinder[lvZip.ItemIndex].ZipCode;

    ModalResult := mrOk;
  end;
end;

end.
