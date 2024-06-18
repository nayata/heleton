package ui;


class Button extends h2d.Object {
	var input:h2d.Interactive;
	var image:h2d.Graphics;
	var label:h2d.Text;

	public var text(get, set):String;

	public var color:Int = 0xffffff;
	public var textColor:Int = 0xe70060;

	public var width:Float = 300;
	public var height:Float = 68;


	public function new(parent:h2d.Object, defaultHandler:hxd.Event->Void = null) {
		super(parent);

		input = new h2d.Interactive(300, 68, this); 
		if (defaultHandler != null) input.onClick = defaultHandler;
		input.onOver = onOver;
		input.onOut = onOut;

		image = new h2d.Graphics(this);

		label = new h2d.Text(hxd.Res.tiltWarp.toFont(), this);
		label.textColor = textColor;

		setSize(300, 68);
	}


	public function setSize(w:Float, h:Float) {
		width = w;
		height = h;

		image.clear();
		image.beginFill(color);
		image.drawRect(0, 0, width, height);
		image.endFill();

		input.width = width;
		input.height = height;

		label.x = width * 0.5 - label.textWidth * 0.5;
		label.y = height * 0.5 - label.textHeight * 0.5;
	}


	function onOver(e:hxd.Event) {
		App.ME.tween.add(image.alpha, 0.5, 3);
	}


	function onOut(e:hxd.Event) {
		App.ME.tween.add(image.alpha, 1, 3);
	}


	function get_text():String {
		return label.text;
	}
	

	function set_text(value:String):String {
		label.text = value;

		label.x = width * 0.5 - label.textWidth * 0.5;
		label.y = height * 0.5 - label.textHeight * 0.5;

		return label.text;
	}


	override function onRemove() {
		super.onRemove();

		App.ME.sevents.checkEvents();
		App.ME.tween.remove(this);
	}
}