package lv.hansagames.chaining.boot;
import flixel.util.FlxSignal.FlxTypedSignal;
import lv.hansagames.chaining.core.AbstractListCommand;
import lv.hansagames.chaining.core.ICommand;
import lv.hansagames.chaining.event.BootEvent;
import lv.hansagames.chaining.event.CommandEvent;
import lv.hansagames.chaining.vo.BootStep;

/**
 * ...
 * @author Uldis Baurovskis
 */
class AbstractBoot extends AbstractListCommand implements IBoot
{
	var stepList:Array<BootStep>;
	var paused:Bool;
	var previousStepItem:BootStep;
	var currentStepItem:BootStep;
	
	var currentIndex:Int;
	
	public function new()
	{
		super("boot");
		stepList = [];
	}
	
	override public function start():Void 
	{
		if (!running)
		{
			super.start();
			
			if (stepList.length != 0)
			{
				currentIndex = 0;
				currentStepItem = stepList[currentIndex];
				
				paused = currentStepItem.pauseBefore;
				
				if (!paused)
				{
					executeStep(currentStepItem.command);
				}
			}
			else
			{
				dispatcher.dispatch(BootEvent.COMPLETE, this,null);
				if (autoDestroy)
					destroy();
				
			}
		}
	}
	
	function executeStep(step:ICommand):Void
	{
		if (!paused)
		{
			if (step!=null)
			{
				step.dispatcher.add(onLocalStep);
				step.start();
			}
		}
	}
	
	function onLocalStep(id:String, target:ICommand = null, data:Dynamic = null):Void
	{
		if (id == CommandEvent.FINISHED)
		{
			if(target!=null && target.dispatcher!=null)
				target.dispatcher.remove(onLocalStep);
			if(dispatcher != null && currentStepItem!=null)
				dispatcher.dispatch(BootEvent.STEP_COMPLETE, this, currentStepItem.id);
			currentIndex++;
			
			if (currentIndex<stepList.length)
			{
				previousStepItem = currentStepItem;
				currentStepItem = stepList[currentIndex];
				paused = previousStepItem.pauseAfter;
				
				if (autoDestroy)
				{
					removeStep(previousStepItem.id);
					target.destroy();
				}
				
				if (!paused)
				{
					executeNextCommand();
				}
			}
			else
			{
				running = false;
				
				if (autoDestroy && currentStepItem!=null && target!=null)
				{
					removeStep(currentStepItem.id);
					target.destroy();
					destroy();
				}
				
				if(dispatcher!=null)
					dispatcher.dispatch(BootEvent.COMPLETE, this,null);
			}
			
		}
		else if (id == CommandEvent.FAILED)
		{
			running = false;
			target.dispatcher.remove(onLocalStep);
			
			if (autoDestroy)
			{
				target.destroy();
				destroy();
			}
			
			if(dispatcher!=null && currentStepItem!=null)
			dispatcher.dispatch(BootEvent.FAILED, this, currentStepItem.id);
		}
	}
	
	override public function addCommand(command:ICommand):Void 
	{
		var step:BootStep=null;
		var length:Int;
		
		if (!running && command!=null)
		{
			super.addCommand(command);
			
			if (stepList != null)
			{
				length = stepList.length;
				
				for (i in 0...length) 
				{
					if (stepList[i].id == command.commandId)
					{
						step = stepList.splice(i, 1)[0];
						break;
					}
				}
				
				if (step != null)
				{
					if (step.command != null)
						step.command.destroy();
					step.command = command;
					step.id = command.commandId;
				}
				else
				{
					step = new BootStep();
					step.command = command;
					step.id = command.commandId;
					stepList.push(step);
				}
			}
		}
	}
	
	public function addStepAfter(position:String, placeID:String):IBoot
	{
		var step:BootStep=null;
		var length:Int;
		
		if (stepList != null)
		{
			length = stepList.length;
			
			for (i in 0...length) 
			{
				if (stepList[i].id == placeID)
				{
					step = stepList.splice(i, 1)[0];
					break;
				}
			}
			
			if (step==null)
			{
				step = new BootStep();
				step.id = placeID;
			}
			
			for (i in 0...length) 
			{
				if (stepList[i].id == position)
				{
					if (i == length - 1)
					{
						stepList.push(step);
					}
					else
					{
						stepList.insert(i + 1, step);
					}
				
					break;
				}
			}
		}
		return this;
	}
	
	function getStepByID(id:String):BootStep
	{
		if (stepList != null)
		{
			for (step in stepList) 
			{
				if (step != null && step.id == id)
					return step;
			}
		}
		return null;
	}
	
	public function addStepBefore(position:String, placeID:String):IBoot
	{
		var step:BootStep=null;
		var length:Int;
		
		if (stepList != null)
		{
			length = stepList.length;
			
			for (i in 0...length) 
			{
				if (stepList[i].id == placeID)
				{
					step = stepList.splice(i, 1)[0];
					break;
				}
			}
			
			if (step==null)
			{
				step = new BootStep();
				step.id = placeID;
			}
			
			for (i in 0...length) 
			{
				if (stepList[i].id == position)
				{
					if (i == 0)
					{
						stepList.insert(0, step);
					}
					else
					{
						stepList.insert(i - 1, step);
					}
				
					break;
				}
			}
		}
		return this;
	}
	
