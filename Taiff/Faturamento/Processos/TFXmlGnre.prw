#INCLUDE "PROTHEUS.CH"   
#INCLUDE "Topconn.ch"
#INCLUDE "XMLXFUN.CH"

User Function TFXmlGnre()

Local cError   := ""
Local cWarning := ""
Local oScript

Local cTitulo	:= "Gera GNRE on-line s/Protocolo"
Local nOpca
Local _cRoot	:= "C:\GNRE\"+Alltrim(SM0->M0_NOME)+"_"+Alltrim(SM0->M0_CODFIL)+"_Lote_"+Dtos(Date())+"_"+Substr(Time(),1,2)+Substr(Time(),4,2)
Local _cString	

Private _dEmiIni	:= dDataBase
Private _dEmiFin	:= dDataBase

DEFINE MSDIALOG oDlg TITLE cTitulo FROM 000,000 TO 120,400 PIXEL
@ 001,001 TO 060, 201 OF oDlg PIXEL
@ 010,010 SAY   "Data de" SIZE 55, 07 OF oDlg PIXEL
@ 010,110 SAY   "Data ate" SIZE 55, 07 OF oDlg PIXEL
@ 025,010 SAY   "Arquivo" SIZE 55, 07 OF oDlg PIXEL

@ 008,030 MSGET  _dEmiIni  SIZE 55, 11 OF oDlg PIXEL VALID !Empty( _dEmiIni )
@ 008,130 MSGET  _dEmiFin  SIZE 55, 11 OF oDlg PIXEL VALID !Empty( _dEmiFin )
@ 023,030 MSGET  _cRoot  SIZE 140, 11 OF oDlg PIXEL VALID !Empty( _cRoot )

DEFINE SBUTTON FROM 045, 070 TYPE 1 ACTION (nOpca := 1,oDlg:End()) ENABLE OF oDlg
DEFINE SBUTTON FROM 045, 110 TYPE 2 ACTION (nOpca := 2,oDlg:End()) ENABLE OF oDlg
ACTIVATE MSDIALOG oDlg CENTERED
     
If nOpca=1
	//a partir do rootpath do ambiente
	_cRoot := Alltrim(_cRoot)+".XML"
	
	Processa( {|lEnd| _cString	:=GeraXML(@lEnd)}, "Aguarde...","Selecionando TITULOS.", .T. )
	
	//Gera o Objeto XML ref. ao script
	oScript := XmlParser( _cString , "_", @cError, @cWarning )
	If !Empty(cError)
		msgalert(cError)
	EndIf
     
	If !Empty(cWarning)
		msgAlert(cWarning)
	EndIf
          
	// Tranforma o Objeto XML em arquivo
	SAVE oScript XMLFILE _cRoot
EndIf
Return oScript

Static Function GeraXML(lEnd)
Local cAliqInterna:= GetNewPar("MV_ESTICM","")
Local _cmv_par01 := Space(06)
Local _cmv_par02 := Replicate("Z",6)
Local _cmv_par03 := Space(09)
Local _cmv_par04 := Replicate("Z",9)
Local _cmv_par05 := _dEmiIni 
Local _cmv_par06 := _dEmiFin
Local __cEndCob
Local nCnt			:= 0

Local cScript
Local nProdGNRE
Local _cChave
Local cMV_ESTADO	:= GetMv('MV_ESTADO')

If TCSPExist("SP_REL_DEMONSTRATIVO_ST")

	aResult := TCSPEXEC( "SP_REL_DEMONSTRATIVO_ST", _Cmv_par01, _Cmv_par02, _Cmv_par03, _Cmv_par04, DTOS(_Cmv_par05), DTOS(_Cmv_par06), cAliqInterna, SM0->M0_CODIGO, xFilial("SF2"), cMV_ESTADO, DTOS(ddatabase)+SUBSTR(TIME(),1,2)+SUBSTR(TIME(),4,2) )

	IF !Empty(aResult)
		If Select("TSQL") > 0
			dbSelectArea("TSQL")
			DbCloseArea()
		EndIf
		TCQuery "SELECT * FROM " + aResult[1] NEW ALIAS "TSQL"
	Else
		Final('Erro na execucao da Stored Procedure SP_REL_DEMONSTRATIVO_ST: '+TcSqlError())
	EndIf

EndIf 

dbEval( {|x| nCnt++ },,{|| !TSQL->(Eof()) } )
ProcRegua(nCnt)

