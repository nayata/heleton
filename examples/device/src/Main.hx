class Main extends App {

    static function main() {
		App.ME = new Main();
    }

	override function startingScene() {
		scene = new Game();
	}
}