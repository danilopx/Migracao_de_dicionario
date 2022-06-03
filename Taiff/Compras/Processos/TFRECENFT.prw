#INCLUDE "Protheus.ch"
#INCLUDE "Topconn.ch"
#include "TbiConn.ch"                  
#DEFINE ENTER Chr(13)+Chr(10)                  
/*
--------------------------------------------------------------------------------------------------------------
FUNCAO: TFRECENFT                                    AUTOR: CARLOS ALDAY TORRES           DATA: 21/05/2013   
DESCRICAO: Rotina de recebimento da Nfe de Transferencia produtos de UN ProArt - Projeto AVANTE
--------------------------------------------------------------------------------------------------------------
*/
User Function TFRECENFT()
Local cAlias  := "SF1"
Local aCores  := {}
Local cFiltra := "F1_FILIAL == '"+xFilial('SF1')+"' .AND. !Empty(F1_NUMRM) "

Private cCadastro	:= "Recebimento da marca PROART"
Private aRotina  	:= {}                
Private aIndexZC1	:= {}	
Private bFiltraSF1Brw:= { || FilBrowse(cAlias,@aIndexZC1,@cFiltra) }
Private _cEmpMestre := "" 
Private _cFilMestre := "" 
Private _cNfeSerie  := GetNewPar("TF_SERIE","TAIFF=1|PROART=2")	// Condição de pagamento do pedido de "devolução" 5 DIAS

_cNfeSerie  := Substr( _cNfeSerie , At( "PROART=" , _cNfeSerie ) + 7 ,1)

cFiltra += " .AND. Substr(F1_SERIE,1,1)='" + _cNfeSerie + "' "

// aTENÇÃO excluir grupo de perguntas da tabela SX1 -- AjustaSx1( "TFNFTPRM" ) 

xZc1Alias	:= SF1->(GetArea())

AADD(aCores,{"Empty(SF1->F1_XRECEBE)"	,"BR_VERDE"		})
AADD(aCores,{"SF1->F1_XRECEBE='E'"		,"BR_AMARELO"		})
AADD(aCores,{"SF1->F1_XRECEBE='F'"		,"BR_VERMELHO"	})   

AADD(aRotina,{"Pesquisar"	,"PesqBrw"			,0,1})
AADD(aRotina,{"Receber"		,"U_TFEfetNFT"	,0,6})
AADD(aRotina,{"Legenda"		,"U_TFELegenda"	,0,6})

dbSelectArea(cAlias)
dbSetOrder(1)
Eval(bFiltraSF1Brw)

MBROWse(6,1,22,75,cAlias,,,,,,aCores,,,,)
   
EndFilBrw(cAlias,aIndexZC1)


Return(.T.)
/*
--------------------------------------------------------------------------------------------------------------
Função: Legenda
--------------------------------------------------------------------------------------------------------------
*/
User Function TFELegenda()

Local aLegenda := {}

AADD(aLegenda,{"BR_VERDE"		, 	"Aguardando confirmação de entrada"	})
AADD(aLegenda,{"BR_VERMELHO"	,	"Recebimento Finalizado"	})
AADD(aLegenda,{"BR_AMARELO"		,	"Recebimento em andamento"	})

BrwLegenda(cCadastro, "Legenda", aLegenda)

Return Nil

/*
--------------------------------------------------------------------------------------------------------------
Função: Recebimento de Ordem de Carga
--------------------------------------------------------------------------------------------------------------
*/
User Function TFEfetNFT()
Local cQuery		:= ""
//Local cUpdate 		:= ""
Local _cNegocio	:= ""
Local cTfClassif	:= ""

Private mTRFPedidos	:= ""
Private cPerg			:= 'ZC1RECNFT'
Private cMarca  		:= GetMark()
Private __cNFTFornece := "" 
Private __cNFTLjFornc := "" 
Private _cEmpMestre	 := "" // Substr(GetNewPar("TF_NFTEMPF",'0302'),1,2) 
Private _cFilMestre	 := "" // Substr(GetNewPar("TF_NFTEMPF",'0302'),3,2)
Private __cNFTTransp	 := ""
Private __cNfEntrada
Private __cSerieEntrada
Private __cSF2Fornece := ""  
Private __cSF2LjFornc := ""
Private cChvCrossDock	:= ""

