#include "rwmake.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
��� Programa � MT381LOK � Autor � Paulo Bindo           � Data � 28/09/15 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � PE PARA VALIDAR O AJUSTE DE EMPENHO MODELO 2               ���
�������������������������������������������������������������������������Ĵ��
��� Uso      �                                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function MT381LOK()
	
	//Local nOld 		:= n
	Local lD4Ret 	:= .T.
	
	IF ISINCALLSTACK("U_TFCOMBNF")
		
		RETURN(lD4Ret)
		
	ENDIF
	
//PERCORRE O ACOLS E VERIFICA SE JA TEM ALGUM ITEM ENVIADO AO FORNECEDOR
	/*
	For n:=1 To Len(aCols)
		If BuscAcols("D4__QTBNFC")>0 .Or. BuscAcols("D4__QTPCBN")>0 .AND. BUSCACOLS("D4_LOCAL") = '31' 
			lD4Ret := .F.
		EndIf
	Next

	If !lD4Ret
		MsgStop("Esta � uma OP de beneficiamento e j� teve material enviado ao fornecedor ou Pedido de compras colocado, a Exclusao de empenho n�o ser� permitida!","MT381LOK")
	EndIf

	n:=nOld
	*/
Return(lD4Ret)
