@echo off

setlocal enabledelayedexpansion
chcp 1251>nul
set /p waittime= "����������, �������, ����� ������� ������ ������ ����� ����������� ������: "
set /p phone= "����������, ������� ����� �������� (����. 79213451243): "
set /p floodmode= "����������, ������� ����� ����� (1 - ������ SMS, 2 - ������ CALL, 3 - SMS � CALL): "
set /p logmode= "����������, ������� ����� ���� (0 - ����, 1 - ������ OK, 2 - ������ ERR, 3 - OK � ERR): "
set /p worktime= "����������, ������� ����� ����� � �������� (0 - ����������): "
echo ��������� �����������. ������ ����������� ����� %waittime% ������
timeout /t %waittime% /NOBREAK > nul
.\infinite-bomber.exe %phone% %floodmode% %logmode% %worktime%
chcp 866>nul
pause