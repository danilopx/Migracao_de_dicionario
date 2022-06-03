#include "protheus.ch"
#include "topconn.ch"
#include "TBICONN.ch"
#DEFINE ENTER Chr(13)+Chr(10)
/*
+--------------------------------------------------------------------------------------------------------------
|FUNCAO: ACD100BUT                                     AUTOR: CARLOS ALDAY TORRES               DATA: 07/05/2015   
+--------------------------------------------------------------------------------------------------------------
|DESCRICAO: PE da rotina de sepação pelo ACD para imprimr etiquetas de volume quando geradas por pedido
+--------------------------------------------------------------------------------------------------------------
*/
User Function ACD100BUT()
Local cRet := {}

AADD( cRet , {"pmsprint",{|| U_TFIMPVOL()  },"ACD", "Reimprime Volume"} )
AADD( cRet , {"pmsprint",{|| U_TFGERVOL("LPT")  },"ACD", "Gera Volume LPT"} )
AADD( cRet , {"pmsprint",{|| U_TFGERVOL("SRV")  },"ACD", "Gera Volume SRV"} )
AADD( cRet , {"pmsprint",{|| U_TFESTROS()  },"ACD", "Prepara Estorno da OS"} )

Return cRet


User Function TFIMPVOL()
Local cIDVol:=""


CB9->(DbSetOrder(1))
CB9->(DbSeek(xFilial("CB9")+CB7->CB7_ORDSEP))
While CB9->(!Eof() .AND. CB9_FILIAL+CB9_ORDSEP == xFilial("CB9")+CB7->CB7_ORDSEP)
	If !Empty(CB9->CB9_VOLUME)
		cIDVol:=CB9->CB9_VOLUME
		Exit
	Endif
	CB9->(DbSkip())
Enddo
If !Empty(cIDVol)
	CB5->(DbSetOrder(1))
	If CB5->(DbSeek(xFilial("CB5")+ CBRLocImp("MV_IACD01") ))
		If CB5SetImp(CBRLocImp("MV_IACD01"))
			MSCBCHKSTATUS(.F.)
			ExecBlock("IMG05",,,{cIDVol,CB7->CB7_PEDIDO,CB7->CB7_NOTA,CB7->CB7_SERIE})
		Else
			Alert("Impressora não encontrada")
		EndIf
		MSCBCLOSEPRINTER()
	EndIf
Else
	Alert("Volume da OS não encontrado")
EndIf

Return NIL


User Function TFGERVOL( _cVLPorta )
		cCodVol := CB6->(GetSX8Num("CB6","CB6_VOLUME"))
		ConfirmSX8()
		CB6->(RecLock("CB6",.T.))
		CB6->CB6_FILIAL := xFilial("CB6")
		CB6->CB6_VOLUME := cCodVol
		CB6->CB6_PEDIDO := CB7->CB7_PEDIDO
		CB6->CB6_NOTA   := CB7->CB7_NOTA
		CB6->CB6_SERIE  := CB7->CB7_SERIE
		CB6->CB6_TIPVOL := "001"
		CB6->CB6_STATUS := "1"   // ABERTO
		CB6->(MsUnlock())
		Alert("Volume gerado " + cCodVol )
		CB5->(DbSetOrder(1))
		
		If CB5->(DbSeek(xFilial("CB5")+ IIf( _cVLPorta="LPT","LOCAL ",CBRLocImp("MV_IACD01")) ))
			If CB5SetImp(IIf( _cVLPorta="LPT","LOCAL ",CBRLocImp("MV_IACD01")))
				MSCBCHKSTATUS(.F.)
				ExecBlock("IMG05",.F.,.F.,{cCodVol,CB7->CB7_PEDIDO,CB7->CB7_NOTA,CB7->CB7_SERIE})
			Else
				Alert("Impressora não encontrada")
			EndIf
			MSCBCLOSEPRINTER()
		EndIf		
Return NIL
		
User Function TFESTROS()
If MsgYesNo("Deseja realmente preparar o estorno da OS?","ATENÇÃO","YESNO")
	CB7->(RecLock("CB7",.F.))
	CB7->CB7_NOTA := ""
	CB7->(MsUnlock())
	Alert(ENTER + "OS perparada para estorno!!!" + ENTER + "Dê prosseguimento com rotina de estorno da OS pelo coletor!!!" + ENTER + "Rotina: Desfaz Separação" )
EndIf
Return NIL
		