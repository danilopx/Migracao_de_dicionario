#Include "Protheus.ch"
#INCLUDE "AP5MAIL.CH"

#DEFINE ENTER Chr(13)+Chr(10)   
//--------------------------------------------------------------------------------------------------------------
// FUNCAO: MA030TOK                                        AUTOR: CARLOS TORRES                 DATA: 29/09/2011
// Descri��o: PE da rotina MATA030 - cadastro do cliente para validar o campo CNAE do cliente
//--------------------------------------------------------------------------------------------------------------
User Function MA030TOK()
	Local lRetorno := .T.
	Local _dAtual 	:= DTOS(Date())
	Local _VldSufr	:= DTOS(M->A1_VLDSUFR)
	Local cLstLiber:= GETNEWPAR("TF_LSTLIB", "rose.araujo@taiff.com.br;douglas.fornazier@taiff.com.br;erick.pinho@taiff.com.br" ) 
	Local cCorpo	:= ""
		
	PRIVATE cAliasLC := GETNEXTALIAS()
	PRIVATE LMSERROAUTO := .F.
	Private cUsuLib

	If INCLUI .or. ALTERA

		/***********************************************************************/
// VALIDA��O DO CNAE PARA PESSOA JURIDICA E QUE N�O SEJA EXPORTA��O
		/***********************************************************************/
		If M->A1_PESSOA = 'J' .and. Empty(M->A1_CNAE) .and. M->A1_EST != "EX"
			Alert( "Para pessoa Juridica o campo CNAE � obrigat�rio!","")
			lRetorno := .F.
		EndIf

		/***********************************************************************/
// VALIDA��O DOS CAMPOS DO SUFRAMA
		/***********************************************************************/
		If !( Empty(M->A1_SUFRAMA) .And. Empty(M->A1_CALCSUF) .And. Empty(M->A1_VLDSUFR) )
			If (!Empty(M->A1_SUFRAMA) .And. (Empty(M->A1_VLDSUFR) .Or. _VldSufr < _dAtual))
				Alert( "Val.Suframa n�o pode ser vazio ou menor que a data atual.","")
				lRetorno := .F.
			ElseIf(M->A1_CALCSUF == "S" .And. (Empty(M->A1_SUFRAMA) .Or. Empty(M->A1_VLDSUFR)) )
				Alert( "Quando o Desc.p/Sufr. diferente de (N�o), o Suframa e Val.Suframa s�o obrigat�rios.","")
				lRetorno := .F.
			ElseIf(!Empty(M->A1_VLDSUFR) .And. (Empty(M->A1_CALCSUF) .Or. Empty(M->A1_SUFRAMA)) )
				Alert( "Quando a Val.Suframa for diferente de vazio, os campos Desc.p/Sufr. e Suframa s�o obrigat�rios.","")
				lRetorno := .F.
			EndIf
			Return lRetorno
		EndIf
		/***********************************************************************/
		/* FIM INCLU�DO PO GILBERTO - 25/11/2011 */

		/***********************************************************************************************************************/
// VALIDA��O DOS CANAL E SUB-CANAL  	                          Autor: Carlos Torres    Data: 31/10/2012
		/***********************************************************************************************************************/
