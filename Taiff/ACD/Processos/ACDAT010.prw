#include 'protheus.ch'
#INCLUDE 'TOPCONN.CH'

user function ACDAT010()

LOCAL ODLG
LOCAL OSAY01
LOCAL OSAY02
LOCAL CSAY01		:= "Registro do peso liquido e peso bruto na conferencia"
LOCAL CSAY02		:= "não disponível nesta empresa/filial."
LOCAL OBTN
LOCAL LOK			:= .F.

Private cTitulo   := "Registro do peso liquido e peso bruto - Ordem de Separação"
Private cCadastro := OEMTOANSI (cTitulo)
Private AROTINA   := {}

If CEMPANT="03" .AND. CFILANT="02"
	dbselectarea("ZAR")
	dbsetorder(1)
	dbGoTop()
	
	aCores := { {'ZAR->ZAR_STATUS == "P"'  ,'BR_VERDE'    },;     
	        	{'ZAR->ZAR_STATUS == "E"'  ,'BR_AMARELO'  },;  
				{'ZAR->ZAR_STATUS == "F"'  ,'BR_VERMELHO' }}    
		 
	AADD(aRotina, { "Pesquisar"  , "AxPesqui"        , 0, 1 })
	AADD(aRotina, { "Visualizar" , "U_ACDATM10(2)"   , 0, 2 })
	AADD(aRotina, { "Incluir"    , "U_ACDATM10(3)"   , 0, 3 })
	AADD(aRotina, { "Alterar"    , "U_ACDATM10(4)"   , 0, 4 })
	AADD(aRotina, { "Excluir"    , "U_ACDATM10(5)"   , 0, 5 })
	AADD(aRotina, { "Encerra"    , "U_ACDATMEN()"    , 0, 6 })
	AADD(aRotina, { "Etiq.Vol"   , "U_ACDATMET()"    , 0, 6 })
	AADD(aRotina, { "Packing"    , "U_ACDATPAC()"    , 0, 6 })
	AADD(aRotina, { "Legenda"    , "U_ACDATL10"      , 0, 6 })
	
	MBrowse(6 , 1 , 22, 75,"ZAR",,,,,,aCores)
Else
	ODLG   := MSDIALOG():NEW(001,001,230,300,"Conferencia da Separação",,,,,CLR_BLACK,CLR_WHITE,,,.T.)
	OSAY01 := TSAY():NEW(010,010, {|| CSAY01},ODLG,,,,,, .T., CLR_BLUE,CLR_WHITE )
	OSAY02 := TSAY():NEW(030,010, {|| CSAY02},ODLG,,,,,, .T., CLR_BLUE,CLR_WHITE )
	OBTN   := TBUTTON():NEW(090,050,'OK'			,ODLG,{|| LOK 		:= .T.,ODLG:END()},40,10,,,,.T.)
	
	ODLG:ACTIVATE(,,,.T.)
	
	WHILE !LOK 
	
	ENDDO
EndIf
Return()

User Function ACDATM10(nOpcx) 
Local _ni := 0
SetPrvt("nUsado,aHeader,aCols,lRetMod2,cTitM2,_aAnt,_cOrdAnt,aC,aR")
SetPrvt("_cOrdSep,_cDtIni,_cHrIni,_lInclui,_cPedido,_cOper,_cStatus") 


If nOpcx <> 3

	If nOpcx == 2 
		cTitM2 := "Vizualização - Registro do peso liquido e peso bruto"
	ElseIf nOpcx == 4
		cTitM2 := "Alteração - Registro do peso liquido e peso bruto"
	Else	
		cTitM2 := "Exclusão - Registro do peso liquido e peso bruto"
    EndIf 
    
    _cOrdSep	:= ZAR->ZAR_ORDSEP
    _cOrdAnt    := ZAR->ZAR_ORDSEP
	_cDtIni     := ZAR->ZAR_DTPESA
	_cHrIni     := ZAR->ZAR_HRPESA
	_cPedido    := ZAR->ZAR_PEDIDO
	_cStatus    := ZAR->ZAR_STATUS
	_cVolume    :=  POSICIONE("CB7", 1, xFilial("CB7") + ZAR->ZAR_ORDSEP, "CB7_X_QTVO")
