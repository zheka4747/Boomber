@echo off

setlocal enabledelayedexpansion
chcp 1251>nul
set /p hours= "Введите часы (прим. 02, 15): "
set /p mins= "Введите минуты (прим. 08, 45): "
set /p phone= "Пожалуйста, введите номер телефона (прим. 79213451243): "
set /p floodmode= "Пожалуйста, введите режим флуда (1 - только SMS, 2 - только CALL, 3 - SMS и CALL): "
set /p logmode= "Пожалуйста, введите режим лога (0 - выкл, 1 - только OK, 2 - только ERR, 3 - OK и ERR): "
set /p worktime= "Пожалуйста, введите время спама в секундах (0 - бескончено): "
echo Настройки установлены. Бомбер запуститься в %hours%:%mins%
:start
FOR /F "usebackq tokens=1,2,3* delims=:" %%a IN ('!time!') DO (
 set h=%%a
 set m=%%b
)
if !hours!==!h! (
 if !mins!==!m! (
  .\infinite-bomber.exe %phone% %floodmode% %logmode% %worktime%
  goto :end
 )
)
timeout /t 5 /NOBREAK>nul
goto :start
:end
chcp 866>nul
pause