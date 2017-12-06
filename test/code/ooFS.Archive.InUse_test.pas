{
  Copyright (c) 2016, Vencejo Software
  Distributed under the terms of the Modified BSD License
  The full license is distributed with this software
}
unit ooFS.Archive.InUse_test;

interface

uses
  Classes, SysUtils,
  ooFS.Archive, ooFS.Archive.InUse,
  ooFSUtils,
{$IFDEF FPC}
  fpcunit, testregistry
{$ELSE}
  TestFramework
{$ENDIF};

type
  TFSArchiveInUseTest = class(TTestCase)
  private
    _Archive: IFSArchive;
  protected
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure IsNotInUse;
    procedure IsInUse;
  end;

implementation

procedure TFSArchiveInUseTest.IsInUse;
var
  NewTextFile: TextFile;
begin
  AssignFile(NewTextFile, _Archive.Path);
  try
    Reset(NewTextFile);
    CheckTrue(TFSArchiveInUse.New(_Archive).Execute);
  finally
    CloseFile(NewTextFile);
  end;
end;

procedure TFSArchiveInUseTest.IsNotInUse;
begin
  CheckFalse(TFSArchiveInUse.New(_Archive).Execute);
end;

procedure TFSArchiveInUseTest.SetUp;
begin
  inherited;
  _Archive := TFSArchive.New(nil, IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0))) + 'temp_file_to_Copy.txt');
  CreateTempArchive(_Archive.Path);
end;

procedure TFSArchiveInUseTest.TearDown;
begin
  inherited;
  DeleteArchive(_Archive.Path);
end;

initialization

RegisterTest(TFSArchiveInUseTest {$IFNDEF FPC}.Suite {$ENDIF});

end.
