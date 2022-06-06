#INCLUDE "rwmake.ch"
#INCLUDE "Protheus.ch"
#include "topconn.ch"
#DEFINE ENTER Chr(13)+Chr(10)

//-----------------------------------------------------------------------------
// Programa:  ACDAT005
// Autor:     Ronald Piscioneri
// Data:      11-Maio-2021
// Descricao: este programa foi desenvolvido para eliminar a recursividade ao
//            se auto-executar nas opcoes "Atualizar" e "Gerar Onda", que
//            estava dando erro "stack depth overflow" e reiniciando o server  
//-----------------------------------------------------------------------------
User Function ACDAT005()
Local nOpt := 1

While nOpt == 1
	MsgRun("Atualizando Dados","Aguarde...",{||nOpt:=U_ACDTX005()})
EndDo



Return(Nil)


/*/
ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÝÝÝÝÝÝÝÝÝÝÑÝÝÝÝÝÝÝÝÝÝËÝÝÝÝÝÝÝÑÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝËÝÝÝÝÝÝÑÝÝÝÝÝÝÝÝÝÝÝÝÝ»±±
±±ºPrograma  ³ACDTX005  º Autor ³ PAULO BINOD        º Data ³  12/04/17   º±±
±±ÌÝÝÝÝÝÝÝÝÝÝØÝÝÝÝÝÝÝÝÝÝÊÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÊÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝ¹±±
±±ºDescricao ³ TELA PARA GERENCIAMENTO DO CENTRO DE DISTRIBUICAO          º±±
±±º          ³                                                            º±±
±±ÌÝÝÝÝÝÝÝÝÝÝØÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝ¹±±
±±ºUso       ³ AP6 IDE                                                    º±±
±±ÈÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function ACDTX005()
	Local nOpc		:= 0
	Local cPedido	:= Space(08)
	Local cNFiscal	:= Space(14)
	Local cPedCli	:= Space(15)
	Private oListBox,o1ListBox,o2ListBox,o3ListBox
	Private oDlgNotas
	Private cCrono		:= "00:00"							// Cronometro da ligacao atual
	Private oCrono					            			// Objeto da tela "00:00"
	Private cTimeOut		:= "00:00"                        	// Time out do atendimento (Posto de venda)
	Private nTimeSeg		:= 0                      			// Segundos do cronograma
	Private nTimeMin		:= 0                      			// Minutos do cronograma
	Private oFnt1			:= TFont():New( "Times New Roman",13,26,,.T.)	// Fonte do cronometro
	Private oLocal
	Private nSeconds	:= 18000
	Private aPeds 	:= {}		// PEDIDOS SEM IMPRESSAO
	Private aNumPed	:= {}		//NUMERO PEDIDOS
	Private aNumFat	:= {}		//NUMERO NOTAS
	Private aFats 	:= {}		// FATURAMENTO SEM SEPARACAO
	Private aOnda 	:= {}		//ONDAS EM ABERTO
	Private aAtraso := {}	//PEDIDOS IMPRESSOS E NAO FATURADOS
	Private nNotasF := 0	//NOTAS FATURA
	Private nNotasR := 0	//NOTAS REMESSA
	Private nValF	:= 0	//TOTAL FATURA
	Private nValR	:= 0	//TOTAL REMESSA
	Private nItensS := 0	//SOMA DOS ITENS FATURADOS
	Private nItensD := 0	//ITENS DISTINTOS
	Private l20 	:= .F.
	PRIVATE aProPeds:= {}		// PEDIDOS SEM IMPRESSAO
	PRIVATE LPRJENDER 	:= GetMV("TF_PRJENDR",.F.,.F.)
	PRIVATE aNumPROPed	:= {}		//NUMERO PEDIDOS


	Cursorwait()
	RelerTerm()
	CursorArrow()

	//MONTA A TELA PEDIDOS SEM ONDA/IMPRESSOS
	cFields := " "
	nCampo 	:= 0

	// 01 - QTDE PEDIDOS, 02 - BLOQUEIO
	aTitCampos := {'',OemToAnsi("Situa��o"),OemToAnsi("Qtde.Pedidos")}

	cLine := "{aPeds[o3ListBox:nAT][1],aPeds[o3ListBox:nAT][3],aPeds[o3ListBox:nAT][2],}"

	bLine := &( "{ || " + cLine + " }" )

	@100,005 TO 600,950  DIALOG oDlgNotas TITLE "Controle Centro Distribuicao"

	@ 5,2 TO 70,135 LABEL "Pedidos TAIFF sem Onda/ sem Impress�o" OF oDlgNotas  PIXEL
	o3ListBox := TWBrowse():New( 17,4,130,50,,aTitCampos,,oDlgNotas,,,,,,,,,,,,.F.,,.T.,,.F.,,,)
	o3ListBox:SetArray(aPeds)
	o3ListBox:bLDblClick := { ||Processa( {||WSAT02B(aPeds[o3ListBox:nAT][3],"1") }) }
	o3ListBox:bLine := bLine


	cPLine := "{aProPeds[oListBox:nAT][1],aProPeds[oListBox:nAT][3],aProPeds[oListBox:nAT][2],}"

	bLine := &( "{ || " + cPLine + " }" )

	@ 5,144 TO 70,135+144 LABEL "Pedidos PROART sem Onda/ sem Impress�o" OF oDlgNotas  PIXEL
	oListBox := TWBrowse():New( 17,146,130,50,,aTitCampos,,oDlgNotas,,,,,,,,,,,,.F.,,.T.,,.F.,,,)
	oListBox:SetArray(aProPeds)
	oListBox:bLDblClick := { ||Processa( {||WSAT02B(aProPeds[oListBox:nAT][3],"3") }) }
	oListBox:bLine := bLine

	//MONTA A TELA NOTAS SE SEPARACAO

	// 01 - QTDE NOTAS, 02 - BLOQUEIO
	a2TitCampos := {'',OemToAnsi("Situa��o"),OemToAnsi("Qtde.Notas")}

	c2Line := "{aFats[o2ListBox:nAT][1],aFats[o2ListBox:nAT][3],aFats[o2ListBox:nAT][2],}"

	b2Line := &( "{ || " + c2Line + " }" )
	@ 5,286 TO 70,315+108 LABEL "Notas sem Onda/ sem Separacao" OF oDlgNotas  PIXEL
	o2ListBox := TWBrowse():New( 17,288,130,50,,a2TitCampos,,oDlgNotas,,,,,,,,,,,,.F.,,.T.,,.F.,,,)
	o2ListBox:SetArray(aFats)
	o2ListBox:bLDblClick := { ||Processa( {||WSAT02B(aFats[o2ListBox:nAT][3],"2") }) }
	o2ListBox:bLine := b2Line


	//MONTA TELA ONDA
	c1Fields := " "
	n1Campo 	:= 0

	//01- COR ,02- ONDA, 03- DATA, 04- ORDENS, 05- FALTA, 06- ITENS, 07- ITENS FALTANTES, 08- A SEPARAR, 09- A EMBALAR, 10- SEPARANDO, 11- EMBALANDO,12-TOTAL PECAS, 13-TRAVA , 14 - NOME ONDA
	a1TitCampos := {'',OemToAnsi("Onda"),OemToAnsi("Data Gera��o"),OemToAnsi("Nome Onda"),OemToAnsi("Qtde.Separacao"),OemToAnsi("F.Separacao"),OemToAnsi("Total Peças"),OemToAnsi("Qt.Itens"),;
	OemToAnsi("F.Separa��o(Itens)"),OemToAnsi("Qt.Separar"),OemToAnsi("Separando"),OemToAnsi("Qt.Embalar"),OemToAnsi("Embalando"),OemToAnsi("Trava"),''}

	c1Line := "{aOnda[o1ListBox:nAT][1],aOnda[o1ListBox:nAT][2],aOnda[o1ListBox:nAT][3],aOnda[o1ListBox:nAT][14],aOnda[o1ListBox:nAT][4],aOnda[o1ListBox:nAT][5],aOnda[o1ListBox:nAT][12],aOnda[o1ListBox:nAT][6],"
	c1Line += " aOnda[o1ListBox:nAT][7],aOnda[o1ListBox:nAT][8],aOnda[o1ListBox:nAT][10],aOnda[o1ListBox:nAT][9],aOnda[o1ListBox:nAT][11],aOnda[o1ListBox:nAT][13],}"

	b1Line := &( "{ || " + c1Line + " }" )
	nMult := 7
	aCoord := {nMult*1,nMult*6,nMult*8,nMult*12,nMult*12,nMult*12,nMult*12,nMult*12,nMult*12,nMult*12,nMult*8,nMult*12,nMult*2,''}


	@ 72,2 TO 185,460 LABEL "Status Onda/Pedidos" OF oDlgNotas  PIXEL
	o1ListBox := TWBrowse():New( 80,4,450,080,,a1TitCampos,aCoord,oDlgNotas,,,,,,,,,,,,.F.,,.T.,,.F.,,,)
	o1ListBox:SetArray(aOnda)
	o1ListBox:bLDblClick := { ||Processa( {||WSAT02A(aOnda[o1ListBox:nAt,2],aOnda[o1ListBox:nAt,15]) }) }
	o1ListBox:bLine := b1Line

	@ 165, 005 BITMAP oBmp1 ResName 	"BR_VERDE" OF oDlgNotas Size 15,15 NoBorder When .F. Pixel
	@ 165, 015 SAY "Gerada no dia" OF oDlgNotas Color CLR_GREEN PIXEL

	@ 165, 080 BITMAP oBmp2 ResName 	"BR_VERMELHO" OF oDlgNotas Size 15,15 NoBorder When .F. Pixel
	@ 165, 095 SAY "Atraso" OF oDlgNotas Color CLR_RED PIXEL

	@ 175, 005 BITMAP oBmp3 ResName 	"BR_PRETO" OF oDlgNotas Size 15,15 NoBorder When .F. Pixel
	@ 175, 015 SAY "Encerrada" OF oDlgNotas Color CLR_RED PIXEL

	@ 175, 080 BITMAP oBmp4 ResName 	"BR_AZUL" OF oDlgNotas Size 15,15 NoBorder When .F. Pixel
	@ 175, 095 SAY "Travada" OF oDlgNotas Color CLR_RED PIXEL

	//busca de pedidos
	@ 160,130 Say OemToAnsi("Filial + Ped.Taiff") Size 99,6 Of oDlgNotas Pixel
	@ 160,180 MSGet cPedido Picture "@!" Size 59,8 Of oDlgNotas Pixel

	@ 172,130 Say OemToAnsi("Filial+ Ped.Portal") Size 99,8 Of oDlgNotas Pixel
	@ 172,180 MSGet cPedCli  Size 59,8 Of oDlgNotas Pixel

	@ 172,250 Say OemToAnsi("Filial + NF+ Serie") Size 99,8 Of oDlgNotas Pixel
	@ 172,300 MSGet cNFiscal Picture "@!" F3 "SA1" Size 59,8 Of oDlgNotas Pixel

	@ 172,389 BUTTON "Busca"   	SIZE 20,10 ACTION (U_BuscCliPed(cPedido,cNFiscal,cPedCli),cPedido:= Space(08),cNFiscal:= Space(14),cPedCli:= Space(15),oDlgNotas:Refresh()) PIXEL OF oDlgNotas


	//MONTA A TELA PEDIDOS IMPRESSOS/ONDA ATRASADOS
	c2Fields := " "
	n2Campo 	:= 0

	//01- STATUS, 02-DATA, 03-QTDE PEDIDOS
	a2TitCampos := {OemToAnsi("Status"),OemToAnsi("Data"),OemToAnsi("Qtde.Pedidos"),''}

	c2Line := "{aAtraso[o2ListBox:nAT][1],aAtraso[o2ListBox:nAT][2],aAtraso[o2ListBox:nAT][3],aAtraso[o2ListBox:nAT][4]}"

	b2Line := &( "{ || " + c2Line + " }" )
	/*
	@ 5,145 TO 70,390 LABEL "Pedidos Impressos/Onda em atraso no CD" OF oDlgNotas  PIXEL
	o2ListBox := TWBrowse():New( 17,150,230,50,,a2TitCampos,,oDlgNotas,,,,,,,,,,,,.F.,,.T.,,.F.,,,)
	o2ListBox:SetArray(aAtraso)
	//o2ListBox:bLDblClick := { || MarcaTodos(o2ListBox, .T., .T.,1,o2ListBox:nAt) }
	o2ListBox:bLine := b2Line
	*/
	@ 015,430  SAY oCrono VAR cCrono PIXEL FONT oFnt1 COLOR CLR_BLUE SIZE 55,15 PICTURE "99:99" OF oDlgNotas


	@ 185,2 TO 210,460 LABEL "Totaliza��o Di�ria" OF oDlgNotas  PIXEL
	@ 190, 005 SAY "NF Remessa TAIFF" OF oDlgNotas Color CLR_RED PIXEL
	@ 190, 070 SAY Transform(nNotasR,"@e 99999") OF oDlgNotas Color CLR_RED PIXEL
	@ 198, 005 SAY "R$ Total Remessa" OF oDlgNotas Color CLR_RED PIXEL
	@ 198, 055 SAY Transform(nValR,"@e 9,999,999.99") OF oDlgNotas Color CLR_RED PIXEL

	@ 190, 115 SAY "NF Fatura TAIFF" OF oDlgNotas Color CLR_BLUE PIXEL
	@ 190, 170 SAY Transform(nNotasF,"@e 99999") OF oDlgNotas Color CLR_BLUE PIXEL
	@ 198, 115 SAY "R$ Total Fatura" OF oDlgNotas Color CLR_BLUE PIXEL
	@ 198, 155 SAY Transform(nValF,"@e 9,999,999.99") OF oDlgNotas Color CLR_BLUE PIXEL

	//@ 190, 225 SAY "Soma Itens" OF oDlgNotas Color CLR_GREEN PIXEL
	//@ 190, 275 SAY Transform(nItensS,"@e 99999") OF oDlgNotas Color CLR_GREEN PIXEL
	//@ 198, 225 SAY "Itens Distintos" OF oDlgNotas Color CLR_GREEN PIXEL
	//@ 198, 275 SAY Transform(nItensD,"@e 99999") OF oDlgNotas Color CLR_GREEN PIXEL
	dbSelectArea("SM0")
	//If U_CHECAFUNC(RetCodUsr(),"ACDAT005") .Or. cFilAnt # "02"
	@ 210,005 BUTTON "Gerar Onda"    	SIZE 40,15 ACTION (U_ACDRD002(),oDlgNotas:End(),nOpc := 1) PIXEL OF oDlgNotas
	@ 210,050 BUTTON "Lib.Impress�o"   	SIZE 40,15 ACTION ( U_ACD05LI()) PIXEL OF oDlgNotas
	//	@ 210,095 BUTTON "Impr.Onda"   		SIZE 40,15 ACTION (Processa( {||ImpPOnda(aOnda[o1ListBox:nAt,2]) } ),oDlgNotas:End(),nOpc := 1) PIXEL OF oDlgNotas
	//@ 210,095 BUTTON "Caixaria"   		SIZE 40,15 ACTION (U_WS02CAIXA(aOnda[o1ListBox:nAt,2])) PIXEL OF oDlgNotas
	@ 210,140 BUTTON "Atualizar"    	SIZE 40,15 ACTION (nOpc:=1,oDlgNotas:End()) PIXEL OF oDlgNotas
	@ 210,185 BUTTON "Cancelar Onda"	SIZE 40,15 ACTION {Processa( {|| WSAT2EST() } ),nOpc :=1,oDlgNotas:End()} PIXEL OF oDlgNotas
	//@ 210,230 BUTTON "Risca FDE"		SIZE 40,15 ACTION (Processa( {||U_RiscaFDE()})) PIXEL OF oDlgNotas
	//@ 210,275 BUTTON "Prev.Pedidos"		SIZE 40,15 ACTION (Processa( {||U_PedidosCD()})) PIXEL OF oDlgNotas
	//	@ 210,320 BUTTON "Risca Item"		SIZE 40,15 ACTION (U_RiscaItem()) PIXEL OF oDlgNotas
	@ 210,365 BUTTON "Lib./Trav.Sep." 		SIZE 40,15 ACTION {U_A005LibOnda(aOnda[o1ListBox:nAt,2],"S",aOnda[o1ListBox:nAt,13])} PIXEL OF oDlgNotas
	@ 210,410 BUTTON "Manut.OF"		SIZE 40,15 ACTION {U_TFMNTOF()} PIXEL OF oDlgNotas
	//@ 210,410 BUTTON "Lib./Trav.Pre." 		SIZE 40,15 ACTION {U_LibOnda(aOnda[o1ListBox:nAt,2],"P",aOnda[o1ListBox:nAt,12])} PIXEL OF oDlgNotas

	//@ 230,005 BUTTON "Ped.Pendentes"   	SIZE 40,15 ACTION (Processa( {||ImpPedPend() } ),oDlgNotas:End(),nOpc := 1) PIXEL OF oDlgNotas
	//@ 230,050 BUTTON "Rel.Abastec."		SIZE 40,15 ACTION (U_WS02ABAST()) PIXEL OF oDlgNotas
	//EndIf

	IF LPRJENDER
		@ 230,005 BUTTON "Reserva Aberta"	SIZE 40,15 ACTION (U_TFRESRVABERTA()) PIXEL OF oDlgNotas
		@ 230,050 BUTTON "Transf. Autom"	SIZE 40,15 ACTION (U_TFTRANAUTOM()) PIXEL OF oDlgNotas
	ENDIF
	@ 230,095 BUTTON "Acomp.Separ." 	SIZE 40,15 ACTION {U_A005WMACOMP(aOnda[o1ListBox:nAt,2])} PIXEL OF oDlgNotas
	@ 230,140 BUTTON "Prep. Estorno" 	SIZE 40,15 ACTION {U_TFPREPESTORNO()} PIXEL OF oDlgNotas
	//@ 230,140 BUTTON "Acomp.Pre." 		SIZE 40,15 ACTION {U_A005WMSPCACOMP(aOnda[o1ListBox:nAt,2],"P")} PIXEL OF oDlgNotas
	//@ 230,185 BUTTON "Acomp.Chk." 		SIZE 40,15 ACTION {U_A005WMSPCACOMP(aOnda[o1ListBox:nAt,2],"C")} PIXEL OF oDlgNotas
	@ 230,185 BUTTON "Rel.Rastrea" 		SIZE 40,15 ACTION {U_ESTRL003(),oDlgNotas:Refresh()} PIXEL OF oDlgNotas
	@ 230,230 BUTTON "Rel.Produt." 		SIZE 40,15 ACTION {U_WMSRL001()} PIXEL OF oDlgNotas
	//@ 230,275 BUTTON "Rel.Sobra." 		SIZE 40,15 ACTION {U_A005WSAT02SB(aOnda[o1ListBox:nAt,2]),oDlgNotas:Refresh()} PIXEL OF oDlgNotas
	//@ 230,320 BUTTON "ALERTA"	 		SIZE 40,15 ACTION {U_A005ALERTAONDA()} PIXEL OF oDlgNotas
	@ 230,275 BUTTON "Rel.Separc." 		SIZE 40,15 ACTION {U_TFRELSEPA(),oDlgNotas:Refresh()} PIXEL OF oDlgNotas
	@ 230,320 BUTTON "Rel.Transp." 		SIZE 40,15 ACTION {U_TFRELONDA(),oDlgNotas:Refresh()} PIXEL OF oDlgNotas

	//If U_CHECAFUNC(RetCodUsr(),"ACDAT005") .Or. cFilAnt # "02"
	@ 230,365 BUTTON "Libera Trava" 	SIZE 40,15 ACTION {PutMv("MV__ACDRD2","N")} PIXEL OF oDlgNotas
	//EndIf
	@ 230,410 BUTTON "Sair"        		SIZE 40,15 ACTION {nOpc :=0,oDlgNotas:End()} PIXEL OF oDlgNotas

	oTimer := TTimer():New( 10 * 1000, {||WSAT2AtuCro(1)}, oDlgNotas )
	oTimer:lActive   := .T. // para ativar

	ACTIVATE DIALOG oDlgNotas CENTERED

Return(nOpc)



/*
ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÝÝÝÝÝÝÝÝÝÝÑÝÝÝÝÝÝÝÝÝÝËÝÝÝÝÝÝÝÑÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝËÝÝÝÝÝÝÑÝÝÝÝÝÝÝÝÝÝÝÝÝ»±±
±±ºPrograma  ³ACDAT005  ºAutor  ³Microsiga           º Data ³  03/10/11   º±±
±±ÌÝÝÝÝÝÝÝÝÝÝØÝÝÝÝÝÝÝÝÝÝÊÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÊÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÝÝÝÝÝÝÝÝÝÝØÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

static function RelerTerm()

	dData 	:= dDataBase
	If Dow(dData+2) == 1 //CAIR NO DOMINGO
		dData += 3
	ElseIf Dow(dData+2) = 7 //CAIR NO SABADO
		dData += 2
	Else
		dData += 1
	End


	//ZERA O CRONOMETRO
	nTimeMin := 0
	nTimeSeg := 0
	cTimeAtu := "00:00"
	/*
	//limpa os itens de pedidos deletados do sistema CB7
	cQuery := " SELECT CB7_FILIAL, CB7_ORDSEP FROM "+RetSqlName("CB7")+" WITH(NOLOCK)"
	cQuery += " WHERE CB7_PEDIDO NOT IN (SELECT C5_NUM FROM "+RetSqlName("SC5")+" WITH(NOLOCK) WHERE C5_FILIAL = CB7_FILIAL AND C5_NUM = CB7_PEDIDO AND D_E_L_E_T_ <> '*')"
	cQuery += " AND D_E_L_E_T_ <> '*' AND CB7_FILIAL = '"+cFilAnt+"' AND CB7_PEDIDO <> ''"
	cQuery += " AND CB7_DTEMIS >= '"+Dtos(dDataBase-30)+"'"
	CONOUT("limpa os itens de pedidos deletados do sistema CB7")

	MemoWrite("ACDAT005.SQL",cQuery)

	dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'TRBRELER', .F., .T.)

	Count To nRec

	If nRec >0
	dbSelectArea("TRBRELER")
	dbGoTop()
	While !Eof()
	dbSelectArea("CB7")
	dbSetOrder(1)
	If dbSeek(TRBRELER->CB7_FILIAL+TRBRELER->CB7_ORDSEP)
	RecLock("CB7",.F.)
	dbDelete()
	CB7->(MsUnlock())
	EndIf
	dbSelectArea("TRBRELER")
	dbSkip()
	End
	EndIf
	TRBRELER->(dbCloseArea())


	//limpa os itens de pedidos deletados do sistema
	cQuery := " SELECT CB8_FILIAL, CB8_ORDSEP FROM "+RetSqlName("CB8")+" WITH(NOLOCK)"
	cQuery += " WHERE CB8_ORDSEP NOT IN (SELECT CB7_ORDSEP FROM "+RetSqlName("CB7")+" WITH(NOLOCK) WHERE CB7_FILIAL = CB8_FILIAL AND  CB7_PEDIDO = CB8_PEDIDO AND CB7_ORDSEP = CB8_ORDSEP AND D_E_L_E_T_ <> '*')"
	cQuery += " AND D_E_L_E_T_ <> '*' AND CB8_FILIAL  = '"+cFilAnt+"' AND CB8_PEDIDO <> ''"
	CONOUT("limpa os itens de pedidos deletados do sistema CB8")

	MemoWrite("ACDAT005A.SQL",cQuery)

	dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'TRB', .F., .T.)

	Count To nRec

	If nRec >0
	dbSelectArea("TRB")
	dbGoTop()
	While !Eof()
	dbSelectArea("CB8")
	dbSetOrder(1)
	If dbSeek(TRB->CB8_FILIAL+TRB->CB8_ORDSEP)
	RecLock("CB8",.F.)
	dbDelete()
	CB8->(MsUnlock())
	EndIf
	dbSelectArea("TRB")
	dbSkip()
	End
	EndIf
	TRB->(dbCloseArea())
	*/

	/*
	//SELECIONA OS PEDIDOS COM BLOQUEIOS
	cQuery := " SELECT COUNT(C5_NUM) PEDIDOS FROM "+RetSqlName("SC5")+" C5 WITH(NOLOCK)"
	cQuery += " INNER JOIN "+RetSqlName("SFM")+" FM WITH(NOLOCK) ON FM_TIPO = C5__TPOPER  "
	cQuery += " INNER JOIN "+RetSqlName("SF4")+" F4 WITH(NOLOCK) ON F4_CODIGO = FM_TS AND F4_FILIAL = C5_FILIAL  "
	cQuery += " WHERE C5_NOTA = '' AND C5_PLIB4 IN ('','LIB.IMP') AND C5_FILIAL = '"+xFilial("SC5")+"' "
	cQuery += " AND F4.D_E_L_E_T_ <> '*' AND FM.D_E_L_E_T_ <> '*'  AND C5.D_E_L_E_T_ <> '*'"
	cQuery += " AND  (C5_BLOQE <> '' OR C5_BLOQT <> '' OR C5_BLOQC <> '' OR  C5_BLOQP <> '' OR C5_BLOQD <> '' OR C5__BLOQV <> '')"
	cQuery += " AND F4_ESTOQUE = 'S'"
	cQuery += " AND C5_EMISSAO >= '"+Dtos(dDataBase-90)+"'"
	CONOUT("SELECIONA OS PEDIDOS COM BLOQUEIOS")
	MemoWrite("ACDAT005C.SQL",cQuery)

	dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'TRB', .F., .T.)

	Count To nRec1

	aPeds := {}
	If nRec1 == 0
	aAdd(aPeds,{'',0,""})
	Else

	dbSelectArea("TRB")
	dbGotop()

	While !Eof()

	// 01 - QTDE PEDIDOS, 02 - BLOQUEIO
	aAdd(aPeds,{LoadBitMap(GetResources(),"BR_BRANCO"   ),TRB->PEDIDOS, "Bloqueio"})
	dbSelectArea("TRB")
	dbSkip()
	End
	EndIf
	TRB->(dbCloseArea())
	*/

	/***********************************[    T A I F F   ]***********************************/        
	//SELECIONA OS PEDIDOS LIBERADOS SEM BLOQUEIOS QUE SAO CROSS DOCKING
	/* O FILTRO DEVERÝ ATENDER O PROCESSO DE SEPARACAO ANTES DE FATURAMENTO PARA TANTO COMENTAR A LINHA "AND C9_XFIL <> C9_FILIAL" */
	cQuery := " SELECT C9_PEDIDO, C9_DATALIB " + ENTER
	cQuery += " ,(CASE WHEN C9_XFIL='01' THEN C9_CLIORI ELSE C9_CLIENTE END) AS C9_CLIENTE" + ENTER
	cQuery += " ,(CASE WHEN C9_XFIL='01' THEN C9_LOJORI ELSE C9_LOJA END) AS C9_LOJA" + ENTER
	cQuery += " ,C5_TRANSP " + ENTER
	cQuery += " ,C5_XITEMC " + ENTER
	cQuery += " FROM "+RetSqlName("SC9") +" SC9 WITH(NOLOCK)"+ ENTER
	cQuery += " INNER JOIN "+RetSqlName("SC5") +" SC5 WITH(NOLOCK)"+ ENTER
	cQuery += "	ON C5_FILIAL = C9_FILIAL "+ ENTER
	cQuery += "	AND SC5.D_E_L_E_T_ ='' "+ ENTER
	cQuery += "	AND C5_NUM = C9_PEDIDO "+ ENTER
	//cQuery += "	AND C5__BLOQF = '' "+ ENTER
	//cQuery += "	AND C5__DTLIBF != '' "+ ENTER // bloquear esta linha para que os pedidos 
	cQuery += "	AND (" + ENTER
	cQuery += "		(C5__DTLIBF != '' AND '" + DTOS(DDATABASE) + "'>= C5__DTLIBF AND C5_DTPEDPR='' AND C5__BLOQF = '')" + ENTER
	cQuery += "			OR" + ENTER
	cQuery += "		(C5__DTLIBF != '' AND '" + DTOS(DDATABASE) + "'>= C5__DTLIBF AND C9_XITEM IN ('1','2') AND C5_DTPEDPR != '' AND C5__BLOQF IN ('','G') AND GETDATE() >= (CONVERT(DATETIME,C5_DTPEDPR) - " + ENTER
	cQuery += "				(CASE " + ENTER
	cQuery += "					WHEN (DATEPART(DW,CONVERT(DATETIME,C5_DTPEDPR) )) = 2  THEN 4 " + ENTER
	cQuery += "					WHEN (DATEPART(DW,CONVERT(DATETIME,C5_DTPEDPR) )) = 1  THEN 3 " + ENTER
	cQuery += "					WHEN (DATEPART(DW,CONVERT(DATETIME,C5_DTPEDPR) )) = 7  THEN 2 " + ENTER
	cQuery += "					ELSE 1 " + ENTER
	cQuery += "				END)" + ENTER
	cQuery += "				))" + ENTER
	cQuery += "				)" + ENTER
	cQuery += "	AND C5_YSTSEP  != 'N' " + ENTER // Quando igual a N � por que foi bloqueado para separacao pelo ADM. Vendas
	cQuery += "	AND C5_LIBCOM  != '2' " + ENTER // Pedidos com bloqueio comercial n�o ser�o apresentados
	//cQuery += "	AND '" + DTOS(DDATABASE) + "'>= C5__DTLIBF "+ ENTER
	cQuery += " INNER JOIN "+RetSqlName("SA4")+" SA4 WITH(NOLOCK) " + ENTER
	cQuery += "	ON SA4.D_E_L_E_T_ = '' " + ENTER
	cQuery += "	AND A4_COD=C5_TRANSP " + ENTER
	cQuery += "	AND A4_CGC != '' " + ENTER			
	cQuery += " WHERE SC9.D_E_L_E_T_ <> '*' " + ENTER
	cQuery += " AND C9_FILIAL = '"+cFilAnt+"'" + ENTER
	cQuery += " AND C9_NFISCAL  = '' " + ENTER // AND C9_XITEM = '1'
	cQuery += " AND C9_XITEM IN ('1','2') " + ENTER 
	cQuery += " AND C9_ORDSEP='' " + ENTER
	cQuery += " AND C9_BLEST != '02'  " + ENTER
	// cQuery += " AND C9_XFIL <> C9_FILIAL " + ENTER
	cQuery += " AND C9_LOCAL='21' " + ENTER
	cQuery += " GROUP BY C9_PEDIDO,C9_DATALIB, C9_CLIORI , C9_LOJORI,C9_XFIL,C9_CLIENTE,C9_LOJA,C5_TRANSP,C5_XITEMC" + ENTER

	//CONOUT("SELECIONA OS PEDIDOS SEM BLOQUEIOS")
	MemoWrite("ACDAT005A_TAIFF.SQL",cQuery)

	dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'TRB', .F., .T.)
	TcSetField("TRB","C9_DATALIB","D")


	Count To nRec1
	CursorArrow()

	aPeds := {}
	aProPeds := {}
	If nRec1 == 0
		aAdd(aPeds,{'',0,""})
		aAdd(aProPeds,{'',0,""})
	Else

		dbSelectArea("TRB")
		dbGotop()

		While !Eof()
			nAscan := 0
			cDias := ""
			cBitMap := "" //LoadBitMap(GetResources(),"BR_VERMELHO"   )
			nPedidos:= ""
			If ALLTRIM(TRB->C5_XITEMC) = "TAIFF"
				If  TRB->C9_DATALIB >= dData-1 	 //2 DIAS
					nAscan := Ascan(aPeds, {|e| e[3] == "1 Dia"})
					cDias := "1 Dia"
					cBitMap := LoadBitMap(GetResources(),"BR_VERDE"   )
					nPedidos:= TRB->C9_PEDIDO
				ElseIf  TRB->C9_DATALIB == dData-2	//1 DIA
					nAscan := Ascan(aPeds, {|e| e[3] == "Dia"})
					cDias := "Dia"
					cBitMap := LoadBitMap(GetResources(),"BR_AMARELO"   )
					nPedidos:= TRB->C9_PEDIDO
				Else //ATRASO
					nAscan := Ascan(aPeds, {|e| e[3] == "Atraso"})
					cDias := "Atraso"
					cBitMap := LoadBitMap(GetResources(),"BR_VERMELHO"   )
					nPedidos:= TRB->C9_PEDIDO
				EndIf

				// 01 - QTDE PEDIDOS, 02 - BLOQUEIO		
				If nAscan == 0
					aAdd(aPeds,{cBitMap,1,cDias})
				Else
					aPeds[nAscan][2]++
				EndIf

				//aNumPed - 01-PEDIDO, 02- SITUACAO, 03-NOME, 04- LIBERACAO, 05- TRANSPORTADORA
				aAdd(aNumPed,{TRB->C9_PEDIDO,cDias,Posicione("SA1",1,xFilial("SA1")+TRB->C9_CLIENTE+TRB->C9_LOJA,"A1_NOME"),TRB->C9_DATALIB,TRB->C5_TRANSP})
			ElseIf ALLTRIM(TRB->C5_XITEMC) = "PROART"
				If  TRB->C9_DATALIB >= dData-1 	 //2 DIAS
					nAscan := Ascan(aProPeds, {|e| e[3] == "1 Dia"})
					cDias := "1 Dia"
					cBitMap := LoadBitMap(GetResources(),"BR_VERDE"   )
					nPedidos:= TRB->C9_PEDIDO
				ElseIf  TRB->C9_DATALIB == dData-2	//1 DIA
					nAscan := Ascan(aProPeds, {|e| e[3] == "Dia"})
					cDias := "Dia"
					cBitMap := LoadBitMap(GetResources(),"BR_AMARELO"   )
					nPedidos:= TRB->C9_PEDIDO
				Else //ATRASO
					nAscan := Ascan(aProPeds, {|e| e[3] == "Atraso"})
					cDias := "Atraso"
					cBitMap := LoadBitMap(GetResources(),"BR_VERMELHO"   )
					nPedidos:= TRB->C9_PEDIDO
				EndIf

				// 01 - QTDE PEDIDOS, 02 - BLOQUEIO		
				If nAscan == 0
					aAdd(aProPeds,{cBitMap,1,cDias})
				Else
					aProPeds[nAscan][2]++
				EndIf

				//aNumPed - 01-PEDIDO, 02- SITUACAO, 03-NOME, 04- LIBERACAO, 05- TRANSPORTADORA
				aAdd(aNumProPed,{TRB->C9_PEDIDO,cDias,Posicione("SA1",1,xFilial("SA1")+TRB->C9_CLIENTE+TRB->C9_LOJA,"A1_NOME"),TRB->C9_DATALIB,TRB->C5_TRANSP})

			ENDIF
			dbSelectArea("TRB")
			dbSkip()
		End
	EndIf
	TRB->(dbCloseArea())

	IF len(aProPeds) = 0
		aAdd(aProPeds,{'',0,""})
	ENDIF
	IF len(aPeds) = 0
		aAdd(aPeds,{'',0,""})
	ENDIF

	/* A TRANSPORTADORA SEM CGC NAO LEVA PARA O CROSS DOCKING */
	//SELECIONA AS NOTAS QUE NAO FORAM SEPARADAS
	//SOMENTE PEDIDOS TAIFF
	//TES COM CFOP 5927 FURTO/PERDA         
	cQuery := " select F2.* FROM "+RetSqlName("SF2")+" F2 WITH(NOLOCK) " + ENTER
	cQuery += " INNER JOIN "+RetSqlName("SA4")+" SA4 WITH(NOLOCK) " + ENTER
	cQuery += " ON SA4.D_E_L_E_T_ = '' " + ENTER
	cQuery += " AND A4_COD=F2_TRANSP " + ENTER
	cQuery += " AND A4_CGC != '' " + ENTER			
	cQuery += " WHERE F2_FILIAL = '"+cFilAnt+"'" + ENTER
	cQuery += " AND F2.D_E_L_E_T_ <> '*'" + ENTER
	cQuery += " AND RTRIM(LTRIM(F2_NUMRM)) <> 'CROSS'" + ENTER
	cQuery += " AND F2_TIPO = 'N'" + ENTER
	cQuery += " AND F2_FILIAL + F2_DOC + F2_SERIE NOT IN (SELECT CB7_FILIAL+CB7_NOTA+CB7_SERIE  FROM "+RetSqlName("CB7")+" WITH(NOLOCK) WHERE CB7_FILIAL = F2_FILIAL AND CB7_NOTA = F2_DOC AND CB7_SERIE = F2_SERIE AND D_E_L_E_T_ <> '*' )" + ENTER
	cQuery += " AND F2_EMISSAO >= '"+Dtos(dDataBase-120)+"'" + ENTER
	cQuery += " AND F2_DOC IN (SELECT D2_DOC FROM " + RetSqlName("SD2") + " D2 WITH(NOLOCK)" + ENTER
	cQuery += " 	INNER JOIN "+RetSqlName("SF4")+" SF4 WITH(NOLOCK) " + ENTER
	cQuery += " 		ON SF4.D_E_L_E_T_='' " + ENTER
	cQuery += " 		AND F4_CODIGO=D2_TES " + ENTER
	cQuery += " 		AND F4_FILIAL=D2_FILIAL " + ENTER
	cQuery += " 		AND F4_ESTOQUE='S' " + ENTER
	cQuery += " 		AND RTRIM(LTRIM(F4_CF)) NOT IN ('5927') " + ENTER
	cQuery += " 	WHERE D2_DOC = F2_DOC AND D2_SERIE = F2_SERIE AND D2_FILIAL = F2_FILIAL AND D2_ITEMCC = 'TAIFF' AND D2.D_E_L_E_T_ <> '*')" + ENTER
	cQuery += " 	AND '' = ISNULL((SELECT MAX(CB7_STATUS) " + ENTER
	cQuery += " 			FROM SC9030 SC9 " + ENTER
	cQuery += " 			INNER JOIN CB7030 CB7" + ENTER
	cQuery += " 			ON CB7_FILIAL = C9_FILIAL" + ENTER
	cQuery += " 			AND CB7_PEDIDO = C9_PEDIDO" + ENTER
	cQuery += " 			AND CB7.D_E_L_E_T_ = ''" + ENTER
	cQuery += " 			WHERE C9_FILIAL=F2_FILIAL AND C9_NFISCAL=F2_DOC AND C9_SERIENF=F2_SERIE AND SC9.D_E_L_E_T_ = ''),'')" + ENTER


	CONOUT("SELECIONA OS PEDIDOS SEM BLOQUEIOS")
	MemoWrite("ACDAT005B.SQL",cQuery)

	dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'TRB', .F., .T.)
	TcSetField("TRB","F2_EMISSAO","D")


	Count To nRec1
	CursorArrow()
	aFats := {}
	If nRec1 == 0
		aAdd(aFats,{'',0,""})
	Else	
		dbSelectArea("TRB")
		dbGotop()

		While !Eof()

			If  TRB->F2_EMISSAO >= dData-1
				nAscan := Ascan(aFats, {|e| e[3] == "1 Dia"})
				cDias := "1 Dia"
				cBitMap := LoadBitMap(GetResources(),"BR_VERDE"   )
				nPedidos:= TRB->F2_EMISSAO
			ElseIf  TRB->F2_EMISSAO == dData-2	//1 DIA
				nAscan := Ascan(aFats, {|e| e[3] == "Dia"})
				cDias := "Dia"
				cBitMap := LoadBitMap(GetResources(),"BR_AMARELO"   )
				nPedidos:= TRB->F2_EMISSAO
			Else //ATRASO
				nAscan := Ascan(aFats, {|e| e[3] == "Atraso"})
				cDias := "Atraso"
				cBitMap := LoadBitMap(GetResources(),"BR_VERMELHO"   )
				nPedidos:= TRB->F2_EMISSAO
			EndIf

			// 01 - QTDE PEDIDOS, 02 - BLOQUEIO		
			If nAscan == 0
				aAdd(aFats,{cBitMap,1,cDias})
			Else
				aFats[nAscan][2]++
			EndIf
			//aNumFat - 01-NOTA, 02- SITUACAO, 03- CLIENTE, 04-EMISSAO
			aAdd(aNumFat,{TRB->F2_DOC,cDias,Posicione("SA1",1,xFilial("SA1")+TRB->F2_CLIENTE+TRB->F2_LOJA,"A1_NOME"),TRB->F2_EMISSAO})

			dbSelectArea("TRB")
			dbSkip()
		End
	EndIf
	TRB->(dbCloseArea())

	//SELECIONA A SITUACAO DA ONDAS EM ABERTO
	cQuery := " select  "
	cQuery += " CB7_DTEMIS ,CB7__PRESE, CB7__NOME, ISNULL(SUM(CB8_QTDORI),0) TOTAL_PECAS,"
	cQuery += " (SELECT COUNT(CB72.CB7_ORDSEP ) FROM "+RetSqlName("CB7")+" CB72 WITH(NOLOCK) WHERE CB7.CB7_FILIAL = CB72.CB7_FILIAL AND CB72.D_E_L_E_T_ <> '*' AND CB72.CB7__PRESE  = CB7.CB7__PRESE  AND CB72.CB7_STATUS = '0' )  A_SEPARAR, "
	cQuery += " (SELECT COUNT(CB72.CB7_ORDSEP) FROM "+RetSqlName("CB7")+" CB72 WITH(NOLOCK) WHERE CB7.CB7_FILIAL = CB72.CB7_FILIAL AND CB72.D_E_L_E_T_ <> '*' AND CB72.CB7__PRESE  = CB7.CB7__PRESE  AND CB72.CB7_STATUS = '1' )  SEPARANDO,  
	cQuery += " (SELECT COUNT(CB72.CB7_ORDSEP) FROM "+RetSqlName("CB7")+" CB72 WITH(NOLOCK) WHERE CB7.CB7_FILIAL = CB72.CB7_FILIAL AND CB72.D_E_L_E_T_ <> '*' AND CB72.CB7__PRESE  = CB7.CB7__PRESE  AND CB72.CB7_STATUS <= '2' )  A_EMBALAR, 
	cQuery += " (SELECT COUNT(CB72.CB7_ORDSEP) FROM "+RetSqlName("CB7")+" CB72 WITH(NOLOCK) WHERE CB7.CB7_FILIAL = CB72.CB7_FILIAL AND CB72.D_E_L_E_T_ <> '*' AND CB72.CB7__PRESE  = CB7.CB7__PRESE  AND CB72.CB7_STATUS = '3' )  EMBALANDO,   
	cQuery += " (SELECT COUNT(CB72.CB7_ORDSEP) FROM "+RetSqlName("CB7")+" CB72 WITH(NOLOCK) WHERE CB7.CB7_FILIAL = CB72.CB7_FILIAL AND CB72.D_E_L_E_T_ <> '*' AND CB72.CB7__PRESE  = CB7.CB7__PRESE  AND CB72.CB7_STATUS = '9' )  FINALIZADO, 

	cQuery += " COUNT(DISTINCT(CB8_PROD)) TOTAL_ITENS, COUNT(DISTINCT(CB7_ORDSEP))ORDSEP, COUNT(CB8_PROD) ITENS, "
	cQuery += " (SELECT count(CB8_PROD) FROM "+RetSqlName("CB8")+" CB82 WITH(NOLOCK) INNER JOIN "+RetSqlName("CB7")+" CB72 WITH(NOLOCK) ON CB72.CB7_FILIAL = CB82.CB8_FILIAL AND CB72.CB7_ORDSEP = CB82.CB8_ORDSEP WHERE CB72.D_E_L_E_T_ <> '*' AND CB82.D_E_L_E_T_ <> '*' AND CB72.CB7__PRESE = CB7.CB7__PRESE AND CB8_SALDOS > 0) ITENS_SEPARACAO,   

	cQuery += " CB7__TRAVA, CB7_ORIGEM"
	cQuery += " FROM "+RetSqlName("CB7")+" CB7 WITH(NOLOCK)"
	cQuery += " LEFT JOIN "+RetSqlName("CB8")+ " CB8 WITH(NOLOCK) ON CB7_FILIAL = CB8_FILIAL AND CB7_ORDSEP = CB8_ORDSEP AND CB8.D_E_L_E_T_ <> '*'"
	cQuery += " WHERE CB7.D_E_L_E_T_ <> '*' "
	cQuery += " AND CB7_FILIAL = '"+xFilial("CB7")+"'"
	cQuery += " AND CB7_DTEMIS >= '"+Dtos(dDataBase-30)+"'"
	cQuery += " AND CB7__PRESE  <> ''
	cQuery += " GROUP BY CB7_DTEMIS ,CB7__PRESE, CB7__NOME, CB7_FILIAL,CB7__TRAVA, CB7_ORIGEM"

	cQuery += "  HAVING( COUNT(DISTINCT(CB7_ORDSEP)) <> (SELECT COUNT(CB72.CB7_ORDSEP ) FROM "+RetSqlName("CB7")+" CB72 WHERE CB7.CB7_FILIAL = CB72.CB7_FILIAL AND CB72.D_E_L_E_T_ <> '*' AND CB72.CB7__PRESE = CB7.CB7__PRESE AND CB72.CB7_STATUS  = '9'))"
	cQuery += " ORDER BY CB7__PRESE DESC"

	CONOUT("SELECIONA A SITUACAO DA ONDAS EM ABERTO")

	MemoWrite("ACDAT005C.SQL",cQuery)

	dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'TRB', .F., .T.)

	TcSetField("TRB","CB7_DTEMIS","D")

	Count To nRec1
	CursorArrow()
	aOnda := {}
	If nRec1 == 0
		//01- COR ,02- ONDA, 03- DATA, 04- ORDENS, 05- FALTA, 06- ITENS, 07- ITENS FALTANTES, 08- A SEPARAR, 09- A EMBALAR, 10- SEPARANDO, 11- EMBALANDO,12-TOTAL PECAS, 13-TRAVA , 14 - NOME ONDA, 15- ORIGEM
		aAdd(aOnda,{'',"",cTod(""),0,0,0,0,0,0,0,0,0,'','',''})
	Else
		dbSelectArea("TRB")
		ProcRegua(nRec1)
		dbGotop()

		While !Eof()

			IncProc("Calculando as Ondas")
			cCor := Iif(TRB->ORDSEP == TRB->FINALIZADO,LoadBitMap(GetResources(),"BR_PRETO"),Iif(TRB->CB7_DTEMIS==dDataBase,LoadBitMap(GetResources(),"BR_VERDE"),LoadBitMap(GetResources(),"BR_VERMELHO")))
			cCor := Iif(TRB->CB7__TRAVA = "S" ,LoadBitMap(GetResources(),"BR_AZUL"),cCor)
						//01- COR 	,02- ONDA			, 03- DATA			, 04- ORDENS	, 05- FALTA					, 06- ITENS	, 07- ITENS FALTANTES	, 08- A SEPARAR	, 09- A EMBALAR	, 10- SEPARANDO	, 11- EMBALANDO	,12-TOTAL PECAS, 13-TRAVA , 14 - NOME ONDA
			aAdd(aOnda,{cCor		,TRB->CB7__PRESE	,TRB->CB7_DTEMIS	,TRB->ORDSEP	,TRB->ORDSEP-TRB->FINALIZADO	,TRB->ITENS	,TRB->ITENS_SEPARACAO	,TRB->A_SEPARAR	,TRB->A_EMBALAR	,TRB->SEPARANDO	,TRB->EMBALANDO	,TRB->TOTAL_PECAS, TRB->CB7__TRAVA,TRB->CB7__NOME, TRB->CB7_ORIGEM})
			dbSelectArea("TRB")
			dbSkip()
		End
	EndIf
	TRB->(dbCloseArea())

	ASort(aOnda,,,{|x,y|x[2]<y[2]})
	/*
	//SELECIONA OS PEDIDOS EM ATRASO
	cQuery := " SELECT COUNT(C5_NUM) PEDIDOS, C5_DLIB4 FROM "+RetSqlName("SC5")+" C5 WITH(NOLOCK)"
	cQuery += " INNER JOIN "+RetSqlName("SFM")+" FM WITH(NOLOCK) ON FM_TIPO = C5__TPOPER  "
	cQuery += " INNER JOIN "+RetSqlName("SF4")+" F4 WITH(NOLOCK) ON F4_CODIGO = FM_TS AND F4_FILIAL = C5_FILIAL  "
	cQuery += " WHERE C5_NOTA = ''  AND C5_PLIB4 NOT IN ('','LIB.IMP') AND C5_FILIAL = '"+xFilial("SC5")+"'"
	cQuery += " AND  C5_BLOQE = '' AND C5_BLOQT = '' AND C5_BLOQC = '' AND  C5_BLOQP = '' AND C5_BLOQD = ''"
	cQuery += " AND F4.D_E_L_E_T_ <> '*' AND FM.D_E_L_E_T_ <> '*'  AND C5.D_E_L_E_T_ <> '*'"
	cQuery += " AND F4_ESTOQUE = 'S'"
	cQuery += " AND C5_EMISSAO >= '"+Dtos(dDataBase-90)+"'"
	cQuery += " GROUP BY C5_DLIB4"

	CONOUT("SELECIONA OS PEDIDOS EM ATRASO")
	MemoWrite("ACDAT005B.SQL",cQuery)

	dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'TRB', .F., .T.)

	TcSetField("TRB","C5_DLIB4","D")
	Count To nRec1
	aAtraso := {}
	If nRec1 == 0
	aAdd(aAtraso,{'',cTod(""),0,''})
	Else


	dbSelectArea("TRB")
	dbGotop()

	While !Eof()
	//01- STATUS, 02-DATA, 03-QTDE PEDIDOS
	If !Empty(TRB->C5_DLIB4)
	aAdd(aAtraso,{Iif(TRB->C5_DLIB4 < dDataBase,'Atraso','Em dia'),TRB->C5_DLIB4, TRB->PEDIDOS,''})
	Else
	aAdd(aAtraso,{'',cTod(""),0,''})
	EndIf
	dbSelectArea("TRB")
	dbSkip()
	End
	EndIf
	TRB->(dbCloseArea())
	*/
	//TOTALIZACAO DO DIA
	cQuery := " SELECT COUNT(DISTINCT(F2_DOC))NOTAS, SUM(D2_TOTAL) TOTAL, F4_ESTOQUE, F4_DUPLIC"
	cQuery += " FROM "+RetSqlName("SF2")+" F2 WITH(NOLOCK)"
	cQuery += " INNER JOIN "+RetSqlName("SD2")+" D2 WITH(NOLOCK) ON D2_DOC = F2_DOC AND D2_SERIE = F2_SERIE AND D2_FILIAL = F2_FILIAL"
	cQuery += " INNER JOIN "+RetSqlName("SF4")+" F4 WITH(NOLOCK) ON F4_CODIGO = D2_TES AND F4_FILIAL = D2_FILIAL"
	cQuery += " WHERE"
	cQuery += " F2_EMISSAO = '"+Dtos(dDataBase)+"' AND D2_ITEMCC = 'TAIFF'"
	cQuery += " AND F2.D_E_L_E_T_ <> '*' AND D2.D_E_L_E_T_ <> '*' AND F4.D_E_L_E_T_ <> '*'"
	cQuery += " AND F2_FILIAL = '"+xFilial("SF2")+"'"
	//cQuery += " AND D2_CLIENTE NOT IN ('000029','109394','119576','120121','122225','126043')"
	cQuery += " GROUP BY F4_ESTOQUE, F4_DUPLIC"

	CONOUT("TOTALIZACAO DO DIA")

	dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'TRB', .F., .T.)

	Count To nRec1
	nNotasF := 0	//NOTAS FATURA
	nNotasR := 0	//NOTAS REMESSA
	nValF	:= 0	//TOTAL FATURA
	nValR	:= 0	//TOTAL REMESSA

	If nRec1 > 0

		dbSelectArea("TRB")
		dbGotop()

		While !Eof()
			If F4_DUPLIC == "S" .And. F4_ESTOQUE == "S"
				nNotasF += TRB->NOTAS
				nValF	+= TRB->TOTAL
			ElseIf F4_ESTOQUE == "S"
				nValR	+= TRB->TOTAL
				nNotasR += TRB->NOTAS
			EndIf

			dbSelectArea("TRB")
			dbSkip()
		End
	EndIf
	TRB->(dbCloseArea())


