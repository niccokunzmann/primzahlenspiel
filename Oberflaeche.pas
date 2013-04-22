unit Oberflaeche;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, math,
  Kreis, Zahl, Spielfeld2, Spielerfeld, Schieber, wall, Darstellbares,
  StdCtrls, zeichnen, funktionen, VE, config, Spin, spieler, spielfeld;

type
  TForm1 = class(TForm)
    primzahlentest: TGroupBox;
    SpinEdit1: TSpinEdit;
    Button1: TButton;
    Label1: TLabel;
    Button2: TButton;
    SpinEdit2: TSpinEdit;
    Timer1: TTimer;
    Image1: TImage;
    cbpause: TCheckBox;
    gbsteuerung: TGroupBox;
    spielernummernlabel: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    farbenlabel: TLabel;
    linksknopf: TButton;
    rechtsknopf: TButton;
    Button5: TButton;
    Button6: TButton;
    gbeinstellungen: TGroupBox;
    Label2: TLabel;
    Label7: TLabel;
    cbleicht: TRadioButton;
    cbmittel: TRadioButton;
    cbschwer: TRadioButton;
    cbirre: TRadioButton;
    cbueben: TRadioButton;
    cbirreirre: TRadioButton;
    schluss: TSpinEdit;
    maxzahl: TSpinEdit;
    cbzufallsende: TCheckBox;
    gbgewonnen: TGroupBox;
    Label15: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    Label19: TLabel;
    Label20: TLabel;
    seschlussgewonnen: TSpinEdit;
    semaxzahlgewonnen: TSpinEdit;
    bugewonnenok: TButton;
    meersteHilfe: TMemo;
    procedure FormCreate(Sender: TObject);
    procedure Image1Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure rechtsknopfKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure linksknopfKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure cbuebenClick(Sender: TObject);
    procedure cbpauseClick(Sender: TObject);
    procedure bugewonnenokClick(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  Form1: TForm1;

implementation
const tab = Char(9);

{$R *.DFM}

type Tspielerzahlarray = array of Tspielernummer;
     Tbewertung = Integer;

var xetwas : TDarstellbares;
    xkreis : TKreis;
    xzahl : Tzahl;
    xwall : Twall;
    xspielfeld2 : Tspielfeld2;

    xtaste : Ttasten;

    spielend : Boolean;
    lastzahlenadd : Real;
    test : Integer;
    g_maxzahl, g_m_old, g_schluss, g_s_old : Integer;

    letzte_ausgaben, ausgabenbreite: Integer; // pxl


///////////////// mein zeug //////////////////////
// erstellen
procedure erstelle_spielerabfrage;
begin
    Form1.spielernummernlabel.caption:= 'Spieler: ' + inttostr(xspielfeld2.spielerzahl);
    Form1.farbenlabel.color:= funktionen.spielerfarbe(xspielfeld2.spielerzahl);
    Form1.linksknopf.Caption:= Char(xtaste.links);
    Form1.rechtsknopf.Caption:= Char(xtaste.rechts);
    if xspielfeld2.spielerzahl = 0 then
        Form1.Button5.Visible:= False
    else
        Form1.Button5.Visible:= True;
end;

procedure erstelle_spieler;
var s : Tspieler;
begin
    s:= xspielfeld2.add_spieler;
    s.tasten:= xtaste;
end;

// ...
function jetzt : Real;
begin
    Result:= xspielfeld2.zeitgeber.mytime;
end;

function zahlen : Integer;
begin
    Result:= xspielfeld2.zahlen.count;
end;
function spielerzahl : Integer;
begin
    Result:= xspielfeld2.spielerzahl;
end;

procedure add_zahl;
begin
    xspielfeld2.add_zahl;
    lastzahlenadd:= jetzt;
end;

procedure add_zahlen;
begin
    if zahlen > spielerzahl * 10 + 10 then
        exit
    else if form1.cbueben.checked then
    begin
        if zahlen < 2 then
             add_zahl;
    end
    else if form1.cbleicht.checked then
    begin
        if ((zahlen < spielerzahl + 3) or (lastzahlenadd < (time - 4)))
        and (lastzahlenadd < jetzt - 5) then
             add_zahl;
    end
    else if form1.cbmittel.checked then
    begin
        if ((zahlen < spielerzahl * 1.5 + 4) or (lastzahlenadd < (time - 3 / spielerzahl + 1)))
           and (lastzahlenadd < jetzt - 2) then
             add_zahl;
    end
    else if form1.cbschwer.checked then
    begin
        if ((zahlen < spielerzahl * 2 + 6) or (lastzahlenadd < (time - 2.1 / spielerzahl + 0.3)))
            and (lastzahlenadd < jetzt - 1.3) then
             add_zahl;
    end
    else if form1.cbirre.checked then
    begin
        if ((zahlen < spielerzahl * 3 + 8) or (lastzahlenadd < (time - 1.5 / spielerzahl + 0.1)))
            and (lastzahlenadd < jetzt - 0.5) then
             add_zahl;
    end;
    if form1.cbirreirre.checked then
    begin
        if ((zahlen < spielerzahl * 3 + 7) or (lastzahlenadd < (time - 2 / spielerzahl + 0.1)))
            and (lastzahlenadd < jetzt - 0.5) then
             add_zahl;
        if xspielfeld2.zeitgeber.stretch <> 0 then
            xspielfeld2.zeitgeber.set_stretch(2);
    end
    else if xspielfeld2.zeitgeber.stretch <> 0 then
        xspielfeld2.zeitgeber.set_stretch(1);

end;

function Bewertung(spieler: Tspieler) : Tbewertung;
begin
    if spieler.durch_ges <> 0 then
        Result:= trunc(spieler.get_punkte * (spieler.durch_prim /spieler.durch_ges))
    else
        Result:= spieler.get_punkte;
end;

function center(const s : string; l : Word) : string;
var i : Integer;
begin
    Result:= copy(s, 0, length(s));
    for i:= 0 to (l - Length(s) - 1) do
        if (i mod 2) = 0 then
            Result:= Result + ' '
        else
            Result:= ' ' + Result;
end;

function rangfolge : Tspielerzahlarray;
var tauschbw : Tbewertung;
    bw : Array of Tbewertung;
    i, j : Integer;
    tauschi : Tspielernummer;
begin
    if xspielfeld2.spielerzahl = 0 then
        exit;
    setlength(Result, xspielfeld2.spielerzahl);
    setlength(bw, xspielfeld2.spielerzahl);
    for i := 0 to xspielfeld2.spielerzahl - 1 do
    begin
        bw[i]:= bewertung(xspielfeld2.spieler.items[i]);
        Result[i]:= i;
    end;
    // minimumsort
    for j := 0 to xspielfeld2.spielerzahl - 1 do
    begin
        for i := j + 1 to xspielfeld2.spielerzahl - 1 do
        begin
            if bw[i] > bw[j] then
            begin
                tauschbw:= bw[i];
                bw[i]:= bw[j];
                bw[j]:= tauschbw;
                tauschi:= Result[i];
                Result[i]:= Result[j];
                Result[j]:= tauschi;
            end;
        end;
    end;
end;

function minausgabenheight : Integer;
begin
    Result:= 0;
    if form1.gbeinstellungen.visible then
        Result:= form1.gbeinstellungen.top + form1.gbeinstellungen.height
    else if form1.gbsteuerung.visible then
        Result:= form1.gbsteuerung.top + form1.gbsteuerung.height
    else if form1.cbpause.visible then
        Result:= form1.cbpause.top + form1.cbpause.height;
        Result:= Result + config.spielfeldabstand;
end;

function ausgaben_x : Integer;
begin
    Result:= trunc(xspielfeld2.pos.x + xspielfeld2.r + config.spielfeldabstand + xspielfeld2.r2);
end;
function ausgaben_y : Integer;
var ma : Integer;
begin
    ma:= minausgabenheight;
    if letzte_ausgaben < ma then
        letzte_ausgaben:= ma;
    Result:= letzte_ausgaben;
end;

procedure ausgabe(const s : String);
var x, y, ab : Integer;
begin
    x:= ausgaben_x;
    y:= ausgaben_y;
    form1.image1.canvas.textout(x, y, s);
    letzte_ausgaben:= letzte_ausgaben + form1.image1.canvas.TextHeight(s);
    ab:= form1.Image1.canvas.TextWidth(s);
    if ab > ausgabenbreite then
        ausgabenbreite:= ab;
end;

procedure leere_ausgabe;
var x: Integer;
begin
    x:= ausgaben_x;
    zeichnen.normalisiere(form1.image1.canvas);
    with form1.image1.canvas do
    begin
        pen.Width:= 0;
        pen.color:= brush.color;
        rectangle(x, minausgabenheight, x + ausgabenbreite, ausgaben_y);
    end;
    letzte_ausgaben:= minausgabenheight;
end;


procedure act_guete;
var i, j : Integer;
    spieler : Tspieler;
    rf : Tspielerzahlarray;
begin
    leere_ausgabe;
    ausgabe(center('X', 10) + tab +
            center('P', 10) + tab +
            center('Ges.', 10) + tab +
            center('Prim', 10) + tab +
            center('Bewertung', 10));
    rf:= rangfolge;
    for j:= 0 to xspielfeld2.spielerzahl - 1 do
    begin
        i:= rf[j];
        spieler:= xspielfeld2.spieler.items[i];
        form1.image1.canvas.Brush.Color:= spieler.schieber.color;
        ausgabe(center(inttostr(i), 10) + tab +
                center(inttostr(spieler.get_punkte), 10) + tab +
                center(inttostr(spieler.durch_ges), 10) + tab +
                center(inttostr(spieler.durch_prim), 14) + tab +
                center(inttostr(Bewertung(spieler)), 14));

    end;
end;

function spielende : Boolean;
begin
    Result:= ((g_schluss <> 0) and (g_schluss < jetzt)) or
             ((g_maxzahl <> 0) and (g_maxzahl <= xspielfeld2.letzte_zahl))
end;

procedure erstelle_spielfeld;
var x, y, r : Real;
begin
    x:= (form1.Image1.width) / 2;
    y:= (form1.Image1.height)  / 2;
    if x > y then
        r:= y
    else
        r:= x;
    xspielfeld2 := TSpielfeld2.create(r, r, r - config.spielfeldabstand - config.spielfeldr2, clSilver);
    xspielfeld2.zeitgeber.set_stretch(0);
end;

procedure bereite_spiel_vor;
var i : Integer;
    spieler : Tspieler;
    wall : Twall;
begin
    for i:= 0 to xspielfeld2.spielerzahl - 1 do
    begin
        spieler:= xspielfeld2.spieler.items[i];
        spieler.schieber.width:= (config.schieberwidth - config.minschieberwidth) / spielerzahl + minschieberwidth;
        spieler.schieber.set_laenge((config.schieberstartlaenge - config.minschieberstartlaenge) / spielerzahl + config.minschieberstartlaenge);
        wall:= xspielfeld2.wall.items[i];
        wall.width:= (config.wallbreite - config.minwallbreite) / spielerzahl + config.minwallbreite;
    end;
end;


procedure _pausenschalten;
begin
    leere_ausgabe;
    if form1.cbpause.checked then
    begin
        xspielfeld2.zeitgeber.set_stretch(0);
        form1.gbeinstellungen.visible:= True;
    end
    else
    begin
        xspielfeld2.zeitgeber.set_stretch(1);
        form1.gbeinstellungen.visible:= False;
        form1.SetFocus;
    end;
end;

procedure pausenschalten;
begin
    _pausenschalten;
    form1.cbpause.checked:= not form1.cbpause.checked;
end;

function pause : Boolean;
begin
    Result:= form1.cbpause.checked;
end;

procedure act_countdown;
var dt : Real;
    dt2 : Tvalue;
begin
    if g_schluss = 0 then
        exit;
    dt:= g_schluss - xspielfeld2.zeitgeber.mytime;
    if (dt < config.countdownstarttime) and (dt > 0) then
    begin
        dt2:= Tvalue(ceil(abs(dt)));
        Zeichnen.normalisiere(Form1.Image1.Canvas);
        Form1.Image1.Canvas.Brush.color:= Tcolor(Trunc(abs((dt - trunc(dt)) * 255)) * rot);
        zeichnen.zeichne_kreis(form1.image1.canvas, xspielfeld2.pos, funktionen.zahlenr(dt2));
        zeichnen.zeichne_zahl(form1.image1.canvas, xspielfeld2.pos, 0, dt2);
    end
end;


procedure habe_gewonnen;
begin
    if not pause then
        pausenschalten;
    form1.gbgewonnen.Visible:= True;
    form1.seschlussgewonnen.value:= trunc(g_schluss);
    form1.semaxzahlgewonnen.value:= xspielfeld2.letzte_zahl;
    form1.cbpause.Enabled:= False;
    form1.cbzufallsende.enabled:= True;
end;


procedure randomize_gewinnen;
begin
    g_s_old:= g_schluss;
    g_m_old:= g_maxzahl;
    if form1.maxzahl.value > 0 then
    begin
        g_maxzahl:= form1.maxzahl.value;
    end
    else
    begin
        g_maxzahl:= 0;
        g_m_old:= 0;
    end;
    if form1.schluss.value > 0 then
    begin
        g_schluss:= form1.schluss.value;
    end
    else
    begin
        g_schluss:= 0;
        g_s_old:= 0;
    end;
    if form1.cbzufallsende.checked then
    begin
        g_maxzahl:= g_m_old + trunc((g_maxzahl - g_m_old) * power(e, (random(2) - 1)));
        g_schluss:= g_s_old + trunc((g_schluss - g_s_old) * power(e, (random(2) - 1)));
    end;
end;


procedure verstecke_gewonnen;
begin
    form1.gbgewonnen.Visible:= False;
    form1.cbpause.Enabled:= True;
    form1.cbpause.setfocus;
    if form1.semaxzahlgewonnen.value <= xspielfeld2.letzte_zahl then
        form1.maxzahl.value:= 0
    else
        form1.maxzahl.value:= form1.semaxzahlgewonnen.value;
    if form1.seschlussgewonnen.value <= xspielfeld2.zeitgeber.mytime then
        form1.schluss.value:= 0
    else
        form1.schluss.value:= form1.seschlussgewonnen.value;
    form1.cbzufallsende.enabled:= False;
    randomize_gewinnen;
end;

procedure act_gewonnen;
begin
    if spielende then
    begin
        habe_gewonnen;
    end;
    act_countdown;
end;


procedure act;
begin
    if spielend then
    begin
        add_zahlen;
        xspielfeld2.act;
        xspielfeld2.zeichne(Form1.Image1.canvas);
        act_gewonnen;
    //    xzahl.move;
    //    zeichne;
        Zeichnen.normalisiere(Form1.Image1.Canvas);
        Form1.Image1.Canvas.TextOut(0, 0, inttostr(trunc(xspielfeld2.zeitgeber.mytime)));
        act_guete;
    end;
    spielend:= not form1.cbpause.checked;
end;



///////////////// mein zeug ende    -------------------------------------------




procedure TForm1.FormCreate(Sender: TObject);
begin
    Randomize;
    // kreieren
//    xetwas:= TDarstellbares.create(100, 30, clBlack);
//    xkreis:= TKreis.create(300, 200, 20, clBlack);
//    xzahl := Tzahl.create(500, 220, -6, -4, 20, 10, clTeal, xspielfeld2.zeitgeber);
//    xwall:= Twall.create(530, 150, 600, 190, 20, clgreen);

//    for i := 1 to spieleranz do
//        xspielfeld2.add_spieler;
    erstelle_spielfeld;
    spielend:= False;
    erstelle_spielerabfrage;
    add_zahl;
    g_schluss:= 0;
    g_maxzahl:= 0;
end;

procedure zeichne;
var //jetzt : Real;
    c : Tcanvas;
begin
    xspielfeld2.act;
    c:= Form1.Image1.Canvas;

    // zeichnen
    xetwas.zeichne(c);
    xkreis.zeichne(c);
    xspielfeld2.zeichne(c);
    xzahl.zeichne(c);
    xwall.zeichne(c);
//    jetzt:= xspielfeld2.zeitgeber.mytime;
    xzahl.move;

    c.pen.color:= clBlack;
    //zeichnen.zeichne_wall(c, xzahl.pos, Tvector.Diff(xzahl.pos, funktionen.distance_to(xwall.pos, xwall.pos2, xzahl.pos)), 1)
    zeichnen.zeichne_wall(c, xzahl.pos, Tvector.Sum(xzahl.pos, xwall.distance_to(xzahl.pos)), 1);
    c.pen.color:= clRed;
    zeichnen.zeichne_wall(c, xzahl.pos, Tvector.Sum(xzahl.pos, funktionen.spiegele(tvector.prod(xzahl.v, 5), xwall.distance_to(xzahl.pos))), 1) ;
    c.pen.color:= clGreen;
    zeichnen.zeichne_wall(c, xzahl.pos, Tvector.Sum(xzahl.pos, tvector.prod(xzahl.v, 5)), 1)                                                     ;

end;

procedure TForm1.Image1Click(Sender: TObject);
begin
    xspielfeld2.add_zahl;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
    act;
end;

procedure TForm1.Button1Click(Sender: TObject);
var a : TprimzahlenArray;
    i : Integer;
begin
    a:= funktionen.primfaktoren(Form1.SpinEdit1.value);
    Form1.Label1.caption:= 'Primfaktoren: ';
    for i := 0 to Length(a) - 1 do
        Form1.Label1.caption:= Form1.Label1.caption + inttostr(a[i]) + '; '
end;

procedure TForm1.Button2Click(Sender: TObject);
var a : TprimzahlenArray;
    i : Integer;
begin
    a:= funktionen.n_teiler(Form1.SpinEdit1.value, Form1.SpinEdit2.value);
    Form1.Label1.caption:= 'teiler: ';
    for i := 0 to Length(a) - 1 do
        Form1.Label1.caption:= Form1.Label1.caption + inttostr(a[i]) + '; '
end;

procedure TForm1.Button6Click(Sender: TObject);
begin
    erstelle_spieler;
    erstelle_spielerabfrage;
    Form1.linksknopf.SetFocus;
end;

procedure TForm1.Button5Click(Sender: TObject);
begin
//    erstelle_spielfeld;  macht alles wieder weg
    self.gbsteuerung.Visible:= False;
    self.cbzufallsende.Enabled:= False;
    self.SetFocus;
    spielend:= True;
    self.cbpause.Enabled:= True;
    self.cbpause.setfocus;
  //  form1.cbpause.checked:= False;
    self.schluss.enabled:= False;
    self.maxzahl.enabled:= False;
    randomize_gewinnen;
    bereite_spiel_vor;
    self.meersteHilfe.visible:= False;
end;

procedure TForm1.rechtsknopfKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
    xtaste.rechts:= Key;
    erstelle_spielerabfrage;
    Form1.Button6.SetFocus;
end;

procedure TForm1.linksknopfKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
    xtaste.links:= Key;
    erstelle_spielerabfrage;
    Form1.rechtsknopf.SetFocus;
end;

procedure TForm1.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
    if spielend then
        xspielfeld2.taste_druck(key);
end;

procedure TForm1.FormKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
    if spielend then
        xspielfeld2.taste_ab(key);
end;


procedure TForm1.cbuebenClick(Sender: TObject);
begin
    if self.cbpause.Visible and self.cbpause.Enabled then
        self.cbpause.setfocus;
end;



procedure TForm1.cbpauseClick(Sender: TObject);
begin
    _pausenschalten;
end;

procedure TForm1.bugewonnenokClick(Sender: TObject);
begin
    verstecke_gewonnen;
end;

end.








