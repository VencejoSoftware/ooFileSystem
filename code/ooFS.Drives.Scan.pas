{$REGION 'documentation'}
{
  Copyright (c) 2016, Vencejo Software
  Distributed under the terms of the Modified BSD License
  The full license is distributed with this software
}
{
  Command to scan a file system returning drive list
  @created(10/02/2016)
  @author Vencejo Software <www.vencejosoft.com>
}
{$ENDREGION}
unit ooFS.Drives.Scan;

interface

uses
  Windows, SysUtils,
  ooFS.Command.Intf,
  ooFS.Drive;

type
{$REGION 'documentation'}
{
  @abstract(Implementation of command to scan a file system returning drive list)
  Scan the file system to return a list of drives
}
{$ENDREGION}
  IFSDrivesScan = interface(IFSCommand<Integer>)
    ['{0C923969-0135-4855-A72C-47E7F35CE526}']
  end;
{$REGION 'documentation'}
{
  @abstract(Implementation of @link(IFSDirectoryScan))
  @member(
    Execute Run scan command
    @return(Integer with the count of drives founded)
  )
  @member(
    Create Object constructor
    @param(Drives @link(TFSDrives List to fill with the founded drives))
    @param(Filter Filter attributes)
  )
  @member(
    New Create a new @classname as interface
    @param(Drives @link(TFSDrives List to fill with the founded drives))
    @param(Filter Filter attributes)
  )
}
{$ENDREGION}

  TFSDrivesScan = class sealed(TInterfacedObject, IFSDrivesScan)
  strict private
    _Drives: TFSDrives;
    _Filter: TFSDriveAtributeSet;
  public
    function Execute: Integer;
    constructor Create(const Drives: TFSDrives; const Filter: TFSDriveAtributeSet = []);
    class function New(const Drives: TFSDrives; const Filter: TFSDriveAtributeSet = []): IFSDrivesScan;
  end;

implementation

function TFSDrivesScan.Execute: Integer;
var
  LogDrives: LongWord;
  Buffer: array [0 .. 128] of char;
  PDrive: PChar;
  Atribute: TFSDriveAtribute;
begin
  Result := 0;
  LogDrives := GetLogicalDriveStrings(SizeOf(Buffer), Buffer);
  if LogDrives = 0 then
    Exit;
  if LogDrives > SizeOf(Buffer) then
    raise Exception.Create(SysErrorMessage(ERROR_OUTOFMEMORY));
  PDrive := Buffer;
  while PDrive^ <> #0 do
  begin
    Atribute := TFSDriveAtribute(GetDriveType(PDrive));
    if Atribute in _Filter then
      _Drives.Add(TFSDrive.New(PDrive, Atribute));
    Inc(PDrive, 4);
  end;
  Result := _Drives.Count;
end;

constructor TFSDrivesScan.Create(const Drives: TFSDrives; const Filter: TFSDriveAtributeSet);
begin
  _Drives := Drives;
  _Filter := Filter;
end;

class function TFSDrivesScan.New(const Drives: TFSDrives; const Filter: TFSDriveAtributeSet): IFSDrivesScan;
begin
  Result := TFSDrivesScan.Create(Drives, Filter);
end;

end.
