//***************************************************************************
//
//       ���ƣ�DuiWindowImplBase.pas
//       ���ߣ�RAD Studio XE6
//       ���ڣ�2015/11/18
//       ���ߣ�ying32
//       QQ  ��1444386932
//       E-mail��1444386932@qq.com
//       ��Ȩ���� (C) 2015-2015 ying32 All Rights Reserved
//
//
//***************************************************************************
unit DuiWindowImplBase;

interface

uses
  Windows,
  Messages,
  Generics.Collections,
  SysUtils,
  DuiBase,
  Duilib;

type

  TDuiWindowImplBase = class(TDuiBase<CDelphi_WindowImplBase>)
  private
    FHandle: HWND;
    FParentHandle: HWND;
    FPaintManagerUI: CPaintManagerUI;
    function GetHandle: HWND;
    function GetInitSize: TSize;
  protected
    // �ص�����
    procedure DUI_InitWindow; cdecl;
    procedure DUI_Click(var Msg: TNotifyUI); cdecl;
    procedure DUI_Notify(var Msg: TNotifyUI); cdecl;
    function  DUI_HandleMessage(uMsg: UINT; wParam: WPARAM; lParam: LPARAM; var bHandled: BOOL): LRESULT; cdecl;
    function  DUI_MessageHandler(uMsg: UINT; wParam: WPARAM; lParam: LPARAM; var bHandled: BOOL): LRESULT; cdecl;
    procedure DUI_FinalMessage(hWd: HWND); cdecl;
    function  DUI_HandleCustomMessage(uMsg: UINT; wParam: WPARAM; lParam: LPARAM; var bHandled: BOOL): LRESULT; cdecl;
    function  DUI_CreateControl(pstrStr: LPCTSTR): CControlUI; cdecl;
    function DUI_GetItemText(pControl: CControlUI; iIndex, iSubItem: Integer): LPCTSTR; cdecl;
    // Delphi�麯��
    procedure DoInitWindow; virtual;
    procedure DoNotify(var Msg: TNotifyUI); virtual;
    procedure DoClick(var msg: TNotifyUI); virtual;
    procedure DoHandleMessage(var Msg: TMessage; var bHandled: BOOL); virtual;
    procedure DoMessageHandler(var Msg: TMessage; var bHandled: BOOL); virtual;
    procedure DoFinalMessage(hWd: HWND); virtual;
    procedure DoHandleCustomMessage(var Msg: TMessage; var bHandled: BOOL); virtual;
    function DoCreateControl(pstrStr: string): CControlUI; virtual;
    function DoGetItemText(pControl: CControlUI; iIndex, iSubItem: Integer): string; virtual;
  public
    procedure Show;
    procedure Hide;
    function ShowModal: UINT;
    procedure CenterWindow;
    procedure Close;
    procedure CreateDuiWindow(AParent: HWND; ATitle: string);
    procedure CreateWindow(hwndParent: HWND; ATitle: string; dwStyle: DWORD; dwExStyle: DWORD; const rc: TRect; hMenu: HMENU); overload;
    procedure CreateWindow(hwndParent: HWND; ATitle: string; dwStyle: DWORD; dwExStyle: DWORD; x: Integer = Integer(CW_USEDEFAULT); y: Integer = Integer(CW_USEDEFAULT); cx: Integer = Integer(CW_USEDEFAULT); cy: Integer = Integer(CW_USEDEFAULT); hMenu: HMENU = 0); overload;
    procedure SetClassStyle(nStyle: UINT);
    procedure SetIcon(nRes: UINT);
    function FindControl(const AName: string): CControlUI; overload;
    function FindControl(const pt: TPoint): CControlUI; overload;
    function Perform(uMsg: UINT; wParam: WPARAM = 0; lParam: LPARAM = 0): LRESULT;
    procedure Minimize;
    procedure Restore;
    procedure Maximize;
    procedure RemoveThisInPaintManager;
  public
    constructor Create(ASkinFile, ASkinFolder, AZipFileName: string; ARType: TResourceType); overload;
    constructor Create(ASkinFile, ASkinFolder: string; ARType: TResourceType); overload;
    constructor Create(ASkinFile, ASkinFolder: string);  overload;
    constructor Create(ASkinFile, ASkinFolder, AZipFileName: string); overload;
    destructor Destroy; override;
    procedure OnReceive(Param: Pointer); virtual;
  public
    property Handle: HWND read GetHandle;
    property ParentHandle: HWND read FParentHandle;
    property PaintManagerUI: CPaintManagerUI read FPaintManagerUI;
    property InitSize: TSize read GetInitSize;
  end;



  TDuiWindowImplList = TObjectList<TDuiWindowImplBase>;

  TDuiApplication = class
  private
    FList: TDuiWindowImplList;
  public
    procedure Initialize;
    procedure Run;
    procedure Terminate;
    // ��д�ã��Ժ����õİ�
