{$REGION 'documentation'}
{
  Copyright (c) 2016, Vencejo Software
  Distributed under the terms of the Modified BSD License
  The full license is distributed with this software
}
{
  Command to delete directory
  @created(10/02/2016)
  @author Vencejo Software <www.vencejosoft.com>
}
{$ENDREGION}
unit ooFS.Directory.Delete;

interface

uses
  Windows, SysUtils,
{$IFDEF fpc}
  FileUtil,
{$ELSE}
  IOUtils,
{$ENDIF}
  ooFS.Command.Delay,
  ooFS.Directory,
  ooFS.Command.Intf;

type
{$REGION 'documentation'}
{
  @abstract(Implementation of command to delete directory)
  Delete a directory
}
{$ENDREGION}
  IFSDirectoryDelete = interface(IFSCommand<Boolean>)
    ['{000FFB2B-02A9-44F5-917C-7D4DDCA99B4B}']
  end;
{$REGION 'documentation'}
{
  @abstract(Implementation of @link(IFSDirectoryDelete))
  @member(
    TryDelete Try to delete directory until success or max tries are reached
    @param(Tries Actual try number to increment if not success)
    @return(@true if success, @false if fail)
  )
  @member(
    Execute Run delete directory command
    @return(@true if success, @false if fail)
  )
  @member(
    Create Object constructor
    @param(Directory @link(IFSDirectory Path))
    @param(MaxTries Max tries for delete fail)
  )
  @member(
    New Create a new @classname as interface
    @param(Directory @link(IFSDirectory Path))
    @param(MaxTries Max tries for delete fail)
  )
}
{$ENDREGION}

  TFSDirectoryDelete = class sealed(TInterfacedObject, IFSDirectoryDelete)
  strict private
  const
    DELAY_IN_TRY = 200;
  strict private
    _Directory: IFSDirectory;
    _MaxTries: Byte;
  private
    function TryDelete(const Tries: Byte): Boolean;
  public
    function Execute: Boolean;
    constructor Create(const Directory: IFSDirectory; const MaxTries: Byte = 10);
    class function New(const Directory: IFSDirectory; const MaxTries: Byte = 10): IFSDirectoryDelete;
  end;

implementation

function TFSDirectoryDelete.TryDelete(const Tries: Byte): Boolean;
begin
{$IFDEF fpc}
  DeleteDirectory(_Directory.Path, True);
{$ELSE}
  TDirectory.Delete(_Directory.Path, True);
{$ENDIF}
  Result := not DirectoryExists(_Directory.Path);
  if not Result and (Tries < _MaxTries) then
  begin
    TFSCommandDelay.New(DELAY_IN_TRY).Execute;
    Result := TryDelete(Tries + 1);
  end;
end;

function TFSDirectoryDelete.Execute: Boolean;
begin
  if DirectoryExists(_Directory.Path) then
    Result := TryDelete(0)
  else
    Result := False;
end;

constructor TFSDirectoryDelete.Create(const Directory: IFSDirectory; const MaxTries: Byte = 10);
begin
  _Directory := Directory;
  _MaxTries := MaxTries;
end;

class function TFSDirectoryDelete.New(const Directory: IFSDirectory; const MaxTries: Byte = 10): IFSDirectoryDelete;
begin
  Result := TFSDirectoryDelete.Create(Directory, MaxTries);
end;

end.
