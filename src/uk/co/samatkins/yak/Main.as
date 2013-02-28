package uk.co.samatkins.yak
{
	import net.flashpunk.Engine;
	import net.flashpunk.FP;
	import flash.system.Security;
	import flash.net.URLRequest;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;

	/**
	 * ...
	 * @author Samuel Atkins
	 */
	public class Main extends Engine 
	{
		public var kongregate:*;
		
		public function Main():void 
		{
			super(256, 224, 60, false);
			FP.screen.scale = 2;
			FP.screen.color = 0x0;
			
			connectKongregate();
			
			FP.world = new MenuWorld();
			
			//FP.console.enable();
		}
		
		private function connectKongregate():void {
			// Pull the API path from the FlashVars
			var paramObj:Object;
			try {
				paramObj = LoaderInfo(root.loaderInfo).parameters;
			} catch (e:*) {
				paramObj = new Object;
			}

			// The API path. The "shadow" API will load if testing locally. 
			var apiPath:String = paramObj.kongregate_api_path || 
			  "http://www.kongregate.com/flash/API_AS3_Local.swf";

			// Allow the API access to this SWF
			Security.allowDomain(apiPath);

			// Load the API
			var request:URLRequest = new URLRequest(apiPath);
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, function(event:Event):void {
				// Save Kongregate API reference
				kongregate = event.target.content;

				// Connect to the back-end
				kongregate.services.connect();
				trace("WE GET KONG SIGNAL!");
			});
			loader.load(request);
			this.addChild(loader);
		}
	}

}