If .NOT. U_TFEmpFilial() //cempant=_cEmpMestre .and. cfilant=_cFilMestre

	MsgAlert("Acesso não permitido à rotina Recebimento Nfe de Transferencia!")

Else
	__cNfEntrada	:= SF1->F1_DOC
	__cSerieEntrada:= SF1->F1_SERIE
	__cNFTFornece := SF1->F1_FORNECE
	__cNFTLjFornc := SF1->F1_LOJA

	SF2->(DbSetOrder(1))
	SF2->(DbSeek( _cFilMestre + __cNfEntrada + __cSerieEntrada + __cSF2Fornece + __cSF2LjFornc ))

	SF1->(DbSetOrder(1))
	If SF1->(DbSeek( xFilial("SF1") + __cNfEntrada + __cSerieEntrada + __cNFTFornece + __cNFTLjFornc  ))
		If .NOT. U_TFSelecNFT()
			MsgAlert("Acesso não permitido à rotina Recebimento Nfe de Transferencia não selecionada!")
		ElseIf SF1->F1_XRECEBE = "F" .AND. !SF1->(Eof())
			MsgAlert("Processo de recebimento já realizado para está Nfe de Transferencia!")
		Else
			_cNegocio := ""
			cTfClassif	:= ""
			SD1->(DbSetOrder(1))
			If SD1->(DbSeek( xFilial("SD1") + __cNfEntrada + __cSerieEntrada + __cNFTFornece + __cNFTLjFornc ))
				While SD1->(D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA) = (xFilial("SD1") + __cNfEntrada + __cSerieEntrada + __cNFTFornece + __cNFTLjFornc) .and. !SD1->(Eof())
					_cNegocio := SD1->D1_ITEMCTA 
					If Empty(SD1->D1_TES)
						cTfClassif	:= "NAO"
					EndIf
					SD1->(DbSkip())
				End 
			EndIf
			If SF2->(Eof())
				MsgAlert("Nfe de Transferencia sem dados de origem (SF2), verifique com a área fiscal o número correto!")
			ElseIf _cNegocio != "PROART"
				MsgAlert("Pedidos da nota fiscal no.: "+SF1->F1_DOC+" não correspondem à PROART!")
			ElseIf cTfClassif = "NAO" 
				MsgAlert("Nota fiscal de entrada não classificada, isto impossibilita o prosseguimento!")
			Else
				cQuery := "SELECT ISNULL(SUM(DA_SALDO),0) AS 'DA_SALDO' " + ENTER
				cQuery += "	,ISNULL(DA_DOC,'VAZIO') AS 'DA_DOC' " + ENTER
				cQuery += "FROM "+ RetSqlName("SDA") +" SDA " + ENTER
				cQuery += "WHERE " + ENTER
				cQuery += "	DA_FILIAL	= '"+xFilial("SDA")+"' " + ENTER
				cQuery += "	AND DA_DOC	= '"+__cNfEntrada+"' " + ENTER
				cQuery += "	AND DA_SERIE	= '"+__cSerieEntrada+"' " + ENTER
				cQuery += "	AND D_E_L_E_T_	= '' " + ENTER
				cQuery += "	GROUP BY DA_DOC " + ENTER
				
				
				MemoWrite("TFRECENFT_QrySDAchek.SQL",cQuery)
				
				If Select("TMPNFT") > 0
					TMPNFT->(DbCloseArea())
				Endif
				TcQuery cQuery NEW ALIAS ("TMPNFT")
		
				If TMPNFT->DA_DOC='VAZIO'  
					TMPNFT->(DbCloseArea())
					MsgAlert("Nota fiscal de entrada não classificada, isto impossibilita o prosseguimento!")
				ElseIf TMPNFT->DA_SALDO>0
					TMPNFT->(DbCloseArea())
					MsgAlert("Há itens da nota fiscal de entrada pendentes de enderaçamento, isto impossibilita o prosseguimento!")
				Else

					/*
					Busca o numero da carga dos pedidos gerados na nota fiscal de origem (filial mestre do Cross Docking).
					*/
					cQuery := "SELECT " + ENTER
					cQuery += "	DISTINCT SC9.C9_NUMOF " + ENTER
					cQuery += "FROM "+ RetSqlName("SC9") + " SC9 WITH(NOLOCK) " + ENTER
					cQuery += "WHERE " + ENTER
					cQuery += "	SC9.D_E_L_E_T_	= '' " + ENTER
					cQuery += "	AND C9_FILIAL	= '" + _cFilMestre + "' " + ENTER
					cQuery += "	AND C9_NFISCAL	= '" + __cNfEntrada + "' " + ENTER
					cQuery += "	AND C9_SERIENF	= '" + __cSerieEntrada + "' " + ENTER
					cQuery += "	AND C9_CLIENTE	= '" + __cSF2Fornece + "' " + ENTER
					cQuery += "	AND C9_LOJA 	= '" + __cSF2LjFornc + "' " + ENTER
					
					MemoWrite("TFRECENFT_C9_NUMOF_CARGA.SQL",cQuery)
	
					If Select("TMPSC9") > 0
						TMPSC9->(DbCloseArea())
					Endif
					TcQuery cQuery NEW ALIAS ("TMPSC9")
					If TMPSC9->(Eof()) .and. TMPSC9->(Bof())
						cChvCrossDock := "" 
					Else					
						cChvCrossDock := TMPSC9->C9_NUMOF
					EndIf
					TMPSC9->(DbCloseArea())
					
					/*
					Busca os pedidos gerados na nota fiscal de origem (SD2 + SC5 - filial mestre do Cross Docking).
					*/
					cQuery := "SELECT " + ENTER
					cQuery += "	SC5_MG.C5_NUMORI AS C5_NUM " + ENTER
					cQuery += "	,D2_PEDIDO " + ENTER
					cQuery += "	,D2_ITEMPV " + ENTER
					cQuery += "	,D2_QUANT - D2_XRECLIB AS D2_QUANT" + ENTER
					cQuery += "	,D2_COD " + ENTER
					cQuery += "	,D2_ITEM " + ENTER
					cQuery += "FROM "+ RetSqlName("SD2") + " SD2 WITH(NOLOCK) " + ENTER
					cQuery += "INNER JOIN " + RetSqlName("SC5") + " SC5_MG WITH(NOLOCK) " + ENTER
					cQuery += "	ON SC5_MG.D_E_L_E_T_ 	= '' " + ENTER
					cQuery += "	AND SC5_MG.C5_FILIAL		= D2_FILIAL " + ENTER
					cQuery += "	AND SC5_MG.C5_NUM 		= D2_PEDIDO " + ENTER
					cQuery += "	AND SC5_MG.C5_CLIENTE 	= D2_CLIENTE " + ENTER
					cQuery += "	AND SC5_MG.C5_LOJACLI 	= D2_LOJA " + ENTER
					cQuery += "	AND SC5_MG.C5_XITEMC		= 'PROART' " + ENTER
					cQuery += "WHERE " + ENTER
					cQuery += "	SD2.D_E_L_E_T_	= '' " + ENTER
					cQuery += "	AND D2_FILIAL		= '" + _cFilMestre + "' " + ENTER
					cQuery += "	AND D2_DOC 		= '" + __cNfEntrada + "' " + ENTER
					cQuery += "	AND D2_SERIE 		= '" + __cSerieEntrada + "' " + ENTER
					cQuery += "	AND D2_CLIENTE 	= '" + __cSF2Fornece + "' " + ENTER
					cQuery += "	AND D2_LOJA 		= '" + __cSF2LjFornc + "' " + ENTER
					cQuery += "	AND D2_XRECEBE	!= 'S' " + ENTER
					
					MemoWrite("TFRECENFT_QryPedidosNFT.SQL",cQuery)
	
					If Select("TMPNFT") > 0
						TMPNFT->(DbCloseArea())
					Endif
					TcQuery cQuery NEW ALIAS ("TMPNFT")
					
					If TMPNFT->(Eof()) .and. TMPNFT->(Bof())
						TMPNFT->(DbCloseArea())
						MsgAlert("Pedidos da nota fiscal no.: "+SF1->F1_DOC+" de transferencia não encontrados no CD!")
					Else
						If MsgYesNo("Deseja continuar com o processo?",FunName())
							/*
								Monta variavel com pedidos da nota fiscal de transferencia
							*/
							U_TF_MontaNFT()
							
							/*
								Monta MBROWSE com pedidos da nota fiscal de transferencia
							*/
							U_TF_BROWNFT( mTRFPedidos )
	
						EndIf
					EndIf
				EndIf							
			EndIf
		EndIf
	Else
		MsgAlert("Nfe de Transferencia não existe, verifique com a área fiscal o número correto!")
	EndIf
