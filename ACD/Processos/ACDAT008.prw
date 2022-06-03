#Include 'Protheus.ch'
#include "TbiConn.ch"
#include "TbiCode.ch"

#DEFINE ENTER CHR(13) + CHR(10)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ACDAT008  º Autor ³ Carlos Torres      º Data ³  19/09/2017 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ SCHEDULE DE FIM DE APONTAMENTO                             º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function ACDAT008()

If Select("SX6") == 0
	RPCClearEnv()
	RPCSetType(3)  
	PREPARE ENVIRONMENT EMPRESA "04" FILIAL "02" MODULO "EST"

	U_ACDAT08PAUSA()

	RESET ENVIRONMENT
Else
	Aviso("AVISO","Rotina não programada para execução manual!" ,{"OK"},3,"")
EndIf

Return

/* Cria registro na CBH com pausa "Fim do Dia" */
User Function ACDAT08PAUSA()
Local _cCBH		:= ""
Local _cQuery		:= ""
Local cMensPausas	:= ""
Local cEmail		:= ""

	//CONOUT("ACDAT008 - Inicio da rotina")

	//CONOUT("ACDAT008 - Colocando PAUSA (99) nos apontamentos abertos do dia")
	CBI->(DbSeek( xFilial("CBI") + "99" ))
	
	_cQuery := "SELECT * " + ENTER 
	_cQuery += "	FROM "+RetSqlName("CBH")+" CBH WITH(NOLOCK) " + ENTER
	_cQuery += "WHERE D_E_L_E_T_ <> '*'" + ENTER
	_cQuery += "	AND CBH_FILIAL = '02'"  + ENTER
	_cQuery += "	AND CBH_OPERAC = '01' AND CBH_TRANSA = '01'" + ENTER
	_cQuery += "	AND CBH_DTFIM = '' AND CBH_HRFIM = ''" + ENTER
	_cQuery += "	AND CBH_DTINI >= CONVERT(VARCHAR(10),GETDATE(),112) " + ENTER
	_cQuery += "	AND NOT EXISTS " + ENTER
	_cQuery += "	(" + ENTER
	_cQuery += "			SELECT 'OK'" + ENTER
	_cQuery += "			FROM CBH040 AUX WITH(NOLOCK)" + ENTER
	_cQuery += "			WHERE AUX.D_E_L_E_T_ <> '*' " + ENTER
	_cQuery += "			AND CBH.CBH_FILIAL = AUX.CBH_FILIAL " + ENTER
	_cQuery += "			AND CBH.CBH_OP = AUX.CBH_OP" + ENTER
	_cQuery += "			AND CBH.CBH_OPERAD = AUX.CBH_OPERAD" + ENTER
	_cQuery += "			AND AUX.CBH_OPERAC = '01' AND AUX.CBH_TRANSA >= '50'" + ENTER
	_cQuery += "			AND (AUX.CBH_HRFIM = '' OR AUX.CBH_DTFIM = '' )" + ENTER 
	_cQuery += "	)" + ENTER
	
	//MEMOWRITE("ACDAT008_LISTA_CBH_EM_ABERTO.SQL",_cQuery)
	
	dbUseArea(.T.,"TOPCONN", TCGenQry(,,_cQuery),(_cCBH := GetNextAlias()), .F., .T.)
	
	TCSETFIELD((_cCBH),"CBH_DTINI","D")
	TCSETFIELD((_cCBH),"CBH_DTFIM","D")
	TCSETFIELD((_cCBH),"CBH_DVALID","D")
	
	(_cCBH)->(DbGoTop())
	While !(_cCBH)->(EoF())
	
		RecLock("CBH",.T.)
		CBH->CBH_FILIAL := (_cCBH)->CBH_FILIAL
		CBH->CBH_OPERAD := (_cCBH)->CBH_OPERAD
		CBH->CBH_OP     := (_cCBH)->CBH_OP     
		CBH->CBH_TRANSA := CBI->CBI_CODIGO
		CBH->CBH_TIPO   := CBI->CBI_TIPO
		CBH->CBH_QEPREV := 0
		CBH->CBH_QTD    := 0
		CBH->CBH_DTINI  := (_cCBH)->CBH_DTINI
		CBH->CBH_DTINV  := (_cCBH)->CBH_DTINV 
		CBH->CBH_HRINI  := (_cCBH)->CBH_HRINI
		CBH->CBH_HRINV  := (_cCBH)->CBH_HRINV
		//CBH->CBH_DTFIM  := (_cCBH)->CBH_DTINI
		//CBH->CBH_HRFIM  := (_cCBH)->CBH_HRINI
		CBH->CBH_OPERAC := (_cCBH)->CBH_OPERAC
		CBH->CBH_HRIMAP := "1"
		CBH->CBH_LOTCTL := (_cCBH)->CBH_LOTCTL
		CBH->CBH_NUMLOT := (_cCBH)->CBH_NUMLOT
		CBH->CBH_DVALID := (_cCBH)->CBH_DVALID
		CBH->CBH_RECUR  := (_cCBH)->CBH_RECUR
		CBH->CBH_OBS    := "Incluido em " + DTOS(dDataBase) + " SCHEDULE"
		CBH->(MsUnlock())
		cMensPausas += "OP " + (_cCBH)->CBH_OP + " apontada em " + DTOC((_cCBH)->CBH_DTINI) + " as " + (_cCBH)->CBH_HRINI + " do operador " + (_cCBH)->CBH_OPERAD + ENTER 
				
		(_cCBH)->(DbSkip())
	End
	If .NOT. EMPTY(cMensPausas)
		//cEmail	:= "carlos.torres@taiffproart.com.br"
		cEmail	:= "grp_pausas@taiff.com.br;grp_sistemas@taiff.com.br"
//		U_2EnvMail("workflow@taiff.com.br",RTrim(cEmail),"",cMensPausas,"Lista de apontamentos pausados em " + DTOC(DDATABASE)	,"")
	EndIf
		
Return

