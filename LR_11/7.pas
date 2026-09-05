program zxc;
uses GraphABC;
var x, y: integer;
begin
  SetWindowSize(400,400);
  // движение вверх вправо
  x:=50; y:=350;
  while (x<200) and (y>50) do
  begin
    setbrushcolor(clWhite); rectangle(x-15,y-15,x+15,y+15);
    x:=x+3; y:=y-3;
    setbrushcolor(clBlack); rectangle(x-15,y-15,x+15,y+15);
    sleep(10);
  end;
  // движение вниз вправо
  while (x<350) and (y<350) do
  begin
    setbrushcolor(clWhite); rectangle(x-15,y-15,x+15,y+15);
    x:=x+3; y:=y+3;
    setbrushcolor(clBlack); rectangle(x-15,y-15,x+15,y+15);
    sleep(10);
  end;
end.