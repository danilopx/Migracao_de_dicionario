#INCLUDE 'PROTHEUS.CH'
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���PROGRAMA  �MFis0001    �Autor  �V.RASPA              �Data  � 21.Jan.11���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Consulta padrao especifica (SA1SA2) amarrada ao campo       ���
���          �F3_CLIEFOR                                                  ���
�������������������������������������������������������������������������Ĵ��
��� Uso      �Especifico: TAIFF                                           ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function MFis0001()
Local xRet := NIL

If INCLUI
	If !Empty(M->F3_CFO)
		If M->F3_CFO < '500'
			If !(M->F3_TIPO $ "B|D")
				xRet := ConPad1(,,,"FOR")
			Else
				xRet := ConPad1(,,,"SA1")
			EndIf
		Else
			If !(M->F3_TIPO $ "B|D")
				xRet := ConPad1(,,,"SA1")
			Else
				xRet := ConPad1(,,,"FOR")
			EndIf
    	EndIf
	Else
		xRet := .F.
		Aviso('Aten��o', 'Informe o CFOP deste documento', {'OK'})
	EndIf   
Else
	If !Empty(SF3->F3_CFO) 
		If SF3->F3_CFO < '500'
			If !(SF3->F3_TIPO $ "B|D")
				xRet := ConPad1(,,,"FOR")
			Else
				xRet := ConPad1(,,,"SA1")
			EndIf
		ElseIf SF3->F3_CFO >= '500'
			If !(SF3->F3_TIPO $ "B|D")
				xRet := ConPad1(,,,"SA1")
			Else
				xRet := ConPad1(,,,"FOR")
			EndIf
		EndIf
	EndIf
EndIf

Return(xRet)