///=======================================================
/// ���ܣ�ר�ṩ��duilibͷ�ļ�ת��ΪDelphi����ģ����ض�Ҫ���
///
/// ���ڣ�2015-11-24
/// ���ߣ�ying32
///
///=======================================================
unit uConvert;

interface

uses
  System.SysUtils,
  System.Classes,
  System.StrUtils,
  System.Generics.Collections;

type
  TParam = record
    Name: string;
    ParamType: string;
    IsConst: Boolean;
    DefaultValue: string;
  end;

  TMember = record
    Name: string;
    ReturnType: string;
    IsConstructor: Boolean;
    IsDestructor: Boolean;
    IsStatic: Boolean;
    IsVirtual: Boolean;
    IsConst: Boolean;
    CppParams: string; // ����ԭcpp�Ĳ������Ա�����������صľ�̬����ʱ��
    OverloadName: string; // ������ֵ�������ƣ��Զ����
    Params: TArray<TParam>;
  end;

  TCvType = (ctClass, ctStruct, ctEnum, ctMakeClass);

  // ��ʽ����
  TCppConvert = class
  private
    FMemberList: TList<TMember>;
    FTypeConvertList: TDictionary<string, string>;
    FParamNameConvertList: TDictionary<string, string>;
    FDelphiTypes: TDictionary<string, string>; // ������ȽϷ���
    // c++
    FCppHeadFile: TStringList;    // cppͷ�ļ�
    FCppSourceFile: TStringList;  // cppԴ�ļ�
    FCppMethods: TStringList;     // cpp�������������ķ���
    FCppTempMethods: TStringList; // ��ʱ���棬ÿһ�����
    // delphi
    FDelphiRecord: TStringList; // Delphi�ṹ
    FDelphiGlobalVar: TStringList; // ȫ�ֱ���������������
    FDelphiInit: TStringList; // ��ʼ������
    FDelphiImportA: TStringList;  // Delphi����dll implementation��
    FDelphiImportB: TStringList;  // Delphi����dll implementation��
    FDelphiFirendClass: TStringList; // ��Ԫ��
    FDelphiClassA: TStringList; // Delphi��implementation��
    FDelphiClassB: TStringList; // Delphi��implementation��
    FDelphiEnum: TStringList; // Delphiö��
    FDelphiRecord2: TStringList; // ���ṹ�ģ������Լ����������
    FDelphiFile: TStringList;
  private
    // c++
    procedure AddCppTempMethod(const Fmt: string; Args: array of const); overload;
    procedure AddCppTempMethod(const Str: string); overload;
    function GetCppParamsNoType(LM: TMember): string;
    procedure AddDefualtCppHeader;
    procedure AddDefualtCppSource;
    procedure AddCpp(const AClass, AClassNoC: string; AM: TMember);

    // delphi
    procedure AddDelphiRecord(const Fmt: string; Args: array of const); overload;
    procedure AddDelphiRecord(const Str: string); overload;
    procedure AddDelphiDefualtHeader;
    procedure AddDelphi(const AClass, AClassNoC: string; AM: TMember);
    function GetDelphiParams(AM: TMember; NoDefualt: Boolean): string;
    function GetDelphiParamsNoType(AM: TMember): string;
    procedure AddDelphiClassAMethod(const Fmt: string; Args: array of const);
    procedure AddDelphiClassBMethod(const Fmt: string; Args: array of const;
      const CallFmt: string; CallArgs: array of const; AM: TMember);

    //===================================
    function GetHead(const Str: string): string;
    function GetParams(const Str: string): string;
    function IsProc(const Str: string): Boolean;
    /// <summary>
    ///   �������Ŀո񣬲����� *����&��λ�õ����ͺ���
    /// </summary>
    procedure ProcessStrSpace(var Str: string);
    procedure ParseParam(const Str: string; var AMember: TMember);
    procedure ParseHead(const Str: string; var AMember: TMember);
    procedure ParseFunction(const Str: string);
    procedure ParseStruct(const Str: string);
    procedure ParseEnum(const Str: string);
    procedure InitConvertList;
    procedure InitParamNameList;
    procedure InitDelphiTypes;
    function TypeOf(const CppType: string; AIsReturn: Boolean = False): string;
    function ParamNameOf(const AName: string): string;
    function FuncExistsCountAndFirstIndex(const AFName: string; var AFirstIndex:
      Integer): Integer;
    function GetRealType(const AType: string): string;
    /// <summary>
    ///   ���ش�ַ�� c++�д��� & ���ŵ�, Delphi����var��ʾ, �޲����У���������ֵ
    /// </summary>
    function IsVar(const CppType: string): Boolean;
    function IsPointer(const CppType: string): Boolean;
    function IsDelphiType(const AType: string): Boolean;

    /// <summary>
    ///   ��ȡ���캯������
    /// </summary>
    function GetConstructorCount: Integer;
    /// <summary>
    ///   ���Ͳ���Ĭ�ϵĹ�������캯��
    /// </summary>
    procedure CheckAndInsertConstructorAndestructor;

    /// <summary>
    ///   Ԥ�����У�ɾ��ע�ͣ��滻#9�ַ���ɾ������ո��
    /// </summary>
    procedure PretreatmentLine(var LineStr: string);
    function GetCVCmd(const Str: string): string;
    function GetClass(const Str: string): string;

    // �ַ�������������
    function LeftStrOf(const ASubStr, AStr: string): string;
    function RightStrOf(const ASubStr, AStr: string): string;
    function BetweenOf(const ASubStr1, ASubStr2, AStr: string): string;
  public
    constructor Create;
    destructor Destroy; override;
    procedure LoadFromFile(const AFileName: string);
    procedure SaveCppFile;
    procedure SaveDelphiFile;
    procedure ProcessMakeList(AList: TStrings);
  end;

  TStringListHelper = class helper for TStringList
  public
    procedure AddFormat(const Fmt: string; Args: array of const);
    procedure AddBlankLine;
  end;

implementation

{ TCppConvert }

uses
  uOthers;



