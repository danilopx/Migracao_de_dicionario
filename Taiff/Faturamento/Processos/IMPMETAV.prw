#INCLUDE "Protheus.ch"
#INCLUDE "ApWizard.ch"
//*******************************************************************************************
// Funcao: IMPMETAV - Interface para importacao de arquivo .CSV
// Autor:  Ronald Piscioneri
// Data:   07/04/2022
// Uso:    Especifico Taiff
//*******************************************************************************************
User Function IMPMETAV()
Local oWizard	:= Nil
Local cMsg		:= ""
Local cMsgDlg	:= ""
Local aParambox := {}
Local aDados	:= {}
Local lHaDados  := .F.

Private _aRetParam	:= {Space(170)}
Private _oProcess 	:= NIL
Private _cErros		:= ""
Private cAnoDel		:= ""

If !U_VACUSROT()

	Alert("Usuário sem acesso a esta rotina")
	Return(Nil)

EndIf

aAdd( aParambox, { 1, "Arquivo .CSV", _aRetParam[01], "@!", "", "TFFCSV", ".T.", 170, .T. }) 

AjustaSXB()

cMsg := "O arquivo .CSV deverá ter as seguintes colunas, na ordem abaixo indicada:"+CRLF+CRLF
cMsg += "CODIGO, DESCRICAO PRODUTO, ORIGEM, ANO, GERENTE,"+CRLF
cMsg += "QTD JAN, QTD FEV, QTD MAR, QTD ABR, QTD MAI, QTD JUN,"+CRLF
cMsg += "QTD JUL, QTD AGO, QTD SET, QTD OUT, QTD NOV, QTD DEZ, QTD TOTAL,"+CRLF
cMsg += "FAT JAN, FAT FEV, FAT MAR, FAT ABR, FAT MAI, FAT JUN,"+CRLF
cMsg += "FAT JUL, FAT AGO, FAT SET, FAT OUT, FAT NOV, FAT DEZ e FAT TOTAL."+CRLF

DEFINE WIZARD oWizard ;
		TITLE "Metas de Venda" ;
          	HEADER "Importação de dados através de arquivo .CSV)" ;
          	MESSAGE "" ;
         	TEXT cMsg PANEL ;
          	NEXT 	{|| .T. } ;
          	FINISH 	{|| .T. } ; 
          	          	                            
   	CREATE PANEL oWizard ;				
          	HEADER "Metas de Venda" ;
          	MESSAGE "Informe o caminho do arquivo *.CSV" PANEL ;          	
          	NEXT 	{|| TudoOk() .And. LeDados(_aRetParam,@aDados,@lHaDados)} ;
          	FINISH 	{|| TudoOk() .And. LeDados(_aRetParam,@aDados,@lHaDados)} ;
          	PANEL

  	Parambox( aParambox, "Parametrização", @_aRetParam,,,,,, oWizard:GetPanel(2),, .F., .F. )
   		   		   
ACTIVATE WIZARD oWizard CENTERED

If Len(aDados)>0

	If lHaDados
		cMsgDlg := "ATENÇÃO: já há dados para o ano informado. Caso confirme a importação deste arquivo, os dados atuais serão sobrepostos pelos dados deste arquivo. Confirma ?"
	Else
		cMsgDlg := "Confirma a importação do arquivo .CSV para atualização das Metas de Venda?"
	EndIf

	If MsgYesNo(cMsgDlg)

		_oProcess := MsNewProcess():New( {|lEnd| ProcDados(aDados,@_cErros,lHaDados) }, 'Aguarde...', 'Atualizando dados...', .F. )
		_oProcess:Activate() 

		If Len(_cErros)>0
			ShowMsg(_cErros,"ATENÇÃO: houve erro na atualização das metas de venda")
		Else
			MsgInfo("Fim da atualização das Metas de Venda")
		EndIf

	EndIf

EndIf

Return(Nil)



//*******************************************************************************************
// Funcao: AJUSTASXB - Cadastra consulta usada para pegar o caminho do arquivo .CSV
// Autor:  Ronald Piscioneri
// Data:   07/04/2022
// Uso:    Especifico Taiff
//*******************************************************************************************
Static Function AjustaSXB()
Local aSXB		:= {}  
Local aEstrut	:= {}
Local i 		:= 0
Local j 		:= 0
Local aArea		:= GetArea()     

