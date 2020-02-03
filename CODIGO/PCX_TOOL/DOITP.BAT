@echo off
REM Ajuste de colores Automatico y conversion
REM Este BAT HACE LA CONVERSION de un PCX/BMP a un AGM
REM Revision del 2/Diciembre/98
REM DAR DE PARAMETRO EL PCX/BMP (320x200)
REM Poner parametro -C para que no centre la imagen!
BSAVE2 -g %1 %2
BSAVE %1
REM Ajuste de colores Automatico
PALETA %1
