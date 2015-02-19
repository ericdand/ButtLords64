package Solids 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.Mask;
	import net.flashpunk.masks.Pixelmask;
	/**
	 * ...
	 * @author Noel Berry
	 */
	public class Slope extends Solid
	{
		[Embed(source = '../assets/graphics/slope1.png')] private static const SLOPE1:Class;
		[Embed(source = '../assets/graphics/slope2.png')] private static const SLOPE2:Class;
		[Embed(source = '../assets/graphics/slope3.png')] private static const SLOPE3:Class;
		[Embed(source = '../assets/graphics/slope4.png')] private static const SLOPE4:Class;
		public var slopeMask:Pixelmask;
		
		public function Slope(x:int, y:int, type:int) 
		{
			super(x, y);
			
			var slope:Class;
			switch(type) {
				case 0: slope = SLOPE1; break;
				case 1: slope = SLOPE2; break;
				case 2: slope = SLOPE3; break;
				case 3: slope = SLOPE4; break;
			}
			
			slopeMask = new Pixelmask(slope, 0, 0);
			mask = slopeMask;
			
			var img:Image = new Image(slope);
			this.graphic = img;
			
			this.type = "wall";
			
			//hide us - we don't need to ever be updated
			active = false;
			visible = true; // TODO: turn this back to false when real art is present
		}
		
	}

}