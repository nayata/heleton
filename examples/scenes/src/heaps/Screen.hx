package heaps;


enum Scale {
	All;
	Fit;
	Width;
	Height;
	Stretch;
}

enum Side {
	Top;
	Right;
	Center;
	Bottom;
	Left;
}

enum Orientation {
	Horisontal;
	Vertical;
}


/**
	A set of functions for creating responsive game design.
**/
class Screen {
	// logical width and height
	public var gameWidth:Int = 1280;
	public var gameHeight:Int = 720;

	// window width and height
	public var width:Int = 1280;
	public var height:Int = 720;

	// center of the window
	public var x:Int = 640;
	public var y:Int = 360;

	public var orientation:Orientation = Horisontal;
	public var diagonal:Float = 0;
	public var scaling:Float = 1;
	

	public function new(w:Int, h:Int) {
		gameWidth = w;
		gameHeight = h;
	}


	public function updateScaling() {
		width = hxd.Window.getInstance().width;
		height = hxd.Window.getInstance().height;

		x = Std.int(width * 0.5);
		y = Std.int(height * 0.5);

		orientation = width > height ? Horisontal : Vertical;
		diagonal = orientation == Horisontal ? width / height : height / width;
		scaling = width / gameWidth;
	}


	/**
		Resize `object` using `Scale` mode to resize.

		@param object object to resize.
		@param mode `Scale` mode to resize `object`.
	**/
	public function resize(object:h2d.Object, mode:Scale) {
		var upscale:Float = 1;

		switch (mode) {
			case All:
				upscale = Math.min(width / gameWidth, height / gameHeight);
			case Fit:
				upscale = Math.max(width / gameWidth, height / gameHeight);
			case Width:
				upscale = width / gameWidth;
			case Height:
				upscale = height / gameHeight;
			default:
		}

		object.setScale(upscale);
	}


	/**
		Scale `object` to the specified area, using `Scale` mode for resizing.

		@param object The object to scale.
		@param wid The width of the area to scale `object` to.
		@param hei The height of the area to scale `object` to.
		@param mode The `Scale` mode for scaling `object`.
	**/
	public function scale(object:h2d.Object, wid:Float, hei:Float, mode:Scale) {
		object.setScale(1);

		var bound = object.getBounds();

		var w:Float = bound.width;
		var h:Float = bound.height;

		switch (mode) {
			case All:
				object.setScale(Math.min(wid / w, hei / h));
			case Fit:
				object.setScale(Math.max(wid / w, hei / h));
			case Width:
				object.setScale(wid / w);
			case Height:
				object.setScale(hei / h);
			case Stretch:
				object.scaleX = wid / w;
				object.scaleY = hei / h;
			default:
		}
	}


	/**
		Align `object` within the window using the specified sides.

		@param object object to align.
		@param horisontal horizontal side to align.
		@param vertical vertical side to align.
		@param pivotX real or virtual horizontal anchor for positioning `object`.
		@param pivotY real or virtual vertical anchor for positioning `object`.
	**/
	public function align(object:h2d.Object, horisontal:Side, vertical:Side, pivotX:Float = 0, pivotY:Float = 0) {
		var bound = object.getBounds();

		switch (horisontal) {
			case Left:
				object.x = 0 + bound.width * pivotX;
			case Center:
				object.x = x - bound.width * 0.5 + bound.width * pivotX;
			case Right:
				object.x = width - bound.width + bound.width * pivotX;
			default:
		}
		switch (vertical) {
			case Top:
				object.y = 0 + bound.height * pivotY;
			case Center:
				object.y = y - bound.height * 0.5 + bound.height * pivotY;
			case Bottom:
				object.y = height - bound.height + bound.height * pivotY;
			default:
		}
	}


	/**
		Align `object` to specified sides using percentage values.
		Equivalent of: object.x = window width * horisontal value;

		@param object object to align.
		@param horisontal horizontal side to align.
		@param vertical vertical side to align.
		@param pivotX real or virtual horizontal anchor for positioning `object`.
		@param pivotY real or virtual vertical anchor for positioning `object`.
	**/
	public function place(object:h2d.Object, horisontal:Float, vertical:Float, pivotX:Float = 0, pivotY:Float = 0) {
		var bound = object.getBounds();

		var w:Float = width * horisontal;
		var h:Float = height * vertical;

		object.x = w - bound.width * pivotX;
		object.y = h - bound.height * pivotY;
	}


	/**
		Attach `object` to another `target` object on the specified sides.

		@param object object to atach.
		@param target target to which `object` will be attached.
		@param horisontal horizontal side to atach.
		@param vertical vertical side to atach.
		@param pivotX real or virtual horizontal anchor for positioning `object`.
		@param pivotY real or virtual vertical anchor for positioning `object`.
	**/
	public function atach(object:h2d.Object, target:h2d.Object, horisontal:Side, vertical:Side, pivotX:Float = 0, pivotY:Float = 0) {
		var folow = target.getBounds();
		var bound = object.getBounds();

		switch (horisontal) {
			case Left:
				object.x = folow.x + bound.width * pivotX;
			case Center:
				object.x = folow.x + folow.width * 0.5 - bound.width * 0.5 + bound.width * pivotX;
			case Right:
				object.x = folow.x + folow.width - bound.width + bound.width * pivotX;
			default:
		}
		switch (vertical) {
			case Top:
				object.y = folow.y + bound.height * pivotY;
			case Center:
				object.y = folow.y + folow.height * 0.5 - bound.height * pivotY;
			case Bottom:
				object.y = folow.y + folow.height - bound.height * pivotY;
			default:
		}
	}


	/**
		Set `object` padding.

		@param sideOne side for the padding.
		@param sideTwo optional second side for the padding.
		@param padOne padding value.
		@param padTwo optional second side for the padding. If this is `null`, `padOne` will be used as the default value.
	**/
	public function padding(object:h2d.Object, sideOne:Side, ?sideTwo:Side, padOne:Float, ?padTwo:Float) {
		inline function setPadding(object:h2d.Object, position:Side, value:Float) {
			switch (position) {
				case Left:
					object.x += value;
				case Right:
					object.x -= value;
				case Top:
					object.y += value;
				case Bottom:
					object.y -= value;
				default:
			}
		}

		setPadding(object, sideOne, padOne);
		
		if (sideTwo != null) {
			setPadding(object, sideTwo, padTwo == null ? padOne : padTwo);
		}
	}


	/**
		Centers the `object` using its logical center point rather than one calculated from its bounds.
	**/
	public function center(object:h2d.Object) {
		var point = new h2d.col.Point(0, 0);
		var upscale:Float = object.scaleX;

		point.x = Std.int(x - (gameWidth * upscale) * 0.5);
		point.y = Std.int(y - (gameHeight * upscale) * 0.5);

		object.setPosition(point.x, point.y);
	}


	/**
		Returns `h2d.col.Bounds` calculated from the projection of `object` onto the window.
	**/
	public function bounds(object:h2d.Object):h2d.col.Bounds {
		var bound = new h2d.col.Bounds();

		var min = object.globalToLocal(new h2d.col.Point(0, 0));
		var max = object.globalToLocal(new h2d.col.Point(width, height));

		bound.x = min.x;
		bound.y = min.y;
		bound.width = max.x;
		bound.height = max.y;

		return bound;
	}
}