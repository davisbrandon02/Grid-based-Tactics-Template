# Grid-based-Tactics-Template

This is a simple template to create turn-based tactics games such as XCOM or Fire Emblem in Godot. Started as just
a fun side project to get more used to AStar pathfinding and creating grids for games in general.

Features:
- Automatic tilemap to grid conversion: easily create maps using the built in tilemap node and the Board node will
  automatically create a game board of Tile objects with whatever data you would like to include. For example, you
  could place down a plains tile with no data that can be traversed, a mountain that cannot be moved onto, or a
  forest that offers a certain amount of defense against attacks.
- Built in AStar pathfinding and range calculation. Easily check movement range, attack range, influence range, etc.

Planned features:
- Easily customizable units that can spawn from set "spawn" locations on the tilemap, and can be easily changed. Example: default unit
  can be made into rifleman units, or units with their own levels and XP like in Fire Emblem.
- Tiles will be able to hold whatever data you see fit, such as fortification level, levels of cover from each
  direction, owner, amount of resource gained per turn, etc.
- Line of sight calculation
- Simple example game with YouTube series tutorial on how to use the template
