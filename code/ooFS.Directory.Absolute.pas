{$REGION 'documentation'}
{
  Copyright (c) 2016, Vencejo Software
  Distributed under the terms of the Modified BSD License
  The full license is distributed with this software
}
{
  Directory object for absolute paths
  @created(10/02/2016)
  @author Vencejo Software <www.vencejosoft.com>
}
{$ENDREGION}
unit ooFS.Directory.Absolute;

interface

uses
  SysUtils,
  ooFS.Entry, ooFS.Drive, ooFS.Directory;

type
  IFSDirectoryAbsolute = interface(IFSEntry)
    ['{8BB7C784-67BE-4A71-9AE1-854C48C067E7}']
  end;
{$REGION 'documentation'}
{
  @abstract(Implementation of @link(IFSDirectory) with absolute path)
  Directory object working with full (absolute) paths
  @member(Path Return an absolute path from @link(IFSDirectory directory))
  @member(Kind @seealso(IFSDirectory.Kind))
  @member(
    Create Object constructor
    @param(Parent @link(IFSEntry Parent object))
    @param(Path Directory path)
  )
  @member(
    NewWithParent Create a new @classname as interface
    @param(Parent @link(IFSEntry Parent object))
    @param(Path Directory path)
  )
}
{$ENDREGION}

  TFSDirectoryAbsolute = class sealed(TInterfacedObject, IFSDirectoryAbsolute)
  strict private
    _Directory: IFSDirectory;
  public
    function Path: String;
    function Kind: TFSEntryKind;
    constructor Create(const Directory: IFSDirectory);
    class function New(const Directory: IFSDirectory): IFSDirectoryAbsolute;
  end;

implementation

function TFSDirectoryAbsolute.Path: String;
begin
  Result := IncludeTrailingPathDelimiter(ExpandFileName(_Directory.Path));
end;

function TFSDirectoryAbsolute.Kind: TFSEntryKind;
begin
  Result := _Directory.Kind;
end;

constructor TFSDirectoryAbsolute.Create(const Directory: IFSDirectory);
begin
  _Directory := Directory;
end;

class function TFSDirectoryAbsolute.New(const Directory: IFSDirectory): IFSDirectoryAbsolute;
begin
  Result := TFSDirectoryAbsolute.Create(Directory);
end;

end.
