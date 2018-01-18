unit ooFSUtils;

interface

uses
  Windows, Classes, SysUtils, Forms
{$IFDEF FPC}
  , FileUtil
{$ELSE}
  , IOUtils
{$ENDIF};
function TempFolder: String;
function ReadLine(const FileName: String; const LineNr: Integer): String;
function AreEqualFiles(const FilePath1, FilePath2: String): Boolean;
function CalcFileSizeInBytes(const FileName: String): Int64;

procedure RemoveTempFolder;
procedure CreateTempArchive(const FileName: String; const Count: Integer = 1);
procedure CreatePath(const Path: String);
procedure DeletePath(const Path: String);
procedure DeleteArchive(const Path: String);
procedure CreateTempFileWithRandomData(const FileName: String; const Lines: Integer = 1);
procedure CreateTempFileWithFixedData(const FileName: String; const Data: String; const Lines: Integer = 1);
procedure CheckFolder(const Folder: String);

implementation

function CalcFileSizeInBytes(const FileName: String): Int64;
var
  SearchRec: TSearchRec;
begin
{$WARN SYMBOL_PLATFORM OFF}
  if FindFirst(FileName, faAnyFile, SearchRec) = 0 then
    Result := Int64(SearchRec.FindData.nFileSizeHigh) shl Int64(32) + Int64(SearchRec.FindData.nFileSizeLow)
  else
    Result := - 1;
{$WARN SYMBOL_PLATFORM ON}
  FindClose(SearchRec);
end;

function IsIdenticalStreams(const Source, Destination: TStream): Boolean;
const
  Block_Size = 4096;
var
  Buffer_1: array [0 .. Block_Size - 1] of byte;
  Buffer_2: array [0 .. Block_Size - 1] of byte;
  Buffer_Length: Integer;
begin
  Result := False;
  if Source.Size <> Destination.Size then
    Exit;
  Source.Position := 0;
  Destination.Position := 0;
  while Source.Position < Source.Size do
  begin
    Buffer_Length := Source.Read(Buffer_1, Block_Size);
    Destination.Read(Buffer_2, Block_Size);
    if not CompareMem(@Buffer_1, @Buffer_2, Buffer_Length) then
      Exit;
  end;
  Result := True;
end;

function AreEqualFiles(const FilePath1, FilePath2: String): Boolean;
var
  File1, File2: TFileStream;
begin
  File1 := TFileStream.Create(FilePath1, fmOpenRead);
  try
    File2 := TFileStream.Create(FilePath2, fmOpenRead);
    try
      Result := IsIdenticalStreams(File1, File2);
    finally
      File2.Free;
    end;
  finally
    File1.Free;
  end;
end;

function ReadLine(const FileName: String; const LineNr: Integer): String;
var
  FileStream: TextFile;
  LineIndex: Integer;
begin
  Result := EmptyStr;
  AssignFile(FileStream, FileName);
  Reset(FileStream);
  try
    LineIndex := 0;
    while not Eof(FileStream) or (LineIndex <> LineNr) do
    begin
      ReadLn(FileStream, Result);
      inc(LineIndex);
    end;
  finally
    CloseFile(FileStream);
  end;
end;

procedure CheckFolder(const Folder: String);
begin
  if not TDirectory.Exists(Folder) then
    TDirectory.CreateDirectory(Folder);
end;

function TempFolder: String;
begin
{$WARN SYMBOL_PLATFORM OFF}
  Result := IncludeTrailingBackslash(ExtractFilePath(Application.ExeName)) + 'temp\';
  CheckFolder(Result);
{$WARN SYMBOL_PLATFORM ON}
end;

procedure RemoveTempFolder;
begin
  if TDirectory.Exists(TempFolder) then
    TDirectory.Delete(TempFolder, True);
end;

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

function NumberToWords(Number: Integer): string;
const
  Billion = 1000000000;
  Million = 1000000;
  Thousand = 1000;
  Hundred = 100;
  Tens: array [2 .. 9] of string = ('twenty', 'thirty', 'forty', 'fifty', 'sixty', 'seventy', 'eighty', 'ninety');
  Teens: array [10 .. 19] of string = ('ten', 'eleven', 'twelve', 'thirteen', 'fourteen', 'fifteen', 'sixteen',
    'seventeen', 'eighteen', 'nineteen');
  Units: array [1 .. 9] of string = ('one', 'two', 'three', 'four', 'five', 'six', 'seven', 'eight', 'nine');
begin
  if (Number < 0) then
    Result := 'minus '
  else
    Result := '';
  Number := abs(Number); // Get number as Positive Value;
  if (Number >= Billion) then
  begin
    Result := Result + NumberToWords(Number div Billion) + ' bllion, ';
    Number := Number mod Billion;
  end;
  if (Number >= Million) then
  begin
    Result := Result + NumberToWords(Number div Million) + ' million, ';
    Number := Number mod Million;
  end;
  if (Number >= Thousand) then
  begin
    Result := Result + NumberToWords(Number div Thousand) + ' thousand, ';
    Number := Number mod Thousand;
  end;
  if (Number >= Hundred) then
  begin
    Result := Result + NumberToWords(Number div Hundred) + ' hundred';
    Number := Number mod Hundred;
  end;
  if (Number > 0) and (Result <> '') then
  begin
    Result := Trim(Result);
    if (Result[Length(Result)] = ',') then
      Delete(Result, Length(Result), 1);
    Result := Result + ' and ';
  end;
  if (Number >= 20) then
  begin
    Result := Result + Tens[Number div 10] + ' ';
    Number := Number mod 10;
  end;
  if (Number >= 10) then
  begin
    Result := Result + Teens[Number];
    Number := 0
  end;
  if (Number >= 1) then
    Result := Result + Units[Number];
  Result := Trim(Result);
  if (Result = '') then
    Result := 'zero'
  else
    if (Result[Length(Result)] = ',') then
      Delete(Result, Length(Result), 1);
end;

procedure CreateTempFileWithRandomData(const FileName: String; const Lines: Integer = 1);
var
  newFile: TextFile;
  i: Integer;
begin
  System.AssignFile(newFile, FileName);
  System.Rewrite(newFile);
  for i := 1 to Lines do
    WriteLn(newFile, NumberToWords(Random(MaxInt)));
  System.CloseFile(newFile);
end;

procedure CreateTempFileWithFixedData(const FileName: String; const Data: String; const Lines: Integer = 1);
var
  newFile: TextFile;
  i: Integer;
begin
  System.AssignFile(newFile, FileName);
  System.Rewrite(newFile);
  for i := 1 to Lines do
    WriteLn(newFile, Data);
  System.CloseFile(newFile);
end;

end.
