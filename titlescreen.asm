 
;TITLE SCREEN CODE

;Kill off all IRQS, sprites, etc.

titlescreen     jsr killirqs

;Setup graphics colour mode
                
                ;Initialise scroll text
                ldx #$00
clearscreent    lda #$20
                sta $0400,x
                sta $0500,x
                sta $0600,x
                sta $06e8,x
                inx
                bne clearscreent
                
                lda #<scrolltext
                sta messread+1
                lda #>scrolltext
                sta messread+2
                
                lda #0
                sta $d020
                sta $d021
                lda #$02
                sta $d022
                lda #$07
                sta $d023
                
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
                
;Setup IRQ raster interrupts

                ldx #<tirq1
                ldy #>tirq1
                lda #$7f
                stx $0314
                sty $0315
                sta $dc0d
                sta $dd0d
                lda $dc0d
                lda $dd0d
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
                jmp titleloop
                
;IRQ raster interrupts (Split into 3 parts, scroller, logo, screen)

;Raster 1 - X Scroller                 

tirq1           asl $d019
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
                stx $0314
                sty $0315
                jmp $ea7e
                
;Raster 2 - Logo bitmap                

tirq2           asl $d019
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
                stx $0314
                sty $0315
tstacka2        jmp $ea7e

;Raster 3 - Still text 

tirq3           asl $d019
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
                stx $0314
                sty $0315
                jmp $ea7e

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
                jmp gamestart
                
;Message scroller

scroller        lda xpos
                sec
                sbc #2
                and #7
                sta xpos
                bcs exitscroll
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
                
messread        lda scrolltext
                cmp #$00
                bne storet
                lda #<scrolltext
                sta messread+1
                lda #>scrolltext
                sta messread+2
                jmp messread
                
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

                
;Display credits

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
               
                
xpos !byte 0                
tdelay !byte 0   
pagedelay !byte 0,0
pageno !byte 0             
