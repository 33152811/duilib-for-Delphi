///=======================================================
///
/// ���ڣ�2015-11-25
/// ���ߣ�ying32
///
///=======================================================
unit uOthers;

interface

uses
  System.SysUtils,
  System.Classes;

type
  TOthers = class
  public
    class procedure AddDelphiDuiStringA(AFile: TStringList);
    class procedure AddDelphiDuiStringB(AFile: TStringList);
    class procedure AddTResourceType(AFile: TStringList);
    class procedure AddTNotifyUIStruct(AFile: TStringList);
    /// <summary>
    ///   �������ͣ���δ�����
    /// </summary>
    class procedure AddOtherType(AFile: TStringList);
    class procedure AddDefualtConst(AFile: TStringList);
    class procedure AddDelphiCommentHeader(AFile: TStringList);
    class procedure AddCppHeaderCommentHeader(AFile: TStringList);
    class procedure AddCppSourceCommentHeader(AFile: TStringList);
  end;

implementation

{ TOthers }

{
  // ֻ��Ҫ��
  CStdStringPtrMap = class;
  CMarkup = class;
  CMarkupNode = class;
  CControlUI = class;
  CPaintManagerUI = class;
  CScrollBarUI = class;
  CTreeViewUI = class;
  CListHeaderUI = class;
}


class procedure TOthers.AddCppHeaderCommentHeader(AFile: TStringList);
begin
  AFile.Add('//*******************************************************************');
  AFile.Add('//');
  AFile.Add('//       ���ߣ�ying32');
  AFile.Add('//       QQ  ��1444386932');
  AFile.Add('//       E-mail��1444386932@qq.com');
  AFile.Add(Format('//       ����Ԫ��CppConvert�����Զ�������%s', [FormatDateTime('YYYY-MM-DD hh:mm:ss', Now)]));
  AFile.Add('//       ��Ȩ���� (C) 2015-2015 ying32 All Rights Reserved');
  AFile.Add('//');
  AFile.Add('//*******************************************************************');
end;

class procedure TOthers.AddCppSourceCommentHeader(AFile: TStringList);
begin
  AFile.Add('//*******************************************************************');
  AFile.Add('//');
  AFile.Add('//       ���ߣ�ying32');
  AFile.Add('//       QQ  ��1444386932');
  AFile.Add('//       E-mail��1444386932@qq.com');
  AFile.Add(Format('//       ����Ԫ��CppConvert�����Զ�������%s', [FormatDateTime('YYYY-MM-DD hh:mm:ss', Now)]));
  AFile.Add('//       ��Ȩ���� (C) 2015-2015 ying32 All Rights Reserved');
  AFile.Add('//');
  AFile.Add('//*******************************************************************');
end;

class procedure TOthers.AddDefualtConst(AFile: TStringList);
begin
  AFile.Add('  UI_WNDSTYLE_CONTAINER   = 0;');
  AFile.Add('  UI_WNDSTYLE_FRAME       = WS_VISIBLE or WS_OVERLAPPEDWINDOW;');
  AFile.Add('  UI_WNDSTYLE_CHILD       = WS_VISIBLE or WS_CHILD or WS_CLIPSIBLINGS or WS_CLIPCHILDREN;');
  AFile.Add('  UI_WNDSTYLE_DIALOG      = WS_VISIBLE or WS_POPUPWINDOW or WS_CAPTION or WS_DLGFRAME or WS_CLIPSIBLINGS or WS_CLIPCHILDREN;');
  AFile.Add('');
  AFile.Add('  UI_WNDSTYLE_EX_FRAME    = WS_EX_WINDOWEDGE;');
  AFile.Add('  UI_WNDSTYLE_EX_DIALOG   = WS_EX_TOOLWINDOW or WS_EX_DLGMODALFRAME;');
  AFile.Add('');
  AFile.Add('  UI_CLASSSTYLE_CONTAINER  = 0;');
  AFile.Add('  UI_CLASSSTYLE_FRAME      = CS_VREDRAW or CS_HREDRAW;');
  AFile.Add('  UI_CLASSSTYLE_CHILD      = CS_VREDRAW or CS_HREDRAW or CS_DBLCLKS or CS_SAVEBITS;');
  AFile.Add('  UI_CLASSSTYLE_DIALOG     = CS_VREDRAW or CS_HREDRAW or CS_DBLCLKS or CS_SAVEBITS;');
  AFile.Add('');
  AFile.Add('  UILIST_MAX_COLUMNS = 32;');
  AFile.Add('');

  AFile.Add('  XMLFILE_ENCODING_UTF8    = 0;');
  AFile.Add('  XMLFILE_ENCODING_UNICODE = 1;');
  AFile.Add('  XMLFILE_ENCODING_ASNI    = 2;');
  AFile.Add('');


