#Include 'Protheus.ch'
#INCLUDE "TOPCONN.CH"
#Include 'rwmake.ch'

#DEFINE ENTER Chr(13)+Chr(10)
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ESTCO790 ºAutor  ³Carlos Torres       º Data ³  15/04/2016 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Conferencia de romaneio							             º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Simples consulta da expedição do CD de Extrema             º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function ESTCO790()
	Local oDlgRomaneio
	Local oDESCR
	Local aItems:= {'TAIFF','PROART'}

	Private dDtEmissao := dDataBase
	Private cMarca		:= aItems[1]
	PRIVATE cCadastro:= "Conferencia do Romaneio"

	define msDialog oDlgRomaneio from 0,0 to 170,290 title cCadastro Of oDlgRomaneio Pixel
	@ 005,005 say "Simples Conferencia do Romaneio por Embarque" size  100,07 Of oDlgRomaneio Pixel
	@ 018,005 say "Embarque em:" size 35,07 Of oDlgRomaneio Pixel
	@ 034,005 say "Marca " size 21,07 Of oDlgRomaneio Pixel
	@ 018,40 GET oDESCR VAR dDtEmissao SIZE 49, 08 Of oDlgRomaneio Pixel

	oCombo1 := TComboBox():New(034,40,{|u|if(PCount()>0,cMarca:=u,cMarca)},;
		aItems,40,20,oDlgRomaneio,,;
		,,,,.T.,,,,,,,,,'cMarca')
/*
oCombo1 := TComboBox():New(034,40,{|u|if(PCount()>0,cMarca:=u,cMarca)},;
        aItems,40,20,oDlgRomaneio,,{||Alert('Mudou item da combo')};
        ,,,,.T.,,,,,,,,,'cMarca')
*/
	define sButton from 070,080 type 1 action( IIf( Empty(dDtEmissao),( MsgInfo( "A data inválida!", "Aviso" ), oDESCR:SetFocus() ),{oDlgRomaneio:End(),nOpc := 1}) ) enable  Of oDlgRomaneio Pixel
	define sButton from 070,110 type 2 action(oDlgRomaneio:End(),nOpc := 2) enable  Of oDlgRomaneio Pixel
	activate msDialog oDlgRomaneio center

	If nOpc = 1
		A_ESTCO790()
	EndIf

Return

/*
Tabela que recebe as chaves eletronicas 
*/
Static Function A_ESTCO790
	Local cQuery := ""
	Local cAliasTrb := "TRB"
	Local oDlgChaveNfe
	Local nOpc := 0
	Local oDESCR
	Local cChaveNfe := space(44)
	Local cAliasFT 	:= GetNextAlias()
	Local __cMarcador := GetMark()
	Local aCores := {}
	Local nConta:= 0
	Local nMarca:= 0
	Local _nX := 0


	aCores    := {{"Empty(F2_OK)",'DISABLE' },;
		{"!Empty(F2_OK)",'ENABLE'}}


	cQuery := "SELECT '  ' AS F2_OK, F2_DOC ,F2_SERIE ,F2_CHVNFE, F2_EST, F2_VOLUME1, A1_NOME " + ENTER
	cQuery += " FROM " + RetSqlName("SF2") + " SF2 "  + ENTER
	cQuery += " INNER JOIN " + RetSqlName("SA1") + " SA1 "  + ENTER
	cQuery += " ON SA1.D_E_L_E_T_='' " + ENTER
	cQuery += " AND A1_FILIAL='" + xFILIAL("SA1") + "' " + ENTER
	cQuery += " AND A1_COD=F2_CLIENTE  " + ENTER
	cQuery += " AND A1_LOJA=F2_LOJA " + ENTER
	cQuery += " WHERE F2_FILIAL = '" + xFilial("SF2") + "' " + ENTER
	cQuery += " AND SF2.D_E_L_E_T_='' " + ENTER
	cQuery += " AND F2_DTEMB = '" + DTOS(dDtEmissao) + "' " + ENTER
	If cMarca="TAIFF"
		cQuery += " AND F2_SERIE IN ('1','5') " + ENTER
	ElseIf cMarca="PROART"
		cQuery += " AND F2_SERIE IN ('2','6') " + ENTER
	EndIf

	//MemoWrite("ESTCO790_Nfe_embarque",cQuery)

	TcQuery cQuery NEW ALIAS (cAliasFT)

	aCmpArqTmp := {{"F2_CHVNFE"	,"C",44,0 } ,;
		{"F2_DOC"		,"C",09,0 } ,;
		{"F2_SERIE"	,"C",03,0 } ,;
		{"F2_OK"		,"C",03,0 } ,;
		{"F2_EST"		,"C",02,0 } ,;
		{"F2_VOLUME1"	,"N",06,0 } ,;
		{"A1_NOME"		,"C",40,0 } }

	aCampos := {}
	AADD(aCampos,{'Chave Eletronica'	,'F2_CHVNFE'	,'C',44,0,''})
	AADD(aCampos,{'Documento'			,'F2_DOC'		,'C',09,0,''})
	AADD(aCampos,{'Serie'				,'F2_SERIE'	,'C',03,0,''})
	AADD(aCampos,{'Volume'			,'F2_VOLUME1'	,'N',06,0,''})
	AADD(aCampos,{'UF'				,'F2_EST'		,'C',02,0,''})
	AADD(aCampos,{'Cliente'			,'A1_NOME'		,'C',40,0,''})


	aCamposBrw := {}
	For _nX := 1 To Len(aCampos)
		AaDd(aCamposBrw,{aCampos[_nX,1],aCampos[_nX,2],aCampos[_nX,3],aCampos[_nX,4],aCampos[_nX,5],aCampos[_nX,6]})
	Next