return (.T.)

/*
ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÝÝÝÝÝÝÝÝÝÝÑÝÝÝÝÝÝÝÝÝÝËÝÝÝÝÝÝÝÑÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝËÝÝÝÝÝÝÑÝÝÝÝÝÝÝÝÝÝÝÝÝ»±±
±±ºPrograma  ³ACDAT005  ºAutor  ³Microsiga           º Data ³  03/10/11   º±±
±±ÌÝÝÝÝÝÝÝÝÝÝØÝÝÝÝÝÝÝÝÝÝÊÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÊÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÝÝÝÝÝÝÝÝÝÝØÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function WSAT2AtuCro(nTipo)
	Local cTimeAtu := ""

	cTimeOut := "15:00"

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

/*/
	If cTimeAtu >= "14:30" .Or. nTipo == 2
		oDlgNotas:End()
		U_ACDAT005()
	EndIf
/*/
	cCrono := cTimeAtu
	oCrono:Refresh()


Return(.T.)


/*
ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÝÝÝÝÝÝÝÝÝÝÑÝÝÝÝÝÝÝÝÝÝËÝÝÝÝÝÝÝÑÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝËÝÝÝÝÝÝÑÝÝÝÝÝÝÝÝÝÝÝÝÝ»±±
±±ºPrograma  ³WSAT2EST  ºAutor  ³Microsiga           º Data ³  03/22/11   º±±
±±ÌÝÝÝÝÝÝÝÝÝÝØÝÝÝÝÝÝÝÝÝÝÊÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÊÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝ¹±±
±±ºDesc.     ³ESTORNA UMA ONDA                                            º±±
±±º          ³                                                            º±±
±±ÌÝÝÝÝÝÝÝÝÝÝØÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function WSAT2EST()
	Local cOnda := Space(06)
	//Local lExclui := .T.
	Local cUsuLib
	LOCAL CSC5PEDIDO	:= ""

	dbSelectArea("SM0")
	cUsuLib := RetCodUsr()

	If MsgYesNo("Deseja cancelar a Onda?","ACDAT005")

		@ 65,153 To 229,435 Dialog oDlg Title OemToAnsi("Cancelamento de Onda")
		@ 9,9 Say OemToAnsi("Onda") Size 99,8 PIXEL OF oDlg
		@ 28,9 Get cOnda Picture "@!" F3 "CB7" Size 59,10
		@ 62,39 BMPBUTTON TYPE 1 ACTION Close(oDlg)
		Activate Dialog oDlg Centered

		If !Empty(cOnda)
			//VERIFICA SE A ONDA EXISTE
			cQuery := " SELECT * FROM "+RetSqlName("CB7")+" WITH(NOLOCK)"
			cQuery += " WHERE CB7__PRESE = '"+cOnda+"' AND D_E_L_E_T_ <> '*' AND CB7_FILIAL = '"+xFilial("CB7")+"'"

			MEMOWRITE("WSAT2EST.SQL",cQuery)
			dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),"TRB", .F., .T.)

			Count To nRec
			If nRec = 0
				MsgStop("Esta Onda N�o existe!","ACDAT005")
				TRB->(dbCloseArea())
				Return(.F.)
			EndIf
			TRB->(dbCloseArea())

			//VERIFICA SE A ONDA PODE SER APAGADA
			cQuery := " SELECT * FROM "+RetSqlName("CB9")+" WITH(NOLOCK)"
			cQuery += " WHERE D_E_L_E_T_ <> '*' AND CB9_FILIAL = '"+xFilial("CB9")+"' AND CB9_ORDSEP IN
			cQuery += " (SELECT CB7_ORDSEP FROM "+RetSqlName("CB7")+" WITH(NOLOCK) WHERE CB7__PRESE = '"+cOnda+"' AND D_E_L_E_T_ <> '*' AND CB7_FILIAL = CB9_FILIAL )"

			MEMOWRITE("WSAT2EST.SQL",cQuery)
			dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),"TRB", .F., .T.)

			Count To nRec

			If nRec > 0
				MsgStop("Esta Onda J� possui movimentacao!","ACDAT005")
				TRB->(dbCloseArea())
				Return(.F.)
			EndIf
			TRB->(dbCloseArea())

			Begin Transaction
				//LIMPA STATUS SC9
				cQuery := " SELECT DISTINCT(C9_PEDIDO) PEDIDO FROM "+RetSqlName("SC9")+" C9 WITH(NOLOCK)"
				cQuery += " WHERE C9_FILIAL = '"+xFilial("SC9")+"' AND C9_NFISCAL = '' AND C9.D_E_L_E_T_ <> '*'"
				cQuery += " AND C9_PEDIDO IN"
				cQuery += " (SELECT CB7_PEDIDO FROM "+RetSqlName("CB7")+" WITH(NOLOCK) WHERE CB7__PRESE = '"+cOnda+"' AND D_E_L_E_T_ <> '*' AND CB7_FILIAL = C9_FILIAL  AND CB7_PEDIDO <> '')"

				MemoWrite("WSAT2EST1.SQL",cQuery)
				dbUseArea(.T.,"TOPCONN", TCGenQry(,,cQuery),"TRB", .F., .T.)

				Count To nRec

				If nRec > 0
					ProcRegua(nRec)
					dbSelectArea("TRB")
					dbGoTop()

					While !Eof()
						IncProc("Liberando Pedidos")
						dbSelectArea("SC9")
						dbSetOrder(1)
						dbSeek(xFilial()+TRB->PEDIDO)

						While !Eof() .And. SC9->C9_PEDIDO == TRB->PEDIDO .And. SC9->C9_FILIAL == xFilial("SC9")
							IF EMPTY(SC9->C9_NFISCAL)
								RecLock("SC9",.F.)
								SC9->C9_ORDSEP := ""
								SC9->(MsUnlock())
							ENDIF
							dbSkip()
						End

						dbSelectArea("TRB")
						dbSkip()
					End
				Else //SELECIONA ITENS NOTAS
					TRB->(dbCloseArea())
					//LIMPA STATUS SD2
					cQuery := " SELECT DISTINCT(D2_DOC) DOC, D2_SERIE SERIE FROM "+RetSqlName("SD2")+" D2 WITH(NOLOCK)"
					cQuery += " WHERE D2_FILIAL = '"+xFilial("SD2")+"' AND D2.D_E_L_E_T_ <> '*'"
					cQuery += " AND D2_DOC+D2_SERIE IN"
					cQuery += " (SELECT CB7_NOTA+CB7_SERIE FROM "+RetSqlName("CB7")+" WITH(NOLOCK) WHERE CB7__PRESE = '"+cOnda+"' AND D_E_L_E_T_ <> '*' AND CB7_FILIAL = D2_FILIAL  AND CB7_PEDIDO = '')"

					MemoWrite("WSAT2EST1.SQL",cQuery)
					dbUseArea(.T.,"TOPCONN", TCGenQry(,,cQuery),"TRB", .F., .T.)

					Count To nRec

					If nRec > 0
						ProcRegua(nRec)
						dbSelectArea("TRB")
						dbGoTop()

						While !Eof()
							IncProc("Liberando Notas")
							dbSelectArea("SD2")
							dbSetOrder(3)
							dbSeek(xFilial()+TRB->DOC+TRB->SERIE)

							While !Eof() .And. SD2->D2_DOC == TRB->DOC .And. SD2->D2_SERIE == TRB->SERIE .And. SD2->D2_FILIAL == xFilial("SD2")
								RecLock("SD2",.F.)
								D2_ORDSEP := ""
								SD2->(MsUnlock())
								dbSelectArea("SD2")
								dbSkip()
							End

							dbSelectArea("TRB")
							dbSkip()
						End
					EndIf
				EndIf
				TRB->(dbCloseArea())

				//LIMPA OS ITENS DA ONDA
				cQuery := " SELECT CB8_FILIAL, CB8_ORDSEP FROM "+RetSqlName("CB8")+" WITH(NOLOCK)"
				cQuery += " WHERE CB8_ORDSEP IN (SELECT CB7_ORDSEP FROM "+RetSqlName("CB7")+" WITH(NOLOCK) WHERE CB7_FILIAL = CB8_FILIAL  AND CB7_ORDSEP = CB8_ORDSEP AND D_E_L_E_T_ <> '*' AND CB7__PRESE = '"+cOnda+"')"
				cQuery += " AND D_E_L_E_T_ <> '*' AND CB8_FILIAL  = '"+cFilAnt+"' "
				CONOUT("limpa os itens de pedidos deletados do sistema CB8")

				MemoWrite("WSAT2EST2.SQL",cQuery)

				dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'TRB', .F., .T.)

				Count To nRec

				If nRec >0
					ProcRegua(nRec)
					dbSelectArea("TRB")
					dbGoTop()
					While !Eof()
						IncProc("Apagando itens onda")
						dbSelectArea("CB8")
						dbSetOrder(1)
						If dbSeek(TRB->CB8_FILIAL+TRB->CB8_ORDSEP)
							RecLock("CB8",.F.)
							dbDelete()
							CB8->(MsUnlock())
						EndIf
						dbSelectArea("TRB")
						dbSkip()
					End
				EndIf
				TRB->(dbCloseArea())

				//LIMPA OS CABECALHOS DA ONDA
				cQuery := " SELECT CB7_FILIAL, CB7_ORDSEP FROM "+RetSqlName("CB7")+" WITH(NOLOCK)"
				cQuery += " WHERE D_E_L_E_T_ <> '*' AND CB7_FILIAL = '"+cFilAnt+"' AND CB7__PRESE = '"+cOnda+"'"

				MemoWrite("WSAT2EST3.SQL",cQuery)
				CONOUT("limpa os cabecalhos da Onda")
				dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'TRB', .F., .T.)

				Count To nRec

				If nRec >0
					ProcRegua(nRec)
					dbSelectArea("TRB")
					dbGoTop()
					While !Eof()
						IncProc("Apagando cabecalho Onda")
						dbSelectArea("CB7")
						dbSetOrder(1)
						If dbSeek(TRB->CB7_FILIAL+TRB->CB7_ORDSEP)
							CSC5PEDIDO := CB7->CB7_PEDIDO
							RecLock("CB7",.F.)
							dbDelete()
							CB7->(MsUnlock())

							SC5->(DBSETORDER(1))
							IF SC5->(DBSEEK( xFilial("SC5") + CSC5PEDIDO ))
								IF SC5->(RECLOCK("SC5",.F.))
									SC5->C5_YSTSEP := ""
									SC5->(MsUnlock())
								ENDIF
							ENDIF

						EndIf
						dbSelectArea("TRB")
						dbSkip()
					End
				EndIf
				TRB->(dbCloseArea())
			End Transaction
			MsgInfo("Onda "+cOnda+" cancelada com Sucesso!")
		EndIf
	EndIf
Return





/*
ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÝÝÝÝÝÝÝÝÝÝÑÝÝÝÝÝÝÝÝÝÝËÝÝÝÝÝÝÝÑÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝËÝÝÝÝÝÝÑÝÝÝÝÝÝÝÝÝÝÝÝÝ»±±
±±ºPrograma  ³TKRD17CP  ºAutor  ³Paulo Bindo         º Data ³  03/08/12   º±±
±±ÌÝÝÝÝÝÝÝÝÝÝØÝÝÝÝÝÝÝÝÝÝÊÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÊÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝ¹±±
±±ºDesc.     ³EXIBE OS PEDIDOS DA ONDA                                    º±±
±±º          ³                                                            º±±
±±ÌÝÝÝÝÝÝÝÝÝÝØÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function WSAT02A(cOnda,cOrigem)
	//Local oDlgPeds,oFatur,oASep,oSep
	Local oDlgPeds
	//LOCAL oFatur
	//LOCAL oASep
	//LOCAL oSep
	//Local dData 	:= dDataBase
	Local lAlter    := .F.
	//Local cFDE		:= "N"
	//Local nFatur 	:= 0
	//Local nAsep  	:= 0
	//Local nSep   	:= 0
	Local K			:= 0

	Private aPedsB := {}
	Private oAListBox

	cQuery := " SELECT C5_FILIAL,C5_NUM ,  C5_CLIENTE, A1_NOME, A3_NREDUZ,C5_TRANSP,"
	If cOrigem == "1" //PEDIDO
		cQuery += " (SELECT TOP 1 CB7__SEQPR FROM "+RetSqlName("CB7")+" WHERE CB7_FILIAL = C5_FILIAL AND CB7_PEDIDO = C5_NUM AND D_E_L_E_T_ <> '*') CB7__SEQPR,
		cQuery += " (SELECT TOP 1 CB7_ORDSEP FROM "+RetSqlName("CB7")+" WHERE CB7_FILIAL = C5_FILIAL AND CB7_PEDIDO = C5_NUM AND D_E_L_E_T_ <> '*') CB7_ORDSEP,
		cQuery += " '' AS CB7_NOTA,
	Else
		cQuery += " (SELECT TOP 1 CB7__SEQPR FROM "+RetSqlName("CB7")+" WHERE CB7_FILIAL = C5_FILIAL AND CB7_NOTA = C6_NOTA AND D_E_L_E_T_ <> '*') CB7__SEQPR,
		cQuery += " (SELECT TOP 1 CB7_ORDSEP FROM "+RetSqlName("CB7")+" WHERE CB7_FILIAL = C5_FILIAL AND CB7_NOTA = C6_NOTA AND D_E_L_E_T_ <> '*') CB7_ORDSEP,
		cQuery += " (SELECT TOP 1 CB7_NOTA FROM "+RetSqlName("CB7")+" WHERE CB7_FILIAL = C5_FILIAL AND CB7_NOTA = C6_NOTA AND D_E_L_E_T_ <> '*') CB7_NOTA,
	EndIf




	cQuery += " SUM(C6_VALOR) TOTAL,"
	cQuery += " COUNT(C6_ITEM ) LINHAS"
	cQuery += " FROM "+RetSqlName("SC5")+" C5 WITH(NOLOCK)"
	cQuery += " INNER JOIN "+RetSqlName("SC6")+" C6 WITH(NOLOCK) ON C6_FILIAL = C5_FILIAL AND C6_NUM = C5_NUM AND C6.D_E_L_E_T_ <> '*'	
	cQuery += " INNER JOIN "+RetSqlName("SA1")+" A1 WITH(NOLOCK) ON A1_COD = C5_CLIENTE AND A1_LOJA = C5_LOJACLI AND A1_FILIAL = C5_FILIAL "
	cQuery += " INNER JOIN "+RetSqlName("SA3")+" A3 WITH(NOLOCK) ON A3_COD = C5_VEND1 AND A3_FILIAL = C5_FILIAL "
	cQuery += " WHERE C5.D_E_L_E_T_ <> '*' AND A1.D_E_L_E_T_ <> '*' AND A3.D_E_L_E_T_ <> '*'
	If cOrigem == "1" //PEDIDO
		cQuery += " AND C5_NUM IN (SELECT CB7_PEDIDO FROM "+RetSqlName("CB7")+" WITH(NOLOCK) WHERE CB7_FILIAL = C5_FILIAL AND CB7__PRESE = '"+cOnda+"' AND D_E_L_E_T_ <> '*')"
	Else
		cQuery += " AND C6_NOTA IN (SELECT CB7_NOTA FROM "+RetSqlName("CB7")+" WITH(NOLOCK) WHERE CB7_FILIAL = C6_FILIAL AND CB7__PRESE = '"+cOnda+"' AND D_E_L_E_T_ <> '*')"
	EndIf
	cQuery += " AND C5_FILIAL = '"+xFilial("SC5")+"'"
	cQuery += " GROUP BY C5_FILIAL,C5_NUM ,  C5_CLIENTE, A1_NOME, A3_NREDUZ,C5_TRANSP, C6_NOTA
	cQuery += " ORDER BY C5_NUM"


	MemoWrite("WSAT02A.SQL",cQuery)


	dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'TRB', .F., .T.)



	Count To nRec1
	aPedsB := {}

	If nRec1 == 0
		//01- COR,02-SEQUECIA ,03-PEDIDO, 04- COD CLIENTE, 05- CLIENTE, 06 - VENDEDOR, 07- VALOR, 08- NOTA, 09- TRANSPORTADORA , 10 - LINHAS, 11- ORDSEP, 12- '', 13 - '', 14-'', 15-'', 16- '', 17 '', 18-''
		aAdd(aPedsB,{'',0,'','','','','',0,cTod(""),'','','','','','','','',''})
	Else

		dbSelectArea("TRB")
		dbGotop()

		While !Eof()
			IncProc("Calculando Pedidos ")
			 //01- COR,02-SEQUECIA ,03-PEDIDO, 04- COD CLIENTE, 05- CLIENTE, 06 - VENDEDOR, 07- VALOR, 08- NOTA, 09- TRANSPORTADORA , 10 - LINHAS, 11- ORDSEP, 12- '', 13 - '', 14-'', 15-'', 16- '', 17 '', 18-''
			cTransp := Posicione("SA4",1,xFilial("SA4")+TRB->C5_TRANSP,"A4_NREDUZ")
			cCor := ""
			dbSelectArea("CB7")
			dbSetOrder(1)
			dbSeek(xFilial()+TRB->CB7_ORDSEP)
			IF CB7->CB7_STATUS == "9" //FINALIZADO
				cCor := LoadBitMap(GetResources(),"BR_VERDE")
			Elseif CB7->CB7_STATUS == "0" //NAO INICIADO
				cCor := LoadBitMap(GetResources(),"BR_VERMELHO")
			ElseIf CB7->CB7_STATUS == "2" //CONFERENCIA
				cCor := LoadBitMap(GetResources(),"BR_AZUL") 
			ElseIf CB7->CB7_STATUS == "1" //SEPARACAO
				cCor := LoadBitMap(GetResources(),"BR_BRANCO")
			EndIf


			aAdd(aPedsB,{cCor,TRB->CB7__SEQPR,TRB->C5_NUM,TRB->C5_CLIENTE,TRB->A1_NOME,TRB->A3_NREDUZ,TRB->TOTAL,TRB->CB7_NOTA,TRB->C5_TRANSP+"-"+cTransp,TRB->LINHAS, TRB->CB7_ORDSEP,'','','', '','','','',''})

			dbSelectArea("TRB")
			dbSkip()
		End
	EndIf
	TRB->(dbCloseArea())
	ASort(aPedsB,,,{|x,y|x[11]<y[11]})


	//MONTA TELA PEDIDOS EM ABERTO
	c2Fields := " "
	n2Campo 	:= 0

	//01- COR,02-SEQUECIA ,03-PEDIDO, 04- COD CLIENTE, 05- CLIENTE, 06 - VENDEDOR, 07- VALOR, 08- NOTA, 09- TRANSPORTADORA , 10 - LINHAS, 11- ORDSEP, 12- '', 13 - '', 14-'', 15-'', 16- '', 17 '', 18-''
	aATitCampos := {'','',OemToAnsi("OS"),OemToAnsi("Nota"),OemToAnsi("Pedido"),OemToAnsi("Cod.Cliente"),OemToAnsi("Razão Social"),OemToAnsi("Linhas"),OemToAnsi("Vendedor"),OemToAnsi("Valor"),OemToAnsi("Trasnportadora"),''}

	cALine := "{aPedsB[oAListBox:nAT][1],aPedsB[oAListBox:nAT][2],aPedsB[oAListBox:nAT][11],aPedsB[oAListBox:nAT][8],aPedsB[oAListBox:nAT][3],aPedsB[oAListBox:nAT][4],aPedsB[oAListBox:nAT][5],aPedsB[oAListBox:nAT][10],"
	cALine += " aPedsB[oAListBox:nAT][6],aPedsB[oAListBox:nAT][7],aPedsB[oAListBox:nAT][9],}"

	bALine := &( "{ || " + cALine + " }" )
	nMult := 7
	aACoord := {nMult*1,nMult*2,nMult*3,nMult*4,nMult*12,nMult*3,nMult*8,nMult*6,nMult*10,nMult*6,nMult*10,''}

	@050,005 TO 500,950  DIALOG oDlgPeds TITLE "Pedidos "
	oAListBox := TWBrowse():New( 10,4,450,170,,aATitCampos,aACoord,oDlgPeds,,,,,,,,,,,,.F.,,.T.,,.F.,,,)
	oAListBox:SetArray(aPedsB)
	oAListBox:bLine := bALine

	@ 185, 005 BITMAP oBmp1 ResName 	"BR_VERDE" OF oDlgPeds Size 15,15 NoBorder When .F. Pixel
	@ 185, 015 SAY "Finalizada" OF oDlgPeds Color CLR_GREEN PIXEL

	@ 185, 065 BITMAP oBmp2 ResName 	"BR_BRANCO" OF oDlgPeds Size 15,15 NoBorder When .F. Pixel
	@ 185, 075 SAY "Separacao" OF oDlgPeds Color CLR_RED PIXEL

	@ 185, 125 BITMAP oBmp3 ResName 	"BR_AZUL" OF oDlgPeds Size 15,15 NoBorder When .F. Pixel
	@ 185, 135 SAY "Conferencia" OF oDlgPeds Color CLR_RED PIXEL

	@ 185, 185 BITMAP oBmp3 ResName 	"BR_VERMELHO" OF oDlgPeds Size 15,15 NoBorder When .F. Pixel
	@ 185, 195 SAY "Nao Iniciado" OF oDlgPeds Color CLR_RED PIXEL

	/*
	//FATURADO
	@ 185, 185 SAY "Faturado" OF oDlgPeds  PIXEL
	@ 185, 220 GET oFatur 	Var nFatur 	Picture "@E 99999"	SIZE 40, 5 When .F.	PIXEL OF oDlgPeds

	//A SEPARAR
	@ 185, 270 SAY "A Separar" OF oDlgPeds  PIXEL
	@ 185, 305 GET oASep 	Var nAsep 	Picture "@E 99999"	SIZE 40, 5 When .F.	PIXEL OF oDlgPeds

	//SEPARADO
	@ 185, 355 SAY "Separado" OF oDlgPeds  PIXEL
	@ 185, 385 GET oSep 	Var nSep 	Picture "@E 99999"	SIZE 40, 5 When .F.	PIXEL OF oDlgPeds
	*/

	dbSelectArea("SM0")
	//	If U_CHECAFUNC(RetCodUsr(),"ACDAT005") .Or. cFilAnt # "02"
	@ 200,190 BITMAP ResName "PMSSETAUP"   OF oDlgPeds Size 15,15 ON CLICK (MarcaTodos(oAListBox, .T., .T.,3,oAListBox:nAt),oAListBox:Refresh(),lAlter := .T.)  NoBorder  Pixel
	@ 200,210 BITMAP ResName "PMSSETADOWN" OF oDlgPeds Size 15,15 ON CLICK (MarcaTodos(oAListBox, .T., .T.,2,oAListBox:nAt),oAListBox:Refresh(),lAlter := .T.)  NoBorder  Pixel

	@ 200,230 BUTTON "Ord.Transp"		SIZE 40,10 ACTION (MarcaTodos(oAListBox, .T., .T.,4,oAListBox:nAt),oAListBox:Refresh(),lAlter := .T.) PIXEL OF oDlgPeds
	@ 200,270 BUTTON "Ord.Linha"		SIZE 40,10 ACTION (MarcaTodos(oAListBox, .T., .T.,5,oAListBox:nAt),oAListBox:Refresh(),lAlter := .T.) PIXEL OF oDlgPeds
	//@ 200,310 BUTTON "Ord.Mun."	    	SIZE 40,10 ACTION (MarcaTodos(oAListBox, .T., .T.,6,oAListBox:nAt),oAListBox:Refresh(),lAlter := .T.) PIXEL OF oDlgPeds
	//@ 200,350 BUTTON "Ord.Spot/Fde."   	SIZE 40,10 ACTION (MarcaTodos(oAListBox, .T., .T.,7,oAListBox:nAt),oAListBox:Refresh(),lAlter := .T.) PIXEL OF oDlgPeds

	//	EndIf
	@ 200,350 BUTTON "Vis.OS"		SIZE 40,10 ACTION U_VEROS(aPedsB[oAListBox:nAt,11], cFilAnt) PIXEL OF oDlgPeds
	@ 200,390 BUTTON "Imp. OS"		SIZE 40,10 ACTION U_TFRELOS() PIXEL OF oDlgPeds
	
	@ 200,430 BUTTON "Sair" 	SIZE 40,10 ACTION oDlgPeds:End() PIXEL OF oDlgPeds

	ACTIVATE DIALOG oDlgPeds CENTERED

	If lAlter
		If MsgYesNo("Voc� alterou a ordem dos pedidos, deseja gravar as mudan�as?","ACDAT005")
			For k:=1 To Len(aPedsB)
				dbSelectArea("CB7")
				dbSetOrder(2)
				If dbSeek(xFilial()+aPedsB[k][3])
					RecLock("CB7",.F.)
					CB7__SEQPR := aPedsB[K][2]
					CB7->(MsUnlock())
				EndIf
			Next
		EndIf
	EndIf

