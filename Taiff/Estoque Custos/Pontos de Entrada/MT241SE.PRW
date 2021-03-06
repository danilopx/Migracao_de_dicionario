#INCLUDE "RWMAKE.CH"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � MT241SE  �Autor  �Edson Estevam       � Data �  17/09/11   ��
�������������������������������������������������������������������������͹��
���Desc.     � Na Emiss�o do Movimento Interno para o WMS gravar no Acols  ��
���D3_SERVIC o conteudo do parametro MV_XSERWMS e se a empresa for a       ��
��� Daihatsu seleciona os itens trazendo deletados os produtos que n�o     ��
���	ser�o separados conforme regra definida pelo cliente.        		   ��
�������������������������������������������������������������������������͹��
���Uso       � TAIFF                                                       ��
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/


User Function MT241SE()

	Local _aArea 	  := GetArea()
	Local _aAreaC2    := SC2->(GetArea())
	Local _aAreaB1    := SB1->(GetArea())
	Local _nPosProd   := aScan(aHeader,{|x| AllTrim(x[2]) == "D3_COD"} )
	Local _nPosLocal  := aScan(aHeader,{|x| Alltrim(x[2]) == "D3_LOCAL"})
	Local _nPosServi  := aScan(aHeader,{|x| Alltrim(x[2]) == "D3_SERVIC"})
	Local _nPosOp     := aScan(aHeader,{|x| Alltrim(x[2]) == "D3_OP"})
	Local _nPosEnd    := aScan(aHeader,{|x| Alltrim(x[2]) == "D3_LOCALIZ"})
	Local _cSerparam  := Getmv("MV_XSERWMS")
	Local _cTmovi     := Getmv("MV_XTPMOV")
	Local _cNumOP     := Substr(COPEST,1,6)
	Local _cNumItem   := Substr(COPEST,7,2)
	Local _cNumSeque  := Substr(COPEST,9,3)
	Local lRet        := .T.
	Local _nElem	  := 0

	If Alltrim(CTM) == Alltrim(_cTmovi)
		If Alltrim(cEmpAnt) == "01" // Se for a Daihatsu
			DbSelectArea("SC2")
			Dbsetorder (1)
			SC2->(DbSeek(xFilial("SC2")+_cNumOP+_cNumItem+_cNumSeque))
			If SC2->C2_OPINTER == "S" // Verifica o Status da Ordem de Produ��o se interna ou n�o

				For _nElem := 1 to Len(acols)

					DbSelectArea("SB1")
					Dbsetorder (1)
					SB1->(DbSeek(xFilial("SB1")+aCols[_nElem][_nPosProd]))

					If ALLTRIM(SB1->B1_TIPO) $ "RT/MO/MA"  // Verifica o tipo do produto
						aCols[_nElem][_nPosprod] := Space(15)
						aCols[_nElem][len(aHeader)+1] := .T.  //Traz os itens deletados caso seja verificada a linha acima
						aCols[_nElem][_nPosLocal] := "02"
					Else
						aCols[_nElem][_nPosServi] := Alltrim(_cSerparam)
						aCols[_nElem][_nPosOp]    := " "
						aCols[_nElem][_nPosEnd]   := " "
						aCols[_nElem][_nPosLocal] := "02"
					Endif
				Next _nElem

			Endif

			IF SC2->C2_OPINTER <> "S"  // Se for OP interna for  diferente de SIM

				For _nElem := 1 to Len(acols)
					DbSelectArea("SB1")
					Dbsetorder (1)
					SB1->(DbSeek(xFilial("SB1")+aCols[_nElem][_nPosProd]))

					If ALLTRIM(SB1->B1_TIPO) $ "MO/MA/" //Verifica somente estes tipo
						aCols[_nElem][_nPosprod] := Space(15)
						aCols[_nElem][len(aHeader)+1] := .T.  // Caso seja , traz deletados.
						aCols[_nElem][_nPosLocal] := "02"
					Else
						aCols[_nElem][_nPosServi] := Alltrim(_cSerparam)
						aCols[_nElem][_nPosOp]    := " "
						aCols[_nElem][_nPosEnd]   := " "
						aCols[_nElem][_nPosLocal] := "02"
					Endif

				Next _nElem
			Endif


		Endif

		If Alltrim(CTM) == Alltrim(_cTmovi)
			If Alltrim(cEmpAnt) == "03"     // Se for empresa PROART traz todos os itens


				For _nElem := 1 to Len(acols)
					aCols[_nElem][_nPosServi] := Alltrim(_cSerparam)

				Next _nElem
			Endif
		Endif

	Endif

	RestArea(_aAreaB1)
	RestArea(_aAreaC2)
	RestArea(_aArea)


Return(lRet)


