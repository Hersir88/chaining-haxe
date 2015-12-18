package lv.hansagames.chaining.core;
import lv.hansagames.chaining.core.AbstractListCommand;
import lv.hansagames.chaining.event.CommandEvent;

/**
 * ...
 * @author Uldis Baurovskis
 */
class ParallelCommand extends AbstractListCommand 
{	
	public function new(id:String,?commands:Map<String,ICommand>) 
	{
		super(id,?commands);
	}
	
	override function execute():Void 
	{
		var item:ICommand;
		
		for (key in commands.keys())
		{
			item = commands.get(key);
			
			if(item != null && item.dispatcher != null)
			{
				item.dispatcher.add(onSubCommandSignal);
				item.start();
			}
			else
			{
				finishedCommands++;
			}
		}
	}
	
	override function onSubCommandSignal(id:String, target:ICommand, data:Dynamic):Void
	{
		if (id == CommandEvent.FINISHED)
		{
			if(target != null && target.dispatcher)
				ICommand(target).dispatcher.removeAll();
			finishedCommands++;
			
			if (finishedCommands >= totalCommands)
				complete();
		}
		else if (id == CommandEvent.FAILED)
		{
			error();
		}
	}
}
