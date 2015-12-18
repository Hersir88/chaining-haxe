package lv.hansagames.chaining.core;

/**
 * ...
 * @author Uldis Baurovskis
 */
class AbstractListCommand extends AbstractCommand implements IListCommand
{
	var commands:Map<String,ICommand>;	
	var keys:Iterator<String>;
	var finishedCommands:Int;
	var totalCommands:Int;
	
	public function new(id:String, ?commands:Map<String,ICommand>)
	{
		super(id);
		
		this.commands = commands;
		
		finishedCommands = 0;
		totalCommands = 0;
		
		var item:ICommand;
		if (commands != null)
		{
			for (key in commands.keys())
			{
				item = commands.get(key);
				if (item != null)
					totalCommands++;
			}
		}
		
	}
	
	function onSubCommandSignal(id:String, target:ICommand, data:Dynamic):Void
	{
	
	}
	
	public function addCommand(command:ICommand):Void
	{
		var old:ICommand;
		
		if (!running)
		{
			if (commands == null)
			{
				commands = new Map<String,ICommand>();
			}
			else if (commands.exists(command.commandId))
			{
				old = commands.get(command.commandId);
				
				if (old != null)
					old.destroy();
				commands.remove(command.commandId);
			}
			
			commands.set(command.commandId, command);
			totalCommands++;
		}
	}
	
	public function removeCommand(id:String):Void 
	{
		var command:ICommand;
		
		if (!running && commands!=null)
		{
			command = commands.get(id);
			if (command != null)
				command.destroy();
			commands.remove(id);
		}
	}
	
	override public function start():Void 
	{
		if (!running)
		{
			finishedCommands = 0;
			keys = commands.keys();
			super.start();
		}
		
	}
	
	override public function stop():Void
	{
		super.stop();
		
		var item:ICommand;
		if (commands !=null)
		{
			for (key in commands.keys())
			{
				item = commands.get(key);
				if (item != null)
					item.stop();
			}
		}
	}
	
	override public function destroy():Void
	{
		super.destroy();
		
		var item:ICommand;
		
		if (commands!=null)
		{
			for (key in commands.keys()) 
			{
				item = commands.get(key);
				
				if (item != null)
					item.destroy();
				commands.remove(key);
			}	
			commands = null;
		}
		
		keys = null;
		totalCommands = 0;
		finishedCommands = 0;
	}
}