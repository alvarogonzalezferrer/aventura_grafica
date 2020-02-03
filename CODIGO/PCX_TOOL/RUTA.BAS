'Programa que dibuja perspectivas para hacer rutas.
'Por Alvaro Gonzalez Ferrer (c) 1999, AGF
'Version mejorada - LA PINTA ALTERNADAMENTE
CLS
PRINT "RUTA.BAS"
PRINT
PRINT "Programa que dibuja perspectivas para hacer rutas."
PRINT "Por Alvaro Gonzalez Ferrer (c) 1999, AGF"
PRINT "Luego, pueden ser capturadas a PCX x NEOGRAB, y pintadas con texturas."
PRINT "Esto solo dibuja las lineas basicas en 320Xruta200Xruta256."
COLOR 15, 4
PRINT "Mientras este en la pantalla de ajuste, F1 proporciona ayuda."
PRINT
COLOR 7, 0
PRINT "Presione una tecla..."
DO: LOOP WHILE INKEY$ = ""
'coordenadas comienzo de la ruta (parte inferior)
xruta1 = 0
xruta2 = 320
yruta1 = 200
yruta2 = 200
'COLOR DE LA RUTA Y HORIZONTE
colruta = 11
'COLOR DE LINEA CENTRAL
colcent = 10
'COLOR DE LINEAS LATERALES
collat = 10
'color lineas de perspectiva 1 y 2
colpasos = 6

'posicion del punto de fuga de la perspectiva
xfuga = 50
yfuga = 45

'posicion "y" del horizonte (-1 = inexistente)
horizonte = 50
'ANCHO LINEA CENTRAL
ALINEA = 10
'coordenadas inicio de la linea de ruta, LAS Y SON IGUAL A LA YRUTA
xlinea1 = xruta2 / 2 - ALINEA
xlinea2 = xruta2 / 2 + ALINEA

'ANCHO DE LAS LINEAS LATERALES DE LA RUTA
ancholateral = 10
'DISTANCIA DE LA BANDA LATERAL DE LA RUTA
distlateral = 15

'intervalo para hacer las lineas de horizonte falsas que cortan la ruta
'
intervalo = 40
dibuint = 1
YSTART = 200 - intervalo


'parametros para dibujar los distintos elementos
dibucentro = 1
dibulateral = 1

'parametro 1 o 0 de comienzo, cuando es 1 pinta, 0 no pinta
'variar de 1 a 0 y vs para pintar alternadamente
pintar = 1
ZOOMOUT = 0

'dibuja el horizonte
SCREEN 13
GOSUB dibujar

DO
d$ = UCASE$(INKEY$)
IF d$ = CHR$(27) THEN GOTO finaliza
IF d$ = CHR$(0) + ";" THEN GOSUB ayuda
IF d$ = CHR$(13) THEN 'alternar pintura
        IF pintar = 1 THEN pintar = 0 ELSE pintar = 1
END IF
IF d$ = CHR$(8) THEN 'hacer cuadro intermedio entre ambos (sin UNDO)
        'backspace
  IF YSTART = 200 - intervalo THEN
        YSTART = 200 - (intervalo / 2)
  ELSE
        YSTART = 200 - intervalo
  END IF
END IF
IF d$ = CHR$(9) THEN 'ZOOM
        'TAB - ZOOM
        IF ZOOMOUT = 1 THEN ZOOMOUT = 0 ELSE ZOOMOUT = 1
END IF

'perspectiva ON/OFF <BARRA>
IF d$ = " " THEN
        dibuint = -dibuint
END IF
'hacer la linea central (Z)
IF d$ = "Z" THEN
        dibucentro = -dibucentro
END IF
'hacer la linea central (X)
IF d$ = "X" THEN
        dibulateral = -dibulateral
END IF
IF d$ = "C" THEN 'alinear punto de fuga con horizonte
        yfuga = horizonte
END IF
IF d$ = "V" THEN 'alinear horizonte con punto de fuga
        horizonte = yfuga
END IF
IF d$ = "B" THEN 'centrar horizontal punto de fuga
        xfuga = 160
END IF

'mover los comienzos de las lineas ASDW,FGHT
IF d$ = "W" THEN yruta1 = yruta1 - 1
IF d$ = "S" THEN yruta1 = yruta1 + 1
IF d$ = "A" THEN xruta1 = xruta1 - 1
IF d$ = "D" THEN xruta1 = xruta1 + 1

IF d$ = "T" THEN yruta2 = yruta2 - 1
IF d$ = "G" THEN yruta2 = yruta2 + 1
IF d$ = "F" THEN xruta2 = xruta2 - 1
IF d$ = "H" THEN xruta2 = xruta2 + 1

'ANCHO DE LA RUTA 1 y 2
IF d$ = "1" THEN xruta1 = xruta1 - 1: xruta2 = xruta2 + 1
IF d$ = "2" THEN xruta1 = xruta1 + 1: xruta2 = xruta2 - 1

'horizonte arriba/abajo 3 y 4
IF d$ = "3" THEN horizonte = horizonte - 1
IF d$ = "4" THEN horizonte = horizonte + 1


'ANCHO LINEA DE RUTA SHIFT+1 (!) y SHIFT+2 (@)
IF d$ = "!" THEN ALINEA = ALINEA - 1
IF d$ = "@" THEN ALINEA = ALINEA + 1

xlinea1 = (xruta2 / 2) - ALINEA
xlinea2 = (xruta2 / 2) + ALINEA

'DISTANCIA LINEA LATERAL SHIFT+3 (#) y SHIFT+4 ($)
IF d$ = "#" THEN distlateral = distlateral - 1
IF d$ = "$" THEN distlateral = distlateral + 1


