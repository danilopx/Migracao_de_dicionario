#INCLUDE "rwmake.ch"
#INCLUDE "Protheus.ch"
#DEFINE ENTER Chr(13)+Chr(10)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณWMSRL001  บ Autor ณ PAULO BINOD        บ Data ณ  16/02/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ RELATORIO DE PRODUTIVIDADE POR OPERADOR                    บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP6 IDE                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function WMSRL001()
       Local cPerg := "WSRL01"
       Private aOper       := {}
       Private nLocais := 0
       Private nLinhas := 0
       Private nPLinhas:= 0
       Private aPerg	:= {}

       If !MsgYesNo("Este relat๓rio irแ gerar planilha com dados das horas produtivas , deseja continuar?","WMSRL001")
              Return
       EndIf

       ValidPerg(cPerg)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Verifica as perguntas selecionadas  ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
       If Pergunte(cPerg,.T.)
              Processa({|| WSRL1SEP() })
              //Processa({|| WSRL1("P") })
              Processa({|| WSRL1("C") })
              Processa({|| WSRL1EXPORTA() })
       EndIf


Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณWMACOMP   บAutor  ณMicrosiga           บ Data ณ  02/09/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณTELA DE ACOMPANHAMENTO DA SEPARACAO                         บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function WSRL1SEP()

       cQuery := " SELECT CB7_CODOPE , CB1_NOME, CB7_ORDSEP, CB7_STATPA  , " + ENTER
       cQuery += " (SELECT TOP 1 CASE WHEN ((SUBSTRING(CB8_LCALIZ,9,1) > '2' AND LEFT(CB8_LCALIZ,2)= 'PP')OR LEFT(CB8_LCALIZ,2)= 'PI') THEN" + ENTER
       cQuery += " 'EM'" + ENTER
       cQuery += " ELSE" + ENTER
       cQuery += " LEFT(CB8_LCALIZ,2) " + ENTER
       cQuery += " END  FROM "+RetSqlName("CB8")+" WITH(NOLOCK) WHERE CB7_FILIAL = CB8_FILIAL AND CB8_ORDSEP = CB7_ORDSEP AND D_E_L_E_T_ <> '*' ORDER BY CB8_LCALIZ DESC) SETOR," + ENTER
       cQuery += " (SELECT SUM(CB8_QTDORI) FROM "+RetSqlName("CB8")+" WITH(NOLOCK) WHERE CB7_FILIAL = CB8_FILIAL AND CB8_ORDSEP = CB7_ORDSEP AND D_E_L_E_T_ <> '*') PECAS," + ENTER
       cQuery += " (SELECT COUNT(CB8_LCALIZ ) FROM "+RetSqlName("CB8")+" WITH(NOLOCK) WHERE CB7_FILIAL = CB8_FILIAL AND CB8_ORDSEP = CB7_ORDSEP AND D_E_L_E_T_ <> '*') LOCAIS," + ENTER
       cQuery += " (SELECT COUNT(CB8_LCALIZ ) FROM "+RetSqlName("CB8")+" WITH(NOLOCK) WHERE CB7_FILIAL = CB8_FILIAL AND CB8_ORDSEP = CB7_ORDSEP AND D_E_L_E_T_ <> '*' AND CB8_SALDOS = 0) LOCAIS_FEITOS," + ENTER
       cQuery += " CB7_DTINIS  ," + ENTER
       cQuery += " CB7_DTFIMS  ," + ENTER
       cQuery += " SUBSTRING(CB7_HRINIS     ,1,2)+':'+SUBSTRING(CB7_HRINIS     ,3,2) HR_INI, " + ENTER
       cQuery += " SUBSTRING(CB7_HRFIMS      ,1,2)+':'+SUBSTRING(CB7_HRFIMS     ,3,2) HR_FIM" + ENTER
       cQuery += " FROM "+RetSqlName("CB7")+"  CB7 WITH(NOLOCK)" + ENTER
       cQuery += " LEFT JOIN "+RetSqlName("CB1")+" WITH(NOLOCK) ON CB1_FILIAL = CB7_FILIAL AND CB1_CODOPE = CB7_CODOPE " + ENTER
       cQuery += " WHERE " + ENTER
       cQuery += " CB7_DTINIS BETWEEN '"+Dtos(mv_par01)+"' AND '"+Dtos(mv_par02)+"'" + ENTER
       cQuery += " AND CB7_DTFIMS  <> '' " + ENTER
