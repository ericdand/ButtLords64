package {
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.Sfx;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	
	import util.ButtUtils;
    
    public class PlayerLord extends BLEntity {
		
		private var canJump:Boolean = true;
        
        public function PlayerLord() {
            this.name = "player";
            
			spritemap.add("stand", [0]);
			spritemap.add("run", [0, 1], 4);
			this.graphic = spritemap;
			
            setHitbox(26, 55, 0, -9);
        }
        
        override public function update():void 
		{
			if (state == STANDING) 
			{
				var e:Entity = this.collideTypes(Globals.collidableTypes, x, y + 1);
                if (e && (e.type == "wall"
					|| int(this.y - this.originY + this.height) == int(e.y)))
				{
					 // Make sure our feet are *on* the platform.
					onTheGround = true;
				}
				else onTheGround = false;
            } 
			else onTheGround = false;
			
            if (Input.pressed(Key.UP) && onTheGround)
			{
				state = JUMPING;
				yVelocity = -JUMP_POWER;
            }
			if (!onTheGround && state != JUMPING) 
			{
				// Apply gravity.
                if (yVelocity < 16) 
				{
                    if (Input.check(Key.UP))
                        yVelocity += GRAVITY / 2; // Fall slower while jumping.
                    else
                        yVelocity += GRAVITY;
                }
            }
            
            if (state == STANDING) 
			{
                if (Input.check(Key.RIGHT))
				{
                    xVelocity = MOVE_SPEED;
					this.spritemap.play("run");
				}	
                else if (Input.check(Key.LEFT))
				{
                    xVelocity = -MOVE_SPEED;
					this.spritemap.play("run");
				}
                else
				{
                    xVelocity *= 0.6;
					this.spritemap.play("stand");
				}
            } 
			else state = STANDING;
            
            moveBy(xVelocity, yVelocity, Globals.collidableTypes, true);
            
            if (Input.mousePressed) {
				ButtUtils.oneOf(spell1, spell2, spell3).play();
				
                var b:Bullet = FP.world.create(Bullet) as Bullet;
            }
        }
        
        override public function takeDamage(enemy:Enemy, damage:uint):void {
            ButtUtils.oneOf(ow1, ow2, ow3).play();
            
            super.takeDamage(enemy, damage);
        }
		
		/// @private Assets.
        [Embed(source="assets/buttwizard-anim-64.png")]
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
		
		private var spritemap:Spritemap = new Spritemap(PLAYER, 32, 64);
    }
}