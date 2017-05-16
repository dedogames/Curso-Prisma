

/*****************************************************************************
  
 File          : Compass.as
 Project       : ID 6687 - Conduta - Bussola
 Platform      : Action Script 2
 Creation Date : 15-05-2017
 Author        : Gelson G. Rodrigues
  
 Description:  Classe responsavel por manipular a bussola e seus respectivos frames, 
 				além da seleção de uma opção clicando no botão OK
             							 
 ================================== HISTORY ==================================
 When      Who         What
 --------- ----------- -------------------------------------------------------
  */
class Compass
{

	private var niveis:Array;
	public var currentQuadrant:Number;
	private var quadrantsOpacity:Array;
	private var mc_compass:MovieClip;
	private var nameBlackGround:String = 'q';
	private var quandrantUnchanged:Number;
	public var numQuadsShow:Number;
	private var quadsArray:Array = [0,0,0,0];
	private var numMaxFrames:Number = 3;
	public var currentFrame:Number = 0;
	private var firstFrame:Number = 0;
	public function Compass(mc:MovieClip, niveis:Array,unchanged)
	{
		GameOrient.log.debug("");
		GameOrient.log.debug("----------- Classe Compass ---------------");		 
		this.niveis = niveis;		
		this.mc_compass= mc;		
		quandrantUnchanged = unchanged;
		numQuadsShow = 0;		
		mc_compass.gotoAndStop("level"+GameOrient.instance.currentLevel);
		firstFrame = currentFrame = mc_compass._currentframe;
		 
		
	}
	
	public function setQuadrant(actual)
	{
		currentQuadrant = actual;
	}
	
	public function showQuadrant(num:Number)
	{ 
		 
		quadsArray[num-1] = true;
		currentQuadrant = num;
		numQuadsShow =0;
		for(var i=0;i < quadsArray.length;i++)
		{
			if(quadsArray[i] == true)
			{
				numQuadsShow++;
			}
		} 
		reset();  
	}	
	 
	 public var countFrame:Number = 1;
	 public var lastFrame = 0
	public function resetAll()
	{
		reset();
		numQuadsShow = 0;
		quadsArray = [0,0,0,0];
		 
		lastFrame = countFrame;
		if(countFrame > numMaxFrames)
		{
			currentFrame = firstFrame; 
			mc_compass.gotoAndStop(currentFrame);
			countFrame = 1;
			
		}  
		 mc_compass.gotoAndStop(currentFrame);
	     currentFrame++; 
		 countFrame++; 
		  
		
		
	}
	public function reset()
	{		 
		
		quadrantsOpacity = [100,100,100,100]; 
		 
		for(var i=0;i < 4 ; i++)
		{ 
			this.mc_compass[nameBlackGround+(i+1)]._alpha = quadrantsOpacity[i];
		} 
		 
		 this.mc_compass[nameBlackGround+(currentQuadrant)]._alpha = 0;
		 this.mc_compass[nameBlackGround+(quandrantUnchanged)]._alpha = 0; 
		 
	}
	
	public function checkOp():Boolean
	{		 
	 
	 	
	    return GameOrient.instance.clickedQuadrant == niveis[GameOrient.instance.currentLevel-1].correta[currentFrame-1];		 
		
	}
}