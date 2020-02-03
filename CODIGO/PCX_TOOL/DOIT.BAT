@echo off
REM Este BAT HACE LA CONVERSION de un PCX/BMP a un AGM
REM Revision del 7/Oct/98
REM DAR DE PARAMETRO EL PCX/BMP (320x200)
REM Poner parametro -c para que no centre la imagen!
REM *** NO AJUSTA LA PALETTA DE LA IMAGEN ***
BSAVE2 -g %1 %2
BSAVE %1
