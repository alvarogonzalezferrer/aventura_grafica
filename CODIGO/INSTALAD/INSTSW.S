;ROCK BABY SHAREWARE - INSTALACION - POR ALVARO GONZALEZ FERRER 
;Directorio Destino
DestDir="C:\\ROCKSHAR"
; Define barra archivos
defbar BLACK,WHITE,WHITE,BLACK,14,7,52
clrscr

; Fondo principal
setcolor DARKGRAY,BLACK
window 1,1,80,25
clrscr 219
; Ventana principal
window 1,1,80,25

; AV info
box 3,3,68,8,YELLOW,BLUE,SINGLE
window 3,1,68,25
setcolor YELLOW,BLUE
gotoxy 1,3
ctext " Rock Baby! Shareware - Instalacion "
setcolor DARKGRAY,BLACK
window 5,9,69,9
clrscr 177
window 69,4,69,9
clrscr 177
window 4,4,67,7
setcolor LIGHTCYAN,BLUE
clrscr
; Campos
gotoxy 1,1
text " Por Alvaro Gonzalez Ferrer "
gotoxy 1,2
text " Copyright (c) 1999 "
gotoxy 1,3
text " Destino: "
gotoxy 1,4

window 1,1,80,25
; Linea del fondo
setcolor LIGHTCYAN,DARKGRAY
gotoxy 1,25
text " Presione F1 para Ayuda, ALT-X para salir                                       "

; Sombra 
setcolor DARKGRAY,BLACK
window 25,17,56,17
clrscr 177
window 54,11,56,17
clrscr 177
window 1,1,80,25

; Sonido 
sound 90,1

; Menu instalacion

Menu:
; Valores
window 4,4,67,7
gotoxy 11,2
setcolor WHITE,BLUE
text DestDir
window 1,1,80,25

Choice = menu 25,10,BLACK,WHITE,1,"Menu de instalacion"," Informacion importante"," Directorio Destino "," Instalar"," Salir"

if Choice == 0
      goto Quit
endif
if Choice == 1
      call informacion
      Goto Menu
endif
if Choice == 2
     savescr 1
     setcolor WHITE,CYAN
     window 11,10,67,15
     clrscr
     box 4,2,54,5,WHITE,CYAN,SINGLE
     gotoxy 20,2
     text " Directorio destino: "
     window 15,12,63,13
     clrscr
     setcolor WHITE,CYAN
     gotoxy 4,1 
     text "Escriba el directorio en donde desea instalar:"
     window 18,13,60,13
     Res=INPUT DARKGRAY,WHITE,DestDir,DestDir,42
     restscr 1
     window 1,1,80,25
     goto Menu
endif

if Choice == 3
  box 6,11,76,24,LIGHTCYAN,BLUE,DOUBLE
  setcolor LIGHTCYAN,BLUE
  gotoxy 27,11
  ctext " Instalacion "
  window 7,12,75,23
  clrscr
  text "Empezo la instalacion.\n"
  inswrow=4
  window 1,1,80,25
endif

if Choice == 4
Quit:
     setcolor WHITE,BLACK
     clrscr
     gotoxy 2,3
     text "El paquete no fue instalado..."
     sound 380,25
     sound 190,25
     exit 1
     goto Menu
endif

; Aqui empieza la instalacion!!!!!!!!!!!
INSTALL


;procedimientos
proc OnKey
;esto es llamado cada vez que toca una tecla     
     window 1,1,80,25
     if Par1 == 3
          savescr 15
          Par1=-1
          sound 2300,25
          sound 1450,100
          Choice=Menu 22,11,WHITE,LIGHTRED,1,"Ctrl-Break"," Abortar "," Continuar instalacion "
          if Choice == 1
               exit 1
          endif
          restscr 15
     endif

     if Par1 == 301
           goto Quit
     endif

     if Par1 == 315
          savescr 15
          call OutHelp
          Par1=-1
          restscr 15
     endif
endp

proc ChangeVol
;esto es llamado para cambiar de diskette
     window 7,12,75,23
     setcolor YELLOW,BLUE
     gotoxy 1,inswrow

     if Par2 == 0
           text ".. Diskette #",Par1," debe ser instalado."
           savescr 14
           Par1=-1
           sound 2300,25
           sound 1450,100
           sound 5450,50
           sound 7450,25
           sound 1450,100
                 window 1,1,80,23

           Choice=Menu 22,11,WHITE,GREEN,1," Cambie diskette "," Procesar el proximo diskette "," Salir "

           restscr 14

           if Choice == 2
                 window 7,12,75,23
                 inswrow=inswrow+1
                 gotoxy 1,inswrow
                 text " No se encontro el diskette. Saliendo..."
                 exit 1
           endif
     endif

     if Par2 != 0
           setcolor LIGHTCYAN,BLUE
           text ".. Diskette #",Par1," fue procesado."
     endif

     if inswrow = 12
           text "\n"
     endif

     if inswrow < 12
           inswrow=inswrow+1
     endif
     window 1,1,80,25
endp

