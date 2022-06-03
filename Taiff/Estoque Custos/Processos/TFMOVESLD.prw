#include 'protheus.ch'
#include 'parmtype.ch'
#INCLUDE "Topconn.ch"
#Include "tbiconn.ch"

#DEFINE ENTER CHR(13) + CHR(10)



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³TFMOVESLD º Autor ³Carlos Torres     º Data ³  30/01/2020   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Funcionalidade para transferencia de saldos PROART         º±±
±±º          ³ para o armazem padrão Projeto remoção do flow rack         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Generico                                                   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
user function TFMOVESLD()
LOCAL ODLG
LOCAL OSAY01
LOCAL CSAY01		:= "Marca"
LOCAL OSAY02
LOCAL CSAY02		:= "Etapa"
LOCAL OBTN
LOCAL LOK			:= .F.
LOCAL CMI01MARCA	:= SPACE(009)
LOCAL CMI02ETAPA	:= SPACE(009)
LOCAL AMARCAS		:= {"TAIFF","PROART"}
LOCAL AETAPAS		:= {"Trasf EXP","Carga Picking","Carga PRE-Picking"}
LOCAL oObj           

ODLG   := MSDIALOG():NEW(001,001,230,300,'Transfere saldos EXP',,,,,CLR_BLACK,CLR_WHITE,,,.T.)
OSAY01 := TSAY():NEW(010,010, {|| CSAY01},ODLG,,,,,, .T., CLR_BLUE,CLR_WHITE )
OSAY02 := TSAY():NEW(030,010, {|| CSAY02},ODLG,,,,,, .T., CLR_BLUE,CLR_WHITE )
OCMB01 := TCOMBOBOX():NEW(010		,060		, {|U| IF(PCOUNT()>0,CMI01MARCA:=U,CMI01MARCA)}	,AMARCAS		,060			,009			,ODLG		,				,				,				,				,				,.T.			,				,				,				,				,				,				,				,				,'CMI01MARCA')
OCMB02 := TCOMBOBOX():NEW(030		,060		, {|U| IF(PCOUNT()>0,CMI02ETAPA:=U,CMI02ETAPA)}	,AETAPAS		,060			,009			,ODLG		,				,				,				,				,				,.T.			,				,				,				,				,				,				,				,				,'CMI02ETAPA')
OBTN   := TBUTTON():NEW(090,010,'OK'		,ODLG,{|| LOK 		:= .T.,ODLG:END()},40,10,,,,.T.)
OBTN   := TBUTTON():NEW(090,100,'Cancelar'	,ODLG,{|| LCANCEL 	:= .T.,ODLG:END()},40,10,,,,.T.)

ODLG:ACTIVATE(,,,.T.)

WHILE !LOK .AND. !LCANCEL

ENDDO

IF LOK	

	If (CMI01MARCA = "PROART" ) .AND. (CMI02ETAPA="Trasf EXP")
		If MsgYesNo("Inicia a transferencia em massa do saldo por endereço para o endereço EXP?")     
			oObj := MsNewProcess():New({|lEnd| Processar(oObj, @lEnd)}, "", "", .T.)
			oObj :Activate()
		EndIf
	ElseIf (CMI01MARCA = "PROART" ) .AND. (CMI02ETAPA="Carga Picking")
		If MsgYesNo("Inicia a transferencia do endereço EXP ao inventario Picking?")     
			oObj := MsNewProcess():New({|lEnd| Cargar(oObj, @lEnd)}, "", "", .T.)
			oObj :Activate()
		EndIf
	ElseIf (CMI01MARCA = "PROART" ) .AND. (CMI02ETAPA="Carga PRE-Picking")
		If MsgYesNo("Inicia a transferencia do endereço EXP ao inventario PRE-Picking?")     
			oObj := MsNewProcess():New({|lEnd| PRECargar(oObj, @lEnd)}, "", "", .T.)
			oObj :Activate()
		EndIf

	ElseIf (CMI01MARCA = "TAIFF" )
		MsgAlert("Transferencia de armazens em massa não disponível para marca TAIFF.")
	EndIf      

