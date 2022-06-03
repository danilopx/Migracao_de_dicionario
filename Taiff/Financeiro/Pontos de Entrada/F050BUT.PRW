/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³F050BUT   ºAutor  ³TOTVS ABM           º Data ³  12/22/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ PE usado para incluir botao na tela do contas a pagar com  º±±
±±º          ³a finalidade de visualizar o documento de origem.           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
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
		Aviso("Nao Localizado", "O documento que voce está procurando, não foi localizado na tabela de notas fiscais de entrada.", {"Ok"})
	EndIf
	
	DbSelectArea(cAlias)
	Return Nil