constructor TCppConvert.Create;
begin
  FMemberList := TList<TMember>.Create;
  FTypeConvertList := TDictionary<string, string>.Create;
  InitConvertList;
  FParamNameConvertList := TDictionary<string, string>.Create;
  InitParamNameList;
  FDelphiTypes := TDictionary<string, string>.Create;
  InitDelphiTypes;

  FCppHeadFile := TStringList.Create;    // cppͷ�ļ�
  FCppSourceFile := TStringList.Create;  // cppԴ�ļ�
  FCppMethods := TStringList.Create;     // cpp�������������ķ���
  FCppTempMethods := TStringList.Create;

  FDelphiRecord := TStringList.Create;      // Delphi�ṹ
  FDelphiGlobalVar := TStringList.Create;   // ȫ�ֱ���������������
  FDelphiInit := TStringList.Create;        // ��ʼ������
  FDelphiImportA := TStringList.Create;     // Delphi����dll implementation��
  FDelphiImportB := TStringList.Create;     // Delphi����dll implementation��
  FDelphiFirendClass := TStringList.Create; // ��Ԫ��
  FDelphiClassA := TStringList.Create;
  FDelphiClassB := TStringList.Create;
  FDelphiEnum := TStringList.Create;
  FDelphiRecord2 := TStringList.Create;
  FDelphiFile := TStringList.Create;
end;

destructor TCppConvert.Destroy;
begin
  FDelphiFile.Free;
  FDelphiRecord2.Free;
  FDelphiEnum.Free;
  FDelphiClassB.Free;
  FDelphiClassA.Free;
  FDelphiFirendClass.Free;
  FDelphiInit.Free;
  FDelphiGlobalVar.Free;
  FDelphiRecord.Free;

  FCppTempMethods.Free;
  FCppMethods.Free;
  FCppSourceFile.Free;
  FCppHeadFile.Free;
  FDelphiTypes.Free;
  FParamNameConvertList.Free;
  FTypeConvertList.Free;
  FMemberList.Free;
  inherited;
end;

// �ַ�������������
function TCppConvert.LeftStrOf(const ASubStr, AStr: string): string;
var
  P1: Integer;
begin
  Result := '';
  P1 := Pos(ASubStr, AStr);
  if P1 > 0 then
    Result := Copy(AStr, 1, P1 - 1);
end;

function TCppConvert.RightStrOf(const ASubStr, AStr: string): string;
var
  P1: Integer;
begin
  Result := '';
  P1 := Pos(ASubStr, AStr);
  if P1 > 0 then
    Result := Copy(AStr, P1 + 1, Length(AStr) - P1);
end;

function TCppConvert.BetweenOf(const ASubStr1, ASubStr2, AStr: string): string;
var
  P1, P2: Integer;
begin
  Result := '';
  P1 := Pos(ASubStr1, AStr);
  if P1 > 0 then
  begin
    P2 := Pos(ASubStr2, AStr, P1 + ASubStr1.Length);
    if P2 > 0 then
      Result := Copy(AStr, P1 + ASubStr1.Length, P2 - P1 - ASubStr1.Length);
  end;
end;

procedure TCppConvert.AddDefualtCppHeader;
begin
  TOthers.AddCppHeaderCommentHeader(FCppHeadFile);
  FCppHeadFile.Add('#include "../UIlib.h"');
  FCppHeadFile.Add('');
  FCppHeadFile.Add('#define DRIECTUILIB_API extern "C" __declspec(dllexport)');
  FCppHeadFile.Add('');
end;

procedure TCppConvert.AddDefualtCppSource;
begin
  TOthers.AddCppSourceCommentHeader(FCppSourceFile);
  FCppSourceFile.Add('');
  FCppSourceFile.Add('#include "stdafx.h"');
  FCppSourceFile.Add('#include "DriectUIlib.h"');
  FCppSourceFile.AddBlankLine;
  FCppSourceFile.Add('using namespace DuiLib;');
  FCppSourceFile.Add('');
  FCppSourceFile.Add('#pragma warning(disable:4190)');
  FCppSourceFile.Add('');
end;

procedure TCppConvert.AddDelphiRecord(const Fmt: string; Args: array of const);
begin
  FDelphiRecord.Add(Format(Fmt, Args));
end;

procedure TCppConvert.AddDelphi(const AClass, AClassNoC: string; AM: TMember);

  function DeleteSymbol(const s: string): string;
  var
    I: Integer;
  begin
    Result := s;
    I := Pos('&', s);
    if I > 0 then
      Delete(Result, I, 1);
  end;

var
  LParams, LParams2, LParams21, LParams3,
    LOverload, LReturnType, LFuncName, LFuncFullName, LClassFuncFlags: string;
