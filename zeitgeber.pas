unit zeitgeber;

interface

uses sysutils;

type Tzeit = Real;
     Tzeitgeber = class(tobject)
     public
         stretch : Real;  // einheit : Tzeit / TdateTime

         constructor create(now : TDateTime); overload;
         constructor create;                  overload;

         function mytime(time : Tdatetime) : Tzeit; overload;
         function mytime : Tzeit;                   overload;
//         function now : Tzeit;

         function globaltime(mytime : Tzeit) : TdateTime; overload;
         function globaltime : TdateTime;                 overload;

         procedure set_t0(time : Tdatetime); overload;
         procedure set_t0;                   overload;

         procedure set_stretch(s : Real);
     protected
         t0 : TDateTime;
         mytime0 : Tzeit;


     end;

implementation

constructor Tzeitgeber.create(now : Tdatetime);
begin
    inherited create;
    self.stretch:= 1;
    self.set_t0;
end;

constructor Tzeitgeber.create;
begin
    self:=  Tzeitgeber.create(Now);
end;


function Tzeitgeber.mytime(time : Tdatetime) : Tzeit;
begin
    Result:= self.mytime0 + (time - self.t0) * self.stretch * 86400
end;

function Tzeitgeber.mytime : Tzeit;
begin
    Result:= self.mytime(Now);
end;

function Tzeitgeber.globaltime(mytime : Tzeit) : Tdatetime;
begin
    if self.stretch = 0 then
        Result:= self.t0
    else
        Result:= mytime / (self.stretch * 86400) + self.t0;;
end;

function Tzeitgeber.globaltime : Tdatetime;
begin
    Result:= now;
end;

procedure Tzeitgeber.set_t0(time : Tdatetime);
begin
    self.t0:= time;
end;
procedure Tzeitgeber.set_t0;
begin
    self.t0:= Now;
end;

procedure Tzeitgeber.set_stretch(s : Real);
begin
    self.mytime0:= self.mytime;
    self.set_t0;
    self.stretch:= s;
end;

(*function Tzeitgeber.now : Tzeit;
begin
    Result:= self.mytime;
end;  *)



end.
