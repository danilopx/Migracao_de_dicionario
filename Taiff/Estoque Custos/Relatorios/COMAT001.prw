#Include 'Protheus.ch'
#INCLUDE "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCOMAT001  บ Autor ณ PAULO BINDO        บ Data ณ  14/09/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ MarkBrowse com filtro de produtos para analise de Inventarioฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP5 IDE                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
User Function COMAT001(cProd,cFilPed)

	Local _aArea
	Local cDelFunc
	Local _nX := 0

	Private _cProd := Space(15)
	Private cFilCon
	Private cFilCon2
	Private _cArq	:= "COMAT001.CSV"
	private cArqTRB2 := CriaTrab(NIL,.F.)
	Private aHeader	:= {}
	Private cPerg := "COAT01"
	Private lAbaixo	:= .F.

	_aArea := GetArea()
	cDelFunc := ".T."

	If cProd == NIL
		cProd := ''
	Else
		_cProd := cProd
	Endif

	If Empty(_cProd)
		ValidPerg(cPerg)
		If !Pergunte(cPerg,.T.)
			Return(.T.)
		Endif
	Endif

	cFilCon	:= Iif(ValType(cFilPed)=="U",mv_par04,cFilPed)
	cFilCon2:=  Iif(ValType(cFilPed)=="U",mv_par05,cFilPed)

	Private cCadastro:="Analise de Estoque - Inventario"
	Private cQueryCad := ""
	Private aFields := {}
	Private _cArqTrab := ""
	Private _cIndex := ""
	Private _cCampos  := 'B2_FILIAL, B2_LOCAL, B1_COD, B1_DESC,  B1_UM,B1_TIPO, B1_UCOM, B1_UPRC, D2_EMISSAO, B2_QEMP, B2_QATU'
	Private _aArqSel  := {'SB1', 'SD2'}
	Private _cArqSel2 := ''

	For _nX := 1 To Len(_aArqSel)
		_cArqSel2 += RetSqlName(_aArqSel[_nX])+ ' ' + _aArqSel[_nX] + ' '+IIf(_nX<>Len(_aArqSel),', ',' ')
	Next

	Private _cMes1, _cMes2, _cMes3

	If Month(dDataBase) = 1
		_cMes1 := Str(Val(Str(Year(dDatabase)-1,4)+StrZero(12,2)),6)
		_cMes2 := Str(Val(Str(Year(dDatabase)-1,4)+StrZero(11,2)),6)
		_cMes3 := Str(Val(Str(Year(dDatabase)-1,4)+StrZero(10,2)),6)
	ElseIf Month(dDataBase) = 2
		_cMes1 := Str(Val(Str(Year(dDatabase),4)+StrZero(1,2)),6)
		_cMes2 := Str(Val(Str(Year(dDatabase)-1,4)+StrZero(12,2)),6)
		_cMes3 := Str(Val(Str(Year(dDatabase)-1,4)+StrZero(11,2)),6)
	ElseIf Month(dDataBase) = 3
		_cMes1 := Str(Val(Str(Year(dDatabase),4)+StrZero(2,2)),6)
		_cMes2 := Str(Val(Str(Year(dDatabase),4)+StrZero(1,2)),6)
		_cMes3 := Str(Val(Str(Year(dDatabase)-1,4)+StrZero(12,2)),6)
	Else
		_cMes1 := Str(Val(Str(Year(dDatabase),4)+StrZero(Month(dDatabase),2))-1,6)
		_cMes2 := Str(Val(Str(Year(dDatabase),4)+StrZero(Month(dDatabase),2))-2,6)
		_cMes3 := Str(Val(Str(Year(dDatabase),4)+StrZero(Month(dDatabase),2))-3,6)
	Endif


	aCampos := {}
	AADD(aCampos,{'Filial'    ,'B2_FILIAL' 	,'C',02,0,''})
	AADD(aCampos,{'Local'     ,'B2_LOCAL'  	,'C',02,0,''})
	AADD(aCampos,{'Codigo'    ,'B1_COD'    	,'C',15,0,''})
	AADD(aCampos,{'Descricao' ,'B1_DESC'   	,'C',90,0,''})
	AADD(aCampos,{'Tipo'	  ,'B1_TIPO'   	,'C',02,0,''})
	AADD(aCampos,{'Un'	      ,'B1_UM'     	,'C',05,0,''})
	AADD(aCampos,{'Saldo'     ,'B2_QATU'   	,'N',09,0,''})
	AADD(aCampos,{'Saldo Disp.','ESTOQUE'  	,'N',09,0,''})
	AADD(aCampos,{'Empenho'   ,'B2_QEMP'   	,'N',09,0,''})
	AADD(aCampos,{'U.Venda'   ,'D2_EMISSAO'	,'D',08,0,''})
	AADD(aCampos,{'Ped.Aprov' ,'PEDAPROV'	,'N',09,0,''})
	AADD(aCampos,{'Ped.Bloq.' ,'PEDBLOQ'	,'N',09,0,''})
	AADD(aCampos,{'Media'     ,'MEDIA'     	,'N',09,0,''})
	AADD(aCampos,{'D Invent'  ,'DIAS'      	,'N',08,0,''})
	AADD(aCampos,{'Vlr.U.Cp.' ,'B1_UPRC'   	,'N',10,2,"@E 999,999.99"})
	AADD(aCampos,{'U.Compra'  ,'B1_UCOM'   	,'D',08,0,''})
	AADD(aCampos,{'Comprador' ,'Y1_NOME'   	,'C',15,0,''})

	aCamposMB := {}
	For _nX := 1 To Len(aCampos)
		AaDd(aCamposMB,{aCampos[_nX,1],aCampos[_nX,2],aCampos[_nX,3],aCampos[_nX,4]/2,aCampos[_nX,5],aCampos[_nX,6]})
	Next


	Cria_TMP()
	DbSelectArea('TRB2')


	Private aRotina := { 	{"Pesquisa"    ,'U_PesqSB1()' , 0, 1},;
		{"Posicao"       ,'u_RESTC03(TRB2->B1_COD,TRB2->B2_FILIAL,TRB2->B2_LOCAL)' , 0, 2},;
		{"Vendas"        ,'u_COAT01Vnd(TRB2->B1_COD)' , 0, 2},;
		{"Legenda"       ,'U_VeLegB()' , 0, 2},;
		{"Relatorio"	 ,'u_COAT01Rel()', 0,2}}



	Private aCores := {{ '(TRB2->ESTOQUE == 0)', 'BR_PRETO'},;
		{ '(TRB2->DIAS <= 60)' , 'BR_VERDE'},;
		{ '(TRB2->DIAS >= 60 .AND. TRB2->DIAS <= 90)' , 'BR_AMARELO'},;
		{ '(TRB2->DIAS > 90)', 'BR_VERMELHO'}}

	Processa({|| Monta_TMP() } ,"Selecionando Informacoes dos Produtos...")

	mBrowse( 6,1,22,75,"TRB2",aCamposMB,,,,,aCores)

	DbSelectArea("TRB2")
	DbCloseArea()
	If File(_cArqTrab+".DBF")
		FErase(_cArqTrab+".DBF")
	Endif
	If File(_cIndex+ordbagext())
		FErase(_cIndex+ordbagext())
	Endif

