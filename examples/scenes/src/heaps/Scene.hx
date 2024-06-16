package heaps;


/**
	The base object for your game screens, such as splash screens, menus, inventories, pause screens, etc.

	Each scene added to the display has automatic update and onResize events. 
	The onResize event is called once when the scene is added and any time the window is resized.
**/
class Scene extends h2d.Layers {
	static var all:Array<Scene> = [];

	// shortcuts for quick access
	var app(get, never):App; inline function get_app() return App.ME;
	var tween(get, never):heaps.Animate; inline function get_tween() return App.ME.tween;
	var screen(get, never):heaps.Screen; inline function get_screen() return App.ME.screen;
	var device(get, never):heaps.Device; inline function get_device() return App.ME.device;

	var onAddResize:Bool = true;


	public function new(?parent:h2d.Object) {
		if (parent != null) onAddResize = false;
		super(parent);
	}


	override function onAdd() {
		super.onAdd();
		trace('Scene "' + Type.getClassName(Type.getClass(this)).split('.').pop() + '" added');

		if (onAddResize) onResize();
		all.push(this);
	}


	override public function sync(ctx:h2d.RenderContext) {
		if (onAddResize == false) {
			onAddResize = true;
			onResize();
		}

		super.sync(ctx);
	}


	public function onReady() {
		trace("Transition ended");
	}


	public function onLeave() {
		trace("Transition begin");
	}


	function update(dt:Float) {
	}


	function onResize() {
	}


	override function onRemove() {
		super.onRemove();
		trace('Scene "' + Type.getClassName(Type.getClass(this)).split('.').pop() + '" removed');
		
		all.remove(this);
		dispose();
	}


	function dispose() {
	}


	// Public API
	public static function updateAll(dt:Float) {
		for (scene in all) {
			scene.update(dt);
		}
	}


	public static function resizeAll() {
		for (scene in all) {
			scene.onResize();
		}
	}
}