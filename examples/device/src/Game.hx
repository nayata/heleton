class Game extends heaps.Scene {
	var info:h2d.Text;


	public function new(?parent:h2d.Object) {
		super(parent);

		app.s2d.defaultSmooth = false;

		info = new h2d.Text(hxd.res.DefaultFont.get(), this);
		info.x = 640;
		info.y = 60;

		info.text = "Mobile: " + app.device.mobile;
		info.text += "\nDesktop: " + app.device.desktop;
		info.text += "\nWeb: " + app.device.web;

		info.setScale(2);
	}


	override function onResize() {
		screen.align(info, Center, Center);
	}
}