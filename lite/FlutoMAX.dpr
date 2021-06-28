{ This program is free software. You are allowed to redistribute this
  software and making the software available for download or
  making this software part of a software CD compilation.
  This software is provided 'as-is', without any express or implied
  warranty.  In no event will the author be held liable for any
  damages arising from the use of this software.

  © Copyright 2013-2021 Vasily Makarov
}
program FlutoMAX;

uses
  System.StartUpCopy,
  FMX.Forms,
  uFrFileSelector in 'uFrFileSelector.pas' {FrFileSelector: TFrame},
  uFrmMain in 'uFrmMain.pas' {FrmMain},
  uFlute in 'uFlute.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TFrmMain, FrmMain);
  Application.Run;
end.
