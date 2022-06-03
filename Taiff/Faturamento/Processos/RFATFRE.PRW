#INCLUDE "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRFATFRE   บ Autor ณ Eduardo Barbosa    บ Data ณ  27/01/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Demonstrativo da Fatura de  Cobranca de Frete              บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ ESPECIFICO DeltaDecisao                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function RFATFRE()

PRIVATE aOrd := {}
PRIVATE cDesc1         := "Relatorio demonstrativo da Fatura "
PRIVATE cDesc2         := "de Cobranca de Frete"
PRIVATE cDesc3         := ""
Private lEnd           := .F.
Private lAbortPrint    := .F. 
Private limite         := 220
Private tamanho        := "G"
Private nomeprog       := "RFATFRE"
Private nTipo          := 18
Private aReturn        := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey       := 0
Private cPerg          := PADR("RFATFRE",10)
Private titulo         := "Demonstrativo da Fatura de Cobranca de Frete"
Private nLin           := 56
Private Cabec1         := ""
Private Cabec2         := ""
PRIVATE imprime        := .T.
Private wnrel          := "RFATFRE" 
Private cString        := "PAV"
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
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณFIMPFAT   บ Autor ณ AP6 IDE            บ Data ณ  24/07/03   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS บฑฑ
ฑฑบ          ณ monta a janela com a regua de processamento.               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Programa principal                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

Static Function FIMPFAT()

Cabec1	:=	"              Nota Fiscal         |                            Cliente                             |                     Frete                  |                     Composicao do Frete                       |" 
Cabec2	:=	" Numero    Ser      Valor     Peso|Codigo Lj Nome                      Municipio       EST CEP     |    Calculado      Cobrado Diferenc   Ajuste|Ad.Valor  Pedagio  Tx.Cto    Gris    Vl Peso Tonelada  Otr.Txa |Conhecim."

//          " 999999 XXX 99,999.99  9,999.99 999999 99 xxxxxxxxxxxxxxxxxxxxxxxx xxxxxxxxxxxxxxxxxxxx  xx 99999-999 99,999.99 99,999.99 9,999.99 9,999.99  999.99 999.99 999.99  9,999.99 9,999.99 9,999.99
//          " 123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
//                    1         2         3         4         5         6         7         8         9        10        11        12        13        14        15        16        17        18        19        20        21

DbSelectArea("PAV")
_cChave	:= "PAV_CODTRA+PAV_FATURA"
_cFiltro:= "PAV_FATURA >= '"+MV_PAR01+"' .AND. PAV_FATURA<='"+MV_PAR02+"' "
_cFiltro:= _cFiltro+".AND. PAV_CODTRA >='"+MV_PAR03+"' .AND. PAV_CODTRA <= '"+MV_PAR04+"' "
_cFiltro:= _cFiltro+".AND. DTOS(PAV_EMISFA) >='"+DTOS(MV_PAR05)+"' .AND. DTOS(PAV_EMISFA) <='"+DTOS(MV_PAR06)+"'"
_cFiltro:= _cFiltro+".AND. DTOS(PAV_VENCFA) >='"+DTOS(MV_PAR07)+"' .AND. DTOS(PAV_VENCFA) <='"+DTOS(MV_PAR08)+"'"
_cFiltro:= _cFiltro+".AND. PAV_FILIAL ='" + xFilial("PAV") + "'"

_cArq	:= CriaTrab(,.F.)
IndRegua("PAV",_cArq,_cChave,,_cFiltro,"Selecionando Registros",.T.)

_nCont	:= RecCount()
SetRegua(_nCont)
nLin		:= 80
_nTotCalc	:= 0
_nTotTran	:= 0
_nTotAjus	:= 0
_cFatura	:= PAV->PAV_FATURA
_cTransp	:= PAV_CODTRA
_lTransp	:= .T.
_nTotDesc	:= 0

