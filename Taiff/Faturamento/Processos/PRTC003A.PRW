#include "protheus.ch"
#INCLUDE "Topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณPRTC0003  บAutor  ณVETI FSW            บ Data ณ  09/19/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณPrograma para a libera็a de estoques                        บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณProArt                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function PRTC003A()
//Local aPosObj	:= {} 
	Local aInfo 	:= {}
	Local aSize  	:= {}
	Local cTitulo 	:= "Consulta Pedido"
	Local cCli:=""
	Local cVend:=""
	Local aArea := GetArea()

	Local cC5_PORTAL	:= ""
	Local nRecnoSC5	:= 0
	Local cC5PEDMINAS	:= ""

	Private aPosObj	:= {}

	If SC5->C5_CLASPED = "A"
		MSGSTOP("Rotina nใo permite acesso para classe de pedido da Assistencia T้cnica!","PRTC003A")
		Return
	EndIf

	aSize := MsAdvSize(.T.,.T.)
	aObjects := {}
	AAdd( aObjects, {   1  ,  180, .T., .T. } )
	aInfo := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ] ,3, 3 }
	aPosObj := MsObjSize( aInfo, aObjects )

	DEFINE MSDIALOG oDlg TITLE OemToAnsi(cTitulo) From aSize[7],0 to aSize[6]+240,aSize[5]+40 OF oMainWnd PIXEL

	@aPosObj[1,1] ,aPosObj[1,2] say "Pedido" of oDlg PIXEL
	@aPosObj[1,1],aPosObj[1,2]+25  say SC5->C5_NUM of oDlg PIXEL
	cStatus:=DefStatus()
	@aPosObj[1,1] ,aPosObj[1,2]+80 say "Status" of oDlg PIXEL
	@aPosObj[1,1] ,aPosObj[1,2]+102 say cStatus of oDlg PIXEL

	@aPosObj[1,1] ,aPosObj[1,2]+170 say "Data" of oDlg PIXEL
//cDTpv:=DTOS(SC5->C5_EMISSAO)
//Substring(SC5->C5_EMISSAO,7,2)+"/"+Substring(SC5->C5_EMISSAO,5,2)+"/"+Substring(SC5->C5_EMISSAO,1,4)
	@aPosObj[1,1] ,aPosObj[1,2]+190 say SC5->C5_EMISSAO of oDlg PIXEL

	If CEMPANT="03" .AND. CFILANT="02" .AND. Alltrim(SC5->C5_NUMOC)="CROSS" .AND. !SC5->C5_TIPO $ ('D|B')
		@aPosObj[1,1] + 10,aPosObj[1,2] say "Pedido SP" of oDlg PIXEL
		@aPosObj[1,1] + 10,aPosObj[1,2]+40  say SC5->C5_NUMORI of oDlg PIXEL
		@aPosObj[1,1] + 10,aPosObj[1,2]+80 say "Pedido Portal" of oDlg PIXEL
		@aPosObj[1,1] + 10,aPosObj[1,2]+115 say SC5->C5_NUMOLD of oDlg PIXEL
	ElseIf CEMPANT="03" .AND. CFILANT="01" .AND. !SC5->C5_TIPO $ ('D|B')

		cC5_PORTAL := SC5->C5_NUMOLD
		nRecnoSC5	:= SC5->(RECNO())
		SC5->(DbOrderNickName("SC5NUMOLD"))  // SC5->(DbSetOrder(8))
		SC5->(DbSeek( "02" + cC5_PORTAL ))
		cC5PEDMINAS:= SC5->C5_NUM
		SC5->(DbSetOrder(1))
		SC5->(DbGoto(nRecnoSC5))

		@aPosObj[1,1] + 10,aPosObj[1,2] say "Pedido MG" of oDlg PIXEL
		@aPosObj[1,1] + 10,aPosObj[1,2]+40  say cC5PEDMINAS of oDlg PIXEL
		@aPosObj[1,1] + 10,aPosObj[1,2]+80 say "Pedido Portal" of oDlg PIXEL
		@aPosObj[1,1] + 10,aPosObj[1,2]+115 say SC5->C5_NUMOLD of oDlg PIXEL
	EndIf