Return(nil)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCOMAT001  บAutor  ณMicrosiga           บ Data ณ  04/18/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static FUNCTION Cria_TMP()

	Local _nX := 0

	aFields := {}
	For _nX := 1 To Len(aCampos)
		AADD(aFields,{aCampos[_nX,2],aCampos[_nX,3],aCampos[_nX,4],aCampos[_nX,5]})
	Next
	_cArqTrab:=Criatrab(aFields,.T.)
	DBUSEAREA(.t.,,_cArqTrab,"TRB2")
Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCOMAT001  บAutor  ณMicrosiga           บ Data ณ  04/18/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Monta_TMP()

	Local _nX := 0

	cQueryCad := " SELECT DISTINCT "
	cQueryCad += " B2_FILIAL, B2_LOCAL, B2_SALPEDI, B1_COD, B1_DESC, B1_UM, B1_TIPO, B1_UCOM, B1_UPRC, B2_QEMP, B2_QATU, "

	cQueryCad += " (SELECT TOP 1 Y1_NOME FROM "+RetSqlName("ZZK")+" ZZK
	cQueryCad += " INNER JOIN "+RetSqlName("SY1")+" Y1 ON Y1_COD = ZZK_CODGRP AND Y1_FILIAL = ZZK_FILIAL
	cQueryCad += " WHERE  B1_GRUPO >= ZZK_GRPPRD  AND B1_GRUPO <= ZZK_GRPFIM AND ZZK_FILIAL = B1_FILIAL
	cQueryCad += " AND Y1.D_E_L_E_T_ <> '*'  AND ZZK.D_E_L_E_T_ <> '*') Y1_NOME,"

	cQueryCad += " ISNULL((SELECT TOP 1 D2_EMISSAO"
	cQueryCad += " 	FROM "+RetSqlName("SD2")+" D2 WITH(NOLOCK)"
	cQueryCad += " 	INNER JOIN "+RetSqlName("SF4")+" F4 WITH(NOLOCK)ON F4_CODIGO = D2_TES "+Iif(cEmpAnt=="03"," AND F4_FILIAL = D2_FILIAL","")
	cQueryCad += " 	WHERE"
	cQueryCad += " 	B2_COD = D2_COD AND B2_FILIAL = D2_FILIAL AND D2_LOCAL = B2_LOCAL "
	cQueryCad += " 	AND F4_ESTOQUE = 'S' "
	cQueryCad += " 	AND D2_FILIAL = B2_FILIAL  AND D2.D_E_L_E_T_ <> '*' AND F4.D_E_L_E_T_ <> '*' "
	cQueryCad += " 	ORDER BY D2_EMISSAO DESC),'') D2_EMISSAO"
	cQueryCad += " FROM "+RetSqlName("SB2")+" B2"
	cQueryCad += " INNER JOIN "+RetSqlName("SB1")+" B1 ON B1_COD = B2_COD  AND B1_FILIAL = B2_FILIAL "
	cQueryCad += " WHERE "
	cQueryCad += " B1.D_E_L_E_T_ <> '*' AND B2.D_E_L_E_T_ <> '*' "
	cQueryCad += " AND B1_MSBLQL <> '1' "
	cQueryCad += " AND B2_FILIAL BETWEEN '"+cFilCon+"' AND '"+cFilCon2+"'"



//FILTRA POR GRUPO DE PRODUTO
	If !Empty(mv_par14)
		cQueryCad += " AND B1_GRUPO = '"+mv_par14+"'"
	EndIf

//FILTRA POR COMPRADOR
	If !Empty(mv_par07)
		cQueryCad += " AND B1_GRUPO IN (SELECT ZZK_GRPPRD FROM "+RetSqlName("ZZK")+" ZZK
		cQueryCad += " INNER JOIN "+RetSqlName("SY1")+" Y1 ON Y1_COD = ZZK_CODGRP AND Y1_FILIAL = ZZK_FILIAL
		cQueryCad += " WHERE  B1_GRUPO >= ZZK_GRPPRD  AND B1_GRUPO <= ZZK_GRPFIM AND ZZK_FILIAL = B1_FILIAL
		cQueryCad += " AND Y1.D_E_L_E_T_ <> '*'  AND ZZK.D_E_L_E_T_ <> '*' AND Y1_COD = '"+mv_par07+"')"
	EndIf


	If  !Empty(MV_PAR02)
		cQueryCad += " AND B1_COD BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"'"
	Endif

//FILTRA ALMOXARIFADO
	cQueryCad += " AND B2_LOCAL BETWEEN '"+mv_par08+"' AND '"+mv_par09+"'"

