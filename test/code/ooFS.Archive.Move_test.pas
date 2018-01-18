{
  Copyright (c) 2016, Vencejo Software
  Distributed under the terms of the Modified BSD License
  The full license is distributed with this software
}
unit ooFS.Archive.Move_test;

interface

uses
  SysUtils,
  ooFS.Archive, ooFS.Archive.Move,
  ooFS.Directory,
  ooFSUtils,
{$IFDEF FPC}
  fpcunit, testregistry
{$ELSE}
  TestFramework
{$ENDIF};

type
  TFSArchiveMoveTest = class sealed(TTestCase)
  strict private
    _Path: IFSDirectory;
  protected
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure MoveTempFileToPath;
    procedure MoveNonExistsFile;
  end;

implementation

procedure TFSArchiveMoveTest.MoveNonExistsFile;
var
  Archive: IFSArchive;
  Target: IFSDirectory;
begin
  Archive := TFSArchive.New(TFSDirectory.New('Temp'), 'temp_file_to_Move_non_exists.txt');
  Target := TFSDirectory.NewWithParent(_Path, 'target');
  CheckFalse(TFSArchiveMove.New(Archive, Target).Execute);
end;

procedure TFSArchiveMoveTest.MoveTempFileToPath;
var
  Archive: IFSArchive;
  Target: IFSDirectory;
begin
  Archive := TFSArchive.New(_Path, 'temp_file_to_Move.txt');
  CreateTempArchive(Archive.Path);
  Target := TFSDirectory.NewWithParent(_Path, 'target');
  CreatePath(Target.Path);
  CheckTrue(TFSArchiveMove.New(Archive, Target).Execute);
  CheckTrue(FileExists(Target.Path + ExtractFileName(Archive.Name)));
end;

procedure TFSArchiveMoveTest.SetUp;
begin
  inherited;
  _Path := TFSDirectory.New(TempFolder);
end;

procedure TFSArchiveMoveTest.TearDown;
begin
  inherited;
  RemoveTempFolder;
end;

initialization

RegisterTest(TFSArchiveMoveTest {$IFNDEF FPC}.Suite {$ENDIF});

end.
