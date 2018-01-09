{$REGION 'documentation'}
{
  Copyright (c) 2016, Vencejo Software
  Distributed under the terms of the Modified BSD License
  The full license is distributed with this software
}
{
  Archive object
  @created(10/02/2016)
  @author Vencejo Software <www.vencejosoft.com>
}
{$ENDREGION}
unit ooFS.Archive;

interface

uses
  Windows, SysUtils,
  Generics.Collections,
  ooFS.Entry, ooFS.Directory;

type
{$REGION 'documentation'}
{
  Enum for archive attributes
  @value ReadOnly Read only files
  @value Hidden Hidden files
}
{$ENDREGION}
  TFSArchiveAttribute = (ReadOnly, Hidden);
{$REGION 'documentation'}
// Define a set of file attributes
{$ENDREGION}
  TFSArchiveAttributeSet = set of TFSArchiveAttribute;
{$REGION 'documentation'}
{
  @abstract(Interface of archive definition)
  @member(
    Parent Archive parent path
    @return(@link(IFSEntry parent object))
  )
  @member(
    Name Archive name
    @return(String with the name)
  )
  @member(
    Creation Return creation datetime
    @return(DateTime with archive creation time)
  )
  @member(
    Modified Return modified datetime
    @return(DateTime with archive modification time)
  )
  @member(
    LastAccess Return last access datetime
    @return(DateTime with archive last access time)
  )
  @member(
    Exists Check if archive exist
    @return(@true if exists, @false if not)
  )
  @member(
    Size Return the archive size
    @return(Integer with size in bytes)
  )
  @member(
    Extension Return archive extension
    @return(String with the extension)
  )
  @member(
    Attributes Return archive attributes
    @return(@link(TFSArchiveAttributeSet archive attributes))
  )
}
{$ENDREGION}

  IFSArchive = interface(IFSEntry)
    ['{DAF50D64-38DA-41C2-B61E-02E8C835ABCA}']
    function Parent: IFSEntry;
    function Name: String;
    function Creation: TDateTime;
    function Modified: TDateTime;
    function LastAccess: TDateTime;
    function Exists: Boolean;
    function Size: Integer;
    function Extension: String;
    function Attributes: TFSArchiveAttributeSet;
  end;
{$REGION 'documentation'}
{
  @abstract(Implementation of @link(IFSArchive))
  Archive object
  @member(Path @seealso(IFSEntry.Path))
  @member(Kind @seealso(IFSEntry.Kind))
  @member(Parent @seealso(IFSArchive.Parent))
  @member(Name @seealso(IFSArchive.Name))
  @member(Creation @seealso(IFSArchive.Creation))
  @member(Modified @seealso(IFSArchive.Modified))
  @member(LastAccess @seealso(IFSArchive.LastAccess))
  @member(Exists @seealso(IFSArchive.Exists))
  @member(Size @seealso(IFSArchive.Size))
  @member(Extension @seealso(IFSArchive.Extension))
  @member(Attributes @seealso(IFSArchive.Attributes))
  @member(
    Create Object constructor
    @param(Parent @link(IFSEntry Parent object))
    @param(Path File path)
  )
  @member(
    New Create a new @classname as interface
    @param(Parent @link(IFSEntry Parent object))
    @param(Path File path)
  )
}
{$ENDREGION}

  TFSArchive = class sealed(TInterfacedObject, IFSArchive)
  strict private
    _Parent: IFSEntry;
    _FSEntry: IFSEntry;
  public
    function Path: String;
    function Kind: TFSEntryKind;
    function Parent: IFSEntry;
    function Name: String;
    function Creation: TDateTime;
    function Modified: TDateTime;
    function LastAccess: TDateTime;
    function Exists: Boolean;
    function Size: Integer;
    function Extension: String;
    function Attributes: TFSArchiveAttributeSet;
    constructor Create(const Parent: IFSEntry; const Path: String);
    class function New(const Parent: IFSEntry; const Path: String): IFSArchive;
  end;
{$REGION 'documentation'}
{
  @abstract(Collection of @link(IFSArchive archives))
  @member(
    IsEmpty Check if the list is empty
    @param(@true if not has items, @false if has items)
  )
}
{$ENDREGION}

  TFSArchiveList = class sealed(TList<IFSArchive>)
  public
    function IsEmpty: Boolean;
  end;