/*
|---------------------------------------------------------------------------------
|	Quando o Pedido e Devolucao deve verificar o Cadastro de Fornecedores
|
|	Edson Hornberger - 05/11/2014
|---------------------------------------------------------------------------------
*/
	If SC5->C5_FILDES='01' .AND. CFILANT='02'
		cCli:=SC5->C5_NOMCLI //Dados do Cliente
		@aPosObj[1,1] + 20,aPosObj[1,2] say "Cliente" of oDlg PIXEL
		@aPosObj[1,1] + 20,aPosObj[1,2]+40 say SC5->C5_CLIORI+"/"+SC5->C5_LOJORI of oDlg PIXEL
		@aPosObj[1,1] + 20,aPosObj[1,2]+80 say Alltrim(cCli) of oDlg PIXEL
	Else
		IF SC5->C5_TIPO $ ('D|B')
			cCli:=Posicione("SA2",1,xFilial("SA2")+SC5->C5_CLIENTE+SC5->C5_LOJACLI,"A2_NOME") //Dados do Fornecedor
			@aPosObj[1,1] + 20,aPosObj[1,2] say "Fornecedor" of oDlg PIXEL
		ELSE
			cCli:=Posicione("SA1",1,xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI,"A1_NOME") //Dados do Cliente
			@aPosObj[1,1] + 20,aPosObj[1,2] say "Cliente" of oDlg PIXEL
		ENDIF
		@aPosObj[1,1] + 20,aPosObj[1,2]+40 say SC5->C5_CLIENTE+"/"+SC5->C5_LOJACLI of oDlg PIXEL
		@aPosObj[1,1] + 20,aPosObj[1,2]+80 say Alltrim(cCli) of oDlg PIXEL
	EndIf

	cVend:=Posicione("SA3",1,xFilial("SA3")+SC5->C5_VEND1,"A3_NOME")  //Vendedor
	@aPosObj[1,1] + 30,aPosObj[1,2] say "Vendedor  "  of oDlg PIXEL
	@aPosObj[1,1] + 30,aPosObj[1,2]+40 say SC5->C5_VEND1 of oDlg PIXEL
	@aPosObj[1,1] + 30,aPosObj[1,2]+80 say Alltrim(cVend) of oDlg PIXEL

	cPagto:=Posicione("SE4",1,xFilial("SE4")+SC5->C5_CONDPAG1,"E4_DESCRI")  //Cond. Pagto.
	@aPosObj[1,1] + 40,aPosObj[1,2] say "Cond. Pagto  " of oDlg PIXEL
	@aPosObj[1,1] + 40,aPosObj[1,2]+40 say SC5->C5_CONDPAG of oDlg PIXEL
	@aPosObj[1,1] + 40,aPosObj[1,2]+80 say Alltrim(cPagto) of oDlg PIXEL

	cTransp:=Posicione("SA4",1,xFilial("SA4")+SC5->C5_TRANSP,"A4_NOME")  //Cond. Pagto.
	@aPosObj[1,1] + 50,aPosObj[1,2] say "Transportador  " of oDlg PIXEL
	@aPosObj[1,1] + 50,aPosObj[1,2]+40 say SC5->C5_TRANSP of oDlg PIXEL
	@aPosObj[1,1] + 50,aPosObj[1,2]+80 say cTransp of oDlg PIXEL

	@aPosObj[1,1] + 60,aPosObj[1,2] say "Peso Bruto   " of oDlg PIXEL
	@aPosObj[1,1] + 60,aPosObj[1,2]+30 say SC5->C5_PBRUTO PICTURE "@E 999,999.9999" of oDlg PIXEL
	@aPosObj[1,1] + 60,aPosObj[1,2]+80 say "Peso Liquido   " of oDlg PIXEL
	@aPosObj[1,1] + 60,aPosObj[1,2]+110 say SC5->C5_PESOL PICTURE "@E 999,999.9999" of oDlg PIXEL
	@aPosObj[1,1] + 60,aPosObj[1,2]+140 say "Volume   " of oDlg PIXEL
	@aPosObj[1,1] + 60,aPosObj[1,2]+160 say SC5->C5_VOLUME1 PICTURE "99999" of oDlg PIXEL
	@aPosObj[1,1] + 60,aPosObj[1,2]+175 say SC5->C5_ESPECI1  of oDlg PIXEL

	@aPosObj[1,1] + 80,aPosObj[1,2]+30 say "POSIวรO PEDIDO "  of oDlg PIXEL
	NFFat()
	@aPosObj[1,1] + 90,aPosObj[1,2] say "Total Pedido"  of oDlg PIXEL
	TotPV:=TotPed() //Soma todo o C6 desse pedido
	@aPosObj[1,1] + 90,aPosObj[1,2]+50 say TotPV PICTURE "@E 999,999,999.99" of oDlg PIXEL

	TotFat:=U_TotFAT() //Soma os D2 que tem o pedido D2_PEDIDO preenchido
	@aPosObj[1,1] + 100,aPosObj[1,2] say "Total Faturado"  of oDlg PIXEL
	@aPosObj[1,1] + 100,aPosObj[1,2]+50 say TotFat PICTURE "@E 999,999,999.99" of oDlg PIXEL

	@aPosObj[1,1] + 110,aPosObj[1,2] say "Eliminado Residuo"  of oDlg PIXEL
	TotRS:=U_Residuo() //Soma todos os itens que estao marcados com Residuo, reduzindo o que ja foi faturado do item
	@aPosObj[1,1] + 110,aPosObj[1,2]+50 say TotRS PICTURE "@E 999,999,999.99" of oDlg PIXEL

	Saldo:=TotPV - TotFat-TotRS
	@aPosObj[1,1] + 120,aPosObj[1,2] say "SALDO A FAT."  of oDlg PIXEL
	@aPosObj[1,1] + 120,aPosObj[1,2]+50 say Saldo PICTURE "@E 999,999,999.99" of oDlg PIXEL

	@aPosObj[1,1] + 140,aPosObj[1,2] say "Liberado"  of oDlg PIXEL
	TotLib:=TotLib()
	@aPosObj[1,1] + 140,aPosObj[1,2]+50 say TotLib PICTURE "@E 999,999,999.99"  of oDlg PIXEL

	@aPosObj[1,1] + 150,aPosObj[1,2] say "Saldo a Lib."  of oDlg PIXEL
	@aPosObj[1,1] + 150,aPosObj[1,2]+50 say Saldo-TotLib PICTURE "@E 999,999,999.99"  of oDlg PIXEL

	@aPosObj[1,1] + 190,aPosObj[1,2]+30 say "SIMULAวรO DE LIBERAวรO"  of oDlg PIXEL

	@aPosObj[1,1] + 200,aPosObj[1,2] say "Disponivel"  of oDlg PIXEL
	ALib:=Simula()
	@aPosObj[1,1] + 200,aPosObj[1,2]+40 say TotLib+ALib PICTURE "@E 999,999,999.99" of oDlg PIXEL
	@aPosObj[1,1] + 210,aPosObj[1,2] say "Saldo Indisponivel"  of oDlg PIXEL
	@aPosObj[1,1] + 210,aPosObj[1,2]+40 say Saldo-(TotLib+ALib) PICTURE "@E 999,999,999.99"  of oDlg PIXEL

