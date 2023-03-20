 
;GAME CODE
      
;Call routine to stop existing interrupts/IRQs from
;playing and also switch the screen off. 

                lda #$35
                sta $01
gamestart       jsr killirqs
               
                
;Grab all graphics map data and place those onto the screen.
;Panel = 1 row (leave blank), Mountains = 6 rows, Canyon = 18 rows

                ldx #$00
buildmap        lda mountains,x
                sta screen+(1*40),x
                lda mountains+(1*40),x
                sta screen+(2*40),x
                lda mountains+(2*40),x
                sta screen+(3*40),x
                lda mountains+(3*40),x
                sta screen+(4*40),x
                lda mountains+(4*40),x
                sta screen+(5*40),x
                lda mountains+(5*40),x
                sta screen+(6*40),x
                
                ;6 mountains drawn, now draw canyon
                
                lda canyon,x
                sta screen+(7*40),x
                lda canyon+(1*40),x
                sta screen+(8*40),x
                lda canyon+(2*40),x
                sta screen+(9*40),x
                lda canyon+(3*40),x
                sta screen+(10*40),x
                lda canyon+(4*40),x
                sta screen+(11*40),x
                lda canyon+(5*40),x
                sta screen+(12*40),x
                lda canyon+(6*40),x
                sta screen+(13*40),x
                lda canyon+(7*40),x
                sta screen+(14*40),x
                lda canyon+(8*40),x
                sta screen+(15*40),x
                lda canyon+(9*40),x
                sta screen+(16*40),x
                lda canyon+(10*40),x
                sta screen+(17*40),x
                lda canyon+(11*40),x
                sta screen+(18*40),x
                lda canyon+(12*40),x
                sta screen+(19*40),x
                lda canyon+(13*40),x
                sta screen+(20*40),x
                lda canyon+(14*40),x
                sta screen+(21*40),x
                lda canyon+(15*40),x
                sta screen+(22*40),x
                lda canyon+(16*40),x
                sta screen+(23*40),x
                lda canyon+(17*40),x
                sta screen+(24*40),x
                
                inx
                cpx #40
                beq stopmapbuild
                jmp buildmap
                
stopmapbuild    ;Map draw finished. 

                ;Draw mountain attribs
                
                ldx #$00
paintmountains  ldy screen,x
                lda mountainattribs,y
                sta colour,x
                ldy screen+$100,x
                lda mountainattribs,y
                sta colour+$100,x
                inx
                bne paintmountains
                
                lda #$03
                sta $dd00
                ldx #$00
paint           ldy screen+(7*40),x
                lda canyonattribs,y
                sta colour+(7*40),x
                ldy screen+(2*$100),x
                lda canyonattribs,y
                sta colour+(2*$100),x
                ldy screen+(2*$100)+$e8,x
                lda canyonattribs,y
                sta colour+(2*$100)+$e8,x
                inx
                bne paint
               
                lda #$00
                sta $d020
                sta $d021 
                
                ;Reset level and score panel 
                
                
                lda #$31
                sta level
                ldx #$00
zeroscore       lda #$30
                sta score,x
                inx
                cpx #$06
                bne zeroscore
                
              
                ;Initialize the lane
                
                ldx #$00
setlane         lda #lane
                sta spawncolumn1,x
                inx
                cpx #32
                bne setlane
                
               
                ;Place score panel on screen 
                jsr maskscorepanel
                
                ldx #$00
paintpanel      lda #$0d
                sta colour,x
                inx
                cpx #40
                bne paintpanel
                
                ;Initialize all necessary game pointers
                
                lda #0
                sta spawndelay
                sta sequencepointer
                sta objectread
                sta positionread
                sta leveltime
                sta leveltime+1
                
                lda #2
                sta spawnvalue 
                jsr zerospawn
                
                ;Reset spawn counter 
                lda #$40
                sta spawndelayexpiry
                
                ;Setup the game sprites
                
                lda #0
                sta spriteanimpointer ;Default animation speed and pointer
                sta spriteanimdelay
        
                
;Prepare in game IRQ raster interrupts          
                lda #$fb
                txs
                ldx #<gameirq1
                ldy #>gameirq1
                lda #$7f
                stx $fffe
                sty $ffff
                sta $dc0d
                sta $dd0d
                 
                lda #$00
                sta $d012
                lda #$1b
                sta $d011
                lda #$01
                sta $d019
                sta $d01a
                lda #getreadymusic
                jsr musicinit
                cli
                jmp getreadymain
                
                !source "irq.asm"
                
getreadymain
                ;Enable all sprites
                
                lda #$00
                sta $d015
                sta $d01c
                
                ;Disable other sprite priorities
                
                lda #$00
                sta $d017
                sta $d01b
                sta $d01d
                sta firebutton 
                
                ;Setup the GET READY sprites
                
                ldx #$00
makegrsprites   lda getreadyspritetable,x
                sta $07f8,x
                lda #$01
                sta $d027,x
                inx
                cpx #4
                bne makegrsprites
                
                lda #$a8
                sta objpos+1
                sta objpos+3
                sta objpos+5
                sta objpos+7
                lda #$44
                sta objpos
                clc
                adc #$0c
                sta objpos+2
                adc #$0c
                sta objpos+4
                adc #$0c
                sta objpos+6
               
                lda #%00001111
                sta $d015
                sta $d01c
                lda #$05
                sta $d025
                lda #$07
                sta $d026
                
                
