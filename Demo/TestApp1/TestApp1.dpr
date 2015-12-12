program TestApp1;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  Windows,
  Messages,
  SysUtils,
  Classes,
  DuiConst,
  DuiWindowImplBase,
  DuiRichEdit,
  DuiActiveX,
  DuiWebBrowser,
  DuiListUI,
  Duilib;

type

  TFrameWindowWnd = class(TDuiWindowImplBase)
  private
  protected
    procedure DoInitWindow; override;
    procedure DoNotify(var Msg: TNotifyUI); override;
    procedure DoHandleMessage(var Msg: TMessage; var bHandled: BOOL); override;
  public
    constructor Create;
    destructor Destroy; override;
  end;

{ TFrameWindowWnd }

constructor TFrameWindowWnd.Create;
begin
  inherited Create('test1.xml', 'skin\TestAppRes');
  CreateWindow(0, '这是一个最简单的测试用exe，修改test1.xml就可以看到效果', UI_WNDSTYLE_FRAME, WS_EX_WINDOWEDGE);
  SetClassStyle(UI_CLASSSTYLE_FRAME or CS_DBLCLKS);
  // 默认的这个类是去掉标题栏的，所以要重新补回
  SetWindowLong(Handle, GWL_STYLE, GetWindowLong(Handle, GWL_STYLE) or WS_CAPTION);
  SetWindowPos(Handle, HWND_TOP, 0, 0, 0, 0, SWP_FRAMECHANGED or SWP_NOSIZE or SWP_NOMOVE);
end;

destructor TFrameWindowWnd.Destroy;
begin
  RemoveThisInPaintManager;
  inherited;
end;

procedure TFrameWindowWnd.DoHandleMessage(var Msg: TMessage; var bHandled: BOOL);
begin
  case Msg.Msg of
    // 拦截三个方法,不让标题栏被绘制
    WM_NCACTIVATE,
    WM_NCCALCSIZE,
    WM_NCPAINT:
      begin
        bHandled := False;
      end;
    WM_ERASEBKGND: Msg.Result := 1;
    WM_DESTROY: PostQuitMessage(0);
  end;
end;

procedure TFrameWindowWnd.DoInitWindow;
begin
  inherited;

end;

procedure TFrameWindowWnd.DoNotify(var Msg: TNotifyUI);
var
  LType, LCtlName: string;
  pRich: CRichEditUI;
begin
  inherited;
{$IFNDEF UseLowVer}
  LType := Msg.sType;
{$ELSE}
  LType := DuiStringToString(Msg.sType);
{$ENDIF}
  LCtlName := Msg.pSender.Name;
  if LType = DUI_MSGTYPE_CLICK then
  begin
    if LCtlName = 'insertimagebtn' then
    begin
      pRich := CRichEditUI(FindControl('testrichedit'));
      if Assigned(pRich) then
        pRich.RemoveAll;
    end else
    if LCtlName = 'changeskinbtn' then
    begin
      if CPaintManagerUI.GetResourcePath = CPaintManagerUI.GetInstancePath then
        CPaintManagerUI.SetResourcePath(CPaintManagerUI.GetInstancePath + 'skin\FlashRes')
      else
        CPaintManagerUI.SetResourcePath(CPaintManagerUI.GetInstancePath);
      CPaintManagerUI.ReloadSkin;
    end;
  end;
end;

var
  FrameWindowWnd: TFrameWindowWnd;

begin
  try
    DuiApplication.Initialize;
    FrameWindowWnd := TFrameWindowWnd.Create;
    FrameWindowWnd.CenterWindow;
    FrameWindowWnd.Show;
    DuiApplication.Run;
    FrameWindowWnd.Free;
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
