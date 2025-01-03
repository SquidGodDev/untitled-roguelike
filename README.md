# Untitled Roguelike
Source code for my Playdate "Broughlike" game. Features strategic turn-based grid movement and battles. Play as 6 different classes against a host of different enemies in increasing levels of difficulty. Adapted to Lua and the Playdate from this [JavaScript Broughlike Tutorial](https://nluqo.github.io/broughlike-tutorial/). You can find the game on [Itch IO](https://squidgod.itch.io/untitled-roguelike).

<img src="https://github.com/user-attachments/assets/0095d1b3-9374-4311-bb7f-c87996632b71" width="400" height="240"/>
<img src="https://github.com/user-attachments/assets/9ddee7b2-e9ca-4d0f-8014-bcf0cc9a52f4" width="400" height="240"/>
<img src="https://github.com/user-attachments/assets/72a3b3e1-6cfe-46f4-a8df-c854a8f7be4d" width="400" height="240"/>
<img src="https://github.com/user-attachments/assets/c54ca9ee-64a3-4d8c-a031-c5b04b5b6141" width="400" height="240"/>

## Project Structure
- `defender.lua` - Player defender class definition
- `enemy.lua` - Generic enemy base class
- `entity.lua` - Generic grid based entity class (enemies and player)
- `gameManager.lua` - Level management (generates map, handles game step, checks win condition)
- `ghost.lua` - Ghost enemy step definition
- `healthDisplay.lua` - Draws enemy health UI
- `heartDisplay.lua` - Draws player hearts 
- `knight.lua` - Player knight class definition
- `main.lua` - Handles scene initialization and transitions
- `map.lua` - Generates and draws map grid
- `menu.lua` - Main menu and character select UI
- `orc.lua` - Orc enemy step definition
- `player.lua` - Player character controller
- `priest.lua` - Player priest class definition
- `ranger.lua` - Player ranger class definition
- `rogue.lua` - Player rogue class definition
- `skeleton.lua` - Skeleton enemy step definition
- `spider.lua` - Spider enemy step definition
- `wizard.lua` - Player wizard class definition

## License
All code is licensed under the terms of the MIT license.
