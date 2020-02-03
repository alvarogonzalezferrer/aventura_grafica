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
ON ERROR GOTO errores
SCREEN 9
PCX$ = "TEST.PCX"'ARCHIVO PCX
CLS
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
A$ = INPUT$(49, #1)
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
PRINT "--presione una tecla--"
WHILE INKEY$ = ""
WEND
SYSTEM

errores:
SCREEN 0
PRINT "Error"; ERR
CLOSE
SYSTEM


