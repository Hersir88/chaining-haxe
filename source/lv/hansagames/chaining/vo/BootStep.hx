package lv.hansagames.chaining.vo;
import lv.hansagames.chaining.core.ICommand;

/**
 * ...
 * @author Uldis Baurovskis
 */
class BootStep
{
	@isVar
	public var id(default,default):String;
	@isVar
	public var pauseAfter(default,default):Bool;
	@isVar
	public var pauseBefore(default,default):Bool;

	@isVar
	public var command(default,default):ICommand;
	
	public function new() 
	{
		
	}
	
	public function destroy():Void
	{
		if (command!=null)
		{
			command.destroy();
			command = null;
		}
	}
	
}