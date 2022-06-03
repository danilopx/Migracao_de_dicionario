#include 'protheus.ch'
#include 'parmtype.ch'
#INCLUDE "Acdv025.ch" 
#INCLUDE 'APVT100.CH'
#INCLUDE 'TOPCONN.CH'

#DEFINE ENTER CHR(13) + CHR(10)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ TFFPCPM2    ³ Autor ³ TAIFF             ³ Data ³ 22/10/2018³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Apontamento Producao PCP Modelo 2                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³SIGAACD                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
*/      
user function TFFPCPM2()   
Local bkey05
Local bkey09
Local cOP      := Space(Len(CBH->CBH_OP))
Local cOperacao:= Space(Len(CBH->CBH_OPERAC))
Local cTransac := Space(Len(CBH->CBH_TRANSA))
Local cRetPe   := ""    
Local lContinua:= .T.
Local lVolta   := .f.
Private nTamOper 		:= TAMSX3("G2_OPERAC")[1]
Private nTamOp		:= TAMSX3("CBH_OP")[1] 
Private nTamRec		:= TAMSX3("H1_CODIGO")[1]
Private nTamOped		:= TAMSX3("CB1_CODOPE")[1]
Private nTamTran		:= TAMSX3("CBI_CODIGO")[1]

Private cOperador  := Space(Len(CB1->CB1_CODOPE))
Private cTM        := GetMV("MV_TMPAD")
Private cRoteiro   := Space(Len(SC2->C2_ROTEIRO))
Private cProduto   := Space(Len(SC2->C2_PRODUTO))
Private cLocPad    := Space(Len(SC2->C2_LOCAL))
Private cUltOper   := Space(Len(CBH->CBH_OPERAC))
Private cPriOper   := Space(Len(CBH->CBH_OPERAC))
Private cEtqApto	:= Space(Len(CB1->CB1_CODOPE))+SPACE(6)+SPACE(2)+SPACE(2)
Private cTipIni    := "1"
Private cUltApont  := " "
Private cApontAnt  := " "
Private nSldOPer   := 0
Private nQtdOP     := 0
Private aOperadores:= {}
Private lConjunto  := .f.
Private lFimIni    := .f.
Private lAutAskUlt := .f.
Private lVldOper   := .f.
Private lRastro    := GetMV("MV_RASTRO")  == "S" // Verifica se utiliza controle de Lote
Private lSGQTDOP   := GetMV("MV_SGQTDOP") == "1" // Sugere quantidade no inicio e no apontamento da producao
Private lInfQeIni  := GetMV("MV_INFQEIN") == "1" // Verifica se deve informar a quantidade no inicio da Operacao
Private lCBAtuemp  := GetMV("MV_CBATUD4") == "1" // Verifica se ajusta o empenho no inicio da producao
Private lVldQtdOP  := GetMV("MV_CBVQEOP") == "1" // Valida no inicio da operacao a quantidade informada com o saldo a produzir da mesma
Private lVldQtdIni := GetMV("MV_CBVLAPI") == "1" // Valida a quantidade do apontamento com a quantidade informada no inicio da Producao
Private lCfUltOper := GetMV("MV_VLDOPER") == "S" // Verifica se tem controle de operacoes
Private lOperador  := GetMV("MV_SOLOPEA",,"2") == "1" // Solicita o codigo do operador no apontamento 1-sim 2-nao (default)
Private nParSleep  := SuperGetMV("ACTAPSLEEP",.T., 45000 )
Private lMod1      := .f.
Private lMsHelpAuto:= .f.
Private lMSErroAuto:= .f.
Private lPerdInf   := .F.
Private cTipAtu  := Space(Len(CBH->CBH_TIPO))
Private cOpOperRec 	:= Space(nTamOper+nTamOp+nTamRec)
Private cOpedTran	:= Space(nTamOped+nTamTran)
Private cRecurso := Space(Len(CBH->CBH_RECUR))
Private cOpAtual	:= ""
Private cLastOper	:= ""
IF !Type("lVT100B") == "L"
	Private lVT100B := .F.
EndIf
PRIVATE cSerialNum 	:= SPACE(TAMSX3("ZA4_SERIAL")[1]) //SPACE(20)
PRIVATE cLote    	:= Space(TamSX3("CBH_LOTCTL")[1])
PRIVATE dValid   	:= ctod('')
//PRIVATE lVolta  	:= .f.
PRIVATE lTamSerial	:= GetMV("MV__TAMSER",.F., .F. )
PRIVATE nTamSerial	:= 13
PRIVATE aOPaberta	:= {}
PRIVATE aAbreNovo	:= {}
PRIVATE cOPrecurso	:= SPACE(nTamRec)
PRIVATE lAbreSemaf	:= .F.
PRIVATE nTfQtdOP	:= 0 

If lTamSerial
	nTamSerial 	:= TAMSX3("ZA4_SERIAL")[1]
EndIf
cSerialNum 	:= SPACE(nTamSerial)

// -- Verifica se data do Protheus esta diferente da data do sistema.
DLDataAtu()

If IsTelnet()
	cOperador := CBRETOPE()
	If ExistBlock("CB023IOPE")
		cRetPe := ExecBlock("CB023IOPE",.F.,.F.,{cOperador})
		If ValType(cRetPe)=="C"
			cOperador := cRetPe
			If ! CBVldOpe(cOperador)
				lContinua := .f.
			EndIf
		EndIf
	EndIf
	If lContinua .And. Empty(cOperador)
		CBALERT("Operador nao cadastrado","Aviso",.T.,3000,2)  
		lContinua := .f.
	EndIf
	If lContinua .And. VtModelo() == "RF"
		bkey05   := VTSetKey(05,{|| CB025Encer()},"Encerrar")
		bkey09   := VTSetKey(09,{|| CB023Hist(cOP)},"Informacoes")
	EndIf
EndIf

If lContinua .And. Empty(cTM)
	CBALERT("Informe o tipo de movimentacao padrao - MV_TMPAD","Aviso",.T.,3000,2) 
	lContinua := .f.
EndIf

If lContinua .And. !lRastro .and. lCBAtuemp
	CBALERT("O parametro MV_CBATUD4 so deve ser ativado quando o sistema controlar rastreabilidade","Aviso",.T.,4000,2) 
	lContinua := .f.
EndIf

If lContinua .And. (lVldQtdOP .or. lVldQtdIni .or. lCBAtuemp) .and. !lInfQeIni
	CBALERT("O parametro MV_INFQEIN deve ser ativado","Aviso",.T.,3000,2) 
	lContinua := .f.
EndIf
if IsTelnet() .and. VtModelo() == "RF"
	While lContinua

		While .T.
			cOpOperRec 	:= Space(nTamOper+nTamOp+nTamRec)	
			cLastOper := ""
			VtClear()
			@ 0,00 vtSay "Producao PCP MOD2" //Producao PCP MOD2
			@ 2,00 VTSAY "OP/Operação/Recurso.: " 
			@ 3,00 VTGET cOpOperRec pict '@!'  Valid CB023OP(Substr(cOpOperRec,1, nTamOp)) .and. ;
			 																		CB023OPERAC(Substr(cOpOperRec,1, nTamOp),Substr(cOpOperRec, nTamOp+1,nTamOper)) .and. ; 
			 																		CB023Rec(Substr(cOpOperRec,1, nTamOp), Substr(cOpOperRec, nTamOp+1,nTamOper), Substr(cOpOperRec, nTamOp+nTamOper+1,nTamRec),cTipAtu)
			VtRead																					
			If VtLastKey() == 27
				Exit
			EndIf	
			cLote 	:= U_BuscaLote(Substr(cOpOperRec,1, nTamOp))
			dValid := Ctod("31/12/2049")
			aOPaberta	:= {}
			aAbreNovo	:= {}
			cOPrecurso	:= Substr(cOpOperRec, nTamOp+nTamOper+1,nTamRec)
			nTfQtdOP 	:= 0
			SC2->(DbSetOrder(1))
			If SC2->(DbSeek( xFilial("SC2") + Substr(cOpOperRec,1, nTamOp)))
				nTfQtdOP := SC2->C2_QUANT
				cProduto := SC2->C2_PRODUTO
			EndIf
			
//CONOUT(PROCNAME() + " - " + ALLTRIM(STR(PROCLINE())) + " nSldOPer = " + ALLTRIM(STR(nSldOPer)) )

			cRecurso := Substr(cOpOperRec, nTamOp+nTamOper+1,nTamRec)
			While .T.
				VtClear()
				VtClearBuffer()
				cOpedTran	:= Space(nTamOped+nTamTran)	
				@ 0,00 vtSay "Producao PCP MOD2" //Producao PCP MOD2
				@ 2,00 VTSAY "OP/Operação/Recurso.: " 				
				@ 3,00 VTSAY "["+Substr(cOpOperRec,1, nTamOp)+"/"+Substr(cOpOperRec, nTamOp+1,nTamOper)+"/"+Substr(cOpOperRec, nTamOp+nTamOper+1,nTamRec)+"]"
				@ 5,00 VtSay Rtrim(cOpAtual)
				@ 6,00 VTSAY "Operador/Transação.: "
				@ 4,00 VTSAY "Quantidade faltante: "+If(!Empty(cLastOper),STRZERO( U_CB023Apt(Substr(cOpOperRec,1, nTamOp),Substr(cOpOperRec, nTamOp+1,nTamOper),cLastOper ),3  ),"000")+" / "+STRZERO(CB023Sld(Substr(cOpOperRec,1, nTamOp),cProduto,Substr(cOpOperRec, nTamOp+1,nTamOper)),4) 
				@ 7,00 VTGET cOpedTran pict '@!' Valid If(VldSdTran(Substr(cOpedTran,nTamOped+1, nTamTran),nSldOPer,cOpedTran),.T.,TFFPCPSAY(@cOpedTran,cOpOperRec)) .and. If(CBVldOpe(Substr(cOpedTran,1, nTamOped)),.T.,TFFPCPSAY(@cOpedTran,cOpOperRec)) .and. ;
							If(U_CB023VTr(Substr(cOpOperRec,1, nTamOp),Substr(cOpOperRec, nTamOp+1,nTamOper),Substr(cOpedTran,1, nTamOped),Substr(cOpedTran,nTamOped+1, nTamTran)),.T.,TFFPCPSAY(@cOpedTran,cOpOperRec)) 

				VtRead
				cLastOper := Substr(cOpedTran,1, nTamOped)
				SLEEP(nParSleep)
				If VtLastKey() == 27
					Exit
				EndIf
			Enddo
		Enddo

		if !lVolta
			lContinua := .f.
		endif
		cOP       := Space(Len(CBH->CBH_OP))
		cOperacao := Space(Len(CBH->CBH_OPERAC))
		cTransac  := Space(Len(CBH->CBH_TRANSA))
	EndDo
	If lContinua
		If IsTelnet() .and. VtModelo() == "RF"
			vtsetkey(05,bkey05)		
			vtsetkey(09,bkey09)
		Else
			TerIsQuit()
		EndIf
	EndIf
Endif
Return

Static Function VldSdTran(cTr,nSld)
Local lRet := .T.
If cTr == "01" .and. nSld > 0
	lRet := .T.
Elseif cTr == "01" .and. nSld <= 0
	CBALERT("Não há saldo disponivel para esse Operador com Transação 01.","Aviso",.T.,3000,2)
	lRet := .F.
Endif
Return(lRet)

