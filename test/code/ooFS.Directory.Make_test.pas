{
  Copyright (c) 2016, Vencejo Software
  Distributed under the terms of the Modified BSD License
  The full license is distributed with this software
}
unit ooFS.Directory.Make_test;

interface

uses
  Classes, SysUtils,
  ooFS.Directory, ooFS.Directory.Make,
  ooFSUtils,
{$IFDEF FPC}
  fpcunit, testregistry
{$ELSE}
  TestFramework
{$ENDIF};

type
  TFSDirectoryMakeTest = class(TTestCase)
  published
    procedure MakeNotExists;
    procedure MakeExists;
  end;

implementation

procedure TFSDirectoryMakeTest.MakeExists;
begin
  CreatePath('..\Directory_test');
  CheckFalse(TFSDirectoryMake.New(TFSDirectory.New('..\Directory_test')).Execute);
  CheckTrue(TFSDirectory.New('..\Directory_test').Exists);
end;

procedure TFSDirectoryMakeTest.MakeNotExists;
begin
  CheckTrue(TFSDirectoryMake.New(TFSDirectory.New('..\Directory_test')).Execute);
  CheckTrue(TFSDirectory.New('..\Directory_test').Exists);
  DeletePath('..\Directory_test');
end;

initialization

RegisterTest(TFSDirectoryMakeTest {$IFNDEF FPC}.Suite {$ENDIF});

end.
