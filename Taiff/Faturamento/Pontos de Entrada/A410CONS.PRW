/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �A410CONS  �Autor  �VETI FSW            � Data �  09/19/11   ���
�������������������������������������������������������������������������͹��
���Desc.     �Ponto de Entrada para a adi��o de bot�es no pedido de venda ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �ProArt                                                      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function A410CONS()
Local aUsrBot := {}

//Executa somente na empresa e filial selecionados
If (cEmpAnt+cFilAnt) $ SuperGetMV("MV__SEPA01",.F.,"") //Rotinas de Expedicao Customizadas
	aadd(aUsrBot,{"BMPVISUAL16",  {|| U_PRTC003V() },                "Consulta Faltas", "Faltas"})
EndIf

If (cEmpAnt+cFilAnt) $ SuperGetMV("MV__MULT06",.F.,"") //Rotinas de Avaliacao de Credito
	If VerSenha(136) //verifica se o usuario logado possui acesso 136-Lib.Pedido Venda
		aadd(aUsrBot,{"SIMULACAO",  {|| U_FINMI001(SC5->C5_CLIENTE, SC5->C5_LOJACLI, "S") },               "Avalia Cr�dito", "Credito"})
	EndIf
EndIf

If cempant == "04"
	Aadd(aUsrBot	, {'PEDIDO',{||U_FATRD001()},"Estrutura do OP <CTRL+E> "})
	SET KEY 5 TO U_FATRD001()
Endif
Return(aUsrBot)

