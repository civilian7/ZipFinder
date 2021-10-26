unit Smart.ZipFinder;

interface

uses
  System.SysUtils,
  System.Variants,
  System.Classes,
  System.Generics.Collections,
  System.Net.HttpClient;

type
  TZipItem = class
  private
    FAddress1: string;
    FAddress2: string;
    FZipCode: string;
  public
    /// <summary>
    ///  도로명주소
    /// </summary>
    property Address1: string read FAddress1 write FAddress1;
    /// <summary>
    ///  지번주소
    /// </summary>
    property Address2: string read FAddress2 write FAddress2;
    /// <summary>
    ///  우편번호
    /// </summary>
    property ZipCode: string read FZipCode write FZipCode;
  end;

  TZipItems = TObjectList<TZipItem>;

  IZipFinder = interface
    ['{F66D0FC0-8F22-456C-9BB9-AC297C0A19DB}']
    procedure Clear;
    function  Execute(const AKeyWord: string): Boolean;
    function  GetCount: Integer;
    function  GetErrorMessage: string;
    function  GetItem(Index: Integer): TZipItem;

    property Count: Integer read GetCount;
    property ErrorMessage: string read GetErrorMessage;
    property Items[Index: Integer]: TZipItem read GetItem; default;
  end;

  TZipFindAPI = class sealed
  strict private
    class var
      FApiKey: string;
      FMaxCount: Integer;
      FUrl: string;

    class constructor Create;
  public
    class property ApiKey: string read FApiKey write FApiKey;
    class property MaxCount: Integer read FMaxCount write FMaxCount;
    class property Url: string read FUrl write FUrl;
  end;

  TZipFinder = class(TInterfacedObject, IZipFinder)
  strict private
    const
      AGENT_NAME = 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/95.0.4638.54 Safari/537.36';
  private
    FErrorMessage: string;
    FHttpClient: THttpClient;
    FItems: TObjectList<TZipItem>;

    function  GetCount: Integer;
    function  GetErrorMessage: string;
    function  GetItem(Index: Integer): TZipItem;
    function  HttpGet(const AKeyword: string; out AResponse: string; const APage: Integer = 1): Integer;
  public
    constructor Create;
    destructor Destroy; override;

    class function New: IZipFinder;

    procedure Clear;
    function  Execute(const AKeyWord: string): Boolean;

    property Count: Integer read GetCount;
    property ErrorMessage: string read GetErrorMessage;
    property Items[Index: Integer]: TZipItem read GetItem; default;
  end;

implementation

uses
  System.NetEncoding,
  Xml.XmlIntf,
  Xml.XmlDoc;

{ TZipFindAPI }

class constructor TZipFindAPI.Create;
begin
  FApiKey := '';
  FMaxCount := 200;
  FURL := 'http://biz.epost.go.kr/KpostPortal/openapi2';
end;

{ TZipFinder }

constructor TZipFinder.Create;
begin
  FErrorMessage := '';
  FHttpClient := THttpClient.Create;
  FHttpClient.UserAgent := AGENT_NAME;
  FItems := TZipItems.Create(True);
end;

destructor TZipFinder.Destroy;
begin
  FItems.Free;

  inherited;
end;

procedure TZipFinder.Clear;
begin
  FItems.Clear;
end;

function TZipFinder.Execute(const AKeyWord: string): Boolean;
var
  LResponseCode: Integer;
  LResponseData: string;
  LItem: TZipItem;
  LXmlDocument: IXmlDocument;
  LXmlData: IXmlNode;
  LXmlNode: IXMLNode;
  LXmlRootNode: IXMLNode;
  LCurrentPage: Integer;
  LTotalCount: Integer;
  LTotalPage: Integer;
begin
  Result := True;

  FErrorMessage := '';
  FItems.Clear;
  LCurrentPage := 1;
  LTotalPage := 0;

  while (True) do
  begin
    LResponseCode := HttpGet(AkeyWord, LResponseData, LCurrentPage);
    if (LResponseCode = 200) then
    begin
      LXmlDocument := LoadXMLData(LResponseData);
      LXmlDocument.Active := True;
      LXmlRootNode := LXmldocument.DocumentElement;

      // 우편번호를 검색할 수 없는 경우에는 루트 엘리먼트가 <error>로 시작한다
      if LXmlRootNode.NodeName = 'error' then
      begin
        FErrorMessage := LXmlRootNode.ChildNodes.FindNode('message').Text;
        Exit(False);
      end;

      // 검색결과를 파싱한다
      LXmlNode := LXmlRootNode.ChildNodes['pageinfo'];

      LTotalCount := LXmlNode.ChildNodes.FindNode('totalCount').Text.ToInteger;
      LTotalPage := LXmlNode.ChildNodes.FindNode('totalPage').Text.ToInteger;
      LCurrentPage := LXmlNode.ChildNodes.FindNode('currentPage').Text.ToInteger;

      // 조회결과 데이터가 최대 데이터 크기보다 큰경우의 처리
      if (LTotalCount > TZipFindApi.MaxCount) then
      begin
        FErrorMessage := Format('데이터가 너무 많습니다(%d건)', [LTotalCount]);
        Exit(False);
      end;

      // <itemlist></itemlist> 의 첫번째 항목을 구한다
      LXmlData := LXmlRootNode.ChildNodes['itemlist'].ChildNodes.First;

      while Assigned(LXmlData) do
      begin
        LItem := TZipItem.Create;
        LItem.ZipCode := LXmlData.ChildValues['postcd'];
        LItem.Address1 := LXmlData.ChildValues['address'];
        LItem.Address2 := LXmlData.ChildValues['addrjibun'];

        FItems.Add(LItem);

        LXmlData := LXmlData.NextSibling;
      end;
    end
    else
    begin
      FErrorMessage := Format('통신오류(%d)가 발생했습니다', [LResponseCode]);
      Exit(False);
    end;

    if (LCurrentPage >= LTotalPage) then
      Break;

    Inc(LCurrentPage);
  end;

  FErrorMessage := Format('%d 건이 검색되었습니다', [Count]);
end;

function TZipFinder.GetCount: Integer;
begin
  Result := FItems.Count;
end;

function TZipFinder.GetErrorMessage: string;
begin
  Result := FErrorMessage;
end;

function TZipFinder.GetItem(Index: Integer): TZipItem;
begin
  Result := FItems[Index];
end;

function TZipFinder.HttpGet(const AKeyword: string; out AResponse: string; const APage: Integer): Integer;
var
  LResponse: IHttpResponse;
  LURL: string;
begin
  LURL := Format('%s?regkey=%s&target=postNew&query=%s&countPerPage=%d&currentPage=%d',
   [TZipFindAPI.Url, TZipFindAPI.ApiKey, TNetEncoding.URL.Encode(AKeyWord), 50, APage]);

  LResponse := FHttpClient.Get(LURL);
  Result := LResponse.StatusCode;
  if Result = 200 then
    AResponse := LResponse.ContentAsString(TEncoding.UTF8);
end;

class function TZipFinder.New: IZipFinder;
begin
  Result := TZipFinder.Create;
end;

end.
