class Testes
{
	public static var Tests:Array = 
		[
		 
		 	{
			  cls:"GameOrient",
 			  allTest:[
						 {t:"1  - Iniciando FSM"             ,status:"OK"},
						 {t:"2  - Evento de click Botão Ok"  ,status:"NO"},
						 {t:"3  - Pause Game"                ,status:"NO"},
						 {t:"4  - Mudança de estado"         ,status:"NO"},
						 {t:"5  - Slecionando quadrante pela fração do timer" ,status:"NO"},
						 {t:"6  - Timer em cada quadrante baseado em tempoExibicaoCadaQuadrante" ,status:"NO"},
						 {t:"7  - Pausar game quando os 3 quadrantes estive completos" ,status:"NO"}
						 
			          ]
		    },
			
 		 	{
			  cls:"Compass",
 			  allTest:[
						 {t:"1 - Manipulação da bussola que esta no Stage"         ,status:"OK"},
						 {t:"2 - Testando inicial por todos os quadrantes"         ,status:"OK"},
						 {t:"2 - Teste de exibir e remover o quadrante via tweener",status:"NO"},
						 {t:"3 - Testado modo resset"  ,status:"NO" },
						 {t:"4 - Setar 90 graus a mais de ordemDeExibicaoDosQuadrantes[0]" ,status:"NO"},
						 {t:"5 - Na reset() setar opcidade de ate" ,status:"NO"}
						 
			          ]
		     }
        ];
	
	
}

