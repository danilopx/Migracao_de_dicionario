//#INCLUDE "rwmake.ch"
#INCLUDE "Protheus.ch"
#INCLUDE "TOPCONN.CH"
#include "colors.ch"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณFuncao    ณ PERF    ณ Autor ณ Ewerton C Tomaz        ณ Data ณ 01/12/00 ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescricao ณ Ponto de Entrada em que trata a Consulta dos Produtos      ณฑฑ
ฑฑณ            Botใo Caracteristicas dos Produto                          ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณSintaxe   ณ TMKVCA.PRW                                                 ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณ Uso      ณ Projeto Ewerton                                            ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

#include "rwmake.ch"

User Function RESTC03(_cProd,cFilCon, _cLocaliz)
	//Local nPeg 		:= 0
	//Local nVPeg 	:= 0
	//Local nSldPeg 	:= 0
	Local nEntrar 	:= 0
	//Local nDispPeg 	:= 0
	//Local nTransf	:= 0
	Local z			:= 0
	Local nReceb
	Private _aAreaRest := GetArea()
	Private _cProduto,cObs
	Private oEstoque,oObs,oDlgBped
	Private _nPEDVEN := 0
	Private _nSalPedi	:= 0
	Private _nReserva	:= 0
	Private _nStok2	:= 0
	Private _cBitPro 	:= "",oBitPro
	Private _cLocal 	:= _cLocaliz
	Private _cPictSB2  := SPACE(12)
	Private cFilEst     := Iif(cFilCon==Nil,xFilial("SB2"),cFilCon)

	DbSelectarea( "SB2" )
	If _cProd <> nil
		DbSetOrder(1)
		If !DbSeek(cFilEst+_cProd+_cLocal)
			MsgStop('Item sem Estoque Lancado!')
			RestArea(_aAreaRest)
			Return(.T.)
		Endif
	Endif
	_cProduto:=B2_COD
	_cLocal  := _cLocal
	_cObs    := ""
	_nQtUM   := 1


	DbSelectarea( "SB1" )
	DbSetorder(1)
	DbSeek(cFilEst + _cProduto )


//PEDIDOS A ENTRAR
	cQueryCad :="select SUM(C7_QUANT-C7_QUJE) ENTRAR"
	cQueryCad +="  from "+RetSqlName('SC7')+" WITH(NOLOCK) "
	cQueryCad +=" where D_E_L_E_T_ <>'*' and C7_PRODUTO ='"+SB2->B2_COD+"' and C7_QUANT >C7_QUJE and C7_RESIDUO <> 'S'"
	cQueryCad +=" AND C7_FILIAL = '"+cFilEst+"' AND C7_CONAPRO IN ('L','')"
	MemoWrite("RESTC03B.SQL",cQueryCad)
	tcQuery cQueryCad new alias "CAD"

	dbSelectArea("CAD")
	dbGoTop()
	nEntrar := CAD->ENTRAR

	CAD->(dbCloseArea())


