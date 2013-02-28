package uk.co.samatkins.yak 
{
	/**
	 * NES-related constants. For now, just the colours.
	 * 
	 * @author Samuel Atkins
	 */
	public class Nes 
	{
		public static const colours:Array = [
			0xff7b7e7f,
			0xff0000fc,
			0xff0000c4,
			0xff4028c4,
			0xff94008c,
			0xffac0028,
			0xffac1000,
			0xff8c1800,
			0xff503000,
			0xff007200,
			0xff005800,
			0xff004058,
			0xffc1c0c1,
			0xff0078fc,
			0xff0088fc,
			0xff6848fc,
			0xffdc00d4,
			0xffe40060,
			0xfffc3800,
			0xffe46018,
			0xffac8000,
			0xff00b800,
			0xff00a800,
			0xff00a848,
			0xff008894,
			0xfffbf8fb,
			0xff38c0fc,
			0xff6888fc,
			0xff9c78fc,
			0xfffc78fc,
			0xfffc589c,
			0xfffc7858,
			0xfffca048,
			0xfffcb800,
			0xffbcf818,
			0xff58d858,
			0xff58f89c,
			0xff00e8e4,
			0xffffffff,
			0xffa9ecec,
			0xffbcb8fc,
			0xffedb8fc,
			0xfff4c0e0,
			0xfffad9a6,
			0xffdcf878,
			0xffb8f878,
			0xffa9ecec,
			0xff00f8fc,
			0xff000000,
			0xff1f1f1f,
			0xff595959
		];
		
		public static function randomColour():uint {
			return Nes.colours[Math.floor(Math.random() * Nes.colours.length)];
		}
		
	}

}