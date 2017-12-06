{$REGION 'documentation'}
{
  Copyright (c) 2016, Vencejo Software
  Distributed under the terms of the Modified BSD License
  The full license is distributed with this software
}
{
  Drive object
  @created(10/02/2016)
  @author Vencejo Software <www.vencejosoft.com>
}
{$ENDREGION}
unit ooFS.Drive;

interface

uses
  SysUtils,
  Generics.Collections,
  ooFS.Entry;

type
{$REGION 'documentation'}
{
  Enum for drive attributes
  @value Unknown Unknown drive
  @value NoRootDir No root in drive
  @value Fixed Fixed drive
  @value Remote Remote drive
  @value CDRom CD rom drive
  @value RamDisk Ram disk drive
}
{$ENDREGION}
  TFSDriveAtribute = (Unknown, NoRootDir, Removable, Fixed, Remote, CDRom, RamDisk);
{$REGION 'documentation'}
// A set of attributes
{$ENDREGION}
  TFSDriveAtributeSet = set of TFSDriveAtribute;
{$REGION 'documentation'}
{
  @abstract(Interface of drive definition)
  @member(
    Attribute Drive attribute
    @return(@link(TFSDriveAtribute attribute))
  )
}
{$ENDREGION}

  IFSDrive = interface(IFSEntry)
    ['{7C577776-8DEA-4CB1-A20F-CF04A99174B1}']
    function Attribute: TFSDriveAtribute;
  end;
{$REGION 'documentation'}
{
  @abstract(Implementation of @link(IFSDrive))
  Drive object
  @member(Path @seealso(IFSEntry.Path))
  @member(Kind @seealso(IFSEntry.Kind))
  @member(Attribute @seealso(IFSDrive.Attribute))
  @member(
    IncludeDriveDelimiter Check if exist drive delimiter and add it if need
    @param(Drive Drive text)
    @return(String with a drive delimited)
  )
  @member(
    SanitizeDrive Sanitize drive text
    @param(Drive Drive text)
    @return(String with a correct drive text value)
  )
  @member(
    Create Object constructor
    @param(Drive Drive text)
    @param(Attribute Attribute)
  )
  @member(
    New Create a new @classname as interface
    @param(Drive Drive text)
    @param(Attribute Attribute)
  )
}
{$ENDREGION}

  TFSDrive = class sealed(TInterfacedObject, IFSDrive)
  strict private
    _FSEntry: IFSEntry;
    _Attribute: TFSDriveAtribute;
  private
    function IncludeDriveDelimiter(const Drive: String): String;
    function SanitizeDrive(const Drive: String): String;
  public
    function Path: String;
    function Kind: TFSEntryKind;
    function Attribute: TFSDriveAtribute;
    constructor Create(const Drive: String; const Attribute: TFSDriveAtribute);
    class function New(const Drive: String; const Attribute: TFSDriveAtribute): IFSDrive;
  end;
{$REGION 'documentation'}
{
  @abstract(Collection of @link(IFSDrive drives))
  @member(
    IsEmpty Check if the list is empty
    @param(@true if not has items, @false if has items)
  )
}
{$ENDREGION}

  TFSDrives = class sealed(TList<IFSDrive>)
  public
    function IsEmpty: Boolean;
  end;

implementation

function TFSDrive.Path: String;
begin
  Result := _FSEntry.Path;
end;

function TFSDrive.Kind: TFSEntryKind;
begin
  Result := _FSEntry.Kind;
end;

function TFSDrive.Attribute: TFSDriveAtribute;
begin
  Result := _Attribute;
end;

function TFSDrive.IncludeDriveDelimiter(const Drive: String): String;
var
  DelimPos: Integer;
begin
  DelimPos := Pos(DriveDelim, Drive);
  if DelimPos > 0 then
    Result := Drive
  else
    Result := Drive + DriveDelim;
end;

function TFSDrive.SanitizeDrive(const Drive: String): String;
begin
  Result := IncludeTrailingPathDelimiter(IncludeDriveDelimiter(Trim(Drive)));
end;

constructor TFSDrive.Create(const Drive: String; const Attribute: TFSDriveAtribute);
begin
  _FSEntry := TFSEntry.New(SanitizeDrive(Drive), TFSEntryKind.Drive);
  _Attribute := Attribute;
end;

class function TFSDrive.New(const Drive: String; const Attribute: TFSDriveAtribute): IFSDrive;
begin
  Result := TFSDrive.Create(Drive, Attribute);
end;

{ TFSDrives }

function TFSDrives.IsEmpty: Boolean;
begin
  Result := Count < 1;
end;

end.
