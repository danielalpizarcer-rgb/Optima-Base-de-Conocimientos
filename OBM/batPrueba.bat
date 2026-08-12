@echo off
REM =========================================================
REM Script BAT de prueba para simular opr-archive-events.bat
REM =========================================================

echo [MOCK BAT] Ejecutando opr-archive-events.bat con parametros:
echo [MOCK BAT] Parametros recibidos: %*

REM Parsear los parametros pasados por PowerShell
:loop
if "%~1"=="" goto continue
if "%~1"=="-force" echo [MOCK BAT] Flag activado: -force
if "%~1"=="--outputFile" (
    set OUTPUT_FILE=%~2
    shift
)
if "%~1"=="--state" (
    set STATE_VAL=%~2
    shift
)
if "%~1"=="-until" (
    set UNTIL_VAL=%~2
    shift
)
shift
goto loop

:continue

echo [MOCK BAT] Output File objetivo: %OUTPUT_FILE%
echo [MOCK BAT] Estado filtrado     : %STATE_VAL%
echo [MOCK BAT] Fecha hasta (-until): %UNTIL_VAL%

REM Simular la creación del archivo XML resultado
if defined OUTPUT_FILE (
    echo ^<events^>^<event id="1" state="%STATE_VAL%" until="%UNTIL_VAL%"/^>^</events^> > "%OUTPUT_FILE%"
    echo [MOCK BAT] ARCHIVO XML CREADO EXITOSAMENTE EN: %OUTPUT_FILE%
    exit /b 0
) else (
    echo [MOCK BAT] ERROR: No se especifico --outputFile.
    exit /b 1
)