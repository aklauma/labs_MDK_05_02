program zxc;

uses crt, GraphABC;

var
  choice: char;
  a, b: real;
  scaleX, scaleY: real;
  offsetX, offsetY: integer;
  windowWidth, windowHeight: integer;
  limitsSet: boolean; // Флаг для проверки, установлены ли пределы
  centerX, centerY: real; // Центр координат
  viewMinX, viewMaxX, viewMinY, viewMaxY: real; // Текущий диапазон отображения
  originalMinX, originalMaxX, originalMinY, originalMaxY: real; // Исходные границы с отступами
  cachedArea, cachedError: real; // Кэшированные значения площади и погрешности
  areaCacheValid: boolean; // Флаг валидности кэша

function f(x: real): real;
begin
  f := x*x*x + x*x - 3*x + 11;
end;

function simpson_integration(a, b: real; n: integer): real;
var
  h, sum: real;
  i: integer;
begin
  if n mod 2 <> 0 then
    n := n + 1;

  h := (b - a) / n;
  sum := f(a) + f(b);

  for i := 1 to n-1 do
  begin
    if i mod 2 = 1 then
      sum := sum + 4 * f(a + i * h)
    else
      sum := sum + 2 * f(a + i * h);
  end;

  simpson_integration := sum * h / 3;
end;

function estimate_error(a, b: real; n: integer): real;
var
  I1, I2: real;
begin
  I1 := simpson_integration(a, b, n);
  I2 := simpson_integration(a, b, n * 2);
  estimate_error := abs(I2 - I1);
end;

procedure get_limits(var a, b: real);
begin
  repeat
    write('Введите нижний предел a: ');
    readln(a);
    write('Введите верхний предел b: ');
    readln(b);
    if a >= b then
      writeln('Ошибка: a должно быть меньше b!');
  until a < b;
end;

function XToScreen(x: real): integer;
begin
  XToScreen := round(offsetX + (x - centerX) * scaleX);
end;

function YToScreen(y: real): integer;
begin
  YToScreen := round(offsetY - (y - centerY) * scaleY);
end;

// Вычисляет границы функции на интервале [a, b] с отступами
procedure calculate_function_bounds;
var
  minX, maxX, minY, maxY: real;
  rangeX, rangeY: real;
  margin: real;
  i: integer;
  x, y: real;
begin
  minX := a;
  maxX := b;
  minY := f(a);
  maxY := f(a);
  
  // Находим минимум и максимум функции на интервале
  for i := 0 to 100 do
  begin
    x := a + (b - a) * i / 100;
    y := f(x);
    if y < minY then minY := y;
    if y > maxY then maxY := y;
  end;
  
  // Добавляем отступы
  margin := 0.1;
  rangeX := maxX - minX;
  rangeY := maxY - minY;
  
  originalMinX := minX - rangeX * margin;
  originalMaxX := maxX + rangeX * margin;
  originalMinY := minY - rangeY * margin;
  originalMaxY := maxY + rangeY * margin;
end;

procedure calculate_scaling;
var
  rangeX, rangeY: real;
begin
  // Если диапазон не задан, используем исходные границы
  if (viewMinX = 0) and (viewMaxX = 0) and (viewMinY = 0) and (viewMaxY = 0) then
  begin
    viewMinX := originalMinX;
    viewMaxX := originalMaxX;
    viewMinY := originalMinY;
    viewMaxY := originalMaxY;
  end;
  
  rangeX := viewMaxX - viewMinX;
  rangeY := viewMaxY - viewMinY;
  
  // Вычисляем масштабы с независимым масштабированием по осям
  scaleX := (windowWidth - 200) / rangeX;
  scaleY := (windowHeight - 200) / rangeY;
  
  // Центр координат в центре окна
  offsetX := windowWidth div 2;
  offsetY := windowHeight div 2;
  
  // Сохраняем центр координат для преобразований
  centerX := (viewMinX + viewMaxX) / 2;
  centerY := (viewMinY + viewMaxY) / 2;
end;

procedure zoom_in;
var
  rangeX, rangeY: real;
  zoomFactor: real;
begin
  zoomFactor := 0.8; // Уменьшаем диапазон на 20% (приближение)
  
  rangeX := (viewMaxX - viewMinX) * zoomFactor;
  rangeY := (viewMaxY - viewMinY) * zoomFactor;
  
  viewMinX := centerX - rangeX / 2;
  viewMaxX := centerX + rangeX / 2;
  viewMinY := centerY - rangeY / 2;
  viewMaxY := centerY + rangeY / 2;
  
  calculate_scaling;
