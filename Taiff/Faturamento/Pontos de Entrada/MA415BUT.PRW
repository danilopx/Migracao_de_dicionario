
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MA415BUT  �Autor  �Thiago Comelli      � Data �  09/19/11   ���
�������������������������������������������������������������������������͹��
���Desc.     �Ponto de Entrada para a adi��o de bot�es no orcamento de venda ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �ProArt                                                      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function MA415BUT()

	Local aUsrBot := {}

//Executa somente na empresa e filial selecionados
	If (cEmpAnt+cFilAnt) $ SuperGetMV("MV__MULT05",.F.,"")
		If VerSenha(136) //verifica se o usuario logado possui acesso 136-Lib.Pedido Venda
			aadd(aUsrBot,{"SIMULACAO",  {|| U_FINMI001(SCJ->CJ_CLIENTE, SCJ->CJ_LOJA, "S") },"Avalia Cr�dito", "Credito"})
		EndIf
	EndIf

Return(aUsrBot)
