package uk.co.samatkins.yak 
{
	import flash.net.URLRequest;
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Stamp;
	import net.flashpunk.graphics.Text;
	import net.flashpunk.Sfx;
	import net.flashpunk.Tween;
	import net.flashpunk.tweens.misc.VarTween;
	import net.flashpunk.World;
	import net.flashpunk.FP;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	import flash.net.navigateToURL;
	
	/**
	 * ...
	 * @author Samuel Atkins
	 */
	public class MenuWorld extends World 
	{
		[Embed(source = "../../../../../assets/title.png")] private const TITLE_PNG:Class;
		private var text:Text;
		
		public function MenuWorld() 
		{
			super();
			
			// Background
			add(new Entity(0, 0, new Stamp(TITLE_PNG, 0, 0)));
			
			// PRESS START
			text = new Text("PRESS SPACE TO START", 0, 0, { align: "center", width: FP.width } );
			addGraphic(text, 0, 0, FP.height - 40);
			
			addGraphic(new Text("Or H for highscores", 0, 0, {
				align: "center",
				size: 8,
				width: FP.width
			}), 0, 0, FP.height - 20);
			
			addGraphic(new Text("v" + Version.Major + "." + Version.Build, 0, 0, {
				align: "left",
				color: 0x888888,
				size: 8
			}), 0, 2, FP.height - 10);
		}
		
		override public function update():void 
		{
			super.update();
			
			if (Input.pressed(Key.SPACE)) {
				FP.world = new InstructionsWorld();
			} else if (Input.pressed(Key.H)) {
				FP.world = new HighScoresWorld();
			}
			
			if (Input.mousePressed) {
				if (mouseY <= 20) {
					navigateToURL(new URLRequest("http://samatkins.co.uk"), "_blank");
				}
			}
		}
		
	}

}