import hxd.Key;
import h2d.col.Point;
import h2d.col.Bounds;
import heaps.Screen;

import ui.Button;
import ui.Joystick;


class Game extends heaps.Scene {
	public static var ME:Game;

	var bg:h2d.Bitmap;
	var level:h2d.Object;

	var description:h2d.Text;

	var pauseScene:Pause;
	var pauseButton:Button;
	var paused:Bool = false;

	var hero:h2d.Bitmap;
	var body:h2d.Bitmap;

	var bound:h2d.col.Bounds;

	var direction = new Point(0, 0);
	var walking:Bool = false;
	var bounce:Float = 0;

	var reload:Float = 0;
	var speed:Float = 5;

	var pad:Joystick;
	var aim:Joystick;

	var showStats:Bool = false;

    
	public function new(?parent:h2d.Object) {
		super(parent);

		ME = this;

		bg = new h2d.Bitmap(hxd.Res.bg.toTile(), this);
		bg.tile.setCenterRatio();

		level = new h2d.Object(this);

		hero = new h2d.Bitmap(hxd.Res.shadow.toTile(), level);
		hero.tile.setCenterRatio();
		hero.smooth = true;
		hero.x = 1280 * 0.5;
		hero.y = 720 * 0.5;

		body = new h2d.Bitmap(hxd.Res.hero.toTile(), hero);
		body.tile.setCenterRatio();
		body.smooth = true;
		body.tile.dy = -60;

		description = new h2d.Text(hxd.Res.tiltWarp.toFont(), this);
		description.textAlign = h2d.Text.Align.Center;
		description.lineSpacing = -10;
		description.x = 1280 * 0.5;
		description.y = 60;

		pauseButton = new Button(this, pauseMenu);
		pauseButton.text = "||";
		pauseButton.setSize(80, 80);
		pauseButton.x = screen.gameWidth - 80;
		pauseButton.y = 0;

		bound = screen.bounds(level);

		pad = new Joystick(hxd.Res.pad.toTile(), hxd.Res.tip.toTile(), this);
		aim = new Joystick(hxd.Res.pad.toTile(), hxd.Res.aim.toTile(), this);

		if (!device.mobile) {
			description.text = "Use WASD or arrow keys to move and mouse to shoot";
			description.text += "\nPress [TAB] to show Stats panel";
			description.text += "\nPress [ESC] to pause";

			pad.disable();
			aim.disable();
		}

		pauseScene = new Pause(this);
		pauseScene.visible = false;
	}


	override function update(dt:Float) {
		// check pause
		if (Key.isPressed(Key.ESCAPE)) togglePause();
		if (paused) return;

		// reset movement
		direction.x = direction.y = 0;
		walking = false;

		// weapon reload
		if (reload > 0) reload -= 1 * dt;

		// desktop movement
		if (Key.isDown(Key.UP) || Key.isDown(Key.W)) { direction.y = -1; walking = true; }
		if (Key.isDown(Key.DOWN) || Key.isDown(Key.S)) { direction.y = 1; walking = true; }
		if (Key.isDown(Key.LEFT) || Key.isDown(Key.A)) { direction.x = -1; walking = true; body.tile.xFlip = true; }
		if (Key.isDown(Key.RIGHT) || Key.isDown(Key.D)) { direction.x = 1; walking = true; body.tile.xFlip = false; }

		direction.normalize();
		direction.scale(speed);

		hero.x += direction.x * dt;
		hero.y += direction.y * dt;

		// desktop shooting
		// TODO: check interactives in the mouse position
		if (Key.isDown(Key.MOUSE_LEFT) && !device.mobile) {
			var position = level.globalToLocal(new Point(app.s2d.mouseX, app.s2d.mouseY));
			var angle = Math.atan2(position.y - hero.y + 35, position.x - hero.x);

			if (position.x < hero.x) body.tile.xFlip = true;
			if (position.x > hero.x) body.tile.xFlip = false;

			if (reload <= 0) {
				shoot(angle);
				reload = 15;
			}
		}

		// mobile movement
		if (pad.moved) {
			walking = true;

			hero.x += pad.velocity.x * speed * dt;
			hero.y += pad.velocity.y * speed * dt;

			if (!aim.moved) {
				if (pad.direction == Left) body.tile.xFlip = true;
				if (pad.direction == Right) body.tile.xFlip = false;
			}
		}

		// mobile shooting
		if (aim.moved && reload <= 0) {
			shoot(aim.angle);
			reload = 15;

			if (aim.direction == Left) body.tile.xFlip = true;
			if (aim.direction == Right) body.tile.xFlip = false;
		}

		// Check stage bounds
		if (hero.x <= bound.x + 40) hero.x = bound.x + 40;
		if (hero.x >= bound.width - 40) hero.x = bound.width - 40;
		if (hero.y <= bound.y + 80) hero.y = bound.y + 80;
		if (hero.y >= bound.height-10) hero.y = bound.height-10;

		// movement animation
		if (walking) {
			body.scaleX = 1 + Math.sin(bounce += 0.3 * dt) * 0.05 * dt;
			body.scaleY = 1 - Math.sin(bounce) * 0.05 * dt;

			body.y += Math.cos(bounce) * 1.0 * dt;
			body.y = Math.min(0, body.y);
		}
		else {
			body.scaleX += (1 - body.scaleX) * 0.5 * dt;
			body.scaleY += (1 - body.scaleY) * 0.5 * dt;
			body.y += (0 - body.y) * 0.5 * dt;
		}

		// update world
		Bullet.updateAll(dt);

		// display total bullets
		if (Key.isReleased(Key.TAB)) toggleStats();
		heaps.Stats.add("Bullets", Bullet.all.length);
	}


