@ECHO OFF 
SETLOCAL ENABLEDELAYEDEXPANSION
::---------- 
set "FileURL=llvm_mingw.txt" 
set "zipName=llvm_mingw02112024.zip" 
set "llvmMingwDir=!USERPROFILE!\LLVM_MINGW" 
set "subName=LLVM_MINGW" 
set "folderName="

::-> Path Checking and Adding 
powershell -Command "$addPath = [System.IO.Path]::Combine($([System.Environment]::GetFolderPath('UserProfile')), 'LLVM_MINGW', 'LLVM_MINGW', 'bin'); $currentUserPath = [Environment]::GetEnvironmentVariable('Path', 'User'); if ($currentUserPath -notlike \"*$addPath*\") { $newUserPath = \"$currentUserPath;$addPath\"; [Environment]::SetEnvironmentVariable('Path', $newUserPath, 'User'); Write-Output \"The path '$addPath' was not present and has been appended to the user Path variable.\" } else { Write-Output \"The path '$addPath' is already present in the user Path variable.\" }"

::----------------------- 
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
if exist "!zipName!" ( 
    del "!zipName!" 
) 

:: DOWNLOAD THE LLVM-MINGW COMPILER WITH CuRL 
echo Downloading LLVM MinGW...
start /wait curl -L -o "!zipName!" "!mingw_url!" --progress-bar
::-> Displaying a Progress Bar
set "_spc=          "
set "_bar=■■■■■■■■■■"
setlocal enabledelayedexpansion

:: Function to show progress
call :showProgress
endlocal

::-> Extracting.............. 
if exist "!zipName!" ( 
    if exist "!llvmMingwDir!" ( 
        rd /S /Q "!llvmMingwDir!" 
    ) 
    :: Use PowerShell to extract the ZIP file 
    echo Extracting files...
    PowerShell -Command "Expand-Archive -Path '!zipName!' -DestinationPath '!llvmMingwDir!' -Force" 
) else ( 
    echo "!zipName! Does Not Exist" 
) 
::-> 
for /d %%F in ("%llvmMingwDir%\*") do ( 
    set "folderName=%%~nF" 
) 
::-> 
if defined folderName (   
    rem Rename the extracted folder to LLVM 
    ren "%llvmMingwDir%\!folderName!" "!subName!" 
    echo The folder has been renamed to: !subName! 
) 
REM CLEANING UP.... 
if exist "!zipName!" ( 
    del /Q "!zipName!" 
) 
if exist "!FileURL!" ( 
    del /Q "!FileURL!" 
) 
PAUSE 
endlocal 

goto :eof

:showProgress
for /L %%L in (1,1,10) do (
    <con: set /p "'= !CR!!BS!!CR![!_bar:~0,%%~L!!BS!!_spc:~%%~L!] " <nul & >nul timeout.exe /t 1
)
goto :eof