ENDIF
Return

Static Function Processar(oObj,lEnd)

LOCAL cQry 		:= ""
Local aAuto 	:= {}
LOCAL aLinha	:= {}
Local _nProc	:= 1
LOCAL _nRec		:= 0

Private lMsErroAuto := .F.
Private cAliasOS	:= GetNextAlias()

cQry 	:= "SELECT" + ENTER
cQry 	+= "	BF_PRODUTO AS PRODUTO" + ENTER
cQry 	+= "	,BF_LOCALIZ AS ORIGEM" + ENTER
cQry 	+= "	,BF_LOCAL " + ENTER
cQry 	+= "	,BF_QUANT-BF_EMPENHO AS BF_SALDO" + ENTER
cQry 	+= "	,'EXP' AS DESTINO" + ENTER
cQry 	+= "FROM SBF030 SBF " + ENTER
cQry 	+= "INNER JOIN SB1030 SB1" + ENTER 
cQry 	+= "	ON B1_FILIAL=BF_FILIAL " + ENTER
cQry 	+= "	AND B1_COD=BF_PRODUTO " + ENTER
cQry 	+= "	AND SB1.D_E_L_E_T_ ='' " + ENTER
cQry 	+= "	AND B1_CODFAM IN ('460','461','462','463','465','466') " + ENTER
cQry 	+= "WHERE BF_FILIAL='02' " + ENTER
cQry 	+= "	AND SBF.D_E_L_E_T_ ='' " + ENTER
cQry 	+= "	AND BF_LOCAL='21' " + ENTER
cQry 	+= "	AND BF_QUANT > 0 " + ENTER
cQry 	+= "	AND BF_LOCALIZ NOT IN ('EXP') " + ENTER

MemoWrite("TFMOVESLD_TRANSFERE_EXP.sql",cQry)

DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQry),cAliasOS,.f.,.f.)
	
COUNT TO _nRec
oObj:SetRegua1(_nRec)

(cAliasOS)->(DbGoTop())

aadd(aAuto,{GetSxeNum("SD3","D3_DOC"),dDataBase}) //Cabecalho


