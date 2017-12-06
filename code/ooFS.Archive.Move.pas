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
    BuildDestinationFileName Create the destination file name
    @param(FileName Source file name)
    @param(Destination Destination file name)
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
    _DestinationFileName: String;
    _MaxTries: Byte;
  private
    function TryMove(const Tries: Byte): Boolean;
    function BuildDestinationFileName(const FileName, Destination: String): String;
  public
    function Execute: Boolean;
    constructor Create(const Archive: IFSArchive; const Destination: String; const MaxTries: Byte = 10);
    class function New(const Archive: IFSArchive; const Destination: String; const MaxTries: Byte = 10): IFSArchiveMove;
  end;

implementation

function TFSArchiveMove.TryMove(const Tries: Byte): Boolean;
begin
  Result := MoveFile(PChar(_Archive.Path), PChar(_DestinationFileName));
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

function TFSArchiveMove.BuildDestinationFileName(const FileName, Destination: String): String;
begin
  if Length(ExtractFileName(Destination)) < 1 then
    Result := IncludeTrailingPathDelimiter(Destination) + _Archive.Name
  else
    Result := Destination;
end;

constructor TFSArchiveMove.Create(const Archive: IFSArchive; const Destination: String; const MaxTries: Byte);
begin
  _Archive := Archive;
  _MaxTries := MaxTries;
  _DestinationFileName := BuildDestinationFileName(_Archive.Path, Destination);
end;

class function TFSArchiveMove.New(const Archive: IFSArchive; const Destination: String;
  const MaxTries: Byte): IFSArchiveMove;
begin
  Result := TFSArchiveMove.Create(Archive, Destination, MaxTries);
end;

end.
