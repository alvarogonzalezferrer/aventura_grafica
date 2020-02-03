'**PROGRAMA QUE CARGA UN PCX DE 320X200X256 A PANTALLA!
'POR ALVARO GONZALEZ FERRER!
'
'ESTE PROGRAMA LEE EL ENCABEZADO DE UN PCX
'EXTRAIDO DE UN PC USERS - A¥O IV - 21 - 1993
'LO SAQUE DE LA BIBLIOTECA DEL NACIONAL
'TRADUCIDO A BASIC POR AGF.
'el header tiene 128 bytes
'byte   item            tam     descripcion
'0      fabricante      1       constante 10=zsoft.pcx
'1      version         1       version
'                               0 = 2.5
'                               2 = 2.8 c/paleta de colores
'                               3 = 2.8 s/paleta de colores
'                               5 = 3.0
'2      codificacion    1       1 = .pcx run-length
'3      bits x pixel    1       bits*pixel*plano
'4      ventana         8       dimensiones del dibujo
'                               (xmin,ymin) - (xmax, ymax)
'                               en pixeles, inclusive
'12     resol. hor.     2       resolucion horizontal del dispositivo que
'                               lo genero          
'14     resol. ver.     2       resolucion vertical etc
'16     colores         48      paleta de colores
'64     reservado       1
'65     planos          1       numero de planos
'66     bytes por linea 2       numero de bytes por linea de exploracion por plano
'68     informacion     2       como interpretar la paleta
'       paleta                  1=color/BN 2=tonos gris
'70     relleno         58      ceros para completar 128 bytes
'
'USAR FUNCION "CVI" PARA TRANSPORTAR LOS NUMEROS A DECIMALES! (mayores a 1 byte)

TYPE lectura
        byteleido AS STRING * 256