cScript := "<?xml version='1.0' encoding='UTF-8' standalone='yes' ?>"
cScript += '<TLote_GNRE xmlns="http://www.gnre.pe.gov.br">'
cScript += '<guias>'
TSQL->(DbGotop())
While !TSQL->(Eof())
	IncProc("Processando registros da tabela temporaria...")
   If lEnd
  	   MsgInfo("Operação cancelada","Fim")
     	Exit
   Endif
     
	_cConvenio := "" // Nas Nfe's SEM PROTOCOLO NÃO DEVE MANDAR O CONVENIO // GetNewPar("TF_CONVE"+TSQL->A1_EST,"")	

	cDtPagto	:= ""
	nVlSt		:=	0
	SE2->(DbSetOrder(1))
	If SE2->(DbSeek( xFilial("SE2") + "ST " + TSQL->F2_DOC + Space(Len(SE2->E2_PARCELA)) + "ICM" + "ESTADO" + "00" ))
		nVlSt		:=	SE2->E2_VALOR
		dDtVencto:= SE2->E2_VENCTO
		cDtPagto	:= SUBSTR(DTOS(dDtVencto),1,4)+"-"+SUBSTR(DTOS(dDtVencto),5,2)+"-"+SUBSTR(DTOS(dDtVencto),7,2)
	EndIf
   If nVlSt != 0 .AND. TSQL->A1_EST != "RJ"
	   SA1->(DbSetOrder(1))
		SA1->(DbSeek( xFilial("SA1") + TSQL->F2_CLIENTE + TSQL->F2_LOJA ))
			
		__cEndCob	:= Alltrim( SA1->A1_LOGR ) + Space(01)
		__cEndCob	+= Alltrim( SA1->A1_END ) + ", "
		__cEndCob	+= SA1->A1_NUME 
		
		__cTelefone := Alltrim(SA1->A1_DDD)
		__cTelefone += Alltrim(SA1->A1_TEL)
		While At("-",__cTelefone) != 0
			__cTelefone := Stuff( __cTelefone ,At("-",__cTelefone),1,"")
		End
		
		__cMesRef	:= Substr(TSQL->F2_EMISSAO,5,2) 
		__cAnoRef   := Substr(TSQL->F2_EMISSAO,1,4) 
	
		nProdGNRE	:= GETNEWPAR("TF_PROGN" + SF6->F6_EST, 0 )
		
		cTxtInfo := "NFe: " + SF2->F2_DOC + Space(01)
		cTxtInfo += Alltrim(SM0->M0_NOMECOM) + Space(01)
		cTxtInfo += "CNPJ: " + SM0->M0_CGC + Space(01)
		cTxtInfo += "IE: " + SM0->M0_INSC
						
		cScript += '     <TDadosGNRE>'
		cScript += '         <c01_UfFavorecida>' + TSQL->A1_EST + '</c01_UfFavorecida>'
		cScript += '         <c02_receita>100099</c02_receita>'
		If nProdGNRE != 0
			cScript += '         <c26_produto>' + Alltrim(Str(nProdGNRE)) + '</c26_produto>'
		EndIf
		cScript += '         <c27_tipoIdentificacaoEmitente>1</c27_tipoIdentificacaoEmitente>'
		cScript += '     <c03_idContribuinteEmitente>'
		cScript += '                        <CNPJ>' + TSQL->A1_CGC + '</CNPJ>'
		cScript += '     </c03_idContribuinteEmitente>'
		cScript += '         <c28_tipoDocOrigem>10</c28_tipoDocOrigem>'
		cScript += '         <c04_docOrigem>' + TSQL->F2_DOC + '</c04_docOrigem>'
		If TSQL->A1_EST="SC"
			cScript += '         <c10_valorTotal>' + Alltrim(StrTran(STR(nVlSt,14,2),",",".")) + '</c10_valorTotal>'
		Else
			cScript += '         <c06_valorPrincipal>' + Alltrim(StrTran(STR(nVlSt,14,2),",",".")) + '</c06_valorPrincipal>'
		EndIf
		cScript += '         <c14_dataVencimento>' + cDtPagto + '</c14_dataVencimento>'
		// A TAG <c15_convenio> não pode ser encaminha com conteudo vazia 
		// cScript += '         <c15_convenio>' + _cConvenio + '</c15_convenio>'
      cScript += '         <c16_razaoSocialEmitente>' + Alltrim(SA1->A1_NOME) + '</c16_razaoSocialEmitente>'
		cScript += '         <c18_enderecoEmitente>' + Alltrim(__cEndCob) + '</c18_enderecoEmitente>'
		cScript += '         <c19_municipioEmitente>' + SA1->A1_COD_MUN + '</c19_municipioEmitente>'
		cScript += '         <c20_ufEnderecoEmitente>' + SA1->A1_EST + '</c20_ufEnderecoEmitente>'
		cScript += '         <c21_cepEmitente>' + SA1->A1_CEP + '</c21_cepEmitente>'
		If !empty(__cTelefone)
			cScript += '         <c22_telefoneEmitente>'+__cTelefone+'</c22_telefoneEmitente>'
		EndIf
		cScript += '         <c33_dataPagamento>' + cDtPagto + '</c33_dataPagamento>'
		cScript += '     <c05_referencia>'
		cScript += '         <mes>' + __cMesRef + '</mes>'
		cScript += '         <ano>' + __cAnoRef + '</ano>'
		cScript += '     </c05_referencia>'
		cScript += '     </TDadosGNRE>'
	EndIf
   _cChave := TSQL->F2_DOC + TSQL->F2_SERIE
   While TSQL->F2_DOC + TSQL->F2_SERIE = _cChave .and. !TSQL->(Eof())
		TSQL->(DbSkip())
	End
End
cScript += '</guias>'
cScript += '</TLote_GNRE>'

//Fecha Alias Temporario
If Select("TSQL")
	TSQL->(dbCloseArea())
EndIf

//Exclui a tabela temporaria do Banco de Dados
If TcCanOpen(aResult[1])
	TcSqlExec("DROP TABLE "+aResult[1])
EndIf

Return cScript
