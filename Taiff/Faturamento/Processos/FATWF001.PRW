#include "protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  ³FATWF001  ºAutor  ³Thiago Comelli      º Data ³  27/11/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Envia E-Mail Bloqueio de Crédito				          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ PROART			                                          º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function FATWF001(cAlias,cNum,cCliente,cLoja,cObs)
	Local _aArea := GetArea()
	Local cMvAtt 	:= GetMv("MV_WFHTML")
	Local cMailto 	:= SuperGetMV("MV__MAILBL",.F.,"")
	Local cQueryPrd 	:= ""
	Local cQueryVen 	:= ""
	Local ENTER			:= Chr(13)+Chr(10)
	Local x := 0

	Private oHtml

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Verifica a Existencia de Parametro MV__MAILBL³
//³Caso nao exista. Cria o parametro.           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SX6")
	If ! dbSeek("  "+"MV__MAILBL")
		RecLock("SX6",.T.)
		X6_VAR    	:= "MV__MAILBL"
		X6_TIPO 	:= "C"
		X6_CONTEUD 	:= ""
		X6_CONTENG 	:= ""
		X6_CONTSPA 	:= ""
		X6_DESCRIC	:= "DEFINE O EMAIL PARA ENVIO DO AVISO DE BLOQUEIO DE"
		X6_DESC1	:= "PEDIDOS DA ROTINA FATMI001; SEPARAR POR PONTO E  "
		X6_DESC2	:= "VIRGULA                                          "
		MsUnlock("SX6")
	EndIf

	aEmpFil := StrTokArr(SuperGetMV("MV__MULT08",.F.,""),"/")

	For x:= 1 to Len(aEmpFil)
		cEmpProc := Substr(aEmpFil[x],1,2)
		cFilProc := Substr(aEmpFil[x],3,2)
		cModoSA1 := POSICIONE("SZB",1,xFilial("SZB")+ cEmpProc + cFilProc + "SA1","ZB_MODO")
		cNomeSA1 := POSICIONE("SZB",1,xFilial("SZB")+ cEmpProc + cFilProc + "SA1","ZB_SQLNAME")
		cModoSE1 := POSICIONE("SZB",1,xFilial("SZB")+ cEmpProc + cFilProc + "SE1","ZB_MODO")
		cNomeSE1 := POSICIONE("SZB",1,xFilial("SZB")+ cEmpProc + cFilProc + "SE1","ZB_SQLNAME")
		cModoSE5 := POSICIONE("SZB",1,xFilial("SZB")+ cEmpProc + cFilProc + "SE5","ZB_MODO")
		cNomeSE5 := POSICIONE("SZB",1,xFilial("SZB")+ cEmpProc + cFilProc + "SE5","ZB_SQLNAME")

// QUERY DE TITULOS PERDIDOS
		cQueryPrd += " SELECT '"+aEmpFil[x]+"' AS EMPRESAFILIAL, E5_TIPO, E5_NUMERO, E5_PARCELA, E5_LOJA, E1_EMISSAO, E1_VENCTO, E1_HIST"+ENTER
		cQueryPrd += " FROM "+cNomeSE5+" AS E5"+ENTER
		cQueryPrd += " INNER JOIN "+cNomeSE1+" AS E1"+ENTER
		cQueryPrd += " ON E1.D_E_L_E_T_ = '' AND E1_FILIAL = '"+IIF(cModoSE1=="E",cFilProc,"")+"' AND E1_PREFIXO = E5_PREFIXO AND E1_NUM = E5_NUMERO AND E1_PARCELA = E5_PARCELA AND E1_TIPO = E5_TIPO"+ENTER
		cQueryPrd += " WHERE E5.D_E_L_E_T_ = ''"+ENTER
		cQueryPrd += " AND E5_FILIAL = '"+IIF(cModoSE5=="E",cFilProc,"")+"'"+ENTER
		cQueryPrd += " AND E5_MOTBX IN('PRD')"+ENTER
		cQueryPrd += " AND E5_CLIENTE + E5_LOJA IN(SELECT A1_COD + A1_LOJA FROM "+cNomeSA1+" WHERE D_E_L_E_T_ = '' AND A1_FILIAL = '"+IIF(cModoSA1=="E",cFilProc,"")+"' AND A1_CGC LIKE '"+IIF(SA1->A1_PESSOA =="J" , SUBSTR(SA1->A1_CGC , 1 , LEN(SA1->A1_CGC) - 6), IIF(SA1->A1_PESSOA =="F" , SUBSTRING(SA1->A1_CGC , 1 , 11),""))+"%')"+ENTER
		IIF(x < Len(aEmpFil), cQueryPrd += " UNION ALL "+ENTER,)

// QUERY DE TITULOS VENCIDOS
		cQueryVen += " SELECT '"+aEmpFil[x]+"' AS EMPRESAFILIAL, E1_TIPO, E1_NUM, E1_PARCELA,E1_LOJA,E1_EMISSAO, E1_VENCREA, E1_VALOR, E1_SALDO, E1_HIST "+ENTER
		cQueryVen += " FROM "+cNomeSE1+" AS E1 "+ENTER
		cQueryVen += " WHERE E1.D_E_L_E_T_ = '' "+ENTER
		cQueryVen += " AND E1_FILIAL = '"+IIF(cModoSE1=="E",cFilProc,"")+"' "+ENTER
		cQueryVen += " AND E1_TIPO IN ('NF','NDC') "+ENTER
		cQueryVen += " AND E1_SALDO > 0 "+ENTER
		cQueryVen += " AND E1_VENCREA < '"+DTOS(dDataBase -2)+"' "+ENTER
		cQueryVen += " AND E1_CLIENTE + E1_LOJA IN(SELECT A1_COD + A1_LOJA FROM "+cNomeSA1+" WHERE D_E_L_E_T_ = '' AND A1_FILIAL = '"+IIF(cModoSA1=="E",cFilProc,"")+"' AND A1_CGC LIKE '"+IIF(SA1->A1_PESSOA =="J" , SUBSTR(SA1->A1_CGC , 1 , LEN(SA1->A1_CGC) - 6), IIF(SA1->A1_PESSOA =="F" , SUBSTRING(SA1->A1_CGC , 1 , 11),""))+"%') "+ENTER
		IIF(x < Len(aEmpFil), cQueryVen += " UNION ALL "+ENTER,)

	Next

