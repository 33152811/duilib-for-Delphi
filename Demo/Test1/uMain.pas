unit uMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, DuiVCLComponent, Duilib, DuiConst;

type
  TForm1 = class(TForm)
    procedure FormCreate(Sender: TObject);
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  private
    FDuiForm: TDDuiForm;
    procedure OnNotify(Sender: TObject; var Msg: TNotifyUI);
    procedure OnSetBtnClick(Sender: TObject; var Msg: TNotifyUI);
    procedure OnDuiDynCreate(Sender: TObject; AMgr: CPaintManagerUI; var ARoot: CControlUI);
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}


procedure TForm1.FormCreate(Sender: TObject);
begin
  FDuiForm := TDDuiForm.Create(Self);
  FDuiForm.OnNotify := OnNotify;
  FDuiForm.AddObjectClick('setbtn', OnSetBtnClick);
//  FDuiForm.SkinKind := skDynCreate;
  FDuiForm.OnDynCreate := OnDuiDynCreate;
  FDuiForm.SkinXmlFile := 'login.xml';
  FDuiForm.SkinFolder := '\skin\QQNewRes\';
  FDuiForm.InitUI;
end;

procedure TForm1.FormMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  Writeln('mouse down');
end;

procedure TForm1.OnDuiDynCreate(Sender: TObject; AMgr: CPaintManagerUI;
  var ARoot: CControlUI);
var
  LCtl: CHorizontalLayoutUI;
begin
  Writeln('��̬�����¼�');
  AMgr.SetCaptionRect(Rect(0, 0, 0, 36));
  AMgr.SetInitSize(400, 300);
  //AMgr.Layered := False;
  // ��֪���������ô������
  ARoot := CVerticalLayoutUI.CppCreate;
  ARoot.Visible := True;
  ARoot.BkColor := ColorToRGB(clBtnFace);
  ARoot.SetManager(AMgr, nil, False);
  LCtl := CHorizontalLayoutUI.CppCreate;
  LCtl.SetManager(AMgr, ARoot, False);
  LCtl.BkColor := ColorToRGB(clRed);

  //ARoot.SetManager(nil, nil, True);
end;

procedure TForm1.OnNotify(Sender: TObject; var Msg: TNotifyUI);
begin
  Writeln('type:' + Msg.sType.ToString + ', name:' + Msg.pSender.Name);
end;

procedure TForm1.OnSetBtnClick(Sender: TObject; var Msg: TNotifyUI);
begin
  ShowMessage('����');
end;

end.
