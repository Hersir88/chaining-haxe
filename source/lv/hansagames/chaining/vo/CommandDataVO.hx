package lv.hansagames.chaining.vo;

/**
 * ...
 * @author Uldis Baurovskis
 */
class CommandDataVO
{
	private var properties:Map<String,Dynamic>;
	
	public function new()
	{
	
	}
	
	public function addProperty(id:String, data:Dynamic):CommandDataVO
	{
		if (properties == null)
			properties = new Map<String,Dynamic>();
		
		properties.set(id,data);
		return this;
	}
	
	public function getPropertyByID(id:String):Dynamic
	{
		if (properties != null)
			return properties.get(id);
		return null;
	}
	
	public function removePropertyByID(id:String):CommandDataVO
	{
		if (properties != null && properties.exists(id))
			properties.remove(id);
		return this;
	}
	
	public function destroy():Void
	{
		if (properties != null)
		{
			for (key in properties.keys())
			{
				properties.remove(key);
			}
			properties = null;
		}
	}
	
}