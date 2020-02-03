'Este programa automaticamente convierte todos los PCX a AGMs
'llamando a DO.BAT con los parametros.
'Por Alvaro Gonzalez Ferrer - 23/Abril/1999
CLS
PRINT "Este programa automaticamente convierte todos los PCX a AGMs"
PRINT "llamando a DO.BAT con los parametros."
PRINT "Por Alvaro Gonzalez Ferrer - 23/Abril/1999"
PRINT
PRINT "Presione una tecla para empezar - ESC cancela "
PRINT "Recuerde presionar la BARRA entre cada archivo para que los convierta!."
DO
a$ = INKEY$
LOOP WHILE a$ = ""
IF a$ = CHR$(27) THEN SYSTEM

PRINT "Trabajando! "
SHELL "dir /B *.PCX > LISTA.TMP"
OPEN "LISTA.TMP" FOR INPUT AS #1
IF EOF(1) THEN
        PRINT "ERROR: "
        PRINT "NO HAY ARCHIVOS PCX!"
        CLOSE 1
        KILL "LISTA.TMP"
SYSTEM
END IF
DO
        LINE INPUT #1, ruta$
        SHELL "do " + ruta$
LOOP UNTIL EOF(1)
CLOSE
KILL "LISTA.TMP"
SYSTEM

