#INCLUDE "Protheus.ch"
#INCLUDE "Topconn.ch"
#include "TbiConn.ch"
#DEFINE ENTER Chr(13)+Chr(10)                  
/*
--------------------------------------------------------------------------------------------------------------
FUNCAO: TFRECTAIFF                                    AUTOR: CARLOS ALDAY TORRES           DATA: 09/03/2015   
DESCRICAO: Rotina de recebimento da Nfe de Transferencia produtos TAIFF
--------------------------------------------------------------------------------------------------------------
*/
User Function TFRECTAIFF()
Local cAlias  := "SF1"
Local aCores  := {}
Local cFiltra := "F1_FILIAL == '"+xFilial('SF1')+"' .AND. !Empty(F1_NUMRM) "
// Local aCols	  := {}
// Local aHeader := {}

Private cCadastro	:= "Recebimento da marca TAIFF"
Private aRotina  	:= {}                
Private aIndexZC1	:= {}	
Private bFiltraSF1Brw:= { || FilBrowse(cAlias,@aIndexZC1,@cFiltra) }
Private _cEmpMestre := "" 
Private _cFilMestre := "" 
Private _cNfeSerie  := GetNewPar("TF_SERIE","TAIFF=1|PROART=2")	// Condição de pagamento do pedido de "devolução" 5 DIAS

_cNfeSerie  := Substr( _cNfeSerie , At( "TAIFF=" , _cNfeSerie ) + 6 ,1) 

cFiltra += " .AND. ( " 
cFiltra += " Substr(F1_SERIE,1,1)='" + _cNfeSerie + "' "
cFiltra += " .OR. F1_SERIE='5' "
cFiltra += " ) "

// aTENÇÃO excluir grupo de perguntas da tabela SX1 -- AjustaSx1( "TFNFTPRM" )
 
xZc1Alias	:= SF1->(GetArea())

AADD(aCores,{"Empty(SF1->F1_XRECEBE)"	,"BR_VERDE"		})
AADD(aCores,{"SF1->F1_XRECEBE='E'"		,"BR_AMARELO"		})
AADD(aCores,{"SF1->F1_XRECEBE='F'"		,"BR_VERMELHO"	})   

AADD(aRotina,{"Pesquisar"	,"PesqBrw"			,0,1})
AADD(aRotina,{"Receber"		,"U_TFEfetTAI"	,0,6})
AADD(aRotina,{"Legenda"		,"U_TFELegenda"	,0,6})

dbSelectArea(cAlias)
dbSetOrder(1)
Eval(bFiltraSF1Brw)

MBROWse(6,1,22,75,cAlias,,,,,,aCores,,,,)
   
EndFilBrw(cAlias,aIndexZC1)


Return(.T.)

/*
--------------------------------------------------------------------------------------------------------------
Função: Recebimento de Ordem de Carga
--------------------------------------------------------------------------------------------------------------
*/
User Function TFEfetTAI()
Local cQuery		:= ""
//Local cUpdate 	:= ""
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
	If SF1->(DbSeek( xFilial("SF1") + __cNfEntrada + __cSerieEntrada + __cNFTFornece + __cNFTLjFornc ))
		If .NOT. U_TFSelecNFT()
			MsgAlert("Acesso não permitido à rotina Recebimento Nfe de Transferencia não selecionada!")
		ElseIf SF1->F1_XRECEBE = "F" .AND. !SF1->(Eof())
			MsgAlert("Processo de recebimento já realizado para está Nfe de Transferencia!")
		Else
			_cNegocio := ""
			cTfClassif	:= ""
			SD1->(DbSetOrder(1))
			If SD1->(DbSeek( xFilial("SD1") + __cNfEntrada + __cSerieEntrada + __cNFTFornece + __cNFTLjFornc ))
				While SD1->(D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA) = ( xFilial("SD1") + __cNfEntrada + __cSerieEntrada + __cNFTFornece + __cNFTLjFornc ) .and. !SD1->(Eof())
					_cNegocio := SD1->D1_ITEMCTA 
					If Empty(SD1->D1_TES)
						cTfClassif	:= "NAO"
					EndIf
					SD1->(DbSkip())
				End 
			EndIf
			If SF2->(Eof())
				MsgAlert("Nfe de Transferencia sem dados de origem (SF2), verifique com a área fiscal o número correto!")
			ElseIf _cNegocio != "TAIFF"
				MsgAlert("Pedidos da nota fiscal no.: "+SF1->F1_DOC+" não correspondem à TAIFF!")
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
				cQuery += "	AND DA_CLIFOR	= '"+SF1->F1_FORNECE+"' " + ENTER
				cQuery += "	AND DA_LOJA	= '"+SF1->F1_LOJA+"' " + ENTER
				cQuery += "	AND D_E_L_E_T_	= '' " + ENTER
				cQuery += "	GROUP BY DA_DOC " + ENTER
				
				MemoWrite("TFRECTAIFF_QrySDAchek.SQL",cQuery)
				
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
					cQuery += "	AND SC5_MG.C5_XITEMC		= 'TAIFF' " + ENTER
					cQuery += "WHERE " + ENTER
					cQuery += "	SD2.D_E_L_E_T_	= '' " + ENTER
					cQuery += "	AND D2_FILIAL		= '" + _cFilMestre + "' " + ENTER
					cQuery += "	AND D2_DOC 		= '" + __cNfEntrada + "' " + ENTER
					cQuery += "	AND D2_SERIE 		= '" + __cSerieEntrada + "' " + ENTER
					cQuery += "	AND D2_CLIENTE 	= '" + __cSF2Fornece + "' " + ENTER
					cQuery += "	AND D2_LOJA 		= '" + __cSF2LjFornc + "' " + ENTER
					cQuery += "	AND D2_XRECEBE	!= 'S' " + ENTER
					
					MemoWrite("TFRECTAIFF_QryPedidosNFT.SQL",cQuery)
	
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


