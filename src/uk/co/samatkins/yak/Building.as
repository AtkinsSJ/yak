package uk.co.samatkins.yak 
{
	import flash.geom.Rectangle;
	import net.flashpunk.Entity;
	import net.flashpunk.Graphic;
	import net.flashpunk.graphics.Stamp;
	import net.flashpunk.graphics.Tilemap;
	import net.flashpunk.Mask;
	import net.flashpunk.masks.Grid;
	
	/**
	 * ...
	 * @author Samuel Atkins
	 */
	public class Building extends Entity 
	{
		[Embed(source = "../../../../../assets/buildings.png")] private static const BUILDINGS_PNG:Class;
		
		private var tiles:Tilemap;
		private var grid:Grid;
		private var city:City;
		
		private var tileX:int;
		private var tileY:int;
		
		private static const POINTS_PER_TILE:int = 10;
		
		private static const ONE_BUILDINGS:Array = [0, 1, 4, 5];
		private static const TWO_BUILDINGS:Array = [
			[2, 3, 6, 7],
			[8, 9, 12, 13]
		];
		
		public function Building(city:City, x:Number=0, y:Number=0, blockType:String) 
		{
			super(x, y);
			
			this.city = city;
			
			type = "building";
			
			tileX = x / City.TILE_SIZE;
			tileY = y / City.TILE_SIZE;
			
			tiles = new Tilemap(BUILDINGS_PNG, City.TILE_SIZE * (City.BLOCK_SIZE - 1), City.TILE_SIZE * (City.BLOCK_SIZE - 1), 8, 8);
			grid = new Grid(City.TILE_SIZE * (City.BLOCK_SIZE - 1), City.TILE_SIZE * (City.BLOCK_SIZE - 1), 8, 8);
			
			// Place buildings
			var x1:int, y1:int;
			
			// 2x2
			for (x1 = 0; x1 < City.BLOCK_SIZE-2; x1++) {
				for (y1 = 0; y1 < City.BLOCK_SIZE-2; y1++) {
					
					if (Math.random() < 0.2) {
						if ( !grid.getTile(x1, y1) && !grid.getTile(x1 + 1, y1)
							&& !grid.getTile(x1, y1 + 1) && !grid.getTile(x1 + 1, y1 + 1) ) {
							
							var building:int = Math.floor(Math.random() * TWO_BUILDINGS.length);
							tiles.setTile(x1, y1, TWO_BUILDINGS[building][0]);
							tiles.setTile(x1+1, y1, TWO_BUILDINGS[building][1]);
							tiles.setTile(x1, y1+1, TWO_BUILDINGS[building][2]);
							tiles.setTile(x1 + 1, y1 + 1, TWO_BUILDINGS[building][3]);
							
							grid.setRect(x1, y1, 2, 2, true);
						}
					}
				}
			}
			
			// 1x1
			for (x1 = 0; x1 < City.BLOCK_SIZE-1; x1++) {
				for (y1 = 0; y1 < City.BLOCK_SIZE-1; y1++) {
					if (!grid.getTile(x1, y1) && Math.random() < 0.65) {
						tiles.setTile(x1, y1, ONE_BUILDINGS[Math.floor(Math.random() * ONE_BUILDINGS.length)]);
						grid.setTile(x1, y1, true);
					}
				}
			}
			
			graphic = tiles;
			mask = grid;
			
			layer = -y;
		}
		
		public function takeDamage(area:Rectangle):void {
			var intersector:Rectangle = new Rectangle(x,y, City.TILE_SIZE, City.TILE_SIZE);
			for (var x1:int = 0; x1 < City.BLOCK_SIZE-1; x1++) {
				intersector.x = x + (x1 * City.TILE_SIZE);
				for (var y1:int = 0; y1 < City.BLOCK_SIZE-1; y1++) {
					intersector.y = y + (y1 * City.TILE_SIZE);
					if (grid.getTile(x1, y1) && area.intersects(intersector)) {
						tiles.clearTile(x1, y1);
						grid.setTile(x1, y1, false);
						city.putRubble(tileX + x1, tileY + y1);
						(world as GameWorld).addPoints(POINTS_PER_TILE);
					}
				}
			}
		}
		
	}

}