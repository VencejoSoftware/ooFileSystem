{$REGION 'documentation'}
{
  Copyright (c) 2016, Vencejo Software
  Distributed under the terms of the Modified BSD License
  The full license is distributed with this software
}
{
  Command to rename copy
  @created(10/02/2016)
  @author Vencejo Software <www.vencejosoft.com>
}
{$ENDREGION}
unit ooFS.Archive.Rename;

interface

uses
  Windows, SysUtils,
  ooFS.Command.Delay,
  ooFS.Archive,
  ooFS.Command.Intf;

type
{$REGION 'documentation'}
{
  @abstract(Implementation of command to rename copy)
  Change the file name
}
{$ENDREGION}
  IFSArchiveRename = interface(IFSCommand<Boolean>)
    ['{A51280AF-3CAA-4985-AC49-01D2D7086F96}']
  end;
{$REGION 'documentation'}
{
  @abstract(Implementation of @link(IFSArchiveRename))
  @member(
    TryRename Try to rename file until success or max tries are reached
    @param(Tries Actual try number to increment if not success)
    @return(@true if success, @false if fail)
  )
  @member(
    Execute Run rename command
    @return(@true if success, @false if fail)
  )
  @member(
    Create Object constructor
    @param(Archive @link(IFSArchive Source archive))
    @param(Name New file name)
    @param(MaxTries Max tries for renam fail)
  )
  @member(
    New Create a new @classname as interface
    @param(Archive @link(IFSArchive Source archive))
    @param(Name New file name)
    @param(MaxTries Max tries for rename fail)
  )
}
{$ENDREGION}

  TFSArchiveRename = class sealed(TInterfacedObject, IFSArchiveRename)
  strict private
  const
    DELAY_IN_TRY = 200;
  strict private
    _Archive: IFSArchive;
    _NewName: String;
    _MaxTries: Byte;
  private
    function TryRename(const Tries: Byte): Boolean;
  public
    function Execute: Boolean;
    constructor Create(const Archive: IFSArchive; const Name: String; const MaxTries: Byte = 10);
    class function New(const Archive: IFSArchive; const Name: String; const MaxTries: Byte = 10): IFSArchiveRename;
  end;

implementation

function TFSArchiveRename.TryRename(const Tries: Byte): Boolean;
begin
  Result := RenameFile(PChar(_Archive.Path), PChar(_NewName));
  if not Result and (Tries < _MaxTries) then
  begin
    TFSCommandDelay.New(DELAY_IN_TRY).Execute;
    Result := TryRename(Tries + 1);
  end;
end;

function TFSArchiveRename.Execute: Boolean;
begin
  Result := TryRename(0);
end;

constructor TFSArchiveRename.Create(const Archive: IFSArchive; const Name: String; const MaxTries: Byte);
begin
  _Archive := Archive;
  _MaxTries := MaxTries;
  _NewName := Archive.Parent.Path + Name;
end;

class function TFSArchiveRename.New(const Archive: IFSArchive; const Name: String;
  const MaxTries: Byte): IFSArchiveRename;
begin
  Result := TFSArchiveRename.Create(Archive, Name, MaxTries);
end;

end.
