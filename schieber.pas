unit schieber;

interface

uses Zeichnen, funktionen, VE, Spielfeld, Wall, spielerfeld, config,
     graphics, sysutils, math;

type Tschieber = class(Twall)
     public
         spielerfeld : Tspielerfeld;
         t0 : Real;
         omega, wb : Real;  // winkelgeschwindigkeit + winkelbeschleunigung
         beta_plus : Real;


         constructor create(spielerfeld : Tspielerfeld; color : Tcolor);

         procedure set_beta(beta : Real);
         function beta : Real;
         function laengenwinkel : Real;                    overload;
         class function laengenwinkel(laenge : Real) : Real; overload;

         function maxlaenge : Real;

         procedure zeichne(canvas : Tcanvas);
         procedure act;

         function spielfeld : Tspielfeld;

         function alpha1 : Real;
         function alpha2 : Real;
         function alphamitte : Real;
         // alpha1 und alpha2 geben die ecken des schiebers an

         procedure set_laenge(b : Real);
         function laenge : Real;

         procedure move;

         function get_pos1 : Tvector;
         function get_pos2 : Tvector;

         procedure act_pos;

         function v : Tvector;

         function abprallrichtung(v : Tvector) : Tvector;

     protected
         _beta, _laenge, _laengenwinkel : Real;
     end;

implementation

constructor Tschieber.create(spielerfeld : Tspielerfeld; color : Tcolor);
begin
    inherited create(spielerfeld.pos, color);
    self.spielerfeld:= spielerfeld;
    self.t0:= self.spielfeld.zeitgeber.mytime;
    self.set_laenge(config.schieberstartlaenge);
    self.width:= config.schieberwidth;
    self.beta_plus:= 0;
    self.wb:= schieberwb;
    self.act;
end;

function Tschieber.maxlaenge : Real;
begin
    Result:= 2 * pot2(self.spielerfeld.r) * (1 - cos(self.spielerfeld.beta));
end;

procedure Tschieber.set_beta(beta : Real);
var bw : Real;
begin
    bw:= self.laengenwinkel / 2;
    if beta + bw > self.spielerfeld.beta then
        beta := self.spielerfeld.beta - bw
    else if beta < bw then
        beta := bw;
    self._beta:= beta;
//    self.act_pos;
end;

class function Tschieber.laengenwinkel(laenge : Real) : Real;
begin
    laenge:= pot2(laenge);
    if laenge >= 4 then
        laenge:= 4;
    Result:= arccos(1 - laenge / 2);

end;

function Tschieber.laengenwinkel : Real;
begin
    Result:= self._laengenwinkel;
end;

function Tschieber.beta : Real;
begin
    Result:= self._beta;
end;

procedure Tschieber.zeichne(canvas : Tcanvas);
begin
    inherited zeichne(canvas);
    Zeichnen.zeichne_schieber(canvas, self.get_pos1, self.get_pos2, self.width);
end;

function Tschieber.spielfeld : Tspielfeld;
begin
    Result:= self.spielerfeld.spielfeld;
end;
function Tschieber.alpha1 : Real;
begin
    Result:= self.spielerfeld.alpha + self.beta  - self.laengenwinkel / 2;
end;

function Tschieber.alpha2 : Real;
begin
    Result:= self.spielerfeld.alpha + self.beta  + self.laengenwinkel / 2;
end;

function Tschieber.laenge : Real;
begin
    Result:= self._laenge;
end;

procedure Tschieber.set_laenge(b : Real);
begin
    b:= abs(b);
    if b > self.maxlaenge then
        b:= self.maxlaenge;
    self._laenge:= b;
    self._laengenwinkel:= self.laengenwinkel(self.laenge / self.spielerfeld.r);
    self.set_beta(self.beta);
end;

procedure Tschieber.move;
var t : Real;
begin
    t:= self.spielfeld.zeitgeber.mytime;
    self.set_beta(self.beta + self.omega * (t - self.t0));
    self.t0:= t;
end;

function Tschieber.get_pos1 : Tvector;
begin
    Result:= self.spielfeld.winkel_zu_pos(self.alpha1);
end;
function Tschieber.get_pos2 : Tvector;
begin
    Result:= self.spielfeld.winkel_zu_pos(self.alpha2);
end;

procedure Tschieber.act_pos;
var dt, beta : Real;
begin
    // pos berechnen
    dt:= self.spielfeld.zeitgeber.mytime - self.t0;
    self.omega:= self.omega + self.wb * dt;
    beta:= self.beta + self.omega * dt;
    self.t0:= self.t0 + dt;
    self.set_beta(beta);
    if self.beta <> beta then
    begin
        self.omega:= self.omega * elastizitaet;
    //    self.wb:= -self.wb; //test
    end;

    // pos setzen
    self.pos:= self.get_pos1;
    self.pos2:= self.get_pos2;
end;

procedure TSchieber.act;
begin
    self.act_pos;
end;

function Tschieber.v : Tvector;
var w : Real;
    x, y : Extended;
begin
    w:= self.spielerfeld.alpha + self.beta - pi / 2;
    math.SinCos(w, y, x);
    w:= self.omega * self.spielerfeld.spielfeld.r;
    Result:= Tvector.create(x * w, y * w)
end;

function Tschieber.abprallrichtung(v : Tvector) : Tvector;
begin
    Result:= self.spielfeld.winkel_zu_pos(self.spielerfeld.alpha + self.beta);
    Result.sub(v);
end;

function Tschieber.alphamitte : Real;
begin
    Result:= self.spielerfeld.alpha + self.beta;
end;

end.
