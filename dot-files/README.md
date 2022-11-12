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
# display and capture cerr, cout
./run_benchmarks.sh 2>&1 | tee results.benchmark    
# run some script in background w/o printing everywhere
./run_benchmarks.sh &> /dev/null &      
find . -type f -not -path './_deps/*' | sort -rn | grep 'the_name_of_the_file_i_want'
# leave console connected
mpstat 2 1000   
# Soften machine duress
nice -n 20 ionice -c 3 cp -rv {SOURCE} {DEST}   
youtube-dl -f bestvideo+bestaudio '[video_URL]'
```

__Ubuntu:__
* If using newer versions of gcc on fresh installs, then update these garbage
symlinks since ubuntu uses `/bin/c++` as the default with `cmake`. Note that 
aliasing doesn't work since they're user-specific.
```bash
# should point to `/etc/alternatives/c++`
readlink /usr/bin/c++       
# should point to `/usr/bin/g++`
readlink /etc/alternatives/c++      
# should be a real link (finally!)
readlink /usr/bin/g++       
```

__PowerShell:__
* WSL can consume ungodly amounts of RAM via VmmemWSL:
```pwsh
# Observe running instances
wsl -l -v
# Frees all memory (can persist even if all WSL instances stopped
wsl --shutdown
```


__Python:__
```python
from subprocess import check_output
check_output("ls -l", shell=True)
```