Return
/*
ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÝÝÝÝÝÝÝÝÝÝÑÝÝÝÝÝÝÝÝÝÝËÝÝÝÝÝÝÝÑÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝËÝÝÝÝÝÝÑÝÝÝÝÝÝÝÝÝÝÝÝÝ»±±
±±ºPrograma  ³MarcaTodosºAutor  ³Paulo Carnelossi    º Data ³  04/11/04   º±±
±±ÌÝÝÝÝÝÝÝÝÝÝØÝÝÝÝÝÝÝÝÝÝÊÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÊÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝ¹±±
±±ºDesc.     ³Marca todos as opcoes do list box - totalizadores           º±±
±±º          ³                                                            º±±
±±ÌÝÝÝÝÝÝÝÝÝÝØÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function MarcaTodos(oListBox1, lInverte, lMarca,nItem,nPos)
	//Local nX
	Local nUltItem 	:= 0
	//Local nItem 	:= 0
	Local K			:= 0
	nSomaTot := 0

	If nItem == 3    //SOBE O ITEM
		If nPos ==1
			Return
		EndIf
		//QUANDO FOR O PRIMEIRO ITEM OU NAO ESTIVER SELECIONADO SAI DA ROTINA
		oListBox1:aArray[nPos-1,2] ++           //SOMA ITEM ANTERIOR
		oListBox1:aArray[nPos,2] --				//DIMINIU O ITEM ATUAL
		ASort(aPedsB,,, { |x,y| StrZero(y[2],3) > StrZero(x[2],3) } )
		oListBox1:nAt--
	ElseIf nItem == 2  //DESCE O ITEM
		//QUANDO FOR O ULTIMO ITEM SAI DA ROTINA
		For k:=1 To Len(aPedsB)
			nUltItem++
		Next
		If nPos == nUltItem .Or. nPos == Len(aPedsB)
			Return
		EndIf

		oListBox1:aArray[nPos+1,2] --	//DIMINUI O ITEM ANTERIOR
		oListBox1:aArray[nPos,2] ++		//SOMA O ITEM ATUAL
		ASort(aPedsB,,, { |x,y| StrZero(y[2],3) > StrZero(x[2],3) } )
		oListBox1:nAt ++
		//01- COR,02-SEQUECIA ,03-PEDIDO, 04- COD CLIENTE, 05- CLIENTE, 06 - VENDEDOR, 07- VALOR, 08- ENTREGA, 09- TRANSPORTADORA , 10 - LINHAS, 11_MUN.ENTREGA

	ElseIf nItem == 4  //ORDEM TRANSPORTADORA
		ASort(aPedsB,,, { |x,y| x[9]+StrZero(x[2],3)>y[9]+StrZero(y[2],3)   } )

		For k:=1 To Len(aPedsB)
			aPedsB[k,2]:= k
		Next
	ElseIf nItem == 5  //LINHA
		If MsgYesNo("Deseja ordenar em ordem crescente?","ACDAT005")
			ASort(aPedsB,,, { |x,y| x[10] < y[10] } )
		Else
			ASort(aPedsB,,, { |x,y| x[10] > y[10] } )
		EndIf
		For k:=1 To Len(aPedsB)
			aPedsB[k,2]:= k
		Next
	ElseIf nItem == 6  //MUNCIPIO
		ASort(aPedsB,,, { |x,y| y[11] > x[11] } )
		For k:=1 To Len(aPedsB)
			aPedsB[k,2]:= k
		Next
	ElseIf nItem == 7  //FDE X SPOT
		If MsgYesNo("Deseja ordenar em ordem crescente?","ACDAT005")
			ASort(aPedsB,,, { |x,y|  x[18]+StrZero(x[10],3) < y[18]+StrZero(y[10],3) } )
		Else
			ASort(aPedsB,,, { |x,y| y[18]+StrZero(x[10],3) > x[18]+StrZero(y[10],3) } )
		EndIf

		For k:=1 To Len(aPedsB)
			aPedsB[k,2]:= k
		Next

	EndIf

Return


/*
ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÝÝÝÝÝÝÝÝÝÝÑÝÝÝÝÝÝÝÝÝÝËÝÝÝÝÝÝÝÑÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝËÝÝÝÝÝÝÑÝÝÝÝÝÝÝÝÝÝÝÝÝ»±±
±±ºPrograma  ³WMACOMP   ºAutor  ³Microsiga           º Data ³  02/09/13   º±±
±±ÌÝÝÝÝÝÝÝÝÝÝØÝÝÝÝÝÝÝÝÝÝÊÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÊÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝ¹±±
±±ºDesc.     ³TELA DE ACOMPANHAMENTO DA SEPARACAO                         º±±
±±º          ³                                                            º±±
±±ÌÝÝÝÝÝÝÝÝÝÝØÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function A005WMACOMP(cOnda)

	Local oBmp1
	LOCAL oBmp2
	LOCAL oBmp3
	//LOCAL oBmp4
	//LOCAL oBmp5
	//LOCAL oBmp6
	//LOCAL oBmp7
	//LOCAL oBmp8
	//LOCAL oBmp9
	//LOCAL oBmp10
	Local oDlgOnda, oLocais,oFinal,oPend,oPFinal,oQOper,oTempo,oMLocal,oOnline
	Private nOnline  := 0
	Private nLocais	:= 0
	Private nFinal	:= 0
	Private nPend		:= 0
	Private nPFinal	:= 0
	Private nQOper	:= 0
	Private nTempo	:= 0
	Private nMLocal	:= 0
	Private aFiltro 	:= {"Todos","Pendente","Finalizado"}
	Private aOrdem 	:= {"Enderecos","Operador","Tempo","% Faltante"}
	Private cFiltro   := "Pendente"
	Private cOrdem	:= "Operador"
	Private cMLocal
	Private cTempo
	Private cHrIni 	:= ""
	Private cHrFim 	:= ""
	Private dDtIni	:= Ctod("")
	Private dDtFim	:= Ctod("")
	Private nDifTempo := 0
	Private oListBox
	Private aAcomp	:={}
	Private aOper	:= {}
	Private aEnder	:= {}
	Private aProd	:={}
	Private cAcompOnda := cOnda
	Private nTamAcolSep := 0

	@ 65,153 To 229,435 Dialog oLocal Title OemToAnsi("Filtro Dados Sepracao")
	@ 19,09 Say OemToAnsi("Dados") Size 99,8 Pixel Of oLocal
	@ 19,49 COMBOBOX cFiltro ITEMS aFiltro  SIZE 35,9 Pixel Of oLocal
	@ 39,09 Say OemToAnsi("Ordena") Size 99,8 Pixel Of oLocal
	@ 39,49 COMBOBOX cOrdem ITEMS aOrdem  SIZE 35,9 Pixel Of oLocal

	@ 62,39 BMPBUTTON TYPE 1 ACTION Close(oLocal)
	Activate Dialog oLocal Centered

	U_AtuSep()

	//QUANDO NAO TEM DADOS SAI DA ROTINA
	If Len(aAcomp) == 0
		Return
	EndIf

	//INICIO TELA
	@ 050,005 TO 600,1100 DIALOG oDlgOnda TITLE "Acompanhamento Separacao"

	aTitCampos := {"",OemToAnsi("Cod.Oper."),OemToAnsi("Nome"),OemToAnsi("Ordem Sep."),OemToAnsi("Pausa"),OemToAnsi("Setor"),OemToAnsi("Pecas"),OemToAnsi("Enderecos"),OemToAnsi("%"),;
	OemToAnsi("End.Efetuados"), OemToAnsi("%"),OemToAnsi("Dt.Inicial"),OemToAnsi("Dt.Final"),OemToAnsi("Hr.Inicial"),OemToAnsi("Hr.Final"),OemToAnsi("Tempo"),'End/Min',''}

	cLine := "{aAcomp[oListBox:nAT][1],aAcomp[oListBox:nAt,2],aAcomp[oListBox:nAT][3],aAcomp[oListBox:nAT][4],aAcomp[oListBox:nAT][5],"
	cLine += " aAcomp[oListBox:nAT][6],aAcomp[oListBox:nAT][7],aAcomp[oListBox:nAT][8],aAcomp[oListBox:nAT][9],aAcomp[oListBox:nAT][10],"
	cLine += " aAcomp[oListBox:nAT][11],aAcomp[oListBox:nAT][12],aAcomp[oListBox:nAT][13],aAcomp[oListBox:nAT][14],aAcomp[oListBox:nAT][15],"
	cLine += " aAcomp[oListBox:nAT][16],aAcomp[oListBox:nAT][17],}"
	nMult := 7
	aCoord := {nMult*1,nMult*8,nMult*20,nMult*6,nMult*3,nMult*3,nMult*9,nMult*9,nMult*6,nMult*9, nMult*6,nMult*8,nMult*8,nMult*7,nMult*7,nMult*7,nMult*7,nMult*1}

	bLine := &( "{ || " + cLine + " }" )
	oListBox := TWBrowse():New( 100,4,500,120,,aTitCampos,aCoord,oDlgOnda,,,,,,,,,,,,.F.,,.T.,,.F.,,,)
	oListBox:SetArray(aAcomp)
	oListBox:bLine := bLine


	@ 5,2 TO 90,205 LABEL "Enderecos" OF oDlgOnda  PIXEL

	ASort(aEnder,,,{|x,y|x[2]>y[2]})

	//aEnder 01-SETOR, 02- LOCAIS, 03- LOCAIS FEITOS, 04-PECAS, 05-TEMPO, 06- MIN/END, 07-% ENDERECOS
	aE1TitCampos := {OemToAnsi("Setor"),OemToAnsi("Enderecos"),OemToAnsi("End.Feitos"),OemToAnsi("Pecas"),OemToAnsi("Tempo"),OemToAnsi("Min/End"),OemToAnsi("% End."),''}

	cE1Line := "{aEnder[oE1ListBox:nAT][1],Transform(aEnder[oE1ListBox:nAT][2],'@E 99999'),Transform(aEnder[oE1ListBox:nAT][3],'@E 99999'),aEnder[oE1ListBox:nAT][4],U_ConVDecHora(aEnder[oE1ListBox:nAT][5]),"
	cE1Line += " U_ConVDecHora(aEnder[oE1ListBox:nAT][6]),Transform(aEnder[oE1ListBox:nAT][7],'@E 999.99'),}"

	aE1Coord := {2,4,4,9,4,4,4}

	bE1Line := &( "{ || " + cE1Line + " }" )
	oE1ListBox := TWBrowse():New( 17,4,200,70,,aE1TitCampos,aE1Coord,oDlgOnda,,,,,,,,,,,,.F.,,.T.,,.F.,,,)
	oE1ListBox:SetArray(aEnder)
	oE1ListBox:bLine := bE1Line

	//TOTALIZACAO OPERADORES
	@ 5,215 TO 90,510 LABEL "Produtividade Por Operador" OF oDlgOnda  PIXEL
	//AProd 01- NOME, 02- ENDERECOS FEITOS, 03-PRODUTIVIDADE TOTAL, 04 - MINUTOS
	ASort(aProd,,,{|x,y|x[2]>y[2]})

	aO2TitCampos := {OemToAnsi("Nome"),OemToAnsi("End.Feitos"),OemToAnsi("Produt."),OemToAnsi("Tempo"),''}

	cO2Line := "{aProd[oO2ListBox:nAT][1],Transform(aProd[oO2ListBox:nAT][2],'@E 99999'),Transform(((aProd[oO2ListBox:nAT][2]/aProd[oO2ListBox:nAT][3])*100),'@E 999.99'),U_ConVDecHora(aProd[oO2ListBox:nAT][4]),}"

	aO1Coord := {10,4,4,,4}

	bO2Line := &( "{ || " + cO2Line + " }" )
	oO2ListBox := TWBrowse():New( 17,220,280,70,,aO2TitCampos,aO1Coord,oDlgOnda,,,,,,,,,,,,.F.,,.T.,,.F.,,,)
	oO2ListBox:SetArray(aProd)
	oO2ListBox:bLine := bO2Line
	oO2ListBox:bLDblClick := { ||Processa( {||U_ACOSEPPROD(aProd[oO2ListBox:nAT][1]) }) }

	//TOTAL DE ITENS
	@ 227, 005 SAY "Total Locais" OF oDlgOnda Color CLR_RED PIXEL
	@ 227, 060 GET oLocais 	Var nLocais 	Picture "@E 99999"	SIZE 40, 5 When .F.	PIXEL OF oDlgOnda

	//TOTAL ITENS FEITOS

	@ 227, 115 SAY "Locais Finalizados" OF oDlgOnda Color CLR_BROWN PIXEL
	@ 227, 170 GET oFinal 	Var nFinal 	Picture "@E 99999"	SIZE 40, 5 When .F.	PIXEL OF oDlgOnda


	@ 227, 225 SAY "Locais Pendentes" OF oDlgOnda Color CLR_GREEN PIXEL
	@ 227, 280 GET oPend 	Var nPend 	Picture "@E 99999"	SIZE 40, 5 When .F.	PIXEL OF oDlgOnda


	@ 227, 335 SAY "% para o Termino" OF oDlgOnda Color CLR_BLUE PIXEL
	@ 227, 390 GET oPFinal 	Var nPFinal	Picture "@e 999.99"	SIZE 40, 5 When .F.	PIXEL OF oDlgOnda

	@ 227, 445 SAY "Oper.On-Line" OF oDlgOnda Color CLR_BLUE PIXEL
	@ 227, 490 GET oOnline 	Var nOnline	Picture "@e 999.99"	SIZE 40, 5 When .F.	PIXEL OF oDlgOnda


	@ 240, 005 SAY "Operadores" OF oDlgOnda Color CLR_BLUE PIXEL
	@ 240, 060 GET oQOper 	Var nQOper 	Picture "@E 99999"	SIZE 40, 5 When .F.	PIXEL OF oDlgOnda

	@ 240, 115 SAY "Tempo Total" OF oDlgOnda Color CLR_BLUE PIXEL
	@ 240, 170 GET oTempo 	Var cTempo 	Picture "@E 99:99:99"	SIZE 40, 5 When .F.	PIXEL OF oDlgOnda

	@ 240, 225 SAY "Med.Tempo Local" OF oDlgOnda Color CLR_BLUE PIXEL
	@ 240, 280 GET oMLocal	Var cMLocal	Picture "@E 99:99:99"	SIZE 40, 5 When .F.	PIXEL OF oDlgOnda

	//@ 200, 335 SAY "Total Peças" OF oDlgOnda Color CLR_BLUE PIXEL
	//@ 200, 390 GET oQVenda	Var nQVenda	Picture "@E 99999"	SIZE 40, 5 When .F.	PIXEL OF oDlgOnda
	@ 260,210 BUTTON "Atualizar"   	SIZE 40,15 ACTION {U_AtuSep(),oDlgOnda:Refresh()} PIXEL OF oDlgOnda
	@ 260,270 BUTTON "Pausa"       	SIZE 40,15 ACTION {U_Pausa(aAcomp[oListBox:nAT][4]),aAcomp[oListBox:nAT][5] := "S",oDlgOnda:Refresh()} PIXEL OF oDlgOnda
	@ 260,330 BUTTON "Exportar"    	SIZE 40,15 ACTION {U_WMAT02EXC()} PIXEL OF oDlgOnda
	@ 260,390 BUTTON "Sair"       	SIZE 40,15 ACTION {nOpc :=0,oDlgOnda:End()} PIXEL OF oDlgOnda

	@ 260, 005 BITMAP oBmp1 ResName 	"BR_VERDE" OF oDlgOnda Size 15,15 NoBorder When .F. Pixel
	@ 260, 015 SAY "Finalizado" OF oDlgOnda Color CLR_GREEN PIXEL

	@ 260, 080 BITMAP oBmp2 ResName 	"BR_VERMELHO" OF oDlgOnda Size 15,15 NoBorder When .F. Pixel
	@ 260, 090 SAY "Em Andamento" OF oDlgOnda Color CLR_RED PIXEL

	@ 260, 155 BITMAP oBmp3 ResName 	"BR_BRANCO" OF oDlgOnda Size 15,15 NoBorder When .F. Pixel
	@ 260, 165 SAY "Sem Operador" OF oDlgOnda Color CLR_BLACK PIXEL

	//@ 260, 230 BITMAP oBmp4 ResName 	"BR_PRETO" OF oDlgOnda Size 15,15 NoBorder When .F. Pixel
	//@ 260, 240 SAY "Muito Lento" OF oDlgOnda Color CLR_BLACK PIXEL

	ACTIVATE DIALOG oDlgOnda CENTERED

Return



/*
ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÝÝÝÝÝÝÝÝÝÝÑÝÝÝÝÝÝÝÝÝÝËÝÝÝÝÝÝÝÑÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝËÝÝÝÝÝÝÑÝÝÝÝÝÝÝÝÝÝÝÝÝ»±±
±±ºPrograma  ³WMSEPACOMPºAutor  ³Microsiga           º Data ³  02/09/13   º±±
±±ÌÝÝÝÝÝÝÝÝÝÝØÝÝÝÝÝÝÝÝÝÝÊÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÊÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝ¹±±
±±ºDesc.     ³TELA DE ACOMPANHAMENTO DE PRE CHECKOUT                      º±±
±±º          ³EXP1 - NUMERO ONDA                                          º±±
±±º          ³EXP2 -P-PRE-CHECKOUT/ C-CHECKOUT                            º±±
±±ÌÝÝÝÝÝÝÝÝÝÝØÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function A005WMSPCACOMP(cOnda,cOpc)

	Local oBmp1
	LOCAL oBmp2
	LOCAL oBmp3
	//LOCAL oBmp4
	//LOCAL oBmp5
	//LOCAL oBmp6
	//LOCAL oBmp7
	//LOCAL oBmp8
	//LOCAL oBmp9
	//LOCAL oBmp10
	Local oDlgOnda, oLocais,oFinal,oPend,oPFinal,oQOper,oTempo,oMLocal,oOnline,oPedFalta
	Private nLocais	:= 0
	Private nFinal	:= 0
	Private nPend	:= 0
	Private nPFinal	:= 0
	Private nQOper	:= 0
	Private nTempo	:= 0
	Private nMLocal	:= 0
	Private aFiltro 	:= {"Todos","Pendente","Finalizado"}
	Private aOrdem 	:= {"Operador","Tempo","% Faltante","Pedido","Ordem Sep."}
	Private cFiltro   := "Pendente"
	Private cOrdem	:= "Operador"
	Private cMLocal
	Private cTempo
	Private cHrIni 	:= ""
	Private cHrFim 	:= ""
	Private dDtIni	:= Ctod("")
	Private dDtFim	:= Ctod("")
	Private nDifTempo := 0
	Private aOper := {}
	Private oListBox
	Private aAcomp	:={}
	Private cNOpc	:= cOpc
	Private cNOnda	:= cOnda
	Private aProd	:= {}
	Private nOnline := 0
	Private nPedFalta := 0
	Private nTamAcolPre := 0

	@ 65,153 To 229,435 Dialog oLocal Title Iif(cOpc=="P",OemToAnsi("Filtro Dados Pre-Checkout"),OemToAnsi("Filtro Dados Checkout"))
	@ 19,09 Say OemToAnsi("Dados") Size 99,8 Pixel Of oLocal
	@ 19,49 COMBOBOX cFiltro ITEMS aFiltro  SIZE 35,9 Pixel Of oLocal
	@ 39,09 Say OemToAnsi("Ordena") Size 99,8 Pixel Of oLocal
	@ 39,49 COMBOBOX cOrdem ITEMS aOrdem  SIZE 35,9 Pixel Of oLocal

	@ 62,39 BMPBUTTON TYPE 1 ACTION Close(oLocal)
	Activate Dialog oLocal Centered

	U_AtuPre()

	//QUANDO NAO TEM DADOS SAI DA ROTINA
	If Len(aAcomp) == 0
		Return
	EndIf


	aTitCampos := {"",OemToAnsi("Cod.Oper."),OemToAnsi("Nome"),OemToAnsi("Pedido"),OemToAnsi("Ordem Sep."),OemToAnsi("Pausa"),OemToAnsi("Pecas"),OemToAnsi("Linhas"),OemToAnsi("%"),;
	OemToAnsi("Linhas.Efetuadas"), OemToAnsi("%"),OemToAnsi("Dt.Inicial"),OemToAnsi("Dt.Final"),OemToAnsi("Hr.Inicial"),OemToAnsi("Hr.Final"),OemToAnsi("Tempo"),'Linha/Min',''}

	cLine := "{aAcomp[oListBox:nAT][1],aAcomp[oListBox:nAt,2],aAcomp[oListBox:nAT][3],aAcomp[oListBox:nAT][18],aAcomp[oListBox:nAT][4],aAcomp[oListBox:nAT][5],"
	cLine += " aAcomp[oListBox:nAT][7],aAcomp[oListBox:nAT][8],aAcomp[oListBox:nAT][9],aAcomp[oListBox:nAT][10],"
	cLine += " aAcomp[oListBox:nAT][11],aAcomp[oListBox:nAT][12],aAcomp[oListBox:nAT][13],aAcomp[oListBox:nAT][14],aAcomp[oListBox:nAT][15],"
	cLine += " aAcomp[oListBox:nAT][16],aAcomp[oListBox:nAT][17],}"

	nMult := 7
	aCoord := {nMult*1,nMult*8,nMult*20,nMult*6,nMult*3,nMult*9,nMult*9,nMult*6,nMult*9, nMult*6,nMult*8,nMult*8,nMult*7,nMult*7,nMult*7,nMult*7,nMult*1}


	bLine := &( "{ || " + cLine + " }" )

	If cOpc == "P"
		@ 050,005 TO 600,1100 DIALOG oDlgOnda TITLE "Acompanhamento Pre-Checkout"
	Else
		@ 050,005 TO 600,1100 DIALOG oDlgOnda TITLE "Acompanhamento Checkout"
	EndIf
	oListBox := TWBrowse():New( 100,4,500,120,,aTitCampos,aCoord,oDlgOnda,,,,,,,,,,,,.F.,,.T.,,.F.,,,)
	oListBox:SetArray(aAcomp)
	oListBox:bLine := bLine

	//TOTALIZACAO OPERADORES
	@ 5,2 TO 90,205 LABEL "Produtividade Por Operador" OF oDlgOnda  PIXEL
	//AProd 01- NOME, 02- ENDERECOS FEITOS, 03-PRODUTIVIDADE TOTAL, 04 - MINUTOS
	ASort(aProd,,,{|x,y|x[2]>y[2]})

	aO2TitCampos := {OemToAnsi("Nome"),OemToAnsi("End.Feitos"),OemToAnsi("Produt."),OemToAnsi("Tempo"),OemToAnsi("Min./Linha"),''}

	cO2Line := "{aProd[oO2ListBox:nAT][1],Transform(aProd[oO2ListBox:nAT][2],'@E 99999'),Transform(((aProd[oO2ListBox:nAT][2]/aProd[oO2ListBox:nAT][3])*100),'@E 999.99'),U_ConVDecHora(aProd[oO2ListBox:nAT][4]),U_ConVDecHora(aProd[oO2ListBox:nAT][5]),}"

	aO1Coord := {10,4,4,,4}

	bO2Line := &( "{ || " + cO2Line + " }" )
	oO2ListBox := TWBrowse():New( 17,4,200,70,,aO2TitCampos,aO1Coord,oDlgOnda,,,,,,,,,,,,.F.,,.T.,,.F.,,,)
	oO2ListBox:SetArray(aProd)
	oO2ListBox:bLine := bO2Line
	//oO2ListBox:bLDblClick := { ||Processa( {||U_ACOSEPPROD(aProd[oO2ListBox:nAT][1]) }) }

	//TOTAL DE ITENS
	@ 227, 005 SAY "Total Linhas" OF oDlgOnda Color CLR_RED PIXEL
	@ 227, 060 GET oLocais 	Var nLocais 	Picture "@E 99999"	SIZE 40, 5 When .F.	PIXEL OF oDlgOnda

	//TOTAL ITENS FEITOS

	@ 227, 115 SAY "Linhas Finalizadas" OF oDlgOnda Color CLR_BROWN PIXEL
	@ 227, 170 GET oFinal 	Var nFinal 	Picture "@E 99999"	SIZE 40, 5 When .F.	PIXEL OF oDlgOnda


	@ 227, 225 SAY "Linhas Pendentes" OF oDlgOnda Color CLR_GREEN PIXEL
	@ 227, 280 GET oPend 	Var nPend 	Picture "@E 99999"	SIZE 40, 5 When .F.	PIXEL OF oDlgOnda


	@ 227, 335 SAY "% para o Termino" OF oDlgOnda Color CLR_BLUE PIXEL
	@ 227, 390 GET oPFinal 	Var nPFinal	Picture "@e 999.99"	SIZE 40, 5 When .F.	PIXEL OF oDlgOnda

	@ 227, 445 SAY "Oper.On-Line" OF oDlgOnda Color CLR_BLUE PIXEL
	@ 227, 490 GET oOnline 	Var nOnline	Picture "@e 999.99"	SIZE 40, 5 When .F.	PIXEL OF oDlgOnda



	@ 240, 005 SAY "Operadores" OF oDlgOnda Color CLR_BLUE PIXEL
	@ 240, 060 GET oQOper 	Var nQOper 	Picture "@E 99999"	SIZE 40, 5 When .F.	PIXEL OF oDlgOnda

	@ 240, 115 SAY "Tempo Total" OF oDlgOnda Color CLR_BLUE PIXEL
	@ 240, 170 GET oTempo 	Var cTempo 	Picture "@E 99:99:99"	SIZE 40, 5 When .F.	PIXEL OF oDlgOnda

	@ 240, 225 SAY "Med.Tempo Linha" OF oDlgOnda Color CLR_BLUE PIXEL
	@ 240, 280 GET oMLocal	Var cMLocal	Picture "@E 99:99:99"	SIZE 40, 5 When .F.	PIXEL OF oDlgOnda

	@ 240, 335 SAY "Pedidos Falta" OF oDlgOnda Color CLR_BLUE PIXEL
	@ 240, 390 GET oPedFalta	Var nPedFalta	Picture "@E 999.99"	SIZE 40, 5 When .F.	PIXEL OF oDlgOnda

	//@ 200, 335 SAY "Total Peças" OF oDlgOnda Color CLR_BLUE PIXEL
	//@ 200, 390 GET oQVenda	Var nQVenda	Picture "@E 99999"	SIZE 40, 5 When .F.	PIXEL OF oDlgOnda


	//BOTOES
	@ 260,270 BUTTON "Atualizar"   	SIZE 40,15 ACTION {U_AtuPre(),oDlgOnda:Refresh()} PIXEL OF oDlgOnda
	@ 260,330 BUTTON "Pausa"       	SIZE 40,15 ACTION {U_Pausa(aAcomp[oListBox:nAT][4]),aAcomp[oListBox:nAT][5] := "S",oDlgOnda:Refresh()} PIXEL OF oDlgOnda
	@ 260,390 BUTTON "Sair"       	SIZE 40,15 ACTION {nOpc :=0,oDlgOnda:End()} PIXEL OF oDlgOnda

	//@ 220,310 SAY "Busca Pedido:" SIZE 65,9 PIXEL OF oDlgOnda
	//@ 220,360 MSGET oSeek VAR cPesqPV SIZE 40,7 Valid (Iif(!Empty(cPesqPV),(Busca(cPesqPV,oListBox),cPesqPV := Space(06),oListBox:Refresh(),oSeek:SetFocus()),)) PIXEL OF oDlgOnda

	@ 260, 005 BITMAP oBmp1 ResName 	"BR_VERDE" OF oDlgOnda Size 15,15 NoBorder When .F. Pixel
	@ 260, 015 SAY "Finalizado" OF oDlgOnda Color CLR_GREEN PIXEL

	@ 260, 080 BITMAP oBmp2 ResName 	"BR_VERMELHO" OF oDlgOnda Size 15,15 NoBorder When .F. Pixel
	@ 260, 090 SAY "Em Andamento" OF oDlgOnda Color CLR_RED PIXEL

	@ 260, 155 BITMAP oBmp3 ResName 	"BR_BRANCO" OF oDlgOnda Size 15,15 NoBorder When .F. Pixel
	@ 260, 165 SAY "Sem Operador" OF oDlgOnda Color CLR_BLACK PIXEL

	//@ 260, 230 BITMAP oBmp4 ResName 	"BR_PRETO" OF oDlgOnda Size 15,15 NoBorder When .F. Pixel
	//@ 260, 240 SAY "Muito Lento" OF oDlgOnda Color CLR_BLACK PIXEL

	ACTIVATE DIALOG oDlgOnda CENTERED


Return



/*
ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÝÝÝÝÝÝÝÝÝÝÑÝÝÝÝÝÝÝÝÝÝËÝÝÝÝÝÝÝÑÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝËÝÝÝÝÝÝÑÝÝÝÝÝÝÝÝÝÝÝÝÝ»±±
±±ºPrograma  ³WMAT02EXC ºAutor  ³Microsiga           º Data ³  02/11/13   º±±
±±ÌÝÝÝÝÝÝÝÝÝÝØÝÝÝÝÝÝÝÝÝÝÊÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÊÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝ¹±±
±±ºDesc.     ³EXPORTA DADOS SEPARACAO PARA EXCEL                          º±±
±±º          ³                                                            º±±
±±ÌÝÝÝÝÝÝÝÝÝÝØÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function A005WMAT02EXC()
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Declaracao de Variaveis                                             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	//Local nTamLin
	LOCAL cLin
	//LOCAL cCpo
	local cDirDocs  := MsDocPath()
	//Local cError 	:= ""
	Local cPath		:= "C:\EXCEL\"
	Local cArquivo 	:= "SEPARACAO"+cAcompOnda+".CSV"
	Local oExcelApp
	//Local nHandle
	//Local cCrLf 	:= Chr(13) + Chr(10)
	//Local nX
	Local Kx		:= 0
	Local nTotEnd := 0
	Private nHdl    := MsfCreate(cDirDocs+"\"+cArquivo,0)
	Private cEOL    := "CHR(13)+CHR(10)"

	//CRIA DIRETORIO
	MakeDir(Trim(cPath))

	FERASE( "C:\EXCEL\"+cArquivo )

	if file(cArquivo) .and. ferase(cArquivo) == -1
		msgstop("N�o foi poss�vel abrir o arquivo CSV pois ele pode estar aberto por outro usuário.")
		return(.F.)
	endif
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Cria o arquivo texto                                                ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	If Empty(cEOL)
		cEOL := CHR(13)+CHR(10)
	Else
		cEOL := Trim(cEOL)
		cEOL := &cEOL
	Endif

	If nHdl == -1
		MsgAlert("O arquivo de nome "+cArqTxt+" nao pode ser executado! Verifique os parametros.","Atencao!")
		Return
	Endif


	//CABECALOS ESTATISTICAS ENDERECOS
	cLin := "DISTRIBUICAO ENDERECOS"
	cLin += cEOL
	If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
		ConOut("Ocorreu um erro na gravacao do arquivo.")
		fClose(nHdl)
		Return
	Endif

	cLin    :=  OemToAnsi("Setor")+';'+OemToAnsi("Enderecos")+';'+OemToAnsi("End.Feitos")+';'+OemToAnsi("Pecas")+';'+OemToAnsi("Tempo")+';'+OemToAnsi("Min/End")+';'+OemToAnsi("% End.")
	cLin += cEOL //ULTIMO ITEM

	If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
		ConOut("Ocorreu um erro na gravacao do arquivo.")
		dbCloseArea()
		fClose(nHdl)
		Return
	Endif

	ProcRegua(Len(aEnder))

	For Kx:=1 To Len(aEnder)
		IncProc("Aguarde......Montando Planilha enderecos!")
		nTotEnd += aEnder[Kx][2]
		cLin    := ''
		cLin    += aEnder[Kx][1]+';'+Transform(aEnder[Kx][2],'@E 99999')+';'+Transform(aEnder[Kx][3],'@E 99999')+';'+Transform(aEnder[Kx][4],'@E 99999')+';'+U_ConVDecHora(aEnder[Kx][5])+';'+U_ConVDecHora(aEnder[Kx][6])+';'+Transform(aEnder[Kx][7],'@E 999.99')

		//PULA LINHA
		cLin += cEOL

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Gravacao no arquivo texto. Testa por erros durante a gravacao da    ³
		//³ linha montada.                                                      ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

		If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
			ConOut("Ocorreu um erro na gravacao do arquivo.")
			fClose(nHdl)
			Return
		Endif
	Next

	//PULA LINHA
	cLin += cEOL
	If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
		ConOut("Ocorreu um erro na gravacao do arquivo.")
		fClose(nHdl)
		Return
	Endif

	cLin := "PRODUTIVIDADE POR OPERADOR X SETOR"
	cLin += cEOL
	If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
		ConOut("Ocorreu um erro na gravacao do arquivo.")
		fClose(nHdl)
		Return
	Endif


	//PRODUTIVIDADE POR OPERADOR X SETOR
	cLin    :=  OemToAnsi("Nome")+';'+OemToAnsi("Enderecos")+';'+OemToAnsi("End.Feitos")+';'+OemToAnsi("Pecas")+';'+OemToAnsi("Tempo")+';'+OemToAnsi("Setor")+';'+OemToAnsi("Min/End")+';'+OemToAnsi("Produt.")
	cLin += cEOL

	If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
		ConOut("Ocorreu um erro na gravacao do arquivo.")
		dbCloseArea()
		fClose(nHdl)
		Return
	Endif

	ProcRegua(Len(aOper))
	//aOper 01-CODIGO, 02- NOME, 03- LOCAIS,04-TEMPO, 05-PECAS, 06-LOCAIS FEITOS, 07- SETOR, 08- MIN/END, 09- PRODUTIVIDADE ENDERECO
	ASort(aOper,,,{|x,y|x[7]+StrZero(x[9],4)>y[7]+StrZero(y[9],4)})

	For Kx:=1 To Len(aOper)
		IncProc("Aguarde......Montando Planilha Operadores!")
		cLin    := ''
		cLin    += aOper[Kx][2]+';'+Transform(aOper[Kx][3],'@E 99999')+';'+Transform(aOper[Kx][6],'@E 99999')+';'+Transform(aOper[Kx][5],'@E 99999')+';'+U_ConVDecHora(aOper[Kx][4])+';'
		cLin    += aOper[Kx][7]+';'+U_ConVDecHora(aOper[Kx][8])+';'+Transform(aOper[Kx][9],'@E 999.99')

		//PULA LINHA
		cLin += cEOL

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Gravacao no arquivo texto. Testa por erros durante a gravacao da    ³
		//³ linha montada.                                                      ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

		If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
			ConOut("Ocorreu um erro na gravacao do arquivo.")
			fClose(nHdl)
			Return
		Endif
	Next

	//MONTA A PRODUTIVIDADE POR OPERADOR
	cLin := ""
	cLin += cEOL
	If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
		ConOut("Ocorreu um erro na gravacao do arquivo.")
		fClose(nHdl)
		Return
	Endif

	cLin := "PRODUTIVIDADE POR OPERADOR"
	cLin += cEOL
	If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
		ConOut("Ocorreu um erro na gravacao do arquivo.")
		fClose(nHdl)
		Return
	Endif


	//PRODUTIVIDADE POR OPERADOR
	cLin    :=  OemToAnsi("Nome")+';'+OemToAnsi("Enderecos")+';'+OemToAnsi("Produt.")+';'+OemToAnsi("Tempo")+";"+OemToAnsi("Min/End.")
	cLin += cEOL

	If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
		ConOut("Ocorreu um erro na gravacao do arquivo.")
		dbCloseArea()
		fClose(nHdl)
		Return
	Endif

	ProcRegua(Len(aProd))
	//AProd 01- NOME, 02- ENDERECOS FEITOS, 03-PRODUTIVIDADE TOTAL, 04 - MINUTOS, 05 - MIN/LINHAS
	ASort(aProd,,,{|x,y|x[5]>y[5]})

	For Kx:=1 To Len(aProd)
		IncProc("Aguarde......Montando Planilha Produtividade!")
		cLin    := ''
		cLin    += aProd[Kx][1]+';'+Transform(aProd[Kx][2],'@E 99999')+';'+Transform((aProd[Kx][2]/aProd[Kx][3])*100,'@E 999.99')+';'+U_ConVDecHora(aProd[Kx][4])+';'+U_ConVDecHora(aProd[Kx][4]/aProd[Kx][2])

		//PULA LINHA
		cLin += cEOL

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Gravacao no arquivo texto. Testa por erros durante a gravacao da    ³
		//³ linha montada.                                                      ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

		If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
			ConOut("Ocorreu um erro na gravacao do arquivo.")
			fClose(nHdl)
			Return
		Endif
	Next


	fClose(nHdl)

	CpyS2T( cDirDocs+"\"+cArquivo, cPath, .T. )

	If ! ApOleClient( 'MsExcel' )
		ShellExecute("open",cPath+cArquivo,"","", 1 )
		Return
	EndIf

	oExcelApp := MsExcel():New()
	oExcelApp:WorkBooks:Open( cPath+cArquivo ) // Abre uma planilha
	oExcelApp:SetVisible(.T.)

	If MsgYesNo("Deseja fechar a planilha do excel?")
		oExcelApp:Quit()
		oExcelApp:Destroy()
	EndIf

Return


/*
ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÝÝÝÝÝÝÝÝÝÝÑÝÝÝÝÝÝÝÝÝÝËÝÝÝÝÝÝÝÑÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝËÝÝÝÝÝÝÑÝÝÝÝÝÝÝÝÝÝÝÝÝ»±±
±±ºPrograma  ³ACOSEPPRODºAutor  ³Microsiga           º Data ³  02/11/13   º±±
±±ÌÝÝÝÝÝÝÝÝÝÝØÝÝÝÝÝÝÝÝÝÝÊÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÊÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝ¹±±
±±ºDesc.     ³TELA COM A PRODUTIVIDADE POR OPERADOR NA SEPARACAO          º±±
±±º          ³                                                            º±±
±±ÌÝÝÝÝÝÝÝÝÝÝØÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function A005ACOSEPPROD(cNomOper)
	Local oDlgOper
	Local a2Oper := {}
	Local oOP2ListBox,cOP2Line,bOP2Line
	Local aOP2TitCampos := {}
	Local aOP2Coord := {}
	Local Kx 		:= 0

	For Kx:=1 To Len(aOper)
		If aOper[Kx][2] == cNomOper
			aAdd(a2Oper,{aOper[Kx][1],aOper[Kx][2],aOper[Kx][3],aOper[Kx][4],aOper[Kx][5],aOper[Kx][6],aOper[Kx][7],aOper[Kx][8],aOper[Kx][9]})
		EndIf
	Next

	//TOTALIZACAO OPERADORES
	ASort(a2Oper,,,{|x,y|x[7]>y[7]})
	@050,005 TO 300,550  DIALOG oDlgOper TITLE "Dados Operador x Separacao "

	//a2Oper 01-CODIGO, 02- NOME, 03- LOCAIS,04-TEMPO, 05-PECAS, 06-LOCAIS FEITOS, 07- SETOR, 08- MIN/END, 09- PRODUTIVIDADE ENDERECO

	aOP2TitCampos := {OemToAnsi("Codigo"),OemToAnsi("Nome"),OemToAnsi("Enderecos"),OemToAnsi("End.Feitos"),OemToAnsi("Pecas"),OemToAnsi("Tempo"),OemToAnsi("Setor"),OemToAnsi("Min/End"),OemToAnsi("Produt."),''}

	cOP2Line := "{a2Oper[oOP2ListBox:nAT][1],a2Oper[oOP2ListBox:nAT][2],Transform(a2Oper[oOP2ListBox:nAT][3],'@E 99999'),Transform(a2Oper[oOP2ListBox:nAT][6],'@E 99999'),a2Oper[oOP2ListBox:nAT][5],U_ConVDecHora(a2Oper[oOP2ListBox:nAT][4]),"
	cOP2Line += " a2Oper[oOP2ListBox:nAT][7],U_ConVDecHora(a2Oper[oOP2ListBox:nAT][8]),Transform(a2Oper[oOP2ListBox:nAT][9],'@E 999.99'),}"

	aOP2Coord := {3,10,4,4,9,4,2,4,4,1}

	bOP2Line := &( "{ || " + cOP2Line + " }" )
	oOP2ListBox := TWBrowse():New( 10,4,270,90,,aOP2TitCampos,aOP2Coord,oDlgOper,,,,,,,,,,,,.F.,,.T.,,.F.,,,)
	oOP2ListBox:SetArray(a2Oper)
	oOP2ListBox:bLine := bOP2Line

	@ 100,200 BUTTON "Sair" 	SIZE 40,10 ACTION oDlgOper:End() PIXEL OF oDlgOper

	ACTIVATE DIALOG oDlgOper CENTERED


Return


/*
ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÝÝÝÝÝÝÝÝÝÝÑÝÝÝÝÝÝÝÝÝÝËÝÝÝÝÝÝÝÑÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝËÝÝÝÝÝÝÑÝÝÝÝÝÝÝÝÝÝÝÝÝ»±±
±±ºPrograma  ³ACDAT005  ºAutor  ³Microsiga           º Data ³  02/27/13   º±±
±±ÌÝÝÝÝÝÝÝÝÝÝØÝÝÝÝÝÝÝÝÝÝÊÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÊÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÝÝÝÝÝÝÝÝÝÝØÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function A005Pausa(cPOrdSep)

	cQuery := " UPDATE "+RetSqlName("CB7")+" SET CB7_STATPA = '1' WHERE CB7_FILIAL = '"+cFilAnt+"' AND CB7_ORDSEP = '"+cPOrdSep+"' AND D_E_L_E_T_ <> '*'"

	If TcSqlExec(cQuery) <0
		UserException( "Erro na atualiza��o"+ Chr(13)+Chr(10) + "Processo com erros"+ Chr(13)+Chr(10) + TCSqlError() )
	EndIf

	MsgInfo("Em Pausa!","ACDAT005")

Return


/*
ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÝÝÝÝÝÝÝÝÝÝÑÝÝÝÝÝÝÝÝÝÝËÝÝÝÝÝÝÝÑÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝËÝÝÝÝÝÝÑÝÝÝÝÝÝÝÝÝÝÝÝÝ»±±
±±ºPrograma  ³AtuPre    ºAutor  ³Microsiga           º Data ³  03/01/13   º±±
±±ÌÝÝÝÝÝÝÝÝÝÝØÝÝÝÝÝÝÝÝÝÝÊÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÊÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝ¹±±
±±ºDesc.     ³Atualiza o pre checkout                                     º±±
±±º          ³                                                            º±±
±±ÌÝÝÝÝÝÝÝÝÝÝØÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function A005AtuPre()
	Local Kx := 0
	nLocais	:= 0
	nFinal	:= 0
	nPend	:= 0
	nPFinal	:= 0
	nQOper	:= 0
	nTempo	:= 0
	nMLocal	:= 0
	nOnline := 0
	nDifTempo := 0
	aOper := {}
	aAcomp	:={}
	aProd	:= {}
	nPedFalta := 0
	cTempo	:= ""
	cMLocal	:= ""


	cQuery := " SELECT "
	If cNOpc == "P"
		cQuery += " CB7__CODOP AS CB7_CODOPE, "
	Else
		cQuery += " CB7_CODOPE , "
	EndIf
	cQuery += " CB1_NOME, CB7_ORDSEP, CB7_STATPA  , CB7_PEDIDO, CB7_NOTA, CB7__CHECK ,CB7_STATUS,"
	cQuery += " (SELECT SUM(CB8_QTDORI) FROM "+RetSqlName("CB8")+" WITH(NOLOCK) WHERE CB7_FILIAL = CB8_FILIAL AND CB8_ORDSEP = CB7_ORDSEP AND D_E_L_E_T_ <> '*') PECAS,"
	cQuery += " (SELECT COUNT(CB8_ITEM ) FROM "+RetSqlName("CB8")+" WITH(NOLOCK) WHERE CB7_FILIAL = CB8_FILIAL AND CB8_ORDSEP = CB7_ORDSEP AND D_E_L_E_T_ <> '*') LINHAS,"
	If cNOpc == "P"
		cQuery += " (SELECT COUNT(CB8_ITEM ) FROM "+RetSqlName("CB8")+" WITH(NOLOCK) WHERE CB7_FILIAL = CB8_FILIAL AND CB8_ORDSEP = CB7_ORDSEP AND D_E_L_E_T_ <> '*' AND CB8__SALDO = 0) LINHAS_FEITAS,"
		cQuery += " CB7__DTINI  ,"
		cQuery += " CB7__DTFIM  ,"
		cQuery += " SUBSTRING(CB7__HRINI     ,1,2)+':'+SUBSTRING(CB7__HRINI     ,3,2) HR_INI, "
		cQuery += " SUBSTRING(CB7__HRFIM      ,1,2)+':'+SUBSTRING(CB7__HRFIM     ,3,2) HR_FIM"
	Else
		cQuery += " (SELECT COUNT(CB8_ITEM ) FROM "+RetSqlName("CB8")+" WITH(NOLOCK) WHERE CB7_FILIAL = CB8_FILIAL AND CB8_ORDSEP = CB7_ORDSEP AND D_E_L_E_T_ <> '*' AND CB8_SALDOS = 0) LINHAS_FEITAS,"
		cQuery += " CB7_DTINIS CB7__DTINI  ,"
		cQuery += " CB7_DTFIMS CB7__DTFIM  ,"
		cQuery += " SUBSTRING(CB7_HRINIS     ,1,2)+':'+SUBSTRING(CB7_HRINIS     ,3,2) HR_INI, "
		cQuery += " SUBSTRING(CB7_HRFIMS      ,1,2)+':'+SUBSTRING(CB7_HRFIMS     ,3,2) HR_FIM"
	EndIf
	cQuery += " FROM "+RetSqlName("CB7")+"  CB7 WITH(NOLOCK)"
	cQuery += " LEFT JOIN "+RetSqlName("CB1")+" WITH(NOLOCK) ON CB1_FILIAL = CB7_FILIAL "
	If cNOpc == "P"
		cQuery += " AND CB1_CODOPE = CB7__CODOP "
	Else
		cQuery += " AND CB1_CODOPE = CB7_CODOPE "
	EndIf
	cQuery += " WHERE CB7__PRESE = '"+cNOnda+"' "
	cQuery += " and CB7_PEDIDO <> ''"
	cQuery += " AND CB7_FILIAL = '"+cFilAnt+"' AND CB7.D_E_L_E_T_ <> '*'  "
	cQuery += " order by LINHAS DESC"

	MemoWrite("ACDAT00516.SQL",cQuery)
	dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),"TRBAC", .F., .T.)

	TcSetField('TRBAC','CB7__DTINI','D')
	TcSetField('TRBAC','CB7__DTFIM','D')

	Count To nRec1

	If nRec1 == 0
		MsgStop("N�o existem dados para esta Onda!","Aten��o")
		TRBAC->(dbCloseArea())
		Return
	EndIf

	//ABRE TELA PARA SELECAO DE PEDIDOS
	dbSelectArea("TRBAC")
	ProcRegua(nRec1)
	dbGotop()

	While !Eof()
		nLocais += TRBAC->LINHAS

		//ARMAZENA ESTATISTICAS DO OPERADOR
		nAscan := Ascan(aOper, {|e| e[1] == TRBAC->CB7_CODOPE })
		If nAscan == 0
			//aOper 01-CODIGO, 02- NOME, 03- LOCAIS,04-TEMPO, 05-PECAS, 06-LOCAIS FEITOS, 07- SETOR, 08- MIN/END, 09- PRODUTIVIDADE ENDERECO
			aAdd(aOper,{TRBAC->CB7_CODOPE,TRBAC->CB1_NOME,TRBAC->LINHAS,0,TRBAC->PECAS, TRBAC->LINHAS_FEITAS, '', 0 ,0})
		Else
			aOper[nAscan][3] +=TRBAC->LINHAS
			aOper[nAscan][5] +=TRBAC->PECAS
			aOper[nAscan][6] += TRBAC->LINHAS_FEITAS
		EndIf

		dbSelectArea("TRBAC")
		dbSkip()
	End


	aAcomp	 := {}
	cCodOPer := ""
	dbSelectArea("TRBAC")
	dbGotop()
	cHrIni := TRBAC->HR_INI
	cHrFim := TRBAC->HR_FIM
	dDtIni := TRBAC->CB7__DTINI
	dDtFim := TRBAC->CB7__DTFIM

	While !Eof()
		IncProc("Gerando dados")

		nLcPorc 	:= (TRBAC->LINHAS/nLocais)*100
		nLcEfPorc 	:= (TRBAC->LINHAS_FEITAS/TRBAC->LINHAS)*100
		cCor		:= Iif(TRBAC->LINHAS-TRBAC->LINHAS_FEITAS == 0 .Or. (TRBAC->CB7__CHECK == "2"  .And. cNOpc == "P"),"BR_VERDE",Iif(!Empty(TRBAC->CB7_CODOPE),"BR_VERMELHO","BR_BRANCO"))

		//LOCAIS FINALIZADOS
		If TRBAC->LINHAS-TRBAC->LINHAS_FEITAS == 0
			nFinal+= TRBAC->LINHAS_FEITAS
		Else
			nPend+= TRBAC->LINHAS-TRBAC->LINHAS_FEITAS
		EndIf

		//NUMERO OPERADORES
		If !TRBAC->CB7_CODOPE $cCodOPer .And. !Empty(TRBAC->CB7_CODOPE)
			cCodOPer +=TRBAC->CB7_CODOPE+"|"
			nQOper	++
		EndIf

		// Calcula o total de horas entre dos hor rios.
		/*
		A680Tempo(dDataIni, cHoraIni, dDataFim, cHoraFim)
		Parametros³ ExpD1 - Data Inicial
		³ ExpN1 - Hor rio Inicial
		³ ExpD2 - Data Final
		³ ExpN2 - Hor rio Final
		*/

		If !(Len(AllTrim(TRBAC->HR_INI)) < 5 .Or. Len(AllTrim(TRBAC->HR_FIM)) < 5) .And. !Empty(TRBAC->CB7__DTINI) .And. !Empty(TRBAC->CB7__DTFIM)
			//ARMAZENA AS HORAS E DADTAS INCIAIS E FINAIS
			If cHrIni > TRBAC->HR_INI
				cHrIni := TRBAC->HR_INI
			EndIf
			If cHrFim < TRBAC->HR_FIM
				cHrFim := TRBAC->HR_FIM
			EndIf
			If dDtIni > TRBAC->CB7__DTINI
				dDtIni := TRBAC->CB7__DTINI
			EndIf
			If dDtFim < TRBAC->CB7__DTFIM
				dDtFim := TRBAC->CB7__DTFIM
			EndIf

			nDifTempo	:= A680Tempo( TRBAC->CB7__DTINI,TRBAC->HR_INI,TRBAC->CB7__DTFIM,TRBAC->HR_FIM )
			nTemp24 	:= 0

			//NAO CONTA HORARIO DE ALMOCO
			If TRBAC->HR_INI > "12:00" .And. TRBAC->HR_INI < "13:00"
				nTemp24 := A680Tempo( TRBAC->CB7__DTINI,"12:00",TRBAC->CB7__DTFIM,"13:00" )
				nDifTempo -= nTemp24
			EndIf
			//NAO CONTA PERIODO NOTURNO
			If TRBAC->CB7__DTINI #TRBAC->CB7__DTFIM
				nTemp24 := A680Tempo( TRBAC->CB7__DTINI,"22:00",TRBAC->CB7__DTFIM,"08:00" )
				nDifTempo -= nTemp24
			EndIf

			//ARMAZENA ESTATISTICAS DO OPERADOR
			nAscan := Ascan(aOper, {|e| e[1] == TRBAC->CB7_CODOPE})
			If nAscan > 0
				//aOper 01-CODIGO, 02- NOME, 03- LOCAIS,04-TEMPO, 05-PECAS, 06-LOCAIS FEITOS, 07- SETOR
				aOper[nAscan][4] += nDifTempo
			EndIf

			nTempo+=nDifTempo

			//TRANSFORMA O TEMPO DE CENTESIMAL PARA HORAS
			cDifTempo := U_ConVDecHora(nDifTempo)

		Else
			nDifTempo := 0
			cDifTempo := "00:00"
		EndIf

		nEndMin := nDifTempo/TRBAC->LINHAS
		cEndMin := U_ConVDecHora(nEndMin)


		If cFiltro == "Todos" .Or. (cFiltro == "Pendente" .And. TRBAC->LINHAS-TRBAC->LINHAS_FEITAS > 0 .And. Empty(TRBAC->CB7_NOTA) .And. Iif( cNOpc == "P",TRBAC->CB7__CHECK <> "2",TRBAC->CB7_STATUS <> "9")) .Or. (cFiltro == "Finalizado" .And. TRBAC->LINHAS-TRBAC->LINHAS_FEITAS == 0)
			// 01 - COR , 02 - COD OPERADOR, 03- NOME, 04- ORDEM SEP, 05 - PAUSA, 06 - SETOR, 07 - PECAS, 08 - LINHAS, 09 - PORC LINHA X ONDA , 10- LINHAS FEITOS,11 - PORC EFETUADA LINHA, 12- DATA ICIAL, 13- DATA FINAL, 14-HR INICIAL, 15- HR FINAL , 16-TEMPO, 17-LINHA X MIN, 18-PEDIDO
			nOnline += Iif(Empty(TRBAC->CB7_CODOPE) ,0,1)
			If cFiltro == "Pendente"  .Or. (cFiltro == "Todos" .And. TRBAC->CB7__CHECK <> "2" .And. Empty(TRBAC->CB7_NOTA))
				nPedFalta ++
			EndIf

			aAdd(aAcomp,{LoadBitMap(GetResources(),cCor),;
			Iif(Empty(TRBAC->CB7_CODOPE) .And. !Empty(TRBAC->CB7_NOTA),"999999",TRBAC->CB7_CODOPE),;
			Iif(Empty(TRBAC->CB7_CODOPE) .And. !Empty(TRBAC->CB7_NOTA),"FATURADO S/ PRE-CHECKOUT",Iif(Empty(TRBAC->CB7_CODOPE),"Z",TRBAC->CB1_NOME)),;
			TRBAC->CB7_ORDSEP,;
			Iif(TRBAC->CB7_STATPA == "1","S","N"),;
			'',;
			TRBAC->PECAS,;
			TRBAC->LINHAS,;
			Transform(nLcPorc,"@E 999.99"),;
			TRBAC->LINHAS_FEITAS,;
			Transform(nLcEfPorc,"@E 999.99"),;
			DTOC(TRBAC->CB7__DTINI),;
			DTOC(TRBAC->CB7__DTFIM),;
			TRBAC->HR_INI,;
			TRBAC->HR_FIM,;
			cDifTempo,;
			cEndMin,;
			TRBAC->CB7_PEDIDO,;
			''})
		EndIf
		dbSelectArea("TRBAC")
		dbSkip()
	End

	//EFETUA CALCULA O FINAL DAS ESTATISTICAS DA ONDA E DOS OPERADORES
	For kx:=1 To Len(aOper)
		//aOper 01-CODIGO, 02- NOME, 03- LINHAS,04-TEMPO, 05-PECAS, 06-LINHAS FEITAS, 07- SETOR, 08- MIN/END, 09- PRODUTIVIDADE LINHA
		nMinEnd := aOper[Kx][4]/aOper[Kx][6]
		aOper[Kx][8]+= nMinEnd
		aOper[Kx][9]+= (aOper[Kx][3]/nLocais)*100
	Next

	//MONTA A PRODUTIVIDADE POR OPERADOR
	aProd := {}
	For Kx:=1 To Len(aOper)
		nAscan := Ascan(aProd, {|e| e[1] == aOper[Kx][2]})
		If nAscan == 0
			//AProd 01- NOME, 02- ENDERECOS FEITOS, 03-PRODUTIVIDADE TOTAL, 04 - MINUTOS, 05 - MIN/LINHAS
			aAdd(aProd,{aOPer[Kx][2],aOPer[Kx][6],nLocais, aOper[Kx][4],(aOper[Kx][4]/aOPer[Kx][6])})
		Else
			aProd[nAscan][2]+= aOPer[Kx][6] //SOMA ENDERECOS FEITOS
			aProd[nAscan][4]+= aOPer[Kx][4] //SOMA TEMPO
			aProd[nAscan][5]+= (aOper[Kx][4]/aOPer[Kx][6]) //SOMA MIN/LINHA
		EndIf
	Next



	nPFinal	:= (nPend/nLocais)*100
	nMLocal	:= (nTempo/nFinal)
	nTempo := nTempo/nQOper

	//TRANSFORMA O TEMPO DE CENTESIMAL PARA HORAS
	cTempo  := U_ConVDecHora(nTempo)
	cMLocal := U_ConVDecHora(nMLocal)

	//MONTA O CABECALHO
	cFields := " "
	nCampo 	:= 0
	TRBAC->(dbCloseArea())

	If nTamAcolPre == 0
		nTamAcolPre := Len(aAcomp)
	ElseIf nTamAcolPre <> Len(aAcomp)
		While nTamAcolPre <> Len(aAcomp)
			// 01 - COR , 02 - COD OPERADOR, 03- NOME, 04- ORDEM SEP, 05 - PAUSA, 06 - SETOR, 07 - PECAS, 08 - LINHAS, 09 - PORC LINHA X ONDA , 10- LINHAS FEITOS,11 - PORC EFETUADA LINHA, 12- DATA ICIAL, 13- DATA FINAL, 14-HR INICIAL, 15- HR FINAL , 16-TEMPO, 17-LINHA X MIN, 18-PEDIDO
			aAdd(aAcomp,{'','','Z','ZZZZZZ','','',0,0,0,0,0,CTOD(''),CTOD(''),":",":",0,0,''})
		End
	EndIf



	If Len(aAcomp) == 0
		If cNOpc == "P"
			MsgInfo("N�o existem mais Pre-checkouts pendentes!")
		Else
			MsgInfo("N�o existem mais Checkouts pendentes!")
		EndIf
		Return
	EndIf

	If cOrdem == "Operador"
		ASort(aAcomp,,,{|x,y|x[3]+x[14]<y[3]+y[14]})
	ElseIf cOrdem == "Tempo"
		ASort(aAcomp,,,{|x,y|x[16]>y[16]})
	ElseIf cOrdem == "% Faltante"
		ASort(aAcomp,,,{|x,y|x[11]>y[11]})
	ElseIf cOrdem == "Pedido"
		ASort(aAcomp,,,{|x,y|x[18]<y[18]})
	ElseIf cOrdem == "Ordem Sep."
		ASort(aAcomp,,,{|x,y|x[4]<y[4]})
	EndIf