/*@aPosObj[1,1] + 130,aPosObj[1,2]+180 say "SIMULAวรO DE LIBERAวรO"  of oDlg PIXEL

@aPosObj[1,1] + 140,aPosObj[1,2]+160 say "Disponivel"  of oDlg PIXEL
ALib:=Simula()
@aPosObj[1,1] + 140,aPosObj[1,2]+230 say TotLib+ALib PICTURE "@E 999,999,999.99" of oDlg PIXEL
@aPosObj[1,1] + 150,aPosObj[1,2]+160 say "Saldo Indisponivel"  of oDlg PIXEL
@aPosObj[1,1] + 150,aPosObj[1,2]+230 say Saldo-(TotLib+ALib) PICTURE "@E 999,999,999.99"  of oDlg PIXEL
*/

	RestArea(aArea)

	ACTIVATE MSDIALOG oDlg CENTERED ON INIT EnchoiceBar(oDlg,{||lOk := .T., oDlg:End()},{||oDlg:End()}            ,,)

Return

/*/
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
	ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
	ฑฑบFuno    ณTotPed บ Autor ณ Ricardo Baldoni    บ Data ณ  08/02/12   บฑฑ
	ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
	ฑฑบDescrio ณ Funcao auxiliar. Determina o Valor Total do Pedido         บฑฑ
	ฑฑบ          ณ                                                            บฑฑ
	ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
	ฑฑบUso       ณ Programa principal                                         บฑฑ
	ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
	ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
	฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

Static Function TotPed()
	Private nTotPed:=0

	BeginSql Alias "T1SC6"
	Column C6_VALOR as Numeric(12,2)
	
	SELECT SUM(C6_VALOR) C6_VALOR
	FROM %Table:SC6% SC6
	WHERE SC6.%NotDel% AND 
	C6_FILIAL = %xFilial:SC6% AND
	C6_NUM =%Exp:SC5->C5_NUM%	
	GROUP BY C6_NUM
	ORDER BY C6_NUM
	EndSql

	DbSelectArea("T1SC6")
	DbGoTop()
	nTotPed:=T1SC6->C6_VALOR
	DbCloseArea()
Return nTotPed

/*/
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
	ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
	ฑฑบFuno    ณTotFat บ Autor ณ Ricardo Baldoni    บ Data ณ  08/02/12   บฑฑ
	ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
	ฑฑบDescrio ณ Funcao auxiliar. Determina o Valor Faturado do Pedido      บฑฑ
	ฑฑบ          ณ                                                            บฑฑ
	ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
	ฑฑบUso       ณ Programa principal                                         บฑฑ
	ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
	ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
	฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function TotFat()
	Private nTotFat:=0

	BeginSql Alias "T2SC6"
	Column D2_TOTAL as Numeric(12,2)
	
	SELECT SUM(C6_QTDENT * C6_PRCVEN) D2_TOTAL
	FROM %Table:SC6% SC6
	WHERE SC6.%NotDel% AND 
	C6_FILIAL = %xFilial:SC6% AND
	//C6_BLQ<>'R' AND
	C6_NUM =%Exp:SC5->C5_NUM%
	EndSql


	DbSelectArea("T2SC6")
	DbGoTop()
	nTotFat:=T2SC6->D2_TOTAL
	DbCloseArea()
Return nTotFat

