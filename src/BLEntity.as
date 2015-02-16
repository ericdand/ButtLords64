package {
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.Sfx;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	
	import util.ButtUtils;
    
    public class BLEntity extends Entity {
        protected const GRAVITY:Number = 1;
        protected const JUMP_POWER:Number = 10;
        protected const MOVE_SPEED:Number = 3;
        
        //"enum" of states
        protected static const STANDING:uint = 1 << 0;
		protected static const ATTACKING:uint = 1 << 1;
        protected static const DAMAGED:uint = 1 << 2;
		protected static const DEAD:uint = 1 << 3;
		protected static const JUMPING:uint = 1 << 4;
        
        protected var xVelocity:Number = 0;
        protected var yVelocity:Number = 0;
        protected var onTheGround:Boolean = false;
        protected var health:int = 10;
        protected var state:uint;
        
		//  TODO: Make a default image
        public function BLEntity() {
            name = "ButtLords64Entity";
            setHitbox(32, 32, -16, 0);
        }
        
        override public function update():void {
			if (state == STANDING && this.collideTypes(Globals.collidableTypes, x, y + 1)) {
                onTheGround = true;
            } 
			else onTheGround = false;
            
            moveBy(xVelocity, yVelocity, Globals.collidableTypes, true);
        }
        
        override public function moveCollideX(e:Entity):Boolean {
            if (e.type == "platform")
			{
				// Don't collide with platforms in the X direction.
				return false;
			}
			
			xVelocity = 0;
            return true;
        }
        
        override public function moveCollideY(e:Entity):Boolean {
            if (e.type == "wall")
			{
				yVelocity = 0;
				return true;
			}
			if (e.type == "platform")
			{
				if (this.yVelocity < 0)
				{
					return false; // Don't collide if moving up.
				}
				else if (int(this.y - this.originY + this.height) == int(e.y - 1))
				{
					 // Make sure our feet are *on* the platform.
					yVelocity = 0;
					return true;
				}
			}
			return false;
        }
		
		/**
		 * A mishmash of the original Entity.moveBy() and Noel Berry's 
		 * Physics.motionx() from his APE library to make slopes work.
		 * 
		 * Always sweeps.
		 * 
		 * @TODO: Currently the player gets stuck in the ground due to the "division" stuff going on. Fix it.
		 * 
		 * @param	x			Horizontal offset.
		 * @param	y			Vertical offset.
		 * @param	solidType	An optional collision type to stop flush against.
		 * @param	sweep		Ignored.
		 */
		override public function moveBy(dx:Number, dy:Number, solidType:Object = null, sweep:Boolean = true):void
		{
			_moveX += dx;
			_moveY += dy;
			dx = Math.round(_moveX);
			dy = Math.round(_moveY);
			_moveX -= dx;
			_moveY -= dy;
			if (solidType)
			{
				var sign:int,
					division:Number,
					s:int,
					e:Entity;
				
				// Find the longer side of the triangle.
				if (Math.abs(dx) < Math.abs(dy)) // greater y velocity.
				{
					// Divide the shorter side to have the same number
					// of subdivisions as the longer side has pixels.
					division = dx / Math.abs(dy);
					sign = FP.sign(dy);
					
					while (dy != 0)
					{
						e = collideTypes(solidType, 
							int(this.x + division), 
							this.y + sign);
							
						if (e)
						{
							if (collideWith(e, this.x + division, this.y) 
								&& moveCollideX(e))
							{
								if (collideWith(e, this.x, this.y + sign))
									moveCollideY(e); // Don't forget to check for y collision too.
								break;
							}
							if (collideWith(e, this.x, this.y + sign) 
								&& moveCollideY(e))
							{
								break;
							}
							// If neither moveCollide function reports
							// a collision, bravely move on.
							this.x += division;
							this.y += sign;
						}
						else
						{
							this.x += division;
							this.y += sign;
						}
						dy -= sign;
					}
				}
				else if (dx != 0) // Greater or equal x velocity. Make sure we're moving at all.
				{
					division = dy / Math.abs(dx);
					sign = FP.sign(dx);
					
					while (dx != 0)
					{
						e = collideTypes(solidType,
							this.x + sign,
							int(this.y + division));
							
						if (e)
						{
							if (collideWith(e, this.x + sign, this.y) 
								&& moveCollideX(e))
							{
								if (collideWith(e, this.x, this.y + division))
									moveCollideY(e); // Don't forget to check for y collision too.
								break;
							}
							if (collideWith(e, this.x, this.y + division) 
								&& moveCollideY(e))
							{
								break;
							}
							// If neither moveCollide function reports
							// a collision, bravely move on.
							this.x += division;
							this.y += sign;
						}
						else
						{
							this.x += sign;
							this.y += division;
						}
						dx -= sign;
					}
				}
			}
			else
			{
				this.x += x;
				this.y += y;
			}
		}
        
        public function takeDamage(enemy:Enemy, damage:uint):void {
			health -= damage;
            state = (health > 0 ? DAMAGED : DEAD);
			
            // Get knocked back farther the more damage is taken.
            xVelocity = FP.sign(this.x - enemy.x) * damage * 16;
            yVelocity = damage * -8;
            onTheGround = false;
			
			if (state == DEAD) {
				die();
			}
        }
		
		public function die():void {
			this.active = false;
		}
    
		// Collision information.
		/** @private */ private var _moveX:Number = 0;
		/** @private */ private var _moveY:Number = 0;
    }
}