Return

/*
ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÝÝÝÝÝÝÝÝÝÝÑÝÝÝÝÝÝÝÝÝÝËÝÝÝÝÝÝÝÑÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝËÝÝÝÝÝÝÑÝÝÝÝÝÝÝÝÝÝÝÝÝ»±±
±±ºPrograma  ³AtuSep    ºAutor  ³Microsiga           º Data ³  03/01/13   º±±
±±ÌÝÝÝÝÝÝÝÝÝÝØÝÝÝÝÝÝÝÝÝÝÊÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÊÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝ¹±±
±±ºDesc.     ³ATUALIZA DADOS SEPARACAO                                    º±±
±±º          ³                                                            º±±
±±ÌÝÝÝÝÝÝÝÝÝÝØÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function A005AtuSep()
	Local Kx := 0
	nOnline := 0
	nLocais := 0
	nFinal 	:= 0
	nPend 	:= 0
	nPFinal	:= 0
	nOnline	:= 0
	nQOper 	:= 0
	cTempo 	:= ""
	cMLocal	:= ""
	aOper	:= {}
	aEnder	:= {}
	aProd	:={}


	cQuery := " SELECT CB7_CODOPE , CB1_NOME, CB7_ORDSEP, CB7_STATPA  , CB7_STATUS ,"
	cQuery += " (SELECT TOP 1 CASE WHEN ((SUBSTRING(CB8_LCALIZ,9,1) > '2' AND LEFT(CB8_LCALIZ,2)= 'PP')OR LEFT(CB8_LCALIZ,2)= 'PI') THEN
	cQuery += " 'EM'"
	cQuery += " ELSE"
	cQuery += " LEFT(CB8_LCALIZ,2) "
	cQuery += " END  FROM "+RetSqlName("CB8")+" WITH(NOLOCK) WHERE CB7_FILIAL = CB8_FILIAL AND CB8_ORDSEP = CB7_ORDSEP AND D_E_L_E_T_ <> '*' ORDER BY CB8_LCALIZ DESC) SETOR,"
	cQuery += " (SELECT SUM(CB8_QTDORI) FROM "+RetSqlName("CB8")+" WITH(NOLOCK) WHERE CB7_FILIAL = CB8_FILIAL AND CB8_ORDSEP = CB7_ORDSEP AND D_E_L_E_T_ <> '*') PECAS,"
	cQuery += " (SELECT COUNT(CB8_LCALIZ ) FROM "+RetSqlName("CB8")+" WITH(NOLOCK) WHERE CB7_FILIAL = CB8_FILIAL AND CB8_ORDSEP = CB7_ORDSEP AND D_E_L_E_T_ <> '*') LOCAIS,"
	cQuery += " (SELECT COUNT(CB8_LCALIZ ) FROM "+RetSqlName("CB8")+" WITH(NOLOCK) WHERE CB7_FILIAL = CB8_FILIAL AND CB8_ORDSEP = CB7_ORDSEP AND D_E_L_E_T_ <> '*' AND CB8_SALDOS = 0) LOCAIS_FEITOS,"
	cQuery += " CB7_DTINIS  ,"
	cQuery += " CB7_DTFIMS  ,"
	cQuery += " SUBSTRING(CB7_HRINIS     ,1,2)+':'+SUBSTRING(CB7_HRINIS     ,3,2) HR_INI, "
	cQuery += " SUBSTRING(CB7_HRFIMS      ,1,2)+':'+SUBSTRING(CB7_HRFIMS     ,3,2) HR_FIM"
	cQuery += " FROM "+RetSqlName("CB7")+"  CB7 WITH(NOLOCK)"
	cQuery += " LEFT JOIN "+RetSqlName("CB1")+" WITH(NOLOCK) ON CB1_FILIAL = CB7_FILIAL AND CB1_CODOPE = CB7_CODOPE "
	cQuery += " WHERE CB7__PRESE = '"+cAcompOnda+"' "
	cQuery += " and CB7_PEDIDO = ''"
	cQuery += " AND CB7_FILIAL = '"+cFilAnt+"' AND CB7.D_E_L_E_T_ <> '*'  "
	cQuery += " order by LOCAIS DESC"

	MemoWrite("ACDAT00515.SQL",cQuery)
	dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),"TRBAC", .F., .T.)

	TcSetField('TRBAC','CB7_DTINIS','D')
	TcSetField('TRBAC','CB7_DTFIMS','D')

	Count To nRec1

	If nRec1 == 0
		MsgStop("N�o existem dados para esta Onda!","Aten��o")
		TRBAC->(dbCloseArea())
		Return
	EndIf

	//ABRE TELA PARA SELECAO DE PEDIDOS
	dbSelectArea("TRBAC")
	ProcRegua(nRec1)
	dbGotop()

	While !Eof()
		nLocais += TRBAC->LOCAIS
		//ARMAZENA ESTATISTICAS DO OPERADOR
		nAscan := Ascan(aOper, {|e| e[1] == TRBAC->CB7_CODOPE .And. e[7] == TRBAC->SETOR})
		If nAscan == 0
			//aOper 01-CODIGO, 02- NOME, 03- LOCAIS,04-TEMPO, 05-PECAS, 06-LOCAIS FEITOS, 07- SETOR, 08- MIN/END, 09- PRODUTIVIDADE ENDERECO
			aAdd(aOper,{TRBAC->CB7_CODOPE,TRBAC->CB1_NOME,TRBAC->LOCAIS,0,TRBAC->PECAS, TRBAC->LOCAIS_FEITOS, TRBAC->SETOR, 0 ,0})
		Else
			aOper[nAscan][3] +=TRBAC->LOCAIS
			aOper[nAscan][5] +=TRBAC->PECAS
			aOper[nAscan][6] += TRBAC->LOCAIS_FEITOS
		EndIf

		//ARMAZENA ESTATISTICAS DA ONDA
		nAscan := Ascan(aEnder, {|e| e[1] == TRBAC->SETOR})
		If nAscan == 0
			//aEnder 01-SETOR, 02- LOCAIS, 03- LOCAIS FEITOS, 04-PECAS, 05-TEMPO, 06- MIN/END, 07-% ENDERECOS
			aAdd(aEnder,{TRBAC->SETOR,TRBAC->LOCAIS,TRBAC->LOCAIS_FEITOS,TRBAC->PECAS,0,0,0})
		Else
			aEnder[nAscan][2] += TRBAC->LOCAIS
			aEnder[nAscan][3] += TRBAC->LOCAIS_FEITOS
			aEnder[nAscan][4] += TRBAC->PECAS
		EndIf
		dbSelectArea("TRBAC")
		dbSkip()
	End


	aAcomp	 := {}
	cCodOPer := ""
	dbSelectArea("TRBAC")
	dbGotop()
	cHrIni := TRBAC->HR_INI
	cHrFim := TRBAC->HR_FIM
	dDtIni := TRBAC->CB7_DTINIS
	dDtFim := TRBAC->CB7_DTFIMS

	While !Eof()
		IncProc("Gerando dados")
		nLcPorc 	:= (TRBAC->LOCAIS/nLocais)*100
		nLcEfPorc 	:= (TRBAC->LOCAIS_FEITOS/TRBAC->LOCAIS)*100
		cCor		:= Iif(TRBAC->LOCAIS-TRBAC->LOCAIS_FEITOS == 0,"BR_VERDE",Iif(!Empty(TRBAC->CB7_CODOPE),"BR_VERMELHO","BR_BRANCO"))

		//LOCAIS FINALIZADOS
		If TRBAC->LOCAIS-TRBAC->LOCAIS_FEITOS == 0
			nFinal+= TRBAC->LOCAIS_FEITOS
		Else
			nPend+= TRBAC->LOCAIS-TRBAC->LOCAIS_FEITOS
		EndIf

		//NUMERO OPERADORES
		If !TRBAC->CB7_CODOPE $cCodOPer .And. !Empty(TRBAC->CB7_CODOPE)
			cCodOPer +=TRBAC->CB7_CODOPE+"|"
			nQOper	++
		EndIf

		// Calcula o total de horas entre dos hor rios.
		/*
		A680Tempo(dDataIni, cHoraIni, dDataFim, cHoraFim)
		Parametros³ ExpD1 - Data Inicial
		³ ExpN1 - Hor rio Inicial
		³ ExpD2 - Data Final
		³ ExpN2 - Hor rio Final
		*/
		If TRBAC->HR_INI # "  :  "
			//ARMAZENA AS HORAS E DADTAS INCIAIS E FINAIS
			If cHrIni > TRBAC->HR_INI
				cHrIni := TRBAC->HR_INI
			EndIf
			If cHrFim < TRBAC->HR_FIM
				cHrFim := TRBAC->HR_FIM
			EndIf
			If dDtIni > TRBAC->CB7_DTINIS
				dDtIni := TRBAC->CB7_DTINIS
			EndIf
			If dDtFim < TRBAC->CB7_DTFIMS
				dDtFim := TRBAC->CB7_DTFIMS
			EndIf
			nDifTempo	:= A680Tempo( TRBAC->CB7_DTINIS,TRBAC->HR_INI,TRBAC->CB7_DTFIMS,TRBAC->HR_FIM )
			nTemp24 	:= 0

			//NAO CONTA HORARIO DE ALMOCO
			If TRBAC->HR_INI > "12:00" .And. TRBAC->HR_INI < "13:00"
				nTemp24 := A680Tempo( TRBAC->CB7_DTINIS,"12:00",TRBAC->CB7_DTFIMS,"13:00" )
				nDifTempo -= nTemp24
			EndIf

			//NAO CONTA PERIODO DA NOITE
			If TRBAC->CB7_DTINIS #TRBAC->CB7_DTFIMS
				nTemp24 := A680Tempo( TRBAC->CB7_DTINIS,"22:00",TRBAC->CB7_DTFIMS,"08:00" )
				nDifTempo -= nTemp24
			EndIf

			nTempo+=nDifTempo

			//ARMAZENA ESTATISTICAS DO OPERADOR
			nAscan := Ascan(aOper, {|e| e[1] == TRBAC->CB7_CODOPE .And. e[7] == TRBAC->SETOR})
			If nAscan > 0
				//aOper 01-CODIGO, 02- NOME, 03- LOCAIS,04-TEMPO, 05-PECAS, 06-LOCAIS FEITOS, 07- SETOR
				aOper[nAscan][4] += nDifTempo
			EndIf

			//ARMAZENA ESTATISTICAS DA ONDA
			nAscan := Ascan(aEnder, {|e| e[1] == TRBAC->SETOR})
			If nAscan > 0
				//aEnder 01-SETOR, 02- LOCAIS, 03- LOCAIS FEITOS, 04-PECAS, 05-TEMPO
				aEnder[nAscan][5] += nDifTempo
			EndIf

			//TRANSFORMA O TEMPO DE CENTESIMAL PARA HORAS
			cDifTempo:= U_ConVDecHora(nDifTempo)
		Else
			cDifTempo	:= '00:00'
		EndIf
		nEndMin := nDifTempo/TRBAC->LOCAIS
		cEndMin:= U_ConVDecHora(nEndMin)

		If cFiltro == "Todos" .Or. (cFiltro == "Pendente" .And. TRBAC->LOCAIS-TRBAC->LOCAIS_FEITOS > 0 .And. TRBAC->CB7_STATUS <> '9' ) .Or. (cFiltro == "Finalizado" .And. TRBAC->LOCAIS-TRBAC->LOCAIS_FEITOS == 0 .And.  TRBAC->CB7_STATUS = '9')
			nOnline += Iif(Empty(TRBAC->CB7_CODOPE) ,0,1)
			// 01 - COR , 02 - COD OPERADOR, 03- NOME, 04- ORDEM SEP, 05 - PAUSA, 06 - SETOR, 07 - PECAS, 08 - ENDERECOS, 09 - PORC END X ONDA , 10- END FEITOS,11 - PORC EFETUADA END, 12- DATA ICIAL, 13- DATA FINAL, 14-HR INICIAL, 15- HR FINAL , 16-TEMPO, 17-ENDERECO X MIN
			aAdd(aAcomp,{LoadBitMap(GetResources(),cCor),TRBAC->CB7_CODOPE,Iif(Empty(TRBAC->CB7_CODOPE),"Z",TRBAC->CB1_NOME),TRBAC->CB7_ORDSEP, Iif(TRBAC->CB7_STATPA == "1","S","N"), TRBAC->SETOR, TRBAC->PECAS, TRBAC->LOCAIS, Transform(nLcPorc,"@E 999.99"),TRBAC->LOCAIS_FEITOS,Transform(nLcEfPorc,"@E 999.99"),DTOC(TRBAC->CB7_DTINIS), DTOC(TRBAC->CB7_DTFIMS), TRBAC->HR_INI, TRBAC->HR_FIM,cDifTempo,cEndMin,''})
		EndIf


		dbSelectArea("TRBAC")
		dbSkip()
	End
	//nTempo	:= A680Tempo( dDtIni,cHrIni,dDtFim,cHrFim )

	nPFinal	:= (nPend/nLocais)*100
	nMLocal	:= nTempo/nFinal
	nTempo := nTempo/nQOper

	//TRANSFORMA O TEMPO DE CENTESIMAL PARA HORAS
	cTempo:= U_ConVDecHora(nTempo)
	cMLocal:= U_ConVDecHora(nMLocal)


	//EFETUA CALCULA O FINAL DAS ESTATISTICAS DA ONDA E DOS OPERADORES
	For kx:=1 To Len(aOper)
		//aOper 01-CODIGO, 02- NOME, 03- LOCAIS,04-TEMPO, 05-PECAS, 06-LOCAIS FEITOS, 07- SETOR, 08- MIN/END, 09- PRODUTIVIDADE ENDERECO
		nMinEnd := aOper[Kx][4]/aOper[Kx][6]
		aOper[Kx][8]+= nMinEnd

		nAscan := Ascan(aEnder, {|e| e[1] == aOper[Kx][7]})
		aOper[Kx][9]+= (aOper[Kx][3]/aEnder[nAscan][2])*100
	Next

	For kx:=1 To Len(aEnder)
		//aEnder 01-SETOR, 02- LOCAIS, 03- LOCAIS FEITOS, 04-PECAS, 05-TEMPO, 06- MIN/END, 07-% ENDERECOS
		aEnder[Kx][6] += aEnder[Kx][5]/aEnder[Kx][2]
		aEnder[Kx][7] += (aEnder[Kx][2]/nLocais)*100
	Next

	//MONTA A PRODUTIVIDADE POR OPERADOR
	aProd := {}
	For Kx:=1 To Len(aOper)
		nAscan := Ascan(aProd, {|e| e[1] == aOper[Kx][2]})
		If nAscan == 0
			//AProd 01- NOME, 02- ENDERECOS FEITOS, 03-PRODUTIVIDADE TOTAL, 04 - MINUTOS, 05 - MIN/LINHAS
			aAdd(aProd,{aOPer[Kx][2],aOPer[Kx][6],nLocais, aOper[Kx][4],(aOper[Kx][4]/aOPer[Kx][6])})
		Else
			aProd[nAscan][2]+= aOPer[Kx][6] //SOMA ENDERECOS FEITOS
			aProd[nAscan][4]+= aOPer[Kx][4] //SOMA TEMPO
			aProd[nAscan][5]+= (aOper[Kx][4]/aOPer[Kx][6]) //MINUTOS ENDERECOS
		EndIf
	Next



	//MONTA O CABECALHO
	cFields := " "
	nCampo 	:= 0
	TRBAC->(dbCloseArea())


	If nTamAcolSep == 0
		nTamAcolSep := Len(aAcomp)
	ElseIf nTamAcolSep <> Len(aAcomp)
		While nTamAcolSep <> Len(aAcomp)
			// 01 - COR , 02 - COD OPERADOR, 03- NOME, 04- ORDEM SEP, 05 - PAUSA, 06 - SETOR, 07 - PECAS, 08 - ENDERECOS, 09 - PORC END X ONDA , 10- END FEITOS,11 - PORC EFETUADA END, 12- DATA ICIAL, 13- DATA FINAL, 14-HR INICIAL, 15- HR FINAL , 16-TEMPO, 17-ENDERECO X MIN
			aAdd(aAcomp,{'','','Z','','','',0,0,0,0,0,CTOD(''),CTOD(''),"","",0,0})
		End
	EndIf

	If Len(aAcomp) == 0
		MsgInfo("N�o existem mais enderecos pendentes!")
		Return
	EndIf


	If cOrdem == "Enderecos"
		ASort(aAcomp,,,{|x,y|x[8]+x[14]>y[8]+y[14]})
	ElseIf cOrdem == "Operador"
		ASort(aAcomp,,,{|x,y|x[3]+x[14]<y[3]+y[14]})
	ElseIf cOrdem == "Tempo"
		ASort(aAcomp,,,{|x,y|x[16]>y[16]})
	ElseIf cOrdem == "% Faltante"
		ASort(aAcomp,,,{|x,y|x[11]>y[11]})
	EndIf