//FILTRA PRODUTOS QUA NAO SAO VENDIDOS HA MAIS DE 6 MESES
	If mv_par11 == 2
		//VENDAS
		If mv_par12 == 2
			cQueryCad += " 	AND B2_COD NOT IN (SELECT D2_COD "
			cQueryCad += " 	FROM "+RetSqlName("SD2")+" D2 WITH(NOLOCK)"
			cQueryCad += " 	INNER JOIN "+RetSqlName("SF4")+" F4 WITH(NOLOCK)ON F4_CODIGO = D2_TES "+Iif(cEmpAnt=="03"," AND F4_FILIAL = D2_FILIAL","")
			cQueryCad += " 	WHERE"
			cQueryCad += " 	B2_COD = D2_COD AND B2_FILIAL = D2_FILIAL AND D2_LOCAL = B2_LOCAL "
			cQueryCad += " 	AND F4_ESTOQUE = 'S' "
			cQueryCad += " 	AND D2_FILIAL = B2_FILIAL  AND D2.D_E_L_E_T_ <> '*' AND F4.D_E_L_E_T_ <> '*' "
			cQueryCad += " 	AND DATEDIFF(DAY,D2_EMISSAO,'"+Dtos(dDataBase)+"')<180) AND B2_QATU > 0"
		Else	//PRODUCAO
			cQueryCad += " 	AND B2_COD NOT IN (SELECT D3_COD "
			cQueryCad += " 	FROM "+RetSqlName("SD3")+" D3 WITH(NOLOCK)"
			cQueryCad += " 	WHERE"
			cQueryCad += " 	B2_COD = D3_COD AND B2_FILIAL = D3_FILIAL "
			cQueryCad += " 	AND D3_FILIAL = B2_FILIAL  AND D3.D_E_L_E_T_ <> '*' AND B2.D_E_L_E_T_ <> '*' "
			cQueryCad += " 	AND DATEDIFF(DAY,D3_EMISSAO,'"+Dtos(dDataBase)+"')<180) AND B2_QATU > 0"
		EndIf
	EndIf


	cQueryCad += " ORDER BY B1_COD "


	MemoWrite("COMAT001.SQL",cQueryCad)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQueryCad),"CAD")

	Count To _nCount

	TcSetField('CAD','B1_UCOM','D')
	TcSetField('CAD','D2_EMISSAO','D')

	Dbselectarea("CAD")
	DbGoTop()
	ProcRegua(_nCount)

	While CAD->(!EOF())
		IncProc()
		dbSelectArea("SB2")
		dbSetOrder(1)
		dbSeek(CAD->B2_FILIAL+CAD->B1_COD)
		nRecB2 := Recno()

		nTerceiro :=0
		While !Eof() .And. SB2->B2_COD == CAD->B1_COD .And. SB2->B2_FILIAL == CAD->B2_FILIAL
			nTerceiro += SB2->B2_QNPT+SB2->B2_QTER
			dbSkip()
		End

		//POSICIONA NO LOCAL
		dbSeek(CAD->B2_FILIAL+CAD->B1_COD+CAD->B2_LOCAL)

		nEstq := SaldoMov()+SB2->B2_QACLASS-SB2->B2_QPEDVEN-SB2->B2_QEMP+nTerceiro

		//BUSCA OS CONSUMOS MENSAIS
		aMes := {}
		_nMedia := 0
		nQuant := 0

		DbSelectArea('SB3')
		DbSetOrder(1)
		If DbSeek(CAD->B2_FILIAL+CAD->B1_COD)
			_nMedia  := SB3->B3_MEDIA
		EndIf


		nDias := If(nEstq > 0 .And. _nMedia > 0,(nEstq  / (_nMedia / 22)),0)
		//FILTRA QUANDO O NUMERO DE DIAS FOR MAIOR QUE ZERO
		If mv_par06 > 0 .And. nDias < mv_par06
			dbSelectArea("CAD")
			dbSkip()
			Loop
		EndIf


		//FILTRA SOMENTE MEDIA ZERO
		If mv_par10  == 1  .And. _nMedia > 0
			dbSelectArea("CAD")
			dbSkip()
			Loop
		EndIf

		//EXCLUI MEDIA ZERO
		If mv_par10  == 2  .And. _nMedia == 0
			dbSelectArea("CAD")
			dbSkip()
			Loop
		EndIf

		RecLock("TRB2",.T.)
		For _nX := 1 To Len(aFields)
			If !aFields[_nX,1]$'ESTOQUE/MEDIA/DIAS/PROMOCAO|PEDBLOQ|PEDAPROV'
				If aFields[_nX,2] = 'C'
					_cX := 'TRB2->'+aFields[_nX,1]+' := Alltrim(CAD->'+aFields[_nX,1]+')'
				Else
					_cX := 'TRB2->'+aFields[_nX,1]+' := CAD->'+aFields[_nX,1]
				Endif
				_cX := &_cX
			Endif
		Next
		//ZERA A ULTIMA COMPRA PARA BUSCAR DAS NOTAS
		TRB2->B1_UPRC := CAD->B1_UPRC
		TRB2->B1_UCOM := CAD->B1_UCOM
		_nUltCompra := 0


		cQuery := " SELECT TOP 1 * FROM "+RetSqlName("SD1")+" D1"
		cQuery += " INNER JOIN  "+RetSqlName("SF4")+" F4"
		cQuery += " ON F4_CODIGO = D1_TES "+Iif(cEmpAnt=="03"," AND F4_FILIAL = D1_FILIAL","")
		cQuery += " WHERE D1_COD = '"+SB2->B2_COD+"'  AND D1.D_E_L_E_T_ <> '*' AND F4.D_E_L_E_T_ <> '*' AND D1_TIPO = 'N'"
		cQuery += " AND D1_FILIAL = '"+CAD->B2_FILIAL+"' AND F4_DUPLIC = 'S'"
		cQuery += " ORDER BY D1_DTDIGIT DESC"

		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TRBSD1")

		tcSetField("TRBSD1","D1_DTDIGIT","D")

		Count To nRec

		If nRec > 0
			dbSelectArea("TRBSD1")
			dbGoTop()

			_nUltCompra := (TRBSD1->D1_VUNIT*(1-(TRBSD1->D1_DESC/100))) + Round((TRBSD1->D1_VUNIT * TRBSD1->D1_IPI)/100,2)+(TRBSD1->D1_ICMSRET/TRBSD1->D1_QUANT)
			TRB2->B1_UPRC := _nUltCompra
			TRB2->B1_UCOM := TRBSD1->D1_DTDIGIT
		EndIf
		TRBSD1->(dbCloseArea())

		//VERIFICA PEDIDOS DE COMPRAS COM BLOQUEIO
		cQuery := " SELECT SUM(C7_QUANT) C7_QUANT FROM "+RetSqlName("SC7")
		cQuery += " WHERE C7_PRODUTO = '"+SB2->B2_COD+"' AND D_E_L_E_T_ <> '*'"
		cQuery += " AND C7_FILIAL = '"+CAD->B2_FILIAL+"' AND C7_CONAPRO = 'B'"
		cQuery += " AND C7_RESIDUO = '' "

		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TRBC7")

		Count To nRec
		nPedBloq := 0
		If nRec > 0
			dbSelectArea("TRBC7")
			dbGoTop()
			nPedBloq := TRBC7->C7_QUANT
		EndIf
		TRBC7->(dbCloseArea())
		TRB2->PEDAPROV := Iif(SB2->B2_SALPEDI-nPedBloq <0,0,SB2->B2_SALPEDI-nPedBloq)
		TRB2->PEDBLOQ  := Iif(nPedBloq <0,0,nPedBloq)
		TRB2->ESTOQUE := nEstq
		TRB2->MEDIA := _nMedia
		TRB2->DIAS  := IIf(TRB2->ESTOQUE > 0 .And. TRB2->MEDIA > 0,(TRB2->ESTOQUE  / (TRB2->MEDIA / 22)),0)

		dbSelectArea("SB2")
		cFilOld := xFilial("SB2")
		cFilAnt := CAD->B2_FILIAL

		cFilAnt := cFilOld

		dbSelectArea("CAD")

		TRB2->(MsUnLock())
		CAD->(dBSkip())
	EndDo
	Dbselectarea("CAD")
	DbCloseArea()
	Dbselectarea("TRB2")
	DbGoTop()

	_cIndex:=Criatrab(Nil,.F.)
	If MV_PAR03 = 2
		_cChave:='B1_COD'
	ElseIf MV_PAR03 = 1
		_cChave:='B1_DESC'
	Endif
	Indregua("TRB2",_cIndex,_cChave,,,"Ordenando registros selecionados...")
	DbSetIndex(_cIndex+ordbagext())
	Dbselectarea("TRB2")
	SysRefresh()
Return




/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCOMAT001  บAutor  ณMicrosiga           บ Data ณ  06/30/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function VeLegB()
	aCorDesc := {{'BR_VERDE'     ,'Menor que 60 Dias'},;
		{'BR_VERMELHO','Acima de 90 Dias' },;
		{'BR_AMARELO' ,'Entre 60 e 90 Dias'},;
		{'BR_PRETO' ,'Restrito sem saldo'}}

	BrwLegenda( "Legenda", "Status", aCorDesc )
Return( .T. )


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCOMAT001  บAutor  ณMicrosiga           บ Data ณ  12/12/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User FUNCTION PesqSB1()
	_cPesqCod := Space(8)
	_cPesqDes := Space(40)
	@ 220,005 TO 320,226 DIALOG oDlgPesC TITLE 'Pesquisa Produtos'
	@ 003,002 SAY 'Codigo'
	@ 002,020 GET _cPesqCod   SIZE 89,15 PICTURE "@!" VALID PesquiPro(_cPesqCod)
	@ 018,002 SAY 'Descricao'
	@ 017,020 GET _cPesqDes   SIZE 89,15 PICTURE "@!" VALID PesquiPro(_cPesqDes)
	@ 030,038 BUTTON "_Ok" SIZE 40,15 ACTION Close(oDlgPesC)
	ACTIVATE DIALOG oDlgPesC CENTERED
Return(.T.)



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCOMAT001  บAutor  ณMicrosiga           บ Data ณ  12/12/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static FUNCTION PesquiPro(_cPesq)
	If !Empty(_cPesq)
		If Len(_cPesq) = 8
			DbSelectArea('TRB2')
			If DbSeek(Rtrim(_cPesq))
				Close(oDlgPesC)
				SysRefresh()
			Else
				MsgBox("Codigo Nao Encontrada!")
				_cPesqCod := Space(8)
				DbSelectArea('TRB2')
				DbGoTop()
			Endif
		Else
			DbSelectArea('SB1')
			DbSetOrder(2)
			If DbSeek(xFilial('SB1')+_cPesq)
				DbSelectArea('TRB2')
				If DbSeek(Rtrim(SB1->B1_COD))
					Close(oDlgPesC)
					SysRefresh()
				Else
					MsgBox("Descricao Nao Encontrada!")
					DbSelectArea('TRB2')
					DbGoTop()
				Endif
			Else
				MsgBox("Descricao Nao Encontrada!")
				DbSelectArea('TRB2')
				DbGoTop()
			Endif
		Endif
	Endif
Return(.T.)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCOMAT001  บAutor  ณMicrosiga           บ Data ณ  04/18/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function COAT01Vnd(cProd)
//01       ฆ Data Inicial dos Movimentos ?
//02       ฆ Data Final dos Movimentos ?
//03       ฆ Qual Armazem ?
//04       ฆ Saldo Item a Item ?
//05       ฆ Qual Moeda ?
//06       ฆ Mostra o Endereco do Produto ?
//07       ฆ Sequencia da Consulta ?
//08       ฆ Listar as Transf. do Produto ?

	Local _nX := 0