begin
  LOverload := '';
  LParams2 := GetDelphiParams(AM, False);
  LParams21 := GetDelphiParams(AM, True); // ��ҪĬ�ϲ���
  LParams3 := GetDelphiParamsNoType(AM);
  // ���������� ���� ���캯��
  if AM.OverloadName <> '' then
    LOverload := ' overload;';
  LParams := GetDelphiParams(AM, True);//LParams2;
  // �Ǿ�̬�����������ǹ��캯��
  if (not AM.IsStatic) and (not AM.IsConstructor) then
  begin
    if LParams <> '' then
      LParams := Format('(Handle: %s; %s)', [AClass, LParams])
    else
      LParams := Format('(Handle: %s)', [AClass]);
  end else
  begin
    // ��̬����
    if LParams <> '' then
      LParams := Format('(%s)', [LParams]);
  end;

  if LParams2.Length <> 0 then
    LParams2 := Format('(%s)', [LParams2]);
  if LParams21.Length <> 0 then
    LParams21 := Format('(%s)', [LParams21]);

  LFuncName := AM.Name;
  if AM.OverloadName = '' then
    LFuncName := ParamNameOf(LFuncName);

  LClassFuncFlags := '';
  if AM.IsStatic or AM.IsConstructor then
    LClassFuncFlags := 'class ';

  // ȷ�����ú�����
  if (not AM.IsStatic) and (not AM.IsConstructor) then
  begin
    if LParams3 <> '' then
      LParams3 := Format('(Self, %s)', [LParams3])
    else
      LParams3 := Format('(Self)', []);
  end else
  begin
    if LParams3 <> '' then
      LParams3 := Format('(%s)', [LParams3]);
  end;

  if AM.IsConstructor then
  begin
    LFuncFullName := DeleteSymbol(Format('Delphi_%s_%s%s', [AClassNoC, LFuncName, AM.OverloadName]));
    FDelphiImportA.AddFormat('function %s%s: %s; cdecl;', [LFuncFullName, LParams, AClass]);
    FDelphiImportB.AddFormat('function %s; external DuiLibdll name ''%s'';',
        [LFuncFullName, LFuncFullName]);

    // class a
    AddDelphiClassAMethod('    %sfunction %s%s: %s;%s', [LClassFuncFlags, LFuncName, LParams2, AClass, LOverload]);
    // class b
    AddDelphiClassBMethod('%sfunction %s.%s%s: %s;', [LClassFuncFlags, AClass, LFuncName, LParams2, AClass],
      'Result := %s%s;', [LFuncFullName, LParams3], AM);

  end else
  if AM.IsDestructor then
  begin
    LFuncFullName := DeleteSymbol(Format('Delphi_%s_%s', [AClassNoC, LFuncName]));
    FDelphiImportA.AddFormat('procedure %s(Handle: %s); cdecl;', [LFuncFullName, AClass]);
    FDelphiImportB.AddFormat('procedure %s; external DuiLibdll name ''%s'';',
        [LFuncFullName, LFuncFullName]);
    // class a
    AddDelphiClassAMethod('    procedure %s;', [LFuncName]);
    // class b
    AddDelphiClassBMethod('procedure %s.%s;', [AClass, LFuncName],
      '%s(Self);', [LFuncFullName], AM);
  end else
  begin
    if IsProc(AM.ReturnType) then
    begin
      LFuncFullName := DeleteSymbol(Format('Delphi_%s_%s%s', [AClassNoC, LFuncName, AM.OverloadName]));
      FDelphiImportA.AddFormat('procedure %s%s; cdecl;', [LFuncFullName, LParams]);
      FDelphiImportB.AddFormat('procedure %s; external DuiLibdll name ''%s'';',
          [LFuncFullName, LFuncFullName]);
      // class a
      AddDelphiClassAMethod('    %sprocedure %s%s;%s', [LClassFuncFlags, LFuncName, LParams2, LOverload]);
      // class b
      AddDelphiClassBMethod('%sprocedure %s.%s%s;', [LClassFuncFlags, AClass, LFuncName, LParams21],
        '%s%s;', [LFuncFullName, LParams3], AM);
    end else
    begin
      LReturnType := GetRealType(TypeOf(AM.ReturnType, True));
      LFuncFullName := DeleteSymbol(Format('Delphi_%s_%s%s', [AClassNoC, LFuncName, AM.OverloadName]));
      FDelphiImportA.AddFormat('function %s%s: %s; cdecl;', [LFuncFullName, LParams, LReturnType]);
      FDelphiImportB.AddFormat('function %s; external DuiLibdll name ''%s'';',
          [LFuncFullName, LFuncFullName]);
      // class a
      AddDelphiClassAMethod('    %sfunction %s%s: %s;%s', [LClassFuncFlags, LFuncName, LParams2,
        LReturnType, LOverload]);
      // class b
      AddDelphiClassBMethod('%sfunction %s.%s%s: %s;', [LClassFuncFlags, AClass, LFuncName, LParams21,
        LReturnType], 'Result := %s%s;', [LFuncFullName,
        LParams3], AM);
    end;
  end;
end;

procedure TCppConvert.AddDelphiClassAMethod(const Fmt: string; Args: array of const);
begin
  FDelphiClassA.Add(Format(Fmt, Args));
end;

procedure TCppConvert.AddDelphiClassBMethod(const Fmt: string; Args: array of
  const; const CallFmt: string; CallArgs: array of const; AM: TMember);
begin
  FDelphiClassB.Add(Format(Fmt, Args));
  FDelphiClassB.Add('begin');
  FDelphiClassB.Add('  ' + Format(CallFmt, CallArgs));
  FDelphiClassB.Add('end;');
  FDelphiClassB.Add('');
end;

procedure TCppConvert.AddDelphiDefualtHeader;
begin
  TOthers.AddDelphiCommentHeader(FDelphiFile);
  FDelphiFile.Add('unit Duilib;');
  FDelphiFile.Add('');
  FDelphiFile.Add('interface');
  FDelphiFile.Add('');
  FDelphiFile.Add('uses');
  FDelphiFile.Add('  Winapi.Windows,');
  FDelphiFile.Add('  Winapi.RichEdit,');
  FDelphiFile.Add('  System.Types,');
  FDelphiFile.Add('  System.Classes,');
  FDelphiFile.Add('  System.SysUtils;');
  FDelphiFile.Add('');
  FDelphiFile.Add('const');
  FDelphiFile.Add('  DuiLibdll = ''DuiLib_ud.dll'';');
  FDelphiFile.Add('');
  TOthers.AddDefualtConst(FDelphiFile);
  FDelphiFile.AddBlankLine;
end;

procedure TCppConvert.AddDelphiRecord(const Str: string);
begin
  FDelphiRecord.Add(Str);
end;

procedure TCppConvert.AddCpp(const AClass, AClassNoC: string; AM: TMember);
var
  LReturnStr, LCppParams, LConstFlags: string;
begin
  LReturnStr := '';
  if not IsProc(AM.ReturnType) then
    LReturnStr := 'return ';
  LCppParams := AM.CppParams;
  if LCppParams.Trim.Equals('void') then LCppParams := '';
  // �жϲ����Ƿ�Ϊ�գ�����ֻ��һ��voidʲô��
  if (LCppParams <> '') and (LCppParams <> 'void') and not AM.IsConstructor then
  begin
    if not AM.IsStatic then
      LCppParams := ' ,' + AM.CppParams;
  end;

  if AM.Name = 'RemoveTranslateAccelerator' then
  begin
    Writeln('----------------------------------');
    Writeln(AM.CppParams);
    Writeln(Length(AM.Params));
    Writeln(GetCppParamsNoType(AM));
  end;
  if AM.IsConstructor then
  begin
    AddCppTempMethod('DRIECTUILIB_API %s* Delphi_%s_CppCreate%s(%s) {', [AClass, AClassNoC, AM.OverloadName, LCppParams]);
    AddCppTempMethod('    return new %s(%s);', [AClass, GetCppParamsNoType(AM)]);
  end else
  if AM.IsDestructor then
  begin
    AddCppTempMethod('DRIECTUILIB_API void Delphi_%s_CppDestroy(%s* handle) {', [AClassNoC, AClass]);
    AddCppTempMethod('    delete handle;');
  end else
  begin
    // ���Ǿ�̬�����Ĵ���
    LConstFlags := '';
    if AM.IsConst then
      LConstFlags := 'const ';
    if not AM.IsStatic then
    begin
      AddCppTempMethod('DRIECTUILIB_API %s%s Delphi_%s_%s%s(%s* handle%s) {', [LConstFlags, AM.ReturnType,
        AClassNoC, AM.Name, AM.OverloadName, AClass, LCppParams]);
      AddCppTempMethod(Format('    %shandle->%s(%s);', [LReturnStr, AM.Name, GetCppParamsNoType(AM)]));
    end
    else
    begin
      // ��̬�����Ĵ���
      AddCppTempMethod('DRIECTUILIB_API %s%s Delphi_%s_%s%s(%s) {', [LConstFlags, AM.ReturnType, AClassNoC, AM.Name,
        AM.OverloadName, LCppParams]);
      AddCppTempMethod(Format('    %s%s::%s(%s);', [LReturnStr, AClass, AM.Name, GetCppParamsNoType(AM)]));
    end;
  end;
  AddCppTempMethod('}');
  AddCppTempMethod('');
