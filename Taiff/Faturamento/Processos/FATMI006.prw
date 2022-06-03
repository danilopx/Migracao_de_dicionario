// #########################################################################################
// Projeto:
// Modulo :
// Fonte  : FATMI006.prw
// -----------+-------------------+---------------------------------------------------------
// Data       | Autor             | Descricao
// -----------+-------------------+---------------------------------------------------------
// 06/10/2016 | pbindo            | Gerado com auxílio do Assistente de Código do TDS.
// -----------+-------------------+---------------------------------------------------------
#INCLUDE "TOTVS.CH"
#include "protheus.ch"
#include "Rwmake.ch"
#INCLUDE "TOPCONN.CH"


//------------------------------------------------------------------------------------------
/*/{Protheus.doc} FATMI006
LIBERACAO DE PEDIDOS TAIFF

@author    pbindo
@version   11.3.2.201607211753
@since     06/10/2016
/*/
//------------------------------------------------------------------------------------------
user function FATMI006()

	Local oOk		:= LoadBitMap(GetResources(), "LBOK")
	Local oNo		:= LoadBitMap(GetResources(), "LBNO")
	Local nOpc		:= 0
	Local oBmp1, oBmp2, oBmp3, oBmp4
	Local cPerg		:= "FTMI06"
	Local cPesq		:= Space(06)

	Private oListBox,o1ListBox,o2ListBox
	Private oDlgNotas
	Private cCrono		:= "00:00"							// Cronometro da ligacao atual
	Private oCrono					            			// Objeto da tela "00:00"
	Private cTimeOut		:= "00:00"                        	// Time out do atendimento (Posto de venda)
	Private nTimeSeg		:= 0                      			// Segundos do cronograma
	Private nTimeMin		:= 0                      			// Minutos do cronograma
	Private oFnt1			:= TFont():New( "Times New Roman",13,26,,.T.)	// Fonte do cronometro
	Private oLocal
	Private nSeconds	:= 18000
	Private aPeds := {}		// PEDIDOS SEM IMPRESSAO
	Private aAtraso := {}	//PEDIDOS IMPRESSOS E NAO FATURADOS
	Private aOnda	:= {}
	Private nAt		:= 0
	Private cCor := ""
	
	//CRIA PERGUNTA
	ValidPerg(cPerg)

	//CHAMA PERGUNTA
	If !Pergunte (cPerg,.T.)
		Return(Nil)
	EndIf	

	//EXECUTA A QUERY
	Cursorwait()
	MSGRUN( "Selecionando Pedidos, Aguarde...", "FATMI006", {|| RelerTerm() } )
	CursorArrow()

	@005,005 TO 700,1250  DIALOG oDlgNotas TITLE "Liberação de Pedidos"


	//MONTA TELA ONDA
	c1Fields := " "
	n1Campo 	:= 0

	//01- MARK ,02- COR, 03- FILIAL, 04- FIL.DESTINO, 05- NOME FILIAL, 06- EMISS.PEDIDO, 07- DT.PROGRAM, 08- PRIORIDADE, 09- PEDIDO, 10- DESC.CLASSE,11-COD.CLIENTE, 12-NOME CLIENTE, 13 -UF, 14 - DESC.C.PAGAMENTO,15- VLR.TOTAL, 16- VLR.LIBERADO, 17-REPRESENTANTE,18-PERC.ATENDIDO,19-OBS.PEDIDO,20- CLASSIFICACAO PEDIDO,21- PEDIDO BONIFICACAO,22- LIBERADO BONIFICACAO

	a1TitCampos := {'',;	//01- MARK 
	'',;					//02 - COR
	OemToAnsi("Perc.Atendido"),;	//18- PERC.ATENDIDO
	OemToAnsi("Emiss.Pedido"),;	//06- EMISS.PEDIDO
	OemToAnsi("Dt.Program"),;	//07- DT.PROGRAM
	OemToAnsi("Pedido"),;		//09- PEDIDO
	OemToAnsi("Cod.Cliente"),;	//11- COD.CLIENTE
	OemToAnsi("Nome Cliente"),;	//12- NOME CLIENTE
	OemToAnsi("UF"),;			//13- UF
	OemToAnsi("Desc.Classe"),;	//10- DESC.CLASSE
	OemToAnsi("Desc.C.Pagamento"),;	//14- DESC.C.PAGAMENTO
	OemToAnsi("Vlr.Total"),;		//15- VLR.TOTAL
	OemToAnsi("Vlr.Liberado"),;		//16- VLR.LIBERADO
	OemToAnsi("Obs.Pedido"),;		//19-OBS.PEDIDO
	OemToAnsi("Representante"),;	//17- REPRESENTANTE
	OemToAnsi("Prioridade"),;	//08- PRIORIDADE
	OemToAnsi("Filial"),;	//03- FILIAL
	OemToAnsi("Fil.Destino"),;	//04- FIL.DESTINO
	OemToAnsi("Nome Filial"),;	//05- NOME FILIAL
	''}

	c1Line := "{If(aOnda[o1ListBox:nAT][1],oOk,oNo),"
	c1Line += "aOnda[o1ListBox:nAT][2],"
	c1Line += "Transform(Iif(aOnda[o1ListBox:nAT][18]>=aOnda[o1ListBox:nAT][23],100,(aOnda[o1ListBox:nAT][18]/aOnda[o1ListBox:nAT][23])*100),'@e 999'),"
	c1Line += "aOnda[o1ListBox:nAT][6],"
	c1Line += "aOnda[o1ListBox:nAT][7],"
	c1Line += "aOnda[o1ListBox:nAT][9],"
	c1Line += "aOnda[o1ListBox:nAT][11],"
	c1Line += "aOnda[o1ListBox:nAT][12],"
	c1Line += "aOnda[o1ListBox:nAT][13],"
	c1Line += "aOnda[o1ListBox:nAT][10],"
	c1Line += "aOnda[o1ListBox:nAT][14],"
	c1Line += "aOnda[o1ListBox:nAT][15],"
	c1Line += "Transform(aOnda[o1ListBox:nAT][16],'@e 9,999,999.99'),"
	c1Line += "aOnda[o1ListBox:nAT][19],"
	c1Line += "aOnda[o1ListBox:nAT][17],"
	c1Line += "aOnda[o1ListBox:nAT][08],"
	c1Line += "aOnda[o1ListBox:nAT][03],"
	c1Line += "aOnda[o1ListBox:nAT][04],"
	c1Line += "aOnda[o1ListBox:nAT][05],}"

	b1Line := &( "{ || " + c1Line + " }" )
	nMult := 4
	aCoord := {nMult*1,nMult*1,nMult*3,nMult*8,nMult*8,nMult*6,nMult*6,nMult*20,nMult*1,nMult*12,nMult*12,nMult*12,nMult*12,nMult*30,nMult*15,nMult*3,nMult*2,nMult*10,''}



	@ 5,2 TO 305,860 LABEL "Pedidos a Liberar" OF oDlgNotas  PIXEL
	o1ListBox := TWBrowse():New( 17,4,600,260,,a1TitCampos,aCoord,oDlgNotas,,,,,,,,,,,,.F.,,.T.,,.F.,,,)
	o1ListBox:SetArray(aOnda)
	o1ListBox:bLDblClick := { ||aOnda[o1ListBox:nAt,1] := !aOnda[o1ListBox:nAt,1] } 
	o1ListBox:bLine := b1Line

	@ 305, 005 BITMAP oBmp1 ResName 	"BR_VERDE" OF oDlgNotas Size 15,15 NoBorder When .F. Pixel
	@ 305, 015 SAY "Total" OF oDlgNotas Color CLR_GRAY PIXEL

	@ 305, 080 BITMAP oBmp2 ResName 	"BR_CINZA" OF oDlgNotas Size 15,15 NoBorder When .F. Pixel
	@ 305, 095 SAY "Liberado" OF oDlgNotas Color CLR_GRAY PIXEL

	@ 315, 005 BITMAP oBmp3 ResName 	"BR_AMARELO" OF oDlgNotas Size 15,15 NoBorder When .F. Pixel
	@ 315, 015 SAY "Pedido Bonif. c/Vinc." OF oDlgNotas Color CLR_BLUE PIXEL

	@ 315, 080 BITMAP oBmp4 ResName 	"BR_VERMELHO" OF oDlgNotas Size 15,15 NoBorder When .F. Pixel
	@ 315, 095 SAY "Pedido Bonif. s/Vinc. n/Aut." OF oDlgNotas Color CLR_BLUE PIXEL


	@ 315, 165 BITMAP oBmp1 ResName 	"BR_AZUL" OF oDlgNotas Size 15,15 NoBorder When .F. Pixel
	@ 315, 175 SAY "Pedido Bonif. s/Vinc. Aut." OF oDlgNotas Color CLR_BLUE PIXEL



	//busca de pedidos