Static Function TFFPCPSAY(cOpedTran,cOpOperRec)
	VtClear()
	cOpedTran	:= Space(nTamOped+nTamTran)	
	@ 0,00 vtSay "Producao PCP MOD2" //Producao PCP MOD2
	@ 2,00 VTSAY "OP/Operação/Recurso.: "																								
	@ 3,00 VTSAY "["+Substr(cOpOperRec,1, nTamOp)+"/"+Substr(cOpOperRec, nTamOp+1,nTamOper)+"/"+Substr(cOpOperRec, nTamOp+nTamOper+1,nTamRec)+"]"
	@ 5,00 VtSay Rtrim(cOpAtual)
	@ 6,00 VTSAY "Operador/Transação.: "
	@ 4,00 VTSAY "Quantidade faltante: "+If(!Empty(cLastOper),STRZERO( U_CB023Apt(Substr(cOpOperRec,1, nTamOp),Substr(cOpOperRec, nTamOp+1,nTamOper),cLastOper ),3  ),"000")+" / "+STRZERO(CB023Sld(Substr(cOpOperRec,1, nTamOp),cProduto,Substr(cOpOperRec, nTamOp+1,nTamOper)),4) 
	@ 7,00 VTSAY cOpedTran pict '@!' 	
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³ CB023VTr ³ Autor ³ TAIFF               ³ Data ³ 22/10/2018 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Valida o get da Transacao do Apontamento da Prod PCP MOD 2 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SIGAACD                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function CB023VTr(cOP,cOperacao,cOperador,cTransac)
Local cDataHora:= (Dtos(dDataBase)+Left(Time(),5))
Local lAchou   := .f.
Local aTela    := {}
Local lContinua := .F.
Local nTamOper 		:= TAMSX3("G2_OPERAC")[1]
Local nTamOp		:= TAMSX3("CBH_OP")[1] 
Local nTamRec		:= TAMSX3("H1_CODIGO")[1]
//Local nTamOped		:= TAMSX3("CB1_CODOPE")[1]
//Local nTamTran		:= TAMSX3("CBI_CODIGO")[1]
Local cOldMens		:= cOpAtual
Local cOPAberta 	:= SPACE(TAMSX3("CBH_OP")[1])
Local cMensGen		:= SPACE(20)
// -- Verifica se data do Protheus esta diferente da data do sistema.
DLDataAtu()

If TerProtocolo() # "PROTHEUS"
	If IsTelnet() .and. VtModelo() == "RF"
		aTela:= VtSave()
	Else
		aTela:= TerSave()
	EndIf
EndIf

If Empty(cTransac)
	If TerProtocolo() # "PROTHEUS"
		If IsTelnet() .and. VtModelo() == "RF"
			VTKeyBoard(chr(23))
		Else
			//TerConPad("??") // Pendencia
		EndIf
	EndIf
	Return .f.
EndIf

aOperadores:= {}
lConjunto  := .f.
lFimIni    := .f.
lAutAskUlt := .f.

CBI->(DbSetOrder(1))
If ! CBI->(DbSeek(xFilial("CBI")+cTransac))
	CBAlert("Transacao de Monitoramento nao cadastrada","Aviso",.T.,3000,2,.t.) 
	VtClear()
	@ 3,00 VTSAY "["+Substr(cOpOperRec,1, nTamOp)+"/"+Substr(cOpOperRec, nTamOp+1,nTamOper)+"/"+Substr(cOpOperRec, nTamOp+nTamOper+1,nTamRec)+"]"
	@ 5,00 VtSay Rtrim(cOpAtual)
	@ 6,00 VTSAY "Operador/Transação.: "	
	Return .f.
EndIf
cOpAtual := CBI->CBI_DESCRI	
If ExistBlock("ACD023TR")
	lACD023TR := ExecBlock('ACD023TR',.F.,.F.,{cOp,cOperacao,cOperador,cTransac})  
	If ValType(lACD023TR)!= "L"
		lACD023TR := .T.
	EndIf
	If !lACD023TR
		cOpAtual := cOldMens
		Return .f.
	Endif
EndIf

// Os tipos sao: 1- inicio
//               2- pausa c/
//               3- pausa s/
//               4- producao
//               5- perda
cTipAtu := CBI->CBI_TIPO
CBH->(DbSetOrder(3))
If cTipAtu == "1" //Inicio
	If ASCAN(aAbreNovo,cOperador) != 0
		CBAlert("Operador com saldos finalizadas" ,"Aviso",.T.,3000,2,.t.) 
		Return .f.
	EndIf

	// Valida se operador está em outra OP em aberto 
	nPosOPabe	:= ASCAN(aOPaberta,cOperador)
	cOPAberta	:= ""
	If nPosOPabe != 0
		If !EMPTY(aOPaberta[nPosOPabe][2])
			CBAlert("Operador com transacao aberta na OP " + aOPaberta[nPosOPabe][2],"Aviso",.T.,3000,2,.t.) 
			Return .F.
		EndIF
	ElseIf nPosOPabe = 0 
		cOPAberta := U_VldOperOPDif(cOP,cOperador)
		AADD(aOPaberta, {cOperador , cOPAberta})
		If !EMPTY(cOPAberta)
			CBAlert("Operador com transacao aberta na OP " + cOPAberta,"Aviso",.T.,3000,2,.t.) 
			Return .F.
		EndIf
	EndIf

	If CBH->(DbSeek(xFilial("CBH")+cOP+cTipIni+cOperacao+cOperador)) .and. (Empty(CBH->CBH_DTFIM) .OR. Empty(CBH->CBH_HRFIM))
		lContinua := .T.
		CBI->(DbSetOrder(1))
		If ! CBI->(DbSeek(xFilial("CBI")+"02"))
			CBAlert("Transacao de Monitoramento nao cadastrada","Aviso",.T.,3000,2,.t.) 
			cOpAtual := cOldMens
			VtClear()
			@ 3,00 VTSAY "["+Substr(cOpOperRec,1, nTamOp)+"/"+Substr(cOpOperRec, nTamOp+1,nTamOper)+"/"+Substr(cOpOperRec, nTamOp+nTamOper+1,nTamRec)+"]"
			@ 5,00 VtSay Rtrim(cOpAtual)
			@ 6,00 VTSAY "Operador/Transação.: "			
			Return .f.
		Else
			cOpAtual := CBI->CBI_DESCRI	
			@ 5,00 VtSay Rtrim(cOpAtual)
		EndIf
		If ExistBlock("ACD023TR")
			lACD023TR := ExecBlock('ACD023TR',.F.,.F.,{cOp,cOperacao,cOperador,"02"})  
			If ValType(lACD023TR)!= "L"
				lACD023TR := .T.
			EndIf
			If !lACD023TR
				cOpAtual := cOldMens
				Return .f.
			Endif
		EndIf		
		cTipAtu := CBI->CBI_TIPO
		cTransac := "02"
	Endif
Elseif cTipAtu == "3" .and. cTransac $ "50/51/52/53"
	If CBH->(DbSeek(xFilial("CBH")+cOP+cTipAtu+cOperacao+cOperador+cTransac)) .and. !(Empty(CBH->CBH_DTFIM) .OR. Empty(CBH->CBH_HRFIM))
		CBI->(DbSetOrder(1))
		If ! CBI->(DbSeek(xFilial("CBI")+"88"))
			CBAlert("Transacao de Monitoramento nao cadastrada","Aviso",.T.,3000,2,.t.) 
			VtClear()
			cOpAtual := cOldMens
			@ 3,00 VTSAY "["+Substr(cOpOperRec,1, nTamOp)+"/"+Substr(cOpOperRec, nTamOp+1,nTamOper)+"/"+Substr(cOpOperRec, nTamOp+nTamOper+1,nTamRec)+"]"
			@ 5,00 VtSay Rtrim(cOpAtual)
			@ 6,00 VTSAY "Operador/Transação.: "			
			Return .f.
		EndIf
		cOpAtual := CBI->CBI_DESCRI	
		cTransac := "88"		
		cTipAtu := CBI->CBI_TIPO
		CBAlert("Pausa Indevida! Apontamento já realizado anteriormente.","Aviso",.T.,3000,2,.t.)
		cOpAtual := cOldMens
		VtClear()
		@ 3,00 VTSAY "["+Substr(cOpOperRec,1, nTamOp)+"/"+Substr(cOpOperRec, nTamOp+1,nTamOper)+"/"+Substr(cOpOperRec, nTamOp+nTamOper+1,nTamRec)+"]"
		@ 5,00 VtSay Rtrim(cOpAtual)
		@ 6,00 VTSAY "Operador/Transação.: "		
	Endif
Elseif 1=2 //cTipAtu == "3" .and. cTransac == "99" 
	If CBH->(DbSeek(xFilial("CBH")+cOP+cTipAtu+cOperacao+cOperador+cTransac))
		CBAlert("Pausa Indevida! Apontamento já realizado anteriormente.","Aviso",.T.,3000,2,.t.)
		VtClear()
		cOpAtual := cOldMens
		@ 3,00 VTSAY "["+Substr(cOpOperRec,1, nTamOp)+"/"+Substr(cOpOperRec, nTamOp+1,nTamOper)+"/"+Substr(cOpOperRec, nTamOp+nTamOper+1,nTamRec)+"]"
		@ 5,00 VtSay Rtrim(cOpAtual)
		@ 6,00 VTSAY "Operador/Transação.: "		
		Return .f.
	Endif	