EndIf
Return(.T.)

/*
--------------------------------------------------------------------------------------------------------------
Seleciona empresa/filial de origem da operação
--------------------------------------------------------------------------------------------------------------
*/
User Function TFEmpFilial()
Local aSalvSM0 := SM0->( GetArea() )
Local aCombo   := {}
Local aFilial	:= {}
Local aEmpresa	:= {}
Local aCGCOri	:= {}
Local oDlg, oButton, oCombo, cCombo
Local cQuery

SM0->(DbGotop())
While !SM0->( EOF() )
	aAdd(aCombo		, Alltrim(SM0->M0_NOME) + "/" + Alltrim(SM0->M0_FILIAL) )
	aAdd(aEmpresa	, SM0->M0_CODIGO )
	aAdd(aFilial	, SM0->M0_CODFIL )
	aAdd(aCGCOri	, SM0->M0_CGC )
	SM0->( dbSkip() )
End
RestArea( aSalvSM0 )

cCombo:= aCombo[5]

DEFINE MSDIALOG oDlg FROM 0,0 TO 150,250 PIXEL TITLE "Origem da Nfe"

@ 006,006 SAY "Selecione Empresa Origem da Transferencia" SIZE 120, 07 OF oDlg PIXEL

oCombo:= tComboBox():New(20,10,{|u|if(PCount()>0,cCombo:=u,cCombo)},aCombo,100,20,oDlg,,,,,,.T.,,,,,,,,,"cCombo")

