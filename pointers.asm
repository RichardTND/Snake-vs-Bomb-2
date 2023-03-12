
;GAME POINTERS
             
rt !byte 0
spawndelay !byte 0
spawndelayexpiry !byte $c0 
spawnvalue !byte 0
sequencepointer !byte 0
objectread !byte 0
positionread !byte 0
leveltime !byte 0,0
leveltimeexpiry !byte $30

rtemp !byte 0
rand !byte %10011101,%01011011

;Scroll - spawn column. The first and second table values are selfmod for where the objects get placed
;the third should be set as zero

spawncolumn1    !byte $00,$00,$00,$00
spawncolumn2    !byte $00,$00,$00,$00
spawncolumn3    !byte $00,$00,$00,$00
spawncolumn4    !byte $00,$00,$00,$00
spawncolumn5    !byte $00,$00,$00,$00
spawncolumn6    !byte $00,$00,$00,$00
spawncolumn7    !byte $00,$00,$00,$00
spawncolumn8    !byte $00,$00,$00,$00

d016table       !byte $10,$10,$10,$10,$10,$10             
rowtemp         !byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00       
colourtemp      !byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00

;Low and hi-byte table for the spawn position values - These indicate positioning of the top left characters

spawnpos1lo     !byte <spawncolumn1,<spawncolumn2,<spawncolumn3,<spawncolumn4,<spawncolumn5,<spawncolumn6,<spawncolumn7
spawnpos1hi     !byte >spawncolumn1,>spawncolumn2,>spawncolumn3,>spawncolumn4,>spawncolumn5,>spawncolumn6,>spawncolumn7

;Low and hi-byte table for the spawn position values - These indicate positioning of the top right characters

spawnpos2lo     !byte <spawncolumn1b,<spawncolumn2b,<spawncolumn3b,<spawncolumn4b,<spawncolumn5b,<spawncolumn6b,<spawncolumn7b
spawnpos2hi     !byte >spawncolumn1b,>spawncolumn2b,>spawncolumn3b,>spawncolumn4b,>spawncolumn5b,>spawncolumn6b,>spawncolumn7b

;Low and hi-byte table for the spawn position values - These indicate positioning of the bottom left characters

spawnpos3lo     !byte <spawncolumn2,<spawncolumn3,<spawncolumn4,<spawncolumn5,<spawncolumn6,<spawncolumn7,<spawncolumn8
spawnpos3hi     !byte >spawncolumn2,>spawncolumn3,>spawncolumn4,>spawncolumn5,>spawncolumn6,>spawncolumn7,>spawncolumn8

;Low and hi-byte table for the spawn position values - These indicate positioning of the bottom right characters

spawnpos4lo     !byte <spawncolumn2b,<spawncolumn3b,<spawncolumn4b,<spawncolumn5b,<spawncolumn6b,<spawncolumn7b,<spawncolumn8b
spawnpos4hi     !byte >spawncolumn2b,>spawncolumn3b,>spawncolumn4b,>spawncolumn5b,>spawncolumn6b,>spawncolumn7b,>spawncolumn8b

;Objects to be spawned - Top left

objectstopleft      !byte banana1, cherry1, strawberry1, bomb1, bomb1
objectstopright     !byte banana2, cherry2, strawberry2, bomb2, bomb2
objectsbottomleft   !byte banana3, cherry3, strawberry3, bomb3, bomb3
objectsbottomright  !byte banana4, cherry4, strawberry4, bomb4, bomb4

;Status panel
;The distance travelled results in the snake colour turning green to yellow (gold)
                !ct scr
statuspanel     !text " score "
score           !text "000000 "
                !text " distance "
distancemarker  !text "+££££][ " 
                !text "level "
level           !text "1"

!align $ff,$00

;256 byte sequence table (0-3) for objects

sequencetable1
                !byte 0,1,2,3,3,0,1,3,2,1,0,3,0,3,2,0 ;Sequence table 1
                !byte 1,3,2,1,0,2,1,3,0,2,3,0,1,2,3,1 ;Sequence table 2
                !byte 2,3,3,1,3,2,1,1,0,2,3,1,3,2,1,3 ;Sequence table 3
                !byte 3,1,2,1,0,2,0,1,3,0,2,0,3,1,2,1 ;Sequence table 4
                !byte 3,1,2,0,1,3,2,0,3,1,3,1,0,2,3,1 ;Sequence table 5
                !byte 0,1,3,2,1,2,3,1,3,2,2,1,0,2,0,3 ;Sequence table 6
                !byte 0,1,3,2,3,1,3,1,0,2,1,0,2,0,1,2 ;Sequence table 7
                !byte 3,1,2,0,3,1,2,3,0,2,1,3,1,2,1,3 ;Sequence table 8
                !byte 1,2,0,2,0,3,1,3,0,1,2,3,0,1,2,0 ;Sequence table 9
                !byte 0,3,1,2,1,0,2,3,0,1,3,2,3,3,1,1 ;Sequence table 10
                !byte 3,1,2,3,1,0,3,1,2,0,1,3,1,2,3,1 ;Sequence table 11
                !byte 2,1,3,0,1,2,3,0,1,3,1,2,0,1,3,2 ;Sequence table 12
                !byte 3,1,2,1,3,1,3,2,0,1,1,3,2,1,3,2 ;Sequence table 13
                !byte 1,0,3,2,1,3,0,3,1,2,0,2,1,3,1,0 ;Sequence table 14
                !byte 3,1,2,0,3,1,2,0,1,3,2,1,3,2,1,3 ;Sequence table 15
                !byte 2,0,3,1,3,2,1,3,2,1,0,3,2,1,3,1 ;Sequence table 16
                
;256 byte sequence table (0-7) for spawn position

sequencetable2  !byte 3,7,2,4,0,1,4,3,5,1,6,2,4,0,4,2 ;Sequence table 1
                !byte 3,1,6,4,1,3,2,7,3,4,1,5,6,2,7,0 ;Sequence table 2
                !byte 2,5,4,1,0,6,5,3,2,1,6,0,5,3,7,3 ;Sequence table 3
                !byte 6,4,1,2,0,4,6,3,5,3,2,0,5,0,3,1 ;Sequence table 4
                !byte 2,6,7,2,4,3,0,1,2,5,3,5,7,2,3,0 ;Sequence table 5
                !byte 3,1,0,5,3,4,7,2,1,0,5,3,6,2,5,4 ;Sequence table 6
                !byte 0,5,1,3,2,6,1,2,7,3,4,1,3,6,2,7 ;Sequence table 7
                !byte 5,1,4,3,1,2,7,3,4,2,1,5,3,4,1,3 ;Sequence table 8
                !byte 2,6,3,1,6,3,4,3,1,0,4,0,3,4,1,2 ;Sequence table 9
                !byte 0,3,2,4,6,7,1,4,3,4,1,2,0,4,3,2 ;Sequence table 10
                !byte 2,4,0,1,5,4,3,5,0,1,3,2,6,7,3,2 ;Sequence table 11
                !byte 3,1,7,0,5,2,3,5,4,1,4,7,5,6,3,4 ;Sequence table 12
                !byte 7,1,2,3,4,1,2,6,3,4,6,3,4,1,2,4 ;Sequence table 13
                !byte 5,1,2,0,4,3,4,6,3,2,5,7,3,2,1,5 ;Sequence table 14
                !byte 3,5,3,4,7,3,1,2,5,3,7,3,5,4,2,6 ;Sequence table 15
                !byte 2,4,1,6,4,5,3,2,3,1,7,4,3,5,1,2 ;Sequence table 16
                
                
                
                