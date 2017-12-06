{$REGION 'documentation'}
{
  Copyright (c) 2016, Vencejo Software
  Distributed under the terms of the Modified BSD License
  The full license is distributed with this software
}
{
  Command to check if a file is in use
  @created(10/02/2016)
  @author Vencejo Software <www.vencejosoft.com>
}
{$ENDREGION}
unit ooFS.Archive.InUse;

interface

uses
  Windows, SysUtils,
  ooFS.Archive,
  ooFS.Command.Intf;

type
{$REGION 'documentation'}
{
  @abstract(Implementation of command to check if a file is in use)
  Check if a file is opened exclusive or in use
}
{$ENDREGION}
  IFSArchiveInUse = interface(IFSCommand<Boolean>)
    ['{E4E10314-3233-4463-860D-9D07C003482C}']
  end;
{$REGION 'documentation'}
{
  @abstract(Implementation of @link(IFSArchiveInUse))
  @member(
    Execute Run check in use command
    @return(@true if the file is in use, @false if not)
  )
  @member(
    Create Object constructor
    @param(Archive @link(IFSArchive Source archive))
  )
  @member(
    New Create a new @classname as interface
    @param(Archive @link(IFSArchive Source archive))
  )
}
{$ENDREGION}

  TFSArchiveInUse = class sealed(TInterfacedObject, IFSArchiveInUse)
  strict private
    _Archive: IFSArchive;
  public
    function Execute: Boolean;
    constructor Create(const Archive: IFSArchive);
    class function New(const Archive: IFSArchive): IFSArchiveInUse;
  end;

implementation

function TFSArchiveInUse.Execute: Boolean;
var
  FileHandle: HFILE;
begin
  Result := False;
  if not _Archive.Exists then
    Exit;
  FileHandle := CreateFile(PChar(_Archive.Path), GENERIC_READ or GENERIC_WRITE, 0, nil, OPEN_EXISTING,
    FILE_ATTRIBUTE_NORMAL, 0);
  Result := (FileHandle = INVALID_HANDLE_VALUE);
  CloseHandle(FileHandle);
end;

constructor TFSArchiveInUse.Create(const Archive: IFSArchive);
begin
  _Archive := Archive;
end;

class function TFSArchiveInUse.New(const Archive: IFSArchive): IFSArchiveInUse;
begin
  Result := TFSArchiveInUse.Create(Archive);
end;

end.
