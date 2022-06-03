#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  AAJUICTB   �Autor  �Microsiga           � Data �  12/06/15   ���
�������������������������������������������������������������������������͹��
���Desc.     � Ajuste os itens cont�beis na tabela CTD                    ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

//Rotina Para Ajustar o Item Cont�bil na TABELA CTD
User Function AAJUICTB()

	Processa({|| ProcItemCTB() },"Atualizando CTD-Item Cont�bil")

Return

Static Function ProcItemCTB()
	DbSelectArea("SZY")
	SZY->(DbSetOrder(1))
	SZY->(DbGoTop())

	While SZY->(!EOF())
		IncProc("Atualizando ITEM CTB do Contrato: " + Alltrim(SZY->ZY_CODCONT))
		aRetITCTB := U_GERITEMC(SZY->ZY_FILIAL)
		If aRetITCTB[1]
			MsgStop("Erro ao incluir/Alterar o Item Cont�bil :" + Alltrim(aRetITCTB[3]) + Char(13) + Char(1) + Alltrim(aRetITCTB[2]),"Erro")
		EndIf
		SZY->(DbSkip())
	EndDo
Return