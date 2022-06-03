#Include "Protheus.ch"
#INCLUDE "Topconn.ch"
#INCLUDE "fileio.ch"
#INCLUDE "rwmake.ch"

#DEFINE LINHAS 999
#DEFINE USADO CHR(0)+CHR(0)+CHR(1)

//--------------------------------------------------------------------------------------------------------------
// FUNCAO: TFMAILCO                                    AUTOR: CARLOS ALDAY TORRES           DATA: 01/03/2012   
//--------------------------------------------------------------------------------------------------------------
// DESCRICAO: Fechamento de comissao do representante
// SOLICITANTE: Odair 
//--------------------------------------------------------------------------------------------------------------
User Function TFMAILCO()
Local xZaqAlias	:= ZAQ->(GetArea())
Local cAlias  := "ZAQ"

Private cCadastro	:= "Comissao Fechamento"
Private aRotina  	:= {}                
Private aIndexSA2	:= {}	

AADD(aRotina,{"Pesquisar"		,"PesqBrw"			,0,1})
AADD(aRotina,{"Alterar"			,"AxAltera"			,0,4})
AADD(aRotina,{"Excluir"			,"AxDeleta"			,0,5})
AADD(aRotina,{"Legenda"			,"U_CISLegenda"	,0,6})
AADD(aRotina,{"Comissão"		,"U_TFCargaComs"	,0,7})
AADD(aRotina,{"Fechamento"		,"U_TFFechaComs"	,0,8})
//AADD(aRotina,{"Rel. Recebida"	,"U_TAIFFR4( ZAQ->ZAQ_CODVEN )"		,0,9})
//AADD(aRotina,{"Venc/A Vencer"	,"U_TAIFFR6( ZAQ->ZAQ_CODVEN )"		,0,10})

dbSelectArea(cAlias)                         

dbSetOrder(1)
//Eval(bFiltraBrw)

mBrowse(6,1,22,75,cAlias,,,,,,U_CMSLegenda(cAlias),,,,,,.F.,,)

EndFilBrw(cAlias,aIndexSA2)
RestArea(xZaqAlias)
Return(.T.)

//+-------------------------------------------
//|Função: BLegenda - Cores da legenda
//+-------------------------------------------
User Function CMSLegenda(cAlias)

Local aLegenda := { 	{"BR_VERDE"		, 	"Comissão não fechada" 		},;
							{"BR_VERMELHO"	, 	"Comissão fechada"	 		}		}	
Local uRetorno := .T.

uRetorno := {}

Aadd(uRetorno, { ' ZAQ->ZAQ_STATUS="F" ', aLegenda[2][1] } )
Aadd(uRetorno, { '.T.', aLegenda[1][1] } )

Return uRetorno

//+-------------------------------------------
//|Função: BLegenda - Rotina de Legenda
//+-------------------------------------------
User Function CISLegenda()

Local aLegenda := {}

AADD(aLegenda,{"BR_VERDE"		, 	"Comissão não fechada" 		})
AADD(aLegenda,{"BR_VERMELHO"	,	"Comissão fechada" 			})

BrwLegenda(cCadastro, "Legenda", aLegenda)

Return Nil

//--------------------------------------------------------------------------------------------------------------
// PROGRAMA: TFCargaComs                                   AUTOR: CARLOS TORRES                 DATA: 01/03/2012
// DESCRICAO: Fechamento de comissao do representante
//--------------------------------------------------------------------------------------------------------------
User Function TFCargaComs()
Local cFiltra := "E3_FILIAL == '"+xFilial('SE3')+"' "

Private cAliasTrb	:= GetNextAlias()
Private aIndexSA1	:= {}	
Private bFiltraBrw:= { || FilBrowse(cAliasTrb,@aIndexSA1,@cFiltra) }

Private cCadastro := "Fechamento de comissão"
Private aRotina   := { { "Altera"	,"U_TFedtCom()", 0 , 6 },{ "Transmite"	,"U_TFSendCom()", 0 , 7 }} 