//NOTAS NO RECEBIMENT0
	cQuery := " SELECT SUM(D1_QUANT) TRANSF FROM "+RetSqlName("SF1")+" F1 WITH(NOLOCK)"
	cQuery += " INNER JOIN "+RetSqlName("SD1")+" D1 WITH(NOLOCK) ON D1_FILIAL = F1_FILIAL AND D1_DOC = F1_DOC AND D1_SERIE = F1_SERIE AND D1_FORNECE = F1_FORNECE "
	cQuery += " INNER JOIN "+RetSqlName("SA2")+" A2 WITH(NOLOCK) ON F1_FORNECE = A2_COD"
	cQuery += " WHERE "
	cQuery += " D1_COD = '"+SB2->B2_COD+"'  AND F1.D_E_L_E_T_ <> '*' AND D1.D_E_L_E_T_ <> '*'AND A2.D_E_L_E_T_ <> '*' AND F1_FILIAL = '"+cFilEst+"'
	cQuery += " AND F1_STATUS = '' AND F1.D_E_L_E_T_ <> '*' AND A2.D_E_L_E_T_ <> '*'"

	MemoWrite("RESTC03D.SQL",cQuery)
	tcQuery cQuery new alias "CAD"

	dbSelectArea("CAD")
	dbGoTop()
	nReceb := CAD->TRANSF

	CAD->(dbCloseArea())

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Mostra dados do Produto.					                 ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

	DEFINE MSDIALOG oEstoque FROM  13,181 TO 590,600 TITLE "Caracteristicas" PIXEL
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณDados das caracteristicas do produto                 ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	@ 000,002    SAY "Dados do Produto"   SIZE  56, 7
//@ 006,002 TO 092,210
	@ 006,002 TO 077,210
	@ 011,004    SAY "Codigo"             SIZE  21, 7
	@ 010,029    GET SB1->B1_COD          SIZE  40, 9 When .F.
	@ 011,070    SAY "Descricao"          SIZE  32, 7
	@ 010,094    GET SB1->B1_DESC         SIZE 114, 9 When .F.

	@ 026,004    SAY "Unidade"            SIZE  25, 7
	@ 025,029    GET SB1->B1_UM           SIZE  14, 9 When .F.
	@ 026,054    SAY "Embalagem"          SIZE  25, 7
	@ 025,084    GET SB1->B1_QE	          SIZE  14, 9 When .F.
	@ 026,140    SAY "Grupo"              SIZE  18, 7
	@ 025,160    GET SB1->B1_GRUPO        SIZE  14, 9 When .F.

	@ 041,004    SAY "Fornec."            SIZE  21, 7
	@ 040,029    GET SB1->B1_PROC         SIZE  40, 9 When .F.
	@ 056,004    SAY "Especif."           SIZE  25, 7
	_cEspec1 := SubStr(SB1->B1_ESPECIF,1,40)
	_cEspec2 := SubStr(SB1->B1_ESPECIF,41,40)
	@ 55, 29   GET _cEspec1      SIZE  170, 9 When .F.
	@ 65, 29   GET _cEspec2      SIZE  170, 9 When .F.


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณSaldo do estoque do produto                          ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู


	@ 078,003  SAY "Estoque:"     	SIZE 100, 7
	@ 078,126  SAY "Empenho"          	SIZE  30, 7
	@ 078,173  SAY "Calculo Mensal"        	SIZE  50, 7
	@ 085,002  TO 147, 210
	@ 087,004  BUTTON "Bloqueado"   	SIZE 35,9 ACTION DETALHE3("2")
	@ 087,089  BUTTON "Empenho"        	SIZE 35,9 ACTION MsgInfo("Quantidade empenhada nas OPs", "")
	@ 097,004  BUTTON "A Entrar"   	SIZE 35,9 ACTION DETALHE()
	@ 097,089  BUTTON "Liber.Fat."    	SIZE 35,9 ACTION DETALHE3("1")



	@ 107,004    BUTTON "Estoque"     SIZE 35,9 ACTION MsgInfo('Quantidade Real em Estoque = '+Transform(SB2->B2_QATU,'@ER 9999999')+Chr(13)+;
		'Quantidade Reservada = '+Transform(SB2->B2_RESERVA+SB2->B2_QPEDVEN,'@ER 9999999')+Chr(13)+'Empenho OPs = '+Transform(SB2->B2_QEMP,'@ER 9999999')+Chr(13)+;
		'Quantidade Real Disponivel= '+Transform((SB2->B2_QATU-SB2->B2_RESERVA-SB2->B2_QPEDVEN-SB2->B2_QEMP),'@ER 9999999'), "")

	@ 107,089   BUTTON "Disponivel"  SIZE 35,9 ACTION MsgInfo('Quantidade Disponivel'+Chr(13)+'Para que o Pedido Aberto possa ser Liberado'+Chr(13)+;
		'Fora essa Quantidade o Pedido ficara Pendente.', "")

	@ 117,004  BUTTON "Recebimento" 	SIZE 35,9 ACTION MsgInfo('Quantidade no Recebimento'+Chr(13)+'Pode estar aguardando classifica็ใo ou endere็ar', "")

	@ 117,089  BUTTON "Defeito"   	SIZE 35,9 ACTION MsgInfo('Quantidade Defeito'+Chr(13), "")


	@ 137,004  BUTTON "Terceiros" 	SIZE 35,9 ACTION MsgInfo('Saldo em poder de terceiros', "")


	_lPromocao := .f.
	_nValor := 0.00

	DbSelectarea( "SB2" )
	DbSetOrder(1)
	DbSeek(cFilEst+_cProd+_cLocal)

	cCod 		:= SB2->B2_COD
	nSaldoSB2 	:= 0
	nSaldoInt	:= 0
	nSaldoDef	:= 0
	//NAO LE O ALMOXARIFADO DE DEFEITO
	If SB2->B2_LOCAL $ "01|02|03|10|11|21|25|31"
		nSaldoSB2 += SB2->B2_QATU
	EndIf
	//SALDO DEFEITO
	If SB2->B2_LOCAL $ "32|90|93|94|95"
		nSaldoDef := SB2->B2_QATU
	EndIf




	nAEnder  := B2_QACLASS + nReceb
	_nPEDVEN :=B2_QPEDVEN
	_nSalPedi:= Iif((nEntrar-B2_QACLASS)<0,0,(nEntrar-B2_QACLASS))
	nSaldo := SaldoMov()
	nTerceiro := SB2->B2_QNPT+SB2->B2_QTER
	_nReserva:= SB2->B2_RESERVA
	_nDisp   := (SB2->B2_QATU-SB2->B2_RESERVA-SB2->B2_QPEDVEN-SB2->B2_QEMP-B2_QACLASS)
	_nStok2  := nSaldoSB2-B2_QACLASS
	_nEmp	 := SB2->B2_QEMP
	_nDisp := Iif(_nDisp<0,0,_nDisp)

	@ 087,042  GET  _nPEDVEN  Picture "@E 999,999" SIZE 40, 9 When .F.
	@ 087,124  GET  _nEmp     Picture "@E 999,999" SIZE 40, 9 When .F.
	@ 097,042  GET  _nSalPedi Picture "@E 999,999" SIZE 40, 9 When .F.
	@ 098,124  GET  _nReserva Picture "@E 999,999" SIZE 40, 9 When .F.
	@ 107,042  GET  _nStok2   Picture "@E 999,999" SIZE 40, 9 When .F.
	@ 107,124  GET  _nDisp    Picture "@E 999,999" SIZE 40, 9 When .F.
	@ 117,042  GET  nAEnder   Picture "@E 999,999" SIZE 40, 9 When .F.
	@ 117,124  GET  nSaldoDef    Picture "@E 999,999" SIZE 40, 9 When .F.
	@ 137,042  GET  nTerceiro  Picture "@E 999,999" SIZE 40, 9 When .F. //poder terceiros


	@ 156,2 TO 220,210

	@ 148,3   SAY Iif(SB1->B1_TIPO == "PA","Media Vendas","Media Consumo") SIZE 143, 7
	aMes 	:= {}
	aMesCons:= {}		//CONSUMO CONTRATO
	aMesItu := {}
	nMedia 	:= 0
	nQuant 	:= 0
	nConsMes:= 0
	//BUSCA OS CONSUMOS MENSAIS

	DbSelectArea('SB3')
	DbSetOrder(1)
	If DbSeek(cFilEst+_cProduto)

		For z:= 1 To 12

			If Month(dDataBase)-z == 0
				cMes	 := "12"
			ElseIf 	Month(dDataBase)-z == -1
				cMes	 := "11"
			ElseIf Month(dDataBase)-z == -2
				cMes	 := "10"
			ElseIf Month(dDataBase)-z == -3
				cMes	 := "09"
			Else
				cMes	 := StrZero(Month(dDataBase)-z,2)
			EndIf

			cCampo := "B3_Q"+cMes
			nQuant += &cCampo
			//01-MES, 02- QUANT
			aAdd(aMes,{"M๊s "+cMes,&cCampo})
			aAdd(aMesCons,{cMes,0})
		Next

		//PEGA A MEDIA CALCULADA PELA ROTINA COMMI005
		nMedia  := SB3->B3_MEDIA
	Else
		nMedia := 0
		For z:= 1 To 12
			aAdd(aMes,{"",0})
			aAdd(aMesCons,{"",0})
		Next

	EndIf



	If Len(aMes) > 0
		//LINHA 1
		@ 148,048 SAY aMes[1][1] SIZE 20, 10
		@ 148,076 SAY aMes[2][1] SIZE 20, 10
		@ 148,104 SAY aMes[3][1] SIZE 20, 10
		@ 148,132 SAY aMes[4][1] SIZE 20, 10

		@ 158,005 GET nMedia    Picture "@E 999999" SIZE 40, 9  When .F.
		@ 158,048 GET aMes[1][2]    Picture "@E 999999" SIZE 20, 9  When .F.
		@ 158,076 GET aMes[2][2]    Picture "@E 999999" SIZE 20, 9  When .F.
		@ 158,104 GET aMes[3][2]    Picture "@E 999999" SIZE 20, 9  When .F.
		@ 158,132 GET aMes[4][2]    Picture "@E 999999" SIZE 20, 9  When .F.

		//LINHA 2

		@ 168,048 SAY aMes[5][1] SIZE 20, 10
		@ 168,076 SAY aMes[6][1] SIZE 20, 10
		@ 168,104 SAY aMes[7][1] SIZE 20, 10
		@ 168,132 SAY aMes[8][1] SIZE 20, 10

		@ 178,048 GET aMes[5][2]    Picture "@E 999999" SIZE 20, 9  When .F.
		@ 178,076 GET aMes[6][2]    Picture "@E 999999" SIZE 20, 9  When .F.
		@ 178,104 GET aMes[7][2]    Picture "@E 999999" SIZE 20, 9  When .F.
		@ 178,132 GET aMes[8][2]    Picture "@E 999999" SIZE 20, 9  When .F.

		//LINHA 3
		@ 188,048 SAY aMes[9][1] SIZE 20, 10
		@ 188,076 SAY aMes[10][1] SIZE 20, 10
		@ 188,104 SAY aMes[11][1] SIZE 20, 10
		@ 188,132 SAY aMes[12][1] SIZE 20, 10

		@ 198,048 GET aMes[9][2]    Picture "@E 999999" SIZE 20, 9  When .F.
		@ 198,076 GET aMes[10][2]    Picture "@E 999999" SIZE 20, 9  When .F.
		@ 198,104 GET aMes[11][2]    Picture "@E 999999" SIZE 20, 9  When .F.
		@ 198,132 GET aMes[12][2]    Picture "@E 999999" SIZE 20, 9  When .F.


	EndIf


	cQuery := " SELECT TOP 1 * FROM "+RetSqlName("SD1")+" D1"
	cQuery += " INNER JOIN  "+RetSqlName("SF4")+" F4"
	cQuery += " ON F4_CODIGO = D1_TES "+Iif(cEmpAnt=="03"," AND F4_FILIAL = D1_FILIAL","")
	cQuery += " WHERE D1_COD = '"+SB2->B2_COD+"' AND  D1.D_E_L_E_T_ <> '*' AND F4.D_E_L_E_T_ <> '*' AND D1_TIPO = 'N'"
	cQuery += " AND D1_FILIAL = '"+cFilEst+"' AND F4_DUPLIC = 'S'"
	cQuery += " ORDER BY D1_DTDIGIT DESC"

	MemoWrite("RESTCSD1.SQL",cQuery)
	tcQuery cQuery new alias "TRBNSD1"
	tcSetField("TRBNSD1","D1_DTDIGIT","D")

	Count To nRec

	If nRec > 0
		dbSelectArea("TRBNSD1")
		dbGoTop()

		@ 187,2 TO 205,200
		@ 220,006  SAY 'U.Cpr: '+DTOC(TRBNSD1->D1_DTDIGIT) SIZE 100, 9
		@ 220,056  SAY 'Qtde: '+Transf(TRBNSD1->D1_QUANT,"@E 999999") SIZE 40, 9
		@ 220,086  SAY 'Icm: '+Transf(TRBNSD1->D1_PICM,"@E 99")+' %' SIZE 40, 9
		@ 220,116  SAY 'Ipi: '+Transf(TRBNSD1->D1_IPI,"@E 99")+'% -> '+Str(((TRBNSD1->D1_PICM * TRBNSD1->D1_IPI)/100),3,1) SIZE 40, 9

		_cCond := Posicione('SF1',1,cFilEst+TRBNSD1->D1_DOC+TRBNSD1->D1_SERIE+TRBNSD1->D1_FORNECE+TRBNSD1->D1_LOJA,'F1_COND')
		// 	   @ 177,131  SAY 'Preco: '+Transf(SB1->B1_UPRC,"@E 999,999.99") SIZE 40, 9

		_nUltCompra := (TRBNSD1->D1_VUNIT*(1-(TRBNSD1->D1_DESC/100))) + Round((TRBNSD1->D1_VUNIT * TRBNSD1->D1_IPI)/100,2)+(TRBNSD1->D1_ICMSRET/TRBNSD1->D1_QUANT)

		@ 220,158  SAY 'Preco: '+Transf(_nUltCompra,"@E 999,999.99") SIZE 50, 9


		@ 229,006  SAY 'Condicao: '+Posicione('SE4',1,xFilial('SE4')+_cCond,'E4_DESCRI') SIZE 60, 9
		@ 229,080  SAY 'Fornecedor: '+SubStr(Posicione('SA2',1,xFilial('SA2')+TRBNSD1->D1_FORNECE+TRBNSD1->D1_LOJA,'A2_NOME'),1,30) SIZE 150, 9
	Else
		@ 220,006  SAY 'Nao existem referencias de compras para o produto.' SIZE 200, 9
	Endif
	TRBNSD1->(dbCloseArea())
	DbSelectarea( "SB2" )



	@ 267,010 BUTTON "Previsao Entrega" SIZE 55,10 ACTION DETALHE()
	@ 270,100 BUTTON "ฺlt.Entrs" SIZE 30,10 ACTION ENTRADAS()
	DEFINE SBUTTON FROM 270,160 TYPE 1 ACTION {||RestArea(_aAreaRest),(oEstoque:End())} ENABLE OF oEstoque

	ACTIVATE MSDIALOG oEstoque CENTER

	RestArea(_aAreaRest)

