#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"

#DEFINE ENTER CHR(13) + CHR(10)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³GFAT001S - Saidas              Autor: CT  Data: 13/01/2015  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Atribui valor de IVA conforme regime especial de MG        º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Linha OK do Pedido de Vendas 			                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function GFATIVAB()
Local lRet		:= aCols[N,aScan( aHeader,{|X| AllTrim(X[2]) == "C6_OPER"}) ]
Local cQuery	:= ""		
Local nPosALIQMAR	:= 0
Local nPosPICMRET	:= 0
Local lBonifIVA	:= GetNewPar("TF_IVABONIF",.F.)
Local cMV_ESTADO	:= GetMv('MV_ESTADO')

If FunName() == "MATA410"		//Pedidos de Venda
	nPosALIQMAR:= aScan( aHeader,{|X| AllTrim(X[2]) == "C6_ALIQMAR"})
	nPosPICMRET:= aScan( aHeader,{|X| AllTrim(X[2]) == "C6_PICMRET"})
	
	If CEMPANT = '03' .AND. CFILANT = '02' .AND. M->C5_CLASPED $ 'X| ' .AND. SA1->A1_EST=cMV_ESTADO .AND. SF7->(FIELDPOS("F7_MARBON"))!=0
		If At( Alltrim(SB1->B1_ORIGEM) , '1|2|3') != 0 .AND.  M->C5_TIPO = "N" .AND. SF4->F4_ISS!="S" .AND. SA1->A1_GRPTRIB='C01' .AND. lBonifIVA 
				
			cQuery := "SELECT ISNULL(F7_MARBON,0) AS F7_MARBON " + ENTER
			cQuery += " FROM " + RetSQLName("SF7")+" SF7 " + ENTER
			cQuery += " WHERE " + ENTER
			cQuery += " F7_FILIAL = '"+xFilial("SF7")+"' " + ENTER 
			cQuery += " AND F7_GRPCLI 	= '" + SA1->A1_GRPTRIB + "' "  + ENTER
			cQuery += " AND F7_EST 		= '" + SA1->A1_EST + "' " + ENTER
			cQuery += " AND F7_GRTRIB		= '" + SB1->B1_GRTRIB + "' " + ENTER
			cQuery += " AND SF7.D_E_L_E_T_ = '' " + ENTER

			//MemoWrite("GFATIVAB_iva_bonificacao.SQL",cQuery)
			
			IF SELECT("AUX") > 0 
				DBSELECTAREA("AUX")
				DBCLOSEAREA()
			ENDIF 
			
			TCQUERY CQUERY NEW ALIAS "AUX"
			DBSELECTAREA("AUX")
				
			aCols[N,nPosALIQMAR]	:= AUX->F7_MARBON
			aCols[N,nPosPICMRET]	:= AUX->F7_MARBON
		EndIf
	EndIf
EndIf
Return (lRet)