/*/
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
	ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
	ฑฑบFuno    ณResiduo บ Autor ณ Ricardo Baldoni    บ Data ณ  08/02/12   บฑฑ
	ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
	ฑฑบDescrio ณ Funcao auxiliar. Determina o Valor Eliminado por Residio   บฑฑ
	ฑฑบ          ณ                                                            บฑฑ
	ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
	ฑฑบUso       ณ Programa principal                                         บฑฑ
	ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
	ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
	฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function Residuo()
	Private nRes:=0

	BeginSql Alias "T3SC6"
	Column C6_VALOR as Numeric(12,2)
	Column D2_TOTAL as Numeric(12,2)
	
	SELECT C6_VALOR, D2_TOTAL
	FROM %Table:SC6% SC6     
	LEFT JOIN %Table:SD2% SD2 ON SD2.%NotDel% AND C6_FILIAL = D2_FILIAL AND C6_NUM=D2_PEDIDO AND C6_ITEM = D2_ITEMPV
	WHERE SC6.%NotDel% AND 
	C6_FILIAL = %xFilial:SC6% AND
	C6_NUM =%Exp:SC5->C5_NUM% AND
	C6_BLQ='R'
	ORDER BY C6_NUM
	EndSql


	DbSelectArea("T3SC6")
	DbGoTop()
	While !EOF()
		If T3SC6->D2_TOTAL >0
			nRes	+=	(T3SC6->C6_VALOR - T3SC6->D2_TOTAL)
		Else
			nRes	+=	T3SC6->C6_VALOR
		Endif
		DbSkip()
	End

	DbCloseArea()
Return nRes

/*/
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
	ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
	ฑฑบFuno    ณStatus บ Autor ณ Ricardo Baldoni    บ Data ณ  08/02/12   บฑฑ
	ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
	ฑฑบDescrio ณ Funcao auxiliar. Determina o Valor Eliminado por Residio   บฑฑ
	ฑฑบ          ณ                                                            บฑฑ
	ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
	ฑฑบUso       ณ Programa principal                                         บฑฑ
	ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
	ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
	฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

Static Function DefStatus()

	Local cStatus:=""

	Do Case
/*	Case Empty(SC5->C5_LIBEROK).And.Empty(SC5->C5_NOTA) .And. Empty(SC5->C5_BLQ) .and. !(U_LibParc()) .and. !(U_VerifEnt())
		cStatus:="Pedido em Aberto"
	Case !Empty(SC5->C5_NOTA).Or.SC5->C5_LIBEROK=='E' .And. Empty(SC5->C5_BLQ)
		cStatus:="Pedido Encerrado"
	Case U_VerifEnt() .AND. U_LibParc9()
		cStatus:="Parcialmente Faturado"
	Case U_LibParc() .and. !(U_VerifEnt())
		cStatus:="Parcialmente Liberado"
	Case (!Empty(SC5->C5_LIBEROK).And.Empty(SC5->C5_NOTA).And. Empty(SC5->C5_BLQ)) .AND. (SC5->C5_YSTSEP $ 'E' .OR. Empty(SC5->C5_YSTSEP))
		cStatus:="Pedido Lib. Ag. Separacao"
	Case (!Empty(SC5->C5_LIBEROK).And.Empty(SC5->C5_NOTA).And. Empty(SC5->C5_BLQ)) .AND. SC5->C5_YSTSEP $ 'S'
		cStatus:="Pedido Lib. Em Separacao"
	Case (!Empty(SC5->C5_LIBEROK).And.Empty(SC5->C5_NOTA).And. Empty(SC5->C5_BLQ)) .AND. SC5->C5_YSTSEP $ 'C'
		cStatus:="Pedido Lib. Em Conferencia"
	Case (!Empty(SC5->C5_LIBEROK).And.Empty(SC5->C5_NOTA).And. Empty(SC5->C5_BLQ)) .AND. SC5->C5_YSTSEP $ 'G'
		cStatus:="Pedido Lib. Conferido"	  */    
		
	Case Empty(C5_LIBEROK).And.Empty(C5_NOTA) .AND. U_LibParcC9() .AND. Empty(C5_BLQ) .AND. !(U_LibParc()) .AND. !(U_VerifEnt())
		cStatus:="Pedido em Aberto"  
	Case  Empty(C5_BLQ)   .AND.  U_LibParcC9() .AND. U_VerFinal()== 1 .AND. Empty(C5_YSTSEP) .AND.!Empty(C5_YFMES) //  violeta faturado e nao separado
		cStatus:="Pedido Fat. e Nao Separado"	 
	Case  Empty(C5_BLQ)   .AND. !U_LibParcC9() .AND. !U_VERSC6() .AND. (C5_YSTSEP $ 'E' .OR. Empty(C5_YSTSEP)) // cinza pedido parc. lib. p/separacao
		cStatus:="Parcialmente Liberado"
	Case  Empty(C5_BLQ)   .AND. !U_LibParcC9() .AND.  U_VERSC6() .AND. (C5_YSTSEP $ 'E' .OR. Empty(C5_YSTSEP)) //amarelo pedido totalmente lib. p/separacao
		cStatus:="Pedido Lib. Ag. Separacao"
	Case  Empty(C5_BLQ)   .AND. C5_YSTSEP == 'S' .AND. !U_VERZZG() //azul pedido lib. em separacao
		cStatus:="Pedido Lib. Em Separacao"
	Case  Empty(C5_BLQ)   .AND. C5_YSTSEP <> 'G'.AND. C5_YSTSEP <> 'E'.AND. (C5_YSTSEP $ 'C' .OR. C5_YSTSEP $ 'F' .OR. U_VERZZG()) 	// pink Pedido Lib. Em Conferencia
		cStatus:="Pedido Lib. Em Conferencia"
	Case  Empty(C5_BLQ)   .AND. !U_LibParcC9() .AND.  C5_YSTSEP == 'G'  // branco pedido liberado e conferido
		cStatus:="Pedido Lib. Conferido"	 
	Case  Empty(C5_BLQ)   .AND. !U_LibParcC9() .AND.  C5_YSTSEP == 'X' // preto erro no calculo de cubagem
		cStatus:="Pedido erro na cubagem"	 
	Case !U_VERSC6FAT()  .AND.  U_VerFinal()== 0  .AND.  U_LibParcC9()     // vermelho faturado totalmente
		cStatus:="Pedido Encerrado"
	Case !U_VERSC6FAT()  .AND.  U_VerFinal()== 2  .AND.  U_LibParcC9()     // laranja parcialmente faturado
		cStatus:="Parcialmente Faturado"

	EndCase
