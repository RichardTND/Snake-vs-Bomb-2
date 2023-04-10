sprite00x = objpos
sprite00y = objpos+1
sprite01x = objpos+2
sprite01y = objpos+3
sprite02x = objpos+4
sprite02y = objpos+5
sprite03x = objpos+6
sprite03y = objpos+7
sprite04x = objpos+8
sprite04y = objpos+9
sprite05x = objpos+10
sprite05y = objpos+11
;VARIABLES/LABELS

titlemusic = 0
gamemusic = 1
getreadymusic = 2
gameovermusic = 3
gamecompletemusic = 4
deathmusic = 5
welldonemusic = 6
hiscoremusic = 7

screen = $0400 ;Assigned screen RAM 
colour = $d800 ;Assigned colour RAM
musicinit = $8000
musicplay = $8003
sfxplay = $8006 

split1 = $22 ;Paralax layer 5 - The rocks (bottom)
split2 = $3a ;Status panel
split3 = $6a ;Mountains
split4 = $7a ;Parallax layer 1 - The rocks (top)
split5 = $8a ;Parallax layer 2 - the plants (top)
split6 = $d9 ;Main game scroll
split7 = $ea;Paralax layer 4 - The plants (bottom)
split8 = $fa ;Copy of split 7 
;Scroll control


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

lane = 94 ;Char ID for black empty lane

screenlostore = $70 ;Zero pages for self mod 
screenhistore = $71 ;sprite/char collision

;Charset ID that form the scoring chars 

points100a = 169 ;100 (2x2)
points100b = 170
points100c = 171
points100d = 172

points200a = 173 ;200 (2x2)
points200b = 174
points200c = 175
points200d = 176

points300a = 177 ;300 (2x2)
points300b = 178
points300c = 179
points300d = 180

points500a = 181 ;500 (2x2)
points500b = 182
points500c = 183
points500d = 184

;Bomb animation charset target 

animbombsrc1 = gamecharset+(149*8)
animbombsrc2 = gamecharset+(161*8)
animbombsrct = titlecharset+(84*8)

;Hi score table variables

scorelen = 6 ;No. of digits used for score
namelen = 9  ;No. of digits used for name
listlen = 10 ;No. of hi scores and names on list

;namestart = $a6a3     ;Target position for first character for name

name1 = $a6cb
name2 = $a6f3
name3 = $a71b
name4 = $a743
name5 = $a76b
name6 = $a6df
name7 = $a707
name8 = $a72f
name9 = $a757
name10 = $a77f

hiscorestart = $a6a0  ;Target position for first digit for hi score
hiscoreend = $a768

hiscoresavestart = $16c9
hiscoresaveend = $178f
hiscoreloadstart = $a6c9


hiscore1 = $a6d5
hiscore2 = $a6fd
hiscore3 = $a725
hiscore4 = $a74d
hiscore5 = $a775
hiscore6 = $a6e9
hiscore7 = $a711
hiscore8 = $a739
hiscore9 = $a761
hiscore10 = $a789


namescreenpos = $0707 ;Screen position in which the name should be displayed 


