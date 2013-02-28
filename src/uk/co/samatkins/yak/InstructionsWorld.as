package uk.co.samatkins.yak 
{
	import net.flashpunk.World;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Text;
	import net.flashpunk.tweens.misc.VarTween;
	import net.flashpunk.Sfx;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	import net.flashpunk.Entity;
	
	/**
	 * ...
	 * @author Samuel Atkins
	 */
	public class InstructionsWorld extends World 
	{
		[Embed(source = "../../../../../assets/start.mp3")] private const START_MP3:Class;
		private var startSfx:Sfx;
		
		private var transitioning:Boolean = false;
		private var text:Text;
		private var fader:VarTween;
		private var blackscreen:Image;
		
		public function InstructionsWorld() 
		{
			super();
			
			startSfx = new Sfx(START_MP3);
			
			addGraphic(new Text("HOW TO PLAY", 0, 0, {
				align: "center",
				color: 0xffffff,
				width: FP.width
			}), 0, 0, 10);
			
			addGraphic(new Text("You are a yak. Wander the city with the arrow keys, wreaking destruction with your powerful jump (spacebar).\nAvoid being blown up.", 0, 0, {
				align: "center",
				color: 0xffffff,
				width: FP.width,
				wordWrap: true
			}), 0, 0, 40);
			
			// PRESS START
			text = new Text("PRESS SPACE TO START", 0, 0, { align: "center", width: FP.width } );
			add(new Entity(0, FP.height - 40, text));
			
			blackscreen =  Image.createRect(FP.width, FP.height, 0x0, 0);
			addGraphic(blackscreen);
			
			fader = new VarTween(play);
			addTween(fader);
		}
		
		override public function update():void 
		{
			super.update();
			
			if (transitioning) {
				text.color = text.color ^ 0x00FFFFFF;
				
			} else if (Input.pressed(Key.SPACE)) {
				// Flash text, fade out, go to game world
				startSfx.play();
				transitioning = true;
				fader.tween(blackscreen, "alpha", 1, 1);
			}
		}
		
		private function play():void {
			trace("Done!");
			FP.world = new GameWorld();
		}
		
	}

}