While !(cAliasOS)->(Eof()) 
	oObj:IncRegua1("Transferindo saldo "+Alltrim(Str(_nProc))+ " de " + Alltrim(Str(_nRec)) + " encontrados.")
	IF (cAliasOS)->ORIGEM != (cAliasOS)->DESTINO .AND. .NOT. EMPTY((cAliasOS)->DESTINO)
		dbSelectArea("SB1")
		dbSetOrder(1)
		If dbSeek(xFilial("SB1") + (cAliasOS)->PRODUTO)

			SBE->(DbsetOrder(1))  //Cadastro de enderecos
			If !SBE->(DbSeek(xFilial("SBE") + (cAliasOS)->BF_LOCAL + (cAliasOS)->DESTINO, .F.))
				SBE->(RecLock("SBE", .T.))
				SBE->BE_FILIAL := xFilial("SBE")
				SBE->BE_LOCAL  := (cAliasOS)->BF_LOCAL
				SBE->BE_LOCALIZ:= (cAliasOS)->DESTINO
				SBE->BE_DESCRIC:= ""
				SBE->BE_PRIOR  := SUBSTR(ALLTRIM((cAliasOS)->DESTINO),1,3)
				SBE->BE_STATUS := "1"
				SBE->(MsUnLock())
			EndIf
		
			aLinha := {}
			aadd(aLinha,{"ITEM",'00'+cvaltochar(_nProc),Nil})
			aadd(aLinha,{"D3_COD", SB1->B1_COD, Nil}) //Cod Produto origem 
			aadd(aLinha,{"D3_DESCRI", SB1->B1_DESC, Nil}) //descr produto origem 
			aadd(aLinha,{"D3_UM", SB1->B1_UM, Nil}) //unidade medida origem 
			aadd(aLinha,{"D3_LOCAL", (cAliasOS)->BF_LOCAL, Nil}) //armazem origem 
			aadd(aLinha,{"D3_LOCALIZ", PadR((cAliasOS)->ORIGEM, tamsx3('D3_LOCALIZ') [1]),Nil}) //Informar endereço origem
			
			//Destino 
			
			aadd(aLinha,{"D3_COD", SB1->B1_COD, Nil}) //cod produto destino 
			aadd(aLinha,{"D3_DESCRI", SB1->B1_DESC, Nil}) //descr produto destino 
			aadd(aLinha,{"D3_UM", SB1->B1_UM, Nil}) //unidade medida destino 
			aadd(aLinha,{"D3_LOCAL", (cAliasOS)->BF_LOCAL, Nil}) //armazem destino 
			aadd(aLinha,{"D3_LOCALIZ", PadR((cAliasOS)->DESTINO, tamsx3('D3_LOCALIZ') [1]),Nil}) //Informar endereço destino
			
			aadd(aLinha,{"D3_NUMSERI", "", Nil}) //Numero serie
			aadd(aLinha,{"D3_LOTECTL", "", Nil}) //Lote Origem
			aadd(aLinha,{"D3_NUMLOTE", "", Nil}) //sublote origem
			aadd(aLinha,{"D3_DTVALID", '', Nil}) //data validade 
			aadd(aLinha,{"D3_POTENCI", 0, Nil}) // Potencia
			aadd(aLinha,{"D3_QUANT", (cAliasOS)->BF_SALDO, Nil}) //Quantidade
			aadd(aLinha,{"D3_QTSEGUM", 0, Nil}) //Seg unidade medida
			aadd(aLinha,{"D3_ESTORNO", "", Nil}) //Estorno 
			aadd(aLinha,{"D3_NUMSEQ", "", Nil}) // Numero sequencia D3_NUMSEQ
			
			aadd(aLinha,{"D3_LOTECTL", "", Nil}) //Lote destino
			aadd(aLinha,{"D3_NUMLOTE", "", Nil}) //sublote destino 
			aadd(aLinha,{"D3_DTVALID", '', Nil}) //validade lote destino
			aadd(aLinha,{"D3_ITEMGRD", "", Nil}) //Item Grade
			
			aadd(aLinha,{"D3_CODLAN", "", Nil}) //cat83 prod origem
			aadd(aLinha,{"D3_CODLAN", "", Nil}) //cat83 prod destino 
	
		
			AADD(aAuto,aLinha)		
		EndIf
	EndIf
	_nProc ++
	(cAliasOS)->(DbSkip())
End
If Len(aAuto) > 0
	lMsErroAuto := .F.
	lMsHelpAuto := .T.
	
	MSExecAuto({|x,y| mata261(x,y)},aAuto,3)//inclusão
	If lMsErroAuto
	   ConOut("Erro na inclusao!")			
	   MostraErro()
	Else
		MsgAlert("Transferencia de armazens em massa finalizada.")
	EndIf
ELSE
   ConOut("Matriz sem dados!")
EndIf
return

Static Function Cargar(oObj,lEnd)
LOCAL cQry 		:= ""
Local aAuto 	:= {}
LOCAL aLinha	:= {}
Local _nProc	:= 1
LOCAL _nRec		:= 0
LOCAL nSaldoBF	:= 0 
LOCAL CNOMELOG	:= ""
LOCAL CQUERY	:= ""

Private lMsErroAuto := .F.
Private cAliasOS	:= GetNextAlias()

/*
CREATE TABLE TEMP_CT_CARGA_INVENTARIO_FLOWRACK_PROART_2020
(
	AF_PRODUTO VARCHAR(15)
	,AF_LOCALIZ VARCHAR(15)
	,AF_QUANT FLOAT
	,AF_RECNO INT
	,AF_STATUS VARCHAR(100)
	,AF_DTLOG DATETIME
)

*/
IF .NOT. TCCanOpen("TEMP_CT_CARGA_INVENTARIO_FLOWRACK_PROART_2020")
	MSGALERT(OEMTOANSI(	"Tabela de inventario temporario do endereço picking nao existe!"),OEMTOANSI("ERROR"))
	RETURN
