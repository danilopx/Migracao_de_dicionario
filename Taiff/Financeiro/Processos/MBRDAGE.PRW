#include "protheus.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � MBRDAGE  � Autor � Adilson Gomes       � Data � 27/02/2006 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Rotina para separar a agencia do codigo de barra para o    ���
���          � PAGFOR posicao ( 99 - 104 )                                ���
�������������������������������������������������������������������������Ĵ��
��� Uso	     � Uso Especifico PHB					                      ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function mbrdage()
Local cRetFun	:= "000000"
Local nTamA2AG	:= 6

//���������������������������������������������������Ŀ
//� Verifica se e pagamento com boleto ou DOC/Dep C/C �
//�����������������������������������������������������
If Left(SEA->EA_MODELO,02) $ "01/03/05/41"
	cRetFun := Replicate( "0", nTamA2AG-Len(Trim(SA2->A2_AGENCIA)) )
	cRetFun += Trim(SA2->A2_AGENCIA)
	
	Return cRetFun
endif

//��������������������������������������������Ŀ
//� Verifica se o codigo de barras e digitavel �
//����������������������������������������������
If 1=1
//SE2->E2_TCODBAR == "1"
	if Left(SE2->E2_CODBAR, 03) == "237"
		cRetFun := SubStr(SE2->E2_CODBAR, 20, 04)
		cRetFun += "0"+mbrdM11( cRetFun )
	else
		cRetFun	:= "000000"
	endif
Else
	if Left(SE2->E2_CODBAR, 03) == "237"
		cRetFun := SubStr(SE2->E2_CODBAR, 05, 04)
		cRetFun += mbrdM11( cRetFun )
		cRetFun := "0"+cRetFun
	else
		cRetFun	:= "000000"
	EndIf
EndIf

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