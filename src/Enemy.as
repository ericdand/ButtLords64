package 
{
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	
	public class Enemy extends Entity
	{
		protected const gravity:Number = 1;
		protected const jumpPower:Number = 10;
		//"enum" of states
		protected static const STANDING:uint = 0;
		protected static const ATTACKING:uint = 1;
		
		protected var xVelocity:Number = 0;
		protected var yVelocity:Number = 0;
		protected var onTheGround:Boolean = false;
		protected var state:uint = STANDING;
		
		protected var player:PlayerLord;
		
		public function Enemy()
		{
			super();
		}
		
		override public function update():void
		{
			super.update();
			
			if (this.collide("wall", x, y + 1))
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
			}
			else
			{
				if (yVelocity < 16)
				{
					yVelocity += gravity;
				}
			}
			
			//if (Input.check(Key.RIGHT)) xVelocity = 5;
			//else if (Input.check(Key.LEFT)) xVelocity = -5;
			//else xVelocity *= 0.6;
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
		
		/* These are useless in light of the "moveBy" function.
		protected function applyXTransformation():void
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
		
		protected function applyYTransformation():void
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
	
