{$REGION 'documentation'}
{
  Copyright (c) 2016, Vencejo Software
  Distributed under the terms of the Modified BSD License
  The full license is distributed with this software
}
{
  Format file system sizes in a understandable text
  @created(10/02/2016)
  @author Vencejo Software <www.vencejosoft.com>
}
{$ENDREGION}
unit ooFS.SizeFormat;

interface

uses
  SysUtils, Math;

type
{$REGION 'documentation'}
{
  @abstract(File system size format)
  Format file system sizes in a understandable text
  @member(
    Stylized Format size
    @returns(String with formatted size)
  )
}
{$ENDREGION}
  IFSSizeFormat = interface
    ['{A88AD3C9-E3FF-4ABD-AEA9-0D8660D2AD6D}']
    function Stylized: String;
  end;
{$REGION 'documentation'}
{
  @abstract(Implementation of @link(IFSSizeFormat))
  @member(Stylized @seealso(IFSSizeFormat.Stylized))
  @member(
    Create Object constructor
    @param(Size Size value of file system)
  )
  @member(
    New Create a new @classname as interface
    @param(Size Size value of file system)
  )
}
{$ENDREGION}

  TFSSizeFormat = class sealed(TInterfacedObject, IFSSizeFormat)
  strict private
    _Stylized: String;
  public
    function Stylized: String;
    constructor Create(const Size: Extended);
    class function New(const Size: Extended): IFSSizeFormat;
  end;

implementation

function TFSSizeFormat.Stylized: String;
begin
  Result := _Stylized;
end;

constructor TFSSizeFormat.Create(const Size: Extended);
const
  SIZE_MEASURE: Array [0 .. 8] of string = ('bytes', 'kb', 'mb', 'gb', 'tb', 'pb', 'eb', 'zb', 'yb');
var
  i: Integer;
begin
  i := 0;
  while Size > Power(1024, i + 1) do
    Inc(i);
  _Stylized := FormatFloat('###0.##', Size / IntPower(1024, i)) + ' ' + SIZE_MEASURE[i];
end;

class function TFSSizeFormat.New(const Size: Extended): IFSSizeFormat;
begin
  Result := TFSSizeFormat.Create(Size);
end;

end.
