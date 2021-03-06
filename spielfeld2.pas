unit spielfeld2;

interface

uses graphics, sysutils, classes, math,
     spielfeld, spielerfeld, wall, schieber, spieler, Zahl, VE, funktionen, config;

type Tspielfeld2 =  class(Tspielfeld)
     public
         letzte_zahl : Tvalue;
         wall_anzahl : Integer;

         function add_spieler(color : Tcolor) : Tspieler; overload;
         function add_spieler : Tspieler;                 overload;
         procedure add_zahl(z : Tzahl);                           overload;
         procedure add_zahl(value : Tvalue);                      overload;
         procedure add_zahl(value : Tvalue; pos, v : Tvector);    overload;
         procedure add_zahl;                                      overload;
      //   function add_wall(w : Twall) : Tvalue;

         procedure act_wallpos;
         procedure act_zahlen;

         procedure zeichne(canvas : Tcanvas);
         procedure act;
         procedure act_spieler;

         procedure abprallen(z : Tzahl; d : Tvector; width : Real);
         function abprallen_wall(z : Tzahl; w : Twall) : Boolean;
         function abprallen_schieber(z : Tzahl; s : Tschieber) : Boolean;

         function next_value : Tvalue;

         function senkrechte(winkel : Real) : Tvector;

         /// funktionen zur punktevergabe
         function is_out(z : Tzahl) : Boolean;
         function belogns_to(z : Tzahl) : Tspielernummer;
         procedure entferne_zahl(z : Tzahl);
         procedure spalte_zahl(z : Tzahl; pos : Tvector);

         // reagieren
         procedure taste_druck(t : Ttaste);
         procedure taste_ab(t : Ttaste);

     end;

implementation




function Tspielfeld2.add_spieler(color : Tcolor) : Tspieler;
var wall : Twall;
begin
    Result:= Tspieler.create(self, color);
    // add two walls so that there are no problems with parallel walls
    wall:= Twall.create(0,0,0,0, self.wallbreite, self.wallfarbe);
    self.wall.add(wall);
    wall:= Twall.create(0,0,0,0, self.wallbreite, self.wallfarbe);
    self.wall.add(wall);
    self.wall_anzahl := 0;
end;

function Tspielfeld2.add_spieler : Tspieler;
begin
    Result:= self.add_spieler(funktionen.spielerfarbe(self.spieler.count))
end;

procedure Tspielfeld2.act_wallpos;
var i : Tspielernummer;
    alpha, beta : Real;
    wall: Twall;
    hat_zwei_teile_waelle : Boolean;
begin
    hat_zwei_teile_waelle := (self.spielerzahl and 1) = 0;
    wall_anzahl := 0;
    for i:= 0 to self.spielerzahl - 1 do
    begin
        alpha:= self.get_wall_alpha(i);
        beta:=  self.get_wall_beta(i);
   //     alpha:= self.get_spieler_alpha(i);
     //   beta:=  self.get_spieler_beta(i);
        wall := self.wall.Items[i];
        wall.pos:= self.winkel_zu_pos(alpha);
        if hat_zwei_teile_waelle and ((self.spielerzahl Div 2) > i) then begin
          wall.pos2:= self.winkel_zu_pos(alpha + beta / 2);
          wall := self.wall.Items[i + self.spielerzahl];
          wall.pos:= self.winkel_zu_pos(alpha + beta / 2);
          wall.pos2:= self.winkel_zu_pos(alpha + beta);
          wall_anzahl := wall_anzahl + 2;
        end else begin
          wall.pos2:= self.winkel_zu_pos(alpha + beta);
          wall_anzahl := wall_anzahl + 1;
        end;
    end;
end;


procedure Tspielfeld2.act;
begin
    self.act_spieler;
    self.act_wallpos;
    self.act_zahlen;
    if self.spielerzahl = 1 then begin
      self.alpha0 := self.zeitgeber.mytime * config.spielfeldrotation
    end;
end;

procedure Tspielfeld2.zeichne(canvas : Tcanvas);
var i : Integer;
    wall : Twall;
    Spieler : Tspieler;
    Zahl : Tzahl;
