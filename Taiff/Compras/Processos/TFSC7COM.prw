#Include "Protheus.ch"
#INCLUDE "Topconn.ch"
#INCLUDE "fileio.ch"
#INCLUDE "rwmake.ch"

#DEFINE LINHAS 999
#DEFINE USADO CHR(0)+CHR(0)+CHR(1)

//--------------------------------------------------------------------------------------------------------------
// FUNCAO: TFSC7COM                                    AUTOR: CARLOS ALDAY TORRES           DATA: 14/01/2014   
//--------------------------------------------------------------------------------------------------------------
// DESCRICAO: Gera pedido de compra sobre a comissão do representante
// SOLICITANTE: Odair 
//--------------------------------------------------------------------------------------------------------------
User Function TFSC7COM()
	Local xZaqAlias	:= ZAQ->(GetArea())
	Local cAlias  := "ZAQ"
	//Local aCores  := {}
	//Local cFiltra := "  ZAQ_FILIAL == '"+xFilial('ZAQ')+"' "

	Private cCadastro	:= "Gera pedido da comissão"
	Private aRotina  	:= {}
	Private aIndexSA2	:= {}
	Private cProdMC1	:= "975070005"
	Private cProdMC2	:= "975070005"
	Private cCondCom	:= "N22"
//Private bFiltraBrw:= { || FilBrowse(cAlias,@aIndexSA2,@cFiltra) }

	AADD(aRotina,{"Pesquisar"		,"PesqBrw"			,0,1})
	AADD(aRotina,{"Legenda"			,"U_C7SLegenda"	,0,6})
	AADD(aRotina,{"Pedido"			,"U_TFGeraPed"		,0,7})

	dbSelectArea(cAlias)

	dbSetOrder(1)
//Eval(bFiltraBrw)     

	AjustaSx1( "TFSC7COM" )
	SetKey(VK_F12,{|| U_TFCmsativa()})

	mBrowse(6,1,22,75,cAlias,,,,,,U_CM7Legenda(cAlias),,,,,,.F.,,)

EndFilBrw(cAlias,aIndexSA2)
RestArea(xZaqAlias)
Return(.T.)

//+-------------------------------------------
//|Função: BLegenda - Cores da legenda
//+-------------------------------------------
User Function CM7Legenda(cAlias)

	Local aLegenda := { 	{"BR_VERDE"		, 	"Comissão não fechada" 		},;
		{"BR_AMARELO"	, 	"Pedido compra gerado" 		},;
		{"BR_VERMELHO"	, 	"Pedido não gerado"	 		}		}
	Local uRetorno := .T.

	uRetorno := {}

	Aadd(uRetorno, { ' ZAQ->ZAQ_STATUS="F" .AND. ZAQ->ZAQ_GERCOM!="S"', aLegenda[3][1] } )
	Aadd(uRetorno, { ' ZAQ->ZAQ_GERCOM="S" ', aLegenda[2][1] } )
	Aadd(uRetorno, { '.T.', aLegenda[1][1] } )

Return uRetorno

//+-------------------------------------------
//|Função: BLegenda - Rotina de Legenda
//+-------------------------------------------
User Function C7SLegenda()

	Local aLegenda := {}

	AADD(aLegenda,{"BR_VERDE"		, 	"Comissão não fechada" 		})
	AADD(aLegenda,{"BR_VERMELHO"	,	"Pedido não gerado" 			})
	AADD(aLegenda,{"BR_AMARELO"	,	"Pedido Compra Gerado"		})

	BrwLegenda(cCadastro, "Legenda", aLegenda)

Return Nil

//+-------------------------------------------
//|Função: TFGeraPed 
//+-------------------------------------------
User Function TFGeraPed

	If MSGYESNO("Deseja gerar pedido de compra para a comissao do vendedor?")
		Processa( { |lEnd| U_TFprocC7comissao() , "Processando comissoes..." })
	EndIf
Return NIL


