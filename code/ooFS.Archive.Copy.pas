{$REGION 'documentation'}
{
  Copyright (c) 2016, Vencejo Software
  Distributed under the terms of the Modified BSD License
  The full license is distributed with this software
}
{
  Command to file copy
  @created(10/02/2016)
  @author Vencejo Software <www.vencejosoft.com>
}
{$ENDREGION}
unit ooFS.Archive.Copy;

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
  @abstract(Implementation of command to file copy)
  Copy a file into location
}
{$ENDREGION}
  IFSArchiveCopy = interface(IFSCommand<Boolean>)
    ['{2896C3DA-A266-4D40-82C8-C8E84C395278}']
  end;
{$REGION 'documentation'}
{
  @abstract(Implementation of @link(IFSArchiveCopy))
  @member(
    TryCopy Try to copy file until success or max tries are reached
    @param(Tries Actual try number to increment if not success)
    @return(@true if success, @false if fail)
  )
  @member(
    Execute Run copy command
    @return(@true if success, @false if fail)
  )
  @member(
    Create Object constructor
    @param(Archive @link(IFSArchive Source archive))
    @param(Target Destinarion file name)
    @param(MaxTries Max tries for copy fail)
  )
  @member(
    New Create a new @classname as interface
    @param(Archive @link(IFSArchive Source archive))
    @param(Target Destinarion file name)
    @param(MaxTries Max tries for copy fail)
  )
}
{$ENDREGION}

  TFSArchiveCopy = class sealed(TInterfacedObject, IFSArchiveCopy)
  strict private
  const
    DELAY_IN_TRY = 200;
  strict private
    _Archive, _TargetArchive: IFSArchive;
    _MaxTries: Byte;
  private
    function TryCopy(const Tries: Byte): Boolean;
  public
    function Execute: Boolean;
    constructor Create(const Archive: IFSArchive; const Target: IFSDirectory; const MaxTries: Byte = 10);
    class function New(const Archive: IFSArchive; const Target: IFSDirectory;
      const MaxTries: Byte = 10): IFSArchiveCopy;
  end;

implementation

function TFSArchiveCopy.TryCopy(const Tries: Byte): Boolean;
begin
  Result := CopyFile(PChar(_Archive.Path), PChar(_TargetArchive.Path), False);
  if not Result and (Tries < _MaxTries) then
  begin
    TFSCommandDelay.New(DELAY_IN_TRY).Execute;
    Result := TryCopy(Tries + 1);
  end;
end;

function TFSArchiveCopy.Execute: Boolean;
begin
  Result := TryCopy(0);
end;

constructor TFSArchiveCopy.Create(const Archive: IFSArchive; const Target: IFSDirectory; const MaxTries: Byte);
begin
  _Archive := Archive;
  _MaxTries := MaxTries;
  _TargetArchive := TFSArchive.New(Target, _Archive.Name);
end;

class function TFSArchiveCopy.New(const Archive: IFSArchive; const Target: IFSDirectory;
  const MaxTries: Byte): IFSArchiveCopy;
begin
  Result := TFSArchiveCopy.Create(Archive, Target, MaxTries);
end;

end.
