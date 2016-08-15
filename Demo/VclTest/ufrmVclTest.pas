unit ufrmVclTest;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, DDuilibComponent, Vcl.StdCtrls, Duilib,
  Vcl.ExtCtrls;

type
  TForm1 = class(TForm)
    btn1: TButton;
    DDuiForm1: TDDuiForm;
    DDuiApp1: TDDuiApp;
    tmr1: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btn1Click(Sender: TObject);
    procedure DDuiForm1Click(Sender: TObject; var Msg: TNotifyUI);
    procedure DDuiForm1InitWindow(Sender: TObject);
    procedure tmr1Timer(Sender: TObject);
    procedure btn1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure btn1MouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure btn1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  private
//    FDuiApp: TDDuiApp;
//    FDuiForm: TDDuiForm;
    hInstRich: THandle;
  public
    procedure WndProc(var Msg: TMessage); override;
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

uses
  frmChat;

procedure TForm1.btn1Click(Sender: TObject);
begin
  Close;
end;

procedure TForm1.btn1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
//  Writeln('btn1 mouse down');
end;

procedure TForm1.btn1MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
//  Writeln('btn1 mouse move');
end;

procedure TForm1.btn1MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
//  Writeln('btn1 mouse up');
end;

procedure TForm1.DDuiForm1Click(Sender: TObject; var Msg: TNotifyUI);
begin
  Writeln(Msg.pSender.Name);
  if Msg.pSender.Name = 'friendbtn' then
    Form2.Show;
end;

procedure TForm1.DDuiForm1InitWindow(Sender: TObject);
var
  LCtl: CNativeControlUI;
begin
  Writeln('DDuiForm1InitWindow');

  LCtl := CNativeControlUI.CppCreate(0);
  // ������
  LCtl.SetManager(DDuiForm1.DUI.PaintManagerUI, DDuiForm1.DUI.PaintManagerUI.GetRoot, False);
  LCtl.Name := btn1.Name;
  LCtl.SetNativeHandle(btn1.Handle);
  LCtl.Visible := True;
  LCtl.SetPos(Rect(1, 1, btn1.Width, btn1.Height), False);
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  hInstRich := LoadLibrary('Riched20.dll');
//  FDuiApp := TDDuiApp.Create(nil);
//  FDuiForm := TDDuiForm.Create(Self);

//  FDuiForm.SkinFolder := '\skin\QQRes\';
//  FDuiForm.SkinXml := 'main_frame.xml';
//  FDuiForm.SkinFolder := 'skin\TestAppRes';
//  FDuiForm.SkinXml := 'test1.xml';
// ��̬���������Ҫ�ֶ�������,�Ƕ�̬����Ҫ
//  FDuiForm.InitDuiComponent;

//  FDuiForm.DUI.Show;
  // Ĭ�ϵ��������ȥ���������ģ�����Ҫ���²���
  //SetWindowLong(Handle, GWL_STYLE, GetWindowLong(Handle, GWL_STYLE) or WS_CAPTION);
  //SetWindowPos(Handle, HWND_TOP, 0, 0, 0, 0, SWP_FRAMECHANGED or SWP_NOSIZE or SWP_NOMOVE);
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
//  FDuiApp.Free;
  FreeLibrary(hInstRich);
end;

procedure TForm1.tmr1Timer(Sender: TObject);
begin
//  Writeln('���Ƕ�ʱ��');
end;

procedure TForm1.WndProc(var Msg: TMessage);
begin
  inherited;
end;

end.