//+-------------------------------------------
//|Função: TFprocC7comissao
//+-------------------------------------------
User Function TFprocC7comissao
	Local __dIni := ZAQ->ZAQ_EMISDE
	ProcRegua(SA3->(RecCount()))
	nLook:=1
	ZAQ->(DbSetOrder(1))
	ZAQ->(DbSeek( xFilial("ZAQ") + Dtos(__dIni) ))
	While ZAQ->ZAQ_EMISDE = __dIni   .and.   !ZAQ->(Eof())
		If ZAQ->ZAQ_STATUS="F" .and. ZAQ->ZAQ_GERCOM != "S" .and. nLook=1
			IncProc("Incluindo Pedido...Aguarde...")

		/*Gera pedido de compras para pagamento de comissão*/
			_cMensSC7 := "COMISSAO A PAGAR PERIODO DE "+Dtoc(ZAQ->ZAQ_EMISDE)+" A "+Dtoc(ZAQ->ZAQ_EMISAT)

			TFcriaC7comissao({ZAQ->ZAQ_CODVEN,ZAQ->ZAQ_DTPAGT,ZAQ->ZAQ_VLMRC1,ZAQ->ZAQ_IRMRC1,ZAQ->ZAQ_NMMRC1,cProdMC1,ZAQ->ZAQ_VLMRC2,ZAQ->ZAQ_IRMRC2,ZAQ->ZAQ_NMMRC2,cProdMC2,"6",_cMensSC7})
		/*							1					2						3					4					5						6		7					8					 9		           10		   11     12	*/
			nLook:=2
		EndIf
		ZAQ->(DbSkip())
	End
	ZAQ->(DbSeek( xFilial("ZAQ") + Dtos(__dIni) ))
Return NIL

//--------------------------------------------------------------------------------------------------------------
// Função: TFcriaC7comissao
// Descrição: Altera status para transmissao
//--------------------------------------------------------------------------------------------------------------
Static Function TFcriaC7comissao( _aDadosComis )
	Local aCab		:= {}
	Local aItens	:= {}
	//Local cNumPc	:= ""
	Local aIteComis:= {}
	//Local nElementos:=0
	Local cQuery
	Local _nLoop := 0

	Private lMsHelpAuto := .T.
	Private lMsErroAuto := .F.


	SA3->(DbSetOrder(1))
	SA3->(DbSeek( xFilial("SA3") + _aDadosComis[1] ))

	SA2->(DbSetOrder(1)) // A2_FILIAL, A2_COD, A2_LOJA
	If SA2->(DbSeek(xFilial("SA2")+SA3->A3_FORNECE+SA3->A3_LOJA))

		aAdd(aIteComis,{_aDadosComis[3],_aDadosComis[4],_aDadosComis[5],_aDadosComis[6]})
		aAdd(aIteComis,{_aDadosComis[7],_aDadosComis[8],_aDadosComis[9],_aDadosComis[10]})

		SZD->(DbSetOrder(3))

		dbSelectArea("SC7")

		Begin Transaction

			aCab 		:= {}
			aItens	:= {}

			aAdd(aCab, {"C7_FORNECE", SA3->A3_FORNECE	, Nil})
			aAdd(aCab, {"C7_LOJA"   , SA3->A3_LOJA		, Nil})
			aAdd(aCab, {"C7_COND"   , cCondCom			, Nil})
			aAdd(aCab, {"C7_EMISSAO", dDataBase			, Nil})
			aAdd(aCab, {"C7_CONTATO", " "					, Nil})
			aAdd(aCab, {"C7_FILENT" , cFilAnt			, Nil})

			For _nLoop:= 1 to 2

				If aIteComis[_nLoop][1] > 0
					_nPercnIR := aIteComis[_nLoop][2]
					If _nPercnIR != 0
						_nValorIR := aIteComis[_nLoop][1]*(_nPercnIR/100)
					Else
						_nValorIR := 0
					EndIf
					_cUnidNeg := aIteComis[_nLoop][3]
					_cProduto := aIteComis[_nLoop][4]

					aAdd(aItens, {})
					aAdd(aItens[_nLoop], {"C7_ITEM"		,Strzero(_nLoop,4)		, Nil})
					aAdd(aItens[_nLoop], {"C7_PRODUTO"	,_cProduto					, Nil})
					aAdd(aItens[_nLoop], {"C7_UM"			,"UN"							, Nil})
					aAdd(aItens[_nLoop], {"C7_QUANT"		,1								, Nil})
					aAdd(aItens[_nLoop], {"C7_PRECO"		,aIteComis[_nLoop][1] 	, Nil})
					aAdd(aItens[_nLoop], {"C7_TOTAL"		,aIteComis[_nLoop][1]	, Nil})
					aAdd(aItens[_nLoop], {"C7_BASEIR"	,aIteComis[_nLoop][1]	, Nil})
					aAdd(aItens[_nLoop], {"C7_ALIQIR"	,_nPercnIR					, Nil})
					aAdd(aItens[_nLoop], {"C7_VALIR"		,_nValorIR					, Nil})
					aAdd(aItens[_nLoop], {"C7_LOCAL"		,"NA"							, Nil})
					aAdd(aItens[_nLoop], {"C7_ITEMCTA"	,_cUnidNeg					, Nil})
					aAdd(aItens[_nLoop], {"C7_OBS"		,_aDadosComis[12]			, Nil})
					aAdd(aItens[_nLoop], {"C7_DATPRF"	,dDataBase					, Nil})
					aAdd(aItens[_nLoop], {"C7_DTENTRG"	,_aDadosComis[02]			, Nil})
					aAdd(aItens[_nLoop], {"C7_CLASCON"	,_aDadosComis[11]			, Nil})
					aAdd(aItens[_nLoop], {"C7_MOEDA"		,01							, Nil})

					If SZD->(DbSeek( xFilial("SZD") + _aDadosComis[1] + _cUnidNeg ))
						aAdd(aItens[_nLoop], {"C7_CC"			,SZD->ZD_CCUSTO			, Nil})
					EndIf
				EndIf
			Next

			lMsErroAuto := .F.
			MSExecAuto({|u,v,x,y| MATA120(u,v,x,y)},1,aCab,aItens,3)

			If lMsErroAuto
				Alert("Erro ao cadastrar pedido")
				MostraErro()
				DisarmTransaction()
			Else

				cQuery := "SELECT MAX(C7_NUM) AS C7_NUM "
				cQuery += "FROM "+ RetSqlName("SC7") + " SC7 WITH(NOLOCK) "
				cQuery += "WHERE D_E_L_E_T_= '' "
				cQuery += "	AND C7_FILIAL	= '"+xFilial("SC7")+"' "
				cQuery += "	AND C7_FORNECE	= '"+SA3->A3_FORNECE+"' "
				cQuery += "	AND C7_LOJA		= '"+SA3->A3_LOJA+"' "
				cQuery += "	AND C7_EMISSAO	= '"+DTOS(dDataBase)+"' "
				cQuery += "	AND C7_DTENTRG	= '"+DTOS(_aDadosComis[02])+"' "
				MemoWrite("TFSC7COM_QryNumPc.SQL",cQuery)

				If Select("AUXSC7") > 0
					AUXSC7->(DbCloseArea())
				Endif
				TcQuery cQuery NEW ALIAS ("AUXSC7")

				ZAQ->(RecLock("ZAQ",.F.))
				ZAQ->ZAQ_GERCOM := "S"
				If ZAQ->(FieldPos("ZAQ_NUMPC"))!=0
					ZAQ->ZAQ_NUMPC  := AUXSC7->C7_NUM
				EndIf
				ZAQ->(MsUnlock())
				AUXSC7->(DbCloseArea())
			EndIf

		End Transaction

	EndIf
	dbSelectArea("ZAQ")
