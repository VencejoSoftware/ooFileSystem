{
  Copyright (c) 2016, Vencejo Software
  Distributed under the terms of the Modified BSD License
  The full license is distributed with this software
}
unit ooFS.Directory.IsEmpty_test;

interface

uses
  SysUtils,
  ooFS.Directory, ooFS.Directory.IsEmpty,
  ooFSUtils,
{$IFDEF FPC}
  fpcunit, testregistry
{$ELSE}
  TestFramework
{$ENDIF};

type
  TFSDirectoryIsEmptyTest = class sealed(TTestCase)
  protected
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure TempFSDirectoryIsEmpty;
    procedure TempDirectoryWithFileIsNotIsEmpty;
  end;

implementation

procedure TFSDirectoryIsEmptyTest.TempFSDirectoryIsEmpty;
begin
  CheckTrue(TFSDirectoryIsEmpty.New(TFSDirectory.New('..\file_list')).Execute);
end;

procedure TFSDirectoryIsEmptyTest.TempDirectoryWithFileIsNotIsEmpty;
begin
  CreateTempArchive('..\file_list\test.txt');
  try
    CheckFalse(TFSDirectoryIsEmpty.New(TFSDirectory.New('..\file_list')).Execute);
  finally
    DeleteArchive('..\file_list\test.txt');
  end;
end;

procedure TFSDirectoryIsEmptyTest.SetUp;
begin
  inherited;
  CreatePath('..\file_list');
end;

procedure TFSDirectoryIsEmptyTest.TearDown;
begin
  inherited;
  DeletePath('..\file_list');
end;

initialization

RegisterTest(TFSDirectoryIsEmptyTest {$IFNDEF FPC}.Suite {$ENDIF});

end.
