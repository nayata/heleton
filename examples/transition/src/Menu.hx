import heaps.Screen;
import ui.Button;


class Menu extends heaps.Scene {
	var bg:h2d.Bitmap;
	var ui:h2d.Object;

	var playButton:Button;

    
	public function new(?parent:h2d.Object) {
		super(parent);

		bg = new h2d.Bitmap(h2d.Tile.fromColor(0x36374d, Std.int(screen.gameWidth), screen.gameHeight), this);
		bg.tile.setCenterRatio();

		ui = new h2d.Object(this);

		var image = new h2d.Bitmap(hxd.Res.hl.toTile(), ui);

		playButton = new Button(ui, playGame);
		playButton.text = "PLAY";
		playButton.setSize(236, 68); 
		playButton.y = 246;
	}


	function playGame(e:hxd.Event) {
		app.scene = new Game();
	}


	override function onResize() {
		screen.resize(bg, Fit);
		bg.setPosition(screen.x, screen.y);

		screen.resize(ui, Height);
		screen.align(ui, Center, Center);
	}
}