	public function addStepAtBegining(placeID:String):IBoot
	{
		var step:BootStep=null;
		var length:Int;
		
		if (stepList != null)
		{
			length = stepList.length;
			
			for (i in 0...length) 
			{
				if (stepList[i].id == placeID)
				{
					step = stepList.splice(i, 1)[0];
					break;
				}
			}
			
			if (step==null)
			{
				step = new BootStep();
				step.id = placeID;
			}
			
			stepList.unshift(step);
		}
		return this;
	}
	
	public function addStepAtEnd(placeID:String):IBoot
	{
		var step:BootStep=null;
		var length:Int;
		
		if (stepList != null)
		{
			length = stepList.length;
			
			for (i in 0...length) 
			{
				if (stepList[i].id == placeID)
				{
					step = stepList.splice(i, 1)[0];
					break;
				}
			}
			
			if (step==null)
			{
				step = new BootStep();
				step.id = placeID;
			}
			
			stepList.push(step);
		}
		return this;
	}
	
	public function getCommandByID(id:String):ICommand
	{
		if (stepList != null)
		{
			for (step in stepList) 
			{
				if (step != null && step.id == id)
					return step.command;
			}
		}
		return null;
	}
	
	public function removeStep(id:String):IBoot
	{
		var step:BootStep=null;
		var command:ICommand;
		var length:Int;
		
		if (stepList != null)
		{
			length = stepList.length;
			
			for (i in 0...length) 
			{
				if (stepList[i].id == id)
				{
					step = stepList.splice(i, 1)[0];
					break;
				}
			}
		}
		
		if (step!=null)
		{
			removeCommand(step.id);
			step.destroy();
		}
		
		return this;
	}
	
	override public function destroy():Void 
	{
		super.destroy();
		paused = false;
		currentIndex = 0;
		previousStepItem = null;
		currentStepItem = null;
		
		var step:BootStep;
		
		while (stepList.length > 0)
		{
			step = stepList.pop();
			if (step!=null)
				step.destroy();
		}
	}
	
	public function pause():Void
	{
		if (running && !paused)
		{
			paused = true;
		}
	}
	
	public function resume():Void
	{
		if (paused && running)
		{
			paused = false;
			if(stepList!=null && currentIndex<stepList.length)
				executeStep(stepList[currentIndex].command);
		}
	}
	
	public function addPauseBefore(position:String):IBoot
	{
		var step:BootStep = getStepByID(position);
		
		if (step!=null)
			step.pauseBefore = true;
		
		return this;
	}
	
	public function addPauseAfter(position:String):IBoot
	{
		var step:BootStep = getStepByID(position);
		
		if (step!=null)
			step.pauseAfter = true;
		
		return this;
	}
	
	public function removePauseBefore(position:String):IBoot
	{
		var step:BootStep = getStepByID(position);
		
		if (step!=null)
			step.pauseBefore = false;
		return this;
	}
	
	public function removePauseAfter(position:String):IBoot
	{
		var step:BootStep = getStepByID(position);
		
		if (step!=null)
			step.pauseAfter = false;
		return this;
	}
	
	public function removeAllPauses():Void
	{
		if (stepList != null)
		{
			for (step in stepList)
			{
				if (step != null)
				{
					step.pauseAfter = false;
					step.pauseBefore = false;
				}
			}
		}
	}
	
	public function removeAllSteps():Void
	{
		var step:BootStep;
		
		while (stepList.length > 0)
		{
			step = stepList.pop();
			if (step != null)
			{
				removeCommand(step.id);
				step.destroy();
			}
		}
	}
	
	function executeNextCommand():Void
	{
		var nextCommand:ICommand=null;
		
		while (!paused && nextCommand == null && currentStepItem!=null)
		{
			previousStepItem = currentStepItem;
			currentStepItem = stepList[currentIndex];
			
			if(currentStepItem!=null)
				paused = currentStepItem.pauseBefore;
			
			if (nextCommand==null)
			{
				nextCommand = currentStepItem.command;
			}
			
			if (nextCommand==null)
			{
				currentIndex++;
				if(currentStepItem!=null)
					paused = currentStepItem.pauseAfter;
				if(dispatcher!=null && previousStepItem!=null)
					dispatcher.dispatch(BootEvent.STEP_COMPLETE, this, previousStepItem.id);
				currentStepItem = stepList[currentIndex];
			}
		}
		
		if (!paused)
		{
			if (nextCommand!=null)
			{
				executeStep(nextCommand);
			}
			else
			{
				if(dispatcher!=null)
					dispatcher.dispatch(BootEvent.COMPLETE, this,null);
				if (autoDestroy)
					destroy();
				
			}
		}
	}

}