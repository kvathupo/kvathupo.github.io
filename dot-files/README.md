# Configuration Cheatsheet
__7zip:__ Compression settings:
```bash
7z a -t7z -mx=9 -mfb=273 -ms -md=31 -myx=9 -mtm=- -mmt -mmtf -md=1536m -mmf=bt3 -mmc=10000 -mpb=0 -mlc=0
```

__Git:__
```bash
git commit --amend
git rm --cached
git -q
```

__Linux:__
```bash
find . -type f -not -path './_deps/*' | sort -rn | grep 'the_name_of_the_file_i_want'
mpstat 2 1000   # leave console connected
nice -n 20 ionice -c 3 cp -rv {SOURCE} {DEST}   # Soften machine duress
```
