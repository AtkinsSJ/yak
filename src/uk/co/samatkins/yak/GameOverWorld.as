package uk.co.samatkins.yak 
{
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	import net.flashpunk.World;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Text;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Samuel Atkins
	 */
	public class GameOverWorld extends World 
	{
		private var nameText:Text;
		private var submitted:Boolean;
		private var score:int;
		
		public function GameOverWorld(score:int) 
		{
			super();
			submitted = false;
			
			this.score = score;
			
			FP.screen.color = 0xff000000;
			
			addGraphic(new Text("GAME OVER", 0, 0, {
				align: "center",
				color: 0xff0000,
				width: FP.width
			}), 0, 0, 10);
			
			addGraphic(new Text("Your illustrious career as a demolition yak has been cut short by some explosives.", 0, 0, {
				align: "center",
				color: 0xffffff,
				width: FP.width,
				wordWrap: true
			}), 0, 0, 40);
			
			addGraphic(new Text("YOUR SCORE:", 0, 0, {
				align: "center",
				color: 0xffffff,
				width: FP.width
			}), 0, 0, 100);
			
			addGraphic(new Text(score.toString(), 0, 0, {
				align: "center",
				color: 0xfcb800,
				width: FP.width
			}), 0, 0, 120);
			
			addGraphic(new Text("ENTER YOUR NAME", 0, 0, {
				align: "center",
				color: 0xffffff,
				width: FP.width
			}), 0, 0, 140);
			
			nameText = new Text("", 0, 0, {
				align: "center",
				color: 0xfcb800,
				width: FP.width
			});
			addGraphic(nameText, 0, 0, 160);
			
			addGraphic(new Text("PRESS ENTER TO SUBMIT SCORE", 0, 0, {
				align: "center",
				color: 0xffffff,
				width: FP.width
			}), 0, 0, FP.height - 40);
			
			Input.keyString = "";
		}
		
		override public function update():void 
		{
			super.update();
			
			nameText.text = Input.keyString;
			
			if (Input.pressed(Key.ENTER)) {
				submitScore();
				FP.world = new MenuWorld();
			}
		}
		
		private function submitScore():void {
			var name:String = nameText.text.slice(0, 32),
				urlLoader:URLLoader = new URLLoader(),
				urlRequest:URLRequest = new URLRequest("http://samatkins.co.uk/games/yak/scores.php"),
				vars:URLVariables = new URLVariables();
			vars.setscore = true;
			vars.name = name;
			vars.score = score;
			urlRequest.data = vars;
			urlLoader.addEventListener(IOErrorEvent.IO_ERROR, trace);
			urlLoader.addEventListener(Event.COMPLETE, trace);
			urlLoader.load(urlRequest);
			
			(FP.engine as Main).kongregate.stats.submit("Highscore", score);
		}
		
	}

}