@ 42,35 BUTTON oButton PROMPT "Fechar" OF oDlg PIXEL ACTION oDlg:End()
ACTIVATE MSDIALOG oDlg CENTERED

_cEmpMestre := aEmpresa[ Ascan( aCombo , {|x| x == cCombo} ) ]
_cFilMestre := aFilial[ Ascan( aCombo , {|x| x == cCombo} ) ]

cQuery := "SELECT A2_COD, A2_LOJA "
cQuery += "FROM "+ RetSqlName("SA2") + " SA2 WITH(NOLOCK) "
cQuery += "WHERE "
cQuery += "	A2_FILIAL			= '"+xFilial("SA2")+"' "
cQuery += "	AND A2_CGC			= '"+aCGCOri[ Ascan( aCombo , {|x| x == cCombo} ) ]+"' "
cQuery += "	AND D_E_L_E_T_		= '' "

If Select("TMPCGC") > 0
	TMPCGC->(DbCloseArea())
Endif
TcQuery cQuery NEW ALIAS ("TMPCGC")

__cNFTFornece := TMPCGC->A2_COD 
__cNFTLjFornc := TMPCGC->A2_LOJA

TMPCGC->(DbCloseArea())

cQuery := "SELECT A1_COD, A1_LOJA "
cQuery += "FROM "+ RetSqlName("SA1") + " SA1 WITH(NOLOCK) "
cQuery += "WHERE "
cQuery += "	A1_FILIAL			= '" + _cFilMestre + "' "
cQuery += "	AND A1_CGC			= '" + SM0->M0_CGC + "' "
cQuery += "	AND D_E_L_E_T_		= '' "

If Select("TMPCGC") > 0
	TMPCGC->(DbCloseArea())
Endif
TcQuery cQuery NEW ALIAS ("TMPCGC")

__cSF2Fornece := TMPCGC->A1_COD 
__cSF2LjFornc := TMPCGC->A1_LOJA

TMPCGC->(DbCloseArea())


Return .T.

/*
--------------------------------------------------------------------------------------------------------------
Seleção da Nfe Origem
--------------------------------------------------------------------------------------------------------------
*/
User Function TFSelecNFT
Local lReturn := .F.
//Local cQuery := ""
Local _nSF1recno:= SF1->(Recno())
Local _nQtNotas := 0
//Local __cCGCforn
Local aCombo   := {}
Local aNfRecn	:= {}
Local oDlg, oButton1,oButton2, oCombo, cCombo
Local lContinue:=.F.

