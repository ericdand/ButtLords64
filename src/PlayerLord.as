package
{
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	import net.flashpunk.FP;
	
	public class PlayerLord extends Entity
	{
		[Embed(source = "assets/ButtLord64.png")] private const PLAYER:Class;
		
		private const GRAVITY:Number = 1;
		private const JUMP_POWER:Number = 12;
		private const MOVE_SPEED:Number = 4;
		
		//"enum" of states
		protected static const STANDING:uint = 0;
		protected static const DAMAGED:uint = 1;
		
		private var xVelocity:Number = 0;
		private var yVelocity:Number = 0;
		private var onTheGround:Boolean = false;
		private var health:int = 10;
		private var state:uint;
		
		public function PlayerLord()
		{
			name = "player";
			
			graphic = new Image(PLAYER);
			setHitbox(26, 64, -14, 0);
		}
		
		override public function update():void
		{
			//trace("Player updates.");
			
			if (state == STANDING && this.collide("wall", x, y + 1))
			{
				onTheGround = true;
				yVelocity = 0;
			}
			else
			{
				onTheGround = false;
			}
			if (onTheGround)
			{
				if(Input.pressed(Key.UP)) yVelocity -= JUMP_POWER;
			}
			else
			{
				if (yVelocity < 16)
				{
					if (Input.check(Key.UP)) yVelocity += GRAVITY/2;
					else yVelocity += GRAVITY;
				}
			}
			
			if (state == STANDING)
			{
				if (Input.check(Key.RIGHT)) xVelocity = MOVE_SPEED;
				else if (Input.check(Key.LEFT)) xVelocity = -MOVE_SPEED;
				else xVelocity *= 0.6;
			}
			else
			{
				state = STANDING;
			}
			
			moveBy(xVelocity, yVelocity, "wall");
			
			if (Input.mousePressed)
			{
				var b:Bullet = FP.world.create(Bullet) as Bullet;
				b.setMovement();
			}
		}
		
		override public function moveCollideX(e:Entity):Boolean
		{
			xVelocity = 0;
			return true;
		}
		
		override public function moveCollideY(e:Entity):Boolean
		{
			yVelocity = 0;
			return true;
		}
		
		public function takeDamage(enemy:Enemy, damage:uint):void
		{
			state = DAMAGED;
			
			health -= damage;
			trace(health);
			
			var bounceSpeed:Number = 10 * damage; // Get knocked back farther the more damage is taken
			
			xVelocity = FP.sign(this.x - enemy.x) * bounceSpeed;
			yVelocity = bounceSpeed * -0.75;
			onTheGround = false;
		}
		
		/* These are useless in light of the "moveBy" function.
		private function applyXTransformation():void
		{
			for (var i:int = 0; i < Math.abs(xVelocity); i++)
			{
				if (xVelocity > 0)
				{
					//Going right
					if (this.collide("wall", x + i, y))
					{
						xVelocity = i - 1;
						break;
					}
				}
				else
				{
					//Going left
					if (this.collide("wall", x - i, y))
					{
						xVelocity = -i + 1;
						break;
					}
				}
			}
			this.x += xVelocity;
		}
		
		private function applyYTransformation():void
		{
			for (var i:int = 0; i <= Math.abs(yVelocity); i++)
			{
				if (yVelocity < 0)
				{
					//Going up
					if (this.collide("wall", x, y - i))
					{
						yVelocity = -i + 1;
						break;
					}
				}
				else
				{
					//Going down
					if (this.collide("wall", x, y + i))
					{
						yVelocity = i - 1;
						break;
					}
				}
			}
			this.y += yVelocity;
		}
		*/
	}
}