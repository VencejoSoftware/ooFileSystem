{$REGION 'documentation'}
{
  Copyright (c) 2016, Vencejo Software
  Distributed under the terms of the Modified BSD License
  The full license is distributed with this software
}
{
  Command to scan a file system returning directories list
  @created(10/02/2016)
  @author Vencejo Software <www.vencejosoft.com>
}
{$ENDREGION}
unit ooFS.Directory.Scan;

interface

uses
  Windows, SysUtils,
  ooFS.Command.Intf,
  ooFS.Entry, ooFS.Directory;

type
{$REGION 'documentation'}
{
  @abstract(Implementation of command to scan a file system returning directories list)
  Scan specified path to return a list of directories
}
{$ENDREGION}
  IFSDirectoryScan = interface(IFSCommand<Integer>)
    ['{719B95CE-7C05-4266-9455-1E977E492133}']
  end;
{$REGION 'documentation'}
{
  @abstract(Implementation of @link(IFSDirectoryScan))
  @member(
    IsRealDirectory Check for relative parented prefix
    @return(@true if not has parent prefix, @false if not)
  )
  @member(
    ScanPath Scan specified path, with the chance to recursively auto call
    @param(Path @link(IFSEntry Path to scan))
    @param(DirectoryList @link(TFSDirectoryList List to fill with the founded directories))
    @param(Recursively Scan recursively)
  )
  @member(
    Execute Run scan command
    @return(Integer with the count of directories founded)
  )
  @member(
    Create Object constructor
    @param(Path @link(IFSEntry Path to scan))
    @param(DirectoryList @link(TFSDirectoryList List to fill with the founded directories))
    @param(Recursively Scan recursively)
  )
  @member(
    New Create a new @classname as interface
    @param(Path @link(IFSEntry Path to scan))
    @param(DirectoryList @link(TFSDirectoryList List to fill with the founded directories))
    @param(Recursively Scan recursively)
  )
}
{$ENDREGION}

  TFSDirectoryScan = class sealed(TInterfacedObject, IFSDirectoryScan)
  strict private
    _Path: IFSEntry;
    _DirectoryList: TFSDirectoryList;
    _Recursively: Boolean;
  private
    function IsRealDirectory(const Name: String): Boolean;
    procedure ScanPath(const Path: IFSEntry; const DirectoryList: TFSDirectoryList; const Recursively: Boolean);
  public
    function Execute: Integer;
    constructor Create(const Path: IFSEntry; const DirectoryList: TFSDirectoryList; const Recursively: Boolean);
    class function New(const Path: IFSEntry; const DirectoryList: TFSDirectoryList;
      const Recursively: Boolean): IFSDirectoryScan;
  end;

implementation

function TFSDirectoryScan.IsRealDirectory(const Name: String): Boolean;
const
  CURRENT = '.';
  PARENT = '..';
begin
  Result := (Name <> CURRENT) and (Name <> PARENT);
end;

procedure TFSDirectoryScan.ScanPath(const Path: IFSEntry; const DirectoryList: TFSDirectoryList;
  const Recursively: Boolean);
var
  SearchRec: TSearchRec;
  Directory: IFSDirectory;
begin
  if FindFirst(Path.Path + '*', faDirectory, SearchRec) = 0 then
    try
      repeat
        if IsRealDirectory(SearchRec.Name) then
        begin
          Directory := TFSDirectory.New(Path.Path + SearchRec.Name);
          DirectoryList.Add(Directory);
          if Recursively then
            ScanPath(Directory, DirectoryList, Recursively);
        end;
      until FindNext(SearchRec) <> 0;
    finally
      FindClose(SearchRec);
    end;
end;

function TFSDirectoryScan.Execute: Integer;
begin
  ScanPath(_Path, _DirectoryList, _Recursively);
  Result := _DirectoryList.Count;
end;

constructor TFSDirectoryScan.Create(const Path: IFSEntry; const DirectoryList: TFSDirectoryList;
  const Recursively: Boolean);
begin
  _Path := Path;
  _DirectoryList := DirectoryList;
  _Recursively := Recursively;
end;

class function TFSDirectoryScan.New(const Path: IFSEntry; const DirectoryList: TFSDirectoryList;
  const Recursively: Boolean): IFSDirectoryScan;
begin
  Result := TFSDirectoryScan.Create(Path, DirectoryList, Recursively);
end;

end.
