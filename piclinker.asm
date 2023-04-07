;Snake vs Bomb 2 intro pic linker

  !to "piclinker.prg",cbm
  
  *=$0801
  !basic 2061
  *=$080d
  sei
  lda #251
  sta $0328
          ;PAL NTSC check routine
checksystem    
        lda $d012
        cmp $d012
        beq *-3
        bmi checksystem
        cmp #$20
        bcc ntsc 
        lda #1
        sta system
       ;lda #$12
       ;sta rline+1
        jmp startmaincode 
ntsc    lda #0
        sta system 
startmaincode        
  lda #8
  jsr $ffd2
  lda #$00
  sta $d020
  lda #$00
  sta $d021
  lda $02a6
  sta system
  ldx #$00
copygfx
  lda $3f40,x
  sta $0400,x
  lda $3f40+$100,x
  sta $0500,x
  lda $3f40+$200,x
  sta $0600,x
  lda $3f40+$2e8,x
  sta $06e8,x
  lda $4328,x
  sta $d800,x
  lda $4328+$100,x
  sta $d900,x
  lda $4328+$200,x
  sta $da00,x
  lda $4328+$2e8,x
  sta $dae8,x
  inx
  bne copygfx
  
  
  lda #$3b
  sta $d011
  lda #$18
  sta $d016
  sta $d018
  lda #$03
  sta $dd00
  
  ldx #<irq
  ldy #>irq
  stx $0314
  sty $0315
  lda #$7f
  sta $dc0d
  sta $dd0d
  lda $dc0d
  lda $dd0d
  lda #$32
  sta $d012
  lda #$01
  sta $d019
  sta $d01a
  lda #$00
  jsr $1000
  cli
  
displayloop
  lda $dc00
  lsr
  lsr
  lsr
  lsr
  lsr
  bcs displayloop2
  jmp exitdisplayer
  
displayloop2
  lda $dc01
  lsr
  lsr
  lsr
  lsr
  lsr
  bcs displayloop
  
exitdisplayer

  sei
  ldx #$31
  ldy #$ea
  stx $0314
  sty $0315
  lda #$00
  sta $d019
  sta $d01a
  sta $d020
  sta $d021
  lda #$81
  sta $dc0d
  sta $dd0d
  
  ldx #$00
clearall
  lda #$00
  sta $d800,x
  sta $d900,x
  sta $da00,x
  sta $dae8,x
  lda #$00
  sta $0500,x
  sta $0600,x
  sta $06e8,x
  lda transfer,x
  sta $0400,x
  inx
  bne clearall
  
  ldx #$00
quietmode
  lda #$00
  sta $d400,x
  inx
  cpx #$18
  bne quietmode
  
  lda #$1b
  sta $d011
  lda #$08
  sta $d016
  lda #$14
  sta $d018
  cli
  jmp $0400

transfer
  sei
  lda #$34
  sta $01
tloop1  
  ldx #$00
tloop2
  lda $4800,x
  sta $0801,x
  inx
  bne tloop2
  inc $0409
  inc $040c
  lda $0409
  bne tloop1
  lda #$37
  sta $01
  cli
  jmp $080d
  
  
    
  
  
  
  
irq
  inc $d019
  lda #$fa
  sta $d012
  jsr musicplayer 
  jmp $ea7e
  
musicplayer
  lda system
  cmp #1
  beq pal 
  inc ntsctimer
  lda ntsctimer
  cmp #6
  bne exitntsc
pal
  jsr $1003
  rts
exitntsc
  lda #0
  sta ntsctimer
  rts
  
system !byte 0
ntsctimer !byte 0
  
  *=$1000
  !bin "c64/loadertune.prg",,2
  
  *=$2000
  !bin "c64/snakevsbomb2loaderpic.prg",,2
  
  *=$4800
  !bin "snakevsbomb2.prg",,2
  
  