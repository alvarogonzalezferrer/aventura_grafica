@echo off
REM RARea un SFX sin el PATH, con volumen de 1430Kb, y usando la instalacion
REM el programa REGISTRADO contenido en C:\PROGRAMA\AVENTURA\ROCKREG
REM Es solido

rar a -ep -s -sfxC:\rar\idos.sfx -zinstREG.s -v1430 INSTROCK.exe C:\PROGRAMA\AVENTURA\ROCKREG\*.*