//	If .NOT. U_TFVLDCNL( "SUB" )
//		lRetorno := .F.
//	EndIf
		/***********************************************************************************************************************/
		/* FIM */

		cUsuLib := RetCodUsr()
		If INCLUI .AND. !l030auto
			If U_CHECAFUNC(cUsuLib,"MA030TOK")  
				cCorpo := "O novo cliente " + Alltrim(M->A1_NOME) + " foi bloqueado para uso." + ENTER
				cCorpo += "O autor do cadastro " + Alltrim(CUSERNAME) + " se encontra dentro da regra de bloqueios." + ENTER
				EnvMail('workflow@taiff.com.br',cLstLiber,'',cCorpo,'Novo Cliente cadastrado: '+M->A1_COD + " " + M->A1_LOJA,"")
				M->A1_MSBLQL := "1"
				
				/* Bloqueio complementado pelo PE M030INC*/
			EndIf
		EndIf
		If ALTERA .AND. !l030auto
			If U_CHECAFUNC(cUsuLib,"MA030TOK")       
				cCorpo := "O cliente " + Alltrim(M->A1_NOME) + " foi bloqueado para uso." + ENTER
				cCorpo += "O autor da altera��o " + Alltrim(CUSERNAME) + " se encontra dentro da regra de bloqueios." + ENTER
				EnvMail('workflow@taiff.com.br',cLstLiber,'',cCorpo,'Altera��o de cliente: '+M->A1_COD + " " + M->A1_LOJA,"")
				M->A1_MSBLQL := "1"
			EndIf
		EndIf

/*---------------------------------------------------------
BLOCO INCLUSO POR VETI - THIAGO COMELLI - EM 21/11/2012
----------------------------------------------------------*/
		If (cEmpAnt+cFilAnt) $ SuperGetMV("MV__MULT08",.F.,"") .AND. lRetorno
			BeginSql alias cAliasLC
				SELECT SA1.A1_LC, SA1.A1_COD, SA1.A1_LOJA, SA1.A1_RISCO
				FROM %table:SA1% AS SA1
				WHERE SA1.A1_FILIAL = %xfilial:SA1%
				AND SA1.A1_EST <> 'EX' 
				AND SA1.%NotDel%
				AND SA1.a1_cgc LIKE (SELECT CASE WHEN A1CGC.a1_pessoa = 'J' AND LEN(A1CGC.a1_cgc) <= 0 THEN SUBSTRING(A1CGC.a1_cgc , 1 , LEN(A1CGC.a1_cgc - 6)) WHEN A1CGC.a1_pessoa = 'F' AND LEN(A1CGC.a1_cgc) <= 0 THEN SUBSTRING(A1CGC.a1_cgc , 1 , 11)	END + '%' AS A1_CNPJRZ
				FROM %table:SA1% AS A1CGC
				WHERE A1CGC.%NotDel%
				AND A1CGC.A1_FILIAL = %xfilial:SA1%
				AND A1CGC.A1_COD = %exp:M->A1_COD%
				AND A1CGC.A1_LOJA = %exp:M->A1_LOJA%)
				ORDER BY SA1.A1_CGC
			EndSql

			//cDebug := GetLastQuery()[2]

			If (cAliasLC)->(Eof())
				(cAliasLC)->(DbCloseArea())
				Return (lRetorno)
			EndIf

			If INCLUI
				If M->A1_LC <> 0
					MsgAlert("Limite de Cr�dito ser� de R$"+AllTrim(TRANSFORM((cAliasLC)->A1_LC,'@E 999,999,999.99' ))+" conforme cadastrado no Cliente:"+(cAliasLC)->A1_COD+" Loja:"+(cAliasLC)->A1_LOJA)
					M->A1_LC := (cAliasLC)->A1_LC
				EndIf
				(cAliasLC)->(DbCloseArea())
			EndIf

			IF ALTERA .AND. !l030auto
				IF M->A1_LC <> SA1->A1_LC .OR. M->A1_RISCO <> SA1->A1_RISCO
					IF M->A1_COD <> (cAliasLC)->A1_COD .OR. M->A1_LOJA <> (cAliasLC)->A1_LOJA
						MsgAlert("Limite de Cr�dito somente pode ser alterado no Cliente:"+(cAliasLC)->A1_COD+" Loja:"+(cAliasLC)->A1_LOJA)
						lRetorno := .F.
					Else

						(cAliasLC)->( DbGoTop() )
						(cAliasLC)->(DbSkip())
						While !(cAliasLC)->(Eof())

							MsgRun("Aguarde... Atualizando Lojas... Cliente:"+(cAliasLC)->A1_COD+"-"+(cAliasLC)->A1_LOJA ,,{ || Atualiza() })

							(cAliasLC)->(DbSkip())
						EndDo
						(cAliasLC)->(DbCloseArea())

					endIf
				EndIf
			EndIf
		EndIf
 
	EndIf
