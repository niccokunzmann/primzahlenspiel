unit Physics;

interface
uses VE, classes;

type
     TBall = class
     public
        Position: TVector;
        Velocity: TVector;
        Color: Integer;
        Radius, Mass: Real;
        constructor Create(x, y, mass, radius: real);
     protected
        procedure Move();
        procedure MoveBack();
        procedure Force(F: TVector);
     private end;

     TWall = record
           Top, Left, Width, Height: real;
           end;

     TTargetCallback = procedure (ball, target: TBall) of object;
     TCollisionCallback = procedure (b1, b2: TBall) of object;

     TEnviron = class
     public
        Width, Height, Resistance: Real;
        Balls: TList;
        Targets: TList;
        Score, Level: integer;

        OnTarget: TTargetCallback;
        OnCollide: TCollisionCallback;

        constructor Create(width, height: real);
        procedure Move();
        function TryPlace(b: TBall): boolean;
        function TryFind(x, y: Real): TBall;
        procedure CreateTargets(count: integer);

     private
        //function Collision(a, b: TBall): boolean;
     end;


implementation

(* TBall ........................... *)

constructor TBall.Create(x, y, mass, radius: real);
begin
     Self.Position := TVector.Create(x, y);
     Self.Velocity := TVector.Create(0, 0);
     Self.Mass := mass;
     self.Radius := radius;
     self.Color := 0;
end;

procedure TBall.Move();
begin
     Position.Add(Velocity);
end;

procedure TBall.Force(F: TVector);
begin
     Velocity.Add(TVector.Prod(F, 1. / Mass));
end;

procedure TBall.MoveBack();
begin
     Position.Sub(Velocity);
end;

(* TEnviron ........................ *)

function BallCollision(b1, b2: TBall): boolean; forward;
procedure ComputeCollision(b1, b2: TBall); forward;
function PerimetricCollision(b1, b2: TBall): boolean; forward;

constructor TEnviron.Create(width, height: real);
begin
     Self.Balls := TList.Create;
     Self.Width := width;
     Self.Height := height;
     Self.Score := 0;
     Self.Level := 1;
     Self.Resistance := 0.01;
     Self.OnTarget := nil;
     Self.OnCollide := nil;
     CreateTargets(level);
end;

procedure TEnviron.Move();
var i, k: integer;
    ball, other, target: TBall;
    WallCollisionLeft, WallCollisionRight,
    WallCollisionTop, WallCollisionBottom: Boolean;
    Removal: TList;
    Hit: TList;
begin
     Removal := TList.Create;
     Hit := TList.Create;

     if Balls.Count > 0 then begin
        for i := 0 to Balls.Count - 1 do begin
            ball := Balls[i];
            ball.Move;

            // Kollision mit den Bildschirmrändern erkennen

            (*WallCollisionLeft   := (ball.Position.x <= -ball.Radius);
            WallCollisionRight  := (ball.position.x > self.Width + ball.Radius);
            WallCollisionTop    := (ball.Position.y <= -ball.Radius);
            WallCollisionBottom := (ball.Position.y > self.Height + ball.Radius);

            if  WallCollisionLeft or WallCollisionRight or
                WallCollisionTop or WallCollisionBottom then begin
                ball.MoveBack;

                if WallCollisionLeft then
                   ball.Position.x := self.Width + ball.Radius - 1;
                if WallCollisionRight then
                   ball.Position.x := 1 - ball.Radius;
                if WallCollisionTop then
                   ball.Position.y := self.Height + ball.Radius - 1;
                if WallCollisionBottom then
                   ball.Position.y := 1 - ball.Radius;
            end; *)

            WallCollisionLeft := (ball.Position.x <= ball.Radius) or
                                 (ball.position.x > self.Width - ball.Radius);
            WallCollisionTop  := (ball.Position.y <= ball.Radius) or
                                 (ball.Position.y > self.Height - ball.Radius);
            if WallCollisionLeft or WallCollisionTop then begin
               ball.MoveBack;
               if WallCollisionLeft then ball.Velocity.x := -ball.velocity.x;
               if WallCollisionTop  then ball.Velocity.y := -ball.velocity.y;
            end;


            // Kollision der Kugeln untereinander erkennen

            for k := 0 to Balls.Count - 1 do
                if k <> i then begin
                   other := Balls[k];
                   if PerimetricCollision(ball, other) then begin
                      while PerimetricCollision(ball, other) do ball.MoveBack;
                      ComputeCollision(ball, other);
                      OnCollide(ball, other);
                   end;
                end;

            // Erreichen eines Ziels erkennen

            for k := 0 to Targets.Count - 1 do begin
                target := Targets[k];
                if BallCollision(ball, target) then begin
                   Removal.Add(ball);
                   Hit.Add(target);
                end;
            end;

            ball.Velocity.Mul(1 - resistance);
            if (ball.Velocity.AbsSqr < 0.01) then ball.Velocity.Zerofy;
        end;
     end;

     // Ziel-Treffer ausloesen

     if Removal.Count > 0 then
        for k := 0 to Removal.Count - 1 do
            OnTarget(Removal[k], Hit[k]);