dbSelectArea("SXB")                    
SXB->(dbSetOrder(1))
If SXB->(!dbSeek("TFFCSV"))

	aEstrut:= { "XB_ALIAS"	,"XB_TIPO"	,"XB_SEQ"	,"XB_COLUNA"	,"XB_DESCRI"		,"XB_DESCSPA"		,"XB_DESCENG"		,"XB_CONTEM"		}
	Aadd( aSXB,	{"TFFCSV"	,"1"		,"01"		,"RE"			,"Metas de Venda"	,"Metas de Venda"	,"Metas de Venda"	,"ZZT"				})
	Aadd( aSXB,	{"TFFCSV"	,"2"		,"01"		,"01"			,""				 	,""					,""					,".T."				})
	Aadd( aSXB,	{"TFFCSV"	,"5"		,"01"		,""				,""					,""					,""					,"U_TFFLARQ()"		})	

	dbSelectArea("SXB")                    
	For i:= 1 To Len(aSXB)
		RecLock("SXB",.T.)			
		For j:=1 To Len(aSXB[i])
			If !Empty(FieldName(FieldPos(aEstrut[j])))
				FieldPut(FieldPos(aEstrut[j]),aSXB[i,j])
			EndIf
		Next j			
		SXB->(dbCommit())
		SXB->(MsUnLock())
	Next i

EndIf
RestArea(aArea)

Return(Nil)
   


//*******************************************************************************************
// Funcao: TFFLARQ
// Autor:  Ronald Piscioneri
// Data:   07/04/2022
// Uso:    Especifico Taiff
//*******************************************************************************************
User Function TFFLARQ()
Local cVariavel := ""
Local cPasta	:= ""

cVariavel 	:= _aRetParam[01]
cPasta		:= _aRetParam[01]
cPasta		:= cGetFile("Arquivo (*.CSV) | *.CSV","Arquivo...",0,cPasta,.T.,GETF_LOCALFLOPPY + GETF_LOCALHARD + GETF_NETWORKDRIVE)

If Empty(cPasta)    
	_aRetParam[01] := cVariavel
Else                          
   	_aRetParam[01] := cPasta
EndIf                         
&(Readvar()) := _aRetParam[01]

Return



//*******************************************************************************************
// Funcao: TUDOOK - Validacao da mudanca de pagina do Wizard
// Autor:  Ronald Piscioneri
// Data:   07/04/2022
// Uso:    Especifico Taiff
//*******************************************************************************************
Static Function TudoOk()
Local lRet := .T.

If Empty(_aRetParam[01])

	MsgAlert("Favor informar o caminho do arquivo")
	lRet := .F.
	
ElseIf !Empty(_aRetParam[01]) .And. !File(_aRetParam[01])

	MsgAlert("Favor informar o caminho do arquivo")
	lRet := .F.
	
EndIf

Return(lRet)



//*******************************************************************************************
// Funcao: LEDADOS - Exibe mensagem "aguarde..." enquanto executa rotina que le o arq .CSV
// Autor:  Ronald Piscioneri
// Data:   07/04/2022
// Uso:    Especifico Taiff
//*******************************************************************************************
Static Function LeDados(_aRetParam,aDados,lHaDados)
Local lRet := .F.
Default lHaDados := .F.

FwMsgRun(,{|| lRet := LerDados(_aRetParam,@aDados,@lHaDados) }, "Aguarde...","Extraindo Dados...")
	
Return(lRet)



//*******************************************************************************************
// Funcao: LERDADOS - Formata array que sera usado na gravacao dos dados
// Autor:  Ronald Piscioneri
// Data:   07/04/2022
// Uso:    Especifico Taiff
//*******************************************************************************************
Static Function LerDados(_aRetParam,aDados,lHaDados)
Local cFile		:= Alltrim(_aRetParam[01])
Local aLeitura 	:= {}
Local aAux01    := {}
Local nX		:= 1
Local lRet		:= .T.
Default lHaDados := .F.

aAux01 := LerCSV(cFile,@lHaDados)
aLeitura := aAux01[1]
lHaDados := aAux01[2]

aDados := {}
aAux01 := {}

If Len(aLeitura) > 0

	For nX:=1 to Len(aLeitura)
		aAdd(aDados,{aLeitura[nX,01],aLeitura[nX,02],aLeitura[nX,03],aLeitura[nX,04],aLeitura[nX,05],aLeitura[nX,06],aLeitura[nX,07]})
	Next nX
	
	If Len(aDados) > 0
		lRet := .T.
	Else
		lRet := .F.
	EndIf	

