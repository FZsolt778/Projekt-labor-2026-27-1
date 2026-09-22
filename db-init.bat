@echo off
setlocal
cd /d "%~dp0"

set "PGBIN=%~dp0pgsql\bin"
set "PGDATA=%~dp0pgdata"
set "PGLOG=%~dp0pgdata.log"

if not exist "%PGBIN%\initdb.exe" (echo Nincs pgsql\bin mappa. & goto :err)
if exist "%PGDATA%\PG_VERSION"    (echo Mar inicializalva van. & goto :err)
if not exist ".env"               (echo Nincs .env fajl. & goto :err)

for /f "usebackq eol=# tokens=1,* delims==" %%a in (".env") do set "%%a=%%b"
if not defined POSTGRES_PASSWORD  (echo Ures POSTGRES_PASSWORD. & goto :err)
if not defined POSTGRES_PORT      set "POSTGRES_PORT=5432"

>"%TEMP%\pgpw.txt" echo %POSTGRES_PASSWORD%
"%PGBIN%\initdb.exe" -D "%PGDATA%" -U postgres -A scram-sha-256 --pwfile="%TEMP%\pgpw.txt" -E UTF8 --locale=C
del "%TEMP%\pgpw.txt"
if errorlevel 1 goto :err

"%PGBIN%\pg_ctl.exe" -D "%PGDATA%" -l "%PGLOG%" -o "-p %POSTGRES_PORT% -c timezone=UTC" start
if errorlevel 1 goto :err

set "PGPASSWORD=%POSTGRES_PASSWORD%"
"%PGBIN%\psql.exe" -h 127.0.0.1 -p %POSTGRES_PORT% -U postgres -c "CREATE USER %POSTGRES_USER% WITH PASSWORD '%POSTGRES_PASSWORD%';"
if errorlevel 1 goto :err
"%PGBIN%\psql.exe" -h 127.0.0.1 -p %POSTGRES_PORT% -U postgres -c "CREATE DATABASE %POSTGRES_DB% OWNER %POSTGRES_USER%;"
if errorlevel 1 goto :err

echo KESZ.
"%PGBIN%\pg_ctl.exe" -D "%PGDATA%" -m fast stop
if exist "%PGDATA%\postmaster.pid" "%PGBIN%\pg_ctl.exe" -D "%PGDATA%" -m fast stop >nul 2>&1
pause
exit /b 0

:err
echo MEGSZAKADT. Naplo: %PGLOG%
pause
exit /b 1