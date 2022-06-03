#Include "Protheus.ch"
#Include "topconn.ch"
#Include "TbiConn.ch"
#Include "TbiCode.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRACDT001   บ Autor ณ Carlos Alday      บ Data ณ  16/04/2010 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Geracao de etiquetas de embarque               	   	      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function RACDT001()

Local xAlias	 := GetArea()

EtiqDestin()

RestArea(xAlias)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ EtiqDestin  บAutor  ณ Carlos Alday    บ Data ณ  12/02/2010 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณImpressใo de Etiquetas                                      บฑฑ
ฑฑบ          ณTipo Etiqueta: Etiqueta Destinatario                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function EtiqDestin()
Local aParamBox	:= {}
Local aRet			:= {}
Local cNota
Local cSerie

Local _sConteudo

//Local _cEtqQuery	:= ""
Local _cCliente	:= ""
Local _cLojaClNf	:= ""
Local _nLoop		:= 0
Local _cVolume		:= ""
//Local _sComando	:= ""
Local _cTipoBar	:= ""
Local nVolume		:= 0
Local cNotaFin		:= ""
Local cSerieFin	:= ""
Local _cPedido		:= ""
Local lEnd			:= .F.      
Local _cOrdSepar	:= ""
Local _dEmissaoNf	:= ctod("  /  /  ")

Local cENomeCli	:= ""
Local cELogrCli	:= ""
Local cEEndeCli	:= ""
Local cENumeCli	:= ""
Local cEBairCli	:= ""
Local cEMuniCli	:= ""
Local cEEstaCli	:= ""
Local cECepsCli	:= ""
Local cEComplto	:= ""
Local __cNmTransportadora
Local cF2_NUMRM := ""
Local cTFtransp	:= ""

Private cString := ""



Aadd(aParamBox,{1,"Da Nota"				,Space(TamSX3("F2_DOC")[1])	 	,PesqPict("SF2","F2_DOC")	 ,"","SF2","",50,.T.})
Aadd(aParamBox,{1,"  Serie"				,Space(TamSX3("F2_SERIE")[1])	,PesqPict("SF2","F2_SERIE")	 ,"",""   ,"",50,.T.})
Aadd(aParamBox,{1," a Nota"				,Space(TamSX3("F2_DOC")[1])	 	,PesqPict("SF2","F2_DOC")	 ,"","SF2","",50,.T.})
Aadd(aParamBox,{1,"  Serie"				,Space(TamSX3("F2_SERIE")[1])	,PesqPict("SF2","F2_SERIE")	 ,"",""   ,"",50,.T.})
Aadd(aParamBox,{1,"Local de impressใo"	,Space(TamSX3("CB5_CODIGO")[1])	,PesqPict("CB5","CB5_CODIGO"),"","CB5","",50,.T.})
Aadd(aParamBox,{1,"Transportadora"		,Space(TamSX3("F2_TRANSP")[1])	,PesqPict("SA4","A4_COD"),"","SA4","",50,.F.})

IF !ParamBox(aParamBox,"Informe os Parametros",@aRet)
		Return(.F.)
Endif

If CB5->CB5_LPT != "0"
		_cPorta := "LPT" + Alltrim( CB5->CB5_LPT )
Else
		_cPorta := "COM" + Alltrim( CB5->CB5_PORTA )
Endif

If CB5->CB5_LPT != "0"
		PrinterWin(.F.) 						// Impressao Dos/Windows
		PreparePrint(.F.,"",.F.,_cPorta) 		// Prepara a impressao na porta especIficada
		InitPrint(1)
Else
		nHdll := 0
		MsOpenPort(nHdll,_cPorta + ":9600,n,8,1")
EndIf


cNota      := aRet[1]
cSerie     := aRet[2]

cNotaFin   := aRet[3]
cSerieFin  := aRet[4]

cTFtransp := Alltrim(aRet[6])

DbSelectArea("SF2")
SF2->(DbSetOrder(1))
SF2->(DBSeek( xFilial("SF2") + cNota + cSerie , .T. ))