// ----- Alimentando arq. temporário ----- // 
	cNomeArq := CriaTrab(aCmpArqTmp,.T.)
	dbUseArea(.T.,, cNomeArq,cAliasTrb,.T.)
	Index On F2_CHVNFE To &cNomeArq

	(cAliasFT)->(DbGoTop())
	While !(cAliasFT)->(Eof())

		RecLock(cAliasTrb,.T.)
		(cAliasTrb)->F2_OK 		:= (cAliasFT)->F2_OK
		(cAliasTrb)->F2_CHVNFE	:= (cAliasFT)->F2_CHVNFE
		(cAliasTrb)->F2_DOC		:= (cAliasFT)->F2_DOC
		(cAliasTrb)->F2_SERIE		:= (cAliasFT)->F2_SERIE
		(cAliasTrb)->F2_EST		:= (cAliasFT)->F2_EST
		(cAliasTrb)->F2_VOLUME1	:= (cAliasFT)->F2_VOLUME1
		(cAliasTrb)->A1_NOME		:= (cAliasFT)->A1_NOME
		(cAliasTrb)->(MsUnlock())

		(cAliasFT)->(DbSkip())
	End

	(cAliasTrb)->(DbGotop())

	While .T.
	/* registra a chave */
		define msDialog oDlgChaveNfe from 0,0 to 120,290 title "Conferencia do Romaneio" Of oDlgChaveNfe Pixel
		@ 005,005 say "Conferencia do Romaneio por Embarque" size  200,07 Of oDlgChaveNfe Pixel
		@ 018,005 say "Chave:" size 31,07 Of oDlgChaveNfe Pixel
		@ 018,37 GET oDESCR VAR cChaveNfe SIZE 100, 08 Of oDlgChaveNfe Pixel

		define sButton from 040,080 type 13 action( IIf( Empty(cChaveNfe) .or. Len(Alltrim(cChaveNfe))<44,( MsgInfo( "Chave inválida!", "Aviso" ), oDESCR:SetFocus() ),{oDlgChaveNfe:End(),nOpc := 1}) ) enable  Of oDlgChaveNfe Pixel
		define sButton from 040,110 type 21 action(oDlgChaveNfe:End(),nOpc := 2) enable  Of oDlgChaveNfe Pixel
		activate msDialog oDlgChaveNfe center
		If nOpc = 2
			nConta:= 0
			nMarca:= 0
			(cAliasTrb)->(DbGotop())
			While !	(cAliasTrb)->(Eof())
				nConta ++
				If (cAliasTrb)->F2_OK = __cMarcador
					nMarca++
				EndIf
				(cAliasTrb)->(DbSkip())
			End
			If nMarca != nConta
				If MsgBox("Existe divergência na conferência, deseja finalizar assim mesmo?", "Conferencia do Romaneio", "YESNO")
					EXIT
				EndIf
			Else
				Aviso("ATENCAO","Conferencia finalizada com sucesso!",{"OK"},3,"Conferencia do Romaneio")
				EXIT
			EndIf
		EndIf
		If (cAliasTrb)->(DbSeek(cChaveNfe))
			RecLock((cAliasTrb),.F.)
			(cAliasTrb)->F2_OK := __cMarcador
			(cAliasTrb)->(msUnlock())
		Else
			Aviso("ATENCAO","A chave de nota fiscal eletrônica não foi encontrada no embarque informado!",{"OK"},3,"Conferencia do Romaneio")
		EndIf
		cChaveNfe := space(44)
	End
	aRotina	:= { 	{ "Pesquisar" ,"AxPesqui"		, 0 , 1, 0, .F.},;		//"Pesquisar"
	{ "Legenda" 	,"U_ESTLG790"	, 0 , 3, 0, .F.}}		//"Pesquisar"


	dbSelectArea(cAliasTrb)
	dbSetOrder(1)

	MBROWse(6,1,22,75,cAliasTrb,aCamposBrw,,,,,aCores,,,,,.F.)

	dbCloseArea()

Return

User Function ESTLG790

	BrwLegenda(cCadastro,"Legenda",	{;
		{"ENABLE" ,"Conferencia realizada"},;
		{"DISABLE","Documento não conferido"}})
Return(.T.)
