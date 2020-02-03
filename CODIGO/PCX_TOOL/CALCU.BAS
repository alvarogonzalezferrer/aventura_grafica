'Calcula una cantidad x de imagenes de 320x200 cuantos mega ocupan
CLS
PRINT "Calcula una cantidad de imagenes AGM cuantos mega ocupan"
PRINT "Por Alvaro D.C Gonzalez Ferrer - 17/E/1999"
INPUT "Ancho (320) ", x
IF x < 1 THEN x = 320

INPUT "Alto (200) ", y
IF y < 1 THEN y = 200

t& = x * y
t& = t& + 1792
INPUT "Cantidad  de Imagenes ", c

PRINT c; "imagenes de "; x; "x"; y; " ocupan ";
PRINT USING "###,###.## megabytes"; (t& * c) / 1048576   'divide x megas
PRINT "En bytes: "; USING "###,###,###,### bytes"; t& * c
PRINT "Cada una ocupa "; USING "###,###,###,### bytes"; t&
SYSTEM