//	@ 315,300 SAY "Busca Pedido:" 									SIZE 65, 7 			PIXEL OF oDlgNotas
//	@ 315,350 MSGET oSeek VAR cPesq	 SIZE  60, 9 Valid (Iif(!Empty(cPesq),(LePed(cPesq,o1ListBox),cPesq := Space(010),o1ListBox:Refresh(),	oSeek:SetFocus()),)) PIXEL OF oDlgNotas

	@ 315,250 Say OemToAnsi("Pedido") Size 99,6 Of oDlgNotas Pixel
	@ 315,270 MSGet cPesq Picture "@!" Size 59,8 Of oDlgNotas Pixel
	@ 315,330 BUTTON "Busca"   	SIZE 20,10 ACTION (o1ListBox:nAT:=Iif(Ascan(aOnda, {|e| e[9] == cPesq})>0,o1ListBox:nAT:=Ascan(aOnda, {|e| e[9] == cPesq}),o1ListBox:nAT),cPesq:= Space(06),oDlgNotas:Refresh()) PIXEL OF oDlgNotas


	@ 310,530  SAY oCrono VAR cCrono PIXEL FONT oFnt1 COLOR CLR_BLUE SIZE 55,15 PICTURE "99:99" OF oDlgNotas


	@ 330,005 BUTTON "Liberar"    	SIZE 40,15 ACTION (U_FTMI06DET(aOnda[o1ListBox:nAt,9],aOnda[o1ListBox:nAt,20],aOnda[o1ListBox:nAt,21],aOnda[o1ListBox:nAt,22])) PIXEL OF oDlgNotas
	@ 330,050 BUTTON "Pergunta"   	SIZE 40,15 ACTION (Pergunte("MTA440",.T.)) PIXEL OF oDlgNotas
	@ 330,095 BUTTON "Atualizar"   	SIZE 40,15 ACTION (FTMI6AtuCro(2)) PIXEL OF oDlgNotas	

	@ 330,530 BUTTON "Sair"        		SIZE 40,15 ACTION {nOpc :=0,oDlgNotas:End()} PIXEL OF oDlgNotas



	oTimer := TTimer():New( 10 * 1000, {||FTMI6AtuCro(1)  }, oDlgNotas )
	oTimer:lActive   := Iif(mv_par16 == 1,.T.,.F.) // para ativar

	ACTIVATE DIALOG oDlgNotas CENTERED

return()


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FTMI6AtuCroºAutor  ³Microsiga          º Data ³  03/10/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function FTMI6AtuCro(nTipo)
	Local cTimeAtu 	:= ""
	Local cPedAnt	:= 0

	cTimeOut := "14:30"

	nTimeSeg += 10

	If nTimeSeg > 59
		nTimeMin ++
		nTimeSeg := 0
		If nTimeMin > 60
			nTimeMin := 0
		Endif
	Endif

	cTimeAtu := STRZERO(nTimeMin,2,0)+":"+STRZERO(nTimeSeg,2,0)

	If cTimeAtu >= cTimeOut
		oCrono:nClrText := CLR_RED
		oCrono:Refresh()
	Endif

	If cTimeAtu >= "15:00" .Or. nTipo == 2
		cPedAnt := aOnda[o1ListBox:nAt,9]
		MsgInfo("Ultimo Pedido "+cPedAnt)
		oDlgNotas:End()
		U_FATMI006()
	EndIf

	cCrono := cTimeAtu
	oCrono:Refresh()


