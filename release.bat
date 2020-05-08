@echo off

IF EXIST build RMDIR /q /s build
IF EXIST "Weapon-Select-#.#.#.zip" DEL "Weapon-Select-#.#.#.zip"
MKDIR build
MKDIR build\WeaponSelect

REM Copy required files into build directory
XCOPY scripts build\WeaponSelect\scripts /s /e /i
XCOPY img build\WeaponSelect\img /s /e /i

REM Zipping contents
powershell.exe -nologo -noprofile -command "& { Add-Type -A 'System.IO.Compression.FileSystem'; [IO.Compression.ZipFile]::CreateFromDirectory('build', 'Weapon-Select-#.#.#.zip'); }"

REM Removing build directory
RMDIR /q /s build