end;

procedure zoom_out;
var
  rangeX, rangeY: real;
  zoomFactor: real;
begin
  zoomFactor := 1.25; // Увеличиваем диапазон на 25% (отдаление)
  
  rangeX := (viewMaxX - viewMinX) * zoomFactor;
  rangeY := (viewMaxY - viewMinY) * zoomFactor;
  
  viewMinX := centerX - rangeX / 2;
  viewMaxX := centerX + rangeX / 2;
  viewMinY := centerY - rangeY / 2;
  viewMaxY := centerY + rangeY / 2;
  
  // Ограничиваем зум исходными границами
  if viewMinX < originalMinX then viewMinX := originalMinX;
  if viewMaxX > originalMaxX then viewMaxX := originalMaxX;
  if viewMinY < originalMinY then viewMinY := originalMinY;
  if viewMaxY > originalMaxY then viewMaxY := originalMaxY;
  
  calculate_scaling;
end;

procedure draw_axes;
var
  i: integer;
  x, y: real;
  stepX, stepY: real;
  sx, sy: integer;
  labelText: string;
  zeroX, zeroY: integer; // Координаты нуля
begin
  // Рисуем оси
  SetPenColor(clBlack);
  SetPenWidth(2);
  
  // Координаты нуля
  zeroX := XToScreen(0);
  zeroY := YToScreen(0);
  
  // Ось X (горизонтальная линия через y=0)
  Line(0, zeroY, windowWidth, zeroY);
  // Стрелка оси X
  Line(windowWidth - 10, zeroY - 5, windowWidth, zeroY);
  Line(windowWidth - 10, zeroY + 5, windowWidth, zeroY);
  
  // Ось Y (вертикальная линия через x=0)
  Line(zeroX, 0, zeroX, windowHeight);
  // Стрелка оси Y
  Line(zeroX - 5, 10, zeroX, 0);
  Line(zeroX + 5, 10, zeroX, 0);
  
  // Подписи осей
  SetFontSize(12);
  SetFontColor(clBlack);
  TextOut(windowWidth - 30, zeroY - 20, 'X');
  TextOut(zeroX + 10, 5, 'Y');
  
  // Разметка и подписи на оси X
  stepX := (viewMaxX - viewMinX) / 10;
  for i := 0 to 10 do
  begin
    x := viewMinX + stepX * i;
    sx := XToScreen(x);
    if (sx >= 0) and (sx <= windowWidth) then
    begin
      Line(sx, zeroY - 5, sx, zeroY + 5);
      labelText := FloatToStr(Round(x * 10) / 10);
      TextOut(sx - 15, zeroY + 10, labelText);
    end;
  end;
  
  // Разметка и подписи на оси Y
  stepY := (viewMaxY - viewMinY) / 10;
  for i := 0 to 10 do
  begin
    y := viewMinY + stepY * i;
    sy := YToScreen(y);
    if (sy >= 0) and (sy <= windowHeight) then
    begin
      Line(zeroX - 5, sy, zeroX + 5, sy);
      labelText := FloatToStr(Round(y * 10) / 10);
      TextOut(zeroX - 50, sy - 8, labelText);
    end;
  end;
  
  // Ноль на осях
  if (viewMinX <= 0) and (viewMaxX >= 0) then
  begin
    if (zeroX >= 0) and (zeroX <= windowWidth) then
      TextOut(zeroX - 5, zeroY + 10, '0');
  end;
  
  if (viewMinY <= 0) and (viewMaxY >= 0) then
  begin
    if (zeroY >= 0) and (zeroY <= windowHeight) then
      TextOut(zeroX - 15, zeroY - 8, '0');
  end;
end;

procedure draw_curve;
var
  i: integer;
  x, y: real;
  prevX, prevY: integer;
  currentX, currentY: integer;
  startX, endX: real;
  step: real;
