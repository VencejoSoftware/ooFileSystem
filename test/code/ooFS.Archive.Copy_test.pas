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
  ooFS.Directory,
  ooFSUtils,
{$IFDEF FPC}
  fpcunit, testregistry
{$ELSE}
  TestFramework
{$ENDIF};

type
  TFSArchiveCopyTest = class sealed(TTestCase)
  strict private
    _Path: IFSDirectory;
  protected
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure CopyTempFileToPath;
    procedure CopyNonExistsFile;
  end;

implementation

procedure TFSArchiveCopyTest.CopyNonExistsFile;
var
  Archive: IFSArchive;
  Target: IFSDirectory;
begin
  Archive := TFSArchive.New(TFSDirectory.New('Temp'), 'temp_file_to_Copy_non_exists.txt');
  Target := TFSDirectory.NewWithParent(_Path, 'target');
  CheckFalse(TFSArchiveCopy.New(Archive, Target).Execute);
end;

procedure TFSArchiveCopyTest.CopyTempFileToPath;
var
  Archive: IFSArchive;
  Target: IFSDirectory;
begin
  Archive := TFSArchive.New(_Path, 'temp_file_to_Copy.txt');
  CreateTempArchive(Archive.Path);
  Target := TFSDirectory.NewWithParent(_Path, 'target');
  CreatePath(Target.Path);
  CheckTrue(TFSArchiveCopy.New(Archive, Target).Execute);
  CheckTrue(FileExists(Target.Path + Archive.Name));
  CheckTrue(FileExists(Archive.Path));
end;

procedure TFSArchiveCopyTest.SetUp;
begin
  inherited;
  _Path := TFSDirectory.New(TempFolder);
end;

procedure TFSArchiveCopyTest.TearDown;
begin
  inherited;
  RemoveTempFolder;
end;

initialization

RegisterTest(TFSArchiveCopyTest {$IFNDEF FPC}.Suite {$ENDIF});

end.
