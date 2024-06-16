package heaps;


enum ScreenState {
	FADEIN;
	WAITING;
	FADEOUT;
	LOCKED;
}


/**
	Transition between scenes.

	- `duration` Transition fade time.
	- `interval` interval between transitions.
**/
class Transition {
	public var working:Bool = false;

	public var duration:Float = 5;
	public var interval:Float = 2.5;

	var app:App;
	var background:h2d.Bitmap;

	var state:ScreenState = LOCKED;

	var fade:Float = 10;
	var wait:Float = 10;
	var time:Float = 0;

	var onReady:Void->Void;
	var onEnd:Void->Void;
	

	public function new(a:App) {
		app = a;

		background = new h2d.Bitmap(h2d.Tile.fromColor(0, app.s2d.width, app.s2d.height));
		app.s2d.add(background, 1);

		background.visible = false;
	}


	/**
		Set a new scene for the App.

		@param allocated Current scene.
		@param scene New scene.
	**/
	public function change(allocated:heaps.Scene, scene:heaps.Scene) {
		if (allocated == null) {
			app.s2d.add(scene, 0);
			return scene;
		}

		if (working) return allocated;
		
		working = true;

		background.visible = true;
		background.alpha = 0;

		fade = 1 / (duration * hxd.Timer.wantedFPS / 1000);
		wait = interval * hxd.Timer.wantedFPS / 1000;
		time = 0;

		app.sevents.removeScene(app.s2d);
		allocated.onLeave();

		onReady = function() {
			allocated.remove();
			allocated = null;

			app.s2d.add(scene, 0);
			app.sevents.removeScene(app.s2d);
		};

		onEnd = function() {
			app.sevents.addScene(app.s2d);
			scene.onReady();
		};

		state = FADEIN;

		return scene;
	}


	public function update(delta:Float) {
		if (!working) return;

		if (state == FADEOUT) {
			time += fade * delta;

			if (time < 1) {
				background.alpha = 1 + time * -1;
			}
			else {
				background.alpha = 0;
				background.visible = false;

				if (onEnd != null) onEnd();
				onEnd = null;

				working = false;
				state = LOCKED;
			}
		}
		else if (state == WAITING) {
			if (wait > 0) wait -= delta;
			if (wait <= 0) state = FADEOUT;
		}
		else if (state == FADEIN) {
			time += fade * delta;

			if (time < 1) {
				background.alpha = time * 1;
			}
			else {
				background.alpha = 1;

				if (onReady != null) onReady();
				onReady = null;

				state = wait > 0 ? WAITING : FADEOUT;
				time = 0;
			}
		}
	}


	public function onResize() {
		background.width = hxd.Window.getInstance().width;
		background.height = hxd.Window.getInstance().height;
	}


	public function dispose() {
		background.remove();
		background = null;
		onReady = null;
		onEnd = null;
	}
}