@echo off

:: Copy demo contents to app data

mkdir %APPDATA%\..\Local\Kengine\mods
xcopy %YYprojectDir%\..\demo\mods %APPDATA%\..\Local\Kengine\mods /E /Y
