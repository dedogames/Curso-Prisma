

/*****************************************************************************
  
 File          : GameOrient.as
 Project       : ID 6687 - Conduta - Bussola
 Platform      : Action Script 2
 Creation Date : 15-05-2017
 Author        : Gelson G. Rodrigues
  
 Description: Controle da bussola através de um timer, sendo que 3 quadrantes
          	 são exibidos em um determinado tempo e o usuário baseado em uma 
		  	 questão deve clicar no botão Ok para confirmar a seleção.
		  	 A ordem que será exibida os quadranes será deternimada pelo diagramador.
			                     
								 
			                  90 
					           |
		  		   quadrante 2 | quadrante 1
			 180 ---------------------------- 0 
		 		   quadrante 3 | quadrante 4
							   |
							  270 
			Supondo que o quadrante 3 seja o inicial, o circulo irá começar em 180 
			e rotacional até 0 grau, portanto o primeiro indice do array 
			ordemDeExibicaoDosQuadrantes determina onde estará a pergunta e onde 
			o circulo timer deve começar.
			
			No stage estão os seguintes elementos
			btn_ok - botão que o usário vai clicar para selecionar a opção que para ele
			esteja correta
			
			mc_map - contém os pontos que vão ser ligados no mapa
				objetos filhos de mc_mapa
				
				mc_start  - Ponto inicial do mapa
				mc_finish - Ponto Final do mapa
				mc_a1,mc_a2,mc_a3   - 1,2 e 3 representam a quantidade que opções por nivel
				mc_b1,mc_b2,mc_b3
				mc_c1,mc_c2,mc_c3
				
			mc_compass - Bussola com seus respectivos frames sendo que cada nivel
			contém 3 frames, caso o usuário erre na primeira opção restam duas opções por nivel,
			caso não acerter nenhum das 3 opções é retornado ao primeiro frame do nivel atual 
			para repetir o processo até que o usuário seleciona um opção valida.
             							  
  
 ================================== HISTORY ==================================
 When      Who         What
 --------- ----------- -------------------------------------------------------
  
 *****************************************************************************/
 
import LuminicBox.Log.*;
class GameOrient
{
	public static var instance:GameOrient;
	public var maxQuadrants:Number = 3;
	public var isDebugMode:Boolean =  false;
	public static var log:Logger = new Logger("GameOrient");
	public var currentState:Number = 0;
	public var mc_callback:Function;
	public var currentLevel:Number;
	public var niveis:Array;
	var timers:Array = [16000,32290,48500];
	var actualTimer:Number = 0;
	var maxTimer ; 
	public var start_time;
	private var elapsed_time; 
	private var btn_ok:String = "btn_ok";
	public var mainStage:MovieClip;
	public var compass:Compass;
	public var startQuadrant:Number;
	public var tempoExibicaoCadaQuadrante:Number;
	public var quadActual = 0;
	public var countNumQuadrantsShowed:Number;
	public var lastTimer;
	public var stopTimer;
	public var ordemDeExibicao:Array;
	public var rotateArray:Array;
	public var corTimer;
	///quadActual
	public function GameOrient(mainStage:MovieClip, 
							   currentLevel,
							   niveis,
							   raioTimer, 
							   corLinhaMapa ,
							   corTimer,
							   tempoExibicaoCadaQuadrante,
							   chamandoAoTerminoDoJogo,
							   ordemDeExibicaoDosQuadrantes,
							   isDebugMode)
	{
		
		if(isDebugMode) log.addPublisher( new TracePublisher() );
		GameOrient.instance = this;
		
		mc_callback = chamandoAoTerminoDoJogo;
		maxTimer =timers[2];
		this.corTimer = corTimer;
		this.ordemDeExibicao  = ordemDeExibicaoDosQuadrantes; 
		this.currentLevel = currentLevel;
		this.niveis       = niveis;
		
		rotateArrayFunc(ordemDeExibicaoDosQuadrantes);
		this.tempoExibicaoCadaQuadrante = tempoExibicaoCadaQuadrante;
		log.debug("----------- Classe GameOrient - Construtor - inicio Debug --------------");		
		log.debug("Nivel atual                   : "+this.currentLevel); 
		log.debug("Tempo Tamanho do raio to timer: "+raioTimer); 
		log.debug("Cor da linha Mapa             : 0x"+corLinhaMapa.toString(16) );
		log.debug("Cor da linha Timer            : 0x"+corTimer.toString(16));
		log.debug("Tempo de exibicação           : "+tempoExibicaoCadaQuadrante);
		log.debug("Função chamada no final       : "+chamandoAoTerminoDoJogo);
		log.debug("Ordem de exibição             : "+ordemDeExibicaoDosQuadrantes);		
		log.debug("Niveis                        : "+niveis);	
		startQuadrant = ordemDeExibicaoDosQuadrantes[0];
		this.mainStage = mainStage;		 
		compass = new Compass(mainStage["mc_compass"],niveis,startQuadrant);
		currentState  = States.INIT;
		
		//mainStage.onEnterFrame = update;		
		showTestes();
		reset();
	}
	
	
	public function reset()
	{		 
	
		 delete mainStage["btn_ok"].onRelease;
	     delete mainStage.onEnterFrame;
		 mainStage["mc_compass"].gotoAndStop("level"+currentLevel);
		 start_time = getTimer();
		 controlTimer()
		 compass.setQuadrant(startQuadrant);
		 countNumQuadrantsShowed = 0;
		 compass.resetAll();
		 
		 mainStage["btn_ok"].onRelease = clickOk;
		 mainStage["btn_ok"].enabled = true;
		 mainStage.onEnterFrame = update;	
	}
	