Else

	lRet := .F.

EndIf
	
Return(lRet)



//*******************************************************************************************
// Funcao: LERCSV - Le e valida os dados do arquivo CSV
// Autor:  Ronald Piscioneri
// Data:   07/04/2022
// Uso:    Especifico Taiff
//*******************************************************************************************
Static Function LerCSV(cFile,lHaDados)
Local nLinhaAtu := 0
Local nTotLinha := 0
Local nNx       := 0
Local lErro		:= .F.
Local cBuffer	:= ""
Local cMsgErr	:= ""
Local cAno      := ""
Local cCodGer   := ""
Local cCodPro   := ""
Local cDesPro   := ""
Local cOriPro   := ""
Local aLeitura	:= {}
Local aAux		:= {}
Local aVldAno	:= {}
Local aCab      := {"CODIGO",;
                    "DESCRICAO PRODUTO",;
                    "ORIGEM",;
                    "ANO",;
                    "GERENTE",;
                    "QTD JAN",;
                    "QTD FEV",;
                    "QTD MAR",;
                    "QTD ABR",;
                    "QTD MAI",;
                    "QTD JUN",;
                    "QTD JUL",;
                    "QTD AGO",;
                    "QTD SET",;
                    "QTD OUT",;
                    "QTD NOV",;
                    "QTD DEZ",;
                    "QTD TOTAL",;
                    "FAT JAN",;
                    "FAT FEV",;
                    "FAT MAR",;
                    "FAT ABR",;
                    "FAT MAI",;
                    "FAT JUN",;
                    "FAT JUL",;
                    "FAT AGO",;
                    "FAT SET",;
                    "FAT OUT",;
                    "FAT NOV",;
                    "FAT DEZ",;
                    "FAT TOTAL"}
Default lHaDados:= .F.
             
