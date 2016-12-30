# Game Of Life Web

Elixir/Phoenix/Elm Game of life visualisation.

## Installation

* Ensure Elm v0.18 is installed `npm install -g elm@0.18.0` (may need running as sudo)
* Clone this repo `git clone https://github.com/xing/game_of_life_web`
* Clone <https://github.com/xing/game_of_life> to a directory at the same level
`git clone https://github.com/xing/game_of_life`
* Enter web folder `cd game_of_life_web`
* Install npm packages `npm install`
* Start app `iex -S mix phoenix.server`
* Visit <http://localhost:4000> and press the green Play button

You can change the pattern and number of boards by starting as follows
```
BOARDS=<num_boards> PATTERN=<pattern> iex -S mix phoenix.server
```
<pattern> can be e.g. glider, random, acorn etc.

## Copy elm-phoenix code into vendor
```
cp -R ../elm-phoenix/src/* web/elm-vendor/elm-phoenix/
```

## Debug websocket traffic
```
sudo ngrep -d lo0 -q -W byline port 4000
```
