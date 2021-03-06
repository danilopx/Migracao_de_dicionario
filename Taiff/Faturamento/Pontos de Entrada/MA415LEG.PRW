#INCLUDE "PROTHEUS.CH"

/*
����������������������������������������������������������������������������������������������
����������������������������������������������������������������������������������������������
������������������������������������������������������������������������������������������ͻ��
���Programa  � MA415LEG �Autor  �Daniel Tadashi Batori                � Data �  10/12/12   ���
������������������������������������������������������������������������������������������͹��
���Desc.     � Ponto de entrada para incluir itens na legenda da tela de orcamento         ���
������������������������������������������������������������������������������������������͹��
���Uso       � AP                                                                          ���
������������������������������������������������������������������������������������������ͼ��
����������������������������������������������������������������������������������������������
����������������������������������������������������������������������������������������������
*/
User Function MA415LEG()
	Local _aLegenda := PARAMIXB

//-----------------------------------------------------------------------------------------------
//Adicionado por Thiago Comelli em 16/10/2012
//Executa somente na empresa e filial selecionados
	If (cEmpAnt+cFilAnt) $ SuperGetMV("MV__MULT05",.F.,"")

		Aadd(_aLegenda,{"V_CRED_AZUL"   ,"Pendente Aval. Cred."})
		Aadd(_aLegenda,{"V_CRED_LARANJA","Pendente Aval. Manual Cred."})
		Aadd(_aLegenda,{ 'V_CRED_ROSA',"Pendente Aval. Cred. Devido Altera��o"})
		Aadd(_aLegenda,{"V_CRED_VERMELHO","Orcamento Bloqueado Cred."})
	EndIf
/*
BR_AMARELO
BR_AZUL
BR_BRANCO
BR_CINZA
BR_LARANJA
BR_MARROM
BR_PINK
BR_PRETO
BR_VERDE
BR_VERMELHO
*/

	Return _aLegenda
