@ECHO OFF
SETLOCAL ENABLEDELAYEDEXPANSION
:: Variable Defining
set "llvm_version=clang--version.txt"
set "FileURL=llvm_mingw.txt"
set "zipName=llvm_mingw02112024.zip"
set "llvmMingwDir=!USERPROFILE!\LLVM_MINGW"
set "subName=LLVM_MINGW"
set "folderName="
::LLVM VERSION CHECKING
IF EXIST !llvm_version! (
    curl https://raw.githubusercontent.com/DevJeffersonL/llvm-mingw/refs/heads/main/COMPILERRUN/clang_version.txt >!llvm_version!
) ELSE (
    curl https://raw.githubusercontent.com/DevJeffersonL/llvm-mingw/refs/heads/main/COMPILERRUN/clang_version.txt >>!llvm_version!
)
REM READING TEXT_FILE
for /f "usebackq delims=" %%a in ("!llvm_version!") do (
    set "Current_Version=%%a"
    goto :done
)
:done
for /f "delims=" %%a in ('powershell -Command "clang --version | Select-String -Pattern 'clang version (\S+)' | ForEach-Object { $_.Matches.Groups[1].Value }"') do (
    set clang_version=%%a
)
ECHO.
ECHO    ============================================
ECHO    CURRENT VERSION: !Current_Version!
ECHO    SYSTEM VERSION : !clang_version!    
ECHO    ============================================
ECHO.
IF "!Current_Version!"=="!clang_version!" (
    ECHO YOUR COMPILER IS UpToDate
    ECHO. & PAUSE
) ELSE (
    ECHO YOUR COMPILER IS OUTDATED
    ECHO. & PAUSE
)

::-> Path Checking and Adding
powershell -Command "$addPath = [System.IO.Path]::Combine($([System.Environment]::GetFolderPath('UserProfile')), 'LLVM_MINGW', 'LLVM_MINGW', 'bin'); $currentUserPath = [Environment]::GetEnvironmentVariable('Path', 'User'); if ($currentUserPath -notlike \"*$addPath*\") { $newUserPath = \"$currentUserPath;$addPath\"; [Environment]::SetEnvironmentVariable('Path', $newUserPath, 'User') }"
::
if exist !FileURL! (
	curl https://raw.githubusercontent.com/DevJeffersonL/llvm-mingw/refs/heads/main/COMPILERRUN/llvm_mingw.txt >!FileURL!
) else (
	curl https://raw.githubusercontent.com/DevJeffersonL/llvm-mingw/refs/heads/main/COMPILERRUN/llvm_mingw.txt >>!FileURL!
)
::---------------------------------------------------
REM Read the first line of the file
for /f "usebackq delims=" %%a in ("!FileURL!") do (
    set "mingw_url=%%a"
    goto :done  REM Exit after reading the first line
)
:done
::---------------------------------------------------
IF EXIST "!zipName!" (
	IF EXIST "!zipName!" (
        DEL "!zipName!"
    )
    REM DOWNLOAD THE LLVM-MINGW COMPILER WITH CuRL
    curl -L  -o !zipName! !mingw_url!
) ELSE (
    REM DOWNLOAD THE LLVM-MINGW COMPILER WITH CuRL
    curl -L  -o !zipName! !mingw_url!
)
::
CLS
::-> Extracting..............
if exist "!zipName!" (
    if exist "!llvmMingwDir!" (
        rd /S /Q "!llvmMingwDir!"
    )
    :: Use PowerShell to extract the ZIP file
    PowerShell -Command "Expand-Archive -Path '!zipName!' -DestinationPath '!llvmMingwDir!' -Force"
)
::->
for /d %%F in ("%llvmMingwDir%\*") do (
    set "folderName=%%~nF"
)
::-> 
if defined folderName (   
    rem Rename the extracted folder to LLVM
    ren "%llvmMingwDir%\!folderName!" "!subName!"
)
:: CLEANING FILES
IF EXIST "!zipName!" (
    DEL /Q "!zipName!"
)
IF EXIST "!FileURL!" (
    DEL /Q "!FileURL!"
)
IF EXIST "!llvm_version!" (
    DEL /Q "!llvm_version!"
)
:: PROMPT DIALOG
ECHO MsgBox "COMPLETED", vbInformation, "C_CPP_UPDATING......." >!USERPROFILE!\tEmP.vbs
ECHO Set oFso = CreateObject("Scripting.FileSystemObject") : oFso.DeleteFile Wscript.ScriptFullName, True >>!USERPROFILE!\tEmP.vbs
START !USERPROFILE!\tEmP.vbs
ENDLOCAL
DEL %0