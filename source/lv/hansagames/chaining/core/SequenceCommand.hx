package lv.hansagames.chaining.core;
import lv.hansagames.chaining.event.CommandEvent;

/**
 * ...
 * @author Uldis Baurovskis
 */
class SequenceCommand extends AbstractListCommand
{

	public function new(id:String,?commands:Map<String,ICommand>) 
	{
		super(id, ?commands);
	}
	
	override function execute():Void
	{
		var item:AbstractCommand;
		
		if (commands != null && keys != null && keys.hasNext())
		{
			item = commands.get(keys.next())
			
			if (item != null && item.dispatcher != null)
			{
				item.dispatcher.add(onSubCommandSignal);
				item.start();
			}
			else
			{
				complete();
			}
		}
		else
		{
			complete();
		}
	}
	
	override function onSubCommandSignal(id:String, target:ICommand, data:Dynamic):Void
	{
		var item:AbstractCommand;
		
		if (id == CommandEvent.FINISHED)
		{
			if (target != null && target.dispatcher != null)
				ICommand(target).dispatcher.removeAll();
			finishedCommands++;
			
			if (!keys.hasNext())
			{
				complete()
			}
			else
			{
				item = commands.get(keys.next())
				
				if (item != null && item.dispatcher != null)
				{
					item.dispatcher.add(onSubCommandSignal);
					item.start();
				}
				else
				{
					complete();
				}
			}
		}
		else if (id == CommandEvent.FAILED)
		{
			error();
		}
	}
}