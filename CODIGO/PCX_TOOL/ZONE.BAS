'Esta rutina scanea la pantalla y determina el tama¤o de la imagen.
'Busca la esquina inferior (considerando al color 0 como nulo)
'Por AGF - 31 Diciembre 1998 (Fin de a¤o!)

'Grafico de prueba
SCREEN 13

DEF SEG = &HA000
RANDOMIZE TIMER
a = INT(RND * 30) + 1
FOR b = 1 TO a
x = INT(RND * 320) + 1
y = INT(RND * 150) + 1
c = INT(RND * 15) + 1
LINE -(x, y), c
CIRCLE (x, y), c, c
NEXT

'--------------------
y& = 0&
Y1& = 0&
FOR x1 = 0 TO 320

FOR Y1& = Y2& TO 200&
        d = POINT(x1, Y1&)
        PSET (x1, Y1&), 15 - d
       
        IF d > 0 THEN
        IF Y1& > y& THEN
                y& = Y1&
        END IF
        END IF
       
        
NEXT Y1&
        Y2& = y&

NEXT x1
'Tama¤o pantalla
y& = y& + 1&
IF y& > 200& THEN y& = 200&
TAM& = 320& * y&




'--------------------

DEF SEG = &HA000
BSAVE "Test.xxx", 0, TAM&

CLS
BLOAD "test.xxx"

PRINT "320 x"; y&
PRINT TAM&; " Bytes"
PRINT " AGM = "; TAM& + 1792&; " bytes"
END