end;

class procedure TOthers.AddDelphiCommentHeader(AFile: TStringList);
begin
  AFile.Add('//***************************************************************************');
  AFile.Add('//');
  AFile.Add('//       ���ƣ�Duilib.pas');
  AFile.Add('//       ���ߣ�ying32');
  AFile.Add('//       QQ  ��1444386932');
  AFile.Add('//       E-mail��1444386932@qq.com');
  AFile.Add(Format('//       ����Ԫ��CppConvert�����Զ�������%s', [FormatDateTime('YYYY-MM-DD hh:mm:ss', Now)]));
  AFile.Add('//       ��Ȩ���� (C) 2015 ying32 All Rights Reserved');
  AFile.Add('//');
  AFile.Add('//       1����C��ͷ�Ķ��������Ž�C++��ģ��������ǲ����̳У�������c++����');
  // AFile.Add('//       2�����еķ������ֶα����ϸ����c++���෽�����ֶε�˳��');                               // �Ѿ���������·��
  // AFile.Add('//       Ҳֻ����2�֣�һ�Ǳ����������鷽����ҪӦ����������static��ʶ����ͨ��Ա����');            // �Ѿ���������·��
  // AFile.Add('//       �Ž����е� public �ֶβ�Ҫ���ã���������Ϊprotected,��絥Ԫ���ܷ��ʣ����Ϊpublic');   // �Ѿ���������·��
  AFile.Add('//       2�������ķ���ԭΪ__thiscall��Delphi�в���stdcall�����ã����õ�ʱ����ָ���ַ����ecx�Ĵ�����');
  AFile.Add('//');
  // AFile.Add('//       �麯��__thiscall���⣬��Delphi������û��һԼ����ֻ������ʵʵ�ɵ���������'); // �Ѿ���������·��
  AFile.Add('//');
  AFile.Add('//***************************************************************************');
end;

class procedure TOthers.AddDelphiDuiStringA(AFile: TStringList);
begin
  AFile.Add('  //CDuiString = array[0..65] of Char; // 132 byte');
  AFile.Add('  // MAX_LOCAL_STRING_LEN = 63 + 1 + 1 + #0 = 66byte');
  AFile.Add('  // ���ﶨ��Ϊһ����¼�� ��Ϊ���ڲ����صĲ�����һ��ָ�룬so���ֶδ�С��һ���ˣ�ֻ�ܸ�record��ʽ����');
  AFile.Add('  PCDuiString = ^CDuiString; // ����е�ǣǿ��');
  AFile.Add('  CDuiString = record');
  AFile.Add('  const');
  AFile.Add('    MAX_LOCAL_STRING_LEN = 63;');
  AFile.Add('  private // ���������֪�����ĸ��汾��Delphi֧��');
  AFile.Add('    /// <summary>');
  AFile.Add('    ///   �����Ҫ�ã�ʹ�á�ToString');
  AFile.Add('    /// </summary>');
  AFile.Add('    szStr:array[0..65] of Char;');
  AFile.Add('  public');
  AFile.Add('    class operator Equal(const Lhs, Rhs : CDuiString) : Boolean; overload;');
  AFile.Add('    class operator Equal(const Lhs: CDuiString; Rhs : string) : Boolean; overload;');
  AFile.Add('    class operator Equal(const Lhs: string; Rhs : CDuiString) : Boolean; overload;');
  AFile.Add('    class operator NotEqual(const Lhs, Rhs : CDuiString): Boolean; overload;');
  AFile.Add('    class operator NotEqual(const Lhs: CDuiString; Rhs : string): Boolean; overload;');
  AFile.Add('    class operator NotEqual(const Lhs: string; Rhs : CDuiString): Boolean; overload;');
  AFile.Add('');
  AFile.Add('    class operator Implicit(const AStr: string): CDuiString; overload;');
  AFile.Add('    class operator Implicit(ADuiStr: CDuiString): string; overload;');
  AFile.Add('    class operator Explicit(ADuiStr: CDuiString): string;');
  AFile.Add('');
  AFile.Add('    function ToString: string;');
  AFile.Add('    function Length: Integer;');
  AFile.Add('    function IsEmpty: Boolean;');
  AFile.Add('  end;');