Return cStatus

Static Function NFFat()

Local cNota		:=""  
Local cSerie	:=""  
Local cData		:="" 
Local cDtEmb	:="" 
Local cDtRcb	:=""
Local nMerc		:=0
Local nFrete	:=0
Local nValIPI	:=0
Local nICMRet	:=0
Local nBrut		:=0
Local nBICM		:=0
Local nValICM	:=0
Local nBRIcms	:=0

Local cNota1	:=""  
Local cSerie1	:=""  
Local cData1	:="" 
Local cDtEmb1	:="" 
Local cDtRcb1	:=""
Local nMerc1	:=0
Local nFrete1	:=0
Local nValIPI1	:=0
Local nICMRet1	:=0
Local nBrut1	:=0
Local nBICM1	:=0
Local nValICM1	:=0
Local nBRIcms1	:=0

Local cNota2	:=""  
Local cSerie2	:=""  
Local cData2	:="" 
Local cDtEmb2	:="" 
Local cDtRcb2	:=""
Local nMerc2	:=0
Local nFrete2	:=0
Local nValIPI2	:=0
Local nICMRet2	:=0
Local nBrut2	:=0
Local nBICM2	:=0
Local nValICM2	:=0
Local nBRIcms2	:=0

	BeginSql Alias "TSC6"
	Column C6_VALOR as Numeric(12,2)
//SUM(C6_VALOR) C6_VALOR	
//	GROUP BY C6_NOTA, C6_SERIE,C6_DATFAT,F2_DTEMB,F2_DTENTR,F2_DTRECEB

	SELECT DISTINCT C6_NOTA, C6_SERIE,C6_DATFAT,F2_DTEMB,F2_DTENTR, F2_DTRECEB, F2_VALMERC, F2_FRETE, F2_VALIPI,
	F2_ICMSRET, F2_VALBRUT, F2_BASEICM, F2_VALICM, F2_BRICMS
	FROM %Table:SC6% SC6
	INNER JOIN %Table:SF2% SF2 ON SF2.%NotDel% AND C6_FILIAL=F2_FILIAL AND C6_NOTA=F2_DOC AND C6_SERIE=F2_SERIE
	WHERE SC6.%NotDel% AND 
	C6_FILIAL = %xFilial:SC6% AND
	C6_NUM =%Exp:SC5->C5_NUM% AND
	C6_NOTA<>'         '

	ORDER BY C6_NOTA, C6_SERIE,C6_DATFAT,F2_DTEMB,F2_DTENTR,F2_DTRECEB
	EndSql

	DbSelectArea("TSC6")
	DbGoTop()

