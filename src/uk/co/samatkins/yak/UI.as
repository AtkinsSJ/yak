package uk.co.samatkins.yak 
{
	import net.flashpunk.Entity;
	import net.flashpunk.Graphic;
	import net.flashpunk.graphics.Tilemap;
	import net.flashpunk.Mask;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	
	/**
	 * ...
	 * @author Samuel Atkins
	 */
	public class UI extends Entity 
	{
		[Embed(source = "../../../../../assets/ui.png")] private const UI_PNG:Class;
		
		private var lifetiles:Tilemap;
		private var scoretiles:Tilemap;
		
		private const HEART_TILE:int = 10;
		
		private const HEARTS_WIDTH:int = 5;
		private const SCORE_WIDTH:int = 10;
		
		public function UI() 
		{
			super(0, 0);
			
			var g:Graphic = Image.createRect(FP.width, 8, 0x0, 1);
			g.scrollX = 0;
			g.scrollY = 0;
			addGraphic(g);
			
			lifetiles = new Tilemap(UI_PNG, 8 * HEARTS_WIDTH, 8, 8, 8);
			scoretiles = new Tilemap(UI_PNG, 8 * SCORE_WIDTH, 8, 8, 8);
			
			lifetiles.scrollX = 0;
			lifetiles.scrollY = 0;
			
			scoretiles.scrollX = 0;
			scoretiles.scrollY = 0;
			scoretiles.x = FP.width - scoretiles.width;
			
			addGraphic(lifetiles);
			addGraphic(scoretiles);
			
			layer = -999999;
		}
		
		override public function added():void 
		{
			super.added();
			lifetiles.setRect(0, 0, 5, 1, HEART_TILE);
			scoretiles.setRect(0, 0, 10, 1, 0);
		}
		
		public function setLives(lives:int):void {
			lifetiles.clearRect(lives, 0, (HEARTS_WIDTH - lives), 1);
			
			// TODO: Make hearts flash for a little while!
		}
		
		public function setScore(score:int):void {
			var digits:String = score.toString();
			var offset:int = SCORE_WIDTH - digits.length;
			for (var i:int = 0; i < digits.length; i++) {
				scoretiles.setTile(offset + i, 0, int(digits.charAt(i)));
			}
		}
		
	}

}