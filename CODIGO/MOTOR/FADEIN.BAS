'FADE IN - FUNCIONA V1.0 PASAR A ASIC!
DIM R1(255)
DIM G1(255)
DIM B1(255)

DIM R2(255)
DIM G2(255)
DIM B2(255)
DIM C2(255)

SCREEN 13
GOSUB RANDI:

'FADE OUT
FOR W = 0 TO 255
RANDOMIZE TIMER
X = INT(RND * 320) + 1
Y = INT(RND * 200) + 1
Z = INT(RND * 30) + 1
        CIRCLE (X, Y), Z, W
        PAINT (X, Y), W
NEXT

LOCATE 1, 1
FOR X = 0 TO 255
COLOR X
PRINT "Û";
NEXT


DEF SEG = &HA000
GOSUB LEEPALETA:
SLEEP 1

GOSUB OSCURO:

W = 255
ST = 5
C = 0

DO
C = C + 1
IF C > W THEN C = 0

A = C2(C)
R2(A) = R2(A) + ST
G2(A) = G2(A) + ST
B2(A) = B2(A) + ST

IF R2(A) < 0 THEN R2(A) = 0
IF G2(A) < 0 THEN G2(A) = 0
IF B2(A) < 0 THEN B2(A) = 0

IF R2(A) >= R1(A) - ST THEN
        R2(A) = R1(A)
END IF
IF G2(A) >= G1(A) - ST THEN
        G2(A) = G1(A)
END IF

IF B2(A) >= B1(A) - ST THEN
        B2(A) = B1(A)
END IF

'ESCRIBIR
OUT &H3C8, A

OUT &H3C9, R2(A)
OUT &H3C9, G2(A)
OUT &H3C9, B2(A)
IF B2(A) = B1(A) THEN
IF R2(A) = R1(A) THEN
IF G2(A) = G1(A) THEN
'OPTIMIZAR
        SWAP C2(C), C2(W)
        SWAP R2(C), R2(W)
        SWAP G2(C), G2(W)
        SWAP B2(C), B2(W)
        W = W - 1
A = C2(C)
END IF
END IF
END IF

LOOP UNTIL INKEY$ <> "" OR W < 1

BEEP
LOCATE 1, 1
FOR X = 0 TO 255
        COLOR X
        PRINT "Û";
NEXT
END


LEEPALETA:
'LEE LA PALETA Y LA PONE EN MATRIZ R1, G1, B1
DEF SEG = &HA000

FOR C = 0 TO 255

'LEERLO
OUT &H3C7, C

R1(C) = INP(&H3C9)
G1(C) = INP(&H3C9)
B1(C) = INP(&H3C9)

C2(C) = C 'ESTO SIRVE PARA OPTIMIZAR LA RUTINA

NEXT C

RETURN

OSCURO:
FOR C = 0 TO 255
        OUT &H3C7, C

        OUT &H3C9, 0
        OUT &H3C9, 0
        OUT &H3C9, 0

NEXT
RETURN

RANDI:
'GENERA PALETA AL AZAR
RANDOMIZE TIMER

FOR C = 0 TO 255
        R = INT(RND * 63)
        G = INT(RND * 63)
        B = INT(RND * 63)

        OUT &H3C7, C

        OUT &H3C9, R
        OUT &H3C9, G
        OUT &H3C9, B
'R = R + 1
'G = G + 1
'B = B + 1
'IF R > 63 THEN R = R - 63
'IF G > 63 THEN G = G - 63
'IF B > 63 THEN B = B - 63

NEXT
RETURN

