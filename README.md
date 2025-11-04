# xlibre

> [!NOTE]
>>  _How to use_
>>> _type in the terminal_

```
printf "repository=https://github.com/sofijacom/xlibre/releases/latest/download/\n" | sudo tee /etc/xbps.d/99-repository-xlibre.conf
```

> [!IMPORTANT]
> 
> _Then type in the terminal `sudo xbps-install -S` and accept the fingerprint (Y)_

```shell
sudo xbps-install -S
```
_These packages will now be in your **OctoXBPS** package manager. When a new version of the program is released, you will update it along with all the other packages._