//Pergunte('MTC030',.F.)
	@ 050,005 TO 550,780 DIALOG oDlgPedL TITLE "50 ฺltimas de Movimentacoes de " + cProd

	aCampos:={}
	AADD(aCampos,{'200','KD_DAT','EMISSAO'     ,'@!','10','0'})
	AADD(aCampos,{'201','KD_DOC','NOTA'  ,'@!','08','0'})
	AADD(aCampos,{'202','KD_CLF','CLIENTE','@!','40','0'})
	AADD(aCampos,{'203','KD_QTS','QTDE'    ,'99999999','8','0'})
	AADD(aCampos,{'204','KD_VND','VENDEDOR(A)' ,'@!','10','0'})
	AADD(aCampos,{'205','KD_CFO','CFO'  	,'@!','04','0'})
	ASort(aCampos,,,{|x,y|x[1]<y[1]})

	aCampos2 := {}
	For _nX := 1 To Len(aCampos)
		AADD(aCampos2,{aCampos[_nX,2],aCampos[_nX,3],aCampos[_nX,4],aCampos[_nX,5],aCampos[_nX,6]})
	Next
	aCampos := {}
	aCampos := aCampos2
	Cria_KDX()
	DbSelectArea('KDX')

	@ 006,005 TO 230,385 BROWSE "KDX"  FIELDS aCampos Object _oBrwPed
//@ 235,247 BUTTON "_Imprimir"        SIZE 40,15 ACTION ImpRKDX()
	@ 235,347 BUTTON "_Sair"            SIZE 40,15 ACTION Close(oDlgPedL)

	Processa({|| Monta_KDX(cProd) } ,"Buscando Movimentacoes...")

	ACTIVATE DIALOG oDlgPedL CENTERED

	DbSelectArea("KDX")
	DbCloseArea()
	If File(_cArqTrab+".DBF")
		FErase(_cArqTrab+".DBF")
	Endif
//If File(_cIndex+ordbagext())
//	FErase(_cIndex+ordbagext())
//Endif
Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCOMAT001  บAutor  ณMicrosiga           บ Data ณ  04/18/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function COAT01Rel()
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de Variaveis ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	Private aOrd 		 := {}
	Private cDesc1       := "Este programa tem como objetivo imprimir relatorio "
	Private cDesc2       := "de acordo com os parametros informados pelo usuario."
	Private cDesc3       := "Pedidos/Notas Fiscais Transportadora"
	Private cPict        := ""
	Private lEnd         := .F.
	Private lAbortPrint  := .F.
	Private limite       := 132
	Private tamanho      := "M"
	Private nomeprog     := "COMAT001" // Coloque aqui o nome do programa para impressao no cabecalho
	Private nTipo        := 18
	Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
	Private nLastKey     := 0
	Private titulo       := "Pedidos/Notas Fiscais Transportadora"
	Private nLin         := 80
	Private Cabec1       := " N.Ped  N.Fisc Cliente                             Endereco Entrega                         Municipio        Vol Pes Bruto  Tot Nota"
	Private Cabec2       := ""
//0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012
//114637 244434 PETROLEO BRASILEIRO S.A - PETR AV. REPUBLICA DO CHILE,65  2 SUBSOLO     RIO DE JANEIRO          3     13.24      444.79
//123456 123456 123456789012345678901234567890 1234567890123456789012345678901234567890 12345678901234567890 9999  9999.999 9999.999,99
	Private cbtxt        := Space(10)
	Private cbcont       := 00
	Private CONTFL       := 01
	Private m_pag        := 01
	Private imprime      := .T.
	Private wnrel        := "COMAT001" // Coloque aqui o nome do arquivo usado para impressao em disco
	Private nFatur       := 0
	Private cCond        := ""
	Private nOrdem       := 0
	Private cArqDbf      := ""
	Private cArqNtx      := ""
	Private cString      := "SC9"
	Private nFatGeral    := 0
	Private c2Perg		 := "RCOM11"

	Valid2Perg(c2Perg)



	dbSelectArea("TRB2")
	dbGoTop()



//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Verifica as perguntas selecionadas  ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	Pergunte(c2Perg,.F.)
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Monta a interface padrao com o usuario... ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	wnrel := SetPrint(cString,NomeProg,c2Perg,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

	If nLastKey == 27
		Return
	Endif

	SetDefault(aReturn,cString)

	If nLastKey == 27
		Return
	Endif

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Processamento. RPTSTATUS monta janela com a regua de processamento. ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	RptStatus({|| RptDetail() })
	If nLastKey == 27
		Return
	Endif
Return .t.




/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCOMAT001  บAutor  ณMicrosiga           บ Data ณ  12/12/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static FUNCTION Cria_Kdx()

	aFields := {}

	AADD(aFields,{"KD_DAT"     ,"D",08,0})
	AADD(aFields,{"KD_DOC"     ,"C",08,0})
	AADD(aFields,{"KD_CLF"     ,"C",40,0})
	AADD(aFields,{"KD_CFO"     ,"C",04,0})
	AADD(aFields,{"KD_QTS"     ,"N",08,0})
	AADD(aFields,{"KD_VND"     ,"C",10,0})
	AADD(aFields,{"KD_UNI"     ,"N",10,2})
	AADD(aFields,{"KD_TOT"     ,"N",12,2})

	cArq:=Criatrab(aFields,.T.)
	DBUSEAREA(.t.,,cArq,"KDX")
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCOMAT001  บAutor  ณMicrosiga           บ Data ณ  04/18/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Monta_KDX(cProd)
	// Local _nMesAnterior := 0
	// Local _nAno := 0
	// Local  _nSaldo := 0
	// Local _Data_Saldo_In := dDataBase
	Local _nX := 0
	Local _nCount

//_nMesAnterior := StrZero(Iif((Month(MV_PAR05)-1) <= 0, 12,(Month(MV_PAR05)-1)),2)
//_nAno         := Iif((Month(MV_PAR05)-1) <= 0, Str(Year(MV_PAR05)-1,4),Str(Year(MV_PAR05),4))

//_Data_Saldo_In := DtoS(CtoD("01/"+_nMesAnterior+"/"+_nAno))

	_nCount := 0
	cQueryCad := ""
	For _nX := 2 To 2
		If _nX = 1
			//       cQueryCad := "SELECT TOP 50 COUNT(*) AS TOTAL FROM "+RetSqlName('SD1')+" D1 WHERE "
		Else
			cQueryCad += "SELECT TOP 50 D2_EMISSAO EMISSAO, "
			cQueryCad += "D2_DOC DOCTO, "
			cQueryCad += "D2_QUANT QTDE, "
			cQueryCad += "D2_PRCVEN VLR_UNIT, "
			cQueryCad += "D2_TOTAL VLR_TOTAL, "
			cQueryCad += "ISNULL((SELECT TOP 1 A1_NOME FROM "+RetSqlName('SA1')+" A1 WHERE A1_COD = D2_CLIENTE),(SELECT TOP 1 A2_NOME FROM "+RetSqlName('SA2')+" A2 WHERE A2_COD = D2_CLIENTE)) FORN_CLIENTE, "
			cQueryCad += "D2_CF CFO, "
			cQueryCad += "A3_NREDUZ VENDEDOR "
			cQueryCad += "FROM "+RetSqlName('SD2')+" AS D2, "+RetSqlName('SF4')+" AS F4 , "+RetSqlName('SF2')+" AS F2 , "+RetSqlName('SA3')+" AS A3 "
			cQueryCad += "WHERE "
		Endif
		cQueryCad += "D2.D_E_L_E_T_ = '' AND "
		cQueryCad += "F4.D_E_L_E_T_ = '' AND "
		cQueryCad += "F2.D_E_L_E_T_ = '' AND "
		cQueryCad += "A3.D_E_L_E_T_ = '' AND "
		//	cQueryCad += "D2_EMISSAO >= '" + DTOS(MV_PAR05)+ "' AND D2_EMISSAO <= '" + DTOS(MV_PAR06)+ "' AND "
		cQueryCad += "D2_COD = '" + cProd + "' AND "
		cQueryCad += "D2.D2_TES = F4.F4_CODIGO AND "
		cQueryCad += "D2.D2_DOC = F2.F2_DOC AND "
		cQueryCad += "A3.A3_COD = F2.F2_VEND1 AND "
		cQueryCad += "F2_FILIAL = D2_FILIAL "+Iif(cEmpAnt=="03"," AND F4_FILIAL = D2_FILIAL","")+" AND "
		cQueryCad += "F4.F4_ESTOQUE = 'S' AND "
		cQueryCad += "D2.D2_TIPO = 'N' AND "
		cQueryCad += "F2_FILIAL = '"+TRB2->B2_FILIAL+"' "
		cQueryCad += "ORDER BY D2_EMISSAO DESC"

		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQueryCad),"CAD")

		TcSetField('CAD','EMISSAO','D')
		If _nX = 1
			_nCount := CAD->TOTAL
			DbCloseArea()
		Endif
	Next

	_nSaldo := 0 // Posicione('SB9',1,xFilial('SB9')+PadR(cProd,15)+"01"+Left(_Data_Saldo_In,6),'B9_QINI')
	_nSaida := 0
	_nEntrada := 0


	Dbselectarea("CAD")
	DbGoTop()