Return


/*
ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÝÝÝÝÝÝÝÝÝÝÑÝÝÝÝÝÝÝÝÝÝËÝÝÝÝÝÝÝÑÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝËÝÝÝÝÝÝÑÝÝÝÝÝÝÝÝÝÝÝÝÝ»±±
±±ºPrograma  ³ACDAT005  ºAutor  ³Microsiga           º Data ³  03/03/13   º±±
±±ÌÝÝÝÝÝÝÝÝÝÝØÝÝÝÝÝÝÝÝÝÝÊÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÊÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÝÝÝÝÝÝÝÝÝÝØÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function A005LibOnda(cLOnda,cOper,cTrava)

	If MsgYesNo("Esta rotina libera/bloqueia a onda para separa��o, deseja prosseguir?","ACDAT004")
		cQuery := " UPDATE "+RetSqlName("CB7")
		cQuery += " SET CB7__TRAVA = '"+Iif(cTrava == "N","S","N")+"'"
		cQuery += " WHERE CB7_FILIAL = '"+cFilAnt+"' AND CB7__PRESE = '"+cLOnda+"'
		cQuery += " AND CB7_OP <> ''"
		cQuery += " AND D_E_L_E_T_ <> '*'"

		If TcSqlExec(cQuery) <0
			UserException( "Erro na atualiza��o"+ Chr(13)+Chr(10) + "Processo com erros"+ Chr(13)+Chr(10) + TCSqlError() )
		EndIf

		aOnda[o1ListBox:nAt,13]:= Iif(cTrava == "N","S","N")
		aOnda[o1ListBox:nAt,1] := Iif(cTrava == "N",LoadBitMap(GetResources(),"BR_AZUL"),LoadBitMap(GetResources(),"BR_VERDE"))
	EndIf

Return


/*
ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÝÝÝÝÝÝÝÝÝÝÑÝÝÝÝÝÝÝÝÝÝËÝÝÝÝÝÝÝÑÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝËÝÝÝÝÝÝÑÝÝÝÝÝÝÝÝÝÝÝÝÝ»±±
±±ºPrograma  ³ACDAT005  ºAutor  ³Microsiga           º Data ³  03/04/13   º±±
±±ÌÝÝÝÝÝÝÝÝÝÝØÝÝÝÝÝÝÝÝÝÝÊÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÊÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÝÝÝÝÝÝÝÝÝÝØÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function A005AlertaOnda()
	Local oDlgOper
	Local oOP2ListBox,cOP2Line,bOP2Line
	Local aOP2TitCampos := {}
	Local aOP2Coord := {}
	Private aAlerta := {}
	Private cAOnda
	Private cACrono		:= "00:00"							// Cronometro da ligacao atual
	Private oACrono
	Private cATimeOut		:= "00:00"                        	// Time out do atendimento (Posto de venda)
	Private nATimeSeg		:= 0                      			// Segundos do cronograma
	Private nATimeMin		:= 0                      			// Minutos do cronograma
	Private nTamAcolAle		:= 0
	U_ALWSAT02()

	If Len(aAlerta) == 0
		aAdd(aAlerta,{'','', '  /  /  ','','',0,''})
	EndIf

	@050,005 TO 450,550  DIALOG oDlgOper TITLE "Alerta Onda"
	//01-OPERADOR, 02-NOME, 03-DATA INICIAL, 04- HORA INICIAL, 05-ALERTA, 06 -TEMPO DECORRIDO, 07- OPERACAO

	aOP2TitCampos := {'',OemToAnsi("Codigo"),OemToAnsi("Nome"),OemToAnsi("Data Inicio"),OemToAnsi("Hora Inicio"),OemToAnsi("Tempo"),OemToAnsi("Operacão"),''}

	cOP2Line := "{aAlerta[oOP2ListBox:nAT][5],aAlerta[oOP2ListBox:nAT][1],aAlerta[oOP2ListBox:nAT][2],aAlerta[oOP2ListBox:nAT][3],aAlerta[oOP2ListBox:nAT][4],U_ConVDecHora(aAlerta[oOP2ListBox:nAT][6]),aAlerta[oOP2ListBox:nAT][7],''}"

	aOP2Coord := {2,6,15,6,6,6,,6,1}

	bOP2Line := &( "{ || " + cOP2Line + " }" )
	oOP2ListBox := TWBrowse():New( 10,4,270,160,,aOP2TitCampos,aOP2Coord,oDlgOper,,,,,,,,,,,,.F.,,.T.,,.F.,,,)
	oOP2ListBox:SetArray(aAlerta)
	oOP2ListBox:bLine := bOP2Line

	@ 180,150 BUTTON "Sair" 	SIZE 40,10 ACTION oDlgOper:End() PIXEL OF oDlgOper
	@ 180,210 SAY oACrono VAR cACrono PIXEL FONT oFnt1 COLOR CLR_BLUE SIZE 55,15 PICTURE "99:99" OF oDlgOper

	oATimer := TTimer():New( 10 * 1000, {||ALERTAAtuCro(1)  }, oDlgOper )
	oATimer:lActive   := .T. // para ativar

	ACTIVATE DIALOG oDlgOper CENTERED


Return
/*
ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÝÝÝÝÝÝÝÝÝÝÑÝÝÝÝÝÝÝÝÝÝËÝÝÝÝÝÝÝÑÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝËÝÝÝÝÝÝÑÝÝÝÝÝÝÝÝÝÝÝÝÝ»±±
±±ºPrograma  ³ACDAT005  ºAutor  ³Microsiga           º Data ³  03/04/13   º±±
±±ÌÝÝÝÝÝÝÝÝÝÝØÝÝÝÝÝÝÝÝÝÝÊÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÊÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÝÝÝÝÝÝÝÝÝÝØÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function A005ALWSAT02()
	aAlerta := {}
	//ZERA O CRONOMETRO
	nATimeMin := 0
	nATimeSeg := 0
	cATimeAtu := "00:00"

	//Cursorwait()

	cQuery := " SELECT CB1_CODOPE , CB1_NOME,"
	cQuery += " ISNULL((SELECT TOP 1 CB7_ORDSEP  FROM "+RetSqlName("CB7")+" WHERE CB7_FILIAL = CB1_FILIAL AND CB7_CODOPE = CB1_CODOPE  AND CB7_STATUS <> '9'  AND CB7_DTFIMS = '' AND CB7_PEDIDO = '' AND CB7_NOTA = ''  AND CB7_DTEMIS >= '"+Dtos(dDatabase-15)+"' ORDER BY CB7_ORDSEP DESC ),'')  SEPARACAO,
	cQuery += " ISNULL((SELECT TOP 1 CB7_ORDSEP  FROM "+RetSqlName("CB7")+" WHERE CB7_FILIAL = CB1_FILIAL AND CB7__CODOP = CB1_CODOPE  AND CB7__CHECK <> '2' AND CB7_PEDIDO <> '' AND CB7__DTFIM = '' AND CB7_NOTA = ''  AND CB7_DTEMIS >= '"+Dtos(dDatabase-15)+"' ORDER BY CB7_ORDSEP DESC ),'')  PRECHECKOUT,
	cQuery += " ISNULL((SELECT TOP 1 CB7_ORDSEP  FROM "+RetSqlName("CB7")+" WHERE CB7_FILIAL = CB1_FILIAL AND CB7_CODOPE = CB1_CODOPE  AND CB7_STATUS <> '9' AND CB7_PEDIDO <> '' AND CB7_DTFIMS = '' AND CB7_NOTA = ''  AND CB7_DTEMIS >= '"+Dtos(dDatabase-15)+"' ORDER BY CB7_ORDSEP DESC ),'')  CHECKOUT
	cQuery += " FROM "+RetSqlName("CB1")+"  CB1"
	cQuery += " WHERE"
	cQuery += " CB1_FILIAL = '"+cFilAnt+"' AND CB1.D_E_L_E_T_ <> '*' AND CB1_STATUS = '1'"

	MemoWrite("WMST0ALERTA.SQL",cQuery)
	dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),"TRBAL", .F., .T.)

	Count To nRec

	If nRec == 0
		MsgAlert("N�o existem operadores trabalhando no momento!","ACDAT005")
		TRBAL->(dbCloseArea())
	EndIf

	dbSelectArea("TRBAL")
	dbGoTop()

	While !Eof()
		If Empty(TRBAL->SEPARACAO) .And. Empty(TRBAL->PRECHECKOUT) .And. Empty(TRBAL->CHECKOUT)
			dbSkip()
			Loop
		EndIf
		//VERIFICA NA SEPARACAO
		dbSelectArea("CB7")
		dbSetOrder(1)
		If dbSeek(xFilial()+TRBAL->SEPARACAO)
			cCor := LoadBitMap(GetResources(),"BR_VERDE")
			cHrini := SUBSTRING(CB7_HRINIS     ,1,2)+':'+SUBSTRING(CB7_HRINIS     ,3,2)
			If !Empty(CB7_DTINIS)
				nDifTempo	:= A680Tempo( CB7_DTINIS,cHrini,dDataBAse,Iif(Left(Time(),5)<cHrini,cHrini,Left(Time(),5)))
				nDifTempo	:= Iif(nDifTempo <= 0,0.01,nDifTempo)
				If (nDifTempo/CB7_NUMITE )>= 0.1 .And. (nDifTempo/CB7_NUMITE )< 0.2
					cCor := LoadBitMap(GetResources(),"BR_AMARELO")
				ElseIf 	(nDifTempo/CB7_NUMITE )>= 0.2
					cCor := LoadBitMap(GetResources(),"BR_VERMELHO")
				EndIf
			EndIf
			//01-OPERADOR, 02-NOME, 03-DATA INICIAL, 04- HORA INICIAL, 05-ALERTA, 06 -TEMPO DECORRIDO, 07- OPERACAO
			aAdd(aAlerta,{TRBAL->CB1_CODOPE,TRBAL->CB1_NOME, Dtoc(CB7_DTINIS),cHrini,cCor,(nDifTempo/CB7_NUMITE) ,"SEPARACAO"})
		EndIf

		//VERIFICA PRE-CHECKOUT
		dbSelectArea("CB7")
		dbSetOrder(1)
		If dbSeek(xFilial()+TRBAL->PRECHECKOUT)
			cCor := LoadBitMap(GetResources(),"BR_VERDE")
			cHrini := SUBSTRING(CB7__HRINI     ,1,2)+':'+SUBSTRING(CB7__HRINI     ,3,2)
			If !Empty(CB7__DTINI)
				nDifTempo	:= A680Tempo( CB7__DTINI,cHrini,dDataBAse,Iif(Left(Time(),5)<cHrini,cHrini,Left(Time(),5)) )
				nDifTempo	:= Iif(nDifTempo <= 0,0.01,nDifTempo)
				If (nDifTempo/CB7_NUMITE )>= 0.1 .And. (nDifTempo/CB7_NUMITE )< 0.2
					cCor := LoadBitMap(GetResources(),"BR_AMARELO")
				ElseIf 	(nDifTempo/CB7_NUMITE )>= 0.2
					cCor := LoadBitMap(GetResources(),"BR_VERMELHO")
				EndIf
			EndIf
			aAdd(aAlerta,{TRBAL->CB1_CODOPE,TRBAL->CB1_NOME, Dtoc(CB7__DTINI),cHrini,cCor,(nDifTempo/CB7_NUMITE), "PRE-CHECKOUT"})
		EndIf

		//VERIFICA CHECKOUT
		dbSelectArea("CB7")
		dbSetOrder(1)
		If dbSeek(xFilial()+TRBAL->CHECKOUT)
			cCor := LoadBitMap(GetResources(),"BR_VERDE")
			cHrini := SUBSTRING(CB7_HRINIS     ,1,2)+':'+SUBSTRING(CB7_HRINIS     ,3,2)
			If !Empty(CB7_DTINIS)
				nDifTempo	:= A680Tempo( CB7_DTINIS,cHrini,dDataBAse,Iif(Left(Time(),5)<cHrini,cHrini,Left(Time(),5)))
				nDifTempo	:= Iif(nDifTempo <= 0,0.01,nDifTempo)
				If (nDifTempo/CB7_NUMITE )>= 0.1 .And. (nDifTempo/CB7_NUMITE )< 0.2
					cCor := LoadBitMap(GetResources(),"BR_AMARELO")
				ElseIf 	(nDifTempo/CB7_NUMITE )>= 0.2
					cCor := LoadBitMap(GetResources(),"BR_VERMELHO")
				EndIf
			EndIf
			aAdd(aAlerta,{TRBAL->CB1_CODOPE,TRBAL->CB1_NOME, Dtoc(CB7_DTINIS),cHrini,cCor,(nDifTempo/CB7_NUMITE),"CHECKOUT"})
		EndIf

		dbSelectArea("TRBAL")
		dbSkip()
	End

	If nTamAcolAle == 0
		nTamAcolAle := Len(aAlerta)
	ElseIf nTamAcolAle <> Len(aAlerta)
		While nTamAcolAle <> Len(aAlerta)
			aAdd(aAlerta,{'','Z',CTOD(''),'',"",0,''})
		End
	EndIf

	ASort(aAlerta,,,{|x,y|x[6]>y[6]})
	TRBAL->(dbCloseArea())
	//CursorArrow()

Return


/*
ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÝÝÝÝÝÝÝÝÝÝÑÝÝÝÝÝÝÝÝÝÝËÝÝÝÝÝÝÝÑÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝËÝÝÝÝÝÝÑÝÝÝÝÝÝÝÝÝÝÝÝÝ»±±
±±ºPrograma  ³ACDAT005  ºAutor  ³Microsiga           º Data ³  03/10/11   º±±
±±ÌÝÝÝÝÝÝÝÝÝÝØÝÝÝÝÝÝÝÝÝÝÊÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÊÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÝÝÝÝÝÝÝÝÝÝØÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function ALERTAAtuCro(nTipo)
	Local cATimeAtu := ""

	cATimeOut := "03:00"

	nATimeSeg += 10

	If nATimeSeg > 59
		nATimeMin ++
		nATimeSeg := 0
		If nATimeMin > 60
			nATimeMin := 0
		Endif
	Endif

	cATimeAtu := STRZERO(nATimeMin,2,0)+":"+STRZERO(nATimeSeg,2,0)

	If cATimeAtu >= cATimeOut
		oACrono:nClrText := CLR_RED
		oACrono:Refresh()

		U_ALWSAT02()

	Endif

	cACrono := cATimeAtu
	oACrono:Refresh()
Return(.T.)






/*
ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÝÝÝÝÝÝÝÝÝÝÑÝÝÝÝÝÝÝÝÝÝËÝÝÝÝÝÝÝÑÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝËÝÝÝÝÝÝÑÝÝÝÝÝÝÝÝÝÝÝÝÝ»±±
±±ºPrograma  ³WSAT02B   ºAutor  ³Paulo Bindo         º Data ³  03/08/12   º±±
±±ÌÝÝÝÝÝÝÝÝÝÝØÝÝÝÝÝÝÝÝÝÝÊÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÊÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝ¹±±
±±ºDesc.     ³EXIBE OS PEDIDOS FORA DA ONDA                               º±±
±±º          ³                                                            º±±
±±ÌÝÝÝÝÝÝÝÝÝÝØÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function WSAT02B(cSituacao, cTipTela)
	Local oDlgStat
	//Local dData 	:= dDataBase
	Local mm		:= 0
	LOCAL CMARCA	:= ""

	Private aOPsB := {}
	Private oBListBox

	If cTipTela == "1" //PEDIDO
		CMARCA:="TAIFF"
		For mm :=1 To Len(aNumPed)
			If cSituacao == aNumPed[mm][2]
				cStatus := aNumPed[mm][2]			

				//01- COR, 02-PEDIDO, 03-DATA
				cCor := LoadBitMap(GetResources(),"BR_VERDE")

				aAdd(aOPsB,{cCor, aNumPed[mm][1],aNumPed[mm][4],aNumPed[mm][3],aNumPed[mm][5]})
			EndIf

		Next
	ElseIf cTipTela == "3" //PEDIDO PROART
		CMARCA:="PROART"
		For mm :=1 To Len(aNumProPed)
			If cSituacao == aNumProPed[mm][2]
				cStatus := aNumProPed[mm][2]			

				//01- COR, 02-PEDIDO, 03-DATA
				cCor := LoadBitMap(GetResources(),"BR_VERDE")

				aAdd(aOPsB,{cCor, aNumProPed[mm][1],aNumProPed[mm][4],aNumProPed[mm][3],aNumProPed[mm][5]})
			EndIf

		Next
	Else

		For mm :=1 To Len(aNumFat)
			If cSituacao == aNumFat[mm][2]
				cStatus := aNumFat[mm][2]			

				//01- COR, 02-PEDIDO, 03-DATA
				cCor := LoadBitMap(GetResources(),"BR_VERDE")

				aAdd(aOPsB,{cCor, aNumFat[mm][1],aNumFat[mm][4],aNumFat[mm][3]})
			EndIf

		Next

	EndIf

	If Len(aOPsB) == 0
		MsgStop("N�o existem dados "+cSituacao)
		Return
	EndIf	

	ASort(aOPsB,,,{|x,y|x[2]<y[2]})


	//MONTA TELA 

	//01- COR, 02-PEDIDO/NOTA, 3-CLIENTE
	aBTitCampos := {'',OemToAnsi(Iif(cTipTela == "1","Pedido ","Nota")),OemToAnsi(Iif(cTipTela == "1","Dt.Liber. ","Dt.Nota")),OemToAnsi("Cliente"),''}

	cBLine := "{aOPsB[oBListBox:nAT][1],aOPsB[oBListBox:nAT][2],aOPsB[oBListBox:nAT][3],aOPsB[oBListBox:nAT][4],}"

	bBLine := &( "{ || " + cBLine + " }" )
	nMult := 7
	aBCoord := {nMult*1,nMult*2,nMult*2,''}

	@050,005 TO 500,950  DIALOG oDlgStat TITLE Iif(cTipTela $ "1|3","Pedidos " + CMARCA,"Notas")
	oBListBox := TWBrowse():New( 10,4,450,170,,aBTitCampos,aBCoord,oDlgStat,,,,,,,,,,,,.F.,,.T.,,.F.,,,)
	oBListBox:SetArray(aOPsB)
	oBListBox:bLDblClick := { ||Processa( {||WSAT02C(aOPsB[oBListBox:nAt,2]) }) }	
	oBListBox:bLine := bBLine

	@ 185, 005 BITMAP oBmp1 ResName 	"BR_VERDE" OF oDlgStat Size 15,15 NoBorder When .F. Pixel
	@ 185, 015 SAY "Liberado" OF oDlgStat Color CLR_GREEN PIXEL
	/*
	@ 185, 065 BITMAP oBmp2 ResName 	"BR_AMARELO" OF oDlgStat Size 15,15 NoBorder When .F. Pixel
	@ 185, 075 SAY "Material Parcial" OF oDlgStat Color CLR_RED PIXEL

	@ 185, 125 BITMAP oBmp3 ResName 	"BR_VERMELHO" OF oDlgStat Size 15,15 NoBorder When .F. Pixel
	@ 185, 135 SAY "Material em Falta" OF oDlgStat Color CLR_RED PIXEL
	*/

	@ 200,430 BUTTON "Sair" 	SIZE 40,10 ACTION oDlgStat:End() PIXEL OF oDlgStat

	ACTIVATE DIALOG oDlgStat CENTERED


Return


User Function TFRELOS()
	Local lContinua      := .T.
	Local lCustRel		 := ExistBlock("ACD100RE")
	Local cCustRel		 := ""
	Local lACDR100		:= SuperGetMV("MV_ACDR100",.F.,.F.)
	Private cString      := "CB7"
	Private aOrd         := {}
	Private cDesc1       := "Este programa tem como objetivo imprimir informacoes das"
	Private cDesc2       := "Ordens de Separacao"
	Private cPict        := ""
	Private lEnd         := .F.
	Private lAbortPrint  := .F.
	Private limite       := 132
	Private tamanho      := "M"
	Private nomeprog     := "ACDA100R" // Coloque aqui o nome do programa para impressao no cabecalho
	Private nTipo        := 18
	Private aReturn      := {"Zebrado",1,"Administracao",2,2,1,"",1}  //"Zebrado"###"Administracao"
	Private nLastKey     := 0
	Private cPerg        := "ACD100"
	Private titulo       := "Impressao das Ordens de Separacao"
	Private nLin         := 06
	Private Cabec1       := ""
	Private Cabec2       := ""
	Private cbtxt        := "Regsitro(s) lido(s)"
	Private cbcont       := 0
	Private CONTFL       := 01
	Private m_pag        := 01
	Private lRet         := .T.
	Private imprime      := .T.
	Private wnrel        := "ACDA100R" // Coloque aqui o nome do arquivo usado para impressao em disco

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Variaveis utilizadas como Parametros                                ³
	//³ MV_PAR01 = Ordem de Separacao de       ?                            ³
	//³ MV_PAR02 = Ordem de Separacao Ate      ?                            ³
	//³ MV_PAR03 = Data de Emissao de          ?                            ³
	//³ MV_PAR04 = Data de Emissao Ate         ?                            ³
	//³ MV_PAR05 = Considera Ordens encerradas ?                            ³
	//³ MV_PAR06 = Imprime Codigo de barras    ?                            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	If lCustRel
		cCustRel := ExecBlock("ACD100RE",.F.,.F.)
		If ExistBlock(cCustRel)
			ExecBlock( cCustRel, .F., .F.)
		EndIf
	ElseIf lACDR100
		ACDR100()
	Else 
		//wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,Nil,.F.,aOrd,.F.,Tamanho,,.T.)

		Pergunte(cPerg,.F.)

		If	nLastKey == 27
			lContinua := .F.
		EndIf

		If	lContinua
			U_ACDR100TF()
		EndIf

		CB7->(DbClearFilter())
	EndIf
Return



/*
ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÝÝÝÝÝÝÝÝÝÝÑÝÝÝÝÝÝÝÝÝÝËÝÝÝÝÝÝÝÑÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝËÝÝÝÝÝÝÑÝÝÝÝÝÝÝÝÝÝÝÝÝ»±±
±±ºPrograma  ³ACD05LI   ºAutor  ³Paulo Bindo         º Data ³  03/08/12   º±±
±±ÌÝÝÝÝÝÝÝÝÝÝØÝÝÝÝÝÝÝÝÝÝÊÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÊÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝ¹±±
±±ºDesc.     ³LIBERA A IMPRESSAO                                          º±±
±±º          ³                                                            º±±
±±ÌÝÝÝÝÝÝÝÝÝÝØÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function ACD05LI()
	Local cOrdSep := Space(06) 

	If MsgYesNo("Deseja cancelar impress�o?","RESTA04")

		@ 65,153 To 229,435 Dialog oDlg Title OemToAnsi("Ordem Separacao")
		@ 9,9 Say OemToAnsi("Ordem Sep.") Size 99,8
		@ 28,9 Get cOrdSep Picture "@!" F3 "CB7" Size 59,10
		@ 62,39 BMPBUTTON TYPE 1 ACTION Close(oDlg)
		Activate Dialog oDlg Centered

		If !Empty(cOrdSep)
			dbSelectArea("CB7")
			dbSetOrder(1)
			If !dbSeek(xFilial()+cOrdSep)
				MsgStop("Ordem de Separacao nao encontrada","ACDAT005")
				Return
			EndIf	

			If !Empty(CB7->CB7_CODOPE)
				If !MsgBox("Atencao, Este Pedido Encontra-se com o(a) Separador(a) :"+CB7->CB7_CODOPE+" Inicio Sep: "+CB7->CB7_HRINIS+" Fim: "+CB7->CB7_HRFIMS+ " Deseja Liberar Assim Mesmo ?  ?",'Atencao','YESNO')
					Return
				Endif
			Endif
			If CB7->CB7_STATUS >= "2"
				MsgBox("Status da OS N�o permite exclus�o!, estorne a ordem de separa��o pelo coletor!","Atencao","ALERT")
				/*
				CB7->(RecLock("CB7",.F.))
				CB7->CB7_NOTA	:= ""
				CB7->CB7_SERIE	:= "" 
				CB7->(MsUnlock())
				*/				
				Return
			EndIf
			/*
			//VERIFICA SE A PRE-SEPARACAO TERMINOU, NAO SE PODE CANCELAR NESTA ETAPA
			If xFilial("SC5") == "02"
			//POSICIONA NO CABECALHO DA SEPARACAO
			dbSelectArea("CB7")
			dbSetOrder(2)
			dbSeek(xFilial()+SC5->C5_NUM)
			cOnda := CB7->CB7__PRESE

			//VERIFICA SE EXISTE UMA PRE-SEPARACAO EM ANDAMENTO
			cQuery := " SELECT * FROM "+RetSqlName("CB7")
			cQuery += " WHERE CB7__PRESE = '"+cOnda+"'
			cQuery += " AND D_E_L_E_T_ <> '*' AND CB7_PEDIDO = ''"
			cQuery += " AND CB7_STATUS <> '9'"
			MemoWrite("RESTA04C.SQL",cQuery)
			TCQUERY cQuery NEW ALIAS "CAD"
			Count To _nCount

			CAD->(dbCloseArea())

			If _nCount > 0
			MsgStop("Existe pre-separacao em andamento nesta Onda, espere o t�rmino desta etapa para cancelar o pedido!","RESTA04")
			Return
			EndIf
			EndIf
			*/
			Begin Transaction
				If ExistBlock('ACD100VE')
					lContinua := ExecBlock('ACD100VE',.F.,.F.)
					If Valtype(lContinua)#'L'
						lContinua := .T.
					EndIf
					If !lContinua
						MsgStop("N�o foi poss�vel atualizar o pedido de vendas, opera��o cancelada","ACDAT005")
						Return
					EndIf
				EndIf



				// LIMPA A "OS" NA LIBERAÇÃO DO PEDIDO (SC9)
				If !EMPTY(CB7->CB7_PEDIDO)
					dbSelectArea("SC9")
					dbSetOrder(1)
					dbSeek(xFilial("SC9")+CB7->CB7_PEDIDO)

					While !Eof() .And. SC9->C9_PEDIDO == CB7->CB7_PEDIDO .And. SC9->C9_FILIAL == xFilial("SC9")
						IF EMPTY(SC9->C9_NFISCAL)
							RecLock("SC9",.F.)
							SC9->C9_ORDSEP := ""
							SC9->C9_XORDSEP := ""
							SC9->(MsUnlock())
						ENDIF
						SC9->(dbSkip())
					End

				Else //LIMPA A "OS" NOS ITENS DA NOTA
					dbSelectArea("CB8")
					dbSetOrder(1)
					dbSeek(xFilial()+cOrdSep)
				
					dbSelectArea("SD2")
					dbSetOrder(3)
					dbSeek(xFilial("SD2") + CB8->CB8_NOTA + CB8->CB8_SERIE)

					While !Eof() .And. SD2->D2_DOC == CB8->CB8_NOTA .And. SD2->D2_SERIE == CB8->CB8_SERIE .And. SD2->D2_FILIAL == xFilial("SD2")
						RecLock("SD2",.F.)
						SD2->D2_ORDSEP := ""
						SD2->(MsUnlock())

						SD2->(dbSkip())
					End

				EndIf

				//LIMPA OS ITENS DA ONDA
				dbSelectArea("CB8")
				dbSetOrder(1)
				dbSeek(xFilial()+cOrdSep)

				While !Eof() .And. CB8->CB8_ORDSEP == cOrdSep 
					RecLock("CB8",.F.)
					dbDelete()
					CB8->(MSUnlock())
					dbSkip()
				End

				//LIMPA OS CABECALHOS DA ONDA
				dbSelectArea("CB7")
				RecLock("CB7",.F.)
				dbDelete()
				CB7->(MSUnlock())

			End Transaction

			MsgInfo("Ordem Separa��o exclu��da com sucesso!","ACDAT005")

		EndIf
	EndIf
Return


