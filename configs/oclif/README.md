# Test su manifest 


Seleziona un comando:
```
.commands[] | select(.id =="calamares")
```

getFlagsNames() {
[jq]> .commands[] | select(.id=="calamares").flags[] | .name
}



in bash?
.commands[] | select(.id =="$answer")