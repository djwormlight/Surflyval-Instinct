@echo on
setlocal

:: Set your game name and paths
set GAMENAME=surflyval-instinct
set LOVE_VERSION=love-11.5-win32
set LOVE_PATH=C:\Program Files\LOVE
set BUILDDIR=build

:: Create the build directory
if exist %BUILDDIR% (
    rmdir /s /q %BUILDDIR%
)
mkdir %BUILDDIR%

:: Create the .love file using 7-Zip
echo Creating .love file with 7-Zip...
cd src
if exist %GAMENAME%.love del %GAMENAME%.love
"C:\Program Files\7-Zip\7z.exe" a -tzip ..\%BUILDDIR%\%GAMENAME%.love *
cd ..

:: Copy love.exe to the build directory
echo Copying LÖVE executable...
copy /y "%LOVE_PATH%\love.exe" "%BUILDDIR%\%GAMENAME%.exe"

:: Combine love.exe and the .love file
echo Combining .love with love.exe...
cd %BUILDDIR%
copy /b %GAMENAME%.exe+%GAMENAME%.love %GAMENAME%.exe
del %GAMENAME%.love

:: Copy necessary DLLs to the build directory
echo Copying necessary DLLs...
copy /y "%LOVE_PATH%\*.dll" .

:: Clean up
echo Cleaning up...
del love.exe

:: Final message
echo Build complete! The executable is located in the %BUILDDIR% directory.
cd ..
endlocal
pause