END TYPE
DIM lecto AS lectura
ON ERROR GOTO errores
SCREEN 9
PCX$ = "rutat1.PCX"'ARCHIVO PCX
CLS
FILES "*.pcx"
INPUT "Archivo PCX: "; PCX$
IF INSTR(PCX$, ".") < 1 THEN PCX$ = PCX$ + ".PCX"
PRINT PCX$
PRINT
OPEN PCX$ FOR INPUT AS #1
PRINT "Informacion: "
PRINT "MARCA: ";
'byte 0 (1 en qbasic)
marca = ASC(INPUT$(1, #1))
IF marca = 10 THEN
        PRINT "Zsoft"
ELSE
        PRINT "Desconocida"
END IF

PRINT "Version: ";
version = ASC(INPUT$(1, #1))
SELECT CASE version
CASE 0
        PRINT "2.5"
CASE 2
        PRINT "2.8 c/paleta de colores"
CASE 3
        PRINT "2.8 s/paleta de colores"
CASE 5
        PRINT "3.0"
CASE ELSE
        PRINT "Version desconocida "; version
END SELECT

PRINT "Metodo: ";
metodo = ASC(INPUT$(1, #1))
PRINT metodo; ";";
IF metodo = 1 THEN
        PRINT "PCX RUN LENGTH"
ELSE
        PRINT "--desconocido--"
END IF

PRINT "Bits x pixel: ";
bits.pixel = ASC(INPUT$(1, #1))
PRINT bits.pixel

PRINT "Dimensiones: "
xmin = CVI(INPUT$(2, #1))
ymin = CVI(INPUT$(2, #1))
xmax = CVI(INPUT$(2, #1))
ymax = CVI(INPUT$(2, #1))
PRINT "Xmin:"; xmin; "³Xmax:"; xmax; "³Dimension:"; xmax - xmin + 1; "pixels"
PRINT "Ymin:"; ymin; "³Ymax:"; ymax; "³Dimension:"; ymax - ymin + 1; "pixels"
xres = CVI(INPUT$(2, #1))
yres = CVI(INPUT$(2, #1))
PRINT "Resolucion del dispositivo que lo genero: "
PRINT "Vertical:"; xres; " Horizontal:"; yres
'lee los 48 bytes de los 16 colores + 1 byte reservado
a$ = INPUT$(49, #1)
'lee los planos (1 byte)
planos = ASC(INPUT$(1, #1))
PRINT "Planos: "; planos
bytes.linea = CVI(INPUT$(2, #1))
PRINT "Bytes por linea "; bytes.linea
paleta = CVI(INPUT$(2, #1))
PRINT "Paleta ";
IF paleta = 1 THEN PRINT "Color ¢ BN "
IF paleta = 2 THEN PRINT "Escala de grises"
IF paleta < 1 OR paleta > 2 THEN PRINT "Desconocida; "; paleta
PRINT
PRINT "Linea completa sin comprimir: "; bytes.linea * planos; " pixels"
PRINT "--presione una tecla--"
WHILE INKEY$ = ""
WEND
CLOSE

SCREEN 13
ruta$ = PCX$
GOSUB leer:
DO: LOOP WHILE INKEY$ = ""

SYSTEM

errores:
SCREEN 0
PRINT "Error"; ERR
CLOSE
SYSTEM


leer:
'lee el archivo PCX de RUTA$, requiere modo 320x200
'el header fue previamente leido por la rutina anterior y los
'datos de color, ancho,largo debidamente leidos
OPEN ruta$ FOR BINARY AS #1

'arma la paleta de colores primero
c = 0
a = LOF(1) - 768 '256*3 RGB + 1 byte de comprobacion de existencia de paleta
GET #1, a, lecto
r = ASC(MID$(lecto.byteleido, 1, 1))
IF r <> 12 THEN RETURN'no tiene paleta
a = a + 1
DEF SEG = &HA000
c = 0
DO
GET #1, a, lecto
      
        r = ASC(MID$(lecto.byteleido, 1, 1))
      
        g = ASC(MID$(lecto.byteleido, 2, 1))
      
        b = ASC(MID$(lecto.byteleido, 3, 1))
      
        'convertirlos a 0 a 64 (en vez de 0 a 255]
        'si no, los colores salen distorsionados!
        r = CINT(r / 4)
        g = CINT(g / 4)
        b = CINT(b / 4)
      
        IF c < 0 OR c > 255 THEN EXIT DO:
       
        OUT &H3C8, c
        OUT &H3C9, r
        OUT &H3C9, g
        OUT &H3C9, b
        c = c + 1
        IF c > 255 THEN EXIT DO
        a = a + 3

LOOP UNTIL c > 255 OR a >= LOF(1)



'lee la imagen y la descomprime en pantalla
totalbytes = (bytes.linea * planos) - 1
x = 0
y = 0
a = 128
DO
GET #1, a, lecto
'carga 256 bytes en memoria y los lee para mas velocidad
FOR k = 1 TO LEN(lecto.byteleido)
        ZZ% = ASC(MID$(lecto.byteleido, k, 1))
'si los dos primeros bits son 1, cuenta 6 bits mas bajos de X, datos=siguiente byte de X
IF ZZ% - 192 > 0 THEN '192=&O11000000
'6 bits mas bajos de la lectura
        cuen = ZZ% - 192 'SACA LOS BITS MENOS SIGNIFICANTES
        'color a escribir
        k = k + 1
        IF k > 256 THEN 'si se pasa, leer los datos siguientes
                a = a + 256
                GET #1, a, lecto
                k = 1
                ZZ% = ASC(MID$(lecto.byteleido, k, 1))
        ELSE
                ZZ% = ASC(MID$(lecto.byteleido, k, 1))
        END IF
        
                LINE (x, y)-(x + cuen, y), ZZ%
                x = x + cuen
        IF x > totalbytes THEN x = 0: y = y + 1
ELSE
                PSET (x, y), ZZ%
                x = x + 1
                IF x > totalbytes THEN x = 0: y = y + 1
END IF
                IF y > ymax - ymin THEN EXIT DO

NEXT

a = a + 256
d$ = INKEY$
IF d$ <> "" THEN EXIT DO

LOOP WHILE a < LOF(1)

CLOSE
RETURN

