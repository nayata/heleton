class Main extends App {

    static function main() {
		App.ME = new Main();
    }

	override function startingScene() {
		s2d.defaultSmooth = true;

		screen.gameWidth = 1244;
		screen.gameHeight = 700;

		scene = new Game();
	}
}