#INCLUDE "rwmake.ch"
#INCLUDE "TOPCONN.ch"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RDEMFRE   º Autor ³ Eduardo Barbosa    º Data ³  27/01/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Demonstrativo do Calculo de Frete                          º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ ESPECIFICO DeltaDecisao                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function RDEMFRE()

PRIVATE aOrd := {}
PRIVATE cDesc1         := "Relatorio demonstrativo do Calculo de Frete "
PRIVATE cDesc2         := ""
PRIVATE cDesc3         := ""
Private lEnd           := .F.
Private lAbortPrint    := .F.
Private limite         := 220
Private tamanho        := "G"
Private nomeprog       := "RDEMFRE"
Private nTipo          := 18
Private aReturn        := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey       := 0
Private cPerg          := PADR("RDFRENEW",10)
Private titulo         := "Frete Por Regiao"
Private nLin           := 56
Private Cabec1         := ""
Private Cabec2         := ""
PRIVATE imprime        := .T.
Private wnrel          := "RDEMFRE"
Private cString        := "SF2"
Private m_pag          := 01
Private cbCont		   := ' '
Private cbTxt		   := ' '

VALIDPERG()
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
RptStatus({|| fImpFat()},,"Selecionando informacoes...")

Return


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³FIMPFAT   º Autor ³ AP6 IDE            º Data ³  24/07/03   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS º±±
±±º          ³ monta a janela com a regua de processamento.               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function FIMPFAT()

Titulo := Alltrim(Titulo) + IIF(MV_PAR11= 1,' - Apenas CIF',' ')
Titulo := Alltrim(Titulo) + IIF(MV_PAR11= 2,' - Apenas Redespacho','')
Titulo := Alltrim(Titulo) + IIF(MV_PAR11= 3,' - CIF e Redespachos','')

Cabec1	:=	"                  Nota Fiscal                     |                      Cliente                    |                Frete                    |"
Cabec2	:=	"Numero    Ser          Valor       Peso Emissao   |Codigo Lj Nome                     EST CEP       |     Calculado  Percentual    Vlr.Fre Kg |Transportador                 | Vendedor "
//          "999999999 XXX 999,999,999.99 999,999.99 99/99/9999 999999 99 xxxxxxxxxxxxxxxxxxxxxxxx xx  99999-999   99,999,999.99     999.99%    999,999.99  xxxxxx - xxxxxxxxxxxxxxxxxxxx   xxx-xxxxxxxxxxxxxxxxxxxx
//          "123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012
//                     1         2         3         4         5         6         7         8         9        10        11        12        13         14        15        16        17       18        19        20         21       22

cQuery := " SELECT F2_EMISSAO,F2_VEND1,F2_TRANSP,F2_DOC,F2_SERIE, F2_VALBRUT,F2_PBRUTO,F2_VALCON,F2_EST,F2_CLIENTE,F2_LOJA"
cQuery += " FROM "+RETSQLNAME('SF2')+" SF2 "
cQuery += " WHERE F2_FILIAL='"+xFilial("SF2")+"'"
cQuery += " AND  F2_DOC    >='"+MV_PAR01+"' AND F2_DOC<='"+MV_PAR02+"'"
cQuery += " AND  F2_TRANSP >='"+MV_PAR03+"' AND F2_TRANSP<='"+MV_PAR04+"'"
cQuery += " AND  F2_EMISSAO>='"+DTOS(MV_PAR05)+"' AND F2_EMISSAO<='"+DTOS(MV_PAR06)+"'"
cQuery += " AND  F2_VEND1  >='"+MV_PAR07+"' AND F2_VEND1<='"+MV_PAR08+"'"
cQuery += " AND  F2_EST    >='"+MV_PAR09+"' AND F2_EST<='"+MV_PAR10+"'"
cQuery += " AND  F2_CLIENTE>='"+MV_PAR14+"' AND F2_CLIENTE<='"+MV_PAR15+"'"
cQuery += " AND  F2_TIPO ='N'"
cQuery += " AND  SF2.D_E_L_E_T_ = ' ' "

If MV_PAR13 == 1
	cQuery += " AND  F2_VALCON > 0 "
Else
	cQuery += " AND  F2_VALCON=0 "
Endif
cQuery +=  " ORDER BY F2_EST,F2_DOC"
If Sele("TRB") <> 0
	DbSelectArea("TRB")
	DbCloseArea()
Endif

TCQUERY cQuery NEW ALIAS "TRB"
TCSETFIELD( "TRB","F2_VALBRUT","N",14,2)
TCSETFIELD( "TRB","F2_PBRUTO","N",14,2)
TCSETFIELD( "TRB","F2_VALCON","N",14,2)
TCSETFIELD( "TRB","F2_EMISSAO","D")

