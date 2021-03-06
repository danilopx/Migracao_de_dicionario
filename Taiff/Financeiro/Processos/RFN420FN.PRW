#INCLUDE "RWMAKE.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � RFN420FN �Autor  � Marcelo Cardoso    � Data � 24/10/2013  ���
�������������������������������������������������������������������������͹��
���Desc.     � Conjunto de Funcoes utilizadas no Cnab Bradesco a Pagar    ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico Taiff-ProArt                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � RFN420AG �Autor  � Marcelo Cardoso    � Data � 24/10/2013  ���
�������������������������������������������������������������������������͹��
���Desc.     � Funcao retornar a Agencia a ser utilizada no Cnab Bradesco ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico Taiff-ProArt                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function RFN420AG()

	Local _cAgenc := "000000"
	//Local _cDigit := ""
	Local _cBanco := SubStr(SE2->E2_CODBAR,1,3)

	If _cBanco == "237"	// BRADESCO

		_cAgenc  :=  "0" + SubStr(SE2->E2_CODBAR, 20, 04)

		_cAgenc += Modulo11(_cAgenc)

	Else

		If SEA->EA_MODELO $ "01/03/05/41/43"

			_cAgenc := StrTran(SA2->A2_AGENCIA, "-", "") //_cAgenc := StrZero(Val(SA2->A2_AGENCIA), 05) + Modulo11(SA2->A2_AGENCIA)
			_cAgenc := StrZero(Val(_cAgenc), 05)

		EndIf

	EndIf

Return(_cAgenc)


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � RFN420BN �Autor  � Marcelo Cardoso    � Data � 24/10/2013  ���
�������������������������������������������������������������������������͹��
���Desc.     � Funcao retornar o Banco a ser utilizado no Cnab Bradesco   ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico Taiff-ProArt                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function RFN420BN()

	Local _cBanco := ""

	If SubStr(SE2->E2_CODBAR, 01, 03) == "   "

		_cBanco := SUBSTR(SA2->A2_BANCO, 01, 03)

	Else
		_cBanco := SUBSTR(SE2->E2_CODBAR, 01, 03)

	Endif

Return(_cBanco)


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � RFN420CN �Autor  � Marcelo Cardoso    � Data � 24/10/2013  ���
�������������������������������������������������������������������������͹��
���Desc.     � Funcao retornar a Conta a ser utilizada no Cnab Bradesco   ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico Taiff-ProArt                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function RFN420CN()

	Local _cConta := "000000000000000"
	Local _cBanco := SubStr(SE2->E2_CODBAR,1,3)

	If _cBanco == "237"	// Bradesco

		_cConta :=  StrZero(Val(SubStr(SE2->E2_CODBAR, 37, 07)), 13, 0)

		_cConta += Modulo11(_cConta)

	Else

		_nPosDV := AT("-", SA2->A2_NUMCON)

		If _nPosDV == 0

			_cConta := Replicate("0", 15 - Len(AllTrim(SA2->A2_NUMCON))) + AllTrim(SA2->A2_NUMCON)

			MsgAlert("Digito da conta corrente " + AllTrim(SA2->A2_NUMCON) + " nao informado! Verifique o cadastro do fornecedor " + AllTrim(SA2->A2_NREDUZ) + ".", "Atencao!")

		Else

			_cConta := SubStr(SA2->A2_NUMCON, 1, _nPosDV - 1)

			_cConta := Replicate("0", 13 - LEN(_cConta) ) + _cConta

			_cConta := _cConta + SubStr(SA2->A2_NUMCON, _nPosDV + 1, 2)

			IIF(Empty(SubStr(SA2->A2_NUMCON, _nPosDV + 1, 2)), MsgAlert("Digito da conta corrente " + AllTrim(SA2->A2_NUMCON) + " nao informado! Verifique o cadastro do fornecedor " + AllTrim(SA2->A2_NREDUZ) + ".", "Atencao!"), "")

		EndIf

	EndIf

