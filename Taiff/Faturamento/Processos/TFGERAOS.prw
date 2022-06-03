#INCLUDE "Protheus.ch"
#INCLUDE "Topconn.ch"
#DEFINE ENTER CHR(13) + CHR(10)
/*
+--------------------------------------------------------------------------------------------------------------
|FUNCAO: TFGERAOS                                     AUTOR: CARLOS ALDAY TORRES               DATA: 15/05/2013   
+--------------------------------------------------------------------------------------------------------------
|DESCRICAO: Rotina do Projeto AVANTE para apresentar os pedidos a separar unidade de negocio PROART 
+--------------------------------------------------------------------------------------------------------------
Recon
*/
User Function TFGERAOS()

	Local xZc1Alias		:= ""
	Local cAlias  		:= "SC5"
	Local aCores  		:= {}
	Local nI			:= 0

	Private cCadastro	:= "Separação de Pedidos"
	Private aRotina  	:= {}
	Private aIndexZC1	:= {}
	Private bFiltraBrw	:= { || FilBrowse(cAlias,@aIndexZC1,@cFiltra) }
	Private _cEmpMestre	:= ""
	Private _cFilMestre	:= ""
	Private aCpos		:= {}
	Private aCampos	:= {}

	dbSelectArea("SC5")

	xZc1Alias	:= SC5->(GetArea())

/*
|=================================================================================
|   COMENTARIO
|---------------------------------------------------------------------------------
|	Incluido Status Vermelho para Pedidos com Bloqueio de Cliente na Empresa 
| Destino
|
|	Edson Hornberger - 26/08/2014
|=================================================================================
*/

	AADD(aCores,{"SC5->C5_YSTSEP = 'B'"													,"BR_VERMELHO"	})
	AADD(aCores,{"SC5->C5_YSTSEP $ ' |N' .AND. !U_LibParcC9()	.AND.	!U_Encerr()"	,"BR_AMARELO"	})
	AADD(aCores,{"SC5->C5_YSTSEP = 'N' .AND. 	U_LibParcC9()	.AND.	!U_Encerr()"	,"BR_CINZA"		})
	AADD(aCores,{"SC5->C5_YSTSEP = 'S' .AND. !U_VERZZG()"								,"BR_AZUL"		})
	AADD(aCores,{"SC5->C5_YSTSEP = 'C' .OR.	U_VERZZG()"									,"BR_PINK"		})

/*
C5_YSTSEP $  ' N'	.AND. 	!U_LibParcC9()	.AND. C5_YFMES <> 'S' .AND.	!U_Encerr()	",'BR_AMARELO'
C5_YSTSEP $  ' N'	.AND. 	U_LibParcC9()	.AND. C5_YFMES <> 'S' .AND.	!U_Encerr()	","BR_CINZA"
C5_YSTSEP $  'S' 	.AND.	C5_YFMES <> 'S' .AND. !U_VERZZG()			",'BR_AZUL'
(C5_YSTSEP $ 'C' 	.OR. 	U_VERZZG()) 	.AND. C5_YFMES <> 'S' 		",'BR_PINK'
*/
	AADD(aRotina,{"Pesquisar"		,"PesqBrw"							,0,1})
	AADD(aRotina,{"Recalculo"		,"U_ZC1prtm03(SC5->C5_NUM)"		,0,6})
	AADD(aRotina,{"Imprime Etq."	,"U_TFETIQ_OS"						,0,6})
	AADD(aRotina,{"Cons. Embal."	,"U_PRTC0001"						,0,6})
	AADD(aRotina,{"Estorna SEP"		,"U_TF_ESTRNOC"						,0,3})
	AADD(aRotina,{"Legenda"			,"U_ZC1Legenda"						,0,6})

	dbSelectArea(cAlias)
	dbSetOrder(1)
//Eval(bFiltraBrw) // metodo filtro

	AADD(aCpos,	"C5_NUM"		)
	AADD(aCpos,	"C5_FILDES"	)
	AADD(aCpos,	"C5_NUMOLD"	)
	AADD(aCpos,	"C5_NOMCLI"	)
	AADD(aCpos,	"C5_YSTSEP"	)
	AADD(aCpos,	"C5_CLIEST"	)
	If SC5->(FIELDPOS("C5_C9DTLIB")) != 0
		AADD(aCpos,	"C5_C9DTLIB"	)
	EndIf


	dbSelectArea("SX3")
	dbSetOrder(2)
	For nI := 1 To Len(aCpos)
		IF dbSeek(aCpos[nI])
			AADD(aCampos,{ Trim(X3_TITULO) , X3_CAMPO })
		ENDIF
	Next


