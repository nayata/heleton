package heaps;

import hxd.System;


class Device {
	public var mobile(get, never):Bool;
	public var desktop(get, never):Bool;
	public var web(get, never):Bool;
	

	public function new() {}


	function get_mobile():Bool {
		var platform = System.platform;
		if (platform == IOS || platform == Android) return true;
		return false;
	}


	function get_desktop():Bool {
		var platform = System.platform;
		return platform == PC;
	}


	function get_web():Bool {
		#if (js || html5)
			return !mobile;
		#end
		return false;
	}
}