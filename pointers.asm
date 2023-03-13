
;GAME POINTERS
             
rt !byte 0
spawndelay !byte 0
spawndelayexpiry !byte $c0 
spawnvalue !byte 0
rowvalue !byte 0
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
;------------------------------------
spawncolumn5    !byte $00,$00,$00,$00
spawncolumn6    !byte $00,$00,$00,$00
spawncolumn7    !byte $00,$00,$00,$00
spawncolumn8    !byte $00,$00,$00,$00

d016table       !byte $10,$10,$10,$10,$10,$10             
rowtemp         !byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00       
colourtemp      !byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00

;SPAWN POSITION TABLES - LOWER HALF OF GAME SCREEN

;Low and hi-byte table for the spawn position values - These indicate positioning of the top left characters

spawnpos1lo     !byte <spawncolumn5,<spawncolumn6,<spawncolumn7,<spawncolumn5,<spawncolumn6,<spawncolumn7,<spawncolumn5
spawnpos1hi     !byte >spawncolumn5,>spawncolumn6,>spawncolumn7,>spawncolumn5,>spawncolumn6,>spawncolumn7,>spawncolumn5

;Low and hi-byte table for the spawn position values - These indicate positioning of the top right characters

spawnpos2lo     !byte <spawncolumn5b,<spawncolumn6b,<spawncolumn7b,<spawncolumn5b,<spawncolumn6b,<spawncolumn7b,<spawncolumn5b
spawnpos2hi     !byte >spawncolumn5b,>spawncolumn6b,>spawncolumn7b,>spawncolumn5b,>spawncolumn6b,>spawncolumn7b,>spawncolumn5b

;Low and hi-byte table for the spawn position values - These indicate positioning of the bottom left characters

spawnpos3lo     !byte <spawncolumn6,<spawncolumn7,<spawncolumn8,<spawncolumn6,<spawncolumn7,<spawncolumn8,<spawncolumn6
spawnpos3hi     !byte >spawncolumn6,>spawncolumn7,>spawncolumn8,>spawncolumn6,>spawncolumn7,>spawncolumn8,>spawncolumn6

;Low and hi-byte table for the spawn position values - These indicate positioning of the bottom right characters

spawnpos4lo     !byte <spawncolumn6b,<spawncolumn7b,<spawncolumn8b,<spawncolumn6b,<spawncolumn7b,<spawncolumn8b,<spawncolumn6b
spawnpos4hi     !byte >spawncolumn6b,>spawncolumn7b,>spawncolumn8b,>spawncolumn6b,>spawncolumn7b,>spawncolumn8b,>spawncolumn6b


;SPAWN TABLES - UPPER HALF OF GAME SCREEN

;Low and hi-byte table for the spawn position values - These indicate positioning of the top left characters

spawnpos5lo     !byte <spawncolumn1,<spawncolumn2,<spawncolumn3,<spawncolumn4,<spawncolumn1,<spawncolumn2,<spawncolumn3
spawnpos5hi     !byte >spawncolumn1,>spawncolumn2,>spawncolumn3,>spawncolumn4,>spawncolumn1,>spawncolumn2,>spawncolumn3

;Low and hi-byte table for the spawn position values - These indicate positioning of the top right characters

spawnpos6lo     !byte <spawncolumn1b,<spawncolumn2b,<spawncolumn3b,<spawncolumn4b,<spawncolumn1b,<spawncolumn2b,<spawncolumn3b
spawnpos6hi     !byte >spawncolumn1b,>spawncolumn2b,>spawncolumn3b,>spawncolumn4b,>spawncolumn1b,>spawncolumn2b,>spawncolumn3b

;Low and hi-byte table for the spawn position values - These indicate positioning of the bottom left characters

spawnpos7lo     !byte <spawncolumn2,<spawncolumn3,<spawncolumn4,<spawncolumn5,<spawncolumn2,<spawncolumn3,<spawncolumn4
spawnpos7hi     !byte >spawncolumn2,>spawncolumn3,>spawncolumn4,>spawncolumn5,>spawncolumn2,>spawncolumn3,>spawncolumn4

;Low and hi-byte table for the spawn position values - These indicate positioning of the bottom right characters

spawnpos8lo     !byte <spawncolumn2b,<spawncolumn3b,<spawncolumn4b,<spawncolumn5b,<spawncolumn2b,<spawncolumn3b,<spawncolumn4b
spawnpos8hi     !byte >spawncolumn2b,>spawncolumn3b,>spawncolumn4b,>spawncolumn5b,>spawncolumn2b,>spawncolumn3b,>spawncolumn4b



;Objects to be spawned (Large versions)

