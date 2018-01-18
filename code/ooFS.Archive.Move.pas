{$REGION 'documentation'}
{
  Copyright (c) 2016, Vencejo Software
  Distributed under the terms of the Modified BSD License
  The full license is distributed with this software
}
{
  Command to file move
  @created(10/02/2016)
  @author Vencejo Software <www.vencejosoft.com>
}
{$ENDREGION}
unit ooFS.Archive.Move;

interface

uses
  Windows, SysUtils,
  ooFS.Command.Delay,
  ooFS.Archive,
  ooFS.Directory,
  ooFS.Command.Intf;

type
{$REGION 'documentation'}
{
  @abstract(Implementation of command to file move)
  Move a file from a location to another
}
{$ENDREGION}
  IFSArchiveMove = interface(IFSCommand<Boolean>)
    ['{30400016-7A3A-45D5-9167-A1452D68C7AD}']
  end;
{$REGION 'documentation'}
{
  @abstract(Implementation of @link(IFSArchiveMove))
  @member(
    TryMove Try to move file until success or max tries are reached
    @param(Tries Actual try number to increment if not success)
    @return(@true if success, @false if fail)
  )
  @member(
    Execute Run move command
    @return(@true if success, @false if fail)
  )
  @member(
    Create Object constructor
    @param(Archive @link(IFSArchive Source archive))
    @param(Destination Destinarion file name)
    @param(MaxTries Max tries for move fail)
  )
  @member(
    New Create a new @classname as interface
    @param(Archive @link(IFSArchive Source archive))
    @param(Destination Destinarion file name)
    @param(MaxTries Max tries for move fail)
  )
}
{$ENDREGION}

  TFSArchiveMove = class sealed(TInterfacedObject, IFSArchiveMove)
  strict private
  const
    DELAY_IN_TRY = 200;
  strict private
    _Archive: IFSArchive;
    _TargetArchive: IFSArchive;
    _MaxTries: Byte;
  private
    function TryMove(const Tries: Byte): Boolean;
  public
    function Execute: Boolean;
    constructor Create(const Archive: IFSArchive; const Target: IFSDirectory; const MaxTries: Byte = 10);
    class function New(const Archive: IFSArchive; const Target: IFSDirectory;
      const MaxTries: Byte = 10): IFSArchiveMove;
  end;

implementation

function TFSArchiveMove.TryMove(const Tries: Byte): Boolean;
begin
  Result := MoveFile(PChar(_Archive.Path), PChar(_TargetArchive.Path));
  if not Result and (Tries < _MaxTries) then
  begin
    TFSCommandDelay.New(DELAY_IN_TRY).Execute;
    Result := TryMove(Tries + 1);
  end;
end;

function TFSArchiveMove.Execute: Boolean;
begin
  Result := TryMove(0);
end;

constructor TFSArchiveMove.Create(const Archive: IFSArchive; const Target: IFSDirectory; const MaxTries: Byte);
begin
  _Archive := Archive;
  _MaxTries := MaxTries;
  _TargetArchive := TFSArchive.New(Target, Archive.Name);
end;

class function TFSArchiveMove.New(const Archive: IFSArchive; const Target: IFSDirectory;
  const MaxTries: Byte): IFSArchiveMove;
begin
  Result := TFSArchiveMove.Create(Archive, Target, MaxTries);
end;

end.