//    procedure AddDuiWindow(AWindow: TDuiWindowImplBase);
//    procedure RemoveWindow(AWindow: TDuiWindowImplBase);
  public
    constructor Create;
    destructor Destroy; override;
  end;


var
  DuiApplication: TDuiApplication;


implementation

{ TWindowImplBase }

constructor TDuiWindowImplBase.Create(ASkinFile, ASkinFolder, AZipFileName: string; ARType: TResourceType);
begin
  inherited Create;
  FThis := CDelphi_WindowImplBase.CppCreate;
  FPaintManagerUI := FThis.GetPaintManagerUI;

  FThis.SetClassName(PChar(ClassName));
  FThis.SetSkinFile(PChar(ASkinFile));
  FThis.SetSkinFolder(PChar(ASkinFolder));
  FThis.SetZipFileName('');
  FThis.SetResourceType(ARType);

  FThis.SetDelphiSelf(Self);
  FThis.SetInitWindow(GetMethodAddr('DUI_InitWindow'));
  FThis.SetClick(GetMethodAddr('DUI_Click'));
  FThis.SetNotify(GetMethodAddr('DUI_Notify'));
  FThis.SetMessageHandler(GetMethodAddr('DUI_MessageHandler'));
  FThis.SetFinalMessage(GetMethodAddr('DUI_FinalMessage'));
  FThis.SetHandleMessage(GetMethodAddr('DUI_HandleMessage'));
  FThis.SetHandleCustomMessage(GetMethodAddr('DUI_HandleCustomMessage'));
  FThis.SetCreateControl(GetMethodAddr('DUI_CreateControl'));
  FThis.SetGetItemText(GetMethodAddr('DUI_GetItemText'));

//  if Assigned(DuiApplication) then
//    DuiApplication.AddDuiWindow(Self);
end;

constructor TDuiWindowImplBase.Create(ASkinFile, ASkinFolder: string; ARType: TResourceType);
begin
  Create(ASkinFile, ASkinFolder, '', ARType);
end;

constructor TDuiWindowImplBase.Create(ASkinFile, ASkinFolder: string);
begin
  Create(ASkinFile, ASkinFolder, UILIB_FILE);
end;

constructor TDuiWindowImplBase.Create(ASkinFile, ASkinFolder,
  AZipFileName: string);
begin
  Create(ASkinFile, ASkinFolder, AZipFileName, UILIB_ZIP);
end;

destructor TDuiWindowImplBase.Destroy;
begin
  if FThis <> nil then
    FThis.CppDestroy;
//  if Assigned(DuiApplication) then
//    DuiApplication.RemoveWindow(Self);
  inherited;
end;

procedure TDuiWindowImplBase.CreateDuiWindow(AParent: HWND; ATitle: string);
begin
  FParentHandle := AParent;
  FThis.CreateDuiWindow(AParent, PChar(ATitle), UI_WNDSTYLE_FRAME, WS_EX_STATICEDGE);
