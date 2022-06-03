#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "FILEIO.CH"
#include "TbiConn.ch"
#include "TbiCode.ch"

#DEFINE ENTER Chr(13)+Chr(10)

//+--------------------------------------------------------------------------------------------------------------
//| ROTINA: SF1100I   		                             AUTOR: CARLOS ALDAY TORRES           DATA: 13/04/2011   |
//+--------------------------------------------------------------------------------------------------------------
//| DESCRICAO: Atualiza os campos do BI na tabela SD1
//| SOLICITANTE: Brito
//| OBSERVACAO: Rotina disparada no PE SF1100I
//+--------------------------------------------------------------------------------------------------------------
User Function SF1100I

Local aArea  := GetArea()
LOCAL lPROART:= .F.
Local aCabec := {}
Local aItem  := {}
Local aOPERINCL	:= {}
Local cNUMERO		:= "" 
Local aLOTE		:= {"","","",""}                                           
LOCAL lRsrvArt	:= .F.
LOCAL cMensImp	:= ""
Local cRsrvEmail:= GetNewPar("TF_EMAISF1","marcio.araujo@taiff.com.br;silvana.cardoso@taiff.com.br" ) 
LOCAL CNOMELOG	:= ""
LOCAL nNumIte	:= 0
LOCAL nEndCompra:= 0 
LOCAL aSD1PONTEIRO := {}
Local nLoop		:= 0
LOCAL cEndAutom := GetNewPar("TF_ENDSF1","E") // Parametro que recebe o tipo de endere?amento se pelo endere?o do cadastro de produto ou se no EXP quando compra PROART

//----------------------------------------------------------------------------------------------------------------------------
// Variaveis: TOTVS
//----------------------------------------------------------------------------------------------------------------------------
Local cPref 	:= GetMv("MV_2DUPREF")
//Local aTamPre 	:= TamSX3('F1_SERIE')
Local aSaveSE1 	:= SE1->(GetArea())
Local cDoc		:= ''
//------------------------------[ Fim Variaveis: TOTVS ]-------------------------------------------------------------
lMsErroAuto := .F.

/*
|=================================================================================
|   COMENTARIO
|---------------------------------------------------------------------------------
|	Verificacao para que os CTEs estejam com a Chave Eletronica informada.
|
|=================================================================================
*/

IF ALLTRIM(SF1->F1_ESPECIE) = 'CTE' .AND. EMPTY(ALLTRIM(SF1->F1_CHVNFE)) .AND. ( 1 = 2 )  

	ENVWFERR(SF1->F1_DOC + "/" + ALLTRIM(SF1->F1_SERIE) + " Fornec.: " + SF1->F1_FORNECE + "/" + SF1->F1_LOJA + "Empresa: " + CEMPANT + "/" + CFILANT + " Usu�rio: " + SUBSTR(CUSUARIO,7,15))

ENDIF

/*
	|---------------------------------------------------------------------------------
	|	Parametro para habilitar a gravacao de LOG dos Processos do CrossDocking
	|	Edson Hornberger - 21/05/2015
	|---------------------------------------------------------------------------------
	*/
	PRIVATE LLOGPROC		:= SUPERGETMV("TF_LOGPROC",.F.,.T.)
	PRIVATE CLOGPROC		:= "\LOGPROCCROSS.TXT"
	PRIVATE NHANDLE
	PRIVATE CTEXTOARQ		:= ""
	PRIVATE CDATAPROC		:= ""
	PRIVATE CHRINI			:= ""
	PRIVATE CUSERLOG		:= SUBSTR(CUSERNAME,1,15)  
		
	IF !FILE(CLOGPROC)
		
		NHANDLE := FCREATE(CLOGPROC)
		IF NHANDLE = -1 
			MSGALERT("Erro ao tentar criar arquivo de LOGProc","Documento de Entrada")
		ELSE
			/*
			|---------------------------------------------------------------------------------
			|	GRAVA O CABECALHO DO ARQUVO DE LOG DE PROCESSOS
			|---------------------------------------------------------------------------------
			*/
			CTEXTOARQ := 	PADR("OPERACAO"	,10) + "|" + PADR("DOCUMENTO"	,10) + "|" + PADR("DATA"	,10) + "|" + PADR("HR.INI"	,06) + "|" + ;
							PADR("HR.FIM"	,06) + "|" + PADR("QTD.REG."	,08) + "|" + PADR("TEMPO"	,08) + "|" + PADR("USUARIO"	,15) + CRLF
			FWRITE(NHANDLE,CTEXTOARQ,90)
			FCLOSE(NHANDLE)
		ENDIF 
		
	ENDIF 
	
	CDATAPROC 	:= DTOC(DDATABASE)
	CHRINI		:= SUBSTR(TIME(),1,5)

