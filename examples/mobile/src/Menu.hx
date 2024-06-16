import heaps.Screen;
import ui.Button;


class Menu extends heaps.Scene {
	var bg:h2d.Bitmap;
	var ui:h2d.Object;

	var playButton:Button;

    
	public function new(?parent:h2d.Object) {
		super(parent);

		bg = new h2d.Bitmap(hxd.Res.bg.toTile(), this);
		bg.tile.setCenterRatio();

		ui = new h2d.Object(this);

		var image = new h2d.Bitmap(hxd.Res.hl.toTile(), ui);
		image.tile.setCenterRatio();
		image.smooth = true;
		image.x = 640; 
		image.y = 200;

		playButton = new Button(ui, playGame);
		playButton.text = "PLAY";
		playButton.setSize(320, 128);
		playButton.x = 490; 
		playButton.y = 460;
	}


	function playGame(e:hxd.Event) {
		app.scene = new Game();
	}

	
	override function onResize() {
		screen.resize(bg, Fit);
		bg.setPosition(screen.x, screen.y);

		screen.resize(ui, Height);
		screen.center(ui);
	}
}