getreadyloop    jsr synctimer
                jsr expandmsb
               
                lda $dc00
                lsr
                lsr
                lsr
                lsr
                lsr
                bit firebutton
                ror firebutton
                bmi getreadyloop
                bvc getreadyloop
                lda #0
                sta firebutton
                
setupmaingame                
                
                ;Setup the sprite position table to object position
                
                ldx #$00
setstartpos     lda startpos,x
                sta objpos,x
                inx
                cpx #$10
                bne setstartpos
                
                ;Setup frames for player sprite
                
                lda largesnakehead
                sta $07f8
                lda largesnakebody
                sta $07f9
                lda largesnaketail
                sta $07fa
                
                ;Setup colour scheme for player sprite
                
                ldx #$00
setsprcolour    lda #$01
                sta $d027,x
                inx
                cpx #8
                bne setsprcolour
                
                lda #$05
                sta $d025
                lda #$07
                sta $d026
                
                jsr expandmsb
                
                ;Enable all sprites
                
                lda #$ff
                sta $d015
                sta $d01c
                
                ;Disable other sprite priorities
                
                lda #$00
                sta $d017
                sta $d01b
                sta $d01d
                
                lda #gamemusic
                jsr musicinit
                
                jmp gameloop

; Kill of all IRQ interrupts that are currently playing also
; make a short delay, in order to prevent sensitive fire
;button pressing

killirqs        sei
               ; ldx #$48
               ; ldy #$ff
               ; stx $fffe
               ; sty $ffff
                ldx #<nmi
                ldy #>nmi
                stx $fffa
                sty $fffb
                lda #$00
                sta $d011
                sta $d019
                sta $d01a
                sta $d015
                sta $d01b
               
                lda #$81
                sta $dc0d
                sta $dd0d
               
                
                
                ;Silence the SID chip
                ldx #$00
quiet           lda #$00
                sta $d400,x
                inx
                cpx #$18
                bne quiet
                
                ;Sprite position also 
                
                ldx #$00
zerosprposy     lda #$00
                sta $d000,x
                sta objpos,x
                inx
                cpx #$10
                bne zerosprposy
                
                ;Pointless, but useful delay routine
                
                ldx #$00
delay1          ldy #$00
delay2          iny
                bne delay2
                inx
                bne delay1
                
                ;End of IRQ kill routine
                rts
                
;Main game loop

gameloop        jsr synctimer       ;Synchronize game timer
                jsr expandmsb       ;Expand sprite X position and store to hardware
                jsr scrollcontrol    ;Main game screen scrolling
                jsr levelcontrolmain
                jsr playercontrol   ;Player, joystick and sprite/background collision control
                
                jsr animbombs
                jmp gameloop
                

;Synchronize timer

synctimer       lda #0
                sta rt
                cmp rt
                beq *-3
                ;Play music
                
                rts
                
;Animate bombs

animbombs       lda bombanimdelay
                cmp #3
                beq animatebomb
                inc bombanimdelay
                rts
animatebomb     lda #0
                sta bombanimdelay
                ldx #0
animbloop1      lda animbombsrc1,x
                sta animbombsrc1+(7*8),x
                lda animbombsrc2,x
                sta animbombsrc2+(7*8),x
                inx
                cpx #$08
                bne animbloop1
                ldx #$00
animbloop2      lda animbombsrc1+8,x
                sta animbombsrc1,x
                lda animbombsrc2+8,x
                sta animbombsrc2,x
                inx
                cpx #$38
                bne animbloop2
                ldx #$00
animbloop3      lda animbombsrc1,x
                sta gamecharset+(bomb2*8),x
                lda animbombsrc2,x
                sta gamecharset+(smallbomb2*8),x
                inx
                cpx #8
                bne animbloop3
                rts
                
;Music player (PAL NTSC)
musicplayer     lda system
                bne pal
                inc ntsctimer
                lda ntsctimer
                cmp #6
                beq resetmusdelay
pal             jsr musicplay
                rts
resetmusdelay   lda #0
                sta ntsctimer
                rts
                
;Expand X position for all game sprites
                
expandmsb       ldx #$00
exploop         lda objpos+1,x
                sta $d001,x
                lda objpos,x
                asl 
                ror $d010
                sta $d000,x
                inx
                inx
                cpx #$10
                bne exploop
                rts             
                                

                
;Scroll controller
scrollcontrol 
                jsr parallax
                jmp spawnlogic 
                
                
;Game parallax routines
parallax        
                
                jsr scrollmountains
                jsr scrollrockstop
                jsr scrollplantstop
             
                
                jsr scrollmainscreen
              
                jsr scrollplantsbottom
                jmp scrollrocksbottom
skipmountainscroll
               rts
                
;Parallax scroll 1 - Scroll mountains.