end;

procedure TCppConvert.AddCppTempMethod(const Fmt: string; Args: array of const);
begin
  FCppTempMethods.Add(Format(Fmt, Args));
end;

procedure TCppConvert.AddCppTempMethod(const Str: string);
begin
  FCppTempMethods.Add(Str);
end;

function TCppConvert.FuncExistsCountAndFirstIndex(const AFName: string; var
  AFirstIndex: Integer): Integer;
var
  L: TMember;
  I: Integer;
begin
  Result := 0;
  I := 0;
  AFirstIndex := -1;
  for L in FMemberList do
  begin
    if L.Name.Equals(AFName) then
    begin
      Inc(Result);
      if Result = 1 then
        AFirstIndex := I;
    end;
    Inc(I);
  end;
end;

function TCppConvert.GetParams(const Str: string): string;
var
  P1, P2: Integer;
begin
  Result := '';
  P1 := Pos('(', Str);
  if P1 > 0 then
  begin
    P2 := Pos(')', Str, P1 + 1);
    if P2 > 0 then
      Result := Trim(Copy(Str, P1 + 1, P2 - P1 - 1));
  end;
end;

function TCppConvert.GetRealType(const AType: string): string;
var
  P1: Integer;
begin
  Result := AType;
  P1 := Pos('&', Result);
  if P1 <> 0 then
    Result := Copy(Result, 1, P1 - 1);
  P1 := Pos('*', Result);
  if P1 <> 0 then
    Result := Copy(Result, 1, P1 - 1);
end;

procedure TCppConvert.InitConvertList;
begin

  FTypeConvertList.Add('void*', 'Pointer');    // !!!
  FTypeConvertList.Add('void**', 'PPointer');  // !!!
  FTypeConvertList.Add('bool', 'Boolean');
  FTypeConvertList.Add('int', 'Integer');
  FTypeConvertList.Add('float', 'Single');
  FTypeConvertList.Add('double', 'Double');
  FTypeConvertList.Add('TCHAR', 'Char');
  FTypeConvertList.Add('_int64', 'Int64');
  FTypeConvertList.Add('long', 'LongInt');
  FTypeConvertList.Add('short', 'Short');
  FTypeConvertList.Add('BYTE', 'Byte');
  FTypeConvertList.Add('unsigned short', 'Byte');
  FTypeConvertList.Add('long double', 'Extended');
  FTypeConvertList.Add('WCHAR', 'WideChar');
  FTypeConvertList.Add('char*', 'PChar');    // !!! 'char', 'PChar'
  FTypeConvertList.Add('CHAR*', 'PChar');    // !!! 'CHAR', 'PChar'
  FTypeConvertList.Add('unsigned int', 'LongInt');
  FTypeConvertList.Add('RECT', 'TRect');
  FTypeConvertList.Add('SIZE', 'TSize');
  FTypeConvertList.Add('POINT', 'TPoint');
  FTypeConvertList.Add('HINSTANCE', 'HINST');
  FTypeConvertList.Add('HANDLE', 'THandle');
  FTypeConvertList.Add('LPVOID', 'Pointer');
  FTypeConvertList.Add('LPMSG', 'PMsg');
  FTypeConvertList.Add('FINDCONTROLPROC', 'TFindControlProc');
  FTypeConvertList.Add('RectF', 'TRectF');

  FTypeConvertList.Add('CDuiPoint', 'TPoint');

  FTypeConvertList.Add('InitWindowCallBack', 'Pointer');
  FTypeConvertList.Add('FinalMessageCallBack', 'Pointer');
  FTypeConvertList.Add('HandleMessageCallBack', 'Pointer');
  FTypeConvertList.Add('NotifyCallBack', 'Pointer');
  FTypeConvertList.Add('MessageCallBack', 'Pointer');
  FTypeConvertList.Add('CreateControlCallBack', 'Pointer');
  FTypeConvertList.Add('DoEventCallBack', 'Pointer');
  FTypeConvertList.Add('SelectItemCallBack', 'Pointer');

  // �����е�
  FTypeConvertList.Add('true', 'True');
  FTypeConvertList.Add('false', 'False');
  FTypeConvertList.Add('NULL', 'nil');
end;

procedure TCppConvert.InitDelphiTypes;
begin
  FDelphiTypes.Add('TRect', '');
  FDelphiTypes.Add('TSize', '');
end;

procedure TCppConvert.InitParamNameList;
begin
  FParamNameConvertList.Add('type', 'AType');
  FParamNameConvertList.Add('set', '&Set');
  FParamNameConvertList.Add('self', 'ASelf');
end;

function TCppConvert.IsDelphiType(const AType: string): Boolean;
begin
  Result := FDelphiTypes.ContainsKey(AType);
end;

function TCppConvert.IsPointer(const CppType: string): Boolean;
begin
  if CppType = '' then
    Exit(False);
  Result := CppType[CppType.Length] = '*';
end;

function TCppConvert.IsProc(const Str: string): Boolean;
begin
  Result := Str.Equals('void') or Str.Equals('VOID');
end;

function TCppConvert.IsVar(const CppType: string): Boolean;
begin
  if CppType = '' then
    Exit(False);
  Result := CppType[CppType.Length] = '&';
end;

procedure TCppConvert.LoadFromFile(const AFileName: string);
var
  LFile: TStringList;
begin
  LFile := TStringList.Create;
  try
    FMemberList.Clear;
    LFile.LoadFromFile(AFileName);
    ProcessMakeList(LFile);
  finally
    LFile.Free;
  end;
end;

