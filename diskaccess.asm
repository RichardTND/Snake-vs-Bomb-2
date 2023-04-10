
dname:  !text "S:"
fname:  !text "-HALL OF FAME!-"
fnamelen = *-fname
dnamelen = *-dname

savehiscores
SaveHiScore:
      jsr copyhiscoredatatolowmem
      jsr DisableInts 
     lda cheatmodeon
                cmp #1
                beq nohiscore1
      jsr savefile
    
nohiscore1
      rts
      
loadhiscores   
      lda #0
      sta $d020
      sta $d021
      sta $d011
     
     
     ; jsr DisableInts 
 
      jsr loadfile
      
      rts
DisableInts:
      sei 
      
     
      lda #$31
      sta $0314
      lda #$ea
      sta $0315
      lda #0
      sta $d019 
      sta $d01a 
      sta $d015 
      lda #$81 
      sta $dc0d
      sta $dd0d
      ldx #$00 
clrsid:   lda #0 
      sta $d400,x
      inx
      cpx #$18 
      bne clrsid 
      lda #$0b 
      sta $d011 
      
      cli 
      jsr copyhiscoredatatolowmem
      lda #0
      sta $d020
      sta $d021
       lda #$36 
      sta $01 
      rts 
      
savefile
      ldx $ba
      cpx #$08 
      bcc skipsave 
      lda #$0f 
      tay
      jsr $ffba
      jsr resetdevice
      lda #dnamelen 
      ldx #<dname 
      ldy #>dname 
      jsr $ffbd 
      jsr $ffc0
      lda #$0f 
      jsr $ffc3 
      jsr $ffcc
      
      lda #$0f 
      ldx $ba 
      tay
      jsr $ffba 
      jsr resetdevice
      lda #fnamelen 
      ldx #<fname 
      ldy #>fname 
      jsr $ffbd 
      lda #$fb 
      ldx #<hiscoresavestart
      ldy #>hiscoresavestart
      stx $fb 
      sty $fc 
      ldx #<hiscoresaveend
      ldy #>hiscoresaveend
      jsr $ffd8
skipsave
      rts
      
loadfile
      lda #$36
      sta $01
      ldx $ba 
      cpx #$08 
      bcc skipload 
      
      lda #$0f 
      tay 
      jsr $ffba 
      jsr resetdevice 
      lda #fnamelen 
      ldx #<fname 
      ldy #>fname
      jsr $ffbd
     
      lda #$00 
      jsr $ffd5 
      bcc skipload
      jsr copyhiscoredatatolowmem
      jsr savefile
    
      
skipload
        ldx #$00
copytablelen
      lda $16c9,x
      sta $a6c9,x
      inx
      cpx #$c6
      bne copytablelen
      rts

resetdevice
      lda #$01 
      ldx #<initdrive
      ldy #>initdrive
      jsr $ffbd 
      jsr $ffc0 
      lda #$0f 
      jsr $ffc3 
      jsr $ffcc
      rts
      
copyhiscoredatatolowmem
      ldx #$00
fetchtable
      lda $a6c9,x
      sta $16c9,x
      inx
      cpx #$c6
      bne fetchtable
      rts
initdrive
      !text "I:"

      rts