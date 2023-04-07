
;HI SCORE DETECTION

;Low and high byte table values which represent hi score and name list

hslo  !byte <hiscore1,<hiscore2,<hiscore3,<hiscore4,<hiscore5
      !byte <hiscore6,<hiscore7,<hiscore8,<hiscore9,<hiscore10
hshi  !byte >hiscore1,>hiscore2,>hiscore3,>hiscore4,>hiscore5
      !byte >hiscore6,>hiscore7,>hiscore8,>hiscore9,>hiscore10
      
nmlo  !byte <name1,<name2,<name3,<name4,<name5
      !byte <name6,<name7,<name8,<name9,<name10
nmhi  !byte >name1,>name2,>name3,>name4,>name5
      !byte >name6,>name7,>name8,>name9,>name10
      
name  !byte $20,$20,$20,$20,$20,$20,$20,$20,$20
nameend
!ct scr
cheatcode
      !text "adderbomb"
cheattext !text "cheat mode active ...   "
cheattextend
!align $ff,$00

checkhiscore    jsr killirqs ;Switch off all IRQs 
                lda #$02
                sta $d022
                lda #$07
                sta $d023
                lda #0
                sta $02 ;Init zeropage always!
                
                ;Init starting character 
                lda #1
                sta letterchar
                
                ;Name should not be finished
                ;also init firebutton press
                lda #0
                sta namefinished
                sta firebutton

;Setup hi score table directives
;and place them into zeropages

                ldx #$00
nextone
                lda hslo,x
                sta $c1
                lda hshi,x
                sta $c2

                ldy #$00
scoreget       lda score,y
scorecmp       cmp ($c1),y
                bcc posdown
                beq nextdigit
                bcs posfound
nextdigit     
                iny
                cpy #scorelen
                bne scoreget
                beq posfound
posdown        
                inx
                cpx #listlen
                bne nextone
                beq nohiscore
posfound
                stx $02
                cpx #listlen-1
                beq lastscore

                ldx #listlen-1
copynext       
                lda hslo,x
                sta $c1
                lda hshi,x
                sta $c2
                lda nmlo,x
                sta $ac
                lda nmhi,x
                sta $ad
                dex
                lda hslo,x
                sta $c3
                lda hshi,x
                sta $c4
                lda nmlo,x
                sta $ae
                lda nmhi,x
                sta $af

                ldy #scorelen-1
copyscore
                lda ($c3),y
                sta ($c1),y
                dey
                bpl copyscore

                ldy #namelen-1
copyname
                lda ($ae),y
                sta ($ac),y
                dey
                bpl copyname
                cpx $02
                bne copynext


lastscore      ldx $02
                lda hslo,x
                sta $c1
                lda hshi,x
                sta $c2
                lda nmlo,x
                sta $ac
                lda nmhi,x
                sta $ad
                jmp nameentry
placenewscore  
                ldy #scorelen-1
putscore
                lda score,y
                sta ($c1),y
                dey
                bpl putscore

                ldy #namelen-1
putname        lda name,y
                sta ($ac),y
                dey
                bpl putname
                
                jsr testforcheat
                
                jsr savehiscores
nohiscore:
                jmp titlescreen
                

                ;Test for cheat mode (invincibility)
testforcheat                
                ldx #$00
checkcheat      lda name,x
                cmp cheatcode,x
                bne nocheatfound
                inx
                cpx #$09
                bne checkcheat
                ldx #$00
setcheattoscroll
                lda cheattext,x
                sta scrolltext,x
                inx
                cpx #cheattextend-cheattext
                bne setcheattoscroll
                
                lda #1
                sta cheatmodeon
                 
nocheatfound    rts                                  
            
nameentry
                ldx #$00
drawhiscreen    lda namescreen,x
                sta screen,x
                lda namescreen+$100,x
                sta screen+$100,x
                lda namescreen+$200,x
                sta screen+$200,x
                lda namescreen+$2e8,x
                sta screen+$2e8,x
                lda #$0d
                sta colour,x
                sta colour+$100,x
                sta colour+$200,x
                sta colour+$2e8,x
                inx
                bne drawhiscreen
                
                lda #$1e
                sta $d018
                lda #$18
                sta $d016
                
                ;Clear player's name
                
                ldx #$00
