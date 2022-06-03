#Include "Protheus.ch" 
//-----------------------------------------------------------------------------
// Programa      TFCTB010 
// Autor         Ronald Piscioneri
// Data          11-Maio-2021
// Descricao     Exportacao de Dados de Frete (tab.PAV) em planilha Excel
// Uso           Especifico Taiff - Proart
//-----------------------------------------------------------------------------
User Function TFCTB010()
Local oBDir := Nil
Local oBNo := Nil
Local oBOk := Nil
Local oBPar := Nil
Local oGtDir := Nil
Local oSay1 := Nil
Local oDgA := Nil
Local cGtDir := ""
Local oMt1 := Nil
Local nMt1 := 0

ChkPrg()

If Pergunte("TFCTB01001",.T.)

  DEFINE MSDIALOG oDgA TITLE "Exportar Dados de Frete para o Excel" FROM 000, 000  TO 100, 500 COLORS 0, 16777215 PIXEL

    @ 005, 005 SAY oSay1 PROMPT "Escolha a pasta para salvar a planilha:" SIZE 238, 007 OF oDgA COLORS 0, 16777215 PIXEL
    @ 015, 005 MSGET oGtDir VAR cGtDir When .F. SIZE 211, 008 OF oDgA COLORS 0, 16777215 PIXEL
	oMt1:= tMeter():New(033,037,{|u|if(Pcount()>0,nMt1:=u,nMt1)},100,oDgA,142,009,,.T.)
	oMt1:lPercentage := .F.
	oMt1:Hide()
    DEFINE SBUTTON oBDir FROM 014, 220 TYPE 14 OF oDgA ENABLE Action( cGtDir := cGetFile( '' , 'Salvar Arquivo', 1, 'C:\', .F., nOR( GETF_RETDIRECTORY, GETF_LOCALHARD, GETF_NETWORKDRIVE ), .F., .T. ) )
    DEFINE SBUTTON oBOk FROM 032, 186 TYPE 01 OF oDgA ENABLE  Action( oBOk:lActive:=.F.,oBNo:lActive:=.F.,oBPar:lActive:=.F.,oBDir:lActive:=.F.,Iif(Proc001(cGtDir,@nMt1,@oMt1,@oDgA),oDgA:End(),(oBOk:lActive:=.T.,oBNo:lActive:=.T.,oBPar:lActive:=.T.,oBDir:lActive:=.T.)) )
    DEFINE SBUTTON oBNo FROM 032, 220 TYPE 02 OF oDgA ENABLE  Action( oDgA:End() )
    DEFINE SBUTTON oBPar FROM 032, 005 TYPE 05 OF oDgA ENABLE Action( Pergunte("TFCTB01001",.T.) )

  ACTIVATE MSDIALOG oDgA CENTERED

EndIf

Return(Nil)



//-----------------------------------------------------------------------------
// Programa      PROC001
// Autor         Ronald Piscioneri
// Data          11-Maio-2021
// Descricao     Processamento (geracao da planilha)
// Uso           Especifico Taiff - Proart
//-----------------------------------------------------------------------------
Static Function Proc001(cGtDir,nMt1,oMt1,oDgA)
Local oExcel 	:= Nil
Local oExcelApp	:= Nil
Local cMsg		:= ""
Local cAba		:= "CTE"
Local cTabela	:= "CTE"
Local cArquivo	:= "CTE_" + DToS( Date() ) + ".xls"
Local cPathSys	:= GetSrvProfString( "StartPath", "\system\" )
Local aDatXL    := {}
Local nNx       := 0
Local lRet		:= .T.
Local nPass		:= 0
Local nCtrl		:= 0

nMt1 := 0

If Empty(cGtDir)

	lRet := .F.
	cMsg := "Escolha a pasta em que a planilha sera gravada"

EndIf

If lRet

	MsgRun("Obtendo Dados...","Aguarde...",{||RetDat(@aDatXL)})

	If Len( aDatXL ) == 0
		lRet := .F.
		cMsg := "Nao ha dados. Verifique parametros."
	EndIf

EndIf

If lRet

	nPass := Round( Len(aDatXL) / 100, 0)
	oMt1:Show()
	oMt1:Refresh()
	oDgA:Refresh()

	oExcel:=FWMSExcel():New()
	oExcel:AddWorkSheet(cAba)
	oExcel:AddTable(cAba, cTabela)
	oExcel:AddColumn(cAba, cTabela, "FILIAL"        , 1, 1, .F.)
	oExcel:AddColumn(cAba, cTabela, "CTE"           , 1, 1, .F.)
	oExcel:AddColumn(cAba, cTabela, "FATURA"	    , 1, 1, .F.)
	oExcel:AddColumn(cAba, cTabela, "EMISSAO FAT"   , 1, 1, .F.)
	
	For nNx := 1 to Len( aDatXL )

		If nNx > nCtrl
			nMt1++
			oMt1:Set(nMt1)
			oMt1:Refresh()
			oDgA:Refresh()
			nCtrl += nPass
		EndIf

		oExcel:AddRow(  cAba,;
						cTabela,;
						{   aDatXL[nNx,01],;
							aDatXL[nNx,02],;
							aDatXL[nNx,03],;
							aDatXL[nNx,04] } )

		oMt1:Refresh()

	Next nNx
		
	If !Empty(oExcel:aWorkSheet)

		nMt1++
		oMt1:Set(nMt1)
		oMt1:Refresh()
		oDgA:Refresh()

		oExcel:Activate()
		MsgRun("Gravando Planilha...","Aguarde...",{||oExcel:GetXMLFile(cArquivo)})

		MsgRun("Copiando Planilha para a Estacao...","Aguarde...",{||CpyS2T(cPathSys+cArquivo,cGtDir)})

		oExcelApp := MsExcel():New()
		MsgRun("Abrindo Excel...","Aguarde...",{||oExcelApp:WorkBooks:Open(cGtDir+cArquivo)})
		oExcelApp:SetVisible(.T.)
		oExcelApp:Destroy()
		FErase(cPathSys+cArquivo)

	Else

		lRet := .F.
		cMsg := "Nao foi possivel gravar a planilha na pasta escolhida. Escolha outra pasta."

	EndIf

EndIf

If !Empty(cMsg)
	Alert(cMsg)
EndIf

Return(lRet)



//-----------------------------------------------------------------------------
// Funcao       RETDAT
// Autor        Ronald Piscioneri
// Data         07-Mai-2021
// Descricao    Retorna Dados em Array
//-----------------------------------------------------------------------------
Static Function RetDat(aDatXL)
Local cQry := ""

cQry := "SELECT "
cQry += "CODFIL = PAV.PAV_FILIAL, "
cQry += "NUMCTE = PAV.PAV_CTO, "
cQry += "NUMFAT = PAV.PAV_FATURA, "
cQry += "EMIFAT = PAV.PAV_EMISFA "
cQry += "FROM "+RetSqlName("PAV")+" PAV "
cQry += "WHERE PAV.D_E_L_E_T_ = ' ' "
cQry += "AND PAV.PAV_FILIAL BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"' "
cQry += "AND PAV.PAV_EMISFA BETWEEN '"+DtoS(MV_PAR03)+"' AND '"+DtoS(MV_PAR04)+"' "
cQry += "ORDER BY CODFIL, NUMCTE, NUMFAT"

Iif(Select("AWRK")>0,AWRK->(dbCloseArea()),Nil)
dbUseArea(.T.,"TOPCONN",TCGenQry(,,cQry),"AWRK",.T.,.T.)
AWRK->(dbGoTop())

If AWRK->(!EoF())

	While AWRK->(!EoF())

		aAdd( aDatXL, { AWRK->CODFIL,;
						AWRK->NUMCTE,;
						AWRK->NUMFAT,;
						SubStr(AWRK->EMIFAT,7,2)+"/"+SubStr(AWRK->EMIFAT,5,2)+"/"+SubStr(AWRK->EMIFAT,1,4) })
		AWRK->(dbSkip())

	EndDo
EndIf
AWRK->(dbCloseArea())

Return(Nil)



//-----------------------------------------------------------------------------
// Funcao       CHKPRG
// Autor        Ronald Piscioneri
// Data         07-Mai-2021
// Descricao    Cadastra as perguntas no SX1
//-----------------------------------------------------------------------------
Static Function ChkPrg()
Local aAtuArea := GetArea()
Local aSX1Area := SX1->(GetArea())

dbSelectArea("SX1")
SX1->(dbSetOrder(1))

If SX1->(!dbSeek("TFCTB01001")) 

	If SX1->(!dbSeek("TFCTB0100101"))
		RecLock("SX1",.T.)
		SX1->X1_GRUPO	:= "TFCTB01001"
		SX1->X1_ORDEM	:= "01"
		SX1->X1_PERGUNT	:= "Da Filial"
		SX1->X1_PERSPA	:= "Da Filial"
		SX1->X1_PERENG	:= "Da Filial"
		SX1->X1_VARIAVL	:= "MV_CH1"
		SX1->X1_VAR01 	:= "MV_PAR01"
		SX1->X1_TIPO	:= "C"
		SX1->X1_TAMANHO	:= 2
		SX1->X1_DECIMAL	:= 0
		SX1->X1_PRESEL	:= 0
		SX1->X1_GSC		:= "G"
		SX1->X1_F3		:= "SM0"
		SX1->X1_PYME	:= "S"
		SX1->(MsUnLock())
	EndIf
	
	If SX1->(!dbSeek("TFCTB0100102"))
		RecLock("SX1",.T.)
		SX1->X1_GRUPO	:= "TFCTB01001"
		SX1->X1_ORDEM	:= "02"
		SX1->X1_PERGUNT	:= "Ate a Filial"
		SX1->X1_PERSPA	:= "Ate a Filial"
		SX1->X1_PERENG	:= "Ate Filial"
		SX1->X1_VARIAVL	:= "MV_CH2"
		SX1->X1_VAR01 	:= "MV_PAR02"
		SX1->X1_TIPO	:= "C"
		SX1->X1_TAMANHO	:= 2
		SX1->X1_DECIMAL	:= 0
		SX1->X1_PRESEL	:= 0
		SX1->X1_GSC		:= "G"
		SX1->X1_F3		:= "SM0"
		SX1->X1_PYME	:= "S"
		SX1->(MsUnLock())
	EndIf

	If SX1->(!dbSeek("TFCTB0100103"))
		RecLock("SX1",.T.)
		SX1->X1_GRUPO	:= "TFCTB01001"
		SX1->X1_ORDEM	:= "03"
		SX1->X1_PERGUNT	:= "Emis. Fat. De"
		SX1->X1_PERSPA	:= "Emis. Fat. De"
		SX1->X1_PERENG	:= "Emis. Fat. De"
		SX1->X1_VARIAVL	:= "MV_CH3"
		SX1->X1_VAR01 	:= "MV_PAR03"
		SX1->X1_TIPO	:= "D"
		SX1->X1_TAMANHO	:= 8
		SX1->X1_DECIMAL	:= 0
		SX1->X1_PRESEL	:= 0
		SX1->X1_GSC		:= "G"
		SX1->X1_PYME	:= "S"
		SX1->(MsUnLock())
	EndIf

	If SX1->(!dbSeek("TFCTB0100104"))
		RecLock("SX1",.T.)
		SX1->X1_GRUPO	:= "TFCTB01001"
		SX1->X1_ORDEM	:= "04"
		SX1->X1_PERGUNT	:= "Emis. Fat. Ate"
		SX1->X1_PERSPA	:= "Emis. Fat. Ate"
		SX1->X1_PERENG	:= "Emis. Fat. Ate"
		SX1->X1_VARIAVL	:= "MV_CH4"
		SX1->X1_VAR01 	:= "MV_PAR04"
		SX1->X1_TIPO	:= "D"
		SX1->X1_TAMANHO	:= 8
		SX1->X1_DECIMAL	:= 0
		SX1->X1_PRESEL	:= 0
		SX1->X1_GSC		:= "G"
		SX1->X1_PYME	:= "S"
		SX1->(MsUnLock())
	EndIf

EndIf

RestArea(aSX1Area)
RestArea(aAtuArea)

Return(Nil)
