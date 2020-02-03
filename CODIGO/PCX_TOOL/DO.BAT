@ECHO OFF
REM Ajuste de colores Automatico y conversion
REM Este BAT HACE LA CONVERSION de un PCX/BMP a un AGM
REM Revision del 31/Diciembre/98 (Casi A¥O NUEVO!)
REM Por Alvaro D.C Gonzalez Ferrer
REM
REM DAR DE PARAMETRO EL PCX/BMP (320x200)

BSAVE2 -g -c %1 %2
IF NOT ERRORLEVEL 1 GOTO OK
ECHO Ajuste de colores Automatico y conversion
ECHO.
ECHO Ocurrio un error...
ECHO Recuerde colocar la extension y nombre correctos del archivo.
ECHO Recuerde ademas que el tama¤o maximo es 320x200 y los colores son 256
ECHO Ejemplo: DO FONDO.PCX
ECHO.
ECHO Este BAT HACE LA CONVERSION de un PCX/BMP a un AGM
ECHO Revision del 31/Diciembre/98; 21:05 (Casi A¥O NUEVO!)
ECHO Por Alvaro D.C Gonzalez Ferrer - Copyrigth (c) 1998, AGF SOFT
ECHO.
GOTO FIN
:OK
CONVERT %1
:FIN
