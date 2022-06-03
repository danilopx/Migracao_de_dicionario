#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    |LP670Perda� Autor � Jorge Tavares		    � Data � 27.05.14 ���
�������������������������������������������������������������������������Ĵ��
���Descricao � Retorno de historico do lancamento 670                     ���
���			 � 												              ���
�������������������������������������������������������������������������Ĵ��
��� Uso      �  		                  								  ���
�������������������������������������������������������������������������Ĵ��
���Parametros�                                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
User Function LP670Perda

Local cRet    := ''     //Lancamento Padrao para o armazem de Origem            
Local cOp	  := Posicione("SBC",2,XFILIAL("SBC")+SD3->D3_NUMSEQ,"BC_OP")
Local cNumseq := Posicione("SBC",2,XFILIAL("SBC")+SD3->D3_NUMSEQ,"BC_SEQSD3")
// Lancamento Padrao 670 , 672
IF Empty(cOP) .or. SD3->D3_NUMSEQ <> cNumSeq	//EMPTY(GETADVFVAL("SBC","BC_OP",XFILIAL("SBC")+SD3->D3_NUMSEQ,2))
	cRet := 'TRANSF. ARMZ ORIG. ' + SD3->D3_LOCAL + ' Doc. ' + SD3->D3_DOC
Else 
 	cRet := 'TRANSF. PERDA ARMZ ORIG. ' + SD3->D3_LOCAL + ' OP ' + cOp; //GETADVFVAL("SBC","BC_OP",XFILIAL("SBC")+SD3->D3_NUMSEQ,2);
 		 + ' Doc. ' + SD3->D3_DOC
