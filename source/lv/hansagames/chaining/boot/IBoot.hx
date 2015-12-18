package lv.hansagames.chaining.boot;
import lv.hansagames.chaining.core.ICommand;
import lv.hansagames.chaining.core.IListCommand;

/**
 * @author Uldis Baurovskis
 */

interface IBoot extends IListCommand
{
	function pause():Void;
	function resume():Void;
	
	function addPauseBefore(position:String):IBoot;
	function addPauseAfter(position:String):IBoot;
	function removePauseBefore(position:String):IBoot;
	function removePauseAfter(position:String):IBoot;
	function removeAllPauses():Void;
	
	function addStepAfter(position:String, placeID:String):IBoot;
	function addStepBefore(position:String, placeID:String):IBoot;
	
	function addStepAtBegining(placeID:String):IBoot;
	function addStepAtEnd(placeID:String):IBoot;
	
	function getCommandByID(id:String):ICommand;
	
	function removeStep(id:String):IBoot;
	function removeAllSteps():Void;
}