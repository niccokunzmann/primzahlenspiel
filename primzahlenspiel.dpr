program primzahlenspiel;

uses
  Forms,
  Oberflaeche in 'Oberflaeche.pas' {Form1},
  Kreis in 'Kreis.pas',
  Zahl in 'Zahl.pas',
  Spielfeld in 'Spielfeld.pas',
  zeitgeber in 'zeitgeber.pas',
  funktionen in 'funktionen.pas',
  Darstellbares in 'Darstellbares.pas',
  Zeichnen in 'Zeichnen.pas',
  wall in 'wall.pas',
  schieber in 'schieber.pas',
  spielerfeld in 'spielerfeld.pas',
  spielfeld2 in 'spielfeld2.pas',
  Spieler in 'Spieler.pas',
  config in 'config.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.Title := 'Primzahlenspiel';
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