Return(.T.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FATMI006DETºAutor  ³Microsiga          º Data ³  03/10/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function FTMI06DET(cPedido,cClassped,cPedBon,cBonLiber)
	
	Private INCLUI := .F.
	PRIVATE cCadastro := OemToAnsi("Libera‡„o de Pedidos de Venda")

	Private aRotina := {	{"Pesquisar","PesqBrw"	, 0 , 1 , 0 , .F.},;	// 
	{"Visualizar","A410Visual", 0 , 2 , 0 , NIL},;	// 
	{"Liberar","A440Libera", 0 , 4 , 0 , NIL},;	// 
	{"Autom tico","A440Automa", 0 , 0 , 0 , NIL},;	// 
	{"Legenda","A410Legend", 0 , 0 , 0 , .F.}}		// 

	Pergunte("MTA440",.F.)
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Transfere locais para a liberacao                    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	PRIVATE lTransf:=MV_PAR01==1
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Libera Parcial pedidos de vendas                     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	PRIVATE lLiber :=MV_PAR02==1
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Sugere quantidade liberada                           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	PRIVATE lSugere:=MV_PAR03==1

	dbSelectArea("SC5")
	dbSetOrder(1)
	If dbSeek(xFilial()+cPedido)
		nReg := Recno()

		If A440Libera("SC5",nReg,3) == 1
			MsgInfo("Pedido "+cPedido+"liberado com sucesso!")
			//ATUALIZA A LEGENDA
			If cClassped = 'V' .AND. U_FT06SLDPED(cPedido)
				cCor := LoadBitMap(GetResources(),"BR_VERDE")
			ElseIf !U_FT06SLDPED(cPedido)
				cCor := LoadBitMap(GetResources(),"BR_CINZA")
			ElseIf cClassped = 'X' .AND. (!EMPTY(cPedBon) .OR. U_FT06VERBONIF(cPedido))
				cCor := LoadBitMap(GetResources(),"BR_AMARELO")
			ElseIf cClassped = 'X' .AND. ((EMPTY(cPedBon) .AND. EMPTY(cBonLiber)) .OR. !U_FT06VERBONIF(cPedido))
				cCor := LoadBitMap(GetResources(),"BR_VERMELHO")
			ElseIf cClassped = 'X' .AND. EMPTY(cPedBon) .AND. !EMPTY(cBonLiber)
				cCor := LoadBitMap(GetResources(),"BR_AZUL")
			EndIf
			aOnda[o1ListBox:nAt,2]:= cCor 
			oDlgNotas:Refresh()		
		EndIf	

	EndIf

Return



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³WMSAT002  ºAutor  ³Microsiga           º Data ³  03/10/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

static function RelerTerm()


	//ZERA O CRONOMETRO
	nTimeMin := 0
	nTimeSeg := 0
	cTimeAtu := "00:00"


	DO CASE		
		CASE MV_PAR07 = 1		
		CCLASPED := 'V'		
		CASE MV_PAR07 = 2		
		CCLASPED := 'X'		
		OTHERWISE		
		CCLASPED := "V','X"		
	END CASE




	//SELECIONA OS PEDIDOS EM ABERTO

	cQuery := " SELECT"
	cQuery += " SC5.C5_FILIAL, SC5.C5_FILDES,"
	cQuery += " CASE"
	cQuery += " WHEN SC5.C5_FILDES = '01' THEN"
	cQuery += " 'MATRIZ'"
	cQuery += " WHEN SC5.C5_FILDES = '02' THEN"
	cQuery += " 'EXTREMA'"
	cQuery += " ELSE"
	cQuery += " 'BARUERI'"
	cQuery += " END	AS NOMEFIL,"
	cQuery += " SC5.C5_EMISSAO,"
	cQuery += " ISNULL(SC5.C5_DTPEDPR,'        ')C5_DTPEDPR,"
	cQuery += " CASE"
	cQuery += " WHEN RTRIM(SC5.C5_DTPEDPR) = '' THEN"
	cQuery += " 'ZZZZZ'"
	cQuery += " WHEN (CONVERT(FLOAT,SC5.C5_DTPEDPR) - CONVERT(FLOAT,CONVERT(NVARCHAR,GETDATE(),112))) > 0 THEN"
	cQuery += " RIGHT(REPLICATE('0',5) + CAST((CONVERT(FLOAT,SC5.C5_DTPEDPR) - CONVERT(FLOAT,CONVERT(NVARCHAR,GETDATE(),112))) AS VARCHAR),5)"
	cQuery += " ELSE"
	cQuery += " RIGHT(REPLICATE('0',5) + CAST(0 AS VARCHAR),5)"
	cQuery += " END	AS PRIORIDADE,"
	cQuery += " SC5.C5_NUM,"
	cQuery += " SC5.C5_CLASPED,"
	cQuery += " CASE"
	cQuery += " WHEN SC5.C5_CLASPED = 'V' THEN 'VENDAS'"
	cQuery += " WHEN SC5.C5_CLASPED = 'X' THEN 'BONIFICACAO'"
	cQuery += " ELSE ''"
	cQuery += " END AS DESCLASPED,"
	cQuery += " SUBSTRING(SC5.C5_X_PVBON,1,6) AS C5_X_PVBON,"
	cQuery += " SC5.C5_X_LIBON,"
	cQuery += " SC5.C5_CLIENTE,"
	cQuery += " SUBSTRING(SA1.A1_NOME,1,50)	AS A1_NOME,"
	cQuery += " SA1.A1_EST,"
	cQuery += " SE4.E4_DESCRI,"
	cQuery += " C5_X_LIBON,"
	cQuery += " (SELECT SUM(C61.C6_VALOR)  FROM "+RetSqlName("SC6")+" C61 WHERE C61.C6_FILIAL = SC5.C5_FILIAL AND C61.C6_NUM = SC5.C5_NUM AND C61.D_E_L_E_T_ <> '*' GROUP BY C6_NUM )AS C6_VALOR ,"
	cQuery += " SUBSTRING(SA3.A3_NOME,1,30)	AS A3_NOME,"
	cQuery += " ISNULL((SELECT"
	cQuery += " CONVERT(VARCHAR(254),CONVERT(VARBINARY(8000),SC5T.C5_OBSERVA))"
	cQuery += " FROM "+RetSqlName("SC5")+" SC5T"
	cQuery += " WHERE"
	cQuery += " SC5T.C5_FILIAL = SC5.C5_FILIAL AND"
	cQuery += " SC5T.C5_NUM = SC5.C5_NUM AND"
	cQuery += " SC5T.D_E_L_E_T_ <> '*'),'')		AS C5_OBS,"

	cQuery += " ISNULL(CASE WHEN SUM((B2_QATU-B2_RESERVA))>=SUM(SC6.C6_QTDVEN - SC6.C6_QTDENT) THEN
	cQuery += " SUM(SC6.C6_QTDVEN - SC6.C6_QTDENT) 
	cQuery += " ELSE
	cQuery += " SUM((B2_QATU-B2_RESERVA)) END,0)    AS DISPONIVEL,"  

	cQuery += " SUM(SC6.C6_QTDVEN - SC6.C6_QTDENT) A_ENTREGAR   ,"	
	cQuery += " CASE WHEN  (B2_QATU-B2_RESERVA) >= (SC6.C6_QTDVEN - SC6.C6_QTDENT) THEN 
	cQuery += " SUM(SC6.C6_PRCVEN * ((SC6.C6_QTDVEN - SC6.C6_QTDENT)))
	cQuery += "  WHEN  (B2_QATU-B2_RESERVA) < (SC6.C6_QTDVEN - SC6.C6_QTDENT)  THEN
	cQuery += " SUM(SC6.C6_PRCVEN * ( (B2_QATU-B2_RESERVA)))
	cQuery += " ELSE
	cQuery += " 0"
	//cQuery += " SUM(SC6.C6_PRCVEN * (B2_QATU-B2_RESERVA)) 
	cQuery += " END AS  VLR_A_ENTREGAR   , "	
	cQuery += " ROW_NUMBER() OVER (ORDER BY SC5.C5_FILIAL) + (SELECT ISNULL(MAX(R_E_C_N_O_),0) FROM SC6030) AS 'R_E_C_N_O_'"
	cQuery += " FROM"
	cQuery += " "+RetSqlName("SC5")+" SC5 WITH(NOLOCK)"
	If mv_par05 == "02" //EXTREMA
		cQuery += " INNER JOIN "+RetSqlName("SA1")+" SA1 WITH(NOLOCK)ON A1_FILIAL = C5_FILIAL AND A1_COD = C5_CLIENTE AND A1_LOJA = C5_LOJACLI"
	Else //FILIAL SAO PAULO
		cQuery += " INNER JOIN "+RetSqlName("SA1")+" SA1 WITH(NOLOCK)ON A1_FILIAL = C5_FILDES  AND A1_COD = C5_CLIORI AND A1_LOJA = C5_LOJORI"
	EndIf
	cQuery += " INNER JOIN "+RetSqlName("SA3")+" SA3 WITH(NOLOCK)ON A3_FILIAL = C5_FILIAL AND A3_COD = C5_VEND1"
	
	/*******************************************************/
	// INCLUÍDO POR GILBERTO (08/11/2016)
	cQuery += " INNER JOIN "+RetSqlName("SZD")+" SZD WITH(NOLOCK)ON ZD_VENDED = C5_VEND1 AND ZD_UNEGOC = '" + IIF(mv_par09 == 1, "TAIFF", "PROART") + "'"
	/*******************************************************/
	
	cQuery += " INNER JOIN "+RetSqlName("SE4")+" SE4 WITH(NOLOCK)ON E4_FILIAL = C5_FILIAL AND E4_CODIGO = C5_CONDPAG"
	cQuery += " INNER JOIN "+RetSqlName("SC6")+" SC6 WITH(NOLOCK)ON C5_FILIAL = C6_FILIAL AND C5_NUM = C6_NUM"
	cQuery += " INNER JOIN "+RetSqlName("SF4")+" SF4 WITH(NOLOCK)ON F4_FILIAL = C6_FILIAL AND F4_CODIGO = C6_TES"
	cQuery += " INNER JOIN "+RetSqlName("SB1")+" SB1 WITH(NOLOCK)ON B1_FILIAL = C6_FILIAL AND B1_COD = C6_PRODUTO"
	cQuery += " LEFT JOIN "+RetSqlName("SB2")+" SB2 WITH(NOLOCK)ON B2_FILIAL = C6_FILIAL AND B2_COD = C6_PRODUTO AND B2_LOCAL = '21'"

	cQuery += " WHERE"
	cQuery += " SC5.C5_FILIAL	= '"+cFilAnt+"'"
	cQuery += " AND SC5.C5_EMISSAO BETWEEN '"+Dtos(mv_par03)+"' AND '"+Dtos(mv_par04)+"'"		
	cQuery += " AND (SF4.F4_ESTOQUE = 'S' OR SF4.F4_CODIGO = '998')"
	cQuery += " AND SC5.C5_CLASPED IN ('"+CCLASPED+"')"

	//FILTRA ORDEM DE CARGA POR FILIAL
	If mv_par05 == "02"
		cQuery += " AND SC5.C5_NUMOC = ''"
	Else
		cQuery += " AND SC5.C5_NUMOC = 'CROSS'"
	EndIf	

	
	If !Empty(mv_par01) //CLIENTE
		cQuery += " AND SA1.A1_COD = '"+mv_par01+"'
	EndIf

	If !Empty(mv_par02) //PEDIDO
		cQuery += " AND SC5.C5_NUM = '"+mv_par02+"'
	EndIf

	If !Empty(mv_par05) //FILIAL DESTINO
		cQuery += " AND SC5.C5_FILDES = '"+mv_par05+"'
	EndIf
	
	//FILTRA ATE 5 GERENTES
	If !Empty(mv_par11) .Or. !Empty(mv_par12) .Or. !Empty(mv_par13) .Or. !Empty(mv_par14) .Or. !Empty(mv_par15)  
		If !Empty(mv_par11) 
			cQuery += " AND (SZD.ZD_GERENT = '"+mv_par11+"'"
		EndIf

		If !Empty(mv_par12) 
			cQuery += " OR SZD.ZD_GERENT = '"+mv_par12+"'"
		EndIf

		If !Empty(mv_par13) 
			cQuery += " OR SZD.ZD_GERENT = '"+mv_par13+"'"
		EndIf

		If !Empty(mv_par14) 
			cQuery += " OR SZD.ZD_GERENT = '"+mv_par14+"'"
		EndIf		

		If !Empty(mv_par15)    
			cQuery += " OR SZD.ZD_GERENT = '"+mv_par15+"'"
		EndIf

		cQuery += ")"
	EndIf

	If !Empty(mv_par06) //UF
		cQuery += " AND SA1.A1_EST = '"+mv_par06+"'
	EndIf

	If mv_par07 == 1 //SEM BLOQUEIO COMERCIAL
		cQuery += " AND C5_LIBCOM = '1' 
	ElseIf mv_par07 == 2 //COM BLOQUEIO COMERCIAL
		cQuery += " AND C5_LIBCOM = '2'
	EndIf	

	If mv_par17 == 1 //SEM BLOQUEIO FINANCEIRO
		cQuery += " AND C5_XLIBCR = 'L' 
	ElseIf mv_par17 == 2 //COM BLOQUEIO FINANCEIRO
		cQuery += " AND C5_XLIBCR = 'B'
	EndIf	



	If mv_par09 == 1 //TAIFF
		cQuery += " AND SB1.B1_ITEMCC = 'TAIFF' AND SC5.C5_XITEMC = 'TAIFF'  AND SC6.C6_LOCAL	= '22'	 
	ElseIf mv_par09 == 2 //PROART
		cQuery += " AND SB1.B1_ITEMCC = 'PROART' AND SC5.C5_XITEMC = 'PROART'  AND SC6.C6_LOCAL	= '23'
	EndIf
	cQuery += " AND SC6.C6_BLQ NOT IN ('R','S') 
	cQuery += " AND SC6.C6_QTDVEN	> SC6.C6_QTDENT 
	cQuery += " AND SA1.D_E_L_E_T_	<> '*' 
	cQuery += " AND SA3.D_E_L_E_T_	<> '*' 
	cQuery += " AND SE4.D_E_L_E_T_	<> '*' 
	cQuery += " AND SC5.D_E_L_E_T_	<> '*' 
	cQuery += " AND SB1.D_E_L_E_T_	<> '*' 
	cQuery += " AND SC6.D_E_L_E_T_	<> '*'
	cQuery += " GROUP BY
	cQuery += " SC5.C5_FILIAL,
	cQuery += " SC5.C5_FILDES,
	cQuery += " SC5.C5_EMISSAO,
	cQuery += " SC5.C5_DTPEDPR,
	cQuery += " SC5.C5_NUM,
	cQuery += " SC5.C5_CLASPED,
	cQuery += " SC5.C5_X_PVBON,
	cQuery += " SC5.C5_X_LIBON,
	cQuery += " SC5.C5_CLIENTE,
	cQuery += " SC5.C5_LOJACLI,
	cQuery += " SC5.C5_CLIENT,
	cQuery += " SC5.C5_LOJAENT,
	cQuery += " SA1.A1_NOME,
	cQuery += " SA1.A1_EST,
	cQuery += " SE4.E4_DESCRI,
	cQuery += " SA3.A3_NOME,B2_QATU, B2_RESERVA , C6_QTDVEN , C6_QTDENT 
	cQuery += " ORDER BY 5,4,3

	//MemoWrite("FATMI006.SQL",cQuery)

	dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'TRBREL', .F., .T.)

	TcSetField("TRBREL","C5_EMISSAO","D")
	TcSetField("TRBREL","C5_DTPEDPR","D")

	Count To nRec1
	CursorArrow()
	aOnda := {}
	If nRec1 == 0
		//01- MARK ,02- COR, 03- FILIAL, 04- FIL.DESTINO, 05- NOME FILIAL, 06- EMISS.PEDIDO, 07- DT.PROGRAM, 08- PRIORIDADE, 09- PEDIDO, 10- DESC.CLASSE,11-COD.CLIENTE, 12-NOME CLIENTE, 13 -UF, 14 - DESC.C.PAGAMENTO,15- VLR.TOTAL, 16- VLR.LIBERADO, 17-REPRESENTANTE,18-DISPONIVEL,19-OBS.PEDIDO,20- CLASSIFICACAO PEDIDO,21- PEDIDO BONIFICACAO,22- LIBERADO BONIFICACAO,23- A ENTREGAR
		aAdd(aOnda,{.F.,"",'','','',Ctod(''),Ctod(''),0,'','','','','','',0,0,'',0,'','','','',0})
	Else
		dbSelectArea("TRBREL")
		ProcRegua(nRec1)
		dbGotop()

		While !Eof()

			IncProc("Calculando os Pedidos")

			//MONTA A COR
			If TRBREL->C5_CLASPED = 'V' .AND. U_FT06SLDPED(TRBREL->C5_NUM)
				cCor := LoadBitMap(GetResources(),"BR_VERDE")
			ElseIf (TRBREL->C5_CLASPED = 'V' .Or. TRBREL->C5_CLASPED = 'X') .AND. !U_FT06SLDPED(TRBREL->C5_NUM)
				cCor := LoadBitMap(GetResources(),"BR_CINZA")
			ElseIf TRBREL->C5_CLASPED = 'X' .AND. (!EMPTY(TRBREL->C5_X_PVBON) .OR. U_FT06VERBONIF(TRBREL->C5_NUM))
				cCor := LoadBitMap(GetResources(),"BR_AMARELO")
			ElseIf TRBREL->C5_CLASPED = 'X' .AND. ((EMPTY(TRBREL->C5_X_PVBON) .AND. EMPTY(TRBREL->C5_X_LIBON)) .OR. !U_FT06VERBONIF(TRBREL->C5_NUM))
				cCor := LoadBitMap(GetResources(),"BR_VERMELHO")
			ElseIf TRBREL->C5_CLASPED = 'X' .AND. EMPTY(TRBREL->C5_X_PVBON) .AND. !EMPTY(TRBREL->C5_X_LIBON)
				cCor := LoadBitMap(GetResources(),"BR_AZUL")
			Else
				cCor := LoadBitMap(GetResources(),"BR_PRETO")
			EndIf

			//nPerAtend := Iif(aOnda[nPos][18]>=aOnda[nPos][23],100,(aOnda[nPos][18]/aOnda[nPos][23])*100)

			nPos := Ascan(aOnda,{|x| x[3] == TRBREL->C5_FILIAL .And. x[9] == TRBREL->C5_NUM }) 
			If  nPos == 0

				aAdd(aOnda,{.F.,; 	//01- MARK
				cCor,; 				//02- COR, 
				TRBREL->C5_FILIAL,; 	//03- FILIAL
				TRBREL->C5_FILDES,; 	//04- FIL.DESTINO
				TRBREL->NOMEFIL,; 		//05- NOME FILIAL
				TRBREL->C5_EMISSAO,;	//06- EMISS.PEDIDO
				TRBREL->C5_DTPEDPR,; 	//07- DT.PROGRAM
				TRBREL->PRIORIDADE,; 	//08- PRIORIDADE
				TRBREL->C5_NUM,; 		//09- PEDIDO
				TRBREL->DESCLASPED,; 	//10- DESC.CLASSE
				TRBREL->C5_CLIENTE,; 	//11-COD.CLIENTE
				TRBREL->A1_NOME,; 		//12-NOME CLIENTE
				TRBREL->A1_EST,; 		//13 -UF
				TRBREL->E4_DESCRI,; 	//14 - DESC.C.PAGAMENTO
				Transform(TRBREL->C6_VALOR,'@e 9,999,999.99'),; 	//15- VLR.TOTAL
				VLR_A_ENTREGAR,; 				//16- VLR.LIBERADO
				TRBREL->A3_NOME,;		//17-REPRESENTANTE
				TRBREL->DISPONIVEL,; 	//18-DISPONIVEL
				TRBREL->C5_OBS,;		//19-OBS.PEDIDO
				TRBREL->C5_CLASPED,;	//20- CLASSIFICACAO PEDIDO
				TRBREL->C5_X_PVBON,;	//21- PEDIDO BONIFICACAO
				TRBREL->C5_X_LIBON,; 	//22- LIBERADO BONIFICACAO
				TRBREL->A_ENTREGAR})	//23 - A ENTREGAR
			Else
				aOnda[nPos][16]+= VLR_A_ENTREGAR
				aOnda[nPos][18]+= TRBREL->DISPONIVEL
				aOnda[nPos][23]+= TRBREL->A_ENTREGAR
			EndIf
			dbSelectArea("TRBREL")
			dbSkip()
		End
	EndIf
	TRBREL->(dbCloseArea())

	If mv_par10 == 1 //PEDIDO
		ASort(aOnda,,,{|x,y|x[9]<y[9]})
	ElseIf mv_par10 == 2 //CLIENTE
		ASort(aOnda,,,{|x,y|x[11]<y[11]})
	ElseIf mv_par10 == 3 //PORCENTAGEM
		ASort(aOnda,,,{|x,y|x[18]>y[18]})
	ElseIf mv_par10 == 4 //DATA
		ASort(aOnda,,,{|x,y|x[6]<y[6]})
	EndIf



