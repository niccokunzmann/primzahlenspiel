unit wall;

interface
uses Darstellbares, VE, funktionen, Zeichnen, 
     graphics;

type Twall = class(Tdarstellbares)
     public
         pos2 : Tvector;
         width : Real;

         constructor create(x1, y1, x2, y2, width : Real; color : Tcolor); overload;
         constructor create(pos, pos2 : Tvector; width : Real; color : Tcolor); overload;

         function distance_from(v : Tvector) : Tvector; overload;
         // abstand von v zu wall
         function _distance_from(v : Tvector) : Tvector; overload;
         // abstand von v zu wall ohne width
         function distance_to(v : Tvector) : Tvector; overload;
         // abstand von wall zu v

         procedure zeichne(canvas : Tcanvas);

     end;

implementation
constructor Twall.create(x1, y1, x2, y2, width : Real; color : Tcolor);
begin
    inherited create(x1, y1, color);
    self.width:= width;
    self.pos2:= Tvector.create(x2, y2);
end;
constructor Twall.create(pos, pos2 : Tvector; width : Real; color : Tcolor);
begin
    self:= self.create(pos.x, pos.y, pos2.x, pos2.y, width, color);
end;

procedure Twall.zeichne(canvas : Tcanvas);
begin
    inherited zeichne(canvas);
    Zeichnen.zeichne_wall(canvas, self.pos, self.pos2, self.width);
end;

function Twall._distance_from(v : Tvector) : Tvector;
var s, p1, p2: Tvector; // s - schnittpunkt

begin
    p1:= self.pos ;
    p2:= self.pos2;
    Result:= funktionen.distance_to(p1, p2, v);//negativer abstand
    s:= Tvector.Diff(v, Result);
// jetzt muss noch getesetet werden, ob der punkt innerhalb von pos, pos2 liegt
    if (((p1.x < s.x) and (s.x < p2.x)) or ((p2.x < s.x) and (s.x < p1.x))) and
       (((p1.y < s.y) and (s.y < p2.y)) or ((p2.y < s.y) and (s.y < p1.y)))
           then
       exit; // tut es
    // sonst muss der abstand zu den Ecken genommen werden. => abstand in p1, p2
    p1:= Tvector.Diff(v, p1);
    p2:= Tvector.Diff(v, p2);
    if p1.AbsSqr < p2.AbsSqr then
        Result:= p1
    else
        Result:= p2;
end;

function Twall.distance_from(v : Tvector) : Tvector;
var d : Real;
begin
    Result:= self._distance_from(v);
    d:= Result.Abs;
    if d <> 0 then                  //sowas muss man noch auslagern (oder nicht)
        Result.mul((d - self.width / 2) / d);

end;

function Twall.distance_to(v : Tvector) : Tvector;
begin
    Result:= self.distance_from(v);
    Result.Mul(-1);
end;

end.
