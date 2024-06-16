/**
	CustomTransition.
**/
class CustomTransition extends heaps.Transition {


	public function new(a:App) {
		super(a);

		background = new h2d.Bitmap(hxd.Res.cover.toTile());
		app.s2d.add(background, 1);
		
		background.y = -app.screen.height;
		background.visible = false;
	}


	/**
		Set a new scene for the App.

		@param allocated Current scene.
		@param scene New scene.
	**/
	override public function change(allocated:heaps.Scene, scene:heaps.Scene) {
		if (allocated == null) {
			app.s2d.add(scene, 0);
			return scene;
		}

		if (working) return allocated;
		
		working = true;

		background.y = -app.screen.height;
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

		app.tween.add(background.y, 0, duration, "easeOut").end(onReady);
		app.tween.add(background.y, -app.screen.height, duration, "easeOut", duration+interval).end(onEnd);

		return scene;
	}


	override public function update(delta:Float) {
	}


	override public function onResize() {
		background.width = hxd.Window.getInstance().width;
		background.height = hxd.Window.getInstance().height;
	}
}