Else                                          
	Msgalert("Opção não permitida")
	Return()   //nao permite inclusao por enquanto - a inclusao é a partir da pesagem via ponto de entrada 
	
	cTitM2 := "Inclusao - Registro do peso liquido e peso bruto" 
	_cOrdSep	:= CriaVar("ZAR_ORDSEP")
	_cDtIni     := CriaVar("ZAR_DTPESA")
	_cHrIni     := CriaVar("ZAR_HRPESA")
	_cPedido    := CriaVar("ZAR_PEDIDO")
	_cStatus    := CriaVar("ZAR_STATUS")
EndIf    

	
dbSelectArea("SX3")
dbSetOrder(1)
dbSeek("ZAR")
nUsado := 0
aHeader:={}

Do While !Eof() .And. (x3_arquivo == "ZAR")
	If Alltrim(UPPER(x3_campo))=="ZAR_FILIAL";
		.OR.Alltrim(UPPER(x3_campo))=="ZAR_ORDSEP";
		.OR.Alltrim(UPPER(x3_campo))=="ZAR_DTPESA";
		.OR.Alltrim(UPPER(x3_campo))=="ZAR_HRPESA";
		.OR.Alltrim(UPPER(x3_campo))=="ZAR_PEDIDO";
		.OR.Alltrim(UPPER(x3_campo))=="ZAR_STATUS"
		dbSkip()
		Loop
	Endif
	IF X3USO(x3_usado) .AND. cNivel >= x3_nivel
		nUsado := nUsado + 1 
		AADD(aHeader,{ TRIM(x3_titulo), x3_campo, x3_picture,;
		x3_tamanho, x3_decimal,x3_vlduser,;
		x3_usado, x3_tipo, x3_arquivo, x3_context } )
	Endif
	dbSkip()
EndDo
                        
dbSelectArea("ZAR")
dbSetOrder(1)
If !dbSeek(xFilial("ZAR")+ _cOrdSep) 
   _lInclui := .T.
   aCols := {Array(nUsado+1)}
   aCols[1,nUsado+1] := .F.
   for _ni := 1 to nUsado
       aCols[1,_ni] := CriaVar(aHeader[_ni,2])
   next                                       
Else  
    _lInclui := .F.
	aCols := {}
	Do While ! ZAR->(Eof()) .and. ZAR->ZAR_FILIAL == xFILIAL("ZAR") .And. ZAR->ZAR_ORDSEP == _cOrdSep
	
		AADD(aCols,Array(nUsado+1))
		For _ni := 1 to nUsado            
			aCols[len(aCols),_ni] := FieldGet(FieldPos(aHeader[_ni,2]))
		NEXT                 
		aCOLS[len(aCols),nUsado+1] := .F.
		dbSkip()
	EndDo
EndIf                                 


_aAnt := aCLONE(aCOLS)

//cabecalho
aC := {}                  
If nOpcx <> 3
	AADD(aC,{"_cOrdSep"	,{25,12}  ,RetTitle("ZAR_ORDSEP") ,PesqPict("ZAR","ZAR_ORDSEP")	,'naovazio() .AND. EXISTCPO("CB7")','CB7',.T.})
	AADD(aC,{"_cDtIni"	,{40,10}  ,RetTitle("ZAR_DTPESA") ,PesqPict("ZAR","ZAR_DTPESA")	,'naovazio()',,.F.})
	AADD(aC,{"_cHrIni"	,{40,100} ,RetTitle("ZAR_HRPESA") ,PesqPict("ZAR","ZAR_HRPESA")	,'naovazio()',,.F.})
	AADD(aC,{"_cPedido"	,{55,16}  ,RetTitle("ZAR_PEDIDO") ,PesqPict("ZAR","ZAR_PEDIDO")	,'vazio() .or. EXISTCPO("SC5")','SC5',.F.})
	AADD(aC,{"_cVolume"	,{70,10}  ,RetTitle("CB7_X_QTVO") ,PesqPict("CB7","CB7_X_QTVOL"),'naovazio() ',,.F.})

