;SNAKE VS BOMB 2 
;TITLE SCREEN CODE

;-------------------------------------------        

;Kill off all IRQS, sprites, etc.

titlescreen     jsr killirqs

;-------------------------------------------        

;Reset the scrolling message, and also 
;setup the hardware settings on the 
;title screen

                ;Initialise scroll text
                lda #<scrolltext
                sta messread+1
                lda #>scrolltext
                sta messread+2

                ;VIC2 default settings before
                ;running interrupts
               
                lda #0      
                sta $d020   
                sta $d021   
                sta $d011   
                lda #$02      
                sta $d022   
                lda #$07
                sta $d023
                lda #$1e
                sta $d018
                lda #$18
                sta $d016
                
;Fetch colour RAM data and copy to screen video RAM

                ldx #$00
logocol         lda logocolram,x
                sta $d800,x
                lda logocolram+$100,x
                sta $d900,x
                inx
                bne logocol
                
                ldx #$00
defaultcolour   lda #$0d
                sta colour+(11*40),x
                sta colour+$200,x
                sta colour+$2e8,x
                inx
                bne defaultcolour

                jsr displaycredits
                lda #1
                sta pageno
                lda #0
                sta pagedelay
                sta pagedelay+1
                sta tdelay 
;-------------------------------------------        
                
;Prepare title screen IRQ raster interrupts

                ldx #<tirq1
                ldy #>tirq1
                lda #$7f
                stx $fffe
                sty $ffff
                sta $dc0d
                sta $dd0d
                
                lda #$02
                sta $d012
                lda #$1b
                sta $d011
                lda #$01
                sta $d019
                sta $d01a
                lda #titlemusic
                jsr musicinit
                cli
                
;IRQ has been setup, jump to the title 
;screen code loop.
                
                jmp titleloop
                
;-------------------------------------------        
                
;IRQ raster interrupts (Split into 3 parts, scroller, logo, screen)

;Raster 1 - X Scroller                 

tirq1           sta tstacka+1
                stx tstackx+1
                sty tstacky+1
                asl $d019
                lda $dc0d
                sta $dd0d
                lda #$22
                sta $d012
                lda #$1b
                sta $d011
                lda xpos
                ora #$10
                sta $d016
                
                ldy #$1e
                sty $d018
                lda #$03
                sta $dd00
                ldx #<tirq2
                ldy #>tirq2
                stx $fffe
                sty $ffff
tstacka        lda #$00
tstackx        ldx #$00
tstacky        ldy #$00                
                rti
                
;Raster 2 - Logo bitmap                

tirq2           sta tstack2a+1
                stx tstack2x+1
                sty tstack2y+1
                asl $d019
                lda #$82
                sta $d012
                
                lda #$3b
                ldx #$18
                ldy #$18
                sta $d011
                stx $d016
                sty $d018
                lda #$00
                sta $dd00
                ldx #<tirq3
                ldy #>tirq3
                stx $fffe
                sty $ffff
tstack2a        lda #$00
tstack2x        ldx #$00
tstack2y        ldy #$00
                rti

;Raster 3 - Still text 

tirq3           sta tstack3a+1
                stx tstack3x+1
                sty tstack3y+1
                asl $d019
                lda #$e8
                sta $d012
                lda #$03
                ldx #$1b
                ldy #$18
                sta $dd00
                stx $d011
                sty $d016
                lda #$1e
                ldx #$01
                sta $d018
                stx rt
                jsr musicplayer
                
                ldx #<tirq1
                ldy #>tirq1
                stx $fffe
                sty $ffff
tstack3a        lda #$00
tstack3x        ldx #$00
tstack3y        ldy #$00                
                rti

;-------------------------------------------        

;Main title screen loop                
                
titleloop       jsr synctimer
                jsr scroller
                jsr titleanimbombs
                jsr pageflipper
                lda $dc00
                lsr
                lsr
                lsr
                lsr
                lsr
                bit firebutton
                ror firebutton
                bmi titleloop
                bvc titleloop
                lda #$00
                sta $d011
                jmp gamestart

;-------------------------------------------        

;1x2 scrolling message routine. Controls
;the $D016 value to make scrolling smooth
;after hardware value placed inside IRQ.

scroller        lda xpos 
                sec
                sbc #2 ;Speed of scroll
                and #7
                sta xpos
                bcs exitscroll
                
;Shift both layers of scroll text 39 columns 
                
                ldx #$00
scrloop         lda screen+(23*40)+1,x
                sta screen+(23*40),x
                lda screen+(24*40)+1,x
                sta screen+(24*40),x
                lda #$0d
                sta colour+(23*40),x
                sta colour+(24*40),x
                inx
                cpx #$28
                bne scrloop
                
;Read scroll text and if @ is found (byte 0)
;then reset the scroll. Otherwise store the
;current character read from "scrolltext"
;and position to last column of each row on screen
                
