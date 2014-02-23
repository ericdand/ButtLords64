package 
{
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	
	public class Enemy extends Entity
	{
		protected const GRAVITY:Number = 1;
		protected const JUMP_POWER:Number = 10;
		protected const MOVE_SPEED:Number = 3;
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
			
			name = "enemy";
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
					yVelocity += GRAVITY;
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
	}
}
	