/*@aPosObj[1,1] + 80,aPosObj[1,2]+195 say "NOTAS FISCAIS"  of oDlg PIXEL
@aPosObj[1,1] + 90,aPosObj[1,2]+130 say "Num. / S้rie"  of oDlg PIXEL
@aPosObj[1,1] + 90,aPosObj[1,2]+170 say "Data Fat."  of oDlg PIXEL
@aPosObj[1,1] + 90,aPosObj[1,2]+210 say "Data Emb."  of oDlg PIXEL
@aPosObj[1,1] + 90,aPosObj[1,2]+250 say "Data Receb."  of oDlg PIXEL
@aPosObj[1,1] + 90,aPosObj[1,2]+290 say "Mercadorias"  of oDlg PIXEL
@aPosObj[1,1] + 90,aPosObj[1,2]+325 say "Frete"  of oDlg PIXEL
@aPosObj[1,1] + 90,aPosObj[1,2]+350 say "IPI"  of oDlg PIXEL
@aPosObj[1,1] + 90,aPosObj[1,2]+380 say "ST"  of oDlg PIXEL

@aPosObj[1,1] + 90,aPosObj[1,2]+395 say "Total"  of oDlg PIXEL
@aPosObj[1,1] + 90,aPosObj[1,2]+415 say "Base ICMS"  of oDlg PIXEL
@aPosObj[1,1] + 90,aPosObj[1,2]+445 say "Base ST"  of oDlg PIXEL
@aPosObj[1,1] + 90,aPosObj[1,2]+465 say "ICMS"  of oDlg PIXEL
*/                                                           
	@aPosObj[1,1] + 80,aPosObj[1,2]+230 say "NOTAS FISCAIS"  of oDlg PIXEL
	@aPosObj[1,1] + 100,aPosObj[1,2]+150 say "Num. / S้rie"  of oDlg PIXEL
	@aPosObj[1,1] + 110,aPosObj[1,2]+150 say "Data Fat."  of oDlg PIXEL
	@aPosObj[1,1] + 120,aPosObj[1,2]+150 say "Data Emb."  of oDlg PIXEL
	@aPosObj[1,1] + 130,aPosObj[1,2]+150 say "Data Receb."  of oDlg PIXEL
	@aPosObj[1,1] + 150,aPosObj[1,2]+150 say "Mercadorias"  of oDlg PIXEL
	@aPosObj[1,1] + 160,aPosObj[1,2]+150 say "Frete"  of oDlg PIXEL
	@aPosObj[1,1] + 170,aPosObj[1,2]+150 say "IPI"  of oDlg PIXEL
	@aPosObj[1,1] + 180,aPosObj[1,2]+150 say "ST"  of oDlg PIXEL

	@aPosObj[1,1] + 190,aPosObj[1,2]+150 say "Total"  of oDlg PIXEL
	@aPosObj[1,1] + 210,aPosObj[1,2]+150 say "Base ICMS"  of oDlg PIXEL
	@aPosObj[1,1] + 220,aPosObj[1,2]+150 say "Base ST"  of oDlg PIXEL
	@aPosObj[1,1] + 230,aPosObj[1,2]+150 say "ICMS"  of oDlg PIXEL

	j:=10
	i:=1
	While !EOF()
		If i==1
			cNota:=TSC6->C6_NOTA
			cSerie:=TSC6->C6_SERIE
			cData:=Substring(TSC6->C6_DATFAT,7,2)+"/"+Substring(TSC6->C6_DATFAT,5,2)+"/"+Substring(TSC6->C6_DATFAT,1,4)
			cDtEmb:=Substring(TSC6->F2_DTEMB,7,2)+"/"+Substring(TSC6->F2_DTEMB,5,2)+"/"+Substring(TSC6->F2_DTEMB,1,4)
			cDtRcb:=Substring(TSC6->F2_DTRECEB,7,2)+"/"+Substring(TSC6->F2_DTRECEB,5,2)+"/"+Substring(TSC6->F2_DTRECEB,1,4)
			nMerc:=TSC6->F2_VALMERC
			nFrete:=TSC6->F2_FRETE
			nValIPI:=TSC6->F2_VALIPI
			nICMRet:=TSC6->F2_ICMSRET
			nBrut:=TSC6->F2_VALBRUT
			nBICM:=TSC6->F2_BASEICM
			nValICM:=TSC6->F2_VALICM
			nBRIcms:=TSC6->F2_BRICMS
		ElseIf i==2
			cNota1:=TSC6->C6_NOTA
			cSerie1:=TSC6->C6_SERIE
			cData1:=Substring(TSC6->C6_DATFAT,7,2)+"/"+Substring(TSC6->C6_DATFAT,5,2)+"/"+Substring(TSC6->C6_DATFAT,1,4)
			cDtEmb1:=Substring(TSC6->F2_DTEMB,7,2)+"/"+Substring(TSC6->F2_DTEMB,5,2)+"/"+Substring(TSC6->F2_DTEMB,1,4)
			cDtRcb1:=Substring(TSC6->F2_DTRECEB,7,2)+"/"+Substring(TSC6->F2_DTRECEB,5,2)+"/"+Substring(TSC6->F2_DTRECEB,1,4)
			nMerc1:=TSC6->F2_VALMERC
			nFrete1:=TSC6->F2_FRETE
			nValIPI1:=TSC6->F2_VALIPI
			nICMRet1:=TSC6->F2_ICMSRET
			nBrut1:=TSC6->F2_VALBRUT
			nBICM1:=TSC6->F2_BASEICM
			nValICM1:=TSC6->F2_VALICM
			nBRIcms1:=TSC6->F2_BRICMS
		ElseIf i==3
			cNota2:=TSC6->C6_NOTA
			cSerie2:=TSC6->C6_SERIE
			cData2:=Substring(TSC6->C6_DATFAT,7,2)+"/"+Substring(TSC6->C6_DATFAT,5,2)+"/"+Substring(TSC6->C6_DATFAT,1,4)
			cDtEmb2:=Substring(TSC6->F2_DTEMB,7,2)+"/"+Substring(TSC6->F2_DTEMB,5,2)+"/"+Substring(TSC6->F2_DTEMB,1,4)
			cDtRcb2:=Substring(TSC6->F2_DTRECEB,7,2)+"/"+Substring(TSC6->F2_DTRECEB,5,2)+"/"+Substring(TSC6->F2_DTRECEB,1,4)
			nMerc2:=TSC6->F2_VALMERC
			nFrete2:=TSC6->F2_FRETE
			nValIPI2:=TSC6->F2_VALIPI
			nICMRet2:=TSC6->F2_ICMSRET
			nBrut2:=TSC6->F2_VALBRUT
			nBICM2:=TSC6->F2_BASEICM
			nValICM2:=TSC6->F2_VALICM
			nBRIcms2:=TSC6->F2_BRICMS
		Endif
		If !Empty(cNota) .and. i==1

			@aPosObj[1,1] + 100,aPosObj[1,2]+190 say cNota +"/"+ cSerie   of oDlg PIXEL
			@aPosObj[1,1] + 110,aPosObj[1,2]+190 say cData   of oDlg PIXEL
			@aPosObj[1,1] + 120,aPosObj[1,2]+190 say cDtEmb  of oDlg PIXEL
			@aPosObj[1,1] + 130,aPosObj[1,2]+190 say cDtRcb  of oDlg PIXEL
			@aPosObj[1,1] + 150,aPosObj[1,2]+190 say nMerc PICTURE "@E 999,999,999.99" of oDlg PIXEL
			@aPosObj[1,1] + 160,aPosObj[1,2]+190 say nFrete PICTURE "@E 999,999,999.99" of oDlg PIXEL
			@aPosObj[1,1] + 170,aPosObj[1,2]+190 say nValIPI PICTURE "@E 999,999,999.99" of oDlg PIXEL
			@aPosObj[1,1] + 180,aPosObj[1,2]+190 say nICMRet PICTURE "@E 999,999,999.99" of oDlg PIXEL
			@aPosObj[1,1] + 190,aPosObj[1,2]+190 say (nMerc+nFrete+nValIPI+nICMRet) PICTURE "@E 999,999,999.99" of oDlg PIXEL
			@aPosObj[1,1] + 210,aPosObj[1,2]+190 say  nBICM PICTURE "@E 999,999,999.99" of oDlg PIXEL
			@aPosObj[1,1] + 220,aPosObj[1,2]+190 say  nValICM PICTURE "@E 999,999,999.99" of oDlg PIXEL
			@aPosObj[1,1] + 230,aPosObj[1,2]+190 say  nBRIcms PICTURE "@E 999,999,999.99" of oDlg PIXEL
			j+=10
		ElseIf !Empty(cNota) .and. i==2
			@aPosObj[1,1] + 100,aPosObj[1,2]+240 say cNota1+"/"+cSerie1   of oDlg PIXEL
			@aPosObj[1,1] + 110,aPosObj[1,2]+240 say cData1   of oDlg PIXEL
			@aPosObj[1,1] + 120,aPosObj[1,2]+240 say cDtEmb1  of oDlg PIXEL
			@aPosObj[1,1] + 130,aPosObj[1,2]+240 say cDtRcb1  of oDlg PIXEL
			@aPosObj[1,1] + 150,aPosObj[1,2]+240 say nMerc1 PICTURE "@E 999,999,999.99" of oDlg PIXEL
			@aPosObj[1,1] + 160,aPosObj[1,2]+240 say nFrete1 PICTURE "@E 999,999,999.99" of oDlg PIXEL
			@aPosObj[1,1] + 170,aPosObj[1,2]+240 say nValIPI1 PICTURE "@E 999,999,999.99" of oDlg PIXEL
			@aPosObj[1,1] + 180,aPosObj[1,2]+240 say nICMRet1 PICTURE "@E 999,999,999.99" of oDlg PIXEL
			@aPosObj[1,1] + 190,aPosObj[1,2]+240 say (nMerc1+nFrete1+nValIPI1+nICMRet1) PICTURE "@E 999,999,999.99" of oDlg PIXEL
			@aPosObj[1,1] + 210,aPosObj[1,2]+240 say  nBICM1 PICTURE "@E 999,999,999.99" of oDlg PIXEL
			@aPosObj[1,1] + 220,aPosObj[1,2]+240 say  nValICM1 PICTURE "@E 999,999,999.99" of oDlg PIXEL
			@aPosObj[1,1] + 230,aPosObj[1,2]+240 say  nBRIcms1 PICTURE "@E 999,999,999.99" of oDlg PIXEL
		ElseIf !Empty(cNota) .and. i==3
			@aPosObj[1,1] + 100,aPosObj[1,2]+280 say cNota2+"/"+cSerie2   of oDlg PIXEL
			@aPosObj[1,1] + 110,aPosObj[1,2]+280 say cData2   of oDlg PIXEL
			@aPosObj[1,1] + 120,aPosObj[1,2]+280 say cDtEmb2  of oDlg PIXEL
			@aPosObj[1,1] + 130,aPosObj[1,2]+280 say cDtRcb2  of oDlg PIXEL
			@aPosObj[1,1] + 150,aPosObj[1,2]+280 say nMerc2 PICTURE "@E 999,999,999.99" of oDlg PIXEL
			@aPosObj[1,1] + 160,aPosObj[1,2]+280 say nFrete2 PICTURE "@E 999,999,999.99" of oDlg PIXEL
			@aPosObj[1,1] + 170,aPosObj[1,2]+280 say nValIPI2 PICTURE "@E 999,999,999.99" of oDlg PIXEL
			@aPosObj[1,1] + 180,aPosObj[1,2]+280 say nICMRet2 PICTURE "@E 999,999,999.99" of oDlg PIXEL
			@aPosObj[1,1] + 190,aPosObj[1,2]+280 say (nMerc2+nFrete2+nValIPI2+nICMRet2) PICTURE "@E 999,999,999.99" of oDlg PIXEL
			@aPosObj[1,1] + 210,aPosObj[1,2]+280 say  nBICM2 PICTURE "@E 999,999,999.99" of oDlg PIXEL
			@aPosObj[1,1] + 220,aPosObj[1,2]+280 say  nValICM2 PICTURE "@E 999,999,999.99" of oDlg PIXEL
			@aPosObj[1,1] + 230,aPosObj[1,2]+280 say  nBRIcms2 PICTURE "@E 999,999,999.99" of oDlg PIXEL
		Endif


		dbSkip()
		i++
	End
	DbCloseArea()
