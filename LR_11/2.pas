program L4_2task2;

uses GraphABC;

begin
  SetWindowSize(800, 600);
  SetWindowTitle('Корона');
  
  //центральный треугольник
  SetPenColor(clBlack);
  moveTo(300, 500);
  lineTo(500, 500);
  lineTo(400, 200);
  lineTo(300, 500);
  FloodFill(400, 450, clred);

  //левый треугольник
  lineTo(200, 500);
  lineTo(100, 200);
  lineTo(334, 400);
  FloodFill(220, 450, clblue);
  
  //правый треугольник
  moveTo(400, 500);
  lineTo(600, 500);
  lineTo(700, 200);
  lineTo(466, 400);
  FloodFill(580, 450, clgreen);
  
  Circle(400, 200, 40);
  floodfill(400,200,clred);
  Circle(700, 200, 40);
  floodfill(700,200,clgreen);
  Circle(100, 200, 40);
  floodfill(100,200,clblue);
end.