_nCont	:= 2000
SetRegua(_nCont)
nLin		:= 80
DbSelectarea("TRB")
DbGoTop()


_nTotVlBr	:= 0
_nTotFret	:= 0
_nTotPeso	:= 0

_cEst	:= TRB->F2_EST

While ! Eof()
	IncRegua()
	If lAbortPrint
		@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
		Exit
	Endif
	_lPula	:= .F.
	
	// Verifica se Nota Fiscal Atualiza Estoque
	
	DbSelectArea("SD2")
	DbSetOrder(3)
	DbSeek(xFilial("SD2")+TRB->F2_DOC+TRB->F2_SERIE+TRB->F2_CLIENTE+TRB->F2_LOJA,.F.)
	
	DbSelectArea("SF4")
	DbSetOrder(1)
	DbSeek(xFilial("SF4")+SD2->D2_TES,.F.)
	
	//If SF4->F4_ESTOQUE <>'S' .AND. SD2->D2_COD<>'ESP000'
	//	_lPula := .T.
	//Endif
	
	DbSelectArea("SC5")
	dbSetOrder(1)
	DbSeek(xFilial("SC5")+SD2->D2_PEDIDO,.F.)
	
	//If SC5->C5_TPFRETE =='F' .AND. EMPTY(SC5->C5_REDESP)
	//   _lPula := .T.
	//Endif   
	
	//If MV_PAR11 <> 3 .AND. ! _lPula // Geral
	//	_lRedesp:= .F.
	//	
	//	DbSelectArea("SC5")
	//	dbSetOrder(1)
	//	DbSeek(xFilial("SC5")+SD2->D2_PEDIDO,.F.)
	//	If ! Empty(SC5->C5_REDESP)
	//		_lRedesp	:= .T.
	//	Endif
	//	If MV_PAR11 == 1 .AND. _lRedesp // Sem Redespacho
	//		_lPula := .T.
	//	Elseif MV_PAR11 == 2 .AND. !_lRedesp //Apenas Redespacho
	//		_lPula := .T.
	//	Endif
				
//	Endif
	
	
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Impressao do cabecalho do relatorio. . .                            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If nLin > 55
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 9
	Endif
	// Posicionamento do Transportador
	DbSelectArea("SA4")
	DbSetOrder(1)
	DbSeek(xFilial("SA4")+TRB->F2_TRANSP,.F.)
	
	// Posicionamento do representante
	DbSelectArea("SA3")
	DbSetOrder(1)
	DbSeek(xFilial("SA3")+TRB->F2_VEND1,.F.)
	
	DbSelectArea("SA1")
	DbSetOrder(1)
	DbSeek(xFilial("SA1")+TRB->F2_CLIENTE+TRB->F2_LOJA,.F.)
	
	If ! _lPula .And. MV_PAR12 == 1               // Incluído por Rafael Godoy em 05/06/04
		nCol := 0
		@ nLin,nCol PSAY RIGHT(TRB->F2_DOC,9)
		@ nLin,nCol+=10 PSAY TRB->F2_SERIE
		@ nLin,nCol+=04 PSAY TRB->F2_VALBRUT Picture "@E 999,999,999.99"
		@ nLin,nCol+=15 PSAY TRB->F2_PBRUTO  Picture "@E 999,999.99"
		@ nLin,nCol+=11 PSAY TRB->F2_EMISSAO //99/99/9999
		@ nLin,nCol+=11 PSAY TRB->F2_CLIENTE
		@ nLin,nCol+=07 PSAY TRB->F2_LOJA
		@ nLin,nCol+=03 PSAY LEFT(SA1->A1_NOME,24)
		@ nLin,nCol+=25 PSAY TRB->F2_EST
		@ nLin,nCol+=04 PSAY SA1->A1_CEP     Picture "@R 99999-999"
		@ nLin,nCol+=10 PSAY TRB->F2_VALCON	Picture "@E 999,999,999.99"
		@ nLin,nCol+=15 PSAY TRB->(F2_VALCON/F2_VALBRUT)*100  Picture "@E 999,999.99%"
		@ nLin,nCol+=13 PSAY TRB->(F2_VALCON/F2_PBRUTO)       Picture "@E 999,999.99"
		@ nlin,nCol+=15 PSAY SA4->(Alltrim(A4_COD)+"-"+Left(A4_NOME,23))
		@ nlin,nCol+=32 PSAY SA3->(Alltrim(A3_COD)+"-"+Left(A3_NOME,23))
		nLin++
		_nTotVlBr	:= _nTotVlBr + TRB->F2_VALBRUT
		_nTotFret	:= _nTotFret + TRB->F2_VALCON
		_nTotPeso	:= _nTotPeso + TRB->F2_PBRUTO
	Elseif ! _lPula .And. MV_PAR12 <> 1
		_nTotVlBr	:= _nTotVlBr + TRB->F2_VALBRUT
		_nTotFret	:= _nTotFret + TRB->F2_VALCON
		_nTotPeso	:= _nTotPeso + TRB->F2_PBRUTO
	Endif
	
	DbSelectArea("TRB")
	DbSkip()
	If  EOF()
		nLin := nLin + 1
		@ nLin,001 PSAY "Total Geral"
		@ nLin,014 PSAY _nTotVlBr Picture "@E 999,999,999.99"
		@ nLin,029 PSAY _nTotPeso Picture "@E 999,999.99"
		@ nLin,100 PSAY _nTotFret Picture "@E 999,999,999.99"
		@ nLin,119 PSAY (_nTotFret)/(_nTotVlBr)*100 Picture "@E 999.99%"
		@ nLin,128 PSAY (_nTotFret)/(_nTotPeso)     Picture "@E 999,999.99"
		nLin := nLin + 2
		_nTotPeso	:= 0
		_nTotVlBr	:= 0
		_nTotFret	:= 0
		_cEst	:= TRB->F2_EST
		
	Endif
	
