;-------------------------------------------
;SNAKE VS BOMB 2 - Canyon Run
;-------------------------------------------
;Written by Richard Bayliss
;Graphics by Hugues (Ax!s) Poisseroux
;Music / SFX by Richard Bayliss
;(C)2023 The New Dimension
;For Retro Programmers Inside Snake Game Jam
;-------------------------------------------

testirqborder = 1
;musicoff = 1

;Variables/labels
        !source "vars.asm"

;Generate program source
        !to "snakevsbomb2.prg",cbm
        
;Generate SYS 2061 header
        *=$0801
        !byte $0b,$08,$e7,$07,$9e,$32,$30,$36,$31,$00
                        
;SYS 2061 code run
        *=$080d
        
        ;Disable KERNAL routines
        lda #$35
        sta $01
        jmp gamestart

;Insert relocated music data (Program format)
        *=$1000
        !bin "c64/music.prg",,2    
        
;Insert sprite data (Binary)
        *=$2000
        !bin "c64/sprites.bin"
        
;Insert game charset data (Binary)        
        *=$2800
        !bin "c64/canyon_charset.bin"
        
;Insert mountain charset data (Binary)        
        *=$3000
        !bin "c64/mountains_charset.bin"
        
;Insert text charset data
        *=$3800
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
;Insert mountains attributes
      *=$4700
mountainattribs        
        !bin "c64/mountains_attribs.bin"
;Snake vs bomb game code

        *=$4800
        !source "gamecode.asm"
                    
                    
                        