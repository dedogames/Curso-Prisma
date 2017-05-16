[![](http://www.prismafs.com.br/wp-content/themes/prisma/img/logo.png)](http://prismafs.com.br/)



## Curso ID 6687 - Conduta - Bussola  - Action Script 2

<p align="center">
  <img width="460" height="300" src="https://dj1hlxw0wr920.cloudfront.net/userfiles/wyzfiles/4325ef97-9128-43a5-b00f-50b50e9e6337.png">
</p>

A Ordem dos quadrantes são importantes para setar a variavel ordemDeExibicaoDosQuadrantes, pois se o primeiro quadrante for 3, a ordem do array ficará [3,2,1,4]. A questão(pergunta) deve ficar no quadrante inicial, ou sej, 3 neste caso.

![](https://www.mathsisfun.com/geometry/images/clockwise.gif)
O timer sempre movimenta no sentindo horário(clockwise)


Caso o usuário erre a primeira questão , ainda haverá duas chances, caso o usuário erro mesmo na terceira tentativa, é reiniciado no primeiro frame no nivel atual.

Devido a fragmentação dos niveis em flash separados, não foi implementado os niveis corridos, portanto é necessário setar o nivel atual.
Dentro do arquivo main.fla há algumas variaveis, abaixo há uma descrição das mesmas

``` 
var tempoExibicaoCadaQuadrante = 50;
var ordemDeExibicaoDosQuadrantes = [2,1,4,3];  // a ordem deve seguir o circulo trigonométrico
var radioTimer = 20;
var corTimer = 0xFFFF00; Linha de contorno do circulo
var corLinhaMapa = 0xFF00FF;


function chamandoAoTerminoDoJogo(instance:GameOrient)
{
	var map:Map = new Map(instance.mainStage["mc_map"],corLinhaMapa,2);
	 
	 Exemplo básico do desenho dos caminhos
	var arr:Array = [
						{mc_start:"mc_start" ,mc_finish:("mc_a"+(instance.compass.lastFrame-1))}
						//,{mc_start:"mc_a1"    ,mc_finish:"mc_b3"},
						//{mc_start:"mc_b3"    ,mc_finish:"mc_c2"},
						//{mc_start:"mc_c2"    ,mc_finish:"mc_finish"}
						];
						
	map.drawPath(arr);
}


setar para false quando for para produção esta variavel imprimie valores no trace 
usando a classe de Logger
var debugMode = true;
var currentLevel = 1;

var niveis:Array = [{nivel:1, correta:[0,3,4,1]}, 
					{nivel:2, correta:[0,1,3,4]}, 
					{nivel:3, correta:[0,1,3,4]}, 
					{nivel:4, correta:[0,1,3,4]}
				    ];

 Clase que contém a lógica do jogo 
var game:GameOrient = new GameOrient(this, currentLevel, niveis, radioTimer, corLinhaMapa, corTimer, tempoExibicaoCadaQuadrante, chamandoAoTerminoDoJogo, ordemDeExibicaoDosQuadrantes, debugMode);
```

## Relação das classes dentro de /src

![](https://github.com/dedogames/Curso-Prisma/blob/86b9780c22120899a7063178786daeb141b16195/classe.png)
