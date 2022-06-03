#Include "Protheus.ch"
#Include "Topconn.ch"
#include "TbiConn.ch"
#include "TbiCode.ch"
#INCLUDE "msgraphi.ch"
#INCLUDE "APWIZARD.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณFun…o ณ PCPMRP01 ณ Autor ณBruno Roberto (VETI)      ณ Data ณ03/05/2011ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescri…o ณ 															  ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณSintaxe 	 ณ (ExpA1,ExpN1) 											  ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณRetorno 	 ณ .T. 														  ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณ Uso 	 ณ Generico 												  ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

/*
|=================================================================================
|   COMENTARIO - Edson Hornberger (14/08/2015)
|---------------------------------------------------------------------------------
| Esta versao esta sendo utilizado pois foi alterado pelo Consultor Paulo Bindo
| sendo que foi utilizado o fonte do Projeto errado (Projeto Protheus).
|=================================================================================
*/

User Function PCPMRP01()

	Local nOpca := 3
	Local aSays :={}, aButtons:={}
	Private cCadastro := OemToAnsi("MRP TAIFF")
	Private oProcess
	Private dDataMRP := Ctod("")
	PRIVATE aOpcoes[2][7]

	Pergunte("MTA712",.f.)

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Inicializa o log de processamento ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	//ProcLogIni( aButtons )
	AADD(aSays,OemToAnsi("Este programa tem como objetivo realizar a analise dos dados"))
	AADD(aSays,OemToAnsi("gerados pelo MRP e disponibilizar uma ferramenta mais completa para"))
	AADD(aSays,OemToAnsi("que acoes corretivas sejam tomadas antes da geracao das OPs e SCs"))
	//AADD(aButtons, { 5,.T.,{|| Pergunte("PCPRL01",.T.) } } )
	AADD(aButtons, { 1,.T.,{|o| nOpca:= 1,o:oWnd:End()}} )
	AADD(aButtons, { 2,.T.,{|o| o:oWnd:End() }} )
	FormBatch( cCadastro, aSays, aButtons ,,,425)
	If ( nOpcA == 1)
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Atualiza o log de processamento ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		ProcLogAtu("INICIO")
		oProcess:=MsNewProcess():New({|lEnd|PCPMRP01(oProcess)},"Consultando","Aguarde...",.F.)
		oProcess:Activate()
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Atualiza o log de processamento ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		ProcLogAtu("FIM")
	EndIf
Return .T.

