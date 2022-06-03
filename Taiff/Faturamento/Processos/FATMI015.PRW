#Include 'rwmake.ch'
#INCLUDE "TOPCONN.CH"
#Include 'Protheus.ch'

#DEFINE ENTER Chr(13)+Chr(10)
//+--------------------------------------------------------------------------------------------------------------
//| ROTINA: FATMI015  				                    AUTOR: CARLOS ALDAY TORRES           DATA: 28/07/2020   |
//+--------------------------------------------------------------------------------------------------------------
//| DESCRICAO: Tabela de horarios de processamento da liberação automatica (ESTMI001.PRW)
//| OBSERVACAO: 
//+--------------------------------------------------------------------------------------------------------------

User Function FATMI015()
	Private cCadastro := "Horarios Lib. Autom."
	Private oVeLogPed

	@ 200,001 TO 480,380 DIALOG oVeLogPed TITLE OemToAnsi("Horarios Lib. Autom.")
	@ 003,005 TO 085,187 PIXEL OF oVeLogPed
	@ 010,018 Say "Este programa tem a finalidade de alterar horarios " SIZE 150,010 PIXEL OF oVeLogPed
	@ 020,018 Say "da liberação automática de pedidos de venda." SIZE 150,010 PIXEL OF oVeLogPed
	@ 065,008 BUTTON "Continua  "  ACTION (Processa({||FATMI1501()}),oVeLogPed:End())PIXEL OF oVeLogPed
	@ 100,008 BMPBUTTON TYPE 02 ACTION oVeLogPed:End()

	Activate Dialog oVeLogPed Centered


Return

