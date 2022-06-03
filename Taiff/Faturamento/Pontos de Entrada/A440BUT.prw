#include "protheus.ch"
#include "topconn.ch"

User Function A440BUT

	Local aButtons   := {}

	If CEMPANT + CFILANT != "0302" .OR. (CEMPANT + CFILANT = "0302" .AND. (U_CLITRANSP(POSICIONE("SA1",1,XFILIAL("SA1") + SC5->C5_CLIENTE + SC5->C5_LOJACLI,"A1_CGC")) .OR. EMPTY(SC5->C5_NUMOC)))
		aadd(aButtons,{"BMPORD1",  {|| U_A440LIBMAN() },                "Ajusta Est.Disponivel", "Ajusta Est.Disponivel"})  // "System Tracker"
	EndIf

Return aButtons


User Function A440LIBMAN()

	Local cProduto   	:= 0
	Local cAlmox     	:= 0
	Local cCli       	:= 0
	Local cLoj       	:= 0
	Local nPosQtdLib 	:= 0
	Local nPosQtdVen 	:= 0
	Local nPosReserva	:= 0
	Local nPosQtdSal		:= 0
	Local nPosQtdEmp		:= 0
	Local _nSomaLib		:= 0
	Local _oDlg
	Local _oTPanel1
	Local _nPrcVen   	:= 0
	Local _nSomaPed	:= 0
	Local nI := 0

	cItem      := aScan( aHeader, {|x| Alltrim(x[2]) == "C6_ITEM"} )
	cProduto   := aScan( aHeader, {|x| Alltrim(x[2]) == "C6_PRODUTO"} )
	cAlmox     := aScan( aHeader, {|x| Alltrim(x[2]) == "C6_LOCAL"  } )
	cCli       := aScan( aHeader, {|x| Alltrim(x[2]) == "C6_CLI"    } )
	cLoj       := aScan( aHeader, {|x| Alltrim(x[2]) == "C6_LOJA"   } )
	nPosQtdLib := aScan( aHeader, {|x| Alltrim(x[2]) == "C6_QTDLIB" } )
	nPosQtdVen := aScan( aHeader, {|x| Alltrim(x[2]) == "C6_QTDVEN" } )
	nPosQtdSal := aScan( aHeader, {|x| Alltrim(x[2]) == "C6_QTDESAL"} )
	nPosQtdEnt := aScan( aHeader, {|x| Alltrim(x[2]) == "C6_QTDENT" } )
	nPosQtdEmp := aScan( aHeader, {|x| Alltrim(x[2]) == "C6_QTDEMP1" } )
	nPosReserva:= aScan( aHeader, {|x| Alltrim(x[2]) == "C6_RESERVA"} )

	For nI := 1 To Len(aCOLS)

	/*
	|=================================================================================
	|   COMENTARIO - 201309001
	|---------------------------------------------------------------------------------
	| Alteracao realizada para que, quando nao existe registro na Tabela SB2, o Sis-
	|tema nao considere e va para o proximo registro.
	|---------------------------------------------------------------------------------
	| DATA DA ALTERACAO - 09/09/2013 - ANALISTA - EDSON HORNBERGER
	|---------------------------------------------------------------------------------
	| SOLICITADO/VERIFICADO ERRO POR - CINTIA NUNES DA SILVA
	|=================================================================================
	*/

		dbSelectArea("SB2")
		If !DBSEEK(xfilial("SB2")+aCols[ni,cProduto]+aCols[ni,cAlmox])

			Loop

		EndIf
		// Fim da Primeira Alteracao

		If !Empty(AllTrim(aCols[nI,nPosReserva]))
			_Qstock:=SaldoSb2(,GetNewPar("MV_QEMPV",.T.)) + Posicione("SC6",1,xFilial("SC6")+M->C5_NUM+aCols[n,1]+aCols[n,2],"C6_QTDRESE")
		Else
			_Qstock:=SaldoSb2(,GetNewPar("MV_QEMPV",.T.))    //(SB2->B2_QATU - SB2->B2_RESERVA - SB2->B2_QACLASS - SB2->B2_QEMP)
		EndIf
		_nQean14:=Posicione("SB5",1,xFilial("SB5")+aCols[ni,cProduto],"B5_EAN141")
		_nQtdent:=Posicione("SC6",1,xFilial("SC6")+M->C5_NUM+aCols[ni,cItem]+aCols[ni,cProduto],"C6_QTDENT" )
		_nQtdEmp:=Posicione("SC6",1,xFilial("SC6")+M->C5_NUM+aCols[ni,cItem]+aCols[ni,cProduto],"C6_QTDEMP" )

	/* Prj: Cross Docking Remodelado */
	/* Para o Projeto Cross Docking remodelado quando filial destino for SP usar preço de venda original */
		_nPrcVen:=Posicione("SC6",1,xFilial("SC6")+M->C5_NUM+aCols[ni,cItem]+aCols[ni,cProduto],"C6_PRCVEN" )

		IF _nQtdEmp < 0
			_nQtdEmp:=0
		Endif

		If aCols[nI,nPosQtdVen]  >=  ( _nQtdent + _nQtdEmp + aCols[nI,nPosQtdLIB])
			// Inicio da Segunda Alteracao
			//aCols[nI,8]:= aCols[nI,nPosQtdVen] - ( _nQtdent + _nQtdEmp )
			//aCols[nI,9]:=_nQtdEmp
			aCols[nI,nPosQtdSal]:= aCols[nI,nPosQtdVen] - ( _nQtdent + _nQtdEmp )
			aCols[nI,nPosQtdEmp]:=_nQtdEmp
			// Fim da Segunda Alteracao
		Endif

	/*
	|=================================================================================
	|   FIM DA ALTERACAO - 201309001
	|=================================================================================
	*/

		If M->C5_FATPARC = "N" // Cliente NAO permite faturamento parcial
			If M->C5_FATFRAC = "N" // Cliente NAO permite faturamento fracionado
				If _Qstock < _nQean14
					aCols[nI,nPosQtdLib]:=0
				Else
					If _nQean14 > 0
						aCols[nI,nPosQtdLib] := aCols[nI,nPosQtdLib] - (aCols[nI,nPosQtdLib] % _nQean14)
						If _Qstock < aCols[ni,nPosQtdLib]
							aCols[nI,nPosQtdLib] := _Qstock - (_Qstock % _nQean14)
						EndIf
					Endif
				Endif
			EndIf
			If _Qstock > aCols[ni,nPosQtdLib] .and. aCols[ni,nPosQtdLib] = aCols[nI,nPosQtdSal]
				// não faz nada por que
				// 1. a quantidade liberada é integral
				// 2. o saldo na SB2 é maior do que o liberado
			ElseIf _Qstock < aCols[ni,nPosQtdLib]
				aCols[nI,nPosQtdLib] := 0
			EndIf
		Else
			If M->C5_FATFRAC = "N" // Cliente NAO permite faturamento fracionado
				If _Qstock < _nQean14
					aCols[nI,nPosQtdLib] := 0
				Else
					If _nQean14 > 0
						aCols[nI,nPosQtdLib] := aCols[nI,nPosQtdLib] - (aCols[nI,nPosQtdLib] % _nQean14)
						If _Qstock < aCols[ni,nPosQtdLib]
							aCols[nI,nPosQtdLib] := _Qstock - (_Qstock % _nQean14)
						EndIf
					Endif
				Endif
			Else
				If _Qstock < aCols[ni,nPosQtdLib] .AND. aCols[ni,nPosQtdLib] != 0
					aCols[nI,nPosQtdLib] := _qstock
				ElseIf aCols[ni,nPosQtdLib] = 0
					aCols[nI,nPosQtdLib] := _qstock
					If _qstock > 0 .and. aCols[nI,nPosQtdSal] < _qstock
						aCols[nI,nPosQtdLib] := aCols[nI,nPosQtdSal]
					ElseIf _qstock > 0 .and. aCols[nI,nPosQtdSal] >= _qstock
						aCols[nI,nPosQtdLib] := _qstock
					EndIf
				EndIf
			EndIf
		EndIf
		If  _Qstock = 0
			aCols[nI,nPosQtdLib] := 0
		EndIf

	/*
		If M->C5_FATPARC $ " 1"
		
			IF M->C5_FATFRAC $ = " 1"
				if aCols[ni,nPosQtdLib] <= _Qstock
				Else
				aCols[nI,nPosQtdLib] := _qstock
				Endif
			Else
			
				If aCols[ni,nPosQtdLib] <= _Qstock
				Else
					If _Qstock < _nQean14
					aCols[nI,nPosQtdLib]:=0
					Else
						If _nQean14 > 0
						aCols[nI,nPosQtdLib] := _qstock - (_qstock % _nQean14)
						Else
						aCols[nI,nPosQtdLib] := _qstock
						Endif
					Endif
				Endif
			Endif
		Endif
	*/
		_nSomaLib += aCols[nI,nPosQtdLib] * _nPrcVen
		_nSomaPed += aCols[nI,nPosQtdVen] * _nPrcVen
	Next Ni

	If SE4->(DbSeek( xFilial("SE4") + M->C5_CONDPAG))

		DEFINE MSDIALOG _oDlg TITLE "Informações do Pedido" FROM 0,0 TO 140,500 OF oMainWnd PIXEL

		_oTPanel1 := TPanel():New(0,0,"",_oDlg,NIL,.T.,.F.,NIL,NIL,0,100,.T.,.F.)

		_oTPanel1:Align := CONTROL_ALIGN_TOP

		@  4, 006 SAY "Condição de Pagamento: " SIZE 170,300 PIXEL OF _oTPanel1
		@  4, 080 SAY Alltrim(SE4->E4_DESCRI) SIZE 170,300 PIXEL OF _oTPanel1

		@ 20, 006 SAY "Valor total liberado : " SIZE 170,300 PIXEL OF _oTPanel1
		@ 20, 080 SAY Alltrim(Transform( _nSomaLib ,"@R 999,999,999.99")) SIZE 170,300 PIXEL OF _oTPanel1

		If M->C5_FILDES="01" .AND. CEMPANT + CFILANT = "0302"
			@ 30, 006 SAY "Valor Total Pedido : " SIZE 170,300 PIXEL OF _oTPanel1
			@ 30, 080 SAY Alltrim(Transform( _nSomaPed ,"@R 999,999,999.99")) SIZE 170,300 PIXEL OF _oTPanel1
		EndIf

		@ 40, 120 BUTTON "Ok"  SIZE 020, 017 PIXEL OF _oDlg ACTION (nOpca := 1,_oDlg:End())

		ACTIVATE MSDIALOG _oDlg CENTER

	Endif

Return