/*
ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÝÝÝÝÝÝÝÝÝÝÑÝÝÝÝÝÝÝÝÝÝËÝÝÝÝÝÝÝÑÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝËÝÝÝÝÝÝÑÝÝÝÝÝÝÝÝÝÝÝÝÝ»±±
±±ºPrograma  ³TMKRD017  ºAutor  ³Microsiga           º Data ³  03/25/11   º±±
±±ÌÝÝÝÝÝÝÝÝÝÝØÝÝÝÝÝÝÝÝÝÝÊÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÊÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÝÝÝÝÝÝÝÝÝÝØÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function BuscCliPed(cPedSC5,cNFiscal,cPedCli)
	Local oDlgBped
	//Local o3ListBox 
	//Local cNomFil := ""

	If !Empty(cPedSC5) .And. !Empty(cPedCli) .And. !Empty(cNfiscal)
		MsgStop("N�o � permitido informar um Pedido Taiff e/ou Uma Nota e/ou um Pedido do Portal!","ACDAT005")
		Return
	EndIf

	If Empty(cPedSC5) .And. Empty(cPedCli) .And. Empty(cNFiscal)
		MsgStop("Informe um Pedido Taiff ou uma Nota ou um Pedido do Portal!","ACDAT005")
		Return
	EndIf
	//PEGA O NUMERO DO PEDIDO CONFORME O NUMERO DO PORTAL
	If !Empty(cPedCli)
		dbSelectArea("SC5")
		dbSetOrder(8)
		dbSeek(cPedCli)	
		cPedSC5 := SC5->C5_FILIAL+SC5->C5_NUM
	EndIf

	If !Empty(cNFiscal)
		dbSelectArea("SD2")
		dbSetOrder(3)
		If !dbSeek(cNFiscal)
				MsgStop("A Nota Fiscal informada N�o foi encontrada!","ACDAT005")
			Return
		EndIf
		cPedSC5 := SD2->D2_FILIAL+SD2->D2_PEDIDO

	EndIf

	//DADOS DO PEDIDO
	cQuery := " SELECT C5_FILIAL,C5_NUM, C5_TRANSP, C5_CLIENT, C5_LOJACLI, C5_DTIMP,C5_HRIMP, C5_VEND1, ISNULL(D2_DOC,'') D2_DOC, ISNULL(D2_SERIE,'') D2_SERIE, ISNULL(CB7_ORDSEP,'') CB7_ORDSEP, C5_NUMOLD, C5_MENNOTA  FROM "+RetSqlName("SC5")+" C5 WITH(NOLOCK)"
	cQuery += " LEFT JOIN "+RetSqlName("SD2")+" D2 WITH(NOLOCK) ON D2_FILIAL = C5_FILIAL AND D2_PEDIDO = C5_NUM AND D2.D_E_L_E_T_ <> '*'
	cQuery += " LEFT JOIN "+RetSqlName("CB7")+" CB7 WITH(NOLOCK) ON CB7.D_E_L_E_T_ <> '*'
		If !Empty(cNFiscal)
			cQuery += " AND CB7_FILIAL+CB7_NOTA+CB7_SERIE = '"+cNFiscal+"' 	
		Else
			cQuery += "AND ((CB7_FILIAL = C5_FILIAL AND CB7_PEDIDO = C5_NUM) OR (CB7_FILIAL = D2_FILIAL AND CB7_NOTA = D2_DOC AND CB7_SERIE = D2_SERIE   ))
		EndIf
	cQuery += " WHERE C5.D_E_L_E_T_ <> '*' "
	cQuery += " AND C5_NUM = '"+SubStr(cPedSC5,3,6)+"' AND C5_FILIAL = '"+SubStr(cPedSC5,1,2)+"'"
	If !Empty(cNFiscal)
		cQuery += " AND  D2_FILIAL+D2_DOC+D2_SERIE = '"+cNFiscal+"'
	EndIf
	cQuery += " GROUP BY C5_FILIAL,C5_NUM, C5_TRANSP, C5_CLIENT, C5_LOJACLI, C5_DTIMP,C5_HRIMP, C5_VEND1, D2_DOC, D2_SERIE,CB7_ORDSEP, C5_NUMOLD, C5_MENNOTA"
	
	MemoWrite("BUSCLIPED.SQL",cQuery)

	dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'TRBRD17', .F., .T.)

	TcSetField("TRBRD17","C5_DTIMP","D")

	Count To nRec1


	If nRec1 == 0
		MsgStop("Pedido N�o encontrado!","ACDAT005")
		TRBRD17->(dbCloseArea())
		Return
	Else

		dbSelectArea("TRBRD17")
		dbGotop()	
		If nRec1 > 1

			aRepete := {}
			While !Eof()
				//AREPETE {01- PEDIDO, 02-NOME, 03- NOTA, 04-FILIAL, 05 -ORDEM SEPARACAO}
				cNomCli := Posicione("SA1",1,xFilial("SA1")+TRBRD17->C5_CLIENT+TRBRD17->C5_LOJACLI,"A1_NOME")
				aAdd(aRepete,{ TRBRD17->C5_NUM, cNomCli, TRBRD17->D2_DOC,TRBRD17->C5_FILIAL,TRBRD17->CB7_ORDSEP })
				dbSelectArea("TRBRD17")
				dbSkip()
			End

			cPedOS := ""
			@050,005 TO 250,450  DIALOG oDlg2Ped TITLE "Visualiza Pedidos"

			//MONTA TELA PEDIDOS EM ABERTO
			cBFields := " "
			nBCampo 	:= 0

			//AREPETE {01- PEDIDO, 02-NOME, 03- NOTA}
			aBTitCampos := {OemToAnsi("Pedido"),OemToAnsi("Cod.Cliente"),OemToAnsi("Nota")}

			cBLine := "{aRepete[oBListBox:nAT][1],aRepete[oBListBox:nAT][2],aRepete[oBListBox:nAT][3],}"


			bBLine := &( "{ || " + cBLine + " }" )

			oBListBox := TWBrowse():New( 10,4,200,50,,aBTitCampos,,oDlg2Ped,,,,,,,,,,,,.F.,,.T.,,.F.,,,)
			oBListBox:SetArray(aRepete)
			oBListBox:bLine := bBLine

			@ 070,170 BUTTON "Ok" 			SIZE 40,10 ACTION (cPedOS := aRepete[oBListBox:nAt,4]+aRepete[oBListBox:nAt,1]+aRepete[oBListBox:nAt,5] , oDlg2Ped:End()) PIXEL OF oDlg2Ped
			ACTIVATE DIALOG oDlg2Ped CENTERED

			If Empty(cPedOS)
				TRBRD17->(dbCloseArea())
				Return
			EndIf
			cPedSC5 := ""
		EndIf

		dbSelectArea("TRBRD17")
		dbGotop()

		While !Eof()
			If TRBRD17->C5_FILIAL+TRBRD17->C5_NUM == cPedSC5 .Or. cPedOS == TRBRD17->C5_FILIAL+TRBRD17->C5_NUM+TRBRD17->CB7_ORDSEP 
				cNomCli := Posicione("SA1",1,xFilial("SA1")+TRBRD17->C5_CLIENT+TRBRD17->C5_LOJACLI,"A1_NOME")
				cTFilial := TRBRD17->C5_FILIAL

				dbSelectArea("CB7")
				dbSetOrder(1)
				dbSeek(cTFilial+TRBRD17->CB7_ORDSEP)	


				//DADOS DO PEDIDO
				cTpedido 	:= TRBRD17->C5_NUM
				cTpedFat 	:= '' //TRBRD17->C5__PEDPAI
				cTCliente	:= TRBRD17->C5_CLIENT+"-"+cNomCli
				cTNota		:= TRBRD17->D2_DOC
				cTNotaFat	:= '' //Posicione("SC5",1,xFilial("SC5")+TRBRD17->C5__PEDPAI,"C5_NOTA")
				cTSerie		:= TRBRD17->D2_SERIE
				cTVend		:= TRBRD17->C5_VEND1+"-"+Posicione("SA3",1,xFilial("SA3")+TRBRD17->C5_VEND1,"A3_NOME")
				cTReqCli	:= TRBRD17->C5_NUMOLD
				cTMensNota  := TRBRD17->C5_MENNOTA
				cTOrdSep	:= TRBRD17->CB7_ORDSEP
				
				//HORA IMPORTACAO
				cTUlib1		:=	'' //TRBRD17->C5_ULIB1
				cTDlib1		:=	TRBRD17->C5_DTIMP
				cTHlib1		:=	SubStr(TRBRD17->C5_HRIMP,1,2)+":"+SubStr(TRBRD17->C5_HRIMP,3,2)
				cTPLib1		:=	'' //TRBRD17->C5_PLIB1

				// Liberacao de Preco
				cTUlib2		:= '' //TRBRD17->C5_ULIB2
				cTDlib2		:= '' //TRBRD17->C5_DLIB2
				cTHlib2		:= '' //TRBRD17->C5_HLIB2
				cTPlib2		:= '' //TRBRD17->C5_PLIB2

				// Liberacao de Credito
				cTUlib3		:= '' //TRBRD17->C5_ULIB3
				cTDlib3		:= '' //TRBRD17->C5_DLIB3
				cTHlib3		:= '' //TRBRD17->C5_HLIB3
				cTPlib3		:= '' //TRBRD17->C5_PLIB3

				//IMPRESSAO
				cTUlib4		:= '' //TRBRD17->C5_ULIB4
				cTDlib4		:= '' //TRBRD17->C5_DLIB4
				cTHlib4		:= '' //TRBRD17->C5_HLIB4
				cTPlib4		:= '' //TRBRD17->C5_PLIB4

				// Liberacao de Estoque
				cTUlib5		:= '' //TRBRD17->C5_ULIB5
				cTDlib5		:= '' //TRBRD17->C5_DLIB5
				cTHlib5		:= '' //TRBRD17->C5_HLIB5
				cTPlib5		:= '' //TRBRD17->C5_PLIB5

				// GEROU NOTA
				cTUlib6		:= '' //TRBRD17->C5_ULIB6
				cTDlib6		:= '' //TRBRD17->C5_DLIB6
				cTHlib6		:= '' //TRBRD17->C5_HLIB6
				cTPlib6		:= '' //TRBRD17->C5_PLIB6

				// CONFERENCIA
				cTUlib7		:= '' //Posicione("CB1",1,TRBRD17->CB7_FILIAL+TRBRD17->CB7_CODOPE,"CB1_NOME")
				cTDlib7		:= '' //TRBRD17->CB7_DTINIS
				cTDFlib7	:= '' //TRBRD17->CB7_DTFIMS
				cTHlib7		:= '' //TRBRD17->CB7_HRFIMS
				cTHIlib7	:= '' //TRBRD17->CB7_HRINIS



				// Bloqueio de TES
				cTUlib8		:= '' //TRBRD17->C5_ULIB8
				cTDlib8		:= '' //TRBRD17->C5_DLIB8
				cTHlib8		:= '' //TRBRD17->C5_HLIB8
				cTPlib8		:= '' //TRBRD17->C5_PLIB8

				// SEPAROU
				cTUlib9		:= Posicione("CB1",1,CB7->CB7_FILIAL+CB7->CB7_CODOPE,"CB1_NOME")
				cTDlib9		:= CB7->CB7_DTINIS
				cTDFlib9	:= CB7->CB7_DTFIMS
				cTHIlib9	:= SubStr(CB7->CB7_HRINIS,1,2)+":"+SubStr(CB7->CB7_HRINIS,3,2)
				cTHlib9		:= SubStr(CB7->CB7_HRFIMS,1,2)+":"+SubStr(CB7->CB7_HRFIMS,3,2)
				cTPlib9		:= ''//TRBRD17->C5_PLIB9

				// CONSUMO
				cTUlib10	:= '' //TRBRD17->C5_ULIB10
				cTDlib10	:= '' //TRBRD17->C5_DLIB10
				cTHlib10	:= '' //TRBRD17->C5_HLIB10
				cTPlib10	:= '' //TRBRD17->C5_PLIB10

				// FRETE
				cTUlib11	:= '' //TRBRD17->C5_ULIB11
				cTDlib11	:= '' //TRBRD17->C5_DLIB11
				cTHlib11	:= '' //TRBRD17->C5_HLIB11
				cTPlib11	:= '' //TRBRD17->C5_PLIB11

			EndIf
			dbSelectArea("TRBRD17")
			dbSkip()
		End
	EndIf
	TRBRD17->(dbCloseArea())

	/*
	//SELECIONA OS DADOS DOS ROTEIROS
	cQuery := " SELECT ZD_FILIAL, ZD_TIPO , ZE_COD , ZE_MOTORIS , ZD_NOTA , ZD_SERIE , ZE_DTROTE , ZE__BXROT , ZD_MOTIVO ,"
	cQuery += " (SELECT F2_TRANSP FROM "+RetSqlName("SF2")+" WHERE F2_FILIAL = ZD_FILNF AND F2_DOC = ZD_NOTA AND F2_SERIE = ZD_SERIE AND D_E_L_E_T_ <> '*') F2_TRANSP ,"
	cQuery += " (SELECT F2__BXROT FROM "+RetSqlName("SF2")+" WHERE F2_FILIAL = ZD_FILNF AND F2_DOC = ZD_NOTA AND F2_SERIE = ZD_SERIE AND D_E_L_E_T_ <> '*') F2__BXROT "
	cQuery += " FROM "+RetSqlName("SZD")+" ZD WITH(NOLOCK)"
	cQuery += " INNER JOIN "+RetSqlName("SZE")+" ZE WITH(NOLOCK) ON ZD_FILIAL = ZE_FILIAL AND ZD_COD = ZE_COD"
	cQuery += " WHERE ZD_NOTA = '"+cTNota+"' AND ZD_SERIE = '"+cTSerie+"'
	cQuery += " AND ZD.D_E_L_E_T_ <> '*' AND ZE.D_E_L_E_T_ <> '*' AND ZD_NOTA <> ''"
	cQuery += " AND ZD_FILNF = '"+cTFilial+"'"

	MemoWrite("TMKRD017J.SQL",cQuery)

	dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'TRBRD17', .F., .T.)
	TcSetField("TRBRD17","ZE_DTROTE","D")
	TcSetField("TRBRD17","F2__BXROT","D")

	Count To nRec1

	aRotPed := {}
	If nRec1 == 0
	//01-SEMAFORO, 02- ROTEIRO, 03- MOTORISTA, 04- NOTA, 05-SERIE,06-ROTEIRIZADO, 07- ENTREGA, 08- OCORRENCIA
	aAdd(aRotPed,{'','','','','','','',''})
	Else

	dbSelectArea("TRBRD17")
	dbGotop()
	While !Eof()  

	//INCLUSAO PARA ATENDER AO CHAMADO 36216 --CARLOS.SILVA 13/05/2015
	If TRBRD17->ZD_FILIAL == "02"    

	cNomFil :="ITU"

	ElseIf TRBRD17->ZD_FILIAL == "05"

	cNomFil :="BRASILIA"

	EndIf

	cMotoris := Iif(TRBRD17->ZD_FILIAL == "01" .Or. (TRBRD17->ZD_FILIAL == "02" .And. !(TRBRD17->F2_TRANSP $ "000543|000544|000547" .And. Empty(TRBRD17->F2__BXROT))) ,Iif(TRBRD17->ZD_TIPO == "1",AllTrim(TRBRD17->ZE_MOTORIS)+" - SENDO ENTREGUE",TRBRD17->ZE_MOTORIS),Iif(TRBRD17->ZD_TIPO == "1" ,""+cNomFil+"-CROSS DOCKING SENDO ENTREGUE",""+cNomFil+"-CROSS DOCKING "+TRBRD17->ZE_MOTORIS))

	aAdd(aRotPed,{Iif(TRBRD17->ZD_TIPO=="2",LoadBitMap(GetResources(),"BR_VERDE"),LoadBitMap(GetResources(),"BR_VERMELHO")),TRBRD17->ZE_COD,cMotoris,TRBRD17->ZD_NOTA,TRBRD17->ZD_SERIE,TRBRD17->ZE_DTROTE,TRBRD17->F2__BXROT,TRBRD17->ZD_MOTIVO})
	dbSkip()
	End
	EndIf
	TRBRD17->(dbCloseArea())
	*/

	//TELA
	@001,001 TO 580,1250  DIALOG oDlgBped TITLE "Controle Pedidos"
	@ 2,2 TO 080,550 LABEL "Dados Pedido" OF oDlgBped  PIXEL

	//busca de pedidos
	nLin 	:= 10
	nDist1 	:= 10
	nDist2	:= 40
	nDist3 	:= 120
	nDist4	:= 160
	nDist5 	:= 340
	nDist6	:= 380

	//PEDIDO
	@ nLin,nDist1 Say OemToAnsi("Pedido") Size 99,6 Of oDlgBped Pixel
	@ nLin,nDist2 MSGet cTPedido Picture "@!" When .F. Size 59,8 Of oDlgBped Pixel
	//CLIENTE
	@ nLin,nDist3 Say OemToAnsi("Cliente") Size 99,6 Of oDlgBped Pixel
	@ nLin,nDist4 MSGet cTCliente Picture "@!" When .F. Size 159,8 Of oDlgBped Pixel
	//VENDEDOR
	@ nLin,nDist5 Say OemToAnsi("Vendedor") Size 99,6 Of oDlgBped Pixel
	@ nLin,nDist6 MSGet cTVend Picture "@!" When .F. Size 159,8 Of oDlgBped Pixel
	nLin += 14

	//NOTA
	@ nLin,nDist1 Say OemToAnsi("Nota") Size 99,6 Of oDlgBped Pixel
	@ nLin,nDist2 MSGet cTNota Picture "@!" When .F. Size 59,8 Of oDlgBped Pixel
	//PEDFATURA
	@ nLin,nDist3 Say OemToAnsi("Ped.Fatura") Size 99,6 Of oDlgBped Pixel
	@ nLin,nDist4 MSGet cTPedFat Picture "@!" When .F. Size 59,8 Of oDlgBped Pixel
	//NFFATURA
	@ nLin,nDist5 Say OemToAnsi("Nota Fat.") Size 99,6 Of oDlgBped Pixel
	@ nLin,nDist6 MSGet cTNotaFat Picture "@!" When .F. Size 59,8 Of oDlgBped Pixel
	nLin += 14

	//ORDEM SEPARACAO 
	@ nLin,nDist1 Say OemToAnsi("Ordem Sep.") Size 99,6 Of oDlgBped Pixel
	@ nLin,nDist2 MSGet cTOrdSep Picture "@!" When .F. Size 59,8 Of oDlgBped Pixel
	//PEDIDO CLIENTE
	@ nLin,nDist3 Say OemToAnsi("Ped.Portal") Size 99,6 Of oDlgBped Pixel
	@ nLin,nDist4 MSGet cTReqCli Picture "@!" When .F. Size 80,8 Of oDlgBped Pixel
	//REQUISITANTE
	//@ nLin,nDist5 Say OemToAnsi("Requisitante") Size 99,6 Of oDlgBped Pixel
	//@ nLin,nDist6 MSGet cTRequis Picture "@!" When .F. Size 159,8 Of oDlgBped Pixel
	nLin += 14

	/*
	//CONTRATO
	@ nLin,nDist1 Say OemToAnsi("Contrato") Size 99,6 Of oDlgBped Pixel
	@ nLin,nDist2 MSGet cTCtr Picture "@!" When .F. Size 59,8 Of oDlgBped Pixel
	//Entrega
	@ nLin,nDist3 Say OemToAnsi("Dt.Entrega") Size 99,6 Of oDlgBped Pixel
	@ nLin,nDist4 MSGet cTEntrega Picture "@!" When .F. Size 59,8 Of oDlgBped Pixel
	//BLOQUEIOS
	@ nLin,nDist5 Say OemToAnsi("Bloqueios") Size 99,6 COLOR CLR_RED Of oDlgBped Pixel
	@ nLin,nDist6 MSGet cBloqueios Picture "@!" When .F. Size 59,8  COLOR CLR_RED Of oDlgBped Pixel
	nLin += 14
	*/
	//MENSAGEM NOTA
	@ nLin,nDist1 Say OemToAnsi("Mens.Nota") Size 99,6 Of oDlgBped Pixel
	@ nLin,nDist2 MSGet cTMensNota Picture "@!" When .F. Size 250,8 Of oDlgBped Pixel
	//ORSEM SEPARACAO
	//@ nLin,nDist5 Say OemToAnsi("Data Lib.Total") Size 99,6  Of oDlgBped Pixel
	//@ nLin,nDist6 MSGet dLibTot Picture "@!" When .F. Size 59,8  Of oDlgBped Pixel

	nLin += 14


	@ 085,2 TO 230,400 LABEL "Libera��es/Bloqueios" OF oDlgBped  PIXEL
	nLin := 090
	nDist 	:= 10
	nDist1 	:= 40
	nDist2 	:= 100
	nDist3 	:= 160
	nDist4 	:= 220
	nDist5 	:= 280
	nDist6 	:= 340



	//GEROU PEDIDO
	@ nLin,nDist1 Say OemToAnsi("Gerou") 	Size 99,6 Of oDlgBped Pixel
	@ nLin,nDist2 Say OemToAnsi("Data Inicial") 	Size 99,6 Of oDlgBped Pixel
	@ nLin,nDist3 Say OemToAnsi("Hora Inicial") 	Size 99,6 Of oDlgBped Pixel
	@ nLin,nDist4 Say OemToAnsi("Data Final") 	Size 99,6 Of oDlgBped Pixel
	@ nLin,nDist5 Say OemToAnsi("Hora Final") 	Size 99,6 Of oDlgBped Pixel
	@ nLin,nDist6 Say OemToAnsi("Rotina") 	Size 99,6 Of oDlgBped Pixel

	nLin += 08
	@ nLin,nDist Say OemToAnsi("Importacao") Size 99,6 Of oDlgBped Pixel
	@ nLin,nDist1 MSGet cTUlib1 Picture "@!" When .F. Size 59,3 Of oDlgBped Pixel
	//DATA
	@ nLin,nDist2 MSGet cTDlib1  When .F. Size 59,6 Of oDlgBped Pixel
	//HORA
	@ nLin,nDist3 MSGet cTHlib1 Picture "99:99" When .F. Size 59,6 Of oDlgBped Pixel
	//ROTINA
	@ nLin,nDist6 MSGet cTPlib1 Picture "@!" When .F. Size 59,6 Of oDlgBped Pixel
	nLin += 11

	//PRECO
	@ nLin,nDist Say OemToAnsi("Preco") Size 99,6 Of oDlgBped Pixel
	@ nLin,nDist1 MSGet cTUlib2 Picture "@!" When .F. Size 59,8 Of oDlgBped Pixel
	//DATA
	@ nLin,nDist2 MSGet cTDlib2 When .F. Size 59,8 Of oDlgBped Pixel
	//HORA
	@ nLin,nDist3 MSGet cTHlib2 Picture "99:99" When .F. Size 59,8 Of oDlgBped Pixel
	//ROTINA
	@ nLin,nDist6 MSGet cTPlib2 Picture "@!" When .F. Size 59,8 Of oDlgBped Pixel
	nLin += 11

	//CREDITO
	@ nLin,nDist Say OemToAnsi("Credito") Size 99,6 Of oDlgBped Pixel
	@ nLin,nDist1 MSGet cTUlib3 Picture "@!" When .F. Size 59,8 Of oDlgBped Pixel
	//DATA
	@ nLin,nDist2 MSGet cTDlib3  When .F. Size 59,8 Of oDlgBped Pixel
	//HORA
	@ nLin,nDist3 MSGet cTHlib3 Picture "99:99" When .F. Size 59,8 Of oDlgBped Pixel
	//ROTINA
	@ nLin,nDist6 MSGet cTPlib3 Picture "@!" When .F. Size 59,8 Of oDlgBped Pixel
	nLin += 11

	//ESTOQUE
	@ nLin,nDist Say OemToAnsi("Estoque") Size 99,6 Of oDlgBped Pixel
	@ nLin,nDist1 MSGet cTUlib5 Picture "@!" When .F. Size 59,8 Of oDlgBped Pixel
	//DATA
	@ nLin,nDist2 MSGet cTDlib5  When .F. Size 59,8 Of oDlgBped Pixel
	//HORA
	@ nLin,nDist3 MSGet cTHlib5 Picture "99:99" When .F. Size 59,8 Of oDlgBped Pixel
	//ROTINA
	@ nLin,nDist6 MSGet cTPlib5 Picture "@!" When .F. Size 59,8 Of oDlgBped Pixel
	nLin += 11

	//TES
	@ nLin,nDist Say OemToAnsi("TES") Size 99,6 Of oDlgBped Pixel
	@ nLin,nDist1 MSGet cTUlib8 Picture "@!" When .F. Size 59,8 Of oDlgBped Pixel
	//DATA
	@ nLin,nDist2 MSGet cTDlib8  When .F. Size 59,8 Of oDlgBped Pixel
	//HORA
	@ nLin,nDist3 MSGet cTHlib8 Picture "99:99" When .F. Size 59,8 Of oDlgBped Pixel
	//ROTINA
	@ nLin,nDist6 MSGet cTPlib8 Picture "@!" When .F. Size 59,8 Of oDlgBped Pixel
	nLin += 11


	//CONSUMO
	@ nLin,nDist Say OemToAnsi("Consumo") Size 99,6 Of oDlgBped Pixel
	@ nLin,nDist1 MSGet cTUlib10 Picture "@!" When .F. Size 59,8 Of oDlgBped Pixel
	//DATA
	@ nLin,nDist2 MSGet cTDlib10  When .F. Size 59,8 Of oDlgBped Pixel
	//HORA
	@ nLin,nDist3 MSGet cTHlib10 Picture "99:99" When .F. Size 59,8 Of oDlgBped Pixel
	//ROTINA
	@ nLin,nDist6 MSGet cTPlib10 Picture "@!" When .F. Size 59,8 Of oDlgBped Pixel
	nLin += 11

	//FRETE
	@ nLin,nDist Say OemToAnsi("Frete") Size 99,6 Of oDlgBped Pixel
	@ nLin,nDist1 MSGet cTUlib11 Picture "@!" When .F. Size 59,8 Of oDlgBped Pixel
	//DATA
	@ nLin,nDist2 MSGet cTDlib11  When .F. Size 59,8 Of oDlgBped Pixel
	//HORA
	@ nLin,nDist3 MSGet cTHlib11 Picture "99:99" When .F. Size 59,8 Of oDlgBped Pixel
	//ROTINA
	@ nLin,nDist6 MSGet cTPlib11 Picture "@!" When .F. Size 59,8 Of oDlgBped Pixel
	nLin += 11

	//IMPRESSAO
	@ nLin,nDist Say OemToAnsi("Impress�o") Size 99,6 Of oDlgBped Pixel
	@ nLin,nDist1 MSGet cTUlib4 Picture "@!" When .F. Size 59,8 Of oDlgBped Pixel
	//DATA
	@ nLin,nDist2 MSGet cTDlib4  When .F. Size 59,8 Of oDlgBped Pixel
	//HORA
	@ nLin,nDist3 MSGet cTHlib4 Picture "99:99" When .F. Size 59,8 Of oDlgBped Pixel
	//ROTINA
	@ nLin,nDist6 MSGet cTPlib4 Picture "@!" When .F. Size 59,8 Of oDlgBped Pixel
	nLin += 11

	//SEPARACAO
	@ nLin,nDist Say OemToAnsi("Separa��o") Size 99,6 Of oDlgBped Pixel
	@ nLin,nDist1 MSGet cTUlib9 Picture "@!" When .F. Size 59,8 Of oDlgBped Pixel
	//DATA INICIAL
	@ nLin,nDist2 MSGet cTDlib9  When .F. Size 59,8 Of oDlgBped Pixel
	//HORA INICIAL
	@ nLin,nDist3 MSGet cTHIlib9 Picture "99:99" When .F. Size 59,8 Of oDlgBped Pixel
	//DATA FINAL
	@ nLin,nDist4 MSGet cTDFlib9  When .F. Size 59,8 Of oDlgBped Pixel
	//HORA FINAL
	@ nLin,nDist5 MSGet cTHlib9 Picture "99:99" When .F. Size 59,8 Of oDlgBped Pixel
	//ROTINA
	@ nLin,nDist6 MSGet cTPlib9 Picture "@!" When .F. Size 59,8 Of oDlgBped Pixel
	nLin += 11

	//CONFERENCIA
	@ nLin,nDist Say OemToAnsi("Conferência") Size 99,6 Of oDlgBped Pixel
	@ nLin,nDist1 MSGet cTUlib7 Picture "@!" When .F. Size 59,8 Of oDlgBped Pixel
	//DATA INICIAL
	@ nLin,nDist2 MSGet cTDlib7 Picture "@!" When .F. Size 59,8 Of oDlgBped Pixel
	//HORA INICIAL
	@ nLin,nDist3 MSGet cTHIlib7 Picture "99:99" When .F. Size 59,8 Of oDlgBped Pixel
	//DATA FINAL
	@ nLin,nDist4 MSGet cTDFlib7  When .F. Size 59,8 Of oDlgBped Pixel
	//HORA FINAL
	@ nLin,nDist5 MSGet cTHlib7 Picture "99:99" When .F. Size 59,8 Of oDlgBped Pixel
	/*
	//ROTINA
	@ nLin,nDist6 MSGet cTPlib7 Picture "@!" When .F. Size 59,8 Of oDlgBped Pixel
	*/
	nLin += 11


	//NOTA
	@ nLin,nDist Say OemToAnsi("Nota") Size 99,6 Of oDlgBped Pixel
	@ nLin,nDist1 MSGet cTUlib6 Picture "@!" When .F. Size 59,8 Of oDlgBped Pixel
	//DATA
	@ nLin,nDist2 MSGet cTDlib6  When .F. Size 59,8 Of oDlgBped Pixel
	//HORA
	@ nLin,nDist3 MSGet cTHlib6 Picture "99:99" When .F. Size 59,8 Of oDlgBped Pixel
	//ROTINA
	/*
	@ nLin,nDist6 MSGet cTPlib6 Picture "@!" When .F. Size 59,8 Of oDlgBped Pixel
	*/
	nLin += 11



	/*

	//MONTA A TELA DOS ROTEIROS
	c3Fields := " "
	n3Campo	:= 0

	//01-SEMAFORO, 02- ROTEIRO, 03- MOTORISTA, 04- NOTA, 05-SERIE,06-ROTEIRIZADO, 07- ENTREGA, 08- OCORRENCIA
	a3TitCampos := {'',OemToAnsi("Roteiro"),OemToAnsi("Motorista"),OemToAnsi("Nota"),OemToAnsi("Serie"),OemToAnsi("Roteirizado"),OemToAnsi("Entrega"),OemToAnsi("Ocorrencia")}

	c3Line := "{aRotPed[o3ListBox:nAT][1],aRotPed[o3ListBox:nAT][2],aRotPed[o3ListBox:nAT][3],aRotPed[o3ListBox:nAT][4],aRotPed[o3ListBox:nAT][5],aRotPed[o3ListBox:nAT][6],aRotPed[o3ListBox:nAT][7],aRotPed[o3ListBox:nAT][8],}"

	b3Line := &( "{ || " + c3Line + " }" )

	//@ 5,2 TO 70,135 LABEL "Roteiro" OF oDlgNotas  PIXEL
	o3ListBox := TWBrowse():New( 230,4,400,40,,a3TitCampos,,oDlgBped,,,,,,,,,,,,.F.,,.T.,,.F.,,,)
	o3ListBox:SetArray(aRotPed)
	o3ListBox:bLine := b3Line
	*/
	//@ 030,560 BUTTON "Aviso Falta" 		SIZE 40,10 ACTION (AvisoFalta(cTPedido,cTFilial)) PIXEL OF oDlgBped
	//@ 050,560 BUTTON "Vis.Pedido"  		SIZE 40,10 ACTION (U_VerPedido(cTPedido,cTFilial)) PIXEL OF oDlgBped
	//@ 070,560 BUTTON "Pendencia"  		SIZE 40,10 ACTION (VerPend(cTPedido,cTFilial,cTBloqE)) PIXEL OF oDlgBped
	//@ 090,560 BUTTON "Vis.Confer." 		SIZE 40,10 ACTION (U_TKRD17ACDA100Vs(cTPedido,cTFilial)) PIXEL OF oDlgBped

	@ 185,560 BUTTON "Sair" 			SIZE 40,10 ACTION oDlgBped:End() PIXEL OF oDlgBped

	ACTIVATE DIALOG oDlgBped CENTERED

Return

/*
ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÝÝÝÝÝÝÝÝÝÝÑÝÝÝÝÝÝÝÝÝÝËÝÝÝÝÝÝÝÑÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝËÝÝÝÝÝÝÑÝÝÝÝÝÝÝÝÝÝÝÝÝ»±±
±±ºPrograma  ³VEROS     ºAutor  ³Microsiga           º Data ³  03/25/11   º±±
±±ÌÝÝÝÝÝÝÝÝÝÝØÝÝÝÝÝÝÝÝÝÝÊÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÊÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝ¹±±
±±ºDesc.     ³ VISUALIZA A ORDEM DE SEPARACAO                             º±±
±±º          ³                                                            º±±
±±ÌÝÝÝÝÝÝÝÝÝÝØÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function VEROS(cOrdSep,cFilAnt)

	PRIVATE aRotina := {	{"Pesquisar"			,"AxPesqui",   0,1},;   //
	{"Visualizar"		,"ACDA100Vs",0,2},;   //
	{"Alterar"		,"ACDA100Al",0,3},;   //
	{"Estornar"		,"ACDA100Et",0,5,5},; //
	{"Gerar"		,"ACDA100Gr",0,3},;   //
	{"Impressao"		,"ACDA100Re",0,4},;   //
	{"Legenda"		,"ACDA100Lg",0,3}}    //


	dbSelectArea("CB7")
	dbSetOrder(1)
	dbSeek(xFilial()+cOrdSep)
	nRec := Recno()

	ACDA100Vs("CB7",nRec,2)

Return

/*
Fun��o que prepara o estorno da OS pelo coletor quando a OS gerada por Nfe
*/
User Function TFPREPESTORNO()
Local cOrdSep := SPACE(06)
Local cNumOF := ""
Local cMsg := ""
Local cXFil := ""
Local cQry := ""
Local cNTransp := ""
Local cSC9Tbl := RetSqlName("SC9")
Local cSC9Fil := xFilial("SC9")
Local cCB7Tbl := RetSqlName("CB7")
Local cCB7Fil := xFilial("CB7")
Local nNx := 0
Local nOpt := 0
Local lGo := .T.
Local lDArm := .F.
Local aSC9Rcn := {}
Local aOrdSep := {}
Local oDlg := Nil

If MsgYesNo("Deseja realmente preparar o estorno da OS para o coletor?","ATEN��O","YESNO")

	@ 65,153 To 229,435 Dialog oDlg Title OemToAnsi("Ordem Separacao")
	@ 9,9 Say OemToAnsi("Ordem Sep.") Size 99,8
	@ 28,9 Get cOrdSep Picture "@!" F3 "CB7" Size 59,10
	@ 62,39 BMPBUTTON TYPE 1 ACTION Close(oDlg)
	Activate Dialog oDlg Centered

	If !Empty(cOrdSep)

		dbSelectArea("CB7")
		dbSetOrder(1)

		If !CB7->(dbSeek(xFilial("CB7") + cOrdSep))

			lGo := .F.
			MsgStop("Ordem de Separacao nao encontrada","ACDAT005")

		EndIf

		If lGo

			lGo := .F.
			cQry := "SELECT DISTINCT "
			cQry += "C9.C9_PEDIDO "
			cQry += "FROM "+cSC9Tbl+" C9 WHERE C9.D_E_L_E_T_ = ' ' "
			cQry += "AND C9.C9_FILIAL = '"+cSC9Fil+"' "
			cQry += "AND C9.C9_ORDSEP = '"+cOrdSep+"'"

			Iif(Select("AWRK")>0,AWRK->(dbCloseArea()),Nil)
			dbUseArea(.T.,"TOPCONN",TCGenQry(,,cQry),"AWRK",.T.,.T.)
			AWRK->(dbGoTop())

			If AWRK->(!EoF())
				If !Empty(AWRK->C9_PEDIDO)
					lGo := .T.
				EndIF
			EndIf
			AWRK->(dbCloseArea())

			If !lGo
				MsgStop("Esta OS j� foi estornada anteriormente","ACDAT005")
			EndIf

		EndIf

		If lGo

			cQry := "SELECT DISTINCT "
			cQry += "C9.C9_NFISCAL, "
			cQry += "C9.C9_SERIENF, "
			cQry += "C9.C9_CLIENTE "
			cQry += "FROM "+cSC9Tbl+" C9 WHERE C9.D_E_L_E_T_ = ' ' "
			cQry += "AND C9.C9_FILIAL = '"+cSC9Fil+"' "
			cQry += "AND C9.C9_ORDSEP = '"+cOrdSep+"'"

			Iif(Select("AWRK")>0,AWRK->(dbCloseArea()),Nil)
			dbUseArea(.T.,"TOPCONN",TCGenQry(,,cQry),"AWRK",.T.,.T.)
			AWRK->(dbGoTop())

			If AWRK->(!EoF())
				If !Empty(AWRK->C9_NFISCAL)					
					If U_TFVFEENF( AWRK->C9_NFISCAL, AWRK->C9_SERIENF, AWRK->C9_CLIENTE )
						lGo := .F.
						cMsg += "Esta OS n�o poder� ser estornada, "+ CRLF
						cMsg += "pois est� vinculada � NF " +Alltrim(AWRK->C9_NFISCAL)+ CRLF
						cMsg += "cuja entrada j� ocorreu na filial de destino"
					EndIf
				EndIf
			EndIf
			AWRK->(dbCloseArea())

			If !lGo
				MsgStop(cMsg,"ACDAT005")
			EndIf
			cMsg := ""

		EndIf


		If lGo

			cQry := "SELECT DISTINCT "
			cQry += "C9.C9_NUMOF, "
			cQry += "C9.C9_XFIL, "
			cQry += "C9.R_E_C_N_O_ AS SC9RCN "
			cQry += "FROM "+cSC9Tbl+" C9 WHERE C9.D_E_L_E_T_ = ' ' "
			cQry += "AND C9.C9_FILIAL = '"+cSC9Fil+"' "
			cQry += "AND C9.C9_ORDSEP = '"+cOrdSep+"'"

			Iif(Select("AWRK")>0,AWRK->(dbCloseArea()),Nil)
			dbUseArea(.T.,"TOPCONN",TCGenQry(,,cQry),"AWRK",.T.,.T.)
			TcSetField("AWRK","SC9RCN","N",14,0)
			AWRK->(dbGoTop())

			While AWRK->(!EoF())

				If Empty(cNumOF)
					If !Empty(AWRK->C9_NUMOF)
						cNumOF := AWRK->C9_NUMOF
					EndIf
				EndIf
				If Empty(cXFil)
					If !Empty(AWRK->C9_XFIL)
						cXFil := AWRK->C9_XFIL
					EndIf
				EndIf
				If AWRK->SC9RCN > 0
					aAdd( aSC9Rcn, Alltrim(Str(AWRK->SC9RCN)) )
				EndIf

				AWRK->(dbSkip())
			EndDo
			AWRK->(dbCloseArea())

			If Empty(cNumOF)

				aAdd(aOrdSep, { cOrdSep,"",""} )

			Else

				aSC9Rcn := {}

				cQry := "SELECT DISTINCT "
				cQry += "C9.C9_ORDSEP, "
				cQry += "C9.C9_PEDIDO, "
				cQry += "C9.C9_NOMORI, "
				cQry += "C9.R_E_C_N_O_ AS SC9RCN "
				cQry += "FROM "
				cQry += cSC9Tbl+ " C9 "
				cQry += "WHERE C9.D_E_L_E_T_ = ' ' "
				cQry += "AND C9.C9_FILIAL = '" +cSC9Fil+ "' "
				cQry += "AND C9.C9_XFIL = '" +cXFil+ "' "
				cQry += "AND C9.C9_NFISCAL <> '' "
				cQry += "AND C9.C9_NUMOF = '"+cNumOF+"' "
				cQry += "ORDER BY C9.R_E_C_N_O_"

				Iif(Select("BWRK")>0,BWRK->(dbCloseArea()),Nil)
				dbUseArea(.T.,"TOPCONN",TCGenQry(,,cQry),"BWRK",.T.,.T.)
				TcSetField("BWRK","SC9RCN","N",14,0)
				BWRK->(dbGoTop())

				While BWRK->(!EoF())

					aAdd( aSC9Rcn, Alltrim(Str(BWRK->SC9RCN)) )

					If aScan( aOrdSep, { |x| x[1] == BWRK->C9_ORDSEP } ) == 0
						aAdd( aOrdSep, { BWRK->C9_ORDSEP, BWRK->C9_PEDIDO, BWRK->C9_NOMORI } )
					EndIf

					BWRK->(dbSkip())
				EndDo
				BWRK->(dbCloseArea())

			EndIf

			If Len(aOrdSep) > 1

				cNTransp := RetNTransp(aOrdSep[1,2])

				cMsg := "Esta OS (" +cOrdSep+ ") est� vinculada a Ordem de Faturamento nr. " +cNumOF+"." +CRLF
				cMsg += "Por este motivo, as OS's abaixo tamb�m ser�o estornadas, pois est�o" +CRLF
				cMsg += "vinculadas � mesma Ordem de Faturamento. " +CRLF+CRLF

				If !Empty(cNTransp)
					cMsg += "Transportadora: "+cNTransp +CRLF+CRLF
				EndIf
				cMsg += "Confirma o estorno de todas as OS's ?" +CRLF+CRLF
				cMsg += "Lista de OS's da Ordem de Faturamento " +cNumOF+":" +CRLF+CRLF
				aSort(aOrdSep,,,{|x,y| x[1] < y[1]})
				For nNx := 1 to Len(aOrdSep)
					cMsg += "OS.....: " +aOrdSep[nNx,1] +CRLF
					cMsg += "Pedido.: " +aOrdSep[nNx,2] +CRLF
					cMsg += "Cliente: " +Alltrim(aOrdSep[nNx,3])
					If nNx < Len(aOrdSep)
						cMsg += CRLF+CRLF
					EndIf
				Next nNx

			Else

				cMsg := "Confirma o estorno da OS " +cOrdSep+ " ?" 

			EndIf

			nOpt := Aviso( "Aviso", cMsg, {"Ok","Sair"}, 3 )

			If nOpt == 1

				BeginTran()
				
				For nNx := 1 to Len(aOrdSep)
					If !lDArm
						cQry := "UPDATE " +cCB7Tbl+ " SET "
						cQry += "CB7_NOTA = '' "
						cQry += "WHERE D_E_L_E_T_ = ' ' "
						cQry += "AND CB7_FILIAL = '" +cCB7Fil+ "' "
						cQry += "AND CB7_ORDSEP = '" +aOrdSep[nNx,1]+"' "
						If TcSqlExec( cQry ) <> 0
							lDArm := .T.
						EndIf
					EndIf
				Next nNx

				If !lDArm
					For nNx := 1 to Len(aSC9Rcn)
						If !lDArm

							cQry := "UPDATE "+cSC9Tbl+" SET "
							cQry += "C9_XORDSEP = C9_ORDSEP, "
							cQry += "C9_ORDSEP = '' "
							cQry += "WHERE D_E_L_E_T_ = ' ' "
							cQry += "AND R_E_C_N_O_ = '" +aSC9Rcn[nNx]+"' "
							If TcSqlExec( cQry ) <> 0
								lDArm := .T.
							EndIf

						EndIf
					Next nNx
				EndIf

				If lDArm
					DisarmTransaction()
				EndIf

				EndTran()
				
				If !lDArm
					//Alert(ENTER + "OS preparada para estorno!!!" + ENTER + "D� prosseguimento com rotina de estorno da OS pelo coletor." + ENTER + "Rotina: Desfaz Separa��o" )
					MsgInfo(ENTER + "OS preparada para estorno!!!" + ENTER + "D� prosseguimento com rotina de estorno da OS pelo coletor." + ENTER + "Rotina: Desfaz Separa��o" )
				Else
					Alert(ENTER + "Erro ao estornar a OS. Tente novamente. Caso o problema persista, contacte o administrador do sistema" )
				EndIf

			EndIf

		EndIf

	EndIf

