package uk.co.samatkins.yak 
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	import flash.net.URLLoader;
	import net.flashpunk.Graphic;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.World;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Text;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	
	// TODO: Fancy tweening!
	
	/**
	 * ...
	 * @author Samuel Atkins
	 */
	public class HighScoresWorld extends World 
	{
		[Embed(source = "../../../../../assets/loading.png")] private var LOADING_PNG:Class;
		
		
		private var urlLoader:URLLoader;
		private var loading:Spritemap;
		
		
		public function HighScoresWorld() 
		{
			super();
			
		}
		
		override public function begin():void 
		{
			super.begin();
			
			addGraphic(new Text("HIGHSCORES", 0, 0, {
				align: "center",
				width: FP.width
			}), 0, 0, 5);
			
			addGraphic(new Text("PRESS SPACE", 0, 0, {
				align: "center",
				color: 0xffffff,
				width: FP.width
			}), 0, 0, FP.height - 24);
			
			// Send request to server!
			var urlRequest:URLRequest = new URLRequest("http://samatkins.co.uk/games/yak/scores.php?getscores");
			
			urlLoader = new URLLoader();
			urlLoader.addEventListener(IOErrorEvent.IO_ERROR, onURLError);
			urlLoader.addEventListener(Event.COMPLETE, scoresLoaded);
			urlLoader.load(urlRequest);
			
			loading = new Spritemap(LOADING_PNG, 8, 8);
			loading.add("loading", [0, 1, 2], 5, true);
			loading.centerOrigin();
			addGraphic(loading, 0, FP.halfWidth, FP.halfHeight);
			loading.play("loading");
		}
		
		private function onURLError(e:IOErrorEvent):void {
			trace("FAILED TO LOAD SCORES!!!");
			trace(e);
		}
		
		private function scoresLoaded(e:Event):void {
			trace("Loaded scores!");
			loading.visible = false;
			
			var scoreXML:XML = new XML(urlLoader.data);
			trace(scoreXML);
			
			var i:int = 0,
				offset:int = 20;
			
			for each (var score:XML in scoreXML.score) {
				trace(score.@name, score);
				addGraphic(new Text(score.@name, 0, 0, {
					color: 0xffffff
				}), 0, 10, offset + i * 18);
				addGraphic(new Text(score, 0, 0, {
					align: "right",
					color: 0xfcb800,
					width: FP.width - 20
				}), 0, 10, offset + i * 18);
				
				i++;
			}
		}
		
		override public function update():void 
		{
			super.update();
			
			if (Input.pressed(Key.SPACE)) {
				FP.world = new MenuWorld();
			}
		}
		
	}

}