end;

function TEnviron.TryPlace(b: TBall): boolean;
var placeable: boolean;
    i: integer;
begin
     placeable := (b.position.x > b.radius) and
                  (b.position.x < self.width - b.radius) and
                  (b.position.y > b.radius) and
                  (b.position.y < self.height - b.radius);
     if placeable and (self.Balls.Count > 0) then begin
        for i := 0 to self.Balls.Count - 1 do
            placeable := placeable and (not PerimetricCollision(self.Balls[i], b));
     end;
     if placeable then self.Balls.Add(b);
     TryPlace := placeable
end;

function TEnviron.TryFind(x, y: real): TBall;
var i: integer;
    b: TBall;
    v: Tvector;
begin
     TryFind := nil;
     if Balls.Count > 0 then begin
        v := Vector(x, y);
        for i := 0 to Balls.Count - 1 do begin
            b := Balls[i];
            if TVector.Diff(v, b.Position).Abs <= b.Radius then
               TryFind := b;
        end;
     end;
end;

procedure TEnviron.CreateTargets(count: integer);
var t: TBall;
    i: integer;
begin
     Targets := TList.Create;
     for i := 0 to count - 1 do begin
         t := TBall.Create(width / (count + 1) * (i + 1), 0, 1, 24);
         t.Color := i;
         Targets.Add(t)
     end;
end;

function BallCollision(b1, b2: TBall): boolean;
var rsum: real;
begin
     rsum := b1.Radius + b2.Radius;
     BallCollision := TVector.Diff(b1.Position, b2.Position).AbsSqr
                      <= rsum * rsum;
end;

function PerimetricCollision(b1, b2: TBall): boolean;
var rsum, rdiff, diffq: real;
begin
     rsum := b1.Radius + b2.Radius;
     rdiff := b1.Radius - b2.Radius;
     diffq := TVector.Diff(b1.Position, b2.Position).AbsSqr;
     PerimetricCollision := (diffq >= rdiff * rdiff) and (diffq <= rsum * rsum);
end;

// Kollision in der Ebene
procedure ComputeCollision(b1, b2: TBall);
var n, t: TVector;
    v1n, v1t, v2n, v2t, v1n2, v2n2, msum: Real;
begin
     // Bestimmen der Kollisions-Tangente und -Normale
     n := TVector.Diff(b1.Position, b2.Position);
     n.Unify;
     t := TVector.Create(-n.y, n.x);

     // Zerlegung in Tangential- und Normal-Komponenten
     v1n := TVector.Scalar(b1.Velocity, n);
     v1t := TVector.Scalar(b1.Velocity, t);
     v2n := TVector.Scalar(b2.Velocity, n);
     v2t := TVector.Scalar(b2.Velocity, t);

     // Eindimensionaler Elastischer Stoß entlang der Normalen
     msum := b1.Mass + b2.Mass;
     v1n2 := (v1n * (b1.Mass - b2.Mass) + 2 * b2.mass * v2n) / msum;
     v2n2 := (v2n * (b2.Mass - b1.Mass) + 2 * b1.mass * v1n) / msum;

     // Zusammensetzen der Bewegung
     b1.Velocity := TVector.Sum(TVector.Prod(n, v1n2), TVector.Prod(t, v1t));
     b2.Velocity := TVector.Sum(TVector.Prod(n, v2n2), TVector.Prod(t, v2t));

end;

end.
