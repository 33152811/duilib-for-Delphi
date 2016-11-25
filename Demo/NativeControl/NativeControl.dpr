program NativeControl;

{$APPTYPE CONSOLE}

{$I DDuilib.inc}

{$R *.res}

uses
  Windows,
  Messages,
  Classes,
  SysUtils,
  StdCtrls,
  Duilib,
  DuiConst,
  ComCtrls,
  Forms,
  DuiWindowImplBase;

type
  TDuiNativeControlTest = class(TDuiWindowImplBase)
  private
    FButton: TButton;
    FTabs: CTabLayoutUI;
    FTabTool: CTabLayoutUI;
    FVclPageCtl: CNativeControlUI;
    FVclListViewCtl: CNativeControlUI;
    FWCaption: CLabelUI;

    FListV: TListView;
    FPages: TPageControl;


    procedure ButtonClick(Sender: TObject);
    procedure OnOptionSelectchanged(Msg: TNotifyUI);
    procedure CreateVclControls;
    procedure CreateVclSubControls;
  protected
    procedure DoInitWindow; override;
    procedure DoNotify(var Msg: TNotifyUI); override;
    procedure DoHandleMessage(var Msg: TMessage; var bHandled: BOOL); override;
  public
    constructor Create;
    destructor Destroy; override;
  end;

{ TDuiNativeControlTest }

procedure TDuiNativeControlTest.ButtonClick(Sender: TObject);
begin
   MessageBox(0, '�����˰�ť', '��Ϣ', 0);
end;