/*/
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
	ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
	ฑฑณFun…o ณ PCPMRP01 ณ Autor ณBruno Roberto (VETI)  ณ Data ณ 03/05/2011   ณฑฑ
	ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
	ฑฑณDescri…o ณ Monta Interface para Visualizar 							  ณฑฑ
	ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
	ฑฑณSintaxe 	 ณ (ExpA1,ExpN1) 											  ณฑฑ
	ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
	ฑฑณRetorno 	 ณ .T. 														  ณฑฑ
	ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
	ฑฑณ Uso 	 ณ Generico												      ณฑฑ
	ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
	ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
	฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
Static Function PCPMRP01(oProcess)
	// Vetor com os campos que poderao ser alterados
	Local aAlter       	:= {}
	//Local nSuperior    	:= 027           // Distancia entre a MsNewGetDados e o extremidade superior do objeto que a contem
	//Local nEsquerda    	:= 003           // Distancia entre a MsNewGetDados e o extremidade esquerda do objeto que a contem
	//Local nInferior    	:= 120           // Distancia entre a MsNewGetDados e o extremidade inferior do objeto que a contem
	//Local nDireita     	:= 150           // 120 Distancia entre a MsNewGetDados e o extremidade direita  do objeto que a contem

	// Posicao do elemento do vetor aRotina que a MsNewGetDados usara como referencia
	//Local nOpc         	:= GD_UPDATE
	Local cLinhaOk     	:= "AllwaysTrue"    // Funcao executada para validar o contexto da linha atual do aCols
	Local cTudoOk      	:= "AllwaysTrue"    // Funcao executada para validar o contexto geral da MsNewGetDados (todo aCols)
	Local cIniCpos     	:= ""               // Nome dos campos do tipo caracter que utilizarao incremento automatico.
	// Este parametro deve ser no formato "+<nome do primeiro campo>+<nome do
	// segundo campo>+..."
	Local nFreeze      	:= 5
	// Campos estaticos na GetDados.
	Local nMax         	:= 999              // Numero maximo de linhas permitidas. Valor padrao 99
	Local cCampoOk     	:= "AllwaysTrue"    // Funcao executada na validacao do campo
	Local cSuperApagar 	:= ""               // Funcao executada quando pressionada as teclas <Ctrl>+<Delete>
	Local cApagaOk     	:= "AllwaysTrue"    // Funcao executada para validar a exclusao de uma linha do aCols
	Local lConsSabDom   := .F.
	lOCAL I				:= 0

	PRIVATE aPergs711   	:= {}
	Private aPeriodos		:= {}

	Private aObj := {}
	Private aObjects := {}
	Private aButtons := { {"PESQUISA" ,{ || Busca(aClientes,oDlgMan,oClieMan)},OemtoAnsi("Pesquisar"),OemtoAnsi("Pesquisar")},;
		{"FILTRO" ,{ || Filtro(aClientes,aCliTela,oClieMan,nVzs)},OemtoAnsi("Filtro"),OemtoAnsi("Filtro")},;
		{PmsBExcel()[1] ,{ || DlgToExcel({{"GETDADOS",OemToAnsi("Facilitador de analise do MRP"),aHeader,aCliTela}},PmsBExcel()[2],PmsBExcel()[3])},OemtoAnsi("Excel"),OemtoAnsi("Excel")}}
	Private nOpcA := 0
	Private aSize := MsAdvSize( .T. )

	Private oClieMan
	Private aClientes := {}
	Private aEstoque  := {}
	Private aSC1 := {}
	Private aSC2 := {}
	Private aSC7 := {}
	Private aSD4 := {}
	Private aHeader := {}
	Private cProduto := ""
	Private lFirst := .T.
	Private lFirstP:= .T.
	Private nLin := 0
	Private cPA := ""
	PRIVATE aDiversos		:= {}
	Private nVzs := 0

	aPergs711 := {}
	SX1->(dbSeek("MTA712"))
	While !SX1->(EOF()) .And. AllTrim(SX1->X1_GRUPO) == "MTA712"
		aAdd(aPergs711,&(AllTrim(SX1->X1_VAR01)))
		SX1->(dbSkip())
	End

	oProcess:SetRegua1(3)
	oProcess:IncRegua1("Apagando Indices")
	oProcess:SetRegua2(2)
	oProcess:IncRegua2("Apagando CZI???.CDX")

	If Select("TRB") > 0
		TRB->(DbCloseArea())
	EndIf


	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณAdiciona Botao F5/F6/F7 na Interface ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	//SetKey(VK_F5, { || lKey:= .F., Detalhes(aClientes,oClieMan,oProcess),lKey:= .T. }) // Comentado por Gilberto, a fun็ใo Detalhes estava passando mais parametros do que a fun็ใo recebe
	SetKey(VK_F5, { || lKey:= .F., Detalhes(aClientes,oClieMan),lKey:= .T. })

	SetKey(VK_F6, { || lKey:= .F., Busca(aClientes,oDlgMan,oClieMan),lKey:= .T. })
	SetKey(VK_F7, { || lKey:= .F., Filtro(aClientes,aCliTela,oClieMan,nVzs),lKey:= .T. })

	oProcess:IncRegua1("Processando MRP")
	oProcess:SetRegua2(2)
	oProcess:IncRegua2("Abrindo tabelas do MRP")

	//Recupera parametrizacao gravada no ultimo processamento
	dbSelectArea("CZI")
	dbSetOrder(2)
	dbSeek(xFilial("CZI")+"PAR")
	While CZI->CZI_ALIAS == "PAR"
		nTipo       := CZI->CZI_NRRGAL
		dInicio     := CZI->CZI_DTOG
		aOpcoes[2,1]:= CZI->CZI_QUANT

		//Verifica se o exibe os dados resumido de acordo com o ultimo calculo
		//lParResu := AllTrim(CZI->CZI_ITEM) == "1"
		If nTipo == 7
			AADD(aDiversos,CTOD(Alltrim(CZI->CZI_OPC)))
		EndIf


		dbSkip()
	EndDo

	If nTipo == 7
		//Correcao do array adiversos
		aDiversos := ASORT(aDiversos)
		//Transforma data em caracter
		For i := 1 to Len(aDiversos)
			aDiversos[i] := DTOC(aDiversos[i])
		Next i
	EndIf

	//PC01Periodo(.T.,@nTipo,@dInicio, @aPeriodos,aOpcoes, aStru2) // Comentado por Gilberto, chamada da fun็ใo passando mais parametros que o necessแrio
	PC01Periodo(.T.,@nTipo,@dInicio, @aPeriodos,aOpcoes)

	AbreMRP() //chamada da abertura dos arquivos CZI e SHA
	dbselectarea("CZIVIW")
	dbSetOrder(1)
	dbselectarea("CZI")
	dbSetOrder(3)
	nRecCount := 0
	Count to nRecCount
	CZI->(dbGoTop())
	While !Eof()
		If CZI_TPRG == "1"
			nVzs := CZI_QUANT
			Exit
		EndIf
		dbSkip()
	End
	CZI->(dbGoTop())

	While !CZIVIW->(Eof()) //Guardo na matriz aEstoque o Estoque Atual da rodada do MRP

		If !Empty(CZIVIW->PRODSHOW) .and. CZIVIW->TIPO == "1"

			Aadd(aEstoque,{CZIVIW->PRODUTO,CZIVIW->PER001 } )

		Endif

		CZIVIW->(DbSkip())

	EndDo

	oProcess:IncRegua1("Processando MRP")
	oProcess:SetRegua2(nRecCount)
	nRegua:=0
	//MONTA AS DATAS
	dbSelectArea("CZI")
	dbSetOrder(1)
	dbGoTop()
	nTipo 	:= 2 //Val(CZI->CZI_PERMRP)
	dInicio := CZI->CZI_DTOG
	nOpcoes	:=  CZI->CZI_QUANT
	aPeriodos := {}
	If (nTipo == 2)                         // Semanal
		While Dow(dInicio)!=2
			dInicio--
		end
	ElseIf (nTipo == 3) .or. (nTipo=4)      // Quinzenal ou Mensal
		dInicio:= CtoD("01"+Substr(Dtoc(dInicio),3,6),"ddmmyy")
	ElseIf (nTipo == 5)                     // Trimestral
		If Month(dInicio) < 4
			dInicio := CtoD("01/01/"+Substr(DtoC(dInicio),7,2),"ddmmyy")
		ElseIf (Month(dInicio) >= 4) .and. (Month(dInicio) < 7)
			dInicio := CtoD("01/04/"+Substr(DtoC(dInicio),7,2),"ddmmyy")
		ElseIf (Month(dInicio) >= 7) .and. (Month(dInicio) < 10)
			dInicio := CtoD("01/07/"+Substr(DtoC(dInicio),7,2),"ddmmyy")
		ElseIf (Month(dInicio) >=10)
			dInicio := CtoD("01/10/"+Substr(DtoC(dInicio),7,2),"ddmmyy")
		EndIf
	ElseIf (nTipo == 6)                     // Semestral
		If Month(dInicio) <= 6
			dInicio := CtoD("01/01/"+Substr(DtoC(dInicio),7,2),"ddmmyy")
		Else
			dInicio := CtoD("01/07/"+Substr(DtoC(dInicio),7,2),"ddmmyy")
		EndIf
	EndIf
	If nTipo != 7
		For i := 1 to nOpcoes
			AADD(aPeriodos,dInicio)
			If nTipo == 1
				dInicio ++
				While !lConsSabDom .And. ( DOW(dInicio) == 1 .or. DOW(dInicio) == 7 )
					dInicio++
				end
			ElseIf nTipo == 2
				dInicio+=7
			ElseIf nTipo == 3
				dInicio := CtoD(If(Substr(DtoC(dInicio),1,2)="01","15"+Substr(DtoC(dInicio),3,6),;
					"01/"+If(Month(dInicio)+1<=12,StrZero(Month(dInicio)+1,2)+"/"+;
					SubStr(DtoC(dInicio),7,2),"01/"+Substr(Str(Year(dInicio)+1,4),3,2))),"ddmmyy")
			ElseIf nTipo == 4
				dInicio := CtoD("01/"+If(Month(dInicio)+1<=12,StrZero(Month(dInicio)+1,2)+;
					"/"+Substr(Str(Year(dInicio),4),3,2),"01/"+Substr(Str(Year(dInicio)+1,4),3,2)),"ddmmyy")
			ElseIf nTipo == 5
				dInicio := CtoD("01/"+If(Month(dInicio)+3<=12,StrZero(Month(dInicio)+3,2)+;
					"/"+Substr(Str(Year(dInicio),4),3,2),"01/"+Substr(Str(Year(dInicio)+1,4),3,2)),"ddmmyy")
			ElseIf nTipo == 6
				dInicio := CtoD("01/"+If(Month(dInicio)+6<=12,StrZero(Month(dInicio)+6,2)+;
					"/"+Substr(Str(Year(dInicio),4),3,2),"01/"+Substr(Str(Year(dInicio)+1,4),3,2)),"ddmmyy")
			EndIf
		Next i
	Else
		dbSelectArea("CZI")
		dbGoTop()
		cTipo := CZI_TPRG
		While !Eof() .And. CZI_TPRG == cTipo
			AADD(aPeriodos,CZI_DTOG)
			dbSkip()
		End
	EndIf
	//nVzs := Len(aPeriodos)
	dbSelectArea("CZI")
	dbGoTop()

	While !CZI->(Eof())  //Gravo o array principal do MSGetNewDados
		nRegua++
		oProcess:IncRegua2("Processando Dados do MRP ("+AllTrim(Str(Round((nRegua/nRecCount)*100,1)))+"%)")

		If lFirst
			dDataMRP := CZI->CZI_DTOG

			Aadd(aHeader,{"Item"  ,"Item"  ,"@E",2      ,0,"AllwaysTrue()" ,"ฐ","N","" } )
			Aadd(aHeader,{"Material(*)"  ,"Material"  ,"@E",15      ,0,"AllwaysTrue()" ,"ฐ","C","" } )
			Aadd(aHeader,{"Estoque"  ,"Estoque"  ,"@E",15      ,0,"AllwaysTrue()" ,"ฐ","C","" } )
			Aadd(aHeader,{"Qtd(*)"  ,"Qtd"  ,"@E",15      ,2,"AllwaysTrue()" ,"ฐ","N","" } )
			Aadd(aHeader,{"MRP"  ,"MRP"  ,"@E",15      ,0,"AllwaysTrue()" ,"ฐ","C","" } )
			Aadd(aHeader,{"Qtd"  ,"Qtd"  ,"@E",15      ,2,"AllwaysTrue()" ,"ฐ","N","" } )

			//MONTA AS DATAS DO AHEADER
			For i:=1 to Len(aPeriodos)+1
				If i==1
					nCol := Strzero(i,2)
					Aadd(aHeader,{Dtoc(aPeriodos[i])+"(*)"  ,"Coluna "+nCol  ,"@E",15      ,2,"AllwaysTrue()" ,"ฐ","N","" } )
				Elseif i==Len(aPeriodos)+1
					Aadd(aHeader,{"PC"  ,"PC"  ,"@E",1      ,0,"AllwaysTrue()" ,"ฐ","C","" } )
				Else
					nCol := Strzero(i,2)

					Aadd(aHeader,{Dtoc(aPeriodos[i])  ,"Coluna "+nCol  ,"@E",15      ,2,"AllwaysTrue()" ,"ฐ","N","" } )
				Endif
			Next i
			lFirst:= .F.
			CZI->(DbSkip())

		Endif

		If cProduto <> CZI->CZI_PROD .and. !lFirst

			/*
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ—
			//ณQuery para extrair dados do produto e do estoqueณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ—
			*/

			cQueryA := "SELECT DISTINCT(B1_COD),B1_DESC, B1_UM, B1_TIPO, B1_PE, B1_LM, (B1_ESTSEG+B1_EMIN) B1_ESTSEG"
			cQueryA += ",(SELECT SUM(B2_QATU) FROM "+RetSqlName("SB2")+" B21 WITH(NOLOCK)  WHERE B21.D_E_L_E_T_<>'*' AND B21.B2_FILIAL = B1_FILIAL AND B21.B2_LOCAL IN ('90','91','92','93','94','95','96') AND B21.B2_COD = '"+CZI->CZI_PROD+"') B2_QATU1 "
			//		cQueryA += ",(SELECT SUM(B2_QATU) FROM "+RetSqlName("SB2")+" WHERE B2.D_E_L_E_T_<>'*' AND B2_FILIAL = '"+xFilial("SB2")+"' AND B2_LOCAL IN ('01','02','10','11','21','31') AND B2_COD = '"+CZI->CZI_PROD+"') B2_QATU2 "
			cQueryA += ",(SELECT SUM(B2_QNPT) FROM "+RetSqlName("SB2")+" B22 WITH(NOLOCK) WHERE B22.D_E_L_E_T_<>'*' AND B22.B2_FILIAL = B1_FILIAL AND B22.B2_COD = '"+CZI->CZI_PROD+"' ) B2_QNPT "
			cQueryA += "FROM "+RetSqlName("SB1")+" B1 WITH(NOLOCK)"
			//		cQueryA += "LEFT JOIN "+RetSqlName("SB2")+" AS B2 WITH(NOLOCK) ON B2_COD = B1_COD AND B2_FILIAL = B1_FILIAL AND B2.D_E_L_E_T_ <> '*' "
			cQueryA += "WHERE B1.D_E_L_E_T_<>'*' AND B1_FILIAL = '"+xFilial("SB1")+"' AND B1_COD = '"+CZI->CZI_PROD+"' "

			If Select("TRB") > 0
				TRB->(DbCloseArea())
			EndIf
			TcQuery cQueryA New Alias "TRB"


			dbSelectArea("TRB")
			DbGoTop()

			cCols1  := 'aAdd(aClientes,{ 01,TRB->B1_COD,"Atual",Iif(nA > 0,Round(aEstoque[nA][2],0),0),"Necessidades",0' //Primeira Linha
			cCols2  := 'aAdd(aClientes,{ 02,TRB->B1_DESC,"Disponivel",0,"PC",0' //Segunda Linha
			cCols3  := 'aAdd(aClientes,{ 03,TRB->B1_UM,"Poder 3",TRB->B2_QNPT,"SC",0' //Terceira Linha
			cCols4  := 'aAdd(aClientes,{ 04,TRB->B1_TIPO,"","","OP",0' //Quarta Linha
			cCols5  := 'aAdd(aClientes,{ 05,"Leadtime: "+Alltrim(Str(TRB->B1_PE)),"QA",TRB->B2_QATU1,"MRP-SC",""' //Quinta Linha
			cCols6  := 'aAdd(aClientes,{ 06,"Lote Minimo: "+Alltrim(Str(TRB->B1_LM)),"Seguran็a/P.PED.",TRB->B1_ESTSEG,"Balan็o",""' //Sexta Linha
			cCols7  := 'aAdd(aClientes,{ 07,"Onde ้ usado: "+Alltrim(cPA),"","","",""' //Setima Linha
			cCols8  := 'aAdd(aClientes,{ 00,"","","","",""' //Linha de Separacao

			If !lFirstP

				For i:=1 to nVzs

					If i > 1
						aClientes[nLin+6][i+6]+= aClientes[nLin+6][(i-1)+6] //Recalcula Linha Balan็o para todas colunas
					Endif

					If aClientes[nLin+5][i+6] <= 0 .or. aClientes[nLin+6][i+6] >= 0
						aClientes[nLin+5][i+6] := 0  //Zera coluna MRP-SC quando valor for negativo ou a soma com o balan็o anterior der negativo
					Endif

					cCols1 += ',0'
					cCols2 += ',0'
					cCols3 += ',0'
					cCols4 += ',0'
					cCols5 += ',0'
					cCols6 += ',0'
					cCols7 += ',""'
					cCols8 += ',""'

				Next i
				nLin += 8

			Else

				For i:=1 to nVzs

					cCols1 += ',0'
					cCols2 += ',0'
					cCols3 += ',0'
					cCols4 += ',0'
					cCols5 += ',0'
					cCols6 += ',0'
					cCols7 += ',""'
					cCols8 += ',""'

				Next i
				lFirstP := .F.
			Endif

			cCols1  += ',"",.F.})' //Fecha o comando aAdd
			cCols2  += ',"",.F.})' //Fecha o comando aAdd
			cCols3  += ',"",.F.})' //Fecha o comando aAdd
			cCols4  += ',"",.F.})' //Fecha o comando aAdd
			cCols5  += ',"",.F.})' //Fecha o comando aAdd
			cCols6  += ',"",.F.})' //Fecha o comando aAdd
			cCols7  += ',"",.F.})' //Fecha o comando aAdd
			cCols8  += ',"",.F.})' //Fecha o comando aAdd

			cProd := TRB->B1_COD
			nA := aScan(aEstoque, {|x| AllTrim(x[1]) == AllTrim(cProd)})





			&(cCols1)//Linha 01
			&(cCols2)//Linha 02
			&(cCols3)//Linha 03
			&(cCols4)//Linha 04
			&(cCols5)//Linha 05
			&(cCols6)//Linha 06
			&(cCols7)//Linha 07
			&(cCols8)//Linha 08

			cCols1  := ""
			cCols2  := ""
			cCols3  := ""
			cCols4  := ""
			cCols5  := ""
			cCols6  := ""
			cCols7  := ""
			cCols8  := ""
			cProduto := CZI->CZI_PROD

			nPer := Val(Substr(CZI->CZI_PERMRP,2,2))
			aClientes[nLin+5][7]-= aClientes[nLin+1][4] //Desconta Saldo Atual da Linha MRP-SC
			aClientes[nLin+6][7]+= aClientes[nLin+1][4] //Desconta Saldo Atual da Linha Balanco

			Preenche()  //Preenche as colunas com os dados do MRP

		Else

			Preenche()  //Preenche as colunas com os dados do MRP

		Endif

		CZI->(DbSkip())
	EndDo


	For i:=1 to nVzs

		If i > 1
			aClientes[nLin+6][i+6]+= aClientes[nLin+6][(i-1)+6] //Recalcula Linha Balan็o para todas colunas
		Endif

		If aClientes[nLin+5][i+6] <= 0 .or. aClientes[nLin+6][i+6] >= 0
			aClientes[nLin+5][i+6] := 0  //Zera coluna MRP-SC quando valor for negativo ou a soma com o balan็o anterior der negativo
		Endif

	Next i

	aCliTela := aClone(aClientes)  //Copio o array principal para utiliza-lo na tela

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Montagem da Interface ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	aObjects := {}
	AAdd( aObjects, { 200, 100 , .T., .T. } )
	aInfo := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ],0, 0 }
	aPosObj := MsObjSize( aInfo, aObjects)
	DEFINE MSDIALOG oDlgMan FROM aSize[7], 000 TO aSize[6],aSize[5] TITLE OemtoAnsi("Consulta") OF oMainWnd PIXEL
	aEval(aObj,{|x| x:hide()})

	oClieMan:= MsNewGetDados():New(aPosObj[1,1],aPosObj[1,2],aPosObj[1,3],aPosObj[1,4],nOpcA,cLinhaOk,cTudoOk,cIniCpos,;
		aAlter,nFreeze,nMax,cCampoOk,cSuperApagar,cApagaOk,,aHeader,aCliTela)

	//oClieMan:nAedonziett := 7
	//oClieMan:oBrowse:oFont:Bold := .T.

	oClieMan:oBrowse:lJustific := .T.
	oClieMan:oBrowse:BLDBLCLICK := {||}
	oClieMan:oBrowse:lAutoEdit := .F.
	oClieMan:oBrowse:lUseDefaultColors := .F.
	oClieMan:oBrowse:SetBlkBackColor({|| GETDCLR(oClieMan:aCols,oClieMan:nAt,aHeader)})

	//oClieMan:oBrowse:Refresh()

	ACTIVATE MSDIALOG oDlgMan ON INIT EnchoiceBar( oDlgMan, { || oDlgMan:End()}, {||oDlgMan:End()},,aButtons)

	TRB->(DbCloseArea())
	CZIVIW->(DbCloseArea())


Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFATMI     บAutor  ณMicrosiga           บ Data ณ  05/18/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static function Preenche()

	nPer := Val(Substr(CZI->CZI_PERMRP,2,2))

	Do Case
	Case CZI->CZI_ALIAS == "SC1"

		aClientes[nLin+3][nPer+6]+= Round(CZI->CZI_QUANT,0) //Linha SC
		aClientes[nLin+3][6]+= Round(CZI->CZI_QUANT,0)	   //Linha Total SC
		aClientes[nLin+5][nPer+6]-= Round(CZI->CZI_QUANT,0) //Linha MRP-SC
		aClientes[nLin+6][nPer+6]+= Round(CZI->CZI_QUANT,0) //Linha Balanco
		aadd(aSC1,{CZI->CZI_PROD, CZI->CZI_PERMRP, CZI->CZI_DOC, CZI->CZI_ITEM}) //Array SC1

	Case CZI->CZI_ALIAS == "SC2"
		aClientes[nLin+4][nPer+6]+= Round(CZI->CZI_QUANT,0) //Linha OP
		aClientes[nLin+4][6]+= Round(CZI->CZI_QUANT,0)	   //Linha Total OP
		aClientes[nLin+5][nPer+6]-= Round(CZI->CZI_QUANT,0) //Linha MRP-SC
		aClientes[nLin+6][nPer+6]+= Round(CZI->CZI_QUANT,0) //Linha Balanco
		aadd(aSC2,{CZI->CZI_PROD, CZI->CZI_PERMRP, CZI->CZI_DOC}) //Array SC2

	Case CZI->CZI_ALIAS == "SC7"
		aClientes[nLin+2][nPer+6]+= Round(CZI->CZI_QUANT,0) //Linha PC
		aClientes[nLin+2][6]+= Round(CZI->CZI_QUANT,0)	   //Linha Total PC
		aClientes[nLin+5][nPer+6]-= Round(CZI->CZI_QUANT,0) //Linha MRP-SC
		aClientes[nLin+6][nPer+6]+= Round(CZI->CZI_QUANT,0) //Linha Balanco
		If CZI->CZI_DTOG < dDataMRP .and. nPer > 1
			aClientes[nLin+2][nVzs+7] := "x"
		Endif
		aadd(aSC7,{CZI->CZI_PROD, CZI->CZI_PERMRP, CZI->CZI_DOC, CZI->CZI_ITEM}) //Array SC7

	Case CZI->CZI_ALIAS == "SD4"
		aClientes[nLin+1][nPer+6]+= Round(CZI->CZI_QUANT,0) //Linha Necessidades
		aClientes[nLin+1][6]+= Round(CZI->CZI_QUANT,0)	   //Linha Total Necessidades
		aClientes[nLin+5][nPer+6]+= Round(CZI->CZI_QUANT,0) //Linha MRP-SC
		aClientes[nLin+6][nPer+6]-= Round(CZI->CZI_QUANT,0) //Linha Balanco
		aadd(aSD4,{CZI->CZI_PROD, CZI->CZI_PERMRP, CZI->CZI_DOC, Round(CZI->CZI_QUANT,0), CZI->CZI_DTOG}) //Array SD4

	Case CZI->CZI_ALIAS == "CZJ"
		aClientes[nLin+1][nPer+6]+= Round(CZI->CZI_QUANT,0) //Linha Necessidades
		aClientes[nLin+1][6]+= Round(CZI->CZI_QUANT,0)	   //Linha Total Necessidades
		aClientes[nLin+5][nPer+6]+= Round(CZI->CZI_QUANT,0) //Linha MRP-SC
		aClientes[nLin+6][nPer+6]-= Round(CZI->CZI_QUANT,0) //Linha Balanco

	EndCase

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณBusca     บAutor  ณBruno Roberto (VETI)บ Data ณ  01/06/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function Busca(aClientes,oDlgMan,oClieMan)

	/*ฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
	ฑฑ Declara็ใo de Variaveis Private dos Objetos                             ฑฑ
	ูฑฑภฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ*/
	Local Tahoma     := TFont():New( "Tahoma",0,-13,,.F.,0,,400,.F.,.F.,,,,,, )
	Local TahomaN    := TFont():New( "Tahoma",0,-15,,.T.,0,,700,.F.,.F.,,,,,, )
	SetPrvt("oDlg1","oPanel1","oSay1","oSay2","oGet1","oSBtn1")
	Private cProd := Space(TamSX3("B1_COD")[1])

	/*ฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
	ฑฑ Definicao do Dialog e todos os seus componentes.                        ฑฑ
	ูฑฑภฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ*/

	oDlg1      := MSDialog():New( 095,233,204,531,"Pesquisa Produto",,,.F.,,,,,,.T.,,,.T. )
	oPanel1    := TPanel():New( 000,000,"",oDlg1,,.F.,.F.,,,156,048,.T.,.F. )
	oSay1      := TSay():New( 020,004,{||"Digite o codigo do produto que deseja pesquisar:"},oPanel1,,Tahoma,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_WHITE,140,008)
	oSay2      := TSay():New( 004,044,{||"Pesquisa Produto"},oPanel1,,TahomaN,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_WHITE,068,008)
	oGet1      := TGet():New( 032,004,{|u| If(PCount()>0,cProd:=u,cProd)},oPanel1,096,010,'@E',,CLR_BLACK,CLR_WHITE,Tahoma,,,.T.,"",,,.F.,.F.,,.F.,.F.,"SB1",cProd,,)
	//oSBtn1     := SButton():New( 032,116,1,{ || oDlg1:End(), PosaCols(cProd,oDlgMan,oClieMan) },oPanel1,,"", )

	oDlg1:Activate(,,,.T.)

