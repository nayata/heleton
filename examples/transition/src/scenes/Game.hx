package scenes;

import hxd.Key;
import heaps.Screen;
import ui.Button;


class Game extends heaps.Scene {
	public static var ME:Game;

	var bg:h2d.Bitmap;
	var ui:h2d.Object;

	var exitButton:Button;
	
	var paused:Bool = false;

	var hero:h2d.Bitmap;
	var body:h2d.Bitmap;

	var walking:Bool = false;
	var bounce:Float = 0;
	var speed:Float = 5;

    
	public function new(?parent:h2d.Object) {
		super(parent);

		ME = this;

		bg = new h2d.Bitmap(hxd.Res.bg.toTile(), this);
		bg.tile.setCenterRatio();

		ui = new h2d.Object(this);

		var frame:h2d.Bitmap = new h2d.Bitmap(hxd.Res.ui.toTile(), ui);

		var description = new h2d.Text(hxd.Res.tiltWarp.toFont(), ui);
		description.text = "Use WASD or arrow keys to move your character\nPress [ESC] to pause";
		description.textAlign = h2d.Text.Align.Center;
		description.lineSpacing = -10;
		description.x = 1280 * 0.5;
		description.y = 60;

		exitButton = new Button(ui, pauseMenu);
		exitButton.text = "Pause";
		exitButton.x = 1280 * 0.5 - 150;
		exitButton.y = 600;

		hero = new h2d.Bitmap(hxd.Res.shadow.toTile(), ui);
		hero.tile.setCenterRatio();
		hero.smooth = true;
		hero.x = 1280 * 0.5;
		hero.y = 720 * 0.5;

		body = new h2d.Bitmap(hxd.Res.hero.toTile(), hero);
		body.tile.setCenterRatio();
		body.smooth = true;
		body.tile.dy = -60;
	}


	function pauseMenu(e:hxd.Event) {
		pause();
	}


	override function update(dt:Float) {
		if (paused) return;

		walking = false;

		if (Key.isDown(Key.UP) || Key.isDown(Key.W)) { hero.y -= speed; walking = true; }
		if (Key.isDown(Key.DOWN) || Key.isDown(Key.S)) { hero.y += speed; walking = true; }
		if (Key.isDown(Key.LEFT) || Key.isDown(Key.A)) { hero.x -= speed; walking = true; body.tile.xFlip = true; }
		if (Key.isDown(Key.RIGHT) || Key.isDown(Key.D)) { hero.x += speed; walking = true; body.tile.xFlip = false; }

		if (walking) {
			body.scaleX = 1 + Math.sin(bounce += 0.3) * 0.05;
			body.scaleY = 1 - Math.sin(bounce) * 0.05;

			body.y += Math.cos(bounce) * 1.0;
			body.y = Math.min(0, body.y);
		}
		else {
			body.scaleX += (1 - body.scaleX) * 0.5;
			body.scaleY += (1 - body.scaleY) * 0.5;
			body.y += (0 - body.y) * 0.5;
		}

		if (Key.isPressed(Key.ESCAPE)) {
			pause();
		}
	}


	public function pause() {
		var pauseScene = new Pause(this);
		paused = true;
	}

	
	public function resume() paused = false;


	override function dispose() {
		if (ME == this) ME = null;
		trace("Game disposed");
	}


	override function onResize() {
		screen.resize(bg, Fit);
		bg.setPosition(screen.x, screen.y);

		screen.resize(ui, Height);
		screen.center(ui);
	}
}