#INCLUDE "TBICONN.CH"
#INCLUDE "PROTHEUS.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �M030DEL   �Autor  �Richard N. Cabral   � Data �  02/12/09   ���
�������������������������������������������������������������������������͹��
���Desc.     � Valida se pode excluir Clientes - somente na DAIHATSU      ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function M030DEL()

Local aFilNoRepl := {}
Local cTabNoRepl := "ZB"
Local aArea, cQuerySX5

//�������������������������������������������������������Ŀ
//�Checa parametro que habilita / desabilita a replica    �
//���������������������������������������������������������
If ! GetMV("MV_REPLIC",,.F.)
	Return .T.
EndIf

If ( Type("l030Auto") == "U" .Or. ! l030Auto )

	aArea	 := GetArea()

	//���������������������������������������������������������Ŀ
	//�Estou chumbando a busca por dados no SX5 da empresa 01   �
	//�para n�o ter que cadastrar os dados em todas as empresas.�
	//�����������������������������������������������������������
	cQuerySX5 := "SELECT X5_DESCRI FROM SX5010 SX5 "
	cQuerySX5 += "WHERE X5_FILIAL = '  ' "  
	cQuerySX5 += "AND X5_TABELA = '" + cTabNoRepl + "' "
	cQuerySX5 += "AND X5_CHAVE = 'SA1' "
	cQuerySX5 += "AND D_E_L_E_T_ = ' ' "
	dbUseArea( .T., "TOPCONN", TCGenQry(,, cQuerySX5), "SQLSX5", .F., .F. )
	
	SQLSX5->(Dbgotop())
	//�������������������������������������������������������������������������������Ŀ
	//�Alimenta Array com as filiais que n�o ser�o replicadas por tabela - Tabela ZB  �
	//���������������������������������������������������������������������������������
	Do While ! SQLSX5->(Eof())
		Aadd(aFilNoRepl, AllTrim(SQLSX5->X5_DESCRI))
		SQLSX5->(DBskip())
	EndDo
	
	SQLSX5->(dbCloseArea())
	
	RestArea(aArea)

	//��������������������������������������������������������Ŀ
	//�Valida se eh a empresa da Central de Cadastro (DAIHATSU)�
	//����������������������������������������������������������
	_aEmpAtu := U_CrgaEmp()
	nEmpAtu := Ascan(_aEmpAtu, { | x | x[1] = cEmpAnt .and. x[2] = cFilAnt } )
	
	If Empty(aFilNoRepl)
		If nEmpAtu > 0 .And. ! (Alltrim(_aEmpAtu[nEmpAtu,1]) = AllTrim(GetMV("MV_GRPCAD",,"01")) )
			MsgAlert("Exclus�o n�o permitida nesta empresa !!!","STOP")
			Return(.F.)
		EndIf
	Else
		If nEmpAtu > 0 .And. ! (Alltrim(_aEmpAtu[nEmpAtu,1]) = AllTrim(GetMV("MV_GRPCAD",,"01")) .Or. ! Empty(Ascan(aFilNoRepl,cEmpAnt)))
			MsgAlert("Exclus�o n�o permitida nesta empresa !!!","STOP")
			Return(.F.)
		EndIf
	Endif

Endif

Return(.T.)
