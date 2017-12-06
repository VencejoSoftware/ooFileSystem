{
  Copyright (c) 2016, Vencejo Software
  Distributed under the terms of the Modified BSD License
  The full license is distributed with this software
}
program test;

uses
  ooRunTest,
  ooFS.Directory.Count_test in '..\code\ooFS.Directory.Count_test.pas',
  ooFS.Archive.CountLines_test in '..\code\ooFS.Archive.CountLines_test.pas',
  ooFS.Archive.Delete_test in '..\code\ooFS.Archive.Delete_test.pas',
  ooFS.Archive.Copy_test in '..\code\ooFS.Archive.Copy_test.pas',
  ooFS.Archive.Move_test in '..\code\ooFS.Archive.Move_test.pas',
  ooFS.Archive.Rename_test in '..\code\ooFS.Archive.Rename_test.pas',
  ooFS.Drive.Scan_test in '..\code\ooFS.Drive.Scan_test.pas',
  ooFS.Directory_test in '..\code\ooFS.Directory_test.pas',
  ooFS.Directory.Scan_test in '..\code\ooFS.Directory.Scan_test.pas',
  ooFS.Archive_test in '..\code\ooFS.Archive_test.pas',
  ooFS.Archive.Scan_test in '..\code\ooFS.Archive.Scan_test.pas',
  ooFS.SizeFormat_test in '..\code\ooFS.SizeFormat_test.pas',
  ooFS.Entry.Scan_test in '..\code\ooFS.Entry.Scan_test.pas',
  ooFS.Archive.InUse_test in '..\code\ooFS.Archive.InUse_test.pas',
  ooFSUtils in '..\code\ooFSUtils.pas',
  ooFS.Directory.IsEmpty_test in '..\code\ooFS.Directory.IsEmpty_test.pas',
  ooFS.Directory.Make_test in '..\code\ooFS.Directory.Make_test.pas',
  ooFS.Directory.Delete_test in '..\code\ooFS.Directory.Delete_test.pas',
  ooFS.Directory.Absolute_test in '..\code\ooFS.Directory.Absolute_test.pas';

{$R *.RES}

begin
  Run;

end.