Endif
While .T.
	If !lContinua
		aOperadores:= {}
		lConjunto  := .f.
		lFimIni    := .f.
		lAutAskUlt := .f.	
		lAchou   := .f.
		// -- Verifica se data do Protheus esta diferente da data do sistema.
		DLDataAtu()		
		CBI->(DbSetOrder(1))
		If ! CBI->(DbSeek(xFilial("CBI")+cTransac))
			CBAlert("Transacao de Monitoramento nao cadastrada","Aviso",.T.,3000,2,.t.) 
			VtClear()
			cOpAtual := cOldMens
			@ 3,00 VTSAY "["+Substr(cOpOperRec,1, nTamOp)+"/"+Substr(cOpOperRec, nTamOp+1,nTamOper)+"/"+Substr(cOpOperRec, nTamOp+nTamOper+1,nTamRec)+"]"
			@ 5,00 VtSay Rtrim(cOpAtual)
			@ 6,00 VTSAY "Operador/Transação.: "			
			Return .f.
		EndIf
		cOpAtual:=CBI->CBI_DESCRI	
		If ExistBlock("ACD023TR")
			lACD023TR := ExecBlock('ACD023TR',.F.,.F.,{cOp,cOperacao,cOperador,cTransac})  
			If ValType(lACD023TR)!= "L"
				lACD023TR := .T.
			EndIf
			If !lACD023TR
				cOpAtual := cOldMens
				Return .f.
			Endif
		EndIf
		cTipAtu := CBI->CBI_TIPO	
	Endif
	CBH->(DbSetOrder(3))
	If cTipAtu == "1" //Inicio
		cDataHora:= (Dtos(dDataBase)+Left(Time(),5))
		//cOpAtual:=CBI->CBI_DESCRI	
		@ 5,00 VtSay Rtrim(cOpAtual)	
		If CBH->(DbSeek(xFilial("CBH")+cOP+cTipIni+cOperacao+cOperador)) .and. (Empty(CBH->CBH_DTFIM) .OR. Empty(CBH->CBH_HRFIM))
			CBAlert("O.P+Operacao ja iniciada pelo Operador "+cOperador,"Aviso",.T.,3000,2,.t.) 
			VtClear()
			cOpAtual := cOldMens
			@ 3,00 VTSAY "["+Substr(cOpOperRec,1, nTamOp)+"/"+Substr(cOpOperRec, nTamOp+1,nTamOper)+"/"+Substr(cOpOperRec, nTamOp+nTamOper+1,nTamRec)+"]"
			@ 5,00 VtSay Rtrim(cOpAtual)
			@ 6,00 VTSAY "Operador/Transação.: "			
			Return .f.
		EndIf
		CB1->(DbSetOrder(1))
		If CB1->(DbSeek(xFilial("CB1")+cOperador)) .and. CB1->CB1_ACAPSM # "1" .and. ! Empty(CB1->CB1_OP+CB1->CB1_OPERAC)
			CBAlert("Operador sem permissao para executar apontamentos simultaneos","Aviso",.T.,4000,4)  
			VtClear()
			CBAlert("A operacao "+CB1->CB1_OPERAC+" da O.P. "+CB1->CB1_OP+" esta em aberto","Aviso",.T.,4000,4,.t.)  
			VtClear()
			cOpAtual := cOldMens
			@ 3,00 VTSAY "["+Substr(cOpOperRec,1, nTamOp)+"/"+Substr(cOpOperRec, nTamOp+1,nTamOper)+"/"+Substr(cOpOperRec, nTamOp+nTamOper+1,nTamRec)+"]"
			@ 5,00 VtSay Rtrim(cOpAtual)
			@ 6,00 VTSAY "Operador/Transação.: "			
			Return .f.
		EndIf
		If lVldQtdOP .and. ! CB023Seq(cOperacao,.T.) 
			VtClear()
			cOpAtual := cOldMens
			@ 3,00 VTSAY "["+Substr(cOpOperRec,1, nTamOp)+"/"+Substr(cOpOperRec, nTamOp+1,nTamOper)+"/"+Substr(cOpOperRec, nTamOp+nTamOper+1,nTamRec)+"]"
			@ 5,00 VtSay Rtrim(cOpAtual)
			@ 6,00 VTSAY "Operador/Transação.: "	
			Return .f.
		EndIf
		If TerProtocolo() # "PROTHEUS"
			If ! GrvInicio(cOP,cOperacao,cOperador,cTransac,cTipAtu)
				If IsTelnet() .and. VtModelo() == "RF"
					VTKeyBoard(chr(20))
				Else
					TerRestore(,,,,aTela)
				EndIf
				cOpAtual := cOldMens
				VtClear()
				@ 3,00 VTSAY "["+Substr(cOpOperRec,1, nTamOp)+"/"+Substr(cOpOperRec, nTamOp+1,nTamOper)+"/"+Substr(cOpOperRec, nTamOp+nTamOper+1,nTamRec)+"]"
				@ 5,00 VtSay Rtrim(cOpAtual)
				@ 6,00 VTSAY "Operador/Transação.: "					
				Return .f.
			EndIf
			Return .t.
		EndIf
	Else
		//cOpAtual:=CBI->CBI_DESCRI	
		@ 5,00 VtSay Rtrim(cOpAtual)
		If ! CBH->(DbSeek(xFilial("CBH")+cOP+cTipIni+cOperacao+cOperador))
			CBAlert("O.P+Operacao nao iniciada pelo Operador "+cOperador,"Aviso",.T.,3000,2,.t.) 	
			VtClear()
			cOpAtual := cOldMens
			@ 3,00 VTSAY "["+Substr(cOpOperRec,1, nTamOp)+"/"+Substr(cOpOperRec, nTamOp+1,nTamOper)+"/"+Substr(cOpOperRec, nTamOp+nTamOper+1,nTamRec)+"]"
			@ 5,00 VtSay Rtrim(cOpAtual)
			@ 6,00 VTSAY "Operador/Transação.: "				
			Return .f.
		Endif
		While CBH->(!EOF()) .and. CBH->(CBH_FILIAL+CBH_OP+CBH_TIPO+CBH_OPERAC+CBH_OPERAD) == xFilial("CBH")+cOP+cTipIni+cOperacao+cOperador
			If ! Empty(DTOS(CBH->CBH_DTFIM)+CBH->CBH_HRFIM)
				CBH->(DbSkip())
				Loop
			Else
				lAchou:= .t.
				Exit
			EndIf
		Enddo
		If !lAchou
			CBAlert("O.P+Operacao nao possui inicio em aberto para o operador "+cOperador,"Aviso",.T.,3000,2,.t.) 
			VtClear()
			cOpAtual := cOldMens
			@ 3,00 VTSAY "["+Substr(cOpOperRec,1, nTamOp)+"/"+Substr(cOpOperRec, nTamOp+1,nTamOper)+"/"+Substr(cOpOperRec, nTamOp+nTamOper+1,nTamRec)+"]"
			@ 5,00 VtSay Rtrim(cOpAtual)
			@ 6,00 VTSAY "Operador/Transação.: "				
			Return .f.
		EndIf
		cDataHora:= (Dtos(dDataBase)+Left(Time(),5))
		If TerProtocolo() # "PROTHEUS"
			If ! U_CB023DTH(cOP,cOperacao,cOperador,cDataHora) 
				CBAlert("Database + hora atual ("+cDataHora+")invalidas para o operador "+cOperador+ "- "+CBH->CBH_HRINI,"Aviso",.T.,3000,2,.t.) 
				VtClear()
				cOpAtual := cOldMens
				@ 3,00 VTSAY "["+Substr(cOpOperRec,1, nTamOp)+"/"+Substr(cOpOperRec, nTamOp+1,nTamOper)+"/"+Substr(cOpOperRec, nTamOp+nTamOper+1,nTamRec)+"]"
				@ 5,00 VtSay Rtrim(cOpAtual)
				@ 6,00 VTSAY "Operador/Transação.: "					
				Return .f.
			EndIf
		EndIf
		If cTipAtu $ "23" // 2 ou 3 pausa
			cDataHora:= (Dtos(dDataBase)+Left(Time(),5))
			cMensGen := "Realmente deseja gravar a pausa " + chr(13) + cTransac + " - "+Left(CBI->CBI_DESCRI,20)
			If U_TFemPausa(cOP,cOperacao,cOperador,cTransac,cTipAtu)
				cMensGen := "Realmente deseja finalizar a pausa " + chr(13) + cTransac + " - "+Left(CBI->CBI_DESCRI,20)
			EndIf
			If CBYesNo(cMensGen ,"ATENCAO",.T.) //"Confirma o recurso"#"ATENCAO"
				If ! GrvPausa(cOP,cOperacao,cOperador,cTransac,cTipAtu)
					cOpAtual := cOldMens
					If TerProtocolo() # "PROTHEUS"
						If IsTelnet() .and. VtModelo() == "RF"
							VTKeyBoard(chr(20))
						EndIf
					EndIf
					VtClear()
					@ 3,00 VTSAY "["+Substr(cOpOperRec,1, nTamOp)+"/"+Substr(cOpOperRec, nTamOp+1,nTamOper)+"/"+Substr(cOpOperRec, nTamOp+nTamOper+1,nTamRec)+"]"
					@ 5,00 VtSay Rtrim(cOpAtual)
					@ 6,00 VTSAY "Operador/Transação.: "					
					Return .f.
				EndIf
			Else
				VtClear()
				@ 3,00 VTSAY "["+Substr(cOpOperRec,1, nTamOp)+"/"+Substr(cOpOperRec, nTamOp+1,nTamOper)+"/"+Substr(cOpOperRec, nTamOp+nTamOper+1,nTamRec)+"]"
				@ 5,00 VtSay Rtrim(cOpAtual)
				@ 6,00 VTSAY "Operador/Transação.: "					
				Return .f.
			EndIf
		ElseIf cTipAtu $ "45" //--> Producao ou Perda
			cDataHora:= (Dtos(dDataBase)+Left(Time(),5))
			If CBI->CBI_TPAPON == "2" // Operacao em conjunto
				lConjunto:= .t.
			EndIf
			If CBI->CBI_FIMINI == "1" // Indica que finaliza o inicio da operacao no ato do apontamento da mesma independente de ter atingido o saldo ou nao
				lFimIni:= .t.
			EndIf
			If !lMod1 .and. CBI->CBI_CFULOP == "1" // No caso de ser PCP MOD2 e nao validar a sequencia de operacoes a transacao confirma o apontamento como ultima operacao
				lAutAskUlt:= .t.
			EndIf
			ChkOperadores(cOP,cOperacao,cOperador)
			If lConjunto .and. Len(aOperadores) < 2
				CBAlert("Para utilizar o apontamento em conjunto devem ter no minimo dois operadores trabalhando na operacao","Aviso",.T.,5000,2,.t.) 
				aOperadores:= {}
				VtClear()
				cOpAtual := cOldMens
				@ 3,00 VTSAY "["+Substr(cOpOperRec,1, nTamOp)+"/"+Substr(cOpOperRec, nTamOp+1,nTamOper)+"/"+Substr(cOpOperRec, nTamOp+nTamOper+1,nTamRec)+"]"
				@ 5,00 VtSay Rtrim(cOpAtual)
				@ 6,00 VTSAY "Operador/Transação.: "					
				Return .f.
			EndIf
			If cTipAtu == "5"
				If !GrvPrPd(cOP,cOperacao,cOperador,cTransac,cTipAtu)
					If TerProtocolo() # "PROTHEUS"
						If IsTelnet() .and. VtModelo() == "RF"
							VTKeyBoard(chr(20))
						EndIf
					EndIf
					cOpAtual := cOldMens
					VtClear()
					@ 3,00 VTSAY "["+Substr(cOpOperRec,1, nTamOp)+"/"+Substr(cOpOperRec, nTamOp+1,nTamOper)+"/"+Substr(cOpOperRec, nTamOp+nTamOper+1,nTamRec)+"]"
					@ 5,00 VtSay Rtrim(cOpAtual)
					@ 6,00 VTSAY "Operador/Transação.: "						
					Return .f.
				EndIf
			Else
				If ! TFGrvPrPd(cOP,cOperacao,cOperador,cTransac,cTipAtu)
					If TerProtocolo() # "PROTHEUS"
						If IsTelnet() .and. VtModelo() == "RF"
							VTKeyBoard(chr(20))
						EndIf
					EndIf
					cOpAtual := cOldMens
					VtClear()
					@ 3,00 VTSAY "["+Substr(cOpOperRec,1, nTamOp)+"/"+Substr(cOpOperRec, nTamOp+1,nTamOper)+"/"+Substr(cOpOperRec, nTamOp+nTamOper+1,nTamRec)+"]"
					@ 5,00 VtSay Rtrim(cOpAtual)
					@ 6,00 VTSAY "Operador/Transação.: "						
					Return .f.
				EndIf		
			Endif
		EndIf
	EndIf
	If !lContinua
		Exit
	Else
		cTransac := "01"
		lContinua := .F.
	Endif	
Enddo
VtClear()
@ 3,00 VTSAY "["+Substr(cOpOperRec,1, nTamOp)+"/"+Substr(cOpOperRec, nTamOp+1,nTamOper)+"/"+Substr(cOpOperRec, nTamOp+nTamOper+1,nTamRec)+"]"
@ 5,00 VtSay Rtrim(cOpAtual)
@ 6,00 VTSAY "Operador/Transação.: "	
Return .t.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³ CB023DTH  ³ Autor ³ TAIFF              ³ Data ³ 22/10/2018 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Analisa se a DataBase e Hora atual sao validas             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SIGAACD                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
USER Function CB023DTH(cOP,cOperacao,cOperador,cDataHora)
Local lRet:= .t.

CBH->(DbSetOrder(5))
If ! CBH->(DbSeek(xFilial("CBH")+cOP+cOperacao))
	lRet:= .f.
EndIf

While lRet .And. !CBH->(EOF()) .And. CBH->(CBH_FILIAL+CBH_OP+CBH_OPERAC) == xFilial("CBH")+cOP+cOperacao
	If CBH->CBH_OPERAD # cOperador
		CBH->(DbSkip())
		Loop
	EndIf
	If CBH->CBH_TIPO == "1" .and. !Empty(DTOS(CBH->CBH_DTFIM)+CBH->CBH_HRFIM)
		CBH->(DbSkip())
		Loop
	EndIf
	If CBH->CBH_TIPO == "1" .and. Empty(DTOS(CBH->CBH_DTFIM)+CBH->CBH_HRFIM)
		If  cDataHora < (DTOS(CBH->CBH_DTINI)+CBH->CBH_HRINI)
			lRet:= .f.
			Exit
		EndIf
	EndIf
	If CBH->CBH_TIPO $ "23" .and. Empty(DTOS(CBH->CBH_DTFIM)+CBH->CBH_HRFIM)
		If cDataHora < (DTOS(CBH->CBH_DTINI)+CBH->CBH_HRINI)
			lRet:= .f.
			Exit
		EndIf
	EndIf
	If CBH->CBH_TIPO $ "23" .and. !Empty(DTOS(CBH->CBH_DTFIM)+CBH->CBH_HRFIM)
		If cDataHora < (DTOS(CBH->CBH_DTFIM)+CBH->CBH_HRFIM)
			lRet:= .f.
			Exit
		EndIf
	EndIf
	If CBH->CBH_TIPO $ "45" .and. cDataHora < (DTOS(CBH->CBH_DTFIM)+CBH->CBH_HRFIM)
		lRet:= .f.
		Exit
	EndIf
	CBH->(DbSkip())
Enddo
Return(lRet)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³ GrvPausa   ³ Autor ³ TAIFF             ³ Data ³ 22/10/2018 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Gravacao das Paradas                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SIGAACD                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function GrvPausa(cOP,cOperacao,cOperador,cTransac,cTipAtu)
Local cRecurso:= Space(Len(CBH->CBH_RECUR))
Local aTela   := {}
// analisando a pausa em aberto
CBH->(DbSetOrder(3))
CBH->(DbSeek(xFilial("CBH")+cOP+"2",.t.))
While ! CBH->(EOF()) .and. CBH->(CBH_FILIAL+CBH_OP) == xFilial("CBH")+cOP .and. CBH->CBH_TIPO $ "23"
	If ! Empty(CBH->CBH_DTFIM)  //pausa nao esta ativa, nao me enteressa
		CBH->(DbSkip())
		Loop
	EndIf
	If cOperador # CBH->CBH_OPERAD
		CBH->(DbSkip())
		Loop
	EndIf
	If cOperacao # CBH->CBH_OPERAC
		CBH->(DbSkip())
		Loop
	EndIf
	If TerProtocolo() # "PROTHEUS" // Se for RF e Microterminal so reclama se a transacao for diferente
		If CBH->CBH_TRANSA # cTransac
			CBAlert("Operacao ja encontra-se pausada pela transacao "+CBH->CBH_TRANSA,"Aviso",.T.,4000,2) 
			VtClear()
			Return .f.
		EndIf
	Else // se for Protheus nao permite nova pausa se qualquer outra estiver em aberto, pois a mesma deve ser finaliada atraves da opcao de alteracao do Monitoramento
		VtClear()
		CBAlert("Operacao ja encontra-se pausada pela transacao "+CBH->CBH_TRANSA,"Aviso",.T.,4000,2)
		Return .f.
	EndIf
	CBH->(DbSkip())
