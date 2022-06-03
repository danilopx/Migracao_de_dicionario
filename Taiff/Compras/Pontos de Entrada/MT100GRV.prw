#INCLUDE 'TBICONN.CH'
#INCLUDE 'TBICODE.CH'
#INCLUDE 'TOPCONN.CH'
#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'PARMTYPE.CH'
#INCLUDE 'TRYEXCEPTION.CH'

#DEFINE ENTER CHR(13) + CHR(10)

/*
=================================================================================
=================================================================================
||   Arquivo:	MT100GRV.prw
=================================================================================
||   Funcao:	MT100GRV 
=================================================================================
||   Descricao
||-------------------------------------------------------------------------------
|| 		Está localizado na função a103Grava responsável pela gravação da Nota 
|| 	Fiscal. Executado antes de iniciar o processo de gravação / exclusão de 
|| 	Nota de Entrada.
|| 
|| 
=================================================================================
=================================================================================
||   Autor:	Edson Hornberger  
||   Data:	28/04/2016
=================================================================================
=================================================================================
*/

USER FUNCTION MT100GRV()

LOCAL BERROR	:= {|OERROR| TRATAERRO(OERROR)}
LOCAL OERROR	
LOCAL LEXCL 	:= PARAMIXB[1]		// Informa se é uma Exclusão de NF.
LOCAL CQUERY 	:= ""
LOCAL CNFORIG	:= ""
LOCAL CSRORIG	:= ""
LOCAL CITORIG	:= ""
LOCAL COP		:= ""
LOCAL NQTDRET	:= 0 
LOCAL I			:= 0 
LOCAL APROCRET	:= {} 
LOCAL LRET		:= .T.

/*
|=================================================================================
|   COMENTARIO
|---------------------------------------------------------------------------------
|	Se for uma Exclusão de NF de retorno de materias divergentes/com defeitos 
|	referente a um Beneficiamento deve restaurar a quantidade no controle da 
|	tabela SD4.
|=================================================================================
*/
TRYEXCEPTION USING BERROR

	IF LEXCL
		
		FOR I := 1 TO LEN(ACOLS)
	
			COP		:= ACOLS[I][GDFIELDPOS("D1_OP")]
			CNFORIG	:= ACOLS[I][GDFIELDPOS("D1_NFORI")]
			CSRORIG	:= ACOLS[I][GDFIELDPOS("D1_SERIORI")]
			CITORIG	:= ACOLS[I][GDFIELDPOS("D1_ITEMORI")]
			NQTDRET	:= ACOLS[I][GDFIELDPOS("D1_QUANT")]
			
			IF !EMPTY(ALLTRIM(CNFORIG)) .AND. !EMPTY(ALLTRIM(CSRORIG)) .AND. !EMPTY(ALLTRIM(CITORIG)) .AND. EMPTY(ALLTRIM(COP))
				
				CQUERY := "SELECT" 																			+ ENTER 
				CQUERY += "	SD2.D2_TIPO," 																	+ ENTER
				CQUERY += "	SD2.D2_PEDIDO," 																+ ENTER
				CQUERY += "	SD2.D2_COD," 																	+ ENTER
				CQUERY += "	SC6.C6__OPBNFC," 																+ ENTER
				CQUERY += "	SD2.D2_QUANT," 																	+ ENTER 
				CQUERY += "	SD2.D2_CLIENTE," 																+ ENTER
				CQUERY += "	SD2.D2_LOJA" 																	+ ENTER
				CQUERY += "FROM" 																			+ ENTER 
				CQUERY += "	" + RETSQLNAME("SD2") + " SD2 WITH(NOLOCK)" 									+ ENTER
				CQUERY += "	INNER JOIN " + RETSQLNAME("SC6") + " SC6 WITH(NOLOCK) ON" 						+ ENTER 
				CQUERY += "		SC6.C6_FILIAL = '" + XFILIAL("SC6") + "' AND" 								+ ENTER 
				CQUERY += "		SC6.C6_NUM = SD2.D2_PEDIDO AND" 											+ ENTER 
				CQUERY += "		SC6.C6_ITEM = SD2.D2_ITEMPV AND" 											+ ENTER 
				CQUERY += "		SC6.C6_PRODUTO = SD2.D2_COD AND" 											+ ENTER 
				CQUERY += "		SC6.D_E_L_E_T_ = ''" 														+ ENTER
				CQUERY += "WHERE" 																			+ ENTER 
				CQUERY += "	SD2.D2_FILIAL = '" + XFILIAL("SD2") + "' AND" 									+ ENTER 
				CQUERY += "	SD2.D2_DOC + SD2.D2_SERIE + SD2.D2_ITEM = '" + CNFORIG + CSRORIG + CITORIG + "' AND" + ENTER 
				CQUERY += "	SD2.D_E_L_E_T_ = ''" 															+ ENTER
				CQUERY += "GROUP BY" 																		+ ENTER
				CQUERY += "	SD2.D2_TIPO," 																	+ ENTER
				CQUERY += "	SD2.D2_COD," 																	+ ENTER
				CQUERY += "	SD2.D2_PEDIDO," 																+ ENTER
				CQUERY += "	SC6.C6__OPBNFC," 																+ ENTER
				CQUERY += "	SD2.D2_QUANT," 																	+ ENTER
				CQUERY += "	SD2.D2_CLIENTE," 																+ ENTER
				CQUERY += "	SD2.D2_LOJA"
				
				IF SELECT("TMP") > 0 
				
					DBSELECTAREA("TMP")
					DBCLOSEAREA()
					
				ENDIF
			
				TCQUERY CQUERY NEW ALIAS "TMP"
				DBSELECTAREA("TMP")
				DBGOTOP()
				
				COUNT TO NREG
				
				IF NREG > 0
					TMP->(DBGOTOP())
					AADD(APROCRET,{I, TMP->C6__OPBNFC, TMP->D2_COD, NQTDRET})
				ENDIF
				
			ENDIF
			
		NEXT I
		
		IF LEN(APROCRET) > 0 
			
			BEGIN TRANSACTION
	
				FOR I := 1 TO LEN(APROCRET)
					
					DBSELECTAREA("SD4")
					DBSETORDER(2)
					DBGOTOP()
					IF DBSEEK(XFILIAL("SD4") + APROCRET[I][2] + APROCRET[I][3])
						
						IF RECLOCK("SD4",.F.)
							
							SD4->D4__QTBNFC += APROCRET[I][4]
							MSUNLOCK()
							
						ENDIF
						
					ENDIF
					TMP->(DBSKIP())
					
				NEXT I 
				
			END TRANSACTION 
			
		ENDIF
		
	ENDIF

