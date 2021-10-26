unit uMain;

interface

uses
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.Variants,
  System.Classes,
  System.Generics.Collections,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  Vcl.StdCtrls, Vcl.ComCtrls;

type
  TForm4 = class(TForm)
    Button1: TButton;
    eZip: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    eAddr1: TEdit;
    Label3: TLabel;
    eAddr2: TEdit;
    Label4: TLabel;
    Label5: TLabel;
    Edit1: TEdit;
    Edit2: TEdit;
    Label6: TLabel;
    Edit3: TEdit;
    Label7: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Edit1KeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form4: TForm4;

implementation

uses
  Smart.ZipFinder,
  Smart.ZipFinder.Popup;

{$R *.dfm}

procedure TForm4.Button1Click(Sender: TObject);
var
  LAddress: string;
  LZipCode: string;
begin
  if TZipFinderPopup.Execute(LZipCode, LAddress) then
  begin
    eZip.Text := LZipCode;
    eAddr1.Text := LAddress;
  end;
end;

procedure TForm4.Edit1KeyPress(Sender: TObject; var Key: Char);
var
  LAddress: string;
  LZipCode: string;
begin
  if Key = #13 then
  begin
    Key := #0;
    if TZipFinderPopup.Execute(Edit1.Text, LZipCode, LAddress) then
    begin
      Edit3.Text := LZipCode;
      Edit1.Text := LAddress;
      Edit2.SetFocus;
    end;
  end;
end;

procedure TForm4.FormCreate(Sender: TObject);
begin
  // 검색 API를 위한 초기화작업

  TZipFindAPI.APIKey := '발급받은 API키를 여기에 넣는다';
  TZipFindAPI.MaxCount := 2000;     // 최대검색건수
end;

end.
