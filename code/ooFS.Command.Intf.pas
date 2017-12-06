{$REGION 'documentation'}
{
  Copyright (c) 2016, Vencejo Software
  Distributed under the terms of the Modified BSD License
  The full license is distributed with this software
}
{
  Interface for all file system commands
  @created(10/02/2016)
  @author Vencejo Software <www.vencejosoft.com>
}
{$ENDREGION}
unit ooFS.Command.Intf;

interface

type
{$REGION 'documentation'}
{
  @abstract(Interface for all file system commands)
  Define an structure for fs commands
  @member(
    Execute Run the command
    @return(A generic type to implements)
  )
}
{$ENDREGION}
  IFSCommand<T> = interface
    ['{B6D2E46E-EC2D-4852-9FDA-046D7561AC21}']
    function Execute: T;
  end;

implementation

end.
