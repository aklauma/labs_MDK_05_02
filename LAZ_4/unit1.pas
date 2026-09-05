unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Button0: TButton;
    ButtonDiv: TButton;
    ButtonSub: TButton;
    ButtonBackspace: TButton;
    ButtonAdd: TButton;
    ButtonDecimal: TButton;
    ButtonEquals: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    Button6: TButton;
    Button7: TButton;
    Button8: TButton;
    Button9: TButton;
    ButtonClear: TButton;
    ButtonMul: TButton;
    edtResult: TEdit;
    Image1: TImage;
    procedure btnDigitClick(Sender: TObject);
    procedure ButtonAddClick(Sender: TObject);
    procedure ButtonBackspaceClick(Sender: TObject);
    procedure ButtonClearClick(Sender: TObject);
    procedure ButtonDecimalClick(Sender: TObject);
    procedure ButtonDivClick(Sender: TObject);
    procedure ButtonEqualsClick(Sender: TObject);
    procedure ButtonMulClick(Sender: TObject);
    procedure ButtonSubClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    FirstNumber: Double;
    Operation: Char;
    NewInput: Boolean;
    procedure SetOperation(Op: Char);
  public

  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.FormCreate(Sender: TObject);
// начальные значения при запуске
begin
  edtResult.Text := '0';
  FirstNumber := 0;
  Operation := #0;
  NewInput := True;
end;

procedure TForm1.btnDigitClick(Sender: TObject);
// общий обработчик
var
  Digit: String;
begin
  Digit := (Sender as TButton).Caption;

  if NewInput or (edtResult.Text = '0') then
    edtResult.Text := Digit
  else
    edtResult.Text := edtResult.Text + Digit;

  NewInput := False;
end;

procedure TForm1.ButtonAddClick(Sender: TObject);
// обработчик сложения
begin
  SetOperation('+');
end;

procedure TForm1.ButtonBackspaceClick(Sender: TObject);
// обработчик удаления последнего символа
var
  S: String;
begin
  if not NewInput then
  begin
    S := edtResult.Text;

    if Length(S) > 1 then
      Delete(S, Length(S), 1)
    else
      S := '0';

    edtResult.Text := S;
  end;
end;

procedure TForm1.ButtonClearClick(Sender: TObject);
// обработчик оччистки
begin
  edtResult.Text := '0';
  FirstNumber := 0;
  Operation := #0;
  NewInput := True;
end;

procedure TForm1.ButtonDecimalClick(Sender: TObject);
// обработчик десятичной дроби
var
  Sep: Char;
begin
  Sep := DefaultFormatSettings.DecimalSeparator;

  if NewInput then
  begin
    edtResult.Text := '0' + Sep;
    NewInput := False;
  end
  else if Pos(Sep, edtResult.Text) = 0 then
    edtResult.Text := edtResult.Text + Sep;
end;

procedure TForm1.ButtonDivClick(Sender: TObject);
// обработчик деления
begin
  SetOperation('/');
end;

procedure TForm1.ButtonEqualsClick(Sender: TObject);
// обработчик равно
var
  SecondNumber, ResultValue: Double;
begin
  SecondNumber := StrToFloat(edtResult.Text);

  case Operation of
    '+': ResultValue := FirstNumber + SecondNumber;
    '-': ResultValue := FirstNumber - SecondNumber;
    '*': ResultValue := FirstNumber * SecondNumber;
    '/':
      begin
        if SecondNumber = 0 then
        begin
          ShowMessage('Деление на ноль невозможно');
          edtResult.Text := '0';
          Operation := #0;
          NewInput := True;
          Exit;
        end;
        ResultValue := FirstNumber / SecondNumber;
      end;
  else
    Exit;
  end;

  edtResult.Text := FloatToStr(ResultValue);
  Operation := #0;
  NewInput := True;
end;

procedure TForm1.ButtonMulClick(Sender: TObject);
// обработчик умножения
begin
  SetOperation('*');
end;

procedure TForm1.ButtonSubClick(Sender: TObject);
// обработчик вычитания
begin
  SetOperation('-');
end;

procedure TForm1.SetOperation(Op: Char);
// сохранене первого числа и выбранной операции
begin
  FirstNumber := StrToFloat(edtResult.Text);
  Operation := Op;
  NewInput := True;
end;

end.

