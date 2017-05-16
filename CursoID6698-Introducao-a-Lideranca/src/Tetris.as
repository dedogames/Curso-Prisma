 
import com.greensock.*;
import com.greensock.easing.*;


/*************************************************************************
  
 File          : Tetris.as
 Project       : ID 6698 - Introdução à Liderança  - Itau
 Platform      : Action Script 2
 Creation Date : 10/05/2017
 Author        : Gelson Gomes Rodrigues
  
 Description: Classe responsavel pela lógica de um pseudo tetris
 			  As variaveis são publicas pois em para acessar varaiveis
 			  dentro do EnterFrame e onRelease foi necessário criar
			  uma instância estatica da classe Tetris e assim conseguir
			  acessar os atritubos
			  
  
 ================================== HISTORY ==================================
 When      		Who         What
 --------- 	----------- -------------------------------------------------------
  11/05       Gelson G   Foi adicionado uma variavel mode_debug que não exibe 
  						  os mc's de referência, case esta variavel esteja 
						  setada com false
 *****************************************************************************/
class Tetris extends MovieClip
{
	public var Root:MovieClip;//Stage onde os elementos do jogo esta
	public static var TETRIS_CLASS:Tetris; //atributo acessador externamente
	
	/* Nome dos elementos no stage*/
	public var colisoes   = [	"mc_colisao1",
								"mc_colisao2",
								"mc_colisao3"
						    ];

    /* Nome das palavras no stage*/
	public var palavras   = [
								"mc_assertividade",
								"mc_empatia",
								"mc_carisma",
								"mc_foco",
								"mc_inspiracao"
						    ];

	/* Nome do moveclip animado */
	public var mc_replay:String   = "mc_replay";
	private var btn_fechar 		  = "btn_fechar"
    public var mc_posicao_replay  = "mc_posInicial4";							
	public var mc_feed:String     = "mc_feed";
	public var velYReplay         = 6;
	/*Frames do feed correspondente a cada ação do jogo*/
	public var FEED_CORRETO       = 2;
	public var FEED_ERRADO        = 3;
	public var FEED_CONTINUAR     = 4;
	public var FEED_CONTINUAR_ULTIMO     = 5;
	
	/* Peça atual usada*/
	public var palavraCorrent;	
	/* Posição do x do bloco que são 3
		mc_colisao1,mc_colisao2,mc_colisao3.
	*/
	public var posBloco;
	
	
    public var currentKey 		   = 0;
	public var keyListener:Object; 
	public var velY;	
	public var maxVel;
	public var lista:Array;
	public var startReplay:Boolean;
	public var pauseGame:Boolean = false; 
	public var currentFeed;
	/* Função a ser chamada no final */
	public var m_callBack;
	public var debug_mode = false;
	public var mc_referencialPosicao = "mc_posInicial";
	public var funcaoChamandoUltimoFeedBack;
	
	/* Construtor - Inicializando variaveis*/
	public function Tetris(Root,velY,lista,m_callBack,velYReplay,funcaoChamandoUltimoFeedBack)
	{
		this.Root           = Root;
		this.velY           = velY;
		maxVel              = velY;
		this.lista          = lista;
		this.m_callBack     = m_callBack;
		Tetris.TETRIS_CLASS = this;
		startReplay 		= false;
		this.velYReplay     = velYReplay;
		palavraCorrent 	    = 0 ;	
		posBloco 			= 2;	
	    this.funcaoChamandoUltimoFeedBack	= funcaoChamandoUltimoFeedBack;
		initPosicao(); 
		initKeyListener();
		loopGame(); 
		
		if(debug_mode == false)
		{						
			for(var i =0; i < colisoes.length; i++)
			{
				Root[colisoes[i]]._alpha = 0;
			}
			
			for(var j =1; j <= 4; j++)
			{
				Root[mc_referencialPosicao+j]._alpha = 0;
			}			 
		}
	}
	
	/*===========================================================================*
	 Function   : replay
	 Description: Inicia mode replay
	 Input      : nothing
	 Output     : nothing
	 Return     : nothing
	 *===========================================================================*/

	private function replay()
	{
		startReplay = true;
	}
	
	/*===========================================================================*
	 Function   : initPosicao
	 Description: Reposiciona todas as peças no centro na parte superior
	 Input      : nothing
	 Output     : nothing
	 Return     : nothing
	 *===========================================================================*/
	private function initPosicao()
	{		 		
		this.Root[mc_replay]._alpha = 0;
		for(var i =0; i < palavras.length; i++)
		{
			this.Root[palavras[i]]._x = this.Root[mc_referencialPosicao+'2']._x;
			this.Root[palavras[i]]._y = this.Root[mc_referencialPosicao+'2']._y;
			this.Root[palavras[i]]._alpha =0;
		}		
		posBloco = 2;
		this.Root[palavras[palavraCorrent]]._alpha =100;		
	} 	
	