scrollmountains
               
                lda d016table
                sec
                sbc #1
                and #7
                
                sta d016table
                bcs skipmountainscroll
                
                lda screen+(1*40)
                sta rowtemp
                lda screen+(2*40)
                sta rowtemp+1
                lda screen+(3*40)
                sta rowtemp+2
                lda screen+(4*40)
                sta rowtemp+3
                lda screen+(5*40)
                sta rowtemp+4
                lda screen+(6*40)
                sta rowtemp+5
                
                lda colour+(1*40)
                sta colourtemp
                lda colour+(2*40)
                sta colourtemp+1
                lda colour+(3*40)
                sta colourtemp+2
                lda colour+(4*40)
                sta colourtemp+3
                lda colour+(5*40)
                sta colourtemp+4
                lda colour+(6*40)
                sta colourtemp+5

                ldx #$00
scrloop1        lda screen+(1*40)+1,x
                sta screen+(1*40),x
                lda screen+(2*40)+1,x
                sta screen+(2*40),x
                lda screen+(3*40)+1,x
                sta screen+(3*40),x
                lda screen+(4*40)+1,x
                sta screen+(4*40),x
                lda screen+(5*40)+1,x
                sta screen+(5*40),x
                lda screen+(6*40)+1,x
                sta screen+(6*40),x
                inx
                cpx #$27
                bne scrloop1
                
                ldx #$00
scrloop1b       lda colour+(1*40)+1,x
                sta colour+(1*40),x
                lda colour+(2*40)+1,x
                sta colour+(2*40),x
                lda colour+(3*40)+1,x
                sta colour+(3*40),x
                lda colour+(4*40)+1,x
                sta colour+(4*40),x
                lda colour+(5*40)+1,x
                sta colour+(5*40),x
                lda colour+(6*40)+1,x
                sta colour+(6*40),x
                inx
                cpx #$27
                bne scrloop1b
                
                lda rowtemp
                sta screen+(1*40)+39
                lda rowtemp+1
                sta screen+(2*40)+39
                lda rowtemp+2
                sta screen+(3*40)+39
                lda rowtemp+3
                sta screen+(4*40)+39
                lda rowtemp+4
                sta screen+(5*40)+39
                lda rowtemp+5
                sta screen+(6*40)+39
                
                lda colourtemp
                sta colour+(1*40)+39
                lda colourtemp+1
                sta colour+(2*40)+39
                lda colourtemp+2
                sta colour+(3*40)+39
                lda colourtemp+3
                sta colour+(4*40)+39
                lda colourtemp+4
                sta colour+(5*40)+39
                lda colourtemp+5
                sta colour+(6*40)+39
skiprockstop                
                rts

;Scroll the rocks at the top of the screen
                
scrollrockstop                
               lda d016table+1
               sec
               sbc #2
               and #7
               sta d016table+1
               bcs skiprockstop
            
               lda screen+(7*40)
               sta rowtemp+6
               lda screen+(8*40)
               sta rowtemp+7
               
               ldx #$00
scrloop2       lda screen+(7*40)+1,x
               sta screen+(7*40),x
               lda screen+(8*40)+1,x
               sta screen+(8*40),x
               inx
               cpx #$27
               bne scrloop2
               
               lda rowtemp+6
               sta screen+(7*40)+39
               lda rowtemp+7
               sta screen+(8*40)+39
skipplantstop               
               rts
                
;Scroll the plants at the top of the screen

scrollplantstop
               lda d016table+2
               sec
               sbc #3
              
               and #7
               sta d016table+2
               bcs skipplantstop
               
               lda screen+(9*40)
               sta rowtemp+8
               lda screen+(10*40)
               sta rowtemp+9
           
               lda colour+(9*40)
               sta colourtemp+6
               lda colour+(10*40)
               sta colourtemp+7
               
               ldx #$00
scrloop3       lda screen+(9*40)+1,x
               sta screen+(9*40),x
               lda screen+(10*40)+1,x
               sta screen+(10*40),x
               lda colour+(9*40)+1,x
               sta colour+(9*40),x
               lda colour+(10*40)+1,x
               sta colour+(10*40),x
               inx
               cpx #$27
               bne scrloop3
               
               lda rowtemp+8
               sta screen+(9*40)+39
               lda rowtemp+9
               sta screen+(10*40)+39
               
               lda colourtemp+6
               sta colour+(9*40)+39
               lda colourtemp+7
               sta colour+(10*40)+39
               
skipmainscroll               
               rts
                
;Scroll main screen. This will not need any wrap around, since
;fruit and bombs are spawned from the right of the screen to the
;left.

scrollmainscreen
              lda d016table+3
              sec
              sbc #4
              and #7
              sta d016table+3
              bcs skipmainscroll
              
              lda screen+(11*40)
              sta rowtemp+15
              lda screen+(20*40)
              sta rowtemp+16
            
              ldx #$00
scrloop4      lda screen+(11*40)+1,x
              sta screen+(11*40),x
              lda screen+(12*40)+1,x
              sta screen+(12*40),x
              lda screen+(13*40)+1,x
              sta screen+(13*40),x
              lda screen+(14*40)+1,x
              sta screen+(14*40),x
              lda screen+(15*40)+1,x
              sta screen+(15*40),x
              inx
              cpx #$27
              bne scrloop4
              
              ldx #$00