//cQuery += " and CB7_PEDIDO = '' AND CB7_CODOPE <> ''" + ENTER
       cQuery += " and CB7_TIPEXP LIKE '00*02*%' AND CB7_CODOPE <> ''" + ENTER
       cQuery += " AND CB7_FILIAL = '"+cFilAnt+"' AND CB7.D_E_L_E_T_ <> '*'  " + ENTER
       cQuery += " order by LOCAIS DESC" + ENTER

       MemoWrite("WMSRL001.SQL",cQuery)
       dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),"TRBAC", .F., .T.)

       TcSetField('TRBAC','CB7_DTINIS','D')
       TcSetField('TRBAC','CB7_DTFIMS','D')

       Count To nRec1

       If nRec1 == 0
              MsgStop("Nใo existem dados para esta Onda!","Aten็ใo")
              TRBAC->(dbCloseArea())
              Return
       EndIf

//ABRE TELA PARA SELECAO DE PEDIDOS
       dbSelectArea("TRBAC")
       ProcRegua(nRec1)
       dbGotop()

       While !Eof()
              IncProc("Buscando dados separacao")
              nLocais += TRBAC->LOCAIS_FEITOS
              //aOper 01-CODIGO, 02- NOME, 03- LOCAIS,04-PECAS, 05-LOCAIS FEITOS, 06- SETOR, 07- DATA INICIAL, 08-DATA FINAL 09 -HORA INICIAL, 10-DATA FINAL, 11-OPERACAO
              aAdd(aOper,{TRBAC->CB7_CODOPE,TRBAC->CB1_NOME,TRBAC->LOCAIS,TRBAC->PECAS, TRBAC->LOCAIS_FEITOS, TRBAC->SETOR, TRBAC->CB7_DTINIS,TRBAC->CB7_DTFIMS, TRBAC->HR_INI, TRBAC->HR_FIM,"SEPARACAO"})

              dbSelectArea("TRBAC")
              dbSkip()
       End
       TRBAC->(dbCloseArea())
Return



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณWMSEPACOMPบAutor  ณMicrosiga           บ Data ณ  02/09/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณTELA DE ACOMPANHAMENTO DE PRE CHECKOUT                      บฑฑ
ฑฑบ          ณEXP1 - NUMERO ONDA                                          บฑฑ
ฑฑบ          ณEXP2 -P-PRE-CHECKOUT/ C-CHECKOUT                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function WSRL1(cOpc)


       cQuery := " SELECT " + ENTER
       If cOpc == "P"
              cQuery += " CB7__CODOP AS CB7_CODOPE, " + ENTER
       Else
              cQuery += " CB7_CODOPE , " + ENTER
       EndIf
       cQuery += " CB1_NOME, CB7_ORDSEP, CB7_STATPA  , CB7_PEDIDO, CB7_NOTA," + ENTER
       cQuery += " (SELECT SUM(CB8_QTDORI) FROM "+RetSqlName("CB8")+" WITH(NOLOCK) WHERE CB7_FILIAL = CB8_FILIAL AND CB8_ORDSEP = CB7_ORDSEP AND D_E_L_E_T_ <> '*') PECAS," + ENTER
       cQuery += " (SELECT COUNT(CB8_ITEM ) FROM "+RetSqlName("CB8")+" WITH(NOLOCK) WHERE CB7_FILIAL = CB8_FILIAL AND CB8_ORDSEP = CB7_ORDSEP AND D_E_L_E_T_ <> '*') LINHAS," + ENTER
       If cOpc == "P"
              cQuery += " (SELECT COUNT(CB8_ITEM ) FROM "+RetSqlName("CB8")+" WITH(NOLOCK) WHERE CB7_FILIAL = CB8_FILIAL AND CB8_ORDSEP = CB7_ORDSEP AND D_E_L_E_T_ <> '*' AND CB8__SALDO = 0) LINHAS_FEITAS," + ENTER
              cQuery += " CB7__DTINI  ," + ENTER
              cQuery += " CB7__DTFIM  ," + ENTER
              cQuery += " SUBSTRING(CB7__HRINI     ,1,2)+':'+SUBSTRING(CB7__HRINI     ,3,2) HR_INI, " + ENTER
              cQuery += " SUBSTRING(CB7__HRFIM      ,1,2)+':'+SUBSTRING(CB7__HRFIM     ,3,2) HR_FIM" + ENTER
       Else
              cQuery += " (SELECT COUNT(CB8_ITEM ) FROM "+RetSqlName("CB8")+" WITH(NOLOCK) WHERE CB7_FILIAL = CB8_FILIAL AND CB8_ORDSEP = CB7_ORDSEP AND D_E_L_E_T_ <> '*' AND CB8_SALDOS = 0) LINHAS_FEITAS," + ENTER
              cQuery += " CB7_DTINIS CB7__DTINI  ," + ENTER
              cQuery += " CB7_DTFIMS CB7__DTFIM  ," + ENTER
              cQuery += " SUBSTRING(CB7_HRINIS     ,1,2)+':'+SUBSTRING(CB7_HRINIS     ,3,2) HR_INI, " + ENTER
              cQuery += " SUBSTRING(CB7_HRFIMS      ,1,2)+':'+SUBSTRING(CB7_HRFIMS     ,3,2) HR_FIM" + ENTER
       EndIf
       cQuery += " FROM "+RetSqlName("CB7")+"  CB7 WITH(NOLOCK)" + ENTER
       cQuery += " LEFT JOIN "+RetSqlName("CB1")+" WITH(NOLOCK) ON CB1_FILIAL = CB7_FILIAL " + ENTER
       If cOpc == "P"
              cQuery += " AND CB1_CODOPE = CB7__CODOP " + ENTER
       Else
              cQuery += " AND CB1_CODOPE = CB7_CODOPE " + ENTER
       EndIf
       cQuery += " WHERE " + ENTER
