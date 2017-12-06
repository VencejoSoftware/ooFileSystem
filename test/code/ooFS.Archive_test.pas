{
  Copyright (c) 2016, Vencejo Software
  Distributed under the terms of the Modified BSD License
  The full license is distributed with this software
}
unit ooFS.Archive_test;

interface

uses
  SysUtils, Windows,
  ooFS.Entry, ooFS.Archive,
  ooFSUtils,
{$IFDEF FPC}
  fpcunit, testregistry
{$ELSE}
  TestFramework
{$ENDIF};

type
  TFSArchiveTest = class(TTestCase)
  protected
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure EntryKindIsFile;
    procedure DirectoryPathIsFileTestTest;
    procedure FileExtensionIsTXT;
    procedure NameIstesttxt;
    procedure SizeIs800;
    procedure CreatingTimeIsToday;
    procedure LastAccessIsToday;
    procedure ModifiedIsNow;
    procedure TestTXTExists;
    procedure TestNoneTXTNonExists;
    procedure ParentIsFileTest;
    procedure TestTxtNotHaveAttributes;
    procedure TestTxtChangedToHidden;
    procedure TestTxtChangedToHiddenReadOnly;
  end;

implementation

procedure TFSArchiveTest.EntryKindIsFile;
begin
  CheckTrue(TFSArchive.New(nil, '..\file_test\test.txt').Kind = TFSEntryKind.Archive);
end;

procedure TFSArchiveTest.FileExtensionIsTXT;
begin
  CheckEquals('txt', TFSArchive.New(nil, '..\file_test\test.txt').Extension);
end;

procedure TFSArchiveTest.DirectoryPathIsFileTestTest;
begin
  CheckEquals('..\file_test\test.txt', TFSArchive.New(nil, '..\file_test\test.txt').Path);
end;

procedure TFSArchiveTest.LastAccessIsToday;
var
  Archive: IFSArchive;
begin
  Archive := TFSArchive.New(nil, '..\file_test\test.txt');
  CheckEquals(Date, Trunc(Archive.LastAccess));
end;

procedure TFSArchiveTest.ModifiedIsNow;
var
  Archive: IFSArchive;
begin
  Archive := TFSArchive.New(nil, '..\file_test\test.txt');
  CheckEquals(FormatDateTime('ddmmyyyyhhmmss', Now), FormatDateTime('ddmmyyyyhhmmss', Archive.Modified));
end;

procedure TFSArchiveTest.CreatingTimeIsToday;
var
  Archive: IFSArchive;
begin
  Archive := TFSArchive.New(nil, '..\file_test\test.txt');
  CheckEquals(Date, Trunc(Archive.Creation));
end;

procedure TFSArchiveTest.NameIstesttxt;
begin
  CheckEquals('test.txt', TFSArchive.New(nil, '..\file_test\test.txt').Name);
end;

procedure TFSArchiveTest.ParentIsFileTest;
begin
  CheckEquals('..\file_test\', TFSArchive.New(nil, '..\file_test\test.txt').Parent.Path);
end;

procedure TFSArchiveTest.SetUp;
begin
  inherited;
  CreatePath('..\file_test');
  CreateTempArchive('..\file_test\test.txt', 100);
end;

procedure TFSArchiveTest.SizeIs800;
begin
  CheckEquals(800, TFSArchive.New(nil, '..\file_test\test.txt').Size);
end;

procedure TFSArchiveTest.TearDown;
begin
  inherited;
  DeletePath('..\file_test');
end;

procedure TFSArchiveTest.TestNoneTXTNonExists;
begin
  CheckFalse(TFSArchive.New(nil, '..\file_test\test_none.txt').Exists);
end;

procedure TFSArchiveTest.TestTxtChangedToHidden;
begin
  if SetFileAttributes(PChar('..\file_test\test.txt'), FILE_ATTRIBUTE_HIDDEN) then
    CheckTrue(TFSArchive.New(nil, '..\file_test\test.txt').Attributes = [Hidden]);
end;

procedure TFSArchiveTest.TestTxtChangedToHiddenReadOnly;
begin
  if SetFileAttributes(PChar('..\file_test\test.txt'), FILE_ATTRIBUTE_READONLY or FILE_ATTRIBUTE_HIDDEN) then
    CheckTrue(TFSArchive.New(nil, '..\file_test\test.txt').Attributes = [ReadOnly, Hidden]);
end;

procedure TFSArchiveTest.TestTXTExists;
begin
  CheckTrue(TFSArchive.New(nil, '..\file_test\test.txt').Exists);
end;

procedure TFSArchiveTest.TestTxtNotHaveAttributes;
begin
  CheckTrue(TFSArchive.New(nil, '..\file_test\test.txt').Attributes = []);
end;

initialization

RegisterTest(TFSArchiveTest {$IFNDEF FPC}.Suite {$ENDIF});

end.
