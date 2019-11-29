@echo off

setlocal enabledelayedexpansion
chcp 1251>nul
set /p waittime= "Пожалуйста, введите, через сколько секунд должен будет запуститься бомбер: "
set /p phone= "Пожалуйста, введите номер телефона (прим. 79213451243): "
set /p floodmode= "Пожалуйста, введите режим флуда (1 - только SMS, 2 - только CALL, 3 - SMS и CALL): "
set /p logmode= "Пожалуйста, введите режим лога (0 - выкл, 1 - только OK, 2 - только ERR, 3 - OK и ERR): "
set /p worktime= "Пожалуйста, введите время спама в секундах (0 - бескончено): "
echo Настройки установлены. Бомбер запуститься через %waittime% секунд
timeout /t %waittime% /NOBREAK > nul
.\infinite-bomber.exe %phone% %floodmode% %logmode% %worktime%
chcp 866>nul
pause