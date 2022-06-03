#Include 'Protheus.ch'
#INCLUDE "rwmake.ch"

#DEFINE ENTER Chr(13)+Chr(10)

/*/
+---------------------------------------------------------------------------+
| Programa  | ESTZERAINV | Autor | Cristiano G. Cunha     | Data | 08/03/05 |
|-----------+---------------------------------------------------------------|
| Descrição | Rotina de criação de registros de inventário (SB7) para       |
|           | produtos não inventariados.                                   |
|-----------+---------------------------------------------------------------|
| Uso       |                                                               |
+---------------------------------------------------------------------------+
/*/

User Function ESTZERAINV()

Local aClassPed:={"PROART","TAIFF"}
Local oPesqCbx	:= Nil

Private _CDOC  := Space(08)
Private _dData := dDataBase
Private cLocal := Space(02)
Private cEnder := SPAC(15)
Private cLinha := SPAC(10)

////GRAVA DADOS DA ROTINA UTILIZADA
//U_CFGRD001("ZERAINV")

//Pergunte("ZERAES",.T.)
@ 05,00 TO 270,500 DIALOG oDlg TITLE "Criacao de Registros Zerados"
@ 05,10 TO 100,240
@ 14,40 SAY "Este programa tem como objetivo criar  registros"
@ 24,40 SAY "zerados no Cadastro de Inventario (SB7) para que"
@ 34,40 SAY "quando for efetuado o Acerto do  Inventario,  os"
@ 44,40 SAY "produtos NAO INVENTARIADOS sejam zerados.       "
@ 54,40 SAY "Data Invent.: "
@ 54,80 GET _dData Size 30,15
@ 68,40 SAY "Documento: "
@ 68,80 GET _cDoc Size 30,15 Picture "XXXXXX"
@ 68,120 SAY "Local: "
@ 68,160 GET cLocal Size 20,15 Picture "XX"
@ 82,40 SAY "Endereco: "
@ 82,80 GET cEnder Size 30,15 Picture "@!"
@ 82,120 SAY "Linha: "
@ 82,160 COMBOBOX oPesqCbx VAR cLinha ITEMS aClassPed SIZE 60,12 PIXEL OF oDlg


@ 104,184 BMPBUTTON TYPE 1 ACTION C010PRO()
@ 104,213 BMPBUTTON TYPE 2 ACTION Close(oDlg)
ACTIVATE DIALOG oDlg CENTERED

Return



/*/
+---------------------------------------------------------------------------+
| Função    | C010PRO    | Autor | Cristiano G. Cunha     | Data | 08/03/05 |
|-----------+---------------------------------------------------------------|
| Descrição | Rotina de processamento.                                      |
|-----------+---------------------------------------------------------------|
| Uso       | Específico Cheminova                                          |
+---------------------------------------------------------------------------+
/*/

Static Function C010PRO()
Processa( { |lEnd| ZERAR_B7() } )
Return



/*/
+---------------------------------------------------------------------------+
| Função    | ZERAR_B7   | Autor | Cristiano G. Cunha     | Data | 08/03/05 |
|-----------+---------------------------------------------------------------|
| Descrição | Rotina de processamento do zeramento dos dados no SB7.        |
|-----------+---------------------------------------------------------------|
| Uso       | Específico Cheminova                                          |
+---------------------------------------------------------------------------+
/*/

Static Function ZERAR_B7()

nArq := FCreate("ZERA_EST.ERR",0)   // cria arquivo de LOG
xLog := "Log das Ocorrencias encontradas no processo de Zeramento"
xGravaLog()
xLog := space(79)
xGravaLog()
xLog := "Processo terminado com sucesso...                       "

cQuery := " SELECT * FROM "+RetSqlName("SBF")+" "+ ENTER
cQuery += " WHERE BF_LOCAL = '" + cLocal + "'"+ ENTER
cQuery += " AND BF_FILIAL = '"+xFilial("SBF")+"'"+ ENTER
cQuery += " AND BF_LOCALIZ = '" + cEnder +"'"+ ENTER
cQuery += " AND D_E_L_E_T_ <> '*'"+ ENTER

MEMOWRITE("ZERAINV.SQL",cQuery)
dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),"TRB1", .F., .T.)

Count To nRec

ProcRegua(nRec)

dbSelectArea("TRB1")
dbGoTop()
_nCont := 0

While !Eof()
	_nCont++
	IncProc("Processando "+StrZero(_nCont,6)+" de "+StrZero(nRec,6))
	
	dbSelectArea("SB1")
	SB1->(dbSetOrder(1))
	SB1->(dbSeek(xFilial("SB1") + TRB1->BF_PRODUTO))
	If SB1->B1_ITEMCC = cLinha 		
		dbSelectArea("SB7")
		_cChvSB7 := xFilial() + DtoS(_dData) + TRB1->BF_PRODUTO + TRB1->BF_LOCAL  + TRB1->BF_LOCALIZ
		If SB7->(dBSeek(_cChvSB7))
			xLog := _cChvSB7 + " ENCONTRADO NO B7 - IGNORADO"
			xGravaLog()
		Else
			xLog := _cChvSB7 + " ** NAO ** ENCONTRADO NO B7 - CRIADO"
			RecLock("SB7",.T.)
			_nCont++
			SB7->B7_FILIAL  := xFilial("SB7")
			SB7->B7_COD     := TRB1->BF_PRODUTO
			SB7->B7_TIPO    := SB1->B1_TIPO
			SB7->B7_DOC     := _cDoc
			SB7->B7_QUANT   := 0
			SB7->B7_DATA    := _dData
			SB7->B7_DTVALID := _dData
			SB7->B7_LOCAL   := TRB1->BF_LOCAL
			SB7->B7_LOCALIZ := TRB1->BF_LOCALIZ
			SB7->(MSUnLock())
		EndIf
	EndIf
	dbSelectArea("TRB1")
	TRB1->(dBSkip())
EndDo
TRB1->(dbCloseArea())
xGravaLog()

Close(oDlg)

Return


/*/
+---------------------------------------------------------------------------+
| Função    | xGravaLog  | Autor | Cristiano G. Cunha     | Data | 08/03/05 |
|-----------+---------------------------------------------------------------|
| Descrição | Rotina de gravação do Log de processamento.                   |
|-----------+---------------------------------------------------------------|
| Uso       | Específico Cheminova                                          |
+---------------------------------------------------------------------------+
/*/

Static Function xGravaLog()
FWRITE(nARQ,xLog + Chr(10))
Return