implementation

function TFSArchive.Path: String;
begin
  Result := Parent.Path + _FSEntry.Path
end;

function TFSArchive.Kind: TFSEntryKind;
begin
  Result := _FSEntry.Kind;
end;

function TFSArchive.Parent: IFSEntry;
begin
  Result := _Parent;
end;

function TFSArchive.Exists: Boolean;
begin
  Result := FileExists(Path);
end;

function TFSArchive.Name: String;
begin
  Result := ExtractFileName(Path);
end;

function TFSArchive.Extension: String;
begin
  Result := ExtractFileExt(Path);
  if Length(Result) > 1 then
    Result := Copy(Result, 2, Pred(Length(Result)));
end;

function TFSArchive.Size: Integer;
var
  FileHandle: file of Byte;
begin
  try
    AssignFile(FileHandle, Path);
    try
      Reset(FileHandle);
      Result := FileSize(FileHandle);
    finally
      CloseFile(FileHandle);
    end;
  except
    Result := - 1;
  end;
end;

function TFSArchive.Creation: TDateTime;
var
  Attrib: WIN32_FILE_ATTRIBUTE_DATA;
  SystemTime, LocalTime: TSystemTime;
begin
  GetFileAttributesEx(PChar(Path), GetFileExInfoStandard, @Attrib);
  if not FileTimeToSystemTime(Attrib.ftCreationTime, SystemTime) then
    RaiseLastOSError;
  if not SystemTimeToTzSpecificLocalTime(nil, SystemTime, LocalTime) then
    RaiseLastOSError;
  Result := SystemTimeToDateTime(LocalTime);
end;

function TFSArchive.LastAccess: TDateTime;
var
  Attrib: WIN32_FILE_ATTRIBUTE_DATA;
  SystemTime, LocalTime: TSystemTime;
begin
  GetFileAttributesEx(PChar(Path), GetFileExInfoStandard, @Attrib);
  if not FileTimeToSystemTime(Attrib.ftLastAccessTime, SystemTime) then
    RaiseLastOSError;
  if not SystemTimeToTzSpecificLocalTime(nil, SystemTime, LocalTime) then
    RaiseLastOSError;
  Result := SystemTimeToDateTime(LocalTime);
end;

function TFSArchive.Modified: TDateTime;
var
  Attrib: WIN32_FILE_ATTRIBUTE_DATA;
  SystemTime, LocalTime: TSystemTime;
begin
  GetFileAttributesEx(PChar(Path), GetFileExInfoStandard, @Attrib);
  if not FileTimeToSystemTime(Attrib.ftLastWriteTime, SystemTime) then
    RaiseLastOSError;
  if not SystemTimeToTzSpecificLocalTime(nil, SystemTime, LocalTime) then
    RaiseLastOSError;
  Result := SystemTimeToDateTime(LocalTime);
end;

function TFSArchive.Attributes: TFSArchiveAttributeSet;
var
  Attrib: WIN32_FILE_ATTRIBUTE_DATA;
begin
  Result := [];
  GetFileAttributesEx(PChar(Path), GetFileExInfoStandard, @Attrib);
  if (Attrib.dwFileAttributes and FILE_ATTRIBUTE_READONLY) > 0 then
    Include(Result, ReadOnly);
  if (Attrib.dwFileAttributes and FILE_ATTRIBUTE_HIDDEN) > 0 then
    Include(Result, Hidden);
end;

constructor TFSArchive.Create(const Parent: IFSEntry; const Path: String);
begin
  _FSEntry := TFSEntry.New(ExtractFileName(Path), TFSEntryKind.Archive);
  if Assigned(Parent) then
    _Parent := Parent
  else
    _Parent := TFSDirectory.New(ExtractFilePath(Path));
end;

class function TFSArchive.New(const Parent: IFSEntry; const Path: String): IFSArchive;
begin
  Result := TFSArchive.Create(Parent, Path);
end;

{ TFSArchiveList }

function TFSArchiveList.IsEmpty: Boolean;
begin
  Result := Count < 1;
end;

end.
