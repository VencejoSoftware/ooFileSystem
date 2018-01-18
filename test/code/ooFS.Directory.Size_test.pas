{
  Copyright (c) 2016, Vencejo Software
  Distributed under the terms of the Modified BSD License
  The full license is distributed with this software
}
unit ooFS.Directory.Size_test;

interface

uses
  SysUtils,
  ooFS.Directory, ooFS.Directory.Size,
  ooFSUtils,
{$IFDEF FPC}
  fpcunit, testregistry
{$ELSE}
  TestFramework
{$ENDIF};

type
  TFSDirectorySizeTest = class sealed(TTestCase)
  strict private
    _Path: IFSDirectory;
  protected
    procedure SetUp; Override;
    procedure TearDown; Override;
  published
    procedure EmptyFolderReturnZero;
    procedure FolderWithFilesReturn27;
    procedure FolderWithFilesAndSubFolderReturn53;
  end;

implementation

procedure TFSDirectorySizeTest.EmptyFolderReturnZero;
begin
  CheckEquals(0, TFSDirectorySize.New(_Path).Execute);
end;

procedure TFSDirectorySizeTest.FolderWithFilesAndSubFolderReturn53;
begin
  CreateTempFileWithFixedData(_Path.Path + 'File1.txt', '12345678');
  CreateTempFileWithFixedData(_Path.Path + 'File2.txt', 'test');
  CreateTempFileWithFixedData(_Path.Path + 'File3.txt', 'alpha5678');
  CreatePath(_Path.Path + 'sub1\');
  CreateTempFileWithFixedData(_Path.Path + 'sub1\File1.txt', '12345678');
  CreateTempFileWithFixedData(_Path.Path + 'sub1\File2.txt', 'test');
  CreatePath(_Path.Path + 'sub1\sub2\');
  CreateTempFileWithFixedData(_Path.Path + 'sub1\sub2\File1.txt', '12345678');
  CheckEquals(53, TFSDirectorySize.New(_Path).Execute);
end;

procedure TFSDirectorySizeTest.FolderWithFilesReturn27;
begin
  CreateTempFileWithFixedData(_Path.Path + 'File1.txt', '12345678');
  CreateTempFileWithFixedData(_Path.Path + 'File2.txt', 'test');
  CreateTempFileWithFixedData(_Path.Path + 'File3.txt', 'alpha5678');
  CheckEquals(27, TFSDirectorySize.New(_Path).Execute);
end;

procedure TFSDirectorySizeTest.SetUp;
begin
  inherited;
  _Path := TFSDirectory.New(TempFolder);
end;

procedure TFSDirectorySizeTest.TearDown;
begin
  inherited;
  RemoveTempFolder;
end;

initialization

RegisterTest(TFSDirectorySizeTest {$IFNDEF FPC}.Suite {$ENDIF});

end.