/*---------------------------------------------------------
FINAL BLOCO INCLUSO POR VETI - THIAGO COMELLI - EM 21/11/2012
----------------------------------------------------------*/

	Return (lRetorno)

Static Function Atualiza()
	Local nModoGrv := SuperGetMV("MA030TOKA",,1)

	LMSERROAUTO := .F.
	aVetor := {;
		{"A1_FILIAL"	,M->A1_FILIAL			, nil},;
		{"A1_COD"		,(cAliasLC)->A1_COD 	, nil},;
		{"A1_LOJA"  	,(cAliasLC)->A1_LOJA	, nil},;
		{"A1_RISCO"  	,M->A1_RISCO   		,nil},;
		{"A1_LC" 		,M->A1_LC     		,nil}}

	Begin Transaction

		If nModoGrv == 0
			MSExecAuto({|x,y|Mata030(x,y)},aVetor,4)
		Else
			MSExecAuto({|x,y|CRMA980(x,y)},aVetor,4 )	
		EndIf

		IF LMSERROAUTO
			MOSTRAERRO()
		EndIf
	End Transaction

	Return
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MA030TOK  �Autor  �Microsiga           � Data �  05/05/10   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function EnvMail(cVar1,cVar2,cVar3,cVar4,cVar5,Var6)

Local lResult   := .f.                         // Resultado da tentativa de comunicacao com servidor de E-Mail
Local cTitulo1      := Rtrim(cVar5)
Local cEmailTo      := Rtrim(cVar2)
Local cEmailBcc:= ""
Local cError   := ""
Local lRelauth := GetNewPar("MV_RELAUTH",.F.)         // Parametro que indica se existe autenticacao no e-mail
Local lRet      := .F.
Local cFrom     := Iif(Empty(cVar1),GetMV("MV_RELACNT"),cVar1)
Local cConta   := GetMV("MV_RELACNT")
Local cSenha1   := GetMV("MV_RELPSW")
Local cMensagem := rTrim(cVar4)
Local cAttachment := ""

//����������������������������������������Ŀ
//� Tenta conexao com o servidor de E-Mail �
//������������������������������������������
CONNECT SMTP                         ;
SERVER        GetMV("MV_RELSERV");      // Nome do servidor de e-mail
ACCOUNT  GetMV("MV_RELACNT");     // Nome da conta a ser usada no e-mail
PASSWORD GetMV("MV_RELPSW") ;     // Senha
RESULT   lResult                  // Resultado da tentativa de conex�o

// Se a conexao com o SMPT esta ok
If lResult
       
       // Se existe autenticacao para envio valida pela funcao MAILAUTH
       If lRelauth
             lRet := Mailauth(cConta,cSenha1)
       Else
             lRet := .T.
       Endif
       
       If lRet
             SEND MAIL FROM      cFrom ;
             TO                         cEmailTo;
             BCC                 cEmailBcc;
             SUBJECT             cTitulo1;
             BODY                cMensagem;
             ATTACHMENT cAttachment;
             RESULT lResult
             
             
             If !lResult
                    GET MAIL ERROR cError
                    Help(" ",1,"ATENCAO",,cError+ " " + cEmailTo,4,5)
             Endif
             
       Else
             GET MAIL ERROR cError
             Help(" ",1,"Autenticacao",,cError,4,5)
             MsgStop("Erro de autentica��o","Verifique a conta e a senha para envio")
       Endif
       
       DISCONNECT SMTP SERVER
Else
       //Erro na conexao com o SMTP Server
       GET MAIL ERROR cError
       Help(" ",1,"Atencao",,cError,4,5)
Endif
Return	
