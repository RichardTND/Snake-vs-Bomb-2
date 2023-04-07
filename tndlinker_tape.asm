
  !to "tndlinker_tape.prg",cbm
  
    *=$0801
    !bin "tndpresentation.rb",,2
    *=$0801
    lda #$01
    sta $ba
    jmp $0810
    *=$2c00
    !bin "snakevsbomb2.prg",,2
    