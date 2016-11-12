# GameOfLifeWeb

## To start
```
BOARDS=<num_boards> PATTERN=<pattern> iex -S mix phoenix.server
```
<pattern> can be e.g. glider, random, acorn etc.

## Debug websocket traffic
```
sudo ngrep -d lo0 -q -W byline port 4000
```