// metodo passando parametro cExprFilTop no MBROWSE: Expressão de filtro para execução somente em ambiente TOP, a expressão deve ser SQL.
	cExprFilTop := " C5_FILIAL = '"+xFilial('SC5')+"' " + ENTER
	cExprFilTop += "	AND C5_YSTSEP IN ('S','C','N','B') " + ENTER
	cExprFilTop += "	AND C5_LIBEROK	!=	'E' " + ENTER
	cExprFilTop += "	AND C5_NOTA		=	'' " + ENTER
	cExprFilTop += "	AND C5_XITEMC		=	'PROART' " + ENTER
	cExprFilTop += "	AND C5_LIBCOM != '2' " + ENTER
	cExprFilTop += "	AND D_E_L_E_T_	= '' " + ENTER
	cExprFilTop += "	AND EXISTS "  + ENTER
	cExprFilTop += " 		( " + ENTER
	cExprFilTop += "		SELECT 'OK' " + ENTER
	cExprFilTop += "		FROM " + RetSqlName( "SA1" ) + " SA1 " + ENTER
	cExprFilTop += "		WHERE SA1.D_E_L_E_T_	= '' " + ENTER
	cExprFilTop += "		AND SA1.A1_FILIAL	= C5_FILDES " + ENTER
	cExprFilTop += "		AND ( "  + ENTER
	cExprFilTop += "			(SA1.A1_COD = C5_CLIENTE AND SA1.A1_LOJA = C5_LOJACLI AND C5_FILDES = '02') " + ENTER
	cExprFilTop += "			 OR " + ENTER
	cExprFilTop += "			(SA1.A1_COD = C5_CLIORI AND SA1.A1_LOJA	= C5_LOJORI AND C5_FILDES = '01' AND C5_CLIORI!='') " + ENTER
	cExprFilTop += "			 OR " + ENTER
	cExprFilTop += "			(SA1.A1_COD = C5_CLIENTE AND SA1.A1_LOJA	= C5_LOJACLI AND C5_FILDES = '01' AND C5_CLIORI='') " + ENTER
	cExprFilTop += "		 	 ) " + ENTER
	cExprFilTop += "		AND SA1.A1_MSBLQL != '1' " + ENTER
	cExprFilTop += " 		) " + ENTER
	cExprFilTop += "	AND "  + ENTER
	cExprFilTop += "		( " + ENTER
	cExprFilTop += "		SELECT COUNT(*) ITENS_LIB " + ENTER
	cExprFilTop += "		FROM " + RetSqlName( "SC9" ) + " SC9 " + ENTER
	cExprFilTop += "		WHERE SC9.D_E_L_E_T_='' " + ENTER
	cExprFilTop += "		AND C9_FILIAL=C5_FILIAL "  + ENTER
	cExprFilTop += "		AND C9_PEDIDO=C5_NUM " + ENTER
	cExprFilTop += "		AND C9_NFISCAL='' " + ENTER
	cExprFilTop += "		AND C9_BLEST != '02' " + ENTER
	cExprFilTop += "		) > 0 " + ENTER

	//MEMOWRITE( "TFGERAOS_Browse_SC5.SQL",cExprFilTop)

//MBROWse(6,1,22,75,cAlias,,,,,,aCores,,,,{|x| TimeRefresh(x)}) // metodo filtro
	MBROWse(6,1,22,75,cAlias,aCampos,,,,,aCores,,,,NIL,NIL,NIL,NIL, cExprFilTop ,30000,{|| zc0Browse(GetObjBrow()) })

EndFilBrw(cAlias,aIndexZC1)

RestArea(xZc1Alias)

Return(.T.)

/*
--------------------------------------------------------------------------------------------------------------
Desativa e Ativa o objeto Browse
--------------------------------------------------------------------------------------------------------------
*/
static Function zc0Browse(oObjBrow)

	oObjBrow:Refresh()

Return .T.


