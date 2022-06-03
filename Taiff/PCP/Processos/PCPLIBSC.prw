#Include "Protheus.ch"
#INCLUDE "Topconn.ch"

//--------------------------------------------------------------------------------------------------------------
// PROGRAMA: PCPLIBSC                                     AUTOR: CARLOS TORRES                 DATA: 26/01/2011
// DESCRICAO: Liberar as SC's em massa
// SOLICITANTE: Alan Veronez
//--------------------------------------------------------------------------------------------------------------
User Function PCPLIBSC()
Local aParamBox	:= {}
Local aRet			:= {}
Private cCadastro := "Liberação de SC em massa"
Private cString := ""

Aadd(aParamBox,{1,"Numero Seq. MRP"	,Space(06),"","","","",50,.T.})

IF !ParamBox(aParamBox,"Informe os Parametros",@aRet)
	Return(.F.)
Endif

Processa({|| U_SCaLIB( aRet[1] ) },"Processando...")

Return Nil         


//--------------------------------------------------------------------------------------------------------------
// DESCRICAO: Rotina para executar a liberação a parti do numero do MRP
//--------------------------------------------------------------------------------------------------------------
User Function SCaLIB( __cNumSeqMRP )
Local lAProvSI 	:= GetNewPar("MV_APROVSI",.F.)
Local _nElementos := 0
Local cQuery		:= ""

//
// O script a seguir tem a finalidade de verificar qual é o primeiro e ultimo item gerado pelo MRP e 
// quantificar o numero de elementos participantes.
//
cQuery := "SELECT COUNT(*) AS NELEMENTOS"
cQuery += " FROM " + RetSqlName("SC1")
cQuery += " WHERE C1_FILIAL='"+xFilial("SC1")+"' AND D_E_L_E_T_ !='*' AND C1_SEQMRP='"+__cNumSeqMRP+"' "

If Select("TMPMRP") > 0
	TMPMRP->(DbCloseArea())
Endif

TcQuery cQuery NEW ALIAS ("TMPMRP")

DbSelectArea("TMPMRP")
_nElementos := TMPMRP->(NELEMENTOS)

If _nElementos > 0 
	cQuery := "SELECT MIN(C1_NUM) AS C1_NUM"
	cQuery += " FROM " + RetSqlName("SC1")
	cQuery += " WHERE C1_FILIAL='"+xFilial("SC1")+"' AND D_E_L_E_T_ !='*' AND C1_SEQMRP='"+__cNumSeqMRP+"' "
	
	If Select("TMPMRP") > 0
		TMPMRP->(DbCloseArea())
	Endif
	
	TcQuery cQuery NEW ALIAS ("TMPMRP")
	
	DbSelectArea("TMPMRP")
	cIniNumMRP := TMPMRP->(C1_NUM)
	
	cQuery := "SELECT MAX(C1_NUM) AS C1_NUM"
	cQuery += " FROM " + RetSqlName("SC1")
	cQuery += " WHERE C1_FILIAL='"+xFilial("SC1")+"' AND D_E_L_E_T_ !='*' AND C1_SEQMRP='"+__cNumSeqMRP+"' "
	
	If Select("TMPMRP") > 0
		TMPMRP->(DbCloseArea())
	Endif
	
	TcQuery cQuery NEW ALIAS ("TMPMRP")
	
	DbSelectArea("TMPMRP")
	cFinNumMrp := TMPMRP->(C1_NUM)
	//
	// Fim
	//

	ProcRegua( _nElementos )  

	cNmAprv := UsrRetName(RetCodUsr())

	DbSelectArea("SC1")
	SC1->(DbSetOrder(1))
	SC1->(DbSeek( xFilial("SC1") + cIniNumMRP ))
	While  SC1->C1_NUM <= cFinNumMrp  .and.  SC1->(!Eof())
		IncProc()
	
		If SC1->C1_SEQMRP = __cNumSeqMRP
			If SC1->C1_APROV $ " ,B,R" .and. SC1->C1_QUJE == 0 .and. Iif(lAProvSI, (Empty(SC1->C1_COTACAO).or.C1_COTACAO=="IMPORT"), Empty(SC1->C1_COTACAO)) .and. Empty(SC1->C1_RESIDUO)
				SC1->(RecLock("SC1",.f.))
				SC1->C1_APROV := "L"
				If SC1->(FieldPos("C1_NOMAPRO")) > 0
					SC1->C1_NOMAPRO := cNmAprv
				EndIf
				SC1->(MsUnlock())
			EndIf
			MaAvalSC("SC1",8)  
		EndIf	
	
		SC1->(DbSkip())
	EndDo
EndIf	
TMPMRP->(DbCloseArea())
Return NIL
