program zxc;
uses GraphABC;
var x, y: integer;
begin
  SetWindowSize(320,320);
  for x:=0 to 7 do
    for y:=0 to 7 do
    begin
      if (x+y) mod 2 = 0 then setbrushcolor(clWhite)
      else setbrushcolor(clBlack);
      rectangle(x*40, y*40, x*40+40, y*40+40);
    end;
end.
