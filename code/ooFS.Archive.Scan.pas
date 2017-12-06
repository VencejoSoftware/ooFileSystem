{$REGION 'documentation'}
{
  Copyright (c) 2016, Vencejo Software
  Distributed under the terms of the Modified BSD License
  The full license is distributed with this software
}
{
  Command to scan a file system returning archive list
  @created(10/02/2016)
  @author Vencejo Software <www.vencejosoft.com>
}
{$ENDREGION}
unit ooFS.Archive.Scan;

interface

uses
  Windows, SysUtils,
  ooFS.Command.Intf,
  ooFS.Entry, ooFS.Archive;

type
{$REGION 'documentation'}
{
  @abstract(Implementation of command to scan file system)
  Scan specified path to return a list of archivs, using a filter mask
}
{$ENDREGION}
  IFSArchiveScan = interface(IFSCommand<Integer>)
    ['{719B95CE-7C05-4266-9455-1E977E492133}']
  end;
{$REGION 'documentation'}
{
  @abstract(Implementation of @link(IFSArchiveScan))
  @member(
    Execute Run scan command
    @return(Integer with the count of archives founded)
  )
  @member(
    Create Object constructor
    @param(Path @link(IFSEntry Path to scan))
    @param(ArchiveList @link(TFSArchiveList List to fill with the founded archives))
    @param(FilterMask Mask to scan filter)
  )
  @member(
    New Create a new @classname as interface
    @param(Path @link(IFSEntry Path to scan))
    @param(ArchiveList @link(TFSArchiveList List to fill with the founded archives))
    @param(FilterMask Mask to scan filter)
  )
}
{$ENDREGION}

  TFSArchiveScan = class sealed(TInterfacedObject, IFSArchiveScan)
  strict private
    _Path: IFSEntry;
    _ArchiveList: TFSArchiveList;
    _FilterMask: String;
  public
    function Execute: Integer;
    constructor Create(const Path: IFSEntry; const ArchiveList: TFSArchiveList; const FilterMask: String);
    class function New(const Path: IFSEntry; const ArchiveList: TFSArchiveList;
      const FilterMask: String = '*.*'): IFSArchiveScan;
  end;

implementation

function TFSArchiveScan.Execute: Integer;
var
  SearchRec: TSearchRec;
begin
  if FindFirst(_Path.Path + _FilterMask, faAnyFile - faDirectory, SearchRec) = 0 then
    try
      repeat
        _ArchiveList.Add(TFSArchive.New(_Path, _Path.Path + SearchRec.Name));
      until FindNext(SearchRec) <> 0;
    finally
      FindClose(SearchRec);
    end;
  Result := _ArchiveList.Count;
end;

constructor TFSArchiveScan.Create(const Path: IFSEntry; const ArchiveList: TFSArchiveList; const FilterMask: String);
begin
  _Path := Path;
  _ArchiveList := ArchiveList;
  _FilterMask := FilterMask;
end;

class function TFSArchiveScan.New(const Path: IFSEntry; const ArchiveList: TFSArchiveList;
  const FilterMask: String): IFSArchiveScan;
begin
  Result := TFSArchiveScan.Create(Path, ArchiveList, FilterMask);
end;

end.