//cQuery += " CB7_PEDIDO <> ''"
       cQuery += " CB7_TIPEXP LIKE '00*02*%' " + ENTER
       cQuery += " AND CB7_FILIAL = '"+cFilAnt+"' AND CB7.D_E_L_E_T_ <> '*'  " + ENTER

       If cOpc == "P"
              cQuery += " AND CB7__CODOP <> ''" + ENTER
              cQuery += " AND CB7__DTINI BETWEEN '"+Dtos(mv_par01)+"' AND '"+Dtos(mv_par02)+"'" + ENTER
              cQuery += " AND CB7__DTFIM <> ''"       + ENTER
       Else
              cQuery += " AND CB7_CODOPE <> '' " + ENTER
              cQuery += " AND CB7_DTINIS BETWEEN '"+Dtos(mv_par01)+"' AND '"+Dtos(mv_par02)+"'" + ENTER
              cQuery += " AND CB7_DTFIMS <> ''"       + ENTER
       EndIf

       cQuery += " order by LINHAS DESC" + ENTER

       MemoWrite("WMSRL001A.SQL",cQuery)
       dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),"TRBAC", .F., .T.)

       TcSetField('TRBAC','CB7__DTINI','D')
       TcSetField('TRBAC','CB7__DTFIM','D')

       Count To nRec1

       If nRec1 == 0
              MsgStop("Nใo existem dados para esta Onda!","Aten็ใo")
              TRBAC->(dbCloseArea())
              Return
       EndIf

