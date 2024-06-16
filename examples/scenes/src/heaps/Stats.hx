package heaps;


/**
	Panel to display the game’s FPS, draw calls, and memory usage. 
**/
class Stats {
	static var panel:Performance;


	/** Add the Stats panel to the top of the display hierarchy. **/
	public static function show() {
		if (panel == null) {
			panel = new Performance();
			App.ME.s2d.add(panel, 2);
		}
	}


	/**	
		Add custom lines to the panel to display information during the update loop.
		Use empty string as separator.
		@param line Label.
		@param v Value to display.
	**/
	public static function add(line:String = "", ?v:Dynamic) {
		if (panel == null) return;

		var string = line == "" ? "\n" : "\n" + line;
		if (v != null) string += " - " + Std.string(v);

		panel.line = panel.line + string;
	}


	/** Remove Stats panel. **/
	public static function hide() {
		if (panel == null) return;

		panel.remove();
		panel = null;
	}
}


class Performance extends heaps.Scene {
	var background:h2d.Bitmap;
	var label:h2d.Text;

	var frame:Int = 0;
	var fps:Float = 0;

	public var line:String = "";


	public function new(?parent:h2d.Object) {
		super(parent);

		background = new h2d.Bitmap(h2d.Tile.fromColor(0x0E0E0E, 100, 70, 0.95), this);

		background.width = 100;
		background.height = 70;

		label = new h2d.Text(hxd.res.DefaultFont.get(), this);
		label.textColor =  0x9C9C9C;
		label.x = label.y = 10;
	}


	override function update(dt:Float) {
		var stats = App.ME.engine.mem.stats();
		var mem = stats.totalMemory / 1024 / 1024;
		
		// Update fps only at 16 ticks to avoid jitter.
		if (hxd.Timer.frameCount - frame > 16) {
			frame = hxd.Timer.frameCount;
			fps = hxd.Timer.fps();
		}

		// TODO: drawCalls - this drawCalls
		var fs = "FPS " + Std.int(fps);
		var ds = "\nDrawCalls " + App.ME.engine.drawCalls;
		var ms = "\nGPU " + Std.int(mem * 10) / 10 + "MB";
		var ls = line == "" ? line : "\n" + line;
		
		label.text = fs + ds +  ms + ls;

		// Clear the line
		line = "";

		background.width = label.textWidth + 20;
		background.height = label.textHeight + 22;

		// Set the panel visibility by pressing the specified key.
		//if (hxd.Key.isPressed(hxd.Key.TAB)) {
			//visible = !visible;
		//}
	}
}