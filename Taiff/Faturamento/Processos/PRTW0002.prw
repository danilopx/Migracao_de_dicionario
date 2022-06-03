#include "protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  ³PRTW0002  ºAutor  ³Thiago Comelli      º Data ³  18/08/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Envia E-Mail Bloqueio de Pre Pedido				          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ PROART			                                          º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function PRTW0002(cEmpresa,cNumOld,cCliente,cLoja)

Local cAliasBKP	:= Iif(Empty(Alias()),"ZZA",Alias())
Local aOrdBKP	:= SaveOrd({cAliasBKP,"ZZA","ZZB","ZZC"})
Local cMailto 	:= SuperGetMV("PRT_SEP008",.F.,"")
Local cAliasQry	:= ""
Local cQuery 	:= ""
Local cMensagem	:= ""

Default cEmpresa	:= ""
Default cNumOld		:= ""
Default cCliente	:= ""
Default cLoja  		:= ""
Private oHtml

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Verifica a Existencia de Parametro PRT_SEP008³
//³Caso nao exista. Cria o parametro.           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SX6")
If ! dbSeek("  "+"PRT_SEP008")
	RecLock("SX6",.T.)
	X6_VAR    	:= "PRT_SEP008"
	X6_TIPO 	:= "C"
	X6_CONTEUD 	:= "thiago@veti.com.br"
	X6_CONTENG 	:= "thiago@veti.com.br"
	X6_CONTSPA 	:= "thiago@veti.com.br"
	X6_DESCRIC	:= "DEFINE O EMAIL PARA ENVIO DO AVISO DE BLOQUEIO DE"
	X6_DESC1	:= "PEDIDOS DA ROTINA PRTW0002                       "
	X6_DESC2	:= "                                                 "
	MsUnlock("SX6")
EndIf

//Seleciona dados para manipulação
//cQuery += " INNER JOIN "+RetSqlName("ZZB")+" AS ZZB ON ZZB.D_E_L_E_T_ = '' AND ZZB_FILIAL = ZZA_FILIAL AND ZZB_EMPRES = ZZA_EMPRES AND ZZB_NUMOLD = ZZA_NUMOLD"
cQuery := " SELECT ZZA_FILIAL, ZZA_EMPRES, ZZA_TIPO, ZZA_CLIENT, ZZA_LOJCLI, ZZA_TIPCLI, ZZA_EMISSA, ZZA_CONDPA, ZZA_DESC1,"
cQuery += " ZZA_VEND1, ZZA_TABELA, ZZA_OBSRVA, ZZA_DTPDPR, ZZA_DTMAN, ZZA_HRMAN, ZZA_SC5NUM, ZZA_USUMAN,A1_NOME, "
cQuery += " ZZB_ITEM, ZZB_PRODUT, ZZB_QTDVEN, ZZB_PRUNIT, ZZB_PRCVEN, ZZB_OPER, ZZB_ENTREG, ZZB_UM, ZZB_LOCAL, ZZB_DESCRI, ZZB_TES"
cQuery += " FROM "+RetSqlName("ZZA")+" AS ZZA"
cQuery += " INNER JOIN "+RetSqlName("ZZB")+" AS ZZB ON ZZB.D_E_L_E_T_ = '' AND ZZB_FILIAL = ZZA_FILIAL AND ZZB_NUMOLD = ZZA_NUMOLD"
cQuery += " INNER JOIN "+RetSqlName("SA1")+" AS A1 ON A1.D_E_L_E_T_ = '' AND A1_FILIAL = '"+xFilial("SA1")+"' AND A1_COD = ZZA_CLIENT AND A1_LOJA = ZZA_LOJCLI
cQuery += " WHERE ZZA.D_E_L_E_T_ = ''"
cQuery += " AND ZZA_FILIAL = '"+xFilial("ZZA")+"' "
cQuery += " AND ZZA_EMPRES = '"+cEmpresa+"'"
cQuery += " AND ZZA_NUMOLD = '"+cNumOld+"'"
cQuery += " AND ZZA_CLINTE = '"+cCliente+"'"
cQuery += " AND ZZA_LOJCLI = '"+cLoja+"'"
cQuery += " ORDER BY ZZB_ITEM"

//MemoWrit("PRTW0002.SQL",cQuery)
dbUseArea(.T.,"TOPCONN", TCGenQry(,,cQuery),(cAliasQry := GetNextAlias()), .F., .T.)

dbSelectArea(cAliasQry)
dbGoTop()

If (cAliasQry)->(EOF()) //verifica se está no fim do arquivo.
	cMensagem := " Nenhum Pedido foi selecionado para WorkFlow. Entrar em contato com o TI."+Chr(13)+Chr(10)
	MsgStop(cMensagem,"Atenção - PRTW0002")
	(cAliasQry)->(dbCloseArea())
	Return
	