Return



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFiltro  บAutor  ณMicrosiga           บ Data ณ  07/06/11    บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


Static Function Filtro(aClientes,aCliTela,oClieMan,nVzs)

	/*ฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
	ฑฑ Declara็ใo de Variaveis Private dos Objetos                             ฑฑ
	ูฑฑภฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ*/
	Local Tahoma10   := TFont():New( "Tahoma",0,-13,,.F.,0,,400,.F.,.F.,,,,,, )

	Private nSali := 0
	SetPrvt("oDlg2","oPanel1","oBtn2")

	/*ฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
	ฑฑ Definicao do Dialog e todos os seus componentes.                        ฑฑ
	ูฑฑภฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ*/

	oDlg2      := MSDialog():New( 122,238,354,678,"Filtro",,,.F.,,,,,,.T.,,,.T. )
	oPanel1    := TPanel():New( 000,000,"",oDlg2,,.F.,.F.,,,352,240,.T.,.F. )
	//oBtn2      := TButton():New( 008,008,"Necessidades",oPanel1,{ || oDlg2:End(), FilNec(aClientes,aCliTela,oClieMan,nVzs) },60,010,,Tahoma10N,,.T.,,"",,,,.F. )
	//oBtn3      := TButton():New( 008,083,"Entrada > 0",oPanel1,{ || oDlg2:End(), FilEM0(aClientes,aCliTela,oClieMan,nVzs) },60,010,,Tahoma10N,,.T.,,"",,,,.F. )
	//oBtn4      := TButton():New( 008,158,"Entrada = 0",oPanel1,{ || oDlg2:End(), FilEI0(aClientes,aCliTela,oClieMan,nVzs) },60,010,,Tahoma10N,,.T.,,"",,,,.F. )
	oSay1      := TSay():New( 028,008,{||"Saldo Final entre"},oPanel1,,Tahoma10,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,064,008)
	oSay2      := TSay():New( 028,118,{||"e"},oPanel1,,Tahoma10,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,044,008)
	oGet1      := TGet():New( 026,063,{|u| If(PCount()>0,nSali:=u,nSali)},oPanel1,028,008,"@E 999999.99",,CLR_BLACK,CLR_WHITE,Tahoma10,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
	//oGet2      := TGet():New( 026,123,{|u| If(PCount()>0,nSalf:=u,nSalf)},oPanel1,028,008,"@E 999999.99",,CLR_BLACK,CLR_WHITE,Tahoma10,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
	//oBtn5      := TButton():New( 026,178,"Filtra",oPanel1,{ || oDlg2:End(), FilSal(aClientes,oClieMan:aCols,oClieMan,nVzs,nSali,nSalf) },40,010,,Tahoma10N,,.T.,,"",,,,.F. )
	//oSay3      := TSay():New( 043,093,{||"Produtos"},oPanel1,,Tahoma10N,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,054,008)
	//oGet3      := TGet():New( 056,008,{|u| If(PCount()>0,cProd1:=u,cProd1)},oPanel1,063,008,"@E",,CLR_BLACK,CLR_WHITE,Tahoma10,,,.T.,"",,,.F.,.F.,,.F.,.F.,"SB1","",,)
	//oGet4      := TGet():New( 056,083,{|u| If(PCount()>0,cProd2:=u,cProd2)},oPanel1,063,008,"@E",,CLR_BLACK,CLR_WHITE,Tahoma10,,,.T.,"",,,.F.,.F.,,.F.,.F.,"SB1","",,)
	//oGet5      := TGet():New( 056,158,{|u| If(PCount()>0,cProd3:=u,cProd3)},oPanel1,063,008,"@E",,CLR_BLACK,CLR_WHITE,Tahoma10,,,.T.,"",,,.F.,.F.,,.F.,.F.,"SB1","",,)
	//oGet6      := TGet():New( 076,008,{|u| If(PCount()>0,cProd4:=u,cProd4)},oPanel1,063,008,"@E",,CLR_BLACK,CLR_WHITE,Tahoma10,,,.T.,"",,,.F.,.F.,,.F.,.F.,"SB1","",,)
	//oGet7      := TGet():New( 076,083,{|u| If(PCount()>0,cProd5:=u,cProd5)},oPanel1,063,008,"@E",,CLR_BLACK,CLR_WHITE,Tahoma10,,,.T.,"",,,.F.,.F.,,.F.,.F.,"SB1","",,)
	//oBtn6      := TButton():New( 076,158,"Fil Prod",oPanel1,{ || oDlg2:End(), FilProd(aClientes,aCliTela,oClieMan,cProd1,cProd2,cProd3,cProd4,cProd5) },55,010,,Tahoma10N,,.T.,,"",,,,.F. )
	//oBtn7      := TButton():New( 098,008,"Restaurar Filtro",oPanel1,{ || oDlg2:End(), LimpaFil(aClientes,aCliTela,oClieMan) },210,012,,Tahoma10N,,.T.,,"",,,,.F. )

	oDlg2:Activate(,,,.T.)

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAbreMRP   บAutor  ณBruno Roberto (VETI)บ Data ณ  01/06/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Funcao que Abre os arquivos SHA e CZI                      บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function ABREMRP()
	Local cDrive 	:= "CTREECDX"
	Local cExt		:= ".cdx"

	Local cCriaTrab	:= ""
	Local cQuery		:= ""
	Local cProdAnt	:= ""
	Local cOpcAnt		:= ""
	Local cRevAnt		:= ""
	Local cNameIdx 	:= ""
	Local cAliasTab	:= "CRIATAB"
	Local cAliasTop	:= "BUSCADADOS"
	Local nInd			:= 0
	Local aTamQuant  	:= TamSX3("B2_QFIM")
	Local aRecNo		:= {}
	Local aFields	  	:= {}





	//Cria o array dos campos para o arquivo
	AADD(aFields,{"TIPO","C",1,0})
	AADD(aFields,{"TEXTO","C",20,0})
	AADD(aFields,{"PRODUTO","C",LEN(CZJ->CZJ_PROD),0})
	AADD(aFields,{"PRODSHOW","C",LEN(CZJ->CZJ_PROD),0})
	AADD(aFields,{"OPCIONAL","C",LEN(CZJ->CZJ_OPCORD),0})
	AADD(aFields,{"OPCSHOW","C",LEN(CZJ->CZJ_OPCORD),0})
	AADD(aFields,{"REVISAO","C",4,0})
	AADD(aFields,{"REVSHOW","C",4,0})
	AADD(aFields,{"MRP","C",6,0}) //TREXG3

	For nInd := 1 to Len(aPeriodos)
		AADD(aFields,{"PER"+StrZero(nInd,3),"N",aTamQuant[1],aTamQuant[2]})
	Next nInd

	//Pega o nome para o arquivo temporario
	cCriaTrab := "CZIVIW"

	//Se o Alias estแ em uso, fecha
	If Select(cAliasTab) > 0
		(cAliasTab)->(dbCloseArea())
	Endif

	//Apaga o arquivo caso ele exista
	FErase(cCriaTrab)
	FErase(FileNoExt(cCriaTrab)+".cdx")

	//Cria o arquivo
	DbCreate(cCriaTrab,aFields,"CTREECDX")
	DbUseArea(.T.,"CTREECDX",cCriaTrab,cAliasTab,.T.,.F.)

	//Cria o nome para indice
	cNameIdx := FileNoExt(cCriaTrab)

	//Cria o indice
	INDEX ON PRODUTO+OPCIONAL+REVISAO TAG &(cNameIdx) TO &(cNameIdx)
	dbClearIndex()

	//Seta o indice
	dbSetIndex(cNameIdx+".cdx")

	cQuery := " SELECT CZJ.CZJ_PROD, " +;
		" CZJ.CZJ_OPCORD, " +;
		" CZJ.CZJ_NRRV, " +;
		" CZJ.CZJ_NRMRP, " +; //TREXG3
	" CZK.CZK_PERMRP, " +;
		" CZK.CZK_QTSLES, " +;
		" CZK.CZK_QTENTR, " +;
		" CZK.CZK_QTSAID, " +;
		" CZK.CZK_QTSEST, " +;
		" CZK.CZK_QTSALD, " +;
		" CZK.CZK_QTNECE " +;
		" FROM " + RetSqlName("CZJ") + " CZJ, " +;
		RetSqlName("CZK") + " CZK " +;
		" WHERE CZJ.CZJ_FILIAL   = '" + xFilial("CZJ") + "' " +;
		" AND CZK.CZK_FILIAL   = '" + xFilial("CZK") + "' " +;
		" AND CZJ.R_E_C_N_O_   = CZK.CZK_RGCZJ " +;
		" AND (CZK.CZK_QTNECE <> 0 " +;
		"  OR  CZK.CZK_QTSAID <> 0 " +;
		"  OR  CZK.CZK_QTSALD <> 0 " +;
		"  OR  CZK.CZK_QTSEST <> 0 " +;
		"  OR  CZK.CZK_QTENTR <> 0 " +;
		"  OR  CZK.CZK_QTSLES <> 0) " +;
		" ORDER BY CZJ.CZJ_PROD, " +;
		" CZJ.CZJ_OPCORD, " +;
		" CZJ.CZJ_NRRV, " +;
		" CZK.CZK_PERMRP "

	cQuery := ChangeQuery(cQuery)

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasTop,.T.,.T.)
	dbSelectArea(cAliasTop)

	While !Eof()
		nInd := VAL((cAliasTop)->CZK_PERMRP)

		//Se mudar o item, grava novo registro
		If cProdAnt # (cAliasTop)->CZJ_PROD .Or. cOpcAnt # (cAliasTop)->CZJ_OPCORD .Or. cRevAnt # (cAliasTop)->CZJ_NRRV
			cProdAnt 	:= (cAliasTop)->CZJ_PROD
			cOpcAnt  	:= (cAliasTop)->CZJ_OPCORD
			cRevAnt  	:= (cAliasTop)->CZJ_NRRV
			aRecNo		:= {}

			//Grava Saldo inicial
			RecLock(cAliasTab,.T.)
			(cAliasTab)->TIPO 	 := '1'
			(cAliasTab)->TEXTO 	 := "Saldo inicial"
			(cAliasTab)->PRODUTO  := (cAliasTop)->CZJ_PROD
			(cAliasTab)->PRODSHOW := (cAliasTop)->CZJ_PROD
			(cAliasTab)->OPCIONAL := (cAliasTop)->CZJ_OPCORD
			(cAliasTab)->OPCSHOW	 := (cAliasTop)->CZJ_OPCORD
			(cAliasTab)->REVISAO  := (cAliasTop)->CZJ_NRRV
			(cAliasTab)->REVSHOW  := (cAliasTop)->CZJ_NRRV
			(cAliasTab)->MRP 		 := (cAliasTop)->CZJ_NRMRP //TREXG3
			(cAliasTab)->&("PER"+StrZero(nInd,3)) := (cAliasTop)->CZK_QTSLES
			MsUnLock(cAliasTab)

			AADD(aRecNo,{(cAliasTab)->(RecNo())})

			//Grava Entradas
			RecLock(cAliasTab,.T.)
			(cAliasTab)->TIPO 	 := '2'
			(cAliasTab)->TEXTO := "Entradas"
			(cAliasTab)->PRODUTO  := (cAliasTop)->CZJ_PROD
			(cAliasTab)->OPCIONAL := (cAliasTop)->CZJ_OPCORD
			(cAliasTab)->REVISAO  := (cAliasTop)->CZJ_NRRV
			(cAliasTab)->&("PER"+StrZero(nInd,3)) := (cAliasTop)->CZK_QTENTR
			MsUnLock(cAliasTab)

			AADD(aRecNo,{(cAliasTab)->(RecNo())})

			//Grava Saida
			RecLock(cAliasTab,.T.)
			(cAliasTab)->TIPO 	 := '3'
			(cAliasTab)->TEXTO := "Saidas"
			(cAliasTab)->PRODUTO  := (cAliasTop)->CZJ_PROD
			(cAliasTab)->OPCIONAL := (cAliasTop)->CZJ_OPCORD
			(cAliasTab)->REVISAO  := (cAliasTop)->CZJ_NRRV
			(cAliasTab)->&("PER"+StrZero(nInd,3)) := (cAliasTop)->CZK_QTSAID
			MsUnLock(cAliasTab)

			AADD(aRecNo,{(cAliasTab)->(RecNo())})

			//Grava Saida por estrutura
			RecLock(cAliasTab,.T.)
			(cAliasTab)->TIPO 	 := '4'
			(cAliasTab)->TEXTO := "Saidas por estrutura"
			(cAliasTab)->PRODUTO  := (cAliasTop)->CZJ_PROD
			(cAliasTab)->OPCIONAL := (cAliasTop)->CZJ_OPCORD
			(cAliasTab)->REVISAO  := (cAliasTop)->CZJ_NRRV
			(cAliasTab)->&("PER"+StrZero(nInd,3)) := (cAliasTop)->CZK_QTSEST
			MsUnLock(cAliasTab)

			AADD(aRecNo,{(cAliasTab)->(RecNo())})

			//Grava Saldo final
			RecLock(cAliasTab,.T.)
			(cAliasTab)->TIPO 	 := '5'
			(cAliasTab)->TEXTO := "Saldo final"
			(cAliasTab)->PRODUTO  := (cAliasTop)->CZJ_PROD
			(cAliasTab)->OPCIONAL := (cAliasTop)->CZJ_OPCORD
			(cAliasTab)->REVISAO  := (cAliasTop)->CZJ_NRRV
			(cAliasTab)->&("PER"+StrZero(nInd,3)) := (cAliasTop)->CZK_QTSALD
			MsUnLock(cAliasTab)

			AADD(aRecNo,{(cAliasTab)->(RecNo())})

			//Grava Necessidades
			RecLock(cAliasTab,.T.)
			(cAliasTab)->TIPO 	 := '6'
			(cAliasTab)->TEXTO := "Necessidade"
			(cAliasTab)->PRODUTO  := (cAliasTop)->CZJ_PROD
			(cAliasTab)->OPCIONAL := (cAliasTop)->CZJ_OPCORD
			(cAliasTab)->REVISAO  := (cAliasTop)->CZJ_NRRV
			(cAliasTab)->&("PER"+StrZero(nInd,3)) := (cAliasTop)->CZK_QTNECE
			MsUnLock(cAliasTab)

			AADD(aRecNo,{(cAliasTab)->(RecNo())})
		Else
			dbSelectArea(cAliasTab)
			(cAliasTab)->(dbGoTo(aRecNo[1][1]))

			RecLock(cAliasTab,.F.)
			(cAliasTab)->&("PER"+StrZero(nInd,3)) := (cAliasTop)->CZK_QTSLES
			MsUnLock(cAliasTab)

			(cAliasTab)->(dbGoTo(aRecNo[2][1]))

			RecLock(cAliasTab,.F.)
			(cAliasTab)->&("PER"+StrZero(nInd,3)) := (cAliasTop)->CZK_QTENTR
			MsUnLock(cAliasTab)

			(cAliasTab)->(dbGoTo(aRecNo[3][1]))

			RecLock(cAliasTab,.F.)
			(cAliasTab)->&("PER"+StrZero(nInd,3)) := (cAliasTop)->CZK_QTSAID
			MsUnLock(cAliasTab)

			(cAliasTab)->(dbGoTo(aRecNo[4][1]))

			RecLock(cAliasTab,.F.)
			(cAliasTab)->&("PER"+StrZero(nInd,3)) := (cAliasTop)->CZK_QTSEST
			MsUnLock(cAliasTab)

			(cAliasTab)->(dbGoTo(aRecNo[5][1]))

			RecLock(cAliasTab,.F.)
			(cAliasTab)->&("PER"+StrZero(nInd,3)) := (cAliasTop)->CZK_QTSALD
			MsUnLock(cAliasTab)

			(cAliasTab)->(dbGoTo(aRecNo[6][1]))

			RecLock(cAliasTab,.F.)
			(cAliasTab)->&("PER"+StrZero(nInd,3)) := (cAliasTop)->CZK_QTNECE
			MsUnLock(cAliasTab)
		EndIf

		dbSelectArea(cAliasTop)
		dbSkip()
	End

	(cAliasTab)->(DbGoTop())

	(cAliasTop)->(dbCloseArea())

	//-- Define o nome do arquivo CZI
	cArqCZI := REtArq(cDrive,"\System\"+"CZIVIW",.t.)


	//-- Abre o arquivo CZI
	If MSFile(cArqCZI,,cDrive)
		dbUseArea( .T. ,cDrive,cArqCZI, "CZIVIW", .T. , .F. )
	EndIf

	cNameIdx := FileNoExt(cArqCZI)


	//-- Checa a existencia do indice permanente para tabela CZI, e cria se nao existir
	If !File(cNameIdx+cExt)
		//Cria o indice
		INDEX ON PRODUTO+OPCIONAL+REVISAO TAG &(cNameIdx) TO &(cNameIdx)
		dbClearIndex()
	EndIf

	dbClearIndex()
	dbSetIndex( cNameIdx+cExt )

	//Autaliza LOG
	MsgInfo("Fim montagem arquivo de trabalho","PCPMRP01")

Return cAliasTab
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณDetalhes  บAutor  ณBruno Roberto (VETI)บ Data ณ  20/05/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Abre a janela de detalhes quando selecionado F5 sobre      บฑฑ
ฑฑบ          ณ a quantidade de um OP,SC,PC ou Necessidade                 บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Detalhes(aCliTela,oClieMan)

	Local nLin := oClieMan:nAt               //Controla a linha posicionada
	Local nLic := oClieMan:oBrowse:ColPos    //Controla a coluna posicionada
	Local cProd := oClieMan:aCols[nLin][2]        //Contem o Produto selecionado
	Local nItem := oClieMan:aCols[nLin][1]        //Contem o n do item posicionado
	Local nPer := nLic - 6                   //Contem o Periodo selecionado
	Local aAlter := {} // Vetor com os campos que poderao ser alterados
	Local aHedSC1 := {}
	Local aColSC1 := {}
	Local aHedSC2 := {}
	Local aColSC2 := {}
	Local aHedSC7 := {}
	Local aColSC7 := {}
	Local aHedSD4 := {}
	Local aColSD4 := {}
	Local oGetD
	Local lSC1 := .F.
	Local lSC2 := .F.
	Local lSC7 := .F.
	Local lSD4 := .F.
	Local lOk  := .F.
	Local cLocal := ""
	Local cTPOP := ""
	Local nRecA := 0
	Local nRecB := 0
	Local nRecC := 0
	Local Z		:= 0
	Private aEstPA := {}


	If aCliTela[nLin][1] > 1
		nNum := oClieMan:aCols[nLin][1] - 1
		cProd := oClieMan:aCols[nLin-nNum][2]
	Endif

	If nLic == 4  //Coluna de Qtd Estoque
		MaViewSB2(cProd) //Chama consulta padrใo estoque
	Endif

	If nItem == 1 .and. nLic == 2  //C้lula do c๓digo do Produto
		ViewEst() //Chama fun็ใo que traz um nivel acima na estrutura desse produto
	Endif

	If nItem == 7 .and. nLic == 2  //C้lula do Onde e usado
		AchaPA() //Chama funcao que traz onde o produto ้ usado (PA)
	Endif

	If nItem == 1 .and. nLic > 6  //Linha de Necessidades

		// Vetor com os campos que poderao ser alterados
		Aadd(aHedSD4,{"OP"  ,"OP"  ,"@E",13      ,0,"AllwaysTrue()" ,"ฐ","C","" } )
		Aadd(aHedSD4,{"Produto"  ,"PRODUTO"  ,"@E",15      ,0,"AllwaysTrue()" ,"ฐ","C","" } )
		Aadd(aHedSD4,{"Quant"  ,"QUANT"  ,"@E",8      ,2,"AllwaysTrue()" ,"ฐ","N","" } )
		Aadd(aHedSD4,{"Local"  ,"LOCAL"  ,"@E",2      ,0,"AllwaysTrue()" ,"ฐ","C","" } )
		Aadd(aHedSD4,{"Data Empenho"  ,"DTEMP"  ,"@E 99/99/99",8      ,0,"AllwaysTrue()" ,"ฐ","D","" } )

		For z:=1 to Len(aSD4)
			If aSD4[z][1] == cProd .and. aSD4[z][2] == Strzero(nPer,3)

				cLocal := Posicione("SD4",1,xFilial("SD4")+aSD4[z][1]+aSD4[z][3],"D4_LOCAL")

				Aadd(aColSD4,{aSD4[z][3], aSD4[z][1], aSD4[z][4], cLocal, aSD4[z][5], .F. } )
				lSD4 := .T.

			Endif
		Next z

		If lSD4
			DEFINE MSDIALOG oDlg FROM 010, 000 TO 300,500 TITLE OemtoAnsi("Consulta SD4") OF oMainWnd PIXEL

			oGetD:= MsNewGetDados():New(010,000,155,253,0,"AllwaysTrue","AllwaysTrue","",;
				aAlter,000,999,"AllwaysTrue","","AllwaysTrue",,aHedSD4,aColSD4)
			ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar( oDlg, { || oDlg:End(), lOk := .T.}, {||oDlg:End()},,)

		Else
			Alert("Nใo hแ Empenhos Firmes para esse produto")

		Endif

	Endif

	If nItem == 3  .and. nLic > 6 //Linha de SC

		// Vetor com os campos que poderao ser alterados
		Aadd(aHedSC1,{"Num.SC"  ,"NUMSC"  ,"@E",9      ,0,"AllwaysTrue()" ,"ฐ","C","" } )
		Aadd(aHedSC1,{"Item"  ,"ITEM"  ,"@E",4      ,0,"AllwaysTrue()" ,"ฐ","C","" } )
		Aadd(aHedSC1,{"Produto"  ,"PRODUTO"  ,"@E",15      ,0,"AllwaysTrue()" ,"ฐ","C","" } )
		Aadd(aHedSC1,{"Un.Med."  ,"UM"  ,"@E",2      ,0,"AllwaysTrue()" ,"ฐ","C","" } )
		Aadd(aHedSC1,{"Saldo"  ,"SALDO"  ,"@E",8      ,2,"AllwaysTrue()" ,"ฐ","N","" } )
		Aadd(aHedSC1,{"Local"  ,"LOCAL"  ,"@E",2      ,0,"AllwaysTrue()" ,"ฐ","C","" } )
		Aadd(aHedSC1,{"Data Necess."  ,"DATANEC"  ,"@E 99/99/99",8      ,0,"AllwaysTrue()" ,"ฐ","D","" } )

		For z:=1 to Len(aSC1)
			If aSC1[z][1] == cProd .and. aSC1[z][2] == Strzero(nPer,3)

				//Fazer a query do SC1
				cQueryB := "SELECT C1_NUM, C1_ITEM, C1_PRODUTO, C1_UM, (C1_QUANT-C1_QUJE) SALDO, C1_LOCAL, C1_DATPRF  "
				cQueryB += "FROM "+RetSqlName("SC1")+" C1 WITH(NOLOCK)"
				cQueryB += "WHERE C1.D_E_L_E_T_<> '*' AND C1_FILIAL = '"+xFilial("SC1")+"' AND C1_NUM = '"+aSC1[z][3]+"' AND C1_ITEM = '"+aSC1[z][4]+"' AND C1_PRODUTO = '"+aSC1[z][1]+"'"

				If Select("TRB1") > 0
					TRB1->(DbCloseArea())
				EndIf
				TcQuery cQueryB New Alias "TRB1"
				TCSETFIELD("TRB1","C1_DATPRF","D")

				dbSelectArea("TRB1")
				Count to nRecA
				DbGoTop()

				If nRecA > 0

					Aadd(aColSC1,{TRB1->C1_NUM ,TRB1->C1_ITEM, TRB1->C1_PRODUTO, TRB1->C1_UM,TRB1->SALDO, TRB1->C1_LOCAL,TRB1->C1_DATPRF, .F. } )
					lSC1 := .T.

				Endif

			Endif
		Next z

		If lSC1
			DEFINE MSDIALOG oDlg FROM 010, 000 TO 300,500 TITLE OemtoAnsi("Consulta SC1") OF oMainWnd PIXEL

			oGetD:= MsNewGetDados():New(010,000,155,253,0,"AllwaysTrue","AllwaysTrue","",;
				aAlter,000,999,"AllwaysTrue","","AllwaysTrue",,aHedSC1,aColSC1)
			ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar( oDlg, { || oDlg:End(), lOk := .T.}, {||oDlg:End()},,)
		Else
			Alert("Nใo hแ Solicitacoes de Compras para esse produto")
		Endif

	Endif

	If nItem == 2  .and. nLic > 6//Linha de PC

		// Vetor com os campos que poderao ser alterados
		Aadd(aHedSC7,{"Num.PC"  ,"NUMPC"  ,"@E",9      ,0,"AllwaysTrue()" ,"ฐ","C","" } )
		Aadd(aHedSC7,{"Item"  ,"ITEM"  ,"@E",4      ,0,"AllwaysTrue()" ,"ฐ","C","" } )
		Aadd(aHedSC7,{"Produto"  ,"PRODUTO"  ,"@E",15      ,0,"AllwaysTrue()" ,"ฐ","C","" } )
		Aadd(aHedSC7,{"Un.Med."  ,"UM"  ,"@E",2      ,0,"AllwaysTrue()" ,"ฐ","C","" } )
		Aadd(aHedSC7,{"Saldo"  ,"SALDO"  ,"@E",8      ,2,"AllwaysTrue()" ,"ฐ","N","" } )
		Aadd(aHedSC7,{"Local"  ,"LOCAL"  ,"@E",2      ,0,"AllwaysTrue()" ,"ฐ","C","" } )
		Aadd(aHedSC7,{"Data Entrega"  ,"DATAENT"  ,"@E 99/99/99",8      ,0,"AllwaysTrue()" ,"ฐ","D","" } )

		For z:=1 to Len(aSC7)
			If aSC7[z][1] == cProd .and. aSC7[z][2] == Strzero(nPer,3)

				//Fazer a query do SC7
				cQueryC := "SELECT C7_NUM, C7_ITEM, C7_PRODUTO, C7_UM, (C7_QUANT-C7_QUJE) SALDO, C7_LOCAL, C7_DATPRF  "
				cQueryC += "FROM "+RetSqlName("SC7")+" C7 WITH(NOLOCK)"
				cQueryC += "WHERE C7.D_E_L_E_T_<> '*' AND C7_FILIAL = '"+xFilial("SC7")+"' AND C7_NUM = '"+aSC7[z][3]+"' AND C7_ITEM = '"+aSC7[z][4]+"' AND C7_PRODUTO = '"+aSC7[z][1]+"'"

				If Select("TRB7") > 0
					TRB7->(DbCloseArea())
				EndIf
				TcQuery cQueryC New Alias "TRB7"
				TCSETFIELD("TRB7","C7_DATPRF","D")

				dbSelectArea("TRB7")
				Count to nRecB
				DbGoTop()

				If nRecB > 0

					Aadd(aColSC7,{TRB7->C7_NUM ,TRB7->C7_ITEM, TRB7->C7_PRODUTO, TRB7->C7_UM,TRB7->SALDO, TRB7->C7_LOCAL,TRB7->C7_DATPRF, .F. } )
					lSC7 := .T.

				Endif

			Endif
		Next z

		If lSC7
			DEFINE MSDIALOG oDlg FROM 010, 000 TO 300,500 TITLE OemtoAnsi("Consulta SC7") OF oMainWnd PIXEL

			oGetD:= MsNewGetDados():New(010,000,155,253,0,"AllwaysTrue","AllwaysTrue","",;
				aAlter,000,999,"AllwaysTrue","","AllwaysTrue",,aHedSC7,aColSC7)
			ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar( oDlg, { || oDlg:End(), lOk := .T.}, {||oDlg:End()},,)
		Else
			Alert("Nใo hแ Pedidos de Compras para esse produto")
		Endif

	Endif

	If nItem == 4  .and. nLic > 6//Linha de OP

		// Vetor com os campos que poderao ser alterados
		Aadd(aHedSC2,{"Num.OP"  ,"NUMOP"  ,"@E",6      ,0,"AllwaysTrue()" ,"ฐ","C","" } )
		Aadd(aHedSC2,{"Item"  ,"ITEM"  ,"@E",2      ,0,"AllwaysTrue()" ,"ฐ","C","" } )
		Aadd(aHedSC2,{"Sequencia"  ,"SEQUENCIA"  ,"@E",3      ,0,"AllwaysTrue()" ,"ฐ","C","" } )
		Aadd(aHedSC2,{"Produto"  ,"PRODUTO"  ,"@E",15      ,0,"AllwaysTrue()" ,"ฐ","C","" } )
		Aadd(aHedSC2,{"Saldo"  ,"SALDO"  ,"@E",8      ,2,"AllwaysTrue()" ,"ฐ","N","" } )
		Aadd(aHedSC2,{"Local"  ,"LOCAL"  ,"@E",2      ,0,"AllwaysTrue()" ,"ฐ","C","" } )
		Aadd(aHedSC2,{"Data Ini"  ,"DATAINI"  ,"@E 99/99/99",8      ,0,"AllwaysTrue()" ,"ฐ","D","" } )
		Aadd(aHedSC2,{"Data Fim"  ,"DATAFIM"  ,"@E 99/99/99",8      ,0,"AllwaysTrue()" ,"ฐ","D","" } )
		Aadd(aHedSC2,{"Tipo OP"  ,"TIPOOP"  ,"@E",8      ,0,"AllwaysTrue()" ,"ฐ","C","" } )

		For z:=1 to Len(aSC2)
			If aSC2[z][1] == cProd .and. aSC2[z][2] == Strzero(nPer,3)

				//Fazer a query do SC1
				cQueryB := "SELECT C2_NUM, C2_ITEM, C2_SEQUEN, C2_PRODUTO, C2_LOCAL, (C2_QUANT - C2_QUJE) SALDO, C2_DATPRI, C2_DATPRF, C2_TPOP  "
				cQueryB += "FROM "+RetSqlName("SC2")+" C2 WITH(NOLOCK)"
				cQueryB += "WHERE C2.D_E_L_E_T_<> '*' AND C2_FILIAL = '"+xFilial("SC2")+"' AND C2_NUM+C2_ITEM+C2_SEQUEN = '"+aSC2[z][3]+"' AND C2_PRODUTO = '"+aSC2[z][1]+"'"

				If Select("TRB2") > 0
					TRB2->(DbCloseArea())
				EndIf
				TcQuery cQueryB New Alias "TRB2"
				TCSETFIELD("TRB2","C2_DATPRI","D")
				TCSETFIELD("TRB2","C2_DATPRF","D")

				dbSelectArea("TRB2")
				Count to nRecC
				DbGoTop()

				If nRecC > 0

					If TRB2->C2_TPOP == "F"
						cTPOP := "Firme"
					Else
						cTPOP := "Prevista"
					Endif
					Aadd(aColSC2,{TRB2->C2_NUM ,TRB2->C2_ITEM,TRB2->C2_SEQUEN, TRB2->C2_PRODUTO, TRB2->SALDO, TRB2->C2_LOCAL,TRB2->C2_DATPRI,TRB2->C2_DATPRF,cTPOP, .F. } )
					lSC2 := .T.

				Endif

			Endif
		Next z

		If lSC2
			DEFINE MSDIALOG oDlg FROM 010, 000 TO 300,500 TITLE OemtoAnsi("Consulta SC2") OF oMainWnd PIXEL

			oGetD:= MsNewGetDados():New(010,000,155,253,0,"AllwaysTrue","AllwaysTrue","",;
				aAlter,000,999,"AllwaysTrue","","AllwaysTrue",,aHedSC2,aColSC2)
			ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar( oDlg, { || oDlg:End(), lOk := .T.}, {||oDlg:End()},,)
		Else
			Alert("Nใo hแ Ordens de Produ็ใo para esse produto")
		Endif

	Endif

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGETDCLR   บAutor  ณMicrosiga           บ Data ณ  08/28/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFun็ใo para cores do GetDados                               บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function GETDCLR(aLinha,nLinha,aHeader)

	Local nPosItem := aScan(aHeader,{|x| Alltrim(x[2]) == "Item"})
	Local nRet := CLR_WHITE

	If aLinha[nLinha][nVzs+7] == "x" .AND. aLinha[nLinha][nPosItem] == 2
		nRet := CLR_YELLOW
	ElseIf !Empty(aLinha[nLinha][nPosItem]) .AND. aLinha[nLinha][nPosItem] <> 6
		//nRet := CLR_HGRAY
	ElseIf Empty(aLinha[nLinha][nPosItem])
		nRet := CLR_BLACK
	Endif

Return nRet


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณViewEst   บAutor  ณMicrosiga           บ Data ณ  08/28/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFun็ใo para trazer um nivel acima na estrutura do produto   บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function ViewEst()

	Local nRec := 0
	Local nNume := 0
	Local cDesc := ""
	Local nLinha := oClieMan:nAt  //Controla a linha posicionada
	Local cPro := aCliTela[nLinha][2]        //Contem o Produto selecionado
	Local aHProd := {}
	Local aCProd := {}

	SetPrvt("TahomaN","oDlg1","oPanel1","oSay1","oSay2","oBrw1")

	If aCliTela[nLinha][1] > 1
		nNume := aCliTela[nLinha][1] - 1
		cPro := aCliTela[nLinha-nNume][2]
	Endif

	//Faz a query do SG1
	cQueryE := "SELECT G1_COD, G1_COMP, G1_QUANT "
	cQueryE += "FROM "+RetSqlName("SG1")+" G1 WITH(NOLOCK)"
	cQueryE += "WHERE G1.D_E_L_E_T_<> '*' AND G1_FILIAL = '"+xFilial("SG1")+"' AND G1_COMP = '"+cPro+"' AND G1_INI <= '"+Dtos(dDataMRP)+"' AND G1_FIM >= '"+Dtos(dDataMRP)+"'"

	If Select("TRB5") > 0
		TRB5->(DbCloseArea())
	EndIf
	TcQuery cQueryE New Alias "TRB5"

	dbSelectArea("TRB5")
	Count to nRec
	DbGoTop()

	If nRec > 0

		Aadd(aHProd,{"Produto"  ,"PRODUTO"  ,"@E",15      ,0,"AllwaysTrue()" ,"ฐ","C","" } )
		Aadd(aHProd,{"Tipo"  ,"TIPO"  ,"@E",2      ,0,"AllwaysTrue()" ,"ฐ","C","" } )
		Aadd(aHProd,{"Quant"  ,"QUANT"  ,"@E ",6      ,2,"AllwaysTrue()" ,"ฐ","N","" } )
		Aadd(aHProd,{"Desc"  ,"DESC"  ,"@E ",50      ,0,"AllwaysTrue()" ,"ฐ","C","" } )

		While !TRB5->(Eof())

			cTipo:= Posicione("SB1",1,xFilial("SB1")+alltrim(TRB5->G1_COD),"B1_TIPO")
			cDescr:= Posicione("SB1",1,xFilial("SB1")+alltrim(TRB5->G1_COD),"B1_DESC")

			Aadd(aCProd,{TRB5->G1_COD,cTipo,TRB5->G1_QUANT,cDescr,.F.} )
			TRB5->(DbSkip())

		EndDo

		TRB5->(DbCloseArea())
		cDesc:= Posicione("SB1",1,xFilial("SB1")+alltrim(cPro),"B1_DESC")

		/*ฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
		ฑฑ Definicao do Dialog e todos os seus componentes.                        ฑฑ
		ูฑฑภฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ*/
		TahomaN    := TFont():New( "Tahoma",0,-13,,.T.,0,,700,.F.,.F.,,,,,, )
		oDlg1      := MSDialog():New( 091,232,347,750,"Consulta Estrutura Produto",,,.F.,,,,,,.T.,,,.T. )
		oPanel1    := TPanel():New( 000,000,"",oDlg1,,.F.,.F.,,,268,136,.T.,.F. )
		oSay1      := TSay():New( 008,004,{||"Produto: "+cPro+" - "},oPanel1,,TahomaN,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_WHITE,076,008)
		oSay2      := TSay():New( 008,080,{||Alltrim(cDesc)},oPanel1,,TahomaN,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_WHITE,176,008)  
		oBrw1      := MsNewGetDados():New(020,004,124,252,0,'AllwaysTrue()','AllwaysTrue()','',,0,99,'AllwaysTrue()','','AllwaysTrue()',oPanel1,aHProd,aCProd )

		oDlg1:Activate(,,,.T.)	

	Else

		Alert("Nใo hแ produto acima na estrutura.")

	Endif

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAchaPA    บAutor  ณMicrosiga           บ Data ณ  08/28/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFun็ใo para trazer onde o produto e usado                   บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function AchaPA()

	Local nRec := 0
	Local nNume := 0
	Local cDesc := ""
	Local nLinha := oClieMan:nAt  //Controla a linha posicionada
	Local lPA := .F.
	SetPrvt("TahomaN","oDlg1","oPanel1","oSay1","oSay2","oBrw1")
	Private aEstPA := {}
	Private aHEst := {}
	Private cPro := aCliTela[nLinha][2] //Contem o Produto selecionado

	If aCliTela[nLinha][1] > 1
		nNume := aCliTela[nLinha][1] - 1
		cPro := aCliTela[nLinha-nNume][2]
	Endif

	//Faz a query do SG1
	cQueryE := "SELECT G1_COD, G1_QUANT "
	cQueryE += "FROM "+RetSqlName("SG1")+" G1 WITH(NOLOCK)"
	cQueryE += "WHERE G1.D_E_L_E_T_<> '*' AND G1_FILIAL = '"+xFilial("SG1")+"' AND G1_COMP = '"+cPro+"'  AND G1_INI <= '"+Dtos(dDataMRP)+"' AND G1_FIM >= '"+Dtos(dDataMRP)+"'"

	If Select("TRB6") > 0
		TRB6->(DbCloseArea())
	EndIf
	TcQuery cQueryE New Alias "TRB6"

	dbSelectArea("TRB6")
	Count to nRec
	DbGoTop()

	If nRec > 0
		lPA := .T.

		While !TRB6->(Eof())

			cTipo := Posicione("SB1",1,xFilial("SB1")+alltrim(TRB6->G1_COD),"B1_TIPO")
			cDescr := Posicione("SB1",1,xFilial("SB1")+alltrim(TRB6->G1_COD),"B1_DESC")

			If cTipo == "PA"
				Aadd(aEstPA,{TRB6->G1_COD,cTipo,TRB6->G1_QUANT,cDescr,.F.} )
			Else
				SobeUm(TRB6->G1_COD)
			Endif

			TRB6->(DbSkip())

		EndDo

		TRB6->(DbCloseArea())

	Endif

	If lPA

		cDesc:= Posicione("SB1",1,xFilial("SB1")+alltrim(cPro),"B1_DESC")
		Aadd(aHEst,{"Produto"  ,"PRODUTO"  ,"@E",15      ,0,"AllwaysTrue()" ,"ฐ","C","" } )
		Aadd(aHEst,{"Tipo"  ,"TIPO"  ,"@E",2      ,0,"AllwaysTrue()" ,"ฐ","C","" } )
		Aadd(aHEst,{"Quant"  ,"QUANT"  ,"@E ",6      ,2,"AllwaysTrue()" ,"ฐ","N","" } )
		Aadd(aHEst,{"Desc"  ,"DESC"  ,"@E ",50      ,0,"AllwaysTrue()" ,"ฐ","C","" } )

		/*ฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
		ฑฑ Definicao do Dialog e todos os seus componentes.                        ฑฑ
		ูฑฑภฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ*/
		TahomaN    := TFont():New( "Tahoma",0,-13,,.T.,0,,700,.F.,.F.,,,,,, )
		oDlg1      := MSDialog():New( 091,232,347,750,"Consulta Estrutura Produto",,,.F.,,,,,,.T.,,,.T. )
		oPanel1    := TPanel():New( 000,000,"",oDlg1,,.F.,.F.,,,268,136,.T.,.F. )
		oSay1      := TSay():New( 008,004,{||"Produto: "+cPro+" - "},oPanel1,,TahomaN,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_WHITE,076,008)
		oSay2      := TSay():New( 008,080,{||Alltrim(cDesc)},oPanel1,,TahomaN,.F.,.F.,.F.,.T.,CLR_BLUE,CLR_WHITE,176,008)  
		oBrw1      := MsNewGetDados():New(020,004,124,252,0,'AllwaysTrue()','AllwaysTrue()','',,0,99,'AllwaysTrue()','','AllwaysTrue()',oPanel1,aHEst,aEstPA )

		oDlg1:Activate(,,,.T.)

	Else

		Alert("Nใo hแ PA acima da estrutura desse produto")

	Endif

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSobeUm    บAutor  ณMicrosiga           บ Data ณ  08/28/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFun็ใo para trazer onde o produto e usado                   บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function SobeUm(cEstru)

	Local nRec := 0
	Local cTipo := ""
	Local cDesc := ""

	//Faz a query do SG1
	cQueryF := "SELECT G1_COD, G1_QUANT "
	cQueryF += "FROM "+RetSqlName("SG1")+" G1 WITH(NOLOCK)"
	cQueryF += "WHERE G1.D_E_L_E_T_<> '*' AND G1_FILIAL = '"+xFilial("SG1")+"' AND G1_COMP = '"+cEstru+"'  AND G1_INI <= '"+Dtos(dDataMRP)+"' AND G1_FIM >= '"+Dtos(dDataMRP)+"'"

	If Select("TRB8") > 0
		TRB8->(DbCloseArea())
	EndIf
	TcQuery cQueryF New Alias "TRB8"

	dbSelectArea("TRB8")
	Count to nRec
	DbGoTop()

	If nRec > 0
		While !TRB8->(Eof())

			cTipo := Posicione("SB1",1,xFilial("SB1")+alltrim(TRB8->G1_COD),"B1_TIPO")
			cDesc := Posicione("SB1",1,xFilial("SB1")+alltrim(TRB8->G1_COD),"B1_DESC")

			If cTipo == "PA"
				Aadd(aEstPA,{TRB8->G1_COD,cTipo,TRB8->G1_QUANT,cDesc,.F.} )
			Endif

			TRB8->(DbSkip())

		EndDo

		TRB8->(DbCloseArea())
		cDesc:= Posicione("SB1",1,xFilial("SB1")+alltrim(cPro),"B1_DESC")

	Endif

Return


/*------------------------------------------------------------------------//
//Programa:	A712AtuPeriodo
//Autor:		Ricardo Prandi     
//Data:		18/09/2013
//Descricao:	Funcao responsavel pela atualizacao de periodos e cria็ใo 
//            da aPeriodos
//Parametros:	ExpL1 : Indica se o MRP sera executado em modo visualizacao
//				ExpN1 : Indica o tipo de periodo escolhido pelo operador
//				ExpD1 : Data de inicio dos periodos 
//				ExpA1 : Array com os periodos que serao retornados por refer
//				ExpA2 : Array com parametros (opcoes)
//Uso: 		MATA712
//------------------------------------------------------------------------*/
Static Function PC01Periodo(lVisualiza,nTipo,dInicio,aPeriodos,aOpcoes)
	Local cForAno 	:= ""
	Local nPosAno 	:= 0
	Local nTamAno 	:= 0 
	Local i 			:= 0
	Local nY2T			:= If(__SetCentury(),2,0)

	DEFAULT lVisualiza := .F.

	If __SetCentury()
		nPosAno := 1
		nTamAno := 4
		cForAno := "ddmmyyyy"
	Else
		nPosAno := 3
		nTamAno := 2
		cForAno := "ddmmyy"
	Endif

	//Monta a data de inicio de acordo com os parametros                   
	If (nTipo == 2)                         // Semanal
		While Dow(dInicio)!=2
			dInicio--
		end
	ElseIf (nTipo == 3) .or. (nTipo == 4)   // Quinzenal ou Mensal
		dInicio:= CtoD("01/"+Substr(DtoS(dInicio),5,2)+Substr(DtoC(dInicio),6,3+nY2T),cForAno)
	ElseIf (nTipo == 5)                     // Trimestral
		If Month(dInicio) < 4
			dInicio := CtoD("01/01/"+Substr(DtoC(dInicio),7+nY2T,2),cForAno)
		ElseIf (Month(dInicio) >= 4) .and. (Month(dInicio) < 7)
			dInicio := CtoD("01/04/"+Substr(DtoC(dInicio),7+nY2T,2),cForAno)
		ElseIf (Month(dInicio) >= 7) .and. (Month(dInicio) < 10)
			dInicio := CtoD("01/07/"+Substr(DtoC(dInicio),7+nY2T,2),cForAno)
		ElseIf (Month(dInicio) >=10)
			dInicio := CtoD("01/10/"+Substr(DtoC(dInicio),7+nY2T,2),cForAno)
		EndIf
	ElseIf (nTipo == 6)                     // Semestral
		If Month(dInicio) <= 6
			dInicio := CtoD("01/01/"+Substr(DtoC(dInicio),7+nY2T,2),cForAno)
		Else
			dInicio := CtoD("01/07/"+Substr(DtoC(dInicio),7+nY2T,2),cForAno)
		EndIf
	EndIf

	//Monta as datas de acordo com os parametros                   
	If nTipo != 7
		For i := 1 to aOpcoes[2][1]
			dInicio := A712NextUtil(dInicio,aPergs711)
			AADD(aPeriodos,dInicio)
			If nTipo == 1
				dInicio ++
			ElseIf nTipo == 2
				dInicio += 7
			ElseIf nTipo == 3
				dInicio := StoD(If(Substr(DtoS(dInicio),7,2)<"15",Substr(DtoS(dInicio),1,6)+"15",;
				If(Month(dInicio)+1<=12,Str(Year(dInicio),4)+StrZero(Month(dInicio)+1,2)+"01",;
				Str(Year(dInicio)+1,4)+"0101")),cForAno)
					ElseIf nTipo == 4
				dInicio := CtoD("01/"+If(Month(dInicio)+1<=12,StrZero(Month(dInicio)+1,2)+;
				"/"+Substr(Str(Year(dInicio),4),nPosAno,nTamAno),"01/"+Substr(Str(Year(dInicio)+1,4),nPosAno,nTamAno)),cForAno)
				ElseIf nTipo == 5
				dInicio := CtoD("01/"+If(Month(dInicio)+3<=12,StrZero(Month(dInicio)+3,2)+;
				"/"+Substr(Str(Year(dInicio),4),nPosAno,nTamAno),"01/"+Substr(Str(Year(dInicio)+1,4),nPosAno,nTamAno)),cForAno)
				ElseIf nTipo == 6
				dInicio := CtoD("01/"+If(Month(dInicio)+6<=12,StrZero(Month(dInicio)+6,2)+;
				"/"+Substr(Str(Year(dInicio),4),nPosAno,nTamAno),"01/"+Substr(Str(Year(dInicio)+1,4),nPosAno,nTamAno)),cForAno)
				EndIf
			Next i
		ElseIf nTipo == 7
		//Seleciona periodos variaveis se nao for visualizacao
			If !lVisualiza
			A712Diver()
			EndIf
			For i:=1 to Len(aDiversos)
			AADD(aPeriodos, StoD(DtoS(CtoD(aDiversos[i])),cForAno) )
			Next
		Endif


Return