Enddo

If TerProtocolo() # "PROTHEUS"
	If IsTelnet() .and. VtModelo() == "RF"
		aTela := VtSave()
	Else
		aTela := TerSave()
	EndIf
EndIf

CBH->(DbSetOrder(1))
If ! CBH->(DbSeek(xFilial("CBH")+cOP+cTransac+cTipAtu+cOperacao+cOperador)) .OR. !Empty(DTOS(CBH->CBH_DTFIM)+CBH->CBH_HRFIM)
	If TerProtocolo() # "PROTHEUS"
		If IsTelnet() .and. VtModelo() == "RF"
			VtClear()
			@ 0,00 VtSay "Inicio da Pausa" 
		Else
		TerCls()
			@ 0,00 TerSay "Inicio da Pausa" 
		EndIf
	EndIf
Else
	CB1->(DbSetOrder(1))
	If CB1->(DbSeek(xFilial("CB1")+cOperador)) .and. CB1->CB1_ACAPSM # "1" .and. ! Empty(CB1->CB1_OP+CB1->CB1_OPERAC)
		If (cOP+cOperacao) # (CB1->CB1_OP+CB1->CB1_OPERAC)
			CBAlert("Operador sem permissao para executar apontamentos simultaneos","Aviso",.T.,4000,4)  
			VtClear()
			CBAlert("A operacao "+CB1->CB1_OPERAC+" da O.P. "+CB1->CB1_OP+" esta em aberto","Aviso",.T.,4000,4,.t.)  			
			VtClear()
			Return .f.
		EndIf
	EndIf
	If TerProtocolo() # "PROTHEUS"
		If IsTelnet() .and. VtModelo() == "RF"
			VtClear()
			@ 0,00 VtSay "Termino da Pausa" 
		Else
			TerCls()
			@ 0,00 TerSay "Termino da Pausa" 
		EndIf
		If U_CB023Apt(cOP,cOperacao,cOperador) > 0
			CBI->(DbSetOrder(1))
			If CBI->(DbSeek(xFilial("CBI")+'01'))
				cOpAtual := CBI->CBI_DESCRI		
			EndIf	
		Endif
	EndIf
EndIf

If TerProtocolo() == "PROTHEUS" 
	Return .t. // Se for Protheus nao faz o bloco abaixo
EndIf

SH8->(DbSetOrder(1))
If lMod1 .And. SH8->(DbSeeK(xFilial("SH8")+padr(cOP,TAMSX3("H8_OP")[1])+cOperacao))
	cRecurso := SH8->H8_RECURSO 
EndIf

cRecurso := cOPrecurso 

If EMPTY(cRecurso)
	If IsTelnet() .and. VtModelo() == "RF"
		@ 2,00 VtSay "Recurso: " 
		@ 2,10 VtGet cRecurso  pict '@!' Valid CB023Rec(cOP,cOperacao,cRecurso,cTipAtu) F3 "SH1"
		VtRead
		VtRestore(,,,,aTela)
		If VtLastKey() == 27
			VtClear()
			Return .f.
		EndIf
	Else
		@ 1,00 TerSay "Recurso: " 
		@ 1,10 TerGetRead cRecurso  pict 'XXXXXX' Valid CB023Rec(cOP,cOperacao,cRecurso,cTipAtu)
		TerRestore(,,,,aTela)
		If TerEsc()
			VtClear()
			Return .f.
		Endif   
	EndIf
EndIf

CBH->(DbSetOrder(1))
If ! CBH->(DbSeek(xFilial("CBH")+cOP+cTransac+cTipAtu+cOperacao+cOperador))
	CB023CBH(cOP,cOperacao,cOperador,cTransac,Nil,dDataBase,Left(Time(),5),Nil,Nil,cTipAtu,"ACDV023",Nil,Nil,cRecurso)
ElseIf ! EMPTY(CBH->CBH_DTINI) .and. EMPTY(CBH->CBH_DTFIM) .and. (CBH->CBH_TRANSA == cTransac) .and. (CBH->CBH_OPERAC == cOperacao) .and. (CBH->CBH_OPERAD == cOperador)
	CB023CBH(cOP,cOperacao,cOperador,cTransac,CBH->(Recno()),CBH->CBH_DTINI,CBH->CBH_HRINI,dDataBase,Left(Time(),5),cTipAtu,"ACDV023",Nil,Nil,cRecurso)
	If !EMPTY(CBH->CBH_DTFIM)
		If U_CB023Apt(cOP,cOperacao,cOperador) > 0
			CBI->(DbSetOrder(1))
			If CBI->(DbSeek(xFilial("CBI")+'01'))
				cOpAtual := CBI->CBI_DESCRI		
			EndIf	
		Endif	
	Endif
Else
	CB023CBH(cOP,cOperacao,cOperador,cTransac,Nil,dDataBase,Left(Time(),5),Nil,Nil,cTipAtu,"ACDV023",Nil,Nil,cRecurso)
EndIf

//--- Ponto de entrada: Apos a gravacao do monitoramento da producao (CBH)
If ExistBlock("ACD023GP")
	ExecBlock("ACD023GP",.F.,.F.,{cOP,cOperacao,cOperador,cTransac})
EndIf
VtClear()
Return .t.


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³ ChkOperadores ³ Autor ³ TAIFF  ³            Data ³ 22/10/2018 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Alimenta o Array aOperadores com os operadores ativos         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SIGAACD                                                       ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function ChkOperadores(cOP,cOperacao,cOperador)
Local aTamQtd  := TamSx3("CBH_QTD")
CBH->(DbSetOrder(3))
CBH->(DbSeek(xFilial("CBH")+cOP+cTipIni+cOperacao))
While ! CBH->(EOF()) .and. CBH->(CBH_FILIAL+CBH_OP+CBH_TIPO+CBH_OPERAC) == xFilial("CBH")+cOP+cTipIni+cOperacao
	If !Empty(DTOS(CBH->CBH_DTFIM)+CBH->CBH_HRFIM)
	CBH->(DbSkip())
		Loop
	EndIf
	If Alltrim(CBH->CBH_OPERAD) == Alltrim(cOperador)
		aadd(aOperadores,{"X",CBH->CBH_OPERAD,Str(0,aTamQtd[1],aTamQtd[2]),CBH->CBH_DTINI,CBH->CBH_HRINI})
	Else
		aadd(aOperadores,{" ",CBH->CBH_OPERAD,Str(0,aTamQtd[1],aTamQtd[2]),CBH->CBH_DTINI,CBH->CBH_HRINI})
	EndIf
	CBH->(DbSkip())
EndDo
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³ GrvInicio  ³ Autor ³ TAIFF             ³ Data ³ 22/10/2018 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Gravacao do Inicio                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SIGAACD                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function GrvInicio(cOP,cOperacao,cOperador,cTransac,cTipAtu)
Local nQuant    := 0
//Local nQtdeCBH  := 0
Local nEmAberto := U_CB023Apt(cOP,cOperacao) // Retorna a quantidade total de inicio em aberto para esta operacao
Local cPictQtd  := PesqPict("CBH","CBH_QTD")
Local lRet	    := .t.
Local aTela     := {}
Local nQtdPadrao := SuperGetMV("ACTQTDAPON",.T., 1 )
Local lConfApto  := SuperGetMV("ACTCONFPON",.T., .T. )
Local lContinua := .T.

If IsTelnet() .and. VtModelo() == "RF"
	aTela:= VtSave()
Else
	aTela:= TerSave()
EndIf
nQuant := nQtdPadrao
//CONOUT(PROCNAME() + " - " + ALLTRIM(STR(PROCLINE())) + " nSldOPer = " + ALLTRIM(STR(nSldOPer)) )
//CONOUT(PROCNAME() + " - " + ALLTRIM(STR(PROCLINE())) + " nEmAberto = " + ALLTRIM(STR(nEmAberto)) )
//nSldOPer -= nEmAberto // Atualiza o Saldo da operacao considerando as quantidades de inicio que estao em aberto

If nSldOPer < 0  // --> Se apos a atualizacao o Saldo ficar negativo deixar como zero.
	nSldOPer:= 0
EndIf

If !lInfQeIni
	If lConfApto
		lContinua := CBYesNo("Confirma o Inicio da Producao da OP?","ATENCAO",.T.) 
	Endif
	If lContinua
		CB023CBH(cOP,cOperacao,cOperador,cTransac,Nil,dDataBase,Left(Time(),5),Nil,Nil,cTipAtu,"ACDV023",nQuant)
		Return .t.
	Else
		If Istelnet() .and. VtModelo() == "RF"
			VTKeyBoard(chr(20))
		EndIf
		Return .f.
	EndIf
EndIf

If lSGQTDOP	.and. nQuant == 0
	nQuant:= nSldOPer
EndIf

While .t.
	If nQtdPadrao == 0
		If IsTelnet() .and. VtModelo() == "RF"
			VtClear()
			VtClearBuffer()
			@ 1,00 VtSay "Inicio da Operacao:" 
			@ 3,00 VtSay "Quantidade: "
			@ 4,00 VtGet nQuant Pict cPictQtd Valid U_CB023Qtd(cOP,cOperacao,cOperador,nQuant,.T.)
			VtRead
			If VtLastKey() == 27
				nSldOPer+= nEmAberto
				lRet:= .f.
				Exit
			EndIf
		Else
			TerIsQuit()
			TerCls()
			TerCBuffer()
			@ 0,00 TerSay "Inicio da Operacao:" 
			If VtModelo() == "MT44"
				@ 1,00 TerSay "Quantidade: " 
				@ 1,13 TerGetRead nQuant Pict cPictQtd Valid U_CB023Qtd(cOP,cOperacao,cOperador,nQuant,.T.)
			Else
				@ 1,00 TerSay "Tecle Enter" 
				TerCls()
				@ 0,00 TerSay "Quantidade: " 
				@ 1,00 TerGetRead nQuant Pict cPictQtd Valid U_CB023Qtd(cOP,cOperacao,cOperador,nQuant,.T.)
			EndIf
			If TerEsc()
				nSldOPer+= nEmAberto
				lRet:= .f.
				Exit
			EndIf
		EndIf
		If lConfApto 
			lContinua:=CBYesNo("Confirma o Inicio da Producao da OP?","ATENCAO",.T.) 
		Endif
		If lContinua
			Begin transaction
				If lCBAtuemp .and. (nQuant > 0) .and. cOperacao == "01"
					CB023EMP(cOP,cOperacao,nQuant)
				EndIf
				CB023CBH(cOP,cOperacao,cOperador,cTransac,Nil,dDataBase,Left(Time(),5),Nil,Nil,cTipAtu,"ACDV023",nQuant)
			End Transaction
			If lMSErroAuto
				lRet:= .f.
				If IsTelnet() .and. VtModelo() == "RF"
					VtDispFile(NomeAutoLog(),.t.)
				Else
					TerDispFile(NomeAutoLog(),.t.)
				EndIf
			EndIf
		Else
			Loop
		Endif
	Else
		lAbreSemaf	:= .T.
		lContinua := U_CB023Qtd(cOP,cOperacao,cOperador,nQuant,.T.)
		lContinua := Iif( .NOT. lContinua, lContinua, lAbreSemaf)