Static Function FATMI1501

	Local nOpc		:= 0
	Local aTFSize := {}
	Local aPosObj := {}
	LOCAL cCodUsu   := RetCodUsr()
	Local oBmp2, oBmp3

	Private aDados	:= {}
	Private oDlgPedidos
	Private _cAlias2	:= ""
	PRIVATE lRetorno  := .T.
	PRIVATE L15ACESSA	:= .T.

    cQuery := " SELECT COUNT(ZV_CODUSU) NCOUNT FROM SZV010 SZV WITH(NOLOCK)" + ENTER
    cQuery += " WHERE ZV_CODUSU = '" + cCodUsu + "' AND ZV_FUNCAO IN ('FATMI015') " + ENTER
    cQuery += " AND ZV_MSBLQL <> '1' AND D_E_L_E_T_ <> '*' AND ZV_ATIVO = 'S'" + ENTER
    cQuery += " AND ZV_FILUSO LIKE '%4%'" + ENTER

    //MemoWrite("CHECAFUNC.SQL",cQuery)
    If  Select("TRBCH") > 0
	    TRBCH->(Dbclosearea())
    Endif

    dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),"TRBCH", .F., .T.)

    dbSelectArea("TRBCH")
    If TRBCH->NCOUNT = 0
        L15ACESSA	:= .F.
    EndIf
    TRBCH->(Dbclosearea())

	If .NOT. (CEMPANT="03" .AND. CFILANT="02") .AND. lRetorno
		MsgStop("A consulta não está disponivel nesta empresa/filial!","Atenção")
        lRetorno  := .F.
	EndIf

	IF lRetorno 

		aTFSize := MsAdvSize(.F.)

		aCampos	:= {}
		_cPesqPed	:= Space(6)
		_nTotal	:= 0
		_cMarca	:= ""
		Cursorwait()

		//cQuery := "SELECT * " + ENTER
		//cQuery += "FROM "+RetSqlName("ZAW")+" ZAW WITH(NOLOCK) " + ENTER
		//MemoWrite("FATMI015.SQL",cQuery)
		
		cQuery := "SELECT " + ENTER
		cQuery += "		HR_PROCESSA AS ZAW_HORA_P" + ENTER
		cQuery += "		,DIA_PROCESSA AS ZAW_DIA_P" + ENTER
		cQuery += "		,'TAIFF' AS ZAW_MARCA" + ENTER
		cQuery += "     ,STATUS AS ZAW_STATUS" + ENTER
		cQuery += "FROM TBL_ESTMI001_HORA ZAW WITH(NOLOCK) " + ENTER

		dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), (_cAlias2 := GetNextAlias()), .F., .T.)

		Count To nRec1

		If nRec1 == 0
			MsgStop("Não existem pedidos a apresentar com os parâmetros informados!","Atenção")
			CursorArrow()
			(_cAlias2)->(dbCloseArea())
			Return
		EndIf


		dbSelectArea((_cAlias2))
		ProcRegua(nRec1)
		dbGotop()

		aDados	 := {}
		While !Eof()
			IncProc("Montando os itens a serem selecionados")

			aAdd(aDados,{fColor(), (_cAlias2)->ZAW_HORA_P, (_cAlias2)->ZAW_DIA_P, (_cAlias2)->ZAW_MARCA, (_cAlias2)->ZAW_STATUS} )

			dbSelectArea((_cAlias2))
			dbSkip()
		End
		lNota := .F.
		CursorArrow()

		If Len(aDados) == 0
			MsgStop("Não existem pedidos a apresentar com os parâmetros informados!","Atenção")
			(_cAlias2)->(dbCloseArea())
			Return
		EndIf

	//MONTA O CABECALHO
		cFields := " "
		nCampo 	:= 0

		aTitCampos := {" ",OemToAnsi("Horario"),OemToAnsi("Periodo"),OemToAnsi("Marca"),OemToAnsi("Status")}

		cLine := "{aDados[oListBox:nAT][1],aDados[oListBox:nAt,2],"
		cLine += " aDados[oListBox:nAT][3],aDados[oListBox:nAT][4],aDados[oListBox:nAT][5],}"

		bLine := &( "{ || " + cLine + " }" )

		@ aTFSize[7],0 To aTFSize[6],aTFSize[5] DIALOG oDlgPedidos TITLE "Horários da liberação automática de pedidos de vendas"

		aCoord2 := {}

		oSize := FwDefSize():New(.T.,,,oDlgPedidos)             

		oSize:AddObject('GRID'  ,100,80,.T.,.T.)
		oSize:AddObject('FOOT'  ,100,40 ,.T.,.F.)	

		oSize:lProp 		:= .T. // Proporcional             
		oSize:aMargins 	:= { 3, 3, 3, 3 } // Espaco ao lado dos objetos 0, entre eles 3 
		
		oSize:Process() 	   // Dispara os calculos   

		aAdd(aPosObj,{oSize:GetDimension('GRID'  , 'LININI'),oSize:GetDimension('GRID'  , 'COLINI'),oSize:GetDimension('GRID'  , 'XSIZE')-15,oSize:GetDimension('GRID'  , 'YSIZE')})
		aAdd(aPosObj,{oSize:GetDimension('FOOT'  , 'LININI'),oSize:GetDimension('FOOT'  , 'COLINI'),oSize:GetDimension('FOOT'  , 'LINEND'),oSize:GetDimension('FOOT'  , 'COLEND')})

		oListBox := TWBrowse():New(aPosObj[1][1],aPosObj[1][2],aPosObj[1][3],aPosObj[1][4],,aTitCampos,aCoord2,oDlgPedidos,,,,,,,,,,,"atenção",.F.,,.T.,,.F.,,,)

		oListBox:SetArray(aDados)
		oListBox:bLDblClick := { || FATMI1502() } 
		oListBox:bLine := bLine
		oListBox:cMsg := "Duplo click para alterar status"


		@ aPosObj[2][1],aPosObj[2][2]+10 SAY "* - Todos os dias "  OF oDlgPedidos Color CLR_BLACK,CLR_WHITE PIXEL
		@ aPosObj[2][1],aPosObj[2][2]+430 BUTTON "Sair"       	SIZE 40,15 ACTION {nOpc :=0,oDlgPedidos:End()} PIXEL OF oDlgPedidos

		//@ aPosObj[2][1]+20,aPosObj[2][2]+065 BITMAP oBmp2 ResName "BR_VERDE" OF oDlgPedidos Size 10,10 NoBorder When .F. Pixel
		//@ aPosObj[2][1]+20,aPosObj[2][2]+075 SAY "Em espera" OF oDlgPedidos Color CLR_GREEN,CLR_WHITE PIXEL
		@ aPosObj[2][1]+20,aPosObj[2][2]+115 BITMAP oBmp3 ResName "BR_VERMELHO" OF oDlgPedidos Size 10,10 NoBorder When .F. Pixel
		@ aPosObj[2][1]+20,aPosObj[2][2]+125 SAY "Desabilitado" OF oDlgPedidos Color CLR_RED,CLR_WHITE PIXEL
		@ aPosObj[2][1]+20,aPosObj[2][2]+215 BITMAP oBmp2 ResName "BR_AZUL" OF oDlgPedidos Size 10,10 NoBorder When .F. Pixel
		@ aPosObj[2][1]+20,aPosObj[2][2]+225 SAY "Habilitado" OF oDlgPedidos Color CLR_BLUE,CLR_WHITE PIXEL

		ACTIVATE DIALOG oDlgPedidos CENTERED

		(_cAlias2)->(dbCloseArea())

		If nOpc == 1
		EndIf
	ENDIF
