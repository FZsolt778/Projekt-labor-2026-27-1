@echo off
setlocal
cd /d "%~dp0"

set "PGBIN=%~dp0pgsql\bin"
set "PGDATA=%~dp0pgdata"

"%PGBIN%\pg_ctl.exe" -D "%PGDATA%" -m fast stop

echo.
echo  Leallitva.
echo.
timeout /t 3 >nul
