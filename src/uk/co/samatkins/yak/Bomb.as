package uk.co.samatkins.yak 
{
	import flash.geom.Rectangle;
	import net.flashpunk.Entity;
	import net.flashpunk.Graphic;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.Mask;
	import net.flashpunk.tweens.misc.Alarm;
	import net.flashpunk.tweens.misc.VarTween;
	import net.flashpunk.utils.Ease;
	
	/**
	 * ...
	 * @author Samuel Atkins
	 */
	public class Bomb extends Entity 
	{
		[Embed(source = "../../../../../assets/bomb.png")] private const BOMB_PNG:Class;
		private var spritemap:Spritemap;
		
		private var fallTween:VarTween;
		private var explodeAlarm:Alarm;
		public static const DROP_HEIGHT:Number = 40;
		
		public function Bomb(x:Number=0, y:Number=0) 
		{
			super(x, y);
			this.centerOrigin();
			spritemap = new Spritemap(BOMB_PNG, 8, 8);
			spritemap.add("sizzle", [0, 1, 2, 3], 10, true);
			spritemap.add("flash", [4, 5], 20, true);
			
			graphic = spritemap;
			spritemap.play("sizzle");
			
			fallTween = new VarTween(land);
			addTween(fallTween);
			
			explodeAlarm = new Alarm(1, explode);
			addTween(explodeAlarm);
			
			layer = -y;
		}
		
		override public function added():void 
		{
			super.added();
			
			spritemap.y = -DROP_HEIGHT;
			fallTween.tween(spritemap, "y", 0, 1, Ease.backIn);
		}
		
		private function land():void {
			spritemap.play("flash");
			explodeAlarm.start();
		}
		
		private function explode():void {
			
			var gameWorld:GameWorld = (world as GameWorld);
			gameWorld.emitter.emit("shockwave_ne", x, y);
			gameWorld.emitter.emit("shockwave_nw", x, y);
			gameWorld.emitter.emit("shockwave_se", x, y);
			gameWorld.emitter.emit("shockwave_sw", x, y);
			
			gameWorld.playSound("bang");
			
			// Collide with buildings to damage them
			var collisionRect:Rectangle = new Rectangle(x - 16, y - 16, 32, 32);
			var buildings:Array = new Array();
			
			gameWorld.collideRectInto("building", collisionRect.x, collisionRect.y, collisionRect.width, collisionRect.height, buildings);
			for each (var b:Building in buildings) {
				b.takeDamage(collisionRect);
			}
			
			// Injure the player
			var yak:Yak = (gameWorld.collideRect("yak", collisionRect.x, collisionRect.y, collisionRect.width, collisionRect.height) as Yak);
			if (yak != null) {
				gameWorld.loseLife();
			}
			
			world.remove(this);
		}
		
	}

}