//----------------------------------------------------------------------------------------------------------------------------
// Ponto de Valida��o: TOTVS
// Descri��o: Validar unidade de negocio no produto
// Merge.......: TAIFF - C. Torres                                           Data: 22/08/2013
//----------------------------------------------------------------------------------------------------------------------------
//1 - E1_FILIAL+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO
//2 - E1_FILIAL+E1_CLIENTE+E1_LOJA+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO

If SF1->F1_TIPO == 'D'
	// NCC
	SE1->(DbSetOrder(2))
	cDoc := SF1->(xFilial('SF1')+F1_FORNECE+F1_LOJA+&cPref+F1_DOC)
	
	If SE1->(DbSeek(cDoc))
		
		Do While cDoc == SE1->(E1_FILIAL+E1_CLIENTE+E1_LOJA+E1_PREFIXO+E1_NUM)
			RecLock("SE1",.F.)
			SE1->E1_ITEMC := SD1->D1_ITEMCTA  	//-- Gravacao unidade de negocios para todas a parcelas geradas no
			MsUnlock("SE1")						//-- financeiro
			
			SE1->(DbSkip())
		EndDo		
	EndIf
	
ElseIf SF1->F1_TIPO == 'N'
	// NCC 
	//6 - E2_FILIAL+E2_FORNECE+E2_LOJA+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO
	SE2->(DbSetOrder(6))
	cDoc := SF1->(xFilial('SF1')+F1_FORNECE+F1_LOJA+&cPref+F1_DOC)
	
	If SE2->(DbSeek(cDoc))
		Do While cDoc == SE2->(E2_FILIAL+E2_FORNECE+E2_LOJA+E2_PREFIXO+E2_NUM)
			RecLock("SE2",.F.)
			SE2->E2_ITEMC := SD1->D1_ITEMCTA  	//-- Gravacao unidade de negocios para todas a parcelas geradas no
			MsUnlock("SE2")						//-- financeiro
			
			SE2->(DbSkip())
		EndDo		
	EndIf	
EndIf

//## GRAVA LOG DE PROCESSOS
IF CEMPANT = '03' .AND. CFILANT = '02' .AND. SF1->F1_FORNECE+SF1->F1_LOJA = '01029701' .AND. SF1->F1_TIPO = 'N' .AND. !EMPTY(SD1->D1_TES) .AND. Alltrim(SD1->D1_ITEMCTA)='TAIFF' 
	NHANDLE := FOPEN(CLOGPROC, FO_READWRITE + FO_SHARED)
	IF NHANDLE = -1
		MSGALERT("Erro ao tentar abrir arquivo de LOG de Processos","Documento de Entrada")
	ELSE
		
		FSEEK(NHANDLE,0,FS_END)
		CTEXTOARQ := 	PADR("D. Entrada"		,10) + "|" + PADR(SF1->F1_DOC						,10) + "|" + PADR(CDATAPROC		,10) + "|" + PADR(CHRINI	,06) + "|" + ;
						PADR("##:##"			,06) + "|" + PADR(TRANSFORM(1,"@E 9999,999")		,08) + "|" + PADR("00:00:00"	,08) + "|" + PADR(CUSERLOG	,15) + CRLF
		FWRITE(NHANDLE,CTEXTOARQ,90)
		FCLOSE(NHANDLE) 
	ENDIF
ENDIF