While SF2->F2_FILIAL+SF2->F2_DOC+SF2->F2_SERIE <= xFilial("SF2") + cNotaFin + cSerieFin .AND. !SF2->(EOF())

	If CEMPANT = "03"
		cF2_NUMRM = SF2->F2_NUMRM //Este campo s๓ existe na empresa 03
	EndIf
	If cF2_NUMRM != 'CROSS' .AND. (SF2->F2_SERIE >= cSerie .AND. SF2->F2_SERIE <= cSerieFin) .AND. ((SF2->F2_TRANSP = cTFtransp .AND. !EMPTY(cTFtransp)) .OR. EMPTY(cTFtransp)) 
		_cNumPedido := ""
		SD2->(DbSetOrder(3))
		If SD2->(DBSeek( xFilial("SD2") + SF2->(F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA) ))
			_cNumPedido := SD2->D2_PEDIDO
		EndIf
	
		nVolume		:= SF2->F2_VOLUME1
		_cCliente	:= SF2->F2_CLIENTE
		_cLojaClNf	:= SF2->F2_LOJA
		_cPedido		:= ""
		_dEmissaoNf	:= SF2->F2_EMISSAO
	    
		cNota		:= SF2->F2_DOC
		cSerie		:= SF2->F2_SERIE
			
		__cNmTransportadora := ""
		
		SA4->(DbSetOrder(1))
		If SA4->(DBSeek( xFilial("SA4") + SF2->F2_TRANSP , .T. ))
			__cNmTransportadora := Alltrim( SA4->A4_NOME )
		EndIf
		
		DbSelectArea("SC9")
		SC9->(DbSetOrder(6))
		SC9->(DBSeek( xFilial("SC9") + cSerie + cNota , .T. ))
		While SC9->C9_FILIAL+SC9->C9_SERIENF+SC9->C9_NFISCAL = xFilial("SC9") + cSerie + cNota .AND. !SC9->(EOF())
			If At( Alltrim(SC9->C9_PEDIDO) , _cPedido ) = 0
				_cPedido  += SC9->C9_PEDIDO + " "    
			Endif   
			DbSkip()
		End
	
		_cOrdSepar := ""
	
		DbSelectArea("CB7")
		CB7->(DbSetOrder(4))
		CB7->(DBSeek( xFilial("CB7") + cNota + cSerie , .T. ))
		While CB7->CB7_FILIAL+CB7->CB7_NOTA+CB7->CB7_SERIE = xFilial("CB7") + cNota + cSerie .AND. !CB7->(EOF())
			_cOrdSepar := CB7->CB7_ORDSEP
			CB7->(DbSkip())
		End
	
		_cQuery := "SELECT C5_TIPO " 
		_cQuery += "  FROM " + RetSqlName("SC5") + " SC5 " 
		_cQuery += " WHERE SC5.C5_FILIAL = '" + xFilial("SC5") + "' "
		_cQuery += "   AND SC5.C5_NUM = '" + _cNumPedido + "'"
		//_cQuery += "   AND SC5.C5_NOTA = '"    + cNota  + "' AND SC5.C5_SERIE = '"   + cSerie + "'"
		_cQuery += "   AND SC5.C5_CLIENTE = '" + _cCliente + "' AND SC5.C5_LOJACLI = '" + _cLojaClNf + "'"
		_cQuery += "   AND SC5.D_E_L_E_T_ != '*' "    
	
		If Select("OSS") > 0
			OSS->(DbCloseArea())
		Endif
	
		TcQuery _cQuery NEW ALIAS ("OSS")
	
		DbSelectArea("OSS")
	    
		OSS->(DbGotop())
	
		If OSS->(eof())
	       DbSelectArea("SA1")
	       SA1->(DbSetOrder(1))
	       SA1->(DbSeek( xFilial("SA1") + _cCliente + _cLojaClNf ))
	       cENomeCli := SA1->A1_NOME
	       cELogrCli := SA1->A1_LOGR
	       cEEndeCli := SA1->A1_END
	       cENumeCli := SA1->A1_NUME
	       cEBairCli := SA1->A1_BAIRRO
	       cEMuniCli := SA1->A1_MUN
	       cEEstaCli := SA1->A1_EST
	       cECepsCli := SA1->A1_CEP
	       cEComplto := " " + Alltrim(SA1->A1_COMPLEM)
		ElseIf At( AllTrim(oss->c5_tipo) , 'DB' ) != 0 .AND. !OSS->(eof())
	       DbSelectArea("SA2")
	       SA2->(DbSetOrder(1))
	       SA2->(DbSeek( xFilial("SA2") + _cCliente + _cLojaClNf ))
	       cENomeCli := SA2->A2_NOME
	       cELogrCli := SA2->A2_LOGR
	       cEEndeCli := SA2->A2_END
	       cENumeCli := SA2->A2_NR_END
	       cEBairCli := SA2->A2_BAIRRO
	       cEMuniCli := SA2->A2_MUN
	       cEEstaCli := SA2->A2_EST
	       cECepsCli := SA2->A2_CEP
	       cEComplto := " " + Alltrim(SA2->A2_COMPLEM)
		Else
	       DbSelectArea("SA1")
	       SA1->(DbSetOrder(1))
	       SA1->(DbSeek( xFilial("SA1") + _cCliente + _cLojaClNf ))
	       cENomeCli := SA1->A1_NOME
	       cELogrCli := SA1->A1_LOGR
	       cEEndeCli := SA1->A1_END
	       cENumeCli := SA1->A1_NUME
	       cEBairCli := SA1->A1_BAIRRO
	       cEMuniCli := SA1->A1_MUN
	       cEEstaCli := SA1->A1_EST
	       cECepsCli := SA1->A1_CEP
	       cEComplto := " " + Alltrim(SA1->A1_COMPLEM)
		Endif
		OSS->(DbCloseArea())
		For _nLoop := 1 to nVolume
			#IFNDEF WINDOWS
				Inkey()
				If LastKey() = K_ESC
					_nLoop := nVolume
					lEnd   := .T.
				Endif
			#ENDIF
			_cVolume   := Alltrim( Str(_nLoop) ) + "/" + Alltrim( Str(nVolume) )
			cEtqCodigo := _cOrdSepar
			
	      cString := ""
			If CB5->CB5_MODELO = "Z4M"
				//InicEtiq(nLargura, nAltura)
				InicEtiq(1000,500)
				//
				// ^FO nColuna,nLinha ^A0N, nHeight, nWidth ^FD cTexto ^FS
				//                      ||                               ภ> Finaliza o comando de impressao
				//                      |ภ> N=normal, R = rotacao de 90ง , I = invertido 180ง
				//                      ภ-> Nome da fonte, quando igual a 0 usar parametros nHeight e nWidth
				//
				_cVolume := Alltrim( Str(_nLoop) ) + "/" + Alltrim( Str(SF2->F2_VOLUME1) )
				ImpPortSel("^LRY")                                                               // Ativa a impressao em reverso
				ImpPortSel("^FO030,000^GB999,100,120^FS")                                        // Demarca area retangular
				ImpPortSel("^FO030,010^A0N,140,100^FDNF: " + cNota + " " + cSerie + "^FS")
				ImpPortSel("^FO030,120^ARN,50,20^FD" + cENomeCli + "^FS")
				ImpPortSel("^FO030,150^ARN,50,20^FD" + Alltrim(cELogrCli) + " " +Alltrim(cEEndeCli)+ ", " + cENumeCli + cEComplto + "^FS")
				ImpPortSel("^FO030,180^ARN,50,20^FD" + cEBairCli + "^FS")
				ImpPortSel("^FO030,210^ARN,50,20^FD" + Alltrim(cEMuniCli)+" "+ Alltrim(cEEstaCli) + " " + Transform(cECepsCli,"@R 99999-999") + "^FS")
				ImpPortSel("^FO540,240^ARN,140,100^FD" + _cVolume + "^FS")
				ImpPortSel("^FO030,240^ARN,50,20^FD" + "No. Pedido: " + Alltrim(_cPedido) + "^FS")
				If !empty(cEtqCodigo)
						ImpPortSel("^FO090,280^BY2,1,120^BCN,80,Y,N,N,N^FD"+cEtqCodigo+"^FS")			//	MSCBSAYBAR(nX,22,cId,"N","MB07",8.36,.F.,.T.,.F.,,2,1,.F.,.F.,"1",.T.)
				EndIf
				ImpPortSel("^FO030,385^GB999,000,05^FS")                                         // Demarca area LINEAR
				ImpPortSel("^FO030,390^AQN,10,10^FDREM: " + Alltrim(SM0->M0_NOMECOM) + "^FS")
				ImpPortSel("^FO300,420^AQN,10,10^FDEmissao da NF: " + dtoc(_dEmissaoNf) + "^FS")
				ImpPortSel("^FO030,450^AQN,10,10^FDTransportadora: " + __cNmTransportadora + "^FS")
				
				FimEtiq(1)
			Endif    
			If CB5->CB5_MODELO = "ELTRON"
				_cTipoBar  := 'MB07' //128  
				nHdll := 0
				MSCBPRINTER(Alltrim(CB5->CB5_MODELO),"LPT1",,)
				MSCBBEGIN(1,6)
				//MSCBBOX(ColunaTop,LinhaTop,ColunaBottom,LinhaBottom,espessura da linha,"B") 
				//MSCBBOX(05,01,100,14,2,"B") 
				MSCBSAY(07,02,"NF: " + cNota + " " + cSerie ,"N","5","1,2",.T.)
				MSCBSAY(07,15,Alltrim(cENomeCli), "N", "3", "1,2")
				MSCBSAY(07,20,Alltrim(cELogrCli) + " " +Alltrim(cEEndeCli)+ ", " + cENumeCli , "N", "3", "1,2")
				MSCBSAY(07,25,cEBairCli,"N","2","1,2")
				MSCBSAY(07,30,Alltrim(cEMuniCli)+" "+ Alltrim(cEEstaCli) + " " + Transform(cECepsCli,"@R 99999-999"),"N", "2", "1,2")
				MSCBSAY(07,35,"No. Pedido: " + _cPedido,"N", "2", "1,2")
				MSCBSAYBAR(07,40,cEtqCodigo,'N',_cTipoBar,10,.T.,,,,4,2,,,,)
				MSCBSAY(70,36,_cVolume,"N", "5", "1,2")
				MSCBSAY(07,55,"REM: " + Alltrim(SM0->M0_NOMECOM),"N", "2", "1,2")
				MSCBInfoEti("EMBARQUE","30X100")	
				_sConteudo:=MSCBEND()
			Endif
		Next
	EndIf
	DbSelectArea("SF2")
	If lEnd
		Exit
	Endif
	dbskip()