Return(.T.)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณDETALHE   บAutor  ณMicrosiga           บ Data ณ  12/27/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

static function DETALHE()
	Local aArea := GetArea()
	private cPro    :=SB1->B1_COD
	private _aArqSel := {"SC7"}
	private cArq    :=""
	private cCampos :="C7_NUM,C7_ITEM,C7_PRODUTO,C7_DESCRI,C7_QUANT,C7_QUJE,C7_AQUANT,C7_UM,C7_DATPRF,C7_EMISSAO,"
	private aFields :={}

	cria_TC7()
	processa({|| monta_TC7()},"Selecionando registros...")

	aTela :={}
	aAdd(aTela,{"C7_NUM"    ,"Pedido"                     })
	aAdd(aTela,{"C7_ITEM"   ,"Item"       ,"@E 99"        })
	aAdd(aTela,{"C7_PRODUTO","Produto"                    })
	aAdd(aTela,{"C7_QUANT"  ,"Quantidade" ,"@E 999,999.99"})
	aAdd(aTela,{"C7_UM"     ,"Unidade"    ,"@!"           })
	aAdd(aTela,{"C7_QUJE"   ,"Qt.Recebida","@E 999,999.99"})
	aAdd(aTela,{"C7_AQUANT" ,"a Receber"  ,"@E 999,999.99"})
	aAdd(aTela,{"C7_DATPRF" ,"Dt.Previsao"                })
	aAdd(aTela,{"C7_DESCRI" ,"Descricao"  ,"@!"           })
	aAdd(aTela,{"C7_EMISSAO","Emissao"    ,		           })

	@ 310,0 to 520,799 dialog oDlg2 title "Detalhes da Previsao de Entrega"
	@ 10,10 to 070,380 browse "TC7" fields aTela
	@ 090,350	bmpButton type 2 action close(oDlg2)

	activate dialog oDlg2

	dbSelectArea("TC7")
	dbCloseArea()
	if file(cArq+".dbf")
		fErase(cArq+".dbf")
	endif

	RestArea(aArea)