Return(.T.)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ???
??ºPrograma  ?fColor    ºAutor  ?C. TORRES           º Data ?  16/02/2018 º??
??ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ???
??ºDesc.     ?                                                            º??
??º          ?                                                            º??
??ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ???
??ºUso       ? AP                                                         º??
??ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ???
?????????????????????????????????????????????????????????????????????????????
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function fColor()

If ALLTRIM((_cAlias2)->ZAW_STATUS) ="HABILITADO"    
	Return(LoadBitMap(GetResources(),"BR_AZUL"   ))
ElseIf EMPTY((_cAlias2)->ZAW_STATUS) .OR. ALLTRIM((_cAlias2)->ZAW_STATUS) = "DESABILITADO"  
	Return(LoadBitMap(GetResources(),"BR_VERMELHO"   ))
Endif

Return

Static Function FATMI1502()
LOCAL lRETORNO	:= .T.
LOCAL cQuery	:= ""

IF .NOT. L15ACESSA
	MSGALERT("Acesso nao permitido para manutenção! Solicite à gestão da adm. de vendas a manutenção","FATMI015 - Liber. Automatica")
ELSEIF SUBSTRING(TIME(),1,5) = oListBox:AARRAY[oListBox:nAt][2]
	MSGALERT("Horário atual idêntico ao horário programado, não permite alteração!" ,"FATMI015 - Liber. Automatica")
ELSE
	IF msgYesNo("Confirma realmente a alteração do status do horário?")
		IF ALLTRIM(oListBox:AARRAY[oListBox:nAt][5]) = "HABILITADO"
			oListBox:AARRAY[oListBox:nAt][1]:=LoadBitMap(GetResources(),"BR_VERMELHO"   )
			oListBox:AARRAY[oListBox:nAt][5] = "DESABILITADO"
			/*
			ZAW->(DBSETORDER(1))
			IF ZAW->(DBSEEK( xFilial("ZAW") + oListBox:AARRAY[oListBox:nAt][4] + oListBox:AARRAY[oListBox:nAt][2]))
				IF ZAW->(RecLock("ZAW",.F.))
					ZAW->ZAW_STATUS := "DESABILITADO"
					ZAW->(MsUnlock())
				ENDIF
			ENDIF
			*/
			cQuery := "UPDATE ZAW SET " + ENTER
			cQuery += "		STATUS = 'DESABILITADO' " + ENTER
			cQuery += "FROM TBL_ESTMI001_HORA ZAW " + ENTER
			cQuery += "WHERE HR_PROCESSA = '" + oListBox:AARRAY[oListBox:nAt][2] + "'" + ENTER

			If TcSqlExec(cQuery) <0
				UserException( "Erro na atualização"+ Chr(13)+Chr(10) + "Processo com erros"+ Chr(13)+Chr(10) + TCSqlError() )
			EndIf
			
		ELSE
			oListBox:AARRAY[oListBox:nAt][1]:=LoadBitMap(GetResources(),"BR_AZUL"   )
			oListBox:AARRAY[oListBox:nAt][5] = "HABILITADO"
			/*
			ZAW->(DBSETORDER(1))
			IF ZAW->(DBSEEK( xFilial("ZAW") + oListBox:AARRAY[oListBox:nAt][4] + oListBox:AARRAY[oListBox:nAt][2]))
				IF ZAW->(RecLock("ZAW",.F.))
					ZAW->ZAW_STATUS := "HABILITADO"
					ZAW->(MsUnlock())
				ENDIF
			ENDIF
			*/
			cQuery := "UPDATE ZAW SET " + ENTER
			cQuery += "		STATUS = 'HABILITADO' " + ENTER
			cQuery += "FROM TBL_ESTMI001_HORA ZAW " + ENTER
			cQuery += "WHERE HR_PROCESSA = '" + oListBox:AARRAY[oListBox:nAt][2] + "'" + ENTER

			If TcSqlExec(cQuery) <0
				UserException( "Erro na atualização"+ Chr(13)+Chr(10) + "Processo com erros"+ Chr(13)+Chr(10) + TCSqlError() )
			EndIf
		ENDIF	
	ENDIF
ENDIF
RETURN (lRETORNO)