Return(_cConta)


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � RFN420CT �Autor  � Marcelo Cardoso    � Data � 24/10/2013  ���
�������������������������������������������������������������������������͹��
���Desc.     � Funcao retornar a Carteira a ser utilizada no Cnab         ���
���          � Bradesco                                                   ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico Taiff-ProArt                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function RFN420CT()

	Local _cCart  := ""

	IF SubStr(SE2->E2_CODBAR, 01, 03) <> "237"

		_cCart := "000"

	Else

		_cCart := "0" + SubStr(SE2->E2_CODBAR, 24, 02)

	EndIf

Return(_cCart)


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � RFN420DC �Autor  � Marcelo Cardoso    � Data � 24/10/2013  ���
�������������������������������������������������������������������������͹��
���Desc.     � Funcao retornar o Documento a ser utilizada no Cnab        ���
���          � Bradesco                                                   ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico Taiff-ProArt                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function RFN420DC()

	Local _cDoc := ""
	Local _cMod := ""

	_cMod := SubStr(SEA->EA_MODELO,1,2)

	If _cMod == "  "

		If SubStr(SE2->E2_CODBAR,1,3) == "237"

			_cMod := "30"

		Else

			_cMod := "31"

		EndIf

	EndIf

	Do Case

	Case _cMod == "03"

		_cDoc := Iif(SubStr(SA2->A2_CGC, 01, 08)==SubStr(SM0->M0_CGC, 01, 08) ,"D","C") + "000000" + "01" + "01" + Space(29)

	Case _cMod == "07" .or. _cMod == "08" .or. _cMod == "41" .or. _cMod == "43"

		_cDoc := Iif(SubStr(SA2->A2_CGC, 01, 08)==SubStr(SM0->M0_CGC, 01, 08) ,"D","C") + "000000" + "01" + "01" + Space(29)

	Case _cMod == "30"  .or. _cMod == "31"

		_cDoc := SubStr(SE2->E2_CODBAR, 20, 25)+SubStr(SE2->E2_CODBAR, 05, 01)+SubStr(SE2->E2_CODBAR, 04, 01) + Space(13)

	OtherWise

		_cDoc := Space(40)

	EndCase

Return(_cDoc)


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � RFN420EN �Autor  � Marcelo Cardoso    � Data � 24/10/2013  ���
�������������������������������������������������������������������������͹��
���Desc.     � Funcao retornar o endereco conforme os campos existentes   ���
���          � para o Cnab Bradesco a Pagar                               ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico Taiff-ProArt                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function RFN420EN()

	Local _lA2Logr  := AllTrim(GetSx3Cache("A2_LOGR",    "X3_CAMPO")) == "A2_LOGR"
	Local _lA2NrEnd := AllTrim(GetSx3Cache("A2_NR_END",  "X3_CAMPO")) == "A2_NR_END"
	Local _lA2Compl := AllTrim(GetSx3Cache("A2_COMPLEM", "X3_CAMPO")) == "A2_COMPLEM"
	Local _cEnd     := ""

	If _lA2Logr

		_cEnd += AllTrim(Upper(SA2->A2_LOGR))   + " "

	EndIf

	_cEnd += AllTrim(Upper(SA2->A2_END))        + " "

	If _lA2NrEnd

		_cEnd += AllTrim(Upper(SA2->A2_NR_END)) + " "

	EndIf

	If _lA2Compl

		If AllTrim(Upper(SA2->A2_COMPLEM)) <> AllTrim(Upper(SA2->A2_BAIRRO))

			_cEnd += AllTrim(Upper(SA2->A2_COMPLEM)) +  " "

		EndIf

	EndIf

	_cEnd += AllTrim(Upper(SA2->A2_BAIRRO)) + " "
	_cEnd += AllTrim(Upper(SA2->A2_MUN))    + " "
	_cEnd += AllTrim(Upper(SA2->A2_EST))

Return(SubStr(_cEnd, 1, 40))


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � RFN420ID �Autor  � Marcelo Cardoso    � Data � 24/10/2013  ���
�������������������������������������������������������������������������͹��
���Desc.     � Funcao para retornar o ID do Cnab a Pagar Bradesco         ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico Taiff-ProArt                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function RFN420ID()

	Local _cCNPJ := ""

	If SA2->A2_TIPO <> "J"

		_cCNPJ := Left(SA2->A2_CGC, 9) + "0000" + SubStr(SA2->A2_CGC, 10, 2)

	Else

		_cCNPJ := "0" + Left(SA2->A2_CGC, 8) + SubStr(SA2->A2_CGC, 9, 4) + Right(SA2->A2_CGC, 2)

	Endif

