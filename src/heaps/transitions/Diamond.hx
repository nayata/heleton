package heaps.transitions;


enum ScreenState {
	FADEIN;
	WAITING;
	FADEOUT;
	LOCKED;
}


/**
	Diamond Tile Transition.
**/
class Diamond extends heaps.Transition {
	var tiles:Array<h2d.SpriteBatch.BatchElement> = [];
	var batch:h2d.SpriteBatch;

	var tile:h2d.Tile;
	var color:Int = 0x000000;

	var resized:Bool = false;

	var width:Float = 1280;
	var height:Float = 720;
	
	var size:Int = 70;
	var range:Float = 0;
	var step:Float = 0;
	var delay:Float = 0;
	var cell:Float = 0;
	var cx:Int = 0;
	var cy:Int = 0;


	public function new(?c:Int = 0x000000, a:App) {
		super(a);

		color = c;

		tile = h2d.Tile.fromColor(color, 100, 100);
		tile.setCenterRatio();

		batch = new h2d.SpriteBatch(tile);
		batch.hasRotationScale = true;
		batch.visible = false;
		app.s2d.add(batch, 1);

		app.s2d.over(background);
	}


	function rebuild() {
		width = hxd.Window.getInstance().width;
		height = hxd.Window.getInstance().height;

		cx = Math.ceil(width / size) + 1;
		cy = Math.ceil(height / size) + 1;
		
		tiles.resize(0);
		batch.clear();

		for(i in 0...cx) {
			for(j in 0...cy) {
				var element = new h2d.SpriteBatch.BatchElement(tile);

				element.rotation = hxd.Math.degToRad(45);
				element.scaleX = element.scaleY = 0.0;

				element.x = i*size;
				element.y = j*size;

				tiles.push(element);
				batch.add(element);
			}
		}

		resized = false;
	}



	override public function change(allocated:heaps.Scene, scene:heaps.Scene) {
		if (allocated == null) {
			app.s2d.add(scene, 0);
			return scene;
		}

		if (working) return allocated;
		
		working = true;

		if (resized) rebuild();

		background.visible = false;
		batch.visible = true;

		fade = 1 / (duration * hxd.Timer.wantedFPS / 1000);
		wait = interval * hxd.Timer.wantedFPS / 1000;
		step = 1 / duration;
		range = 1 / cx;
		time = 0;

		app.sevents.removeScene(app.s2d);
		allocated.onLeave();

		onReady = function() {
			allocated.remove();
			allocated = null;

			app.s2d.add(scene, 0);
			app.sevents.removeScene(app.s2d);
		};

		onEnd = function() {
			app.sevents.addScene(app.s2d);
			scene.onReady();
		};

		state = FADEIN;

		return scene;
	}


	override public function update(delta:Float) {
		if (!working) return;

		if (state == FADEOUT) {
			time += fade * delta;

			background.alpha = 1 + time * -1;

			if (time < 1) {
				delay = time * 2;

				for (element in tiles){
					cell = Math.ceil(element.x / size);
					cell *= range;
					
					if (cell < delay) {
						if (element.scaleX > 0) element.scaleX = element.scaleY -= step;
						if (element.scaleX < 0.001) element.scaleX = element.scaleY = 0;
					}
				}
			}
			else {
				for (element in tiles){
					element.scaleX = element.scaleY = 0;
				}

				background.alpha = 0;
				background.visible = false;
				batch.visible = false;

				if (onEnd != null) onEnd();
				onEnd = null;

				working = false;
				state = LOCKED;
			}
		}
		else if (state == WAITING) {
			if (wait > 0) wait -= delta;
			if (wait <= 0) state = FADEOUT;
		}
		else if (state == FADEIN) {
			time += fade * delta;

			if (time < 1) {
				background.alpha = time * 1;

				delay = time * 2;

				for (element in tiles){
					cell = Math.ceil(element.x / size);
					cell *= range;
					
					if (cell < delay) {
						if (element.scaleX <= 1) element.scaleX = element.scaleY += step;
					}
				}
			}
			else {
				background.alpha = 1;
				
				for (element in tiles){
					element.scaleX = element.scaleY = 1;
				}

				if (onReady != null) onReady();
				onReady = null;

				state = wait > 0 ? WAITING : FADEOUT;
				time = 0;
			}
		}
	}


	override public function onResize() {
		background.width = hxd.Window.getInstance().width;
		background.height = hxd.Window.getInstance().height;

		if (working) {
			background.visible = true;
			batch.visible = false;
		}
		resized = true;
	}


	override public function dispose() {
		background.remove();
		background = null;

		batch.remove();
		batch = null;

		tiles.resize(0);
		tiles = null;

		onReady = null;
		onEnd = null;
	}
}