Return
/*
--------------------------------------------------------------------------------------------------------------
Pergunta para informar a nota fiscal de transferencia
--------------------------------------------------------------------------------------------------------------
*/
Static Function AjustaSx1(cPerg)

	Local aAreaAnt := GetArea()
	// Local aHelpPor := {}
	// Local aHelpEng := {}
	// Local aHelpSpa := {}

	PutSx1("TFSC7COM","01"   ,"Produto de comissão TAIFF?","Produto de comissão TAIFF?","Produto de comissão TAIFF?"	,"mv_ch1","C",9,0,0,"G","","SB1","","S",;
		"mv_par01", "","","","975070005",;
		"","","",;
		"","","",;
		"","","",;
		"","","",;
		"","","",".TFSC7COM.")

	PutSx1("TFSC7COM","02"   ,"Produto de comissão PROART?","Produto de comissão PROART?","Produto de comissão PROART?"	,"mv_ch2","C",9,0,0,"G","","SB1","","S",;
		"mv_par02", "","","","975070005",;
		"","","",;
		"","","",;
		"","","",;
		"","","",;
		"","","",".TFSC7COM.")

	PutSx1("TFSC7COM","03"   ,"Condição de pagamento?","Condição de pagamento?","Condição de pagamento?"	,"mv_ch3","C",3,0,0,"G","","SE4","","S",;
		"mv_par03", "","","","N22",;
		"","","",;
		"","","",;
		"","","",;
		"","","",;
		"","","",".TFSC7COM.")
	RestArea(aAreaAnt)

Return()

/*
--------------------------------------------------------------------------------------------------------------
Abre perguntas da tecla F12, no caso para o codigo de produto de comissao
--------------------------------------------------------------------------------------------------------------
*/
User Function TFCmsativa()
	Local aArea	:=	GetArea()
	Pergunte("TFSC7COM",.T.)

	cProdMC1	:= mv_par01
	cProdMC2	:= mv_par02
	cCondCom	:= mv_par03

	RestArea(aArea)
Return(.T.)