End

If CB5->CB5_LPT != "0"
	Ms_Flush()
Else
	MsClosePort(nHdll)
	nHdll := 0
Endif
Return(.F.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณImpPortSelบAutor  ณ Richard N. Cabral  บ Data ณ  09/12/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณValidacao de perguntas do SX1                               บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function ImpPortSel(cTexto)

cString += cTexto
If CB5->CB5_LPT != "0"
	@ PROW()+1,001 PSAY cTexto
Else
	MsWrite(nHdll,cTexto)
	Inkey(.01)
Endif

Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณInicEtiq  บAutor  ณ Richard N. Cabral  บ Data ณ  14/12/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณComandos iniciais impressao de etiqueta padrao Zebra        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function InicEtiq(nLargura, nAltura)

ImpPortSel("^XA")									// Comeco Etiqueta
ImpPortSel("^MCY")									// Set Map Clear to Yes
ImpPortSel("^XZ")									// Fim Etiqueta

ImpPortSel("^XA")									// Comeco Etiqueta
ImpPortSel("^SS033,084,028,"+strzero(nAltura,3))	// Set Media Sensor - Web, Media, Ribbon, Lenght
ImpPortSel("^FWN")									// Field Orientation - N-Normal, R-Rotate 90, I-Inverte 180, B-Bottom 270
ImpPortSel("^CFD,24")								// Change Alphanumeric Default Font f=font,h=height,w=width
ImpPortSel("^PW"+strzero(nLargura,4))				// Print Width
ImpPortSel("^LH0,0")								// Set Label Home - To Right, down from top
ImpPortSel("^CI0")									// Change International font
ImpPortSel("^PR2")									// Set print rate
ImpPortSel("^MNY")									// Media Tracking - Y=Non continuos
ImpPortSel("^MTT")									// Media Type - T=Termal Transfer Media
ImpPortSel("^MMT")									// Print Mode - T=Tear Off
ImpPortSel("^MD0")									// Media Darkness Adjust -30 a 30
ImpPortSel("^PON")									// Print Orientation N=Normal, I=Inverte
ImpPortSel("^PMN")									// Print Mirror N=No, Y=Yes
ImpPortSel("^LRN")									// Label Reverse N=No, Y=Yes
ImpPortSel("^XZ")									// Fim Etiqueta

ImpPortSel("^XA")									// Comeco Etiqueta
ImpPortSel("^MCY")									// Set Map Clear to Yes
ImpPortSel("^XZ")									// Fim Etiqueta

ImpPortSel("^XA")									// Comeco Etiqueta
ImpPortSel("^DFR:TEMP_FMT.ZPL")						// Download format

Return(.T.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFimEtiq   บAutor  ณ Richard N. Cabral  บ Data ณ  14/12/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณComandos finais impressao de etiqueta padrao Zebra          บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function FimEtiq(nQtde)

ImpPortSel("^XZ")									// Fim de Etiqueta

ImpPortSel("^XA")									// Comeco Etiqueta
ImpPortSel("^XFR:TEMP_FMT.ZPL")                    	// Recall Format
ImpPortSel("^PQ"+strzero(nQtde,2)+",0,1,Y")			// Qtde etiquetas
ImpPortSel("^XZ")									// Fim de Etiqueta

ImpPortSel("^XA")									// Comeco Etiqueta
ImpPortSel("^IDR:TEMP_FMT.ZPL")						// image Delete
ImpPortSel("^XZ")									// Fim de Etiqueta

Return(.T.)

