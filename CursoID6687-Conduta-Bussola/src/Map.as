class Map
{
	public var mc_map:MovieClip;
	private var color;
	private var thickness:Number;
	
	public function Map(mc_map,color,thickness)
	{
		this.mc_map = mc_map;
		this.color = color;
		this.thickness = thickness; 
	}
	 
	 
	public function drawPath(arr:Array)
	{		  
		for(var i=0; i <arr.length;i++)
		{
			drawLine(arr[i].mc_start,arr[i].mc_finish); 
		}
	}
	
	private function drawLine(to:String, From:String)
	{		 
		mc_map.lineStyle(thickness, color);
		mc_map.moveTo(mc_map[to]._x, mc_map[to]._y);
		mc_map.lineTo(mc_map[From]._x, mc_map[From]._y);
	}
}