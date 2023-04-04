 
;GAME POINTERS
rt !byte 0    
system !byte 0
vblank !byte 0
ntsctimer !byte 0  
cheatmodeon !byte 0
spawndelay !byte 0
spawndelayexpiry !byte $c0 
spawnvalue !byte 0
rowvalue !byte 0
sequencepointer !byte 0
objectread !byte 0
positionread !byte 0
leveltime !byte 0,0
leveltimeexpiry !byte $30
spriteanimdelay !byte 0
spriteanimpointer !byte 0
explodeanimpointer !byte 0
explodeanimdelay !byte 0
firebutton !byte 0
rtemp !byte 0
sinuspointer !byte 0
bombanimdelay !byte 0
expcoldelay !byte 0
expcoltimer !byte 0

rand !byte %10011101,%0101101

;Sprite Animation pointers
largesnakehead !byte $80
largesnakebody !byte $83
largesnaketail !byte $86
smallsnakehead !byte $80
smallsnakebody !byte $83
smallsnaketail !byte $86
largedeadsnakehead !byte $99
largedeadsnakebody !byte $98
smalldeadsnakehead !byte $9b
smalldeadsnakebody !byte $9a

;Game over pointers

gameoverspritetable !byte $92,$93,$94,$95,$96,$97
                    !byte 0
levelupspritetable  !byte $a3,$a4,$a5,$a6
welldonespritetable !byte $a7,$a8,$a9,$aa
getreadyspritetable !byte $ab,$ac,$ad,$ae

gameoverpos         !byte $38,$a4
                    !byte $38+12,$a4
                    !byte $38+24,$a4
                    !byte $38+36,$a4
                    !byte $38+48,$a4
                    !byte $38+60,$a4
                    
     
levuppostable       !byte $b0,$a4                    
                    !byte $b0+12,$a4
                    !byte $b0+24,$a4
                    !byte $b0+36,$a4
                    

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
 
;SPRITE ANIMATION FRAMES
 
largesnakeheadframe  !byte $80,$81,$82,$81
largesnakebodyframe  !byte $83,$84,$85,$84
largesnaketailframe  !byte $86,$87,$88,$87

smallsnakeheadframe  !byte $89,$8a,$8b,$8a
smallsnakebodyframe  !byte $8c,$8d,$8e,$8d
smallsnaketailframe  !byte $8f,$90,$91,$90 

explosionframe       !byte $9c,$9d,$9e,$9f,$a0,$a1,$a2,$af,$af,$af,$af,$af,$af,$af,$af,$af,$af,$af,$af,$af,$af,$af,$af,$af,$af,$af,$af,$af
explosionframeend
;OBJECT POSITION TABLE

startpos !byte $48, $a8
         !byte $3c, $a8
         !byte $30, $a8
         !byte $00,$00
         !byte $00,$00
         !byte $00,$00
         !byte $00,$00
         !byte $00,$00

objpos !byte $00,$00,$00,$00,$00,$00,$00,$00
       !byte $00,$00,$00,$00,$00,$00,$00,$00
;STARTING POSITION TABLE
 
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

smallobjectstopleft   !byte smallapple1, smallbanana1, smallcherry1, smallstrawberry1, smallbomb1
smallobjectstopright   !byte smallapple2, smallbanana2, smallcherry2, smallstrawberry2, smallbomb2
smallobjectsbottomleft  !byte smallapple3, smallbanana3, smallcherry3, smallstrawberry3, smallbomb3
smallobjectsbottomright   !byte smallapple4, smallbanana4, smallcherry4, smallstrawberry4, smallbomb4

;Status panel
;The distance travelled results in the snake colour turning green to yellow (gold)
                !ct scr
