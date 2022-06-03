#INCLUDE "rwmake.ch"
#INCLUDE "TOPCONN.ch"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณPROVFRE   บ Autor ณ Eduardo Barbosa    บ Data ณ  30/05/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Geracao de dados Para provisao de Frete                    บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ ESPECIFICO DeltaDecisao                                          บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function PROVFRE()

	PRIVATE aOrd := {}
	PRIVATE cDesc1         := "Este Relatorio ira demonstrar o Saldo de Frete "
	PRIVATE cDesc2         := "Provisionado de Acordo com os parametros selecionados"
	PRIVATE cDesc3         := ""
	Private lEnd           := .F.
	Private lAbortPrint    := .F.
	Private limite         := 80
	Private tamanho        := "P"
	Private nomeprog       := "PROVFRE"
	Private nTipo          := 18
	Private aReturn        := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
	Private nLastKey       := 0
	Private cPerg          := "PRVFRE"
	Private titulo         := "Saldo de Frete Para Provisao"
	Private nLin           := 56
	Private Cabec1         := ""
	Private Cabec2         := ""
	PRIVATE imprime        := .T.
	Private wnrel          := "PROVFRE"
	Private cString        := "SF2"
	Private m_pag          := 01
	Private cbCont		   := ' '
	Private cbTxt		   := ' '

	ValidPerg(cPerg)
	pergunte(cPerg,.F.)

	wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.T.,Tamanho,,.F.)

	If nLastKey == 27
		Return
	Endif

	SetDefault(aReturn,cString)

	If nLastKey == 27
		Return
	Endif

	nTipo := If(aReturn[4]==1,15,18)
	RptStatus({|| fImpPROV()},,"Selecionando informacoes...")

Return


