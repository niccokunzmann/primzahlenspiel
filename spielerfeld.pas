unit spielerfeld;

interface

uses Zeichnen, funktionen, VE, Spielfeld, Darstellbares,
     graphics, sysutils;

type
      Tspielerfeld = class(Tdarstellbares)
      public
          spielfeld : Tspielfeld;
          spielernummer : TSpieleranzahl;
          constructor create(spielfeld : Tspielfeld; color : Tcolor);


          function alpha : Real;
          // => anfangswinkel
          function beta : Real;
          // => feldwinkel (größe des feldes)
          function r : Real;
          // => self.spielfeld.r

          procedure zeichne(canvas : Tcanvas);
          procedure act;

      end;

implementation
constructor Tspielerfeld.create(spielfeld : Tspielfeld; color : Tcolor);
begin
    inherited create(spielfeld.pos, color);
    self.spielfeld:= spielfeld;
    self.spielernummer:= spielfeld.get_spieler_nummer;
    self.pos:= spielfeld.pos;
end;


procedure Tspielerfeld.zeichne(canvas : Tcanvas);
begin
    inherited zeichne(canvas);
    Zeichnen.zeichne_spielerfeld(canvas, self.pos, self.r, self.alpha, self.beta);
end;


function Tspielerfeld.alpha : Real;
begin
    Result:= self.spielfeld.get_spieler_alpha(self.spielernummer);
   // Result:= Result;
end;

function Tspielerfeld.beta : Real;
begin
    Result:= self.spielfeld.get_spieler_beta(self.spielernummer);
    Result:= Result;
end;

function Tspielerfeld.r : Real;
begin
    Result:= self.spielfeld.r;
end;

procedure Tspielerfeld.act;
begin
end;


end.
