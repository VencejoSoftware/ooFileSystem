unit ooFSUtils;

interface

uses
  SysUtils, Windows
{$IFDEF FPC}
  , FileUtil
{$ELSE}
  , IOUtils
{$ENDIF};

procedure CreateTempArchive(const FileName: String; const Count: Integer = 1);
procedure CreatePath(const Path: String);
procedure DeletePath(const Path: String);
procedure DeleteArchive(const Path: String);

implementation

function FileIsReadOnly(const FileName: String): Boolean;
begin
  Result := GetFileAttributes(PChar(FileName)) and FILE_ATTRIBUTE_READONLY > 0;
end;

procedure DeleteArchive(const Path: String);
begin
{$WARN SYMBOL_PLATFORM OFF}
  if FileIsReadOnly(Path) then
    FileSetAttr(Path, not SysUtils.faReadOnly);
{$WARN SYMBOL_PLATFORM ON}
  if not SysUtils.DeleteFile(Path) then
    RaiseLastOSError;
end;

procedure CreatePath(const Path: String);
begin
  if DirectoryExists(Path) then
    DeletePath(Path);
  CreateDir(Path);
end;

procedure DeletePath(const Path: String);
begin
  try
{$IFDEF FPC}
    DeleteDirectory(Path, False);
{$ELSE}
    TDirectory.Delete(Path, True);
{$ENDIF}
  except
  end;
end;

procedure CreateTempArchive(const FileName: String; const Count: Integer = 1);
var
  newFile: TextFile;
  i: Integer;
begin
  if FileExists(FileName) then
    DeleteArchive(FileName);
  AssignFile(newFile, FileName);
  try
    Rewrite(newFile);
    for i := 1 to Count do
      WriteLn(newFile, 'line 1');
  finally
    CloseFile(newFile);
  end;
end;

end.