If MSGYESNO("Deseja cargar a comissão calcula no mês corrente?","Questionario")

	cPerg := "TFMAILCO"	
   GeraX1(cPerg)
	
	If Pergunte(cPerg) .And. !Empty(MV_PAR01) .And. !Empty(MV_PAR02)
	
		//
		// Chamada de função para carga de tabela temporaria
		//
		Processa( {|lEnd| U_TFVeComis(@lEnd,MV_PAR01, MV_PAR02)}, "Aguarde...","Executando rotina.", .T. )
		
	EndIf
EndIf
Return(.T.)

//--------------------------------------------------------------------------------------------------------------
// Função: GeraX1
// Descrição: Criar grupo de perguntas com origem de arquivo CSV
//--------------------------------------------------------------------------------------------------------------
Static Function GeraX1(cPerg)
	Local aArea    := GetArea()
	Local aRegs    := {}
	Local aHelpPor := {}
	Local aHelpSpa := {}
	Local aHelpEng := {}
	Local i, j
	
	cPerg := PadR(cPerg, Len(SX1->X1_GRUPO))
	AADD(aRegs, {cPerg, "01","Mes/Ano da comissão?	","","","mv_ch0","C", 07,00,00,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","","","","","@R XX/XXXX",""})
	AADD(aRegs, {cPerg, "02","Data de Pagamento?		","","","mv_ch1","D", 08,00,00,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","","","","","@!",""})

	SX1->(DbSetOrder(1))
	For i := 1 To Len(aRegs)
		If !SX1->(DbSeek(cPerg + aRegs[i,2]))
			RecLock("SX1",.T.)
			For j := 1 to FCount()
				If j <= Len(aRegs[i])
					SX1->(FieldPut(j, aRegs[i,j]))
				Endif
			Next
			SX1->(MsUnlock())
			
			aHelpPor := {}
			aHelpSpa := {}
			aHelpEng := {}	
			If i == 1
				aAdd(aHelpPor, "Digite MES e ANO da comissão")
			EndIf		
			PutSX1Help("P." + cPerg + StrZero(i,2) + ".", aHelpPor, aHelpEng, aHelpSpa, .T.)
		Endif
	Next
	RestArea(aArea)
Return

//--------------------------------------------------------------------------------------------------------------
// Função: TFVeComis
// Descrição: Busca comissao com base na PROCEDURE
//--------------------------------------------------------------------------------------------------------------
User Function TFVeComis( lEnd , _cMVPAR01, _dMVPAR02)
Local lRetorno := .T.
Local __dIni	:= ctod( "01/" + Transform( _cMVPAR01,"@R 99/9999") )
Local __dFim	:= ( ctod( "01/" + Transform( _cMVPAR01,"@R 99/9999") ) + 40 )
Local nCnt		:= 0

__dFim := ctod( "01/" + Strzero(Month(__dFim),2) + "/" +Strzero( Year(__dFim) ,4) ) - 1

aResult := {}
If TCSPExist("SP_REL_COMISSAO_A_PAGAR_FECHAMENTO")
	
	aResult := TCSPEXEC("SP_REL_COMISSAO_A_PAGAR_FECHAMENTO", Dtos( __dIni ), Dtos( __dFim ), DTOS(ddatabase)+SUBSTR(TIME(),1,2)+SUBSTR(TIME(),4,2), '' )
	IF !Empty(aResult)
		If Select("FATSQL") > 0
			dbSelectArea("FATSQL")
			DbCloseArea()
		EndIf
		TCQuery "SELECT * FROM " + aResult[1] NEW ALIAS "FATSQL"
	Else
		Final('Erro na execucao da Stored Procedure SP_REL_COMISSAO_A_PAGAR_FECHAMENTO: '+TcSqlError())
	EndIf

	dbSelectArea("FATSQL")
	FATSQL->(DbGoTop())
	
	dbEval(   {|x| nCnt++ },,{|| !FATSQL->(Eof()) }   )
	
	ProcRegua(nCnt)
	FATSQL->(DbGoTop())

	While !FATSQL->(Eof())

	   IncProc("Processando representante: "+FATSQL->A3_NOME)	 

	   If lEnd
			MsgInfo("Operação cancelada","Fim")
			Exit
	   Endif
	     
		If (SM0->M0_CODIGO='01' .and. FATSQL->VL_EMP101 != 0) .OR. ;
			(SM0->M0_CODIGO='02' .and. cFilAnt='01' .and. FATSQL->VL_EMP201 != 0) .OR. ;
			(SM0->M0_CODIGO='02' .and. cFilAnt='02' .and. FATSQL->VL_EMP202 != 0) .OR. ;
			(SM0->M0_CODIGO='03' .and. cFilAnt='01' .and. FATSQL->VL_EMP301 != 0) .OR. ;
			(SM0->M0_CODIGO='03' .and. cFilAnt='02' .and. FATSQL->VL_EMP302 != 0) .OR. ;
			(SM0->M0_CODIGO='03' .and. cFilAnt='03' .and. FATSQL->VL_EMP303 != 0)

			If SM0->M0_CODIGO='01'
				vVL_Comissao	:= FATSQL->VL_EMP101 
				nVL_IR_DEB		:= ( FATSQL->VL_EMP101 * GetNewPar("MV_ALIQIRF",1.5))/100
				nVL_IR_DEB		:= IIf(GetNewPar("MV_RNDIRF",.F.), Round( nVL_IR_DEB,TamSX3( "D1_VALIRR")[2] ), NoRound( nVL_IR_DEB,TamSX3( "D1_VALIRR")[2]))
				vVL1_Comissao	:= FATSQL->VL_EMP101
				nVL1_IR_DEB	:= ( FATSQL->VL_EMP101 * GetNewPar("MV_ALIQIRF",1.5))/100
				nVL1_IR_DEB	:= IIf(GetNewPar("MV_RNDIRF",.F.), Round( nVL1_IR_DEB,TamSX3( "D1_VALIRR")[2] ), NoRound( nVL1_IR_DEB,TamSX3( "D1_VALIRR")[2]))
				cNM1_unidade	:= FATSQL->NM_UN_101
				vVL2_Comissao	:= 0
				nVL2_IR_DEB	:= 0
				cNM2_unidade	:= ""
			ElseIf SM0->M0_CODIGO='02' .AND. cFilAnt='01'
				vVL_Comissao	:= FATSQL->VL_EMP201 
				nVL_IR_DEB		:= ( FATSQL->VL_EMP201 * GetNewPar("MV_ALIQIRF",1.5))/100
				nVL_IR_DEB		:= IIf(GetNewPar("MV_RNDIRF",.F.), Round( nVL_IR_DEB,TamSX3( "D1_VALIRR")[2] ), NoRound( nVL_IR_DEB,TamSX3( "D1_VALIRR")[2]))
				vVL1_Comissao	:= FATSQL->VL_EMP201
				nVL1_IR_DEB	:= ( FATSQL->VL_EMP201 * GetNewPar("MV_ALIQIRF",1.5))/100
				nVL1_IR_DEB	:= IIf(GetNewPar("MV_RNDIRF",.F.), Round( nVL1_IR_DEB,TamSX3( "D1_VALIRR")[2] ), NoRound( nVL1_IR_DEB,TamSX3( "D1_VALIRR")[2]))
				cNM1_unidade	:= FATSQL->NM_UN_201
				vVL2_Comissao	:= 0
				nVL2_IR_DEB		:= 0
				cNM2_unidade	:= ""
			ElseIf SM0->M0_CODIGO='02' .AND. cFilAnt='02'
				vVL_Comissao	:= FATSQL->VL_EMP202
				nVL_IR_DEB		:= ( FATSQL->VL_EMP202 * GetNewPar("MV_ALIQIRF",1.5))/100
				nVL_IR_DEB		:= IIf(GetNewPar("MV_RNDIRF",.F.), Round( nVL_IR_DEB,TamSX3( "D1_VALIRR")[2] ), NoRound( nVL_IR_DEB,TamSX3( "D1_VALIRR")[2]))
				vVL1_Comissao	:= FATSQL->VL_EMP202
				nVL1_IR_DEB	:= ( FATSQL->VL_EMP202 * GetNewPar("MV_ALIQIRF",1.5))/100
				nVL1_IR_DEB	:= IIf(GetNewPar("MV_RNDIRF",.F.), Round( nVL1_IR_DEB,TamSX3( "D1_VALIRR")[2] ), NoRound( nVL1_IR_DEB,TamSX3( "D1_VALIRR")[2]))
				cNM1_unidade	:= FATSQL->NM_UN_202
				vVL2_Comissao	:= 0
				nVL2_IR_DEB		:= 0
				cNM2_unidade	:= ""
			ElseIf SM0->M0_CODIGO='03' .AND. cFilAnt='01'
				vVL_Comissao	:= FATSQL->VL_EMP301 
				nVL_IR_DEB		:= ( FATSQL->VL_EMP301 * GetNewPar("MV_ALIQIRF",1.5))/100
				nVL_IR_DEB		:= IIf(GetNewPar("MV_RNDIRF",.F.), Round( nVL_IR_DEB,TamSX3( "D1_VALIRR")[2] ), NoRound( nVL_IR_DEB,TamSX3( "D1_VALIRR")[2]))

				vVL1_Comissao	:= FATSQL->VL_UN1301 
				nVL1_IR_DEB	:= ( FATSQL->VL_UN1301 * GetNewPar("MV_ALIQIRF",1.5))/100
				nVL1_IR_DEB	:= IIf(GetNewPar("MV_RNDIRF",.F.), Round( nVL1_IR_DEB,TamSX3( "D1_VALIRR")[2] ), NoRound( nVL1_IR_DEB,TamSX3( "D1_VALIRR")[2]))
				cNM1_unidade	:= FATSQL->NM_UN1301
				
				vVL2_Comissao	:= FATSQL->VL_UN2301 
				nVL2_IR_DEB	:= ( FATSQL->VL_UN2301 * GetNewPar("MV_ALIQIRF",1.5))/100
				nVL2_IR_DEB	:= IIf(GetNewPar("MV_RNDIRF",.F.), Round( nVL2_IR_DEB,TamSX3( "D1_VALIRR")[2] ), NoRound( nVL2_IR_DEB,TamSX3( "D1_VALIRR")[2]))
				cNM2_unidade	:= FATSQL->NM_UN2301
			ElseIf SM0->M0_CODIGO='03' .AND. cFilAnt='02'
				vVL_Comissao	:= FATSQL->VL_EMP302 
				nVL_IR_DEB		:= ( FATSQL->VL_EMP302 * GetNewPar("MV_ALIQIRF",1.5))/100
				nVL_IR_DEB		:= IIf(GetNewPar("MV_RNDIRF",.F.), Round( nVL_IR_DEB,TamSX3( "D1_VALIRR")[2] ), NoRound( nVL_IR_DEB,TamSX3( "D1_VALIRR")[2]))
				
				vVL1_Comissao	:= FATSQL->VL_UN1302 
				nVL1_IR_DEB	:= ( FATSQL->VL_UN1302 * GetNewPar("MV_ALIQIRF",1.5))/100
				nVL1_IR_DEB	:= IIf(GetNewPar("MV_RNDIRF",.F.), Round( nVL1_IR_DEB,TamSX3( "D1_VALIRR")[2] ), NoRound( nVL1_IR_DEB,TamSX3( "D1_VALIRR")[2]))
				cNM1_unidade	:= FATSQL->NM_UN1302
				
				vVL2_Comissao	:= FATSQL->VL_UN2302 
				nVL2_IR_DEB	:= ( FATSQL->VL_UN2302 * GetNewPar("MV_ALIQIRF",1.5))/100
				nVL2_IR_DEB	:= IIf(GetNewPar("MV_RNDIRF",.F.), Round( nVL2_IR_DEB,TamSX3( "D1_VALIRR")[2] ), NoRound( nVL2_IR_DEB,TamSX3( "D1_VALIRR")[2]))
				cNM2_unidade	:= FATSQL->NM_UN2302
			ElseIf SM0->M0_CODIGO='03' .AND. cFilAnt='03'
				vVL_Comissao	:= FATSQL->VL_EMP303 
				nVL_IR_DEB		:= ( FATSQL->VL_EMP303 * GetNewPar("MV_ALIQIRF",1.5))/100
				nVL_IR_DEB		:= IIf(GetNewPar("MV_RNDIRF",.F.), Round( nVL_IR_DEB,TamSX3( "D1_VALIRR")[2] ), NoRound( nVL_IR_DEB,TamSX3( "D1_VALIRR")[2]))
				
				vVL1_Comissao	:= FATSQL->VL_UN1303 
				nVL1_IR_DEB	:= ( FATSQL->VL_UN1303 * GetNewPar("MV_ALIQIRF",1.5))/100
				nVL1_IR_DEB	:= IIf(GetNewPar("MV_RNDIRF",.F.), Round( nVL1_IR_DEB,TamSX3( "D1_VALIRR")[2] ), NoRound( nVL1_IR_DEB,TamSX3( "D1_VALIRR")[2]))
				cNM1_unidade	:= FATSQL->NM_UN1303
				
				vVL2_Comissao	:= FATSQL->VL_UN2303 
				nVL2_IR_DEB	:= ( FATSQL->VL_UN2303 * GetNewPar("MV_ALIQIRF",1.5))/100
				nVL2_IR_DEB	:= IIf(GetNewPar("MV_RNDIRF",.F.), Round( nVL2_IR_DEB,TamSX3( "D1_VALIRR")[2] ), NoRound( nVL2_IR_DEB,TamSX3( "D1_VALIRR")[2]))
				cNM2_unidade	:= FATSQL->NM_UN2303
			EndIf
			If GetNewPar("TF_ALIQIRF"," ") != " "
				nVL_IR_DEB	:= 0
				nVL1_IR_DEB	:= 0
				nVL2_IR_DEB	:= 0
			EndIf
			If nVL_IR_DEB <= GetNewPar("MV_VLRETIR",9.99)
				nVL_IR_DEB := 0
				nVL1_IR_DEB:= 0
				nVL2_IR_DEB:= 0
			Endif
			If FATSQL->A2_SIMPNAC='1'
				nVL_IR_DEB := 0
				nVL1_IR_DEB:= 0
				nVL2_IR_DEB:= 0
			EndIf

			If !ZAQ->(DbSeek(  xFilial("ZAQ") + Dtos(__dIni) + FATSQL->A3_COD ))	
				ZAQ->(RecLock("ZAQ",.T.))
				ZAQ->ZAQ_FILIAL	:= xFilial("ZAQ")
				ZAQ->ZAQ_CODVEN	:= FATSQL->A3_COD
				ZAQ->ZAQ_VL_COM	:= vVL_Comissao
				ZAQ->ZAQ_IR_DEB	:= nVL_IR_DEB
				ZAQ->ZAQ_IR_PER	:= Iif(  GetNewPar("TF_ALIQIRF"," ") != " "  , 0 ,GetNewPar("MV_ALIQIRF",1.5))
				ZAQ->ZAQ_EMISDE	:= __dIni	
				ZAQ->ZAQ_EMISAT	:= __dFim
				ZAQ->ZAQ_STATUS	:= "A"	
				ZAQ->ZAQ_DTPAGT	:= _dMVPAR02
				ZAQ->ZAQ_VLMRC1	:= vVL1_Comissao
				ZAQ->ZAQ_IRMRC1	:= nVL1_IR_DEB
				ZAQ->ZAQ_NMMRC1	:= cNM1_unidade
				ZAQ->ZAQ_VLMRC2	:= vVL2_Comissao
				ZAQ->ZAQ_IRMRC2	:= nVL2_IR_DEB
				ZAQ->ZAQ_NMMRC2	:= cNM2_unidade
				ZAQ->(MsUnlock())
			Else
				If ZAQ->ZAQ_STATUS != "F"
					ZAQ->(RecLock("ZAQ",.F.))
					ZAQ->ZAQ_VL_COM	:= vVL_Comissao
					ZAQ->ZAQ_IR_DEB	:= nVL_IR_DEB
					ZAQ->ZAQ_IR_PER	:= Iif(  GetNewPar("TF_ALIQIRF"," ") != " "  , 0 ,GetNewPar("MV_ALIQIRF",1.5))
					ZAQ->ZAQ_DTPAGT	:= _dMVPAR02
					ZAQ->ZAQ_VLMRC1	:= vVL1_Comissao
					ZAQ->ZAQ_IRMRC1	:= nVL1_IR_DEB
					ZAQ->ZAQ_NMMRC1	:= cNM1_unidade
					ZAQ->ZAQ_VLMRC2	:= vVL2_Comissao
					ZAQ->ZAQ_IRMRC2	:= nVL2_IR_DEB
					ZAQ->ZAQ_NMMRC2	:= cNM2_unidade
					ZAQ->(MsUnlock())
				EndIf
         EndIf
		EndIf

		FATSQL->(DbSkip())
	End

	//Fecha Alias Temporario
	If Select("FATSQL")
		FATSQL->(dbCloseArea())
	EndIf

	//Exclui a tabela temporaria do Banco de Dados
	If TcCanOpen(aResult[1])
		TcSqlExec("DROP TABLE "+aResult[1])
	EndIf

EndIf	

Return (lRetorno)

//--------------------------------------------------------------------------------------------------------------
// Função: FILTRO
// Descrição: FILTRO
//--------------------------------------------------------------------------------------------------------------
User Function TFedtCom()
Local oDlg
Local aObjects		:= {}
Local aPosObj  	:= {}
Local aSize    	:= MsAdvSize()
Local aInfo    	:= {aSize[1],aSize[2],aSize[3],aSize[4],3,3}

Local nVlOutro		:= (cAliasTrb)->VL_DEBITO
Local cNmOutro		:= (cAliasTrb)->NM_DEBITO
Local nVlCredto	:= (cAliasTrb)->VL_CREDITO
Local cNmCredto	:= (cAliasTrb)->NM_CREDITO

Local cNmRepres	:= (cAliasTrb)->E3_NOME
Local nOpct			:= 0

aButtons  := If(Type("aButtons") == "U", {}, aButtons)

AADD(aObjects,{100,020,.T.,.F.,.F.})
AADD(aObjects,{100,100,.T.,.T.,.F.})

aPosObj:=MsObjSize(aInfo,aObjects)

DEFINE MSDIALOG oDlg TITLE "Informação de desconto do representante" OF oMainWnd PIXEL FROM aSize[7],0 TO aSize[6],aSize[5]  

@ 1.6,00.7 SAY "Representante:" OF oDlg 
@ 1.5,08.0 MSGET cNmRepres SIZE 100,08 OF oDlg
@ 2.6,00.7 SAY "Descrição (Debito):" OF oDlg 
@ 2.5,08.0 MSGET cNmOutro Picture "@!" SIZE 200,08 OF oDlg VALID !empty(cNmOutro)
@ 3.6,00.7 SAY "Valor (Debito):" OF oDlg 
@ 3.5,08.0 MSGET nVlOutro Picture "@E 999,999,999.99" OF oDlg VALID nVlOutro > 0
@ 4.6,00.7 SAY "Descrição (Credito):" OF oDlg 
@ 4.5,08.0 MSGET cNmCredto Picture "@!" SIZE 200,08 OF oDlg VALID !empty(cNmCredto)
@ 5.6,00.7 SAY "Valor (Credito):" OF oDlg 
@ 5.5,08.0 MSGET nVlCredto Picture "@E 999,999,999.99" OF oDlg VALID nVlCredto > 0

ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{||nOpct:=1,oDlg:End()},{||nOpct:=2,oDlg:End()},,aButtons)
If nOpct=1
	(cAliasTrb)->VL_DEBITO	:= nVlOutro
	(cAliasTrb)->NM_DEBITO	:= cNmOutro
	(cAliasTrb)->VL_CREDITO	:= nVlCredto
	(cAliasTrb)->NM_CREDITO	:= cNmCredto
	U_TFGrvCom("U")
EndIf
Return NIL

//--------------------------------------------------------------------------------------------------------------
// Função: TFFechaComs
// Descrição: Altera status para transmissao
//--------------------------------------------------------------------------------------------------------------
User Function TFFechaComs
Local __dIni := ZAQ->ZAQ_EMISDE             

If ZAQ->ZAQ_STATUS	= "F"
	MsgAlert("Comissão já fechada anteriormente!.")
Else
	If MSGYESNO("Deseja marcar a comissao como Fechada?")

		ZAQ->(DbSetOrder(1))
		ZAQ->(DbSeek( xFilial("ZAQ") + Dtos(__dIni) ))
	
		While ZAQ->ZAQ_EMISDE = __dIni   .and.   !ZAQ->(Eof())
			If ZAQ->(RecLock("ZAQ",.F.))
				ZAQ->ZAQ_STATUS	:= "F"
				ZAQ->(MsUnlock())

				mv_par01	:= 2						//³ mv_par01            // Gerar pela(Emissao/Baixa/Ambos)   ³
				mv_par02	:= ZAQ->ZAQ_EMISDE	//³ mv_par02            // Considera da data                 ³
				mv_par03	:= ZAQ->ZAQ_EMISAT	//³ mv_par03            // ate a data                        ³
				mv_par04 := ZAQ->ZAQ_CODVEN	//³ mv_par04            // Do Vendedor                       ³
				mv_par05 := ZAQ->ZAQ_CODVEN	//³ mv_par05            // Ate o vendedor                    ³
				mv_par06	:= ZAQ->ZAQ_DTPAGT	//³ mv_par06            // Data de Pagamento                 ³
				mv_par07	:= 2						//³ mv_par07            // Gera ctas a Pagar (Sim/Nao)       ³
				mv_par08	:= 2						//³ mv_par08            // Contabiliza on-line               ³
				mv_par09	:= 2						//³ mv_par09            // Mostra lcto Contabil              ³
				mv_par10	:= ZAQ->ZAQ_EMISDE	//³ mv_par10            // Vencimento de                     ³
				mv_par11	:= ZAQ->ZAQ_EMISAT	//³ mv_par11            // Vencimento Ate                    ³
				mv_par12	:= 2						//³ mv_par12            // Considera data (Vencto/Pagamento) ³
				mv_par13	:= 2						//³ mv_par13            // Seleciona Filial						 ³
				mv_par14	:= 'XX'					//³ mv_par14            // Filial De? 								 ³
				mv_par15	:= 'XX'					//³ mv_par15            // Filial Até?								 ³

				mv_par10 -= 100
				mv_par11 += 100
				
				Processa( { |lEnd| fa530Processa() }) 
            
			EndIf
			ZAQ->(DbSkip())
		End
	
		ZAQ->(DbSeek( xFilial("ZAQ") + Dtos(__dIni) ))
		
	EndIf
EndIf
Return NIL


