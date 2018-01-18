{
  Copyright (c) 2016, Vencejo Software
  Distributed under the terms of the Modified BSD License
  The full license is distributed with this software
}
unit ooFS.Archive.CountLines_test;

interface

uses
  SysUtils,
  ooFS.Archive, ooFS.Archive.CountLines,
  ooFSUtils,
{$IFDEF FPC}
  fpcunit, testregistry
{$ELSE}
  TestFramework
{$ENDIF};

type
  TFSArchiveCountLinesTest = class sealed(TTestCase)
  protected
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure CountLinesIs6635;
    procedure CountLinesInFileUnExistsIs0;
  end;

implementation

procedure TFSArchiveCountLinesTest.SetUp;
begin
  inherited;
  CreatePath('..\file_text_count');
  CreateTempArchive('..\file_text_count\test.txt', 6635);
end;

procedure TFSArchiveCountLinesTest.TearDown;
begin
  inherited;
  DeletePath('..\file_text_count');
end;

procedure TFSArchiveCountLinesTest.CountLinesInFileUnExistsIs0;
begin
  CheckEquals(0, TFSArchiveCountLines.New(TFSArchive.New(nil, '..\file_text_count\none.txt')).Execute);
end;

procedure TFSArchiveCountLinesTest.CountLinesIs6635;
begin
  CheckEquals(6635, TFSArchiveCountLines.New(TFSArchive.New(nil, '..\file_text_count\test.txt')).Execute);
end;

initialization

RegisterTest(TFSArchiveCountLinesTest {$IFNDEF FPC}.Suite {$ENDIF});

end.