//CONOUT(PROCNAME() + " - " + ALLTRIM(STR(PROCLINE())) + " nSldOPer = " + ALLTRIM(STR(nSldOPer)) )
		If lContinua
			If lConfApto 
				lContinua:=CBYesNo("Confirma o Inicio da Producao da OP?","ATENCAO",.T.) 	
			Endif
			If lContinua
				Begin transaction
					If lCBAtuemp .and. (nQuant > 0) .and. cOperacao == "01"
						CB023EMP(cOP,cOperacao,nQuant)
					EndIf
					CB023CBH(cOP,cOperacao,cOperador,cTransac,Nil,dDataBase,Left(Time(),5),Nil,Nil,cTipAtu,"ACDV023",nQuant)
				End Transaction
				If lMSErroAuto
					lRet:= .f.
					If IsTelnet() .and. VtModelo() == "RF"
						VtDispFile(NomeAutoLog(),.t.)
					Else
						TerDispFile(NomeAutoLog(),.t.)
					EndIf
				EndIf				
			Endif
		Endif
//CONOUT(PROCNAME() + " - " + ALLTRIM(STR(PROCLINE())) + " nSldOPer = " + ALLTRIM(STR(nSldOPer)) )
	Endif
	Exit
Enddo
If IsTelnet() .and. VtModelo() == "RF"
	VtRestore(,,,,aTela)
Else
	TerRestore(,,,,aTela)
EndIf
Return(lRet)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³ TFGrvPrPd    ³ Autor ³ TAIFF           ³ Data ³ 22/10/2018 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Analisa se faz apontamento de perda ou de producao         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SIGAACD                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function TFGrvPrPd(cOP,cOperacao,cOperador,cTransac,cTipAtu)

If lVldOper
	If ! CB023Seq(cOperacao)
		Return .f.
	EndIf
EndIf

CBH->(DbSetOrder(3))
CBH->(DbSeek(xFilial("CBH")+cOP+"2"+cOperacao+cOperador,.t.))
While ! CBH->(EOF()) .and. CBH->(CBH_FILIAL+CBH_OP) == xFilial("CBH")+cOP
	If CBH->CBH_OPERAD # cOperador
		CBH->(DbSkip())
		Loop
	EndIf
	If CBH->CBH_OPERAC == cOperacao .and. CBH->CBH_TIPO $ "23" .and. Empty(CBH->CBH_DTFIM)
		CBAlert("Operacao em pausa pelo codigo: " + CBH->CBH_TRANSA,"Aviso",.T.,3000,2) 
		If TerProtocolo() # "PROTHEUS"
			If IsTelnet() .and. VtModelo() == "RF"
				VTKeyBoard(chr(20))
			EndIf
		EndIf
		VtClear()
		Return .f.
	EndIf
	CBH->(DbSkip())
Enddo

If TerProtocolo() == "PROTHEUS"
	Return .t. // Se for Protheus nao executa o bloco abaixo
EndIf

If cTipAtu == "4"
	If ! GrvProd(cOP,cOperacao,cOperador,cTransac,cTipAtu)
		VTKeyBoard(chr(20))
		Return .f.
	EndIf
EndIf
VtClear()
Return .t.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³ GrvProd    ³ Autor ³ TAIFF             ³ Data ³ 22/10/2018 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Gravacao do apontamento da Producao                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SIGAACD                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function GrvProd(cOP,cOperacao,cOperador,cTransac,cTipAtu)

Local aTela   := {}
Local cPictQtd:= PesqPict("CBH","CBH_QTD")
//Local cLote    := Space(TamSX3("CBH_LOTCTL")[1])
//Local dValid   := ctod('')
Local lVolta  := .f.
Local cAquivo  := " " 
Local nQtdPadrao := SuperGetMV("ACTQTDAPON",.T., 1 )
Local lConfApto  := SuperGetMV("ACTCONFPON",.T., .T. )
Local lConfSeri	 := GetMV("MV__CONSER",.F., .T. )
Local cApoHora	 := SPACE(05)

If IsTelnet() .and. VtModelo() == "RF"
	aTela:= VtSave()
Else
	aTela:= TerSave()
EndIf
nQtd:= nQtdPadrao
SH8->(DbSetOrder(1))
While .t.
	If !Empty(cRecurso)
		If IsTelnet() .and. VtModelo() == "RF"
			If nQtdPadrao == 0
				VtClearBuffer()
				@ 5,00 VtSay "Quantidade: " 
				@ 6,00 VtGet nQTD Pict cPictQtd Valid U_CB023Qtd(cOP,cOperacao,cOperador,nQTD)
				VtRead
			Endif
		Else
			TerCls()
			TerCBuffer()
			@ 0,00 TerSay "Quantidade: " 
			@ 1,00 TerGetRead nQTD Pict cPictQtd Valid U_CB023Qtd(cOP,cOperacao,cOperador,nQTD)
		EndIf
	EndIf
	If nQtdPadrao > 0
		If cOperacao == "01" .AND. cTransac="02" .AND. cTipAtu="4" .AND. lConfSeri
			If IsTelnet() .and. VtModelo() == "RF"
				VtClearBuffer()
				@ 5,00 VTSAY "Numero serial: " + SPACE(10)
				@ 6,00 VTSAY SPACE(20) 
				@ 7,00 VTSAY SPACE(10)
				@ 6,00 VTGET cSerialNum Valid VldSerNum(cSerialNum)
				VtRead
			EndIf
		EndIf
//CONOUT(PROCNAME() + " - " + ALLTRIM(STR(PROCLINE())) )
		If !U_CB023Qtd(cOP,cOperacao,cOperador,nQTD)
			VtRestore(,,,,aTela)
			Return .f.		
		Endif
	Endif
	If IsTelnet() .and. VtModelo() == "RF"
		If VtLastKey() == 27
			Exit
		EndIf
	Else
		If TerEsc()
			Exit
		EndIf
	EndIf
	//Geralote(@cLote,@dValid,@lVolta) Desabilitada a função do lote e habilitado como .T. a variavel lVolta
	lVolta := .F.
	If lVolta
		nQTD := 0
		VtClearGet("nQTD")
		lVolta := .f.
		Loop
	EndIf
	If ExistBlock("ACD023PR")        // Validacao antes da confirmacao do apontamento da producao
		If ! ExecBlock("ACD023PR",.F.,.F.,{cOp,cOperacao,cRecurso,cOperador,nQtd,cTransac,cLote})
			Loop
		EndIf
	EndIf
	If lConfApto
		If CBYesNo("Confirma o Apontamento de Producao da OP?","ATENCAO",.T.) 
			Begin transaction
			If lConjunto
				If !GrvConjunto(cOP,cOperacao,cOperador,cTransac,cRecurso,cTipAtu,nQtd,cLote,dValid)
					lVolta := .t.
				EndIf
			Else
				cApoHora := Left(Time(),5)
				If lMod1
					If ! CB023GRV(cOP,cOperacao,cTransac,cProduto,cRecurso,cOperador,cTipAtu,nQtd,cLote,dValid)
						lVolta := .t.
					Endif
				Else
					If ! CB025GRV(cOP,cOperacao,cTransac,cProduto,cRecurso,cOperador,cTipAtu,nQtd,cLote,dValid)
						lVolta := .t.
					EndIf
				EndIf
			EndIf
			End Transaction
			If lVolta
				nQTD := 0
				VtClearGet("nQTD")
				lVolta := .f.
				Loop
			EndIf
			If lMSErroAuto
				cAquivo:= NomeAutoLog()
				VTDispFile(cAquivo,.t.)
			EndIf
			If cOperacao == "01" .AND. cTransac="02" .AND. cTipAtu="4" .AND. lConfSeri
				GrvSerial(cOP,cOperacao,cOperador,cTransac,dDataBase,cSerialNum,cApoHora)
				cSerialNum := SPACE(nTamSerial)
				VtClearGet("cSerialNum")
			EndIf
		Else
			nQTD := 0
			VtClearGet("nQTD")
			Loop
		EndIf
	Else
//CONOUT(PROCNAME() + " - " + ALLTRIM(STR(PROCLINE())) + " nSldOPer = " + ALLTRIM(STR(nSldOPer)) )
		Begin transaction
		If lConjunto
			If !GrvConjunto(cOP,cOperacao,cOperador,cTransac,cRecurso,cTipAtu,nQtd,cLote,dValid)
				lVolta := .t.
			EndIf
		Else
			cApoHora := Left(Time(),5)
			If lMod1
				If ! CB023GRV(cOP,cOperacao,cTransac,cProduto,cRecurso,cOperador,cTipAtu,nQtd,cLote,dValid)
					lVolta := .t.
				Endif
			Else
				If ! CB025GRV(cOP,cOperacao,cTransac,cProduto,cRecurso,cOperador,cTipAtu,nQtd,cLote,dValid)
					lVolta := .t.
				EndIf
			EndIf
		EndIf
		End Transaction
//CONOUT(PROCNAME() + " - " + ALLTRIM(STR(PROCLINE())) + " nSldOPer = " + ALLTRIM(STR(nSldOPer)) )
		If lVolta
			nQTD := 0
			VtClearGet("nQTD")
			lVolta := .f.
			Loop
		EndIf
		If lMSErroAuto
			cAquivo:= NomeAutoLog()
			VTDispFile(cAquivo,.t.)
		EndIf	
		If cOperacao == "01" .AND. cTransac="02" .AND. cTipAtu="4" .AND. lConfSeri
			GrvSerial(cOP,cOperacao,cOperador,cTransac,dDataBase,cSerialNum,cApoHora)
			cSerialNum := SPACE(nTamSerial)
			VtClearGet("cSerialNum")
		EndIf
	Endif
	Exit
Enddo
If IsTelnet() .and. VtModelo() == "RF"
	If VtLastKey() == 27
		VtRestore(,,,,aTela)
		Return .f.
	EndIf
Else
	If TerEsc()
		TerRestore(,,,,aTela)
		Return .f.
	EndIf
EndIf
VtClear()
Return .t.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³GeraLote    ³ Autor ³ TAIFF             ³ Data ³ 22/10/2018 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Responsável pela chamada da função CBRASTRO()que verifica  ³±±
±±³          ³ se o produto controla lote e possibilita a digitação dos   ³±±
±±³          ³ Gets lote e data de valida. 								  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SIGAACD (RF)                                               ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function GeraLote(cLote,dValid,lVolta)

cProduto := SC2->C2_PRODUTO
SB1->(DbSetOrder(1))
SB1->(DbSeek(xFilial("SB1")+cProduto))

// Gera No.Lote ao apontar a ultima operacao na finalizacao da transacao
If (CBI->CBI_TIPO == "4" .And. SG2->G2_OPERAC == cUltOper) .Or. CBI->CBI_CFULOP == "1"
	If Empty(SB1->B1_FORMLOT)
		If !Empty(SuperGetMV("MV_FORMLOT",.F.,""))
			cLote := Formula(SuperGetMV("MV_FORMLOT",.F.,""))
		EndIf
	Else
		cLote := Formula(SB1->B1_FORMLOT)
	EndIf
	dValid   := dDataBase+SB1->B1_PRVALID

	If ! CBRastro(cProduto,@cLote,,@dValid,,.T.,@lVolta)
		If IsTelnet() .and. VtModelo() == "RF"
			VTKeyBoard(chr(20))
		EndIf
		Return .f.
	EndIf                    

EndIf                    
Return                

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³ CB023Qtd   ³ Autor ³ TAIFF             ³ Data ³ 22/10/2018   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Valida as quantidades requisitadas x quantidade a ser apontada³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SIGAACD                                                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function CB023Qtd(cOP,cOperacao,cOperador,nQTD,lInicio)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ MV_GANHOPR - Parametro utilizado para verificar se NAO permite o conceito   ³
//|              de "Ganho de Producao" na inclusao do apontamento de Producao. |
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local lGanhoProd:= SuperGetMV("MV_GANHOPR",.F.,.T.)
Local lACD023VQ := ExistBlock("ACD023VQ")
Local lRetBkp
Local lRet      := .T.
Default lInicio := .F.

If lInicio .and. ! lVldQtdOP // Nao valida a quantidade a ser produzida com a quantidade da OP no inicio da OP+Operacao
	lRet := .T.
Else
	If	lGanhoProd
		lRet := .T.
	ElseIf lInicio // --> Indica que a transacao e do tipo 1 --> Inicio da OP+Operacao
		If ! VldQtdOP(cOP,cOperacao,nQtd) // Valida a quantidade a ser iniciada com a OP e o Saldo da Producao
			lRet := .F.
		EndIf
	ElseIf lVldQtdIni // --> Validacao quando a transacao for do tipo 4 ou 5 --> Apontamento de Producao e/ou Perda
		If ! VldQeComIni(cOP,cOperacao,cOperador,nQtd,lInicio)
			lRet := .F.
		EndIf
	ElseIf lVldOper
		If ! VldQeComOP(cOP,cOperacao,cOperador,nQtd,lInicio)
			lRet := .F.
		EndIf
	EndIf
	If lRet .And. (nQtd >= nSldOPer) .and. (Len(aOperadores) > 1) .and. ! lConjunto
		//CBAlert("Existem outros operadores em andamento nesta operacao, a quantidade informada finaliza o saldo da operacao","Aviso",.T.,Nil,2,Nil) 
		//lRet := .F.
		If ASCAN( aAbreNovo, cOperador ) = 0
			AADD(aAbreNovo,cOperador)
		EndIf 
