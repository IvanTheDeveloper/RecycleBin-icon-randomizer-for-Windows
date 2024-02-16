Recycle Bin Icon Randomizer for windows (RBIR)

Instrucciones (en orden):

	1-Descomprimir el archivo ".zip".

	2-Para hacer que el programa se ejecute al inicio o deje de hacerlo, de manera que cada vez que se encienda el PC haya un icono aleatorio, basta con abrir el archivo config.ini y establecer como "true" el valor "startup".

	3-Si se quieren añadir iconos extra, simplemente hay que meter los archivos .ico en las carpetas "full" y "empty" respectivamente, asignandoles un nombre que será el número sucesivo al del resto de iconos (el mismo para ambos archivos).

	Por ejemplo, si queremos añadir un icono extra, y en la carpeta "empty" tenemos los archivos "1.ico", "2.ico" y "3.ico", tendriamos que nombrar a nuestro archivo "4.ico". Mismo proceso para la carpeta "full". Cabe destacar que ambas carpetas deben tener el mismo número de archivos, y estos ser complementarios en imagen y número si se desea obtener el resultado esperado.

¿Qué vas a encontrar en este directorio?:
Carpeta "empty" donde se almacenarán los iconos de papelera vacía.
Carpeta "full" donde se almacenarán los iconos de papelera llena.
Archivo "readme.me" (este archivo) con el tutorial de uso y los detalles de funcionamiento.
Archivo "config.ini" con valores predeterminados modificables para ajustar el funcionamiento del programa a gusto.
Archivo "source.txt" con el código fuente del .bat principal como copia de seguridad.
Archivo "icon-reged.bat" núcleo del programa que realiza el cambio de icono.

¿Cómo funciona?:
El .bat principal ejecuta una serie de comandos que eligen un numero al azar, buscan en las relativas carpetas el archivo correspondiente a ese número, y lo establecen como valor en la ruta "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\CLSID\{645FF040-5081-101B-9F08-00AA002F954E}\DefaultIcon" del editor de registro, añadiendo ",0" al final, lo que hace que los iconos cambien automáticamente sin tener que refrescar el escritorio.
Modificar el contenido del directorio o su orden sin conocimiento sobre lo que se está haciendo provocará que el programa deje de funcionar como se desea.
Proyecto inspirado por https://github.com/sdushantha/recycle-bin-themes

Versiones de S.O. compatibles probadas:
Windows 11
Windows 10