//ProcRegua(_nCount)

	While CAD->(!EOF())
		//	IncProc()

		dbSelectArea('KDX')

		RecLock("KDX",.T.)
		KDX->KD_DAT := CAD->EMISSAO
		KDX->KD_DOC := CAD->DOCTO
		KDX->KD_CLF := CAD->FORN_CLIENTE
		KDX->KD_CFO := CAD->CFO
		KDX->KD_QTS := CAD->QTDE
		KDX->KD_VND := CAD->VENDEDOR
		KDX->KD_UNI := CAD->VLR_UNIT
		KDX->KD_TOT := CAD->VLR_TOTAL
		KDX->(MsUnLock())


		CAD->(dBSkip())
	EndDo

/*
RecLock("KDX",.T.)
KDX->KD_DAT := CTOD(_Data_Saldo_In)
KDX->KD_DOC := "________"
KDX->KD_CLF := "TOTAIS...."
KDX->KD_SLD := _nSaldo
KDX->KD_QTE := _nEntrada
KDX->KD_QTS := _nSaida
MsUnLock()
*/

	Dbselectarea("CAD")
	DbCloseArea()
	Dbselectarea("KDX")
	DbGoTop()

//_cIndex:=Criatrab(Nil,.F.)
//_cChave:="DTOC(KD_DAT)+KD_DOC"
//Indregua("KDX",_cIndex,_cChave,,,"Ordenando registros selecionados...")
//DbSetIndex(_cIndex+ordbagext())

	SysRefresh()
Return




/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCOMAT001  บAutor  ณMicrosiga           บ Data ณ  12/12/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static function rptdetail

	Local x := 0
	cabec1:="Fl Codigo   Descricao do Produto                     Marc Un  Saldo  Media D Inv. Reposicao   Ult Cmp   Dt U.Cmp Promocao"
	cabec2:=""

//Fl Codigo   Descricao do Produto                     Marc Un  Saldo  Media D Inv. Reposicao   Ult Cmp   Dt U.Cmp Promocao"
//99 99999999 1234567890123456789012345678901234567890 1234 12 999999 999999 999999 99,999.99 99,999.99 99/99/9999 X
//0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
//          1         2         3         4         5         6         7         8         9        10        11
//SetDefault(aReturn,cString)
	_nLin := 80
	setprc(0,0)
	setregua(RecCount())
	_nRegs := 0
	If mv_par03 == 2
		do while TRB2->(!eof())
			If TRB2->DIAS >= MV_PAR01 .And. TRB2->DIAS <= MV_PAR02

				_nRegs++


				incregua()

				if _nLin>=55
					Cabec(titulo,cabec1,cabec2,nomeprog,tamanho,18)
					_nLin := 8
					++_nLin
				endif

				@ _nLin,000 PSAY TRB2->B2_FILIAL
				@ _nLin,003 PSAY TRB2->B1_COD
				@ _nLin,012 PSAY Left(TRB2->B1_DESC,45)
				If Len(AllTrim(TRB2->B1_DESC)) > 45
					_nLin++
					@ _nLin,012 PSAY SubStr(TRB2->B1_DESC,46,45)
				EndIf
				@ _nLin,058 PSAY Left(TRB2->B1_UM,2)

				@ _nLin,061 PSAY TRB2->ESTOQUE Picture "999999"
				@ _nLin,068 PSAY TRB2->MEDIA   Picture "999999"
				@ _nLin,075 PSAY TRB2->DIAS    Picture "999999"
				//@ _nLin,082 PSAY TRB2->ZZ_PYPRCL Picture "@EZ 99,999.99"
				@ _nLin,092 PSAY TRB2->B1_UPRC   Picture "@EZ 99,999.99"
				@ _nLin,102 PSAY DtoC(TRB2->B1_UCOM)
				//@ _nLin,113 PSAY TRB2->PROMOCAO

				_nLin++
			Endif

			TRB2->(dbskip(1))
		enddo
		@ _nLin+=2,19 PSAY 'Qtde de Itens -> '
		@ _nLin ,58 PSAY _nRegs Picture "999999"

		If aReturn[5] == 1
			Set Printer To
			Commit
			ourspool(wnrel)
		Endif
		MS_FLUSH()
	Else
		AbreArq()
		dbSelectArea("TRB2")
		dbGoTop()
		do while !EOF()
			If TRB2->DIAS >= MV_PAR01 .And. TRB2->DIAS <= MV_PAR02
				_nRegs++
				IncRegua()
				If lAbortPrint
					@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
					Exit
				Endif
				dbSelectArea("TRB3")
				RecLock("TRB3",.T.)
				FILIAL		:= TRB2->B2_FILIAL
				CODIGO		:= TRB2->B1_COD
				DESCRICAO	:= TRB2->B1_DESC
				UNIDADE		:= Left(TRB2->B1_UM,2)
				SALDO		:= TRB2->ESTOQUE
				MEDIA		:= TRB2->MEDIA
				DINV		:= TRB2->DIAS
				ULT_COMP	:= TRB2->B1_UPRC		//TransForm(_aAtuali[_nX,4],"@E 999.99"),Arial36,100  )
				DT_UCOMP	:= TRB2->B1_UCOM
				COMPRADOR   := TRB2->Y1_NOME
				DbSelectArea('SB3')
				DbSetOrder(1)
				If DbSeek(TRB2->B2_FILIAL+TRB2->B1_COD)

					dbSelectArea("TRB3")

					MES01		:= SB3->B3_Q01
					MES02		:= SB3->B3_Q02
					MES03		:= SB3->B3_Q03
					MES04		:= SB3->B3_Q04
					MES05		:= SB3->B3_Q05
					MES06		:= SB3->B3_Q06
					MES07		:= SB3->B3_Q07
					MES08		:= SB3->B3_Q08
					MES09		:= SB3->B3_Q09
					MES10		:= SB3->B3_Q10
					MES11		:= SB3->B3_Q11
					MES12		:= SB3->B3_Q12
				Else
					dbSelectArea("TRB3")

					MES01		:= 0
					MES02		:= 0
					MES03		:= 0
					MES04		:= 0
					MES05		:= 0
					MES06		:= 0
					MES07		:= 0
					MES08		:= 0
					MES09		:= 0
					MES10		:= 0
					MES11		:= 0
					MES12		:= 0

				EndIf
				TRB3->(MsUnlock())
			EndIf
			dbSelectArea("TRB2")
			dbSkip()
		EndDo

		MSAguarde({|| GeraExcel("TRB3","",aHeader)},"Gerando Planilha Excel...")
		MS_FLUSH()
	EndIf

