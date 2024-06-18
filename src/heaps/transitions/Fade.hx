package heaps.transitions;


/**
	Fade Transition.
	Fades new scene alpha from 0 to 1.
**/
class Fade extends heaps.Transition {


	public function new(a:App) {
		super(a);
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

		onEnd = function() {
			allocated.remove();
			allocated = null;

			app.sevents.addScene(app.s2d);
			scene.onReady();

			working = false;
		};

		app.s2d.add(scene, 0);
		app.sevents.removeScene(app.s2d);

		scene.alpha = 0;
		app.tween.add(scene.alpha, 1, 5, "easeOut").end(onEnd);

		return scene;
	}


	override public function update(delta:Float) {
	}
}