{
  Copyright (c) 2016, Vencejo Software
  Distributed under the terms of the Modified BSD License
  The full license is distributed with this software
}
unit ooFS.Archive.Scan_test;

interface

uses
  SysUtils,
  ooFS.Directory, ooFS.Archive, ooFS.Archive.Scan,
  ooFSUtils,
{$IFDEF FPC}
  fpcunit, testregistry
{$ELSE}
  TestFramework
{$ENDIF};

type
  TFSArchiveScanTest = class(TTestCase)
  protected
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure File_ListIsEmpty;
    procedure Directory2Has4Files;
  end;

implementation

procedure TFSArchiveScanTest.Directory2Has4Files;
var
  Files: TFSArchiveList;
begin
  Files := TFSArchiveList.Create;
  try
    TFSArchiveScan.New(TFSDirectory.New('..\file_list\Directory2\'), Files).Execute;
    CheckEquals(4, Files.Count);
  finally
    Files.Free;
  end
end;

procedure TFSArchiveScanTest.File_ListIsEmpty;
var
  Files: TFSArchiveList;
begin
  Files := TFSArchiveList.Create;
  try
    TFSArchiveScan.New(TFSDirectory.New('..\file_list\Directory4'), Files).Execute;
    CheckTrue(Files.IsEmpty, 'file_list\Directory4 is not empty');
  finally
    Files.Free;
  end
end;

procedure TFSArchiveScanTest.SetUp;
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

procedure TFSArchiveScanTest.TearDown;
begin
  inherited;
  DeletePath('..\file_list');
end;

initialization

RegisterTest(TFSArchiveScanTest {$IFNDEF FPC}.Suite {$ENDIF});

end.
