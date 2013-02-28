package uk.co.samatkins.yak 
{
	import flash.geom.Rectangle;
	import net.flashpunk.Entity;
	import net.flashpunk.Graphic;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.Mask;
	import net.flashpunk.tweens.misc.VarTween;
	import net.flashpunk.tweens.motion.LinearPath;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	import net.flashpunk.utils.Ease;
	
	/**
	 * ...
	 * @author Samuel Atkins
	 */
	public class Yak extends Entity 
	{
		[Embed(source = "../../../../../assets/yak.png")] private const YAK_PNG:Class;
		
		private var gameWorld:GameWorld;
		
		public var spritemap:Spritemap;
		
		private var playable:Boolean = false; // Whether the player can move around at the moment
		
		private var jumping:Boolean = false;
		private var jumpTween:LinearPath;
		
		private const SPEED:Number = 0.4;
		
		public function Yak(gameWorld:GameWorld, x:Number=0, y:Number=0) 
		{
			super(x, y);
			setHitbox(16, 8, 0, -8);
			type = "yak";
			
			this.gameWorld = gameWorld;
			
			spritemap = new Spritemap(YAK_PNG, 16, 16);
			graphic = spritemap;
			
			// Animation!
			spritemap.add("Still", [0], 0, false);
			spritemap.add("Walk", [0, 1], 5, true);
			spritemap.add("Jump", [2, 3, 3, 3, 3], 5, false);
			spritemap.add("Die", [4], 0, false);
			spritemap.play("Still");
			
			// Jump tween
			jumpTween = new LinearPath(endJump);
			jumpTween.addPoint(0,  1);
			jumpTween.addPoint(0, -8);
			jumpTween.addPoint(0,  0);
			addTween(jumpTween);
		}
		
		override public function added():void 
		{
			super.added();
			
			// Animation of falling from the top of the screen, then calling endJump() to do an explosion
			
			graphic.y = -140;
			var fallTween:VarTween = new VarTween(function():void {
				endJump();
				playable = true;
				gameWorld.startMusic();
			});
			addTween(fallTween);
			fallTween.tween(graphic, "y", 0, 1, Ease.cubeIn);
			layer = -y;
		}
		
		override public function update():void 
		{
			super.update();
			if (!playable) { return; }
			if (jumping) {
				graphic.y = jumpTween.y;
				graphic.x = jumpTween.x;
				return;
			}
			
			var still:Boolean = false;
			
			if (Input.check(Key.LEFT)) {
				spritemap.flipped = false;
				spritemap.play("Walk");
				moveBy( -SPEED, 0, "building");
				still = false;
			} else if (Input.check(Key.RIGHT)) {
				spritemap.flipped = true;
				spritemap.play("Walk");
				moveBy( SPEED, 0, "building");
				still = false;
			} else {
				still = true;
			}
			
			if (Input.check(Key.UP)) {
				spritemap.play("Walk");
				moveBy( 0, -SPEED, "building");
				still = false;
			} else if (Input.check(Key.DOWN)) {
				spritemap.play("Walk");
				moveBy( 0, SPEED, "building");
				still = false;
			} else {
				if (still) {
					spritemap.play("Still");
				}
			}
			
			if (Input.pressed(Key.SPACE)) {
				spritemap.play("Jump");
				jumping = true;
				gameWorld.playSound("jump");
				jumpTween.setMotion(1);
			}
			
			layer = -y;
		}
		
		private function endJump():void {
			jumping = false;
			spritemap.play("Still");
			
			// Send out some shockwaves, probably
			gameWorld.emitter.emit("shockwave_ne", x+5, y+10);
			gameWorld.emitter.emit("shockwave_nw", x+5, y+10);
			gameWorld.emitter.emit("shockwave_se", x+5, y+10);
			gameWorld.emitter.emit("shockwave_sw", x + 5, y + 10);
			
			gameWorld.playSound("crunch");
			
			// Destroy things!
			var buildings:Array = new Array();
			var collisionRect:Rectangle = new Rectangle(x - 8, y - 4, 32, 32);
			gameWorld.collideRectInto("building", collisionRect.x, collisionRect.y, collisionRect.width, collisionRect.height, buildings);
			for each (var b:Building in buildings) {
				b.takeDamage(collisionRect);
			}
		}
		
	}

}