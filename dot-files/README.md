# Configuration Cheatsheet
__7zip:__ Compression settings:
```bash
7z a -t7z -mx=9 -mfb=273 -ms -md=31 -myx=9 -mtm=- -mmt -mmtf -md=1536m -mmf=bt3 -mmc=10000 -mpb=0 -mlc=0
```

__Git:__
```bash
git pull --rebase
git rm --cached
git commit --amend
```

__Linux:__
* Useful Commands:
```bash
#
#   bash scripting
#
# display and capture cerr, cout
./run_benchmarks.sh 2>&1 | tee results.benchmark    
# run some script in background w/o printing everywhere
./run_benchmarks.sh &> /dev/null &      


#
#   Search utilities
#
find . -type f -not -path './_deps/*' | sort -rn | grep 'the_name_of_the_file_i_want'

#
#   quality-of-life cli
#
# leave console connected
mpstat 2 1000   
# Soften machine duress
nice -n 20 ionice -c 3 cp -rv {SOURCE} {DEST}   

#
#   third-party
#
youtube-dl -f bestvideo+bestaudio '[video_URL]'
```
* Even though it's on Nvidia's installation guide (as of this writing), __do not__ 
install CUDA via a Linux package manager. Instead, just use the package Nvidia rolls,
and make the mandatory path changes (also in that guide).

__Ubuntu:__
* If using newer versions of gcc on fresh installs, then update these garbage
symlinks since ubuntu uses `/bin/c++` as the default with `cmake`. Note that 
aliasing doesn't work since they're user-specific.
```bash
readlink /usr/bin/c++       # should point to `/etc/alternatives/c++`
readlink /etc/alternatives/c++      # should point to `/usr/bin/g++`
readlink /usr/bin/g++       # should be a real link (finally!)
```

__PowerShell:__
* WSL can consume ungodly amounts of RAM via VmmemWSL:
```pwsh
# Observe running instances
wsl -l -v
# Frees all memory (use can persist if all instances stopped)
wsl --shutdown
```


__Python:__
```python
#
#   Shell interaction
#
from subprocess import check_output
check_output("ls -l", shell=True)

#
#   E-Trade data
#
df = pd.read_csv('HOOLI.csv', index_col='Date')
def summarize(t = df.shape[0]):
    print('Over the last ' + str(t) + ' days (of ' + str(df.shape[0]) + ')')
    print("Avg. return selling at high from open: " + str(df['High-Open'][-t:].mean()) + "\nAverage Spread: " + str(df['Spread'][-t:].mean()))
```
