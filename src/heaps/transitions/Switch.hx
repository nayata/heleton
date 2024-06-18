package heaps.transitions;


/**
	Switch  Transition.
	Simple chenges scenes without animation.
**/
class Switch extends heaps.Transition {


	public function new(a:App) {
		super(a);
	}


	override public function change(allocated:heaps.Scene, scene:heaps.Scene) {
		if (allocated == null) {
			app.s2d.add(scene, 0);
			return scene;
		}

		allocated.onLeave();
		allocated.remove();
		allocated = null;

		app.s2d.add(scene, 0);
		scene.onReady();

		return scene;
	}


	override public function update(delta:Float) {
	}
}