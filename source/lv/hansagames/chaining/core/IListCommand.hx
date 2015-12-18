package lv.hansagames.chaining.core;

/**
 * @author Uldis Baurovskis
 */

interface IListCommand extends ICommand
{
	function addCommand(command:ICommand):Void;
	function removeCommand(id:String):Void;
}