If .NOT. SF1->(DbSeek( xFilial("SF1") + __cNfEntrada + __cSerieEntrada + __cNFTFornece + __cNFTLjFornc ))

	SF1->(DbSeek( xFilial("SF1") + __cNfEntrada + __cSerieEntrada ))
	SA2->(DbSetOrder(1))
	While SF1->(F1_FILIAL+F1_DOC+F1_SERIE)=xFilial("SF1") + __cNfEntrada + __cSerieEntrada  .and. !SF1->(Eof())
		SA2->(DbSeek( xFilial("SA2")+SF1->F1_FORNECE+SF1->F1_LOJA ))
		If !Empty(SF1->F1_NUMRM)
			aAdd(aCombo		, Substr(SA2->A2_NOME,1,40) )
			aAdd(aNfRecn	, SF1->(Recno()) )
			_nQtNotas++
		EndIf
		SF1->(DbSkip())
	End
	
	/* Se houve mais de uma nota com a mesma numeração e 
	*/
	If _nQtNotas > 1
		DEFINE MSDIALOG oDlg FROM 0,0 TO 150,250 PIXEL TITLE "Fornecedores com Ordem de Carga"
		
		oCombo:= tComboBox():New(10,10,{|u|if(PCount()>0,cCombo:=u,cCombo)},aCombo,100,20,oDlg,,,,,,.T.,,,,,,,,,"cCombo")
		
		@ 40,10 BUTTON oButton1 PROMPT "Confirmar"	Size 30,15 OF oDlg PIXEL ACTION {||oDlg:End(),lContinue := .T.}
		@ 40,90 BUTTON oButton2 PROMPT "Fechar" 		Size 30,15 OF oDlg PIXEL ACTION {||oDlg:End(),lContinue := .F.}
		ACTIVATE MSDIALOG oDlg CENTERED
	   
		If lContinue
			SF1->(DbGoto( aNfRecn[Ascan( aCombo , {|x| x == cCombo} )] ))
		                                                  
			__cNFTFornece := SF1->F1_FORNECE
			__cNFTLjFornc := SF1->F1_LOJA
		
			lReturn := .T.
		EndIf
	Else
		SF1->(DbGoto( _nSF1recno ))
		                                                  
		__cNFTFornece := SF1->F1_FORNECE
		__cNFTLjFornc := SF1->F1_LOJA
		
		lReturn := .T.
	EndIf
Else
	lReturn := .T.
EndIf
Return (lReturn)

/*
--------------------------------------------------------------------------------------------------------------
Função: Legenda
--------------------------------------------------------------------------------------------------------------
*/
User Function NFTLegenda()

Local aLegenda := {}

AADD(aLegenda,{"BR_VERDE"		, 	"Pedido não confirmado" 		})
AADD(aLegenda,{"BR_VERMELHO"	,	"Pedido confirmado" 			})
AADD(aLegenda,{"BR_AZUL"			,	"Pedido confirmado parcial" })
/*
AADD(aLegenda,{"BR_AZUL"		,	"Pedido não confirmado com Etiqueta impressa" })
AADD(aLegenda,{"BR_AMARELO"	,	"Pedido Rejeitado"					})
AADD(aLegenda,{"BR_LARANJA"	,	"Pedido Rejeitado Devolvido"		})
AADD(aLegenda,{"BR_CINZA"		,	"Pedido Sintético de Devolução"	})
AADD(aLegenda,{"BR_MARRON"		,	"Qtd. Liberada na origem difere Qtd. do Pedido"	})
*/

BrwLegenda(cCadastro, "Legenda", aLegenda)

Return Nil


/*
--------------------------------------------------------------------------------------------------------------
Browse da Nfe de transferencia
--------------------------------------------------------------------------------------------------------------
*/
User Function TF_BROWNFT(mTRFPedidos)
Local xSc5Alias	:= ""
Local xSf1Alias	:= SF1->(GetArea())
Local cAlias  := "SC5"
Local aCores  := {}
Local cFiltra := "C5_FILIAL == '"+xFilial('SC5')+"' .AND. C5_NUM $ '"+mTRFPedidos+"'"
Local mCampos := {}

Private cCadastro	:= "Confirmação de Pedidos"
Private aRotina  	:= {}                
Private aIndexSC5	:= {}	
Private bFiltraBrw:= { || FilBrowse(cAlias,@aIndexSC5,@cFiltra) }

