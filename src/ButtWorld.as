package {
    import flash.geom.Rectangle;
    import net.flashpunk.graphics.Tilemap;
    import net.flashpunk.masks.Grid;
    import net.flashpunk.World;
    import net.flashpunk.FP;
    import flash.display.BitmapData;
    import net.flashpunk.graphics.Image;
    import net.flashpunk.graphics.Stamp;
    import net.flashpunk.utils.Draw;
    import net.flashpunk.Entity;
	import Solids.Slope;
	
    public class ButtWorld extends World {
        // OGMO-generated level XML.
        [Embed(source = "../ogmo/PlayerHut.oel", mimeType = "application/octet-stream")]
		private static const LEVEL:Class;
		
        protected var map:Entity;
        private var _player:PlayerLord = new PlayerLord();
        private var _enemies:Vector.<Enemy> = new Vector.<Enemy>();
        
        public function ButtWorld() {
            trace("Initializing ButtWorld.");
            
            var mapXML:XML = FP.getXML(LEVEL);
			
            // Load the ground/walls.
            var mapGrid:Grid = new Grid(uint(mapXML.@width), uint(mapXML.@height), 32, 32, 0, 0);
            mapGrid.loadFromString(String(mapXML.Ground), "", "\n");            
            var i:Image = new Image(mapGrid.data);
            i.scale = 32;
            map = new Entity(0, 0, i, mapGrid);
            map.type = "wall";
            add(map);
			createRamps(mapGrid);
			
			// Load the platforms.
			var platformGrid:Grid = new Grid(uint(mapXML.@width), uint(mapXML.@height), 32, 32, 0, 0);
			platformGrid.loadFromString(String(mapXML.Platform), "", "\n");
			var platformImage:Image = new Image(platformGrid.data);
			platformImage.scale = 32;
			var platforms:Entity = new Entity(0, 0, platformImage, platformGrid);
			platforms.type = "platform";
			add(platforms);
            
            // Add and position the player.
            _player.x = mapXML.Entities.Player.@x;
            _player.y = mapXML.Entities.Player.@y;
            add(_player);
            
			// Create enemies.
            for each (var dog:XML in mapXML.Entities.Dog) {
                var newEn:Dog = create(Dog) as Dog; // create(e) adds e to world.
                newEn.x = dog.@x;
                newEn.y = dog.@y;
                _enemies.push(newEn);
            }

        }
		
		private function createRamps(mapGrid:Grid):void {
			var ramp:Slope;
			for (var j:uint = 0; j < mapGrid.columns; j++)
			{
				for (var i:uint = 0; i < mapGrid.rows; i++)
				{
					// Empty space with a tile below.
					if (! mapGrid.getTile(j, i) && mapGrid.getTile(j, i + 1)) 
					{
						 // Solid square to the right, space to left.
						if (mapGrid.getTile(j + 1, i) && !mapGrid.getTile(j - 1, i))
						{
							// Type 0 slope goes from bottom-left to top-right.
							ramp = new Slope(j*mapGrid.tileWidth, i*mapGrid.tileHeight, 0);
							ramp.type = "wall";
							add(ramp);
						}
						// Solid square to the left, space to the right.
						else if (!mapGrid.getTile(j + 1, i) && mapGrid.getTile(j - 1, i))
						{
							// Type 1 slope goes from top-left to bottom-right.
							ramp = new Slope(j*mapGrid.tileWidth, i*mapGrid.tileHeight, 1);
							ramp.type = "wall";
							add(ramp);
						}
					}
				}
			}
		}
        
        override public function update():void {
            super.update();
            
            followPlayerWithCamera();
            
            for each (var enemy:Enemy in _enemies) {
                var bullet:Bullet = enemy.collide("bullet", enemy.x, enemy.y) as Bullet;
                if (bullet) {
                    recycle(enemy);
                    bullet.destroy();
                }
            }
        }
        
        private function followPlayerWithCamera():void {
            var dX:Number = _player.x - camera.x;
            //Player is far right
            if (dX > 600)
                camera.x += (dX - 600);
            //Player is far left
            else if (dX < 200)
                camera.x += (dX - 200);
            
            var dY:Number = _player.y - camera.y;
            //Player is low on screen
            if (dY > 400)
                camera.y += (dY - 400);
            //Player is high on screen
            else if (dY < 200)
                camera.y += (dY - 200);
        }
        
    }

}