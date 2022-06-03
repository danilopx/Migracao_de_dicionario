#INCLUDE "Protheus.ch"
#INCLUDE "Topconn.ch"
#IFNDEF CRLF
	#DEFINE CRLF ( chr(13)+chr(10) )
#ENDIF

//+--------------------------------------------------------------------------------------------------------------
//| FUNCAO: TAIFFACD02                                | AUTOR: CARLOS ALDAY TORRES     |     DATA: 13/12/2010   |
//+--------------------------------------------------------------------------------------------------------------
//| DESCRICAO: Permitir ao usuario preparar o estorno da OS
//| SOLICITANTE: Expedicao - Marcelo 
//+--------------------------------------------------------------------------------------------------------------
User Function TAIFACD2
Local xSe1Alias	:= CB7->(GetArea())
Local cAlias  := "CB7"
//Local aCores  := {}
Local cFiltra := "CB7_FILIAL == '"+xFilial('CB7')+"' .And. CB7_STATUS > '0' .and. CB7_STATUS<'5' "

Private cCadastro	:= "Estorno de OS"
Private aRotina  	:= {}                
Private aIndexSA2	:= {}	
Private bFiltraBrw:= { || FilBrowse(cAlias,@aIndexSA2,@cFiltra) }

AADD(aRotina,{"Pesquisar"		,"PesqBrw"			,0,1})
AADD(aRotina,{"Legenda"			,"U_OSLegenda"		,0,3})
AADD(aRotina,{"Prep.Estorno"	,"U_OSprepara"		,0,6})

dbSelectArea(cAlias)                         

dbSetOrder(1)
Eval(bFiltraBrw)

mBrowse(6,1,22,75,cAlias,,,,,,U_OSLejenda(cAlias),,,,,,.F.,,)

EndFilBrw(cAlias,aIndexSA2)
RestArea(xSe1Alias)
Return(.T.)

//+-------------------------------------------
//|Função: BLegenda - Cores da legenda
//+-------------------------------------------
User Function OSLejenda(cAlias)

Local aLegenda := { 	{"BR_AMARELO"	, 	"OS em andamento"	} ,;
							{"BR_CINZA"		, 	"OS pausada" 		}	}

Local uRetorno := .T.

uRetorno := {}

Aadd(uRetorno, { ' At(CB7_STATUS,"1x2x4")!=0 ', aLegenda[2][1] } )
Aadd(uRetorno, { ' At(CB7_STATUS,"3")!=0 ', aLegenda[1][1] } )
Aadd(uRetorno, { '.T.', aLegenda[1][1] } )

Return uRetorno

           
//+-------------------------------------------
//|Função: BLegenda - Cores da legenda
//+-------------------------------------------
User Function OSLegenda()

Local aLegenda := {}

AADD(aLegenda,{"BR_AMARELO"	, 	"OS em andamento" 	})
AADD(aLegenda,{"BR_CINZA"		,	"OS pausada" 		})

BrwLegenda(cCadastro, "Legenda", aLegenda)

Return Nil
           
//+-------------------------------------------
//|Função: Prepara o estorno
//+-------------------------------------------
User Function OSprepara()
If MsgYesNo("Deseja realmente Preparar o ESTORNO da OS?",FunName())
	CB8->(DbSetOrder(1))
	If CB8->(DbSeek( xFilial("CB8") + CB7->CB7_ORDSEP ))
		CB7->(RecLock("CB7",.f.))
		CB7->CB7_STATUS := "0"
		CB7->CB7_STATPA := " "
		CB7->CB7_CODOPE := ""
		CB7->CB7_DTINIS := CTOD("  /  /  ")
		CB7->CB7_HRINIS := ""
		CB7->CB7_DTFIMS := CTOD("  /  /  ")
		CB7->CB7_HRFIMS := ""
		CB7->(MsUnlock())
		
		While CB8->CB8_FILIAL = xFilial("CB8") .and. CB8->CB8_ORDSEP=CB7->CB7_ORDSEP .AND. !CB8->(EOF())

			CB8->(RecLock("CB8",.f.))
			CB8->CB8_SALDOS := CB8->CB8_QTDORI
			CB8->CB8_SALDOE := 0
			CB8->(MsUnlock())

			CB8->(DbSkip())
		End
   EndIf	
EndIf
Return(.T.)