begin
    inherited zeichne(canvas);
    for i := 0 to self.wall.Count - 1 do
    begin
        wall:= self.wall.Items[i];
        wall.zeichne(canvas);
    end;
    for i := 0 to self.spielerzahl - 1 do
    begin
        spieler:= self.spieler.Items[i];
        spieler.zeichne(canvas);
    end;
    for i := 0 to self.zahlen.Count - 1 do
    begin
        zahl:= self.zahlen.items[i];
        zahl.zeichne(canvas);
    end;
end;

procedure Tspielfeld2.act_zahlen;
var i, j : Integer;
    wall : Twall;
//    d : Tvector;
    Zahl : Tzahl;
    spieler : Tspieler;
begin
    for i := 0 to self.zahlen.Count - 1 do
     begin
        if self.zahlen.Count <= i then
            break;
        zahl:= self.zahlen.Items[i];
        zahl.act;
        if self.is_out(zahl) then
        begin
            self.entferne_zahl(zahl);
            continue;
        end;
        for j:= 0 to self.wall_anzahl - 1 do
        begin
            wall:= self.wall.Items[j];
            self.abprallen_wall(zahl, wall);
        end;
        for j:= 0 to self.spielerzahl - 1 do
        begin
            spieler:= self.spieler.Items[j];
            self.abprallen_schieber(zahl, spieler.schieber);
        end;
    end;
    // zahlen entfernen
    for i := 0 to self.remove_zahlen.Count - 1 do
        self.zahlen.Remove(self.remove_zahlen.items[i]);
    self.remove_zahlen:= Tlist.create;
end;

function Tspielfeld2.abprallen_wall(z : Tzahl; w : Twall) : Boolean;
var d : Tvector;
begin
    d:= w._distance_from(z.pos);
    if d.abssqr >= pot2(w.width / 2 + z.r) then
    begin
        Result:= False;
        exit;
    end;
    self.abprallen(z, d, w.width);
    Result:= True;
end;

procedure Tspielfeld2.abprallen(z : Tzahl; d : Tvector; width : Real);
var a : Real;
    back, m : Tvector;
begin
    a:= d.Abs;
    if a <> 0 then
        m:= Tvector.prod(d, (a - z.r - width / 2) / a)// was sich überschneidet
    else
        m:= Tvector.prod(d, (a - z.r - width / 2) / a);
    if is_zero(m) then
        exit;
    a:= m.abssqr / (z.v.x * m.x + z.v.y * m.y);
    back:= Tvector.prod(z.v, a);
    z.v:= Tvector.Prod(funktionen.spiegele(z.v, d), -1);
    z.pos.Sub(back);
    z.t0:= z.zeitgeber.mytime  + a;
end;

function Tspielfeld2.abprallen_schieber(z : Tzahl; s : TSchieber) : Boolean;
var d : Tvector;
begin
    d:= s._distance_from(z.pos);
    if d.abssqr >= pot2(s.width / 2 + z.r) then
    begin
        Result:= False;
        exit;
    end;
    if primzahltest(z.value) then
    begin
        d:= s.abprallrichtung(z.pos);
        if Tvector.diff(z.pos, self.pos).abssqr > pot2(self.r) then
            d:= funktionen.spiegele(d, self.senkrechte(s.alphamitte));
        z.v:= funktionen.ausrichten(z.v, d);
        Result:= True;
    end
    else
    begin
        self.spalte_zahl(z, z.pos);
        Result:= False;
    end;
end;

procedure Tspielfeld2.add_zahl(z : Tzahl);
begin
    self.zahlen.Add(z);
end;

procedure Tspielfeld2.add_zahl(value : Tvalue);
begin
    self.add_zahl(value, self.pos, randomvector(self.get_zahlenv));
end;

procedure Tspielfeld2.add_zahl(value : Tvalue; pos, v : Tvector);
begin
    self.add_zahl(Tzahl.create(pos.x, pos.y, v.x, v.y, zahlenr(value), value,
                     funktionen.zahlenfarbe(value), self.zeitgeber));