ENDIF
cQry 	:= "SELECT" + ENTER
cQry 	+= "	AF_PRODUTO AS PRODUTO " + ENTER
cQry 	+= "	,AF_LOCALIZ AS POS_INV " + ENTER
cQry 	+= "	,AF_QUANT AS QTD_INV " + ENTER
cQry 	+= "	,ISNULL((SELECT B1_ENDNOVO FROM TEMP_CT_CARGA_ENDERECO AUX WHERE AUX.B1_COD = AF_PRODUTO ),'') AS DESTINO " + ENTER
cQry 	+= "	,'EXP' AS ORIGEM " + ENTER
cQry 	+= "	,AF_RECNO " + ENTER
cQry 	+= "	,'21' AS BF_LOCAL " + ENTER
cQry 	+= "FROM TEMP_CT_CARGA_INVENTARIO_FLOWRACK_PROART_2020 AUX " + ENTER
cQry 	+= "WHERE ISNULL(AF_STATUS,'') != 'ATUALIZADO'" + ENTER

MemoWrite("TFMOVESLD_CARGA_PICKING.sql",cQry)

DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQry),cAliasOS,.f.,.f.)
	
COUNT TO _nRec
oObj:SetRegua1(_nRec)

(cAliasOS)->(DbGoTop())

