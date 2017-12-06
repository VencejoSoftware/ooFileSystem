{$REGION 'documentation'}
{
  Copyright (c) 2016, Vencejo Software
  Distributed under the terms of the Modified BSD License
  The full license is distributed with this software
}
{
  Command to produce not blocking delay
  @created(10/02/2016)
  @author Vencejo Software <www.vencejosoft.com>
}
{$ENDREGION}
unit ooFS.Command.Delay;

interface

uses
  Forms, Windows,
  ooFS.Command.Intf;

type
{$REGION 'documentation'}
{
  @abstract(Implementation of command for delays)
  Create a non blocking delay in application
}
{$ENDREGION}
  IFSCommandDelay = interface(IFSCommand<Boolean>)
    ['{9DD5BCCF-3C08-4398-8403-9F18FE9B6EBF}']
  end;
{$REGION 'documentation'}
{
  @abstract(Implementation of @link(IFSCommandDelay))
  @member(
    Execute Run delay command
    @return(@true if success, @false if fail)
  )
  @member(
    Create Object constructor
    @param(Milliseconds Delay in milliseconds)
  )
  @member(
    New Create a new @classname as interface
    @param(Milliseconds Delay in milliseconds)
  )
}
{$ENDREGION}

  TFSCommandDelay = class sealed(TInterfacedObject, IFSCommandDelay)
  strict private
    _Milliseconds: Integer;
  public
    function Execute: Boolean;
    constructor Create(const Milliseconds: Integer);
    class function New(const Milliseconds: Integer): IFSCommandDelay;
  end;

implementation

function TFSCommandDelay.Execute: Boolean;
var
  FirstTickCount: DWORD;
begin
  FirstTickCount := GetTickCount;
  repeat
    Application.ProcessMessages;
    Sleep(1);
  until ((GetTickCount - FirstTickCount) >= DWORD(_Milliseconds)) or Application.Terminated;
  Result := True;
end;

constructor TFSCommandDelay.Create(const Milliseconds: Integer);
begin
  _Milliseconds := Milliseconds;
end;

class function TFSCommandDelay.New(const Milliseconds: Integer): IFSCommandDelay;
begin
  Result := TFSCommandDelay.Create(Milliseconds);
end;

end.