function TCppConvert.ParamNameOf(const AName: string): string;
begin
  if not FParamNameConvertList.TryGetValue(AName.ToLower, Result) then
    Result := AName;
end;

procedure TCppConvert.ParseEnum(const Str: string);
var
  P1: Integer;
begin
  P1 := Pos('=', Str);
  // ��Ĭ��ֵ
  if P1 > 0 then
    FDelphiEnum.AddFormat('    %s = %s', [LeftStrOf('=', Str).Trim, RightStrOf('=',
      Str).Trim])
  else
    FDelphiEnum.Add('    ' + Str.Trim);
end;

procedure TCppConvert.ParseStruct(const Str: string);
var
  S, LType, LName, LArrSize: string;
  P1: Integer;
begin
  S := Str.Trim;
  ProcessStrSpace(S);
  // �Ƿ��г�����ʶ��
  P1 := Pos('const', S);
  if P1 > 0 then
  begin
    Delete(S, P1, 'const'.Length);
    S := S.Trim;
  end;
  // �Ƿ���һ������
  P1 := Pos('(', S);
  if P1 > 0 then
  begin
    FDelphiRecord2.AddFormat('    // %s', [S]);
    // ��ʱ�˳������
    Exit;
  end;
  // ����

  P1 := Pos('[', S);
  if P1 > 0 then
  begin
    LArrSize := BetweenOf('[', ']', S);
    LName := ParamNameOf(LeftStrOf('[', BetweenOf(' ', ';', S)));
    LType := Format('array[0..%s-1] of %s', [LArrSize, GetRealType(TypeOf(LeftStrOf(' ', S), True))]);
  end else
  begin
    LName := ParamNameOf(BetweenOf(' ', ';', S));
    LType := GetRealType(TypeOf(LeftStrOf(' ', S), True));
  end;

  FDelphiRecord2.AddFormat('    %s: %s;', [LName, LType]);
end;

procedure TCppConvert.ParseFunction(const Str: string);
var
  LMember: TMember;