//CONOUT(PROCNAME() + " - " + ALLTRIM(STR(PROCLINE())) )
	Endif
EndIf

If lRet .And. lACD023VQ
	lRetBkp := lRet
	lRet := ExecBlock('ACD023VQ',.F.,.F.,{cOP,cOperacao,cOperador,nQTD,lInicio})  //Retorno .F. para nao validar a quantidade informada
	If ValType(lRet)!= "L"
		lRet := lRetBkp
	EndIf
Endif
Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³ VldQeComOP ³ Autor ³ TAIFF             ³ Data ³ 22/10/2018 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Valida a quantidade do apontamento com a quantidade da OP  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SIGAACD                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function VldQeComOP(cOP,cOperacao,cOperador,nQtd,lInicio)
Local nX      := 0
Local nPos    := 0
Local nQtdSH6 := 0
Local nTotSH6 := 0
Local nQtdNec := 0
Local nQtdPend:= 0
Local nQtdRe  := 0
Local nTotRe  := 0
//Local nRecSD4 := 0
Local aSave   := {}
Local aProds  := {}
Local aErros  := {}
Local aAreaAnt:= GetArea()
Local cProd   := SB1->B1_COD
If TerProtocolo() # "PROTHEUS"
	If IsTelnet() .and. VtModelo() == "RF"
		aSave:= VtSave()
	Else
		aSave:= TerSave()
	EndIf
EndIf

If !("U_TFFPCPM2" $ FunName())
	If lVldOper .and. nQtd > nSldOPer // Validar somente no apontamento PCP MOD1
		If TerProtocolo() == "PROTHEUS"
			MsgAlert("Quantidade excede o saldo disponivel da OP"+". "+"O saldo disponivel e  ---> "+Str(nSldOPer,16,2))
		Else
			CBAlert("Quantidade excede o saldo disponivel da OP","Aviso",.T.,3000,2,Nil) 
			CBAlert("O saldo disponivel e  ---> "+Str(nSldOPer,16,2),"Aviso",.t.,4000,Nil,Nil) 
		EndIf
		Return .f.
	EndIf
ElseIf cOperacao > "01" 
	If !Empty(cApontAnt)
		If cOperacao == cApontAnt .and. nSldOPer == 0
			If lVldOper
				If TerProtocolo() == "PROTHEUS"
					MsgAlert("Quantidade maior do que o saldo disponivel para o apontamento da operacao"+". "+"O saldo disponivel e  ---> "+Str(nSldOPer,16,2))
				Else
					CBAlert("Quantidade maior do que o saldo disponivel para o apontamento da operacao","Aviso",.T.,2000,2,Nil) 
					CBAlert("O saldo disponivel e  ---> "+Str(nSldOPer,16,2),"Aviso",.t.,2000,Nil,Nil)           
				EndIf
				Return .f.
			EndIf
		ElseIf cOperacao > cApontAnt
			If lVldOper .and. (nQtd > nSldOPer)
				If TerProtocolo() == "PROTHEUS"
					MsgAlert("Quantidade maior do que o saldo disponivel para o apontamento da operacao"+". "+"O saldo disponivel e  ---> "+Str(nSldOPer,11,2))
				Else
					CBAlert("Quantidade maior do que o saldo disponivel para o apontamento da operacao","Aviso",.T.,2000,2,Nil) 
				   	CBAlert("O saldo disponivel e  ---> "+Str(nSldOPer,16,2),"Aviso",.t.,2000,Nil,Nil)
				EndIf
				Return .f.   
			EndIf
		EndIf
	EndIf
EndIf

aAreaAnt   := GetArea()
dbSelectArea("SB5")
SB5->(DbSetOrder(1))  
If SB5->(DbSeek(xFilial("SB5")+cProd))
	If SB5->B5_VLDREQ == "3" // Nao valida em Hipotese alguma
		Return.T.
	EndIf
	
	If Empty(GetMV("MV_VLDREQ")).and. Empty(SB5->B5_VLDREQ)
		Return.T.
	EndIf
	
	If Empty(SB5->B5_VLDREQ)
		If GetMV("MV_VLDREQ") == "1" .and. cOperacao # "01"
			Return.T.
		EndIf
	Else
		If SB5->B5_VLDREQ == "1" .and. cOperacao # "01"
			Return.T.
		EndIf
	EndIf
	
	If Empty(SB5->B5_VLDREQ)
		If GetMV("MV_VLDREQ") == "2" .and. cUltOper # cOperacao
			Return.T.
		Endif
	Else
		If SB5->B5_VLDREQ == "2" .and. cUltOper # cOperacao
			Return.T.
		EndIf
	EndIf
Else
	Return.T.
EndIf	
RestArea(aAreaAnt)

SD4->(DbSetOrder(2))
SB1->(DbSetOrder(1))

If ! SD4->(DbSeek(xFilial("SD4")+cOP))
	Return .t.
EndIf

While ! SD4->(EOF()) .and. SD4->(D4_FILIAL+D4_OP) == xFilial("SD4")+cOP
	If SB1->(DbSeek(xFilial("SB1")+SD4->D4_COD))
		If Alltrim(SB1->B1_TIPO) == "MO"
			SD4->(DbSkip())
			Loop
		EndIf
	EndIf
	nPos:= Ascan(aProds,{|x| x[1] == SD4->D4_COD})
	If nPos > 0
		aProds[nPos,2]+= SD4->D4_QTDEORI
		aProds[nPos,3]+= SD4->D4_EMPROC
	Else
		aadd(aProds,{SD4->D4_COD,SD4->D4_QTDEORI,SD4->D4_EMPROC})
	EndIf
	SD4->(DbSkip())
Enddo

nTotSH6:= 0
SH6->(DbSetOrder(1))
If SH6->(DbSeek(xFilial("SH6")+Padr(cOP,Len(H6_OP))+cProduto+cOperacao))
	While ! SH6->(EOF()) .and. SH6->(H6_FILIAL+H6_OP+H6_PRODUTO+H6_OPERAC) == xFilial("SH6")+cOP+cProduto+cOperacao
		nQtdSH6:= (SH6->H6_QTDPROD+SH6->H6_QTDPERD)
		nTotSH6+= nQtdSH6
		SH6->(DbSkip())
	Enddo
EndIf

For nX:= 1 to Len(aProds)
	nQtdNec:= (aProds[nX,2]/nQtdOP)  // --> Descobre a quantidade necessaria por unidade a ser produzida
	If CBArmProc(aProds[nX,1],cTM)
		nQtdNec:= (nQtd*nQtdNec)      // --> Descobre a quantidade necessaria para o total ser produzido
		If nQtdNec > aProds[nX,3]
			nQtdPend:= (nQtdNec-aProds[nX,3])
			aadd(aErros,{aProds[nX,1],Str(nQtdPend,6,2)})
		EndIf
	Else
		nQtdNec:= ((nQtd+nTotSH6)*nQtdNec) // --> Descobre a quantidade necessaria para o total ser produzido
		nTotRe:= 0
		SD3->(DbSetOrder(1))
		If SD3->(DbSeek(xFilial("SD3")+Padr(cOP,Len(SD3->(D3_OP)))+aProds[nX,1]))
			While ! SD3->(EOF()) .and. SD3->D3_FILIAL+SD3->D3_OP+SD3->D3_COD == xFilial("SD3")+cOP+aProds[nX,1]
				If SD3->D3_CF == "RE0"
					nQtdRe:= SD3->D3_QUANT
					nTotRe+= nQtdRe
				EndIf
				SD3->(DbSkip())
			Enddo
		Else
			nTotRe:= 0
		EndIf
		If nQtdNec > nTotRe
			nQtdPend:= (nQtdNec-nTotRe)
			aadd(aErros,{aProds[nX,1],Str(nQtdPend,6,2)})
		EndIf
	EndIf
Next
If Empty(aErros)
	Return .t.
EndIf
ShowErros(aErros,aSave)
Return .f.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³ShowErros   ³ Autor ³ Anderson Rodrigues  ³ Data ³ 29/04/04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Mostra as inconsistencias encontradas pela funcao VldQeComOP³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SIGAACD                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function ShowErros(aErros,aSave)
Local nX   := 0
Local aCab := {}
Local aSize:= {}

CBAlert("Erro no apontamento da producao","Aviso",.T.,3000,2,Nil) 
CBAlert("Favor requisitar os produtos a seguir","Aviso",.T.,3000,2,Nil) 

//-- Se ja existir o arquivo de log de uma operacao anterior, o mesmo devera ser apagado.
If NomeAutoLog()<> NIL .And. File( NomeAutoLog() )
	FErase( NomeAutoLog() )
EndIf

If TerProtocolo() == "PROTHEUS"
	autogrlog(Padr(OemToAnsi("Produto"),Tamsx3("B1_COD")[1])+" "+PadL(OemToAnsi("Quantidade"),20)) 
	For nX:= 1 to Len(aErros)
		autogrlog(" ")
		autogrlog(PadL(aErros[nX,1],Tamsx3("B1_COD")[1])+" "+PadL(aErros[nX,2],20))
	Next
	MostraErro()
ElseIf TerProtocolo() == "VT100"
	aCab  := {"Produto","Quantidade"} 
	aSize := {15,15}
	VtClear()
	VTaBrowse(0,0,7,19,aCab,aErros,aSize)
	VtRestore(,,,,aSave)
ElseIf TerProtocolo() == "GRADUAL"
	aCab  := {"Produto","Quantidade"} 
	aSize := {15,15}
	TerCls()
	TeraBrowse(0,0,1,19,aCab,aErros,aSize)
	TerRestore(,,,,aSave)
EndIf
Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³ VldQtdOP   ³ Autor ³ TAIFF             ³ Data ³ 22/10/2018 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Valida a quantidade a ser iniciada com o saldo da Operacao ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SIGAACD                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function VldQtdOP(cOP,cOperacao,nQtd)
Local nSldCBH := 0
Local nSaldo  := 0
Local nSldaApontar := 0
//CONOUT(PROCNAME() + " - " + ALLTRIM(STR(PROCLINE())) + " nSldOPer = " + ALLTRIM(STR(nSldOPer)) )
//CONOUT(PROCNAME() + " - " + ALLTRIM(STR(PROCLINE())) + " nQtd = " + ALLTRIM(STR(nQtd)) )

If nQtd > nSldOPer
	If TerProtocolo() == "PROTHEUS"
		MsgAlert("Quantidade maior do que o saldo disponivel para o inicio da operacao"+". "+"O saldo disponivel e  ---> "+Str(nSldOper,16,2))
	Else
		CBAlert("Quantidade maior do que o saldo disponivel para o inicio da operacao","Aviso",.T.,2000,2,Nil) 
		CBAlert("O saldo disponivel e  ---> "+Str(nSldOPer,16,2),"Aviso",.t.,2000,Nil,Nil) 
	EndIf
	//Return .f. <--- Manter comentado
	lAbreSemaf	:= .F.
//CONOUT(PROCNAME() + " - " + ALLTRIM(STR(PROCLINE())) )
EndIf

nSldCBH:= CBSldCBH(cOP,cOperacao) // Retorna a quantidade de producao iniciada para a operacao anterior a atual

If nSldCBH > 0 .and. nQtd > nSldCBH	
	nSaldo:= (nSldCBH	- nQtd)
	If nSaldo < 0
		nSaldo:= 0
	EndIf
	If nSaldo == 0 .and. nQtd == 0
		Return .t.
	EndIf
	If TerProtocolo() == "PROTHEUS"
		MsgAlert("Quantidade a ser iniciada e maior do que a quantidade do inicio da Operacao anterior"+". "+"O saldo disponivel e  ---> "+Str(nSaldo,16,2))
	Else
		CBAlert("Quantidade a ser iniciada e maior do que a quantidade do inicio da Operacao anterior","Aviso",.T.,4000,2,Nil) 
		CBAlert("O saldo disponivel e  ---> "+Str(nSaldo,16,2),"Aviso",.t.,4000,Nil,Nil) 
	EndIf
	//Return .f. <--- Manter comentado
	lAbreSemaf	:= .F.