Return

/*/
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
	ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
	ฑฑบFuno    ณTotLib บ Autor ณ Ricardo Baldoni    บ Data ณ  08/02/12   บฑฑ
	ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
	ฑฑบDescrio ณ Funcao auxiliar. Determina o Valor Faturado do Pedido      บฑฑ
	ฑฑบ          ณ                                                            บฑฑ
	ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
	ฑฑบUso       ณ Programa principal                                         บฑฑ
	ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
	ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
	฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

Static Function TotLib()
	Private nTotLib:=0

	BeginSql Alias "T1SC9"
	Column TOTLIB as Numeric(12,2)

	SELECT SUM((C9_QTDLIB * C9_PRCVEN)) TOTLIB
	FROM %Table:SC9% SC9
	INNER JOIN %Table:SC6% SC6 ON SC6.%NotDel% AND C9_FILIAL = C6_FILIAL AND C9_PEDIDO=C6_NUM AND C9_ITEM=C6_ITEM
	WHERE SC9.%NotDel%
	AND C9_PEDIDO=%Exp:SC5->C5_NUM%
	AND C9_NFISCAL='         '
	AND C9_BLEST='  '
	EndSql

	DbSelectArea("T1SC9")
	DbGoTop()
	nTotLib:=T1SC9->TOTLIB
	DbCloseArea()
Return nTotLib

Static Function Simula()
	Private nALib:=0
	BeginSql Alias "TSLD"

	SELECT C9_PRODUTO,(C6_QTDVEN-C9_QTDLIB) QTD_A_LIB,(B2_QATU -B2_RESERVA) QTD_DISP, C9_PRCVEN 
	FROM %Table:SC9% SC9
	INNER JOIN %Table:SC6% SC6 ON SC6.%NotDel% AND C9_FILIAL = C6_FILIAL AND C9_PEDIDO=C6_NUM AND C9_ITEM=C6_ITEM
	INNER JOIN %Table:SB2% SB2 ON SB2.%NotDel% AND C9_FILIAL = B2_FILIAL AND C9_PRODUTO=B2_COD AND C9_LOCAL=B2_LOCAL
	WHERE SC9.%NotDel%
	AND C9_NFISCAL='         '
	AND C9_PEDIDO=%Exp:SC5->C5_NUM%
	AND C9_BLEST<>'  '
	EndSql

	DbSelectArea("TSLD")
	DbGoTop()
	While !EOF()
		If TSLD->QTD_DISP >= TSLD->QTD_A_LIB  //Tem Saldo Total a Liberar
			nALib+=QTD_A_LIB*C9_PRCVEN
		Endif

		If TSLD->QTD_DISP < TSLD->QTD_A_LIB  .AND. TSLD->QTD_DISP > 0  //Tem Saldo Parcial a Liberar
			nALib+=QTD_DISP*C9_PRCVEN
		Endif

		DbSkip()
	End
	DbCloseArea()
Return nALib