end;

procedure Tspielfeld2.add_zahl;
begin
    self.add_zahl(self.next_value);
end;

function Tspielfeld2.next_value : Tvalue;
begin
    Result:= self.letzte_zahl + self.zahl_inc;
    self.letzte_zahl:= Result;
end;

procedure Tspielfeld2.act_spieler;
var i : Integer;
    spieler : Tspieler;
begin
    for i := 0 to self.spielerzahl - 1 do
    begin
        spieler:= self.spieler.items[i];
        spieler.act;
    end;
end;

function Tspielfeld2.is_out(z : Tzahl) : Boolean;
var d : Real;
begin
    d:= Tvector.diff(self.pos, z.pos).abssqr;
    Result:= pot2(self.r + self.r2 - z.r) <= d;
end;

function Tspielfeld2.belogns_to(z : Tzahl) : Tspielernummer;
var w, wallbeta_div_2, spieleralpha : Real;
begin
    w:= self.pos_zu_winkel(z.pos);
    wallbeta_div_2:= self.get_wall_beta(0) / 2;
    for Result := 0 to (self.spielerzahl - 1) do
    begin
        spieleralpha:= self.get_spieler_alpha(Result);
        if (spieleralpha - wallbeta_div_2 < w) and
           (w < spieleralpha + wallbeta_div_2 + self.get_spieler_beta(Result)) then
            exit;
    end;
//    Result:= trunc((self.pos_zu_winkel(z.pos) - self.get_wall_beta(0) / 2 - self.alpha0)
//              / (2 * pi) * self.spielerzahl);
end;

procedure Tspielfeld2.entferne_zahl(z : Tzahl);
var spielernummer : Tspielernummer;
    spieler : Tspieler;
begin
    if self.is_out(z) then
    begin
        spielernummer:= self.belogns_to(z) mod self.spielerzahl;
//        if spielernummer < self.spielerzahl then
  //      begin
            spieler:= self.spieler.items[spielernummer];
            if primzahltest(z.value) and (z.value > 1) then
                spieler.add_punkte(Integer(z.value))
            else
            begin
                spieler.add_punkte(-Integer(z.value));
                self.spalte_zahl(z, self.pos);
            end;
    //    end;
    end;
    if z.value = 1 then
    begin
        self.add_zahl(1);
    end;
    self.remove_zahlen.add(z);
   // dispose(z);
end;

function Tspielfeld2.senkrechte(winkel : Real) : Tvector;
var y, x : Extended;
begin
    math.SinCos(winkel - pi / 2, y, x);
    Result:= Tvector.create(x, y)
end;

procedure Tspielfeld2.taste_druck(t : Ttaste);
var i : Integer;
    s : Tspieler;
begin
    for i := 0 to self.spielerzahl - 1 do
    begin
        s:= self.spieler.items[i];
        s.taste_druck(t);
    end;
end;

procedure Tspielfeld2.taste_ab(t : Ttaste);
var i : Integer;
    s : Tspieler;
begin
    for i := 0 to self.spielerzahl - 1 do
    begin
        s:= self.spieler.items[i];
        s.taste_ab(t);
    end;
end;

procedure Tspielfeld2.spalte_zahl(z : Tzahl; pos : Tvector);
var pf : TprimzahlenArray;
    i : Integer;
    d : Tvector;
begin
    pf := n_teiler(z.value, self.teilerzahl);
    for i:= 0 to length(pf) - 1 do
        if pf[i] <> 0 then
        begin
            d:= Tvector.diff(pos, self.pos);
        //    if d.abssqr > pot2(self.r) then    // dann gehen die zahlen in den schieber, bis sie alee prim sind
        //        d.mul(-1);
            if d.abssqr = 0 then
                self.add_zahl(pf[i], pos,
                          drehe(z.v, random * 2 * pi))
            else
                self.add_zahl(pf[i], pos,
                          ausrichten(z.v, drehe(d, (random - 0.5) * config.spaltwinkel)))
        end;
    self.remove_zahlen.add(z);
end;


end.
