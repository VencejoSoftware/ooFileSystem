{
  Copyright (c) 2016, Vencejo Software
  Distributed under the terms of the Modified BSD License
  The full license is distributed with this software
}
unit ooFS.Archive.Rename_test;

interface

uses
  SysUtils,
  ooFS.Archive, ooFS.Archive.Rename,
  ooFSUtils,
{$IFDEF FPC}
  fpcunit, testregistry
{$ELSE}
  TestFramework
{$ENDIF};

type
  TFSArchiveRenameTest = class(TTestCase)
  published
    procedure RenameTempFileToPath;
    procedure RenameTempFileToFileName;
    procedure RenameNonExistsFile;
  end;

implementation

procedure TFSArchiveRenameTest.RenameNonExistsFile;
var
  TempFile, Destination: String;
begin
  TempFile := IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0))) + 'temp_file_to_Rename_non_exists.txt';
  Destination := TempFile + '.copied';
  CheckFalse(TFSArchiveRename.New(TFSArchive.New(nil, TempFile), Destination).Execute);
end;

procedure TFSArchiveRenameTest.RenameTempFileToFileName;
var
  TempFile, Destination: String;
begin
  TempFile := IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0))) + 'temp_file_to_Rename.txt';
  CreateTempArchive(TempFile);
  Destination := TempFile + '.copied';
  CheckTrue(TFSArchiveRename.New(TFSArchive.New(nil, TempFile), Destination).Execute);
  CheckTrue(FileExists(Destination));
  DeleteArchive(Destination);
end;

procedure TFSArchiveRenameTest.RenameTempFileToPath;
var
  TempFile, Destination: String;
begin
  TempFile := IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0))) + 'temp_file_to_Rename.txt';
  CreateTempArchive(TempFile);
  Destination := IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0))) + 'to_Rename\';
  CreatePath(Destination);
  try
    CheckTrue(TFSArchiveRename.New(TFSArchive.New(nil, TempFile), Destination).Execute);
    CheckTrue(FileExists(Destination + ExtractFileName(TempFile)));
  finally
    DeleteArchive(Destination + ExtractFileName(TempFile));
    DeletePath(Destination);
  end;
end;

initialization

RegisterTest(TFSArchiveRenameTest {$IFNDEF FPC}.Suite {$ENDIF});

end.
