@ECHO OFF
SETLOCAL EnableDelayedExpansion
set "llvm_version=clang--version.txt"
IF EXIST !llvm_version! (
	curl https://raw.githubusercontent.com/DevJeffersonL/llvm-mingw/refs/heads/main/COMPILERRUN/clang_version.txt >!llvm_version! >NUL 2>&1
) ELSE (
	curl https://raw.githubusercontent.com/DevJeffersonL/llvm-mingw/refs/heads/main/COMPILERRUN/clang_version.txt >>!llvm_version! >NUL 2>&1
)
REM Read the first line of the file
for /f "usebackq delims=" %%a in ("!llvm_version!") do (
    set "Current_Version=%%a"
    goto :done  REM Exit after reading the first line
)
:done

for /f "delims=" %%a in ('powershell -Command "clang --version | Select-String -Pattern 'clang version (\S+)' | ForEach-Object { $_.Matches.Groups[1].Value }"') do (
    set clang_version=%%a
)
IF "!Current_Version!"=="!clang_version!" (
	ECHO Your Compiler Is Upto date
) ELSE (
	ECHO CURRENT VERION: %Current_Version%
	ECHO COMPILER VERSION: %clang_version%
)
pause