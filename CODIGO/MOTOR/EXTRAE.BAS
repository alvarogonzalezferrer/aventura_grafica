'este programa lee un archivo GAI y dice
'todos los archivos necesarios para que ese archivo GAI funcione
'Por Alvaro G.F
'V1.0
DIM com$(10)
'comandos que especifican archivos
cantcom = 3
com$(1) = "GLOAD"
com$(2) = "ANIMA"
com$(3) = "RUN"

CLS
PRINT "Este programa lee un archivo GAI y dice todos los archivos necesarios para"
PRINT "que ese archivo GAI funcione "
PRINT "Por Alvaro G.F"
PRINT "V1.0"
PRINT "Crea una lista para copiarlos directo en COPYIT.TXT "
PRINT "Coloca el resultado en NECESAR.TXT (append al final del archivo en ambos)"
INPUT "Archivo .GAI ?", gai$
gai$ = LTRIM$(RTRIM$(UCASE$(gai$)))
IF gai$ = "" THEN SYSTEM
IF INSTR(gai$, ".") < 1 THEN gai$ = gai$ + ".GAI"


ON ERROR GOTO errores
OPEN gai$ FOR INPUT AS #1
OPEN "necesar.txt" FOR APPEND AS #2
OPEN "copyit.txt" FOR APPEND AS #3

PRINT #2, "Archivo "; gai$
PRINT "Archivos mencionados: "
DO
LINE INPUT #1, linea$
linea$ = LTRIM$(RTRIM$(UCASE$(linea$)))
'ignora las rems con ;
IF NOT LEFT$(linea$, 1) = ";" THEN
FOR a = 1 TO cantcom
'busca el comando

IF INSTR(linea$, com$(a)) THEN
        PRINT linea$
        PRINT #2, linea$
'saca comando
MID$(linea$, INSTR(linea$, com$(a)), LEN(com$(a))) = SPACE$(LEN(com$(a)))
'saca ","
WHILE INSTR(linea$, ",") > 0
        MID$(linea$, INSTR(linea$, ","), LEN(com$(a))) = " "
WEND
linea$ = LTRIM$(RTRIM$(linea$))
        PRINT #3, linea$

END IF
NEXT a
END IF

LOOP UNTIL EOF(1)
PRINT "Listo..."
PRINT #2, " -------------------------------------------------------------- "

SYSTEM
errores:
PRINT "Error "; ERR
SYSTEM

