import hxd.Key;
import heaps.Screen;
import ui.Button;


class Game extends heaps.Scene {
	var bg:h2d.Bitmap;
	var ui:h2d.Object;

	var exitButton:Button;

	var hero:h2d.Bitmap;
	var body:h2d.Bitmap;

	var walking:Bool = false;
	var bounce:Float = 0;
	var speed:Float = 5;

    
	public function new(?parent:h2d.Object) {
		super(parent);

		bg = new h2d.Bitmap(h2d.Tile.fromColor(0xed145b, Std.int(screen.gameWidth), screen.gameHeight), this);
		bg.tile.setCenterRatio();

		ui = new h2d.Object(this);

		var description = new h2d.Text(hxd.Res.tiltWarp.toFont(), ui);
		description.text = "Use WASD or arrow keys to move\nyour character";
		description.textAlign = h2d.Text.Align.Center;
		description.lineSpacing = -10;
		description.x = 1280 * 0.5;
		description.y = 60;

		exitButton = new Button(ui, exitMenu);
		exitButton.text = "Menu";
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


	function exitMenu(e:hxd.Event) {
		app.scene = new Menu();
	}


	override function update(dt:Float) {
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
	}


	override function onResize() {
		screen.resize(bg, Fit);
		bg.setPosition(screen.x, screen.y);

		screen.resize(ui, Height);
		screen.center(ui);
	}
}