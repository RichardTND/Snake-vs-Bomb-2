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
        *=$0800 ;"MOUNTAIN GRAPHICS CHARSET"
        !bin "c64/mountains_charset.bin"
        
        *=$1000 "DISK ACCESS"
        !source "diskaccess.asm"
;Insert sprite data (Binary)
        *=$2000 ;"GAME SPRITE DATA"
        !bin "c64/sprites.bin"
        
;Insert game charset data (Binary)        
        *=$3000 ;"MAIN GAME (CANYON) CHARSET"
gamecharset        
        !bin "c64/canyon_charset.bin"
        
;Insert text charset data
        *=$3800 ;"STATUS PANEL AND TEXT CHARSET"
titlecharset        
        !bin "c64/text_charset.bin" 
;Insert canyon map data
        *=$4000 ;"CANYON SCREEN DATA"
canyon        
        !bin "c64/canyon_map.bin"
        
;Insert mountains map data        
        *=$4400 ;"MOUNTAIN SCREEN DATA"
mountains        
        !bin "c64/mountains_map.bin"
;Insert canyon attributes        
      *=$4600 ;"CANYON COLOUR DATA"
canyonattribs
        !bin "c64/canyon_attribs.bin"      

;Snake vs bomb game code

        *=$5000; "MAIN START"
        
        lda #$36
        sta $01
        lda $ba
        sta device
        lda #251
        sta 808
        ;PAL NTSC check routine
checksystem    
        lda $d012
        cmp $d012
        beq *-3
        bmi checksystem
        cmp #$20
        bcc ntsc 
        lda #1
        sta system
       ;lda #$12
       ;sta rline+1
        jmp startmaincode 
ntsc    lda #0
        sta system 
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
       
        ;Hi score code
        !source "hiscore.asm"
        
;Insert relocated music data (Program format)
        *=$8000 ;"MUSIC DATA"
        
       !bin "c64/music.prg",,2           
    
;Insert credits text

        *=$a400 ;"Credits text"
creditstext
        !bin "c64/text_credits.bin"
        *=$a600 ;"Hi score table"
;Insert hi score list
hiscoretable
        !bin "c64/text_hiscores.bin"
        *=$a800 ;"Scoring advance object list"
;Insert scoring list        
scoringlist
        !bin "c64/text_scoring.bin"
        *=$aa00 ;"Name entry text"
;Insert name screen
namescreen 
        !bin "c64/text_nameentry.bin"        
    
;Scroll text 
       *=$b000 ;"SCROLL TEXT MESSAGE"
       !ct scr
scrolltext
       !text "                                                          "
       !text " ... snake vs bomb 2 - canyon chaos ...   "
       !text "brought to you by the phaze101 and retro programmers inside's snake game jam in april 2023 ...   "
       !text "graphics and game design by hugues (ax!s) poisseroux ...   "
       !text "programming, charset, sound effects and music by richard bayliss ...   "
       !text "copyright (c) 2023 the new dimension ...   like with all of my productions on richard-tnd.itch.io, this is non-commercial software ...   "
       !text "you are welcome to copy/share or use parts of this production, providing that no part of it is being sold commerically without my permission "
       !text "to do so ...    and now, on with the game instructions ...   this is a fun sequel to the first snake vs bomb, which i had launched in december 2022 ...   " 
       !text "this time, it features horizontal parallax scrolling and could be even tougher and more challenging ...    "
      
       !text "your hungry snake is on a long journey across a huge canyon across the nevada desert ...   using up and down on your "
       !text "joystick (plugged into port 2), safely eat the fruit, but avoid touching the deadly bombs, otherwise your snake will be no more ...   you "
       !text "will encounter many of these deadly bombs on the way ...   you will score a bonus of 1,000 points for every level completed ...   try to complete all eight levels if you can ...   "
       !text "good luck! ...    this game was programmed and compiled using endurion's c64studio "
       !text "...   the graphics were drawn by hugues using multipaint by dr. terrorz, charpad and spritepad by subchrist software ...   i designed the 1x1 text charset and converted to 1x2 charset using char expander by alpha flight 1970 ...   "
       !text "the music and sound effects were done by me using gt ultra v1.4.1.1 ...   "
       !text "finally this game was squeezed down with antonio savona's latest version of tscruncher ...   special thanks goes to "
       !text "hugues poisseroux for the game's graphics, bitmap logo and loading bitmap ...   jason page for gt ultra ...    finally, a huge thank you goes to "
       !text "emanuel bonin and prince/phaze 101 for broadcasting this game live at the game jam ...   also to you for downloading "
       !text "this game and playing it on your commodore 64, thec64 mini/maxi, ultimate64 or your other devices that support this game ...   "
       !text "that wraps up everything ...   have loads of fun ...   - press fire to play - ...                              "
       !text "                                                            "
       !byte 0
           

;Insert logo video RAM
  
        *=$c400 ;"BITMAP LOGO: VIDEO RAM"
        !bin "c64/logocolram.prg",,2

;Insert logo colour ram data       
  
       *=$c800 ;"BITMAP LOGO: COLOUR RAM"
logocolram       
       !bin "c64/logovidram.prg",,2

;Insert logo bitmap data

       *=$e000 ;"BITMAP LOGO: BITMAP"
       !bin "c64/logobitmap.prg",,2
                               