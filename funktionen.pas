unit funktionen;

interface
uses VE, config, graphics, math, Classes;

type Tvalue = LongWord;
     TprimzahlenArray = Array of Tvalue;

function pot2(x : Real) : Real;       overload;
function pot2(i : Integer) : Integer; overload;
// => x hoch 2

function pot(x : Real; n : Integer) : Real;    overload;
// => x hoch n

function pow(i, exp, m : Integer) : Integer;
// => i hoch exp modulo m

function primzahltest(zahl : Tvalue) : Boolean;
// => True, wenn primzahl

function primfaktoren(zahl : Tvalue) : Tprimzahlenarray;
// => liste mit allen primfaktoren

procedure shuffle(var pza : Tprimzahlenarray);
// mischt die liste

function n_teiler(zahl : Tvalue; n : Integer) : Tprimzahlenarray;
// liefert eine liste von max. n teilern der zahl zurück, die multipliziert
// die zahl selbst ergeben

function distance_to(q, p, v : Tvector) : Tvector;
// => Abstand des Punktes P von der Geraden G(G1, G2)
// p + Result = ist der Schnittpunkt

function smaller(v1, v2 : TVector) : Boolean;
// v1 < v2

function is_zero(v : Tvector) : Boolean;
// => ob vector 0 ist

function spiegele(v, p : Tvector) : Tvector;
// spiegelt v an p

function randomvector(r : Real) : Tvector;

function spielerfarbe(i : Integer) : Tcolor;

function zahlenfarbe(i : Integer) : Tcolor;

function fill_up(color : Tcolor; max : Integer) : Tcolor;

function ausrichten(v, nach : Tvector) : Tvector;

function drehe(v : Tvector; w : Extended) : Tvector;

function zahlenr(v : Tvalue) : Real;

implementation

var primzahlen : TprimzahlenArray;

function pot2(x : Real) : Real;
begin
    Result:= x * x;
end;

function pot2(i : Integer) : Integer;
begin
    Result:= i * i;
end;

function pot(x : Real; n : Integer) : Real;
begin
    Result:= 1;
    while n > 0 do
    begin
        if (n and 1) = 1 then
        begin
            Result:= Result * x;
            dec(n);
        end
        else
        begin
            x:= x * x;
            n:= n div 2;
        end;
    end;

end;
function pow(i, exp, m : Integer) : Integer;
begin
    Result:= 1;
    while exp > 0 do
    begin
        if (exp and 1) = 1 then
        begin
            Result:= (Result * i) mod m;
            dec(exp);
        end
        else
        begin
            i:= (i * i) mod m;
            exp:= exp div 2;
        end;
    end;

end;

procedure add_primzahlen_bis_wurzel(zahl : Tvalue); forward;

function primzahltest2(zahl : Tvalue) : Boolean;
var i : Integer;
    z : Tvalue;
begin
    i:= 0;
    Result:= False;
    z:= primzahlen[i];
    while z * z <= zahl do
    begin
        if zahl mod z = 0 then
            exit;
        inc(i);
        z:= primzahlen[i];
    end;
    Result:= True;
end;

function primzahltest(zahl : Tvalue) : Boolean;
begin
    add_primzahlen_bis_wurzel(zahl);
    Result:= primzahltest2(zahl);
end;

procedure add_primzahlen_bis_wurzel(zahl : Tvalue);
var p2 : Tvalue;
    l : Integer;
begin
    if Length(primzahlen) <= 0 then
    begin
        setLength(primzahlen, 2);
        primzahlen[0]:= 2;
        primzahlen[1]:= 3;
    end;
    l:= Length(primzahlen);
    p2:= primzahlen[l - 1];
    while p2 * p2 < zahl do
    begin
        p2:= p2 + 2;
        if primzahltest2(p2) then  // add primzahl
        begin
            SetLength(primzahlen, l + 1);
            primzahlen[l]:= p2;
            inc(l);
        end;
    end;
end;

procedure add_primzahlen_bis(zahl : Tvalue);
begin
    add_primzahlen_bis_wurzel(zahl * zahl);
end;


