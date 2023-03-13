
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
split8 = $fd ;Copy of split 7

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

;Charset values for lower half of canyon

apple1 = 95 ;Apple top left
apple2 = 96 ;Apple top right
apple3 = 97 ;Apple bottom left 
apple4 = 98 ;Apple bottom right

banana1 = 99 ;Banana top left
banana2 = 100 ;Banana top right
banana3 = 101 ;Banana bottom left
banana4 = 102 ;Banana bottom right

cherry1 = 103 ;cherry top left
cherry2 = 104 ;cherry top right
cherry3 = 105 ;cherry bottom left
cherry4 = 106 ;cherry bottom right

strawberry1 = 107 ;strawberry top left
strawberry2 = 108 ;strawberry top right
strawberry3 = 109 ;strawberry bottom left
strawberry4 = 110 ;strawberry bottom right

bomb1 = 111 ;bomb top left
bomb2 = 112 ;bomb top right
bomb3 = 114;bomb bottom left
bomb4 = 115 ;bomb bottom right

;Character values for upper half of canyon

smallapple1 = 116; small apple top left
smallapple2 = 117; small apple top right
smallapple3 = 118; small apple bottom left
smallapple4 = 119; small apple bottom right

smallbanana1 = 120 ;small banana top left
smallbanana2 = 121 ;small banana top right
smallbanana3 = 122 ;small banana bottom left
smallbanana4 = 123 ;small bannan bottom right

smallcherry1 = 124 ;small cherry top left
smallcherry2 = 125 ;small cherry top right
smallcherry3 = 126 ;small cherry bottom left
smallcherry4 = 127 ;small cherry bottom right

smallstrawberry1 = 128 ;small strawberry top left
smallstrawberry2 = 129 ;small strawberry top right
smallstrawberry3 = 130 ;small strawberry bottom left
smallstrawberry4 = 131 ;small strawberry bottom right

smallbomb1 = 132 ;small bomb top left
smallbomb2 = 133 ;small bomb top right
smallbomb3 = 134 ;small bomb bottom left
smallbomb4 = 135 ;small bomb bottom right

lane = 170 ;Char ID for black empty lane