//ABRE TELA PARA SELECAO DE PEDIDOS
       dbSelectArea("TRBAC")
       ProcRegua(nRec1)
       dbGotop()

       While !Eof()
              IncProc("Buscando dados "+Iif(cOpc=="P","pre-checkout","checkout"))
              If cOpc=="P"
                     nPLinhas += TRBAC->LINHAS_FEITAS
              Else
                     nLinhas += TRBAC->LINHAS_FEITAS
              EndIf
              //aOper 01-CODIGO, 02- NOME, 03- LOCAIS,04-PECAS, 05-LOCAIS FEITOS, 06- SETOR, 07- DATA INICIAL, 08-DATA FINAL 09 -HORA INICIAL, 10-DATA FINAL, 11-OPERACAO
              aAdd(aOper,{TRBAC->CB7_CODOPE,TRBAC->CB1_NOME,TRBAC->LINHAS,TRBAC->PECAS, TRBAC->LINHAS_FEITAS, '', TRBAC->CB7__DTINI,TRBAC->CB7__DTFIM, TRBAC->HR_INI, TRBAC->HR_FIM,Iif(cOpc=="P","PRE-CHECKOUT","CHECKOUT")})

              dbSelectArea("TRBAC")
              dbSkip()
       End
       TRBAC->(dbCloseArea())
Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณWMAT02EXC บAutor  ณMicrosiga           บ Data ณ  02/11/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณEXPORTA DADOS SEPARACAO PARA EXCEL                          บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function WSRL1EXPORTA()
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de Variaveis                                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
       Local nTamLin, cLin, cCpo
       local cDirDocs  := MsDocPath()
       Local cError        := ""
       Local cPath         := "C:\EXCEL\"
       Local cArquivo      := "WMSRL001.CSV"
       Local cPath         := "C:\EXCEL\"
       Local oExcelApp
       Local nHandle
       Local cCrLf := Chr(13) + Chr(10)
       Local nX
       Local nTempo        := 0
       Local aGeral        := {}
       Local aProd         := {}
       Local Kx := 0
       Local Kk := 0

       Private nHdl    := MsfCreate(cDirDocs+"\"+cArquivo,0)
       Private cEOL    := "CHR(13)+CHR(10)"

//CRIA DIRETORIO
       MakeDir(Trim(cPath))

       FERASE( "C:\EXCEL\"+cArquivo )

       if file(cArquivo) .and. ferase(cArquivo) == -1
              msgstop("Nใo foi possํvel abrir o arquivo CSV pois ele pode estar aberto por outro usuแrio.")
              return(.F.)
       endif

//MONTA A PRODUCAO POR OPERADOR
//aOper 01-CODIGO, 02- NOME, 03- LOCAIS,04-PECAS, 05-LOCAIS FEITOS, 06- SETOR, 07- DATA INICIAL, 08-DATA FINAL 09 -HORA INICIAL, 10-HORA FINAL, 11-OPERACAO
       For Kx:=1 To Len(aOper)
              nDifTempo := 0
              //NAO CONSIDERA HORAS EM BRANCO OU MAIS QUE 1 DIA PARA FINALIZAR
              If aOper[Kx][9] # "  :  " .And. (aOper[Kx][8] - aOper[Kx][7])<1

                     nDifTempo    := A680Tempo( aOper[Kx][7],aOper[Kx][9],aOper[Kx][8],aOper[Kx][10] )
                     If (Int(nDifTempo)/aOper[Kx][5] )> 0.2
                            nDifTempo := 0.2
                     EndIf
                     nTemp24      := 0

                     //NAO CONTA HORARIO DE ALMOCO
                     If aOper[Kx][9] > "12:00" .And. aOper[Kx][9] < "13:00"
                            nTemp24 := A680Tempo( aOper[Kx][7],"12:00",aOper[Kx][8],"13:00" )
                            nDifTempo -= nTemp24
                     EndIf

                     //NAO CONTA HORARIO DE cafe
                     If aOper[Kx][9] > "15:00" .And. aOper[Kx][9] < "15:15"
                            nTemp24 := A680Tempo( aOper[Kx][7],"15:00",aOper[Kx][8],"15:15" )
                            nDifTempo -= nTemp24
                     EndIf


                     //NAO CONTA HORARIO DE JANTA
                     If aOper[Kx][9] > "19:00" .And. aOper[Kx][9] < "19:30"
                            nTemp24 := A680Tempo( aOper[Kx][7],"19:00",aOper[Kx][8],"19:30" )
                            nDifTempo -= nTemp24
                     EndIf

                     //NAO CONTA PERIODO DA NOITE
                     If aOper[Kx][7] #aOper[Kx][8]
                            nTemp24 := A680Tempo( aOper[Kx][7],"22:00",aOper[Kx][8],"08:00" )
                            nDifTempo -= nTemp24
                     EndIf

              EndIf

              //aOper 01-CODIGO, 02- NOME, 03- LOCAIS,04-PECAS, 05-LOCAIS FEITOS, 06- SETOR, 07- DATA INICIAL, 08-DATA FINAL 09 -HORA INICIAL, 10-HORA FINAL, 11-OPERACAO
              nAscan := Ascan(aProd, {|e| e[1] == aOper[Kx][2] .And. e[2] == aOper[Kx][11] })
              If nAscan == 0
                     //AProd 01- NOME, 02- SETOR, 03-PRODUTIVIDADE TOTAL, 04 - MINUTOS , 06- TOTAL CD
                     aAdd(aProd,{aOPer[Kx][2],aOPer[Kx][11],aOper[Kx][5], nDifTempo,Iif(aOper[Kx][11]=="SEPARACAO",nLocais,IIf(aOper[Kx][11]=="PRE-CHECKOUT",nPLinhas,nLinhas))  })
              Else
                     aProd[nAscan][3]+= aOPer[Kx][5] //PRODUTIVIDADE
                     aProd[nAscan][4]+= nDifTempo //SOMA TEMPO
              EndIf

              //AGERAL 01- NOME, 02- MINUTOS, 03 -HORA INICIAL, 04- HORA FINAL , 05-PRODUTIVIDADE GLOBAL
              nAscan := Ascan(aGeral, {|e| e[1] == aOper[Kx][2] })
              If nAscan == 0
                     //AProd 01- NOME,  02 - MINUTOS
                     aAdd(aGeral,{aOPer[Kx][2], nDifTempo,aOper[Kx][9],aOper[Kx][10],0 })
              Else
                     //ARMAZENA A MENOR HORA
                     If aGeral[nAscan][3] > aOper[Kx][9]
                            aGeral[nAscan][3] := aOper[Kx][9]
                     EndIf

                     //ARMAZENA A MAIOR HORA
                     If aGeral[nAscan][4] < aOper[Kx][10]
                            aGeral[nAscan][4] := aOper[Kx][10]
                     EndIf

                     aGeral[nAscan][2]+= nDifTempo //TEMPO
              EndIf

       Next

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Cria o arquivo texto                                                ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

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


//CABECALHOS
       cLin := "PRODUCAO OPERADOR X SETOR"
       cLin += cEOL
       If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
              ConOut("Ocorreu um erro na gravacao do arquivo.")
              fClose(nHdl)
              Return
       Endif


//PRODUTIVIDADE POR OPERADOR X SETOR
       cLin    :=  OemToAnsi("Setor")+';'+OemToAnsi("Nome")+';'+OemToAnsi("Producao")+';'+OemToAnsi("Horas Trabalhadas")+';'+OemToAnsi("Tempo por unidade")+';'+OemToAnsi("% Setor")
       cLin += cEOL

       If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
              ConOut("Ocorreu um erro na gravacao do arquivo.")
              dbCloseArea()
              fClose(nHdl)
              Return
       Endif

       ProcRegua(Len(aOper))
//AProd 01- NOME, 02- SETOR, 03-PRODUTIVIDADE TOTAL, 04 - MINUTOS   - 05 TOTAL SETOR
       ASort(aProd,,,{|x,y|x[2]+StrZero(x[3],4)>y[2]+StrZero(y[3],4)})
       cSetor := aProd[1][2]
       For Kx:=1 To Len(aProd)
              IncProc("Aguarde......Montando Setores!")
              //PULA UMA LINHA
              If cSetor # aProd[1][2]
                     cLin    := ''
                     cLin += cEOL

                     If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
                            ConOut("Ocorreu um erro na gravacao do arquivo.")
                            fClose(nHdl)
                            Return
                     Endif

              EndIf


              cLin    := ''
              cLin    += aProd[Kx][2]+';'+aProd[Kx][1]+';'+Transform(aProd[Kx][3],'@E 9999999')+';'+U_ConVDecHora(aProd[Kx][4])+';'+U_ConVDecHora(aProd[Kx][4]/aProd[Kx][3])+';'+Transform((aProd[Kx][3]/aProd[Kx][5])*100,'@E 999.99')

              //PULA LINHA
              cLin += cEOL

              //ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
              //ณ Gravacao no arquivo texto. Testa por erros durante a gravacao da    ณ
              //ณ linha montada.                                                      ณ
              //ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

              If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
                     ConOut("Ocorreu um erro na gravacao do arquivo.")
                     fClose(nHdl)
                     Return
              Endif
              //SOMA A PRODUTIVIDADE DO SETOR NO OPERADOR
              nAscan := Ascan(aGeral, {|e| e[1] == aProd[Kx][1] })
              If nAscan > 0
                     aGeral[nAscan][5]+= ((aProd[Kx][3]/aProd[Kx][5])*100)/3
              EndIf

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
       cLin    :=  OemToAnsi("Ranking")+';'+OemToAnsi("Nome")+';'+OemToAnsi("Horas Trabalhadas")+';'+OemToAnsi("Hora Inicio")+';'+OemToAnsi("Hora Final")+';'+OemToAnsi("Produtividade no CD")
       cLin += cEOL

       If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
              ConOut("Ocorreu um erro na gravacao do arquivo.")
              dbCloseArea()
              fClose(nHdl)
              Return
       Endif

       ProcRegua(Len(aProd))
//AGERAL 01- NOME, 02- MINUTOS
       ASort(aGeral,,,{|x,y|x[5]>y[5]})

       For Kx:=1 To Len(aGeral)
              IncProc("Aguarde......Montando horas x Operador")
              cLin    := ''
              cLin    += Transform(Kx,'@E 999.99')+';'+aGeral[Kx][1]+';'+U_ConVDecHora(aGeral[Kx][2])+';'+aGeral[Kx][3]+';'+aGeral[Kx][4]+';'+Transform(aGeral[Kx][5],'@E 999.99')

              //PULA LINHA
              cLin += cEOL

              If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
                     ConOut("Ocorreu um erro na gravacao do arquivo.")
                     fClose(nHdl)
                     Return
              Endif

              //IMPRIME OS DADOS DOS SETORES DO OPERADOR
              For Kk:=1 To Len(aProd)

                     If aGeral[Kx][1] == aProd[Kk][1]
                            cLin    := ''
                            cLin    += ''+';'+aProd[Kk][2]+';'+U_ConVDecHora(aProd[Kk][4])+';'+''+';'+''+';'+Transform((aProd[Kk][3]/aProd[Kk][5])*100,'@E 999.99')

                            //PULA LINHA
                            cLin += cEOL

                            //ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
                            //ณ Gravacao no arquivo texto. Testa por erros durante a gravacao da    ณ
                            //ณ linha montada.                                                      ณ
                            //ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

                            If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
                                   ConOut("Ocorreu um erro na gravacao do arquivo.")
                                   fClose(nHdl)
                                   Return
                            Endif

                     EndIf
              Next

              cLin    := ''
              cLin    += ''+';'+'----------'+';'+'----------'+';'+'----------'+';'+'----------'+';'+'----------'

              //PULA LINHA
              cLin += cEOL

              //ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
              //ณ Gravacao no arquivo texto. Testa por erros durante a gravacao da    ณ
              //ณ linha montada.                                                      ณ
              //ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

              If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
                     ConOut("Ocorreu um erro na gravacao do arquivo.")
                     fClose(nHdl)
                     Return
              Endif

       Next

       If mv_par03 == 1
              //LISTA DADOS OPERADORES
              //aOper 01-CODIGO, 02- NOME, 03- LOCAIS,04-PECAS, 05-LOCAIS FEITOS, 06- SETOR, 07- DATA INICIAL, 08-DATA FINAL 09 -HORA INICIAL, 10-HORA FINAL, 11-OPERACAO
              cLin := ""
              cLin += cEOL
              If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
                     ConOut("Ocorreu um erro na gravacao do arquivo.")
                     fClose(nHdl)
                     Return
              Endif

              cLin := "DADOS POR OPERADOR"
              cLin += cEOL
              If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
                     ConOut("Ocorreu um erro na gravacao do arquivo.")
                     fClose(nHdl)
                     Return
              Endif


              //PRODUTIVIDADE POR OPERADOR
              cLin    :=  OemToAnsi("Nome")+';'+OemToAnsi("Producao")+';'+OemToAnsi("Setor")+';'+OemToAnsi("Data Inicial")+';'+OemToAnsi("Data Final")+';'+OemToAnsi("Hora Inicial")+';'+OemToAnsi("Hora Final")+';'+OemToAnsi("Operacao")
              cLin += cEOL

              If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
                     ConOut("Ocorreu um erro na gravacao do arquivo.")
                     dbCloseArea()
                     fClose(nHdl)
                     Return
              Endif

              ProcRegua(Len(aOper))
              //AGERAL 01- NOME, 02- MINUTOS
              ASort(aProd,,,{|x,y|x[2]>y[2]})
              //aOper 01-CODIGO, 02- NOME, 03- LOCAIS,04-PECAS, 05-LOCAIS FEITOS, 06- SETOR, 07- DATA INICIAL, 08-DATA FINAL 09 -HORA INICIAL, 10-HORA FINAL, 11-OPERACAO

              For Kx:=1 To Len(aOper)
                     IncProc("Aguarde......Montando dados gerais")
                     cLin    := ''
                     cLin    += aOper[Kx][2]+';'+Transform(aOper[Kx][5],'@E 99999')+';'+aOper[Kx][6]+';'+Dtoc(aOper[Kx][7])+';'+Dtoc(aOper[Kx][8])+';'+aOper[Kx][9]+';'+aOper[Kx][10]+';'+aOper[Kx][11]

                     //PULA LINHA
                     cLin += cEOL

                     //ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
                     //ณ Gravacao no arquivo texto. Testa por erros durante a gravacao da    ณ
                     //ณ linha montada.                                                      ณ
                     //ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

                     If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
                            ConOut("Ocorreu um erro na gravacao do arquivo.")
                            fClose(nHdl)
                            Return
                     Endif
              Next

       EndIf
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
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTMKRL013  บAutor  ณMicrosiga           บ Data ณ  04/21/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function ValidPerg(cPerg)
       Local cKey := ""
       Local aHelpEng := {}
       Local aHelpPor := {}
       Local aHelpSpa := {}

////PutSx1(cGrupo,cOrdem,cPergunt               ,cPerSpa               ,cPerEng               ,cVar ,cTipo ,nTamanho,nDecimal,nPresel,cGSC,cValid                   ,cF3   , cGrpSxg    ,cPyme,cVar01    ,cDef01     ,cDefSpa1,cDefEng1,cCnt01,cDef02                 ,cDefSpa2,cDefEng2,cDef03       ,cDefSpa3,cDefEng3,cDef04,cDefSpa4,cDefEng4,cDef05,cDefSpa5,cDefEng5,aHelpPor,aHelpEng,aHelpSpa,cHelp)
//PutSx1(cPerg,"01"   ,"Data Inicial                  ?",""                   ,""                    ,"mv_ch1","D"   ,08      ,0       ,0      , "G",""                      ,""    ,""         ,""   ,"mv_par01",""                    ,""      ,""      ,""    ,""                ,""     ,""      ,""            ,""      ,""      ,""    ,""      ,""     ,""    ,""      ,""      ,""      ,""      ,""      ,"")
//PutSx1(cPerg,"02"   ,"Data Final            ?",""                       ,""                    ,"mv_ch2","D"   ,08      ,0       ,0      , "G",""                      ,""    ,""         ,""   ,"mv_par02",""                    ,""      ,""      ,""    ,""                ,""     ,""      ,""            ,""      ,""      ,""    ,""      ,""     ,""    ,""      ,""      ,""      ,""      ,""      ,"")
//PutSx1(cPerg,"03"   ,"Tipo                            ?",""                  ,""                    ,"mv_ch3","N"   ,01      ,0       ,0      , "C",""                      ,""    ,""         ,""   ,"mv_par03","Analitico"   ,""      ,""      ,""    ,"Sintetico"       ,""     ,""      ,""               ,""      ,""      ,""    ,""      ,""     ,""    ,""      ,""      ,""      ,""      ,""      ,"")

       AADD(aPerg,{	"01"   		,"Data Inicial       ?"	,""						 ,""                    ,"mv_ch1"	,"D"   		,08      	,0       	,0      	, "G"	,""        ,"mv_par01"	,""         ,""      ,""      	,""    		,""      ,""     		,""      	,""        ,""      	,""      	,""    		,""      	,""     	,""    		,""      ,""      	,""      	,""      	,""      	,""      	,""			,""      	,""			,""			,""		,""			,""			,""			,""			,""})
       AADD(aPerg,{	"02"   		,"Data Final         ?"	,""						 ,""                    ,"mv_ch2"	,"D"   		,08      	,0       	,0      	, "G"	,""        ,"mv_par02"	,""         ,""      ,""      	,""    		,""      ,""     		,""      	,""        ,""      	,""      	,""    		,""      	,""     	,""    		,""      ,""      	,""      	,""      	,""      	,""      	,""			,""      	,""			,""			,""		,""			,""			,""			,""			,""})
       AADD(aPerg,{	"03"   		,"Tipo               ?"	,""						 ,""                    ,"mv_ch3"	,"N"   		,01      	,0       	,0      	, "C"	,""        ,"mv_par03"	,"Analitico",""      ,""      	,""    	 	,""		  ,"Sintetico",""     	,""      	,""        ,""      	,""      	,""    		,""      	,""     	,""    	  ,""      	,""      	,""      	,""      	,""      	,""			,""      	,""			,""			,""		,""			,""			,""			,""			,""})
       //				X1_ORDEM	X1_PERGUNT					X1_PERSPA					X1_PERENG				X1_VARIAVL	X1_TIPO		X1_TAMANHO	X1_DECIMAL	X1_PRESEL	X1_GSC	X1_VALID	X1_VAR01		X1_DEF01	X1_DEFSPA1	X1_DEFENG1	X1_CNT01	X1_VAR02	X1_DEF02	X1_DEFSPA2	X1_DEFENG2	X1_CNT02	X1_VAR03	X1_DEF03	X1_DEFSPA3	X1_DEFENG3	X1_CNT03	X1_VAR04	X1_DEF04	X1_DEFSPA4	X1_DEFENG4	X1_CNT04	X1_VAR05	X1_DEF05	X1_DEFSPA5	X1_DEFENG5	X1_CNT05	X1_F3	X1_PYME		X1_GRPSXG	X1_HELP		X1_PICTURE	X1_IDFIL

       AjustaSX1( cPerg, aPerg, aHelpPor )


Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAjustaSX1 บAutor  ณC. TORRES           บ Data ณ  16/02/2018 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function AjustaSX1( cPerg, aPerg, aHelp )
       Local aArea := GetArea()
       Local aCpoPerg := {}
       Local nX := 0
       Local nY := 0

// DEFINE ESTRUTUA DO ARRAY DAS PERGUNTAS COM AS PRINCIPAIS INFORMACOES
       AADD( aCpoPerg, 'X1_ORDEM' )
       AADD( aCpoPerg, 'X1_PERGUNT' )
       AADD( aCpoPerg, 'X1_PERSPA' )
       AADD( aCpoPerg, 'X1_PERENG' )
       AADD( aCpoPerg, 'X1_VARIAVL' )
       AADD( aCpoPerg, 'X1_TIPO' )
       AADD( aCpoPerg, 'X1_TAMANHO' )
       AADD( aCpoPerg, 'X1_DECIMAL' )
       AADD( aCpoPerg, 'X1_PRESEL' )
       AADD( aCpoPerg, 'X1_GSC' )
       AADD( aCpoPerg, 'X1_VALID' )
       AADD( aCpoPerg, 'X1_VAR01' )
       AADD( aCpoPerg, 'X1_DEF01' )
       AADD( aCpoPerg, 'X1_DEFSPA1' )
       AADD( aCpoPerg, 'X1_DEFENG1' )
       AADD( aCpoPerg, 'X1_CNT01' )
       AADD( aCpoPerg, 'X1_VAR02' )
       AADD( aCpoPerg, 'X1_DEF02' )
       AADD( aCpoPerg, 'X1_DEFSPA2' )
       AADD( aCpoPerg, 'X1_DEFENG2' )
       AADD( aCpoPerg, 'X1_CNT02' )
       AADD( aCpoPerg, 'X1_VAR03' )
       AADD( aCpoPerg, 'X1_DEF03' )
       AADD( aCpoPerg, 'X1_DEFSPA3' )
       AADD( aCpoPerg, 'X1_DEFENG3' )
       AADD( aCpoPerg, 'X1_CNT03' )
       AADD( aCpoPerg, 'X1_VAR04' )
       AADD( aCpoPerg, 'X1_DEF04' )
       AADD( aCpoPerg, 'X1_DEFSPA4' )
       AADD( aCpoPerg, 'X1_DEFENG4' )
       AADD( aCpoPerg, 'X1_CNT04' )
       AADD( aCpoPerg, 'X1_VAR05' )
       AADD( aCpoPerg, 'X1_DEF05' )
       AADD( aCpoPerg, 'X1_DEFSPA5' )
       AADD( aCpoPerg, 'X1_DEFENG5' )
       AADD( aCpoPerg, 'X1_CNT05' )
       AADD( aCpoPerg, 'X1_F3' )
       AADD( aCpoPerg, 'X1_PYME' )
       AADD( aCpoPerg, 'X1_GRPSXG' )
       AADD( aCpoPerg, 'X1_HELP' )
       AADD( aCpoPerg, 'X1_PICTURE' )
       AADD( aCpoPerg, 'X1_IDFIL' )

       DBSelectArea( "SX1" )
       DBSetOrder( 1 )
       For nX := 1 To Len( aPerg )
              IF !DBSeek( PADR(cPerg,10) + aPerg[nX][1] )
                     RecLock( "SX1", .T. ) // Inclui
              Else
                     RecLock( "SX1", .F. ) // Altera
              Endif
              // Grava informacoes dos campos da SX1
              For nY := 1 To Len( aPerg[nX] )
                     If aPerg[nX][nY] <> NIL
                            SX1->( &( aCpoPerg[nY] ) ) := aPerg[nX][nY]
                     EndIf
              Next
              SX1->X1_GRUPO := PADR(cPerg,10)
              MsUnlock() // Libera Registro
              // Verifica se campo possui Help
              _nPosHelp := aScan(aHelp,{|x| x[1] == aPerg[nX][1]})
              IF (_nPosHelp > 0)
                     cNome := "P."+TRIM(cPerg)+ aHelp[_nPosHelp][1]+"."
                     PutSX1Help(cNome,aHelp[_nPosHelp][2],{},{},.T.)
              Else
                     // Apaga help ja existente.
                     cNome := "P."+TRIM(cPerg)+ aPerg[nX][1]+"."
                     PutSX1Help(cNome,{" "},{},{},.T.)
              Endif
       Next
// Apaga perguntas nao definidas no array
       DBSEEK(cPerg,.T.)
       DO WHILE SX1->(!Eof()) .And. SX1->X1_GRUPO == cPerg
              IF ASCAN(aPerg,{|Y| Y[1] == SX1->X1_ORDEM}) == 0
                     Reclock("SX1", .F.)
                     SX1->(DBDELETE())
                     Msunlock()
              ENDIF
              SX1->(DBSKIP())
       ENDDO
       RestArea( aArea )
Return

