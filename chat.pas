unit chat;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, IdTCPServer, IdTCPClient, IdContext,
  IdCustomTCPServer, IdBaseComponent, IdComponent, IdTCPConnection, IdStack, IdGlobal, DCPrijndael, DCPsha256, System.NetEncoding,
  Vcl.Mask;

type
  TfrmChat = class(TForm)
    pnlHlavny: TPanel;
    edtPort: TEdit;
    memChat: TMemo;
    edtSprava: TEdit;
    btnPoslat: TButton;
    pnlNastavenie: TPanel;
    btnPripoj: TButton;
    rbtServer: TRadioButton;
    rbtKlient: TRadioButton;
    tcpKlient: TIdTCPClient;
    tcpServer: TIdTCPServer;
    tmrCasovac: TTimer;
    lblIPV4: TLabel;
    lblPort: TLabel;
    lblPripojenie: TLabel;
    lblHeslo: TLabel;
    edtHeslo: TEdit;
    medIPAdresa: TMaskEdit;
    procedure edtSpravaClick(Sender: TObject);
    procedure btnPripojClick(Sender: TObject);
    procedure btnPoslatClick(Sender: TObject);
    procedure tcpServerExecute(AContext: TIdContext);
    procedure FormCreate(Sender: TObject);
    procedure tmrCasovacTimer(Sender: TObject);
    procedure rbtServerClick(Sender: TObject);
    procedure rbtKlientClick(Sender: TObject);
    procedure edtSpravaKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
    procedure AddChatLine(s: String);
    procedure SkontrolujServerKlient;
    function EncryptAES(const Msg, Password: string): string;
    function DecryptAES(const EncryptedB64, Password: string): string;
  public
    { Public declarations }
  end;

var
  frmChat: TfrmChat;

implementation

{$R *.dfm}

procedure TfrmChat.AddChatLine(s: String);
begin
  TThread.Synchronize(nil,
    procedure begin
      memChat.Lines.Add(s);
    end);
end;

function TfrmChat.EncryptAES(const Msg, Password: string): string;
var
  Cipher: TDCP_rijndael;
  Encrypted: string;
begin
  Cipher := TDCP_rijndael.Create(nil);
  try
    Cipher.InitStr(Password, TDCP_sha256);  // pouûije SHA256 ako deriv·ciu kæ˙Ëa
    Encrypted := Cipher.EncryptString(Msg);
    Result := TNetEncoding.Base64.Encode(Encrypted);  // Base64, aby sa to dalo poslaù textovo
  finally
    Cipher.Free;
  end;
end;

function TfrmChat.DecryptAES(const EncryptedB64, Password: string): string;
var
  Cipher: TDCP_rijndael;
  Decrypted: string;
begin
  Cipher := TDCP_rijndael.Create(nil);
  try
    Cipher.InitStr(Password, TDCP_sha256);
    Decrypted := Cipher.DecryptString(TNetEncoding.Base64.Decode(EncryptedB64));
    Result := Decrypted;
  finally
    Cipher.Free;
  end;
end;

procedure TfrmChat.btnPoslatClick(Sender: TObject);
var
  msg: string;
  ctxList: TList;
  i: Integer;
  ctx: TIdContext;
begin
  msg := EncryptAES(edtSprava.Text, edtHeslo.Text);
//  msg := edtSprava.Text;
  if msg = '' then Exit;

  if rbtKlient.Checked and tcpKlient.Connected then
  begin
    tcpKlient.IOHandler.WriteLn(msg);
    AddChatLine('Ja: ' + edtSprava.Text);
  end
  else if rbtServer.Checked then
  begin
    ctxList := tcpServer.Contexts.LockList;
    try
      for i := 0 to ctxList.Count - 1 do
      begin
        ctx := TIdContext(ctxList[i]);
        ctx.Connection.IOHandler.WriteLn(msg);
      end;
      AddChatLine('Ja: ' + edtSprava.Text);
    finally
      tcpServer.Contexts.UnlockList;
    end;
  end;

  edtSprava.Clear;
end;