xSc5Alias	:= SC5->(GetArea())

 
AADD(aCores,{"Empty(C5_XSTACON)","BR_VERDE"		})
AADD(aCores,{"C5_XSTACON='I'"	,"BR_AZUL"		})
AADD(aCores,{"C5_XSTACON='C'"	,"BR_VERMELHO"	})
AADD(aCores,{"C5_XSTACON='R'"	,"BR_AMARELO"	})
AADD(aCores,{"C5_XSTACON='D'"	,"BR_LARANJA"	})
AADD(aCores,{"C5_XSTACON='S'"	,"BR_CINZA"		})
AADD(aCores,{"C5_XSTACON='P'"	,"BR_MARRON"	})

AADD(aRotina,{"Pesquisar"			,"PesqBrw"				,0,1})
AADD(aRotina,{"Confirmar Entr"		,"U_NFTconfirma"		,0,6})
AADD(aRotina,{"Legenda"				,"U_NFTLegenda"		,0,6})

SetKey(VK_F12,{|| U_TFNfTativa()})

dbSelectArea(cAlias)

dbSetOrder(1)
(cAlias)->(dbGoTop())

Eval(bFiltraBrw)

AADD(mCampos, {"C5_OK"			, NIL ,"Ok"  })
AADD(mCampos, {"C5_NUMOLD"		, NIL ,"Nro.Portal"})
AADD(mCampos, {"C5_EMISSAO"		, NIL ,"Emissão"})
AADD(mCampos, {"C5_NUM"			, NIL ,"Pedido CD"})
AADD(mCampos, {"C5_NOMCLI"		, NIL ,"Cliente"})

MARKBROW(cAlias,"C5_OK",,mCampos,,cMarca,'U_SC5MarkAll(cMarca)',,,,'U_SC5Mark(cMarca)',,,,aCores)

EndFilBrw(cAlias,aIndexSC5)

RestArea(xSc5Alias)
RestArea(xSf1Alias)
Return NIL

/*
--------------------------------------------------------------------------------------------------------------
Monta variavel com numero de pedidos da nota fiscal de transferencia
--------------------------------------------------------------------------------------------------------------
*/
User Function TF_MontaNFT()
Local cNumChave := ""

mTRFPedidos := ""

TMPNFT->(DbGoTop())
While !TMPNFT->(Eof())
	mTRFPedidos += TMPNFT->C5_NUM +"|"
	If SC5->(DbSeek( xFilial("SC5") + TMPNFT->C5_NUM ))	
		SC5->(RecLock("SC5", .F.))
		SC5->C5_XSTACON := ''
		SC5->(MsUnLock())
	EndIf
	cNumChave := TMPNFT->C5_NUM 
	While  TMPNFT->C5_NUM = cNumChave .and. !TMPNFT->(Eof()) 
		TMPNFT->(DbSkip())
	End
End

Return .T.

/*
--------------------------------------------------------------------------------------------------------------
Função marca/desmarca individual
--------------------------------------------------------------------------------------------------------------
*/
User Function SC5Mark( cMarca )
//Local cUpdate := ""

dbSelectArea('SC5')
If IsMark('C5_OK',cMarca)
	RecLock('SC5',.F.)
	C5_OK := Space(2)
	MsUnLock()
Else
	If .not. SC5->C5_XSTACON $ 'C'
		RecLock('SC5',.F.)
		C5_OK := cMarca 
		MsUnLock()
	EndIf
EndIf
Return

/*
--------------------------------------------------------------------------------------------------------------
Função marca/desmarca todos
--------------------------------------------------------------------------------------------------------------
*/
User Function SC5MarkTodos(cMarca)
Local nRecno:=Recno()

dbSelectArea('SC5')
ProcRegua(RecCount()) // Numero de registros a processar
SC5->(dbGotop())
While !SC5->(Eof())
	IncProc()
	U_SC5Mark(cMarca)
	SC5->(dbSkip())
End
SC5->(dbGoto(nRecno))
Return        

/*
--------------------------------------------------------------------------------------------------------------
Função de progresso marcadora de registros
--------------------------------------------------------------------------------------------------------------
*/
User Function SC5MarkAll(cMarca)
Processa({|| U_SC5MarkTodos(cMarca) },"Processando...")
Return NIL