end;

class procedure TOthers.AddDelphiDuiStringB(AFile: TStringList);
begin
  AFile.Add('{ CDuiString }');
  AFile.Add('');
  AFile.Add('class operator CDuiString.Equal(const Lhs, Rhs: CDuiString): Boolean;');
  AFile.Add('begin');
  AFile.Add('  Result := Lhs.ToString = Rhs.ToString;');
  AFile.Add('end;');
  AFile.Add('');
  AFile.Add('class operator CDuiString.Equal(const Lhs: CDuiString; Rhs: string): Boolean;');
  AFile.Add('begin');
  AFile.Add('  Result := Lhs.ToString = Rhs;');
  AFile.Add('end;');
  AFile.Add('');
  AFile.Add('class operator CDuiString.Equal(const Lhs: string; Rhs: CDuiString): Boolean;');
  AFile.Add('begin');
  AFile.Add('  Result := Lhs = Rhs.ToString;');
  AFile.Add('end;');
  AFile.Add('');
  AFile.Add('class operator CDuiString.Explicit(ADuiStr: CDuiString): string;');
  AFile.Add('begin');
  AFile.Add('  Result := ADuiStr.ToString;');
  AFile.Add('end;');
  AFile.Add('');
  AFile.Add('// �����ò��ֻ����ʱ�Եģ�����ûɶ��ϵ��');
  AFile.Add('class operator CDuiString.Implicit(const AStr: string): CDuiString;');
  AFile.Add('var');
  AFile.Add('  LLen: Integer;');
  AFile.Add('  LBytes: TBytes;');
  AFile.Add('begin');
  AFile.Add('  LBytes := TEncoding.Unicode.GetBytes(AStr + #0);');
  AFile.Add('  LLen := System.Length(LBytes);');
  AFile.Add('  if LLen > MAX_LOCAL_STRING_LEN then');
  AFile.Add('    LLen := MAX_LOCAL_STRING_LEN;');
  AFile.Add('  Move(LBytes[0], Result.szStr[2], LLen);');
  AFile.Add('end;');

  AFile.Add('');
  AFile.Add('class operator CDuiString.Implicit(ADuiStr: CDuiString): string;');
  AFile.Add('begin');
  AFile.Add('  Result := ADuiStr.ToString;');
  AFile.Add('end;');
  AFile.Add('');
  AFile.Add('function CDuiString.IsEmpty: Boolean;');
  AFile.Add('begin');
  AFile.Add('  Result := ToString.IsEmpty;');
  AFile.Add('end;');
  AFile.Add('');
  AFile.Add('function CDuiString.Length: Integer;');
  AFile.Add('begin');
  AFile.Add('  Result := ToString.Length;');
  AFile.Add('end;');
  AFile.Add('');
  AFile.Add('class operator CDuiString.NotEqual(const Lhs, Rhs: CDuiString): Boolean;');
  AFile.Add('begin');
  AFile.Add('  Result := Lhs.ToString <> Rhs.ToString;');
  AFile.Add('end;');
  AFile.Add('');
  AFile.Add('class operator CDuiString.NotEqual(const Lhs: CDuiString; Rhs: string): Boolean;');
  AFile.Add('begin');
  AFile.Add('  Result := Lhs.ToString <> Rhs;');
  AFile.Add('end;');
  AFile.Add('');
  AFile.Add('class operator CDuiString.NotEqual(const Lhs: string; Rhs: CDuiString): Boolean;');
  AFile.Add('begin');
  AFile.Add('  Result := Lhs <> Rhs.ToString;');
  AFile.Add('end;');
  AFile.Add('');
  AFile.Add('function CDuiString.ToString: string;');
  AFile.Add('begin');
  AFile.Add('  Result := PChar(@szStr[2]);');
  AFile.Add('end;');
