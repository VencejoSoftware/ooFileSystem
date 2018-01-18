{
  Copyright (c) 2016, Vencejo Software
  Distributed under the terms of the Modified BSD License
  The full license is distributed with this software
}
unit ooFS.Directory.Delete_test;

interface

uses
  Classes, SysUtils,
  ooFS.Directory, ooFS.Directory.Delete,
  ooFSUtils,
{$IFDEF FPC}
  fpcunit, testregistry
{$ELSE}
  TestFramework
{$ENDIF};

type
  TFSDirectoryDeleteTest = class sealed(TTestCase)
  published
    procedure DeleteNotExists;
    procedure DeleteExists;
  end;

implementation

procedure TFSDirectoryDeleteTest.DeleteExists;
begin
  CreatePath('..\Directory_test');
  CheckTrue(TFSDirectoryDelete.New(TFSDirectory.New('..\Directory_test')).Execute);
  CheckFalse(TFSDirectory.New('..\Directory_test').Exists);
end;

procedure TFSDirectoryDeleteTest.DeleteNotExists;
begin
  DeletePath('..\Directory_test');
  CheckFalse(TFSDirectoryDelete.New(TFSDirectory.New('..\Directory_test')).Execute);
end;

initialization

RegisterTest(TFSDirectoryDeleteTest {$IFNDEF FPC}.Suite {$ENDIF});

end.
