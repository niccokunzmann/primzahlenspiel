unit Spieler;

interface
uses sysutils, graphics, 
     Spielerfeld, spielfeld, schieber, config, VE, zeichnen;

type Ttaste = Word;
     Ttasten = record
         rechts , links : Ttaste;
     end;
     Tpunkte = Integer;
     TSpieler = class(Tobject)
     public
         spielfeld : Tspielfeld;
         Spielerfeld : TSpielerfeld;
         schieber : Tschieber;
         tasten : Ttasten;
         // sonstiges
         durch_prim, durch_ges : Integer;

         constructor create(spielfeld : Tspielfeld; color : Tcolor);

         function nummer : Tspielernummer;

         procedure zeichne(canvas : Tcanvas);
         procedure act;

         procedure add_punkte(p : Tpunkte);

         procedure sterbe;

         procedure taste_druck(t : Ttaste);
         procedure taste_ab(t : Ttaste);

         function get_punkte : Tpunkte;

     private
         punkte : Tpunkte;
     end;

implementation

constructor Tspieler.create(spielfeld : Tspielfeld; color : Tcolor);
begin
    inherited create;
    self.spielfeld:= spielfeld;
    self.Spielerfeld:= TSpielerfeld.create(spielfeld, color);
    self.schieber:= Tschieber.create(self.Spielerfeld, color);
    spielfeld.spieler.add(self);
end;

function Tspieler.nummer : Tspielernummer;
begin
    Result:= self.spielerfeld.spielernummer;
end;

procedure Tspieler.zeichne(canvas : Tcanvas);
var pos : Tvector;
begin
    self.Spielerfeld.zeichne(canvas);
    self.schieber.zeichne(canvas);
    // punkte ausgabe
    zeichnen.normalisiere(canvas);
    pos:= Tvector.diff(self.schieber.pos, self.schieber.pos2);
    pos.mul(-0.5);
    pos.add(self.schieber.pos);
    pos.sub(self.Spielerfeld.spielfeld.pos);
    pos.mul((self.Spielerfeld.spielfeld.r + config.punkteradius) / self.Spielerfeld.spielfeld.r);
    pos.add(self.Spielerfeld.spielfeld.pos);
    zeichnen.text_mittig(canvas, pos, inttostr(self.punkte));
end;

procedure Tspieler.act;
begin
    self.Spielerfeld.act;
    self.schieber.act;
end;

procedure Tspieler.add_punkte(p : Tpunkte);
begin
    self.punkte:= self.punkte + p;
    if self.punkte < 0 then
        self.sterbe;
    if p > 0 then
    begin
        inc(self.durch_prim);
    end;
    inc(self.durch_ges);
end;

procedure Tspieler.sterbe;
begin
//    self.schieber.set_laenge(self.schieber.maxwidth); //self.Spielerfeld.spielfeld.r * );
end;

procedure Tspieler.taste_druck(t : Ttaste);
begin
    if self.tasten.rechts = t then
    begin
        self.schieber.wb:= config.schieberwb / self.spielfeld.spielerzahl + config.minschieberwb;
    end
    else if self.tasten.links = t then
    begin
        self.schieber.wb:= -config.schieberwb / self.spielfeld.spielerzahl + config.minschieberwb;
    end;
end;

procedure Tspieler.taste_ab(t : Ttaste);
begin
    if self.tasten.rechts = t then
    begin
        self.schieber.wb:= 0;
    end
    else if self.tasten.links = t then
    begin
        self.schieber.wb:= 0;
    end;
end;

function Tspieler.get_punkte : Tpunkte;
begin
    Result:= self.punkte
end;
end.
