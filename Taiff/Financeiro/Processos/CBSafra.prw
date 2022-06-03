#Include "Protheus.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CBSafra   �Autor  �TOTVS ABM           � Data �17/05/2011   ���
�������������������������������������������������������������������������͹��
���Desc.     �Trata o codigo de barras do titulo a pagar na geracao de    ���
���          �cnab Safra.                                                 ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function CBSafra()

Local aAreaSE2     := SE2->( GetArea() )
Local cRet         := ""
Local cBanco       := Substr(SE2->E2_CODBAR,1,3)
Local cMoeda       := Substr(SE2->E2_CODBAR,4,1)
Local cDac         := Substr(SE2->E2_CODBAR,33,1)
Local dDtRef       := CtoD("07/10/97")
Local cVencto      := Strzero((SE2->E2_VENCTO-dDtRef),4,0)
Local cSaldo       := Strzero((SE2->E2_SALDO*100),10,0)
Local cCampoLivre  := Substr(SE2->E2_CODBAR,5,5) + Substr(SE2->E2_CODBAR,11,10) + Substr(SE2->E2_CODBAR,22,10)
Local cSequenc     := "" 
Local nSoma        := 0 
Local cDac2        := ""
Local nCntFor      := 0

cRet := cBanco+cMoeda+cDac+cVencto+cSaldo+cCampolivre

//������������������������������������������������������������������������Ŀ
//�Calculo do DAC - digito de auto conferencia. Em 25/03/03 o banco Safra  �
//�passou a validar este digito, fazendo com que boletos pre-impressos fos-�
//�sem rejeitados no envio das remessas.                                   �
//�O calculo do DAC na 5a. posicao do codigo de barras sera calculado pelo �
//�modulo 11, multiplicando-se cada algarismo, pela sequencia de 2 a 9, po-�
//�sicionados da direita para a esquerda.                                  �
//�A 5a posicao da esquerda para a direita nao pode ser considerada.       �
//�- Somar o resultado da multiplicacao de cada algarismo do codigo de bar-�
//�ras pela sequencia correspondente.                                      �
//�- Dividir o total da soma por 11.                                       �
//�- Subtrair a sobra de 11. Ex: sobra=4 ---> 11 - 4 = 7 (DAC 7)           �
//��������������������������������������������������������������������������
cSequenc := "4329 876543298765432987654329876543298765432"  // Sequencia de 2 a 9, da direita para a esquerda
//������������������������������������������������������������������������Ŀ
//�- Neste momento, cRet contem o codigo de barras no formato que deve     �
//�ser transmitido, com 44 posicoes. Sera feito o calculo do DAC para ele. �
//��������������������������������������������������������������������������
nSoma := 0
For nCntFor := Len(cSequenc) To 1 Step -1   // De 44 a 1, deve pular a posicao 5
   If ! nCntFor==5 // Pula a posicao 5
      nSoma += ( Val(Substr(cSequenc,nCntFor,1)) * Val(Substr(cRet,nCntFor,1)) )
   EndIf
Next nCntFor
//������������������������������������������������������������������������Ŀ
//�- Se o resto da divisao da Soma por 11 for igual a 0, 1 ou 10, o DAC    �
//�sera considerado sempre como 1.                                         �
//��������������������������������������������������������������������������
If Mod(nSoma,11)==0 .OR. Mod(nSoma,11)==1 .OR. Mod(nSoma,11)==10
   cDac2 := "1"
Else
   cDac2 := Str( (11-Mod(nSoma,11)), 1, 0 )
EndIf

//������������������������������������������������������������������������Ŀ
//�Codigo de barras com o DAC calculado                                    �
//��������������������������������������������������������������������������
cRet := Substr(cRet,1,4)+cDac2+Substr(cRet,6,39)

RestArea( aAreaSE2 )
Return( cRet )