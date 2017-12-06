{
  Copyright (c) 2016, Vencejo Software
  Distributed under the terms of the Modified BSD License
  The full license is distributed with this software
}
unit ooFS.Archive.Copy_test;

interface

uses
  SysUtils,
  ooFS.Archive, ooFS.Archive.Copy,
  ooFSUtils,
{$IFDEF FPC}
  fpcunit, testregistry
{$ELSE}
  TestFramework
{$ENDIF};

type
  TFSArchiveCopyTest = class(TTestCase)
  published
    procedure CopyTempFileToPath;
    procedure CopyTempFileToFileName;
    procedure CopyNonExistsFile;
  end;

implementation

procedure TFSArchiveCopyTest.CopyNonExistsFile;
var
  TempFile, Destination: String;
begin
  TempFile := IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0))) + 'temp_file_to_Copy_non_exists.txt';
  Destination := TempFile + '.copied';
  CheckFalse(TFSArchiveCopy.New(TFSArchive.New(nil, TempFile), Destination).Execute);
end;

procedure TFSArchiveCopyTest.CopyTempFileToFileName;
var
  TempFile, Destination: String;
begin
  TempFile := IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0))) + 'temp_file_to_Copy.txt';
  CreateTempArchive(TempFile);
  try
    Destination := TempFile + '.copied';
    CheckTrue(TFSArchiveCopy.New(TFSArchive.New(nil, TempFile), Destination).Execute);
    CheckTrue(FileExists(Destination));
    DeleteArchive(Destination);
  finally
    DeleteArchive(TempFile);
  end;
end;

procedure TFSArchiveCopyTest.CopyTempFileToPath;
var
  TempFile, Destination: String;
begin
  TempFile := IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0))) + 'temp_file_to_Copy.txt';
  CreateTempArchive(TempFile);
  try
    Destination := IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0))) + 'to_copy\';
    CreatePath(Destination);
    try
      CheckTrue(TFSArchiveCopy.New(TFSArchive.New(nil, TempFile), Destination).Execute);
      CheckTrue(FileExists(Destination + ExtractFileName(TempFile)));
    finally
      DeleteArchive(Destination + ExtractFileName(TempFile));
      DeletePath(Destination);
    end;
  finally
    DeleteArchive(TempFile);
  end;
end;

initialization

RegisterTest(TFSArchiveCopyTest {$IFNDEF FPC}.Suite {$ENDIF});

end.