/*/
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	ฑฑฑฑฑฑฑฑ
	ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
	ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
	ฑฑบFuno    ณFIMPPROV บ Autor ณ AP6 IDE            บ Data ณ  24/07/03   บฑฑ
	ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
	ฑฑบDescrio ณ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS บฑฑ
	ฑฑบ          ณ monta a janela com a regua de processamento.               บฑฑ
	ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
	ฑฑบUso       ณ Programa principal                                         บฑฑ
	ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
	ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
	฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

Static Function FIMPPROV()

	cQuery := " SELECT F2_FILIAL,F2_DOC,F2_SERIE,F2_CLIENTE,F2_LOJA,F2_TRANSP,F2_EMISSAO "
	cQuery += " FROM " + RetSqlName("SF2")
	cQuery += " WHERE F2_FILIAL='"+xFilial("SF2")+"' "
	cQuery += " AND F2_TIPO='N' "
	cQuery += " AND F2_DOC    >='"+MV_PAR01+"'"
	cQuery += " AND F2_DOC 	  <='"+MV_PAR02+"'"
	cQuery += " AND F2_TRANSP >='"+MV_PAR03+"'"
	cQuery += " AND F2_TRANSP <='"+MV_PAR04+"'"
	cQuery += " AND F2_EMISSAO >='"+DTOS(MV_PAR05)+"'"
	cQuery += " AND F2_EMISSAO <='"+DTOS(MV_PAR06)+"'"
	cQuery += " AND F2_PRVFRE  > 0 "
	cQuery += " AND D_E_L_E_T_=' '  "
	cQuery += " ORDER BY F2_FILIAL,F2_TRANSP,F2_EMISSAO,F2_DOC,F2_SERIE,F2_CLIENTE,F2_LOJA"
	cQuery := ChangeQuery(cQuery)
	If Select("QRY")>0
		DbSelectArea("QRY")
		DbCloseArea()
	Endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"QRY",.T.,.T.)

	Cabec1	:=	"   Data    Nota Fiscal  Serie  UF      Valor NF        Provisao    C.Custo"

	nLin		:= 80
	_cTransp 	:= ' '
	_nSubProv 	:= 0
	_nTotProv	:= 0
	_nSubNota	:= 0
	_nTotNota	:= 0

	SetRegua(2500)
	DbSelectArea("QRY")
	DbGoTop()

	While ! Eof()
		IncRegua()
		If lAbortPrint
			@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
			Exit
		Endif
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Impressao do cabecalho do relatorio. . .                            ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		If nLin > 65
			nLin := Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin++
		Endif

		DbSelectArea("SF2")
		DbSetOrder(1)
		DbSeek(xFilial("SF2")+QRY->(F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA),.F.)

		// Valida se a Fatura ja foi Liberada
		DbSelectArea("PAV")
		DbSetOrder(2)  // Conhecimento + Transportador + Fatura + Nota Fiscal
		DbSeek(xFilial("PAV") + SF2->F2_CONHECI+Space(3) +SF2->F2_TRANSP + Left(SF2->F2_FATURA,6)+SF2->F2_DOC,.F.)
		DbSelectArea("SF2")
		If Empty(PAV->PAV_LIBERA) .OR. SF2->F2_DTCON > MV_PAR06
			If QRY->F2_TRANSP <> _cTransp
				_cTransp		:= SF2->F2_TRANSP
				_cNomeTra	:= Posicione("SA4",1,xFilial("SA4")+_cTransp,"A4_NOME")
				@ nLin,001 PSAY "Transportadora : "+_cTransp +" - "+_cNomeTra
				nLin	:= nLin + 2
			Endif
			If MV_PAR07 == 1 // Relatorio Analitico
				@ nLin,001 PSAY DTOC(SF2->F2_EMISSAO)
				@ nLin,013 PSAY SF2->F2_DOC
				@ nLin,025 PSAY SF2->F2_SERIE
				@ nLin,031 PSAY	SF2->F2_EST
				@ nLin,038 PSAY Transform(SF2->F2_VALBRUT,"@E 999,999.99")
				@ nLin,053 PSAY Transform(SF2->F2_PRVFRE,"@E 999,999.99")
				nLin++
			Endif
			_nSubProv 	:= _nSubProv+SF2->F2_PRVFRE
			_nTotProv	:= _nTotProv+SF2->F2_PRVFRE
			_nSubNota	:= _nSubNota+SF2->F2_VALBRUT
			_nTotNota	:= _nTotNota+SF2->F2_VALBRUT
		Endif
		DbSelectarea("QRY")
		DbSkip()
		If QRY->F2_TRANSP <> _cTransp .OR. EOF()
			@ nLin,001 PSAY "S U B   T O T A L ----> "
			@ nLin,036 PSAY Transform(_nSubNota,"@E 9,999,999.99")
			@ nLin,051 PSAY Transform(_nSubProv,"@E 9,999,999.99")
			nLin++
			@ nLin,001 PSAY Replicate("-",80)
			nLin	:= nLin + 2
			_cTransp		:= SF2->F2_TRANSP
			_nSubProv 	:= 0
			_nSubReal	:= 0
			_nSubNota	:= 0
		Endif
	Enddo

	If _nTotProv > 0
		@ nLin,001 PSAY "T O T A L   G E R A L ----> "
		@ nLin,036 PSAY Transform(_nTotNota,"@E 9,999,999.99")
		@ nLin,051 PSAY Transform(_nTotProv,"@E 9,999,999.99")
		nLin	:= nLin + 2
	Endif

	QRY->(DbCloseArea())


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Finaliza a execucao do relatorio...                                 ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	SET DEVICE TO SCREEN
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Se impressao em disco, chama o gerenciador de impressao...          ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

	If aReturn[5]==1
		dbCommitAll()
		SET PRINTER TO
		OurSpool(wnrel)
	Endif
	MS_FLUSH()
Return


/*/
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
	ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
	ฑฑณFun…o    ณVALIDPERG ณ Autor ณ  Fernando Bombardi    ณ Data ณ 05/05/03 ณฑฑ
	ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
	ฑฑณDescri…o ณ Verifica as perguntas incluindo-as caso nao existam		  ณฑฑ
	ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
	ฑฑณUso       ณ Relatorio RFAT27                                           ณฑฑ
	ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
	ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
	฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

Static Function VALIDPERG(cPerg)

	cPerg := PADR(cPerg,6)

//Grupo/Ordem/Pergunta/Perg.Esp./Perg.English/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/DefEsp01/DefEng01/Cnt01/Var02/Def02/DefEsp02/DefEng02/Cnt02/Var03/Def03/DefEsp03/DefEng03/Cnt03/Var04/Def04/DefEsp04/DefEng04/Cnt04/Var05/Def05/DefEsp05/DefEng05/Cnt05/F3/GRPSXG
	PutSx1(cPerg,"01","Nota de          ?","","","mv_ch1","C",09,00,0,"G","","","","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","","")
	PutSx1(cPerg,"02","Nota Ate         ?","","","mv_ch2","C",09,00,0,"G","","","","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","","")
	PutSx1(cPerg,"03","Transportador de ?","","","mv_ch3","C",06,00,0,"G","","SA4","","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","","")
	PutSx1(cPerg,"04","Transportador Ate?","","","mv_ch4","C",06,00,0,"G","","SA4","","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","","")
	PutSx1(cPerg,"05","Emissao de       ?","","","mv_ch5","D",08,00,0,"G","","","","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","",""," ","")
	PutSx1(cPerg,"06","Emissao Ate      ?","","","mv_ch6","D",08,00,0,"G","","","","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","",""," ","")
	PutSx1(cPerg,"07","Tipo Relatorio   ?","","","mv_ch7","N",01,00,1,"C","","","","","mv_par07","Analitico","","","","Sintetico","","","Ambos","","","","","","","","","","","","","","","")

Return Nil