//LIMPA OS ARQUIVOS TEMPORARIOS DA PASTA EXCEL
	aDirList 	:= {}

	cDirAnexo	:= "C:\EXCEL\" //Sempre colocar barra no final. Ex: "C:\ANEXOS\"
	aDirList 	:= DIRECTORY (cDirAnexo+"*.tmp")
	For x:=1 To Len(aDirList)
		cArqCod := "C:\EXCEL\"+aDirList[x][1]
		Ferase(cArqCod)
	Next

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAbreArq   บAutor  ณFernando Pacheco    บ Data ณ  05/03/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Abre os arquivos necessarios                               บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
static function AbreArq()
	local aStru 	:= {}
	// local _dData
	// local _nDias	:= 1
	// local _cCpoAtu
	// local _ni

	FERASE( "C:\EXCEL\"+_cArq )

	if file(_cArq) .and. ferase(_cArq) == -1
		msgstop("Nใo foi possํvel abrir o arquivo TMKRL001.CSV pois ele pode estar aberto por outro usuแrio.")
		return(.F.)
	endif
// monta arquivo analitico
	aAdd(aStru,{"FILIAL"	,"C",02,0})
	aAdd(aStru,{"COMPRADOR"	,"C",15,0})
	aAdd(aStru,{"REPOS"		,"N",12,2})
	aAdd(aStru,{"DT_UCOMP"	,"D",08,0})
	aAdd(aStru,{"CODIGO"	,"C",15,0})
	aAdd(aStru,{"DESCRICAO"	,"C",90,0})
	aAdd(aStru,{"MARCA"		,"C",15,0})
	aAdd(aStru,{"UNIDADE"	,"C",02,0})
	aAdd(aStru,{"SALDO"		,"N",12,2})
	aAdd(aStru,{"DINV"		,"N",12,2})
	aAdd(aStru,{"MEDIA"		,"N",12,2})
	aAdd(aStru,{"ULT_COMP"	,"N",12,2})
	aAdd(aStru,{"MES01"		,"N",12,2})
	aAdd(aStru,{"MES02"		,"N",12,2})
	aAdd(aStru,{"MES03"		,"N",12,2})
	aAdd(aStru,{"MES04"		,"N",12,2})
	aAdd(aStru,{"MES05"		,"N",12,2})
	aAdd(aStru,{"MES06"		,"N",12,2})
	aAdd(aStru,{"MES07"		,"N",12,2})
	aAdd(aStru,{"MES08"		,"N",12,2})
	aAdd(aStru,{"MES09"		,"N",12,2})
	aAdd(aStru,{"MES10"		,"N",12,2})
	aAdd(aStru,{"MES11"		,"N",12,2})
	aAdd(aStru,{"MES12"		,"N",12,2})



	dbcreate(cArqTRB2,aStru)
	dbUseArea(.T.,,cArqTRB2,"TRB3",.T.,.F.)

	aAdd(aHeader,{"FILIAL"		,"FILIAL"		,"C",02,0})
	aAdd(aHeader,{"COMPRADOR"	,"COMPRADOR"	,"C",15,0})
	aAdd(aHeader,{"CODIGO"		,"CODIGO"		,"C",15,0})
	aAdd(aHeader,{"DESCRICAO"	,"DESCRICAO"	,"C",90,0})
	aAdd(aHeader,{"MARCA"		,"MARCA"		,"C",15,0})
	aAdd(aHeader,{"UNIDADE" 	,"UNIDADE"		,"C",02,0})
	aAdd(aHeader,{"SALDO"		,"SALDO"		,"N",12,2})
	aAdd(aHeader,{"MEDIA"		,"MEDIA"		,"N",12,2})
	aAdd(aHeader,{"DINV"		,"DINV"			,"N",12,2})
	aAdd(aHeader,{"REPOSICAO"	,"REPOS"   		,"N",12,2})
	aAdd(aHeader,{"ULTCOMPRA"	,"ULT_COMP"		,"N",12,2})
	aAdd(aHeader,{"DTUCOMP"		,"DT_UCOMP"		,"D",08,0})
	aAdd(aHeader,{"MES01"		,"MES01"		,"N",12,2})
	aAdd(aHeader,{"MES02"		,"MES02"		,"N",12,2})
	aAdd(aHeader,{"MES03"		,"MES03"		,"N",12,2})
	aAdd(aHeader,{"MES04"		,"MES04"		,"N",12,2})
	aAdd(aHeader,{"MES05"		,"MES05"		,"N",12,2})
	aAdd(aHeader,{"MES06"		,"MES06"		,"N",12,2})
	aAdd(aHeader,{"MES07"		,"MES07"		,"N",12,2})
	aAdd(aHeader,{"MES08"		,"MES08"		,"N",12,2})
	aAdd(aHeader,{"MES09"		,"MES09"		,"N",12,2})
	aAdd(aHeader,{"MES10"		,"MES10"		,"N",12,2})
	aAdd(aHeader,{"MES11"		,"MES11"		,"N",12,2})
	aAdd(aHeader,{"MES12"		,"MES12"		,"N",12,2})


return(.T.)



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณABREDOC   บAutor  ณFernando Pacheco    บ Data ณ  05/03/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Abre o XLS com os dados do fluxo de caixa                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
static function AbreDoc( _cFile )
	LOCAL cDrive     := ""
	LOCAL cDir       := ""

	cTempPath := "C:\Excel\"
	cPathTerm := cTempPath + _cFile

	ferase(cTempPath + _cFile)

	If CpyS2T( "\SYSTEM\"+_cFile, cTempPath, .T. )
		SplitPath(cPathTerm, @cDrive, @cDir )
		cDir := Alltrim(cDrive) + Alltrim(cDir)
		nRet := ShellExecute( "Open" , cPathTerm ,"", cDir , 3 )
	else
		MsgStop("Ocorreram problemas na c๓pia do arquivo.")
	endif

return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGeraExcel บAutor  ณMarcos Zanetti GZ   บ Data ณ  01/11/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Gera Arquivo em Excel e abre                               บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
static function GeraExcel(_cAlias,_cFiltro,aHeader)

	local cDirDocs  := MsDocPath()
	Local cArquivo 	:= _cArq
//Local cPath	:= AllTrim(GetTempPath())
	Local cPath	:= "C:\EXCEL\"
	Local oExcelApp
	Local nHandle
	Local cCrLf 	:= Chr(13) + Chr(10)
	Local nX
	Local _ni := 0

//CRIA DIRETORIO
	MakeDir(Trim(cPath))

	_cFiltro := iif(_cFiltro==NIL, "",_cFiltro)

	if !empty(_cFiltro)
		(_cAlias)->(dbsetfilter({|| &(_cFiltro)} , _cFiltro))
	endif

	nHandle := MsfCreate(cDirDocs+"\"+cArquivo,0)

	If nHandle > 0

		// Grava o cabecalho do arquivo
		aEval(aHeader, {|e, nX| fWrite(nHandle, e[1] + If(nX < Len(aHeader), ";", "") ) } )
		fWrite(nHandle, cCrLf ) // Pula linha

		(_cAlias)->(dbgotop())
		while (_cAlias)->(!eof())

			for _ni := 1 to len(aHeader)

				_uValor := ""

				if aHeader[_ni,3] == "D" // Trata campos data
					_uValor := dtoc(&(_cAlias + "->" + aHeader[_ni,2]))
				elseif aHeader[_ni,3] == "N" // Trata campos numericos
					_uValor := transform((&(_cAlias + "->" + aHeader[_ni,2])),"@E 999999999.99")
				elseif aHeader[_ni,3] == "C" // Trata campos caracter
					_uValor := &(_cAlias + "->" + aHeader[_ni,2])
				endif

				if _ni < (len(aHeader)+1)
					fWrite(nHandle, _uValor + ";" )
				endif

			next _ni

			fWrite(nHandle, cCrLf )

			(_cAlias)->(dbskip())

		enddo

		fClose(nHandle)
		CpyS2T( cDirDocs+"\"+cArquivo, cPath, .T. )

		If ! ApOleClient( 'MsExcel' )
			ShellExecute("open",cPath+cArquivo,"","", 1 )
			TRB2->(dbCloseArea())
			Return
		EndIf

		oExcelApp := MsExcel():New()
		oExcelApp:WorkBooks:Open( cPath+cArquivo ) // Abre uma planilha
		oExcelApp:SetVisible(.T.)

		If MsgYesNo("Deseja fechar a planilha do excel?")
			oExcelApp:Quit()
			oExcelApp:Destroy()
		EndIf
	Else
		MsgAlert("Falha na cria็ใo do arquivo")
	Endif

	(_cAlias)->(dbclearfil())
	TRB3->(dbCloseArea())
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCOMAT001  บAutor  ณMicrosiga           บ Data ณ  06/30/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function VALIDPERG(cPerg)

	Local cKey := ""
	Local aHelpEng := {}
	Local aHelpPor := {}
	Local aHelpSpa := {}

//PutSx1(cGrupo,cOrdem,cPergunt               ,cPerSpa               ,cPerEng               ,cVar	 ,cTipo ,nTamanho,nDecimal,nPresel,cGSC,cValid			,cF3   , cGrpSxg    ,cPyme,cVar01    ,cDef01     ,cDefSpa1,cDefEng1,cCnt01,cDef02    			,cDefSpa2,cDefEng2,cDef03       ,cDefSpa3,cDefEng3,cDef04,cDefSpa4,cDefEng4,cDef05,cDefSpa5,cDefEng5,aHelpPor,aHelpEng,aHelpSpa,cHelp)
	PutSx1(cPerg,"01"   ,"Produto De      	?",""                    ,""                    ,"mv_ch1","C"   ,15      ,0       ,0      , "G",""    			,"SB1" 	,""         ,""   ,"mv_par01",""        	 ,""      ,""      ,""    ,""        		,""     ,""      ,""    	  ,""      ,""      ,""    ,""      ,""     ,""    ,""      ,""      ,""      ,""      ,""      ,"")
	PutSx1(cPerg,"02"   ,"Produto Ate      	?",""                    ,""                    ,"mv_ch2","C"   ,15      ,0       ,0      , "G",""    			,"SB1" 	,""         ,""   ,"mv_par02",""		   	 ,""      ,""      ,""    ,""	        	,""     ,""      ,""  	 	  ,""      ,""      ,""    ,""      ,""     ,""    ,""      ,""      ,""      ,""      ,""      ,"")
	PutSx1(cPerg,"03"   ,"Ordem Desejada	?",""                    ,""                    ,"mv_ch3","N"   ,01      ,0       ,0      , "C",""    			,"SA4"  ,""         ,""   ,"mv_par03","Descricao"	 ,""      ,""      ,""    ,"Codigo" 		,""     ,""      ,""		  ,""      ,""      ,""    ,""      ,""     ,""    ,""      ,""      ,""      ,""      ,""      ,"")
	PutSx1(cPerg,"04"   ,"Da Filial	      	?",""                    ,""                    ,"mv_ch4","C"   ,02      ,0       ,0      , "G",""    			,"SM0" 	,""         ,""   ,"mv_par04",""        	 ,""      ,""      ,""    ,""        		,""     ,""      ,""    	  ,""      ,""      ,""    ,""      ,""     ,""    ,""      ,""      ,""      ,""      ,""      ,"")
	PutSx1(cPerg,"05"   ,"Ate a Filial     	?",""                    ,""                    ,"mv_ch5","C"   ,02      ,0       ,0      , "G",""    			,"SM0" 	,""         ,""   ,"mv_par05",""		   	 ,""      ,""      ,""    ,""	        	,""     ,""      ,""  	 	  ,""      ,""      ,""    ,""      ,""     ,""    ,""      ,""      ,""      ,""      ,""      ,"")
	PutSx1(cPerg,"06"   ,"Dias Inventแrio   ?",""                    ,""                    ,"mv_ch6","N"   ,03      ,0       ,0      , "G",""    			,"" 	,""         ,""   ,"mv_par06",""        	 ,""      ,""      ,""    ,""        		,""     ,""      ,""    	  ,""      ,""      ,""    ,""      ,""     ,""    ,""      ,""      ,""      ,""      ,""      ,"")
	PutSx1(cPerg,"07"   ,"Comprador      	?",""                    ,""                    ,"mv_ch7","C"   ,06      ,0       ,0      , "G",""    			,"SY1" 	,""         ,""   ,"mv_par07",""		   	 ,""      ,""      ,""    ,""	        	,""     ,""      ,""  	 	  ,""      ,""      ,""    ,""      ,""     ,""    ,""      ,""      ,""      ,""      ,""      ,"")
	PutSx1(cPerg,"08"   ,"Do Almoxarifado	?",""                    ,""                    ,"mv_ch8","C"   ,02      ,0       ,0      , "G",""    			,""		,""         ,""   ,"mv_par08",""  			 ,""      ,""      ,""    ,""		 		,""     ,""      ,""		  ,""      ,""      ,""    ,""      ,""     ,""    ,""      ,""      ,""      ,""      ,""      ,"")
	PutSx1(cPerg,"09"   ,"Ate o Almoxarifado?",""                    ,""                    ,"mv_ch9","C"   ,02      ,0       ,0      , "G",""    			,"" 	,""         ,""   ,"mv_par09",""        	 ,""      ,""      ,""    ,""        		,""     ,""      ,""    	  ,""      ,""      ,""    ,""      ,""     ,""    ,""      ,""      ,""      ,""      ,""      ,"")
	PutSx1(cPerg,"10"   ,"Media ZERO     	?",""                    ,""                    ,"mv_cha","N"   ,01      ,0       ,0      , "C",""    			,"" 	,""         ,""   ,"mv_par10","Somente"	   	 ,""      ,""      ,""    ,"Excluir"      	,""     ,""      ,"Ambos" 	  ,""      ,""      ,""    ,""      ,""     ,""    ,""      ,""      ,""      ,""      ,""      ,"")
	PutSx1(cPerg,"11"   ,"+ 6 Meses S/Consumo?",""                    ,""                    ,"mv_chb","N"   ,01      ,0       ,0      , "C",""    			,""	  	,""         ,""   ,"mv_par11","Nao"			 ,""      ,""      ,""    ,"Sim" 			,""     ,""      ,""		  ,""      ,""      ,""    ,""      ,""     ,""    ,""      ,""      ,""      ,""      ,""      ,"")
	PutSx1(cPerg,"12"   ,"Tipo Produto		?",""                    ,""                    ,"mv_chc","N"   ,01      ,0       ,0      , "C",""    			,""	  	,""         ,""   ,"mv_par12","Producao"	 ,""      ,""      ,""    ,"Vendas"			,""     ,""      ,""		  ,""      ,""      ,""    ,""      ,""     ,""    ,""      ,""      ,""      ,""      ,""      ,"")

	cKey     := "P.COAT0101."
	aHelpEng := {}
	aHelpPor := {}
	aHelpSpa := {}
	aAdd(aHelpEng,"")
	aAdd(aHelpEng,"")
	aAdd(aHelpPor,"Informe o Produto ")
	aAdd(aHelpPor,"Inicial")
	aAdd(aHelpSpa,"")
	aAdd(aHelpSpa,"")
	PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa)

	cKey     := "P.COAT0102."
	aHelpEng := {}
	aHelpPor := {}
	aHelpSpa := {}
	aAdd(aHelpEng,"")
	aAdd(aHelpEng,"")
	aAdd(aHelpPor,"Informe o Produto ")
	aAdd(aHelpPor,"final")
	aAdd(aHelpSpa,"")
	aAdd(aHelpSpa,"")
	PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa)


	cKey     := "P.COAT0103."
	aHelpEng := {}
	aHelpPor := {}
	aHelpSpa := {}
	aAdd(aHelpEng,"")
	aAdd(aHelpEng,"")
	aAdd(aHelpPor,"Selecione a ordem que  ")
	aAdd(aHelpPor,"deseja para a apresenta็ใo dos dados na tela")
	aAdd(aHelpSpa,"")
	aAdd(aHelpSpa,"")
	PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa)

	cKey     := "P.COAT0104."
	aHelpEng := {}
	aHelpPor := {}
	aHelpSpa := {}
	aAdd(aHelpEng,"")
	aAdd(aHelpEng,"")
	aAdd(aHelpPor,"Informe a Filial")
	aAdd(aHelpPor,"inicial")
	aAdd(aHelpSpa,"")
	aAdd(aHelpSpa,"")
	PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa)

	cKey     := "P.COAT0105."
	aHelpEng := {}
	aHelpPor := {}
	aHelpSpa := {}
	aAdd(aHelpEng,"")
	aAdd(aHelpEng,"")
	aAdd(aHelpPor,"Informe a Filial")
	aAdd(aHelpPor,"final")
	aAdd(aHelpSpa,"")
	aAdd(aHelpSpa,"")
	PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa)

	cKey     := "P.COAT0106."
	aHelpEng := {}
	aHelpPor := {}
	aHelpSpa := {}
	aAdd(aHelpEng,"")
	aAdd(aHelpEng,"")
	aAdd(aHelpPor,"Informe o minimo dias de Inventแrio")
	aAdd(aHelpPor,"que o produto tem em estoque")
	aAdd(aHelpSpa,"")
	aAdd(aHelpSpa,"")
	PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa)

	cKey     := "P.COAT0107."
	aHelpEng := {}
	aHelpPor := {}
	aHelpSpa := {}
	aAdd(aHelpEng,"")
	aAdd(aHelpEng,"")
	aAdd(aHelpPor,"Selecione a carteira de um comprador")
	aAdd(aHelpPor,"ou deixe em branco para todos")
	aAdd(aHelpSpa,"")
	aAdd(aHelpSpa,"")
	PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa)


	cKey     := "P.COAT0108."
	aHelpEng := {}
	aHelpPor := {}
	aHelpSpa := {}
	aAdd(aHelpEng,"")
	aAdd(aHelpEng,"")
	aAdd(aHelpPor,"Indorme o almoxarifado inicial")
	aAdd(aHelpPor,"ou deixe em branco")
	aAdd(aHelpSpa,"")
	aAdd(aHelpSpa,"")
	PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa)

	cKey     := "P.COAT0109."
	aHelpEng := {}
	aHelpPor := {}
	aHelpSpa := {}
	aAdd(aHelpEng,"")
	aAdd(aHelpEng,"")
	aAdd(aHelpPor,"Informe o almoxarifado final ")
	aAdd(aHelpPor,"ou coloque ZZ")
	aAdd(aHelpSpa,"")
	aAdd(aHelpSpa,"")
	PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa)

	cKey     := "P.COAT0110."
	aHelpEng := {}
	aHelpPor := {}
	aHelpSpa := {}
	aAdd(aHelpEng,"")
	aAdd(aHelpEng,"")
	aAdd(aHelpPor,"Filtra os produtos que  ")
	aAdd(aHelpPor,"tem m้dia Zero")
	aAdd(aHelpSpa,"")
	aAdd(aHelpSpa,"")
	PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa)

	cKey     := "P.COAT0111."
	aHelpEng := {}
	aHelpPor := {}
	aHelpSpa := {}
	aAdd(aHelpEng,"")
	aAdd(aHelpEng,"")
	aAdd(aHelpPor,"Filtra os produtos que  ")
	aAdd(aHelpPor,"nใo sโo vendidos/consumidos hแ mais de 6 meses")
	aAdd(aHelpPor,"deve ser combinado com o parametro TIPO")
	aAdd(aHelpSpa,"")
	aAdd(aHelpSpa,"")
	PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa)

	cKey     := "P.COAT0121."
	aHelpEng := {}
	aHelpPor := {}
	aHelpSpa := {}
	aAdd(aHelpEng,"")
	aAdd(aHelpEng,"")
	aAdd(aHelpPor,"Informe se serใao filtrados")
	aAdd(aHelpPor,"os produtos de Vendas ou de Produ็ใo")
	aAdd(aHelpSpa,"")
	aAdd(aHelpSpa,"")
	PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa)



Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCOMAT001  บAutor  ณMicrosiga           บ Data ณ  06/30/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function VALID2PERG(c2Perg)

	Local cKey := ""
	Local aHelpEng := {}
	Local aHelpPor := {}
	Local aHelpSpa := {}