EndIf
Return cRet
/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    |LP670Val  � Autor � Jorge Tavares		    � Data � 27.05.14 ���
�������������������������������������������������������������������������Ĵ��
���Descricao � Retorno de valor para nao contabilizar transferencias para ���
���			 � para o mesmo armazem. Contabilizar so armazem 93,          ���
���			 �	definido com Karina (Controladoria						  ���
�������������������������������������������������������������������������Ĵ��
��� Uso      �  		                  								  ���
�������������������������������������������������������������������������Ĵ��
���Parametros�                                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
User Function LP670Val

Local nRet 		:= 0     //Lancamento Padrao para o armazem de Origem
Local aAreaSd3 	:= SD3->(GetArea()) 
Local nRecno	:= 0
Local cLocal	:= ' '
// Lancamento Padrao 670 , 672
SD3->(DbSetorder(4))

nRecno	:= SD3->(Recno())
cLocal 	:= SD3->D3_LOCAL

SD3->(DbSkip())
If SUBSTR(SD3->D3_CF,2,2) == "E4"
	//If cLocal <> '32' //Retirado em 28.07.14 pois n�o contabilizaremos esta perda na entrada(SD1)
		IF SD3->D3_LOCAL == '93' .And. cLocal 	<> SD3->D3_LOCAL
			SD3->(DbGoto(nRecno))
			nRet := SD3->D3_CUSTO1 
		Elseif SD3->D3_LOCAL == "12" .And. cLocal == "02"
			SD3->(DbGoto(nRecno))
			nRet := SD3->D3_CUSTO1    
		EndIf  
	//EndIf
EndIf

RestArea(aAreaSd3)
Return nRet
/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    |LP672Perda� Autor � Jorge Tavares		    � Data � 27.05.14 ���
�������������������������������������������������������������������������Ĵ��
���Descricao � Retorno de historico do lancamento 672 					  ���
���			 � 							          						  ���
���			 �	definido com Karina (Controladoria						  ���
�������������������������������������������������������������������������Ĵ��
��� Uso      �  		                  								  ���
�������������������������������������������������������������������������Ĵ��
���Parametros�                                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
User Function LP672Perda

Local cRet := ''//Lancamento Padrao para o armazem de Origem
Local cOp	:=  Posicione("SBC",2,XFILIAL("SBC")+SD3->D3_NUMSEQ,"BC_OP")
Local cNumseq := Posicione("SBC",2,XFILIAL("SBC")+SD3->D3_NUMSEQ,"BC_SEQSD3")
// Lancamento Padrao 670 , 672
IF Empty(cOP) .or. SD3->D3_NUMSEQ <> cNumSeq	//EMPTY(GETADVFVAL("SBC","BC_OP",XFILIAL("SBC")+SD3->D3_NUMSEQ,2))
	cRet := 'TRANSF. ARMZ DEST. ' + SD3->D3_LOCAL + ' Doc. ' + SD3->D3_DOC
Else 
 	cRet := 'TRANSF. PERDA ARMZ DEST. ' + SD3->D3_LOCAL + ' OP ' + cOP;	//GETADVFVAL("SBC","BC_OP",XFILIAL("SBC")+SD3->D3_NUMSEQ,2);
 		 + ' Doc. ' + SD3->D3_DOC
EndIf
Return cRet
/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    |LP672Val  � Autor � Jorge Tavares		    � Data � 27.05.14 ���
�������������������������������������������������������������������������Ĵ��
���Descricao � 															  ���
�������������������������������������������������������������������������Ĵ��
��� Uso      �  		                  								  ���
�������������������������������������������������������������������������Ĵ��
���Parametros�                                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
User Function LP672Val

Local nRet 		:= 0     //Lancamento Padrao para o armazem de Destino - DE4
Local aAreaSd3 	:= SD3->(GetArea()) 
Local nRecno	:= 0
Local cLocal	:= ' '
// Lancamento Padrao 670 , 672
SD3->(DbSetorder(4))

nRecno	:= SD3->(Recno())

SD3->(DbSkip(-1))
cLocal 	:= SD3->D3_LOCAL

SD3->(DbGoto(nRecno))
If SUBSTR(SD3->D3_CF,2,2) == "E4"
	IF SD3->D3_LOCAL == '93'.And. cLocal <> SD3->D3_LOCAL
		nRet := SD3->D3_CUSTO1     
    ElseIf SD3->D3_LOCAL == "12".And. cLocal == '02'
		nRet := SD3->D3_CUSTO1 
	EndIf  
EndIf

RestArea(aAreaSd3)
Return nRet
/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    |LP670C    � Autor � Jorge Tavares		    � Data � 27.05.14 ���
�������������������������������������������������������������������������Ĵ��
���Descricao � 															  ���
�������������������������������������������������������������������������Ĵ��
��� Uso      �  		                  								  ���
�������������������������������������������������������������������������Ĵ��
���Parametros�                                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
User Function LP670C

Local cRet := ''     //Lancamento Padrao para o armazem de Destino - RE4
Local cOp	:=  Posicione("SBC",2,XFILIAL("SBC")+SD3->D3_NUMSEQ,"BC_OP")
Local cNumseq := Posicione("SBC",2,XFILIAL("SBC")+SD3->D3_NUMSEQ,"BC_SEQSD3")
// Lancamento Padrao 670 , 672
IF !Empty(cOP) .and. SD3->D3_NUMSEQ == cNumSeq	//EMPTY(GETADVFVAL("SBC","BC_OP",XFILIAL("SBC")+SD3->D3_NUMSEQ,2))
	cRet := '1104010005'
ElseIf SD3->D3_LOCAL $ '11'
	cRet := '1104010005'	
ElseIf SD3->D3_LOCAL $ '02/40/51/32'
	cRet := '1104010001'
ElseIf SD3->D3_LOCAL $ '21/96'
	cRet := '1104010004'
Else
	cRet := '1104010003'
EndIf

Return cRet   
/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    |LP672D    � Autor � Jorge Tavares		    � Data � 27.05.14 ���
�������������������������������������������������������������������������Ĵ��
���Descricao � 															  ���
�������������������������������������������������������������������������Ĵ��
��� Uso      �  		                  								  ���
�������������������������������������������������������������������������Ĵ��
���Parametros�                                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
User Function LP672D

Local cRet := ''     //Lancamento Padrao para o armazem de Destino - DE4
Local cOp	:=  Posicione("SBC",2,XFILIAL("SBC")+SD3->D3_NUMSEQ,"BC_OP")
Local cNumseq := Posicione("SBC",2,XFILIAL("SBC")+SD3->D3_NUMSEQ,"BC_SEQSD3")
// Lancamento Padrao 670 , 672
IF !Empty(cOP) .and. SD3->D3_NUMSEQ == cNumSeq	.AND. SD3->D3_CF == 'DE4' //EMPTY(GETADVFVAL("SBC","BC_OP",XFILIAL("SBC")+SD3->D3_NUMSEQ,2))
	cRet := '1104010007'
ElseIf SD3->D3_LOCAL $ '93' .AND. SD3->D3_CF == 'DE4'
	cRet := '1104010007'	
ElseIf SD3->D3_LOCAL $ '11'.AND. SD3->D3_CF == 'DE4'
	cRet := '1104010005'	
ElseIf SD3->D3_LOCAL $ '02/40/51/32'.AND. SD3->D3_CF == 'DE4'
	cRet := '1104010001'
ElseIf SD3->D3_LOCAL $ '21/96'.AND. SD3->D3_CF == 'DE4'
	cRet := '1104010004'
Else
	cRet := '1104010003'
EndIf

Return cRet   	