{
  Copyright (c) 2016, Vencejo Software
  Distributed under the terms of the Modified BSD License
  The full license is distributed with this software
}
unit ooFS.Directory.Count_test;

interface

uses
  SysUtils,
  ooFS.Directory, ooFS.Directory.Count,
  ooFSUtils,
{$IFDEF FPC}
  fpcunit, testregistry
{$ELSE}
  TestFramework
{$ENDIF};

type
  TFSDirectoryCountTest = class sealed(TTestCase)
  protected
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure File_ListHas4Directory;
    procedure File_ListDirectory2Has2Directory;
    procedure File_ListDirectory3HasNone;
    procedure File_ListDirectory4HasNone;
    procedure Directory2RecursiveHas3;
  end;

implementation

procedure TFSDirectoryCountTest.File_ListDirectory2Has2Directory;
begin
  CheckEquals(2, TFSDirectoryCount.New(TFSDirectory.New('..\file_list\Directory2'), False).Execute);
end;

procedure TFSDirectoryCountTest.File_ListDirectory3HasNone;
begin
  CheckEquals(0, TFSDirectoryCount.New(TFSDirectory.New('..\file_list\Directory3'), False).Execute);
end;

procedure TFSDirectoryCountTest.File_ListDirectory4HasNone;
begin
  CheckEquals(0, TFSDirectoryCount.New(TFSDirectory.New('..\file_list\Directory4'), False).Execute);
end;

procedure TFSDirectoryCountTest.File_ListHas4Directory;
begin
  CheckEquals(4, TFSDirectoryCount.New(TFSDirectory.New('..\file_list'), False).Execute);
end;

procedure TFSDirectoryCountTest.Directory2RecursiveHas3;
begin
  CheckEquals(3, TFSDirectoryCount.New(TFSDirectory.New('..\file_list\Directory2'), True).Execute);
end;

procedure TFSDirectoryCountTest.SetUp;
begin
  inherited;
  CreatePath('..\file_list');
  CreatePath('..\file_list\Directory1');
  CreatePath('..\file_list\Directory2');
  CreatePath('..\file_list\Directory2\a');
  CreatePath('..\file_list\Directory2\b');
  CreatePath('..\file_list\Directory2\b\1');
  CreatePath('..\file_list\Directory3');
  CreatePath('..\file_list\Directory4');
end;

procedure TFSDirectoryCountTest.TearDown;
begin
  inherited;
  DeletePath('..\file_list');
end;

initialization

RegisterTest(TFSDirectoryCountTest {$IFNDEF FPC}.Suite {$ENDIF});

end.