scrloop4b              
              lda screen+(16*40)+1,x
              sta screen+(16*40),x
              lda screen+(17*40)+1,x
              sta screen+(17*40),x
              lda screen+(18*40)+1,x
              sta screen+(18*40),x
              lda screen+(19*40)+1,x
              sta screen+(19*40),x
              lda screen+(20*40)+1,x
              sta screen+(20*40),x
              
              inx
              cpx #$27
              bne scrloop4b
              
              lda rowtemp+15
              sta screen+(11*40)+39
              lda rowtemp+16
              sta screen+(20*40)+39
              
              ;Spawn objects from top left of screen
              
              ldx spawnvalue
              lda spawncolumn1,x
              sta spawnrow1
              lda spawncolumn2,x
              sta spawnrow2
              lda spawncolumn3,x
              sta spawnrow3
              lda spawncolumn4,x
              sta spawnrow4
              lda spawncolumn5,x
              sta spawnrow5
              lda spawncolumn6,x
              sta spawnrow6
              lda spawncolumn7,x
              sta spawnrow7
              lda spawncolumn8,x
              sta spawnrow8
              inx
              cpx #3
              beq nospawn
              inc spawnvalue
              rts
nospawn       ldx #$02 ;Empty space
              stx spawnvalue
              jmp zerospawn
              
              
              ;Clear all spawn columns 
              
zerospawn     ldx #$00
zeroloop      lda #lane
              sta spawncolumn1,x
              sta spawncolumn2,x
              sta spawncolumn3,x
              sta spawncolumn4,x
              sta spawncolumn5,x
              sta spawncolumn6,x
              sta spawncolumn7,x
              sta spawncolumn8,x
              inx
              cpx #$03
              bne zeroloop
              rts
                
              
              
skipplantsbottom              
              rts
      
;Scroll plants at bottom of the screen
              
scrollplantsbottom
             
              lda d016table+4
              sec
              sbc #5
              and #7
              sta d016table+4
              bcs skipplantsbottom
              
              lda screen+(21*40)
              sta rowtemp+10
              lda screen+(22*40)
              sta rowtemp+11
              lda colour+(21*40)
              sta colourtemp+11
              lda colour+(22*40)
              sta colourtemp+12
              ldx #$00
scrloop5
              lda screen+(21*40)+1,x
              sta screen+(21*40),x
              lda screen+(22*40)+1,x
              sta screen+(22*40),x
              lda colour+(21*40)+1,x
              sta colour+(21*40),x
              lda colour+(22*40)+1,x
              sta colour+(22*40),x
              inx
              cpx #$27
              bne scrloop5
              
              lda rowtemp+10
              sta screen+(21*40)+39
              lda rowtemp+11
              sta screen+(22*40)+39
              lda colourtemp+11
              sta colour+(21*40)+39
              lda colourtemp+12
              sta colour+(22*40)+39
skiprocksbottom              
              rts
              
;Finally scroll the rocks at the bottom 

scrollrocksbottom
              lda d016table+5
              sec
              sbc #6
              and #7
              sta d016table+5
              bcs skiprocksbottom
              
              lda screen+(23*40)
              sta rowtemp+12
              lda screen+(24*40)
              sta rowtemp+13
              
              ldx #$00
scrloop6      lda screen+(23*40)+1,x
              sta screen+(23*40),x
              lda screen+(24*40)+1,x
              sta screen+(24*40),x
              inx
              cpx #$27
              bne scrloop6
              
              lda rowtemp+12
              sta screen+(23*40)+39
              lda rowtemp+13
              sta screen+(24*40)+39
              rts
                
;Game spawn logic

spawnlogic       
                lda spawndelay
                cmp spawndelayexpiry
                beq testspawntime
                inc spawndelay
                rts
testspawntime   lda #$00
                sta spawndelay
                
;Pick object type by calling the randomizer, and then 
;store the object to the correct column table.

                jsr randomizer
                sta sequencepointer
                ldx sequencepointer
                lda sequencetable0,x
                sta rowvalue 
                
                lda rowvalue 
                beq lowerspawn
                jmp upperspawn
lowerspawn                
                jsr randomizer 
                ldx sequencepointer
                lda sequencetable1,x
                sta objectread
                jsr randomizer
                
                ldx sequencepointer
                lda sequencetable2,x
                sta positionread
                
                ;Setup object ID 
                
                ldx objectread
                lda objectstopleft,x
                sta objectread1+1
                lda objectstopright,x
                sta objectread2+1
                lda objectsbottomleft,x
                sta objectread3+1
                lda objectsbottomright,x
                sta objectread4+1
                
                ;Setup row position
                
                ldx positionread
                lda spawnpos1lo,x
                sta destpos1+1
                lda spawnpos1hi,x
                sta destpos1+2
                lda spawnpos2lo,x
                sta destpos2+1
                lda spawnpos2hi,x
                sta destpos2+2
                lda spawnpos3lo,x
                sta destpos3+1
                lda spawnpos3hi,x
                sta destpos3+2
                lda spawnpos4lo,x
                sta destpos4+1
                lda spawnpos4hi,x
                sta destpos4+2
                jmp makeobjects
                