begin
  SetPenColor(clBlue);
  SetPenWidth(2);
  
  // Используем текущий диапазон зума, но не выходим за пределы [a, b]
  startX := viewMinX;
  endX := viewMaxX;
  if startX < a then startX := a;
  if endX > b then endX := b;
  
  step := (endX - startX) / 500;
  prevX := XToScreen(startX);
  prevY := YToScreen(f(startX));
  
  for i := 1 to 500 do
  begin
    x := startX + step * i;
    y := f(x);
    currentX := XToScreen(x);
    currentY := YToScreen(y);
    
    if (currentX >= 0) and (currentX <= windowWidth) and
       (currentY >= 0) and (currentY <= windowHeight) then
      Line(prevX, prevY, currentX, currentY);
    
    prevX := currentX;
    prevY := currentY;
  end;
end;

procedure draw_hatching;
var
  i: integer;
  x, y: real;
  sx, sy: integer;
  step: real;
  zeroY: integer; // Y координата оси X (y=0)
  startX, endX: real;
  numSteps: integer;
begin
  SetPenColor(clGreen);
  SetPenWidth(1);
  SetPenStyle(psDash);
  
  zeroY := YToScreen(0);
  
  // Используем текущий диапазон зума, но не выходим за пределы [a, b]
  startX := viewMinX;
  endX := viewMaxX;
  if startX < a then startX := a;
  if endX > b then endX := b;
  
  numSteps := 30;
  step := (endX - startX) / numSteps;
  for i := 0 to numSteps do
  begin
    x := startX + step * i;
    if (x >= a) and (x <= b) then
    begin
      y := f(x);
      sx := XToScreen(x);
      sy := YToScreen(y);
      
      if (sx >= 0) and (sx <= windowWidth) and
         (sy >= 0) and (sy <= windowHeight) then
        Line(sx, sy, sx, zeroY);
    end;
  end;
  
  SetPenStyle(psSolid);
end;

procedure draw_integral_visualization;
var
  n: integer;
  h, x1, x2, y1, y2: real;
  sx1, sx2, sy1, sy2: integer;
  i: integer;
  points: array of Point;
  zeroY: integer; // Y координата оси X (y=0)
begin
  n := 20; // Количество трапеций для визуализации
  h := (b - a) / n;
  
  // Цвет RGB(0,255,255) - голубой
  SetPenColor(RGB(0, 255, 255));
  SetPenWidth(1);
  SetBrushColor(RGB(0, 255, 255));
  SetBrushStyle(bsSolid);
  
  SetLength(points, 4);
  
  // Y координата оси X (y=0)
  zeroY := YToScreen(0);
  
  for i := 0 to n - 1 do
  begin
    x1 := a + i * h;
    x2 := a + (i + 1) * h;
    
    // Пропускаем трапеции, которые полностью вне видимой области
    if (x2 < viewMinX) or (x1 > viewMaxX) then
      continue;
    
    y1 := f(x1);
    y2 := f(x2);
    
    sx1 := XToScreen(x1);
    sx2 := XToScreen(x2);
    sy1 := YToScreen(y1);
    sy2 := YToScreen(y2);
    
    // Рисуем трапецию до оси X (y=0)
    points[0].X := sx1;
    points[0].Y := sy1;
    points[1].X := sx2;
    points[1].Y := sy2;
    points[2].X := sx2;
    points[2].Y := zeroY;
    points[3].X := sx1;
    points[3].Y := zeroY;
    Polygon(points);
  end;
  
  SetBrushStyle(bsClear);
end;

function FormatReal(value: real; decimals: integer): string;
var
  str: string;
  dotPos: integer;
begin
  str := FloatToStr(value);
  dotPos := Pos('.', str);
  if dotPos > 0 then
  begin
    if Length(str) > dotPos + decimals then
      Result := Copy(str, 1, dotPos + decimals)
    else
      Result := str;
  end
  else
    Result := str;
end;

procedure draw_task_info;
begin
  // Используем кэшированные значения, если они валидны
  if not areaCacheValid then
  begin
    cachedArea := simpson_integration(a, b, 1000);
    cachedError := estimate_error(a, b, 1000);
    areaCacheValid := true;
  end;
  
  SetFontSize(10);
  SetFontColor(clBlack);
  SetBrushColor(clWhite);
  SetBrushStyle(bsSolid);
  
  // Информация о задании
  TextOut(10, 10, 'ДКР №4');
  TextOut(10, 30, 'Работа в графическом режиме');
  TextOut(10, 50, 'Функция: y = x³ + x² - 3x + 11');
  TextOut(10, 70, 'Интервал: [' + FormatReal(a, 2) + ', ' + FormatReal(b, 2) + ']');
  TextOut(10, 90, 'Площадь: ' + FormatReal(cachedArea, 6));
  TextOut(10, 110, 'Погрешность: ' + FormatReal(cachedError, 6));
  
  // Информация об управлении
  TextOut(10, windowHeight - 100, 'Управление:');
  TextOut(10, windowHeight - 80, 'Стрелки - масштабирование по осям');
  TextOut(10, windowHeight - 60, '+/- или PageUp/Down - зум');
  TextOut(10, windowHeight - 40, 'R - сброс масштаба и зума');
  TextOut(10, windowHeight - 20, 'ESC - выход');
