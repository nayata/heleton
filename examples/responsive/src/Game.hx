import heaps.Screen;


class Game extends heaps.Scene {
	var back:h2d.Bitmap;

	var board:h2d.Bitmap;
	var coins:h2d.Bitmap;
	var pause:h2d.Bitmap;

	var help:h2d.Bitmap;


	public function new(?parent:h2d.Object) {
		super(parent);

		back = new h2d.Bitmap(h2d.Tile.fromColor(0x00D9FF, 1244, 700), this);
		back.tile.setCenterRatio();

		board = new h2d.Bitmap(h2d.Tile.fromColor(0xFF0062, 514, 548), this);
		coins = new h2d.Bitmap(h2d.Tile.fromColor(0xf6d424, 88, 88), this);
		pause = new h2d.Bitmap(h2d.Tile.fromColor(0x333333, 88, 88), this);

		help = new h2d.Bitmap(h2d.Tile.fromColor(0xFFFFFF, 180, 30), this);
	}


	override function update(dt:Float) {
	}


	override function onResize() {
		var border:Float = 20;

		screen.resize(back, Fit);
		back.x = screen.x;
		back.y = screen.y;

		screen.resize(board, All);
		screen.resize(coins, Height);
		screen.resize(pause, Height);
		screen.resize(help, Height);

		if (screen.orientation == Vertical) {
			screen.scale(board, screen.width * 0.9, 0, Width);
			screen.scale(coins, screen.width * 0.2, 0, Width);
			screen.scale(pause, screen.width * 0.2, 0, Width);
			screen.scale(help, screen.width * 0.4, 0, Width);

			border = screen.width * 0.05;

			if (screen.diagonal < 1.75) {
				screen.scale(board, screen.width * 0.8, 0, Width);
				screen.scale(coins, screen.width * 0.1, 0, Width);
				screen.scale(pause, screen.width * 0.1, 0, Width);
				screen.scale(help, screen.width * 0.25, 0, Width);
			}
		}

		screen.align(board, Center, Center);

		screen.align(coins, Left, Top);
		screen.padding(coins, Left, Top, border);

		screen.align(pause, Right, Top);
		screen.padding(pause, Right, Top, border);

		screen.align(help, Center, Bottom);
		screen.padding(help, Bottom, 20);
	}
}