constructor TDuiNativeControlTest.Create;
begin
  CreateVclControls;
  //inherited Create('NativeControlTest.xml', 'skin');
  inherited Create('dlg_main2.xml', 'skin\PCManager\');
  CreateDuiWindow(0, 'NativeControl����');
end;

procedure TDuiNativeControlTest.CreateVclControls;
var
  LCol: TListColumn;
begin
  // �е���֣�delphi7�·ŵ�create��CreateDuiWindow֮��ͱ����߰汾���޴�����
  FButton := TButton.Create(nil);
  FButton.Caption := '��ť1';
  FButton.OnClick := ButtonClick;

  FPages := TPageControl.Create(nil);
  FPages.Left := 0 - (FPages.Width + 1);


  FListV := TListView.Create(nil);
  // ��ʹ��visible����
  FListV.Left := 0 - (FListV.Width + 1);

  FListV.GridLines := True;
  FListV.RowSelect := True;
  FListV.ViewStyle := vsReport;

  LCol := FListV.Columns.Add;
  LCol.Caption := '��һ��';
  LCol.Width := 100;

  LCol := FListV.Columns.Add;
  LCol.Caption := '�ڶ���';
  LCol.Width := 100;

  LCol := FListV.Columns.Add;
  LCol.Caption := '������';
  LCol.Width := 100;

end;

procedure TDuiNativeControlTest.CreateVclSubControls;
var
  LTabSheet: TTabSheet;
  LItem: TListItem;
  I: Integer;
  LButton: TButton;
begin
  // ������޷��л�tab������ӦĳЩ��Ϣ�ˡ������������Ǻ�vcl�ͳ�ͻ��ĳЩ��Ϣ��Ҫת��
  LTabSheet := TTabSheet.Create(FPages);
  LTabSheet.Parent := FPages;
  LTabSheet.PageControl := FPages;
  LTabSheet.Caption := '��һҳ';

  LButton := TButton.Create(LTabSheet);
  LButton.Parent := LTabSheet;
  LButton.Caption := '��ť';

  LTabSheet := TTabSheet.Create(FPages);
  LTabSheet.Parent := FPages;
  LTabSheet.PageControl := FPages;
  LTabSheet.Caption := '�ڶ�ҳ';
  // ����������޷���ʾ�������������Ǻ�vcl�ͳ�ͻ��ĳЩ��Ϣ��Ҫת��
  FListV.Items.BeginUpdate;
  try
    for I := 0 to 100 do
    begin
      LItem := FListV.Items.Add;
      LItem.Caption := IntToStr(I+1);
      LItem.SubItems.Add('1111');
    end;
  finally
    FListV.Items.EndUpdate;
  end;
end;

destructor TDuiNativeControlTest.Destroy;
begin
  FreeAndNil(FListV);
  FreeAndNil(FButton);
  inherited;
end;

procedure TDuiNativeControlTest.DoHandleMessage(var Msg: TMessage;
  var bHandled: BOOL);
begin
  inherited;
  if Msg.Msg = WM_COMMAND then
  begin
    // ��WM_COMMAND�н���
    if Msg.LParam = FButton.Handle then
      FButton.WindowProc(Msg);
  end;
end;

procedure TDuiNativeControlTest.DoInitWindow;
var
  LNativeCtl: CNativeControlUI;
begin
  inherited;
{$IFDEF SupportGeneric}
  FTabs := FindControl<CTabLayoutUI>('tabs');
  FTabTool := FindControl<CTabLayoutUI>('tabtool');
  FVclPageCtl := FindControl<CNativeControlUI>('vclpagectl');
  FWCaption := FindControl<CLabelUI>('lblCaption');
  FVclListViewCtl := FindControl<CNativeControlUI>('vcllistviewctl');
{$ELSE}
  FTabs := CTabLayoutUI(FindControl('tabs'));
  FTabTool := CTabLayoutUI(FindControl('tabtool'));
  FVclPageCtl := CNativeControlUI(FindControl('vclpagectl'));
  FWCaption := CLabelUI(FindControl('lblCaption'));
  FVclListViewCtl := CNativeControlUI(FindControl('vcllistviewctl'));
{$ENDIF}
  FWCaption.Text := 'VCL�ؼ�����';

  if FVclPageCtl <> nil then
  begin
    FPages.ParentWindow := Handle;
    FVclPageCtl.SetNativeHandle(FPages.Handle);
  end;
  if FVclListViewCtl <> nil then
  begin
    FListV.ParentWindow := Handle;
    FVclListViewCtl.SetNativeHandle(FListV.Handle);
  end;

  CreateVclSubControls;

//  LNativeCtl := CNativeControlUI(FindControl('test1'));
//  if LNativeCtl <> nil then
//  begin
//    // ���ֻ��ʹ��delphi����parent
//    FButton.ParentWindow := Handle;
//    LNativeCtl.SetNativeHandle(FButton.Handle);
//  end;
end;

procedure TDuiNativeControlTest.DoNotify(var Msg: TNotifyUI);
begin
  if Msg.sType.m_pStr = DUI_MSGTYPE_SELECTCHANGED then
    OnOptionSelectchanged(Msg);
  Writeln(string(Msg.sType.m_pstr));
  inherited;
end;


procedure TDuiNativeControlTest.OnOptionSelectchanged(Msg: TNotifyUI);
var
  LName: string;
  LIndex: Integer;
begin
  LName := Msg.pSender.Name;
  if Copy(LName, 1, 6) = 'tabsel' then
  begin
    LIndex := StrToIntDef(Copy(LName, 7, 1), -1) - 1;
    if LIndex >= 0 then
      FTabs.SelectIndex := LIndex;
  end else if Copy(LName, 1, 7) = 'toolsel' then
  begin
    LIndex := StrToIntDef(Copy(LName, 8, 1), -1) - 1;
    if LIndex >= 0 then
      FTabTool.SelectIndex := LIndex;
  end;
end;

var
  DuiNativeControlTest: TDuiNativeControlTest;

begin
  try
    DuiApplication.Initialize;
    DuiNativeControlTest := TDuiNativeControlTest.Create;
    DuiNativeControlTest.CenterWindow;
    DuiNativeControlTest.Show;
    DuiApplication.Run;
    DuiNativeControlTest.Free;
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