end;

class procedure TOthers.AddOtherType(AFile: TStringList);
begin
  // typedef CControlUI* (CALLBACK* FINDCONTROLPROC)(CControlUI*, LPVOID);
  AFile.Add('  FINDCONTROLPROC = function(AControl: CControlUI; P: LPVOID): CControlUI; cdecl;');
  AFile.Add('  TFindControlProc = FINDCONTROLPROC;');

  AFile.Add('  INotifyUI = Pointer;');
  AFile.Add('  IMessageFilterUI = Pointer;');
//  AFile.Add('  CNotifyPump = class(TObject) end;');
  AFile.Add('  IListCallbackUI = Pointer;');
//  AFile.Add('  CListHeaderUI = class(TObject) end;');
  AFile.Add('  CWebBrowserEventHandler = class(TObject) end;');
//  AFile.Add('  CScrollBarUI = class(TObject) end;');
  AFile.Add('  ITranslateAccelerator = Pointer;');
  AFile.Add('  IDialogBuilderCallback = Pointer;');
//  AFile.Add('  STRINGorID = class');
//  AFile.Add('  public');
//  AFile.Add('    m_lpstr: LPCTSTR;');
//  AFile.Add('  end;');
  AFile.Add('  IListOwnerUI = Pointer;');
  AFile.Add('  STRINGorID = PWideChar; // �ݸ�');
  AFile.Add('  IDropTarget = Pointer;');
  AFile.Add('  PLRESULT = ^LRESULT;');
  // typedef int (CALLBACK *PULVCompareFunc)(UINT_PTR, UINT_PTR, UINT_PTR);
  AFile.Add('  PULVCompareFunc = function(p1, p2, p3: UINT_PTR): Integer; cdecl;');
end;

class procedure TOthers.AddTNotifyUIStruct(AFile: TStringList);
begin
  AFile.Add('  TNotifyUI = packed record');
  AFile.Add('    sType: CDuiString;');
  AFile.Add('    sVirtualWnd: CDuiString;');
  AFile.Add('    pSender: CControlUI;');
  AFile.Add('    dwTimestamp: DWORD;');
  AFile.Add('    ptMouse: TPoint;');
  AFile.Add('    wParam: WPARAM;');
  AFile.Add('    lParam: LPARAM;');
  AFile.Add('  end;');
end;

class procedure TOthers.AddTResourceType(AFile: TStringList);
begin
  AFile.Add('  /// <summary>');
  AFile.Add('  ///  ���Դ����ļ�, ���Դ���zipѹ����, ������Դ, ������Դ��zipѹ���� , ʹ�� {$Z4+} ָ�����4�ֽ�');
  AFile.Add('  /// </summary>');
  AFile.Add('  {$Z4+}');
  AFile.Add('  UILIB_RESOURCETYPE  = (UILIB_FILE = 1, UILIB_ZIP, UILIB_RESOURCE, UILIB_ZIPRESOURCE);');
  AFile.Add('  TResourceType = UILIB_RESOURCETYPE;');
end;

end.