return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณcria_TC7  บAutor  ณMicrosiga           บ Data ณ  12/27/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

static function cria_TC7()

	Local _nX := 0

	dbSelectArea('SX3')
	dbSetOrder(1)
	For _nX := 1 To Len(_aArqSel)
		DbSeek(_aArqSel[_nX])
		While !Eof() .And. X3_ARQUIVO = _aArqSel[_nX]
			if (alltrim(X3_CAMPO)+"," $cCampos)
				aadd(aFields,{X3_CAMPO,X3_TIPO,X3_TAMANHO,X3_DECIMAL})
			endif
			dbSkip()
		endDo
	Next
	aadd(aFields,{"C7_AQUANT","N",12,2})

	cArq:=criatrab(aFields,.T.)
	dbUseArea(.t.,,cArq,"TC7")
return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณmonta_TC7 บAutor  ณMicrosiga           บ Data ณ  12/27/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

static function monta_TC7()

	Local nX := 0

	cQueryCad :="select C7_NUM,C7_ITEM,C7_PRODUTO,C7_DESCRI,C7_QUANT,C7_QUJE, C7_EMISSAO,"
	cQueryCad +="       (C7_QUANT-C7_QUJE) as C7_AQUANT,C7_UM,C7_DATPRF"
	cQueryCad +="  from "+RetSqlName('SC7')+" WITH(NOLOCK) "
	cQueryCad +=" where D_E_L_E_T_ <>'*' and C7_PRODUTO ='"+alltrim(cPro)+"' and C7_QUANT >C7_QUJE and C7_RESIDUO <> 'S'"
	cQueryCad +=" AND C7_FILIAL = '"+cFilEst+"' AND C7_CONAPRO IN ('L','')"
	cQueryCad +=" order by C7_DATPRF"

	If Select("CAD") > 0
		CAD->(dbCloseArea())
	EndIf

	tcQuery cQueryCad new alias "CAD"

	tcSetField("CAD","C7_DATPRF","D")
	tcSetField("CAD","C7_EMISSAO","D")

	dbSelectArea("CAD")
	dbGoTop()

	procRegua(recCount())
	while CAD->(!eof())
		incProc()
		recLock("TC7",.T.)
		for nX := 1 to Len(aFields)
			if aFields[nX,2] ='C'
				cX :='TC7->'+aFields[nX,1]+' :=alltrim(CAD->'+aFields[nX,1]+')'
			else
				cX :='TC7->'+aFields[nX,1]+' :=CAD->'+aFields[nX,1]
			endif
			cX :=&cX
		next
		TC7->(msUnLock())
		CAD->(dbSkip())
	endDo
	dbSelectarea("CAD")
	dbCloseArea()

	dbSelectarea("TC7")
	dbGoTop()
	sysRefresh()