/*
--------------------------------------------------------------------------------------------------------------
Confirmação da entrada do pedido
--------------------------------------------------------------------------------------------------------------
*/
User Function NFTconfirma()
Local __nMarcaOk	:= 0
//Local __lHaDevolucao := .F.
Local __cMensagem	:= ""
Local xSf1Alias	:= SF1->(GetArea())
Local _nSf1Recno	:= SF1->(Recno())

__cMensagem	:= "Ao confirmar esta rotina para os pedidos selecionados será executada a rotina de:"
__cMensagem	+= chr(13)+chr(10)
__cMensagem	+= "a) Liberação de pedidos para faturamento."+chr(13)+chr(10)
__cMensagem	+= "Deseja realmente confirmar?"

If MsgYesNo(  __cMensagem  ,FunName())
	DbSelectArea("SC5")
	SC5->(DbSetOrder(1))
	TMPNFT->(DbGoTop())
	While !TMPNFT->(Eof())
		If SC5->(DbSeek( xFilial("SC5") + TMPNFT->C5_NUM ))	
			__nMarcaOk	+= IIf(SC5->C5_OK=cMarca ,1,0)
		EndIf
		TMPNFT->(DbSkip())
	End
	If __nMarcaOk = 0
		MsgAlert("Não há pedidos selecionados para dar prosseguimento com a liberação!")
	Else
		EndFilBrw("SC5",{})

		U_TFNFTLIB()  /* Libera pedidos confirmados */

		RestArea(xSf1Alias)
		DbSelectArea("SF1")
		dbSetOrder(1)
		Eval(bFiltraSF1Brw)
		SF1->(DbGoto( _nSf1Recno ))

		/*
		Limpa conteúdo do campo "marca" (C5_OK) para os pedidos selecionados, desta forma o browse se 
		recompõe 
		*/
		DbSelectArea("SC5")
		SC5->(DbSetOrder(1))
		TMPNFT->(DbGoTop())
		While !TMPNFT->(Eof())
			If SC5->(DbSeek( xFilial("SC5") + TMPNFT->C5_NUM ))	
				If SC5->C5_OK=cMarca
					SC5->(RecLock("SC5", .F.))
					SC5->C5_OK:=''
					SC5->(MsUnLock())
				EndIf
			EndIf
			TMPNFT->(DbSkip())
		End

		DbSelectArea("SC5")
		dbSetOrder(1)
		Eval(bFiltraBrw)
		SC5->(DbGotop())

		MsgAlert("Processamento finalizado!!!")
	EndIf            
EndIf
Return NIL

/*
--------------------------------------------------------------------------------------------------------------
Libera pedidos confirmados
--------------------------------------------------------------------------------------------------------------
*/		
User Function TFNFTLIB(nTotPrevisto , nTotLiberado ) 
//Local lRetorno:= .F.
Local nPedPrevisto := 0
Local nPedLiberado := 0
// Local nTotPrevisto := 0
// Local nTotLiberado := 0

nTotPrevisto := 0
nTotLiberado := 0

lCredito	:= .F. /* Nunca alterar este parametro deve ser mantido como FALSE */
lEstoque	:= .T.
lLiber	:= .F. /* Nunca alterar este parametro deve ser mantido como FALSE */
lTransf	:= .F.
If GetMv("MV_ESTNEG") == "S"
	lAvEst:= .f.
Else
	lAvEst:= .t.
