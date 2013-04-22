unit Zeichnen;

interface

uses graphics, sysutils,
     funktionen, VE;

procedure normalisiere(canvas : Tcanvas);

procedure zeichne_kreis(canvas : Tcanvas; pos : Tvector; r : Real);
procedure zeichne_zahl(canvas : Tcanvas; pos : Tvector; r : Real; value : Tvalue);
procedure zeichne_wall(canvas : Tcanvas; pos1, pos2 : Tvector; width : Real);
procedure zeichne_spielerfeld(canvas : Tcanvas; pos : Tvector; r, alpha, beta : Real);
procedure zeichne_schieber(canvas : Tcanvas; pos1, pos2 : Tvector; width : Real);
procedure text_mittig(canvas : Tcanvas; pos : Tvector; const Text : String);

implementation

procedure zeichne_kreis(canvas : Tcanvas; pos : Tvector; r : Real);
begin
    canvas.Ellipse(trunc(pos.x - r), trunc(pos.y - r),
                   trunc(pos.x + r), trunc(pos.y + r))
end;

procedure zeichne_zahl(canvas : Tcanvas; pos : Tvector; r : Real; value : Tvalue);
var text : String;
begin
    text := inttostr(value);
    canvas.TextOut(trunc(pos.x - canvas.TextWidth(text) / 2),
                   trunc(pos.y - canvas.TextHeight(text) / 2),
                   text); // ob richtig;
end;



procedure zeichne_wall(canvas : Tcanvas; pos1, pos2 : Tvector; width : Real);
begin
    canvas.Pen.Width:= trunc(width);
    canvas.MoveTo(trunc(pos1.x), trunc(pos1.y));
    canvas.LineTo(trunc(pos2.x), trunc(pos2.y));
end;

procedure zeichne_spielerfeld(canvas : Tcanvas; pos : Tvector; r, alpha, beta : Real);
begin
    //nix
end;

procedure zeichne_schieber(canvas : Tcanvas; pos1, pos2 : Tvector; width : Real);
begin
//    zeichne_wall(canvas, pos1, pos2, width)
end;

procedure normalisiere(canvas : Tcanvas);
begin
    canvas.Pen.Width:= 1;
    canvas.Pen.color:= clBlack;
    canvas.Brush.color:= clWhite;
    canvas.Brush.Style:= bsSolid;
end;

procedure text_mittig(canvas : Tcanvas; pos : Tvector; const Text : String);
begin
    canvas.Textout(trunc(pos.x - canvas.TextWidth(Text) / 2),
                   trunc(pos.y - canvas.TextHeight(Text) / 2),
                   Text);
end;


end.
