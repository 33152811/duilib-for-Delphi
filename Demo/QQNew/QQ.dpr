program QQ;

{$APPTYPE CONSOLE}

{$R *.res}



uses
  Windows,
  Messages,
  Classes,
  SysUtils,
  Duilib,
  DuiConst,
  DuiWindowImplBase;

type

  TLoginUI = class(TDuiWindowImplBase)
  private
    FComb: CComboUI;
  protected
    procedure DoInitWindow; override;
    procedure DoNotify(var Msg: TNotifyUI); override;
    procedure DoHandleMessage(var Msg: TMessage; var bHandled: BOOL); override;
  public
    constructor Create;
    destructor Destroy; override;
  end;



{ TLoginUI }

constructor TLoginUI.Create;
begin
  // ����Դzip�м��أ�������ǰ����һ��������������ھ��޸���duilibֱ��Ĭ��
  // ��Դ�� DefaultSkin ����Ҫ������Ϊ ZIPRes
  //inherited Create('login.xml', '', UILIB_ZIPRESOURCE);
  inherited Create('login.xml', '', '');
  CreateWindow(0, '����', UI_WNDSTYLE_EX_DIALOG, WS_EX_WINDOWEDGE);
end;

destructor TLoginUI.Destroy;
begin

  inherited;
end;

procedure TLoginUI.DoHandleMessage(var Msg: TMessage; var bHandled: BOOL);
begin

end;

procedure TLoginUI.DoInitWindow;
begin
  FComb := CComboUI(FindControl('users'));
  // FComb := FindControl<CComboUI>('users');
end;

procedure TLoginUI.DoNotify(var Msg: TNotifyUI);
begin
  if Msg.sType.m_pstr = DUI_MSGTYPE_CLICK then
  begin
    if Msg.pSender.Name = 'delete' then
    begin
      Writeln('ɾ����ť.Parent=', Msg.wParam, '   ', Msg.lParam);
      Writeln('FComb.Index=', FComb.CurSel);
      if FComb.CurSel <> -1 then
      begin
        FComb.RemoveAt(FComb.CurSel);
        FComb.CurSel := -1;
      end;
    end;
  end;
end;

var
   LoginUI: TLoginUI;

begin
  try
    TDuiApplication.Initialize;
    TDuiApplication.SetResourcePath(ExtractFilePath(ParamStr(0)) + 'skin\QQNewRes\');
    // ����zip�������ݲ�֪��Ϊʲô
    //TDuiApplication.SetResourceZip('QQNewRes.zip');
    LoginUI := TLoginUI.Create;
    LoginUI.CenterWindow;
    LoginUI.Show;
    TDuiApplication.Run;
    LoginUI.Free;
    { TODO -oUser -cConsole Main : Insert code here }
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
