const
  MAXN = 50;

type
  TNode = record
    value: integer;
    next: integer; // индекс следующего, -1 = нет
  end;

var
  pool: array[1..MAXN] of TNode;
  used: array[1..MAXN] of boolean;
  Head: integer;
  cnt: integer;
  choice, val, target: integer;

// Получение свободного индекса (линейный поиск)
function GetFree: integer;
var i: integer;
begin
  Result := 0;
  i := 1;
  while (i <= MAXN) and (Result = 0) do
  begin
    if not used[i] then
    begin
      used[i] := true;
      pool[i].next := -1;
      Result := i;
    end;
    i := i + 1;
  end;
end;

// Освобождение узла
procedure ReleaseNode(idx: integer);
begin
  used[idx] := false;
end;

// Вывод списка (линейный вид)
procedure PrintList;
var cur, steps: integer;
begin
  if Head = 0 then
  begin
    writeln('Список пуст');
    exit;
  end;
  
  cur := Head;
  steps := 0;
  
  while steps < cnt do
  begin
    if steps > 0 then
      write(' -> ');
    write('[', pool[cur].value, ']');
    cur := pool[cur].next;
    steps := steps + 1;
  end;
  
  writeln;
  writeln('Кол-во: ', cnt);
end;

// Добавление: toBegin = true → в начало, false → в конец
procedure ADD(val: integer; toBegin: boolean);
var nn, cur: integer;
begin
  // Проверка переполнения
  if cnt >= MAXN then
  begin
    writeln('Пул заполнен');
    exit;
  end;
  
  // Получаем новый узел
  nn := GetFree;
  pool[nn].value := val;
  
  // Если список пуст — создаём первый элемент
  if Head = 0 then
  begin
    Head := nn;
    pool[nn].next := nn;
    cnt := cnt + 1;
    exit;
  end;
  
  // Поиск последнего элемента (чей next указывает на Head)
  cur := Head;
  while pool[cur].next <> Head do
    cur := pool[cur].next;
  
  // Вставка в начало
  if toBegin then
  begin
    pool[nn].next := Head;
    pool[cur].next := nn;
    Head := nn;
  end
  // Вставка в конец
  else
  begin
    pool[nn].next := Head;
    pool[cur].next := nn;
  end;
  
  cnt := cnt + 1;
end;

// Очистка списка
procedure ClearAll;
var cur, tmp, steps: integer;
begin
  if Head = 0 then
  begin
    writeln('Уже пуст');
    exit;
  end;
  
  cur := Head;
  steps := 0;
  
  while steps < cnt do
  begin
    tmp := cur;
    cur := pool[cur].next;
    ReleaseNode(tmp);
    steps := steps + 1;
  end;
  
  Head := 0;
  cnt := 0;
  writeln('Очищено');
end;

// main
begin
  Head := 0;
  cnt := 0;
  for var i := 1 to MAXN do
  begin
    used[i] := false;
    pool[i].next := -1;
  end;
  
  repeat
    writeln;
    writeln('============================');
    writeln(' Кольцевой односвязный список');
    writeln('============================');
    writeln('1 - Добавить в конец');
    writeln('2 - Добавить в начало');
    writeln('3 - Вывести список');
    writeln('4 - Очистить');
    writeln('0 - Выход');
    writeln('============================');
    write('> ');
    readln(choice);
    
    case choice of
      1: begin
           write('Значение: ');
           readln(val);
           ADD(val, false);
           PrintList;
         end;
      2: begin
           write('Значение: ');
           readln(val);
           ADD(val, true);
           PrintList;
         end;
      3: PrintList;
      4: ClearAll;
      0: writeln('Выход');
    else
      writeln('Неверный выбор');
    end;
  until choice = 0;
end.