objectstopleft      !byte apple1, banana1, cherry1, strawberry1, bomb1
objectstopright     !byte apple2, banana2, cherry2, strawberry2, bomb2
objectsbottomleft   !byte apple3, banana3, cherry3, strawberry3, bomb3
objectsbottomright  !byte apple4, banana4, cherry4, strawberry4, bomb4

;Object to be spawned (Small versions)

smallobjectstopleft  !byte smallapple1, smallbanana1, smallcherry1, smallstrawberry1, smallbomb1
smallobjectstopright !byte smallapple2, smallbanana2, smallcherry2, smallstrawberry2, smallbomb2
smallobjectsbottomleft !byte smallapple3, smallbanana3, smallcherry3, smallstrawberry3, smallbomb3
smallobjectsbottomright !byte smallapple4, smallbanana4, smallcherry4, smallstrawberry4, smallbomb4

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

;256 byte sequence table for row position to select (Top = small objects, Bottom = large objects)

sequencetable0
                !byte 0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1 ;Sequence table 1
                !byte 1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0 ;Sequence table 2
                !byte 0,0,1,0,0,1,1,0,0,1,0,1,0,0,1,0 ;Sequence table 3
                !byte 1,0,0,1,0,1,0,1,1,0,1,0,1,0,1,0 ;Sequence table 4
                !byte 0,1,0,1,0,0,1,0,1,0,1,0,1,0,1,0 ;Sequence table 5
                !byte 1,0,0,1,0,0,1,0,0,0,1,0,0,1,1,1 ;Sequence table 6
                !byte 0,1,0,1,1,0,1,0,1,0,0,1,0,1,0,1 ;Sequence table 7
                !byte 1,0,1,0,1,1,0,1,0,1,0,1,1,0,1,0 ;Sequence table 8
                !byte 0,1,0,0,1,0,1,0,1,1,0,1,0,1,0,1 ;Sequence table 9
                !byte 1,0,0,1,0,1,1,0,0,0,1,0,1,0,1,0 ;Sequence table 10
                !byte 0,1,0,1,1,0,1,1,0,0,1,0,1,0,1,0 ;Sequence table 11
                !byte 1,1,0,0,1,0,1,0,1,1,0,1,0,1,0,1 ;Sequence table 12
                !byte 0,0,1,0,1,0,1,0,1,0,1,0,0,1,0,1 ;Sequence table 13
                !byte 1,0,1,1,0,1,0,1,0,1,0,0,1,0,1,0 ;Sequence table 14
                !byte 1,0,0,1,0,1,1,0,1,0,1,0,1,1,0,1 ;Sequence table 15
                !byte 1,0,1,0,1,0,1,0,1,1,0,0,1,0,1,0
                

;256 byte sequence table (0-4) for objects 
;This table operates for large or smaller objects for spawning


sequencetable1
                !byte 0,1,2,3,4,0,1,3,4,1,0,3,0,4,2,0 ;Sequence table 1
                !byte 1,3,4,1,0,2,1,3,0,2,4,0,1,4,3,1 ;Sequence table 2
                !byte 2,4,3,1,4,2,1,4,0,2,3,1,4,2,1,3 ;Sequence table 3
                !byte 3,1,4,1,0,2,4,1,3,0,2,0,4,1,2,1 ;Sequence table 4
                !byte 3,1,4,0,1,3,2,0,3,4,3,1,0,2,4,1 ;Sequence table 5
                !byte 0,1,3,2,4,2,3,1,4,2,2,1,0,4,0,3 ;Sequence table 6
                !byte 0,1,3,4,3,1,3,1,0,2,1,0,4,0,1,2 ;Sequence table 7
                !byte 3,1,2,4,3,4,2,3,0,4,1,3,1,4,1,3 ;Sequence table 8
                !byte 1,2,0,2,4,3,1,3,4,1,2,4,0,1,2,0 ;Sequence table 9
                !byte 0,4,1,2,4,0,2,3,0,1,3,4,3,4,1,1 ;Sequence table 10
                !byte 3,1,2,4,1,0,3,1,4,0,1,3,1,2,4,1 ;Sequence table 11
                !byte 2,1,4,0,1,2,3,4,1,3,1,2,0,4,3,2 ;Sequence table 12
                !byte 3,1,2,4,3,1,3,2,0,1,4,3,2,4,3,2 ;Sequence table 13
                !byte 1,0,3,4,1,3,0,3,4,2,0,2,1,4,1,0 ;Sequence table 14
                !byte 3,1,2,0,3,1,4,0,4,3,2,1,3,2,4,3 ;Sequence table 15
                !byte 2,0,3,4,3,4,1,3,2,4,0,3,2,4,3,1 ;Sequence table 16
                
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
                
                
                
                