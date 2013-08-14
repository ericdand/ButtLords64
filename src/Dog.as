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
		
		private const DAMAGE_DONE:uint = 1;
		
		public var sprDog:Spritemap = new Spritemap(DOG, 55, 29, callback);
		
		//An animation callback-- allows hit-testing when the dog has breathed all the way out
		public function callback():void {
			if (sprDog.currentAnim == "breathe-out-right")
			{
				hitTest(0);
				sprDog.play("breathe-in-right", true);
			}
			else if (sprDog.currentAnim == "breathe-out-left")
			{
				hitTest(1);
				sprDog.play("breathe-in-left", true);
			}
			else
			{//reset the state to standing any animation is done
				state = STANDING;
			}
		}
		
		public function Dog()
		{
			super();
			
			setHitbox(32, 27, -23);
			
			this.x = 280;
			
			sprDog.add("breathe-out-right", [1, 2, 3, 4, 5], 15, false);
			sprDog.add("breathe-in-right", [4, 3, 2, 1, 0], 15, false);
			sprDog.add("breathe-out-left", [7, 8, 9, 10, 11], 15, false);
			sprDog.add("breathe-in-left", [10, 9, 8, 7, 6], 15, false);
			graphic = sprDog;
			growl.play();
		}
		
		override public function update():void
		{
			super.update();
			player = world.getInstance("player") as PlayerLord;
			
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
						xVelocity = -MOVE_SPEED;
					}
					else if (dX < -26)
					{
						// look left
						sprDog.setFrame(0, 0);
						xVelocity = MOVE_SPEED;
					}
					else
					{
						state = ATTACKING;
						if (dX > 0)
						{
							sprDog.play("breathe-out-left", true);
						}
						else
						{
							sprDog.play("breathe-out-right", true);
						}
						breath.play();
						xVelocity = 0;
					}
					
					if (collide("wall", x + FP.sign(xVelocity), y))
					{
						yVelocity -= JUMP_POWER; //jump!
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
			else if (state == ATTACKING)
			{
				
			}
			
			var bullet:Bullet = collide("bullet", x, y) as Bullet;
			
			if (bullet)
			{
				FP.world.recycle(this);
				bullet.destroy();
			}
			
			moveBy(xVelocity, yVelocity, "wall");
		}
		
		/* Direction: 0 == right, 1 == left
		 * Returns true if player was damaged, false if the attack missed */
		private function hitTest(direction:uint):Boolean
		{
			var p:PlayerLord;
			if (direction == 0)
			{
				p = collideWith(player, x, y) as PlayerLord;
			}
			else if (direction == 1)
			{
				p = collideWith(player, x - 32, y) as PlayerLord;
			}
			
			if (p)
			{
				p.takeDamage(this, DAMAGE_DONE);
				return true; 
			}
			return false;
		}
	}
}