return



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณcria_SD1  บAutor  ณMicrosiga           บ Data ณ  12/27/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

static function cria_SD1()

	Local _nX := 0

	dbSelectArea('SX3')
	dbSetOrder(1)
	For _nX := 1 To Len(_aArqSel)
		DbSeek(_aArqSel[_nX])
		While !Eof() .And. X3_ARQUIVO = _aArqSel[_nX]
			if (alltrim(X3_CAMPO)+"," $cCampos)
				aadd(aFields,{X3_CAMPO,X3_TIPO,X3_TAMANHO,X3_DECIMAL})
			endif
			dbSkip()
		endDo
	Next

	cArq:=criatrab(aFields,.T.)
	dbUseArea(.t.,,cArq,"TD1")
return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณmonta_TD1 บAutor  ณMicrosiga           บ Data ณ  12/27/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

static function monta_SD1()

	Local nX := 0

	cQuery := " SELECT D1_DOC,D1_ITEM,D1_COD,D1_PYDPROD,D1_QUANT,D1_UM,D1_DTDIGIT FROM "+RetSqlName("SF1")+" F1 WITH(NOLOCK)"
	cQuery += " INNER JOIN "+RetSqlName("SD1")+" D1 WITH(NOLOCK) ON D1_FILIAL = F1_FILIAL AND D1_DOC = F1_DOC AND D1_SERIE = F1_SERIE AND D1_FORNECE = F1_FORNECE "
	cQuery += " INNER JOIN "+RetSqlName("SA2")+" A2 WITH(NOLOCK) ON F1_FORNECE = A2_COD"
	cQuery += " WHERE "
	cQuery += " D1_COD = '"+alltrim(cPro)+"'  AND F1.D_E_L_E_T_ <> '*' AND D1.D_E_L_E_T_ <> '*'AND A2.D_E_L_E_T_ <> '*' AND F1_FILIAL = '"+cFilEst+"'
	cQuery += " AND F1_STATUS = '' AND F1.D_E_L_E_T_ <> '*' AND A2.D_E_L_E_T_ <> '*'"

	MemoWrite("RESTC03G.SQL",cQuery)
	tcQuery cQuery new alias "CAD"

	tcSetField("CAD","D1_DTDIGIT","D")

	dbSelectArea("CAD")
	dbGoTop()

	procRegua(recCount())
	while CAD->(!eof())
		incProc()
		recLock("TD1",.T.)
		for nX := 1 to Len(aFields)
			if aFields[nX,2] ='C'
				cX :='TD1->'+aFields[nX,1]+' :=alltrim(CAD->'+aFields[nX,1]+')'
			else
				cX :='TD1->'+aFields[nX,1]+' :=CAD->'+aFields[nX,1]
			endif
			cX :=&cX
		next
		TD1->(msUnLock())
		CAD->(dbSkip())
	endDo

	CAD->(dbCloseArea())

	dbSelectarea("TD1")
	dbGoTop()
	sysRefresh()
