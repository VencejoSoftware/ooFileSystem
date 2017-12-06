{$REGION 'documentation'}
{
  Copyright (c) 2016, Vencejo Software
  Distributed under the terms of the Modified BSD License
  The full license is distributed with this software
}
{
  Command to count lines in file
  @created(10/02/2016)
  @author Vencejo Software <www.vencejosoft.com>
}
{$ENDREGION}
unit ooFS.Archive.CountLines;

interface

uses
  Classes, SysUtils,
  ooFS.Archive,
  ooFS.Command.Intf;

type
{$REGION 'documentation'}
{
  @abstract(Implementation of command to count lines in file)
  Calculate the amount of lines in file
}
{$ENDREGION}
  IFSArchiveCountLines = interface(IFSCommand<Integer>)
    ['{B416BE24-9862-418C-9D55-464FF781D74C}']
  end;
{$REGION 'documentation'}
{
  @abstract(Implementation of @link(IFSArchiveCountLines))
  @member(
    Execute Run the count lines command
    @return(Integer with the counted lines)
  )
  @member(
    Create Object constructor
    @param(Archive @link(IFSArchive Source archive))
  )
  @member(
    New Create a new @classname as interface
    @param(Archive @link(IFSArchive Source archive))
  )
}
{$ENDREGION}

  TFSArchiveCountLines = class sealed(TInterfacedObject, IFSArchiveCountLines)
  strict private
    _Archive: IFSArchive;
  public
    function Execute: Integer;
    constructor Create(const Archive: IFSArchive);
    class function New(const Archive: IFSArchive): IFSArchiveCountLines;
  end;

implementation

function TFSArchiveCountLines.Execute: Integer;
const
  MAX_BUFFER = 1024 * 1024;
  LF = #10;
  CR = #13;
var
  FileStream: TFileStream;
  BufferString: AnsiString;
  BufferSize: Integer;
  SeekPos: Integer;
  NeedCarry: Boolean;
begin
  Result := 0;
  if not _Archive.Exists then
    Exit;
  NeedCarry := False;
  FileStream := TFileStream.Create(_Archive.Path, fmOpenRead or fmShareDenyWrite);
  try
    SetLength(BufferString, MAX_BUFFER);
    repeat
      BufferSize := FileStream.Read(BufferString[1], MAX_BUFFER);
      if BufferSize <= 0 then
        break;
      SeekPos := 1;
      if NeedCarry and (BufferString[1] = LF) then
        inc(SeekPos);
      while SeekPos <= BufferSize do
      begin
        case BufferString[SeekPos] of
          LF:
            inc(Result);
          CR:
            if SeekPos = BufferSize then
              inc(Result)
            else
              if BufferString[SeekPos + 1] <> LF then
                inc(Result)
              else
              begin
                inc(Result);
                inc(SeekPos);
              end;
        end;
        inc(SeekPos);
      end;
      NeedCarry := (BufferString[BufferSize] = CR);
    until BufferSize < MAX_BUFFER;
  finally
    FreeAndNil(FileStream);
  end;
end;

constructor TFSArchiveCountLines.Create(const Archive: IFSArchive);
begin
  _Archive := Archive;
end;

class function TFSArchiveCountLines.New(const Archive: IFSArchive): IFSArchiveCountLines;
begin
  Result := TFSArchiveCountLines.Create(Archive);
end;

end.
