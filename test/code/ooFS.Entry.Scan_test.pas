{
  Copyright (c) 2016, Vencejo Software
  Distributed under the terms of the Modified BSD License
  The full license is distributed with this software
}
unit ooFS.Entry.Scan_test;

interface

uses
  ooFS.Entry, ooFS.Directory, ooFS.Entry.Scan,
  ooFSUtils,
{$IFDEF FPC}
  fpcunit, testregistry
{$ELSE}
  TestFramework
{$ENDIF};

type
  TFSEntryScanTest = class sealed(TTestCase)
  protected
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure file_listDirectoryCountIs4;
    procedure file_listDirectoryRecursiveCountIs9;
    procedure file_listArchiveCountIs4;
    procedure file_listArchiveRecursiveCountIs9;
    procedure file_listArchiveRecursiveCountWithMaskNoneIs4;
    procedure IsNotEmpty;
  end;

implementation

procedure TFSEntryScanTest.file_listDirectoryCountIs4;
var
  EntryList: TFSEntryList;
  Entry: IFSEntry;
  Count: Integer;
begin
  EntryList := TFSEntryList.Create;
  try
    TFSEntryScan.New(TFSDirectory.New('..\file_list'), EntryList, False).Execute;
    Count := 0;
    for Entry in EntryList do
      if Entry.Kind = TFSEntryKind.Directory then
        inc(Count);
    CheckEquals(4, Count);
  finally
    EntryList.Free;
  end;
end;

procedure TFSEntryScanTest.file_listDirectoryRecursiveCountIs9;
var
  EntryList: TFSEntryList;
  Entry: IFSEntry;
  Count: Integer;
begin
  EntryList := TFSEntryList.Create;
  try
    TFSEntryScan.New(TFSDirectory.New('..\file_list'), EntryList, True).Execute;
    Count := 0;
    for Entry in EntryList do
      if Entry.Kind = TFSEntryKind.Directory then
        inc(Count);
    CheckEquals(9, Count);
  finally
    EntryList.Free;
  end;
end;

procedure TFSEntryScanTest.IsNotEmpty;
var
  EntryList: TFSEntryList;
begin
  EntryList := TFSEntryList.Create;
  try
    TFSEntryScan.New(TFSDirectory.New('..\file_list'), EntryList, False).Execute;
    CheckFalse(EntryList.IsEmpty);
  finally
    EntryList.Free;
  end;
end;

procedure TFSEntryScanTest.file_listArchiveCountIs4;
var
  EntryList: TFSEntryList;
  Entry: IFSEntry;
  Count: Integer;
begin
  EntryList := TFSEntryList.Create;
  try
    TFSEntryScan.New(TFSDirectory.New('..\file_list'), EntryList, False).Execute;
    Count := 0;
    for Entry in EntryList do
      if Entry.Kind = TFSEntryKind.Archive then
        inc(Count);
    CheckEquals(4, Count);
  finally
    EntryList.Free;
  end;
end;

procedure TFSEntryScanTest.file_listArchiveRecursiveCountIs9;
var
  EntryList: TFSEntryList;
  Entry: IFSEntry;
  Count: Integer;
begin
  EntryList := TFSEntryList.Create;
  try
    TFSEntryScan.New(TFSDirectory.New('..\file_list'), EntryList, True).Execute;
    Count := 0;
    for Entry in EntryList do
      if Entry.Kind = TFSEntryKind.Archive then
        inc(Count);
    CheckEquals(14, Count);
  finally
    EntryList.Free;
  end;
end;

procedure TFSEntryScanTest.file_listArchiveRecursiveCountWithMaskNoneIs4;
var
  EntryList: TFSEntryList;
  Entry: IFSEntry;
  Count: Integer;
begin
  EntryList := TFSEntryList.Create;
  try
    TFSEntryScan.New(TFSDirectory.New('..\file_list\Directory2\'), EntryList, True, '*.none').Execute;
    Count := 0;
    for Entry in EntryList do
      if Entry.Kind = TFSEntryKind.Archive then
        inc(Count);
    CheckEquals(4, Count);
  finally
    EntryList.Free;
  end;
end;

procedure TFSEntryScanTest.SetUp;
begin
  inherited;
  CreatePath('..\file_list');
  CreatePath('..\file_list\Directory1');
  CreatePath('..\file_list\Directory2');
  CreatePath('..\file_list\Directory2\a');
  CreatePath('..\file_list\Directory2\b');
  CreatePath('..\file_list\Directory3');
  CreatePath('..\file_list\Directory3\a');
  CreatePath('..\file_list\Directory3\b');
  CreatePath('..\file_list\Directory3\c');
  CreatePath('..\file_list\Directory4');
  CreateTempArchive('..\file_list\1.txt');
  CreateTempArchive('..\file_list\2.txt');
  CreateTempArchive('..\file_list\3.txt');
  CreateTempArchive('..\file_list\Directory3\b\1.txt');
  CreateTempArchive('..\file_list\Directory3\b\2.txt');
  CreateTempArchive('..\file_list\Directory3\b\3.txt');
  CreateTempArchive('..\file_list\Directory3\b\4.txt');
  CreateTempArchive('..\file_list\Directory3\b\5.txt');
  CreateTempArchive('..\file_list\Directory3\b\6.txt');
  CreateTempArchive('..\file_list\4-read only.txt');
  CreateTempArchive('..\file_list\Directory2\file22.none');
  CreateTempArchive('..\file_list\Directory2\file22.none');
  CreateTempArchive('..\file_list\Directory2\file23.none');
  CreateTempArchive('..\file_list\Directory2\file24.none');
  CreateTempArchive('..\file_list\Directory2\file25.none');
end;

procedure TFSEntryScanTest.TearDown;
begin
  inherited;
  DeletePath('..\file_list');
end;

initialization

RegisterTest(TFSEntryScanTest {$IFNDEF FPC}.Suite {$ENDIF});

end.