return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณDETALHE3  บAutor  ณMicrosiga           บ Data ณ  12/27/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณpedidos liberados                                           บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

static function DETALHE3(cDOpC6)
	Local aArea := GetArea()
	private cPro    :=SB1->B1_COD
	private _aArqSel := {"SC5","SC6","SA1"}
	private cArq    :=""
	private cCampos :="C5_NUM, A1_NOME, C6_ITEM,C6_PRODUTO,C6_DESCRI,C6_QTDVEN,C6_UM,C5_EMISSAO,"
	private aFields :={}
	Private cOpC6   := cDOpC6

	cria_SC6()
	processa({|| monta_SC6()},"Selecionando registros...")

	aTela :={}
	aAdd(aTela,{"C5_NUM"  		,"Pedido"                     })
	aAdd(aTela,{"A1_NOME"  		,"Cliente"                    })
	aAdd(aTela,{"C6_ITEM" 		,"Item"       ,"@E 99"        })
	aAdd(aTela,{"C6_PRODUTO"	,"Produto"                    })
	aAdd(aTela,{"C6_DESCRI"		,"Descricao"                   })
	aAdd(aTela,{"C6_QTDVEN"  	,"Quantidade" ,"@E 999,999.99"})
	aAdd(aTela,{"C6_UM"     	,"Unidade"    ,"@!"           })
	aAdd(aTela,{"C5_EMISSAO"	,"Emissao" 		               })

	@ 310,0 to 520,799 dialog oDlg2 title "Detalhes Pedidos"
	@ 10,10 to 070,380 browse "TC6" fields aTela
	@ 090,350	bmpButton type 2 action close(oDlg2)

	activate dialog oDlg2

	TC6->(dbCloseArea())
	if file(cArq+".dbf")
		fErase(cArq+".dbf")
	endif

	RestArea(aArea)
return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณcria_SC6  บAutor  ณMicrosiga           บ Data ณ  12/27/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

static function cria_SC6()
	Local _nX := 0

	dbSelectArea('SX3')
	dbSetOrder(1)
	For _nX := 1 To Len(_aArqSel)
		DbSeek(_aArqSel[_nX])
		While !Eof() .And. X3_ARQUIVO = _aArqSel[_nX]
			if (alltrim(X3_CAMPO)+"," $cCampos)
				aadd(aFields,{X3_CAMPO,X3_TIPO,X3_TAMANHO,X3_DECIMAL})
			endif
			dbSkip()
		endDo
	Next

	cArq:=criatrab(aFields,.T.)
	dbUseArea(.t.,,cArq,"TC6")
return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณmonta_TC6 บAutor  ณMicrosiga           บ Data ณ  12/27/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