Else							// inclusao
	AADD(aC,{"_cOrdSep"	,{25,12}  ,RetTitle("ZAR_ORDSEP") ,PesqPict("ZAR","ZAR_ORDSEP")	,'naovazio() .AND. EXISTCPO("CB7")','CB7',.F.})
	AADD(aC,{"_cDtIni"	,{40,10}  ,RetTitle("ZAR_DTPESA") ,PesqPict("ZAR","ZAR_DTPESA")	,'naovazio()',,.F.})
	AADD(aC,{"_cHrIni"	,{40,100} ,RetTitle("ZAR_HRPESA") ,PesqPict("ZAR","ZAR_HRPESA")	,'naovazio()',,.F.})
	AADD(aC,{"_cPedido"	,{55,16}  ,RetTitle("ZAR_PEDIDO") ,PesqPict("ZAR","ZAR_PEDIDO")	,'vazio() .or. EXISTCPO("SC5")','SC5',.T.})
	AADD(aC,{"_cVolume"	,{70,10}  ,RetTitle("CB7_X_QTVO") ,PesqPict("CB7","CB7_X_QTVOL"),'naovazio() ',,.F.})
EndIf

aR       := {}

aSize := MsAdvSize(.T.)
L1 := aSize[7]
L2 := aSize[1]
L3 := aSize[6]
L4 := aSize[5]
aCGD     := {150,10,aSize[6]/2.2,aSize[5]/2.04} 
aAdvSize  := MsAdvSize( NIL ,.F. )
aCordW    := Array(Len(aAdvSize))
aCordW[1] := aAdvSize[7]
aCordW[2] := 0
aCordW[3] := aAdvSize[6]
aCordW[4] := aAdvSize[5]


cLinhaOk := "U_ACDLOK10()" 
cTudoOk  := "U_ACDTOK10()"
lRetMod2:=Modelo2(cTitM2,aC,aR,aCGD,nOpcx,cLinhaok,cTudoOk,,,,1500,aCordW,,.t.,)


IF lRetMod2
	If nOpcx == 5 // exclusao                                  
			ACDGRVE()	
	ElseIf nOpcx == 4 // alteracao                                  
			ACDGRV(nOpcx)		
   	ElseIf nOpcx == 3 // inclusao                                  	
			ACDGRV(nOpcx)		
	EndIf
Endif

Return()
/************************************************************/
Static Function ACDGRVE()

//CONFIRMA EXCLUSAO SIM OU NAO
//SE ESTIVER ENCERRADO - SO DEIXA EXCLUIR SE NAO TEM NOTA EMITIDA

IF  !MSGYESNO("Deseja realmente excluir toda a Conferência?","Atenção, caso a conferencia seja excluida o peso bruto no pedido será estornado e terá que refazer o processo de conferencia!!!")
    Return
ENDIF

cQuery := "SELECT * "
cQuery += "FROM " + RETSQLNAME("SD2") + " SD2 "
cQuery += "WHERE D2_FILIAL = '" + xFilial("SD2") + "' "
cQuery += "AND D2_ORDSEP = '"+_cOrdSep+"' "
cQuery += "AND SD2.D_E_L_E_T_ = ' ' "

If  Select("TSD2") > 0
	TSD2->(Dbclosearea())
Endif
	
TcQuery cQuery NEW ALIAS ("TSD2")

Dbselectarea("TSD2")
Dbgotop()
IF  !eof()
     Msgalert("Não é Possível Excluir esta Pesagem - Nota "+TSD2->D2_DOC + " emitida!!!")
     dbSelectArea("ZAR")
     Return
ENDIF

dbSelectArea("ZAR")
dbSetOrder(1)     
dbSeek(xFilial("ZAR")+_cOrdSep)
Do While ! ZAR->(Eof()) .AND. ;
    	   ZAR->ZAR_FILIAL == xFILIAL("ZAR") .And. ;
           ZAR->ZAR_ORDSEP == _cOrdSep
	RecLock("ZAR",.F.)
	dbDelete()
	MsUnLock()
	DbSkip()
EndDo

Dbselectarea("CB7")
Dbsetorder(1)
If  dbseek(xfilial("CB7")+_cOrdSep)
	Reclock("CB7",.F.)
	Replace CB7->CB7_X_QTVO WITH 0
	Msunlock()

	Dbselectarea("SC5")
	Dbsetorder(1)
	If  Dbseek(xfilial("SC5")+CB7->CB7_PEDIDO)
		Reclock("SC5",.F.)
		Replace C5_PESOL   WITH 0
		Replace C5_PBRUTO  WITH 0
		Replace C5_VOLUME1 WITH 0
		Replace C5_YSTSEP  WITH ""
		Msunlock()
	Endif    