While !(cAliasOS)->(Eof()) 
	oObj:IncRegua1("Transferindo saldo "+Alltrim(Str(_nProc))+ " de " + Alltrim(Str(_nRec)) + " encontrados.")
	cStatus := ""
	
	dbSelectArea("SB1")
	dbSetOrder(1)
	
	DBSELECTAREA("SBF")
	DBSETORDER(1) // BF_FILIAL, BF_LOCAL, BF_LOCALIZ, BF_PRODUTO, BF_NUMSERI, BF_LOTECTL, BF_NUMLOTE, R_E_C_N_O_, D_E_L_E_T_
	DBSEEK(XFILIAL("SBF") + "21" + PADR( ALLTRIM((cAliasOS)->ORIGEM) ,15) + (cAliasOS)->PRODUTO )
	nSaldoBF := SBF->BF_QUANT - SBF->BF_EMPENHO 
	
	If .NOT. SB1->(dbSeek(xFilial("SB1") + (cAliasOS)->PRODUTO))
		cStatus := "NAO ATUALIZADO PRODUTO INFORMADO NAO EXISTE NO CADASTRO DE PRODUTOS"
	ElseIF (cAliasOS)->POS_INV != (cAliasOS)->DESTINO 
		cStatus := "NAO ATUALIZADO POSICAO INVENTARIO DIFERE COM POSICAO PICKING"
	ElseIf EMPTY((cAliasOS)->DESTINO)
		cStatus := "NAO ATUALIZADO POSICAO POSICAO PICKING NAO ENCONTRADA"
	ElseIf (cAliasOS)->QTD_INV = 0
		cStatus := "NAO ATUALIZADO INVENTARIO IGUAL A ZERO"
	ElseIf nSaldoBF = 0 
		cStatus := "NAO ATUALIZADO SALDO NO EXP IGUAL A ZERO"
	ElseIf (cAliasOS)->QTD_INV > nSaldoBF
		cStatus := "NAO ATUALIZADO INVENTARIO SUPERIOR AO SALDO NO EXP "
	ELSEIF (cAliasOS)->POS_INV = (cAliasOS)->DESTINO .AND. .NOT. EMPTY((cAliasOS)->DESTINO)

		aAuto 	:= {}
		aLinha	:= {}
		
		aadd(aAuto,{GetSxeNum("SD3","D3_DOC"),dDataBase}) //Cabecalho

		SBE->(DbsetOrder(1))  //Cadastro de enderecos
		If !SBE->(DbSeek(xFilial("SBE") + (cAliasOS)->BF_LOCAL + (cAliasOS)->DESTINO, .F.))
			SBE->(RecLock("SBE", .T.))
			SBE->BE_FILIAL := xFilial("SBE")
			SBE->BE_LOCAL  := (cAliasOS)->BF_LOCAL
			SBE->BE_LOCALIZ:= (cAliasOS)->DESTINO
			SBE->BE_DESCRIC:= ""
			SBE->BE_PRIOR  := SUBSTR(ALLTRIM((cAliasOS)->DESTINO),1,3)
			SBE->BE_STATUS := "1"
			SBE->(MsUnLock())
		EndIf
		
		aLinha := {}
		aadd(aLinha,{"ITEM",'00'+cvaltochar(_nProc),Nil})
		aadd(aLinha,{"D3_COD", SB1->B1_COD, Nil}) //Cod Produto origem 
		aadd(aLinha,{"D3_DESCRI", SB1->B1_DESC, Nil}) //descr produto origem 
		aadd(aLinha,{"D3_UM", SB1->B1_UM, Nil}) //unidade medida origem 
		aadd(aLinha,{"D3_LOCAL", (cAliasOS)->BF_LOCAL, Nil}) //armazem origem 
		aadd(aLinha,{"D3_LOCALIZ", PadR((cAliasOS)->ORIGEM, tamsx3('D3_LOCALIZ') [1]),Nil}) //Informar endereço origem
		
		//Destino 
		
		aadd(aLinha,{"D3_COD", SB1->B1_COD, Nil}) //cod produto destino 
		aadd(aLinha,{"D3_DESCRI", SB1->B1_DESC, Nil}) //descr produto destino 
		aadd(aLinha,{"D3_UM", SB1->B1_UM, Nil}) //unidade medida destino 
		aadd(aLinha,{"D3_LOCAL", (cAliasOS)->BF_LOCAL, Nil}) //armazem destino 
		aadd(aLinha,{"D3_LOCALIZ", PadR((cAliasOS)->DESTINO, tamsx3('D3_LOCALIZ') [1]),Nil}) //Informar endereço destino
		
		aadd(aLinha,{"D3_NUMSERI", "", Nil}) //Numero serie
		aadd(aLinha,{"D3_LOTECTL", "", Nil}) //Lote Origem
		aadd(aLinha,{"D3_NUMLOTE", "", Nil}) //sublote origem
		aadd(aLinha,{"D3_DTVALID", '', Nil}) //data validade 
		aadd(aLinha,{"D3_POTENCI", 0, Nil}) // Potencia
		aadd(aLinha,{"D3_QUANT", (cAliasOS)->QTD_INV, Nil}) //Quantidade
		aadd(aLinha,{"D3_QTSEGUM", 0, Nil}) //Seg unidade medida
		aadd(aLinha,{"D3_ESTORNO", "", Nil}) //Estorno 
		aadd(aLinha,{"D3_NUMSEQ", "", Nil}) // Numero sequencia D3_NUMSEQ
		
		aadd(aLinha,{"D3_LOTECTL", "", Nil}) //Lote destino
		aadd(aLinha,{"D3_NUMLOTE", "", Nil}) //sublote destino 
		aadd(aLinha,{"D3_DTVALID", '', Nil}) //validade lote destino
		aadd(aLinha,{"D3_ITEMGRD", "", Nil}) //Item Grade
		
		aadd(aLinha,{"D3_CODLAN", "", Nil}) //cat83 prod origem
		aadd(aLinha,{"D3_CODLAN", "", Nil}) //cat83 prod destino 

	
		AADD(aAuto,aLinha)		
		
		If Len(aAuto) > 0
			lMsErroAuto := .F.
			lMsHelpAuto := .T.
			
			MSExecAuto({|x,y| mata261(x,y)},aAuto,3)//inclusão
			If lMsErroAuto
				cStatus := "NAO ATUALIZADO ERRO NO EXECAUTO VER LOG"
				CNOMELOG := "CARGA_PICKING_ERRO_" + Alltrim((cAliasOS)->DESTINO) + ".LOG"
				MOSTRAERRO("\SYSTEM\",CNOMELOG)				  
			Else
				cStatus := "ATUALIZADO"
			EndIf
		ELSE
	   		cStatus := "NAO ATUALIZADO MATRIZ DE DADOS INCOMPLETA"
		EndIf

	EndIf
	 // **** UPDATE ****

	CQUERY := "UPDATE AUX SET" + ENTER
	CQUERY += "		AF_STATUS = '" + ALLTRIM(cStatus) + "'"+ ENTER 
	CQUERY += "		,AF_DTLOG =	GETDATE() "+ ENTER
	CQUERY += "FROM TEMP_CT_CARGA_INVENTARIO_FLOWRACK_PROART_2020 AUX" + ENTER 
	CQUERY += "WHERE " 									+ ENTER 
	CQUERY += "	AF_RECNO = '" + ALLTRIM(STR( (cAliasOS)->AF_RECNO )) + "'" + ENTER 
	
	MEMOWRITE("TFMOVESLD_update_status.sql",CQUERY)
	
	IF TCSQLEXEC(CQUERY) != 0 
		
		MSGALERT(OEMTOANSI(	"Erro ao tentar alterar o Status do endereço picking!"),OEMTOANSI("ERRO"))
		
	ENDIF
		  
	_nProc ++
	(cAliasOS)->(DbSkip())
End
return


Static Function PRECargar(oObj,lEnd)
LOCAL cQry 		:= ""
Local aAuto 	:= {}
LOCAL aLinha	:= {}
Local _nProc	:= 1
LOCAL _nRec		:= 0
LOCAL nSaldoBF	:= 0 
LOCAL CNOMELOG	:= ""
LOCAL CQUERY	:= ""

Private lMsErroAuto := .F.
Private cAliasOS	:= GetNextAlias()

/*
CREATE TABLE TEMP_CT_CARGA_INVENTARIO_FLOWRACK_PROART_2020
(
	AF_PRODUTO VARCHAR(15)
	,AF_LOCALIZ VARCHAR(15)
	,AF_QUANT FLOAT
	,AF_RECNO INT
	,AF_STATUS VARCHAR(100)
	,AF_DTLOG DATETIME
)

*/
IF .NOT. TCCanOpen("TEMP_CT_CARGA_INVENTARIO_FLOWRACK_PROART_2020")
	MSGALERT(OEMTOANSI(	"Tabela de inventario temporario do endereço picking nao existe!"),OEMTOANSI("ERROR"))
	RETURN
ENDIF
cQry 	:= "SELECT" + ENTER
cQry 	+= "	AF_PRODUTO AS PRODUTO " + ENTER
cQry 	+= "	,AF_LOCALIZ AS POS_INV " + ENTER
cQry 	+= "	,AF_QUANT AS QTD_INV " + ENTER
cQry 	+= "	,AF_LOCALIZ AS DESTINO " + ENTER
cQry 	+= "	,'EXP' AS ORIGEM " + ENTER
cQry 	+= "	,AF_RECNO " + ENTER
cQry 	+= "	,'21' AS BF_LOCAL " + ENTER
cQry 	+= "FROM TEMP_CT_CARGA_INVENTARIO_FLOWRACK_PROART_2020 AUX " + ENTER
cQry 	+= "WHERE ISNULL(AF_STATUS,'') != 'ATUALIZADO'" + ENTER

MemoWrite("TFMOVESLD_CARGA_PICKING.sql",cQry)

DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQry),cAliasOS,.f.,.f.)
	