//CONOUT(PROCNAME() + " - " + ALLTRIM(STR(PROCLINE())) )
EndIf

nSldaApontar := U_TFSldOP(cOP,cOperacao)
//CONOUT(PROCNAME() + " - " + ALLTRIM(STR(PROCLINE())) + " nSldaApontar=" + ALLTRIM(STR(nSldaApontar)) )
//CONOUT(PROCNAME() + " - " + ALLTRIM(STR(PROCLINE())) + " nSldOPer=" + ALLTRIM(STR(nSldOPer)) )

If nSldaApontar >= nTfQtdOP
	CBAlert("Quantidade maior do que o saldo disponivel para o inicio da operacao","Aviso",.T.,2000,2,Nil) 
	CBAlert("O saldo disponivel e  ---> "+Str(nSldOPer,16,2),"Aviso",.t.,2000,Nil,Nil) 
	lAbreSemaf	:= .F.
EndIf

Return .t.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³ VldQeComIni³ Autor ³ TAIFF             ³ Data ³ 22/10/2018 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Valida a quantidade do apontamento com a quantidade 		  ³±±
±±³			 ³ informada no inicio da Producao                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SIGAACD                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function VldQeComIni(cOP,cOperacao,cOperador,nQtd,lInicio)
Local nQtdPrev:= 0

CBH->(DBSetOrder(3))
If CBH->(DbSeek(xFilial("CBH")+cOP+cTipIni+cOperacao+cOperador))
	nQtdPrev:= (CBH->CBH_QEPREV-CBH->CBH_QTD)
	If (Empty(DTOS(CBH->CBH_DTFIM)+(CBH->CBH_HRFIM))) .and. (nQtd > nQtdPrev) // Quantidade Prevista
		If TerProtocolo() == "PROTHEUS"
			MsgAlert("Quantidade maior do que o saldo previsto no inicio da operacao"+". "+"Aviso"+Str(nQtdPrev,16,2))
		Else
			CBAlert("Quantidade maior do que o saldo previsto no inicio da operacao","Aviso",.T.,4000,2,Nil) 
			CBAlert("O saldo disponivel e  ---> "+Str(nQtdPrev,16,2),"Aviso",.t.,4000,Nil,Nil) 
		EndIf
		//Return .f.
	EndIf
EndIf
If lVldOper
	If ! VldQeComOP(cOP,cOperacao,cOperador,nQtd,lInicio)
		Return .f.
	EndIf
EndIf
Return .t.


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³ CBSldCBH   ³ Autor ³ TAIFF             ³ Data ³ 22/10/2018 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Retorna a quantidade de producao iniciada e que esta em    ³±±
±±³          ³ aberto para a operacao atual                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SIGAACD                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function CBSldCBH(cOP,cOperacao)
Local nSldPar:= 0
Local nSldTot:= 0

CBH->(DbSetOrder(3)) // Filial+OP+Tipo+Operacao
If ! CBH->(DbSeek(xFilial("CBH")+cOP+cTipIni+cOperacao))
	Return(nSldTot)
EndIf
While ! CBH->(EOF()) .and. CBH->(CBH_FILIAL+CBH_OP+CBH_TIPO+CBH_OPERAC) == xFilial("CBH")+cOP+cTipIni+cOperacao
	nSldPar:= (CBH->CBH_QEPREV - CBH->CBH_QTD)
	If nSldPar < 0
		nSldPar:= 0
	EndIf
	nSldTot+= nSldPar
	CBH->(DbSkip())
Enddo
Return(nSldTot)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³ CB023Apt ³ Autor ³ TAIFF             ³ Data ³ 22/10/2018 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Retorna as quantidades de apontamentos iniciados que estao ³±±
±±³          ³ em aberto para a Operacao atual                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SIGAACD                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function CB023Apt(cOP,cOperacao,cOpdor)	// --> O parametro lFim determina se ira considerar os inicios ja encerrados e
//Local nQtdIni := 0							//     as quantidades ja apontadas para cada inicio em aberto
Local nTotIni := 0
Local cAliasCBH	:= GetNextAlias()
Default cOpdor := ""

CBH->(DbSetOrder(3))
/*
If ! CBH->(DbSeek(xFilial("CBH")+cOP+cTipIni+cOperacao))
	Return(nTotIni)
EndIf

While ! CBH->(EOF()) .and. CBH->(CBH_FILIAL+CBH_OP+CBH_TIPO+CBH_OPERAC) == xFilial("CBH")+cOP+cTipIni+cOperacao
	If ! Empty(DTOS(CBH->CBH_DTFIM)+CBH->CBH_HRFIM)
		CBH->(DbSkip())
		Loop
	EndIf
	If !Empty(cOpdor) .and. cOpdor <> CBH->CBH_OPERAD
		CBH->(DbSkip())
		Loop	
	Endif
	nQtdIni+= (CBH->CBH_QEPREV - CBH->CBH_QTD)
	If	nQtdIni < 0  // deve ser feita esta verificacao, pois no caso de nao validar a qtd apontada com a iniciada a 
		nQtdIni := 0 // qtd apontada pode ser maior e neste caso o nQtdIni ficara negativo
	EndIf
	nTotIni += nQtdIni
	CBH->(DbSkip())
Enddo
*/
	_cQuery := " SELECT SUM(CBH.CBH_QEPREV - CBH.CBH_QTD) AS TOTABERTO" + ENTER
	_cQuery += " FROM "+RetSqlName("CBH")+" CBH WITH(NOLOCK) " + ENTER
	_cQuery += " WHERE CBH_FILIAL= '" + xFILIAL("CBH") + "'" + ENTER
	_cQuery += " AND CBH.D_E_L_E_T_ <> '*'" + ENTER
	_cQuery += " AND RTRIM(CBH_OP) = '" + ALLTRIM(cOP) + "'" + ENTER
	_cQuery += " AND CBH_TIPO = '" + cTipIni + "'" + ENTER
	_cQuery += " AND CBH_OPERAC = '" + cOperacao + "'" + ENTER
	_cQuery += " AND CBH_DTFIM = ''" + ENTER
	
	MEMOWRITE("TFFPCPM2_select_linha_fonte_" + ALLTRIM(STR(PROCLINE())) + ".SQL",_cQuery)				
	If Select("TRB1") > 0
		TRB1->( dbCloseArea() )
	EndIf
	
	dbUseArea(.T., "TOPCONN", TCGenQry(,,_cQuery), cAliasCBH, .F., .T.)

	(cAliasCBH)->(DbGoTop())
	If !(cAliasCBH)->(Eof())
		nTotIni := (cAliasCBH)->TOTABERTO
	EndIf
	(cAliasCBH)->(dbCloseArea())

Return(nTotIni)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³ VldSerNum ³ Autor ³ TAIFF             ³ Data ³ 01/08/2019 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Retorna a validação necessária do serial number            ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SIGAACD                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function VldSerNum(cSerialNum)
Local lRetorno	:= .T.
Local nRec		:= 0
Local _cQuery	:= ""
Local lValSeri	 := GetMV("MV__VLDSER",.F., .T. )

If lValSeri
	_cQuery := " SELECT CBH.R_E_C_N_O_ AS NPONTEIRO " + ENTER
	_cQuery += " FROM "+RetSqlName("CBH")+" CBH WITH(NOLOCK) " + ENTER
	_cQuery += " WHERE CBH_FILIAL= '" + xFILIAL("CBH") + "'" + ENTER
	_cQuery += " AND CBH.D_E_L_E_T_ <> '*'" + ENTER
	_cQuery += " AND RTRIM(CBH_NUMSER) = '" + ALLTRIM(cSerialNum) + "'" + ENTER
	
	MEMOWRITE("TFFPCPM2_select_linha_fonte_" + ALLTRIM(STR(PROCLINE())) + ".SQL",_cQuery)				
	If Select("TRB1") > 0
		TRB1->( dbCloseArea() )
	EndIf
	
	dbUseArea(.T., "TOPCONN", TCGenQry(,,_cQuery), 'TRB1', .F., .T.)
	
	Count To nRec
	TRB1->(DbCloseArea())
		
	If nRec != 0 
		CBAlert("Serial Number ja cadastrado","Aviso",.T.,4000,2,Nil)
		lRetorno := .F.
	EndIf 
	If lRetorno
		_cQuery := " SELECT ZA4.R_E_C_N_O_ AS NPONTEIRO " + ENTER
		_cQuery += " FROM "+RetSqlName("ZA4")+" ZA4 WITH(NOLOCK) " + ENTER
		_cQuery += " WHERE ZA4_FILIAL= '" + xFILIAL("ZA4") + "'" + ENTER
		_cQuery += " AND ZA4_COD ='" + cProduto + "'" + ENTER
		_cQuery += " AND ZA4.D_E_L_E_T_ <> '*'" + ENTER		
		_cQuery += " AND RTRIM(ZA4_SERIAL) = '" + ALLTRIM(cSerialNum) + "'" + ENTER
		
		MEMOWRITE("TFFPCPM2_select_linha_fonte_" + ALLTRIM(STR(PROCLINE())) + ".SQL",_cQuery)				
		If Select("TRB1") > 0
			TRB1->( dbCloseArea() )
		EndIf
		
		dbUseArea(.T., "TOPCONN", TCGenQry(,,_cQuery), 'TRB1', .F., .T.)
		
		Count To nRec
		TRB1->(DbCloseArea())
			
		If nRec = 0 
			CBAlert("Serial Number nao existe","Aviso",.T.,4000,2,Nil)
			lRetorno := .F.
		EndIf 
	EndIf
EndIf

Return(lRetorno)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³ GrvSerial ³ Autor ³ TAIFF             ³ Data ³ 01/08/2019 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Grava serial number na tabela CBH em campo customizado     ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SIGAACD                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function GrvSerial(cOP,cOperacao,cOperador,cTransac,dDataBase,cSerialNum,cApoHora)
Local lRetorno	:= .T.
Local _cQuery	:= SPACE(100)
Local nStatus	:= 0 

_cQuery   := "UPDATE CBH SET" + ENTER
_cQuery   += "		CBH_NUMSER = '" + cSerialNum + "' " + ENTER
_cQuery   += "FROM " + RETSQLNAME("CBH") + " CBH "  + ENTER
_cQuery   += "WHERE CBH.CBH_OP = '" + ALLTRIM(cOP) + "' " + ENTER
_cQuery   += "		AND CBH.D_E_L_E_T_ = '' " + ENTER
_cQuery   += "		AND CBH_FILIAL = '" + xFilial("CBH") +  "' " + ENTER
_cQuery   += "		AND CBH_OPERAC = '" + cOperacao +  "' " + ENTER
_cQuery   += "		AND CBH_OPERAD = '" + cOperador +  "' " + ENTER
_cQuery   += "		AND CBH_TRANSA = '" + cTransac +  "' " + ENTER
_cQuery   += "		AND CBH_HRFIM >= '" + cApoHora +  "' " + ENTER
_cQuery   += "		AND CBH_DTFIM = '" + DTOS(dDataBase) +  "' " + ENTER
_cQuery   += "		AND CBH_NUMSER = '' " + ENTER

MEMOWRITE("TFFPCPM2_UPDATE_linha_fonte_" + ALLTRIM(STR(PROCLINE())) + ".SQL",_cQuery)				
nStatus := TCSQLExec(_cQuery)
If (nStatus < 0)
    MEMOWRITE("TFFPCPM2_erro_linha_fonte_" + ALLTRIM(STR(PROCLINE())) + ".TXT","TCSQLError() " + TCSQLError())
EndIf