Else //Caso tenha dados começa impressão de etiquetas
	
	//FUNCOES PARA ENVIO DE HTML
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Muda o parametro para enviar no corpo do e-mail³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	PutMv("MV_WFHTML","T")
	
	oProcess:=TWFProcess():New("000001","Bloqueio de Pedidos")
	oProcess:NewTask('Inicio',"\WORKFLOW\PRTW0002.htm")
	oHtml   := oProcess:oHtml
	
	oHtml:ValByName("FILIAL"	,(cAliasQry)->ZZA_FILIAL)
	oHtml:ValByName("EMPRES"	,(cAliasQry)->ZZA_EMPRES)
	oHtml:ValByName("TIPO"		,(cAliasQry)->ZZA_TIPO)
	oHtml:ValByName("EMISSA"	,DTOC(STOD((cAliasQry)->ZZA_EMISSA)))
	oHtml:ValByName("SC5NUM"	,(cAliasQry)->ZZA_SC5NUM)
	oHtml:ValByName("CLINTE"	,(cAliasQry)->ZZA_CLIENT)
	oHtml:ValByName("LOJCLI"	,(cAliasQry)->ZZA_LOJCLI)
	oHtml:ValByName("NOMECLI"	,(cAliasQry)->A1_NOME)
	oHtml:ValByName("TIPCLI"	,(cAliasQry)->ZZA_TIPCLI)
	oHtml:ValByName("CONDPA"	,(cAliasQry)->ZZA_CONDPA)
	oHtml:ValByName("DESC1"		,(cAliasQry)->ZZA_DESC1)
	oHtml:ValByName("VEND1"		,(cAliasQry)->ZZA_VEND1)
	oHtml:ValByName("TABELA"	,(cAliasQry)->ZZA_TABELA)
	oHtml:ValByName("DTPDPR"	,DTOC(STOD((cAliasQry)->ZZA_DTPDPR)))
	oHtml:ValByName("DTMAN"		,DTOC(STOD((cAliasQry)->ZZA_DTMAN)))
	oHtml:ValByName("HRMAN"		,(cAliasQry)->ZZA_HRMAN)
	oHtml:ValByName("USUMAN"	,AllTrim(UsrRetName((cAliasQry)->ZZA_USUMAN)))
	oHtml:ValByName("it.Item"	, {})
	oHtml:ValByName("it.Cod"	, {})
	oHtml:ValByName("it.Descr"	, {})
	oHtml:ValByName("it.Quant"	, {})
	oHtml:ValByName("it.UM"		, {})
	oHtml:ValByName("it.PrcLis"	, {})
	oHtml:ValByName("it.PrcVen"	, {})
	oHtml:ValByName("it.Oper"	, {})
	oHtml:ValByName("it.Entreg"	, {})
	oHtml:ValByName("it.Local"	, {})
	oHtml:ValByName("it.TES"	, {})
	oHtml:ValByName("ob.Data"	, {})
	oHtml:ValByName("ob.Hora"	, {})
	oHtml:ValByName("ob.Usr"	, {})
	oHtml:ValByName("ob.OBS"	, {})
	
	dbSelectArea((cAliasQry))
	dbGoTop()
	While (cAliasQry)->(!Eof())
		aadd(oHtml:ValByName("it.Item")		, (cAliasQry)->ZZB_ITEM)
		aadd(oHtml:ValByName("it.Cod")		, (cAliasQry)->ZZB_PRODUT)
		aadd(oHtml:ValByName("it.Descr")	, (cAliasQry)->ZZB_DESCRI)
		aadd(oHtml:ValByName("it.Quant")	, (cAliasQry)->ZZB_QTDVEN)
		aadd(oHtml:ValByName("it.UM")		, (cAliasQry)->ZZB_UM)
		aadd(oHtml:ValByName("it.PrcLis")	, (cAliasQry)->ZZB_PRUNIT)
		aadd(oHtml:ValByName("it.PrcVen")	, (cAliasQry)->ZZB_PRCVEN)
		aadd(oHtml:ValByName("it.Oper")		, (cAliasQry)->ZZB_OPER)
		aadd(oHtml:ValByName("it.Entreg")	, DTOC(STOD((cAliasQry)->ZZB_ENTREG)))
		aadd(oHtml:ValByName("it.Local")	, (cAliasQry)->ZZB_LOCAL)
		aadd(oHtml:ValByName("it.TES")		, (cAliasQry)->ZZB_TES)
		
		//aadd(oHtml:ValByName("it.Qtde")		, TRANSFORM( TRB->D1_QUANT ,'@E 9999,999.99' ))
		(cAliasQry)->(DbSkip())
	End
	
	dbSelectArea("ZZC")
	dbGoTop()
	If dbSeek(xFilial("ZZC")+cNumOld)
		While ("ZZC")->(!Eof()) .AND. AllTrim(("ZZC")->ZZC_NUMOLD) == AllTrim(cNumOld)
			aadd(oHtml:ValByName("ob.Data")		, DTOC(("ZZC")->ZZC_DTEVT))
			aadd(oHtml:ValByName("ob.Hora")		, ("ZZC")->ZZC_HREVT)
			aadd(oHtml:ValByName("ob.Usr")		, AllTrim(UsrRetName(("ZZC")->ZZC_USREVT)))
			aadd(oHtml:ValByName("ob.OBS")		, ("ZZC")->ZZC_OBSERV)
			("ZZC")->(DbSkip())
		End
	EndIf
	
	//envia o e-mail
	cUser 				:= Subs(cUsuario,7,15)
	oProcess:ClientName(cUser)
	oProcess:cTo      := cMailto
	oProcess:cSubject  	:= "Bloqueio de Pedido - "+cNumOld
	oProcess:Start()
	oProcess:Finish()
	oProcess:Free()
	oProcess:= Nil
	
	(cAliasQry)->(dbCloseArea())	
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Restaura a Ordem Original dos arquivos, mantendo a integridade do sistema³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
RestOrd(aOrdBKP)
DbSelectArea(cAliasBKP)

Return
