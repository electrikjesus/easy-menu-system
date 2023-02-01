# project eggs TUI/GUI

# Plan
I want to get something like that - note we discard help and nointeractive -:

## main menu

```
===================================================
eggs

On the road of Remastersys, Refracta, Systemback and father Knoppix!

adapt
calamares
dad
help
kill
install
produce
syncfrom
syncto
status
update
export
tools
```

## calamares:
```
===================================================
calamares

calamares configuration or install and configure it
[ ] install 
[ ] release 
[ ] remove
[ ] theme: ________________
[ ] verbose
```

## install
```
===================================================
install

krill TUI system installer - the egg becomes a chick
[ ] none
[ ] suspend
[ ] custom: ________________
[ ] domain: ________________
[ ] ip
[ ] crypted
[ ] pve
[ ] random
[ ] small
[ ] unattended
[ ] verbose
```

## produce
```
===================================================
produce

the system produces an egg: iso image of your system

[ ] backup
[ ] basename: ________________
[ ] clone
[ ] fast
[ ] max
[ ] prefix: ________________
[ ] release
[ ] script
[ ] theme: ________________
[ ] verbose
[ ] yolk
```

# .oclif.manifest.json

After wrote the entire mom.yaml I realized there is the opportunity of use the file .oclif.manifest.json this is automatically generated and update when I create eggs package.




