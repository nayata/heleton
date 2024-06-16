package ui;

import hxd.Event;
import hxd.Direction;
import h2d.col.Point;


class Joystick extends heaps.Scene {
	var pad:h2d.Bitmap;
	var aim:h2d.Bitmap;

	var base = new Point(0, 0);
	var drag = new Point(0, 0);

	var disabled:Bool = false;
	var touchId:Int = -1;

	public var threshold:Int = 20;
	public var restraint:Int = 50;
	public var radius:Int = 100;

	public var velocity:Point = new Point(0, 0);
	public var direction:Direction = Right;
	public var diagonal:Bool = false;
	public var angle:Float = 0;

	public var up:Bool = false;
	public var down:Bool = false;
	public var left:Bool = false;
	public var right:Bool = false;

	public var touch:Bool = false;
	public var moved:Bool = false;

    
	public function new(padTile:h2d.Tile, aimTile:h2d.Tile, ?parent:h2d.Object) {
		super(parent);

		pad = new h2d.Bitmap(padTile, this);
		pad.tile.setCenterRatio();
		pad.smooth = true;

		aim = new h2d.Bitmap(aimTile, pad);
		aim.tile.setCenterRatio();
		aim.smooth = true;
	}


	public function enable() {
		pad.visible = true;
		disabled = false;
	}


	public function disable() {
		pad.visible = false;
		disabled = true;
	}


	function onEvent(event:Event) {
		if (disabled) return;

		if (event.kind == EPush) {
			onDown(event);
		}
		if (event.kind == EMove) {
			if (event.touchId == touchId) {
				onMove(event);
			}
		}
		if (event.kind == ERelease || event.kind == EReleaseOutside) {
			if (event.touchId == touchId) {
				onUp(event);
			}
		}
	}


	function onDown(event:Event) {
		var focus = app.s2d.getInteractive(base.x, base.y);
		if (focus != null) return;

		base.x = pad.x;
		base.y = pad.y;

		var position = pad.globalToLocal(new Point(event.relX, event.relY));
		var distance = position.distance(new Point(0, 0));

		if (distance <= radius) {
			touchId = event.touchId;
			touch = true;
		}
	}


	function onMove(event:Event) {
		if (touch) {
			drag.x = event.relX;
			drag.y = event.relY;

			var position = pad.globalToLocal(drag);
			var distance = position.distance(new Point(0, 0));

			angle = Math.atan2(position.y-base.y, position.x-base.x);

			if (distance > radius) {
				position.x = Math.cos(angle) * radius;
				position.y = Math.sin(angle) * radius;
			}

			aim.x = position.x;
			aim.y = position.y;

			if (distance > threshold) {
				up = down = left = right = false;

				if (Math.abs(position.x) > Math.abs(position.y)) {
					right = aim.x > 0;
					left = aim.x < 0;

					if (diagonal && Math.abs(position.y) > restraint) {
						up = aim.y < 0;
						down = aim.y > 0;
					}
				}
				else {
					up = aim.y < 0;
					down = aim.y > 0;

					if (diagonal && Math.abs(position.x) > restraint) {
						right = aim.x > 0;
						left = aim.x < 0;
					}
				}

				direction = position.x > 0 ? Right : Left;

				velocity.x = Math.cos(angle);
				velocity.y = Math.sin(angle);

				moved = true;
			}
			else {
				up = down = left = right = false;
				velocity.x = velocity.y = 0;

				moved = false;
			}
		}
	}


	function onUp(event:Event) {
		touchId = -1;

		touch = false;
		moved = false;

		up = down = left = right = false;
		velocity.x = velocity.y = 0;

		aim.x = aim.y = 0;
	}


	override function onAdd() {
		super.onAdd();
		hxd.Window.getInstance().addEventTarget(onEvent);
	}


	override function onRemove() {
		super.onRemove();
		hxd.Window.getInstance().removeEventTarget(onEvent);
	}
}