/*
--------------------------------------------------------------------------------------------------------------
Refresh do MBROwSE
--------------------------------------------------------------------------------------------------------------
*/
Static Function TimeRefresh(oBrowse)

	Local oTimer
	Local nMSgundos	:= 30000 // Menor valor 1000 no entanto causa lentidão ao navegar pelo Browse
//  1 segundo  =  1000 milisegundos
// 60 segundos = 60000 milisegundos
// 30 segundos = 30000 milisegundos
	oTimer := TTimer():New(nMSgundos, {|| tmBrowse(GetObjBrow(),oTimer) }, oBrowse)
	oTimer:Activate()

Return .T.

/*
--------------------------------------------------------------------------------------------------------------
Desativa e Ativa o objeto Browse
--------------------------------------------------------------------------------------------------------------
*/
static Function TmBrowse(oObjBrow,oTimer)

	oTimer:Deactivate()
	oObjBrow:Refresh()
	oTimer:Activate()

Return .T.

/*
--------------------------------------------------------------------------------------------------------------
Consulta Pedido da OS selecionada da ZC0
--------------------------------------------------------------------------------------------------------------
*/
User Function TF_ESTRPED()

	dbSelectArea("SC5")
	U_PRTM0003()
	dbSelectArea("SC5")

Return NIL

/*
--------------------------------------------------------------------------------------------------------------
Estorna Ordem de Separação
--------------------------------------------------------------------------------------------------------------
*/
User Function TF_ESTRNOC()

	Local xAnteAlias		:= SC5->(GetArea())
	Local xZc0Alias			:= ""
	Local cZC0Alias  		:= "SC5"
	Local aCores  			:= {}
	Local cZC0Filtra 		:= "C5_FILIAL == '"+xFilial('SC5')+"' .AND. C5_YSTSEP $ 'G' .AND. C5_NOTA='' .AND. C5_LIBEROK!='E' .AND. C5_XITEMC='PROART' "

	Private cZC0Cadastro	:= "Separação de Pedidos"
	Private aRotina  		:= {}
	Private aZC0Index		:= {}
	Private bZC0FiltraBrw	:= { || FilBrowse(cZC0Alias,@aZC0Index,@cZC0Filtra) }
	Private _cEmpMestre		:= ""
	Private _cFilMestre		:= ""

EndFilBrw(cZC0Alias,{})

xZc0Alias	:= SC5->(GetArea())

AADD(aCores,{"C5_YSTSEP='G'"	,"BR_BRANCO"	})

AADD(aRotina,{"Pesquisar"		,"PesqBrw"				,0,1})
AADD(aRotina,{"Recalculo"		,"U_TF_ESTRPED"		,0,6})
AADD(aRotina,{"Legenda"			,"U_ZC1Legenda"		,0,6})

dbSelectArea(cZC0Alias)
dbSetOrder(1)
Eval(bZC0FiltraBrw)
dbGoTop()

MBROWse(6,1,22,75,cZC0Alias,,,,,,aCores,,,,,.F.)

EndFilBrw(cZC0Alias,aZC0Index)

Eval(bFiltraBrw)

RestArea(xAnteAlias)

Return NIL

/*
--------------------------------------------------------------------------------------------------------------
Função: Legenda
--------------------------------------------------------------------------------------------------------------
*/
User Function ZC1Legenda()

	Local aLegenda := {}

	AADD(aLegenda,{"BR_VERMELHO"	,	"Cad. cliente Bloqueado no Destino"			})
	AADD(aLegenda,{"BR_AMARELO"		,	"Pedido Liberado / Aguardando Separacao" 	})
	AADD(aLegenda,{"BR_CINZA"		, 	"Pedido Parcialmente Liberado" 				})
	AADD(aLegenda,{"BR_AZUL"		, 	"Etiq. Separacao Emitida" 					})
	AADD(aLegenda,{"BR_PINK"		,	"Pedido Lib. em Sep/Conf"					})

	BrwLegenda(cCadastro, "Legenda", aLegenda)

Return Nil

/*
--------------------------------------------------------------------------------------------------------------
Função: Recalculo
--------------------------------------------------------------------------------------------------------------
*/
User Function ZC1prtm03( _cNumPedido )

	SC5->(DbSetOrder(1))
	SC5->(DbSeek(xFilial("SC5")+_cNumPedido))
	U_PRTM0003()

Return Nil

