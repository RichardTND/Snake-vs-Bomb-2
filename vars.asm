
;VARIABLES/LABELS

screen = $0400 ;Assigned screen RAM 
colour = $d800 ;Assigned colour RAM
musicinit = $1000
musicplay = $1003

split1 = $22 ;Paralax layer 5 - The rocks (bottom)
split2 = $3a ;Status panel
split3 = $6a ;Mountains
split4 = $7a ;Parallax layer 1 - The rocks (top)
split5 = $8a ;Parallax layer 2 - the plants (top)
split6 = $da ;Main game scroll
split7 = $ea;Paralax layer 4 - The plants (bottom)
split8 = $fa ;Copy of split 7

;Object spawn row/column position

spawnrow1 = screen+(12*40)+39
spawnrow2 = screen+(13*40)+39
spawnrow3 = screen+(14*40)+39
spawnrow4 = screen+(15*40)+39
spawnrow5 = screen+(16*40)+39
spawnrow6 = screen+(17*40)+39
spawnrow7 = screen+(18*40)+39
spawnrow8 = screen+(19*40)+39

spawncolumn1b = spawncolumn1+1
spawncolumn2b = spawncolumn2+1
spawncolumn3b = spawncolumn3+1
spawncolumn4b = spawncolumn4+1
spawncolumn5b = spawncolumn5+1
spawncolumn6b = spawncolumn6+1
spawncolumn7b = spawncolumn7+1
spawncolumn8b = spawncolumn8+1

;Charset values for fruit

banana1 = 00 ;Banana top left
banana2 = 83 ;Banana top right
banana3 = 84 ;Banana bottom left
banana4 = 85 ;Banana bottom right

cherry1 = 86 ;cherry top left
cherry2 = 87 ;cherry top right
cherry3 = 88 ;cherry bottom left
cherry4 = 89 ;cherry bottom right

strawberry1 = 90 ;strawberry top left
strawberry2 = 91 ;strawberry top right
strawberry3 = 92 ;strawberry bottom left
strawberry4 = 93 ;strawberry bottom right

bomb1 = 94 ;bomb top left
bomb2 = 95 ;bomb top right
bomb3 = 96 ;bomb bottom left
bomb4 = 97 ;bomb bottom right

score100a = 102 ;score 100 top left
score100b = 103
score100c = 104
score100d = 105

score200a = 106
score200b = 107
score200c = 108
score200d = 109

score300a = 110
score300b = 111
score300c = 112
score300d = 113

score500a = 114
score500b = 115
score500c = 116
score500d = 117

