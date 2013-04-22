unit Spielfeld;

interface

uses classes, graphics, math,
     Kreis, zeitgeber, config, VE, zeichnen, funktionen;

type Tspielfeldzeiger = ^TSpielfeld;
     TSpieleranzahl = Word;
     TSpielernummer = TSpieleranzahl;
     TSpielfeld = class(TKreis)
     public
         spieler, zahlen, wall, remove_zahlen : Tlist;
         zeitgeber : Tzeitgeber;
         spielerzahl : TSpieleranzahl;
         wallanteil, alpha0 : Real;
         wallbreite : Real;
         wallfarbe : Tcolor;
         zahlenv, r2 : Real;
         teilerzahl: word;
         zahl_inc : Tvalue;

         constructor create(r : Real; color : Tcolor); overload;
         constructor create(x, y, r : Real; color : Tcolor); overload;

         function get_spieler_nummer : TSpieleranzahl;

         function get_spieler_alpha(spielernummer : TSpieleranzahl) : Real;
         // alpha ist der winkel, ab dem das spielfeld des spielers beginnt
         function get_spieler_beta(spielernummer : TSpieleranzahl) : Real;
         // beta ist der winkel, der die größe dieses spielfeldes angibt

         function get_wall_alpha(wallnummer : TSpielernummer) : Real;
         function get_wall_beta(wallnummer : TSpielernummer) : Real;

         function winkel_zu_pos(w : Real) : Tvector;
         function pos_zu_winkel(p : Tvector) : Real;

         procedure zeichne(c : Tcanvas);
         procedure act;

         function get_zahlenv : Real;

    end;


implementation

constructor TSpielfeld.create(r : Real; color : Tcolor);
begin
    self:= self.create(0, 0, r, color);
end;

constructor TSpielfeld.create(x, y, r : Real; color : Tcolor);
begin
    inherited create(x, y, r, color);
    self.zeitgeber:= Tzeitgeber.create;
    self.r2:= config.spielfeldr2;
    // wallzeug
    self.wallbreite:= config.wallbreite;
    self.wallanteil:= config.wallanteil;
    self.wallfarbe:= config.wallfarbe;
    // listen
    self.zahlen:= Tlist.create;
    self.spieler:= Tlist.create;
    self.wall:= Tlist.create;
    self.remove_zahlen:= Tlist.create;
    // zahlen
    self.zahlenv:= config.zahlenv;
    self.teilerzahl:= config.teilerzahl;
    self.zahl_inc:= 1;
end;
function TSpielfeld.get_spieler_alpha(spielernummer : TSpieleranzahl) : Real;
begin
    Result:= self.alpha0 + spielernummer / self.spielerzahl * 2 * pi;
end;

function TSpielfeld.get_spieler_beta(spielernummer : TSpieleranzahl) : Real;
begin
    Result:= 2 * pi * (1 - self.wallanteil) / self.spielerzahl;
end;
function TSpielfeld.get_spieler_nummer : TSpieleranzahl;
begin
    Result:= self.spielerzahl;
    inc(self.spielerzahl);
end;

function TSpielfeld.get_wall_alpha(wallnummer : TSpielernummer) : Real;
begin
    Result:= self.get_spieler_alpha(wallnummer) +
             self.get_spieler_beta(wallnummer);
end;

function TSpielfeld.get_wall_beta(wallnummer : TSpielernummer) : Real;
begin
    Result:= self.get_spieler_alpha(wallnummer + 1) -
             self.get_wall_alpha(wallnummer);
end;

function TSpielfeld.winkel_zu_pos(w : Real) : Tvector;
var x , y : Extended;
begin
    sincos(w + self.alpha0, y, x);
    Result:= Tvector.Create(x, y);
    Result.mul(self.r);
    Result.Add(self.pos);
end;

procedure TSpielfeld.zeichne(c : Tcanvas);
begin
    zeichnen.normalisiere(c);
    c.brush.color:= funktionen.fill_up(self.color, 255);
    zeichnen.zeichne_kreis(c, self.pos, self.r + self.r2);
    inherited zeichne(c);
end;

procedure TSpielfeld.act;
begin
    inherited act;
end;

function Tspielfeld.get_zahlenv : Real;
begin
    Result:= self.zahlenv;
end;

function Tspielfeld.pos_zu_winkel(p : Tvector) : Real;
var i : Integer;
begin
    p:= Tvector.Diff(p, self.pos);
    Result:= math.ArcTan2(p.y, p.x) - self.alpha0;
    while Result < 0 do
        Result:= Result + pi * 2;
end;


end.
