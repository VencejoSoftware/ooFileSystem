{$REGION 'documentation'}
{
  Copyright (c) 2016, Vencejo Software
  Distributed under the terms of the Modified BSD License
  The full license is distributed with this software
}
{
  Command to checks if directory is empty
  @created(10/02/2016)
  @author Vencejo Software <www.vencejosoft.com>
}
{$ENDREGION}
unit ooFS.Directory.IsEmpty;

interface

uses
  Windows, SysUtils,
  ooFS.Directory, ooFS.Archive, ooFS.Archive.Scan,
  ooFS.Command.Intf;

type
{$REGION 'documentation'}
{
  @abstract(Implementation of command to checks if directory is empty)
  Checks if directory has some archives or another directories
}
{$ENDREGION}
  IFSDirectoryIsEmpty = interface(IFSCommand<Boolean>)
    ['{EE614F18-5741-4F9E-96D7-D8695AEF8FC4}']
  end;
{$REGION 'documentation'}
{
  @abstract(Implementation of @link(IFSDirectoryIsEmpty))
  @member(
    Execute Run check isempty command
    @return(@true if is empty, @false if not)
  )
  @member(
    Create Object constructor
    @param(Directory @link(IFSDirectory Path))
  )
  @member(
    New Create a new @classname as interface
    @param(Directory @link(IFSDirectory Path))
  )
}
{$ENDREGION}

  TFSDirectoryIsEmpty = class sealed(TInterfacedObject, IFSDirectoryIsEmpty)
  strict private
    _Directory: IFSDirectory;
  public
    function Execute: Boolean;
    constructor Create(const Directory: IFSDirectory);
    class function New(const Directory: IFSDirectory): IFSDirectoryIsEmpty;
  end;

implementation

function TFSDirectoryIsEmpty.Execute: Boolean;
var
  ArchiveList: TFSArchiveList;
begin
  ArchiveList := TFSArchiveList.Create;
  try
    TFSArchiveScan.New(_Directory, ArchiveList).Execute;
    Result := ArchiveList.IsEmpty;
  finally
    ArchiveList.Free;
  end;
end;

constructor TFSDirectoryIsEmpty.Create(const Directory: IFSDirectory);
begin
  _Directory := Directory;
end;

class function TFSDirectoryIsEmpty.New(const Directory: IFSDirectory): IFSDirectoryIsEmpty;
begin
  Result := TFSDirectoryIsEmpty.Create(Directory);
end;

end.
