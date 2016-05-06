program CppConvert;

{$APPTYPE CONSOLE}

{$R *.res}

uses
//  winapi.Windows,
  System.SysUtils,
  uConvert in 'uConvert.pas',
  uOthers in 'uOthers.pas';


var
  gFileName: string;

procedure Test1;
var
  Cpp: TCppConvert;
begin
  Writeln('��ʼ����');

  Cpp := TCppConvert.Create;
  try
    Writeln('�����ĵ���', gFileName);
    Cpp.LoadFromFile(gFileName);
    Cpp.SaveCppFile;
    Cpp.SaveDelphiFile;
  finally
    Cpp.Free;
  end;
  Writeln('��ɡ�');
  Writeln('�밴[Enter]���˳���');
end;

begin
  try
    Writeln('��һ���ļ������ڣ�');
    Readln(gFileName);
    if FileExists(gFileName) then
      Test1;
    readln;
    { TODO -oUser -cConsole Main : Insert code here }
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
