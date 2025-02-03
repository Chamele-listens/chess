### Chess
A full fledge 2 player chess game on the terminal you can play with your friends !

### Features
- save load system (support for win/linux/mac)
- check and checkmate
- proper chess moves constraints

### Prerequisites 

Before you run the game, make sure you do a bundle install to install of the
required gems from the Gemfile

```
bundle install
```

### Starting the game
To start the game type this in the terminal from the root directory

##### linux
```
ruby lib/chess_main.rb
```

##### window
```
ruby lib\chess_main.rb
```

### How to play

To move a chess piece, type 4 strings of number like `2242`, where the first 2 numbers
represent the vertical and horizontal position of your chess piece. The last 2 numbers shows the vertical and horizontal position of where you want to move you piece.

### Saving and loading

You can type save/load any time during the game to save/load a file. A save file folder will be created automatically if there isn't any. 

#### Warning
You can only create one save_file at a time !
