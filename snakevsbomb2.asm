;-------------------------------------------
;SNAKE VS BOMB 2 - Canyon Run
;-------------------------------------------
;Written by Richard Bayliss
;Graphics by Hugues (Ax!s) Poisseroux
;Music / SFX by Richard Bayliss
;(C)2023 The New Dimension
;For Retro Programmers Inside Snake Game Jam
;------------------------------------------- 
;FORMAT = C64STUDIO/ACME

;Use $4700 as jump address in packer/cruncher
;to make executable. 

;-------------------------------------------
;Uncomment one of these features if needed for testing
;testgameend = 1
;testirqborder = 1
;-------------------------------------------

;Load source code that contain variables and 
;label
        !source "vars.asm"
;-------------------------------------------

;Generate main program 

        !to "snakevsbomb2.prg",cbm

;-------------------------------------------
        
;Load mountain charset data (Binary)        

        *=$0800 
        !bin "c64/mountains_charset.bin"
        
;-------------------------------------------        

;Load disk access code (Source)

        *=$1000
        !source "diskaccess.asm"
        
;-------------------------------------------        

;Load Sprite Pad V2.0 sprite data (Binary)

        *=$2000
        !bin "c64/sprites.bin"

;-------------------------------------------        

;Load Game charset data (Binary)        
        
        *=$3000  
gamecharset        
        !bin "c64/canyon_charset.bin"
        
;-------------------------------------------        

;Load text charset data (Binary)

        *=$3800  
titlecharset        
        !bin "c64/text_charset.bin" 
        
;-------------------------------------------        

;Load canyon screen map data (Binary)

        *=$4000 
canyon        
        !bin "c64/canyon_map.bin"

;-------------------------------------------
        
;Load mountains map data (Binary)

        *=$4400  
mountains        
        !bin "c64/mountains_map.bin"

;-------------------------------------------

;Snake vs bomb startup code
 
        *=$4700
        
;Check if C64 type is PAL or NTSC based. 
;This routine will check the raster size
;in order to get the correct system 
;settings

checksystem    
        lda $d012
        cmp $d012
        beq *-3
        bmi checksystem
        cmp #$20
        bcc ntsc 
        lda #$30
        sta leveltimeexpiry
        lda #1
        sta system
        jmp startmaincode 
ntsc    lda #0
        sta system 
        lda #$40
        sta leveltimeexpiry

;Start main code by loading in hi scores
;from disk
  
startmaincode       
        
        jsr loadhiscores
       
; ... then jump to the title screen code

        jmp titlescreen


;-------------------------------------------

;Load main game code

        !source "gamecode.asm"

;-------------------------------------------
     
;Load end screen code

        !source "endscreen.asm"

;-------------------------------------------        

;Load end screen (Binary)

endscreentext
        !bin "c64/endscreen.bin"
   

;-------------------------------------------

;Load title screen code 

        !source "titlescreen.asm"
        
;-------------------------------------------        
!align $ff,0 ;Align the memory to the next $xx00 bytes
      
;Load in hi score code 

        !source "hiscore.asm"

;-------------------------------------------
        
;Load relocated music data (Program format)
        *=$8000  
       !bin "c64/music.prg",,2           

;-------------------------------------------    
       
;Load credits screen matrix (Binary)

        *=$a400  
creditstext
        !bin "c64/text_credits.bin"
        
;-------------------------------------------        

;Load default hi score name list (Binary)

        *=$a600  
hiscoretable
        !bin "c64/text_hiscores.bin"


;-------------------------------------------        

;Load scoring list (Binary)
        *=$a800  

scoringlist
        !bin "c64/text_scoring.bin"
 
;-------------------------------------------        

;Load name message screen (Binary)

        *=$aa00  


namescreen 
        !bin "c64/text_nameentry.bin"         

;-------------------------------------------        
    
;Title screen scroll text message

       *=$b000 
       
       !ct scr ;Convert to C64 screen text
       
scrolltext
       !text "                                                          "
       !text " ... snake vs bomb 2 - canyon chaos ...   "
       !text "participated in the retro programmers inside (rpi) and phaze101 retro snake game jam ...   "
       !text "graphics and game design by hugues (ax!s) poisseroux ...   "
       !text "programming, charset, sound effects and music by richard bayliss ...   "
       !text "copyright (c) 2023 the new dimension ...   like with all of my productions on richard-tnd.itch.io, this is non-commercial software ...   "
       !text "you are welcome to copy, share or use parts of this production, providing that no part of it is being sold commerically without my permission "
       !text "to do so ...    and now, on with the game instructions ...   this is a fun sequel to the first snake vs bomb, which i had launched in december 2022 ...   " 
       !text "this time, it features horizontal parallax scrolling and could be even tougher and more challenging ...    "
       !text "your hungry snake is on a long journey along the road across a huge canyon ...   help your slithering friend safely and eat the fruit, but avoid touching the deadly bombs, otherwise your snake will be no more ...   you "
       !text "will encounter many of these deadly bombs on the way ...   you will score a bonus of 1,000 points for every level completed ...   the snake is controlled by using up and down on your "
       !text "joystick (plugged into port 2) ...   you can pause the game with control, spacebar or fire will resume play or pressing back arrow key will abort game ...   try to complete all eight levels and reach the top of the table if you can ...   "
       !text "good luck! ...    this game was programmed and compiled using endurion's c64studio v7.3.1 and v7.4 "
       !text "...   the graphics were drawn by hugues using multipaint by dr. terrorz, charpad v2.7.6 (free edition) and spritepad v2.0 by subchrist software ...   i designed the 1x1 text charset and converted to 1x2 charset using char expander by alpha flight 1970 ...   "
       !text "the music and sound effects were done by me using gt ultra v1.4.1.1 ...   the tape version of this game was mastered using martin piper's tape tool v1.0.0.7, which i transformed to look a bit like the colourful hewson loader ...   "
       !text "finally this game was squeezed down with exomizer v3.1.1 ...   special thanks goes to "
       !text "hugues poisseroux for the game's graphics bitmap logo, loading bitmap and testing on his real c64 hardware ...   jason page and cadaver for gt ultra ...   magnus lind for exomizer ...   martin piper for tape tool v1.0.0.7 ...   finally, a huge thank you goes to "
       !text "retro programmers inside and phaze 101 for broadcasting this game live at the snake game jam ...   also to you for downloading "
       !text "this game and playing it on your commodore 64, thec64, ultimate64 or your other devices that support this game ...   "
       
       !text "that wraps up everything ...   have loads of fun ...   - press fire to play - ...                              "
       !text "                                                            "
       !byte 0
           
;-------------------------------------------        

;Load sound effects table 
       
        !source "sfx.asm"

;-------------------------------------------        

;Insert logo video RAM (C64 Program)
  
        *=$c400
        !bin "c64/logocolram.prg",,2

;-------------------------------------------        

;Insert logo colour ram data (C64 Program)
  
       *=$c800 
logocolram       
       !bin "c64/logovidram.prg",,2

;-------------------------------------------        

;Insert logo bitmap data (C64 Program)

       *=$e000 
       !bin "c64/logobitmap.prg",,2

;END                               