upperspawn      ldx sequencepointer
                lda sequencetable1,x
                sta objectread
                jsr randomizer
                
                ldx sequencepointer
                lda sequencetable2,x
                sta positionread
                
                ;Setup small object ID
                
                ldx objectread
                lda smallobjectstopleft,x
                sta objectread1+1
                lda smallobjectstopright,x
                sta objectread2+1
                lda smallobjectsbottomleft,x
                sta objectread3+1
                lda smallobjectsbottomright,x
                sta objectread4+1
                
                ldx positionread
                lda spawnpos5lo,x
                sta destpos1+1
                lda spawnpos5hi,x
                sta destpos1+2
                lda spawnpos6lo,x
                sta destpos2+1
                lda spawnpos6hi,x
                sta destpos2+2
                lda spawnpos7lo,x
                sta destpos3+1
                lda spawnpos7hi,x
                sta destpos3+2
                lda spawnpos8lo,x
                sta destpos4+1
                lda spawnpos8hi,x
                sta destpos4+2
                
                ;Now setup the objects and position
makeobjects
                
objectread1     lda #banana1
destpos1        sta spawncolumn1
objectread2     lda #banana2
destpos2        sta spawncolumn2
objectread3     lda #banana3
destpos3        sta spawncolumn3
objectread4     lda #banana4
destpos4        sta spawncolumn4

                lda #0
                sta spawnvalue
                rts
                 
;Random timer routine for working out sequence number to 
;read from table (for spawning objects / setting position).                

randomizer      lda rand+1
                sta rtemp 
                lda rand
                asl
                rol rtemp 
                asl 
                rol rtemp 
                clc
                adc rand 
                pha 
                lda rtemp 
                adc rand+1
                sta rand+1
                pla
                adc #$11
                sta rand
                lda rand+1
                adc #$36
                sta rand+1
                rts
                
;Main game level control

levelcontrolmain

!ifdef testgameend {
                jmp gamecomplete 
                }
              
                jsr scrolllevup
                lda leveltime
                cmp leveltimeexpiry ;milliseconds
                beq nexttime
                inc leveltime
                rts
nexttime        lda #0
                sta leveltime
                inc leveltime+1
               
                lda leveltime+1
                cmp #5
                bne notpaintgold1
                jmp paintsnakegold1
                
notpaintgold1   cmp #10
                bne notpaintgold2
                jmp paintsnakegold2
                
notpaintgold2   cmp #15
                bne notpaintgold3
                jmp paintsnakegold3
                
notpaintgold3   cmp #20
                bne notpaintgold4
                jmp paintsnakegold4
                
notpaintgold4   cmp #25
                bne notpaintgold5
                jmp paintsnakegold5
                
notpaintgold5   cmp #30  
                bne notpaintgold6
                jmp paintsnakegold6
                
notpaintgold6   cmp #35
                bne notpaintgold7
                jmp paintsnakegold7
                
notpaintgold7                
                cmp #40
                beq nextlevel
                rts
                
nextlevel       lda #0
                sta leveltime
                sta leveltime+1
                lda level
                cmp #$38
                beq gamecomplete
                lda spawndelayexpiry
                sec
                sbc #8
                sta spawndelayexpiry
                inc level
                jsr maskscorepanel
                jsr paintsnakegreen
                
                ;Position level up sprites and make them scroll across the screen
                ldx #$00
makesprs        lda levelupspritetable,x
                sta $07fb,x
                lda #$05
                sta $d02a,x
                inx
                cpx #$04
                bne makesprs
                
                ldx #$00
poslevup        lda levuppostable,x
                sta objpos+6,x
                inx
                cpx #$08
                bne poslevup
                
                lda #<levelupsfx
                ldy #>levelupsfx
                ldx #14
                jsr sfxplay
                rts

;Game completed
gamecomplete
                jsr synctimer
                jsr expandmsb
                jsr spriteanimation
                jsr moveplayeroutofscene
                jsr snakerange
                jsr parallax
                jmp gamecomplete

;Move the snake out of the game scenery.

moveplayeroutofscene
                lda objpos+4
                clc
                adc #1
                cmp #$e0
                bcc notexitend
                jmp allspritesout
notexitend      sta objpos+4
                lda objpos+2
                clc
                adc #1
                sta objpos+2
                lda objpos
                clc
                adc #1
                sta objpos
                rts
                
;Scrolling stops, and well done sprites appear on screen.

;Enable all sprites
allspritesout               
                lda #gamecompletemusic
                jsr musicinit
                
                lda #$00
                sta $d015
                sta $d01c
                
                ;Disable other sprite priorities
                
                lda #$00
                sta $d017
                sta $d01b
                sta $d01d
                sta firebutton 
                
                ;Setup the GET READY sprites
                
                ldx #$00
makewdsprites   lda welldonespritetable,x
                sta $07f8,x
                lda #$01
                sta $d027,x
                inx
                cpx #4
                bne makewdsprites
                
                lda #$a8
                sta objpos+1
                sta objpos+3
                sta objpos+5
                sta objpos+7
                lda #$44
                sta objpos
                clc
                adc #$0c
                sta objpos+2
                adc #$0c
                sta objpos+4
                adc #$0c
                sta objpos+6
               
                lda #%00001111
                sta $d015
                sta $d01c
                lda #$05
                sta $d025
                lda #$07
                sta $d026
                lda #0
                sta firebutton
wdloop          jsr synctimer      
                jsr expandmsb
                jsr parallax
                
                lda $dc00
                lsr
                lsr
                lsr
                lsr
                lsr
                bit firebutton
                ror firebutton
                bmi wdloop
                bvc wdloop
                jmp endscreen
                
                
                
                ;Continue animation, but make snake slither out of the screen.
                
  
