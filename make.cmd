@echo off
rem Windows stand-in for `make`, so the commands from the README work as typed:
rem   .\make install   .\make git docker   .\make help
rem It forwards to install.ps1 and bypasses the execution policy for that one
rem process only. With no arguments it lists the tools, like `make` does.
if "%~1"=="" (powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0install.ps1" -List) else (powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0install.ps1" %*)
exit /b %ERRORLEVEL%
