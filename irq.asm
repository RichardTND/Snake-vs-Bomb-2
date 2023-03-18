
;IRQ INTERRUPTS

;IRQ 1 - outer raster 

gameirq1        sta gstacka1+1
                stx gstackx1+1
                sty gstacky1+1
                asl $d019
                lda $dc0d
                sta $dd0d
                lda #split1
                sta $d012
               
                lda #$1c
                sta $d018
                lda #$02
                sta $d022
                lda #$07
                sta $d023
                
!ifdef testirqborder {                
                lda #1
                sta $d020
} else {
  nop
  nop
  nop
  nop
  nop
}  
            
               
                ldx #<gameirq2
                ldy #>gameirq2
                stx $fffe
                sty $ffff
gstacka1        lda #$00
gstackx1        ldx #$00
gstacky1        ldy #$00                
                rti
                
;IRQ 2 - Score panel raster

gameirq2        sta gstacka2+1
                stx gstackx2+1
                sty gstacky2+1
                asl $d019
                
                lda #split2
                sta $d012
               
                lda #$10
                sta $d016
                
                lda #$1e
                sta $d018
!ifdef testirqborder {                
                lda #2
                sta $d020
} else {
  nop
  nop
  nop
  nop
  nop
}  

                lda #$09
                sta $d022
                lda #$01
                sta $d023
                
                ldx #<gameirq3
                ldy #>gameirq3
                stx $fffe
                sty $ffff
gstacka2        lda #$00
gstackx2        ldx #$00
gstacky2        ldy #$00                
                rti
                
;IRQ 3 - Mountains

gameirq3        sta gstacka3+1
                stx gstackx3+1
                sty gstacky3+1
                asl $d019
                lda #split3
                sta $d012
              
                nop
                nop
                nop
                nop
                nop
                lda d016table
                ora #$10
                sta $d016
                nop
                nop
                nop
                nop
                nop
                lda #$12
                sta $d018
!ifdef testirqborder {                
                lda #3
                sta $d020
} else {
  nop
  nop
  nop
  nop
  nop
}  

                lda #$07
                sta $d022
                lda #$0a
                sta $d023
                ldx #<gameirq4
                ldy #>gameirq4
                stx $fffe
                sty $ffff
gstacka3        lda #$00
gstackx3        ldx #$00
gstacky3        ldy #$00
                rti
                
;IRQ 4 - Parralax 1 - The rocks (top)

gameirq4        sta gstacka4+1
                stx gstackx4+1
                sty gstacky4+1
                asl $d019
                lda #split4
                sta $d012
rline           ldx #$04
                dex
                bne *-1
                lda d016table+1
                ora #$10
                sta $d016
               
                lda #$1c
                sta $d018
!ifdef testirqborder {                
                lda #4
                sta $d020
} else {
  nop
  nop
  nop
  nop
  nop
}  
                lda #$02
                sta $d022
                lda #$07
                sta $d023
                ldx #<gameirq5
                ldy #>gameirq5
                stx $fffe
                sty $ffff
gstacka4        lda #$00
gstackx4        ldx #$00
gstacky4        ldy #$00
                rti
                
;IRQ5 - Parallax 2 - The plants (top)

gameirq5        sta gstacka5+1
                stx gstackx5+1
                sty gstacky5+1
                asl $d019
                lda #split5
                sta $d012
                nop
                nop
                nop
                nop
                nop
                nop
                lda d016table+2
                ora #$10
                sta $d016
                
!ifdef testirqborder {                
                lda #5
                sta $d020
} else {
  nop
  nop
  nop
  nop
  nop
}  

                lda #$02
                sta $d022
                lda #$07
                sta $d023
                ldx #<gameirq6
                ldy #>gameirq6
                stx $fffe
                sty $ffff
gstacka5        lda #$00
gstackx5        ldx #$00
gstacky5        ldy #$00
                rti
                
;IRQ6 - Main scroll game field

gameirq6        sta gstacka6+1
                stx gstackx6+1
                sty gstacky6+1
                asl $d019
                lda #split6
                sta $d012
                nop
                nop
                nop
                nop
                nop
                nop
                lda d016table+3
                ora #$10
                sta $d016
              
!ifdef testirqborder {                
                lda #6
                sta $d020
} else {
  nop
  nop
  nop
  nop
  nop
}  
                
                ldx #<gameirq7
                ldy #>gameirq7
                stx $fffe
                sty $ffff
gstacka6        lda #$00
gstackx6        ldx #$00
gstacky6        ldy #$00
nmi             rti
                
;IRQ7 - Parallax scrolling - the plants (bottom)

gameirq7     
                sta gstacka7+1
                stx gstackx7+1
                sty gstacky7+1
                asl $d019
                lda #split7
                sta $d012
                
                nop
                nop
                nop
                nop
                nop
                nop
                lda d016table+4
                ora #$10
                sta $d016
 
                 
!ifdef testirqborder {                
                lda #7
                sta $d020
} else {
  nop
  nop
  nop
  nop
  nop
}  
                ldx #<gameirq8
                ldy #>gameirq8
                stx $fffe
                sty $ffff
               
gstacka7        lda #$00
gstackx7        ldx #$00
gstacky7        ldy #$00
                rti
                ;IRQ7 - Parallax scrolling - the plants (bottom)

gameirq8     
                sta gstacka8+1
                stx gstackx8+1
                sty gstacky8+1
                asl $d019
                lda #split8
                sta $d012
                nop
                nop
                nop
                nop
                nop
                nop
                lda d016table+5
                ora #$10
                sta $d016
               
!ifdef testirqborder {                
                lda #8
                sta $d020
} else {
  nop
  nop
  nop
  nop
  nop
}  
                lda #1
                sta rt
                jsr musicplayer
                ldx #<gameirq1
                ldy #>gameirq1
                stx $fffe
                sty $ffff
               
                 
               
 
gstacka8        lda #$00
gstackx8        ldx #$00
gstacky8        ldy #$00
                rti
                