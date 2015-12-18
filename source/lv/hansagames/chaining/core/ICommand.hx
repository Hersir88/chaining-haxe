package lv.hansagames.chaining.core;
import flixel.util.FlxSignal.FlxTypedSignal;

/**
 * @author Uldis Baurovskis
 */

interface ICommand
{
	var running(default, null):Bool;
	var commandId(default, default):String;
	var autoDestroy(default, default):Bool;
	var dispatcher(default, null):FlxTypedSignal<String->ICommand->Dynamic->Void>;
		
	function start():Void;
	function stop():Void;
	function addProperty(id:String, data:Dynamic):ICommand;
	function destroy():Void;
}