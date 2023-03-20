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
        *=$0800
        !bin "c64/mountains_charset.bin"
        
;Insert sprite data (Binary)
        *=$2000
        !bin "c64/sprites.bin"
        
;Insert game charset data (Binary)        
        *=$3000
gamecharset        
        !bin "c64/canyon_charset.bin"
        
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
        
        ;PAL NTSC check routine
    
        !source "gamecode.asm"
        
        !align $ff,$00
        !source "endscreen.asm"
        !align $ff,$00
endscreentext
        !bin "c64/endscreen.bin"
                    
;Insert relocated music data (Program format)
        *=$8000
        !bin "c64/music.prg",,2                        
                        