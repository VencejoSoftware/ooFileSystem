{
  Copyright (c) 2016, Vencejo Software
  Distributed under the terms of the Modified BSD License
  The full license is distributed with this software
}
unit ooFS.Drive.Scan_test;

interface

uses
  SysUtils,
  ooFS.Entry, ooFS.Drive, ooFS.Drives.Scan,
{$IFDEF FPC}
  fpcunit, testregistry
{$ELSE}
  TestFramework
{$ENDIF};

type
  TFSDrivesScanTest = class(TTestCase)
  private
    _Drives: TFSDrives;
  protected
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure ExistDrives;
    procedure CDriveIsPresent;
    procedure CIsFixed;
    procedure IsNotEmpty;
    procedure DrivesKindIsDrive;
  end;

implementation

procedure TFSDrivesScanTest.CDriveIsPresent;
var
  FSDrive: IFSDrive;
  Founded: Boolean;
begin
  Founded := False;
  TFSDrivesScan.New(_Drives, [Fixed]).Execute;
  for FSDrive in _Drives do
  begin
    Founded := CompareText(FSDrive.Path, 'C:\') = 0;
    if Founded then
      Break;
  end;
  CheckTrue(Founded);
end;

procedure TFSDrivesScanTest.CIsFixed;
var
  FSDrive: IFSDrive;
begin
  TFSDrivesScan.New(_Drives, [Fixed]).Execute;
  for FSDrive in _Drives do
  begin
    if CompareText(FSDrive.Path, 'C:\') = 0 then
    begin
      CheckTrue(FSDrive.Attribute = Fixed);
      Break;
    end;
  end;
end;

procedure TFSDrivesScanTest.DrivesKindIsDrive;
begin
  TFSDrivesScan.New(_Drives, [Fixed]).Execute;
  CheckTrue(_Drives.Items[0].Kind = TFSEntryKind.Drive);
end;

procedure TFSDrivesScanTest.ExistDrives;
begin
  CheckTrue(TFSDrivesScan.New(_Drives, [Fixed]).Execute > 0);
end;

procedure TFSDrivesScanTest.IsNotEmpty;
begin
  TFSDrivesScan.New(_Drives, [Fixed]).Execute;
  CheckFalse(_Drives.IsEmpty);
end;

procedure TFSDrivesScanTest.SetUp;
begin
  inherited;
  _Drives := TFSDrives.Create;
end;

procedure TFSDrivesScanTest.TearDown;
begin
  inherited;
  _Drives.Free;
end;

initialization

RegisterTest(TFSDrivesScanTest {$IFNDEF FPC}.Suite {$ENDIF});

end.
