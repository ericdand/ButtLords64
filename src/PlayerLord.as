package {
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.Sfx;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	
	import util.EricsUtils;
    
    public class PlayerLord extends BLEntity {
        [Embed(source="assets/ButtLord64.png")]
        private const PLAYER:Class;
        [Embed(source="sound/ow1.mp3")]
        private const OW1:Class;
        [Embed(source="sound/ow2.mp3")]
        private const OW2:Class;
        [Embed(source="sound/ow3.mp3")]
        private const OW3:Class;
		[Embed(source = "sound/spell1.mp3")]
		private const SPELL1:Class;
		[Embed(source = "sound/spell2.mp3")]
		private const SPELL2:Class;
		[Embed(source = "sound/spell3.mp3")]
		private const SPELL3:Class;
		
        private var ow1:Sfx = new Sfx(OW1);
        private var ow2:Sfx = new Sfx(OW2);
        private var ow3:Sfx = new Sfx(OW3);
		private var spell1:Sfx = new Sfx(SPELL1);
		private var spell2:Sfx = new Sfx(SPELL2);
		private var spell3:Sfx = new Sfx(SPELL3);
        
        public function PlayerLord() {
            name = "player";
            
            graphic = new Image(PLAYER);
            setHitbox(26, 64, -14, 0);
        }
        
        override public function update():void {
			if (state == STANDING && this.collide("wall", x, y + 1)) {
                onTheGround = true;
                yVelocity = 0;
            } else {
                onTheGround = false;
            }
			
            if (onTheGround) {
                if (Input.pressed(Key.UP))
                    yVelocity -= JUMP_POWER;
            } else {
                if (yVelocity < 16) {
                    if (Input.check(Key.UP))
                        yVelocity += GRAVITY / 2; // Fall slower while jumping.
                    else
                        yVelocity += GRAVITY;
                }
            }
            
            if (state == STANDING) {
                if (Input.check(Key.RIGHT))
                    xVelocity = MOVE_SPEED;
                else if (Input.check(Key.LEFT))
                    xVelocity = -MOVE_SPEED;
                else
                    xVelocity *= 0.6;
            } else {
                state = STANDING;
            }
            
            moveBy(xVelocity, yVelocity, "wall");
            
            if (Input.mousePressed) {
				EricsUtils.oneOf(spell1, spell2, spell3).play();
				
                var b:Bullet = FP.world.create(Bullet) as Bullet;
            }
        }
        
        override public function takeDamage(enemy:Enemy, damage:uint):void {
            EricsUtils.oneOf(ow1, ow2, ow3).play();
            
            super.takeDamage(enemy, damage);
			
			if (state == DEAD) {
				die();
			}
        }
		
		public function die():void {
			// TODO: Play dying animation and silly sound, prevent control
		}
    
    }
}