function primfaktoren(zahl : Tvalue) : Tprimzahlenarray;
var i, l : Integer;
    p2 : Tvalue;
begin
    i:= 0;
    l:= 0;
    add_primzahlen_bis(zahl);
    while zahl > 1 do
    begin
        p2:= primzahlen[i];
        if ((zahl mod p2) = 0) then
        begin
            Setlength(Result, l + 1);
            Result[l]:= p2;
            inc(l);
            zahl:= zahl div p2;
        end
        else inc(i);
    end;
end;

procedure tausche(var p1, p2 : Tvalue);
var a : Tvalue;
begin
    a:= p1;
    p1:=p2;
    p2:= a;
end;

procedure shuffle(var pza : Tprimzahlenarray);
var i, l : Integer;
begin
    l:= Length(pza) - 1;
    for i := 0 to l do
        tausche(pza[i], pza[trunc(random(l))]);
end;

function n_teiler(zahl : Tvalue; n : Integer) : Tprimzahlenarray;
var i, i2, last : Integer;
begin
    Result:= primfaktoren(zahl);
    shuffle(Result);
    last:= Length(Result) - 1;
    for i := 1 to Length(Result) - n do
    begin
        i2:= trunc(random(n));
        Result[i2]:= Result[i2] * Result[last];
        dec(last);
    end;
    setLength(Result, n)
end;

function distance_to(q, p, v : Tvector) : Tvector;
var b : Real;
begin
    p:= Tvector.Diff(p, q);
    v:= Tvector.Diff(v , q);
    b:= (p.y * v.x - p.x * v.y) / p.abssqr;
    Result:= Tvector.create(p.y * b, -p.x * b);
end;

function smaller(v1, v2 : TVector) : Boolean;
begin
    Result:= (v1.x < v2.x) and (v1.y < v2.y)
end;

function is_zero(v : Tvector) : Boolean;
begin
    Result:= (v.x = 0) and (v.y = 0);
end;

function spiegele(v, p : Tvector) : Tvector;
var a : Real;
begin
    if is_zero(p) then
    begin
        Result:= Tvector.Prod(v, -1);
        exit;
    end;
    a := (v.x * p.y - v.y * p.x) / p.abssqr * 2;
    Result:= Tvector.create(v.x - a * p.y, v.y + a * p.x);
end;

function spielerfarbe(i : Integer) : Tcolor;
begin
    Result:= fill_up(pow(config.farbenprimzahl, i, inc_maxfarbe), 200);
end;

function zahlenfarbe(i : Integer) : Tcolor;
begin
    Result:= fill_up(pow(config.farbenprimzahl, i, inc_maxfarbe), 255);
end;

function randomvector(r : Real) : Tvector;
var x, y : Extended;
begin
    math.SinCos(2 * pi * random, x, y);
    Result:= Tvector.create(x * r, y * r);
end;

function fill_up(color : Tcolor; max : Integer) : Tcolor;
var r, g, b : Tcolor;
    m : Real;
begin
    r:= (rot * 255 and color) div rot;
    g:= (gruen * 255 and color) div gruen;
    b:= (blau * 255 and color) div blau;
    // in r den maximalen farbwert
    m:= r;
    if g > m then
        m:= g;
    if b > m then
        m:= b;
    m:= max / m;
    Result:= trunc(r * m) * rot + trunc(g * m) * gruen + trunc(b * m) * blau;
end;

function ausrichten(v, nach : Tvector) : Tvector;
var ab : Real;
begin
    ab:= sqrt(v.AbsSqr / nach.abssqr);
    Result:= Tvector.create(nach.x * ab, nach.y * ab);
end;

function drehe(v : Tvector; w : Extended) : Tvector;
var sin, cos : Extended;
begin
    sincos(w, sin, cos);
    Result:= Tvector.create(sin * v.y + cos * v.x, cos * v.y - sin * v.x);
end;

function zahlenr(v : Tvalue) : Real;
begin
    Result:= config.minzahlenr + config.zahlenr_pro_ziffer * (1+ math.Log10(v + 0.0001));
end;





end.
