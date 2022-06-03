#INCLUDE 'Protheus.ch'
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �FATMI005  �Autor  �Daniel Ruffino      � Data �  17/10/12   ���
�������������������������������������������������������������������������͹��
���Desc.     � Realiza a grava��o dos Logs na tabela SZC.				  ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function FATMI005(_cAlias, _cChave, _dDtIni, _cHrIni, _cDtFim, _cHrFim, _cCodUser, _cEstacao, _cOperac,_cFuncao)
Local _aArea := GetArea()

DbSelectArea("SZC")

RecLock("SZC",.T.)
	SZC->ZC_FILIAL	:= xFilial("SZC")
	SZC->ZC_ALIAS	:= _cAlias
	SZC->ZC_CHAVE	:= _cChave
	SZC->ZC_DTINI	:= _dDtIni
	SZC->ZC_HRINI	:= _cHrIni
	SZC->ZC_DTFIM	:= _cDtFim
	SZC->ZC_HRFIM	:= _cHrFim
	SZC->ZC_CODUSER	:= _cCodUser
	SZC->ZC_ESTACAO	:= _cEstacao
	SZC->ZC_OPERAC	:= _cOperac 
	SZC->ZC_FUNC	:= _cFuncao
SZC->(MsUnLock())

RestArea(_aArea)
Return