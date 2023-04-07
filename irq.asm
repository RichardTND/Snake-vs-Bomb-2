
;IRQ INTERRUPTS

;IRQ 1 - outer raster 

gameirq1        sta gstack1a+1
                stx gstack1x+1
                sty gstack1y+1
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
                lda #0
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
             ;   jsr musicplayer
               
                ldx #<gameirq2
                ldy #>gameirq2
                stx $fffe
                sty $ffff
gstack1a        lda #$00
gstack1x        ldx #$00
gstack1y        ldy #$00
nmi             rti
                
;IRQ 2 - Score panel raster

gameirq2        sta gstack2a+1
                stx gstack2x+1
                sty gstack2y+1
                asl $d019
              
                lda #split2
                sta $d012
                
                ;Time things out a little under the score panel
            
             
                
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
gstack2a        lda #$00
gstack2x        ldx #$00
gstack2y        ldy #$00
                rti
                
                
;IRQ 3 - Mountains

gameirq3        sta gstack3a+1
                stx gstack3x+1
                sty gstack3y+1
                asl $d019
                lda #split3
                sta $d012
              nop
              nop
              nop
                ;Time things out a little
               lda d016table
               ora #$10
               sta $d016
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
gstack3a        lda #$00
gstack3x        ldx #$00
gstack3y        ldy #$00
                rti
                
;IRQ 4 - Parralax 1 - The rocks (top)

gameirq4       sta gstack4a+1
               stx gstack4x+1
               sty gstack4y+1
               asl $d019
                lda #split4
                sta $d012
                nop
                nop
                nop
                nop
                nop
                nop
                nop
                nop
                lda #$07
                sta $d023
                 
             
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
               
                ldx #<gameirq5
                ldy #>gameirq5
                stx $fffe
                sty $ffff
gstack4a        lda #$00
gstack4x        ldx #$00
gstack4y        ldy #$00               
                rti
                
;IRQ5 - Parallax 2 - The plants (top)

gameirq5        sta gstack5a+1
                stx gstack5x+1
                sty gstack5y+1
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
gstack5a        lda #$00
gstack5x        ldx #$00
gstack5y        ldy #$00                
                rti
                
;IRQ6 - Main scroll game field

gameirq6        sta gstack6a+1
                stx gstack6x+1
                sty gstack6y+1
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
              nop
              nop
              nop
              nop
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
gstack6a       lda #$00
gstack6x       ldx #$00
gstack6y       ldy #$00               
                rti
                
;IRQ7 - Parallax scrolling - the plants (bottom)

gameirq7        sta gstack7a+1
                stx gstack7x+1
                sty gstack7y+1
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
gstack7a        lda #$00
gstack7x        ldx #$00
gstack7y        ldy #$00                
                rti
                
                ;IRQ7 - Parallax scrolling - the plants (bottom)

gameirq8        sta gstack8a+1
                stx gstack8x+1
                sty gstack8y+1
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
                nop
                nop
                nop
                nop
  
}   
                ldx #<gameirq1
                ldy #>gameirq1
                stx $fffe
                sty $ffff
                jsr musicplayer
gstack8a        lda #$00
gstack8x        ldx #$00
gstack8y        ldy #$00                
                rti
                
                