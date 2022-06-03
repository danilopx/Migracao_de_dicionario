#include "Protheus.ch"		// Eduardo Alberti Em 10/Jul/2014
#include "RwMake.ch"		// Eduardo Alberti Em 10/Jul/2014
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa� MT100LOK  � Autor � Gilberto Ribeiro Jr  �Data � 07/10/2011  ���
�������������������������������������������������������������������������͹��
���Descricao � Ponto de Entrada para valida��o dos itens da Nota Fiscal   ���
���				de Entrada			  													  ���
�������������������������������������������������������������������������͹��
���Uso       � Sempre que mudar de linha, ou fechar a tela                ���
�������������������������������������������������������������������������͹��
*/
User Function MT100LOK()

Local _aArea	:= GetArea()
Local _aArSF4	:= SF4->(GetArea())
Local _aArSA1	:= SA1->(GetArea())
Local _aArSA2	:= SA2->(GetArea())
Local _aArCT1	:= CT1->(GetArea())
Local _aArSC7	:= SC7->(GetArea())

Local lExecuta 	:= ParamIxb[1]
Local cInter
Local cMeta
Local cTes
Local cConta
Local cCodCliForn := CA100FOR //C�digo do Cliente ou Fornecedor
Local cCodLoja		:= CLOJA 	//C�digo da Loja do Cliente ou Fornecedor
Local cPedido 						//C�digo do Pedido
Local cItemPc 						//Item do Pedido de Compra
Local nQtdeNF := 0 				//Quantidade digitada para o item

Local cTfArmBlq := GETNEWPAR('MV__ARMBLQ'/*cParametro*/, "" /*cPadrao*/, /*cFilial*/) // Cont�m os armazens bloqueados para o projeto bloco K
Local cD1ARMAZEM:= ""
Local cMensLocal:= ""

cInter  	:= aCols[n][GDFieldPos("D1_INTER")]
cMeta   	:= aCols[n][GDFieldPos("D1_META")]
cPedido 	:= aCols[n][GDFieldPos("D1_PEDIDO")]
cTes 		:= aCols[n][GDFieldPos("D1_TES")]
cConta		:= aCols[n][GDFieldPos("D1_CONTA")]
cPedido		:= aCols[n][GDFieldPos("D1_PEDIDO")]
cItemPc		:= aCols[n][GDFieldPos("D1_ITEMPC")]
nQtdeNF		:= aCols[n][GDFieldPos("D1_QUANT")]
cD1ARMAZEM	:= aCols[n][GDFieldPos("D1_LOCAL")]
cTfArmBlq 	:= ALLTRIM(cTfArmBlq)
cD1ARMAZEM	:= ALLTRIM(cD1ARMAZEM)
//Valida��o do campo de CI (Conteudo de Importa��o) para os Itens da NF - Edson Hornberger - 27/08/2013
//If !U_GCOM003()

//	Return(.F.)

//EndIf

//Se o campo Meta (D1_META) do Item estiver vazio, obtem o campo Meta (F4_META) do cadastro de TES
If Empty(AllTrim(cMeta))
	dbSelectArea("SF4")
	SF4->( dbSetOrder(1) )
	SF4->(dbSeek(xFilial("SF4")+cTes))
	aCols[n][GDFieldPos("D1_META")] = SF4->F4_META
EndIf

If cTipo$"D/B" //Se for do tipo Devolu��o/Beneficiamento busca no cadastro de Clientes
	If Empty(AllTrim(cInter))
		dbSelectArea("SA1")
		SA1->( dbSetOrder(1) )
		SA1->(dbSeek(xFilial("SA1")+cCodCliForn+cCodLoja))
		aCols[n][GDFieldPos("D1_INTER")] = SA1->A1_INTER
	EndIf
Else
	
	/*******************************************************************************************************************************
	Autor: Gilberto Ribeiro Junior
	Data: 12/08/2013
	Solicitante: Patricia Inoue
	Se quantidade digitada for maior que a o saldo do pedido, emite uma mensagem e sai da rotina
	*******************************************************************************************************************************/
	/*
	If (cPedido <> "" .And. cItemPc <> "")
	If U_ValQtdPed(cPedido, cItemPc, nQtdeNF)
	Alert("ATEN��O!!! N�o � permitido efetuar entrada da nota fiscal com quantidade maior que o saldo do pedido.")
	Return .F.
	EndIf
	EndIf
	*/
	/*******************************************************************************************************************************/
	
	dbSelectArea("SA2")
	SA2->( dbSetOrder(1) )
	SA2->(dbSeek(xFilial("SA2")+cCodCliForn+cCodLoja))
	
	//CUSTOMIZA��O PARA FORNECEDORES OPTANTE PELO SIMPLES NACIONAL (INCLUIR ESTE BLOCO NO FONTE MT140LOK)
	If SA2->A2_SIMPNAC = "1" .AND. U_RETPERCICMS() > 0
		aCols[n][GDFieldPos("D1_PICM")] = U_RETPERCICMS()
		// Incluido verificacao no TES se a mesma realiza calculo de Impostos
		// Caso positivo, realize o recalculo com a funcao MaFisRef
		// Edson Hornberger - 29/07/2013
		If SF4->F4_ICM = 'S' .OR. SF4->F4_IPI = 'S'
			MaFisRef("IT_ALIQICM", "MT100", aCols[n][GDFieldPos("D1_PICM")])
		EndIf
		If ExistTrigger("D1_PICM") // Eduardo Alberti Em 10/Jul/2014 -> Ajustado Nome Do Campo estava D1_PICMS
			RunTrigger(1,Nil,Nil,,"D1_PICM")
		EndIf
	EndIf
	
	If Empty(AllTrim(cInter))
		aCols[n][GDFieldPos("D1_INTER")] = SA2->A2_INTER
	EndIf
	
