;-------------------------------------------
;SNAKE VS BOMB 2 - Canyon Run
;-------------------------------------------
;Written by Richard Bayliss
;Graphics by Hugues (Ax!s) Poisseroux
;Music / SFX by Richard Bayliss
;(C)2023 The New Dimension
;For Retro Programmers Inside Snake Game Jam
;------------------------------------------- 
;testgameend = 1
;testirqborder = 1
;musicoff = 1

;Variables/labels
        !source "vars.asm"

;Generate program source
        !to "snakevsbomb2.prg",cbm
        
;Insert mountain charset data (Binary)        
        *=$0800 "MOUNTAIN GRAPHICS CHARSET"
        !bin "c64/mountains_charset.bin"
        
        *=$1000 "DISK ACCESS"
        !source "diskaccess.asm"
;Insert sprite data (Binary)
        *=$2000 "GAME SPRITE DATA"
        !bin "c64/sprites.bin"
        !align $ff,$00
        !align $ff,$00
        !align $ff,$00
        !align $ff,$00
;Insert game charset data (Binary)        
        *=$3000  
gamecharset        
        !bin "c64/canyon_charset.bin"
        
;Insert text charset data
        *=$3800  
titlecharset        
        !bin "c64/text_charset.bin" 
;Insert canyon map data
        *=$4000 
canyon        
        !bin "c64/canyon_map.bin"
        
;Insert mountains map data        
        *=$4400  
mountains        
        !bin "c64/mountains_map.bin"
;Insert canyon attributes        
      *=$4600 
canyonattribs
        !bin "c64/canyon_attribs.bin"      

;Snake vs bomb game code

        *=$4700
        
        lda #$36
        sta $01
        lda $ba
        sta device
        
        ;PAL NTSC check routine
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
       ;lda #$12
       ;sta rline+1
        jmp startmaincode 
ntsc    lda #0
        sta system 
        lda #$40
        sta leveltimeexpiry
     ;  lda #$0e
     ;  sta rline+1
  
startmaincode             
        jsr loadhiscores
       ; jmp gamestart
        jmp titlescreen

        !source "gamecode.asm"
     
        !source "endscreen.asm"

endscreentext
        !bin "c64/endscreen.bin"
   
        ;Title screen code
        !source "titlescreen.asm"
!align $ff,0       
        ;Hi score code
        !source "hiscore.asm"
        
;Insert relocated music data (Program format)
        *=$8000  
       !bin "c64/music.prg",,2           
    
;Insert credits text

        *=$a400  
creditstext
        !bin "c64/text_credits.bin"
        *=$a600  
;Insert hi score list
hiscoretable
        !bin "c64/text_hiscores.bin"
        *=$a800  
;Insert scoring list        
scoringlist
        !bin "c64/text_scoring.bin"
        *=$aa00  
;Insert name screen
namescreen 
        !bin "c64/text_nameentry.bin"        
    
;Scroll text 
       *=$b000 "SCROLL TEXT MESSAGE"
       !ct scr
scrolltext
       !text "                                                          "
       !text " ... snake vs bomb 2 - canyon chaos ...   "
       !text "brought to you by the phaze101 and retro programmers inside snake game jam in april 2023 ...   "
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
       !text "finally this game was squeezed down with ts cruncher v1.3 ...   special thanks goes to "
       !text "hugues poisseroux for the game's graphics, bitmap logo and loading bitmap ...   jason page and cadaver for gt ultra ...   antonio savona for ts cruncher v1.3 ...   martin piper for tape tool v1.0.0.7 ...   finally, a huge thank you goes to "
       !text "retro programmers inside and phaze 101 for broadcasting this game live at the snake game jam ...   also to you for downloading "
       !text "this game and playing it on your commodore 64, thec64, ultimate64 or your other devices that support this game ...   "
       !text "that wraps up everything ...   have loads of fun ...   - press fire to play - ...                              "
       !text "                                                            "
       !byte 0
           
        !source "sfx.asm"

;Insert logo video RAM
  
        *=$c400 "BITMAP LOGO: VIDEO RAM"
        !bin "c64/logocolram.prg",,2

;Insert logo colour ram data       
  
       *=$c800 "BITMAP LOGO: COLOUR RAM"
logocolram       
       !bin "c64/logovidram.prg",,2

;Insert logo bitmap data

       *=$e000 "BITMAP LOGO: BITMAP"
       !bin "c64/logobitmap.prg",,2
                               