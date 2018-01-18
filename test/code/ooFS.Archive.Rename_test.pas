{
  Copyright (c) 2016, Vencejo Software
  Distributed under the terms of the Modified BSD License
  The full license is distributed with this software
}
unit ooFS.Archive.Rename_test;

interface

uses
  SysUtils,
  ooFS.Archive, ooFS.Archive.Rename,
  ooFS.Directory,
  ooFSUtils,
{$IFDEF FPC}
  fpcunit, testregistry
{$ELSE}
  TestFramework
{$ENDIF};

type
  TFSArchiveRenameTest = class sealed(TTestCase)
  strict private
    _Path: IFSDirectory;
  protected
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure RenameTempFileToFileName;
    procedure RenameNonExistsFile;
  end;

implementation

procedure TFSArchiveRenameTest.RenameNonExistsFile;
var
  Archive: IFSArchive;
begin
  Archive := TFSArchive.New(TFSDirectory.New('Temp'), 'temp_file_to_Rename_non_exists.txt');
  CheckFalse(TFSArchiveRename.New(Archive, 'NewName').Execute);
end;

procedure TFSArchiveRenameTest.RenameTempFileToFileName;
var
  Archive: IFSArchive;
begin
  Archive := TFSArchive.New(_Path, 'temp_file_to_Rename_non_exists.txt');
  CreateTempArchive(Archive.Path);
  CheckTrue(TFSArchiveRename.New(Archive, 'newname.txt').Execute);
  CheckTrue(FileExists(Archive.Parent.Path + 'newname.txt'));
end;

procedure TFSArchiveRenameTest.SetUp;
begin
  inherited;
  _Path := TFSDirectory.New(TempFolder);
end;

procedure TFSArchiveRenameTest.TearDown;
begin
  inherited;
  RemoveTempFolder;
end;

initialization

RegisterTest(TFSArchiveRenameTest {$IFNDEF FPC}.Suite {$ENDIF});

end.
