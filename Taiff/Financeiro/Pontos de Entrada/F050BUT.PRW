/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �F050BUT   �Autor  �TOTVS ABM           � Data �  12/22/10   ���
�������������������������������������������������������������������������͹��
���Desc.     � PE usado para incluir botao na tela do contas a pagar com  ���
���          �a finalidade de visualizar o documento de origem.           ���
�������������������������������������������������������������������������͹��
���������������������������������������������������������������������������*/
#include "PROTHEUS.CH"
User Function F050BUT()
	Local aRet := {}
	
	aAdd(aRet, {"TK_VERTIT", {|| U_MFIN001()}, "Ver Doc.Origem", "Doc.Origem"})
	Return aRet

User Function MFIN001()
	Local cAlias := Alias()

	PRIVATE l103Auto	:= .F.
	
	SF1->(DbSetOrder(1))
	SF1->(DbGoTop())
	If SF1->(DbSeek(SE2->(E2_FILIAL + E2_NUM + E2_PREFIXO + E2_FORNECE + E2_LOJA), .F.))
		A103NFISCAL("SF1", SF1->(RecNo()), 2, .F., .F.)
	Else
		Aviso("Nao Localizado", "O documento que voce est� procurando, n�o foi localizado na tabela de notas fiscais de entrada.", {"Ok"})
	EndIf
	
	DbSelectArea(cAlias)
	Return Nil