Enddo
@ nLin,001 PSAY "."  // Forca aImpressora imprimir a ultima linha

TRB->(DbCloseArea())
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Finaliza a execucao do relatorio...                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
SET DEVICE TO SCREEN
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Se impressao em disco, chama o gerenciador de impressao...          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If aReturn[5]==1
	dbCommitAll()
	SET PRINTER TO
	OurSpool(wnrel)
Endif
MS_FLUSH()
Return




/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³VALIDPERG ³ Autor ³  Fernando Bombardi    ³ Data ³ 05/05/03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Verifica as perguntas incluindo-as caso nao existam		  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Relatorio RFAT27                                           ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function VALIDPERG()

//Grupo/Ordem/Pergunta/Perg.Esp./Perg.English/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/DefEsp01/DefEng01/Cnt01/Var02/Def02/DefEsp02/DefEng02/Cnt02/Var03/Def03/DefEsp03/DefEng03/Cnt03/Var04/Def04/DefEsp04/DefEng04/Cnt04/Var05/Def05/DefEsp05/DefEng05/Cnt05/F3/GRPSXG
PutSx1(cPerg,"01","Nota De          ?","","","mv_ch1","C",09,00,0,"G","","","","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","","")
PutSx1(cPerg,"02","Nota Ate         ?","","","mv_ch2","C",09,00,0,"G","","","","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","","")
PutSx1(cPerg,"03","Transportador De ?","","","mv_ch3","C",06,00,0,"G","","SA4","","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","","")
PutSx1(cPerg,"04","Transportador Ate?","","","mv_ch4","C",06,00,0,"G","","SA4","","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","","")
PutSx1(cPerg,"05","Emissao De       ?","","","mv_ch5","D",08,00,0,"G","","","","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","",""," ","")
PutSx1(cPerg,"06","Emissao Ate      ?","","","mv_ch6","D",08,00,0,"G","","","","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","",""," ","")
PutSx1(cPerg,"07","Representante De ?","","","mv_ch7","C",06,00,0,"G","","SA3","","","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","","","")
PutSx1(cPerg,"08","Representante Ate?","","","mv_ch8","C",06,00,0,"G","","SA3","","","mv_par08","","","","","","","","","","","","","","","","","","","","","","","","","","")
PutSx1(cPerg,"09","Estado De        ?","","","mv_ch9","C",02,00,0,"G","","12","","","mv_par09","","","","","","","","","","","","","","","","","","","","","","","","","","")
PutSx1(cPerg,"10","Estado Ate       ?","","","mv_chA","C",02,00,0,"G","","12","","","mv_par10","","","","","","","","","","","","","","","","","","","","","","","","","","")
PutSx1(cPerg,"11","Tipo Relatorio   ?","","","mv_chB","N",01,00,1,"C","","","","","mv_par11","CIF","","","","Redespacho","","","Ambos","","","","","","","","","","","","","","","")
PutSx1(cPerg,"12","Impressao        ?","","","mv_chC","N",01,00,1,"C","","","","","mv_par12","Analítico","","","","Sintético","","","","","","","","","","","","","","","","","","","","")
PutSx1(cPerg,"13","Tipo Frete       ?","","","mv_chD","N",01,00,1,"C","","","","","mv_par13","Calculado","","","","Nao Calculado","","","","","","","","","","","","","","","","","","","","")
PutSx1(cPerg,"14","Cliente De       ?","","","mv_chE","C",06,00,0,"G","","SA1","","","mv_par14","","","","","","","","","","","","","","","","","","","","","","","","","","")
PutSx1(cPerg,"15","Cliente Ate      ?","","","mv_chF","C",06,00,0,"G","","SA1","","","mv_par15","","","","","","","","","","","","","","","","","","","","","","","","","","")

Return Nil
