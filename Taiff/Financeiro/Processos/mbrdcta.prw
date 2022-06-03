#include "protheus.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � MBRDCTA  � Autor � Adilson Gomes       � Data � 27/02/2006 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Rotina para separar a C/C do codigo de barra para o PAGFOR ���
���          � no posicao (105 - 119 )                                    ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � GAVM020()                                                  ���
�������������������������������������������������������������������������Ĵ��
��� Uso	     � Uso Especifico PHB				                          ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function mbrdcta()
Local cRetFun	:= "000000000000000"
Local cCtaFor	:= " "
Local nTamA2CC	:= 12//13
Local nLoop		:= 0
Local cNunCont	:= ""
Local nPosSep	:= 0

//���������������������������������������������������Ŀ
//� Verifica se e pagamento com boleto ou DOC/Dep C/C �
//�����������������������������������������������������
If Left(SEA->EA_MODELO,02) $ "01/03/05/41"

	for nLoop := 1 to Len( AllTrim(SA2->A2_NUMCON) )
		if !SubStr(AllTrim(SA2->A2_NUMCON), nLoop, 01) $ "/|-|.|,"
			cNunCont += SubStr(AllTrim(SA2->A2_NUMCON), nLoop, 01)
		else
			nPosSep := nLoop
		endif
	next nLoop
		
	cRetFun := Replicate("0", nTamA2CC-Len( Trim(cNunCont) ))+Trim(cNunCont)
	
	nPosSep := Len( AllTrim(SA2->A2_NUMCON) ) - nPosSep
	
	if nPosSep == 1
		cRetFun := "0"+cRetFun
	else
		cRetFun := "00"+cRetFun
	endif
	
	//Alexandre
	cRetFun := PadR(cRetFun,15)
	
	Return cRetFun
endif

//��������������������������������������������Ŀ
//� Verifica se o codigo de barras e digitavel �
//����������������������������������������������
If SE2->E2_TCODBAR == "1"
	if Left(SE2->E2_CODBAR, 3) == "237"
		cCtaFor := SubStr(SE2->E2_CODBAR, 37, 7)
		cRetFun := StrZero( Val(cCtaFor), 13)+mbrdM11( cCtaFor )
	endif
Else
	if Left(SE2->E2_CODBAR, 3) == "237"
		cCtaFor := StrZero(Val(SubStr(SE2->E2_CODBAR,24,7) ),13)
		cRetFun := StrZero(Val(cCtaFor), 13)+mbrdM11( cCtaFor )
	EndIf
EndIf

cRetFun := PadR(cRetFun,15)

Return cRetFun

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �mbrdctM11 � Autor � Adilson Gomes         � Data � 27/02/06 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Calculo do digito com base em modelo 11                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function mbrdM11(cNumCalc)
Local nSoma		:= 0
Local nResult	:= 0
Local nPeso		:= 2
Local nX		:= 0
Local nDvSoma	:= 0
Local cRetFun	:= " "

//�������������������������������������������Ŀ
//�Tratamento do fator e a soma dos resultados�
//���������������������������������������������
For nX := Len(cNumCalc) to 1 step -1
	nSoma	:= Val( SubStr(cNumCalc,nX,1) ) * nPeso
	nResult	+= nSoma
	nPeso++
	If nPeso > 7
		nPeso := 2
	EndIf
Next nX

//�����������������������������������������������������������Ŀ
//�Divide-se o resultado por 11. O resto da divis�o � o d�gito�
//�������������������������������������������������������������
nDvSoma := MOD(nResult, 11)

nDvSoma := 11 - nDvSoma

nDvSoma := Int(nDvSoma)

//�������������������������������������������������������Ŀ
//�Se o resto for igual a 0 ou 10, o valor assumido ser� 0�
//���������������������������������������������������������
If nDvSoma > 9 .Or. nDvSoma == 0
	cRetFun := "0"
Elseif nDvSoma == 1
	cRetFun := "P"
Else
	cRetFun := AllTrim( Str(nDvSoma) )
EndIf

Return cRetFun