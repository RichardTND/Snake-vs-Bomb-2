;SNAKE VS BOMB 2
;GAME CODE
      
;-------------------------------------------        

;Call routine to stop existing interrupts/IRQs from
;playing and also switch the screen off. 

gamestart       
                jsr killirqs

;-------------------------------------------        
               
;Grab all graphics map data (exported as map from Charpad V2.7.6) and place those onto the screen.
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

;-------------------------------------------        

;Paint mountains chars multicolour red
                
                ldx #$00
paintmountains  lda #$0a
                sta colour,x
                sta colour+$100,x
                inx
                bne paintmountains
                
                
                lda #$03
                sta $dd00
                
;Paint the scenery multicoloured green
                
                ldx #$00
paint           
                lda #$0d
                sta colour+(7*40),x
                sta colour+(2*$100),x
                sta colour+(2*$100)+$e8,x
                inx
                bne paint

;-------------------------------------------        

;Set border and background colour black
               
                lda #$00
                sta $d020
                sta $d021 

;-------------------------------------------        
                
;Reset level and score panel 
                
                
                lda #$31
                sta level
                ldx #$00
zeroscore       lda #$30
                sta score,x
                lda #$00
                sta score1,x
                sta score2,x
                sta carry,x
                sta result,x
                inx
                cpx #$06
                bne zeroscore
                
;-------------------------------------------        
              
;Initialize the lane
                
                ldx #$00
setlane         lda #lane
                sta spawncolumn1,x
                inx
                cpx #32
                bne setlane
                
;-------------------------------------------        
               
;Place score panel on screen 

                jsr maskscorepanel
                
                ldx #$00
paintpanel      lda #$0d
                sta colour,x
                inx
                cpx #40
                bne paintpanel

;-------------------------------------------        
                
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

;-------------------------------------------        
                
;Setup the game sprites
                
                lda #0
                sta spriteanimpointer ;Default animation speed and pointer
                sta spriteanimdelay

;-------------------------------------------        

;Initialize all bytes of the parallax 
;scroll table
        
                ldx #$00
setd016table                
                lda #0
                sta d016table,x
                inx
                cpx #6
                bne setd016table

;-------------------------------------------        

;Sprites behind background
                
                lda #$ff
                sta $d01b

;-------------------------------------------        
               
;Prepare in game IRQ raster interrupts       
              
                ldx #$fb
                txs
                ldx #<gameirq1
                ldy #>gameirq1
                stx $fffe
                sty $ffff
                lda #$7f
                sta $dc0d
                sta $dd0d
                lda #$32
                sta $d012
                lda #$1b
                sta $d011
                lda #$01
                sta $d01a
                
                ;Initialize get ready jingle
                lda #getreadymusic
                jsr musicinit
                cli
                jmp getreadymain
              
;-------------------------------------------        

;Get Ready screen setup

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
                
;-------------------------------------------        

;Main loop for GET READY, until fire in 
;joystick port 2 is pressed
                
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
;-------------------------------------------        
       
;Setup the game sprite position table to object position
                
                ldx #$00
setstartpos     lda startpos,x
                sta objpos,x
                inx
                cpx #$10
                bne setstartpos

;-------------------------------------------        
                
;Setup type and colour for player sprite
                
                lda largesnakehead
                sta $07f8
                lda largesnakebody
                sta $07f9
                lda largesnaketail
                sta $07fa

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
                
;-------------------------------------------        

;Initialize in game music

                lda #gamemusic
                jsr musicinit

;-------------------------------------------        

;Jump to main game code                

                jmp gameloop

;-------------------------------------------        

;Load IRQ Raster interrupt source code

                !source "irq.asm"                
                
;-------------------------------------------                        
;Main game loop


gameloop    

;-------------------------------------------        

;Check if CONTROL has been pressed. If it 
;has then the game should be paused.

                lda #4
                bit $dc01
                bne continueplay
                
;The game is paused, check if SPACEBAR or
;FIRE has been pressed to resume the game.
                
gamepaused                
                lda #16
                bit $dc01
                bne checkfireunpause
                jmp continueplay                
                
checkfireunpause 
                lda #16
                bit $dc00
                bne checkabort
                jmp continueplay
                
