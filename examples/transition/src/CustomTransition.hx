/**
	Custom Transition.
**/
class CustomTransition extends heaps.Transition {
	var image:h2d.Bitmap;


	public function new(a:App) {
		super(a);

		image = new h2d.Bitmap(hxd.Res.bg.toTile());
		image.visible = false;

		app.s2d.add(image, 1);
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

		image.x = -app.screen.width;
		image.visible = true;

		onReady = function() {
			allocated.remove();
			allocated = null;

			app.s2d.add(scene, 0);
			app.sevents.removeScene(app.s2d);
		};

		onEnd = function() {
			app.sevents.addScene(app.s2d);
			scene.onReady();

			image.visible = false;
			working = false;
		};

		app.tween.add(image.x, 0, duration, "easeOut").end(onReady);
		app.tween.add(image.x, app.screen.width, duration, "easeOut", duration+interval).end(onEnd);

		return scene;
	}


	override public function update(delta:Float) {
	}


	override public function onResize() {
		image.width = hxd.Window.getInstance().width;
		image.height = hxd.Window.getInstance().height;
	}


	override public function dispose() {
		super.dispose();

		image.remove();
		image = null;

		onReady = null;
		onEnd = null;
	}
}