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
		[Embed(source = "assets/Dog spritesheet32c.png")] private static const DOG:Class;
		[Embed(source = "sound/DogBreath.mp3")] private static const BREATH:Class;
		private var breath:Sfx = new Sfx(BREATH);
		[Embed(source = "sound/DogGrowl.mp3")] private static const GROWL:Class;
		public var growl:Sfx = new Sfx(GROWL);
		
		public var sprDog:Spritemap = new Spritemap(DOG, 55, 29, function():void {
			//reset the state to standing any animation is done
			state = STANDING;
		});
		
		public function Dog()
		{
			super();
			
			setHitbox(32, 27, -23);
			
			this.x = 280;
			
			sprDog.add("breathe-right", [1, 2, 3, 4, 5, 4, 3, 2, 1, 0], 15, false);
			sprDog.add("breathe-left", [7, 8, 9, 10, 11, 10, 9, 8, 7, 6], 15, false);
			graphic = sprDog;
			growl.play();
		}
		
		override public function update():void
		{
			super.update();
			var player:PlayerLord = world.getInstance("player") as PlayerLord;
			
			var dX:Number = this.x - player.x;
			var dY:Number = this.y - player.y;
			
			if (state == STANDING)
			{
				if (onTheGround)
				{
					if (dX > 26)
					{
						// look right
						sprDog.setFrame(0, 1);
						xVelocity = -3;
					}
					else if (dX < -26)
					{
						// look left
						sprDog.setFrame(0, 0);
						xVelocity = 3;
					}
					else
					{
						state = ATTACKING;
						if (dX > 0)
						{
							sprDog.play("breathe-left", true);
						}
						else
						{
							sprDog.play("breathe-right", true);
						}
						breath.play();
						xVelocity = 0;
					}
					
					if (collide("wall", x + FP.sign(xVelocity), y))
					{
						yVelocity -= jumpPower; //jump!
					}
				}
				else
				{
					//Maintain momentum
					if (!xVelocity)
					{ //But move slower in the air
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