Endif
Msginfo("Estorno da Pesagem realizado!!!")
Return

/************************************************************/
Static Function ACDGRV(nOpcx)
Local _nPosDel := Len(aHeader) + 1
Local _uChave                      
Local _nPosCod := GDFieldPos("ZAR_VOLUME")  
Local nI := 0
Local nY := 0

For nI := 1 to len(acols)                  
	dbSelectArea("ZAR")
	dbSetOrder(1)      
    
    if nOpcx == 3
        If nI > len(_aAnt)
			_uChave := xFilial("ZAR") + _cOrdSep + aCols[nI,_nPosCod]
	    Else            
			_uChave := xFilial("ZAR") + _cOrdSep + _aAnt[nI,_nPosCod]
		EndIf	    
    else
	    If nI > len(_aAnt)
			_uChave := xFilial("ZAR") + _cOrdAnt + aCols[nI,_nPosCod]
	    Else            
			_uChave := xFilial("ZAR") + _cOrdAnt + _aAnt[nI,_nPosCod]
		EndIf	                        
	endif     
	
	If ! aCols[nI,_nPosDel] // Trata somente itens nao deletados. . .
	
		If ! dbSeek(_uChave)
            MsgAlert("Inclusão de novos itens não permitido")
		Else	              
			RecLock("ZAR",.F.)
	        replace ZAR->ZAR_FILIAL   with  XFILIAL("ZAR")
			replace ZAR->ZAR_ORDSEP   with  _cOrdSep
			replace ZAR->ZAR_DTPESA   with  _cDtIni
			replace ZAR->ZAR_HRPESA   with  _cHrIni
			replace ZAR->ZAR_PEDIDO   with  _cPedido
			replace ZAR->ZAR_OPERAD   with  _cOper
			replace ZAR->ZAR_STATUS   with  _cStatus
			
			For nY := 1 TO len(aHeader)
				replace &(aHeader[nY,2]) with acols[nI,nY]
			Next nY
			MsUnLock()
		Endif	
	Else 
		Msgalert("Exclusão de Linhas não permitida")
    Endif
Next nI

Return
                          
/************************************************************/
User Function ACDLOK10()

Local _nPosDel := Len(aHeader) + 1
Local _uChave                      
Local _nPosCod := GDFieldPos("ZAR_VOLUME")  
Local nI := 0
Local lRet := .T.

For nI := 1 to len(acols)                  
	dbSelectArea("ZAR")
	dbSetOrder(1)      
    If nI > len(_aAnt)
		_uChave := xFilial("ZAR") + _cOrdAnt + aCols[nI,_nPosCod]
    Else            
		_uChave := xFilial("ZAR") + _cOrdAnt + _aAnt[nI,_nPosCod]
	endif     
	If ! aCols[nI,_nPosDel] // Trata somente itens nao deletados. . .
	   If  !dbSeek(_uChave)
            MsgAlert("Inclusão de novos itens não permitido")
            lRet := .F.
       Endif
    Else
        MsgAlert("Exclusão de linhas não permitido")
        lRet := .F.
    Endif        
Next nI
Return(lRet)                        
/************************************************************/    
User Function ACDTOK10()

Local _nPosDel := Len(aHeader) + 1
Local _uChave                      
Local _nPosCod := GDFieldPos("ZAR_VOLUME")  
Local nI := 0
Local lRet := .T.


For nI := 1 to len(acols)                  
	dbSelectArea("ZAR")
	dbSetOrder(1)      
    If nI > len(_aAnt)
		_uChave := xFilial("ZAR") + _cOrdAnt + aCols[nI,_nPosCod]
    Else            
		_uChave := xFilial("ZAR") + _cOrdAnt + _aAnt[nI,_nPosCod]
	endif     
	If ! aCols[nI,_nPosDel] // Trata somente itens nao deletados. . .
	   If  !dbSeek(_uChave)
            MsgAlert("Inclusão de novos itens não permitido")
            lRet := .F.
       Endif
    Else
        MsgAlert("Exclusão de linhas não permitido")
        lRet := .F.
    Endif        
