{
  Copyright (c) 2016, Vencejo Software
  Distributed under the terms of the Modified BSD License
  The full license is distributed with this software
}
unit ooFS.Directory.Absolute_test;

interface

uses
  SysUtils,
  ooFS.Entry, ooFS.Directory, ooFS.Directory.Absolute,
  ooFSUtils,
{$IFDEF FPC}
  fpcunit, testregistry
{$ELSE}
  TestFramework
{$ENDIF};

type
  TFSDirectoryAbsoluteTest = class sealed(TTestCase)
  protected
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure AbsolutePathFromDirectory;
    procedure AbsolutePathKindIsDirectory;
  end;

implementation

procedure TFSDirectoryAbsoluteTest.AbsolutePathFromDirectory;
var
  CurPath: String;
  Directory: IFSDirectoryAbsolute;
begin
  CurPath := ExtractFilePath(ExcludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0)))) + 'Directory_test\';
  Directory := TFSDirectoryAbsolute.New(TFSDirectory.New('..\Directory_test'));
  CheckEquals(CurPath, Directory.Path);
end;

procedure TFSDirectoryAbsoluteTest.AbsolutePathKindIsDirectory;
begin
  CheckTrue(TFSDirectoryAbsolute.New(TFSDirectory.New('..\Directory_test')).Kind = TFSEntryKind.Directory);
end;

procedure TFSDirectoryAbsoluteTest.SetUp;
begin
  inherited;
  CreatePath('..\Directory_test');
  CreatePath('..\Directory_test\Directory1');
end;

procedure TFSDirectoryAbsoluteTest.TearDown;
begin
  inherited;
  DeletePath('..\Directory_test');
end;

initialization

RegisterTest(TFSDirectoryAbsoluteTest {$IFNDEF FPC}.Suite {$ENDIF});

end.