EndIf

//
// Demanda funcional especifica para empresa ACTION devido � participa��o do bloco K 
// Que diz sobre o controle dos armazens que n�o movimentam estoque, neste caso ACTION - Varginha 
// n�o poder� utilizar TES que movimenta estoque, por exemplo no armaz�m 40.  
//
If CEMPANT="04"
	If .NOT. Empty(cTfArmBlq)
		If At( cD1ARMAZEM ,cTfArmBlq) != 0 
			dbSelectArea("SF4")
			SF4->( dbSetOrder(1) )
			SF4->(dbSeek(xFilial("SF4")+cTes))
			If SF4->F4_ESTOQUE="S"
				cMensLocal	:= "N�o � permitido efetuar entrada da nota fiscal com TES que movimenta estoque no armaz�m " + cD1ARMAZEM 
				cMensLocal	+= ", determina��o dada pela gest�o da Controladoria e da Contabilidade."
				Help(NIL, NIL, "Valida��o interna (MT100LOK)", NIL, cMensLocal, 1, 0, NIL, NIL, NIL, NIL, NIL, {"Solicite � �rea fiscal TES que n�o movimente estoque"})
				lExecuta	:= .F.
			EndIf
		EndIf
	EndIf
EndIf

RestArea(_aArSC7)
RestArea(_aArCT1)
RestArea(_aArSA2)
RestArea(_aArSA1)
RestArea(_aArSF4)
RestArea(_aArea)

Return (lExecuta)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �VLDSIMPNAC� Autor �Gilberto Ribeiro Jr �Data  � 30/07/2012  ���
�������������������������������������������������������������������������͹��
���Descricao � Customiza��o para fornecedores optantes pelo simples nacio ���
���			 �nal                                                         ���
�������������������������������������������������������������������������͹��
���Uso       � Sempre que mudar de linha, ou fechar a tela                ���
�������������������������������������������������������������������������͹��
*/
User Function VLDSIMPNAC

Local _aArea		:= GetArea()			// Eduardo Alberti Em 10/Jul/2014
Local _cPar01		:= Iif(Type("MV_PAR01") <> "U",MV_PAR01,"")	// Eduardo Alberti Em 10/Jul/2014
Local lRet 			:= .T.
Local cPerg 		:= "VLDSIMPNAC"
Public nPercICMS 	:= 0

/*********************************************************************************************/
//CUSTOMIZA��O SOLICITADA PELA MARTA (16/07/2012)
/*********************************************************************************************/
// Implementado ISINCALLSTACK() para atender o bloqueio que ocorre no EDI, j� que interrompe o 
// processo e deixando o arquivo em estado de espera (rotina chamada pela TAEDIS01). 
If SA2->A2_SIMPNAC == "1" .AND. .NOT. (ISINCALLSTACK("TAEDIS01") .OR. ISINCALLSTACK("U_TAEDIS01"))
	Alert("ATEN��O!!! Fornecedor optante pelo Simples Nacional. Atente-se para o percentual de ICMS.")
	PutSX1( cPerg, "01","% ICMS","% ICMS:","% ICMS:","mv_ch1","N",05,2,0,"G","U_VLSIMPN()","","","","mv_par01"," "," "," ",""," "," "," "," "," "," "," "," "," ","","","")
	If Pergunte(cPerg,.t.)
		nPercICMS := mv_par01
	EndIf
EndIf

MV_PAR01 := _cPar01	// Eduardo Alberti Em 10/Jul/2014
RestArea(_aArea) 	// Eduardo Alberti Em 10/Jul/2014

Return lRet
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa�RETPERCICMS� Autor � Gilberto Ribeiro Jr  �Data � 12/08/2013 ���
�������������������������������������������������������������������������͹��
���Descricao � Valida a se a qtd. da nota � maior que o saldo do pedido   ���
�������������������������������������������������������������������������͹��
*/
User Function RETPERCICMS

If Type("nPercICMS") == "U"
	Return 0
EndIf

Return nPercICMS
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa� ValQtdPed  � Autor � Gilberto Ribeiro Jr  �Data � 12/08/2013 ���
�������������������������������������������������������������������������͹��
���Descricao � Valida a se a qtd. da nota � maior que o saldo do pedido   ���
�������������������������������������������������������������������������͹��
���Uso       � Sempre que mudar de linha, ou fechar a tela                ���
�������������������������������������������������������������������������͹��
*/
User Function ValQtdPed(cPedido, cItemPc, nQtdeNF)

Local lRet   	 := .F.
Local nQtdSaldo := 0
Local aArea		 := GetArea()

DbSelectArea("SC7")

SC7->(DbSetOrder(1))

If SC7->(DbSeek(xFilial("SC7") + cPedido + cItemPc))
	nQtdSaldo := SC7->C7_QUANT - SC7->C7_QUJE
	If nQtdeNF > nQtdSaldo
		lRet := .T.
	EndIf
EndIf

RestArea(aArea)

Return lRet


/*==========================================================================
Funcao.........:	VlSimpn
Descricao......:	Verifica preenchimento da aliquota
Autor..........:	Amedeo D. Paoli Filho (Advise)
Parametros.....:	Nil
Retorno........:	Logico
==========================================================================*/
User Function VlSimpn()
Local lRetorno	:= .T.
Local nAliqMax	:= SuperGetMV("TF_PERSIMP", Nil, 7)
Local nValor	:= &(ReadVar())

If nValor > nAliqMax
	lRetorno := .F.
	Alert("O valor m�ximo aceito por esse campo � (" + Alltrim(Str(nAliqMax)) + "%)" + CRLF + "Verifique par�metro TF_PERSIMP")
EndIf

Return lRetorno
