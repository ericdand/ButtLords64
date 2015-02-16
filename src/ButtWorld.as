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
		private static const SCALE:uint = 32; // 32 pixels per square of the grid.
		
        protected var map:Entity;
        private var _player:PlayerLord = new PlayerLord();
        private var _enemies:Vector.<Enemy> = new Vector.<Enemy>();
        
        public function ButtWorld() {
            trace("Initializing ButtWorld.");
            
            var mapXML:XML = FP.getXML(LEVEL);
			
            // Load the ground/walls.
            var mapGrid:Grid = new Grid(uint(mapXML.@width), uint(mapXML.@height), SCALE, SCALE, 0, 0);
            mapGrid.loadFromString(String(mapXML.Ground), "");            
            var i:Image = new Image(mapGrid.data);
            i.scale = SCALE;
            map = new Entity(0, 0, i, mapGrid);
            map.type = "wall";
            add(map);
			createRamps(mapGrid);
			
			// Load the platforms.
			loadPlatforms(mapXML);
            
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
		
		/**
		 * Iterate over the platforms string data and add Platform objects to
		 * the world accordingly.
		 * 
		 * This works by incrementing a "platform width" every time a '1' is
		 * seen in the platform data. When a '0' is seen, if "platform width"
		 * is nonzero, it is set to zero and a platform of that width is added
		 * to the world in the place specified.
		 * @param	mapXML	The OGMO level XML object loaded from FP.getXML.
		 */
		private function loadPlatforms(mapXML:XML):void 
		{
			var row:Array = String(mapXML.Platform).split("\n"),
				nRows:uint = row.length,
				col:Array, 
				nCols:uint, 
				x:int, 
				y:int,
				platformWidth:uint;
			
			for (y = 0; y < nRows; y++)
			{
				col = row[y].split(""),
				nCols = col.length;
				platformWidth = 0;
				for (x = 0; x < nCols; x++)
				{
					if (col[x] == '1')
					{
						platformWidth++;
					}
					else if (platformWidth > 0)
					{
						createPlatform(x - platformWidth, y, platformWidth);
						platformWidth = 0;
					}
				}
				
				// Before going on, don't forget to check for platforms which
				// touch the far edge of the world.
				if (platformWidth > 0)
				{
					createPlatform(x - platformWidth, y, platformWidth);
					platformWidth = 0;
				}
			}
		}
		
		private function createPlatform(x:int, y:int, width:uint):void 
		{
			var platform:Platform = new Platform(width * SCALE);
			platform.x = x * SCALE;
			platform.y = y * SCALE;
			add(platform);
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