	/*===========================================================================*
	 Function   : initKeyListener
	 Description: Inicia funções relacioandas ao teclado
	 Input      : nothing
	 Output     : nothing
	 Return     : nothing
	 *===========================================================================*/
	private function initKeyListener()
	{
		keyListener = new Object(); 
		keyListener.onKeyDown = function() 
		{
			//Tetris.TETRIS_CLASS.pauseGame = false;
		   // Tetris.TETRIS_CLASS.loopGame();
		   Tetris.TETRIS_CLASS.currentKey = Key.getCode(); 				
		
		};
		
		keyListener.onKeyUp = function() {
		  Tetris.TETRIS_CLASS.currentKey = 0;
		  Tetris.TETRIS_CLASS.velY = Tetris.TETRIS_CLASS.maxVel;
		};
		Key.addListener(keyListener);
	}
	
	
	/*===========================================================================*
	 Function   : checkColisao
	 Description: Checa se a peça chegou ao seu correspondente correto através 
	 			  Verifica também a colisão com mc_posInicial4 no mode replay
				  reposicionando a peça na posição correta
	 			  atraves do hitTest
	 Input      : nothing
	 Output     : nothing
	 Return     : nothing
	 *===========================================================================*/
	private function checkColisao()
	{		
		for(var i =0; i < colisoes.length; i++)
		{
			if( this.Root[palavras[palavraCorrent]].hitTest(this.Root[colisoes[i]]))
			{
				   this.Root[palavras[palavraCorrent]]._alpha = 0;
				    
				   if(colisoes[i] == this.lista[palavraCorrent].target)
				   { 
					     if(startReplay == true)
						 { 
							 if( Tetris.TETRIS_CLASS.palavraCorrent >= 4)
							 {								 
							 	 Tetris.TETRIS_CLASS.currentFeed =  Tetris.TETRIS_CLASS.FEED_CONTINUAR_ULTIMO
							 }
							 else
							 	 Tetris.TETRIS_CLASS.currentFeed = Tetris.TETRIS_CLASS.FEED_CONTINUAR;
								 
								 
							  Tetris.TETRIS_CLASS.pauseGame = true;
							  palavraCorrent++;
							   startReplay = false;
							  initPosicao();					
							  this.Root[palavras[palavraCorrent]]._alpha =0;
						 }
						else{
							  currentFeed = FEED_CORRETO;
							  Tetris.TETRIS_CLASS.pauseGame = true;
							  palavraCorrent++;
							  startReplay = false;
							  initPosicao();					
							  this.Root[palavras[palavraCorrent]]._alpha =0;
						}
				   }else
				   { 
					     currentFeed = FEED_ERRADO;
					     Tetris.TETRIS_CLASS.pauseGame = true;
					     replay();
				   }			
				   
				 
			}
		}
		
		/* Movimento de replay*/
		 if(startReplay == true)
		 {
			 if( this.Root[palavras[palavraCorrent]].hitTest(this.Root[mc_posicao_replay]))
			 {
				 for(var j = 0 ; j < lista.length; j++)
				 {					  
					 if(lista[j].obj == palavras[palavraCorrent])
					 { 
						 posBloco = lista[j].target.charAt(lista[j].target.length -1);						 
					 }
				 }
			 }
		 }		 
	}
	
	
	/*===========================================================================*
	 Function   : listenerBtnFechar
	 Description: Botão fechar dos feed's de erro e feed de replay 
	 Input      : nothing
	 Output     : nothing
	 Return     : nothing
	 *===========================================================================*/
	public function listenerBtnFechar()
	{		
		Tetris.TETRIS_CLASS.Root[Tetris.TETRIS_CLASS.mc_feed][Tetris.TETRIS_CLASS.btn_fechar].enabled = true;
		
		Tetris.TETRIS_CLASS.Root[Tetris.TETRIS_CLASS.mc_feed][Tetris.TETRIS_CLASS.btn_fechar].onRelease = function()
		{						
			  TweenMax.to( Tetris.TETRIS_CLASS.Root[Tetris.TETRIS_CLASS.mc_feed], 1, {_alpha:0, onComplete: Tetris.TETRIS_CLASS.finishAlphaOut});
			  this.enabled = false;
		}
	}
	
	
	/*===========================================================================*
	 Function   : finishAlphaOut
	 Description: Chamando ao final dos tweens dos feedback, seja de erro, acerto ou replay
	 			   Caso esteja na última peça, o jogo é finalizado e a função externa é chamada
				   para continuar o curso
	 Input      : nothing
	 Output     : nothing
	 Return     : nothing
	 *===========================================================================*/
	public function finishAlphaOut()
	{	 		
		if(Tetris.TETRIS_CLASS.currentFeed == Tetris.TETRIS_CLASS.FEED_CONTINUAR_ULTIMO)		
		{			  
			 delete Tetris.TETRIS_CLASS.Root.onEnterFrame;
			 Tetris.TETRIS_CLASS.funcaoChamandoUltimoFeedBack();
		 	// Tetris.TETRIS_CLASS.m_callBack();			 
		}
		
		Tetris.TETRIS_CLASS.pauseGame = false;
		if(Tetris.TETRIS_CLASS.startReplay == true)
			TweenMax.to( Tetris.TETRIS_CLASS.Root[Tetris.TETRIS_CLASS.mc_replay], 1, {_alpha:100});
			
		Tetris.TETRIS_CLASS.loopGame();
		Tetris.TETRIS_CLASS.currentFeed = 0;
		Tetris.TETRIS_CLASS.initPosicao();			
		TweenMax.to( Tetris.TETRIS_CLASS.Root[Tetris.TETRIS_CLASS.palavras[Tetris.TETRIS_CLASS.palavraCorrent]], 0.8, {_alpha:100});
	}
	
	
	/*===========================================================================*
	 Function   : finishAlphaIn
	 Description: Exibe o feed con tween
	 Input      : nothing
	 Output     : nothing
	 Return     : nothing
	 *===========================================================================*/
	public function finishAlphaIn()
	{ 		
		if(Tetris.TETRIS_CLASS.currentFeed == Tetris.TETRIS_CLASS.FEED_CORRETO)
		{
		 	TweenMax.to( Tetris.TETRIS_CLASS.Root[Tetris.TETRIS_CLASS.mc_feed], 1, {delay: 1,_alpha:0, onComplete: Tetris.TETRIS_CLASS.finishAlphaOut});
		}else{		
			
			Tetris.TETRIS_CLASS.listenerBtnFechar();
		}
	}
	
	
	/*===========================================================================*
	 Function   : loopGame
	 Description: Função principal, responsavel por responder as ações do usuário, 
	 			  verificação de colisão e validações de final do jogo
	 Input      : nothing
	 Output     : nothing
	 Return     : nothing
	 *===========================================================================*/
	 public var forceStopLoop:Boolean = false;
	private function loopGame()
	{	
		if(forceStopLoop == true)
		{
			delete this;
			return;
		}
		this.Root.onEnterFrame = function()
		{ 		  
		
		if( (Tetris.TETRIS_CLASS.palavraCorrent >= 5) && (  Tetris.TETRIS_CLASS.currentFeed != Tetris.TETRIS_CLASS.FEED_CONTINUAR_ULTIMO) )		
		{
			 Tetris.TETRIS_CLASS.forceStopLoop = true;
		 	 Tetris.TETRIS_CLASS.m_callBack();
			 delete Tetris.TETRIS_CLASS.Root.onEnterFrame;
		}
		    if(Tetris.TETRIS_CLASS.pauseGame == true)
			{											
				Tetris.TETRIS_CLASS.Root[Tetris.TETRIS_CLASS.mc_feed].gotoAndStop(Tetris.TETRIS_CLASS.currentFeed);
				  Tetris.TETRIS_CLASS.Root[Tetris.TETRIS_CLASS.mc_feed]._alpha = 100				 
				  // Tetris.TETRIS_CLASS.Root[mc_feed]._alpha = 50;				 
				  TweenMax.from(Tetris.TETRIS_CLASS.Root[Tetris.TETRIS_CLASS.mc_feed], 0.5, {_alpha:0, onComplete:Tetris.TETRIS_CLASS.finishAlphaIn});				 
	
				   delete Tetris.TETRIS_CLASS.Root.onEnterFrame;
			}			
			
		    if(Tetris.TETRIS_CLASS.startReplay == true)
			{
				Tetris.TETRIS_CLASS.Root[Tetris.TETRIS_CLASS.palavras[Tetris.TETRIS_CLASS.palavraCorrent]]._y += Tetris.TETRIS_CLASS.velYReplay;
			}else{
				
				if(Tetris.TETRIS_CLASS.currentKey > 0)
				{
					if( Tetris.TETRIS_CLASS.currentKey == 37)//left
					{
						if(Tetris.TETRIS_CLASS.posBloco > 1)
							Tetris.TETRIS_CLASS.posBloco--;
							Tetris.TETRIS_CLASS.currentKey = 0;							
						 
					}else
						if(Tetris.TETRIS_CLASS.currentKey == 39)
						{
							if(Tetris.TETRIS_CLASS.posBloco < 3)
								Tetris.TETRIS_CLASS.posBloco++;
								Tetris.TETRIS_CLASS.currentKey = 0;
								
						} else
						if(Tetris.TETRIS_CLASS.currentKey == 40)
						{
							Tetris.TETRIS_CLASS.velY += 0.5;				
						}
							
				}
				
				Tetris.TETRIS_CLASS.Root[Tetris.TETRIS_CLASS.palavras[Tetris.TETRIS_CLASS.palavraCorrent]]._y += Tetris.TETRIS_CLASS.velY;
			}
				 Tetris.TETRIS_CLASS.checkColisao();				 
				
				Tetris.TETRIS_CLASS.Root[Tetris.TETRIS_CLASS.palavras[Tetris.TETRIS_CLASS.palavraCorrent]]._x = Tetris.TETRIS_CLASS.Root[Tetris.TETRIS_CLASS.mc_referencialPosicao+Tetris.TETRIS_CLASS.posBloco]._x;
			
		}
	}
}

