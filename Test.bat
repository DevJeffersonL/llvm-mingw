@echo off
for /f "delims=" %%a in ('powershell -Command "clang --version | Select-String -Pattern 'clang version (\S+)' ^| ForEach-Object { $_.Matches.Groups[1].Value }"') do set version=%%a
echo %version%
pause 


@echo off
setlocal

:: Set two variables
set var1=1.0.0
set var2=1.0.0

:: Compare the variables
if "%var1%"=="%var2%" (
    echo Your compiler is up to date.
) else (
    echo Your compiler is outdated.
)

endlocal
