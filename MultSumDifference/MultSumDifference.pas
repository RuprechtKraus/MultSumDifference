PROGRAM CalculateDifference(INPUT, OUTPUT);
VAR
  NumberToCast, Notation, MultResult, SumResult, Difference: INTEGER;
  NumberAfterCast: STRING;
  SourceFile, DestFile: TEXT;
 
//Считывание аргументов из файла
//Number - для сохранения числа n
//Notation - для сохранения числа k
FUNCTION FetchArgsFromFile(VAR Source: TEXT; VAR Number, Notation: INTEGER): BOOLEAN;  //При успешном считывание всех аргументов возвращается TRUE, в противном случае FALSE
VAR
  ArgLine: STRING;
  Args: ARRAY OF STRING;
BEGIN  
  RESULT := TRUE;
  
  //Считываем две строки файла на требуемые аргументы n и k
  FOR i: INTEGER := 1 TO 2 
  DO
    BEGIN
      READLN(Source, ArgLine);
      Args := ArgLine.Split(':');
      IF (Args[0] = 'n')
      THEN
        BEGIN
          IF NOT TRYSTRTOINT(Args[1], Number)
          THEN
            BEGIN
              WRITELN('Ошибка: Некорректное значение параметра "n"');
              RESULT := FALSE;
              EXIT
            END
        END
      ELSE
        BEGIN
          IF (Args[0] = 'k')
          THEN
           IF NOT TRYSTRTOINT(Args[1], Notation)
           THEN
             BEGIN
               WRITELN('Ошибка: Некорректное значение параметра "k"');
               RESULT := FALSE;
               EXIT
             END
        END
    END;  
  EXIT
END;

//Преобразование числа в другую систему счисления
FUNCTION CastNumber(VAR Number, NewNotation: INTEGER): STRING; //После преобразования возвращаем число в новой системе в виде строки
VAR
  Remainder, Quotient: INTEGER;
BEGIN
  RESULT := '';
  IF NewNotation <> 10
  THEN
    BEGIN
      REPEAT
        Quotient := Number DIV NewNotation;
        Remainder := Number MOD NewNotation;
        RESULT += Remainder;
        Number := Quotient
      UNTIL Quotient < NewNotation;
      IF Quotient <> 0
      THEN
        RESULT += INTTOSTR(Quotient);
      RESULT := ReverseString(RESULT);
      EXIT
    END
  ELSE //Если новая система счисления является дисетичной - возвращаем сразу это же число
    BEGIN
      RESULT := INTTOSTR(Number);
      EXIT
    END   
END;

FUNCTION MultiplyDigitsInNumber(VAR Number: STRING): INTEGER;
BEGIN
  RESULT := 1;
  FOREACH x: CHAR IN Number
  DO
    RESULT *= ORD(x) - 48;
  EXIT
END;

FUNCTION SummarizeDigitsInNumber(VAR Number: STRING): INTEGER;
BEGIN
  RESULT := 0;
  FOREACH x: CHAR IN Number
  DO
    RESULT += ORD(x) - 48;
  EXIT
END;
  
BEGIN
  NumberToCast := 0;
  Notation := 0;
  MultResult := 0;
  SumResult := 0;
  Difference := 0;
  NumberAfterCast := '';
  
  IF FILEEXISTS('Files/input.txt')
  THEN
    BEGIN
      ASSIGNFILE(SourceFile, 'Files/input.txt');
      RESET(SourceFile);
      IF FetchArgsFromFile(SourceFile, NumberToCast, Notation) //Считывание аргументов из файла
      THEN
        BEGIN
          CLOSEFILE(SourceFile);
          IF (NumberToCast = 0) OR (Notation = 0) //Если какой-либо из аргументов не найден - выводим ошибку
          THEN
            BEGIN
              IF NumberToCast = 0
              THEN
                BEGIN
                  WRITELN('Ошибка: Не найден аргумент "n"');
                END;
              IF Notation = 0
              THEN
                BEGIN
                  WRITELN('Ошибка: Не найден аргумент "k"');
                END   
            END
          ELSE //IF (NumberToCast = 0) OR (Notation = 0)
            BEGIN
              IF ((1 <= NumberToCast) AND (NumberToCast <= 109)) AND ((2 <= Notation) AND (Notation <= 10)) //Проверяем на соответствие условий
              THEN
                BEGIN 
                  ASSIGNFILE(DestFile, 'Files/output.txt');
                  REWRITE(DestFile);
                  WRITE(DestFile, 'Число ', NumberToCast, ' в ', Notation, '-ой системе счисления: ');
                  NumberAfterCast := CastNumber(NumberToCast, Notation); //Перевод в другую систему счисления  
                  WRITELN(DestFile, NumberAfterCast);
                  MultResult := MultiplyDigitsInNumber(NumberAfterCast);
                  WRITELN(DestFile, 'Результат умножения цифр в числе ', NumberAfterCast, ': ', MultResult); //Вычисление произведения
                  SumResult := SummarizeDigitsInNumber(NumberAfterCast); //Вычисление суммы
                  WRITELN(DestFile, 'Результат сложения цифр в числе ', NumberAfterCast, ': ', SumResult);
                  Difference := MultResult - SumResult; //Вычисление разности
                  WRITELN(DestFile, 'Разница умножения и сложения (', MultResult, ' - ', SumResult ,'): ', Difference);           
                  CLOSEFILE(DestFile)
                END
              ELSE
                BEGIN
                  WRITE('Ошибка: Данные не входят в требуемый диапазон (1 <= n <= 109, 2 <= k <= 10)')
                END
            END
        END
      ELSE
        CLOSEFILE(SourceFile)
    END
  ELSE
    WRITELN('Ошибка: Входной файл не найден')
END.