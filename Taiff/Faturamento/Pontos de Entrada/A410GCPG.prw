/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �A410GCPG  �Autor  �FSW                 � Data �  04/17/12   ���
�������������������������������������������������������������������������͹��
���Desc.     �Programa de Valida��o, colocado para atualiza��o do campo   ���
���          �preco de lista, a partir da cond pagto                      ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

/*
Implementada a variavel "l410auto" j� que impacta na rotina de cria��o de pedidos 
na devolu��o de pedidos do CD para EXTREMA no projeto AVANTE unidade de negocio fase II
Giba
*/

User Function A410GCPG()

Local nPosVen := 0
Local nPosLis := 0
Local nPosVal := 0
Local nPosQtd := 0
Local _nx	  := 0  

If .NOT. l410auto .AND. cEmpAnt == "03" .and. !IsInCallStack("U_PRTM0001") .and. !IsInCallStack("U_PRTM0002") .AND. M->C5_CLASPED != "A" 

	nPosVen := GdFieldPos("C6_PRCVEN")
	nPosLis := GdFieldPos("C6_PRUNIT")
	nPosVal	:= GdFieldPos("C6_VALOR")
	nPosQtd	:= GdFieldPos("C6_QTDVEN")

	For _nx	:= 1 to Len(aCols)     
		aCols[_nx][nPosVen] := aCols[_nx][nPosVal] / aCols[_nx][nPosQtd]	
		aCols[_nx][nPosLis] := aCols[_nx][nPosVen]      
	Next                  
	
	oGetDad:oBrowse:Refresh()
	Ma410Rodap()
EndIf                       

RETURN(&(ReadVar()))