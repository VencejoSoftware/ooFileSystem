{$REGION 'documentation'}
{
  Copyright (c) 2016, Vencejo Software
  Distributed under the terms of the Modified BSD License
  The full license is distributed with this software
}
{
  Command to count directories
  @created(10/02/2016)
  @author Vencejo Software <www.vencejosoft.com>
}
{$ENDREGION}
unit ooFS.Directory.Count;

interface

uses
  ooFS.Directory, ooFS.Directory.Scan,
  ooFS.Command.Intf;

type
{$REGION 'documentation'}
{
  @abstract(Implementation of command to count directories)
  Calculate the amount of directories in a path
}
{$ENDREGION}
  IFSDirectoryCount = interface(IFSCommand<Integer>)
    ['{B416BE24-9862-418C-9D55-464FF781D74C}']
  end;
{$REGION 'documentation'}
{
  @abstract(Implementation of @link(IFSDirectoryCount))
  @member(
    Execute Run copy command
    @return(Integer with the counted directories)
  )
  @member(
    Create Object constructor
    @param(Directory @link(IFSDirectory Path))
    @param(Recursively Scan recursively folders and count)
  )
  @member(
    New Create a new @classname as interface
    @param(Directory @link(IFSDirectory Path))
    @param(Recursively Scan recursively folders and count)
  )
}
{$ENDREGION}

  TFSDirectoryCount = class sealed(TInterfacedObject, IFSDirectoryCount)
  strict private
    _Directory: IFSDirectory;
    _Recursively: Boolean;
  public
    function Execute: Integer;
    constructor Create(const Directory: IFSDirectory; const Recursively: Boolean);
    class function New(const Directory: IFSDirectory; const Recursively: Boolean): IFSDirectoryCount;
  end;

implementation

function TFSDirectoryCount.Execute: Integer;
var
  DirectoryList: TFSDirectoryList;
begin
  DirectoryList := TFSDirectoryList.Create;
  try
    Result := TFSDirectoryScan.New(_Directory, DirectoryList, _Recursively).Execute;
  finally
    DirectoryList.Free;
  end;
end;

constructor TFSDirectoryCount.Create(const Directory: IFSDirectory; const Recursively: Boolean);
begin
  _Directory := Directory;
  _Recursively := Recursively;
end;

class function TFSDirectoryCount.New(const Directory: IFSDirectory; const Recursively: Boolean): IFSDirectoryCount;
begin
  Result := TFSDirectoryCount.Create(Directory, Recursively);
end;

end.