;Scroll level up sprites across the screen. After they have
;left the screen, remove them                
                
scrolllevup     
                lda objpos+12
                sec
                sbc #2
                cmp #$02
                bcs notoffset
                lda #$00
                sta objpos+7
                sta objpos+9
                sta objpos+11
                sta objpos+13
                rts
notoffset       sta objpos+12
                lda objpos+12
                 
                sbc #12
                sta objpos+10
                sbc #12
                sta objpos+8
                sbc #12
                sta objpos+6
                rts
                
;Paint snake gold according to distance

paintsnakegold1 lda #$0f ;Yellow = gold
                sta colour+24
                rts
paintsnakegold2 
                lda #$0f
                sta colour+25
                rts
                
paintsnakegold3 lda #$0f
                sta colour+26
                rts
                
paintsnakegold4 lda #$0f
                sta colour+27
                rts
                
paintsnakegold5 lda #$0f
                sta colour+28
                rts
                
paintsnakegold6 lda #$0f
                sta colour+29
                rts
                
paintsnakegold7 lda #$0f
                sta colour+30
                rts
                
;Paint snake green

paintsnakegreen
                ldx #$00
paintloop       lda #$0d
                sta colour+24,x
                inx
                cpx #7
                bne paintloop
                rts
                
;Player control (and animation)

playercontrol  
                jsr spriteanimation       ;Animate the main player
                jsr joystickcontrol       ;call joystick control for the main player
                jsr snakerange            ;set snake range for size visual position of the snake sprites
                jmp spritetocharcollision ;Sprite to charset collision routine (scoring, death, etc).
                
;Player joystick control (up or down only)

joystickcontrol
                lda #1
                bit $dc00
                bne checkgamejoydown
                lda objpos+1
                sec
                sbc #2
                cmp #$90
                bcs updateupposition
                lda #$90
updateupposition                
                sta objpos+1
                sta objpos+3
                sta objpos+5
                rts
checkgamejoydown
                lda #2
                bit $dc00
                bne nogamejoycontrol
                lda objpos+1
                clc
                adc #2
                cmp #$c0
                bcc updatebottomposition
                lda #$c0
updatebottomposition
                sta objpos+1
                sta objpos+3
                sta objpos+5
nogamejoycontrol                
                rts
                
;Sprite animation routines 
spriteanimation                
                lda spriteanimdelay
                cmp #5
                beq animsprites
                inc spriteanimdelay
                rts
animsprites     lda #0                
                sta spriteanimdelay
                ldx spriteanimpointer
                lda largesnakeheadframe,x
                sta largesnakehead
                lda largesnakebodyframe,x
                sta largesnakebody
                lda largesnaketailframe,x
                sta largesnaketail
                lda smallsnakeheadframe,x
                sta smallsnakehead
                lda smallsnakebodyframe,x
                sta smallsnakebody
                lda smallsnaketailframe,x
                sta smallsnaketail
                inx
                cpx #4
                beq loopspriteanim
                inc spriteanimpointer
                rts
loopspriteanim  ldx #0
                stx spriteanimpointer
                rts
  
;Check snake Y position range, so that the correct size frame
;can be picked to be stored onto the actual sprite

snakerange      lda objpos+1
                cmp #$ac
                bcc under
                cmp #$ac
                bcs over
                rts
over             
                lda largesnakehead
                sta $07f8
                lda largesnakebody
                sta $07f9
                lda largesnaketail
                sta $07fa
                rts
under          
                lda smallsnakehead
                sta $07f8
                lda smallsnakebody
                sta $07f9
                lda smallsnaketail
                sta $07fa
                rts
                
;Sprite to background collision detection

spritetocharcollision

                lda objpos+1
                sec
colltesty       sbc #$32
                lsr
                lsr
                lsr
                tay
                
                lda screenlo,y
                sta screenlostore
                lda screenhi,y
                sta screenhistore
                
                lda objpos 
                sec
colltestx       sbc #$07
                lsr
                lsr
                tay
                
                ldx #$03
                sty selfmodi+1
                
bgcloop         jmp  checkobjectchars

selfmodi         ldy #$00
                lda screenlostore
                clc
                adc #40
                sta screenlostore
                bcc skipmod
                inc screenhistore
skipmod         dex
                bne bgcloop
                rts
                
;Check object characters to see whether or not they relate to fruit or bombs
   
