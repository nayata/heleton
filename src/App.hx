import heaps.Scene;
import heaps.Transition;
import heaps.Animate;
import heaps.Screen;
import heaps.Device;


/**
	`App` class is the entry point of your game and takes care of 
	scene updates, transitions, tween animations, and resizing.
**/

class App extends hxd.App {
	public static var ME:App;

	public var scene(default, set):Scene;

	public var transition:heaps.Transition;
	public var tween:heaps.Animate;
	public var screen:Screen;
	public var device:Device;
	

	/** App entry point. **/
	static function main() {
		ME = new App();
	}


	override function init() {
		engine.backgroundColor = 0x222222;
		s2d.defaultSmooth = true;

		hxd.Timer.smoothFactor = 0.4;
		hxd.Timer.wantedFPS = 60;

		#if( hl && debug )
			hxd.Res.initLocal();
		#else
			hxd.Res.initEmbed();
		#end

		transition = new Transition(this);
		tween = new Animate(hxd.Timer.wantedFPS);
		screen = new Screen(1280, 720);
		device = new Device();

		startingScene();
		onResize();
	}


	/** Set your first scene. **/
	function startingScene() {
		scene = new Scene();
	}


	function set_scene(s:Scene) {
		return scene = transition.change(scene, s);
	}


	override function update(dt:Float) {
		super.update(dt);

		Scene.updateAll(hxd.Timer.tmod);
		
		transition.update(dt);
		tween.update(dt);
	}


	override function onResize() {
		super.onResize();

		screen.updateScaling();
		Scene.resizeAll();
		transition.onResize();
	}
}