If File(cFile)

	FT_FUSE(cFile)
	nTotLinha := FT_FLASTREC()

	FT_FGOTOP()
	cBuffer := FT_FREADLN()

	Do While !FT_FEOF() .And. !lErro

		nLinhaAtu ++
		aAux := {}
		aAux := StrTokArr2( cBuffer , ";", .T. )

    	If ( Len(aAux) == Len(aCab) )
		
			If nLinhaAtu == 1

                For nNx := 1 to Len(aCab)
                    If Upper(Alltrim(aAux[nNx])) <> aCab[nNx]
                        lErro := .T.
                        cMsgErr += "Linha 1: Erro na coluna " +Alltrim(Str(nNx))+ " (informe " +aCab[nNx]+ ")"+CRLF
                    EndIf
                Next nNx

			Else
	
				If !Empty(aAux[1])

					cCodPro := StrZero(Val(aAux[1]),9)
					cDesPro := Upper(Alltrim(aAux[2]))
					cOriPro := Upper(Alltrim(aAux[3]))
					cAno    := Upper(Alltrim(aAux[4]))
					cCodGer := StrZero(Val(aAux[5]),6)

					If Empty(cAno)
						lErro := .T.
						cMsgErr += "Linha "+Alltrim(Str(nLinhaAtu))+" - Ano não informado"+CRLF
					EndIf

					If !lErro
						lErro := VldDados( cCodPro, cOriPro, cAno, cCodGer, nLinhaAtu, @cMsgErr )
					EndIf

					If !lErro

						If Len( aVldAno ) == 0
							aAdd( aVldAno, cAno )
						Else
							If aScan( aVldAno, {|x| x == cAno }) == 0
								aAdd( aVldAno, cAno )
							EndIf
						EndIf

						For nNx := 1 to 12

							If nNx == 1
								aAdd( aLeitura,{	cCodPro,;
													cDesPro,;
													cOriPro,;
                                                    cCodGer,;
													StoD(cAno+"0101"),;
													RetVlrN(aAux[6]),;
													RetVlrN(aAux[19])})
							EndIf

							If nNx == 2
								aAdd( aLeitura,{	cCodPro,;
													cDesPro,;
													cOriPro,;
                                                    cCodGer,;
													StoD(cAno+"0201"),;
													RetVlrN(aAux[7]),;
													RetVlrN(aAux[20])})
							EndIf

							If nNx == 3
								aAdd( aLeitura,{	cCodPro,;
													cDesPro,;
													cOriPro,;
                                                    cCodGer,;
													StoD(cAno+"0301"),;
													RetVlrN(aAux[8]),;
													RetVlrN(aAux[21])})
							EndIf

							If nNx == 4
								aAdd( aLeitura,{	cCodPro,;
													cDesPro,;
													cOriPro,;
                                                    cCodGer,;
													StoD(cAno+"0401"),;
													RetVlrN(aAux[9]),;
													RetVlrN(aAux[22])})
							EndIf

							If nNx == 5
								aAdd( aLeitura,{	cCodPro,;
													cDesPro,;
													cOriPro,;
                                                    cCodGer,;
													StoD(cAno+"0501"),;
													RetVlrN(aAux[10]),;
													RetVlrN(aAux[23])})
							EndIf

							If nNx == 6
								aAdd( aLeitura,{	cCodPro,;
													cDesPro,;
													cOriPro,;
                                                    cCodGer,;
													StoD(cAno+"0601"),;
													RetVlrN(aAux[11]),;
													RetVlrN(aAux[24])})
							EndIf

							If nNx == 7
								aAdd( aLeitura,{	cCodPro,;
													cDesPro,;
													cOriPro,;
                                                    cCodGer,;
													StoD(cAno+"0701"),;
													RetVlrN(aAux[12]),;
													RetVlrN(aAux[25])})
							EndIf

							If nNx == 8
								aAdd( aLeitura,{	cCodPro,;
													cDesPro,;
													cOriPro,;
                                                    cCodGer,;
													StoD(cAno+"0801"),;
													RetVlrN(aAux[13]),;
													RetVlrN(aAux[26])})
							EndIf

							If nNx == 9
								aAdd( aLeitura,{	cCodPro,;
													cDesPro,;
													cOriPro,;
                                                    cCodGer,;
													StoD(cAno+"0901"),;
													RetVlrN(aAux[14]),;
													RetVlrN(aAux[27])})
							EndIf

							If nNx == 10
								aAdd( aLeitura,{	cCodPro,;
													cDesPro,;
													cOriPro,;
                                                    cCodGer,;
													StoD(cAno+"1001"),;
													RetVlrN(aAux[15]),;
													RetVlrN(aAux[28])})
							EndIf

							If nNx == 11
								aAdd( aLeitura,{	cCodPro,;
													cDesPro,;
													cOriPro,;
                                                    cCodGer,;
													StoD(cAno+"1101"),;
													RetVlrN(aAux[16]),;
													RetVlrN(aAux[29])})
							EndIf

							If nNx == 12
								aAdd( aLeitura,{	cCodPro,;
													cDesPro,;
													cOriPro,;
                                                    cCodGer,;
													StoD(cAno+"1201"),;
													RetVlrN(aAux[17]),;
													RetVlrN(aAux[30])})
							EndIf

						Next nNx

					EndIf

			 	Else

					lErro := .T.
					cMsgErr += "Linha "+Alltrim(Str(nLinhaAtu))+" - CODIGO não informado"+CRLF

				EndIf
			 		
	    	EndIf

		Else
	    	
	    	lErro := .T.
			cMsgErr += "Linha "+Alltrim(Str(nLinhaAtu))+" - Não é possível validar os dados desta linha (quantidade de colunas deve ser "+Alltrim(Str(Len(aCab)))+") "+CRLF

		EndIf

		FT_FSKIP()

		cBuffer := FT_FREADLN()

    EndDo
	FT_FUSE()

Else
    
	lErro := .T.
	cMsgErr := "Arquivo não localizado."+CRLF

EndIf

If Len(aVldAno) > 0
	If Len(aVldAno) == 1
		lHaDados := ChkData(aVldAno[1])
	ElseIf Len(aVldAno) > 1	
		lErro := .T.
		cMsgErr := "Não é permitido informar mais de um ano no mesmo arquivo .CSV"+CRLF
	EndIf
EndIf

If lErro
	aLeitura := {}
	ShowMsg(cMsgErr)
EndIf

Return({aLeitura,lHaDados})



//*******************************************************************************************
// Funcao: PROCDADOS - Faz a gravacao dos dados ja validados
// Autor:  Ronald Piscioneri
// Data:   07/04/2022
// Uso:    Especifico Taiff
//*******************************************************************************************
Static Function ProcDados(aDados,_cErros,lHaDados)
Local nNx := 1
Local cFilZZT := xFilial("ZZT")
Local dDtAtu := Date()
Local cHrAtu := StrTran(Time(),":","")
Local cUserN := Upper(Alltrim(cUserName))
Local cSql := ""
Default lHaDados := .F.
        