Endif                        
/*
Função: MaLibDoFat
Retorna Quantidade Liberada
Parametros                	
	ExpN1: Registro do SC6                                      
	ExpN2: Quantidade a Liberar                                 
	ExpL3: Bloqueio de Credito                                  
	ExpL4: Bloqueio de Estoque                                  
	ExpL5: Avaliacao de Credito                                 
	ExpL6: Avaliacao de Estoque                                 
	ExpL7: Permite Liberacao Parcial                            
	ExpL8: Tranfere Locais automaticamente                      
	ExpA9: Empenhos (Caso seja informado nao efetua a gravacao apenas avalia)
	ExpbA: CodBlock a ser avaliado na gravacao do SC9          
	ExpAB: Array com Empenhos previamente escolhidos (impede selecao dos empenhos pelas rotinas)         
	ExpLC: Indica se apenas esta trocando lotes do SC9         
	ExpND: Valor a ser adicionado ao limite de credito         
	ExpNE: Quantidade a Liberar - segunda UM                   

Parametros: MaLiberOk
	ExpA1: Array com numero de pedidos
	ExpL2: Elimina residuo

*/
SC6->(DbSetOrder(1))
SC5->(DbSetOrder(1))
SD2->(DbSetOrder(3))
TMPNFT->(DbGotop())
While !TMPNFT->(Eof())
	SC5->(dbSeek(xFilial("SC5")+TMPNFT->C5_NUM)) 
	If SC5->C5_OK=cMarca .AND. !SC5->(Eof())
		cNumChave := TMPNFT->C5_NUM 
		lPedLiberado := .T.
		While TMPNFT->C5_NUM = cNumChave .and. !TMPNFT->(Eof())
			nTotPrevisto += TMPNFT->D2_QUANT
			nPedPrevisto += TMPNFT->D2_QUANT
			If SC6->(DbSeek(xFilial("SC6") + TMPNFT->C5_NUM + TMPNFT->D2_ITEMPV + TMPNFT->D2_COD  )) .AND. TMPNFT->D2_QUANT > 0
				/*			Executar a função padrão PROTHEUS de liberação de pedido	MaLibDoFat	*/
				nQtdLib := MaLibDoFat(SC6->(RecNo()),TMPNFT->D2_QUANT,@lCredito,@lEstoque,.F.,lAvEst,lLiber,lTransf)

				If nQtdLib = 0
					lPedLiberado := .F.
				Else
					If SD2->(DbSeek( _cFilMestre + __cNfEntrada + __cSerieEntrada + __cSF2Fornece + __cSF2LjFornc + TMPNFT->D2_COD + TMPNFT->D2_ITEM ))
						SD2->(RecLock("SD2", .F.))
						SD2->D2_XRECEBE := IIF( TMPNFT->D2_QUANT = nQtdLib ,'T',IIF(TMPNFT->D2_QUANT > nQtdLib ,'P',SD2->D2_XRECEBE) )
						SD2->D2_XRECLIB := SD2->D2_XRECLIB + nQtdLib 
						SD2->(MsUnLock())
					EndIf
				EndIf
				nTotLiberado += nQtdLib 
				nPedLiberado += nQtdLib
			EndIf
			TMPNFT->(DbSkip())			     
		End
		MaLiberOk({ SC5->C5_NUM },.F.)

		/*			Reforçar a atualização do credito na SC9 			*/
		cQuery := "UPDATE " + RetSqlName("SC9") + " SET " + ENTER
		cQuery += "	C9_BLCRED='' " + ENTER
		cQuery += "	,C9_NUMOF= '" + cChvCrossDock + "' " + ENTER
		cQuery += "FROM " + RetSqlName("SC9") + " SC9 WITH(NOLOCK) " + ENTER
		cQuery += "WHERE SC9.D_E_L_E_T_ = '' "   + ENTER
		cQuery += "	AND C9_FILIAL		= '"+xFilial("SC9")+"' " + ENTER
		cQuery += "	AND C9_NFISCAL 	= '' " + ENTER
		cQuery += "	AND C9_PEDIDO 		= '" + SC5->C5_NUM + "' " + ENTER
		cQuery += "	AND C9_NUMOF		= ''"
		MemoWrite("TFRECENT_AtualizaCreditoSC9.sql",cQuery)
		TCSQLExec(cQuery)

		If lPedLiberado
			SC5->(RecLock("SC5", .F.))
			If nPedLiberado = nPedPrevisto
				SC5->C5_XSTACON := 'C'
			ElseIf nPedPrevisto > nPedLiberado 
				SC5->C5_XSTACON := 'I'
			EndIf
			SC5->C5_YSTSEP := 'G'
			SC5->(MsUnLock())

			SF1->(RecLock("SF1", .F.))
			SF1->F1_XRECEBE := 'E'
			SF1->(MsUnLock())
		EndIf
	Else
		nTotPrevisto += TMPNFT->D2_QUANT
		TMPNFT->(DbSkip())
	EndIf
End
/*
Atualiza status da nota fiscal de INTERCOMPANY - SF1
*/
If nTotPrevisto = nTotLiberado
	SF1->(RecLock("SF1", .F.))
	SF1->F1_XRECEBE := 'F'
	SF1->(MsUnLock())
EndIf

Return NIL

