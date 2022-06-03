#INCLUDE "TOTVS.CH"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � GP180MSG  � Autor �Ricardo Duarte Costa� Data�  15/03/2013 ���
�������������������������������������������������������������������������͹��
���Descricao � PE na Transferencia para buscar numero sequencial para     ���
���          � matricula quando transf. entre empresas, de acordo com     ���
���          � mnemonicos M_MATRFUNC e M_MATRAUTO do RCA destino          ���
�������������������������������������������������������������������������͹��
���Uso       � Grupo Taiff                                                ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function GP180MSG

Local _aArea		:= GetArea()
Local cModo_
Local aCols_TRF_	:= oGetSRA2:ACOLS	//-- 2o acols da tela com as informa��es de destino da transfer�ncia.
Local aCols_ORG_	:= oGetSRA1:ACOLS	//-- 1o acols da tela com as informa��es de origem da transfer�ncia.
Local nPosEmp_		:= GdFieldPos("M_EMPRESA", oGetSRA2:aHeader ) 
Local nPosFil_		:= GdFieldPos("RA_FILIAL", oGetSRA2:aHeader ) 
Local nPosCC_		:= GdFieldPos("RA_CC", oGetSRA2:aHeader )
Local nPosEmpORG_	:= GdFieldPos("M_EMPRESA", oGetSRA1:aHeader ) 
Local nPosFilORG_	:= GdFieldPos("RA_FILIAL", oGetSRA1:aHeader ) 
Local nPosCCORG_	:= GdFieldPos("RA_CC", oGetSRA1:aHeader )
Local nPosMat_		:= GdFieldPos("RA_MAT", oGetSRA2:aHeader )
Local nPosDelet_	:= len(oGetSRA2:aHeader)+1
Local _cEmpAte		:= ""
Local _cFilAte		:= ""
Local _cCcuAte		:= ""
Local _cEmpORG		:= ""
Local _cFilORG		:= ""
Local _cCcuORG		:= ""
Local nx			:= 0

For nx := 1 to len(aCols_TRF_)
	If !aCols_TRF_[nx,nPosDelet_]
		_cEmpAte		:= aCols_TRF_[nx,nPosEmp_]
		_cFilAte		:= aCols_TRF_[nx,nPosFil_]
		_cCcuAte		:= aCols_TRF_[nx,nPosCC_]
		_cEmpORG		:= aCols_ORG_[nx,nPosEmpORG_]
		_cFilORG		:= aCols_ORG_[nx,nPosFilORG_]
		_cCcuORG		:= aCols_ORG_[nx,nPosCCORG_]
		If .NOT. U_TFCCUSTO(_cEmpAte,_cFilAte,_cCcuAte)
			Return(.f.)
		EndIf

		//Somente se empresa destino diferente da origem
		If _cEmpAte <> _cEmpORG .Or. _cFilAte <> _cFilORG
			_cTabela := "GPERCA"
			If SRA->RA_CATFUNC == "A"
				cMnem_  := "P_MATRAU"+_cFilAte
				cFaixa_ := "999999" //limita a faixa
			Else
				cMnem_  := "P_MATRFU"+cFilAte
				cFaixa_ := "899999" //limita a faixa
			EndIF
			//�������������������������������Ŀ
			//�Abrir tabela RCA destino       �
			//���������������������������������
			IF (lRet := MyEmpOpen(_cTabela,"RCA",1,.t.,if(_cEmpAte <> _cEmpORG,_cEmpAte,_cEmpORG),@cModo_))
				If (_cTabela)->(DbSeek("  "+cMnem_))
					Reclock(_cTabela, .F.)
					cUltima_ := Soma1(ALLTRIM((_cTabela)->RCA_CONTEU))
					If cUltima_ > cFaixa_
						MsgAlert("Aten��o: a sequencia de matricula excedeu a faixa permitida para esta categoria")
						Return(.f.)
					EndIf
					aCols_TRF_[nx,nPosMat_] := cUltima_
					cMatAte					:= cUltima_
					MsgAlert("Aten��o: a matricula destino ser� "+cUltima_)
					(_cTabela)->RCA_CONTEU := cUltima_
					(_cTabela)->(MSUnlock())
				Else
					MsgAlert( OemToAnsi( "Erro ao ler a proxima sequencia de matricula na empresa destino. Ajuste o mnem�nico: "+cMnem_ )  )
					Return(.f.)
				EndIf
			Else
				MsgAlert( OemToAnsi( "Erro ao abrir a Tabela de Mnemonicos da empresa destino" )  )
				Return(.f.)
			EndIF
		EndIf
	Endif
Next nx

RestArea(_aArea)

Return(.t.)               

/*
���������������������������������������������������������������������������Ŀ
�Fun��o    �MyEmpOpenFile � Autor �Wilson de Godoy        � Data �03/01/2001�
���������������������������������������������������������������������������Ĵ
�Descri��o �Abre Arquivo de Outra Empresa                         			�
���������������������������������������������������������������������������Ĵ
�Parametros�x1 - Alias com o Qual o Arquivo Sera Aberto                  	�
�          �x2 - Alias do Arquivo Para Pesquisa e Comparacao                �
�          �x3 - Ordem do Arquivo a Ser Aberto                              �
�          �x4 - .T. Abre e .F. Fecha                                       �
�          �x5 - Empresa                                                    �
�          �x6 - Modo de Acesso (Passar por Referencia)                     �
�����������������������������������������������������������������������������*/
Static Function MyEmpOpen(x1,x2,x3,x4,x5,x6)
Local cSavE := cEmpAnt, cSavF := cFilAnt, xRet
if type("__cSvEmpAnt")<>"U"
	cEmpAnt := __cSvEmpAnt
	cFilAnt := __cSvFilAnt
EndIf
xRet	:= EmpOpenFile(@x1,@x2,@x3,@x4,@x5,@x6)
cEmpAnt := cSavE
cFilAnt := cSavF
Return( xRet )
