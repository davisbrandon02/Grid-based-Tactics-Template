# Grid-based-Tactics-Template

This is a simple template to create turn-based tactics games such as XCOM or Fire Emblem/Advance Wars in Godot. Started as just
a fun side project to get more used to AStar pathfinding and creating grids for games in general.

Features:
- Grid system with game object tiles that can store whatever data is needed, such as fortification level, levels of cover from each
  direction, owner, amount of resource gained per turn, etc.
- Automatic tilemap to grid conversion: easily create maps using the built in tilemap node and the Board node will
  automatically create a game board of Tile objects with whatever data you would like to include.
- Base unit node with grid-based pathfinding and movement
- Unit attack system
- Built in AStar pathfinding and range calculation. Easily check movement range, attack range, influence range, etc.
- Built in line of sight calculation

Planned features:
- Two different advanced attacking systems: either percentage hit chance system (XCOM) or damage calculation based on terrain/stats (Advance Wars)
- Turn queue system that can support any number of sides. Example: XCOM turn, Alien turn, civilian turn, Lost turn (In progress)
- Customizable units. Example: default unit  can be made into rifleman units, or units with their own levels and XP like in Fire Emblem.
- Customizable tiles to build maps with, including the ability to store any data you want in the tiles. Example: cover directions, fortification level, walkable, etc.
- Easy integration within already created games or within games' strategic layers. To create an instance of this tactical combat, the
  developer should only need to give the units involved and a valid map.
- Simple example game with YouTube series tutorial on how to use the template
