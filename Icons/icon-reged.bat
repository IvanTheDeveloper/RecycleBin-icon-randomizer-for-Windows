@echo off
setlocal enabledelayedexpansion

:: Obtener la ruta del directorio del archivo .bat
set "ruta_actual=%~dp0"

:: Comprobar si la carpeta "full" existe
if not exist "%ruta_actual%\full\" (
	echo La carpeta "full" no se encuentra en el directorio actual.
	set "error=1"
)
:: Comprobar si la carpeta "empty" existe
if not exist "%ruta_actual%\empty\" (
	echo La carpeta "empty" no se encuentra en el directorio actual.
	set "error=1"
)
:: Comprobar si el archivo "config.ini" existe
if not exist "%ruta_actual%\config.ini" (
	echo El archivo "config.ini" no se encuentra en el directorio actual.
	set "error=1"
)
:: Si hay algún error, mostrar un mensaje de error
if defined error (
	echo Error: Faltan elementos necesarios en el directorio actual.
	pause
	exit
)

:: Leer el valor "Startup" del archivo INI
for /f "usebackq delims=" %%A in (`findstr /r /c:"^Startup=" "%ruta_actual%\config.ini"`) do set "Startup=%%A"
set "Startup=!Startup:~8!"

:: Verificar si el valor es "true" y el archivo no existe
if "!Startup!"=="true" (
	if not exist "%USERPROFILE%\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\reged.lnk" (
		set "sourceFile=%ruta_actual%\reged.bat"
		set "destinationFolder=%USERPROFILE%\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup"
		set "shortcutName=reged.lnk"

		:: Crea el acceso directo
		powershell -command "$WshShell = New-Object -ComObject WScript.Shell; $Shortcut = $WshShell.CreateShortcut('%destinationFolder%\%shortcutName%'); 	$Shortcut.TargetPath = '%sourceFile%'; $Shortcut.Save()"
		echo Startup has been enabled.
	) else ( echo Startup is currently enabled.
		)
)
:: Verificar si el valor es "false" y el archivo existe
if "!Startup!"=="false" (
	if exist "%USERPROFILE%\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\reged.lnk" (
		del "%USERPROFILE%\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\reged.lnk"
		echo Startup has been disabled.
	) else ( echo Startup is currently disabled.
		)
)

:: Leer el valor "Mode" del archivo INI
for /f "usebackq delims=" %%A in (`findstr /r /c:"^Mode=" "%ruta_actual%\config.ini"`) do set "Mode=%%A"
set "Mode=!Mode:~5!"

:: Contar el número de archivos de las carpetas de iconos
set "contador=0"
for %%F in ("%ruta_actual%\empty\*.*") do (
	set /a "contador+=1"
)

:: Verificar el modo.
if "!Mode!"=="random" (
	if !contador! gtr 0 (
		set /a "elegido=!random! %% contador + 1"
		echo Elegido icono numero !elegido! de !contador!
	)
) else if "!Mode!"=="auto" (
	:: Obtener el valor de "empty" en la clave del registro especificada
	for /f "tokens=2,*" %%a in ('reg query "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\CLSID\{645FF040-5081-101B-9F08-00AA002F954E}\DefaultIcon" /v "empty" ^| findstr /i "empty"') do (
		:: Utilizar la variable %%b y quitar la ruta absoluta y la extensión.
		for %%c in (%%~nb) do set "Icon=%%~c"
	)
	:: Incrementar el valor de icon y contador en 1
	set /a "Icon+=1"
	set /a "contador+=1"
	:: Volver a 1 si alcanza el valor maximo
	if !Icon! equ !contador! set "Icon=1"
	set "elegido=!Icon!"
	echo Icono siguiente: !Icon!
) else if "!Mode!"=="fixed" (
	:: Leer el valor "Icon" del archivo INI
	for /f "usebackq delims=" %%A in (`findstr /r /c:"^Icon=" "%ruta_actual%\config.ini"`) do set "Icon=%%A"
	set "Icon=!Icon:~5!"
	set "elegido=%Icon%"
	echo Icono actual: !Icon!
)

:: Cambiar el icono de la papelera vacía
REG ADD "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\CLSID\{645FF040-5081-101B-9F08-00AA002F954E}\DefaultIcon" /v empty /t REG_EXPAND_SZ /d "%ruta_actual%\empty\!elegido!.ico,0" /f

:: Cambiar el icono de la papelera llena
REG ADD "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\CLSID\{645FF040-5081-101B-9F08-00AA002F954E}\DefaultIcon" /v full /t REG_EXPAND_SZ /d "%ruta_actual%\full\!elegido!.ico,0" /f

:: Reiniciar el explorador de Windows para que se reflejen los cambios
start rundll32.exe user32.dll,UpdatePerUserSystemParameters

:: Mensaje de finalización
echo Proceso finalizado.
pause