While ! Eof() 
	IncRegua()
	If lAbortPrint
		@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
		Exit
	Endif
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Impressao do cabecalho do relatorio. . .                            ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If nLin > 55 
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 9
	Endif
    If _lTransp
	    // Posicionamento do Transportador
	    DbSelectArea("SA4")
	    DbSetOrder(1)
	    DbSeek(xFilial("SA4")+PAV->PAV_CODTRA,.F.)
	    @ nLin,001 PSAY "Transp.: "+PAV->PAV_CODTRA+" - "+SA4->A4_NOME
	    nLin++
	    @ nLin,001 PSAY "Fatura : "+PAV->PAV_FATURA+" Emissao: "+DTOC(PAV->PAV_EMISFA)+" Vencimento: "+DTOC(PAV->PAV_VENCFA)   
	    nLin := nLin + 2
	    _lTransp := .F.
    Endif

	
	// Posicionamento na Nota Fiscal
	DbSelectArea("SF2")
	DbSetOrder(1)
	DbSeek(xFilial("SF2")+PAV->PAV_NF+PAV->PAV_SERIE,.F.)
	
	// Posicionamento no Cliente
	DbSelectArea("SA1")
	DbSetOrder(1)
	DbSeek(xFilial("SA1")+SF2->F2_CLIENTE+SF2->F2_LOJA,.F.)
    
	nCol := 1
    @ nLin,nCol 	 PSAY PAV->PAV_NF
    @ nLin,nCol+=010 PSAY PAV->PAV_SERIE
    @ nLin,nCol+=004 PSAY SF2->F2_VALBRUT Picture "@E 999,999.99"
    @ nLin,nCol+=011 PSAY SF2->F2_PBRUTO  Picture "@E 9,999.99"
    @ nLin,nCol+=009 PSAY SA1->A1_COD
    @ nLin,nCol+=007 PSAY SA1->A1_LOJA
    @ nLin,nCol+=003 PSAY LEFT(SA1->A1_NOME,25)
    @ nLin,nCol+=026 PSAY LEFT(SA1->A1_MUN,15)
    @ nLin,nCol+=016 PSAY SA1->A1_EST
    @ nLin,nCol+=004 PSAY SA1->A1_CEP     Picture "99999-999"
    @ nLin,nCol+=010 PSAY PAV->PAV_FRCALC	Picture "@E 9,999,999.99"
    @ nLin,nCol+=013 PSAY PAV->PAV_FRETRA Picture "@E 9,999,999.99"
    @ nLin,nCol+=013 PSAY PAV->PAV_DESCON Picture "@E 9,999.99"
    @ nLin,nCol+=009 PSAY PAV->PAV_AJUST Picture "@E 9,999.99"
    @ nLin,nCol+=009 PSAY PAV->PAV_ADVALO Picture "@E 9,999.99"
    @ nLin,nCol+=011 PSAY PAV->PAV_VLRPED Picture "@E 999.99"
    @ nLin,nCol+=008 PSAY PAV->PAV_TXACTO Picture "@E 999.99"
    @ nLin,nCol+=008 PSAY PAV->PAV_VLGRIS Picture "@E 999.99"
    @ nLin,nCol+=008 PSAY PAV->(PAV_ADPESO+PAV_TXPESO+PAV_VLPESO) Picture "@E 99,999.99"
    @ nLin,nCol+=009 PSAY PAV->PAV_FRETOL Picture "@E 99,999.99"
    @ nLin,nCol+=010 PSAY PAV->PAV_OTRTXA  Picture "@E 9,999.99"
	@ nLin,nCol+=010 PSAY PAV->PAV_CTO
	//@ nLin,205 PSAY SA1->A1_CCC
	  
	nLin++
	_nTotCalc   := _nTotCalc + PAV->PAV_FRCALC
	_nTotTran	:= _nTotTran + PAV->PAV_FRETRA
	_nTotAjus	:= _nTotAjus + PAV->PAV_AJUST
	_nTotDesc	:= _nTotDesc + PAV->PAV_DESCON
	
	DbSelectArea("PAV")
	DbSkip()
    
    If PAV->PAV_CODTRA + PAV->PAV_FATURA <> _cTransp+_cFatura .OR. EOF()
   	    _lTransp := .T.
	    nLin	:= nLin + 2
		nCol    := 1
	    @ nLin,nCol+=86 PSAY "Total Fatura "
	    @ nLin,nCol+=14 PSAY _nTotCalc	Picture "@E 9,999,999.99"
    	@ nLin,nCol+=13 PSAY _nTotTran   Picture "@E 9,999,999.99"
    	@ nLin,nCol+=13 PSAY _nTotDesc   Picture "@E 9,999.99"
    	@ nLin,nCol+=09 PSAY _nTotAjus   Picture "@E 9,999.99"
		_nTotCalc   := 0
		_nTotTran	:= 0
		_nTotAjus   := 0
		_cFatura	:= PAV->PAV_FATURA
		_cTransp	:= PAV->PAV_CODTRA
		_nTotDesc	:= 0
		
        nLin++
        @ nLin,001 PSAY Replicate("-",203)
        nLin := nLin+2
        @ nLin,003 PSAY "APROVADOR : "+Substr(cUsuario,7,15)
         nLin := nLin+3
    Endif

Enddo


RetIndex("PAV")
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

Static Function VALIDPERG()

//Grupo/Ordem/Pergunta/Perg.Esp./Perg.English/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/DefEsp01/DefEng01/Cnt01/Var02/Def02/DefEsp02/DefEng02/Cnt02/Var03/Def03/DefEsp03/DefEng03/Cnt03/Var04/Def04/DefEsp04/DefEng04/Cnt04/Var05/Def05/DefEsp05/DefEng05/Cnt05/F3/GRPSXG
PutSx1(cPerg,"01","Fatura de        ?","","","mv_ch1","C",09,00,0,"G","","","","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","","")
PutSx1(cPerg,"02","Fatura Ate       ?","","","mv_ch2","C",09,00,0,"G","","","","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","","")
PutSx1(cPerg,"03","Transportador de ?","","","mv_ch3","C",06,00,0,"G","","SA4","","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","","")
PutSx1(cPerg,"04","Transportador Ate?","","","mv_ch4","C",06,00,0,"G","","SA4","","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","","")
PutSx1(cPerg,"05","Emissao de       ?","","","mv_ch5","D",08,00,0,"G","","","","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","",""," ","")
PutSx1(cPerg,"06","Emissao Ate      ?","","","mv_ch6","D",08,00,0,"G","","","","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","",""," ","")
PutSx1(cPerg,"07","Vencimento de    ?","","","mv_ch7","D",08,00,0,"G","","","","","mv_par07","","","","","","","","","","","","","","","","","","","","","","","",""," ","")
PutSx1(cPerg,"08","Vencimento Ate   ?","","","mv_ch8","D",08,00,0,"G","","","","","mv_par08","","","","","","","","","","","","","","","","","","","","","","","",""," ","")

Return Nil