end;

procedure TDuiWindowImplBase.CreateWindow(hwndParent: HWND; ATitle: string;
  dwStyle, dwExStyle: DWORD; x, y, cx, cy: Integer; hMenu: HMENU);
begin
  FThis.Create(hwndParent, PChar(ATitle), dwStyle, dwExStyle, x, y, cx, cy, hMenu);
end;

procedure TDuiWindowImplBase.CreateWindow(hwndParent: HWND; ATitle: string;
  dwStyle, dwExStyle: DWORD; const rc: TRect; hMenu: HMENU);
begin
  FThis.Create(hwndParent, PChar(ATitle), dwStyle, dwExStyle, rc, hMenu);
end;

procedure TDuiWindowImplBase.DoClick(var Msg: TNotifyUI);
begin
  // virtual method
end;

function TDuiWindowImplBase.DoCreateControl(pstrStr: string): CControlUI;
begin
  // virtual method
  Result := nil;
end;

procedure TDuiWindowImplBase.DoFinalMessage(hWd: HWND);
begin
  // virtual method
  RemoveThisInPaintManager;
end;

function TDuiWindowImplBase.DoGetItemText(pControl: CControlUI; iIndex,
  iSubItem: Integer): string;
begin
  Result := '';
end;

procedure TDuiWindowImplBase.DoHandleCustomMessage(var Msg: TMessage; var bHandled: BOOL);
begin
  // virtual method
end;

procedure TDuiWindowImplBase.DoHandleMessage(var Msg: TMessage; var bHandled: BOOL);
begin
  // virtual method
end;

procedure TDuiWindowImplBase.DoInitWindow;
begin
  // virtual method
end;

procedure TDuiWindowImplBase.DoMessageHandler(var Msg: TMessage; var bHandled: BOOL);
begin
  // virtual method
end;

procedure TDuiWindowImplBase.DoNotify(var Msg: TNotifyUI);
begin
  // virtual method
end;

procedure TDuiWindowImplBase.DUI_Click(var Msg: TNotifyUI);
begin
  DoClick(Msg);
end;

function TDuiWindowImplBase.DUI_CreateControl(pstrStr: LPCTSTR): CControlUI;
begin
  Result := DoCreateControl(pstrStr);
end;

procedure TDuiWindowImplBase.DUI_FinalMessage(hWd: HWND);
begin
  DoFinalMessage(hWd);
end;

function TDuiWindowImplBase.DUI_GetItemText(pControl: CControlUI; iIndex,
  iSubItem: Integer): LPCTSTR;
begin
  Result := PChar(DoGetItemText(pControl, iIndex, iSubItem));
end;

function TDuiWindowImplBase.DUI_HandleCustomMessage(uMsg: UINT; wParam: WPARAM;
  lParam: LPARAM; var bHandled: BOOL): LRESULT;
var
  LMsg: TMessage;
begin
  LMsg.Msg := uMsg;
  LMsg.WParam := wParam;
  LMsg.LParam := lParam;
  LMsg.Result := 0;
  DoHandleCustomMessage(LMsg, bHandled);
  Result := LMsg.Result;
end;

function TDuiWindowImplBase.DUI_HandleMessage(uMsg: UINT; wParam: WPARAM;
  lParam: LPARAM; var bHandled: BOOL): LRESULT;
var
  LMsg: TMessage;
begin
  LMsg.Msg := uMsg;
  LMsg.WParam := wParam;
  LMsg.LParam := lParam;
  LMsg.Result := 0;
  DoHandleMessage(LMsg, bHandled);
  Result := LMsg.Result;
end;

procedure TDuiWindowImplBase.DUI_InitWindow;
begin
  DoInitWindow;
end;

function TDuiWindowImplBase.DUI_MessageHandler(uMsg: UINT; wParam: WPARAM;
  lParam: LPARAM; var bHandled: BOOL): LRESULT;
var
  LMsg: TMessage;
