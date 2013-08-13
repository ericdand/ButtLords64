package
{
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.Sfx;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	import net.flashpunk.FP;
	
	public class Dog extends Enemy
	{
		[Embed(source = "assets/Dog spritesheet32.png")] private static const DOG:Class;
		[Embed(source = "sound/DogBreath.mp3")] private static const BREATH:Class;
		private var breath:Sfx = new Sfx(BREATH);
		[Embed(source = "sound/DogGrowl.mp3")] private static const GROWL:Class;
		public var growl:Sfx = new Sfx(GROWL);
		
		public var sprDog:Spritemap = new Spritemap(DOG, 55, 29);
		
		public function Dog()
		{
			super();
			
			setHitbox(32, 27, -23);
			
			this.x = 280;
			
			sprDog.add("breathe", [1, 2, 3, 4, 5, 4, 3, 2, 1, 0], 15, false);
			sprDog.add("stand", [0]);
			graphic = sprDog;
			sprDog.play("stand");
			growl.play();
		}
		
		override public function update():void
		{
			super.update();
			var player:PlayerLord = world.getInstance("player") as PlayerLord;
			
			if (Input.pressed(Key.SPACE))
			{
				sprDog.play("breathe", true);
				breath.play();
			}
			
			var dX:Number = this.x - player.x;
			var dY:Number = this.y - player.y;
			
			if (onTheGround)
			{
				if (dX > 64)
				{
					xVelocity = -4;
				}
				else if (dX < -32)
				{
					xVelocity = 4;
				}
				else
				{
					//TODO: Player is in range! Attack!
				}
				
				if (collide("wall", x + FP.sign(xVelocity), y))
				{
					yVelocity -= jumpPower; //jump!
				}
			}
			else
			{
				//Maintain momentum, but move slower in the air.
				if (!xVelocity)
				{
					if (dX > 30)
					{
						xVelocity = -1;
					}
					else if (dX < -20)
					{
						xVelocity = 1;
					}
				}
			}
			
			var bullet:Bullet = collide("bullet", x, y) as Bullet;
			
			if (bullet)
			{
				FP.world.recycle(this);
				bullet.destroy();
			}
			
			moveBy(xVelocity, yVelocity, "wall");
		}
	}
}