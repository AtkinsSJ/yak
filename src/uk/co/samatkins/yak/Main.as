package uk.co.samatkins.yak
{
	import net.flashpunk.Engine;
	import net.flashpunk.FP;

	/**
	 * ...
	 * @author Samuel Atkins
	 */
	public class Main extends Engine 
	{
		public function Main():void 
		{
			super(256, 224, 60, false);
			FP.screen.scale = 2;
			FP.screen.color = 0x0;
			
			FP.world = new MenuWorld();
			
			//FP.console.enable();
		}
	}

}