EndIf

Return NIL
		
	
/*
Fun��o que emitir relatório detalhado da separacao
*/
User Function 	TFRELSEPA()
Local dEmissao	:= CTOD("  /  /  ")
Local cQuery	:= ""
//Local nTamLin
LOCAL cLin
//LOCAL cCpo
local cDirDocs  := MsDocPath()
//Local cError        := ""
Local cPath         := "C:\EXCEL\"
Local cArquivo      := "ACDAT005_RELSEP.CSV"
//Local cPath         := "C:\EXCEL\"
Local oExcelApp
//Local nHandle
//Local cCrLf := Chr(13) + Chr(10)
//Local nX
//Local nTempo        := 0
//Local aGeral        := {}
//Local aProd         := {}
Local oDlgRel
Local cHrInicial	:= "000000"		
Local cHrFinal		:= "235959"
Local nBtnAcao		:= 0

Private nHdl    := MsfCreate(cDirDocs+"\"+cArquivo,0)
Private cEOL    := "CHR(13)+CHR(10)"

@ 65,153 To 229,435 Dialog oDlgRel Title OemToAnsi("Relatorio Detalhe da Separacao")
@ 14,9 Say OemToAnsi("Dt. Emissao") Size 99,8 Of oDlgRel Pixel
@ 10,40 Get dEmissao Size 59,10 Of oDlgRel Pixel

@ 30,9 Say OemToAnsi("Hr. Intervalo") Size 99,8 Of oDlgRel Pixel
@ 26,40 Get cHrInicial Size 30,10 Of oDlgRel Pixel  PICTURE "@R 99:99:99"
@ 30,75 Say OemToAnsi("at�") Size 99,8 Of oDlgRel Pixel
@ 26,90 Get cHrFinal Size 30,10 Of oDlgRel Pixel  PICTURE "@R 99:99:99"

@ 62,39 BMPBUTTON TYPE 1 ACTION {nBtnAcao :=1,oDlgRel:End()} //Close(oDlgRel)
@ 62,79 BMPBUTTON TYPE 2 ACTION {nBtnAcao :=2,oDlgRel:End()} //Close(oDlgRel)
Activate Dialog oDlgRel Centered

If nBtnAcao = 1

	//CRIA DIRETORIO
	MakeDir(Trim(cPath))
	
	FERASE( "C:\EXCEL\"+cArquivo )
	
	if file(cArquivo) .and. ferase(cArquivo) == -1
		msgstop("N�o foi poss�vel abrir o arquivo CSV pois ele pode estar aberto por outro usuário.")
		return(.F.)
	endif

	If Empty(cEOL)
		cEOL := CHR(13)+CHR(10)
	Else
		cEOL := Trim(cEOL)
		cEOL := &cEOL
	Endif
	
	If nHdl == -1
	       MsgAlert("O arquivo de nome " + cArqTxt + " nao pode ser executado! Verifique os parametros.","Atencao!")
	       Return
	Endif

	cQuery:= "SELECT " + ENTER
	cQuery+= "	 CB7_CODOPE		AS OPERADOR" + ENTER
	cQuery+= "	 ,CONVERT(VARCHAR(10),CONVERT(DATETIME,CB7_DTINIS),103)	AS INICIO_SEPARACAO" + ENTER
	cQuery+= "	 ,substring(CB7_HRINIS, 1, 2) + ':' + substring(CB7_HRINIS, 3, 2) + ':' + substring(CB7_HRINIS, 5, 2) AS HORA_INICIO" + ENTER
	cQuery+= "	 ,CONVERT(VARCHAR(10),CONVERT(DATETIME,CB7_DTFIMS),103)	AS FIM_SEPARACAO" + ENTER
	cQuery+= "	 ,substring(CB7_HRFIMS, 1, 2) + ':' + substring(CB7_HRFIMS, 3, 2) + ':' + substring(CB7_HRFIMS, 5, 2) AS HORA_FIM" + ENTER
	cQuery+= "	 ,CB7_ORDSEP	AS ORDEM_SEPARACAO" + ENTER
	cQuery+= "	 ,CB8_ITEM		AS ITEM_SEPARACAO" + ENTER
	cQuery+= "	 ,CB8_PROD		AS PRODUTO" + ENTER
	cQuery+= "	 ,B1_DESC		AS DESCRICAO_PRODUTO" + ENTER
	cQuery+= "	 ,CB8_QTDORI	AS QT_ORIGINAL" + ENTER
	cQuery+= "	 ,(CASE WHEN CB7_CLIORI = '' THEN SA1.A1_NOME ELSE SA1_SP.A1_NOME END) AS NOME_CLIENTE" + ENTER
	cQuery+= "	 ,(CASE WHEN CB7_DTEMBA='' THEN '' ELSE CONVERT(VARCHAR(10),CONVERT(DATETIME,CB7_DTEMBA),103) END)	AS DT_EMBARQUE" + ENTER
	cQuery+= "	 ,(CASE WHEN CB7_CLIORI = '' THEN SA1.A1_EST ELSE SA1_SP.A1_EST END) AS UF_CLIENTE" + ENTER
	cQuery+= "	 ,B5_QE1" + ENTER
	cQuery+= "	 ,B5_QE2" + ENTER
	cQuery+= "FROM " + RetSqlName("CB7") + " CB7 WITH(NOLOCK)" + ENTER
	cQuery+= "INNER JOIN " + RetSqlName("CB8") + " CB8 WITH(NOLOCK)" + ENTER
	cQuery+= "	ON CB8_FILIAL=CB7_FILIAL" + ENTER
	cQuery+= "	AND CB8_ORDSEP=CB7_ORDSEP" + ENTER
	cQuery+= "	AND CB8.D_E_L_E_T_=''" + ENTER
	cQuery+= "	AND CB8_LOCAL='21'" + ENTER
	cQuery+= "INNER JOIN " + RetSqlName("SB1") + " SB1 WITH(NOLOCK)" + ENTER
	cQuery+= "	ON B1_FILIAL=CB7_FILIAL" + ENTER
	cQuery+= "	AND B1_COD=CB8_PROD" + ENTER
	cQuery+= "	AND SB1.D_E_L_E_T_=''" + ENTER
	cQuery+= "INNER JOIN " + RetSqlName("SB5") + " SB5 WITH(NOLOCK)" + ENTER
	cQuery+= "	ON B5_FILIAL=B1_FILIAL" + ENTER
	cQuery+= "	AND B5_COD=B1_COD" + ENTER
	cQuery+= "	AND SB5.D_E_L_E_T_=''" + ENTER
	cQuery+= "LEFT OUTER JOIN " + RetSqlName("SA1") + " SA1 WITH(NOLOCK)" + ENTER
	cQuery+= "	ON A1_FILIAL=CB7_FILIAL" + ENTER
	cQuery+= "	AND A1_COD=CB7_CLIENT" + ENTER
	cQuery+= "	AND A1_LOJA=CB7_LOJA" + ENTER
	cQuery+= "	AND SA1.D_E_L_E_T_=''" + ENTER
	cQuery+= "LEFT OUTER JOIN " + RetSqlName("SA1") + " SA1_SP WITH(NOLOCK)" + ENTER
	cQuery+= "	ON SA1_SP.A1_FILIAL=CB7_FILIAL" + ENTER
	cQuery+= "	AND SA1_SP.A1_COD=CB7_CLIORI" + ENTER
	cQuery+= "	AND SA1_SP.A1_LOJA=CB7_LOJORI" + ENTER
	cQuery+= "	AND SA1_SP.D_E_L_E_T_=''" + ENTER
	cQuery+= "WHERE CB7.D_E_L_E_T_=''" + ENTER
	cQuery+= "	AND CB7_FILIAL='" + xFilial("CB7") + "'" + ENTER
	cQuery+= "	AND CB7_ORDSEP>='' AND CB7_ORDSEP<='ZZZZZZ'" + ENTER 
	cQuery+= "	AND CB7_DTINIS= '" + DTOS(dEmissao) + "'" + ENTER
	cQuery+= "	AND (CB7_HRINIS >= '" + cHrInicial +  "' AND CB7_HRFIMS <= '" + cHrFinal +"') " + ENTER 
	cQuery+= "	AND CB7_STATUS='9'" + ENTER
	cQuery+= "	AND CB7_LOCAL='21'" + ENTER
	cQuery+= "ORDER BY CB7_DTINIS,CB7_HRINIS" + ENTER

	MemoWrite("ACDAT005_RELATORIO_SEPARACAO.SQL",cQuery)

	dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'TRBCB7', .F., .T.)
	
	Count To nRec
	
	If nRec != 0 
       cLin := ""
       cLin += cEOL
       If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
			ConOut("Ocorreu um erro na gravacao do arquivo.")
			TRBCB7->(dbCloseArea())
			fClose(nHdl)
			Return
       Endif
       
       //CABECALHO
       cLin	:= OemToAnsi("OPERADOR")+';'
       cLin	+= OemToAnsi("INICIO_SEPARACAO")+';'
       cLin	+= OemToAnsi("HORA_INICIO")+';'
       cLin	+= OemToAnsi("FIM_SEPARACAO")+';'
       cLin	+= OemToAnsi("HORA_FIM")+';'
       cLin	+= OemToAnsi("ORDEM_SEPARACAO")+';'
       cLin	+= OemToAnsi("ITEM_SEPARACAO")+';'
       cLin	+= OemToAnsi("PRODUTO")+';'
       cLin	+= OemToAnsi("DESCRICAO_PRODUTO")   +';'    
       cLin	+= OemToAnsi("QT_ORIGINAL")+';'
       cLin	+= OemToAnsi("NOME_CLIENTE")+';'
       cLin	+= OemToAnsi("DT_EMBARQUE")+';'
       cLin	+= OemToAnsi("UF_CLIENTE")+';'
       cLin	+= OemToAnsi("QT_CLICK_CALCULADO")
       cLin	+= cEOL
       
       If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
			ConOut("Ocorreu um erro na gravacao do arquivo.")
			TRBCB7->(dbCloseArea())
			fClose(nHdl)
			Return
       Endif

		TRBCB7->(DbGotop())
		While .NOT. TRBCB7->(Eof())

			NQTCLICK := 0
			
			If INT(TRBCB7->QT_ORIGINAL / TRBCB7->B5_QE2) >= 1
				
				NQTCLICK	:= INT(TRBCB7->QT_ORIGINAL / TRBCB7->B5_QE2)

				NQTRESTO	:= TRBCB7->QT_ORIGINAL - (TRBCB7->B5_QE2 * NQTCLICK)

				If INT(NQTRESTO / TRBCB7->B5_QE1) >= 1
					NQTCLICK	+= INT(NQTRESTO / TRBCB7->B5_QE1)
	
					NSUBQTCLICK	:= INT(NQTRESTO / TRBCB7->B5_QE1)
					NQTRESTO	:= NQTRESTO - (TRBCB7->B5_QE1 * NSUBQTCLICK)
					
					If NQTRESTO > 0
						NQTCLICK	+= NQTRESTO 
					EndIf
				Else
					NQTCLICK += NQTRESTO 				
				EndIf

			ElseIf INT(TRBCB7->QT_ORIGINAL / TRBCB7->B5_QE1) >= 1
				NQTCLICK	:= INT(TRBCB7->QT_ORIGINAL / TRBCB7->B5_QE1)
				NQTRESTO	:= TRBCB7->QT_ORIGINAL  - (NQTCLICK * TRBCB7->B5_QE1)
				If NQTRESTO >  0
					NQTCLICK	+= NQTRESTO 
				EndIf
			Else
				NQTCLICK := TRBCB7->QT_ORIGINAL			
			EndIf 

			cLin	:= ''
			cLin	+= TRBCB7->OPERADOR + ';'
			cLin	+= TRBCB7->INICIO_SEPARACAO + ';'
			cLin	+= TRBCB7->HORA_INICIO + ';'
			cLin	+= TRBCB7->FIM_SEPARACAO + ';'
			cLin	+= TRBCB7->HORA_FIM + ';'
			cLin	+= TRBCB7->ORDEM_SEPARACAO + ';'
			cLin	+= TRBCB7->ITEM_SEPARACAO + ';'
			cLin	+= TRBCB7->PRODUTO + ';'
			cLin	+= TRBCB7->DESCRICAO_PRODUTO + ';'
			cLin	+= TRANSFORM(TRBCB7->QT_ORIGINAL,"@E 999999") + ';'
			cLin	+= TRBCB7->NOME_CLIENTE + ';'
			cLin	+= TRBCB7->DT_EMBARQUE + ';'
			cLin	+= TRBCB7->UF_CLIENTE + ';'
			cLin	+= TRANSFORM(NQTCLICK,"@E 999999")
      		cLin	+= cEOL

			If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
				ConOut("Ocorreu um erro na gravacao do arquivo.")
				TRBCB7->(dbCloseArea())
				fClose(nHdl)
				RETURN
			Endif
             
			TRBCB7->(DbSkip())	      
		End
		fClose(nHdl)
		TRBCB7->(dbCloseArea())
		
		CpyS2T( cDirDocs+"\"+cArquivo, cPath, .T. )
		
		If ! ApOleClient( 'MsExcel' )
	       ShellExecute("open",cPath+cArquivo,"","", 1 )
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
		TRBCB7->(dbCloseArea())
		MSGALERT("N�o h� dados para o per��odo informado " ,"Aten��o")
	EndIf

EndIf
Return NIL


/*
Fun��o que emitir relatório detalhado da onda
*/
User Function 	TFRELONDA()
Private oGeraNf
Private cPerg		:= "TFRELONDA"
Private cCadastro := "Relatorio da Transportadora"
Private oReport

AjustaSx1( "TFRELONDA" ) 

If Pergunte("TFRELONDA",.T.)
	oReport := DReportDef()
	oReport:PrintDialog()
EndIf

Return

/*
--------------------------------------------------------------------------------------------------------------
Fun��o Static de prepara��o dos objetos
--------------------------------------------------------------------------------------------------------------
*/
Static Function DReportDef()
Local oReport
Local cAliasQry := "TFRELONDA" 
Local oOSTransf_1
Local oOSTransf_2
Local oOSTransf_3 

PRIVATE CTFOPE1 := ""
PRIVATE CTFOPE2 := ""
PRIVATE CTFOPE3 := ""
PRIVATE CTFOPE4 := ""

oReport := TReport():New("TFRELONDA","Relacao de Pedidos por Transportadora","TFRELONDA", {|oReport| DReportPrint(oReport,cAliasQry)},"")	
oReport:SetPortrait() 
oReport:SetTotalInLine(.T.)

oReport:cFontBody := 'Arial Narrow' 
oReport:nFontBody := 14
oReport:SetColSpace(1,.T.) 
oReport:SetLineHeight(50) 

Pergunte(oReport:uParam,.F.)

oOSTransf_1 := TRSection():New(oReport,"Relacao de Pedidos por Transportadora",{"CB7"},/*{Array com as ordens do relatório}*/,/*Campos do SX3*/,/*Campos do SIX*/)
oOSTransf_1:SetTotalInLine(.F.)
oOSTransf_1:SetPageBreak(.T.)

TRCell():New(oOSTransf_1,"A4_NOMTRA"	,"SA4"	,"TRANSPORTADORA"	,PesqPict("SA4","A4_NOME")	,60							,/*lPixel*/,{|| (cAliasQry)->A4_NOMTRA	})	

oOSTransf_2 := TRSection():New(oReport,"CELULA",{"CB7"},/*{Array com as ordens do relatório}*/,/*Campos do SX3*/,/*Campos do SIX*/)
oOSTransf_2:SetTotalInLine(.T.)

TRCell():New(oOSTransf_2,"CB7_ORDSEP"		,"CB7"	,"Ordem Separ."	,"@!"								,06							,/*lPixel*/,{|| (cAliasQry)->CB7_ORDSEP		},"RIGHT",,"RIGHT")	
TRCell():New(oOSTransf_2,"QT_ORIGINAL"		,"CBH"	,"QT. Original"	,"@E 999"							,03							,/*lPixel*/,{|| (cAliasQry)->QT_ORIGINAL	},"RIGHT",,"RIGHT")	
TRCell():New(oOSTransf_2,"CB7_QTPALLET"		,"CBH"	,"QT. Pallet"		,"@E 999"							,03							,/*lPixel*/,{|| (cAliasQry)->CB7_QTPALLET	},"RIGHT",,"RIGHT")	
TRCell():New(oOSTransf_2,"CB7_QTCAIXA"		,"CBH"	,"QT. Caixas"		,"@E 999"							,03							,/*lPixel*/,{|| (cAliasQry)->CB7_QTCAIXA	},"RIGHT",,"RIGHT")	
TRCell():New(oOSTransf_2,"CB7_QTUNITA"		,"CBH"	,"QT. Unitar"		,"@E 999"							,03							,/*lPixel*/,{|| (cAliasQry)->CB7_QTUNITA	},"RIGHT",,"RIGHT")	
TRCell():New(oOSTransf_2,"PRODUTO"			,"CB8"	,"Produto"			,"@!"								,15							,/*lPixel*/,{|| (cAliasQry)->PRODUTO		})	
TRCell():New(oOSTransf_2,"DESCRICAO_PRO"	,"CB8"	,"Descricao produto","@!"								,40							,/*lPixel*/,{|| (cAliasQry)->DESCRICAO_PRO	})	
TRCell():New(oOSTransf_2,"CB7_PEDIDO"		,"CB7"	,"Num. Pedido "	,"@!"								,06							,/*lPixel*/,{|| (cAliasQry)->CB7_PEDIDO		},"RIGHT",,"RIGHT")	
TRCell():New(oOSTransf_2,"CB7__NOME"		,"CB7"	,"Onda"				,"@!"								,06							,/*lPixel*/,{|| (cAliasQry)->CB7__NOME		})		
TRCell():New(oOSTransf_2,"STATUS_SEP"		,"CB7"	,"Status OS"		,"@!"								,25							,/*lPixel*/,{|| (cAliasQry)->STATUS_SEP		})		
TRCell():New(oOSTransf_2,"CB7_NOMCLI"		,"CB7"	,"Nome Cliente"	,"@!"								,40							,/*lPixel*/,{|| (cAliasQry)->CB7_NOMCLI		})	

oOSTransf_3 := TRSection():New(oReport,"TOTAIS",{"CB7"},/*{Array com as ordens do relatório}*/,/*Campos do SX3*/,/*Campos do SIX*/)
TRCell():New(oOSTransf_3,"Totais"			,		,"Ordem Separ."	,									,06)
TRCell():New(oOSTransf_3,"QT_ORIGINAL"		,		,"Qtd. Original"	,"@E 999"							,03							,,,"RIGHT",,"RIGHT")	
TRCell():New(oOSTransf_3,"CB7_QTPALLET"		,		,"QT. Pallet"		,"@E 999"							,03							,,,"RIGHT",,"RIGHT")	
TRCell():New(oOSTransf_3,"CB7_QTCAIXA"		,		,"QT. Unitar"		,"@E 999"							,03							,,,"RIGHT",,"RIGHT")	
TRCell():New(oOSTransf_3,"CB7_QTUNITA"		,		,"Volume"			,"@E 999"							,03							,,,"RIGHT",,"RIGHT")	
TRCell():New(oOSTransf_3,"PRODUTO"			,		,"Produto"			,									,15)	
TRCell():New(oOSTransf_3,"DESCRICAO_PRO"	,		,"Descricao produto",									,40)	
TRCell():New(oOSTransf_3,"CB7_PEDIDO"		,		,"Num. Pedido"		,									,06)	
TRCell():New(oOSTransf_3,"CB7__NOME"		,		,"Onda"				,									,06)	
TRCell():New(oOSTransf_3,"STATUS_SEP"		,		,"Status OS"		,									,25)	
TRCell():New(oOSTransf_3,"CB7_NOMCLI"		,		,"Nome Cliente"	,									,40)	

oOSTransf_3:Cell("Totais"):HideHeader()
oOSTransf_3:Cell("QT_ORIGINAL"):HideHeader()
oOSTransf_3:Cell("CB7_QTPALLET"):HideHeader()
oOSTransf_3:Cell("CB7_QTCAIXA"):HideHeader()
oOSTransf_3:Cell("CB7_QTUNITA"):HideHeader()
oOSTransf_3:Cell("PRODUTO"):HideHeader()
oOSTransf_3:Cell("DESCRICAO_PRO"):HideHeader()
oOSTransf_3:Cell("CB7_PEDIDO"):HideHeader()
oOSTransf_3:Cell("CB7__NOME"):HideHeader()
oOSTransf_3:Cell("STATUS_SEP"):HideHeader()
oOSTransf_3:Cell("CB7_NOMCLI"):HideHeader()

Return(oReport)


/*
--------------------------------------------------------------------------------------------------------------
Fun��o Static de execu��o do Script SQL para alimentar os objetos
--------------------------------------------------------------------------------------------------------------
*/
Static Function DReportPrint(oReport,cAliasQry)


oReport:SetTitle(oReport:Title() )	
oReport:Section(1):SetHeaderPage(.T.)
oReport:Section(1):SetHeaderSection(.T.)
oReport:Section(1):SetHeaderBreak(.F.)

MakeSqlExpr(oReport:uParam)

aResult	:= {}
If TCSPExist("SP_REL_MAT_NUMERO_DA_ONDA")

	aResult := TCSPEXEC("SP_REL_MAT_NUMERO_DA_ONDA", MV_PAR01, DTOS(MV_PAR02), CEMPANT, CFILANT, DTOS(ddatabase)+SUBSTR(TIME(),1,2)+SUBSTR(TIME(),4,2) )
	
	If Select((cAliasQry)) > 0
		dbSelectArea((cAliasQry))
		(cAliasQry)->(DbCloseArea())
	EndIf
	TCQuery "SELECT * FROM " + aResult[1] NEW ALIAS "TFRELONDA"

Else
	Final("RE-INSTALAR A STORED PROCEDURE: SP_REL_MAT_NUMERO_DA_ONDA")
EndIf

oReport:Section(1):BeginQuery()	
dbSelectArea("TFRELONDA")				
oReport:Section(1):EndQuery(/*Array com os parametros do tipo Range*/)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Inicio da impressao do fluxo do relatório                               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oReport:SetMeter((cAliasQry)->(LastRec()))
dbSelectArea(cAliasQry)
                          
While !oReport:Cancel() .And. !(cAliasQry)->(Eof()) 
                         
	cDtQuebra := (cAliasQry)->A4_COD
	
	_nTotPr1 := 0
	_nTotPr2 := 0
	_nTotPr3 := 0
	_nTotPr4 := 0
	
	oReport:Section(1):Init()
	oReport:Section(1):PrintLine()
	oReport:Section(2):Init()
	While !oReport:Cancel() .And. !(cAliasQry)->(Eof()) .and. (cAliasQry)->A4_COD = cDtQuebra 
	
		oReport:Section(2):PrintLine()
		_nTotPr1 += (cAliasQry)->QT_ORIGINAL
		_nTotPr2 += (cAliasQry)->CB7_QTPALLET
		_nTotPr3 += (cAliasQry)->CB7_QTCAIXA
		_nTotPr4 += (cAliasQry)->CB7_QTUNITA
		
		dbSkip()
		oReport:IncMeter()
	End
	
	oReport:Section(3):Init()
	oReport:Section(3):Cell( "Totais" ):SetBlock( { || "TOTAL" } ) // "TOTAL GERAL"
	//oReport:Section(3):Cell("QT_ORIGINAL"):SetBlock( { || _nTotPr1 } )
	oReport:Section(3):Cell("CB7_QTPALLET"):SetBlock( { || _nTotPr2 } )
	oReport:Section(3):Cell("CB7_QTCAIXA"):SetBlock( { || _nTotPr3 } )
	//oReport:Section(3):Cell("CB7_QTUNITA"):SetBlock( { || _nTotPr4 } )
	
	oReport:Section(3):PrintLine()
	oReport:Section(3):Finish()
	oReport:Section(2):Finish()
	oReport:Section(1):Finish()
	
End

//Fecha Alias Temporario
If Select(cAliasQry)
	(cAliasQry)->(dbCloseArea())
EndIf
//Exclui a tabela temporaria do Banco de Dados
If TcCanOpen(aResult[1])
	TcSqlExec("DROP TABLE "+aResult[1])
EndIf

RETURN


/*
--------------------------------------------------------------------------------------------------------------
Perguntas do relatório
--------------------------------------------------------------------------------------------------------------
*/
Static Function AjustaSx1(cPerg)
//Local cKey 		:= ""
Local aHelpPor	:= {}
Local aHelpEng	:= {}
Local aHelpSpa	:= {}

Aadd( aHelpPor, "Transportadora" )
Aadd( aHelpEng, "Transportadora" )
Aadd( aHelpSpa, "Transportadora" ) 

PutSx1(cPerg,"01"   ,"Da transportadora: ","",""	,"mv_ch1","C",06,0,0,"G","","SA4",,,;
"mv_par01", "","","","",;
		    "","","",;
			"","","",;
			"","","",;
			"","","",;
			aHelpPor,aHelpEng,aHelpSpa)
			//"","","",".TFSEPTAI.")


Aadd( aHelpPor, "Emissao da OS" )
Aadd( aHelpEng, "Emissao da OS" )
Aadd( aHelpSpa, "Emissao da OS" ) 

PutSx1(cPerg,"02"   ,"OS emitidas a partir de: ","",""	,"mv_ch2","D",08,0,0,"G","","",,,;
"mv_par02", "","","","",;
		    "","","",;
			"","","",;
			"","","",;
			"","","",;
			aHelpPor,aHelpEng,aHelpSpa)
			//"","","",".TFSEPTAI.")

Return

/*
--------------------------------------------------------------------------------------------------------------
PUTSX1 
--------------------------------------------------------------------------------------------------------------
*/
Static Function PutSx1(cGrupo,cOrdem,cPergunt,cPerSpa,cPerEng,cVar,;
	cTipo ,nTamanho,nDecimal,nPresel,cGSC,cValid,;
	cF3, cGrpSxg,cPyme,;
	cVar01,cDef01,cDefSpa1,cDefEng1,cCnt01,;
	cDef02,cDefSpa2,cDefEng2,;
	cDef03,cDefSpa3,cDefEng3,;
	cDef04,cDefSpa4,cDefEng4,;
	cDef05,cDefSpa5,cDefEng5,;
	aHelpPor,aHelpEng,aHelpSpa,cHelp)

	LOCAL aArea := GetArea()
	Local cKey
	Local lPort := .f.
	Local lSpa  := .f.
	Local lIngl := .f. 


	cKey  := "P." + AllTrim( cGrupo ) + AllTrim( cOrdem ) + "."

	cPyme    := Iif( cPyme 		== Nil, " ", cPyme		)
	cF3      := Iif( cF3 		== NIl, " ", cF3		)
	cGrpSxg  := Iif( cGrpSxg	== Nil, " ", cGrpSxg	)
	cCnt01   := Iif( cCnt01		== Nil, "" , cCnt01 	)
	cHelp	 := Iif( cHelp		== Nil, "" , cHelp		)

	dbSelectArea( "SX1" )
	dbSetOrder( 1 )

	// Ajusta o tamanho do grupo. Ajuste emergencial para valida��o dos fontes.
	// RFC - 15/03/2007
	cGrupo := PadR( cGrupo , Len( SX1->X1_GRUPO ) , " " )

	If !( DbSeek( cGrupo + cOrdem ))

		cPergunt:= If(! "?" $ cPergunt .And. ! Empty(cPergunt),Alltrim(cPergunt)+" ?",cPergunt)
		cPerSpa	:= If(! "?" $ cPerSpa  .And. ! Empty(cPerSpa) ,Alltrim(cPerSpa) +" ?",cPerSpa)
		cPerEng	:= If(! "?" $ cPerEng  .And. ! Empty(cPerEng) ,Alltrim(cPerEng) +" ?",cPerEng)

		Reclock( "SX1" , .T. )

		Replace X1_GRUPO   With cGrupo
		Replace X1_ORDEM   With cOrdem
		Replace X1_PERGUNT With cPergunt
		Replace X1_PERSPA  With cPerSpa
		Replace X1_PERENG  With cPerEng
		Replace X1_VARIAVL With cVar
		Replace X1_TIPO    With cTipo
		Replace X1_TAMANHO With nTamanho
		Replace X1_DECIMAL With nDecimal
		Replace X1_PRESEL  With nPresel
		Replace X1_GSC     With cGSC
		Replace X1_VALID   With cValid

		Replace X1_VAR01   With cVar01

		Replace X1_F3      With cF3
		Replace X1_GRPSXG  With cGrpSxg

		If Fieldpos("X1_PYME") > 0
			If cPyme != Nil
				Replace X1_PYME With cPyme
			Endif
		Endif

		Replace X1_CNT01   With cCnt01
		If cGSC == "C"			// Mult Escolha
			Replace X1_DEF01   With cDef01
			Replace X1_DEFSPA1 With cDefSpa1
			Replace X1_DEFENG1 With cDefEng1

			Replace X1_DEF02   With cDef02
			Replace X1_DEFSPA2 With cDefSpa2
			Replace X1_DEFENG2 With cDefEng2

			Replace X1_DEF03   With cDef03
			Replace X1_DEFSPA3 With cDefSpa3
			Replace X1_DEFENG3 With cDefEng3

			Replace X1_DEF04   With cDef04
			Replace X1_DEFSPA4 With cDefSpa4
			Replace X1_DEFENG4 With cDefEng4

			Replace X1_DEF05   With cDef05
			Replace X1_DEFSPA5 With cDefSpa5
			Replace X1_DEFENG5 With cDefEng5
		Endif

		Replace X1_HELP  With cHelp

		PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa)

		MsUnlock()
	Else

		lPort := ! "?" $ X1_PERGUNT .And. ! Empty(SX1->X1_PERGUNT)
		lSpa  := ! "?" $ X1_PERSPA  .And. ! Empty(SX1->X1_PERSPA)
		lIngl := ! "?" $ X1_PERENG  .And. ! Empty(SX1->X1_PERENG)

		If lPort .Or. lSpa .Or. lIngl
			RecLock("SX1",.F.)
			If lPort 
				SX1->X1_PERGUNT:= Alltrim(SX1->X1_PERGUNT)+" ?"
			EndIf
			If lSpa 
				SX1->X1_PERSPA := Alltrim(SX1->X1_PERSPA) +" ?"
			EndIf
			If lIngl
				SX1->X1_PERENG := Alltrim(SX1->X1_PERENG) +" ?"
			EndIf
			SX1->(MsUnLock())
		EndIf
	Endif

	RestArea( aArea )

Return




/*
Fun��o que emitir relatório detalhado da onda
*/
User Function TFTRANAUTOM()
Private oGeraNf
Private cPerg		:= "TFRELTRAU"
Private cCadastro := "Relatorio da Transferencias Automaticas"
Private oReport

AjustaTRS( "TFRELTRAU" ) 

If Pergunte("TFRELTRAU",.T.)
	IF MV_PAR04=1
		oReport := TRSinReportDef()
		oReport:PrintDialog()
	ELSEIF MV_PAR04=2
		oReport := TRReportDef()
		oReport:PrintDialog()
	ENDIF
EndIf

Return
/*
--------------------------------------------------------------------------------------------------------------
Perguntas do relatório
--------------------------------------------------------------------------------------------------------------
*/
Static Function AjustaTRS(cPerg)
//Local cKey 		:= ""
Local aHelpPor	:= {}
Local aHelpEng	:= {}
Local aHelpSpa	:= {}

Aadd( aHelpPor, "Produto" )
Aadd( aHelpEng, "Produto" )
Aadd( aHelpSpa, "Produto" ) 

PutSx1(cPerg,"01"   ,"Do Produto: ","",""	,"mv_ch1","C",15,0,0,"G","","SB1",,,;
"mv_par01", "","","","",;
		    "","","",;
			"","","",;
			"","","",;
			"","","",;
			aHelpPor,aHelpEng,aHelpSpa)
			//"","","",".TFSEPTAI.")

PutSx1(cPerg,"02"   ,"Ao Produto: ","",""	,"mv_ch2","C",15,0,0,"G","","SB1",,,;
"mv_par02", "","","","",;
		    "","","",;
			"","","",;
			"","","",;
			"","","",;
			aHelpPor,aHelpEng,aHelpSpa)
			//"","","",".TFSEPTAI.")


Aadd( aHelpPor, "Data da Transferencia" )
Aadd( aHelpEng, "Data da Transferencia" )
Aadd( aHelpSpa, "Data da Transferencia" ) 

PutSx1(cPerg,"03"   ,"Transferencias ocorridas a partir de: ","",""	,"mv_ch3","D",08,0,0,"G","","",,,;
"mv_par03", "","","","",;
		    "","","",;
			"","","",;
			"","","",;
			"","","",;
			aHelpPor,aHelpEng,aHelpSpa)
			//"","","",".TFSEPTAI.")

Aadd( aHelpPor, "Tipo de Relatorio" )
Aadd( aHelpEng, "Tipo de Relatorio" )
Aadd( aHelpSpa, "Tipo de Relatorio" ) 

PutSx1(cPerg,"04"   ,"Tipo de Relatorio?","",""	,"mv_ch4","N",01,0,0,"C","","","","",;
"mv_par04", "Sintetico","","","",;
		    "Analitico","","",;
			"","","",;
			"","","",;
			"","","",;
			aHelpPor,aHelpEng,aHelpSpa)
			//"","","",".TFSEPTAI.")
Return

/*
--------------------------------------------------------------------------------------------------------------
Fun��o Static de prepara��o dos objetos
--------------------------------------------------------------------------------------------------------------
*/
Static Function TRReportDef()
Local oReport
Local cAliasQry := "TFRELTRAU" 
Local oOSTransf_1

oReport := TReport():New("TFRELTRAU","Relacao de transferencias automaticas - Analitico","TFRELTRAU", {|oReport| TRReportPrint(oReport,cAliasQry)},"")	
oReport:SetPortrait() 
oReport:SetTotalInLine(.T.)

oReport:cFontBody := 'Arial Narrow' 
oReport:nFontBody := 14
oReport:SetColSpace(1,.T.) 
oReport:SetLineHeight(50) 

Pergunte(oReport:uParam,.F.)

oOSTransf_1 := TRSection():New(oReport,"Relacao de transferencias automaticas - Analitico",{"SD3"},/*{Array com as ordens do relatório}*/,/*Campos do SX3*/,/*Campos do SIX*/)
oOSTransf_1:SetTotalInLine(.F.)
oOSTransf_1:SetPageBreak(.T.)

TRCell():New(oOSTransf_1,"DOC_TRANSFERE"	,"SD3"	,"Docto. Transfere"	,"@!"								,09							,/*lPixel*/,{|| (cAliasQry)->DOC_TRANSFERE	})		
TRCell():New(oOSTransf_1,"PRODUTO"			,"SD3"	,"Produto"			,"@!"								,15							,/*lPixel*/,{|| (cAliasQry)->PRODUTO		})	
TRCell():New(oOSTransf_1,"DESCRICAO_PRO"	,"SD3"	,"Descricao produto","@!"								,40							,/*lPixel*/,{|| (cAliasQry)->DESCRICAO_PRO	})	
TRCell():New(oOSTransf_1,"ARMAZEM"			,"SD3"	,"Armazem"			,"@!"								,02							,/*lPixel*/,{|| (cAliasQry)->ARMAZEM		})	
TRCell():New(oOSTransf_1,"END_ORIGEM"		,"SD3"	,"End. Origem"		,"@!"								,02							,/*lPixel*/,{|| (cAliasQry)->END_ORIGEM		})	
TRCell():New(oOSTransf_1,"END_DESTINO"		,"SD3"	,"End. Destino"		,"@!"								,02							,/*lPixel*/,{|| (cAliasQry)->END_DESTINO	})	
TRCell():New(oOSTransf_1,"QUANTIDADE"		,"SD3"	,"Quantidade"		,"@E 999"							,03							,/*lPixel*/,{|| (cAliasQry)->QUANTIDADE 	},"RIGHT",,"RIGHT")	
TRCell():New(oOSTransf_1,"PEDIDO_VENDA"		,"SD3"	,"Pedido Venda"		,"@!"								,06							,/*lPixel*/,{|| (cAliasQry)->PEDIDO_VENDA	})	
TRCell():New(oOSTransf_1,"DATA_TRANSFERE"	,"SD3"	,"Data Transferecia","@!"								,10							,/*lPixel*/,{|| (cAliasQry)->DATA_TRANSFERE	})	
TRCell():New(oOSTransf_1,"HORA_MOVTO"		,"SD3"	,"Hora Transferecia","@!"								,06							,/*lPixel*/,{|| (cAliasQry)->HORA_MOVTO		})	

Return(oReport)


/*
--------------------------------------------------------------------------------------------------------------
Fun��o Static de execu��o do Script SQL para alimentar os objetos
--------------------------------------------------------------------------------------------------------------
*/
Static Function TRReportPrint(oReport,cAliasQry)

oReport:SetTitle(oReport:Title() )	
oReport:Section(1):SetHeaderPage(.T.)
oReport:Section(1):SetHeaderSection(.T.)
oReport:Section(1):SetHeaderBreak(.F.)

MakeSqlExpr(oReport:uParam)

aResult := {}
If TCSPExist("SP_REL_MAT_TRANSF_AUTOM_CD")

	aResult := TCSPEXEC("SP_REL_MAT_TRANSF_AUTOM_CD", MV_PAR01, MV_PAR02, DTOS(MV_PAR03), ALLTRIM(STR(MV_PAR04)), DTOS(ddatabase)+SUBSTR(TIME(),1,2)+SUBSTR(TIME(),4,2) )
	
	If Select((cAliasQry)) > 0
		dbSelectArea((cAliasQry))
		(cAliasQry)->(DbCloseArea())
	EndIf

	TCQuery "SELECT * FROM " + aResult[1] NEW ALIAS "TFRELTRAU"

Else
	Final("RE-INSTALAR A STORED PROCEDURE: SP_REL_MAT_TRANSF_AUTOM_CD")
EndIf

oReport:Section(1):BeginQuery()	
dbSelectArea("TFRELTRAU")				
oReport:Section(1):EndQuery(/*Array com os parametros do tipo Range*/)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Inicio da impressao do fluxo do relatório                               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oReport:SetMeter((cAliasQry)->(LastRec()))
dbSelectArea(cAliasQry)
                          
While !oReport:Cancel() .And. !(cAliasQry)->(Eof()) 
                         
	oReport:Section(1):Init()
	While !oReport:Cancel() .And. !(cAliasQry)->(Eof()) 
	
		oReport:Section(1):PrintLine()
		
		dbSkip()
		oReport:IncMeter()
	End
	
	oReport:Section(1):Finish()
	
End

//Fecha Alias Temporario
If Select(cAliasQry)
	(cAliasQry)->(dbCloseArea())
EndIf
//Exclui a tabela temporaria do Banco de Dados
If TcCanOpen(aResult[1])
	TcSqlExec("DROP TABLE "+aResult[1])
EndIf

RETURN

/*
Fun��o que emitir relatório detalhado da onda
*/
User Function TFRESRVABERTA()
Private oGeraNf
Private oReport

If MsgYesNo("Deseja emitir relatorio de reservas abertas?","ACDAT005")
	oReport := RSReportDef()
	oReport:PrintDialog()
EndIf

Return

/*
--------------------------------------------------------------------------------------------------------------
Fun��o Static de prepara��o dos objetos
--------------------------------------------------------------------------------------------------------------
*/
Static Function RSReportDef()
Local oReport
Local cAliasQry := "TFRELRESV" 
Local oOSTransf_1

oReport := TReport():New("TFRELRESV","Relacao de reservas abertas","TFRELRESV", {|oReport| RSReportPrint(oReport,cAliasQry)},"")	
oReport:SetPortrait() 
oReport:SetTotalInLine(.T.)

oReport:cFontBody := 'Arial Narrow' 
oReport:nFontBody := 14
oReport:SetColSpace(1,.T.) 
oReport:SetLineHeight(50) 

Pergunte(oReport:uParam,.F.)

oOSTransf_1 := TRSection():New(oReport,"Relacao de reservas abertas",{"SC0"},/*{Array com as ordens do relatório}*/,/*Campos do SX3*/,/*Campos do SIX*/)
oOSTransf_1:SetTotalInLine(.F.)
oOSTransf_1:SetPageBreak(.T.)

TRCell():New(oOSTransf_1,"NUMERO_RESERVA"	,"CB0"	,"Docto. da Resrva"	,"@!"			,06			,/*lPixel*/,{|| (cAliasQry)->NUMERO_RESERVA	})		
TRCell():New(oOSTransf_1,"DT_EMISSAO"		,"CB0"	,"Data Reserva"		,"@!"			,10			,/*lPixel*/,{|| (cAliasQry)->DT_EMISSAO		})	
TRCell():New(oOSTransf_1,"TIPO_RESERVA"		,"CB0"	,"Tipo de reserva"	,"@!"			,02			,/*lPixel*/,{|| (cAliasQry)->TIPO_RESERVA	})		
TRCell():New(oOSTransf_1,"SOLICITANTE"		,"CB0"	,"Solicitante"		,"@!"			,20			,/*lPixel*/,{|| (cAliasQry)->SOLICITANTE	})		
TRCell():New(oOSTransf_1,"PEDIDO_VENDA"		,"CB0"	,"Pedido de venda"	,"@!"			,06			,/*lPixel*/,{|| (cAliasQry)->PEDIDO_VENDA	})		
TRCell():New(oOSTransf_1,"PRODUTO"			,"CB0"	,"Produto"			,"@!"			,15			,/*lPixel*/,{|| (cAliasQry)->PRODUTO		})	
TRCell():New(oOSTransf_1,"DESCRICAO_PRO"	,"CB0"	,"Descricao produto","@!"			,40			,/*lPixel*/,{|| (cAliasQry)->DESCRICAO_PRO	})	
TRCell():New(oOSTransf_1,"ARMAZEM"			,"CB0"	,"Armazem"			,"@!"			,02			,/*lPixel*/,{|| (cAliasQry)->ARMAZEM		})	
TRCell():New(oOSTransf_1,"ENDERECO"			,"CB0"	,"Endereco reserva"	,"@!"			,10			,/*lPixel*/,{|| (cAliasQry)->ENDERECO		})	
TRCell():New(oOSTransf_1,"QUANTIDADE"		,"CB0"	,"Quantidade"		,"@E 999"		,03			,/*lPixel*/,{|| (cAliasQry)->QUANTIDADE 	},"RIGHT",,"RIGHT")	
TRCell():New(oOSTransf_1,"DT_VALIDADE"		,"CB0"	,"Data Validade"	,"@!"			,10			,/*lPixel*/,{|| (cAliasQry)->DT_VALIDADE	})	

Return(oReport)


/*
--------------------------------------------------------------------------------------------------------------
Fun��o Static de execu��o do Script SQL para alimentar os objetos
--------------------------------------------------------------------------------------------------------------
*/
Static Function RSReportPrint(oReport,cAliasQry)

oReport:SetTitle(oReport:Title() )	
oReport:Section(1):SetHeaderPage(.T.)
oReport:Section(1):SetHeaderSection(.T.)
oReport:Section(1):SetHeaderBreak(.F.)

MakeSqlExpr(oReport:uParam)

aResult := {}
If TCSPExist("SP_REL_MAT_RESERVA_ABERTA")

	aResult := TCSPEXEC("SP_REL_MAT_RESERVA_ABERTA", DTOS(ddatabase)+SUBSTR(TIME(),1,2)+SUBSTR(TIME(),4,2) )
	
	If Select((cAliasQry)) > 0
		dbSelectArea((cAliasQry))
		(cAliasQry)->(DbCloseArea())
	EndIf

	TCQuery "SELECT * FROM " + aResult[1] NEW ALIAS "TFRELRESV"

Else
	Final("RE-INSTALAR A STORED PROCEDURE: SP_REL_MAT_RESERVA_ABERTA")
EndIf

oReport:Section(1):BeginQuery()	
dbSelectArea("TFRELRESV")				
oReport:Section(1):EndQuery(/*Array com os parametros do tipo Range*/)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Inicio da impressao do fluxo do relatório                               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oReport:SetMeter((cAliasQry)->(LastRec()))
dbSelectArea(cAliasQry)
                          
While !oReport:Cancel() .And. !(cAliasQry)->(Eof()) 
                         
	oReport:Section(1):Init()
	While !oReport:Cancel() .And. !(cAliasQry)->(Eof()) 
	
		oReport:Section(1):PrintLine()
		
		dbSkip()
		oReport:IncMeter()
	End
	
	oReport:Section(1):Finish()
	
End

//Fecha Alias Temporario
If Select(cAliasQry)
	(cAliasQry)->(dbCloseArea())
EndIf
//Exclui a tabela temporaria do Banco de Dados
If TcCanOpen(aResult[1])
	TcSqlExec("DROP TABLE "+aResult[1])
EndIf

RETURN
/*
--------------------------------------------------------------------------------------------------------------
Fun��o Static de prepara��o dos objetos
--------------------------------------------------------------------------------------------------------------
*/
Static Function TRSinReportDef()
Local oReport
Local cAliasQry := "TFRELTRAU" 
Local oOSTransf_1

oReport := TReport():New("TFRELTRAU","Relacao de transferencias automaticas - Sintetico","TFRELTRAU", {|oReport| TRReportPrint(oReport,cAliasQry)},"")	
oReport:SetPortrait() 
oReport:SetTotalInLine(.T.)

oReport:cFontBody := 'Arial Narrow' 
oReport:nFontBody := 14
oReport:SetColSpace(1,.T.) 
oReport:SetLineHeight(50) 

Pergunte(oReport:uParam,.F.)

oOSTransf_1 := TRSection():New(oReport,"Relacao de transferencias automaticas - Sintetico",{"SD3"},/*{Array com as ordens do relatório}*/,/*Campos do SX3*/,/*Campos do SIX*/)
oOSTransf_1:SetTotalInLine(.F.)
oOSTransf_1:SetPageBreak(.T.)

TRCell():New(oOSTransf_1,"PRODUTO"			,"SD3"	,"Produto"			,"@!"								,15							,/*lPixel*/,{|| (cAliasQry)->PRODUTO		})	
TRCell():New(oOSTransf_1,"DESCRICAO_PRO"	,"SD3"	,"Descricao produto","@!"								,40							,/*lPixel*/,{|| (cAliasQry)->DESCRICAO_PRO	})	
TRCell():New(oOSTransf_1,"ARMAZEM"			,"SD3"	,"Armazem"			,"@!"								,02							,/*lPixel*/,{|| (cAliasQry)->ARMAZEM		})	
TRCell():New(oOSTransf_1,"END_ORIGEM"		,"SD3"	,"End. Origem"		,"@!"								,02							,/*lPixel*/,{|| (cAliasQry)->END_ORIGEM		})	
TRCell():New(oOSTransf_1,"END_DESTINO"		,"SD3"	,"End. Destino"		,"@!"								,02							,/*lPixel*/,{|| (cAliasQry)->END_DESTINO	})	
TRCell():New(oOSTransf_1,"QUANTIDADE"		,"SD3"	,"Quantidade"		,"@E 999,999"						,10							,/*lPixel*/,{|| (cAliasQry)->QUANTIDADE 	},"RIGHT",,"RIGHT")	

Return(oReport)



//Programa:		TFMNTOF
//Descricao:	Rotina de Manutencao de OF - Ordem de Faturamento
//Autor:		Ronald Piscioneri
//Data:			14-ABR-2021
User Function TFMNTOF()
Local lCk1 := .F.
Local cGNOF := Space(12)
Local cInf := "Digite o nro. da OF e/ou a Data de Libera��o, e clique em PESQUISA"
Local dGDt := CtoD("//")
Local aLbxA := {}
Local oNo := LoadBitmap( GetResources(), "LBNO" )
Local oOk := LoadBitmap( GetResources(), "LBOK" )
Local oBNo := Nil
Local oBOk := Nil
Local oBPsq := Nil
Local oCk1 := Nil
Local oGDt := Nil
Local oGNOF := Nil
Local oGpInf := Nil
Local oGpIt := Nil
Local oGpPsq := Nil
Local oSDt := Nil
Local oSInf := Nil
Local oSNOF := Nil
Local oLbxA := Nil
Local oDgA := Nil

aLbxA := aClone(RetOF())

DEFINE MSDIALOG oDgA TITLE "Manuten��o de OF - Ordem de Faturamento" FROM 000, 000  TO 500, 700 COLORS 0, 16777215 PIXEL

    @ 006, 005 GROUP oGpPsq TO 042, 347 PROMPT "Pesquisa de OF" OF oDgA COLOR 0, 16777215 PIXEL
    @ 026, 009 MSGET oGNOF VAR cGNOF SIZE 134, 010 OF oDgA COLORS 0, 16777215 PIXEL
    @ 017, 009 SAY oSNOF PROMPT "N�mero da OF" SIZE 129, 006 OF oDgA COLORS 0, 16777215 PIXEL
    @ 017, 187 SAY oSDt PROMPT "Data da Libera��o" SIZE 050, 007 OF oDgA COLORS 0, 16777215 PIXEL
    @ 026, 187 MSGET oGDt VAR dGDt SIZE 073, 010 OF oDgA COLORS 0, 16777215 PIXEL
    @ 025, 303 BUTTON oBPsq PROMPT "Pesquisa" SIZE 039, 011 OF oDgA PIXEL Action (MsgRun("Pesquisando OFs... Aguarde...",,{||PsqOF(@cGNOF,@dGDt,@aLbxA,@oLbxA)}))
    @ 046, 005 GROUP oGpIt TO 215, 347 PROMPT "Itens da OF" OF oDgA COLOR 0, 16777215 PIXEL
	@ 055, 009 LISTBOX oLbxA Fields HEADER "","Nro. OF","Pedido","Ord. Sep.","Nota Fiscal","Cliente Destino","Cliente Pedido" SIZE 334, 156 OF oDgA PIXEL
    oLbxA:SetArray(aLbxA)
    oLbxA:bLine := {||{Iif(aLbxA[oLbxA:nAt,1],oOk,oNo),aLbxA[oLbxA:nAt,2],aLbxA[oLbxA:nAt,3],aLbxA[oLbxA:nAt,4],aLbxA[oLbxA:nAt,5],aLbxA[oLbxA:nAt,6]}}
    oLbxA:bLDblClick := {||aLbxA[oLbxA:nAt,1]:=!aLbxA[oLbxA:nAt,1],oLbxA:DrawSelect()}
    @ 219, 005 CHECKBOX oCk1 VAR lCk1 PROMPT "Marca / Desmarca Todos" SIZE 103, 008 OF oDgA COLORS 0, 16777215 PIXEL ON CLICK(aEval(aLbxA,{|x|x[1]:=lCk1}),oLbxA:Refresh())
    @ 232, 005 GROUP oGpInf TO 246, 347 OF oDgA COLOR 0, 16777215 PIXEL
    @ 236, 008 SAY oSInf PROMPT cInf SIZE 336, 007 OF oDgA COLORS 0, 16777215 PIXEL
    @ 218, 240 BUTTON oBOk PROMPT "Grava Altera��es" SIZE 068, 011 OF oDgA PIXEL Action (MsgRun("Gravando altera��o na OF... Aguarde...",,{||GrvOF(@cGNOF,@dGDt,@aLbxA,@oLbxA,@oDgA)}))
    @ 218, 312 BUTTON oBNo PROMPT "Sair" SIZE 034, 011 OF oDgA PIXEL Action(Iif(MsgYesNo("Confirma a sa�da ?"),oDgA:End(),Nil))

ACTIVATE MSDIALOG oDgA CENTERED

Return(Nil)



//Programa:		GrvOF
//Descricao:	Grava as altera��es na OF
//Autor:		Ronald Piscioneri
//Data:			14-ABR-2021
Static Function GrvOF(cGNOF,dGDt,aLbxA,oLbxA,oDgA)
Local cMsg := ""
Local cMsgConf := ""
Local cUpd := ""
Local cLPed := ""
Local lGo := .T.
Local lTodos := .T.
Local lDArm := .F.
Local nNx := 0
Local aUpd := {}

If Empty(aLbxA[1,2])
	lGo := .F.
	cMsg := "N�o h� altera��es a serem gravadas"
EndIf

If lGo

	For nNx := 1 to Len(aLbxA)
		If !aLbxA[nNx,1]

			cUpd := "UPDATE "+RetSqlName("SC9")+" SET "
			cUpd += "C9_XNUMOF = '"+aLbxA[nNx,2]+"', "
			cUpd += "C9_NUMOF = '' "
			cUpd += "WHERE D_E_L_E_T_ = ' ' "
			cUpd += "AND C9_FILIAL = '" +xFilial("SC9")+ "' "
			cUpd += "AND C9_NUMOF = '" +aLbxA[nNx,2]+ "' "
			cUpd += "AND C9_PEDIDO = '" +aLbxA[nNx,3]+ "' "
			cUpd += "AND C9_NFISCAL = '" +aLbxA[nNx,5]+ "' "
			cUpd += "AND C9_NOMORI = '" +aLbxA[nNx,6]+ "' "
			aAdd( aUpd, cUpd )

			cLPed += aLbxA[nNx,3] + " - " + Alltrim(aLbxA[nNx,6]) +CRLF
		Else
			lTodos := .F.
		EndIf
	Next nNx

	If Len(aUpd) > 0

		cMsgConf := "Confirma a grava��o das altera��es ?"+CRLF+CRLF
		If lTodos
			cMsgConf += "Todos os pedidos ser�o removidos da OF (a OF ser� eliminada)."+CRLF
		Else
			cMsgConf += "Os seguintes pedidos ser�o removidos desta OF:"+CRLF+CRLF+cLPed
		EndIf

		If MsgYesNo(cMsgConf)

			BeginTran()
			For nNx := 1 to Len(aUpd)
				If TcSqlExec(aUpd[nNx]) <> 0
					lDArm := .T.
				EndIf
			Next nNx
			If lDArm
				DisarmTransaction()
			EndIf
			EndTran()
			
			If lDArm

				cMsg := "Aten��o: n�o foi poss�vel gravar as altera��es, favor tentar novamente. Caso o erro persiste, contacte o Administrador do Sistema."

			Else

				cGNOF := Space(12)
				dGDt := CtoD("//")
				aLbxA := aClone(RetOF())
				oLbxA:aArray:= aClone(aLbxA)
				oLbxA:Refresh()
				oDgA:Refresh()

				cMsg := "Altera��es gravadas com sucesso"

			EndIf
		
		EndIf

	Else

		cMsg := "N�o h� altera��es a serem gravadas."

	EndIf

EndIf

If !Empty(cMsg)
	Aviso( "Aviso", cMsg, {"Ok"}, 3 )
EndIf

Return(Nil)



//Programa:		PsqOF
//Descricao:	Pesquisa OFs
//Autor:		Ronald Piscioneri
//Data:			14-ABR-2021
Static Function PsqOF(cGNOF,dGDt,aLbxA,oLbxA)
Local cQry := ""
Local cMsg := ""
Local cOFNum := ""
Local cSC9Tbl := RetSqlName("SC9")
Local cSC9Fil := xFilial("SC9")
Local cSC5Tbl := RetSqlName("SC5")
Local cSC5Fil := xFilial("SC5")
Local cSA4Tbl := RetSqlName("SA4")
Local cSA4Fil := xFilial("SA4")
Local aOFs := {}
Local nQRgs := 0
Local lGo := .T.

If ( Empty(cGNOF) .And. Empty(dGDt) )

	lGo := .F.
	cMsg := "Preencha o n�mero ou a data de libera��o para pesquisar as OFs"

EndIf

If !Empty(cGNOF)
	If Len(Alltrim(cGNOF)) < 6
		lGo := .F.
		cMsg := "Preencha pelo menos 6 caracteres para pesquisar OFs pelo n�mero"
	EndIf
EndIf

If lGo

	cQry := "SELECT DISTINCT "
	cQry += "C9.C9_NUMOF, "
	cQry += "A4.A4_NOME "
	cQry += "FROM " +cSC9Tbl+ " C9 "
	cQry += "INNER JOIN " +cSC5Tbl+ " C5 "
	cQry += "ON C5.D_E_L_E_T_ = ' ' "
	cQry += "AND C5.C5_FILIAL = '" +cSC5Fil+ "' "
	cQry += "AND C5.C5_NUM = C9.C9_PEDIDO "
	cQry += "INNER JOIN " +cSA4Tbl+ " A4 "
	cQry += "ON A4.D_E_L_E_T_ = ' ' "
	cQry += "AND A4.A4_FILIAL = '" +cSA4Fil+ "' "
	cQry += "AND A4.A4_COD = C5.C5_TRANSP "
	cQry += "WHERE C9.D_E_L_E_T_ = ' ' "
	cQry += "AND C9.C9_FILIAL = '" +cSC9Fil+ "' "
	If !Empty(cGNOF)
		cQry += "AND C9.C9_NUMOF LIKE '%" +Alltrim(cGNOF)+ "%' "
	EndIf
	If !Empty(dGDt)
		cQry += "AND C9.C9_DATALIB = '" +DtoS(dGDt)+ "' "
	EndIf
	cQry += "AND C9.C9_NUMOF <> '' "
	cQry += "ORDER BY C9.C9_NUMOF"

	Iif(Select("AWRK")>0,AWRK->(dbCloseArea()),Nil)
	dbUseArea(.T.,"TOPCONN",TCGenQry(,,cQry),"AWRK",.T.,.T.)
	TcSetField("AWRK","C9_DATALIB","D",8,0)
	AWRK->(dbGoTop())

	While AWRK->(!EoF())
		nQRgs++
		aAdd( aOFs,	{	AWRK->C9_NUMOF,;
						Alltrim(AWRK->A4_NOME)})
		AWRK->(dbSkip())
	EndDo
	AWRK->(dbCloseArea())

	If nQRgs == 0
		cMsg := "Nao h� OFs para os par�metros informados"
	ElseIf nQRgs == 1
		cOFNum := aOFs[1,1]
	ElseIf nQRgs > 1
		cOFNum := SelOf(aOFs)
	EndIf

	If !Empty(cOFNum)
		ChkOSNF( @cOFNum, @cMsg ) 
	EndIf

	aLbxA := aClone(RetOF(cOFNum))
	oLbxA:aArray := aClone(aLbxA)
	oLbxA:Refresh()

EndIf

If !Empty(cMsg)
	Aviso( "Aviso", cMsg, {"Fechar"}, 3 )
EndIf

Return(Nil)



//Programa:		ChkOSNF
//Descricao:	Verifica se a OF escolhida possui OS vinculada, e se a NF ja deu entrada na filial destino
//Autor:		Ronald Piscioneri
//Data:			14-ABR-2021
Static Function ChkOSNF( cOFNum, cMsg )
Local cQry := ""
Local cSC9Tbl := RetSqlName("SC9")
Local cSC9Fil := xFilial("SC9")

cQry := "SELECT DISTINCT "
cQry += "A.C9_NUMOF, "
cQry += "A.C9_NFISCAL, "
cQry += "A.C9_SERIENF, "
cQry += "A.C9_CLIENTE, "
cQry += "A.C9_ORDSEP, "
cQry += "A.C9_PEDIDO, "
cQry += "A.C9_NOMORI "
cQry += "FROM " +cSC9Tbl+ " A "
cQry += "WHERE A.D_E_L_E_T_ = ' ' "
cQry += "AND A.C9_FILIAL = '" +cSC9Fil+ "' "
cQry += "AND A.C9_NUMOF = '" +cOFNum+ "' "
cQry += "AND A.C9_ORDSEP <> '' "
cQry += "ORDER BY A.C9_NUMOF, A.C9_ORDSEP, A.C9_PEDIDO"

Iif(Select("AWRK")>0,AWRK->(dbCloseArea()),Nil)
dbUseArea(.T.,"TOPCONN",TCGenQry(,,cQry),"AWRK",.T.,.T.)
AWRK->(dbGoTop())

If AWRK->(!EoF())
	If !Empty( AWRK->C9_NUMOF )

		cMsg := ""

		If U_TFVFEENF( AWRK->C9_NFISCAL, AWRK->C9_SERIENF, AWRK->C9_CLIENTE )

			cMsg += "N�o ser� permitido fazer altera��es nesta" +CRLF
			cMsg += "OF (" +cOFNum+ "), pois j� foi faturada pela NF " +Alltrim(AWRK->C9_NFISCAL) +CRLF
			cMsg += "cuja entrada j� ocorreu na filial de destino." +CRLF+CRLF
			
		EndIf

		cMsg += "Esta OF (" +cOFNum+ ") possui pedidos com Ordens de Separa��o (OS)." +CRLF
		cMsg += "Portanto, antes de fazer manuten��o nesta OF, � necess�rio estornar as OS's." +CRLF+CRLF
		cMsg += "Lista das OS's desta OF:" +CRLF+CRLF

		While AWRK->(!EoF())

			cMsg += "OS.....: " +AWRK->C9_ORDSEP +CRLF
			cMsg += "Pedido.: " +AWRK->C9_PEDIDO +CRLF
			cMsg += "Cliente: " +Alltrim(AWRK->C9_NOMORI)

			If AWRK->(!EoF())
				cMsg += CRLF+CRLF
			EndIf

			AWRK->(dbSkip())

		EndDo

	EndIf
EndIf
AWRK->(dbCloseArea())

If !Empty(cMsg)
	cOFNum := ""
EndIf

Return(Nil)



//Programa:		SELOF
//Descricao:	Tela para usuario selecionar a OF que sera' feita a manutencao
//Autor:		Ronald Piscioneri
//Data:			14-ABR-2021
Static Function SELOF(aOFs)
Local oBOk := Nil
Local oSay1 := Nil
Local oDgB := Nil
Local oLbxB := Nil
Local aLbxB := aClone(aOFs)
Local cRet := ""
Local bRet := {||cRet:=aLbxB[oLbxB:nAt,1],oDgB:End()}

DEFINE MSDIALOG oDgB TITLE "Foram encontradas "+Alltrim(Str(Len(aOFs)))+ " Ordens de Faturamento" FROM 000, 000  TO 250, 500 COLORS 0, 16777215 PIXEL

    @ 004, 005 SAY oSay1 PROMPT "Selecione a OF desejada na lista abaixo" SIZE 241, 007 OF oDgB COLORS 0, 16777215 PIXEL
    @ 012, 005 LISTBOX oLbxB Fields HEADER "Nro. OF","Transportadora" SIZE 242, 094 OF oDgB PIXEL ColSizes 50,50
    oLbxB:SetArray(aLbxB)
    oLbxB:bLine := {||{aLbxB[oLbxB:nAt,1],aLbxB[oLbxB:nAt,2]}}
    oLbxB:bLDblClick := bRet
	@ 109, 210 BUTTON oBOk PROMPT "OK" SIZE 037, 012 OF oDgB PIXEL Action (Eval(bRet))

ACTIVATE MSDIALOG oDgB CENTERED

Return(cRet)



//Programa:		RETOF
//Descricao:	Retorna dados da OF a ser alterada
//Autor:		Ronald Piscioneri
//Data:			14-ABR-2021
Static Function RetOF( cNumOF )
Local cQry := ""
Local cNSep := ""
Local cSC9Tbl := RetSqlName("SC9")
Local cSC9Fil := xFilial("SC9")
Local cSA1Tbl := RetSqlName("SA1")
Local cSA1Fil := xFilial("SA1")
Local aRet := {}
Default cNumOF := ""

If !Empty(cNumOF)

	cQry := "SELECT DISTINCT "
	cQry += "A.C9_NUMOF, "
	cQry += "A.C9_DATALIB, "
	cQry += "A.C9_ORDSEP, "
	cQry += "A.C9_XORDSEP, "
	cQry += "A.C9_PEDIDO, "
	cQry += "A.C9_NFISCAL, "
	cQry += "A.C9_NOMORI, "
	cQry += "B.A1_NOME "
	cQry += "FROM " +cSC9Tbl+ " A "
	cQry += "INNER JOIN " +cSA1Tbl+ " B "
	cQry += "ON B.D_E_L_E_T_ = ' ' "
	cQry += "AND B.A1_FILIAL = '" +cSA1Fil+ "' "
	cQry += "AND B.A1_COD = A.C9_CLIENTE "
	cQry += "AND B.A1_LOJA = A.C9_LOJA "
	cQry += "WHERE A.D_E_L_E_T_ = ' ' "
	cQry += "AND A.C9_FILIAL = '" +cSC9Fil+ "' "
	cQry += "AND A.C9_NUMOF = '" +cNumOF+ "' "
	cQry += "ORDER BY A.C9_NUMOF, A.C9_ORDSEP, A.C9_PEDIDO"

	Iif(Select("AWRK")>0,AWRK->(dbCloseArea()),Nil)
	dbUseArea(.T.,"TOPCONN",TCGenQry(,,cQry),"AWRK",.T.,.T.)
	TcSetField("AWRK","C9_DATALIB","D",8,0)
	AWRK->(dbGoTop())

	While AWRK->(!EoF())

		cNSep := ""
		If !Empty(AWRK->C9_XORDSEP)
			cNSep := AWRK->C9_XORDSEP
		EndIf
		If Empty(cNSep)
			cNSep := AWRK->C9_ORDSEP
		EndIf

		aAdd( aRet, {	.T.,;
						AWRK->C9_NUMOF,;
						AWRK->C9_PEDIDO,;
						cNSep,;
						AWRK->C9_NFISCAL,;
						AWRK->C9_NOMORI,;
						AWRK->A1_NOME })
		AWRK->(dbSkip())

	EndDo
	AWRK->(dbCloseArea())

EndIf

If Len(aRet) == 0
	aRet :={{.F.,"","","","","",""}}
EndIf

Return(aRet)



//Programa:		TFVFEENF
//Descricao:	Verifica se a NF de saida na filial 02 deu entrada na filial 01
//Retorno:		.T. (deu entrada) ou .F. (nao deu entrada)
//Autor:		Ronald Piscioneri
//Data:			14-ABR-2021
User Function TFVFEENF( cNumNF, cSerNF, cCliEmit )
Local cQry := ""
Local lRet := .F.
Local cEmit := SuperGetMV("TF_CODEMIT",,"001497") //Codigo de Cliente Emitente na filial 02
Local cDest := SuperGetMV("TF_CODDEST",,"010652") //Codigo de Fornecedor do Emitente na filial 01

If cCliEmit == cEmit

	cQry := "SELECT A.F1_DOC "	
	cQry += "FROM "	+RetSqlName("SF1")+ " A "
	cQry += "WHERE A.D_E_L_E_T_ = ' ' "
	cQry += "AND A.F1_FILIAL = '01' "
	cQry += "AND A.F1_DOC = '"+cNumNF+"' "
	cQry += "AND A.F1_SERIE = '"+cSerNF+"' "
	cQry += "AND A.F1_FORNECE = '"+cDest+"' "

	Iif(Select("WRKC9XF1")>0,WRKC9XF1->(dbCloseArea()),Nil)
	dbUseArea(.T.,"TOPCONN",TCGenQry(,,cQry),"WRKC9XF1",.T.,.T.)
	WRKC9XF1->(dbGoTop())

	If WRKC9XF1->(!EoF())
		If !Empty(WRKC9XF1->F1_DOC)
			lRet := .T.
		EndIf
	EndIf
	WRKC9XF1->(dbCloseArea())

EndIf

Return(lRet)



//Programa:		RetNTransp
//Descricao:	Retorna nome da transportadora de um pedido de vendas
//Retorno:		cRet (nome da transportadora)
//Autor:		Ronald Piscioneri
//Data:			15-ABR-2021
Static Function RetNTransp(cNumPed)
Local cQry := ""
Local cRet := ""

cQry := "SELECT B.A4_NOME "	
cQry += "FROM "	+RetSqlName("SC5")+ " A "
cQry += "INNER JOIN " +RetSqlName("SA4")+ " B "
cQry += "ON B.D_E_L_E_T_ = ' ' "
cQry += "AND B.A4_FILIAL = '" +xFilial("SA4")+ "' "
cQry += "AND B.A4_COD = A.C5_TRANSP "
cQry += "WHERE A.D_E_L_E_T_ = ' ' "
cQry += "AND A.C5_FILIAL = '"+xFilial("SC5")+"' "
cQry += "AND A.C5_NUM = '"+cNumPed+"' "

Iif(Select("WKC9A4")>0,WKC9A4->(dbCloseArea()),Nil)
dbUseArea(.T.,"TOPCONN",TCGenQry(,,cQry),"WKC9A4",.T.,.T.)
WKC9A4->(dbGoTop())

If WKC9A4->(!EoF())
	If !Empty(WKC9A4->A4_NOME)
		cRet := Alltrim(WKC9A4->A4_NOME)
	EndIf
EndIf
WKC9A4->(dbCloseArea())

Return(cRet)
