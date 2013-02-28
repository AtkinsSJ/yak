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
		
		private static const BUILDINGS:Object = {
			"houses": [
				{
					w: 1,
					h: 1,
					tiles: [0],
					solid: true
				},{
					w: 1,
					h: 1,
					tiles: [1],
					solid: true
				},{
					w: 1,
					h: 1,
					tiles: [16],
					solid: true
				},{
					w: 1,
					h: 1,
					tiles: [17],
					solid: true
				},{
					w: 2,
					h: 2,
					tiles: [32,33,48,49],
					solid: true
				}
			],
			"offices": [
				{
					w: 2,
					h: 2,
					tiles: [2, 3, 18, 19],
					solid: true
				}
			],
			"industry": [
				{
					w: 4,
					h: 4,
					tiles: [
						64, 65, 66, 67,
						80, 81, 82, 83,
						96, 97, 98, 99,
						112, 113, 114, 115
					],
					solid: true
				}
			],
			/*"towers",*/
			"parks": [
				{
					w: 1,
					h: 1,
					tiles: [4],
					solid: false
				},
				{
					w: 1,
					h: 1,
					tiles: [5],
					solid: false
				}
			]
		};
		
		public function Building(city:City, blockType:String, x:Number=0, y:Number=0) 
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
			
			for (x1 = 0; x1 < City.BLOCK_SIZE-1; x1++) {
				for (y1 = 0; y1 < City.BLOCK_SIZE-1; y1++) {
					putBuilding(x1, y1, BUILDINGS[blockType][Math.floor(Math.random() * BUILDINGS[blockType].length)]);
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
		
		private function putBuilding(top:int, left:int, building:Object):Boolean {
			// is there room?
			if ( (building.w + left >= City.BLOCK_SIZE)
				|| (building.h + top >= City.BLOCK_SIZE)) {
				return false;
			}
			
			// Anything in the way?
			var x:int, y:int;
			for (x = left; x < left + building.w; x++) {
				for (y = top; y < top + building.h; y++) {
					if ( tiles.getTile(x, y) != 0 ) {
						return false;
					}
				}
			}
			
			// BUILD IT! :D
			grid.setRect(left, top, building.w, building.h, building.solid);
			for (x = 0; x < building.w; x++) {
				for (y = 0; y < building.h; y++) {
					tiles.setTile(x + left, y + top, building.tiles[y * building.w + x]);
				}
			}
			
			return true;
		}
		
	}

}