#INCLUDE "TBICONN.CH"
#INCLUDE "PROTHEUS.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �A020DELE  �Autor  �Richard N. Cabral   � Data �  02/12/09   ���
�������������������������������������������������������������������������͹��
���Desc.     � Valida se pode excluir fornecedor - somente na DAIHATSU    ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function A020DELE()

//�������������������������������������������������������Ŀ
//�Checa parametro que habilita / desabilita a replica    �
//���������������������������������������������������������
If ! GetMV("MV_REPLIC",,.F.)
	Return .T.
EndIf

//��������������������������������������������������������Ŀ
//�Valida se eh a empresa da Central de Cadastro (DAIHATSU)�
//����������������������������������������������������������
_aEmpAtu := U_CrgaEmp()
nEmpAtu := Ascan(_aEmpAtu, { | x | x[1] = cEmpAnt .and. x[2] = cFilAnt } )

If ! ( (nEmpAtu > 0) .And. ( Alltrim(_aEmpAtu[nEmpAtu,1]) = AllTrim(GetMV("MV_GRPCAD",,"01")) ) )
	MsgAlert("Exclus�o n�o permitida nesta empresa !!!","STOP")
	Return(.F.)
EndIf

Return(.T.)