/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �M711SC2   �Autor  �Marcos J.           � Data �  11/26/10   ���
�������������������������������������������������������������������������͹��
���Desc.     � PE utilizado para gravar informa��o de op produzida interna���
���          �ou externamente.                                            ���
�������������������������������������������������������������������������͹��
���������������������������������������������������������������������������*/
#include "PROTHEUS.CH"
User Function M711SC2()
	Local aDados := aClone(ParamIxb)
	Local cAlias := Alias()
	Local aArea  := GetArea()
	
	//aAdd(aDados, {"C2_OPINTER", SHC->HC_OPINTER, Nil})           
	If(AllTrim(SHC->HC_OPINTER) = "")
		aAdd(aDados, {"C2_OPINTER", "S", Nil})
	Else
		aAdd(aDados, {"C2_OPINTER", SHC->HC_OPINTER, Nil})
	EndIf
	

	RestArea(aArea)	
	DbSelectArea(cAlias)
	Return(aDados)