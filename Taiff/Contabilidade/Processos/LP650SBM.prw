/*                     
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �LP650SBM �Autor  � ADVISE          � Data �   16/03/2021    ���
�������������������������������������������������������������������������͹��
���Desc.     �Regra para atender a integra��o cont�bil do LP de entrada   ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � TAIFF                                                      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User function LP650SBM()
Local RETORNO := " "
	Do Case

		Case SM0->M0_CODIGO=="03" .AND. ALLTRIM(SB1->B1_COD)=="975070005"
		    RETORNO := "2102010002"
		
		Case substring(Posicione("CTT",1,xFilial("CTT")+SD1->D1_CC,"CTT_XGRPCC"),1,4)$ ("6203")
			RETORNO := Posicione("SBM",1,xFilial("SBM")+SB1->B1_GRUPO,"BM_EST")

		Case substring(Posicione("CTT",1,xFilial("CTT")+SD1->D1_CC,"CTT_XGRPCC"),1,4)$ ("6204")
			RETORNO := Posicione("SBM",1,xFilial("SBM")+SB1->B1_GRUPO,"BM_INVEST")

		otherwise
			RETORNO := Posicione("SBM",1,xFilial("SBM")+SB1->B1_GRUPO,"BM_OUTRAS")

	EndCase        

Return    RETORNO        
