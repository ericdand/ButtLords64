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
        
        internal var xVelocity:Number = 0;
        internal var yVelocity:Number = 0;
        internal var onTheGround:Boolean = false;
        internal var health:int = 10;
        internal var state:uint;
        
		/// @TODO: Make a default image
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
		 * Move the entity by (dx, dy), colliding with solidType.
		 * 
		 * A mishmash of the original Entity.moveBy(), Noel Berry's 
		 * Physics.motionx() from his APE library (to make slopes work),
		 * and a home-rolled sweep-checking algorithm.
		 * 
		 * Always sweeps.
		 * 
		 * @param	x			Horizontal offset.
		 * @param	y			Vertical offset.
		 * @param	solidType	An optional collision type to stop flush against.
		 * @param	sweep		Ignored.
		 */
		override public function moveBy(dx:Number, dy:Number, 
				solidType:Object = null, sweep:Boolean = true):void
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
					divisionSize:Number,
					remainder:Number,
					roundedRemainder:int,
					s:int,
					e:Entity;
				
				// Find the longer side of the triangle.
				if (Math.abs(dx) < Math.abs(dy))
				{
					// Greater y velocity: Y is the longer side.
					// Divide the shorter side to have the same number
					// of subdivisions as the longer side has pixels.
					divisionSize = (dx / Math.abs(dy));
					remainder = divisionSize;
					sign = FP.sign(dy);
					
					while (dy != 0)
					{
						// roundedRemainder will always be 0, -1, or 1.
						roundedRemainder = Math.round(remainder);
						// Check for an entity 1 px forward.
						e = collideTypes(solidType,
							this.x + roundedRemainder,
							this.y + sign);
							
						if (e)
						{
							if (tryMoveAndClimb(e, roundedRemainder, sign))
							{							
								// If there is no collision, bravely move on.
								remainder -= roundedRemainder;
								this.x += roundedRemainder;
								this.y += sign;	
							}
							else break;
						}
						else
						{
							remainder -= roundedRemainder;
							this.x += roundedRemainder;
							this.y += sign;
						}
						
						dy -= sign;
						remainder += divisionSize;
					}
				}
				else if (dx != 0)
				{	// Greater or equal x velocity. 
					// We check (dx != 0) to make sure we're moving at all.
					divisionSize = dy / Math.abs(dx);
					remainder = divisionSize;
					sign = FP.sign(dx);
					
					while (dx != 0)
					{
						roundedRemainder = Math.round(remainder);
						 // Check for an entity 1 px forward.
						e = collideTypes(solidType,
							this.x + sign,
							this.y + roundedRemainder);
							
						if (e)
						{
							if (tryMoveAndClimb(e, sign, roundedRemainder))
							{
								remainder -= roundedRemainder;
								this.y += roundedRemainder;
								this.x += sign;
							}
							else break;
						}
						else
						{
							remainder -= roundedRemainder;
							this.y += roundedRemainder;
							this.x += sign;
						}
						
						dx -= sign;
						remainder += divisionSize;
					}
				}
			}
			else
			{
				this.x += x;
				this.y += y;
			}
		}
		
		/**
		 * Checks for collision with an entity, and moves the player up, if
		 * necessary, to climb slopes.
		 * 
		 * This method is a helper for moveBy. It checks if there is a
		 * collision in the x direction, then in the y direction. If there is
		 * a collision in the x direction, it checks if there would be one in
		 * the same position 1px higher. If there is space, it moves the player
		 * up by 1px. This allows the player to climb slopes.
		 * 
		 * @param	e	The entity to collide against.
		 * @param	dx	The distance to move in the x direciton.
		 * @param	dy	The distance to move in the y direction.
		 * @return 	"true" if the player can move, "false" if they collided.
		 */
		private function tryMoveAndClimb(e:Entity, dx:int, dy:int):Boolean
		{
			var retval:Boolean = true;
			
			if (collideWith(e, this.x + dx, this.y)) // Collides in the x direction?
			{
				// Don't collide with platforms in the X direction.
				if (e.type != "platform")
				{
					// Try to climb a slope.
					if (!collideWith(e, this.x + dx, this.y - 1))
					{
						// There was room! Move up 1px into it.
						this.y -= 1;
					}
					else
					{
						xVelocity = 0;
						retval = false;
					}
				}
			}
			if (collideWith(e, this.x, this.y + dy)) // Collides in the y direction?
			{
				if (e.type == "platform")
				{
					// Only collide if moving down.
					if (this.yVelocity >= 0
						&& int(this.y + dy - this.originY + this.height) == int(e.y + 1))
					{
						// Make sure our feet are *on* the platform.
						yVelocity = 0;
						retval = false;
					}
				}
				else
				{
					yVelocity = 0;
					retval = false;
				}
			}
			return retval;
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