Next nI
Return(lRet)
                               
User Function ACDSEQ10()
Local nRet    := ""
Local _nPosIT := GDFieldPos("ZAR_VOLUME")
  
If _lInclui
	nRet := STRZERO(LEN(ACOLS),TAMSX3("ZAR_VOLUME")[1])
	_lInclui := .F.
Else
	nRet := soma1(aCols[len(aCols)-1,_nPosIT])
EndIf

Return(nRet)

User Function ACDATMEN()
If ZAR->ZAR_STATUS = "F"
	MsgAlert("Encerramento da pesagem já realizado!")
Else
	If Msgyesno("Confirma o Encerramento da Pesagem?","O encerramento da pesagem atualizará o volume e peso no pedido!!")
		 //consistir status da ZAR - só status P 
		_nTotPesLiq := 0
		_nTotPesBru := 0
		_nQTdVol    := 0
		_cNumOrd    := ZAR->ZAR_ORDSEP
	    Dbselectarea("CB7")
	    Dbsetorder(1)
	    If  dbseek(xfilial("CB7")+_cNumOrd)
			Dbselectarea("ZAR")
			Dbsetorder(1)
			Dbseek(xfilial("ZAR")+_cNumOrd)
			While .not. eof() .and. ZAR->ZAR_ORDSEP == _cNumOrd
			    _nTotPesLiq += ZAR->ZAR_PLIQUI
			    _nTotPesBru += ZAR->ZAR_PBRUTO
			    Reclock("ZAR",.F.)
			    Replace ZAR_STATUS WITH "F"
			    Msunlock()
			    Dbskip()
			End
			Dbselectarea("SC5")
			Dbsetorder(1)
			If  Dbseek(xfilial("SC5")+CB7->CB7_PEDIDO)
			    Reclock("SC5",.F.)
			    Replace C5_PESOL   WITH _nTotPesLiq
			    Replace C5_PBRUTO  WITH _nTotPesBru
			    Replace C5_VOLUME1 WITH CB7->CB7_X_QTVO
			    Replace C5_YSTSEP  WITH "G"
			    Msunlock()
			    Msginfo("Encerramento da Pesagem realizado")
			Endif    
	    Endif
	Endif
EndIf
Return

User Function ACDATMET()
Local cCDestino:=""
If  Msgyesno("Confirma impressao das Etiquetas de Volumes")

    _nQtVol := POSICIONE("CB7", 1, xFilial("CB7") + ZAR->ZAR_ORDSEP, "CB7_X_QTVO")

    SC5->(DBORDERNICKNAME("SC5NUMOLD"))
	If SC5->(DBSEEK(xFilial("SC5") + ZAR->ZAR_PEDIDO))
		cCDestino := ALLTRIM(SC5->C5_FILDES)
    EndIf

	CB5->(DbSetOrder(1))
	If  CB5->(DbSeek(xFilial("CB5")+ CBRLocImp("MV__IACD01") ))
		If  CB5SetImp(CBRLocImp("MV__IACD01"))
			U_IMG12(ZAR->ZAR_VOLUME,ZAR_PBRUTO,ZAR_CAIXA,_nQTVol, cCDestino )
		Else
			Alert("Impressora não encontrada, peça ao TI verificar o parametro MV__IACD01!!")
		EndIf
		MSCBCLOSEPRINTER()
	EndIf
Endif
Return 

User Function ACDATL10()
BrwLegenda(cCadastro,"Legenda",{{"BR_VERDE"      ,"Pendente"},;    
                                {"BR_AMARELO"    ,"Em Andamento"},; 
								{"BR_VERMELHO"   ,"Finalizada"}})	
Return(.t.)  

User Function ACDATPAC()
Local lRet := .T.
If  Msgyesno("Confirma impressao do relatorio Packing do volume " + ZAR->ZAR_VOLUME + "?")
	U_ACDRD005(.F.,ZAR->ZAR_ORDSEP,ZAR->ZAR_ORDSEP,ZAR->ZAR_VOLUME,ZAR->ZAR_VOLUME,"ACDATPAC")
Endif
Return (lRet)
                                           