Return(lRetorno)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³ AbreTran01 ³ Autor ³ Carlos Torre      ³ Data ³ 09/08/2019 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Valida abertura de apontamento 01 após transacao 02        ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SIGAACD                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function BuscaLote(cNumOp)
Local cRetorno	:= ""
Local _cQuery	:= ""
Local nRec		:= ""

		_cQuery := " SELECT MAX(ZA4_NLOTE) AS NUM_LOTE " + ENTER
		_cQuery += " FROM "+RetSqlName("ZA4")+" ZA4 WITH(NOLOCK) " + ENTER
		_cQuery += " WHERE ZA4_FILIAL= '" + xFILIAL("ZA4") + "'" + ENTER
		_cQuery += " AND ZA4_NUMOP ='" + SUBSTR(cNumOp,1,6) + "'" + ENTER
		_cQuery += " AND ZA4_OPITEM ='" + SUBSTR(cNumOp,7,2) + "'" + ENTER
		_cQuery += " AND ZA4_OPSEQ ='" + SUBSTR(cNumOp,9,3) + "'" + ENTER
		_cQuery += " AND ZA4.D_E_L_E_T_ <> '*'" + ENTER		
		
		MEMOWRITE("TFFPCPM2_select_linha_fonte_" + ALLTRIM(STR(PROCLINE())) + ".SQL",_cQuery)				
		If Select("TRB1") > 0
			TRB1->( dbCloseArea() )
		EndIf
		
		dbUseArea(.T., "TOPCONN", TCGenQry(,,_cQuery), 'TRB1', .F., .T.)
		
		Count To nRec
			
		TRB1->(DbGoTop())
		If nRec = 0 
			//CBAlert("Numero de Lote nao gerado para esta OP","Aviso",.T.,4000,2,Nil)
			cRetorno := ""
		Else
			cRetorno := TRB1->NUM_LOTE
		EndIf 

		TRB1->(DbCloseArea())
Return(cRetorno)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³ VldOperOPDif ³ Autor ³ Carlos Torres   ³ Data ³ 09/08/2019 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Busca se há outra OP em aberto para o operador 			  ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SIGAACD                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function VldOperOPDif(cNumOP,cOperador)
Local cRetorno	:= ""
Local _cQuery	:= ""
Local nRec		:= ""

_cQuery := " SELECT MAX(CBH_OP) AS OP_EMCURSO " + ENTER
_cQuery += " FROM "+RetSqlName("CBH")+" CBH WITH(NOLOCK) " + ENTER
_cQuery += " WHERE CBH_FILIAL= '" + xFILIAL("CBH") + "'" + ENTER
_cQuery += " AND CBH_OP !='" + cNumOp + "'" + ENTER
_cQuery += " AND CBH.D_E_L_E_T_ <> '*'" + ENTER
_cQuery += " AND CBH_OPERAD = '" + cOperador + "'" + ENTER
_cQuery += " AND (CBH_DTFIM = '' OR CBH_HRFIM ='') " + ENTER

MEMOWRITE("TFFPCPM2_select_linha_fonte_" + ALLTRIM(STR(PROCLINE())) + ".SQL",_cQuery)				
If Select("TRB1") > 0
	TRB1->( dbCloseArea() )
EndIf

dbUseArea(.T., "TOPCONN", TCGenQry(,,_cQuery), 'TRB1', .F., .T.)

Count To nRec
TRB1->(DbGoTop())
If nRec = 0 
	cRetorno := ""
Else
	cRetorno := TRB1->OP_EMCURSO
EndIf 

TRB1->(DbCloseArea())
Return(cRetorno)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³ TFemPausa ³ Autor ³ TAIFF             ³ Data ³ 01/08/2019 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Verifica se a pausa existe     							  ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SIGAACD                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function TFemPausa(cOP,cOperacao,cOperador,cTransac,cTipAtu)
Local lRetorno	:= .T.
Local _cQuery	:= SPACE(100)
//Local nStatus	:= 0 

_cQuery   := " SELECT CBH_TRANSA " + ENTER
_cQuery   += "FROM " + RETSQLNAME("CBH") + " CBH WITH(NOLOCK) "  + ENTER
_cQuery   += "WHERE CBH.CBH_OP = '" + ALLTRIM(cOP) + "' " + ENTER
_cQuery   += "		AND CBH.D_E_L_E_T_ = '' " + ENTER
_cQuery   += "		AND CBH_FILIAL = '" + xFilial("CBH") +  "' " + ENTER
_cQuery   += "		AND CBH_OPERAC = '" + cOperacao +  "' " + ENTER
_cQuery   += "		AND CBH_OPERAD = '" + cOperador +  "' " + ENTER
_cQuery   += "		AND CBH_TRANSA = '" + cTransac +  "' " + ENTER
_cQuery   += "		AND CBH_HRFIM  = '' " + ENTER
_cQuery   += "		AND CBH_DTFIM  = '' " + ENTER
_cQuery   += "		AND CBH_NUMSER = '' " + ENTER

MEMOWRITE("TFFPCPM2_select_linha_fonte_" + ALLTRIM(STR(PROCLINE())) + ".SQL",_cQuery)				
If Select("TRB1") > 0
	TRB1->( dbCloseArea() )
EndIf

dbUseArea(.T., "TOPCONN", TCGenQry(,,_cQuery), 'TRB1', .F., .T.)

Count To nRec
TRB1->(DbGoTop())
lRetorno := Iif(nRec = 0 ,.F.,.T.)

Return(lRetorno)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³ TFSldOP ³ Autor ³ TAIFF    	         ³ Data ³ 01/08/2019 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Levanta o saldo de apontamento da OP						  ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SIGAACD                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function TFSldOP(cOP,cOperacao)
Local nSldOp := 0
Local cAliasSH6	:= GetNextAlias()
Local nEmAberto := U_CB023Apt(cOP,cOperacao) // Retorna a quantidade total de inicio em aberto para esta operacao

	_cQuery := " SELECT ISNULL(SUM(SH6.H6_QTDPROD - SH6.H6_QTDPERD),0) AS TOTPRODZ" + ENTER
	_cQuery += " FROM "+RetSqlName("SH6")+" SH6 WITH(NOLOCK) " + ENTER
	_cQuery += " WHERE H6_FILIAL= '" + xFILIAL("SH6") + "'" + ENTER
	_cQuery += " AND SH6.D_E_L_E_T_ <> '*'" + ENTER
	_cQuery += " AND RTRIM(H6_OP) = '" + ALLTRIM(cOP) + "'" + ENTER
	_cQuery += " AND H6_PRODUTO = '" + cProduto + "'" + ENTER
	_cQuery += " AND H6_OPERAC = '" + cOperacao + "'" + ENTER
		
	MEMOWRITE("TFFPCPM2_select_linha_fonte_" + ALLTRIM(STR(PROCLINE())) + ".SQL",_cQuery)				
	
	dbUseArea(.T., "TOPCONN", TCGenQry(,,_cQuery), cAliasSH6, .F., .T.)

	(cAliasSH6)->(DbGoTop())
	If !(cAliasSH6)->(Eof())
		nSldOp := (cAliasSH6)->TOTPRODZ
	EndIf
	(cAliasSH6)->(dbCloseArea())

	nSldOp := nEmAberto + nSldOp

Return(nSldOp)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
?????????????????????????????????????????????????????????????????????????????
??ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ???
???Fun??o	 ? GrvConjunto? Autor ? Anderson Rodrigues  ? Data ? 04/04/03 ???
???ÄÄÄÄÄÄÄÄÄÄ?ÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´??
???Descri??o ? Analisa os operadores em aberto para fazer o apontamento   ???
???ÄÄÄÄÄÄÄÄÄÄ?ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´??
??? Uso      ? SIGAACD                                                    ???
???ÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ???
?????????????????????????????????????????????????????????????????????????????
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function GrvConjunto(xOP,xOperacao,xOperador,cTransac,cRecurso,cTipAtu,nQtd,cLote,dValid)
	Local aCab     := {"Ok","Operador","Quantidade"} //"Operador"###"Quantidade"
	Local aTamQtd  := TamSx3("CBH_QTD")
	Local aSize    := {2,8,aTamQtd[1]}
	Local nX       := 0
	Local nPos     := 0
	Local nMarcados:= 0
	//Local lErro    := .f.
	Private cOP       := xOP
	Private cOperacao := xOperacao
	Private cOperador := xOperador

	nPos:= Ascan(aOperadores,{|x| x[2] == cOperador})
	If nPos > 0
		aOperadores[nPos,3]:= Str(nQtd,aTamQtd[1],aTamQtd[2])
	Endif

	aOperadores:= aSort(aOperadores,,,{|x,y| x[3] < y[3]})

	While .t.
		nMarcados:= 0
		If IsTelnet() .and. VtModelo() == "RF"
			VtClearBuffer()
			VtClear()
			VtaBrowse(0,0,7,19,aCab,aOperadores,aSize,'U_AT06AUX')
		Else
			TerIsQuit()
			TerCBuffer()
			TerCls()
			TeraBrowse(0,0,1,19,aCab,aOperadores,aSize,'U_AT06AUX')
		EndIf
		For nX:= 1 to Len(aOperadores)
			If Empty(aOperadores[nX,1])
				Loop
			EndIf
			nMarcados++
		Next

		If nMarcados < 2
			CBAlert("Para utilizar o apontamento em conjunto devem ser selecionados no minimo dois operadores","Aviso",.T.,5000,2) //"Para utilizar o apontamento em conjunto devem ser selecionados no minimo dois operadores"###"Aviso"
			If CBYesNo("Continua ?","ATENCAO",.T.) //"Continua ?"###"ATENCAO"
				Loop
			Else
				Return .f.
			EndIf
		EndIf

		If (nQTD >= nSldOPer) .and. nMarcados < Len(aOperadores) // Nao selecionou todos os operadores
			CBAlert("A quantidade informada finaliza o saldo da operacao, neste caso e necessario selecionar todos os operadores","Aviso",.T.,nil,2) //"A quantidade informada finaliza o saldo da operacao, neste caso e necessario selecionar todos os operadores"###"Aviso"
			If CBYesNo("Continua ?","ATENCAO",.T.) //"Continua ?"###"ATENCAO"
				Loop
			Else
				Return .f.
			EndIf
		EndIf

		If CBYesNo("Confirma os itens selecionados","ATENCAO",.T.) //"Confirma os itens selecionados"###"ATENCAO"
			For nX:= 1 to Len(aOperadores)
				If Empty(aOperadores[nX,1])
					Loop
				EndIf
				If lMod1
					If ! U_AT06GRV(cOP,cOperacao,cTransac,cProduto,cRecurso,aOperadores[nX,2],cTipAtu,Val(aOperadores[nX,3]),cLote,dValid)
						Return .f.
					EndIf
				Else
					If ! U_ATCB065GRV(cOP,cOperacao,cTransac,cProduto,cRecurso,aOperadores[nX,2],cTipAtu,Val(aOperadores[nX,3]),cLote,dValid)
						Return .f.
					EndIf
				EndIf
			Next
			Exit
		Else
			Return .f.
		EndIf
	Enddo
Return .t.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
?????????????????????????????????????????????????????????????????????????????
??ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ???
???Fun??o	 ? GrvPRPD    ? Autor ? Anderson Rodrigues  ? Data ? 03/02/04 ???
???ÄÄÄÄÄÄÄÄÄÄ?ÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´??
???Descri??o ? Analisa se faz apontamento de perda ou de producao         ???
???ÄÄÄÄÄÄÄÄÄÄ?ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´??
??? Uso      ? SIGAACD                                                    ???
???ÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ???
?????????????????????????????????????????????????????????????????????????????
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function GrvPrPd(cOP,cOperacao,cOperador,cTransac,cTipAtu)

	If lVldOper
		If ! U_AT06Seq(cOperacao)
			Return .f.
		EndIf
	EndIf

	CBH->(DbSetOrder(3))
	CBH->(DbSeek(xFilial("CBH")+cOP+"2"+cOperacao+cOperador,.t.))
	While ! CBH->(EOF()) .and. CBH->(CBH_FILIAL+CBH_OP) == xFilial("CBH")+cOP
		If CBH->CBH_OPERADOR # cOperador
			CBH->(DbSkip())
			Loop
		EndIf
		If CBH->CBH_OPERAC == cOperacao .and. CBH->CBH_TIPO $ "23" .and. Empty(CBH->CBH_DTFIM)
			CBAlert("Operacao em pausa","Aviso",.T.,3000,2) //"Operacao em pausa"###"Aviso"
			If TerProtocolo() # "PROTHEUS"
				If IsTelnet() .and. VtModelo() == "RF"
					VTKeyBoard(chr(20))
				EndIf
			EndIf
			Return .f.
		EndIf
		CBH->(DbSkip())
	Enddo

	If TerProtocolo() == "PROTHEUS"
		Return .t. // Se for Protheus nao executa o bloco abaixo
	EndIf

	If cTipAtu == "4"
		If ! ATGrvProd(cOP,cOperacao,cOperador,cTransac,cTipAtu)
			VTKeyBoard(chr(20))
			Return .f.
		EndIf
	Else
		If ! GrvPerda(cOP,cOperacao,cOperador,cTransac,cTipAtu)
			VTKeyBoard(chr(20))
			Return .f.
		EndIf
	EndIf
Return .t.
