# 1Bit-PPG

Simple game created in Godot Engine utilizing [gdppg](https://github.com/dAmihl/gdppg) and [ppg-core](https://github.com/dAmihl/ppg-core)

Please refer to Godots documentation on how to build Godot Engine with custom modules to run this game.

### What it does:

It's a simple 2d sidescrolling "puzzle" game, where a predefined YAML (from the _/universes_ folder) is plugged into the _ppg_ module and generates a _"puzzle"_. This puzzle is then displayed (__very simply__) in the map. The player is able to interact with the game objects until the portal opens. When entering the portal, a new room, i.e. puzzle, is generated.

