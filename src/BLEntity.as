package {
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.Sfx;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	
	import util.EricsUtils;
    
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
			if (state == STANDING && this.collide("wall", x, y + 1)) {
                onTheGround = true;
                yVelocity = 0;
            } else {
                onTheGround = false;
            }
            
            moveBy(xVelocity, yVelocity, "wall");
        }
        
        override public function moveCollideX(e:Entity):Boolean {
            xVelocity = 0;
            return true;
        }
        
        override public function moveCollideY(e:Entity):Boolean {
            yVelocity = 0;
            return true;
        }
		
		override public function moveBy(x:Number, y:Number, solidType:Object = null, sweep:Boolean = false):void
		{
			// Run through a slope
			for (var s:int = 0; s <= MOVE_SPEED + 1; s ++)
			{
				// If we don't hit a solid in the direction we're moving, move.
				if (!collideTypes(solidType, this.x + x, this.y - s)) 
				{
					// Move up the slope.
					y -= s;
					// Stop checking for slope (so we don't fly up into the air).
					break;
				}
			}
			super.moveBy(x, y, solidType, sweep);
		}
        
        public function takeDamage(enemy:Enemy, damage:uint):void {
			health -= damage;
            state = (health > 0 ? DAMAGED : DEAD);
			
            // Get knocked back farther the more damage is taken.
            var bounceSpeed:Number = 10 * damage;
            xVelocity = FP.sign(this.x - enemy.x) * bounceSpeed;
            yVelocity = bounceSpeed * -0.75;
            onTheGround = false;
        }
		
		private function die():void {
			// Stop updating
		}
    
    }
}