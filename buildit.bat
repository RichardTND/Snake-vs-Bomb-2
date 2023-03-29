del *.prg
c:\c64\tools\acme\acme.exe snakevsbomb2.asm
if not exist snakevsbomb2.prg goto abort
c:\c64\tools\exomizer20\win32\exomizer.exe sfx $4800 snakevsbomb2.prg -o snakevsbomb2+.prg -x2
c:\c64\tools\vice\x64sc.exe snakevsbomb2+.prg
abort:
