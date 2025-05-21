program projectChat;

uses
  Vcl.Forms,
  chat in 'chat.pas' {frmChat};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmChat, frmChat);
  Application.Run;
end.
