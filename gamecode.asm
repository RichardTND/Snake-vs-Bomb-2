 
;GAME CODE
      
;Call routine to stop existing interrupts/IRQs from
;playing and also switch the screen off. 

gamestart       jsr killirqs
                ldx #$fb
                txs
                
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
               
                ;Place score panel on screen 
                jsr maskscorepanel
                
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
                
;Prepare in game IRQ raster interrupts          

                ldx #<gameirq1
                ldy #>gameirq1
                lda #$7f
                stx $fffe
                sty $ffff
                sta $dc0d
                sta $dd0d
                lda #$36
                sta $d012
                lda #$1b
                sta $d011
                lda #$01
                sta $d019
                sta $d01a
                lda #$01
                jsr musicinit
                cli
                jmp gameloop
                
                !source "irq.asm"
                
                

; Kill of all IRQ interrupts that are currently playing also
; make a short delay, in order to prevent sensitive fire
;button pressing

killirqs        sei
                lda #$00
                sta $d019
                sta $d01a
                sta $d015
                sta $d01b
                lda #$81
                sta $dc0d
                sta $dd0d
                ldx #$48
                ldy #$ff
                stx $fffe
                sty $ffff
                ldx #<nmi
                ldy #>nmi
                stx $fffa
                sty $fffb
                
                ;Silence the SID chip
                ldx #$00
quiet           lda #$00
                sta $d400,x
                inx
                cpx #$18
                bne quiet
                
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

gameloop        jsr synctimer     ;Synchronize game timer
                jsr scrollcontrol
                jsr levelcontrol
                jmp gameloop
                
;Scroll controller
scrollcontrol 
                jsr parallax
                jsr spawnlogic 
                rts 
                
;Game parallax routines
parallax
                jsr scrollmountains
                jsr scrollrockstop
                jsr scrollplantstop
                jsr scrollmainscreen
                jsr scrollplantsbottom
                jsr scrollrocksbottom
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
              bne scrloop4
              
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
              jsr zerospawn
              rts
              
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
                
;Synchronize timer
synctimer       lda #0
                sta rt
                cmp rt
                beq *-3
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

levelcontrol    lda leveltime
                cmp leveltimeexpiry ;milliseconds
                beq nexttime
                inc leveltime
                rts
nexttime        lda #0
                sta leveltime
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
skipcounter                
                inc leveltime+1
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
                rts

;Game completed
gamecomplete
                inc $d020
                jmp *-3
  
                
;Paint snake gold according to distance

paintsnakegold1 lda #$0f ;Yellow = gold
                sta colour+24
                jmp skipcounter
paintsnakegold2 lda #$0f
                sta colour+25
                jmp skipcounter
paintsnakegold3 lda #$0f
                sta colour+26
                jmp skipcounter
paintsnakegold4 lda #$0f
                sta colour+27
                jmp skipcounter
paintsnakegold5 lda #$0f
                sta colour+28
                jmp skipcounter
paintsnakegold6 lda #$0f
                sta colour+29
                jmp skipcounter
paintsnakegold7 lda #$0f
                sta colour+30
                jmp skipcounter
                
;Paint snake green

paintsnakegreen
                ldx #$00
paintloop       lda #$0d
                sta colour+24,x
                inx
                cpx #7
                bne paintloop
                rts
                
                
                
;Mask status panel for score update

maskscorepanel  ldx #$00
putstatuspanel  lda statuspanel,x
                sta screen,x
                lda #$0d
                sta colour,x
                inx
                cpx #$28
                bne putstatuspanel
                rts
                
                !source "pointers.asm"
                    