package 
{
	import flash.geom.Rectangle;
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Tilemap;
	import net.flashpunk.masks.Grid;
	import net.flashpunk.World;
	import net.flashpunk.FP;
	import flash.display.BitmapData;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Stamp;
	import net.flashpunk.utils.Draw;
	import net.flashpunk.Entity;
	
	
	public class ButtWorld extends World
	{
		// OGMO-generated level
		[Embed(source = "ButtWorld.oel", mimeType = "application/octet-stream")] private static const LEVEL:Class;
		
		protected var map:Entity;
		
		private var _player:PlayerLord;
		private var _mapGrid:Grid;
		private var _enemyList:Vector.<Enemy>;
		
		public function ButtWorld()
		{
			trace("initializing ButtWorld");
			
			loadMap(LEVEL);
			
			var i:Image = new Image(_mapGrid.data);
			i.scale = 32;
			map = new Entity(0, 0, i, _mapGrid);
			map.type = "wall";
			
			add(map);
			add(_player);
		}
		
		override public function update():void
		{
			super.update();
			
			followPlayerWithCamera();
		}
		
		private function followPlayerWithCamera():void
		{
			var dX:Number = _player.x - camera.x;
			//Player is far right
			if (dX > 600) camera.x += (dX - 600);
			//Player is far left
			else if (dX < 200) camera.x += (dX - 200);
			
			var dY:Number = _player.y - camera.y;
			//Player is low on screen
			if (dY > 400) camera.y += (dY - 400);
			//Player is high on screen
			else if (dY < 200) camera.y += (dY - 200);
		}
		
		private function loadMap(mapData:Class):Boolean
		{
			var mapXML:XML = FP.getXML(mapData);
			
			//Create the map grid
			_mapGrid = new Grid(uint(mapXML.@width), uint(mapXML.@height), 32, 32, 0, 0);
			_mapGrid.loadFromString(String(mapXML.Wall), "", "\n");
			
			//Add the player at the player start
			_player = new PlayerLord();
			_player.x = mapXML.Entities.PlayerStart.@x;
			_player.y = mapXML.Entities.PlayerStart.@y;
			
			return true;
		}
	}
	
}