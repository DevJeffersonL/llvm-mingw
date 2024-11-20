@ECHO OFF
CLS
ECHO.
ECHO        ::::::::: UPDATING C_CPP_COMPILER ::::::::::
ECHO. 
SETLOCAL ENABLEDELAYEDEXPANSION
::
set "FileURL=llvm_mingw.txt"
set "zipName=llvm_mingw02112024.zip"
set "llvmMingwDir=!USERPROFILE!\LLVM_MINGW"
set "subName=LLVM_MINGW"
set "folderName="
set ""
::-> Path Checking and Adding
powershell -Command "$addPath = [System.IO.Path]::Combine($([System.Environment]::GetFolderPath('UserProfile')), 'LLVM_MINGW', 'LLVM_MINGW', 'bin'); $currentUserPath = [Environment]::GetEnvironmentVariable('Path', 'User'); if ($currentUserPath -notlike \"*$addPath*\") { $newUserPath = \"$currentUserPath;$addPath\"; [Environment]::SetEnvironmentVariable('Path', $newUserPath, 'User') }"
::
if exist !FileURL! (
	curl https://raw.githubusercontent.com/DevJeffersonL/llvm-mingw/refs/heads/main/llvm_mingw02112024.txt >!FileURL!
) else (
	curl https://raw.githubusercontent.com/DevJeffersonL/llvm-mingw/refs/heads/main/llvm_mingw02112024.txt >>!FileURL!
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
if exist "!zipName!" (
    del /Q "!zipName!"
)
if exist "!FileURL!" (
    del /Q "!FileURL!"
)
ECHO MsgBox "COMPLETED", vbInformation, "C_CPP_UPDATING......." >!USERPROFILE!\tEmP.vbs
ECHO Set oFso = CreateObject("Scripting.FileSystemObject") : oFso.DeleteFile Wscript.ScriptFullName, True >>!USERPROFILE!\tEmP.vbs
START !USERPROFILE!\tEmP.vbs
ENDLOCAL
DEL %0