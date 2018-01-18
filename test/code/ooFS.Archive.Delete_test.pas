{
  Copyright (c) 2016, Vencejo Software
  Distributed under the terms of the Modified BSD License
  The full license is distributed with this software
}
unit ooFS.Archive.Delete_test;

interface

uses
  SysUtils,
  ooFS.Archive, ooFS.Archive.Delete,
  ooFSUtils,
{$IFDEF FPC}
  fpcunit, testregistry
{$ELSE}
  TestFramework
{$ENDIF};

type
  TFSArchiveDeleteTest = class sealed(TTestCase)
  published
    procedure DeleteTempFile;
    procedure DeleteNonExistsFile;
  end;

implementation

procedure TFSArchiveDeleteTest.DeleteNonExistsFile;
var
  TempFile: String;
begin
  TempFile := IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0))) + 'temp_file_to_delete_non_exists.txt';
  CheckFalse(TFSArchiveDelete.New(TFSArchive.New(nil, TempFile)).Execute);
end;

procedure TFSArchiveDeleteTest.DeleteTempFile;
var
  TempFile: String;
begin
  TempFile := IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0))) + 'temp_file_to_delete.txt';
  CreateTempArchive(TempFile);
  CheckTrue(TFSArchiveDelete.New(TFSArchive.New(nil, TempFile)).Execute);
end;

initialization

RegisterTest(TFSArchiveDeleteTest {$IFNDEF FPC}.Suite {$ENDIF});

end.