return (.T.)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³TMKRD018   ºAutor  ³Microsiga           º Data ³  06/04/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function VALIDPERG(cPerg)

	Local cKey := ""
	Local aHelpEng := {}
	Local aHelpPor := {}
	Local aHelpSpa := {}




	//PutSx1(cGrupo,cOrdem,cPergunt               ,cPerSpa               ,cPerEng               ,cVar	 ,cTipo ,nTamanho,nDecimal,nPresel,cGSC,cValid			,cF3   , cGrpSxg    ,cPyme,cVar01    ,cDef01     	,cDefSpa1,cDefEng1,cCnt01,cDef02    		,cDefSpa2,cDefEng2,cDef03       ,cDefSpa3,cDefEng3,cDef04		,cDefSpa4	,cDefEng4,cDef05,cDefSpa5,cDefEng5,aHelpPor,aHelpEng,aHelpSpa,cHelp)
	PutSx1(cPerg,"01"   ,"Cliente?"				  ,""                    ,""                    ,"mv_ch1","C"   ,06      ,0       ,0      , "G",""    			,"SA1" 	,""         ,""   ,"mv_par01",""        	 ,""      ,""      ,""    ,""        		,""     ,""      ,""    	  	,""      ,""      ,""    		,""      	,""     ,""    	,""      ,""      ,""      ,""      ,""      ,"")
	PutSx1(cPerg,"02"   ,"Pedido?"				  ,""                    ,""                    ,"mv_ch2","C"   ,06      ,0       ,0      , "G",""    			,"SA5" 	,""         ,""   ,"mv_par02",""        	 ,""      ,""      ,""    ,""        		,""     ,""      ,""    	  	,""      ,""      ,""    		,""      	,""     ,""   	,""      ,""      ,""      ,""      ,""      ,"")
	PutSx1(cPerg,"03"   ,"Emissao De?"			  ,""                    ,""                    ,"mv_ch3","D"   ,08      ,0       ,0      , "G",""    			,"" 	,""         ,""   ,"mv_par03",""	     	 ,""      ,""      ,""    ,""		      	,""     ,""      ,""		  	,""      ,""      ,""		 	,""			,""     ,""    	,""    	,""      ,""      ,""      ,""      ,"")
	PutSx1(cPerg,"04"   ,"Emissao Ate?"			  ,""                    ,""                    ,"mv_ch4","D"   ,08      ,0       ,0      , "G",""    			,"" 	,""         ,""   ,"mv_par04",""	    	 ,""      ,""      ,""    ,""	        	,""     ,""      ,""			,""      ,""      ,""		  	,""			,""     ,""    	,""    	,""      ,""      ,""      ,""      ,"")
	PutSx1(cPerg,"05"   ,"Filial Dest?"			  ,""                    ,""                    ,"mv_ch5","C"   ,02      ,0       ,0      , "G","NaoVazio()"	,"TF003",""         ,""   ,"mv_par06",""        	 ,""      ,""      ,""    ,""        		,""     ,""      ,""    	  	,""      ,""      ,""    		,""      	,""     ,""    	,""      ,""      ,""      ,""      ,""      ,"")
	PutSx1(cPerg,"06"   ,"UF?"					  ,""                    ,""                    ,"mv_ch7","C"   ,02      ,0       ,0      , "G",""    			,"12" 	,""         ,""   ,"mv_par06",""        	 ,""      ,""      ,""    ,""        		,""     ,""      ,""    	  	,""      ,""      ,""    		,""      	,""     ,""    	,""      ,""      ,""      ,""      ,""      ,"")
	PutSx1(cPerg,"07"   ,"Class.Pedido:?"		  ,""                    ,""                    ,"mv_ch8","N"   ,01      ,0       ,0      , "C",""    			,"" 	,""         ,""   ,"mv_par07","Vendas"     	 ,""      ,""      ,""    ,"Bonificacao"	,""     ,""      ,"Ambas"  	  	,""      ,""      ,""    		,""      	,""     ,""    	,""      ,""      ,""      ,""      ,""      ,"")
	PutSx1(cPerg,"08"   ,"Bloq.Comercial?"		  ,""                    ,""                    ,"mv_ch9","N"   ,01      ,0       ,0      , "C",""    			,"" 	,""         ,""   ,"mv_par08","Sem"        	 ,""      ,""      ,""    ,"Com"       		,""     ,""      ,"Ambos"  	  	,""      ,""      ,""    		,""      	,""     ,""    	,""      ,""      ,""      ,""      ,""      ,"")
	PutSx1(cPerg,"09"   ,"Linha?"				  ,""                    ,""                    ,"mv_chA","N"   ,01      ,0       ,0      , "C",""    			,"" 	,""         ,""   ,"mv_par09","Taiff"      	 ,""      ,""      ,""    ,"Proart"    		,""     ,""      ,""	  	  	,""      ,""      ,""    		,""      	,""     ,""    	,""      ,""      ,""      ,""      ,""      ,"")
	PutSx1(cPerg,"10"   ,"Ordem?"				  ,""                    ,""                    ,"mv_chB","N"   ,01      ,0       ,0      , "C",""    			,"" 	,""         ,""   ,"mv_par10","Pedido"     	 ,""      ,""      ,""    ,"Cliente"   		,""     ,""      ,"Porcentagem" ,""      ,""      ,"Data"  		,""      	,""     ,""    	,""      ,""      ,""      ,""      ,""      ,"")
	PutSx1(cPerg,"11"   ,"Gerente 1?"			  ,""                    ,""                    ,"mv_chc","C"   ,06      ,0       ,0      , "G",""    			,"TF002",""         ,""   ,"mv_par11",""        	 ,""      ,""      ,""    ,""        		,""     ,""      ,""    	  	,""      ,""      ,""    		,""      	,""     ,""    	,""      ,""      ,""      ,""      ,""      ,"")
	PutSx1(cPerg,"12"   ,"Gerente 2?"			  ,""                    ,""                    ,"mv_chd","C"   ,06      ,0       ,0      , "G",""    			,"TF002",""         ,""   ,"mv_par12",""        	 ,""      ,""      ,""    ,""        		,""     ,""      ,""    	  	,""      ,""      ,""    		,""      	,""     ,""    	,""      ,""      ,""      ,""      ,""      ,"")
	PutSx1(cPerg,"13"   ,"Gerente 3?"			  ,""                    ,""                    ,"mv_che","C"   ,06      ,0       ,0      , "G",""    			,"TF002",""         ,""   ,"mv_par13",""        	 ,""      ,""      ,""    ,""        		,""     ,""      ,""    	  	,""      ,""      ,""    		,""      	,""     ,""    	,""      ,""      ,""      ,""      ,""      ,"")
	PutSx1(cPerg,"14"   ,"Gerente 4?"			  ,""                    ,""                    ,"mv_chf","C"   ,06      ,0       ,0      , "G",""    			,"TF002",""         ,""   ,"mv_par14",""        	 ,""      ,""      ,""    ,""        		,""     ,""      ,""    	  	,""      ,""      ,""    		,""      	,""     ,""    	,""      ,""      ,""      ,""      ,""      ,"")
	PutSx1(cPerg,"15"   ,"Gerente 5?"			  ,""                    ,""                    ,"mv_chg","C"   ,06      ,0       ,0      , "G",""    			,"TF002",""         ,""   ,"mv_par15",""        	 ,""      ,""      ,""    ,""        		,""     ,""      ,""    	  	,""      ,""      ,""    		,""      	,""     ,""    	,""      ,""      ,""      ,""      ,""      ,"")
	PutSx1(cPerg,"16"   ,"Cronometro?"			  ,""                    ,""                    ,"mv_chh","N"   ,01      ,0       ,0      , "C",""    			,""		,""         ,""   ,"mv_par16","Ativo"      	 ,""      ,""      ,""    ,"Desativado"  	,""     ,""      ,"" 			,""      ,""      ,""    		,""      	,""     ,""    	,""      ,""      ,""      ,""      ,""      ,"")
	PutSx1(cPerg,"17"   ,"Bloq.Financeiro?"		  ,""                    ,""                    ,"mv_chi","N"   ,01      ,0       ,0      , "C",""    			,"" 	,""         ,""   ,"mv_par17","Sem"        	 ,""      ,""      ,""    ,"Com"       		,""     ,""      ,"Ambos"  	  	,""      ,""      ,""    		,""      	,""     ,""    	,""      ,""      ,""      ,""      ,""      ,"")


	cKey     := "P.FTMI0601."
	aHelpEng := {}
	aHelpPor := {}
	aHelpSpa := {}
	aAdd(aHelpEng,"")
	aAdd(aHelpEng,"")
	aAdd(aHelpPor,"Informe o codigo do Cliente")
	aAdd(aHelpPor,"ou deixe em branco para todos")
	aAdd(aHelpSpa,"")
	aAdd(aHelpSpa,"")
	PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa)

	cKey     := "P.FTMI0602."
	aHelpEng := {}
	aHelpPor := {}
	aHelpSpa := {}
	aAdd(aHelpEng,"")
	aAdd(aHelpEng,"")
	aAdd(aHelpPor,"Informe um pedidos")
	aAdd(aHelpPor,"ou deixe em branco")
	aAdd(aHelpSpa,"")
	aAdd(aHelpSpa,"")
	PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa)


	cKey     := "P.FTMI0603."
	aHelpEng := {}
	aHelpPor := {}
	aHelpSpa := {}
	aAdd(aHelpEng,"")
	aAdd(aHelpEng,"")
	aAdd(aHelpPor,"Informe a data de emissao Inicial")
	aAdd(aHelpPor,"")
	aAdd(aHelpSpa,"")
	aAdd(aHelpSpa,"")
	PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa)

	cKey     := "P.FTMI0604."
	aHelpEng := {}
	aHelpPor := {}
	aHelpSpa := {}
	aAdd(aHelpEng,"")
	aAdd(aHelpEng,"")
	aAdd(aHelpPor,"Informe a data de emissao final")
	aAdd(aHelpPor,"")
	aAdd(aHelpSpa,"")
	aAdd(aHelpSpa,"")
	PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa)

	cKey     := "P.FTMI0605."
	aHelpEng := {}
	aHelpPor := {}
	aHelpSpa := {}
	aAdd(aHelpEng,"")
	aAdd(aHelpEng,"")
	aAdd(aHelpPor,"Informe a Filial de destino")
	aAdd(aHelpPor,"ou deixe em branco")
	aAdd(aHelpSpa,"")
	aAdd(aHelpSpa,"")
	PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa)

	cKey     := "P.FTMI0606."
	aHelpEng := {}
	aHelpPor := {}
	aHelpSpa := {}
	aAdd(aHelpEng,"")
	aAdd(aHelpEng,"")
	aAdd(aHelpPor,"Informe o codigo do gerente")
	aAdd(aHelpPor,"ou deixe em branco")
	aAdd(aHelpSpa,"")
	aAdd(aHelpSpa,"")
	PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa)

	cKey     := "P.FTMI0607."
	aHelpEng := {}
	aHelpPor := {}
	aHelpSpa := {}
	aAdd(aHelpEng,"")
	aAdd(aHelpEng,"")
	aAdd(aHelpPor,"Informe o estado de entrega")
	aAdd(aHelpPor,"ou deixe em branco")
	aAdd(aHelpSpa,"")
	aAdd(aHelpSpa,"")
	PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa)

	cKey     := "P.FTMI0608."
	aHelpEng := {}
	aHelpPor := {}
	aHelpSpa := {}
	aAdd(aHelpEng,"")
	aAdd(aHelpEng,"")
	aAdd(aHelpPor,"Selecione a Classificacao do pedido")
	aAdd(aHelpPor,"")
	aAdd(aHelpSpa,"")
	aAdd(aHelpSpa,"")
	PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa)


	cKey     := "P.FTMI0609."
	aHelpEng := {}
	aHelpPor := {}
	aHelpSpa := {}
	aAdd(aHelpEng,"")
	aAdd(aHelpEng,"")
	aAdd(aHelpPor,"Selecione a Forma de Bloqueio")
	aAdd(aHelpPor,"")
	aAdd(aHelpSpa,"")
	aAdd(aHelpSpa,"")
	PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa)


	cKey     := "P.FTMI0610."
	aHelpEng := {}
	aHelpPor := {}
	aHelpSpa := {}
	aAdd(aHelpEng,"")
	aAdd(aHelpEng,"")
	aAdd(aHelpPor,"Selecione a Linha de produto")
	aAdd(aHelpPor,"")
	aAdd(aHelpSpa,"")
	aAdd(aHelpSpa,"")
	PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³A5_LIBPED ºAutor  ³Edson Hornberger    º Data ³  05/29/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Funcao para Liberacao do Pedido de Venda                  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ TF_AVN_A5                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