_oProcess:SetRegua1(0)
_oProcess:SetRegua2(Len(aDados))

dbSelectArea("ZZT")
ZZT->(dbSetOrder(1))

If ( lHaDados .And. !Empty(cAnoDel) )

	cSql := "UPDATE " +RetSqlName("ZZT")+ " SET D_E_L_E_T_ = '*', R_E_C_D_E_L_ = R_E_C_N_O_ "
	cSql += "WHERE ZZT_FILIAL = '" +xFilial("ZZT")+ "' "
	cSql += "AND SUBSTRING(ZZT_DATA,1,4) = '" +cAnoDel+ "'"
	TcSqlExec( cSql )

EndIf

For nNx:=1 to Len(aDados)    

	_oProcess:IncRegua1( 'Atualizando Metas de Vendas...')
	_oProcess:IncRegua2( Alltrim(Str(nNx))+"/"+Alltrim(Str(Len(aDados))) )

	RecLock("ZZT",.T.)
	ZZT->ZZT_FILIAL := cFilZZT
	ZZT->ZZT_DATA := aDados[nNx,5]
	ZZT->ZZT_CODPRO := aDados[nNx,1]
	ZZT->ZZT_DESPRO := aDados[nNx,2]
	ZZT->ZZT_ORIPRO := aDados[nNx,3]
	ZZT->ZZT_GERENG := aDados[nNx,4]
	ZZT->ZZT_QTDPRO := aDados[nNx,6]
	ZZT->ZZT_VLRPRO := aDados[nNx,7]
	ZZT->ZZT_DTINC := dDtAtu
	ZZT->ZZT_HRINC := cHrAtu
	ZZT->ZZT_USRNOM := cUserN
	ZZT->(MsUnLock())
        
Next nNx
    
Return(Nil)



//*******************************************************************************************
// Funcao: VLDDADOS - Valida dados lidos do arquivo CSV
// Autor:  Ronald Piscioneri
// Data:   07/04/2022
// Uso:    Especifico Taiff
//*******************************************************************************************
Static Function VldDados( cCodPro, cOriPro, cAno, cCodGer, nLinhaAtu, cMsgErr )
Local aAtuArea := GetArea()
Local aSB1Area := SB1->(GetArea())
Local cSB1Fil := xFilial("SB1")
Local cVldAno := SuperGetMV("IMPMETAV1",,"|2022|")
Local lErroVld := .F.

dbSelectArea("SB1")
SB1->(dbSetOrder(1))

If !Empty(cCodPro)
	If SB1->(!dbSeek(cSB1Fil+cCodPro))
		lErroVld := .T.
		cMsgErr += "Linha "+Alltrim(Str(nLinhaAtu))+" - Produto "+cCodPro+" nao cadastrado"+CRLF
	EndIf
Else
	lErroVld := .T.
	cMsgErr += "Linha "+Alltrim(Str(nLinhaAtu))+" - Produto nao informado"+CRLF
EndIf

If !Empty(cOriPro)
	If !( cOriPro $ "|NACIONAL|IMPORTADO|" )
		lErroVld := .T.
		cMsgErr += "Linha "+Alltrim(Str(nLinhaAtu))+" - Conteudo invalido para ORIGEM (deve ser NACIONAL ou IMPORTADO)"+CRLF
	EndIf
Else
	lErroVld := .T.
	cMsgErr += "Linha "+Alltrim(Str(nLinhaAtu))+" - Origem do Produto nao informada"+CRLF
EndIf

If !Empty(cAno)
	If !( cAno $ cVldAno )
		lErroVld := .T.
		cMsgErr += "Linha "+Alltrim(Str(nLinhaAtu))+" - Conteudo invalido para ANO, pois esta fechado para movimentação "+CRLF
	EndIf
Else
	lErroVld := .T.
	cMsgErr += "Linha "+Alltrim(Str(nLinhaAtu))+" - Ano nao informado"+CRLF
EndIf

If Empty(cCodGer)
	lErroVld := .T.
	cMsgErr += "Linha "+Alltrim(Str(nLinhaAtu))+" - Gerente nao informado"+CRLF
EndIf

RestArea(aAtuArea)
RestArea(aSB1Area)

Return(lErroVld)



