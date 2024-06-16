class Game extends heaps.Scene {
	var myTween:heaps.Animate;
	
	var paused:Bool = false;
	var image:h2d.Bitmap;


	public function new(?parent:h2d.Object) {
		super(parent);

		myTween = new heaps.Animate(hxd.Timer.wantedFPS);

		var description = new h2d.Text(hxd.res.DefaultFont.get(), this);
		description.text = "Press [ESC] to pause";
		description.textAlign = h2d.Text.Align.Center;
		description.x = 640;
		description.y = 60;

		image = new h2d.Bitmap(h2d.Tile.fromColor(0xFF016B, 80, 80), this);
		image.x = image.y = 320;

		repeat();
	}


	function repeat() {
		myTween.add(image.x, 960, 20, "easeOutElastic", 0);
		myTween.add(image.x, 320, 20, "easeOutElastic", 20).end(repeat);
	}


	override function update(dt:Float) {
		if (hxd.Key.isPressed(hxd.Key.ESCAPE)) {
			paused = !paused;
		}

		if (paused) return;

		myTween.update(hxd.Timer.dt);
	}
}