	public function finishGame()
	{		 
	
		 delete mainStage["btn_ok"].onRelease;
	     delete mainStage.onEnterFrame; 
		 mainStage["mc_compass"]["q1"]._alpha = 100;
		 mainStage["mc_compass"]["q2"]._alpha = 100;
		 mainStage["mc_compass"]["q3"]._alpha = 100;
		 mainStage["mc_compass"]["q4"]._alpha = 100;
	}
	
	public var clickedQuadrant =0;
	public function clickOk()
	{
		
		
		if(GameOrient.instance.compass.checkOp()== true )
		{
			
			 GameOrient.instance.reset();
			 GameOrient.instance.mainStage["btn_ok"].enabled = true;
			 GameOrient.instance.currentState =States.FINISH;
		}else{
		 
		 GameOrient.instance.start_time = getTimer();
		 GameOrient.instance.controlTimer();
		 GameOrient.instance.compass.setQuadrant(GameOrient.instance.startQuadrant);
		 GameOrient.instance.compass.resetAll();
		}
		 
	}
	
	public var trigger = 0;
	public function pause()
	{
		trigger = trigger == 0 ? 1 : 0;
		
		if(trigger == 1)
		{
			 delete mainStage.onEnterFrame;
		}else{
			 
		   		reset();
		   
		   }
			
		 //delete mainStage.onEnterFrame;
	}
	function getActualQuad()
	{ 		
		return quadActual				 
	}	
	