begin
  LMsg.Msg := uMsg;
  LMsg.WParam := wParam;
  LMsg.LParam := lParam;
  LMsg.Result := 0;
  DoMessageHandler(LMsg, bHandled);
  Result := LMsg.Result;
end;

procedure TDuiWindowImplBase.DUI_Notify(var Msg: TNotifyUI);
begin
  DoNotify(Msg);
end;

function TDuiWindowImplBase.FindControl(const pt: TPoint): CControlUI;
begin
  Result := FPaintManagerUI.FindControl(pt);
end;

function TDuiWindowImplBase.GetHandle: HWND;
begin
  if FHandle = 0 then
    FHandle := FThis.GetHWND;
   Result := FHandle;
end;

function TDuiWindowImplBase.GetInitSize: TSize;
begin
  Result := FPaintManagerUI.GetInitSize;
end;

function TDuiWindowImplBase.FindControl(const AName: string): CControlUI;
begin
  Result := FPaintManagerUI.FindControl(PChar(AName));
end;

procedure TDuiWindowImplBase.Hide;
begin
  FThis.ShowWindow(False, False);
end;

procedure TDuiWindowImplBase.Maximize;
begin
  Perform(WM_SYSCOMMAND, SC_MAXIMIZE);
end;

procedure TDuiWindowImplBase.Minimize;
begin
  Perform(WM_SYSCOMMAND, SC_MINIMIZE);
end;

procedure TDuiWindowImplBase.OnReceive(Param: Pointer);
begin
  // virtual method
end;

function TDuiWindowImplBase.Perform(uMsg: UINT; wParam: WPARAM;
  lParam: LPARAM): LRESULT;
begin
  Result := SendMessage(Handle, uMsg, wParam, lParam);
end;

procedure TDuiWindowImplBase.RemoveThisInPaintManager;
begin
  FThis.RemoveThisInPaintManager;
end;

procedure TDuiWindowImplBase.Restore;
begin
  Perform(WM_SYSCOMMAND, SC_RESTORE);
end;

procedure TDuiWindowImplBase.SetClassStyle(nStyle: UINT);
begin
  FThis.SetGetClassStyle(nStyle);
end;

procedure TDuiWindowImplBase.SetIcon(nRes: UINT);
begin
  FThis.SetIcon(nRes);
end;

procedure TDuiWindowImplBase.Show;
begin
  FThis.ShowWindow(True, False);
end;

function TDuiWindowImplBase.ShowModal: UINT;
begin
  Result := FThis.ShowModal;
end;

procedure TDuiWindowImplBase.CenterWindow;
begin
  FThis.CenterWindow;
end;

procedure TDuiWindowImplBase.Close;
begin
  FThis.Close();
end;



{ TDuiApplication }

constructor TDuiApplication.Create;
begin
  inherited;
  FList := TDuiWindowImplList.Create;
end;

destructor TDuiApplication.Destroy;
begin
  FList.Free;
  inherited;
end;

procedure TDuiApplication.Initialize;
begin
  CPaintManagerUI.SetInstance(HInstance);
end;

//procedure TDuiApplication.RemoveWindow(AWindow: TDuiWindowImplBase);
//begin
//  TMonitor.Enter(FList);
//  try
//    FList.Remove(AWindow);
//  finally
//    TMonitor.Exit(FList);
//  end;
//end;

//procedure TDuiApplication.AddDuiWindow(AWindow: TDuiWindowImplBase);
//begin
//  TMonitor.Enter(FList);
//  try
//    FList.Add(AWindow);
//  finally
//    TMonitor.Exit(FList);
//  end;
//end;

procedure TDuiApplication.Run;
begin
  CPaintManagerUI.MessageLoop;
end;

procedure TDuiApplication.Terminate;
begin
  PostQuitMessage(0);
end;

initialization
   DuiApplication := TDuiApplication.Create;

finalization
   DuiApplication.Free;


end.
