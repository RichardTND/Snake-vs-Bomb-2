
;IRQ INTERRUPTS

;IRQ 1 - outer raster 

gameirq1       
                inc $d019
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
                lda #0
                sta $d020
  
}  
             
              
               
                ldx #<gameirq2
                ldy #>gameirq2
                stx $0314
                sty $0315
               
                jmp $ea7e
                
;IRQ 2 - Score panel raster

gameirq2        inc $d019
              
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
                
                lda #0
                bit $d020
  }  

                lda #$09
                sta $d022
                lda #$01
                sta $d023
                
                ldx #<gameirq3
                ldy #>gameirq3
                stx $0314
                sty $0315
                jmp $ea7e
                
;IRQ 3 - Mountains

gameirq3        inc $d019
                lda #split3
                sta $d012
                
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
                lda #0
                bit $d020
  }  

                lda #$07
               
                sta $d022
                lda #$0a
                sta $d023
                ldx #<gameirq4
                ldy #>gameirq4
                stx $0314
                sty $0315
                jmp $ea7e
                
;IRQ 4 - Parralax 1 - The rocks (top)

gameirq4        inc $d019
                lda #split4
                sta $d012

                nop
                nop
                nop
                nop
                nop
             
                lda d016table+1
                ora #$10
                sta $d016
               
                lda #$1c
                sta $d018
!ifdef testirqborder {                
                lda #4
                sta $d020
} else {
                lda #0
                bit $d020
  
}  
               
                lda #$02
                
                sta $d022
                lda #$07
                sta $d023
                ldx #<gameirq5
                ldy #>gameirq5
                stx $0314
                sty $0315
                jmp $ea7e
                
;IRQ5 - Parallax 2 - The plants (top)

gameirq5        inc $d019
                lda #split5
                sta $d012
                ;ms nop
                ;nop
                ;nop
                ;nop
                ;nop
                ;nop
                lda d016table+2
                ora #$10
                sta $d016
                
!ifdef testirqborder {                
                lda #5
                sta $d020
} else {
                lda #0
                bit $d020
  
}  

                lda #$02
                sta $d022
                lda #$07
                sta $d023
               
                ldx #<gameirq6
                ldy #>gameirq6
                stx $0314
                sty $0315
                jmp $ea7e
                
;IRQ6 - Main scroll game field

gameirq6        inc $d019
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
                lda #0
                bit $d020
}  
                
                ldx #<gameirq7
                ldy #>gameirq7
                stx $0314
                sty $0315
                jmp $ea7e
                
;IRQ7 - Parallax scrolling - the plants (bottom)

gameirq7     
                inc $d019
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
                lda #0
                bit $d020
  
}  
                 
                ldx #<gameirq8
                ldy #>gameirq8
                stx $0314
                sty $0315
                jmp $ea7e
                
                ;IRQ7 - Parallax scrolling - the plants (bottom)

gameirq8     
                inc $d019
                
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
                lda #0
                sta $d020
  
}   
               
             
                ldx #<gameirq1
                ldy #>gameirq1
                stx $0314
                sty $0315
             
                lda #1
                sta rt
                jsr musicplayer
                jmp $ea7e