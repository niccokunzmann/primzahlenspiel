unit VE;

interface

type TVector = class                               // Kartesischer 2D-Vektor
     public
         x, y: real;

         constructor Create(x, y: real);           // Neuen Vektor erzeugen
         constructor Clone(a: TVector);            // Vektor a klonen

         function Abs(): real;                     // Betrag
         function AbsSqr(): real;                  // Quadrat des Betrags

         procedure Add(a: TVector);                // Addiere mir a
         procedure Sub(a: TVector);                // Ziehe a von mir ab
         procedure Mul(n: Real);                   // Multipliziere mich mit n
         procedure Unify();                        // Mach mich Einheitsvektor
         procedure Zerofy();                       // Mach mich Nullvektor

         // Neue Vektoren erstellen aus...
         class function Sum(a, b: TVector): TVector;        // a + b
         class function Diff(a, b: TVector): TVector;       // a - b
         class function Prod(a: TVector; n: real): TVector; // a * n

         // Skalarprodukt a • b
         class function Scalar(a, b: TVector): Real;

     end;

function Vector(x, y: real): TVector;

implementation

constructor TVector.Create(x, y: real);
begin
     Self.x := x;
     Self.y := y;
end;

function Vector(x, y: real): TVector;
begin
     Vector := TVector.Create(x, y);
end;

constructor TVector.Clone(a: TVector);
begin
     Self.x := a.x;
     Self.y := a.y;
end;

function TVector.Abs(): real;
begin
     Abs := sqrt(Self.AbsSqr);
end;

function TVector.AbsSqr(): real;
begin
     AbsSqr := x * x + y * y;
end;

procedure TVector.Add(a: TVector);
begin
     Self.x := Self.x + a.x;
     Self.y := Self.y + a.y;
end;

procedure TVector.Sub(a: TVector);
begin
     Self.x := Self.x - a.x;
     Self.y := Self.y - a.y;
end;

procedure TVector.Mul(n: Real);
begin
     Self.x := Self.x * n;
     Self.y := Self.y * n;
end;

procedure TVector.Unify();
var s: Real;
begin
     s := Self.Abs;
     Self.x := Self.x / s;
     Self.y := Self.y / s;
end;

procedure TVector.Zerofy();
begin
     Self.x := 0;
     Self.y := 0;
end;

class function TVector.Sum(a, b: TVector): TVector;
begin
     Sum := TVector.Create(a.x + b.x, a.y + b.y);
end;

class function TVector.Diff(a, b: Tvector): TVector;
begin
     Diff := TVector.Create(a.x - b.x, a.y - b.y);
end;

class function TVector.Scalar(a, b: TVector): Real;
begin
     Scalar := a.x * b.x + a.y * b.y;
end;

class function TVector.Prod(a: Tvector; n: Real): TVector;
begin
     Prod := TVector.Create(a.x * n, a.y * n);
end;

end.
 