static function monta_SC6()
	Local nX := 0

	cQuery := " SELECT C5_NUM, ISNULL(A1_NOME,'FORNECEDOR') A1_NOME, C6_ITEM,C6_PRODUTO,C6_DESCRI,C6_QTDVEN,C6_UM,C5_EMISSAO"
	cQuery += " FROM "+RetSqlName("SC6")+" C6 with(nolock) "
	cQuery += " INNER JOIN "+RetSqlName("SC5")+" C5 ON C5_FILIAL = C6_FILIAL AND C5_NUM = C6_NUM"
	cQuery += " LEFT JOIN "+RetSqlName("SA1")+" A1 ON A1_COD = C5_CLIENTE"
	cQuery += " WHERE C6_PRODUTO   = '"+alltrim(cPro)+"'  AND C5.D_E_L_E_T_ <> '*' AND C6.D_E_L_E_T_ <> '*'"
	cQuery += " AND C6_FILIAL = '"+cFilEst+"' AND C6_NOTA = '' AND C6_BLQ NOT IN ('R','S')"
	cQuery += "ORDER BY C5_NUM"

	MemoWrite("RESTC03H.SQL",cQuery)

	tcQuery cQuery new alias "CAD"

	tcSetField("CAD","C5_EMISSAO","D")

	dbSelectArea("CAD")
	dbGoTop()

	procRegua(recCount())
	while CAD->(!eof())
		incProc()
		recLock("TC6",.T.)
		for nX := 1 to Len(aFields)
			if aFields[nX,2] ='C'
				cX :='TC6->'+aFields[nX,1]+' :=alltrim(CAD->'+aFields[nX,1]+')'
			else
				cX :='TC6->'+aFields[nX,1]+' :=CAD->'+aFields[nX,1]
			endif
			cX :=&cX
		next
		TC6->(msUnLock())
		CAD->(dbSkip())
	endDo

	CAD->(dbCloseArea())

	dbSelectarea("TC6")
	dbGoTop()
	sysRefresh()
return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRESTC03   บAutor  ณMicrosiga           บ Data ณ  06/02/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

static function ENTRADAS()
	Local aArea := GetArea()

	private cPro    :=SB1->B1_COD
	private _aArqSel := {"SD1","SA2","SE4","SF1"}
	private cArq    :=""
	private cCampos :="D1_DOC,D1_PEDIDO,D1_DTDIGIT,D1_FORNECE,D1_CF,D1_VUNIT,D1_QUANT,D1_TOTAL,D1_CUSTO2,D1_IPI,D1_PICM,F1_COND,E4_DESCRI, "
	private aFields :={}

	cria_ENT()
	processa({|| monta_ENT()},"Selecionando registros...")

	aTela :={}
	aAdd(aTela,{"D1_DOC"    ,"N.F."      	,"@!"           })
	aAdd(aTela,{"D1_PEDIDO" ,"Ped Cpr"   	,"@!"           })
	aAdd(aTela,{"D1_DTDIGIT","Dt.Entr"   			        })
	aAdd(aTela,{"D1_FORNECE","Codigo"    	,"@!"           })
	aAdd(aTela,{"A2_NOME"  ,"Fornecedor" 	,"@!"			})
	aAdd(aTela,{"D1_CF"    ,"CFOP"       	,"@!"           })
	aAdd(aTela,{"D1_VUNIT" ,"Unit.C/ ST." 	,"@E 999,999.99"})
	aAdd(aTela,{"D1_CUSTO2","Unit.S/ ST."	,"@E 999,999.99"})
	aAdd(aTela,{"D1_QUANT" ,"Qtde"		  				 	})
	aAdd(aTela,{"D1_TOTAL" ,"Total"      	,"@E 999,999.99"})
	aAdd(aTela,{"D1_IPI"   ,"IPI"  		    		        })
	aAdd(aTela,{"D1_PICM"  ,"ICM"                  			})
	aAdd(aTela,{"FORMULA"  ,"Formula"           			})
	aAdd(aTela,{"F1_COND"  ,"C.Pagto"  ,"@!"           		})
	aAdd(aTela,{"E4_DESCRI","Descricao"  ,"@!"           	})

	dbSelectArea("ENT")

	@ 310,0 to 520,799 dialog oDlg2 title "Ultimas Entradas"
	@ 10,10 to 070,380 browse "ENT" fields aTela
	@ 090,350	bmpButton type 2 action close(oDlg2)

	activate dialog oDlg2

	dbSelectArea("ENT")
	dbCloseArea()
	if file(cArq)
		fErase(cArq)
	endif

	RestArea(aArea)
return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณcria_ENT  บAutor  ณMicrosiga           บ Data ณ  12/27/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

