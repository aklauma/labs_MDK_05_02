program L4_2task5;

uses GraphABC;

var
  x, y: integer;
  radius: integer;
  colors: array[1..8] of Color;
  i: integer;

begin
  SetWindowSize(800, 600);
  SetWindowTitle('Диагональный ряд кругов');
  
  colors[1] := RGB(30, 144, 255);      
  colors[2] := RGB(138, 43, 226);     
  colors[3] := RGB(0, 191, 255);       
  colors[4] := RGB(255, 20, 147);      
  colors[5] := RGB(255, 105, 180);   
  colors[6] := RGB(75, 0, 130);        
  colors[7] := RGB(186, 85, 211);      
  colors[8] := RGB(50, 205, 50);       

  x := 100;
  y := 100;
  
  for i := 1 to 8 do
  begin
    radius := 20 + (i - 1) * 15; 
    
    SetPenColor(clBlack);
    SetPenWidth(2);
    SetBrushColor(colors[i]);
    
    Circle(x, y, radius);
    
    x := x + 60;
    y := y + 50;
  end;
end.

