{$REGION 'documentation'}
{
  Copyright (c) 2016, Vencejo Software
  Distributed under the terms of the Modified BSD License
  The full license is distributed with this software
}
{
  Command to delete copy
  @created(10/02/2016)
  @author Vencejo Software <www.vencejosoft.com>
}
{$ENDREGION}
unit ooFS.Archive.Delete;

interface

uses
  Windows, SysUtils,
  ooFS.Command.Delay,
  ooFS.Archive,
  ooFS.Command.Intf;

type
{$REGION 'documentation'}
{
  @abstract(Implementation of command to file delete)
  Delete a file from location
}
{$ENDREGION}
  IFSArchiveDelete = interface(IFSCommand<Boolean>)
    ['{7E7BA5A7-226E-4089-A199-BD6EBB83A178}']
  end;
{$REGION 'documentation'}
{
  @abstract(Implementation of @link(IFSArchiveDelete))
  @member(
    TryDelete Try to delete file until success or max tries are reached
    @param(Tries Actual try number to increment if not success)
    @return(@true if success, @false if fail)
  )
  @member(
    Execute Run delete command
    @return(@true if success, @false if fail)
  )
  @member(
    Create Object constructor
    @param(Archive @link(IFSArchive Source archive))
    @param(MaxTries Max tries for delete fail)
  )
  @member(
    New Create a new @classname as interface
    @param(Archive @link(IFSArchive Source archive))
    @param(MaxTries Max tries for delete fail)
  )
}
{$ENDREGION}

  TFSArchiveDelete = class sealed(TInterfacedObject, IFSArchiveDelete)
  strict private
  const
    DELAY_IN_TRY = 200;
  strict private
    _Archive: IFSArchive;
    _MaxTries: Byte;
  private
    function TryDelete(const Tries: Byte): Boolean;
  public
    function Execute: Boolean;
    constructor Create(const Archive: IFSArchive; const MaxTries: Byte = 10);
    class function New(const Archive: IFSArchive; const MaxTries: Byte = 10): IFSArchiveDelete;
  end;

implementation

function TFSArchiveDelete.TryDelete(const Tries: Byte): Boolean;
begin
  Result := DeleteFile(_Archive.Path);
  if not Result and (Tries < _MaxTries) then
  begin
    TFSCommandDelay.New(DELAY_IN_TRY).Execute;
    Result := TryDelete(Tries + 1);
  end;
end;

function TFSArchiveDelete.Execute: Boolean;
begin
  if FileExists(_Archive.Path) then
    Result := TryDelete(0)
  else
    Result := False;
end;

constructor TFSArchiveDelete.Create(const Archive: IFSArchive; const MaxTries: Byte);
begin
  _Archive := Archive;
  _MaxTries := MaxTries;
end;

class function TFSArchiveDelete.New(const Archive: IFSArchive; const MaxTries: Byte): IFSArchiveDelete;
begin
  Result := TFSArchiveDelete.Create(Archive, MaxTries);
end;

end.
