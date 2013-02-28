package uk.co.samatkins.yak 
{
	import flash.geom.Point;
	import net.flashpunk.Entity;
	import net.flashpunk.Graphic;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.Mask;
	import net.flashpunk.FP;
	import net.flashpunk.tweens.misc.Alarm;
	
	/**
	 * ...
	 * @author Samuel Atkins
	 */
	public class Helicopter extends Entity 
	{
		
		[Embed(source = "../../../../../assets/helicopter.png")] private static const HELICOPTER_PNG:Class;
		
		private var spritemap:Spritemap;
		
		private var vSpeed:Number = 0;
		private var hSpeed:Number = 0;
		private const ACCELERATION:Number = 0.05;
		private const MAX_SPEED:Number = 2;
		
		private var yak:Yak;
		
		private var bombAlarm:Alarm;
		
		public function Helicopter(x:Number=0, y:Number=0) 
		{
			super(x, y);
			
			spritemap = new Spritemap(HELICOPTER_PNG, 16, 8);
			spritemap.add("fly", [0, 1], 10, true);
			spritemap.play("fly");
			graphic = spritemap;
		}
		
		override public function added():void 
		{
			super.added();
			
			var a:Array = new Array;
			world.getClass(Yak, a);
			yak = a[0];
			
			bombAlarm = new Alarm(2 + Math.random() * 2, dropBomb);
			addTween(bombAlarm, true);
		}
		
		override public function update():void 
		{
			super.update();
			
			// Find direction to player
			var acceleration:Point = new Point();
			FP.angleXY(acceleration, FP.angle(x, y, yak.x, yak.y), ACCELERATION);
			
			// Accelerate toward them
			hSpeed += acceleration.x;
			vSpeed += acceleration.y;
			
			// Clamp to maximum speed
			hSpeed = FP.clamp(hSpeed, -MAX_SPEED, MAX_SPEED);
			vSpeed = FP.clamp(vSpeed, -MAX_SPEED, MAX_SPEED);
			
			// Move according to speed
			moveBy(hSpeed, vSpeed);
			
			spritemap.flipped = (hSpeed > 0);
			
			layer = -y;
		}
		
		private function dropBomb():void {
			world.add(new Bomb(x+4, y + Bomb.DROP_HEIGHT));
			bombAlarm.start();
		}
		
	}

}