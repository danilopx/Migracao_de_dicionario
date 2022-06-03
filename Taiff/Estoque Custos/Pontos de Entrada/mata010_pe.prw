#Include 'Protheus.ch'
#INCLUDE "FWMVCDEF.CH"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � MATA010_pe � Autor � Carlos Torres     � Data � 23/11/2017 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Programa de atualizacao de Produtos - MVC                  ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   �                                                            ���
�������������������������������������������������������������������������Ĵ��
���Parametros�                                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

/* Link de referencia => http://tdn.totvs.com/display/public/PROT/ADV0041_PE_MVC_MATA010_P12 */
/*********************************************************************************************************************/
/*****************************               I  M  P  O  R  T  A  N  T  E                *****************************/
/*********************************************************************************************************************/
/* Na rotina MATA010 o ponto de entrada no Padr�o MVC o nome da user function � ITEM que � o ID do Modelo de Dados   */
/*********************************************************************************************************************/
/* Com a rotina MATA010_PE.PRW os pontos de entrada s�o subtituiveis: A010TOK, MT010ALT e MTA010MNU                  */

User Function ITEM()
	Local aParam := PARAMIXB
	Local xRet := .T.
	Local oObj := ''
	Local cIdPonto := ''
	Local cIdModel := ''
	Local lIsGrid := .F.

	// Local nLinha := 0
	// Local nQtdLinhas := 0
	// Local cMsg := ''

	Local lOk_MTA010MNU := .F.
	//---------------------------------------------------------------------------------------------------------------------------- 
	// Variaveis: TOTVS 
	//---------------------------------------------------------------------------------------------------------------------------- 
	Local lUniNeg	:= cEmpAnt+cFilant $ GETNEWPAR('MV_UNINEG'/*cParametro*/, cEmpAnt+cFilant /*cPadrao*/, /*cFilial*/)
	//-- Separar no parametro as empresas filiais concatenadas. Ex. 0302/0303
	//--------------------------------------------[ Fim Customiza��o TOTVS ]------------------------------------------------------
	
	If aParam <> NIL

		oObj := aParam[1]
		cIdPonto := aParam[2]
		cIdModel := aParam[3]
		lIsGrid := ( Len( aParam ) > 3 )

		If cIdPonto == 'MODELPOS'
			If M->B1_IMPZFRC != "S" .AND. !M->B1_ORIGEM $ ("0|5|6|7")
				ApMsgInfo("H� diverg�ncia de informa��es entre os campos Origem e Imp.Z.Franca!","Valida��o em MATA010_PE.PRW")
				//Aviso("Aten��o" , "H� diverg�ncia de informa��es entre os campos Origem e Imp.Z.Franca! " + chr(13) + "Valida��o MATA010_PE.PRW", {"Ok"}, 	3)
				
				xRet := .F.
			EndIf
			//cMsg := 'Chamada na valida��o total do modelo.' + CRLF
			//cMsg += 'ID ' + cIdModel + CRLF

			//xRet := ApMsgYesNo( cMsg + 'Continua ?' )

		ElseIf cIdPonto == 'FORMPOS'
			//cMsg := 'Chamada na valida��o total do formul�rio.' + CRLF
			//cMsg += 'ID ' + cIdModel + CRLF

			//If lIsGrid
			//	cMsg += '� um FORMGRID com ' + Alltrim( Str( nQtdLinhas ) ) + ' linha(s).' + CRLF
			//	cMsg += 'Posicionado na linha ' + Alltrim( Str( nLinha ) ) + CRLF
			//Else
			//	cMsg += '� um FORMFIELD' + CRLF
			//EndIf

			//xRet := ApMsgYesNo( cMsg + 'Continua ?' )

		ElseIf cIdPonto == 'FORMLINEPRE'
			//If aParam[5] == 'DELETE'
			//	cMsg := 'Chamada na pre valida��o da linha do formul�rio. ' + CRLF
			//	cMsg += 'Onde esta se tentando deletar a linha' + CRLF
			//	cMsg += 'ID ' + cIdModel + CRLF
			//	cMsg += '� um FORMGRID com ' + Alltrim( Str( nQtdLinhas ) ) + ' linha(s).' + CRLF
			//	cMsg += 'Posicionado na linha ' + Alltrim( Str( nLinha ) ) + CRLF
			//	xRet := ApMsgYesNo( cMsg + 'Continua ?' )
			//EndIf

		ElseIf cIdPonto == 'FORMLINEPOS'
			//---------------------------------------------------------------------------------------------------------------------------- 
			// Ponto de Valida��o: TOTVS 
			// Descri��o: Validar unidade de negocio no produto
			// Merge.......: TAIFF - C. Torres                                           Data: 10/04/2013
			//---------------------------------------------------------------------------------------------------------------------------- 
			If lUniNeg
				if Empty(M->B1_ITEMCC) 
					xRet := .F.   
					Help(nil,1,'Unidade de Negocios',nil,'Obrigat�rio preencher unidade de negocios!',3,0)
				endif
			EndIf
			
		ElseIf cIdPonto == 'MODELCOMMITTTS'
			//ApMsgInfo('Chamada apos a grava��o total do modelo e dentro da transa��o.')

		ElseIf cIdPonto == 'MODELCOMMITNTTS'

			IF LEFT(SB1->B1_CODBAR,1) <> "7" .AND. (CEMPANT="04" .OR. CEMPANT="03")
				IF SB1->(RecLock("SB1",.F.))
					SB1->B1_CODBAR := SB1->B1_COD
				ENDIF
				SB1->(msUnlock())
			ENDIF


			//ApMsgInfo('Chamada apos a grava��o total do modelo e fora da transa��o.')
			If CEMPANT="01"
				nOpcReplica := IIF(ALTERA,4,IIF(INCLUI,3,0))
				Processa({|| U_TPPROCREP("SB1","U_CADSB1",nOpcReplica) },"Replicando para as demais empresas...")
			EndIf   

		ElseIf cIdPonto == 'FORMCOMMITTTSPRE'
			//ApMsgInfo('Chamada apos a grava��o da tabela do formul�rio.')

		ElseIf cIdPonto == 'FORMCOMMITTTSPOS'
			//ApMsgInfo('Chamada apos a grava��o da tabela do formul�rio.')

		ElseIf cIdPonto == 'MODELCANCEL'
			//cMsg := 'Deseja Realmente Sair ?'
			//xRet := ApMsgYesNo( cMsg )

		ElseIf cIdPonto == 'BUTTONBAR'
			cUsuLib := RetCodUsr()
			
			If U_CHECAFUNC(cUsuLib,"MTA010MNU")
				lOk_MTA010MNU := .T.
			EndIf
			
			If lOk_MTA010MNU
				xRet := { {'Anexo', 'ANEXO', { || U_SelArqSQL('SB1'+SB1->B1_FILIAL+SB1->B1_COD,.T., .T.) } } }
			Else
				xRet := { {'Anexo', 'ANEXO', { || U_SelArqSQL('SB1'+SB1->B1_FILIAL+SB1->B1_COD,.F., .F.) } } }
			EndIf
		EndIf
	EndIf
Return xRet
