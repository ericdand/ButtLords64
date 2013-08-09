package 
{
	import flash.display.BitmapData;
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Stamp;
	import net.flashpunk.utils.Draw;
	import net.flashpunk.FP;

	public class Bullet extends Entity
	{
		private var vX:Number;
		private var vY:Number;
		
		private const speed:Number = 400;
		
		public function Bullet()
		{
			type = "bullet";
			setHitbox(8, 2, -2);
			
			var bd:BitmapData = new BitmapData(10, 2);
			
			Draw.setTarget(bd);
			Draw.rect(0, 0, 10, 2, 0xFFFFAA);
			
			var s:Stamp = new Stamp(bd, 0, 0);
			graphic = s;
		}
		
		override public function update():void
		{
			x += vX;
			y += vY;
			
			if (x > FP.camera.x + FP.width + 50 || x < FP.camera.x - 50 || y > FP.camera.y + FP.height + 50 || y < FP.camera.y - 50)
			{
				this.destroy();
			}
		}
		
		internal function setMovement():void
		{
			var player:PlayerLord = FP.world.getInstance("player");
			x = player.x + 16;
			y = player.y + 32;
			
			var dX:Number = FP.world.mouseX - x;
			var dY:Number = FP.world.mouseY - y;
			var scaleFactor:Number = 10 / Math.sqrt(dX * dX + dY * dY);
			
			vX = dX * scaleFactor;
			vY = dY * scaleFactor;
		}
		
		public function destroy():void
		{
			FP.world.recycle(this);
		}
	}
}