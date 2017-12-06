{$REGION 'documentation'}
{
  Copyright (c) 2016, Vencejo Software
  Distributed under the terms of the Modified BSD License
  The full license is distributed with this software
}
{
  File system entry definition
  @created(10/02/2016)
  @author Vencejo Software <www.vencejosoft.com>
}
{$ENDREGION}
unit ooFS.Entry;

interface

uses
  Generics.Collections;

type
{$REGION 'documentation'}
{
  Enum for kind of file system entries
  @value Unknown Unknown kind
  @value Drive Drive kind
  @value Directory Folder kind
  @value Archive File kind
}
{$ENDREGION}
  TFSEntryKind = (Unknown, Drive, Directory, Archive);
{$REGION 'documentation'}
{
  @abstract(Interface of file system entry)
  @member(Path Entry path)
  @member(Kind Kind file system)
}
{$ENDREGION}

  IFSEntry = interface
    ['{CDD73A1E-77F6-4A48-AE71-D460584CB8D9}']
    function Path: String;
    function Kind: TFSEntryKind;
  end;
{$REGION 'documentation'}
{
  @abstract(Implementation of @link(IFSEntry))
  File system object
  @member(Path @seealso(IFSEntry.Path))
  @member(Kind @seealso(IFSEntry.Kind))
  @member(
    Create Object constructor
    @param(Path Entry path)
    @param(Kind Kind file system)
  )
  @member(
    New Create a new @classname as interface
    @param(Path Entry path)
    @param(Kind Kind file system)
  )
}
{$ENDREGION}

  TFSEntry = class sealed(TInterfacedObject, IFSEntry)
  strict private
    _Path: String;
    _Kind: TFSEntryKind;
  public
    function Path: String;
    function Kind: TFSEntryKind;
    constructor Create(const Path: String; const Kind: TFSEntryKind);
    class function New(const Path: String; const Kind: TFSEntryKind): IFSEntry;
  end;
{$REGION 'documentation'}
{
  @abstract(Collection of @link(IFSEntry file system entries))
  @member(
    IsEmpty Check if the list is empty
    @param(@true if not has items, @false if has items)
  )
}
{$ENDREGION}

  TFSEntryList = class sealed(TList<IFSEntry>)
  public
    function IsEmpty: Boolean;
  end;

implementation

function TFSEntry.Path: String;
begin
  Result := _Path;
end;

function TFSEntry.Kind: TFSEntryKind;
begin
  Result := _Kind;
end;

constructor TFSEntry.Create(const Path: String; const Kind: TFSEntryKind);
begin
  _Path := Path;
  _Kind := Kind;
end;

class function TFSEntry.New(const Path: String; const Kind: TFSEntryKind): IFSEntry;
begin
  Result := TFSEntry.Create(Path, Kind);
end;

{ TFSEntryList }

function TFSEntryList.IsEmpty: Boolean;
begin
  Result := Count < 1;
end;

end.