USER FUNCTION FT06SLDPED(CNUMPED)

	LOCAL LRET 		:= .T.
	LOCAL CQUERY 	:= ""
	LOCAL AAREAS	:= GETAREA()

	CQUERY := " SELECT SUM(C9_QTDLIB) AS QTDC9IK"													
	CQUERY += " FROM " + RETSQLNAME("SC9") 															
	CQUERY += " WHERE D_E_L_E_T_ <> '*'" 															
	CQUERY += " AND C9_FILIAL = '" + XFILIAL("SC9") + "' AND C9_NFISCAL = '' " //AND C9_BLEST<>'02'" 	
	CQUERY += " AND C9_PEDIDO='" + CNUMPED + "'"

	DBUSEAREA(.T.,"TOPCONN", TCGENQRY(,,CQUERY),"QRYIK", .F., .T.)

	WQTDC9IK:= QRYIK->QTDC9IK
	QRYIK->(dbCloseArea())

	CQUERY := " SELECT SUM(C6_QTDVEN) AS QTDC6IK" 			
	CQUERY += " FROM " + RETSQLNAME("SC6") 					
	CQUERY += " WHERE D_E_L_E_T_ <> '*'" 					
	CQUERY += " AND C6_FILIAL = '"+ XFILIAL("SC6") + "'" 	
	CQUERY += " AND C6_NUM='" + CNUMPED + "'"

	DBUSEAREA(.T.,"TOPCONN", TCGENQRY(,,CQUERY),"QRYIK1", .F., .T.)

	WQTDC6IK:= QRYIK1->QTDC6IK
	QRYIK1->(dbCloseArea())

	// LIBERACAO PARCIAL: QUANTIDADE ATUAL LIBERADA NO SC9 (NFISCAL EM BRANCO) DIFERENTE DA QUANTIDADE TOTAL DO PEDIDO.

	IF WQTDC9IK > 0 //WQTDC9IK <> WQTDC6IK .AND. WQTDC9IK > 0
		LRET := .F.
	ELSE
		LRET := .T.
	ENDIF

	RESTAREA(AAREAS)

