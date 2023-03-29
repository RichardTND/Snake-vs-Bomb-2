;DISK ACCESS
!ct scr
dname !text "S:" ;Scratch/overwrite filename
fname !text "-HALL OF FAME-"
fnamelen = *-fname
dnamelen = *-dname

;Call subroutine for saving hi scores

savehiscores
        jsr killirqs
        jsr savefile
skiphiscoresaver
        rts
        
;Loading hi scores        

loadhiscores
        lda #0
        sta $d020
        sta $d021
        lda #$0b
        sta $d011
        jsr loadfile
skiphiscoreloader
        rts
        
;Saving hi scores main routine        

savefile
        lda #$0b
        sta $d011
        
        ;Check last device
        
        ldx device
        cmp #$08
        bcc skipsave ;No Drive or found tape drive
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
        ldx device
        tay
        jsr $ffba
        jsr resetdevice
        
        lda #fnamelen
        ldx #<fname
        ldy #>fname
        jsr $ffbd
        lda #$fb
        ldx #<hiscorestart
        ldy #>hiscorestart
        stx $fb
        sty $fc
        ldx #<hiscoreend
        ldy #>hiscoreend
        jsr $ffd8
skipsave
        rts
        
;Load file from disk

loadfile  
        ldx device
        cpx #$08
        bcc skipload
        
        lda #$0f
        tay
        jsr $ffba
        jsr resetdevice
        
        lda #fnamelen
        ldx  #<fname
        ldy #>fname
        jsr $ffbd
        lda #$00
        jsr $ffd5
        bcc loaded
        jsr savefile
loaded
skipload
        rts
        
;Initialize disk drive

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
!ct scr        
initdrive        
        !text "I:"
device  !byte 8        