end;

procedure redraw_graph;
begin
  LockDrawing;
  ClearWindow(clWhite);
  draw_axes;
  draw_integral_visualization;
  draw_hatching;
  draw_curve;
  draw_task_info;
  UnlockDrawing;
  Redraw;
end;

procedure visualize_graph;
var
  needRedraw: boolean;
  
begin
  windowWidth := 1000;
  windowHeight := 700;
  SetWindowSize(windowWidth, windowHeight);
  SetWindowTitle('Визуализация графика функции');
  
  calculate_scaling;
  needRedraw := true;
  
  OnKeyDown := procedure(k: integer) -> begin
    case k of
      VK_Escape: begin
                   needRedraw := false;
                   CloseWindow;
                 end;
      VK_Up: begin
               scaleY := scaleY * 1.1;
               redraw_graph;
             end;
      VK_Down: begin
                 scaleY := scaleY / 1.1;
                 redraw_graph;
               end;
      VK_Left: begin
                 scaleX := scaleX * 1.1;
                 redraw_graph;
               end;
      VK_Right: begin
                  scaleX := scaleX / 1.1;
                  redraw_graph;
                end;
      VK_Add, 187: begin  // '+' на цифровой клавиатуре и основной
                  zoom_in;
                  redraw_graph;
                end;
      VK_Subtract, 189: begin  // '-' на цифровой клавиатуре и основной
                  zoom_out;
                  redraw_graph;
                end;
      VK_Prior: begin  // PageUp - приближение
                  zoom_in;
                  redraw_graph;
                end;
      VK_Next: begin  // PageDown - отдаление
                 zoom_out;
                 redraw_graph;
               end;
      82, 114: begin  // 'R' и 'r' - сброс
                 viewMinX := 0;
                 viewMaxX := 0;
                 viewMinY := 0;
                 viewMaxY := 0;
                 calculate_scaling;
                 redraw_graph;
               end;
    end;
  end;
  
  redraw_graph;
  
  while needRedraw do
    Sleep(10);
  
  // Закрываем окно при выходе
  CloseWindow;
end;

procedure show_menu;
begin
  writeln('========================================');
  writeln('Меню:');
  writeln('1. Вычислить площадь');
  writeln('2. Визуализация графика');
  writeln('3. Выход');
  write('Выберите действие (1, 2 или 3): ');
  readln(choice);
end;

begin
  clrscr;
  limitsSet := false;
  a := 0;
  b := 0;
  viewMinX := 0;
  viewMaxX := 0;
  viewMinY := 0;
  viewMaxY := 0;
  areaCacheValid := false;
  
  writeln('Программа вычисления площади под кривой y = x^3 + x^2 - 3x + 11');
  writeln('ДКР №4 - Работа в графическом режиме');

  repeat
    show_menu;

    case choice of
      '1': begin
             get_limits(a, b);
             limitsSet := true;
             areaCacheValid := false; // Инвалидируем кэш при изменении пределов
             calculate_function_bounds; // Вычисляем границы функции
             writeln;
             cachedArea := simpson_integration(a, b, 1000);
             cachedError := estimate_error(a, b, 1000);
             areaCacheValid := true;
             writeln('Площадь фигуры от ', a:0:2, ' до ', b:0:2, ': ', cachedArea:0:6);
             writeln('Оценка погрешности: ', cachedError:0:6);
           end;
      '2': begin
             if not limitsSet then
             begin
               writeln('Сначала введите пределы интегрирования!');
               get_limits(a, b);
               limitsSet := true;
               areaCacheValid := false;
               calculate_function_bounds;
             end;
             visualize_graph;
           end;
      '3': begin
             writeln('Выход из программы.');
             Halt;
           end;
      else writeln('Неверный выбор. Попробуйте снова.');
    end;

    writeln;
    if choice <> '3' then
      readln;
  until false;
end.