CATCHEXCEPTION USING OERROR
	
	APMSGALERT("OCORREU UM ERRO DE PROCESSAMENTO!","ERROR CAPTURED")
	LRET := .F.
	
ENDEXCEPTION

If lRet
	If lExcl
		ExcLote()
	EndIf
EndIf

RETURN(LRET)

/*
=================================================================================
=================================================================================
||   Arquivo:	MT100GRV.prw
=================================================================================
||   Funcao:	TRATAERRO 
=================================================================================
||   Descricao
||-------------------------------------------------------------------------------
||		 Bloco de código para tratamento de Erros 
|| 
=================================================================================
=================================================================================
||   Autor:	Edson Hornberger 
||   Data:	28/04/2016
=================================================================================
=================================================================================
*/
STATIC FUNCTION TRATAERRO(OERROR)

	CONOUT("Warning --> MT100GRV" + ENTER + OERROR:DESCRIPTION + ENTER + OERROR:ERRORSTACK)
	APMSGINFO(OERROR:DESCRIPTION,"ERROR CAPTURED")
	BREAK

RETURN



//Programa:     ExcLote
//Finalidade:   Exclui lote de componente vinculado a NFe que sera' excluida 
//Autor:        Ronald Piscioneri
//Data:         14-Set-2021
//Uso:          Taiff / Action
Static Function ExcLote()
Local cEmpFAtl := SuperGetMV("MT100GRV01",,"|0402|")
Local cSql := ""

If ( Alltrim(cEmpAnt) + Alltrim(cFilAnt) ) $ cEmpFAtl

	cSql := "UPDATE " +RetSqlName("ZZS")+ " "
	cSql += "SET D_E_L_E_T_ = '*', R_E_C_D_E_L_ = R_E_C_N_O_ "
	cSql += "WHERE D_E_L_E_T_ = ' ' "
	cSql += "AND ZZS_FILIAL = '" +xFilial("ZZS")+ "' "
	cSql += "AND ZZS_NUMNF = '" +SF1->F1_DOC+ "' "
	cSql += "AND ZZS_SERNF = '" +SF1->F1_SERIE+ "' "
	cSql += "AND ZZS_CODFOR = '" +SF1->F1_FORNECE+ "' "
	cSql += "AND ZZS_LOJFOR = '" +SF1->F1_LOJA+ "' "

	TcSqlExec( cSql )

EndIf

Return(Nil)
