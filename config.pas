unit config;

interface
uses graphics, math;

const
e= 2.7182818284590451;
//////////////////////////////   Allgemeines   ////////////////////////////////
// Farben
rot   = 1;
gruen = 256;
blau  = 256 * 256;
farbenprimzahl = 1158251;
maxfarbe = 255 * rot + 255 * gruen + 255 * blau;
inc_maxfarbe = maxfarbe + 1;

//////////////////////////////   Oberfläche   /////////////////////////////////
///////////    wall
wallbreite = 13;
wallfarbe = rot * 58 + gruen * 112 + blau * 5;
wallanteil = 0.3;
minwallbreite= 4;
///////////    schieber
schieberstartlaenge = 60;
minschieberstartlaenge= 5;
schieberwidth= 4;
minschieberwidth= 3;
elastizitaet= -0.33;
schieberwb= 1;
minschieberwb= 0;
punkteradius= 20;

///////////    Zahlen
zahlenv= 40;
spaltwinkel= pi - 0.2;
zahlenr_pro_ziffer= 3;
minzahlenr= 4 ;


///////////    Spielfeld
spielfeldr2= 40;
teilerzahl= 2;
spielfeldabstand= 10;
spielfeldrotation= 0.004; // 2pi*umdrehungen/sekunde

///////////    Main
countdownstarttime= 20;

///                     TEST
spieleranz= 0;


implementation

end.
