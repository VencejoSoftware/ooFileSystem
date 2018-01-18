{$REGION 'documentation'}
{
  Copyright (c) 2016, Vencejo Software
  Distributed under the terms of the Modified BSD License
  The full license is distributed with this software
}
{
  Command to calculate directory size
  @created(10/02/2016)
  @author Vencejo Software <www.vencejosoft.com>
}
{$ENDREGION}
unit ooFS.Directory.Size;

interface

uses
  Windows, SysUtils,
  ooFS.Directory,
  ooFS.Command.Intf;

type
{$REGION 'documentation'}
{
  @abstract(Implementation of command to calculate folder size)
  Scan folder and return the sum of all children sizes
}
{$ENDREGION}
  IFSDirectorySize = interface(IFSCommand<Cardinal>)
    ['{8E5F3C5B-7F7F-4A74-AB6F-DF44B2F54D87}']
  end;
{$REGION 'documentation'}
{
  @abstract(Implementation of @link(IFSDirectorySize))
  @member(
    IsValidItem Check for relative parented prefix
    @return(@true if not has parent prefix, @false if not)
  )
  @member(
    Execute Run check in use command
    @return(Size of folder)
  )
  @member(
    Create Object constructor
    @param(Directory @link(IFSDirectory Source Directory))
  )
  @member(
    New Create a new @classname as interface
    @param(Directory @link(IFSDirectory Source Directory))
  )
}
{$ENDREGION}

  TFSDirectorySize = class sealed(TInterfacedObject, IFSDirectorySize)
  strict private
    _Directory: IFSDirectory;
  private
    function IsValidItem(const Name: String): Boolean;
  public
    function Execute: Cardinal;
    constructor Create(const Directory: IFSDirectory);
    class function New(const Directory: IFSDirectory): IFSDirectorySize;
  end;

implementation

function TFSDirectorySize.IsValidItem(const Name: String): Boolean;
const
  CURRENT = '.';
  PARENT = '..';
begin
  Result := (Name <> CURRENT) and (Name <> PARENT);
end;

function TFSDirectorySize.Execute: Cardinal;
var
  SearchRec: TSearchRec;
begin
  Result := 0;
  if FindFirst(_Directory.Path + '*', faAnyFile, SearchRec) = 0 then
    try
      repeat
        if IsValidItem(SearchRec.Name) then
        begin
          Inc(Result, SearchRec.Size);
          if (SearchRec.Attr and faDirectory > 0) then
            Result := Result + TFSDirectorySize.New(TFSDirectory.NewWithParent(_Directory, SearchRec.Name)).Execute;
        end;
      until FindNext(SearchRec) <> 0;
    finally
      FindClose(SearchRec);
    end;
end;

constructor TFSDirectorySize.Create(const Directory: IFSDirectory);
begin
  _Directory := Directory;
end;

class function TFSDirectorySize.New(const Directory: IFSDirectory): IFSDirectorySize;
begin
  Result := TFSDirectorySize.Create(Directory);
end;

end.
