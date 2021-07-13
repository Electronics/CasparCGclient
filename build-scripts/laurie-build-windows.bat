@echo off

pushd %1
cd ..\ || goto :error

set BUILD_DIR="build-Solution-Desktop_Qt_5_14_2_MinGW_64_bit-Release"
set BUILD_OUTPUT_DIR="build"

:: Clean and enter shadow build folder
echo Cleaning...
if exist %BUILD_OUTPUT_DIR% rmdir %BUILD_OUTPUT_DIR% /s /q || goto :error
mkdir %BUILD_OUTPUT_DIR% || goto :error

echo Copying dlls
cd %BUILD_DIR% || goto :error
for /r %%x in (*.dll) do (
	if not exist "..\%BUILD_OUTPUT_DIR%\%%~nx.dll" copy "%%x" "..\%BUILD_OUTPUT_DIR%\" /Y || goto :error
)

echo Copying main application
copy Shell\release\shell.exe "..\%BUILD_OUTPUT_DIR%\CasparCG Client.exe" || goto :error


:: Copy binary dependencies
echo Copying binary dependencies...
cd ..\%BUILD_OUTPUT_DIR% || goto :error
copy ..\deploy\win32\* . || goto :error
xcopy ..\deploy\win32\sqldrivers sqldrivers\ /E /I /Y || goto :error
xcopy ..\deploy\win32\plugins plugins\ /E /I /Y || goto :error
xcopy ..\deploy\win32\platforms platforms\ /E /I /Y || goto :error

:: Copy documentation
echo Copying documentation...
copy ..\CHANGELOG . || goto :error
copy ..\LICENSE . || goto :error

:: Skip exiting with failure
popd
pause
goto :EOF

:error
popd
pause
exit /b %errorlevel%