statuspanel     !text " score "
score           !text "000000 "
                !text " distance "
                !text "+"
                !byte 28,28,28,28
                !text "][ " 
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
                !byte 1,3,4,1,0,2,4,3,0,2,4,0,1,4,3,1 ;Sequence table 2
                !byte 2,4,3,1,4,2,1,4,0,2,3,1,4,2,1,3 ;Sequence table 3
                !byte 3,1,4,1,0,2,4,1,3,0,2,0,4,1,2,4 ;Sequence table 4
                !byte 3,1,4,4,1,3,2,0,3,4,3,1,0,2,4,1 ;Sequence table 5
                !byte 0,1,3,2,4,2,3,1,4,2,2,1,0,4,0,3 ;Sequence table 6
                !byte 0,1,4,4,3,1,3,1,0,2,1,4,4,0,1,2 ;Sequence table 7
                !byte 3,1,2,4,3,4,2,3,0,4,1,3,1,4,1,3 ;Sequence table 8
                !byte 1,2,0,4,4,3,1,3,4,1,2,4,0,1,4,0 ;Sequence table 9
                !byte 0,4,1,2,4,0,2,4,0,1,3,4,3,4,1,1 ;Sequence table 10
                !byte 3,4,2,4,1,0,3,1,4,0,1,3,1,4,4,1 ;Sequence table 11
                !byte 2,1,4,0,1,2,4,4,1,3,1,2,4,4,3,2 ;Sequence table 12
                !byte 3,1,2,4,4,1,3,2,4,1,4,3,4,4,3,2 ;Sequence table 13
                !byte 1,0,3,4,1,4,0,3,4,2,0,4,1,4,1,0 ;Sequence table 14
                !byte 3,1,2,4,3,1,4,0,4,3,2,1,4,2,4,3 ;Sequence table 15
                !byte 2,4,3,4,3,4,1,3,2,4,0,3,2,4,3,4 ;Sequence table 16
                
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
   
;Sprite sinus table
sinus 
      !byte 66,69,72,75,78,80
      !byte 83,85,87,89,91,93
      !byte 94,95,96,97,98,98
      !byte 98,98,98,97,96,95
      !byte 94,93,91,89,87,85
      !byte 83,80,78,75,72,69
      !byte 66,63,60,57,54,51
      !byte 48,45,42,39,36,34
      !byte 31,29,26,24,22,21
      !byte 19,18,16,16,15,14
      !byte 14,14,14,15,15,16
      !byte 17,18,20,22,24,26
      !byte 28,30,33,35,38,41
      !byte 44,47,50,53,56,59
      !byte 62,65,68,71,74,77
      !byte 79,82,84,86,88,90
      !byte 92,93,95,96,97,97
      !byte 98,98,98,98,97,96
      !byte 96,94,93,92,90,88
      !byte 86,83,81,79,76,73
      !byte 70,67,64,61,58,55
      !byte 52,49,46,43,40,37
      !byte 34,32,29,27,25,23
      !byte 21,19,18,17,16,15
      !byte 14,14,14,14,14,15
      !byte 16,17,18,19,21,23
      !byte 25,27,29,32,34,37
      !byte 40,43,46,49,52,55
      !byte 58,61,64,67,70,73
      !byte 76,78,81,83,86,88
      !byte 90,91,93,94,96,96
      !byte 97,98,98,98,98,97
      !byte 97,96,95,94,92,90
      !byte 88,86,84,82,79,77
      !byte 74,71,68,65,62,59
      !byte 56,53,50,47,44,41
      !byte 38,35,33,30,28,26
      !byte 24,22,20,19,17,16
      !byte 15,15,14,14,14,14
      !byte 15,16,16,18,19,20
      !byte 22,24,26,29,31,33
      !byte 36,39,42,45,48,51
      !byte 54,57,60,63 
  
;Exploding colours

expcoltable
      !byte $09,$02,$08,$0a,$07,$01,$07,$0a,$08,$02,$09,$00
 

;Screen low and hi byte pointers for sprite to background collision reader
;subroutine.

screenhi        !byte $04,$04,$04,$04,$04
                !byte $04,$04,$05,$05,$05
                !byte $05,$05,$05,$06,$06
                !byte $06,$06,$06,$06,$06
                !byte $07,$07,$07,$07,$07 
                
screenlo        !byte $00,$28,$50,$78,$a0
                !byte $c8,$f0,$18,$40,$68
                !byte $90,$b8,$e0,$08,$30
                !byte $58,$80,$a8,$d0,$f8
                !byte $20,$48,$70,$98,$c0 
                
score1          !byte $30,$30,$30,$30,$30,$30                
score2          !byte $30,$30,$30,$30,$30,$30
carry           !byte $00,$00,$00,$00,$00,$00
result          !byte $00,$00,$00,$00,$00,$00