begin
  FillChar(LMember, SizeOf(TMember), #0);
  ParseHead(Str, LMember);
  ParseParam(Str, LMember);
end;

procedure TCppConvert.ParseHead(const Str: string; var AMember: TMember);
var
  LHead, S: string;
  LHeadArr: TArray<string>;
  I: Integer;
begin
  LHead := GetHead(Str);
  ProcessStrSpace(LHead);
  if LHead <> '' then
  begin
    LHeadArr := LHead.Split([#32]);
    // ���ٰ���2����һ������,һ��������
    if Length(LHeadArr) < 2 then
    begin
      // ֻ��һ�����������ǹ��캯��
      if Length(LHeadArr) = 1 then
      begin
        AMember.Name := 'CppCreate';
        AMember.IsConstructor := True;
      end;
      Exit;
    end;

    AMember.Name := LHeadArr[High(LHeadArr)];
    AMember.ReturnType := LHeadArr[High(LHeadArr) - 1];
    // ��������ֵ�뺯����
    for I := 0 to High(LHeadArr) - 2 do
    begin
      S := LHeadArr[I].Trim;
      if S.Equals('static') then
        AMember.IsStatic := True
      else if S.Equals('const') then
        AMember.IsConst := True
      else if S.Equals('virtual') then
        AMember.IsVirtual := True;
    end;
  end;
end;

procedure TCppConvert.ParseParam(const Str: string; var AMember: TMember);
var
  ParamsStr, S: string;
  LParamArr: TArray<string>;
  I, P1, LFirstIndex: Integer;
  LTempMember: TMember;
begin
  // ��������û�в������
  if AMember.Name = '' then Exit;
  ParamsStr := GetParams(Str);
  if ParamsStr <> '' then
  begin
    AMember.CppParams := ParamsStr;

    LParamArr := ParamsStr.Split([',']);
    if Length(LParamArr) > 0 then
    begin
      SetLength(AMember.Params, Length(LParamArr));
      for I := 0 to High(LParamArr) do
      begin
        S := LParamArr[I].Trim;
        ProcessStrSpace(S);
        // �鿴��û��*�����λ��
        P1 := S.LastIndexOf('*');
        if P1 <> -1 then
        begin
          if S[P1 + 2] <> #32 then
            System.Insert(#32, S, P1 + 2);
        end;
        // �鿴��û��&�����λ��
        P1 := S.LastIndexOf('&');
        if P1 <> -1 then
        begin
          if S[P1 + 2] <> #32 then
            System.Insert(#32, S, P1 + 2);
        end;


        P1 := Pos('=', S);
        // �ж���û��Ĭ��ֵ
        if P1 > 0 then
        begin
          // ȡ��Ĭ��ֵ��Ȼ��ɾ��Ĭ��ֵ
          AMember.Params[I].DefaultValue := Trim(Copy(S, P1 + 1, S.Length - P1));
          Delete(S, P1, S.Length - P1 + 1);
          S := S.Trim; // ��ɾ������Ŀո�
        end;
        // �����û��const�ֶ�
        P1 := Pos('const', S);
        if P1 > 0 then
        begin
          AMember.Params[I].IsConst := True;
          Delete(S, P1, 'const'.Length);
          S := S.Trim;
        end;
        P1 := S.LastIndexOf(#32);
        // û�в�������
        if P1 >= 0 then
        begin
          AMember.Params[I].ParamType := Trim(Copy(S, 1, S.LastIndexOf(#32)));
          AMember.Params[I].Name := Trim(Copy(S, P1 + 1, S.Length - P1));
        end
        else
        begin
          AMember.Params[I].Name := '';
          AMember.Params[I].ParamType := S.Trim;
        end;
      end;
    end;
  end;
  // ��ӵ��ռ���Ϣ����
  if AMember.IsConstructor then
    FMemberList.Insert(GetConstructorCount, AMember)
  else
    FMemberList.Add(AMember);
  // ��ѯ�Ƿ������ز�����
  P1 := FuncExistsCountAndFirstIndex(AMember.Name, LFirstIndex);
  if P1 > 1 then
  begin
    if LFirstIndex <> -1 then
    begin
      LTempMember := FMemberList[LFirstIndex];
      if LTempMember.OverloadName = '' then
      begin
        LTempMember.OverloadName := '_01';
        FMemberList[LFirstIndex] := LTempMember;
      end;
    end;
    AMember.OverloadName := Format('_%.2d', [P1]);
    FMemberList[FMemberList.Count - 1] := AMember;
  end;
end;

procedure TCppConvert.PretreatmentLine(var LineStr: string);
var
  P1, P2: Integer;
begin
  LineStr := LineStr.Replace(#9, #32, [rfReplaceAll]);

  P1 := Pos('//', LineStr);
  if P1 > 0 then
    Delete(LineStr, P1, Length(LineStr) - P1);
  P1 := Pos('/*', LineStr);
  if P1 > 0 then
  begin
    P2 := Pos('*/', LineStr, P1 + 2);
    if P2 > 0 then
      Delete(LineStr, P1, P2 - P1 + 2);
  end;
end;

procedure TCppConvert.ProcessMakeList(AList: TStrings);
var
  S: string;
  I: Integer;
  LCvType: TCvType;
  LCvCmd, LClass, LClassNoC, LBaseClass, LTempStr: string;
  LM: TMember;
begin
  LCvType := ctClass;
  for I := 0 to AList.Count - 1 do
  begin
    S := Trim(AList[I]);
    if S.IsEmpty or
      (S[1] = '#') or
      (Pos('~', S) <> 0) or  // ��������������
      (Copy(S, 1, 2) = '//') or
      (Pos('operator', S) <> 0) then
      Continue;
    PretreatmentLine(S);
    LCvCmd := GetCVCmd(S);
    // ���ת��
    if LCvCmd.Equals('classbegin') then
    begin
      LCvType := ctClass;
      FCppMethods.Clear;
      FMemberList.Clear;
      LClass := GetClass(S);
      LBaseClass := '';
      if LClass.IndexOf(',') <> -1 then
      begin
        // ��ע�͵�, �����ٿ������������
        LBaseClass := RightStrOf(',', LClass).Trim;
        LClass := LeftStrOf(',', LClass).Trim;
      end;

      if LClass[1] = 'C' then
        LClassNoC := LClass.Substring(1)
      else
        LClassNoC := LClass;
      Writeln('���ڴ���', LClass);
      // ���ȫ�ֱ���
      //FDelphiGlobalVar.AddFormat('  %sMethods: TDelphi_%sMethods;', [LClassNoC, LClassNoC]);
      // ��ӳ�ʼ������
      //FDelphiInit.AddFormat('  Export_Delphi_%s(%sMethods);', [LClassNoC, LClassNoC]);

      // ���implementation֮ǰ
      //FDelphiImportA.AddFormat('  procedure Export_Delphi_%s(var methods: TDelphi_%sMethods); cdecl;',
      //  [LClassNoC, LClassNoC]);
      // ���implementation֮��
      //FDelphiImportB.AddFormat('procedure Export_Delphi_%s; external DuiLibdll name ''Export_Delphi_%s'';',
      //  [LClassNoC, LClassNoC]);

      // �����Ԫ��
      FDelphiFirendClass.AddFormat('  %s = class;', [LClass]);

      // ���Delphi��
      FDelphiClassA.Add('');
      FDelphiClassA.AddFormat('  %s = class%s', [LClass, IfThen(LBaseClass.IsEmpty, '', '(' + LBaseClass + ')')]);
      FDelphiClassA.Add('  public');
//      AddDelphiClassAMethod('    class function CppCreate: %s;', [LClass]);
//      AddDelphiClassAMethod('    procedure CppDestroy;', []);
//      // �����ʵ�ַ���
      FDelphiClassB.AddFormat('{ %s }', [LClass]);
      FDelphiClassB.Add('');

      FDelphiImportA.AddBlankLine;
      FDelphiImportA.AddFormat('//================================%s============================', [LClass]);
      FDelphiImportA.AddBlankLine;

      FDelphiImportB.AddBlankLine;
      FDelphiImportB.AddFormat('//================================%s============================', [LClass]);
      FDelphiImportB.AddBlankLine;
//      FDelphiClassB.AddFormat('class function %s.CppCreate: %s;', [LClass, LClass]);
//      FDelphiClassB.Add('begin');
//      FDelphiClassB.AddFormat('  Result := %sMethods.Default._Create;', [LClassNoC]);
//      FDelphiClassB.Add('end;');
//      FDelphiClassB.AddBlankLine;
//      FDelphiClassB.AddFormat('procedure %s.CppDestroy;', [LClass]);
//      FDelphiClassB.Add('begin');
//      FDelphiClassB.AddFormat('  %sMethods.Default._Destroy(Self);', [LClassNoC]);
//      FDelphiClassB.Add('end;');
//      FDelphiClassB.AddBlankLine;

      // ���Delphi��¼ͷ
      //AddDelphiRecord('  TDelphi_%sMethods = record', [LClassNoC]);
      //AddDelphiRecord('    Default: TDefaultMethods;');

      // ���cpp��¼ͷ
      //AddCppStruct('struct TDelphi_%sMethods {', [LClassNoC]);
      //AddCppStruct('    TDefaultMethods default;');

      // ���cpp�������������
//      AddCppTempMethod('%s* Delphi_%s_Create() {', [LClass, LClassNoC]);
//      AddCppTempMethod('    return new %s;', [LClass]);
//      AddCppTempMethod('}');
//      AddCppTempMethod('');
//      AddCppTempMethod('void Delphi_%s_Destroy(%s* handle) {', [LClassNoC, LClass]);
//      AddCppTempMethod('    delete handle;');
//      AddCppTempMethod('}');
//      AddCppTempMethod('');

      //AddCppExport('DRIECTUILIB_API void Export_Delphi_%s(TDelphi_%sMethods& methods) {',
      //  [LClassNoC, LClassNoC]);
//      AddCppExport('    methods.default._Create = &Delphi_%s_Create;', [LClassNoC]);
//      AddCppExport('    methods.default._Destroy = &Delphi_%s_Destroy;', [LClassNoC]);
      AddCppTempMethod('//================================%s============================', [LClass]);
      AddCppTempMethod('');
    end
    else if LCvCmd.Equals('classend') then
    begin
      // ���Ͳ��빹�����������
      CheckAndInsertConstructorAndestructor;
      for LM in FMemberList do
      begin
        AddCpp(LClass, LClassNoC, LM);
        AddDelphi(LClass, LClassNoC, LM);
      end;
//      AddCppExport('};');
//      AddCppExport('');
//      AddCppTempMethod(FCppExports.Text);

//      AddCppStruct('};');
//      AddCppStruct('');

      FCppMethods.Add('');
      FCppMethods.AddStrings(FCppTempMethods);
      FCppMethods.Add('');
      // ��¼����
//      AddDelphiRecord('  end;');
//      AddDelphiRecord('');
      // �����
      FDelphiClassA.Add('  end;');

      Writeln('����', LClass, '����.');
    end
    else
    // �ṹ��ת��
    if LCvCmd.Equals('structbegin') then
    begin
      LCvType := ctStruct;
      LClass := GetClass(S);
      LClassNoC := LClass;
      Writeln('���ڴ���', LClass);
      if Copy(LClass, 1, 3) = 'tag' then
        LClassNoC := LClass.Substring(3);
      if LClassNoC[1] = 'T' then
        LClassNoC := LClassNoC.Substring(1);
      FDelphiRecord2.AddFormat('  %s = packed record', [LClass]);
    end
    else if LCvCmd.Equals('structend') then
    begin
      FDelphiRecord2.Add('  end;');
      FDelphiRecord2.AddFormat('  P%s = ^T%s;', [LClassNoC, LClassNoC]);
      FDelphiRecord2.AddFormat('  T%s = %s;', [LClassNoC, LClass]);
      FDelphiRecord2.Add('');
      Writeln('����', LClass, '����.');
    end
    else
    // ö��ֵ��ת��
    if LCvCmd.Equals('enumbegin') then
    begin
      LCvType := ctEnum;
      LClass := GetClass(S);
      LClassNoC := LClass;
      Writeln('���ڴ���', LClass);
      FDelphiEnum.Add('');
      FDelphiEnum.Add('  {$Z4+}');
      FDelphiEnum.Add('  ' + LClass + ' = (');
    end
    else if LCvCmd.Equals('enumend') then
    begin
      if FDelphiEnum.Count > 0 then
      begin
        LTempStr := FDelphiEnum[FDelphiEnum.Count - 1];
        if LTempStr[LTempStr.Length] = ',' then
        begin
          Delete(LTempStr, LTempStr.Length, 1);
          FDelphiEnum[FDelphiEnum.Count - 1] := LTempStr;
        end;
      end;
      FDelphiEnum.Add('  );');
      FDelphiEnum.AddFormat('  T%s = %s;', [LClass, LClass]);
      Writeln('����', LClass, '����.');
    end
    else if LCvCmd.Equals('makeclassbegin') then
    begin
      LCvType := ctMakeClass;

    end
    else if LCvCmd.Equals('makeclassend') then
    begin

    end
    else
    begin
      case LCvType of
        ctClass:
          ParseFunction(S);
        ctStruct:
          ParseStruct(S);
        ctEnum:
          ParseEnum(S);
        ctMakeClass:
          begin

          end;
      end;
    end;
  end;
end;

procedure TCppConvert.ProcessStrSpace(var Str: string);
var
  I: Integer;
begin
  if Str = '' then
    Exit;
  // �ȴ���ո�
  I := Str.Length;
  repeat
    if Str[I] = #32 then
    begin
      if Str[I - 1] = #32 then
        Delete(Str, I, 1);
    end;
    Dec(I);
  until I = 1;
  I := Str.Length;
  // �ٴ��� * �� & ���ŵ�λ��
  repeat
    if (Str[I] = '*') or (Str[I] = '&') then
    begin
      if Str[I - 1] = #32 then
        Delete(Str, I - 1, 1);
    end;
    Dec(I);
  until I = 1;
  Str := Str.Trim;
end;

function TCppConvert.TypeOf(const CppType: string; AIsReturn: Boolean): string;

  function GetType: string;
  var
    P1: Integer;
  begin
    Result := CppType;
    if Pos('void', Result) = 0 then
    begin
      P1 := Pos('&', Result);
      if P1 <> 0 then
        Result := Copy(Result, 1, P1 - 1);
      P1 := Pos('*', Result);
      if P1 <> 0 then
        Result := Copy(Result, 1, P1 - 1);
    end;
  end;

var
  LFChar: Char;
begin
  if not FTypeConvertList.TryGetValue(GetType, Result) then
    Result := CppType;
  if IsPointer(CppType) or (AIsReturn and IsVar(CppType)) then
  begin
    // *����&
    LFChar := Result[1];
    if (LFChar = 'T') and not AIsReturn then // �Ѿ�תΪDelphi�����˵�
      Result := 'P' + Result.Substring(1)
    else if (LFChar <> 'I') and (LFChar <> 'C') and not AIsReturn then
      Result := 'P' + Result
    else if AIsReturn then
    begin
      if IsPointer(CppType) then
      begin
        if Result[1] = 'T' then // �Ѿ�תΪDelphi�����˵�
          Result := 'P' + Result.Substring(1)
      end else if IsVar(CppType) then
      begin
        if Result[1] = 'T' then // �Ѿ�תΪDelphi�����˵�
          Result := 'P' + Result.Substring(1)
        else Result := 'P' + Result;
      end;
    end;
  end;
end;

function TCppConvert.GetClass(const Str: string): string;
begin
  Result := RightStrOf(':', Str).Trim;
end;

function TCppConvert.GetConstructorCount: Integer;
var
  LM: TMember;
begin
  Result := 0;
  for LM in FMemberList do
    if LM.IsConstructor then
      Inc(Result);
end;

procedure TCppConvert.CheckAndInsertConstructorAndestructor;
var
  I: Integer;
  LM: TMember;
begin
  I := GetConstructorCount;
  FillChar(LM, SizeOf(TMember), #0);
  if I = 0 then
  begin
    LM.Name := 'CppCreate';
    LM.IsConstructor := True;
    FMemberList.Insert(0, LM);
    I := 1;
  end;
  LM.Name := 'CppDestroy';
  LM.IsConstructor := False;
  LM.IsDestructor := True;
  FMemberList.Insert(I, LM);
end;

function TCppConvert.GetCppParamsNoType(LM: TMember): string;
var
  L: TParam;
begin
  Result := '';
  for L in LM.Params do
  begin
    if LM.Name = 'RemoveTranslateAccelerator' then
    begin
      Writeln(L.Name,  '            ', L.ParamType);
    end;
    Result := Result + L.Name + ', ';
  end;
  if Result.Length > 0 then
    Delete(Result, Result.Length - 1, 2);
end;

function TCppConvert.GetCVCmd(const Str: string): string;
begin
  Result := LeftStrOf(':', Str).Trim;
end;

function TCppConvert.GetDelphiParams(AM: TMember; NoDefualt: Boolean): string;
var
  L: TParam;
  LD, LVar, LConst, LName: string;
begin
  Result := '';
  if Length(AM.Params) = 1 then
  begin
    if AM.Params[0].Name = '' then
      Exit;
  end;
  for L in AM.Params do
  begin
    LName := ParamNameOf(L.Name);

    LVar := '';
    if IsVar(L.ParamType) then
    begin
      LVar := 'var ' + LName;
      LName := '';
    end;
    LD := '';
    if (L.DefaultValue <> '') and not NoDefualt then
    begin
      if not IsPointer(L.ParamType) then
      begin
        // ������ NULL���Ҳ���ָ������
        LD := ' = ' + TypeOf(L.DefaultValue);
        // ��ʱ������
        if (L.DefaultValue = 'NULL') and (L.ParamType <> 'LPCTSTR') then
          LD := ' = 0'
        else if CharInSet(L.DefaultValue[1], ['0'..'9']) then
        begin
          if CharInSet(L.DefaultValue[L.DefaultValue.Length], ['L', 'l']) then
            LD := ' = ' + Copy(L.DefaultValue, 1, L.DefaultValue.Length - 1)
        end;
      end
      else
        LD := ' = ' + TypeOf(L.DefaultValue);
    end;
    LConst := '';
    if not IsVar(L.ParamType) and L.IsConst then
      LConst := 'const ';
    Result := Result + Format('%s%s%s: %s%s; ', [LConst, LVar, LName,
      GetRealType(TypeOf(L.ParamType)), LD]);
  end;
  if Result.Length <> 0 then
    Delete(Result, Result.Length - 1, 2);
end;

function TCppConvert.GetDelphiParamsNoType(AM: TMember): string;
var
  L: TParam;
begin
  Result := '';
  if Length(AM.Params) = 1 then
  begin
    if AM.Params[0].Name = '' then
      Exit;
  end;
  for L in AM.Params do
    Result := Result + Format('%s, ', [ParamNameOf(L.Name)]);
  if Result.Length <> 0 then
    Delete(Result, Result.Length - 1, 2);
end;

function TCppConvert.GetHead(const Str: string): string;
begin
  Result := Trim(Copy(Str, 1, Pos('(', Str) - 1));
end;

procedure TCppConvert.SaveCppFile;
begin
  AddDefualtCppHeader;
  FCppHeadFile.Add('');
  FCppHeadFile.SaveToFile(ExtractFilePath(ParamStr(0)) + 'DriectUIlib.h');

  AddDefualtCppSource;
  FCppSourceFile.AddBlankLine;
  //TOthers.AddCppCDelphi_WindowImplBase(FCppSourceFile);
  if FileExists(ExtractFilePath(ParamStr(0)) + 'MakeCppSourceDef.txt') then
  begin
    FCppTempMethods.LoadFromFile(ExtractFilePath(ParamStr(0)) + 'MakeCppSourceDef.txt');
    FCppSourceFile.AddStrings(FCppTempMethods);
    FCppTempMethods.Clear;
    FCppSourceFile.AddBlankLine;
  end;
  FCppSourceFile.Add('');
  FCppSourceFile.AddStrings(FCppMethods);
  FCppSourceFile.Add('');
  FCppSourceFile.SaveToFile(ExtractFilePath(ParamStr(0)) + 'DriectUIlib.cpp');
end;

procedure TCppConvert.SaveDelphiFile;
begin
  AddDelphiDefualtHeader;
  FDelphiFile.Add('type');
  FDelphiFile.AddBlankLine;
  FDelphiFile.AddStrings(FDelphiFirendClass);
  FDelphiFile.AddBlankLine;
  // ��֪�������Ͷ�����ӵ���Ԫ��������
  TOthers.AddOtherType(FDelphiFile);
  FDelphiFile.AddBlankLine;

  TOthers.AddDelphiDuiStringA(FDelphiFile);
  FDelphiFile.AddBlankLine;
  TOthers.AddTResourceType(FDelphiFile);
  FDelphiFile.AddBlankLine;
  FDelphiFile.AddStrings(FDelphiEnum);
  FDelphiFile.AddBlankLine;
  FDelphiFile.AddStrings(FDelphiRecord2);
  FDelphiFile.AddBlankLine;
//  FDelphiFile.Add('  TDefaultMethods = record');
//  FDelphiFile.Add('    {static} _Create: function: Pointer; cdecl;');
//  FDelphiFile.Add('    {static} _Destroy: procedure(handle: Pointer); cdecl;');
//  FDelphiFile.Add('  end;');
//  FDelphiFile.AddBlankLine;
  TOthers.AddTNotifyUIStruct(FDelphiFile);

  FDelphiFile.AddBlankLine;
  FDelphiFile.AddStrings(FDelphiClassA);

  FDelphiFile.AddBlankLine;
  FDelphiFile.AddStrings(FDelphiRecord);
  FDelphiFile.AddBlankLine;
  FDelphiFile.AddBlankLine;

  FDelphiFile.AddBlankLine;
//  FDelphiFile.Add('var');
//  FDelphiFile.AddStrings(FDelphiGlobalVar);
//  FDelphiFile.AddBlankLine;

  FDelphiFile.AddStrings(FDelphiImportA);
  FDelphiFile.Add('implementation');
  FDelphiFile.AddBlankLine;
  // ���һ����ຯ��
//  FDelphiFile.Add('procedure PushECX(this: Pointer);');
//  FDelphiFile.Add('asm');
//  FDelphiFile.Add('  MOV ECX, this');
//  FDelphiFile.Add('end;');
  FDelphiFile.AddBlankLine;
  TOthers.AddDelphiDuiStringB(FDelphiFile);
  FDelphiFile.AddBlankLine;
  FDelphiFile.AddStrings(FDelphiClassB);
  FDelphiFile.AddBlankLine;
  FDelphiFile.AddStrings(FDelphiImportB);
  FDelphiFile.AddBlankLine;
  FDelphiFile.Add('initialization');
  FDelphiFile.AddStrings(FDelphiInit);
  FDelphiFile.AddBlankLine;
  FDelphiFile.Add('end.');
  FDelphiFile.SaveToFile(ExtractFilePath(ParamStr(0)) + 'Duilib.pas');
end;

{ TStringListHelper }

procedure TStringListHelper.AddBlankLine;
begin
  Add('');
end;

procedure TStringListHelper.AddFormat(const Fmt: string; Args: array of const);
begin
  Add(Format(Fmt, Args));
end;

end.

