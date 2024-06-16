package scenes;

import heaps.Screen;


class Intro extends heaps.Scene {
	var bg:h2d.Bitmap;
	var ui:h2d.Object;

    
	public function new(?parent:h2d.Object) {
		super(parent);
		
		bg = new h2d.Bitmap(h2d.Tile.fromColor(0x222222, screen.gameWidth, screen.gameHeight), this);
		bg.tile.setCenterRatio();

		ui = new h2d.Object(this);

		var image = new h2d.Bitmap(hxd.Res.hl.toTile(), ui);
		image.tile.setCenterRatio();
		image.smooth = true;
		image.x = screen.x;
		image.y = screen.y;

		image.scaleX = image.scaleY = 0.1;
		image.alpha = 0;

		tween.add(image.scaleX, 1, 10, "easeOutElastic", 5);
		tween.add(image.scaleY, 1, 10, heaps.Easing.EASE_OUT_ELASTIC, 5);
		tween.add(image.alpha, 1, 5, 5);

		// this is used as a delayed function
		tween.add(image.alpha, 1, 5, 40).remove().end(mainMenu);
	}


	function mainMenu() {
		app.scene = new Menu();
	}


	override function onResize() {
		screen.resize(bg, Fit);
		bg.setPosition(screen.x, screen.y);

		screen.resize(ui, Height);
		screen.center(ui);
	}
}