	public function rotateArrayFunc(_array)
	{
		var array:Array = new Array();
		for(var i=0;i < _array.length;i++)
		{
			array.push(_array[i]);
		}
		var newArray:Array = new Array(array.length);
		var sizeArray = 4;
		var first = array.shift();
		
		newArray = array;
		newArray[sizeArray-1] = first;
		rotateArray =  newArray;
	}
	public function drawArc(centerX, centerY, radius, startAngle, arcAngle, steps)
	{	 
			var factor =0.248; 
			 if(arcAngle <= 0.248)
			{
				GameOrient.instance.quadActual = 0;
				 
			}else
				if( (arcAngle > factor) && (arcAngle <= factor*2) )
				{
					GameOrient.instance.quadActual = 1;
					 
				}else
				if( (arcAngle > factor) && (arcAngle <= factor*3) )
				{
					GameOrient.instance.quadActual = 2;
					 
				}else
					if( (arcAngle > factor) && (arcAngle <= factor*4) )
				{
					GameOrient.instance.quadActual = 3;
					
				} 		 	
				
		       GameOrient.instance.clickedQuadrant =  GameOrient.instance.rotateArray[GameOrient.instance.quadActual];
			 
			GameOrient.instance.mainStage.clear();
			GameOrient.instance.mainStage.lineStyle(10, corTimer);
			startAngle -= .25;
			var twoPI = 2 * Math.PI;
			var angleStep = arcAngle/steps;
			
			var xx = centerX + Math.cos(startAngle * twoPI) * radius;
			var yy = centerY + Math.sin(startAngle * twoPI) * radius;
			GameOrient.instance.mainStage.moveTo(xx, yy);
			
			for(var i=1; i<=steps; i++){
				var angle = startAngle + i * angleStep;
				xx = centerX + Math.cos(angle * twoPI) * radius;
				yy = centerY + Math.sin(angle * twoPI) * radius;
				GameOrient.instance.mainStage.lineTo(xx, yy);
				//arrow_orient._rotation = (Math.atan2(yy,xx)*180)/Math.PI+90;
			}		
	}	
	
	
	// 0   - 90
	// 90  - 0
	// 180 - 270
	// 180 - 180
	
	//
	private var quadrantsStart:Array = [
										{quadrant: 1 , value:90},
										{quadrant: 2 , value:0},
										{quadrant: 3 , value:270},
										{quadrant: 4 , value:180}
										]
	public function controlTimer()
	{	 	    
		elapsed_time = getTimer()-start_time; 	 
		drawArc(mainStage["mc_compass"]._x,mainStage["mc_compass"]._y, 395, quadrantsStart[startQuadrant-1].value/360, (elapsed_time/(tempoExibicaoCadaQuadrante))/360, 80);
		 
		compass.showQuadrant(rotateArray[quadActual]);
	}
	
	
	
	public function update()
	{
			
		 GameOrient.instance.controlTimer();
		 switch( GameOrient.instance.currentState)
		 {
			case States.INIT:
				 GameOrient.instance.currentState = States.PLAY;
			break;
			
			case States.PLAY: 
				if(GameOrient.instance.currentLevel > 4)
				{
					  GameOrient.instance.reset();
					 GameOrient.instance.currentState =States.FINISH;
				}
				if(GameOrient.instance.compass.numQuadsShow  > GameOrient.instance.maxQuadrants)
				{
					 GameOrient.instance.currentState = States.RESET;
				}
			break;
			case States.SELECT:
				 
			break;
			case States.RESET: 
				 GameOrient.instance.reset();
				 GameOrient.instance.currentState = States.INIT;
			
			break;
			
			case States.FINISH:
					GameOrient.instance.finishGame();
					 GameOrient.instance.mc_callback(GameOrient.instance);
					 
					 
				
			break;
			case States.DRAWMAP:
			
			break;
			case States.PAUSE:
				//pause();
			break;
			case States.FEEDBACK:
			break;
		 }
	}
	
	public function showTestes()
	{
		
		 log.info("\n");
		 log.info("--------------------------------------------");
		 log.info("------------- ALL TESTS   ------------------");
		 log.info("--------------------------------------------\n");
		for(var i=0;i<  Testes.Tests.length;i++)
		{
			log.debug("\n\n");
			log.debug("----------- Classe Tested Name:  "+Testes.Tests[i].cls+" -----------\n");
			for(var j=0;j< Testes.Tests[i].allTest.length;j++)
			{
			//if(Testes.Tests[i].
			
				if(Testes.Tests[i].allTest[j].status ==  "OK")
				{
					log.info("TEST OK: "+Testes.Tests[i].allTest[j].t);
				}else
					log.warn("TEST NO: "+Testes.Tests[i].allTest[j].t);
				//test				
				//status
			}
		}
	}	
}

	/*
	public var mc_start:String ;
	public var mc_finish:String;
	
	public var mc_a1:String ;
	public var mc_a2:String ;
	public var mc_a3:String ;
	
	public var mc_b1:String ;
	public var mc_b2:String ;
	public var mc_b3:String ;
	
	public var mc_c1:String ;
	public var mc_c2:String ;
	public var mc_c3:String ;;
	*/