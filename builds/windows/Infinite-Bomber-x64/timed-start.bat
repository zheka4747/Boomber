@echo off

setlocal enabledelayedexpansion
chcp 1251>nul
set /p hours= "������� ���� (����. 02, 15): "
set /p mins= "������� ������ (����. 08, 45): "
set /p phone= "����������, ������� ����� �������� (����. 79213451243): "
set /p floodmode= "����������, ������� ����� ����� (1 - ������ SMS, 2 - ������ CALL, 3 - SMS � CALL): "
set /p logmode= "����������, ������� ����� ���� (0 - ����, 1 - ������ OK, 2 - ������ ERR, 3 - OK � ERR): "
set /p worktime= "����������, ������� ����� ����� � �������� (0 - ����������): "
echo ��������� �����������. ������ ����������� � %hours%:%mins%
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