;Still paused, check if LEFT ARROW has been
;pressed. If so, the game aborts to the title
;screen.
                
checkabort      lda #2
                bit $dc01
                bne gamepaused
                jmp titlescreen

;-------------------------------------------        

;Main game loop

continueplay    jsr synctimer
                jsr expandmsb       ;Expand sprite X position and store to hardwarey
                jsr scrollcontrol   ;Main game screen scrolling
                jsr gamecontrol
                jmp gameloop
               
;-------------------------------------------        

;Game control, calls for level, player, 
;animation, and other subroutines inside
;the main game loop.
                
gamecontrol     
                jsr levelcontrolmain
                jsr playercontrol   ;Player, joystick and sprite/background collision control
                jsr animbombs
                jsr spriteanimation
                jsr scrolllevup
                rts  
;-------------------------------------------        

;Synchronize timer with IRQ raster 
;interrupt (rt = raster interrupt timer)

synctimer       lda #0
                sta rt
                cmp rt
                beq *-3 
                rts
                
;-------------------------------------------                        
                
;Animate bombs character set 

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
                
;-------------------------------------------        
                
;Music player speed check and control
;(PAL NTSC)

musicplayer     
                lda system
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

;-------------------------------------------        
                
;Expand X position for all game sprites to
;use whole screen area, excluding borders.
                
expandmsb     
                ldx #$00
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
                                
;-------------------------------------------        
                
;Parallax and game scroll sub routines 

scrollcontrol  
                jsr parallax1
                jsr parallax2
                jmp spawnlogic 
                
;-------------------------------------------                    

;Parallax 1 - Controls mountain, top rocks,
;top plants wrap-around scrolling            

parallax1       jsr scrollmountains
                jsr scrollrockstop
                jmp scrollplantstop
                
;-------------------------------------------                        

;Parallax 2 - Controls main game screen,
;bottom plants, bottom rocks wrap-around 
;scrolling.

parallax2                
               
                jsr scrollplantsbottom
                jsr scrollrocksbottom
                jmp scrollmainscreen

;-------------------------------------------        

;Scroll wrap-around mountains.

scrollmountains
               
                lda d016table
                sec
                sbc #1
                and #7
                
                sta d016table
                bcs skiprockstop
                
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
                
                ldx #$00
scrloop0        lda screen+(1*40)+1,x
                sta screen+(1*40),x
                lda screen+(2*40)+1,x
                sta screen+(2*40),x
                lda screen+(3*40)+1,x
                sta screen+(3*40),x
                inx
                cpx #$27
                bne scrloop0
                ldx #$00
scrloop1                  
                lda screen+(4*40)+1,x
                sta screen+(4*40),x
                lda screen+(5*40)+1,x
                sta screen+(5*40),x
                lda screen+(6*40)+1,x
                sta screen+(6*40),x
                inx
                cpx #$27
                bne scrloop1
 
                       
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
skiprockstop                
                rts

;-------------------------------------------        

;Scroll wrap-around top rocks
               
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
           
               ldx #$00
scrloop3       lda screen+(9*40)+1,x
               sta screen+(9*40),x
               lda screen+(10*40)+1,x
               sta screen+(10*40),x
               inx
               cpx #$27
               bne scrloop3
               
               lda rowtemp+8
               sta screen+(9*40)+39
               lda rowtemp+9
               sta screen+(10*40)+39
                   
skipmainscroll               
               rts
;-------------------------------------------        
                
;Scroll main screen (Where fruit and bombs 
;are spawned into the game screen, where 
;the snake can move up/down).

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
              
skipplantsbottom              
              rts
;-------------------------------------------        
      
;Wrap-around scroll botto plants
              
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
              
              ldx #$00
scrloop5
              lda screen+(21*40)+1,x
              sta screen+(21*40),x
              lda screen+(22*40)+1,x
              sta screen+(22*40),x
              inx
              cpx #$27
              bne scrloop5
              
              lda rowtemp+10
              sta screen+(21*40)+39
              lda rowtemp+11
              sta screen+(22*40)+39
           
skiprocksbottom              
              rts
           
;-------------------------------------------                      

