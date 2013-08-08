package
{
	import flash.display.BitmapData;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Stamp;
	import net.flashpunk.utils.Draw;
	import net.flashpunk.Entity;
	
	public class Wall extends Entity
	{
		public const size:uint = 32;
		
		public function Wall(x:int, y:int)
		{
			setHitbox(32, 32);
			this.x = x;
			this.y = y;
			type = "wall";
		
			var bd:BitmapData = new BitmapData(size, size);
			
			Draw.setTarget(bd);
			Draw.rect(0, 0, this.size, this.size, 0xEFA832);
			
			var s:Stamp = new Stamp(bd, 0, 0);
			graphic = s;
		}
	}
}