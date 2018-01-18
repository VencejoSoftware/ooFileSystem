{
  Copyright (c) 2016, Vencejo Software
  Distributed under the terms of the Modified BSD License
  The full license is distributed with this software
}
unit ooFS.Directory.Scan_test;

interface

uses
  SysUtils,
  ooFS.Entry, ooFS.Directory, ooFS.Directory.Scan,
  ooFSUtils,
{$IFDEF FPC}
  fpcunit, testregistry
{$ELSE}
  TestFramework
{$ENDIF};

type
  TFSDirectoryScanTest = class sealed(TTestCase)
  protected
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure Directory_testCount3;
    procedure Directory_testCount3Recursive;
    procedure IsNotEmpty;
  end;

implementation

procedure TFSDirectoryScanTest.Directory_testCount3;
var
  DirectoryList: TFSDirectoryList;
begin
  DirectoryList := TFSDirectoryList.Create;
  try
    CheckEquals(3, TFSDirectoryScan.New(TFSDirectory.New('..\Directory_test'), DirectoryList, False).Execute);
  finally
    DirectoryList.Free;
  end;
end;

procedure TFSDirectoryScanTest.Directory_testCount3Recursive;
var
  DirectoryList: TFSDirectoryList;
begin
  DirectoryList := TFSDirectoryList.Create;
  try
    CheckEquals(5, TFSDirectoryScan.New(TFSDirectory.New('..\Directory_test'), DirectoryList, True).Execute);
  finally
    DirectoryList.Free;
  end;
end;

procedure TFSDirectoryScanTest.IsNotEmpty;
var
  DirectoryList: TFSDirectoryList;
begin
  DirectoryList := TFSDirectoryList.Create;
  try
    TFSDirectoryScan.New(TFSDirectory.New('..\Directory_test'), DirectoryList, True).Execute;
    CheckFalse(DirectoryList.IsEmpty);
  finally
    DirectoryList.Free;
  end;
end;

procedure TFSDirectoryScanTest.SetUp;
begin
  inherited;
  CreatePath('..\Directory_test');
  CreatePath('..\Directory_test\Directory1');
  CreatePath('..\Directory_test\Directory2');
  CreatePath('..\Directory_test\Directory3');
  CreatePath('..\Directory_test\Directory1\a');
  CreatePath('..\Directory_test\Directory1\b');
end;

procedure TFSDirectoryScanTest.TearDown;
begin
  inherited;
  DeletePath('..\Directory_test');
end;

initialization

RegisterTest(TFSDirectoryScanTest {$IFNDEF FPC}.Suite {$ENDIF});

end.