;Wrap-around scroll bottom rocks

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
;-------------------------------------------        
                
;Game spawn logic. First reads delay value
;and then after expired, calls randomizer
;and positions new objects on screen.

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
;-------------------------------------------        
                 
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

;-------------------------------------------                        
;Main game level control and snake status
;paintt routines.

levelcontrolmain
  
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
                jsr award1000points
                jsr maskscorepanel
                jsr paintsnakegreen
;-------------------------------------------        
                
;Position level up sprites and make them scroll 
;across the screen

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
                
;-------------------------------------------        

;Game complete loop

gamecomplete
                jsr synctimer
                jsr expandmsb
                jsr spriteanimation
                jsr moveplayeroutofscene
                jsr snakerange
                jsr parallax1
                jsr parallax2
                jmp gamecomplete
;-------------------------------------------        

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
;-------------------------------------------        

;Enable all sprites
allspritesout               
                lda #gameovermusic
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
                
                ;Well done jingle
                lda #welldonemusic
                jsr musicinit
;-------------------------------------------        
;Make well done sprites
                
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
                
;-------------------------------------------        
;Main loop for Well Done routine                
                
wdloop          jsr synctimer      
                jsr expandmsb
                jsr parallax1
                jsr parallax2
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
                
;-------------------------------------------      
                  
;Scroll level up sprites across the screen. 
;After they are offset remove them.
                
scrolllevup     
                lda objpos+12
                sec
                sbc #4
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
                sec
                sbc #12
                sta objpos+10
                sbc #12
                sta objpos+8
                sbc #12
                sta objpos+6
                rts
;-------------------------------------------        
                
;Paint snake gold according to distance
;the player has travelled

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
                
;-------------------------------------------                        

;Player control (and animation)

playercontrol   
                
                jsr joystickcontrol       ;call joystick control for the main player
                jsr snakerange            ;set snake range for size visual position of the snake sprites
                jmp spritetocharcollision ;Sprite to charset collision routine (scoring, death, etc).

;-------------------------------------------        
                
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
;-------------------------------------------        
                
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
;-------------------------------------------        
  
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
                
;-------------------------------------------                        

;Software based sprite to background 
;collision routine.

spritetocharcollision
 
                ;Fix all snake sprites to 
                ;select which objects should collide
                ;Head - Fruit
                ;Full body - Bombs
                
                lda #<sprite00x
                sta collxtest+1
                lda #<sprite00y
                sta collytest+1
                jsr testcollider
                lda #<sprite01x
                sta collxtest+1
                lda #<sprite01y
                sta collytest+1
                jsr testcollider
                lda #<sprite02x
                sta collxtest+1
                lda #<sprite02y
                sta collytest+1
                
testcollider                
collytest       lda objpos+1
                sec
                sbc #$36
                lsr
                lsr
                lsr
                tay
                
                lda screenlo,y
                sta screenlostore
                lda screenhi,y
                sta screenhistore
                
collxtest       lda objpos 
                sec
                sbc #$07
                lsr
                lsr
                tay
                
                ldx #$03
                sty selfmodi+1
                
bgcloop         jmp checkobjectchars

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
;-------------------------------------------                        
;Check object characters to see whether or not they relate to fruit or bombs
   
checkobjectchars 
                
               ;Test 
               lda collxtest+1
               cmp #<objpos
               bne notjustsnakehead
               lda (screenlostore),y
               jmp collimain