//*******************************************************************************************
// Funcao: SHOWMSG - Exibe tela com inconsistencias
// Autor:  Ronald Piscioneri
// Data:   07/04/2022
// Uso:    Especifico Taiff
//*******************************************************************************************
Static Function ShowMsg(cMsgErr,cCab)
Local oDg1 := Nil
Local oBtF := Nil
Local oGt1 := Nil
Local cGt1 := cMsgErr
Default cCab := "ATENÇÃO: o arquivo não será importado, pelos motivos abaixo:"

DEFINE MSDIALOG oDg1 TITLE cCab FROM 000, 000  TO 400, 600 COLORS 0, 16777215 PIXEL

    @ 004, 004 GET oGt1 VAR cGt1 OF oDg1 MULTILINE SIZE 290, 172 COLORS 0, 16777215 READONLY HSCROLL PIXEL
    @ 182, 257 BUTTON oBtF PROMPT "Fechar" SIZE 037, 012 OF oDg1 ACTION (oDg1:End()) PIXEL

ACTIVATE MSDIALOG oDg1 CENTERED

Return(Nil)



//*******************************************************************************************
// Funcao: RETVLRN - Transforma uma string em valor numerico
// Autor:  Ronald Piscioneri
// Data:   07/04/2022
// Uso:    Especifico Taiff
//*******************************************************************************************
Static Function RetVlrN(cStr)
Local xAux := cStr

If xAux == NIL

	xAux := 0

ElseIf Empty(xAux)

	xAux := 0

Else

	xAux := StrTran(xAux,".","")
	xAux := StrTran(xAux,",",".")
	xAux := Val(xAux)

EndIf

Return(xAux)



//*******************************************************************************************
// Funcao: CHKDATA - Verifica se ja ha dados gravados, ref. a coluna ANO do arq. CSV
// Autor:  Ronald Piscioneri
// Data:   07/04/2022
// Uso:    Especifico Taiff
//*******************************************************************************************
Static Function ChkData( cAnoCSV )
Local lRet := .F.
Local cQry := ""

cQry := "SELECT TOP 1 ZZT_CODPRO "
cQry += "FROM " +RetSqlName("ZZT")+ " WHERE D_E_L_E_T_ = ' ' "
cQry += "AND ZZT_FILIAL = '" +xFilial("ZZT")+ "' "
cQry += "AND SUBSTRING(ZZT_DATA,1,4) = '" +cAnoCSV+ "' "

Iif(Select("WRKXZZT")>0,WRKXZZT->(dbCloseArea()),Nil)
dbUseArea(.T.,"TOPCONN",TCGenQry(,,cQry),"WRKXZZT",.T.,.T.)
WRKXZZT->(dbGoTop())

If WRKXZZT->(!EoF())
	If !Empty(WRKXZZT->ZZT_CODPRO)
		lRet := .T.
	EndIf
EndIf

WRKXZZT->(dbCloseArea())

If lRet
	cAnoDel := cAnoCSV
EndIf

Return(lRet)



//*******************************************************************************************
// Funcao: VACUSROT - Verifica se usuario tem acesso a rotina
// Autor:  Ronald Piscioneri
// Data:   07/04/2022
// Uso:    Especifico Taiff
//*******************************************************************************************
User Function VACUSROT( cCodUsr, cFunName )
Local lRet := .F.
Local cQry := ""
Default cCodUsr := __cUserId
Default cFunName := Upper(Alltrim(FunName()))

cQry := "SELECT ISNULL(R_E_C_N_O_,0) AS SZVRCN "
cQry += "FROM " +RetSqlName("SZV")+ " "
cQry += "WHERE D_E_L_E_T_ = ' ' "
cQry += "AND ZV_FILIAL = '" +xFilial("SZV")+ "' "
cQry += "AND ZV_CODUSU = '" +cCodUsr+ "' "
cQry += "AND UPPER(RTRIM(LTRIM(ZV_FUNCAO))) = '" +cFunName+ "' "
cQry += "AND ZV_ATIVO = 'S'"

Iif(Select("WRKACSS")>0,WRKACSS->(dbCloseArea()),Nil)
dbUseArea(.T.,"TOPCONN",TCGenQry(,,cQry),"WRKACSS",.T.,.T.)
TcSetField("WRKACSS","SZVRCN","N",14,0)
WRKACSS->(dbGoTop())

If WRKACSS->(!EoF())
	If WRKACSS->SZVRCN > 0
		lRet := .T.
	EndIf
EndIf
WRKACSS->(dbCloseArea())

Return(lRet)
