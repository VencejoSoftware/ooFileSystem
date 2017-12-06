{$REGION 'documentation'}
{
  Copyright (c) 2016, Vencejo Software
  Distributed under the terms of the Modified BSD License
  The full license is distributed with this software
}
{
  Command to create a directory
  @created(10/02/2016)
  @author Vencejo Software <www.vencejosoft.com>
}
{$ENDREGION}
unit ooFS.Directory.Make;

interface

uses
  Windows, SysUtils,
{$IFNDEF fpc}
  IOUtils,
{$ENDIF}
  ooFS.Command.Delay,
  ooFS.Directory,
  ooFS.Command.Intf;

type
{$REGION 'documentation'}
{
  @abstract(Implementation of command to create a directory)
  Create a directory in the filesystem
}
{$ENDREGION}
  IFSDirectoryMake = interface(IFSCommand<Boolean>)
    ['{E8F685BD-4F83-41C1-8C36-836724876205}']
  end;
{$REGION 'documentation'}
{
  @abstract(Implementation of @link(IFSDirectoryMake))
  @member(
    TryMake Try to make directory until success or max tries are reached
    @param(Tries Actual try number to increment if not success)
    @return(@true if success, @false if fail)
  )
  @member(
    Execute Run make directory command
    @return(@true if can create the directory, @false if not)
  )
  @member(
    Create Object constructor
    @param(Directory @link(IFSDirectory Path))
    @param(MaxTries Max tries for make fail)
  )
  @member(
    New Create a new @classname as interface
    @param(Directory @link(IFSDirectory Path))
    @param(MaxTries Max tries for make fail)
  )
}
{$ENDREGION}

  TFSDirectoryMake = class sealed(TInterfacedObject, IFSDirectoryMake)
  strict private
  const
    DELAY_IN_TRY = 200;
  strict private
    _Directory: IFSDirectory;
    _MaxTries: Byte;
  private
    function TryMake(const Tries: Byte): Boolean;
  public
    function Execute: Boolean;
    constructor Create(const Directory: IFSDirectory; const MaxTries: Byte = 10);
    class function New(const Directory: IFSDirectory; const MaxTries: Byte = 10): IFSDirectoryMake;
  end;

implementation

function TFSDirectoryMake.TryMake(const Tries: Byte): Boolean;
begin
{$IFDEF fpc}
  CreateDir(_Directory.Path);
{$ELSE}
  TDirectory.CreateDirectory(_Directory.Path);
{$ENDIF}
  Result := DirectoryExists(_Directory.Path);
  if not Result and (Tries < _MaxTries) then
  begin
    TFSCommandDelay.New(DELAY_IN_TRY).Execute;
    Result := TryMake(Tries + 1);
  end;
end;

function TFSDirectoryMake.Execute: Boolean;
begin
  if not DirectoryExists(_Directory.Path) then
    Result := TryMake(0)
  else
    Result := False;
end;

constructor TFSDirectoryMake.Create(const Directory: IFSDirectory; const MaxTries: Byte = 10);
begin
  _Directory := Directory;
  _MaxTries := MaxTries;
end;

class function TFSDirectoryMake.New(const Directory: IFSDirectory; const MaxTries: Byte = 10): IFSDirectoryMake;
begin
  Result := TFSDirectoryMake.Create(Directory, MaxTries);
end;

end.
