program L4_2task4;

uses GraphABC;

var
  centerX, centerY: integer;
  radius: integer;
  i: integer;

begin
  SetWindowSize(800, 600);
  SetWindowTitle('Круги на воде');

  centerX := 400;
  centerY := 300;
  
  SetPenColor(clBlue);
  SetPenWidth(2);
  
  for i := 1 to 20 do
  begin
    radius := i * 10;
    Circle(centerX, centerY, radius);
    Sleep(50);  
  end;
end.

