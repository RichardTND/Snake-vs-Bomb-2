;End screen

endscreen         jsr killirqs

;Draw end screen scene

                  ldx #$00
drawend           lda endscreentext,x
                  sta $0400,x
                  lda endscreentext+$100,x
                  sta $0500,x
                  lda endscreentext+$200,x
                  sta $0600,x
                  lda endscreentext+$2e8,x
                  sta $06e8,x
                  lda #$0d
                  sta $d800,x
                  sta $d900,x
                  sta $da00,x
                  sta $dae8,x
                  inx
                  bne drawend
                  
                  lda #$18
                  sta $d016
                  lda #$1e
                  sta $d018
                  lda #$02
                  sta $d022
                  lda #$07
                  sta $d023
                  
                  ldx #<singleirq
                  ldy #>singleirq
                  lda #$7f
                  stx $fffe
                  sty $ffff
                  sta $dc0d
                  sta $dd0d
                  lda #$22
                  sta $d012
                  lda #$1b
                  sta $d011
                  lda #$01
                  sta $d019
                  sta $d01a
                  lda #gamecompletemusic
                  jsr musicinit
                  lda #0
                  sta firebutton
                  cli
endloop           lda $dc00
                  lsr
                  lsr
                  lsr
                  lsr
                  lsr
                  bit firebutton
                  ror firebutton
                  bmi endloop
                  bvc endloop
                  jmp gamestart
singleirq         sta stacka+1                  
                  stx stackx+1
                  sty stacky+1
                  asl $d019
                  lda $dc0d
                  sta $dd0d
                  lda #$fa
                  sta $d012
                  lda #1
                  sta rt
                  jsr musicplay
stacka            lda #0
stackx            ldx #0
stacky            ldy #0
                  rti
                  