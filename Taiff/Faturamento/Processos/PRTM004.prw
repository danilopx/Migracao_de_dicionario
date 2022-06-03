#include "protheus.ch"
#include "topconn.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �PRTM0004  �Autor  �FSW Veti            � Data �     08/11   ���
�������������������������������������������������������������������������͹��
���Desc.     �Rotina de Cancelamento de Calculo de Embalagens             ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �PROART                                                      ���
�������������������������������������������������������������������������͹��
���Alteracoes�20130320-Arlete-Processa exclus�o somente se usu�rio for    ���
���          �                autorizado         				           ���
���          �                                       			           ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function PRTM004(cPedido)

	Local cAliasBKP	:= Alias()
	Local aOrdBKP	:= SaveOrd({cAliasBKP,"ZZF","ZZG"})
	Local lApagou	:= .F.
	Local aUsu		:= PswRet()
	Local cUsu		:= aUsu[1][1]
	Local cDHCalc	:= ''
	Local cAliasTRB	:= GetNextAlias()
	Local aArea1 	:= GetArea()
	Local _nRec		:= 0
	Default cPedido	:= SC5->C5_NUM

	Begin Transaction

//������������������������������������������
//�Exclui os Itens do Calculo de Embalagens�
//������������������������������������������

		ZZG->(DbSetOrder(1))
		ZZG->(DbSeek(xFilial("ZZG") + cPedido))

		While ZZG->(!Eof()) .and. ZZG->ZZG_FILIAL == xFilial("ZZG") .and. ZZG->ZZG_PEDIDO == cPedido
			
			/*
			|=================================================================================
			|   COMENTARIO
			|---------------------------------------------------------------------------------
			|	Tratamento dos Registros que nao gravaram o RECNO do SC9.
			|	Edson Hornberger - 11/04/2014
			|=================================================================================
			*/
			
			If ZZG->ZZG_SC9 = 0
			
				cDHCalc := ZZG->ZZG_DHCALC // guarda data e hora da liberacao para deletar registros da ZZF
				If RecLock("ZZG",.F.)
					ZZG->(DbDelete())
					ZZG->(MsUnLock())
				Endif
				
				lApagou := .T.
				
			Else
			
//Exclui calculo e dados de separacao somente dos itens nao faturados
				SC9->( dbGoTo( ZZG->ZZG_SC9 ) )
				If ALLTRIM(SC9->C9_NFISCAL) = ''
					cDHCalc := ZZG->ZZG_DHCALC // guarda data e hora da liberacao para deletar registros da ZZF
					If RecLock("ZZG",.F.)
						ZZG->(DbDelete())
						ZZG->(MsUnLock())
					Endif
					If RecLock("SC9",.F.)
						SC9->C9_ORDSEP := ''
						SC9->(MsUnLock())
					Endif
					lApagou := .T.
				Endif
			EndIf
			
			ZZG->(DbSkip())
			
		EndDo
		
	End Transaction

	RestArea(aArea1)

	If lApagou
//���������������������������������������������
//�Exclui o Cabecalho do Calculo de Embalagens�
//���������������������������������������������

		cQuery := "UPDATE "+RetSqlName("ZZF")+" SET D_E_L_E_T_ = '*' "
		cQuery += " FROM "+RetSqlName("ZZF")+" "
		cQuery += " WHERE ZZF_DHCALC = '" + cDHCalc + "' "
		cQuery += " AND ZZF_PEDIDO = '"+ cPedido +"' "
		
		//MemoWrite("PRTM004-deletar.sql",cQuery)
		TCSQLExec(cQuery)

	//VERIFICA SE EXISTE SEPARA��ES ANTERIORES COM CONFERENCIA
		cQuery := " SELECT ZZG_PEDIDO FROM "+RetSqlName("ZZG")+","+RetSQLName("SC9")+" "
		cQuery += " WHERE ZZG_PEDIDO = '" + cPedido + "' "
		cQuery += " AND C9_PEDIDO = '" + cPedido + "' "
		cQuery += " AND "+RetSQLName("SC9")+".R_E_C_N_O_ = ZZG_SC9 "
		cQuery += " AND "+RetSqlName("ZZG")+".D_E_L_E_T_ <> '*' "
		cQuery += " AND "+RetSQLName("SC9")+".D_E_L_E_T_ <> '*' "

		cQuery := ChangeQuery( cQuery )
		//MemoWrite("PRTM0004-buscaconferencias.sql",cQuery)
		dbUseArea(.T.,"TOPCONN", TCGenQry(,,cQuery),(cAliasTRB := GetNextAlias()), .F., .T.)

		COUNT TO _nRec
		(cAliasTRB)->(dbGoTop())
		(cAliasTRB)->(DbCloseArea())

		If RecLock("SC5",.F.)
					//CASO HOUVER SEPARACOES ANTERIORES COM CONFERENCIA, ATUALIZA O CAMPO C5_YSTSEP
			If _nRec > 0
				SC5->C5_YSTSEP := 'G'
			Else
				SC5->C5_YSTSEP := ''
			EndIf
			SC5->(MsUnLock())
		Endif


//���������������������������������������Ŀ
//�Realiza a Gravacao do Log de Pre-Pedido�
//�����������������������������������������
		U_M003LOG(,SC5->C5_NUM,"Exclusao de Calculo de Embalagens realizada com sucesso! Origem exclusao: "+FunName()+" Usu�rio "+cUsu)
	EndIf

//���������������������������������������������������������������������������
//�Restaura a Ordem Original dos arquivos, mantendo a integridade do sistema�
//���������������������������������������������������������������������������
	RestOrd(aOrdBKP)
	DbSelectArea(cAliasBKP)

Return .T.