//----------------------------------------------------------------------------------------------------------------------------------------
// Descri��o: Endere�amento automatico de produtos PROART no CD de Extrema atendendo a especifica��o do projeto da remo��o do flow rack
// Data.....: 07/02/2020 
// Autor....: Carlos Torres 
// Observa..: Em 05/03/2020 Marcio solicitou que o endere?amento autom?tico seja ao inv?s do endere?o padr?o B1_YENDEST seja no "EXP"
//----------------------------------------------------------------------------------------------------------------------------------------
If cempant = "03" .and. cfilant = "02" .AND. SF1->F1_TIPO = "N" .AND. CB7->(FIELDPOS("CB7_X_QTVO")) > 0
	aSD1PONTEIRO := {}
	SD1->(DbSetOrder(1)) // D1_FILIAL, D1_DOC, D1_SERIE, D1_FORNECE, D1_LOJA, D1_COD, D1_ITEM, R_E_C_N_O_, D_E_L_E_T_
	SD1->(DbSeek( xFilial("SD1") + SF1->F1_DOC + SF1->F1_SERIE + SF1->F1_FORNECE + SF1->F1_LOJA))
	While xFilial("SD1") = SD1->D1_FILIAL .AND. SD1->D1_DOC=SF1->F1_DOC .AND. SD1->D1_SERIE=SF1->F1_SERIE .AND. SD1->D1_FORNECE=SF1->F1_FORNECE .AND. SD1->D1_LOJA=SF1->F1_LOJA .AND. .NOT. SD1->(Eof())
		aadd(aSD1PONTEIRO,{ SD1->(RECNO()) }) //Cabecalho
		SD1->(DbSkip())
	End

	nEndCompra	:= 0 
	nNumIte	:= 0

	FOR nLoop := 1 TO LEN(aSD1PONTEIRO)
		SD1->(DbGoTo( aSD1PONTEIRO[nLoop,1]))
		
		SF4->(DbSetOrder(1))
		SF4->(DbSeek( xFilial("SF4") + SD1->D1_TES ))
		
		SB1->(DbSetOrder(1))
		If SB1->(DbSeek( xFilial("SB1") + SD1->D1_COD ))
			lPROART := (ALLTRIM(SB1->B1_ITEMCC) = "PROART")
		EndIf
		
		IF lPROART .AND. SD1->D1_LOCAL = "21" .AND. SF4->F4_ESTOQUE = "S"
			SBE->(DbsetOrder(1))  
			If .NOT. SBE->(DbSeek( xFilial("SBE") + SD1->D1_LOCAL + IIF(cEndAutom="P", SB1->B1_YENDEST,"EXP"), .F.))
				SBE->(RecLock("SBE", .T.))
				SBE->BE_FILIAL := xFilial("SBE")
				SBE->BE_LOCAL  := SD1->D1_LOCAL
				SBE->BE_LOCALIZ:= IIF(cEndAutom="P", SB1->B1_YENDEST,"EXP")
				SBE->BE_DESCRIC:= "EXPEDICAO PROART"
				SBE->BE_PRIOR  := IIF(cEndAutom="P",SUBSTR(ALLTRIM(SB1->B1_YENDEST),1,3),"ZZZ")
				SBE->BE_STATUS := "1"
				SBE->(MsUnLock())
			EndIf

			aCabec := {}
			aItem  := {}

			aCabec:={{"DA_PRODUTO" ,SD1->D1_COD		,Nil},;
				{"DA_DATA"    ,dDataBase		,Nil},;
				{"DA_LOCAL"   ,SD1->D1_LOCAL	,Nil},;
				{"DA_DOC"     ,SD1->D1_DOC		,Nil},;
				{"DA_SERIE"   ,SD1->D1_SERIE	,Nil},;
				{"DA_CLIFOR"  ,SD1->D1_FORNECE	,Nil},;
				{"DA_LOJA"    ,SD1->D1_LOJA		,Nil},;
				{"DA_NUMSEQ"  ,SD1->D1_NUMSEQ	,Nil}}

			nNumIte ++
			aAdd(aItem,{{"DB_ITEM"		,STRZERO(nNumIte,4)				,Nil},;
				{"DB_PRODUTO"	,SD1->D1_COD		,Nil},;
				{"DB_LOCAL"		,SD1->D1_LOCAL		,Nil},;
				{"DB_LOCALIZ"	,IIF(cEndAutom="P", SB1->B1_YENDEST,"EXP")	,Nil},;
				{"DB_DATA"		,dDataBase			,Nil},;
				{"DB_QUANT"		,SD1->D1_QUANT		,Nil},;
				{"DB_DOC"		,SD1->D1_DOC		,Nil},;
				{"DB_SERIE"		,SD1->D1_SERIE		,Nil},;
				{"DB_CLIFOR"	,SD1->D1_FORNECE	,Nil},;
				{"DB_LOJA"		,SD1->D1_LOJA		,Nil},;
				{"DB_NUMSEQ"	,SD1->D1_NUMSEQ	,Nil}})
			nEndCompra	:= Iif( nEndCompra=0 , 1 , nEndCompra )  
			lMsErroAuto := .F.
			
			MsExecAuto({|x,y,z|MATA265(x,y,z)},aCabec, aItem, 3)

			If lMsErroAuto
				CNOMELOG 	:= "SF1100I_ENDER_AUTOMATICO_" + Alltrim(SF1->F1_DOC)  + "_" + ALLTRIM(SF1->F1_SERIE) + "_" + ALLTRIM(SD1->D1_NUMSEQ) + "_" + ALLTRIM(SD1->D1_COD) + ".LOG"
				
				MostraErro("\SYSTEM\",CNOMELOG)
	
				nEndCompra	:= 2 
	
			Endif
			
		EndIf
	Next
	/* reserva do documento de entrada */
	IF nEndCompra = 2
		cMensImp	:= "Aviso de endere�amento automatico de documento de entrada de produto PROART" + ENTER  
		cMensImp	+= "***************************************************************************" + ENTER
		cMensImp	+= ""  + ENTER
		cMensImp	+= "Nota Fiscal/serie: " + SF1->F1_DOC  + "/" + SF1->F1_SERIE + ENTER
		cMensImp	+= "Fornecedor: " + SF1->F1_FORNECE + " - " + ALLTRIM(SA2->A2_NOME) + ENTER
		cMensImp	+= "**********   OCORREU ERRO NO ENDERECAMENTO AUTOMATICO   *************" + ENTER
		cMensImp	+= ""  + ENTER
		cMensImp	+= "***************************************************************************" + ENTER
		
		U_2EnvMail("workflow@taiff.com.br", RTrim(cRsrvEmail) ,"",cMensImp , "Erro no endere�amento de documento de entrada"	,'')
	ELSEIF nEndCompra = 1
		
		SC0->(DbSetOrder(1))
	
		cNUMERO := GETSX8NUM("SC0","C0_NUM")
		
		SD1->(DbSetOrder(1)) // D1_FILIAL, D1_DOC, D1_SERIE, D1_FORNECE, D1_LOJA, D1_COD, D1_ITEM, R_E_C_N_O_, D_E_L_E_T_
		SD1->(DbSeek( xFilial("SD1") + SF1->F1_DOC + SF1->F1_SERIE + SF1->F1_FORNECE + SF1->F1_LOJA))
		While xFilial("SD1") = SD1->D1_FILIAL .AND. SD1->D1_DOC=SF1->F1_DOC .AND. SD1->D1_SERIE=SF1->F1_SERIE .AND. SD1->D1_FORNECE=SF1->F1_FORNECE .AND. SD1->D1_LOJA=SF1->F1_LOJA .AND. .NOT. SD1->(Eof()) 
			SF4->(DbSetOrder(1))
			SF4->(DbSeek( xFilial("SF4") + SD1->D1_TES ))
			If SB1->(DbSeek( xFilial("SB1") + SD1->D1_COD ))
				lPROART := (ALLTRIM(SB1->B1_ITEMCC) = "PROART")
			EndIf
			IF lPROART .AND. SD1->D1_LOCAL="21" .AND. SF4->F4_ESTOQUE = "S"
				SDB->(DbSetOrder(1))  // DB_FILIAL, DB_PRODUTO, DB_LOCAL, DB_NUMSEQ, DB_DOC, DB_SERIE, DB_CLIFOR, DB_LOJA, DB_ITEM, R_E_C_N_O_, D_E_L_E_T_
				If SDB->(DbSeek( xFilial("SDB") + SD1->D1_COD + SD1->D1_LOCAL + SD1->D1_NUMSEQ + SD1->D1_DOC + SD1->D1_SERIE + SD1->D1_FORNECE + SD1->D1_LOJA ))
					aOPERINCL := {1,"NF",SF1->F1_DOC,"SCHDL",CFILANT,"Compra Nfe: " + SF1->F1_DOC+"/"+SF1->F1_SERIE} 
					A430Reserv(aOPERINCL,cNUMERO,SD1->D1_COD , SD1->D1_LOCAL , SD1->D1_QUANT ,aLOTE)
					lRsrvArt := .T.
				EndIf
			EndIf
			SD1->(DbSkip())
		End
		IF lRsrvArt 
			CONFIRMSX8()
	
			cMensImp	:= "Aviso de reserva automatica de documento de entrada de produto PROART" + ENTER  
			cMensImp	+= "***********************************************************************" + ENTER
			cMensImp	+= ""  + ENTER
			cMensImp	+= "Nota Fiscal/serie: " + SF1->F1_DOC  + "/" + SF1->F1_SERIE + ENTER
			cMensImp	+= "Fornecedor: " + SF1->F1_FORNECE + " - " + ALLTRIM(SA2->A2_NOME) + ENTER
			cMensImp	+= "Numero da Reserva: " + cNUMERO + ENTER
			cMensImp	+= "Obs.: Endere�amento e reserva realizada com sucesso!!" + ENTER
			cMensImp	+= ""  + ENTER
			cMensImp	+= "***********************************************************************" + ENTER
							
			U_2EnvMail("workflow@taiff.com.br", RTrim(cRsrvEmail) ,"",cMensImp , "Aviso de reserva de documento de entrada"	,'')
			
			SC0->(DbSetOrder(1))
			SC0->(DbSeek( xFilial("SC0") + cNUMERO))
			While .NOT. SC0->(Eof()) .AND. SC0->C0_NUM = cNUMERO 
				If SC0->(RecLock("SC0", .F.))
					SC0->C0_VALIDA := SC0->C0_VALIDA + 15
					SC0->(MsUnLock())
				EndIf
				SC0->(DbSkip())
			End
		Else
			cMensImp	:= "Aviso de endere�amento automatico de documento de entrada de produto PROART" + ENTER  
			cMensImp	+= "***************************************************************************" + ENTER
			cMensImp	+= ""  + ENTER
			cMensImp	+= "Nota Fiscal/serie: " + SF1->F1_DOC  + "/" + SF1->F1_SERIE + ENTER
			cMensImp	+= "Fornecedor: " + SF1->F1_FORNECE + " - " + ALLTRIM(SA2->A2_NOME) + ENTER
			cMensImp	+= "***************************************************************************" + ENTER
			cMensImp	+= "****************   OCORREU ERRO NO ENDERE�AMENTO AUTOMATICO   *************"  + ENTER
			cMensImp	+= "***************************************************************************" + ENTER
							
			U_2EnvMail("workflow@taiff.com.br", RTrim(cRsrvEmail) ,"",cMensImp , "Aviso de reserva de documento de entrada"	,'')
		
		EndIf
	EndIf
EndIf

RestArea(aSaveSE1)
//------------------------------[ Fim Ponto de Valida��o: TOTVS ]-------------------------------------------------------------

RestArea(aArea)
Return Nil

/*
=================================================================================
=================================================================================
||   Arquivo:	SF1100I.prw
=================================================================================
||   Funcao: 
=================================================================================
||   Descricao
||-------------------------------------------------------------------------------
|| 
|| 
|| 
|| 
|| 
=================================================================================
=================================================================================
||   Autor: 
||   Data:
=================================================================================
=================================================================================
*/

STATIC FUNCTION ENVWFERR(cNota)

LOCAL CEMAIL 	:= "grp_sistemas@taiff.com.br"
LOCAL OPROCESS 

//## Cria processo de Workflow
OPROCESS 			:= TWFPROCESS():NEW( "WFERRCTE", OEMTOANSI("WORKFLOW CTE SEM CHAVE ELETRONICA"))
OPROCESS:NEWTASK( "WFERRCTE", "\WORKFLOW\WFERRCTE.HTM" )
OPROCESS:CTO 		:= CEMAIL
OPROCESS:CSUBJECT 	:= OEMTOANSI("WORKFLOW CTE SEM CHAVE ELETRONICA")
OHTML 				:= OPROCESS:OHTML

//## Preenche o campo de Numero da OF e Data da OF
OHTML:VALBYNAME("cNota"		,cNota) 

//## Envia WorkFlow e Encerra
OPROCESS:CLIENTNAME( SUBS(CUSUARIO,7,15) )
OPROCESS:USERSIGA	:= __CUSERID
OPROCESS:START()
OPROCESS:FREE()

RETURN
