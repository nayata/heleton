package heaps.transitions;


/**
	Slide Transition.
**/
class Slide extends heaps.Transition {


	public function new(?color:Int = 0x000000, a:App) {
		super(a);

		background.tile = h2d.Tile.fromColor(color, app.s2d.width, app.s2d.height);
		background.smooth = false;
		background.visible = false;
	}


	override public function change(allocated:heaps.Scene, scene:heaps.Scene) {
		if (allocated == null) {
			app.s2d.add(scene, 0);
			return scene;
		}

		if (working) return allocated;
		
		working = true;

		app.sevents.removeScene(app.s2d);
		allocated.onLeave();

		background.x = -app.screen.width;
		background.visible = true;

		onReady = function() {
			allocated.remove();
			allocated = null;

			app.s2d.add(scene, 0);
			app.sevents.removeScene(app.s2d);
		};

		onEnd = function() {
			app.sevents.addScene(app.s2d);
			scene.onReady();

			background.visible = false;
			working = false;
		};

		app.tween.add(background.x, 0, duration, "easeOut").end(onReady);
		app.tween.add(background.x, app.screen.width, duration, "easeOut", duration+interval).end(onEnd);

		return scene;
	}


	override public function update(delta:Float) {
	}
}