{
  Copyright (c) 2016, Vencejo Software
  Distributed under the terms of the Modified BSD License
  The full license is distributed with this software
}
unit ooFS.Directory_test;

interface

uses
  SysUtils,
  ooFS.Entry, ooFS.Drive, ooFS.Directory,
  ooFSUtils,
{$IFDEF FPC}
  fpcunit, testregistry
{$ELSE}
  TestFramework
{$ENDIF};

type
  TFSDirectoryTest = class sealed(TTestCase)
  protected
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure EmptyDirectoryRaiseError;
    procedure DirectoryPathIsDirectoryTest;
    procedure EntryKindIsDirectory;
    procedure ExistsDirectory_test;
    procedure CreatedToday;
    procedure ModifiedNow;
    procedure NilParentIsEmpty;
    procedure ParentAssignedHasSomeValue;
    procedure DriveParentAssignedHasC;
    procedure ParentWith2LevelsAssignedHasSomeValue;
  end;

implementation

procedure TFSDirectoryTest.DirectoryPathIsDirectoryTest;
begin
  CheckEquals('..\Directory_test\', TFSDirectory.New('..\Directory_test').Path);
end;

procedure TFSDirectoryTest.EmptyDirectoryRaiseError;
var
  ErrorFound: Boolean;
begin
  ErrorFound := False;
  try
    CheckEquals(EmptyStr, TFSDirectory.New(EmptyStr).Path);
  except
    ErrorFound := True;
  end;
  CheckTrue(ErrorFound);
end;

procedure TFSDirectoryTest.EntryKindIsDirectory;
begin
  CheckTrue(TFSDirectory.New('..\Directory_test').Kind = TFSEntryKind.Directory);
end;

procedure TFSDirectoryTest.ExistsDirectory_test;
begin
  CheckTrue(TFSDirectory.New('..\Directory_test').Exists);
end;

procedure TFSDirectoryTest.CreatedToday;
var
  Directory: IFSDirectory;
begin
  Directory := TFSDirectory.New('..\Directory_test');
  CheckEquals(Date, Trunc(Directory.Creation));
end;

procedure TFSDirectoryTest.ModifiedNow;
var
  Directory: IFSDirectory;
begin
  Directory := TFSDirectory.New('..\Directory_test');
  CheckEquals(FormatDateTime('ddmmyyyyhhmmss', Now), FormatDateTime('ddmmyyyyhhmmss', Directory.Modified));
end;

procedure TFSDirectoryTest.NilParentIsEmpty;
begin
  CheckEquals(EmptyStr, TFSDirectory.New('..\Directory_test').Parent.Path);
end;

procedure TFSDirectoryTest.ParentAssignedHasSomeValue;
var
  Parent: IFSDirectory;
begin
  Parent := TFSDirectory.New('C:\Test\');
  CheckEquals('C:\Test\..\Directory_test\', TFSDirectory.NewWithParent(Parent, '..\Directory_test').Path);
end;

procedure TFSDirectoryTest.DriveParentAssignedHasC;
var
  Parent: IFSDrive;
begin
  Parent := TFSDrive.New('C', Unknown);
  CheckEquals('C:\..\Directory_test\', TFSDirectory.NewWithParent(Parent, '..\Directory_test').Path);
end;

procedure TFSDirectoryTest.ParentWith2LevelsAssignedHasSomeValue;
var
  Parent1, Parent2: IFSDirectory;
begin
  Parent1 := TFSDirectory.New('C:\Test\');
  Parent2 := TFSDirectory.NewWithParent(Parent1, 'level2\something');
  CheckEquals('C:\Test\level2\something\..\Directory_test\', TFSDirectory.NewWithParent(Parent2,
      '..\Directory_test').Path);
end;

procedure TFSDirectoryTest.SetUp;
begin
  inherited;
  CreatePath('..\Directory_test');
  CreatePath('..\Directory_test\Directory1');
end;

procedure TFSDirectoryTest.TearDown;
begin
  inherited;
  DeletePath('..\Directory_test');
end;

initialization

RegisterTest(TFSDirectoryTest {$IFNDEF FPC}.Suite {$ENDIF});

end.
