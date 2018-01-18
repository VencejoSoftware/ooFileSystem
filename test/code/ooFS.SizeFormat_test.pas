{
  Copyright (c) 2016, Vencejo Software
  Distributed under the terms of the Modified BSD License
  The full license is distributed with this software
}
unit ooFS.SizeFormat_test;

interface

uses
  SysUtils,
  ooFS.SizeFormat,
{$IFDEF FPC}
  fpcunit, testregistry
{$ELSE}
  TestFramework
{$ENDIF};

type
  TFSSizeFormatTest = class sealed(TTestCase)
  published
    procedure Stilized1024Bytes;
    procedure Stilized1kb;
    procedure Stilized1mb;
    procedure Stilized1gb;
  end;

implementation

procedure TFSSizeFormatTest.Stilized1024Bytes;
begin
  CheckEquals('1024 bytes', TFSSizeFormat.New(1024).Stylized);
end;

procedure TFSSizeFormatTest.Stilized1kb;
begin
  CheckEquals('1 kb', TFSSizeFormat.New(1025).Stylized);
end;

procedure TFSSizeFormatTest.Stilized1gb;
begin
  CheckEquals('1 gb', TFSSizeFormat.New(1024 * 1024 * 1024 + 1).Stylized);
end;

procedure TFSSizeFormatTest.Stilized1mb;
begin
  CheckEquals('1 mb', TFSSizeFormat.New(1024 * 1024 + 1).Stylized);
end;

initialization

RegisterTest(TFSSizeFormatTest {$IFNDEF FPC}.Suite {$ENDIF});

end.
