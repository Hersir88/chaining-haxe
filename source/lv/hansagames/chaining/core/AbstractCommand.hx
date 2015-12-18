package lv.hansagames.chaining.core;
import flixel.util.FlxDestroyUtil;
import flixel.util.FlxSignal;
import flixel.util.FlxSignal.FlxTypedSignal;
import lv.hansagames.chaining.event.CommandEvent;
import lv.hansagames.chaining.vo.CommandDataVO;

/**
 * ...
 * @author Uldis Baurovskis
 */
class AbstractCommand implements ICommand
{
	
	@isVar
	public var commandId(default, default):String;
	@isVar
	public var dispatcher(default, null):FlxTypedSignal<String->ICommand->Dynamic->Void>;
	
	@isVar
	public var autoDestroy(default, default):Bool;

	var data:CommandDataVO;
	
	@isVar
	public var running(default, null):Bool;
	
	public function new(id:String, ?data:CommandDataVO) 
	{
		this.data = data;
		commandId = id;
		dispatcher = new FlxTypedSignal<String->ICommand->Dynamic->Void>();
	}
	
	function execute():Void
	{
	
	}
	
	function complete():Void
	{
		running = false;
		if(dispatcher!=null)
			dispatcher.dispatch(CommandEvent.FINISHED, this,null);
	}
	
	function error():Void
	{
		stop();
		if(dispatcher != null)
			dispatcher.dispatch(CommandEvent.FAILED, this,null);
		if (autoDestroy)
			destroy();
	}
	
	public function start():Void
	{
		if (!running)
		{
			running = true;
			if(dispatcher!=null)
				dispatcher.dispatch(CommandEvent.STARTED, this,null);
			execute();
		}
	
	}
	
	public function stop():Void
	{
		running = false;
	}
	
	public function destroy():Void
	{
		stop();
		running = false;
		autoDestroy = false;
		commandId = '';
		if (dispatcher !=null)
		{
			//dispatcher = FlxDestroyUtil.destroy(cast(dispatcher, FlxSignal));
			dispatcher = null;
		}
		
		if (data !=null)
		{
			data.destroy();
			data = null;
		}
	}
	
	public function addProperty(id:String, data:Dynamic):ICommand
	{
		if (this.data == null)
			this.data = new CommandDataVO();
		this.data.addProperty(id, data);
		return this;
	}
}