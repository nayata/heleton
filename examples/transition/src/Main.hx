/**
	Custom Transition example.
**/
class Main extends App {


	static function main() {
		App.ME = new Main();
    }


	override function startingScene() {
		// dispose current transition
		transition.dispose();


		// add new transition
		transition = new CustomTransition(this);

		// set transition fade time and interval
		transition.duration = 6;
		transition.interval = 3;

		// first scene
		scene = new Menu();
	}
}