unit Zahl;

interface
uses VE, Kreis, zeitgeber, funktionen, Zeichnen, wall, 
     graphics, SysUtils;

type
    Tvalue = funktionen.Tvalue;
    TZahl = class(Tcircle)
    public
        value : Tvalue;
        v, lastpos : Tvector;
        t0 : Tzeit;

        zeitgeber : Tzeitgeber;

        constructor create(x, y, vx, vy : Real; r : Tradian; value : Tvalue; color : Tcolor; zeitgeber : Tzeitgeber); overload;
        constructor clone(other : TZahl);

        procedure zeichne(canvas : Tcanvas);
        procedure act;

        // bewegung
        function get_nextpos : Tvector;
        procedure move;

        function Velocity : Tvector;
        function Position : Tvector;

        function distance_to(v : Tvector) : Tvector;  overload;
        function distance_to(z : Tzahl) : Tvector;    overload;
        function distance_to(w : Twall) : Tvector;    overload;


    protected


    end;


implementation

constructor TZahl.create(x, y, vx, vy : Real; r : Tradian; value : Tvalue; color : Tcolor; zeitgeber : Tzeitgeber);
begin
    inherited create(x, y, r, color);
    self.v:= Tvector.Create(vx, vy);
    self.value:= value;
    self.zeitgeber:= zeitgeber;
    self.t0:= self.zeitgeber.mytime;
end;

constructor TZahl.clone(other : TZahl);
begin
    self:= self.create(other.pos.x, other.pos.y, other.v.x, other.v.y, other.r, other.value, other.color, other.zeitgeber);
end;

procedure TZahl.zeichne(canvas : Tcanvas);
begin
    inherited zeichne(canvas);
    Zeichnen.zeichne_zahl(canvas, self.pos, self.r, self.value);
end;


  //        Bewegung        //
function TZahl.get_nextpos : Tvector;
begin
    Result:= Tvector.sum(self.pos,
                        Tvector.prod(self.v, t0 - self.zeitgeber.mytime)
                        )
end;

procedure TZahl.move;
begin
    self.lastpos:= self.pos;
    self.pos:= self.get_nextpos;
    self.t0:= self.zeitgeber.mytime
end;

function Tzahl.Velocity : Tvector;
begin
    Result:= self.v;
end;
function Tzahl.Position : Tvector;
begin
    Result:= self.pos;
end;

function Tzahl.distance_to(v : Tvector) : Tvector;
var d : Real;
begin
    Result:= Tvector.Diff(v, self.pos);
    d:= Result.Abs;
    if d <> 0 then
        Result.mul((d - self.r) / d);
end;

function Tzahl.distance_to(z : Tzahl) : Tvector;
var d : Real;
begin
    Result:= Tvector.Diff(z.pos, self.pos);
    d:= Result.Abs;
    if d <> 0 then
        Result.mul((d - self.r - z.r) / d);
end;

function Tzahl.distance_to(w : Twall) : Tvector;
var d : Real;
begin
    Result:= w._distance_from(self.pos);
    d:= Result.Abs;
    if d <> 0 then
        Result.mul((d - self.r - w.width) / d);
end;

procedure Tzahl.act;
begin
    inherited act;
    self.move;
end;


end.
 