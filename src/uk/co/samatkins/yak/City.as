package uk.co.samatkins.yak 
{
	import net.flashpunk.Entity;
	import net.flashpunk.Graphic;
	import net.flashpunk.graphics.Tilemap;
	import net.flashpunk.Mask;
	import net.flashpunk.masks.Grid;
	import net.flashpunk.FP;
	
	/**
	 * ...
	 * @author Samuel Atkins
	 */
	public class City extends Entity 
	{
		[Embed(source = "../../../../../assets/roads.png")] private const ROADS_PNG:Class;
		public static const TILE_SIZE:int = 8;
		public static const BLOCK_SIZE:int = 6;
		
		private var tiles:Tilemap;
		private var grid:Grid;
		
		private var tilesX:int;
		private var tilesY:int;
		
		private var gameWorld:GameWorld;
		
		public function City(world:GameWorld, blocksAcross:int, blocksDown:int) 
		{
			super(0, 0);
			
			gameWorld = world;
			
			tilesX = (blocksAcross * BLOCK_SIZE) + 1;
			tilesY = (blocksDown * BLOCK_SIZE) + 1;
			var w:int = tilesX * TILE_SIZE;
			var h:int = tilesY * TILE_SIZE;
			
			setHitbox(w,h);
			
			tiles = new Tilemap(ROADS_PNG, w, h, TILE_SIZE, TILE_SIZE);
			
			this.graphic = tiles;
			
			generateCity(blocksAcross, blocksDown);
		}
		
		private function generateCity(blocksAcross:int, blocksDown:int):void {
			

						// City blocks
						//(FP.world as GameWorld).add(new Building(x * TILE_SIZE, y * TILE_SIZE));

			
			// Road tiles
			for (var x:int = 0; x < tilesX; x++) {
				for (var y:int = 0; y < tilesX; y++) {
					if (x % BLOCK_SIZE == 0) {
						if (y % BLOCK_SIZE == 0) {
							tiles.setTile(x, y, 2);
						} else {
							tiles.setTile(x, y, 0);
						}
					} else if (y % BLOCK_SIZE == 0) {
						tiles.setTile(x, y, 1);
					}
					
					if (Math.random() > 0.9) {
						gameWorld.add(new Person(x * TILE_SIZE, y * TILE_SIZE));
					}
				}
			}
			
			// City blocks
			var x1:int, y1:int;
			
			var blockTypes:Array = [
				"houses",
				"offices",
				"industry",
				"towers",
				"parks"
			];
			var sb:ShuffleBag = new ShuffleBag();
			sb.add(0, 5); // houses
			sb.add(1, 2); // offices
			sb.add(2, 1); // industry
			//sb.add(3, 1); // towers
			//sb.add(4, 1); // parks
			
			for (var bx:int = 0; bx < blocksAcross; bx++) {
				for (var by:int = 0; by < blocksDown; by++) {
					x1 = (bx * BLOCK_SIZE) + 1;
					y1 = (by * BLOCK_SIZE) + 1;
					
					// What kind of city block?
					gameWorld.add(new Building(this, blockTypes[sb.next()], x1 * TILE_SIZE, y1 * TILE_SIZE));
					//switch (sb.next()) {
						//case 1: // houses
							//gameWorld.add(new Building(this, x1 * TILE_SIZE, y1 * TILE_SIZE));
							//break;
						//default:
							//break; 
					//}
				}
			}
		}
		
		public function putRubble(tileX:int, tileY:int):void {
			tiles.setTile(tileX, tileY, 3);
		}
	}
}