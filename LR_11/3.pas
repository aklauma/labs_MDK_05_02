program zxc;
uses GraphABC;
var x: integer;
begin
  SetWindowSize(400,200);
  for x:=50 to 290 step 30 do
  begin
    setbrushcolor(rgb(random(256),random(256),random(256)));
    circle(x,100,10);
  end;
end.
