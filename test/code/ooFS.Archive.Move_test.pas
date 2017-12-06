{
  Copyright (c) 2016, Vencejo Software
  Distributed under the terms of the Modified BSD License
  The full license is distributed with this software
}
unit ooFS.Archive.Move_test;

interface

uses
  SysUtils,
  ooFS.Archive, ooFS.Archive.Move,
  ooFSUtils,
{$IFDEF FPC}
  fpcunit, testregistry
{$ELSE}
  TestFramework
{$ENDIF};

type
  TFSArchiveMoveTest = class(TTestCase)
  published
    procedure MoveTempFileToPath;
    procedure MoveTempFileToFileName;
    procedure MoveNonExistsFile;
  end;

implementation

procedure TFSArchiveMoveTest.MoveNonExistsFile;
var
  TempFile, Destination: String;
begin
  TempFile := IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0))) + 'temp_file_to_Move_non_exists.txt';
  Destination := TempFile + '.copied';
  CheckFalse(TFSArchiveMove.New(TFSArchive.New(nil, TempFile), Destination).Execute);
end;

procedure TFSArchiveMoveTest.MoveTempFileToFileName;
var
  TempFile, Destination: String;
begin
  TempFile := IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0))) + 'temp_file_to_Move.txt';
  CreateTempArchive(TempFile);
  Destination := TempFile + '.copied';
  CheckTrue(TFSArchiveMove.New(TFSArchive.New(nil, TempFile), Destination).Execute);
  CheckTrue(FileExists(Destination));
  DeleteArchive(Destination);
end;

procedure TFSArchiveMoveTest.MoveTempFileToPath;
var
  TempFile, Destination: String;
begin
  TempFile := IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0))) + 'temp_file_to_Move.txt';
  CreateTempArchive(TempFile);
  Destination := IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0))) + 'to_Move\';
  CreatePath(Destination);
  try
    CheckTrue(TFSArchiveMove.New(TFSArchive.New(nil, TempFile), Destination).Execute);
    CheckTrue(FileExists(Destination + ExtractFileName(TempFile)));
  finally
    DeleteArchive(Destination + ExtractFileName(TempFile));
    DeletePath(Destination);
  end;
end;

initialization

RegisterTest(TFSArchiveMoveTest {$IFNDEF FPC}.Suite {$ENDIF});

end.