clearname       lda #$20
                sta name,x
                inx
                cpx #$09
                bne clearname
                
                ;Reset position of name
                
                lda #<name 
                sta namesm+1
                lda #>name
                sta namesm+2
                
;Setup as single IRQ raster interrupt player 

                ldx #<hiirq
                ldy #>hiirq
                lda #$7f
                stx $fffe
                sty $ffff
                sta $dc0d
                sta $dd0d
                lda $dc0d
                lda $dd0d
                lda #$2e
                sta $d012
                lda #$1b
                sta $d011
                lda #$01
                sta $d019
                sta $d01a
                
                ;Initialize music for hi score
                
                lda #hiscoremusic
                jsr musicinit
                cli
                
;Name entry loop 

nameentryloop                
                jsr synctimer
                jsr titleanimbombs
                
                ;Display name which is being entered
                
                ldx #$00
showname        lda name,x 
                sta namescreenpos,x
                lda #$0b
                sta $db07,x
                inx
                cpx #9
                bne showname
                
                ;Check if name input is finished
                
                lda namefinished
                bne stopnameentry
                jsr joycheck
                jmp nameentryloop
stopnameentry   
                jmp placenewscore
                
;Joystick control name check routine

joycheck        lda letterchar
namesm          sta name 
                lda joydelay 
                cmp #6
                beq joyhiok
                inc joydelay
                rts
joyhiok         lda #0
                sta joydelay
                
                ;Check joystick direction up
                
hiup            lda #1
                bit $dc00
                beq lettergoesdown
                jmp hidown
lettergoesdown  jmp letterdown

hidown          lda #2
                bit $dc00
                beq lettergoesup
                jmp hifire
lettergoesup    jmp letterup

hifire          lda $dc00
                lsr
                lsr
                lsr
                lsr
                lsr
                bit firebutton
                ror firebutton
                bmi nohijoy
                bvc nohijoy
                jmp select
nohijoy         rts

                ;Letter increments next char
                
letterup        inc letterchar
                lda letterchar
                cmp #27
                beq makeupendchar
                cmp #33
                beq achar
                rts
makeupendchar   lda #30
                sta letterchar
                rts
autospace       lda #32
                sta letterchar
                rts
achar           lda #1
                sta letterchar
                rts
                
                ;Letter goes down
letterdown      dec letterchar
                lda letterchar
                beq spacechar
                lda letterchar
                cmp #29
                beq zchar
                rts
spacechar       lda #32
                sta letterchar
                rts
zchar           lda #26
                sta letterchar
                rts
                
;Char selected, check for end / delete 
;characters. Else move to next char 
;position.

select          lda #0
                sta firebutton
                lda letterchar
checkdeletechar
                cmp #31
                bne checkendchar
                lda namesm+1
                cmp #<name 
                beq donotgoback
                dec namesm+1
                jsr housekeep
donotgoback     rts

checkendchar    cmp #30
                bne charisok
                lda #32
                sta letterchar
                jmp finishednow
                
charisok        inc namesm+1
                lda namesm+1
                cmp #<name+9
                beq finishednow
hinofire        rts
finishednow     jsr housekeep
                lda #1
                sta namefinished
                rts
                
                ;Name housekeeping routine
housekeep       ldx #$00
clearcharsn     lda name,x
                cmp #30
                beq cleanup
                cmp #31
                beq cleanup
                jmp skipcleanup
cleanup         lda #$20
                sta name,x
skipcleanup     inx
                cpx #9
                bne clearcharsn
                rts
                
;IRQ raster interrupt for hi score entry

hiirq           sta hstacka+1
                stx hstackx+1
                sty hstacky+1
                asl $d019
                lda $dc0d
                sta $dd0d
                lda #$f8
                sta $d012
                lda #1
                sta rt 
                jsr musicplayer
hstacka         lda #$00
hstackx         ldx #$00
hstacky         ldy #$00                
                rti
                
;Hi score pointers

joydelay !byte 0
letterchar !byte 1
namefinished !byte 0                
                

                