	function shoot(angle:Float) {
		var bullet = new Bullet(level);
		
		bullet.x = hero.x + Math.cos(angle) * 50;
		bullet.y = hero.y - 35 + Math.sin(angle) * 50;
		bullet.rotation = angle;

		bullet.velocity.x = Math.cos(angle);
		bullet.velocity.y = Math.sin(angle);

		bullet.speed = 20;
		bullet.life = 80;
	}


	// Pause handlers
	function pauseMenu(e:hxd.Event) {
		togglePause();
	}


	public function pause() paused = true;
	public function resume() paused = false;


	public function togglePause() {
		if (paused) {
			pauseScene.visible = false;
			resume();
		}
		else {
			pauseScene.visible = true;
			pause();
		}
	}


	// Show/hide Stats
	public function toggleStats() {
		if (showStats) {
			showStats = false;
			heaps.Stats.hide();
		}
		else {
			showStats = true;
			heaps.Stats.show();
		}
	}


	override function dispose() {
		if (ME == this) ME = null;
		trace("Game disposed");

		Bullet.all.resize(0);
		heaps.Stats.hide();
	}


	override function onResize() {
		screen.resize(bg, Fit);
		bg.setPosition(screen.x, screen.y);

		// resize level first
		// TODO: set another zoom if (device.mobile); 
		screen.resize(level, Width);
		screen.center(level);

		// and update `level to screen` bounds
		bound = screen.bounds(level);

		// ui resize
		screen.resize(description, Height);
		screen.align(description, Center, Top, 0.5, 0.5);

		screen.resize(pauseButton, Height);
		screen.align(pauseButton, Right, Top);

		// joysticks resize
		if (device.mobile) {
			// if the device is a phone
			var upscale:Float = screen.height * 0.36;

			// if the devise is a tablet
			if (screen.diagonal < 1.75) upscale = screen.height * 0.2;

			screen.scale(pad, upscale, 0, Fit);
			screen.scale(aim, upscale, 0, Fit);

			// pause mobile resize
			screen.scale(pauseButton, screen.height * 0.175, 0, Fit);
			screen.align(pauseButton, Right, Top);
		}

		screen.align(pad, Left, Bottom, 0.5, 0.5);
		screen.align(aim, Right, Bottom, 0.5, 0.5);

		screen.padding(pad, Left, Bottom, 60);
		screen.padding(aim, Right, Bottom, 60);
	}
}


class Bullet extends h2d.Object {
	public static var all:Array<Bullet> = [];

	public var velocity:Point = new Point(0, 0);
	public var speed:Float = 3;

	public var alive:Bool = true;
	public var life:Float = 10;
	

	public function new(?parent:h2d.Object) {
		super(parent);

		var image = new h2d.Bitmap(h2d.Tile.fromColor(0xFFFFFF, 40, 40), this);
		image.tile.setCenterRatio();
		
		all.push(this);
	}


	public function update(dt:Float) {
		x += velocity.x * speed * dt;
		y += velocity.y * speed * dt;

		life -= 1 * dt;

		if (life < 0) alive = false;
	}


	public static function updateAll(dt:Float) {
		for (bullet in all) {
			bullet.update(dt);
		}
		for (bullet in all) {
			if (!bullet.alive) {
				all.remove(bullet);
				bullet.remove();
			}
		}
	}
}