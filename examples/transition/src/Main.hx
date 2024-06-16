import scenes.*;

/**
	Custom Transition example.
**/
class Main extends App {
	var myTransition:CustomTransition;

    static function main() {
		App.ME = new Main();
    }

	override function startingScene() {
		// To change default transition:
		//transition.dispose();
		//transition = new CustomTransition(this);

		myTransition = new CustomTransition(this);
		myTransition.duration = 5;
		myTransition.interval = 10;

		scene = new Menu();
	}


	override function set_scene(s:heaps.Scene) {
		return scene = myTransition.change(scene, s);
	}


	override function onResize() {
		super.onResize();

		myTransition.onResize();
	}
}