static function cria_ENT()

	Local _nX := 0

	dbSelectArea('SX3')
	dbSetOrder(1)
	For _nX := 1 To Len(_aArqSel)
		DbSeek(_aArqSel[_nX])
		While !Eof() .And. X3_ARQUIVO = _aArqSel[_nX]
			if (alltrim(X3_CAMPO)+"," $cCampos)
				aadd(aFields,{X3_CAMPO,X3_TIPO,X3_TAMANHO,X3_DECIMAL})
			endif
			dbSkip()
		endDo
	Next
	aadd(aFields,{"A2_NOME","C",20,0})
	aadd(aFields,{"FORMULA","N",5,3})

	cArq:=criatrab(aFields,.T.)
	dbUseArea(.t.,,cArq,"ENT")
return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRESTC03   บAutor  ณMicrosiga           บ Data ณ  12/27/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

static function monta_ENT()

	Local nX := 0

	cQueryCad :="SELECT TOP 20 D1_DOC, "
	cQueryCad +="				D1_PEDIDO, "
	cQueryCad +="				D1_DTDIGIT, "
	cQueryCad +="				D1_FORNECE, "
	cQueryCad +="				A2_NOME,    "
	cQueryCad +="				D1_TES,     "
	cQueryCad +="				D1_CF,		"
	cQueryCad +="				ROUND(((D1_VUNIT*(1-(D1_DESC/100))) + ((D1_VUNIT * D1_IPI)/100))+(D1_ICMSRET/D1_QUANT),2) D1_VUNIT,   "
	cQueryCad +="				D1_QUANT,   "
	cQueryCad +="				ROUND(((D1_VUNIT*(1-(D1_DESC/100))*D1_QUANT) + D1_VALIPI)+D1_ICMSRET,2) D1_TOTAL,   "
	cQueryCad +="				D1_IPI,     "
	cQueryCad +="				D1_PICM,    "
	cQueryCad +="				((D1_PICM * D1_IPI)/100) FORMULA, "
	cQueryCad +="				D1_VUNIT  D1_CUSTO2,"
	cQueryCad +="				F1_COND, "
	cQueryCad +="				E4_DESCRI "
	cQueryCad +=" FROM "+RetSqlName('SD1')+", "+RetSqlName('SA2')+", "+RetSqlName('SF1')+", "+RetSqlName('SE4')+", "+RetSqlName('SF4')+"  "
	cQueryCad +=" WHERE D1_COD = '"+alltrim(cPro)+"' "
	cQueryCad +=" AND F1_DOC = D1_DOC "
	cQueryCad +=" AND D1_FORNECE = F1_FORNECE "
	cQueryCad +=" AND E4_CODIGO = F1_COND "
	cQueryCad +=" AND D1_FORNECE = A2_COD  "
	cQueryCad +=" AND F4_CODIGO = D1_TES "+Iif(cEmpAnt=="03"," AND F4_FILIAL = D1_FILIAL","")
	cQueryCad +=" AND D1_TIPO = 'N' AND D1_TES <> ''"
	cQueryCad +=" AND F4_ESTOQUE = 'S' AND F4_DUPLIC = 'S'"
	cQueryCad +=" AND D1_FILIAL = '"+cFilEst+"' AND F1_FILIAL = '"+cFilEst+"' AND A2_FILIAL = '"+xFilial("SA2")+"' AND E4_FILIAL = '"+xFilial("SE4")+"'"
	cQueryCad +=" AND "+RetSqlName('SD1')+".D_E_L_E_T_ <> '*' "
	cQueryCad +=" AND "+RetSqlName('SF1')+".D_E_L_E_T_ <> '*' "
	cQueryCad +=" AND "+RetSqlName('SA2')+".D_E_L_E_T_ <> '*' "
	cQueryCad +=" AND "+RetSqlName('SE4')+".D_E_L_E_T_ <> '*' "
	cQueryCad +=" AND "+RetSqlName('SF4')+".D_E_L_E_T_ <> '*' "
	cQueryCad +="ORDER BY D1_DTDIGIT DESC "

	If Select("CAD") > 0
		CAD->(dbCloseArea())
	EndIf

	tcQuery cQueryCad new alias "CAD"

	tcSetField("CAD","D1_DTDIGIT","D")

	Count To nCount

	dbSelectArea("CAD")
	dbGoTop()

	procRegua(nCount)
	while CAD->(!eof())
		incProc()
		recLock("ENT",.T.)
		for nX := 1 to Len(aFields)
			if aFields[nX,2] ='C'
				cX :='ENT->'+aFields[nX,1]+' :=alltrim(CAD->'+aFields[nX,1]+')'
			else
				cX :='ENT->'+aFields[nX,1]+' :=CAD->'+aFields[nX,1]
			endif
			cX :=&cX
		next
		ENT->(msUnLock())
		CAD->(dbSkip())
	endDo
	dbSelectarea("CAD")
	dbCloseArea()

	dbSelectarea("ENT")
	dbGoTop()
	sysRefresh()
return