notjustsnakehead
               lda (screenlostore),y
               jmp snakefullcoll
               
               ;Does the snake hit a large apple (Only read top left/right?
collimain               
         
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

snakefullcoll  lda cheatmodeon
               cmp #1
               bne checkbombscollision
               jmp selfmodi
checkbombscollision               
               ;Does the snake hit a large bomb?
               lda (screenlostore),y
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
               
;-------------------------------------------        

;Snake eats apple, remove apple, score 100 points and play
;apple sound effects.

appleeatenleft
               jsr appleto100ptsleft
               jsr score100
               jsr playapplesfx
               rts
               
appleeatenright
               jsr appleto100ptsright
               jsr score100
playapplesfx   lda #<snakeapplessfx
               ldy #>snakeapplessfx
               ldx #14
               jsr sfxplay
               rts

;-------------------------------------------        
               
;Snake eats banana, remove banana, score 200 points and play
;banana sound effects.

bananaeatenleft
              jsr bananato200ptsleft
              jsr score200
              jsr playbananasfx
              rts
bananaeatenright
              jsr bananato200ptsright
              jsr score200
playbananasfx    
              lda #<snakebananasfx
              ldy #>snakebananasfx
              ldx #14
              jsr sfxplay
              rts

;-------------------------------------------        
              
;Snake eats cherries, remove cherries, score 300 points and
;play cherries sound effects.

cherrieseatenleft
              jsr cherriesto300ptsleft
              jsr score300
              jsr playcherriessfx
              rts
cherrieseatenright              
              jsr cherriesto300ptsright
              jsr score300
playcherriessfx
              lda #<snakecherriessfx
              ldy #>snakecherriessfx
              ldx #14
              jsr sfxplay
              rts

;-------------------------------------------        
              
;Snake eats strawberry, remove strawberry, score 500 points and
;play strawberry sound effects.

strawberryeatenleft
              jsr strawberryto500ptsleft
              jsr score500
              jsr playstrawberrysfx
              rts
strawberryeatenright
              jsr strawberryto500ptsright
              jsr score500
playstrawberrysfx
              lda #<snakestrawberrysfx
              ldy #>snakestrawberrysfx
              ldx #14
              jsr sfxplay
              rts

;-------------------------------------------        
              
;Finally, the snake hits a bomb. Remove the bomb and destroy 
;the snake.

bombkillplayerleft 
              jsr removecharleft
              jmp killsnake
              
bombkillplayerright
              jsr removecharright

;-------------------------------------------        
              
;Kill the snake

killsnake    
              ;Clear all existing objects on road
              
              ldx #$00
clearroad     lda #lane 
              sta screen+(12*40),x
              sta screen+(13*40),x
              sta screen+(14*40),x
              sta screen+(15*40),x
              sta screen+(16*40),x
              sta screen+(17*40),x
              sta screen+(18*40),x
              sta screen+(19*40),x
              inx
              cpx #40
              bne clearroad

              ldx #0
resetd016     lda #0
              sta d016table,x
              inx
              cpx #6
              bne resetd016
              lda #0
              sta expcoldelay
              sta expcoltimer
              
              lda #deathmusic
              jsr musicinit
              lda #<bombsfx
              ldy #>bombsfx
              ldx #14
              jsr sfxplay
              
              jmp snakedestroyer
;-------------------------------------------        
              
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

;-------------------------------------------        
               
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
;-------------------------------------------        
    
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

;-------------------------------------------        
              
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
;-------------------------------------------        
              
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
              
;-------------------------------------------                      
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

;-------------------------------------------        
;Add score values according to fruit eaten 

score500      lda #5      
              sta vblank
              jmp scorepoints
              
score300      lda #3
              sta vblank
              jmp scorepoints
              
score200      lda #2
              sta vblank
              jmp scorepoints
              
score100      lda #1
              sta vblank
              jmp scorepoints
             
;-------------------------------------------        
               
;The player scores points for eating fruit 
               
scorepoints
              lda vblank
              sta score2+3
              ldx #$05
shiftscore    
              lda score,x
              sec
              sbc #$30
              sta score1,x
              dex 
              bpl shiftscore
              ldx #$05
              lda #$00
scoreloop1    sta carry,x
              dex
              bpl scoreloop1
              
              ldx #$05
scoreloop2    lda score1,x
              clc
              adc score2,x
              adc carry,x
              and #$0f
              cmp #$0a
              bcc nocarry
              inc carry-1,x
              sec
              sbc #$0a
nocarry       ora #$30
              sta result,x
              dex
              bpl scoreloop2
              ldx #5
scoreloop3    lda result,x
              
              sta score,x
              dex
              bpl scoreloop3
              jsr maskscorepanel
              rts
              
         rts  
;-------------------------------------------        
              
;Award 1000 points for level completion             
 
award1000points
              inc score+2
              ldx #2
scoreloop4    lda score,x
              cmp #$3a
              bne scoreok2
              lda #$30
              sta score,x
              inc score-1,x
scoreok2      dex
              bne scoreloop4
              jsr maskscorepanel
              rts
              
;-------------------------------------------                    

;Mask status panel for score update

maskscorepanel  ldx #$00
putstatuspanel  lda statuspanel,x
                sta screen,x
                inx
                cpx #$28
                bne putstatuspanel
                rts
                
;-------------------------------------------        
                
;The main snake destroyer subroutine 

snakedestroyer  
                lda #0
                sta explodeanimpointer
                sta explodeanimdelay 
                
                lda explosionframe
                sta $07f8
                sta $07f9
                sta $07fa
                lda #$af
                sta $07fb
                sta $07fc
                sta $07fd
                sta $07fe
                sta $07ff
                lda objpos
                sec
                sbc #4
                sta objpos+6
                lda objpos+2
                sbc #4
                sta objpos+8
                lda objpos+1
                sta objpos+7
                lda objpos+3
                sta objpos+9
                lda objpos+5
                sta objpos+11
               
                
                lda #1
                sta $d02a
                sta $d02b
                sta $d02c
               
                 
                
                ;Check range again
                
                lda objpos+1
                cmp #$ac
                bcc issmalldeadsnake
                bcs islargedeadsnake
issmalldeadsnake
                lda smalldeadsnakehead
                ldx smalldeadsnakebody
                ldy #$af
                sta $07fb
                stx $07fc
                sty $07fd
                jmp continuedeath
                
islargedeadsnake
                lda largedeadsnakehead
                ldx largedeadsnakebody
                ldy #$af
                sta $07fb
                stx $07fc
                sty $07fd
continuedeath               
                
explosionloop   jsr synctimer
                jsr expandmsb
                jsr animexplosion
                jsr animexplodecol
                
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
                cpx #explosionframeend-explosionframe
                beq morphtodeadsnake
                inc explodeanimpointer
                rts
                
animexplodecol  lda expcoldelay
                cmp #1
                beq expscene
                inc expcoldelay
                rts
expscene        lda #0
                sta expcoldelay
                
                ldx expcoltimer
                lda expcoltable,x
                sta $d021
                inx
                cpx #12
                beq setasblack
                inc expcoltimer
                rts
setasblack      ldx #11
                stx expcoltimer
                rts
                
;Explosion has finished, morph explosion sprites to dead snake                

morphtodeadsnake  jsr clearspritepos
                ldx #0
                stx explodeanimpointer
                
                lda #gameovermusic
                jsr musicinit
               
                ldx #0
makegameoverspr lda gameoverspritetable,x
                sta $07fa,x
                lda #$05
                sta $d029,x
                inx
                cpx #6
                bne makegameoverspr
                lda #0
                sta objpos+1
                sta objpos+3
                sta objpos+5
                
;-------------------------------------------        
                
;Place game over sprites
                
                ldx #$00
readgopos       lda gameoverpos,x
                sta objpos+4,x
                inx
                cpx #$0c
                bne readgopos
               
;-------------------------------------------        
                
;Game over loop
                
                jsr maskscorepanel
                
                lda #0
                sta firebutton
                lda #$ff
                sta $d015
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
                
                jmp checkhiscore
                
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
                   
clearspritepos
                lda #0
                sta $d015
                ldy #$00
zop             lda #$00
                sta $d000,y
                iny
                cpy #$10
                bne zop
                rts
                
;-------------------------------------------        

; Kill off all IRQ interrupts that are currently playing also
; make a short delay, in order to prevent sensitive fire
;button pressing

;-------------------------------------------        

killirqs        lda #$35
                sta $01
                sei
                
               
               
                
                lda #$00
                sta $d019
                sta $d01a
                
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
                
               ;  lda #$00
               ; sta $d011
                sta $d015
                sta $d01b
                 
                 ldx #$00
clearscreent    lda #$00
                sta $0400,x
                sta $0500,x
                sta $0600,x
                sta $06e8,x
                sta $d800,x
                sta $d900,x
                sta $da00,x
                sta $dae8,x
                inx
                bne clearscreent
                
                
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
                rts
               
;-------------------------------------------                         

;Load in game pointers source.
                !source "pointers.asm"
                    
          