procedure TfrmChat.btnPripojClick(Sender: TObject);
begin
  if tcpServer.Active OR tcpKlient.Connected then begin
    if tcpServer.Active then begin
      tcpServer.Active := False;
      AddChatLine('Server sa ukonËil...');
      lblPripojenie.Caption := 'Pripojenie neaktÌvne';
      lblPripojenie.Font.Color := clRed;
      btnPripoj.Caption := 'Pripoj';
    end;
    if tcpKlient.Connected then begin
      tcpKlient.Disconnect;
      tmrCasovac.Enabled := True;
      AddChatLine('Odpojen˝ od serveru.');
      lblPripojenie.Caption := 'Pripojenie neaktÌvne';
      lblPripojenie.Font.Color := clRed;
      btnPripoj.Caption := 'Pripoj';
    end;
  end
  else begin
    if rbtServer.Checked then
    begin
      tcpServer.DefaultPort := StrToIntDef(edtPort.Text, 12345);
      tcpServer.Active := True;
      AddChatLine('Server spusten˝...');
      lblPripojenie.Caption := 'Pripojenie aktÌvne';
      lblPripojenie.Font.Color := clGreen;
      btnPripoj.Caption := 'Odpoj';
    end
    else if rbtKlient.Checked then
    begin
      tcpKlient.Host := medIPAdresa.Text;
      tcpKlient.Port := StrToIntDef(edtPort.Text, 12345);
      tcpKlient.ConnectTimeout := 3000;
      try
        tcpKlient.Connect;
        if tcpKlient.Connected then begin
          tmrCasovac.Enabled := True;
          AddChatLine('Pripojen˝ k serveru.');
           lblPripojenie.Caption := 'Pripojenie aktÌvne';
           lblPripojenie.Font.Color := clGreen;
           btnPripoj.Caption := 'Odpoj';
        end;
      except
        on E: Exception do
          AddChatLine('Chyba pripojenia: ' + E.Message);
      end;
    end;
  end;
end;

procedure TfrmChat.edtSpravaClick(Sender: TObject);
begin
  if edtSprava.Text = 'Zadaj spr·vu' then
    edtSprava.Text := '';
end;

procedure TfrmChat.edtSpravaKeyPress(Sender: TObject; var Key: Char);
begin
  if ord(Key) = VK_RETURN then
    btnPoslatClick(nil);
end;

procedure TfrmChat.FormCreate(Sender: TObject);
var
  ip: string;
begin
  // Prejdi cez vöetky IP adresy priradenÈ k lok·lnym adaptÈrom
  for ip in GStack.LocalAddresses do
  begin
    if not ip.StartsWith('127.') then  // Vynechaj loopback
    begin
      medIPAdresa.Text := ip;
      Break;
    end;
  end;
  edtPort.Text := '12345';
end;

procedure TfrmChat.rbtKlientClick(Sender: TObject);
begin
  SkontrolujServerKlient;
end;

procedure TfrmChat.rbtServerClick(Sender: TObject);
begin
  SkontrolujServerKlient;
end;

procedure TfrmChat.SkontrolujServerKlient;
begin
  if rbtServer.Checked then begin
    medIPAdresa.Enabled := False;
    rbtKlient.Checked := False;
  end;

  if rbtKlient.Checked then begin
    medIPAdresa.Enabled := True;
    rbtServer.Checked := False;
  end;
end;

procedure TfrmChat.tcpServerExecute(AContext: TIdContext);
var
  msg, received: string;
begin
  try
    received := AContext.Connection.IOHandler.ReadLn;
    msg := DecryptAES(received, edtHeslo.Text);
    AddChatLine('Peer: ' + msg);
  except
    on E: Exception do
      AddChatLine('Chyba prÌjmu: ' + E.Message);
  end;
end;

procedure TfrmChat.tmrCasovacTimer(Sender: TObject);
var
  msg, received: string;
begin
  if tcpKlient.Connected then
  begin
    try
      if tcpKlient.IOHandler.InputBufferIsEmpty then
        tcpKlient.IOHandler.CheckForDataOnSource(10);

      if tcpKlient.IOHandler.InputBufferIsEmpty then
        Exit;

      received := tcpKlient.IOHandler.ReadLn;
      msg := DecryptAES(received, edtHeslo.Text);
      AddChatLine('Peer: ' + msg);
    except
      on E: Exception do
        AddChatLine('Chyba klienta: ' + E.Message);
    end;
  end;
end;

end.
