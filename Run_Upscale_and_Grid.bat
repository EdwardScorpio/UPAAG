@echo off
chcp 65001 > nul
powershell -ExecutionPolicy Bypass -File "%~dp0Upscale_and_Grid.ps1" -Encoding UTF8
if %errorlevel% neq 0 (
    echo.
    echo Произошла ошибка при выполнении скрипта.
    echo Нажмите любую клавишу, чтобы закрыть это окно...
    pause >nul
) else (
    echo.
    echo Скрипт выполнен успешно.
    echo Нажмите любую клавишу, чтобы закрыть это окно...
    pause >nul
)