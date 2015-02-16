package  
{
	import flash.display.BitmapData;
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Image;
	
	/**
	 * Used to create one-way (jump-through) platforms.
	 * @author Eric Dand
	 */
	public class Platform extends Entity 
	{
		
		public function Platform(width:uint) 
		{
			type = "platform";
			setHitbox(int(width), 1);
			graphic = new Image(new BitmapData(int(width), 1, false, 0xFFFFFFFF));
		}
		
	}

}