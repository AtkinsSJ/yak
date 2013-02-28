package uk.co.samatkins.yak 
{
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.Graphic;
	import net.flashpunk.graphics.Emitter;
	import net.flashpunk.graphics.Stamp;
	import net.flashpunk.Sfx;
	import net.flashpunk.tweens.misc.Alarm;
	import net.flashpunk.tweens.misc.VarTween;
	import net.flashpunk.World;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	import net.flashpunk.utils.Ease;
	import net.flashpunk.graphics.Image;
	
	/**
	 * ...
	 * @author Samuel Atkins
	 */
	public class GameWorld extends World 
	{
		[Embed(source = "../../../../../assets/particles.png")] private const PARTICLES_PNG:Class;
		
		[Embed(source = "../../../../../assets/crunch.mp3")] private const CRUNCH_MP3:Class;
		[Embed(source = "../../../../../assets/jump.mp3")] private const JUMP_MP3:Class;
		[Embed(source = "../../../../../assets/bang.mp3")] private const BANG_MP3:Class;
		[Embed(source = "../../../../../assets/ouch.mp3")] private const OUCH_MP3:Class;
		[Embed(source = "../../../../../assets/over.mp3")] private const OVER_MP3:Class;
		[Embed(source = "../../../../../assets/fall.mp3")] private const FALL_MP3:Class;
		private var crunchSfx:Sfx;
		private var jumpSfx:Sfx;
		private var bangSfx:Sfx;
		private var ouchSfx:Sfx;
		private var overSfx:Sfx;
		private var fallSfx:Sfx;
		
		[Embed(source = "../../../../../assets/music.mp3")] private const MUSIC_MP3:Class;
		private var musicSfx:Sfx;
		
		public var yak:Yak;
		private var city:City;
		public var emitter:Emitter;
		public var ui:UI;
		
		public var score:int = 0;
		public var lives:int = 5;
		
		private var helicopterAlarm:Alarm;
		
		private var gameOver:Boolean = false;
		
		private var paused:Boolean = false;
		
		public function GameWorld() 
		{
			super();
			// load sounds
			crunchSfx = new Sfx(CRUNCH_MP3, null, "crunch");
			jumpSfx = new Sfx(JUMP_MP3, null, "jump");
			bangSfx = new Sfx(BANG_MP3, null, "bang");
			ouchSfx = new Sfx(OUCH_MP3, null, "ouch");
			overSfx = new Sfx(OVER_MP3, null, "over");
			fallSfx = new Sfx(FALL_MP3, null, "fall");
			
			musicSfx = new Sfx(MUSIC_MP3, null, "music");
		}
		
		override public function begin():void 
		{
			super.begin();
			emitter = new Emitter(PARTICLES_PNG, 8, 8);
			emitter.newType("shockwave_nw", [0]);
			emitter.newType("shockwave_ne", [1]);
			emitter.newType("shockwave_sw", [2]);
			emitter.newType("shockwave_se", [3]);
			emitter.setMotion("shockwave_nw", 135, 20, 1);
			emitter.setMotion("shockwave_ne",  45, 20, 1);
			emitter.setMotion("shockwave_sw", 225, 20, 1);
			emitter.setMotion("shockwave_se", 315, 20, 1);
			var e:Entity = addGraphic(emitter);
			e.layer = -99999;
			
			city = new City(this, 10, 10);
			add(city);
			
			yak = new Yak(this, FP.halfWidth, FP.halfHeight);
			add(yak);
			
			fallSfx.play();
			
			ui = new UI();
			add(ui);
			ui.setLives(lives);
			ui.setScore(score);
			
			FP.screen.color = 0xff007200;
			
			helicopterAlarm = new Alarm(10, function():void {
				// pick a random map forner for the helicopter to spawn at
				var hx:int = ((Math.random() > 0.5) ? -20 : city.width+20);
				var hy:int = ((Math.random() > 0.5) ? -20 : city.height+20);
				
				add(new Helicopter(hx, hy));
				helicopterAlarm.start();
			});
			
			addTween(helicopterAlarm, true);
		}
		
		override public function update():void 
		{
			if (paused) { return; }
			super.update();
			
			// Make camera follow the player
			camera.x = yak.x - FP.halfWidth;
			camera.y = yak.y - FP.halfHeight;
			if (camera.x < 0) {
				camera.x = 0;
			} else if (camera.x + FP.width > city.width) {
				camera.x = city.width - FP.width;
			}
			
			if (camera.y < 0) {
				camera.y = 0;
			} else if (camera.y + FP.height > city.height) {
				camera.y = city.height - FP.height;
			}
			
			yak.clampHorizontal(0, city.width);
			yak.clampVertical(0, city.height);
			
			// Test code: You die if you press R.
			if (Input.pressed(Key.R)) {
				die();
			}
			
			// This is test code to see if the little people were visible
			//if (Input.mousePressed) {
				//add(new Person(camera.x + Input.mouseX, camera.y + Input.mouseY));
			//}
		}
		
		public function playSound(name:String):void {
			if (name == "crunch") {
				crunchSfx.play();
			} else if (name == "jump") {
				jumpSfx.play();
			} else if (name == "bang") {
				bangSfx.play();
			} else if (name == "ouch") {
				trace("Ouch");
				ouchSfx.play();
			} else if (name == "over") {
				overSfx.play();
			} else if (name == "fall") {
				fallSfx.play();
			}
		}
		
		public function startMusic():void {
			musicSfx.loop();
		}
		
		public function addPoints(points:int):void {
			if (!gameOver) {
				score += points;
				ui.setScore(score);
			}
		}
		
		public function loseLife():void {
			if (!gameOver) {
				lives--;
				ui.setLives(lives);
				
				playSound("ouch");
				
				if (lives == 0) {
					die();
				}
			}
		}
		
		public function die():void {
			trace("Game over");
			gameOver = true;
			
			// Stop music
			musicSfx.stop();
			
			// Play yak death animation
			yak.spritemap.play("Die");
			yak.layer = -99999;
			
			// Freeze game
			var entities:Array = new Array();
			getAll(entities);
			for each (var e:Entity in entities) {
				e.active = false;
			}
			helicopterAlarm.cancel();
			
			// Play sad death sound
			overSfx.play();
			
			// Yak fall
			var deathTween:VarTween = new VarTween();
			addTween(deathTween);
			deathTween.tween(yak.spritemap, "y", 200, 2, Ease.backIn);
			
			// Fade to black
			var black:Image = Image.createRect(FP.width, FP.height, 0x0, 0);
			black.scrollX = 0;
			black.scrollY = 0;
			addGraphic(black, -9999999);
			var fadeTween:VarTween = new VarTween(function():void {
				// Go to game over world
				FP.world = new GameOverWorld(score);
			});
			addTween(fadeTween);
			fadeTween.tween(black, "alpha", 1, 2);
		}
		
		override public function focusLost():void 
		{
			super.focusLost();
			paused = true;
		}
		
		override public function focusGained():void 
		{
			super.focusGained();
			paused = false;
		}
		
	}

}