checkobjectchars 

               ;Does the snake hit a large apple (Only read top left/right?
               lda (screenlostore),y
               cmp #apple1
               bne notlargeapple
               jmp appleeatenleft
notlargeapple
               cmp #apple2 
               bne notlargeapple2
               jmp appleeatenright
notlargeapple2
               ;Does the snake hit a small apple 
               cmp #smallapple1
               bne notsmallapple
               jmp appleeatenleft
notsmallapple
               cmp #smallapple2
               bne notsmallapple2
               jmp appleeatenright
notsmallapple2               
               ;Does the snake hit a large banana?
               cmp #banana1
               bne notlargebanana
               jmp bananaeatenleft
notlargebanana               
               cmp #banana2
               bne notlargebanana2
               jmp bananaeatenright
notlargebanana2
               ;Does the snake hit a small banana?
               cmp #smallbanana1
               bne notsmallbanana
               jmp bananaeatenleft
notsmallbanana                 
               cmp #smallbanana2
               bne notsmallbanana2 
               jmp bananaeatenright
               
               ;Does the snake hit cherries?
notsmallbanana2
               cmp #cherry1
               bne notcherry
               jmp cherrieseatenleft
               
notcherry      cmp #cherry2               
               bne notcherry2
               jmp cherrieseatenright 
               
notcherry2     ;Does the snake hit small cherries?               
               cmp #smallcherry1
               bne notsmallcherry
               jmp cherrieseatenleft
               
notsmallcherry
               cmp #smallcherry2
               bne notsmallcherry2
               jmp cherrieseatenright
               
               ;Does the snake hit a large strawberry?
notsmallcherry2               
               cmp #strawberry1
               bne notstrawberry
               jmp strawberryeatenleft
notstrawberry               
               cmp #strawberry2
               bne notstrawberry2
               jmp strawberryeatenright 
               
               ;Does the snake hit a small strawberry
notstrawberry2
               cmp #smallstrawberry1
               bne notsmallstrawberry
               jmp strawberryeatenleft
               
notsmallstrawberry
               cmp #smallstrawberry2
               bne notsmallstrawberry2
               jmp strawberryeatenright
notsmallstrawberry2

               ;Does the snake hit a large bomb?
               cmp #bomb1
               bne nothitbomb
               jmp bombkillplayerleft
nothitbomb     cmp #bomb2 
               bne nothitbomb2
               jmp bombkillplayerright
nothitbomb2     
               ;Does the snake hit a small bomb?
               cmp #smallbomb1
               bne nothitsmallbomb
               jmp bombkillplayerleft
nothitsmallbomb                
               cmp #smallbomb2 
               bne nothitsmallbomb2
               jmp bombkillplayerright

nothitsmallbomb2
               jmp selfmodi
               

;Snake eats apple, remove apple, score 100 points and play
;apple sound effects.

appleeatenleft
               jsr appleto100ptsleft
               jsr score100
               jmp playapplesfx
               
appleeatenright
               jsr appleto100ptsright
               jsr score100
playapplesfx   lda #<snakeapplessfx
               ldy #>snakeapplessfx
               ldx #14
               jsr sfxplay
               rts
               
;Snake eats banana, remove banana, score 200 points and play
;banana sound effects.

bananaeatenleft
              jsr bananato200ptsleft
              jsr score200
              jmp playbananasfx
bananaeatenright
              jsr bananato200ptsright
              jsr score200
playbananasfx    
              lda #<snakebananasfx
              ldy #>snakebananasfx
              ldx #14
              jsr sfxplay
              rts
              
;Snake eats cherries, remove cherries, score 300 points and
;play cherries sound effects.

cherrieseatenleft
              jsr cherriesto300ptsleft
              jsr score300
              jmp playcherriessfx
cherrieseatenright              
              jsr cherriesto300ptsright
              jsr score300
playcherriessfx
              lda #<snakecherriessfx
              ldy #>snakecherriessfx
              ldx #14
              jsr sfxplay
              rts
              
;Snake eats strawberry, remove strawberry, score 500 points and
;play strawberry sound effects.

strawberryeatenleft
              jsr strawberryto500ptsleft
              jsr score500
              jmp playstrawberrysfx
strawberryeatenright
              jsr strawberryto500ptsright
              jsr score500
playstrawberrysfx
              lda #<snakestrawberrysfx
              ldy #>snakestrawberrysfx
              ldx #14
              jsr sfxplay
              rts
              
;Finally, the snake hits a bomb. Remove the bomb and destroy 
;the snake.

bombkillplayerleft 
              jsr removecharleft
              jmp killsnake
              
bombkillplayerright
              jsr removecharright
              
;Kill the snake
killsnake
              lda #<bombsfx
              ldy #>bombsfx
              ldx #14
              jsr sfxplay
              
              jmp snakedestroyer
              
               
;Replace object characters as lane
              
;Remove characters from top left
               
removecharleft
               lda #lane
               sta (screenlostore),y
               iny
               sta (screenlostore),y
               tya
               sec
               clc
               adc #40
               tay
               lda #lane
               sta (screenlostore),y
               dey
               sta (screenlostore),y
               rts
               
;Remove characters from top right 

removecharright
               lda #lane
               sta (screenlostore),y
               dey
               sta (screenlostore),y
               tya
               clc
               adc #40
               tay
               lda #lane
               sta (screenlostore),y
               iny
               sta (screenlostore),y
               rts
    
;Turn apple  char into 100 points

appleto100ptsleft
              lda #points100a
              sta (screenlostore),y
              iny
              lda #points100b
              sta (screenlostore),y
              tya
              clc
              adc #40
              tay
              lda #points100d
              sta (screenlostore),y
              dey
              lda #points100c
              sta (screenlostore),y
              rts
              
appleto100ptsright
              inc $d020
              lda #points100b
              sta (screenlostore),y
              dey
              lda #points100a
              sta (screenlostore),y
              tya
              clc
              adc #40
              tay
              lda #171
              sta (screenlostore),y
              iny
              lda #points100d
              sta (screenlostore),y
              rts
              
;Transform banana into 200 points              
              
bananato200ptsleft              
              lda #points200a
              sta (screenlostore),y
              iny
              lda #points200b
              sta (screenlostore),y
              tya
              clc
              adc #40
              tay
              lda #points200d
              sta (screenlostore),y
              dey
              lda #points200c
              sta (screenlostore),y
              rts
              
bananato200ptsright
              lda #points200b
              sta (screenlostore),y
              dey
              lda #points200a
              sta (screenlostore),y
              tya
              clc
              adc #40
              tay
              lda #points200c
              sta (screenlostore),y
              iny
              lda #points200d
              sta (screenlostore),y
              rts
              
;Transform cherries to 300 points              

cherriesto300ptsleft
              lda #points300a
              sta (screenlostore),y
              iny
              lda #points300b
              sta (screenlostore),y
              tya
              clc
              adc #40
              tay
              lda #points300d
              sta (screenlostore),y
              dey
              lda #points300c
              sta (screenlostore),y
              rts
              
cherriesto300ptsright
              lda #points300b
              sta (screenlostore),y
              dey
              lda #points300a
              sta (screenlostore),y
              tya
              clc
              adc #40
              tay
              lda #points300c
              sta (screenlostore),y
              iny
              lda #points300d
              sta (screenlostore),y
              rts
              
;Transform stawberry to 500 points

strawberryto500ptsleft
              lda #points500a
              sta (screenlostore),y
              iny
              lda #points500b
              sta (screenlostore),y
              tya
              clc
              adc #40
              tay
              lda #points500d
              sta (screenlostore),y
              dey
              lda #points500c
              sta (screenlostore),y
              rts
              
strawberryto500ptsright
              lda #points500b
              sta (screenlostore),y
              dey
              lda #points500a
              sta (screenlostore),y
              tya
              clc
              adc #40
              tay
              lda #points500c
              sta (screenlostore),y
              iny
              lda #points500d
              sta (screenlostore),y
              rts

              
              
               
;Add score values according to fruit eaten 

score500      jsr score100points
              jsr score100points
score300      jsr score100points
score200      jsr score100points
score100      jmp score100points


               
;The player scores points for eating fruit 
               
score100points                
              inc score+3
              ldx #3
scoreloop     lda score,x
              cmp #$3a
              bne scoreok
              lda #$30
              sta score,x
              inc score-1,x
scoreok       dex
              bne scoreloop
              jsr maskscorepanel
              rts  
            
;Mask status panel for score update

maskscorepanel  ldx #$00
putstatuspanel  lda statuspanel,x
                sta screen,x
                inx
                cpx #$28
                bne putstatuspanel
                rts
                
;The main snake destroyer subroutine 

snakedestroyer 
                lda #0
                sta explodeanimpointer
                sta explodeanimdelay 
                lda explosionframe
                sta $07f8
                sta $07f9
                sta $07fa
                
explosionloop   jsr synctimer
                jsr expandmsb
                jsr animexplosion
                jmp explosionloop
animexplosion            
                lda explodeanimdelay
                cmp #3
                beq explodeanimok
                inc explodeanimdelay
                rts
explodeanimok   lda #0
                sta explodeanimdelay
                ldx explodeanimpointer
                lda explosionframe,x
                sta $07f8
                sta $07f9
                sta $07fa
                inx
                cpx #7
                beq morphtodeadsnake
                inc explodeanimpointer
                rts
                
;Explosion has finished, morph explosion sprites to dead snake                

morphtodeadsnake
                ldx #0
                stx explodeanimpointer
                lda #1
                sta $d027
                sta $d028
                sta $d029
                
                ;Check range again
                
                lda objpos+1
                cmp #$ac
                bcc issmalldeadsnake
                bcs islargedeadsnake
issmalldeadsnake
                lda smalldeadsnakehead
                ldx smalldeadsnakebody
                ldy smalldeadsnaketail
                sta $07f8
                stx $07f9
                sty $07fa
                jmp gameover
                
islargedeadsnake
                lda largedeadsnakehead
                ldx largedeadsnakebody
                ldy largedeadsnaketail 
                sta $07f8
                stx $07f9
                
;Game over routine

gameover        lda #gameovermusic
                jsr musicinit
                
                ldx #0
makegameoverspr lda gameoverspritetable,x
                sta $07fa,x
                lda #$05
                sta $d029,x
                inx
                cpx #6
                bne makegameoverspr
                
;Now place game over sprites

                ldx #$00
readgopos       lda gameoverpos,x
                sta objpos+4,x
                inx
                cpx #$0c
                bne readgopos
               
                
;Game over loop
                jsr maskscorepanel
                
                lda #0
                sta firebutton
gameoverloop                
                jsr synctimer
                jsr expandmsb
                jsr spritesinus
                
                lda $dc00
                lsr
                lsr
                lsr
                lsr
                lsr
                bit firebutton
                ror firebutton
                bmi gameoverloop
                bvc gameoverloop
                
                jmp gamestart
                
spritesinus     ldx sinuspointer
                lda sinus,x
                sta objpos+4
                lda objpos+4
                clc
                adc #12
                sta objpos+6
                adc #12
                sta objpos+8
                adc #12
                sta objpos+10
                adc #12
                sta objpos+12
                adc #12
                sta objpos+14
                inc sinuspointer
                rts
                


                
                
                
                !source "pointers.asm"
                    