COUNT TO _nRec
oObj:SetRegua1(_nRec)

(cAliasOS)->(DbGoTop())

While !(cAliasOS)->(Eof()) 
	oObj:IncRegua1("Transferindo saldo "+Alltrim(Str(_nProc))+ " de " + Alltrim(Str(_nRec)) + " encontrados.")
	cStatus := ""
	
	dbSelectArea("SB1")
	dbSetOrder(1)
	
	DBSELECTAREA("SBF")
	DBSETORDER(1) // BF_FILIAL, BF_LOCAL, BF_LOCALIZ, BF_PRODUTO, BF_NUMSERI, BF_LOTECTL, BF_NUMLOTE, R_E_C_N_O_, D_E_L_E_T_
	DBSEEK(XFILIAL("SBF") + "21" + PADR( ALLTRIM((cAliasOS)->ORIGEM) ,15) + (cAliasOS)->PRODUTO )
	nSaldoBF := SBF->BF_QUANT - SBF->BF_EMPENHO 
	
	If .NOT. SB1->(dbSeek(xFilial("SB1") + (cAliasOS)->PRODUTO))
		cStatus := "NAO ATUALIZADO PRODUTO INFORMADO NAO EXISTE NO CADASTRO DE PRODUTOS"
	ElseIF (cAliasOS)->POS_INV != (cAliasOS)->DESTINO 
		cStatus := "NAO ATUALIZADO POSICAO INVENTARIO DIFERE COM POSICAO PICKING"
	ElseIf EMPTY((cAliasOS)->DESTINO)
		cStatus := "NAO ATUALIZADO POSICAO POSICAO PICKING NAO ENCONTRADA"
	ElseIf (cAliasOS)->QTD_INV = 0
		cStatus := "NAO ATUALIZADO INVENTARIO IGUAL A ZERO"
	ElseIf nSaldoBF = 0 
		cStatus := "NAO ATUALIZADO SALDO NO EXP IGUAL A ZERO"
	ElseIf (cAliasOS)->QTD_INV > nSaldoBF
		cStatus := "NAO ATUALIZADO INVENTARIO SUPERIOR AO SALDO NO EXP "
	ELSEIF (cAliasOS)->POS_INV = (cAliasOS)->DESTINO .AND. .NOT. EMPTY((cAliasOS)->DESTINO)

		aAuto 	:= {}
		aLinha	:= {}
		
		aadd(aAuto,{GetSxeNum("SD3","D3_DOC"),dDataBase}) //Cabecalho

		SBE->(DbsetOrder(1))  //Cadastro de enderecos
		If !SBE->(DbSeek(xFilial("SBE") + (cAliasOS)->BF_LOCAL + (cAliasOS)->DESTINO, .F.))
			SBE->(RecLock("SBE", .T.))
			SBE->BE_FILIAL := xFilial("SBE")
			SBE->BE_LOCAL  := (cAliasOS)->BF_LOCAL
			SBE->BE_LOCALIZ:= (cAliasOS)->DESTINO
			SBE->BE_DESCRIC:= ""
			SBE->BE_PRIOR  := SUBSTR(ALLTRIM((cAliasOS)->DESTINO),1,3)
			SBE->BE_STATUS := "1"
			SBE->(MsUnLock())
		EndIf
		
		aLinha := {}
		aadd(aLinha,{"ITEM",'00'+cvaltochar(_nProc),Nil})
		aadd(aLinha,{"D3_COD", SB1->B1_COD, Nil}) //Cod Produto origem 
		aadd(aLinha,{"D3_DESCRI", SB1->B1_DESC, Nil}) //descr produto origem 
		aadd(aLinha,{"D3_UM", SB1->B1_UM, Nil}) //unidade medida origem 
		aadd(aLinha,{"D3_LOCAL", (cAliasOS)->BF_LOCAL, Nil}) //armazem origem 
		aadd(aLinha,{"D3_LOCALIZ", PadR((cAliasOS)->ORIGEM, tamsx3('D3_LOCALIZ') [1]),Nil}) //Informar endereço origem
		
		//Destino 
		
		aadd(aLinha,{"D3_COD", SB1->B1_COD, Nil}) //cod produto destino 
		aadd(aLinha,{"D3_DESCRI", SB1->B1_DESC, Nil}) //descr produto destino 
		aadd(aLinha,{"D3_UM", SB1->B1_UM, Nil}) //unidade medida destino 
		aadd(aLinha,{"D3_LOCAL", (cAliasOS)->BF_LOCAL, Nil}) //armazem destino 
		aadd(aLinha,{"D3_LOCALIZ", PadR((cAliasOS)->DESTINO, tamsx3('D3_LOCALIZ') [1]),Nil}) //Informar endereço destino
		
		aadd(aLinha,{"D3_NUMSERI", "", Nil}) //Numero serie
		aadd(aLinha,{"D3_LOTECTL", "", Nil}) //Lote Origem
		aadd(aLinha,{"D3_NUMLOTE", "", Nil}) //sublote origem
		aadd(aLinha,{"D3_DTVALID", '', Nil}) //data validade 
		aadd(aLinha,{"D3_POTENCI", 0, Nil}) // Potencia
		aadd(aLinha,{"D3_QUANT", (cAliasOS)->QTD_INV, Nil}) //Quantidade
		aadd(aLinha,{"D3_QTSEGUM", 0, Nil}) //Seg unidade medida
		aadd(aLinha,{"D3_ESTORNO", "", Nil}) //Estorno 
		aadd(aLinha,{"D3_NUMSEQ", "", Nil}) // Numero sequencia D3_NUMSEQ
		
		aadd(aLinha,{"D3_LOTECTL", "", Nil}) //Lote destino
		aadd(aLinha,{"D3_NUMLOTE", "", Nil}) //sublote destino 
		aadd(aLinha,{"D3_DTVALID", '', Nil}) //validade lote destino
		aadd(aLinha,{"D3_ITEMGRD", "", Nil}) //Item Grade
		
		aadd(aLinha,{"D3_CODLAN", "", Nil}) //cat83 prod origem
		aadd(aLinha,{"D3_CODLAN", "", Nil}) //cat83 prod destino 

	
		AADD(aAuto,aLinha)		
		
		If Len(aAuto) > 0
			lMsErroAuto := .F.
			lMsHelpAuto := .T.
			
			MSExecAuto({|x,y| mata261(x,y)},aAuto,3)//inclusão
			If lMsErroAuto
				cStatus := "NAO ATUALIZADO ERRO NO EXECAUTO VER LOG"
				CNOMELOG := "CARGA_PICKING_ERRO_" + Alltrim((cAliasOS)->DESTINO) + ".LOG"
				MOSTRAERRO("\SYSTEM\",CNOMELOG)				  
			Else
				cStatus := "ATUALIZADO"
			EndIf
		ELSE
	   		cStatus := "NAO ATUALIZADO MATRIZ DE DADOS INCOMPLETA"
		EndIf

	EndIf
	 // **** UPDATE ****

	CQUERY := "UPDATE AUX SET" + ENTER
	CQUERY += "		AF_STATUS = '" + ALLTRIM(cStatus) + "'"+ ENTER 
	CQUERY += "		,AF_DTLOG =	GETDATE() "+ ENTER
	CQUERY += "FROM TEMP_CT_CARGA_INVENTARIO_FLOWRACK_PROART_2020 AUX" + ENTER 
	CQUERY += "WHERE " 									+ ENTER 
	CQUERY += "	AF_RECNO = '" + ALLTRIM(STR( (cAliasOS)->AF_RECNO )) + "'" + ENTER 
	
	MEMOWRITE("TFMOVESLD_update_status.sql",CQUERY)
	
	IF TCSQLEXEC(CQUERY) != 0 
		
		MSGALERT(OEMTOANSI(	"Erro ao tentar alterar o Status do endereço picking!"),OEMTOANSI("ERRO"))
		
	ENDIF
		  
	_nProc ++
	(cAliasOS)->(DbSkip())
End
return
