program zxc;
uses GraphABC;
begin
  SetWindowSize(400,200);
  // левый круг
  setbrushcolor(clRed); circle(70,100,35);
  // правый круг
  setbrushcolor(clYellow); circle(330,100,30);
  // верхний ромб
  setbrushcolor(clBlue); polygon([(105,100),(200,50),(295,100),(200,100)]);
  // нижний ромб
  setbrushcolor(clGreen); polygon([(105,100),(200,150),(295,100),(200,100)]);
end.
