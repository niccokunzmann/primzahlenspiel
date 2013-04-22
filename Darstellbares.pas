unit Darstellbares;

interface
uses VE, Zeichnen, 
     graphics;

type Tdarstellbares = class(Tobject)
    public
        pos : Tvector;
        color : Tcolor;

        constructor create(x, y: Real; color : Tcolor);    overload;
        constructor create(pos : Tvector; color : Tcolor); overload;
        constructor clone(d : Tdarstellbares);

        procedure zeichne(canvas : Tcanvas);
        procedure act;


    end;

implementation
constructor Tdarstellbares.create(pos : Tvector; color : Tcolor);
begin
    self:= self.create(pos.x, pos.y, color);
end;

constructor Tdarstellbares.create(x, y: Real; color : Tcolor);
begin
    inherited create;
    self.color:= color;
    self.pos:= TVector.create(x, y);
end;

constructor Tdarstellbares.clone(d : Tdarstellbares);
begin
    self.pos:= Tvector.Clone(d.pos);
    self.color:= d.color;
end;

procedure Tdarstellbares.zeichne(canvas : Tcanvas);
begin
    Zeichnen.normalisiere(canvas);
    canvas.Pen.color:=   self.color;
    canvas.Brush.Color:= self.color;
end;

procedure Tdarstellbares.act;
begin
end;

end.
 