'ANCHO LINEA LATERAL 5 Y 6
IF d$ = "5" THEN ancholateral = ancholateral - 1
IF d$ = "6" THEN ancholateral = ancholateral + 1

'perspectiva (+.1) % y ^
IF d$ = "%" THEN intervalo = intervalo - 1
IF d$ = "^" THEN intervalo = intervalo + 1
IF intervalo < 2 THEN intervalo = 2

'COMIENZO DE LA PERSPECTIVA 7 Y 8
IF d$ = "7" THEN YSTART = YSTART - 1
IF d$ = "8" THEN YSTART = YSTART + 1

'mover punto de fuga: las flechas
IF d$ = CHR$(0) + "H" THEN yfuga = yfuga - 1
IF d$ = CHR$(0) + "P" THEN yfuga = yfuga + 1
IF d$ = CHR$(0) + "K" THEN xfuga = xfuga - 1
IF d$ = CHR$(0) + "M" THEN xfuga = xfuga + 1




IF d$ <> "" THEN GOSUB dibujar


LOOP

'---------------------------------------------------------
dibujar:
'dibuja el grafico
'BORRA LA PANTALLA
        CLS
'SITUA LA ESCALA DE DIBUJO
IF ZOOMOUT = 1 THEN
        'UN CUARTO DE PANTALLA, CENTRADO
        WINDOW SCREEN (-320, -200)-(640, 480)
ELSE
        'PANTALLA ENTERA
        WINDOW
END IF

'LINEA CENTRAL
IF dibucentro = 1 THEN
        LINE (xlinea1, 200)-(xfuga, yfuga), colcent
        LINE (xlinea2, 200)-(xfuga, yfuga), colcent
        y2 = (xlinea2 - xlinea1) / 2
        y2 = y2 + xlinea1

        IF NOT ZOOMOUT = 1 THEN PAINT (y2, 199), colcent, colcent
END IF

'lineas de interrupcion de horizonte

IF dibuint = 1 THEN
        IF intervalo > 0 THEN
                y = YSTART
                y2 = 200
                z = 200
                p2 = pintar
                DO
IF pintar = 1 THEN
        LINE (0, y2)-(320, y), colpasos, BF
        pintar = 0
ELSE
        pintar = 1
END IF
                y2 = y
                IF CINT(intervalo * (y / 200)) >= 1 THEN
                                y = y - (intervalo * (y / 200))
                                y = FIX(y)
                        ELSE
                                y = y - 1
                        END IF
                        z = z - 1
                'LOOP UNTIL y < horizonte OR z < 0 OR CINT(y) <= 0
        LOOP UNTIL CINT(y) <= 0
        pintar = p2
        END IF
END IF
'------

'BANDA LATERAL

IF ancholateral > -1 AND dibulateral = 1 THEN
        LINE (xruta1 + distlateral, 200)-(xfuga, yfuga), collat
        LINE (xruta2 - distlateral, 200)-(xfuga, yfuga), collat
       
LINE (xruta1 + distlateral + ancholateral, 200)-(xfuga, yfuga), collat
LINE (xruta2 - distlateral - ancholateral, 200)-(xfuga, yfuga), collat
IF NOT ZOOMOUT = 1 THEN
        PAINT (xruta1 + distlateral + ancholateral - 1, 199), collat, collat
        PAINT (xruta2 - distlateral - ancholateral + 1, 199), collat, collat
END IF
END IF

'LINEA DE RUTA
      
        LINE (xruta1, 200)-(xfuga, yfuga), colruta
        LINE (xruta2, 200)-(xfuga, yfuga), colruta

'HORIZONTE
IF horizonte > -1 THEN
        LINE (0, horizonte)-(320, 0), 0, BF
        LINE (0, horizonte)-(320, horizonte), colruta
END IF


RETURN
'---------------------------------------------------------
ayuda:
        SCREEN 9
        PRINT "AYUDA: ";
        PRINT "Las teclas son:"
        PRINT "ASDW y TFGH para mover los laterales de la ruta."
        PRINT "1 y 2 para el ancho de la ruta."
        PRINT "3 y 4 para mover el horizonte"
        PRINT "! y @ para el ancho de linea central de ruta"
        PRINT "# y $ para la posicion de linea lateral de ruta"
        PRINT "5 y 6 para el ancho de linea lateral de ruta"
        PRINT "% y ^ para el intervalo de la pintura del suelo"
        PRINT "7 y 8 para el comienzo de la pintura del suelo"
        PRINT "<ESPACIO> para cambiar pintura del suelo ON/OFF"
        PRINT "Z cambiar linea central ON/OFF"
        PRINT "X cambiar linea lateral ON/OFF"
        PRINT "C alinear punto de fuga con horizonte"
        PRINT "V alinear horizonte con punto de fuga"
        PRINT "B centrar horizontal punto de fuga"
        PRINT CHR$(24); CHR$(25); CHR$(27); CHR$(26);
        PRINT " para cambiar la perspectiva (punto de fuga)"
        PRINT "ENTER para alternar pintura del suelo"
        PRINT "BACKSPACE hacer cuadro intermedio entre ambos (sin UNDO)"
        PRINT "ESC para salir - USE PRINT SCR si tiene NEOGRAB cargado para capturar pantalla"
        COLOR 14
        PRINT "TAB ZOOM IN/OUT (PARA SITUAR PUNTO DE FUGA FUERA DE PANTALLA!)"
        COLOR 15
        PRINT "Presione una tecla..."
DO: LOOP WHILE INKEY$ = ""
SCREEN 13

RETURN
'---------------------------------------------------------
finaliza:
SYSTEM

