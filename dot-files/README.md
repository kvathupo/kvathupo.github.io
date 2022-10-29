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
./run_benchmarks.sh 2>&1 | tee results.benchmark    # display and capture cerr, cout
./run_benchmarks.sh &> /dev/null &      # run some script in background w/o printing everywhere
find . -type f -not -path './_deps/*' | sort -rn | grep 'the_name_of_the_file_i_want'
mpstat 2 1000   # leave console connected
nice -n 20 ionice -c 3 cp -rv {SOURCE} {DEST}   # Soften machine duress
youtube-dl -f bestvideo+bestaudio '[video_URL]'
```

__Ubuntu:__
* If using newer versions of gcc on fresh installs, then update these garbage
symlinks since ubuntu uses `/bin/c++` as the default with `cmake`. Note that 
aliasing doesn't work since they're user-specific.
```bash
readlink /usr/bin/c++       # should point to `/etc/alternatives/c++`
readlink /etc/alternatives/c++      # should point to `/usr/bin/g++`
readlink /usr/bin/g++       # should be a real link (finally!)
```


__Python:__
```python
from subprocess import check_output
check_output("ls -l", shell=True)
```