messread        lda scrolltext
                cmp #$00
                bne storet
                lda #<scrolltext
                sta messread+1
                lda #>scrolltext
                sta messread+2
                jmp messread
                
;Store scroll text and convert to the 1x2 font
;segment read from the charset memory. 
                
storet          clc
                adc #$80
                sta screen+(23*40)+39
                adc #$40
                sta screen+(24*40)+39
                
                inc messread+1
                lda messread+1
                
                bne exitscroll
                inc messread+2
exitscroll      rts                
;-------------------------------------------        

;Display credits screen (read from creditstext)

displaycredits  ldx #$00
copycredits     lda creditstext,x
                sta screen+(11*40),x
                lda creditstext+(1*40),x
                sta screen+(12*40),x
                lda creditstext+(2*40),x
                sta screen+(13*40),x
                lda creditstext+(3*40),x
                sta screen+(14*40),x
                lda creditstext+(4*40),x
                sta screen+(15*40),x
                lda creditstext+(5*40),x
                sta screen+(16*40),x
                lda creditstext+(6*40),x
                sta screen+(17*40),x
                lda creditstext+(7*40),x
                sta screen+(18*40),x
                lda creditstext+(8*40),x
                sta screen+(19*40),x
                lda creditstext+(9*40),x
                sta screen+(20*40),x
                lda creditstext+(10*40),x
                sta screen+(21*40),x
                inx
                cpx #$28
                bne copycredits
                rts

;-------------------------------------------        
                
;Display hi score table                
                
displayhiscores
                ldx #$00
hidisplay       lda hiscoretable,x
                sta screen+(11*40),x
                lda hiscoretable+(1*40),x
                sta screen+(12*40),x
                lda hiscoretable+(2*40),x
                sta screen+(13*40),x
                lda hiscoretable+(3*40),x
                sta screen+(14*40),x
                lda hiscoretable+(4*40),x
                sta screen+(15*40),x
                lda hiscoretable+(5*40),x
                sta screen+(16*40),x
                lda hiscoretable+(6*40),x
                sta screen+(17*40),x
                lda hiscoretable+(7*40),x
                sta screen+(18*40),x
                lda hiscoretable+(8*40),x
                sta screen+(19*40),x
                lda hiscoretable+(9*40),x
                sta screen+(20*40),x
                lda hiscoretable+(10*40),x
                sta screen+(21*40),x
                inx
                cpx #$28
                bne hidisplay
                rts

;-------------------------------------------        
                
;Display objects list

displayobjects
                ldx #$00
objdisplay      lda scoringlist,x
                sta screen+(11*40),x
                lda scoringlist+(1*40),x
                sta screen+(12*40),x
                lda scoringlist+(2*40),x
                sta screen+(13*40),x
                lda scoringlist+(3*40),x
                sta screen+(14*40),x
                lda scoringlist+(4*40),x
                sta screen+(15*40),x
                lda scoringlist+(5*40),x
                sta screen+(16*40),x
                lda scoringlist+(6*40),x
                sta screen+(17*40),x
                lda scoringlist+(7*40),x
                sta screen+(18*40),x
                lda scoringlist+(8*40),x
                sta screen+(19*40),x
                lda scoringlist+(9*40),x
                sta screen+(20*40),x
                lda scoringlist+(10*40),x
                sta screen+(21*40),x
                inx
                cpx #$28
                bne objdisplay
                rts

;-------------------------------------------        
                
;Animate title screen bomb charset

titleanimbombs
               lda tdelay
               cmp #3
               beq dobombanimt
               inc tdelay
               rts
dobombanimt    lda #0
               sta tdelay
               ldx #$00
tanimstep1     lda animbombsrct,x
               sta animbombsrct+(7*8),x
               inx
               cpx #$08
               bne tanimstep1
               ldx #$00
tanimstep2     lda animbombsrct+8,x
               sta animbombsrct,x
               inx 
               cpx #$38
               bne tanimstep2
               ldx #$00
tanimstep3     lda animbombsrct,x
               sta titlecharset+(81*8),x
               inx
               cpx #$08
               bne tanimstep3
               rts

;-------------------------------------------        

;Page flipper

pageflipper    inc pagedelay
               lda pagedelay
               beq nextbyte
               rts
nextbyte       lda #0
               sta pagedelay
               inc pagedelay+1
               lda pagedelay+1
               cmp #2
               beq nextpage
               rts
nextpage       lda #0
               sta pagedelay+1
               lda pageno
               cmp #1
               beq setuphiscores
               cmp #2
               beq setupobjects
               jsr displaycredits
               lda #1
               sta pageno
               rts
setuphiscores  jsr displayhiscores
               lda #2
               sta pageno
               rts
setupobjects   jsr displayobjects
               lda #0
               sta pageno
               rts

;-------------------------------------------        
               
;Title screen pointers

xpos !byte 0                
tdelay !byte 0   
pagedelay !byte 0,0
pageno !byte 0             