RETURN(LRET)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FT06VERBONIFºAutor  ³Edson Hornberger    º Data ³  31/10/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Funcao para Verificar se ha Vinculo de Bonificacao pelo   º±±
±±º          ³Portal de Vendas                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ TF_AVN_A5                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

USER FUNCTION FT06VERBONIF(CNUMPED)

	LOCAL LTEMBONIF 	:= .F.
	LOCAL CQUERY		:= ""
	LOCAL CNUMPORTAL	:= ""
	LOCAL AAREA			:= GETAREA()

	DBSELECTAREA("SC5")
	DBSETORDER(1)

	IF DBSEEK(XFILIAL("SC5") + CNUMPED)

		CNUMPORTAL := SC5->C5_NUMOLD

	ELSE

		RETURN(LTEMBONIF)

	ENDIF

	CQUERY := " SELECT COUNT(*) AS QTD" 															
	CQUERY += " FROM PORTAL_TAIFFPROART..TBL_PEDIDOS_ASSOCIADOS PA WITH(NOLOCK) " 				
	CQUERY += " WHERE CAST(C5_NUMPRE_VENDAS AS VARCHAR(010)) = '" + CNUMPORTAL + "' " 			
	CQUERY += " OR CAST(C5_NUMPRE_BONIFICACAO AS VARCHAR(010)) = '" + CNUMPORTAL + "' "

	IF SELECT("BNF5") > 0

		DBSELECTAREA("BNF5")
		DBCLOSEAREA()

	ENDIF

	TCQUERY CQUERY NEW ALIAS "BNF5"
	DBSELECTAREA("BNF5")

	LTEMBONIF := (BNF5->QTD > 0)

	BNF5->(DBCLOSEAREA())

	RESTAREA(AAREA)

RETURN(LTEMBONIF)