//Seleciona dados para manipulação
	//MemoWrit("FATWF001Prd.SQL",cQueryPrd)
	//MemoWrit("FATWF001Ven.SQL",cQueryVen)

	dbUseArea(.T.,"TOPCONN", TCGenQry(,,cQueryPrd),(cQryPrd := GetNextAlias()), .F., .T.)
	dbUseArea(.T.,"TOPCONN", TCGenQry(,,cQueryVen),(cQryVen := GetNextAlias()), .F., .T.)

	dbSelectArea(cQryPrd)
	dbSelectArea(cQryVen)
	(cQryPrd)->(dbGoTop())
	(cQryVen)->(dbGoTop())

//FUNCOES PARA ENVIO DE HTML
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Muda o parametro para enviar no corpo do e-mail³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	PutMv("MV_WFHTML","T")

	oProcess:=TWFProcess():New("000001","Bloqueio de Pedidos")
	oProcess:NewTask('Inicio',"\WORKFLOW\FATWF001.htm")
	oHtml   := oProcess:oHtml

	oHtml:ValByName("cNumPed"	,cNum)
	oHtml:ValByName("cNomeCli"	,AllTrim(SA1->A1_NOME))
	oHtml:ValByName("cObs"		,cObs)

	oHtml:ValByName("ta.Tipo"	, {})
	oHtml:ValByName("ta.Titulo"	, {})
	oHtml:ValByName("ta.Parc"	, {})
	oHtml:ValByName("ta.Loja"	, {})
	oHtml:ValByName("ta.Emiss"	, {})
	oHtml:ValByName("ta.Venc"	, {})
	oHtml:ValByName("ta.VlrTit"	, {})
	oHtml:ValByName("ta.SldRec"	, {})
	oHtml:ValByName("ta.Hist"	, {})
	oHtml:ValByName("ta.Empresa", {})
	oHtml:ValByName("tp.Tipo", {})
	oHtml:ValByName("tp.Titulo", {})
	oHtml:ValByName("tp.Parc", {})
	oHtml:ValByName("tp.Loja", {})
	oHtml:ValByName("tp.Emiss", {})
	oHtml:ValByName("tp.Venc", {})
	oHtml:ValByName("tp.VlrTit", {})
	oHtml:ValByName("tp.Hist", {})
	oHtml:ValByName("tp.Empresa", {})

	While (cQryPrd)->(!Eof())
		aadd(oHtml:ValByName("it.Item")		, (cQryPrd)->ZZB_ITEM)
		aadd(oHtml:ValByName("it.Cod")		, (cQryPrd)->ZZB_PRODUT)
		aadd(oHtml:ValByName("it.Descr")	, (cQryPrd)->ZZB_DESCRI)
		aadd(oHtml:ValByName("it.Quant")	, (cQryPrd)->ZZB_QTDVEN)
		aadd(oHtml:ValByName("it.UM")		, (cQryPrd)->ZZB_UM)
		aadd(oHtml:ValByName("it.PrcLis")	, (cQryPrd)->ZZB_PRUNIT)
		aadd(oHtml:ValByName("it.PrcVen")	, (cQryPrd)->ZZB_PRCVEN)
		aadd(oHtml:ValByName("it.Oper")		, (cQryPrd)->ZZB_OPER)
		aadd(oHtml:ValByName("it.Entreg")	, DTOC(STOD((cQryPrd)->ZZB_ENTREG)))
		aadd(oHtml:ValByName("it.Local")	, (cQryPrd)->ZZB_LOCAL)
		aadd(oHtml:ValByName("it.TES")		, (cQryPrd)->ZZB_TES)
		(cQryPrd)->(DbSkip())
	End

	While (cQryVen)->(!Eof())
		aadd(oHtml:ValByName("ob.Data")		, DTOC((cQryVen)->ZZC_DTEVT))
		aadd(oHtml:ValByName("ob.Hora")		, (cQryVen)->ZZC_HREVT)
		aadd(oHtml:ValByName("ob.Usr")		, AllTrim(UsrRetName((cQryVen)->ZZC_USREVT)))
		aadd(oHtml:ValByName("ob.OBS")		, (cQryVen)->ZZC_OBSERV)
		(cQryVen)->(DbSkip())
	End

//envia o e-mail
	cUser 				:= Subs(cUsuario,7,15)
	oProcess:ClientName(cUser)
	oProcess:cTo      := cMailto
	oProcess:cSubject  	:= IIF(cAlias=="SC5","PEDIDO","ORCAMENTO") + " RETIDO NO CREDITO - "+AllTrim(cNum)+" - "+AllTrim(SA1->A1_NOME)
	oProcess:Start()
	oProcess:Finish()
	oProcess:Free()
	oProcess:= Nil

	(cQryPrd)->(dbCloseArea())
	(cQryVen)->(dbCloseArea())

	PutMv("MV_WFHTML",cMvAtt)
	RestArea(_aArea)
Return