proc FileDone
     ;esto es llamado cuando pasa un archivo (imprime el archivo que sigue)
     window 7,12,75,23
     setcolor LIGHTCYAN,BLUE
     gotoxy 1,inswrow
     text DestFileName
     if inswrow = 12
           text "\n"
     endif
     if inswrow < 12
           inswrow=inswrow+1
     endif
     window 1,1,80,25
endp

proc Error
;esto controla los errores
     window 7,12,75,23
     setcolor LIGHTCYAN,BLUE
     gotoxy 1,inswrow

     Title="Error"

     ; Par1 tiene el codigo de error

     if Par1 == 1
           Message="Error Fatal"
           call ErrMsg
     endif

     if Par1 == 2
           Message="CRC error, archivo roto"
           call ErrMsg
     endif

     if Par1 == 3
           Message="Error de escritura"
           call ErrMsg
     endif

     if Par1 == 4
           Message="Error creacion archivo"
           call ErrMsg
     endif

     if Par1 == 5
           Message="Error de lectura"
           call ErrMsg
     endif

     if Par1 == 6
           Message="Error al cerrar archivo"
           call ErrMsg
     endif

     if Par1 == 7
           Message="Error abriendo archivo"
           call ErrMsg
     endif

     if Par1 == 8
           Message="No hay memoria suficiente"
           call ErrMsg
     endif

     if inswrow = 12
           text "\n"
     endif

     if inswrow < 12
           inswrow=inswrow+1
     endif
     window 1,1,80,25
endp

proc ErrMsg
     ;mensaje de error
     window 17,14,62,21
     setcolor WHITE,RED
     clrscr
     window 1,1,80,25
     box 20,15,59,20,WHITE,RED,DOUBLE
     gotoxy 1,15
     ctext " ",Title," "
     gotoxy 1,17
     ctext Message
     setcolor WHITE,BLACK
     gotoxy 1,19
     ctext " Ok "
     sound 20,5
     sound 80,50
     delay 
     window 1,1,80,25
endp

proc ArcDone
     ;fin de la instalacion-sale del programa
     sound 3300,25
     
     sound 2450,100
     window 7,12,75,23
     setcolor LIGHTCYAN,BLUE
     gotoxy 1,inswrow
     text " Instalacion completada "
     
     savescr 2
     Title=" Instalacion "
     Message=" Completada "
     call OkMsg
     restscr 2
setcolor WHITE,BLACK
window 1,1,80,25
clrscr 32
     setcolor BLACK,WHITE
     box 14,6,65,16,BLACK,WHITE,DOUBLE
     gotoxy 30,6
     text " Instrucciones "
     window 15,7,64,15
     clrscr
     outtext on
 ROCK BABY! - AYUDA DEL INSTALADOR

 La instalacion fue finalizada.
 Lea el Archivo LEAME.TXT
 Ejecute SETUP.EXE para configurar el juego
 Luego ejecute ROCK.BAT para jugar
     
     outtext off
     setcolor WHITE,BLACK
     ctext " Ok "
     delay
     
     EXIT
endp

proc OkMsg
     ;mensaje de OK
     window 24,14,57,21
     setcolor BLACK,WHITE
     clrscr
     window 1,1,80,25
     box 27,15,53,20,BLACK,WHITE,DOUBLE
     gotoxy 1,15
     ctext " ",Title," "
     gotoxy 1,17
     ctext Message
     setcolor WHITE,BLACK
     gotoxy 1,19
     ctext " Ok "
     delay
     window 1,1,80,25
endp

proc OutHelp
     ;ayuda instantanea
     setcolor BLACK,CYAN
     box 14,6,65,20,BLACK,CYAN,SINGLE
     gotoxy 37,6
     text " Ayuda "
     window 15,7,64,19
     clrscr
     outtext on
 ROCK BABY! - AYUDA DEL INSTALADOR

 Para instalar elija el directorio destino,
 entonces presione ENTER en el item "instalar"
 del menu.

 Despues de instalar, los archivos estaran
 en el directorio deseado.

 Si se le pide que cambie de diskette, inserte
 el diskette siguiente y continue la instalacion.

     outtext off
     delay
endp

proc informacion
          savescr 14
     ;info del programa
     setcolor WHITE,RED
     box 14,3,65,23,YELLOW,RED,DOUBLE
     gotoxy 38,3
     ctext " ROCK BABY! - INFORMACION "
     window 15,4,64,22
     clrscr
     outtext on
Rock Baby!(r) es una "historieta interactiva"
En los sucesivos cuadros de la historieta, 
el jugador (usted) toma las decisiones.
Existen m£ltiples historias y finales 
dependiendo de su elecci¢n.
Similar a una aventura grafica.
Incluye SEXO, ALCOHOL & ROCK 'N ROLL!
Grandiosas animaciones, peleas, disparos, etc

**Version Shareware U$S 20 + gastos envio **

Requiere 386, VGA, Disco Rigido y 200 Kb RAM
Recomendado: Pentium, Disco Rigido con cache 
             tipo Smartdrv y 400 Kb RAM 
Lea el archivo LEAME.TXT para mas informaci¢n
luego de instalar el juego.
     outtext off
     delay
          restscr 14
endp

