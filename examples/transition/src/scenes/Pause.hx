package scenes;

import hxd.Key;
import heaps.Screen;
import ui.Button;


class Pause extends heaps.Scene {
	var bg:h2d.Interactive;
	var ui:h2d.Object;

	var resumeButton:Button;
	var exitButton:Button;

	var paused:Bool = false;

    
	public function new(?parent:h2d.Object) {
		super(parent);

		bg = new h2d.Interactive(screen.gameWidth, screen.gameHeight, this);
		bg.backgroundColor = 0xFF222222;
		bg.cursor = null;
		bg.alpha = 0.95;

		ui = new h2d.Object(this);
		
		var frame = new h2d.Bitmap(h2d.Tile.fromColor(0xFF016B, Std.int(screen.gameWidth * 0.33), screen.gameHeight), ui);
		frame.alpha = 0.75;

		var description = new h2d.Text(hxd.Res.tiltWarpLarge.toFont(), ui);
		description.text = "Pause";
		description.textAlign = h2d.Text.Align.Left;
		description.lineSpacing = -10;
		description.x = 60;
		description.y = 150;

		description = new h2d.Text(hxd.Res.tiltWarp.toFont(), ui);
		description.text = "Press [ESC] to resume";
		description.textAlign = h2d.Text.Align.Left;
		description.lineSpacing = -10;
		description.x = 60+2;
		description.y = 232;

		resumeButton = new Button(ui, playGame);
		resumeButton.text = "Resume";
		resumeButton.x = 60; 
		resumeButton.y = 320;

		exitButton = new Button(ui, exitGame);
		exitButton.text = "Main Menu";
		exitButton.x = 60; 
		exitButton.y = 320+72;
	}


	function playGame(e:hxd.Event) {
		close();
	}


	function exitGame(e:hxd.Event) {
		app.scene = new Menu();
	}


	function close() {
		Game.ME.resume();
		this.remove();
	}


	override function update(dt:Float) {
		if (Key.isReleased(Key.ESCAPE)) {
			paused = true;
		}
		if (paused && Key.isDown(Key.ESCAPE)) {
			close();
		}
	}


	override function onResize() {
		bg.width = screen.width;
		bg.height = screen.height;

		screen.resize(ui, Height);
		screen.align(ui, Left, Top);
	}
}