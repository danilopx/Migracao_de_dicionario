#INCLUDE "PROTHEUS.CH"
#INCLUDE "Topconn.ch"
#INCLUDE "rwmake.ch"

//--------------------------------------------------------------------------------------------------------------
// FUNCAO: TFCARPV                                        AUTOR: CARLOS TORRES                 DATA: 19/10/2011
// DESCRICAO: PE para ativar botoes na rotina MATA241 - Movimentos Internos
//--------------------------------------------------------------------------------------------------------------

User Function TFCARPV()
	Local lReturn := .T.
	Local cSql    := ""
	Local aLinha  := ""
	// Local cArmOri := ""
	// Local cArmDes := ""
	Local cPerg   := Avkey("TFLoadPED","X1_GRUPO")
	Local cAlias  := Alias()
	Local aGetArea:= GetArea()

	Local nPosPed := aScan( aHeader, {|x| upper(alltrim(x[2])) =="D3_NUM_PED"	}	)
	Local nPosCod := aScan(	aHeader, {|x| upper(alltrim(x[2])) =="D3_COD"		}	)
	Local nPosUnd := aScan(	aHeader, {|x| upper(alltrim(x[2])) =="D3_UM"			}	)
	Local nPosQtd := aScan(	aHeader, {|x| upper(alltrim(x[2])) =="D3_QUANT"		}	)
	Local nPosQt2 := aScan(	aHeader, {|x| upper(alltrim(x[2])) =="D3_QTSEGUM"	}	)
	Local nPosVld := aScan(	aHeader, {|x| upper(alltrim(x[2])) =="D3_DTVALID"	}	)
	Local nPosLcl := aScan(	aHeader, {|x| upper(alltrim(x[2])) =="D3_LOCAL"		}	)
	Local nPosSrv := aScan(	aHeader, {|x| upper(alltrim(x[2])) =="D3_SERVIC"	}	)
	Local nPosUn2 := aScan(	aHeader, {|x| upper(alltrim(x[2])) =="D3_SEGUM"		}	)

	local nOpc := 1

	Local _cTmovi     := Getmv("MV_XTPMOV")

	Static oDlg
	Static oButton1
	Static oButton2
	Static oPedVend
	Static cPedVend := GetMv("MV_TFNPED", , space(6) )
	Static cCodSerWMS := Getmv("MV_XSERWMS")
	Static oSay1



	If Alltrim(CTM) == Alltrim(_cTmovi)
		aHelpPor := {}
		aAdd( aHelpPor, "Informe o numero do " )
		aAdd( aHelpPor, "Pedido de Venda" )
		PutSx1(cPerg, "01", "Num do Ped Venda", "Num do Ped Venda", "Num do Ped Venda", "mv_ch1", "C", 06, 0, 0, "G", "", "", "", "", "MV_PAR01", "", "", "", "", "", "", "", "", "", "", "", "", "", "SC5", "", "", aHelpPor, aHelpPor, aHelpPor)
		
		DEFINE MSDIALOG oDlg TITLE "Endereçamento" FROM 000, 000  TO 150, 350 COLORS 0, 16777215 PIXEL
		
		@ 009, 008 SAY oSay1 PROMPT "Num do Pedido:" SIZE 040, 007 OF oDlg COLORS 0, 16777215 PIXEL
		@ 009, 048 MSGET oPedVend VAR cPedVend SIZE 060, 010 OF oDlg COLORS 0, 16777215 PIXEL
		
		DEFINE SBUTTON FROM 009, 122 TYPE 01 ENABLE OF oDlg ACTION (nOpc := 1, oDlg:End())
		DEFINE SBUTTON FROM 030, 122 TYPE 02 ENABLE OF oDlg ACTION (nOpc := 0, oDlg:End())
		
		ACTIVATE MSDIALOG oDlg
		
		if nOpc == 1 .and. !Empty( cPedVend )
		
			if (Posicione("SC5",1,xFilial("SC5")+cPedVend,"C5_TIPO") <> "B")
				Aviso( "Inconsistência - Rotina: TFCARPV" , "O pedido informado não é do tipo 'B'",	{"Ok"}, 	3)
				Return nil	
			endif
			
			if !Empty( Posicione("SC6",1,xFilial("SC6")+cPedVend,"C6_DOC_END") )
				Aviso( "Inconsistência - Rotina: TFCARPV" , "O pedido já foi Transferido",	{"Ok"}, 	3)
				Return nil		
			endif
		
			cSQL := "SELECT SC6.*, "
			cSQL += "(SC6.C6_QTDVEN - SC6.C6_QTDENT) QTD_DISP, "
			cSQL += "(SC6.C6_UNSVEN - SC6.C6_QTDENT2) QTD_DISP2 "	
			cSQL += "from " + RetSqlName("SC6") + " SC6 "
			cSQL += "WHERE (SC6.C6_QTDVEN - SC6.C6_QTDENT) > 0 AND SC6.C6_NUM = '" + cPedVend + "' "
			cSQL += "AND SC6.D_E_L_E_T_ <> '*' "	
			cSQL += "ORDER BY SC6.C6_ITEM"
		
			DbUseArea(.T., "TOPCONN", TcGenQry(,, cSql), "TMPC6", .T., .T.) 
			aLinha := aClone(aCols[1])	
			
			TMPC6->( DbGotop() )
			while !TMPC6->( eof() )
				if (Posicione("SF4",1,xFilial("SF4")+TMPC6->C6_TES,"F4_ESTOQUE") == "S")    
		
					aTail(aCols)[nPosCod]	:= TMPC6->C6_PRODUTO   
					aTail(aCols)[3]			:= TMPC6->C6_DESCRI   			
					aTail(aCols)[nPosUnd]	:= TMPC6->C6_UM   			
					aTail(aCols)[nPosUn2]	:= TMPC6->C6_SEGUM
					aTail(aCols)[nPosQtd]	:= TMPC6->QTD_DISP  
					aTail(aCols)[nPosQt2]	:= TMPC6->QTD_DISP2 
					aTail(aCols)[nPosPed]  	:= TMPC6->C6_NUM+TMPC6->C6_ITEM+TMPC6->C6_PRODUTO		
					aTail(aCols)[nPosVld]  	:= ctod("  /  /  ")
					aTail(aCols)[nPosLcl]	:= "02"
					aTail(aCols)[nPosSrv]	:= cCodSerWMS
				
					aAdd(aCols, aClone(aLinha))	  
				endif	
				TMPC6->( DbSkip() )	
			enddo
			TMpC6->( DBCloseArea() )
		endif
	Else
		Aviso( "Inconsistência - Rotina: TFCARPV" , "Tipo de movimento não corresponde ao Carrega PV!",	{"Ok"}, 	3)
	EndIf	
	RestArea(aGetArea)
	DbSelectArea(cAlias)

return lReturn

