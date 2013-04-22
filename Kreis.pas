unit Kreis;

interface

uses
    VE, funktionen, Darstellbares, wall, zeichnen,
    graphics, SysUtils;


type Tradian = Real;

     Tcircle = class(TDarstellbares)
     public
         r : Real;

         constructor create(x, y, r : Real; color : Tcolor); overload;
         constructor clone(c : Tcircle);

         procedure zeichne(canvas : Tcanvas);

         function in_kreis(v : Tvector) : Boolean; overload; // ob anderer in |
         function in_kreis(k : Tcircle) : Boolean; overload; // einem selbst  |
         function in_kreis_ganz(k : Tcircle) : Boolean;      // drin ist      |
         function auf_umkreis(k : Tcircle) : Boolean;      // oder auf dem rand

         // folgende funktionen geben den k�rzesten abstand als vector zur�ck
         function distance_to(v : Tvector) : Tvector;  overload;
         function distance_to(k : Tcircle) : Tvector;  overload;
         function distance_to(w : Twall)   : Tvector;  overload;

   //      function in_kreis(w : Twall) : Boolean;   overload;

     protected


     end;

     Tkreis = Tcircle;


implementation

constructor Tcircle.create(x, y, r : Real; color : Tcolor);
begin
    inherited create(x, y, color);
    self.r:= r;
end;

constructor Tcircle.clone(c : Tcircle);
begin
    self.pos.clone(c.pos);
    self.r:= c.r;
end;


procedure Tcircle.zeichne(canvas : Tcanvas);
begin
    inherited zeichne(canvas);
    zeichnen.zeichne_kreis(canvas, self.pos, self.r);
end;

                 ////////////  in kreis  ////////////
function Tcircle.in_kreis(v : Tvector) : Boolean;
begin
    Result:= (Tvector.Diff(self.pos, v).abssqr)  < pot2(self.r);
end;

function Tcircle.in_kreis(k : Tcircle) : Boolean;
begin
    Result:= (Tvector.Diff(self.pos, k.pos).abssqr)  < pot2(self.r + k.r);
end;
function Tcircle.in_kreis_ganz(k : Tcircle) : Boolean;
begin
    Result:= (self.r > k.r) and
             ((Tvector.Diff(self.pos, k.pos).abssqr) < pot2(self.r - k.r)) ;
end;

function Tcircle.auf_umkreis(k : Tcircle) : Boolean;
var dist : Real;
begin
    dist:= (Tvector.Diff(self.pos, k.pos).abssqr);
    Result:= (dist < pot2(self.r + k.r)) and (dist > pot2(self.r - k.r))
end;

function Tkreis.distance_to(v : Tvector) : Tvector;
var d : Real;
begin
    Result:= Tvector.Diff(v, self.pos);
    d:= Result.Abs;
    Result.mul((d - self.r) / d);
end;

function Tkreis.distance_to(k : Tcircle) : Tvector;
var d : Real;
begin
    Result:= Tvector.Diff(k.pos, self.pos);
    d:= Result.Abs;
    Result.mul((d - self.r - k.r) / d);
end;

function Tkreis.distance_to(w : Twall)   : Tvector;
var d : Real;
begin
    Result:= w.distance_from(self.pos);
    d:= Result.Abs;
    if d <> 0 then
        Result.mul((d - self.r) / d);
end;

end.