//PutSx1(cGrupo,cOrdem,cPergunt               ,cPerSpa               ,cPerEng               ,cVar	 ,cTipo ,nTamanho,nDecimal,nPresel,cGSC,cValid			,cF3   , cGrpSxg    ,cPyme,cVar01    ,cDef01     	,cDefSpa1,cDefEng1,cCnt01,cDef02    			,cDefSpa2,cDefEng2,cDef03       ,cDefSpa3,cDefEng3,cDef04,cDefSpa4,cDefEng4,cDef05,cDefSpa5,cDefEng5,aHelpPor,aHelpEng,aHelpSpa,cHelp)
	PutSx1(c2Perg,"01"   ,"D Invent Inicial		?",""                    ,""                    ,"mv_ch1","N"   ,04      ,0       ,0      , "G",""    			,"" 	,""         ,""   ,"mv_par01",""        	,""      ,""      ,""    ,""        		,""     ,""      ,""    	  ,""      ,""      ,""    ,""      ,""     ,""    ,""      ,""      ,""      ,""      ,""      ,"")
	PutSx1(c2Perg,"02"   ,"D Invent Final  		?",""                    ,""                    ,"mv_ch2","N"   ,04      ,0       ,0      , "G",""    			,"" 	,""         ,""   ,"mv_par02",""		   	,""      ,""      ,""    ,""	        	,""     ,""      ,""  	 	  ,""      ,""      ,""    ,""      ,""     ,""    ,""      ,""      ,""      ,""      ,""      ,"")
	PutSx1(c2Perg,"03"   ,"Gera arq. Excel 		?",""                    ,""                    ,"mv_ch3","N"   ,01      ,0       ,0      , "C",""    			,""	  	,""         ,""   ,"mv_par03","Sim"			,""      ,""      ,""    ,"Nโo" 			,""     ,""      ,""		  ,""      ,""      ,""    ,""      ,""     ,""    ,""      ,""      ,""      ,""      ,""      ,"")


	cKey     := "P.RCOM1101."
	aHelpEng := {}
	aHelpPor := {}
	aHelpSpa := {}
	aAdd(aHelpEng,"")
	aAdd(aHelpEng,"")
	aAdd(aHelpPor,"Informe o n๚mero de dias ")
	aAdd(aHelpPor,"de inventแrio inicial")
	aAdd(aHelpSpa,"")
	aAdd(aHelpSpa,"")
	PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa)

	cKey     := "P.RCOM1102."
	aHelpEng := {}
	aHelpPor := {}
	aHelpSpa := {}
	aAdd(aHelpEng,"")
	aAdd(aHelpEng,"")
	aAdd(aHelpPor,"Informe o n๚mero de dias ")
	aAdd(aHelpPor,"de inventแrio final")
	aAdd(aHelpSpa,"")
	aAdd(aHelpSpa,"")
	PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa)


	cKey     := "P.RCOM1103."
	aHelpEng := {}
	aHelpPor := {}
	aHelpSpa := {}
	aAdd(aHelpEng,"")
	aAdd(aHelpEng,"")
	aAdd(aHelpPor,"Gera planilha excel")
	aAdd(aHelpPor,"")
	aAdd(aHelpSpa,"")
	aAdd(aHelpSpa,"")
	PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa)






Return

