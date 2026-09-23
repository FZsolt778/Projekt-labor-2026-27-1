@echo off
setlocal
cd /d "%~dp0"

set "PGBIN=%~dp0pgsql\bin"
set "PGDATA=%~dp0pgdata"
set "PGLOG=%~dp0pgdata.log"

if not exist "%PGDATA%\PG_VERSION" (echo Futtasd eloszor a db-init.bat szkriptet. & goto :err)

for /f "usebackq eol=# tokens=1,* delims==" %%a in (".env") do set "%%a=%%b"
if "%POSTGRES_PORT%"=="" set "POSTGRES_PORT=5432"

"%PGBIN%\pg_ctl.exe" -D "%PGDATA%" -l "%PGLOG%" -o "-p %POSTGRES_PORT% -c timezone=UTC" start
if errorlevel 1 (echo Nem indult el. Mar fut, vagy a port foglalt. & goto :err)

echo.
echo  Fut a %POSTGRES_PORT% porton.
echo.
timeout /t 3 >nul
exit /b 0

:err
echo.
echo MEGSZAKADT. Naplo: %PGLOG%
pause
exit /b 1