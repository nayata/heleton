package scenes;

import heaps.Screen;
import ui.Button;


class Menu extends heaps.Scene {
	var bg:h2d.Bitmap;
	var ui:h2d.Object;

	var playButton:Button;
	var screenButton:Button;
	var exitButton:Button;

	var dimensions = ["1280x720", "960x540", "1600x900", "Fullscreen"];
	static var resolution:Int = 0;

    
	public function new(?parent:h2d.Object) {
		super(parent);

		bg = new h2d.Bitmap(hxd.Res.bg.toTile(), this);
		bg.tile.setCenterRatio();

		ui = new h2d.Object(this);

		var frame = new h2d.Bitmap(hxd.Res.ui.toTile(), ui);

		var image = new h2d.Bitmap(hxd.Res.hl.toTile(), ui);
		image.tile.setCenterRatio();
		image.smooth = true;
		image.x = 640; 
		image.y = 200;

		playButton = new Button(ui, playGame);
		playButton.text = "PLAY";
		playButton.x = 490; 
		playButton.y = 350+72;

		screenButton = new Button(ui, resizeWindow);
		screenButton.text = dimensions[resolution];
		screenButton.x = 490; 
		screenButton.y = 350+72*2;

		exitButton = new Button(ui, exitGame);
		exitButton.text = "Exit";
		exitButton.x = 490; 
		exitButton.y = 350+72*3;
	}


	function playGame(e:hxd.Event) {
		app.scene = new Game();
	}


	function exitGame(e:hxd.Event) {
		hxd.System.exit();
	}


	function resizeWindow(e:hxd.Event) {
		if (++resolution > 3) resolution = 0;

		if (resolution == 0) {
			app.engine.fullScreen = false;
			hxd.Window.getInstance().resize(1280, 720);
		}

		if (resolution == 1) hxd.Window.getInstance().resize(960, 540);
		if (resolution == 2) hxd.Window.getInstance().resize(1600, 900);
		if (resolution == 3) app.engine.fullScreen = true;
		
		screenButton.text = dimensions[resolution];
	}


	override function update(dt:Float) {
	}


	override function onResize() {
		screen.resize(bg, Fit);
		bg.setPosition(screen.x, screen.y);

		screen.resize(ui, Height);
		screen.center(ui);
	}
}