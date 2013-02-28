package uk.co.samatkins.yak 
{
	import net.flashpunk.Entity;
	import net.flashpunk.Graphic;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.Mask;
	import net.flashpunk.tweens.misc.VarTween;
	
	/**
	 * ...
	 * @author Samuel Atkins
	 */
	public class Person extends Entity 
	{
		private var moveSpeed:Number;
		private var tween:VarTween;
		private var tweenTarget:Number = 1;
		private var bounceTime:Number;
		private var fleeing:Boolean;
		
		public function Person(x:Number=0, y:Number=0) 
		{
			super(x, y);
			graphic = Image.createRect(1, 3, Nes.randomColour());
			originY = 1;
			
			setHitbox(1, 3);
			
			fleeing = false;
			
			bounceTime = 0.3 + (Math.random() * 0.3);
			moveSpeed = 0.5 + Math.random();
			
			tween = new VarTween(bounce);
			addTween(tween);
			bounce();
		}
		
		override public function update():void
		{
			super.update();
			
			if (fleeing) {
				if (distanceFrom( (world as GameWorld).yak ) > 120) {
					fleeing = false; 
				} else {
					moveTowards((world as GameWorld).yak.x, (world as GameWorld).yak.y, -moveSpeed, "building");
				}
			} else {
				if (distanceFrom( (world as GameWorld).yak ) < 30) {
					fleeing = true;
				}
			}
			
			// TODO: Remove this Person if it's outside the map
			
			layer = -y;
		}
		
		private function bounce():void {
			tweenTarget = (tweenTarget == -1)? 1.5 : -1;
			tween.tween(graphic, "y", tweenTarget, bounceTime);
		}
		
	}

}