Return(_cCNPJ)


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � RFN420MD �Autor  � Marcelo Cardoso    � Data � 24/10/2013  ���
�������������������������������������������������������������������������͹��
���Desc.     � Funcao retornar a Modalidade a ser utilizada no Cnab       ���
���          � Bradesco                                                   ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico Taiff-ProArt                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/ 

User Function RFN420MD()

	Local _cModal  := ""
	Local _aX5Brad := {}

	AAdd(_aX5Brad, {"01", "01"} )
	AAdd(_aX5Brad, {"02", "02"} )
	AAdd(_aX5Brad, {"03", "03"} )
	AAdd(_aX5Brad, {"05", "01"} )
	AAdd(_aX5Brad, {"30", "31"} )
	AAdd(_aX5Brad, {"31", "31"} )
	AAdd(_aX5Brad, {"41", "08"} )
	AAdd(_aX5Brad, {"43", "08"} )

	_nPos   := AScan(_aX5Brad, {|x| x[1] == SEA->EA_MODELO })
	_cModal := IIf(_nPos <> 0, _aX5Brad[_nPos][2], "  ")

Return(_cModal)


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � RFN420NN �Autor  � Marcelo Cardoso    � Data � 24/10/2013  ���
�������������������������������������������������������������������������͹��
���Desc.     � Funcao retornar o Nosso Numero a ser utilizada no Cnab     ���
���          � Bradesco                                                   ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico Taiff-ProArt                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function RFN420NN()

	Local _cNosNum := ""

	If SubStr(SE2->E2_CODBAR, 01, 03) <> "237"

		_cNosNum := "000000000000"

	Else

		_cNosNum := "0" + SubStr(SE2->E2_CODBAR, 26, 11)

	EndIf

Return(_cNosNum)


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � RFN420SQ �Autor  � Marcelo Cardoso    � Data � 24/10/2013  ���
�������������������������������������������������������������������������͹��
���Desc.     � Funcao para retornar o sequencial do Cnabs a pagar         ���
���          � Bradesco                                                   ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico Taiff-ProArt                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function RFN420SQ()

	_cOldAlias := Alias()
	_aOldAlias := GetArea()

	DBSelectArea("SEE")
	_cRetorno  := SEE->EE_FAXATU

	RecLock("SEE", .F.)

	SEE->EE_FAXATU := StrZero(Val(_cRetorno) + 1, 5)

	MSUnLock()

	DBSelectArea(_cOldAlias)
	RestArea(_aOldAlias)

Return _cRetorno


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � RFN420TP �Autor  � Marcelo Cardoso    � Data � 24/10/2013  ���
�������������������������������������������������������������������������͹��
���Desc.     � Funcao retornar o Tipo de Conta a ser utilizada no Cnab    ���
���          � Bradesco                                                   ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico Taiff-ProArt                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function RFN420TP()

	Local _cTipoCC := "0"

	If SEA->EA_MODELO == "01"

		_cTipoCC := "1"

	ElseIF SEA->EA_MODELO == "05"

		_cTipoCC := "2"

	Endif

Return(_cTipoCC)


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � RFN420VL �Autor  � Marcelo Cardoso    � Data � 24/10/2013  ���
�������������������������������������������������������������������������͹��
���Desc.     � Funcao retornar o Valor a ser utilizada no Cnab Bradesco   ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico Taiff-ProArt                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function RFN420VL()

	Local _cValor := Replicate("0", 15)

	IF SubStr(SE2->E2_CODBAR, 01, 03) == "   "

		_cValor :=  StrZero((SE2->E2_SALDO * 100), 15, 0)

	Else

		_cValor :=  "00000" + SubStr(SE2->E2_CODBAR, 38, 10)

	Endif

Return(_cValor)
