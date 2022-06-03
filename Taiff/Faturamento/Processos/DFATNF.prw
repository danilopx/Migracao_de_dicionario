#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "COLORS.CH"
#INCLUDE "FIVEWIN.CH"
#INCLUDE "COLORS.CH"
#INCLUDE "SHELL.CH"
#DEFINE CRLF Chr(13) + Chr(10)
#DEFINE ENTER Chr(13) + Chr(10)
#DEFINE CGETFILE_TYPE GETF_LOCALHARD+GETF_LOCALFLOPPY+GETF_NETWORKDRIVE

/*
ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ DFATNF   บAutor  ณ Anderson Messias   บ Data ณ  11/03/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Trata arquivo de retorno do EDI - PROCEDA OCORREN          บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ TAIFF                                                      บฑฑ
ฑฑฬออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ         ATUALIZACOES SOFRIDAS DESDE A CONSTRUÿAO INICIAL.             บฑฑ
ฑฑฬออออออออออออัออออออออัอออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบProgramador ณ Data   ณ Motivo da Alteracao                             บฑฑ
ฑฑฬออออออออออออุออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบMarcelo Cardณ14/03/13ณUtilizacao da familia de funcoes FT_F para leitu บฑฑ
ฑฑบ            ณ        ณra do arquivo texto com diferentes tamanhos de   บฑฑ
ฑฑบ            ณ        ณlinhas                                           บฑฑ
ฑฑบMarcelo Cardณ18/03/13ณTratamento da Filial da Tabela SX5 para identifi บฑฑ
ฑฑบ            ณ        ณcacao das Ocorrencias                            บฑฑ
ฑฑศออออออออออออฯออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿

*/

User Function DFATNF(_lAuto,_cArquivo,_aDados,_cAtivo)

Local oBtn := ARRAY(3)
Private oDlgImp
Private oArqEnt,cArqEnt := Space(255)
Private _bAtive := .F.
Private cAtivo,oAtivo
Private cLoja := Space(2),oLoja
Private _cSerie	:= "1-A"
Private nI

DEFAULT _lAuto    := .F.
DEFAULT _cArquivo := {}
DEFAULT _aDados   := {}
DEFAULT _cAtivo   := "2"

//RpcSetType(3)
//RPCSetEnv("03","01") //Posiciono na empresa 01 e filial 01 pois ้ onde estแ configurado o workflow de envio do email

//Populando empresas do sigamat na matriz para buscar nome pelo CNPJ, necessario para a importa็ใo de faturas
aSavATU := GetArea()
aSavSM0 := SM0->(GetArea())
DBSelectArea("SM0")
DBGoTop()
_aEmpresas := {}
While !SM0->(Eof())
	IF SM0->M0_CODIGO<"90"
		aadd(_aEmpresas,{SM0->M0_CGC,SM0->M0_NOME})
	ENDIF
	SM0->(DBSkip())
EndDo
RestArea(aSavSM0)
RestArea(aSavATU)

if !_lAuto
	DEFINE FONT oBold    NAME "Arial" SIZE 0, -12 BOLD
	DEFINE MSDIALOG oDlgImp TITLE "Arquivos de Retorno EDI" OF oMainWnd PIXEL FROM 258,151 TO 480,695
	
	@ 002,002 BITMAP oBmp RESOURCE "CELERINA" OF oDlgImp PIXEL SIZE 65,90 NOBORDER ADJUST WHEN .F.
	@ 095,000 BITMAP oBmp2 RESOURCE "TOOLBAR"  OF oDlgImp PIXEL SIZE 330,10 NOBORDER ADJUST WHEN .F.
	
	@ 04,075 SAY "Arquivo de Entrada ?" SIZE 140,07  OF oDlgImp PIXEL COLOR CLR_BLUE
	obtnFile := TButton():New( 12, 240, "Abrir",oDlgImp,{|| fSelArq() },30,10,,,.F.,.T.,.F.,,.F.,,,.F.)
	@ 12,075 MSGET oArqEnt VAR cArqEnt    SIZE 160,8  WHEN _bAtive OF oDlgImp PIXEL //FONT oBold COLOR CLR_BLUE
	
	@ 193,482 BTNBMP oBtn[2]  RESOURCE "OK"     SIZE 30,30 OF oDlgImp PIXEL MESSAGE "Confirmar..."   ACTION (Tratarq(),oDlgImp:End())
	@ 193,512 BTNBMP oBtn[3]  RESOURCE "CANCEL" SIZE 30,30 OF oDlgImp PIXEL MESSAGE "Cancelar..."    ACTION oDlgImp:End()
	
	@ 46,075 SAY "Selecione o tipo de transfer๊ncia EDI:" SIZE 150,07  OF oDlgImp PIXEL COLOR CLR_BLUE
	@ 54,075 COMBOBOX oAtivo VAR cAtivo ITEMS {"1- Conhecimentos Transporte","2- Ocorr๊ncia Mercadoria","3- Fatura de Transportes"} PIXEL SIZE 110,10 OF oDlgImp
	
	ACTIVATE MSDIALOG oDlgImp CENTER
	
else
	//Tratamento para execu็ใo via rotina schedulada
	cAtivo  := _cAtivo
	cArqEnt := _cArquivo
	if len(Alltrim(cArqEnt)) > 0
		Tratarq(_lAuto,@_aDados)
	endif
endif

_cAtivo := cAtivo
//RPCClearEnv()

Return

/*
ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ fSelArq  บAutor  ณ Anderson Messias   บ Data ณ  11/03/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Selecao do Arquivo                                         บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ TAIFF                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function fSelArq()

Local cTitulo1  := "Selecione o arquivo"
Local cExtens   := "Arquivo TXT | *.txt*"
Local cFileOpen := cGetFile(cExtens,cTitulo1,,,.T.)

If !File(cFileOpen)
	if !_lAuto
		MsgAlert("Arquivo : "+cFileOpen+" nใo localizado","Arquivo nao encontrado")
	endif
	cArqEnt := ""
else
	cArqEnt := cFileOpen
Endif

Return

/*
ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTratarq   บAutor  ณFernando Bombardi   บ Data ณ  14/09/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณTrata arquivos de retorno do EDI Transportadora             บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ TAIFF                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function Tratarq(_lAuto,_aDados)

//Local _NomeArq1 := 0
//Local nTamFile1 := 0
//Local nTamLin   := 0
Local cBuffer1  := ""
//Local nBtLidos1 := 0
LOCAL _cNfeChave:= ""
LOCAL _nIx		:= 0
LOCAL _nI		:= 0
LOCAL NITECURSOR:= 0
LOCAL NCTECURSOR:= 0
Local cVldLayOut := SuperGetMV("DFATNF003",,"|A|")
Local nTpLayOut  := 0

Private cArqEDI := ""
Private _nFFTU  := 0
Private _lA4PsChv  := AllTrim(GetSx3Cache("A4_X_PSCHV", "X3_CAMPO")) == "A4_X_PSCHV"
Private _lSerCto   := AllTrim(GetSx3Cache("PAV_SERCTO", "X3_CAMPO")) == "PAV_SERCTO"
Private nHdlFile
Private _nAtivChv	:= 0

Private _aConCTe := {}
DEFAULT _lAuto := .F.
DEFAULT _aDados:= {}

Do Case
	Case Substr(cAtivo,1,1) == "1"
		_cOco := '320' //Conhecimentos de Transporte
	Case Substr(cAtivo,1,1) == "2"
		_cOco := '340' //Ocorrencia de Entrega
	Case Substr(cAtivo,1,1) == "3"
		_cOco := '350' //Faturas de Transporte
Endcase

If File(cArqEnt)
	
	/*
	|---------------------------------------------------------------------------------
	|	VALIDAวรO DE TAMANHO DE ARQUIVO
	|---------------------------------------------------------------------------------
	*/
	nHdlFile := FOpen( cArqEnt, 0 + 64 )  // Read + Shared
	If nHdlFile < 0
		If !_lAuto
			Alert("Arquivo " + cArqEnt + " nใo existe!")
		EndIf
		FClose( nHdlFile )
		Return
	EndIf
	If FSeek( nHdlFile, 0, 2 ) > 10240000  // Ate 10 Megabytes
	    If !_lAuto
	    	Alert("Arquivo " + cArqEnt + "muito grande!")
	    EndIf
	    if Len(alltrim(cArqEDI)) > 0
			if !_lAuto //So executo se foi lido pelo usuario, se for processado pelo schedule ele tem controle proprio do log e copia dos arquivos
				cDestino:="\EDI\processados\"+cArqEDI+".txt"
				COPY FILE &cArqEnt TO &cDestino
			endif
		endif
		FClose( nHdlFile )
		Return
	EndIf
	FClose( nHdlFile )
	
	_nFFTU := FT_FUse(Alltrim(cArqEnt))
	FT_FGoTop()
	
	if _lAuto //Se for rotina automatica
		
		//Busco a segunda linha do arquivo para saber qual ้ o tipo de arquivo lido para posicionar a opcao de importa็ใo		
		FT_FSkip()
		cBuffer1 := FT_FReadLn()
		If Len(cBuffer1) > 778
			cDestino:="\EDI\nao_processados\"+cArqEDI+".txt"
			COPY FILE &cArqEnt TO &cDestino
			RETURN
		EndIf
		_cOco := Substr(cBuffer1,1,3) //Conhecimentos de Transporte
		Do Case
			Case _cOco == "320"
				cAtivo := '1' //Conhecimentos de Transporte
			Case _cOco == "340"
				cAtivo := '2' //Ocorrencia de Entrega
			Case _cOco == "350"
				cAtivo := '3' //Faturas de Transporte
		EndCase
	endif
	
	//	fSeek(_NomeArq1,0,0)
	Do Case
		Case Substr(cAtivo,1,1) == "1"
			nTamLin1  := 772+Len(CRLF)
		Case Substr(cAtivo,1,1) == "2"
			nTamLin1  := 120+Len(CRLF)
		Case Substr(cAtivo,1,1) == "3"
			nTamLin1  := 170+Len(CRLF)
	Endcase
	//	cBuffer1  := Space(nTamLin1) // Variavel para criacao da linha do registro para leitura
	
	
	
	//nBtLidos1 := fRead(_NomeArq1,@cBuffer1,nTamLin1) // Leitura da primeira linha do arquivo texto
	
	//	cBuffer1 := FT_FReadLn()
	
Else
	if !_lAuto
		Alert("Erro:"+CRLF+"Arquivo nใo encontrado!"+CRLF+CRLF+;
		"Solu็ใo:"+CRLF+"Verifique o caminho do arquivo ou se ele realmente existe!")
	endif
	Return
Endif

lValido   := .F.
aNotas    := {}
aConhec   := {}
aFaturas  := {}
nCount    := 1
bChk      := .F.
_nProximo := 1
cArqEDI   := ""
//_aConCTe  := {}   // _aConCTe
NITECURSOR:= 0
NCTECURSOR:= 0

_lFirstKey  := .T.

FT_FGoTop()

While !FT_FEOF()

	
	cBuffer1 := FT_FReadLn()
	
	Do Case
		Case Substr(cAtivo,1,1) == "1" //Conhecimento de Transportes
			cPos01_03 := Substr(cBuffer1,01,03) //IDENTIFICADOR DE REGISTRO
			If Val(cPos01_03) == 320     // Codigo 320 Cabecalho do Documento
				cArqEDI := alltrim(Substr(cBuffer1,4,14))
				lValido := .T.
			Endif
			If Val(cPos01_03) == 321     // Codigo 321 Dados transportadora

				_cCNPJTrans := Substr(cBuffer1,04,14)
				_cNomeTrans := alltrim(Substr(cBuffer1,15,50))

				If "|A|" $ cVldLayOut //
					If "UBERLOG" $ Upper(Alltrim(cBuffer1))
						nTpLayOut := 1
					EndIf
				EndIf

			endif
			If Val(cPos01_03) == 322     // Codigo 322 Conhecimentos de Transporte

				/*
				LAYOUT PROCEDA MUITO EXTENSO PARA SER ADICIONADO AO CODIGO COMO MODELO, VIDE DOCUMENTACAO DE LAYOUT.
				No	CAMPO	FORMATO	POSIวรO	STATUS	NOTAS
				1.		IDENTIFICADOR DE REGISTRO	N 3	001	M	"322"
				2.		FILIAL EMISSORA DO CONHECIMENTO	A 10	004	C
				3.		SษRIE DO CONHECIMENTO	A 5	014	C
				4.		NฺMERO DO CONHECIMENTO	A 12	019	M
				5.		DATA DE EMISSรO	N 8	031	M	DDMMAAAA
				6.		CONDIวรO DE FRETE	A 1	039	M	C = CIF; F = FOB
				7.		PESO TRANSPORTADO	N 5,2	040	M
				8.		VALOR TOTAL DO FRETE	N 13,2	047	M
				9.		BASE DE CมLCULO PARA APURAวรO ICMS	N 13,2	062	M
				10.		% DE TAXA DO ICMS	N 2,2	077	M
				11.		VALOR DO ICMS	N 13,2	081	M
				12.		VALOR DO FRETE POR PESO/VOLUME	N 13,2	096	M
				13.		FRETE VALOR	N 13,2	111	M
				14.		VALOR SEC - CAT	N 13,2	126	C
				15.		VALOR ITR	N 13,2	141	C
				16.		VALOR DO DESPACHO	N 13,2	156	C
				17.		VALOR DO PEDมGIO	N 13,2	171	C
				18.		VALOR ADEME	N 13,2	186	C
				19.		SUBSTITUIวรO TRIBUTมRIA?	N 1	201	M	1 = SIM; 2 = NรO
				20.		FILLER (ANTIGO CAMPO DE CFOP DE 3 POSIวีES)	A 3	202	M	Espa็os - Antigo campo de CFOP
				21.		C.G.C. DO EMISSOR DO CONHECIMENTO	N 14	205	M	SEM PONTOS E BARRA
				22.		C.G.C. DA EMBARCADORA
				23.		SษRIE DA NOTA FISCAL - 1	A 3	233	C
				24.		NฺMERO DA NOTA FISCAL - 1	N 8	236	M
				*/

				cPos004_10 := Substr(cBuffer1,004,10) //FILIAL EMISSORA DO CONHECIMENTO
				cPos014_05 := Substr(cBuffer1,014,05) //SษRIE DO CONHECIMENTO
				cPos019_12 := Substr(cBuffer1,019,12) //NฺMERO DO CONHECIMENTO
				cPos031_08 := Substr(cBuffer1,031,08) //DATA DE EMISSรO
				cPos039_01 := Substr(cBuffer1,039,01) //CONDIวรO DE FRETE
				cPos040_07 := Substr(cBuffer1,040,07) //PESO TRANSPORTADO
				cPos047_15 := Substr(cBuffer1,047,15) //VALOR TOTAL DO FRETE
				cPos062_15 := Substr(cBuffer1,062,15) //BASE DE CมLCULO PARA APURAวรO ICMS
				cPos077_04 := Substr(cBuffer1,077,04) //% DE TAXA DO ICMS
				cPos081_15 := Substr(cBuffer1,081,15) //VALOR DO ICMS
				cPos096_15 := Substr(cBuffer1,096,15) //VALOR DO FRETE POR PESO/VOLUME
				cPos111_15 := Substr(cBuffer1,111,15) //FRETE VALOR - ADVALOREM
				cPos126_15 := Substr(cBuffer1,126,15) //VALOR SEC - CAT
				cPos141_15 := Substr(cBuffer1,141,15) //VALOR ITR
				cPos156_15 := Substr(cBuffer1,156,15) //VALOR DO DESPACHO
				cPos171_15 := Substr(cBuffer1,171,15) //VALOR DO PEDมGIO
				cPos186_15 := Substr(cBuffer1,186,15) //VALOR ADEME - GRIS
				cPos201_15 := Substr(cBuffer1,201,01) //SUBSTITUIวรO TRIBUTมRIA?
				cPos202_03 := Substr(cBuffer1,202,03) //FILLER
				cPos205_03 := Substr(cBuffer1,205,14) //C.G.C. DO EMISSOR DO CONHECIMENTO
				cPos219_03 := Substr(cBuffer1,219,14) //C.G.C. DA EMBARCADORA
				//				cPos680_44 := IIf(Len(cBuffer1) >= 724, Substr(cBuffer1,683,44), "")
				
				//Log de Chave NFe
				_cOldArea   := Alias()
				_aOldArea   := GetArea()
				_aSA4Area   := SA4->(GetArea())
				
				_cCodUF     := ""
   				_cKeyCTe1   := ""
				_cKeyCTe2   := ""
				
				_nA4PsChv := 0
				_nAtivChv	:= 0
				DBSelectArea("SA4")
				DBSetOrder(3)
				lTraOkAchou := DBSeek(xFilial("SA4") + _cCNPJTrans )
				If .NOT. lTraOkAchou
					lTraOkAchou := DBSeek(xFilial("SA4") + cPos205_03 )
				EndIf
				If .NOT. lTraOkAchou
					lTraOkAchou := DBSeek(xFilial("SA4") + SUBSTR(_cCNPJTrans,1,8) )
				EndIf

				If lTraOkAchou .and. _lFirstKey

					If _lA4PsChv
						
						_nA4PsChv	:= IIf(SA4->A4_X_PSCHV <> 0, SA4->A4_X_PSCHV, 0)
						_nAtivChv	:= IIf(SA4->A4_X_PSCHV <> 0, SA4->A4_X_PSCHV, 0)
						
					EndIf
					
					If !Empty(SA4->A4_EST) .and. _nA4PsChv == 0
						
						_cCodUF := Tabela("AA", SA4->A4_EST, .F.)
						
						If _cCodUF <> NIL
							
							If Len(AllTrim(_cCodUF)) > 1
								
								_cKeyCTe1 := StrZero(Val(_cCodUF), 02)
								_cKeyCTe1 += SubStr(cPos031_08, 07, 02) + SubStr(cPos031_08, 03, 02)
								_cKeyCTe1 += _cCNPJTrans
								
								_nLenKey1 := Len(_cKeyCTe1)
								
								_cKeyCTe2 := StrZero(Val(cPos019_12), 09)
								
								_cFileChv := ""
								
								For _nIx = 1 To Len(cBuffer1) - 43
									
									_cTrecho := SubStr(cBuffer1, _nIx, 44)
									
									If SubStr(_cTrecho, 01, _nLenKey1) == _cKeyCTe1 .and. SubStr(_cTrecho, 26, 09) == _cKeyCTe2
										
										_nA4PsChv := _nIx
										
										If _lA4PsChv
											
											RecLock("SA4", .F.)
											
											SA4->A4_X_PSCHV := _nA4PsChv
											
											MSUnLock()
											
										EndIf
										
										_cFileChv := "chvnfe_" + _cCNPJTrans + "_" + StrZero(_nIx, 04) + ".txt"
										
										If !File(_cFileChv)
											
											MemoWrit(_cFileChv, _cTrecho )
											
											_lFirstKey  := .F.
											
										EndIf
										
										Exit
										
									EndIf
									
								Next _nIx
								
								If Empty(AllTrim(_cFileChv)) .and. _lFirstKey
									
									_cFileChv := "chvnfe_" + _cCNPJTrans + "__NOT.txt"
									
									MemoWrit(_cFileChv, _cFileChv )
									
									_lFirstKey  := .F.
									
								EndIf
								
							EndIf
							
						EndIf
						
					EndIf
					
				EndIf
				
				DBSelectArea("SA4")
				RestArea(_aSA4Area)
				
				DBSelectArea(_cOldArea)
				RestArea(_aOldArea)
				
				//Termino do Log de Chave NFe
				
				cPos680_44 := IIf(_nA4PsChv <> 0, Substr(cBuffer1, _nA4PsChv, 44), "")
				If _nAtivChv != 0
					cPos680_44 :=  Substr(cBuffer1, _nAtivChv, 44)
				EndIf
				
				aItem   := {}
				_aItCTe := {}

				/*
				Em 25/05/2016 atravez de defini็ใo da equipe de logistica quando a serie do conhecimento for 
				igual a UNICA os dados do conhecimento serใo relativos เ uma minuta
				*/
				If 	UPPER(AllTrim(cPos014_05)) = "UNICA"
					cPos014_05 := Substr(cPos014_05,1,TamSX3("F1_SERIE")[1])
				Else
					cPos014_05 := AllTrim(cPos014_05)
					cPos014_05 := StrZero(Val(cPos014_05), TamSX3("F1_SERIE")[1] )
				EndIf
				
				If !Empty(AllTrim(cPos680_44)) .and. Len(AllTrim(cPos680_44)) == 44 .and. !Empty(SubStr(AllTrim(cPos680_44), 23, 03))
					
					If cPos014_05 <> SubStr(AllTrim(cPos680_44), 23, 03)
						
						cPos014_05 := SubStr(AllTrim(cPos680_44), 23, 03)
						
					EndIf
					
				EndIf
				
				aadd(aItem,cPos004_10)
				aadd(aItem,cPos014_05)
				aadd(aItem,cPos019_12)
				aadd(aItem,STOD(Substr(cPos031_08,5,4)+Substr(cPos031_08,3,2)+Substr(cPos031_08,1,2)))
				aadd(aItem,cPos039_01)
				aadd(aItem,Val(cPos040_07)/100)
				aadd(aItem,Val(cPos047_15)/100)
				aadd(aItem,Val(cPos062_15)/100)
				aadd(aItem,Val(cPos077_04)/100)
				aadd(aItem,Val(cPos081_15)/100)
				aadd(aItem,Val(cPos096_15)/100)
				aadd(aItem,Val(cPos111_15)/100)
				aadd(aItem,Val(cPos126_15)/100)
				aadd(aItem,Val(cPos141_15)/100)
				aadd(aItem,Val(cPos156_15)/100)
				aadd(aItem,Val(cPos171_15)/100)
				aadd(aItem,Val(cPos186_15)/100)
				aadd(aItem,Val(cPos201_15)/100)
				aadd(aItem,cPos202_03)
				aadd(aItem,cPos205_03)
				aadd(aItem,cPos219_03)
				
				//40 notas fiscais em sequencia
				_nSerie := 233
				_nDoc   := 236
				For _nI := 1 to 40
					&("cPos"+Alltrim(str(_nSerie))+"_03") := Substr(cBuffer1,_nSerie,03) //SษRIE DA NOTA FISCAL
					&("cPos"+Alltrim(str(_nDoc))+"_08") := Substr(cBuffer1,_nDoc,08) //NฺMERO DA NOTA FISCAL
					
					aadd(aItem,&("cPos"+Alltrim(str(_nSerie))+"_03"))
					aadd(aItem,&("cPos"+Alltrim(str(_nDoc))+"_08"))
					
					_nSerie += 11
					_nDoc   += 11
				Next _nI
				
				cPos673_01 := Substr(cBuffer1,673,01) //AวรO DO DOCUMENTO
				cPos674_01 := Substr(cBuffer1,674,01) //TIPO DO CONHECIMENTO
				cPos675_01 := Substr(cBuffer1,675,01) //INDICAวรO DE CONTINUIDADE/REPETIวรO DOS DADOS DO CONHECIMENTO, QUANDO HOUVER MAIS DE 40 NFs
				cPos676_05 := Substr(cBuffer1,676,05) //CำDIGO DA OPERAวรO FISCAL DO CONHECIMENTO
				
				aadd(aItem,cPos673_01)
				aadd(aItem,cPos674_01)
				aadd(aItem,cPos675_01)
				aadd(aItem,cPos676_05)
				aadd(aItem,cArqEnt)
				aadd(aItem,_cCNPJTrans+" - "+_cNomeTrans)
				aadd(aItem,.F.)
				aadd(aItem,"A")
				aadd(aItem,"B")
				aadd(aItem,Len(aConhec)+3)
				
				aadd(aConhec,aItem)
				
				_aItCTe := AClone(aItem)  // Tratamento do CTe sem alterar o layout do array original
				AAdd(_aItCTe, cPos680_44)
				
				AAdd(_aConCTe, _aItCTe)

				NITECURSOR:= LEN(_aItCTe)
				NCTECURSOR++

			Endif
			If Val(cPos01_03) == 329 // Codigo 329 Dados da chave eletronica do CTe
				If nTpLayOut == 1 //LayOut UberLog
					_cNfeChave := Substr(cBuffer1,4,44)
				Else //Layout padrao
					_cNfeChave := Substr(cBuffer1,121,44)
				EndIf
				_aConCTe[NCTECURSOR][NITECURSOR]:=_cNfeChave
			endif
		Case Substr(cAtivo,1,1) == "2" //Ocorrencia de Entregas
			cPos01_03 := Substr(cBuffer1,01,03) //IDENTIFICADOR DE REGISTRO
			If Val(cPos01_03) == 340     // Codigo 340 Cabecalho do Documento
				cArqEDI := alltrim(Substr(cBuffer1,4,14))
				lValido := .T.
			Endif
			If Val(cPos01_03) == 341     // Codigo 341 Dados transportadora
				_cCNPJTrans := Substr(cBuffer1,04,14)
				_cNomeTrans := alltrim(Substr(cBuffer1,15,50))
			endif
			If Val(cPos01_03) == 342     // Codigo 342 Ocorrencia de entrega
				/*
				LAYOUT PROCEDA
				OCOREN-OCORRสNCIA NA ENTREGA DE MERCADORIA (VERSรO 3.1 DE 15/05/2000)
				PREENCHIMENTO: MANDATำRIO
				REGISTRO: O E N  - OCORRสNCIA NA ENTREGA	TAMANHO DO REGISTRO: 120
				OCCURS = 5000 (P/ CADA REG. "341")
				No	CAMPO	FORMATO	POSIวรO	STATUS	NOTAS
				1.	IDENTIFICADOR DE REGISTRO	N 3	01	M	"342"
				2.	CGC DA EMPRESA EMISSORA DA NOTA FISCAL	N 14	04	C
				3.	SษRIE DA NOTA FISCAL	A 3	18	C
				4.	NฺMERO DA NOTA FISCAL	N 8	21	M
				5.	CำDIGO DE OCORRสNCIA NA ENTREGA	N 2	29	M	Vide tabela anexa com os c๓digos de ocorr๊ncia disponํveis para uso
				6.	DATA DA OCORRสNCIA	N 8	31	M	DDMMAAAA
				7.	HORA DA OCORRสNCIA	N 4	39	C	HHMM
				8.	CำDIGO DE OBSERVAวรO DE OCORRสNCIA NA ENTRADA	N 2	43	C	01 = Devolu็ใo/recusa total, 02 = Devolu็ใo/recusa parcial, 03 = Aceite/entrega por acordo
				9.	TEXTO EM FORMATO LIVRE	A 70	45	C	TEXTO COMPLEMENTAR EXPLICATIVO
				10.	FILLER	A 6	115	C	PREENCHER COM BRANCOS
				*/
				cPos04_14 := Substr(cBuffer1,04,14) //CGC DA EMPRESA EMISSORA DA NOTA FISCAL
				cPos18_03 := Substr(cBuffer1,18,03) //SษRIE DA NOTA FISCAL
				if Len(alltrim(cPos18_03)) == 0
					cPos18_03 := SuperGetMv("MV_XOCOSER",,"1  ")
				endif
				cPos21_08 := '0'+Substr(cBuffer1,21,08) //NฺMERO DA NOTA FISCAL
				cPos29_02 := Substr(cBuffer1,29,02) //CำDIGO DE OCORRสNCIA NA ENTREGA
				cPos31_08 := Substr(cBuffer1,31,08) //DATA DA OCORRสNCIA
				cPos39_04 := Substr(cBuffer1,39,04) //HORA DA OCORRสNCIA
				//_cDescOco := GetAdvFval("SX5","X5_DESCRI","  ZI"+cPos29_02,1) // Chave ignorando a Filial
				_cDescOco := GetAdvFval("SX5", "X5_DESCRI", + xFilial("SX5") + "ZI" + cPos29_02, 1)
				if Len(Alltrim(_cDescOco)) == 0
					_cDescOco := "Ocorrencia nao localizada"
				endif
				cPos45_70 := Substr(cBuffer1,45,70) //TEXTO COMPLEMENTAR EXPLICATIVO
				//		1		2			3			4		5																			6			7				8	  9		10			11			12						  13	14
				AAdd(aNotas,{cPos04_14,cPos18_03,cPos21_08,cPos29_02,STOD(Substr(cPos31_08,5,4)+Substr(cPos31_08,3,2)+Substr(cPos31_08,1,2)),cPos39_04,"NF Atualizada",_cDescOco,.T.,Len(aNotas)+3,cArqEnt,_cCNPJTrans+" - "+_cNomeTrans,"",cPos45_70})
			Endif
		Case Substr(cAtivo,1,1) == "3" //Fatura de Transportes
			cPos01_03 := Substr(cBuffer1,01,03) //IDENTIFICADOR DE REGISTRO
			If Val(cPos01_03) == 350     // Codigo 350 Cabecalho do Documento
				cArqEDI := alltrim(Substr(cBuffer1,4,14))
				lValido := .T.
			Endif
			If Val(cPos01_03) == 351     // Codigo 351 Dados transportadora
				_cCNPJTrans := Substr(cBuffer1,04,14)
				_cNomeTrans := alltrim(Substr(cBuffer1,15,50))
			endif
			If Val(cPos01_03) == 352     // Codigo 352 Dados da Fatura
				/*
				IDENTIFICADOR DE REGISTRO	N 3	001	M	"352"
				FILIAL EMISSORA DO DOCUMENTO	A 10	004	M	IDENTIFICAวรO DA UNIDADE EMISSORA
				TIPO DO DOCUMENTO DE COBRANวA	N 1	014	M	0 = NOTA FISCAL FATURA; 1 = ROMANEIO
				SษRIE DO DOCUMENTO DE COBRANวA	A 3	015	C
				NฺMERO DO DOCUMENTO DE COBRANวA	N 10	018	M
				DATA DE EMISSรO	N 8	028	M	DDMMAAAA
				DATA DE VENCIMENTO	N 8	036	M	DDMMAAAA
				VALOR DO DOCUMENTO DE COBRANวA	N 13,2	044	M
				TIPO DE COBRANวA	A 3	059	M
				VALOR TOTAL DO ICMS	N 13,2	062	M
				VALOR - JUROS POR DIA DE ATRASO	N 13,2	077	C
				DATA LIMITE P/ PAGTO C/ DESCONTO	N 8	092	C	DDMMAAAA
				VALOR DO DESCONTO	N 13,2	100	C
				IDENTIFICAวรO DO AGENTE DE COBRANวA	A 35	115	M	NOME DO BANCO
				NฺMERO DA AGสNCIA BANCมRIA	N 4	150	C
				DอGITO VERIFICADOR NUM. DA AGสNCIA	A 1	154	C	           DEL
				NฺMERO DA CONTA CORRENTE	N 10	155	C
				DอGITO VERIFICADOR CONTA CORRENTE	A 2	165	C
				AวรO DO DOCUMENTO	A 1	167	C	I = INCLUIR;
				E = EXCLUIR/CANCELAR
				*/
				cPos04_10 := Substr(cBuffer1,04,10)
				cPos14_01 := Substr(cBuffer1,14,01)
				cPos15_03 := Substr(cBuffer1,15,03)
				cPos18_10 := StrZero(Val(Substr(cBuffer1,19,9)),9) // StrZero(Val(Substr(cBuffer1,18,10)),9) // Ajuste para evitar estouro de campo
				cPos28_08 := Substr(cBuffer1,28,08)
				cPos36_08 := Substr(cBuffer1,36,08)
				
				cPos28_08 := STOD(Substr(cPos28_08,5,4)+Substr(cPos28_08,3,2)+Substr(cPos28_08,1,2))
				cPos36_08 := STOD(Substr(cPos36_08,5,4)+Substr(cPos36_08,3,2)+Substr(cPos36_08,1,2))
				
				//Cabecalho da Fatura
				AAdd(aFaturas,{cPos04_10,cPos14_01,cPos15_03,cPos18_10,cPos28_08,cPos36_08,{},_cCNPJTrans,_cNomeTrans,"",cArqEnt,"","","",""})
			endif
			If Val(cPos01_03) == 353     // Codigo 353 Conhecimentos da Fatura
				/*
				IDENTIFICADOR DE REGISTRO	N 3	01	M	"353"
				FILIAL EMISSORA DO DOCUMENTO	A 10	04	M	IDENTIFICAวรO DA UNIDADE EMISSORA
				SษRIE DO CONHECIMENTO	A 5	14	C
				NฺMERO DO CONHECIMENTO	A 12	19	M
				VALOR DO FRETE (*)	N 13,2	31	C
				DATA DE EMISSรO DO CONHECIMENTO (*)	N 8	46	C	DDMMAAAA
				CGC DO REMETENTE - EMISSOR DA NF (*)	N 14	54	C	SEM EDIวรO (PONTOS E HอFEN)
				CGC DO DESTINATมRIO DA NF (*)	N 14	68	C	SEM EDIวรO (PONTOS E HอFEN)
				CGC DO EMISSOR DO CONHECIMENTO (**)	N 14	82	C	SEM EDIวรO (PONTOS E HอFEN)
				FILLER	A 75	96	C	PREENCHER COM BRANCOS
				*/
				cPos04_10 := Substr(cBuffer1,04,10)
				cPos14_05 := Substr(cBuffer1,14,05)
				cPos19_12 := Substr(cBuffer1,19,12)
				cPos54_15 := Substr(cBuffer1,54,14)
				
				//Conhecimentos que compoem a Fatura
				AAdd(aFaturas[Len(aFaturas)][7],{cPos04_10,cPos14_05,cPos19_12,{}})
				//Adiciono na matriz principal o CNPJ da empresa emissora do conhecimento
				if alltrim(aFaturas[Len(aFaturas)][10]) == ""
					aFaturas[Len(aFaturas)][10] := cPos54_15
				endif
			endif
			If Val(cPos01_03) == 354     // Codigo 354 Notas fiscais do conhecimento
				/*
				IDENTIFICADOR DE REGISTRO	N 3	01	M	"354"
				SษRIE	A 3	04	C
				NฺMERO DA NOTA FISCAL	N 8	07	M
				DATA DE EMISSรO DA NOTA FISCAL	N 8	15	M	DDMMAAAA
				PESO DA NOTA FISCAL	N 5,2	23	M
				VALOR DA MERCADORIA NA NOTA FISCAL	N 13,2	30	M
				CGC DO EMISSOR DA NOTA FISCAL	N 14	45	C
				FILLER	A 112	59	C	PREENCHER COM BRANCOS
				*/
				cPos04_03 := Substr(cBuffer1,04,03)
				cPos07_08 := Substr(cBuffer1,07,08)
				cPos15_08 := Substr(cBuffer1,15,08)
				cPos23_07 := Substr(cBuffer1,23,07)
				cPos30_15 := Substr(cBuffer1,30,15)
				
				//Conhecimentos que compoem a Fatura
				AAdd(aFaturas[Len(aFaturas)][7][len(aFaturas[Len(aFaturas)][7])][4],{cPos04_03,cPos07_08,cPos15_08,cPos23_07,cPos30_15})
			endif
	Endcase
	
	FT_FSKIP()
	
Enddo

FT_FUse()

//FClose(_NomeArq1)

//Se nao achou nota
if !lValido
	if !_lAuto
		Do Case
			Case Substr(cAtivo,1,1) == "1"
				Alert("Erro: Arquivo invalido!, Registro tipo 320 nao localizado no arquivo!")
			Case Substr(cAtivo,1,1) == "2"
				Alert("Erro: Arquivo invalido!, Registro tipo 340 nao localizado no arquivo!")
			Case Substr(cAtivo,1,1) == "3"
				Alert("Erro: Arquivo invalido!, Registro tipo 350 nao localizado no arquivo!")
		EndCase
	endif
	Return
endif

// Mover o arquivo para a Pasta Lidos
if Len(alltrim(cArqEDI)) > 0
	if !_lAuto //So executo se foi lido pelo usuario, se for processado pelo schedule ele tem controle proprio do log e copia dos arquivos
		cDestino:="\EDI\Lidos\"+cArqEDI+".txt"
		COPY FILE &cArqEnt TO &cDestino
	endif
endif
//fErase(cArqEnt)

Do Case
	Case Substr(cAtivo,1,1) == "1" //Conhecimento de Transportes
		//Chama Funcao de Atualizacao do SF2
		If len(aConhec) > 0
			if !_lAuto
				MsAguarde({|x| AtuPAV(_lAuto,@_aDados)},,"Atualizando Dados !")
				Relatorio()
				Msginfo("Importa็ใo realizada com sucesso!","Aviso")
			else
				AtuPAV(_lAuto,@_aDados)
			endif
		else
			if !_lAuto
				Alert("Nao foram encontrados registros tipo 322 no arquivo informado!")
			endif
		Endif
	Case Substr(cAtivo,1,1) == "2" //Ocorrencia de Entregas
		//Chama Funcao de Atualizacao do SF2
		If len(aNotas) > 0
			if !_lAuto
				MsAguarde({|x| AtuSf2(_lAuto,@_aDados)},,"Atualizando Dados !")
				Relatorio()
				Msginfo("Importa็ใo realizada com sucesso!","Aviso")
			else
				AtuSf2(_lAuto,@_aDados)
			endif
		else
			if !_lAuto
				Alert("Nao foram encontrados registros tipo 342 no arquivo informado!")
			endif
		Endif
	Case Substr(cAtivo,1,1) == "3" //Faturas de Transportes
		If len(aFaturas) > 0
			if !_lAuto
				MsAguarde({|x| AtuFAT(_lAuto,@_aDados)},,"Atualizando Dados !")
				Relatorio()
				Msginfo("Importa็ใo realizada com sucesso!","Aviso")
			else
				AtuFAT(_lAuto,@_aDados)
			endif
		else
			if !_lAuto
				Alert("Nao foram encontrados registros tipo 322 no arquivo informado!")
			endif
		Endif
EndCase

Return

/*
ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAtuSf2    บAutor  ณFernando Bombardi   บ Data ณ  15/09/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณAtualiza os dados do SF2 (F2_CONHECI,F2_VALCON,F2_DTRECEB)  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ TAIFF                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function AtuSf2(_lAuto,_aDados)
//Local _bLog := .F.
//Local _bPri := .T.
Local _bVai := .F.
Local _N
Local aSavATU := GetArea()
Local aSavSM0 := SM0->(GetArea())

DEFAULT _lAuto := .F.
DEFAULT _aDados:= {}

//Ordenando por CNPJ da Emissora para poder posicionar o sigamat quando for rotina automatica
_lFirst := .F.
if _lAuto
	aSort(aNotas,,,{|x,y| x[1] < y[1] })
	_lFirst := .T.
endif

if len(aNotas) > 0
	_cCnpj := aNotas[1][1]
	For _N := 1 to len(aNotas)
		
		if _lAuto //Se For Executado via Schedule, posiciono o Sigamat e Seto o environment para processar os registros
			if _cCnpj <> aNotas[_N][1] .OR. _lFirst
				DBSelectArea("SM0")
				DBGoTop()
				While !SM0->(Eof()) //.AND. SM0->M0_CODIGO >= "01" .AND. SM0->M0_CODIGO <= "07"
					IF SM0->M0_CODIGO >= "01" .AND. SM0->M0_CODIGO <= "04"
						if alltrim(aNotas[_N][1]) == alltrim(SM0->M0_CGC)
							//Se Achar o CNPJ no Sigamat aponto o RPC
							cEmpAnt := SM0->M0_CODIGO
							cFilAnt := SM0->M0_CODFIL
							RPCClearEnv()
							RpcSetType(3)
							RPCSetEnv(cEmpAnt,cFilAnt)
							Exit
						endif
					ENDIF
					SM0->(DBSkip())
				EndDo
				_lFirst := .F.
			endif
		endif
		
		if !_lAuto
			Do Case
				Case SubStr(cAtivo,1,1) == "2"
					_cTexto := "Nota Nr.: "+ aNotas[_N,2]+"/"+aNotas[_N,3] +"  Restantes " + Str(len(aNotas)-_N)
			Endcase
			MsProcTxt(_cTexto)
		endif
		
		Do Case
			Case Substr(cAtivo,1,1) == "2"
				dbSelectArea("SF2")
				dbSetOrder(1)
				_bVai := dbSeek(xFilial("SF2")+aNotas[_N,3]+aNotas[_N,2])
				/* Comentado porque nao estou usando o sigamat da taiff */
				If Left(aNotas[_N,1],5) <> Left(SM0->M0_CGC,5)
					aNotas[_N][7] := "CNPJ do Arquivo nใo confere com CNPJ da Empresa"
					aNotas[_N][9] := .F.
					aNotas[_N][13] := "Empresa do arquivo nใo consta no SIGAMAT do sistema"
					Loop
				Endif
		Endcase
		If _bVai
			Do Case
				Case Substr(cAtivo,1,1) == "2"
					
					_lOkTransp := .F.
					
					DBSelectArea("SA4")
					DBSetOrder(3)
					If DBSeek(xFilial() + _cCNPJTrans)
						
						If SA4->A4_COD == SF2->F2_TRANSP
							
							_lOkTransp := .T.
							
						EndIf
						
					EndIf
					
					DBSelectArea("SF2")
					
					If _lOkTransp
						
						Reclock("SF2",.F.)
						
						If aNotas[_N][4] $ SuperGetMV("MV_XOCOENT",,"01/02") //Definir MV para controlar as ocorrencias de entrega
							
							SF2->F2_DTRECEB := aNotas[_N,5]
							
						EndIf
						
						SF2->F2_OCOENT := aNotas[_N][4]
						SF2->F2_OCODAT := aNotas[_N][5]
						SF2->F2_OCODES := aNotas[_N][8]
						SF2->F2_OCOARQ := cArqEDI
						
						MsUnlock()
						
						U_GravaPAU(aNotas,_N)	// incluido em 06/12/2012
						
					Else
						
						aNotas[_N][7] := "Transp. diferente"
						aNotas[_N][9] := .F.
						
					EndIf
			Endcase
		Else
			aNotas[_N][7] := "NF nใo localizada"
			aNotas[_N][9] := .F.
		Endif
		
		aNotas[_N][13] := SM0->M0_CGC+" - "+SM0->M0_NOME
		_cCnpj := aNotas[_N][1]
		
	Next _N
Endif

if _lAuto
	_aDados := aClone(aNotas)
endif

RestArea(aSavSM0)
RestArea(aSavATU)

Return .T.

/*
ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ AtuPAV   บAutor  ณAnderson Messias    บ Data ณ  20/03/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Atualiza os dados do Conhecimento na tabela PAV            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ TAIFF                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function AtuPAV(_lAuto,_aDados)
//Local _bLog := .F.
//Local _bPri := .T.
//Local _bVai := .F.
Local _N
Local aSavATU := GetArea()
Local aSavSM0 := SM0->(GetArea())
Local aCteOriginal := {} // copia do arquivo com conhecimentos 
Local nRatLoop := 0
Local cMensRateio := ""
Local _nI	:= 0
Local _nChv	:= 0
Local cVTpCTe := SuperGetMV("DFATNF001",,"|N|")
Local cGTpCTe := SuperGetMV("DFATNF002",,"N")
Local lGo := .T.

Private lMsErroAuto := .F.

aCteOriginal := Aclone(aConhec) // Clona arquivo de conhecimentos 

//Ordenando por CNPJ da Emissora para poder posicionar o sigamat quando for rotina automatica
aSort(aConhec,,,{|x,y| x[21]+x[3] < y[21]+y[3] })
_lFirst := .F.
_lExec  := .F.
if _lAuto
	_lFirst := .T.
endif

If Len(aConhec) > 0

	_cCnpj := aConhec[1][21]

	For _N := 1 to len(aConhec)

		lGo := .T.

		if _lAuto //Se For Executado via Schedule, posiciono o Sigamat e Seto o environment para processar os registros
			if _cCnpj <> aConhec[_N][21] .OR. _lFirst
				DBSelectArea("SM0")
				DBGoTop()
				While !SM0->(Eof()) //.AND. SM0->M0_CODIGO >= "01" .AND. SM0->M0_CODIGO <= "07"
					IF SM0->M0_CODIGO >= "01" .AND. SM0->M0_CODIGO <= "04"
						if alltrim(aConhec[_N][21]) == alltrim(SM0->M0_CGC)
							//Se Achar o CNPJ no Sigamat aponto o RPC
							cEmpAnt := SM0->M0_CODIGO
							cFilAnt := SM0->M0_CODFIL
							RPCClearEnv()
							RpcSetType(3)
							RPCSetEnv(cEmpAnt,cFilAnt)
							Exit
						endif
					ENDIF
					SM0->(DBSkip())
				EndDo
				_lFirst := .F.
			endif
		endif
		
		if !_lAuto
			Do Case
				Case SubStr(cAtivo,1,1) == "1"
					_cTexto := "Conhecimento Nr.: "+ aConhec[_N,2]+"/"+aConhec[_N,3] +"  Restantes " + alltrim(Str(len(aConhec)-_N))
					If Left(aConhec[_N,21],5) <> Left(SM0->M0_CGC,5)
						aConhec[_N][Len(aConhec[_N])-4] := "CNPJ do Arquivo nใo confere com CNPJ da Empresa"
						aConhec[_N][Len(aConhec[_N])-3] := .F.
						aConhec[_N][Len(aConhec[_N])-2] := "Empresa do arquivo nใo consta no SIGAMAT do sistema"
						aConhec[_N][Len(aConhec[_N])-1] := aConhec[_N,21]+" - Empresa do arquivo nใo consta no SIGAMAT do sistema - Conhecimento nใo importado"
						Loop
					Endif
			Endcase
			MsProcTxt(_cTexto)
		endif

		If !( Upper(Alltrim(aConhec[_N,103])) $ cVTpCTe )
			aConhec[_N][Len(aConhec[_N])-3] := .F.
			aConhec[_N][Len(aConhec[_N])-2] := "CTe de tipo " +aConhec[_N,103]+" nao importado"
			aConhec[_N][Len(aConhec[_N])-1] := "CTe de tipo " +aConhec[_N,103]+" nao importado"
			lGo := .F.
		EndIf

		If lGo

			aCab := {}
			aItens := {}
			DBSelectArea("SA4")
			DBSetOrder(3)
			if DBSeek(xFilial("SA4")+alltrim(aConhec[_N][20]))
				//Executando Rotina Automatica.
				aCab := {}
				aadd(aCab,{"PAV_CODTRA",SA4->A4_COD,Nil})
				aadd(aCab,{"PAV_TIPO","V",Nil})
				
				aItens := {}
				nPosNF  := 23
				_nPosSr := 22  // 26/02/2014
				For _nI := 1 to 40
					aItem := {}
					if Val(aConhec[_N][nPosNF]) > 0
						aadd(aItem,{"PAV_NF",aConhec[_N][nPosNF],Nil})
						aadd(aItem,{"PAV_SERIE",aConhec[_N][_nPosSr],Nil}) // 26/02/2014
						
						If AllTrim(aConhec[_N][_nPosSr]) <> "1"
							
							_nStopHere := 1
							
						EndIf
						
						aadd(aItem,{"PAV_CTO",aConhec[_N][3],Nil})
						if _nI == 1
							aadd(aItem,{"PAV_PESOCU",aConhec[_N][6],Nil})
							aadd(aItem,{"PAV_FRETRA",aConhec[_N][7],Nil})
							//Campos que gravarao os valores do arquivo importado
							aadd(aItem,{"PAV_IVLGRI",aConhec[_N][17],Nil})
							aadd(aItem,{"PAV_IADVAL",aConhec[_N][12],Nil})
							aadd(aItem,{"PAV_IVLPES",aConhec[_N][11],Nil})
							aadd(aItem,{"PAV_ITXACT",aConhec[_N][15],Nil})
							aadd(aItem,{"PAV_IVLRPE",aConhec[_N][16],Nil})
							//aadd(aItem,{"PAV_IOTRTX",aConhec[_N][6],Nil})
						else
							aadd(aItem,{"PAV_PESOCU",1,Nil})
							aadd(aItem,{"PAV_FRETRA",1,Nil})
							//Campos que gravarao os valores do arquivo importado
							aadd(aItem,{"PAV_IVLGRI",0,Nil})
							aadd(aItem,{"PAV_IADVAL",0,Nil})
							aadd(aItem,{"PAV_IVLPES",0,Nil})
							aadd(aItem,{"PAV_ITXACT",0,Nil})
							aadd(aItem,{"PAV_IVLRPE",0,Nil})
							//aadd(aItem,{"PAV_IOTRTX",aConhec[_N][6],Nil})
						endif
						
						aadd(aItem,{"PAV_IMPORT","S",Nil})
						aadd(aItem,{"PAV_EMICTO",aConhec[_N][4],Nil})
						
						If _lSerCto
							
							aadd(aItem,{"PAV_SERCTO", aConhec[_N][2],Nil})
							
						EndIf
						
						_nPosCto := AScan(aItem,{ |x| x[1] == "PAV_CTO"})
						
						_nPosCTe := AScan(_aConCTe, { |x| x[_nPosCTo] == aItem[_nPosCto][2] } )
						
						_nPosCHVe := Len(_aConCTe[1])

						If !Empty(AllTrim(_aConCTe[_nPosCTe][_nposCHVe]))
							
							AAdd(aItem,{"PAV_CHVNFE", _aConCTe[_nPosCTe][_nposCHVe], Nil })
							
						EndIf

						If cGTpCTe == "S"
							aadd(aItem,{"PAV_TPCTE",aConhec[_N][103],Nil})
						EndIf
						
						
						//					If !Empty(AllTrim(_aConCTe[_N][Len(_aConCTe[_N])]  ))
						
						//						aadd(aItem,{"PAV_CHVNFE", _aConCTe[_N][Len(_aConCTe[_N])], Nil })            //Len(_aConCTe[_N])
						
						//					EndIf
						
						aadd(aItens,aItem)
						
					EndIf
					
					nPosNF  += 2
					_nPosSr += 2  // 26/02/2014
					
				Next _nI
				
			EndIf

			If Len(aItens)>0

				lMsErroAuto := .F.
				MSExecAuto({|x,y,z| u_CONFCONH(x,y,z)},aCab,aItens,3)
				cMensRateio := ""

				If lMsErroAuto
					cPath := GetSrvProfString("Startpath","")
					cArquivo := CriaTrab(,.F.)
					cArquivo := alltrim(cArquivo)+".Log"
					MostraErro(cPath,cArquivo)
					cMsg := MemoRead(cPath+"\"+cArquivo)
					aConhec[_N][Len(aConhec[_N])-1] := cMsg
				else                                        
					
					//Atualiza o campo PAV_CHVNFE para todos os PAVs de um mesmo Conhecimento        
					_nLenIte  := Len(aItens)
					
					If _nLenIte > 1                          
					
						_cAtuChv  := "" 
						_cAtuCto  := "" 
						_cAtuSct  := ""  
						
						For _nChv := 1 To _nLenIte
							
							_aItChv   := aItens[_nChv]
							_nPos_Chv := AScan(_aItChv, {|x| x[1] == "PAV_CHVNFE"})
							_nPos_Cto := AScan(_aItChv, {|x| x[1] == "PAV_CTO"})
							_nPos_SCt := AScan(_aItChv, {|x| x[1] == "PAV_SERCTO"})
						
							If _nPos_Chv <> 0
							
								_cAtuChv := _aItChv[_nPos_Chv][2] 
								_cAtuCto := _aItChv[_nPos_Cto][2] 
								_cAtuSct := _aItChv[_nPos_SCt][2] 
								
								If Len(AllTrim(_cAtuChv)) == 44
								
									Exit                   
								
								EndIf
							
							EndIf 
					
						Next _nChv
					
						If !Empty(AllTrim(_cAtuChv)) .and. !Empty(AllTrim(_cAtuCto)) 
						
							_cQryUpd := "UPDATE " + RetSQLName("PAV")  + "  " 
							_cQryUpd += "SET PAV_CHVNFE = '" +_cAtuChv + "' "
							_cQryUpd += "WHERE " 
							_cQryUpd += "PAV_FILIAL = '" + xFilial("PAV") + "' AND "
							_cQryUpd += "PAV_CTO    = '" + _cAtuCto       + "' AND "
							_cQryUpd += "PAV_SERCTO = '" + _cAtuSct       + "' AND "
							_cQryUpd += "PAV_CODTRA = '" + SA4->A4_COD    + "' AND "
							_cQryUpd += "D_E_L_E_T_ <> '*' AND "
							_cQryUpd += "PAV_CHVNFE  = ''      "	
							
							TCSqlExec(_cQryUpd)
							
						EndIf    


						/* Rerateio do conhecimento na importa็ใo do arquivo */
						_cAtuChv  := "" 
						_cAtuCto  := "" 
						_cAtuSct  := ""  
						
						For _nChv := 1 To _nLenIte
							
							_aItChv   := aItens[_nChv]
							_nCtoPos := AScan(_aItChv, {|x| x[1] == "PAV_CTO"})
							_nSCtPos := AScan(_aItChv, {|x| x[1] == "PAV_SERCTO"})
						
							If _nPos_Cto <> 0
							
								_cAtuCto := _aItChv[_nCtoPos][2] 
								_cAtuSct := _aItChv[_nSCtPos][2]

								nVlCteFrete := 0

								// Loop para buscar o valor original do frete contido no arquivo de conhecimentos
								For nRatLoop := 1 to Len(aCteOriginal)
									
									If aCteOriginal[nRatLoop][3] = _cAtuCto
										nVlCteFrete := aCteOriginal[nRatLoop][7] 
										Exit
									EndIf

								Next nRatLoop

								If nVlCteFrete != 0
								
									_cSqlBrut:="SELECT " + ENTER
									_cSqlBrut+="	ISNULL(SUM(F2_VALBRUT),0) AS TT_VALBRUT " + ENTER 
									_cSqlBrut+="FROM " + RetSQLName("SF2")  + " SF2 WITH(NOLOCK) " + ENTER
									_cSqlBrut+="INNER JOIN " + RetSQLName("PAV") + " PAV WITH(NOLOCK) " + ENTER
									_cSqlBrut+="	ON PAV_FILIAL=F2_FILIAL" + ENTER
									_cSqlBrut+="	AND PAV.D_E_L_E_T_='' " + ENTER
									_cSqlBrut+="	AND PAV_NF		= F2_DOC" + ENTER
									_cSqlBrut+="	AND PAV_SERIE	= F2_SERIE " + ENTER
									_cSqlBrut+="	AND PAV.PAV_CODTRA = '" + SA4->A4_COD    + "' " + ENTER
									_cSqlBrut+="	AND PAV.PAV_CTO = '" + Strzero(Val(_cAtuCto),9)       + "' " + ENTER
									_cSqlBrut+="	AND PAV.PAV_SERCTO = '" + _cAtuSct       + "' " + ENTER
									_cSqlBrut+="WHERE " + ENTER
									_cSqlBrut+="	F2_FILIAL = '" + xFilial("SF2") + "' " + ENTER 
									_cSqlBrut+="	AND F2_TRANSP = '" + SA4->A4_COD + "' "  + ENTER
									_cSqlBrut+="	AND F2_TIPO='N' " + ENTER
									_cSqlBrut+="	AND SF2.D_E_L_E_T_='' "  + ENTER
									//MemoWrite("DFATNF_SELECT_DO_TOTAL_BRUTO.SQL",_cSqlBrut)
								
									If Select("SQLBRT") # 0
										SQLBRT->(DbCloseArea())
									EndIf
								
									TcQuery _cSqlBrut New Alias "SQLBRT"

									nVlTTBruto :=	SQLBRT->TT_VALBRUT
										
									_cQryUpd := "UPDATE PAV SET "  + ENTER
									_cQryUpd += "	 PAV_FRETRA = ISNULL(ROUND( ((SF2.F2_VALBRUT/ '" + ALLTRIM(STR(nVlTTBruto)) + "' ) * '" + ALLTRIM(STR(nVlCteFrete)) + "' ) ,4),0) " + ENTER
									_cQryUpd += "	 ,PAV_DESCON = ISNULL(ROUND(PAV_FRETRA - PAV_FRCALC,4),0) " + ENTER
									_cQryUpd += "FROM " + RetSQLName("PAV")  + " PAV "  + ENTER
									_cQryUpd += "INNER JOIN " + RetSQLName("SF2") + " SF2 WITH(NOLOCK) " + ENTER
									_cQryUpd += "	ON PAV_FILIAL=F2_FILIAL" + ENTER
									_cQryUpd += "	AND SF2.D_E_L_E_T_='' " + ENTER
									_cQryUpd += "	AND PAV_NF		= F2_DOC" + ENTER
									_cQryUpd += "	AND PAV_SERIE	= F2_SERIE " + ENTER
									_cQryUpd += "	AND PAV_CODTRA = F2_TRANSP "  + ENTER
									_cQryUpd += "	AND F2_TIPO='N' " + ENTER
									_cQryUpd += "WHERE "  + ENTER
									_cQryUpd += "	PAV_FILIAL = '" + xFilial("PAV") + "' AND " + ENTER
									_cQryUpd += "	PAV_CTO    = '" + Strzero(Val(_cAtuCto),9)       + "' AND " + ENTER
									_cQryUpd += "	PAV_SERCTO = '" + _cAtuSct       + "' AND " + ENTER
									_cQryUpd += "	PAV_CODTRA = '" + SA4->A4_COD    + "' AND " + ENTER
									_cQryUpd += "	PAV.D_E_L_E_T_ = '' " + ENTER
									
									//MemoWrite("DFATNF_UPD_DO_RATEIO.SQL",_cQryUpd)
									TCSqlExec(_cQryUpd)
									SQLBRT->(DbCloseArea())

									_cSqlBrut := "SELECT ROUND(SUM(PAV_FRETRA),2) AS PAV_FRETRA " + ENTER
									_cSqlBrut += "FROM " + RetSQLName("PAV")  + " PAV "  + ENTER
									_cSqlBrut += "INNER JOIN " + RetSQLName("SF2") + " SF2 WITH(NOLOCK) " + ENTER
									_cSqlBrut += "	ON PAV_FILIAL=F2_FILIAL" + ENTER
									_cSqlBrut += "	AND SF2.D_E_L_E_T_='' " + ENTER
									_cSqlBrut += "	AND PAV_NF		= F2_DOC" + ENTER
									_cSqlBrut += "	AND PAV_SERIE	= F2_SERIE " + ENTER
									_cSqlBrut += "	AND PAV_CODTRA = F2_TRANSP "  + ENTER
									_cSqlBrut += "	AND F2_TIPO='N' " + ENTER
									_cSqlBrut += "WHERE "  + ENTER
									_cSqlBrut += "	PAV_FILIAL = '" + xFilial("PAV") + "' AND " + ENTER
									_cSqlBrut += "	PAV_CTO    = '" + Strzero(Val(_cAtuCto),9) + "' AND " + ENTER
									_cSqlBrut += "	PAV_SERCTO = '" + _cAtuSct       + "' AND " + ENTER
									_cSqlBrut += "	PAV_CODTRA = '" + SA4->A4_COD    + "' AND " + ENTER
									_cSqlBrut += "	PAV.D_E_L_E_T_ = '' " + ENTER
									//MemoWrite("DFATNF_SELECT_DO_TOTAL_PAV_FRETRA.SQL",_cSqlBrut)
								
									If Select("SQLBRT") # 0
										SQLBRT->(DbCloseArea())
									EndIf
								
									TcQuery _cSqlBrut New Alias "SQLBRT"
									
									cMensRateio := " - rateio com sucesso!"	
									If	SQLBRT->PAV_FRETRA != nVlCteFrete
										cMensRateio := " - rateio com erro!"	
									EndIf

								EndIf	
							
							EndIf 
					
						Next _nChv
						/* fim do rateio */
				
					EndIf    
				
					aConhec[_N][Len(aConhec[_N])-3] := .T.
					aConhec[_N][Len(aConhec[_N])-1] := "Conhecimento importado com sucesso" + cMensRateio

				EndIf
			else
				//aConhec[_N][Len(aConhec[_N])-4] := "CNPJ do Arquivo nใo confere com CNPJ da Empresa"
				aConhec[_N][Len(aConhec[_N])-3] := .F.
				aConhec[_N][Len(aConhec[_N])-2] := "Transportadora nใo cadastrada no sistema"
				aConhec[_N][Len(aConhec[_N])-1] := alltrim(aConhec[_N][20])+" - Transportadora nao cadastrada no sistema - Conhecimento nใo importado"
			endif
			
			aConhec[_N][Len(aConhec[_N])-2] := SM0->M0_CGC+" - "+SM0->M0_NOME
			
			_cCnpj := aConhec[_N][21]

		EndIf

	Next _N

EndIf

if _lAuto
	_aDados := aClone(aConhec)
endif

RestArea(aSavSM0)
RestArea(aSavATU)

Return .T.

/*
ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ AtuFAT   บAutor  ณAnderson Messias    บ Data ณ  24/04/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Atualiza os dados da Fatura dos Conhecimento na tabela PAV บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ TAIFF                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function AtuFAT(_lAuto,_aDados)
//Local _bLog := .F.
//Local _bPri := .T.
//Local _bVai := .F.
Local _N
Local aSavATU := GetArea()
Local aSavSM0 := SM0->(GetArea())
LOCAL _nI	:= 0

Private lMsErroAuto := .F.

//Ordenando por CNPJ da Emissora para poder posicionar o sigamat quando for rotina automatica
aSort(aFaturas,,,{|x,y| x[10] < y[10] })
_lFirst := .F.
_lExec  := .F.
if _lAuto
	_lFirst := .T.
endif

if len(aFaturas) > 0
	_cCnpj := aFaturas[1][10]
	For _N := 1 to len(aFaturas)
		if _lAuto //Se For Executado via Schedule, posiciono o Sigamat e Seto o environment para processar os registros
			if _cCnpj <> aFaturas[_N][10] .OR. _lFirst
				DBSelectArea("SM0")
				DBGoTop()
				While !SM0->(Eof()) 
					IF SM0->M0_CODIGO >= "01" .AND. SM0->M0_CODIGO <= "04"
						if alltrim(aFaturas[_N][10]) == alltrim(SM0->M0_CGC)
							//Se Achar o CNPJ no Sigamat aponto o RPC
							cEmpAnt := SM0->M0_CODIGO
							cFilAnt := SM0->M0_CODFIL
							RPCClearEnv()
							RpcSetType(3)
							RPCSetEnv(cEmpAnt,cFilAnt)
							Exit
						endif
					ENDIF
					SM0->(DBSkip())
				EndDo
				_lFirst := .F.
			endif
		endif
		
		if !_lAuto
			Do Case
				Case SubStr(cAtivo,1,1) == "1"
					_cTexto := "Conhecimento Nr.: "+ aFaturas[_N,2]+"/"+aFaturas[_N,3] +"  Restantes " + alltrim(Str(len(aFaturas)-_N))
					If Left(aFaturas[_N,21],5) <> Left(SM0->M0_CGC,5)
						aFaturas[_N][Len(aFaturas[_N])-4] := "CNPJ do Arquivo nใo confere com CNPJ da Empresa"
						aFaturas[_N][Len(aFaturas[_N])-3] := .F.
						aFaturas[_N][Len(aFaturas[_N])-2] := "Empresa do arquivo nใo consta no SIGAMAT do sistema"
						aFaturas[_N][Len(aFaturas[_N])-1] := aFaturas[_N,21]+" - Empresa do arquivo nใo consta no SIGAMAT do sistema - Conhecimento nใo importado"
						Loop
					Endif
			Endcase
			//MsProcTxt(_cTexto)
		endif
		
		aCab := {}
		aItens := {}
		DBSelectArea("SA4")
		DBSetOrder(3)
		if DBSeek(xFilial("SA4")+alltrim(aFaturas[_N][8]))
			//Executando Rotina Automatica.
			aCab := {}
			aadd(aCab,{"PAV_CODTRA",SA4->A4_COD,Nil})
			aadd(aCab,{"PAV_TIPO","V",Nil})
			aadd(aCab,{"PAV_FATURA",aFaturas[_N][4],Nil})
			aadd(aCab,{"PAV_EMISFA",aFaturas[_N][5],Nil})
			aadd(aCab,{"PAV_VENCFA",aFaturas[_N][6],Nil})
			
			aItens := {}
			nPosCon := 7
			For _nI := 1 to Len(aFaturas[_N][nPosCon])
				//posiciono no conhecimento ja importado ou pre-lancado para importar ele para a fatura
				//Caso nao exista o conhecimento lancado a fatura nใo serแ importada.
				DBSelectArea("PAV")
				DBSetOrder(4)
				_cChave := xFilial("PAV")+SA4->A4_COD+StrZero(Val(aFaturas[_N][nPosCon][_nI][3]),9)
				if DBSeek(_cChave)
					While !PAV->(Eof()) .AND. _cChave == PAV->(PAV_FILIAL+PAV_CODTRA+PAV_CTO)
						/*
						|---------------------------------------------------------------------------------
						|	SOMENTE IRA REALIZAR ALTERAวีES EM CONHECIMENTOS QUE NAO TENHAM FATURA 
						|	INFORMADA
						|
						|	EDSON HORNBERGER - 24/09/2015
						|---------------------------------------------------------------------------------
						*/
						IF EMPTY(ALLTRIM(PAV->PAV_FATURA))
							aItem := {}
							aadd(aItem,{"PAV_NF"    ,PAV->PAV_NF,Nil})
							aadd(aItem,{"PAV_CTO"   ,PAV->PAV_CTO,Nil})
							If _lSerCto
								aadd(aItem,{"PAV_SERCTO",PAV->PAV_SERCTO,Nil})
							EndIf
							aadd(aItem,{"PAV_PESOCU",PAV->PAV_PESOCU,Nil})
							aadd(aItem,{"PAV_FRETRA",PAV->PAV_FRETRA,Nil})
							//Campos que gravarao os valores do arquivo importado
							aadd(aItem,{"PAV_IVLGRI",PAV->PAV_IVLGRI,Nil})
							aadd(aItem,{"PAV_IADVAL",PAV->PAV_IADVAL,Nil})
							aadd(aItem,{"PAV_IVLPES",PAV->PAV_IVLPES,Nil})
							aadd(aItem,{"PAV_ITXACT",PAV->PAV_ITXACT,Nil})
							aadd(aItem,{"PAV_IVLRPE",PAV->PAV_IVLRPE,Nil})
							//aadd(aItem,{"PAV_IOTRTX",PAV->,Nil})
							aadd(aItem,{"PAV_IMPORT",PAV->PAV_IMPORT,Nil})
							aadd(aItem,{"PAV_EMICTO",PAV->PAV_EMICTO,Nil})
							aadd(aItens,aItem)
						ENDIF 
						PAV->(DBSkip())
					EndDo
				endif
			Next _nI

			if Len(aItens)>0
				lMsErroAuto := .F.
				MSExecAuto({|x,y,z| u_CONFRETE(x,y,z)},aCab,aItens,3)
				If lMsErroAuto
					cPath := GetSrvProfString("Startpath","")
					cArquivo := CriaTrab(,.F.)
					cArquivo := alltrim(cArquivo)+".Log"
					MostraErro(cPath,cArquivo)
					cMsg := MemoRead(cPath+"\"+cArquivo)
					Aviso("OK",cMsg,{"OK"},3)
					aFaturas[_N][Len(aFaturas[_N])-1] := cMsg
				else
					aFaturas[_N][Len(aFaturas[_N])-3] := .T.
					aFaturas[_N][Len(aFaturas[_N])-1] := "Fatura importada com sucesso"
				EndIf
			else
				//aFaturas[_N][Len(aFaturas[_N])-4] := "CNPJ do Arquivo nใo confere com CNPJ da Empresa"
				aFaturas[_N][Len(aFaturas[_N])-3] := .F.
				aFaturas[_N][Len(aFaturas[_N])-2] := "Transportadora nใo cadastrada no sistema"
				aFaturas[_N][Len(aFaturas[_N])-1] := alltrim(aFaturas[_N][8])+" - Transportadora nao cadastrada no sistema - Conhecimento nใo importado"
			endif
		endif
		
		//aFaturas[_N][Len(aFaturas[_N])-2] := SM0->M0_CGC+" - "+SM0->M0_NOME
		
		_cCnpj := aFaturas[_N][10]
	Next _N
endif

if _lAuto
	_aDados := aClone(aFaturas)
endif

RestArea(aSavSM0)
RestArea(aSavATU)

Return .T.

/*
ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ RelatorioบAutor  ณ Anderson Messias   บ Data ณ  11/03/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Atualiza os dados do SF2                                   บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ TAIFF                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function Relatorio()

Local oSection1
Local oReport //,oSection1
Local cTitulo

Private _cCTO
Private _cSerie
Private _cNF
Private _nPesoCub
Private _nValorTra
Private _nValorCalc
Private _cDtemissao
Private _cOcorrencia

Do Case
	Case Substr(cAtivo,1,1) == "1"
		cTitulo := "Demonstrativo de Conhecimentos"
		oReport := TReport():New("DFATNF1",cTitulo,/*cPerg*/,{|oReport| ReportPrint(oReport)},cTitulo)
		
		oSection1 := TRSection():New(oReport,'Registros',{},{})
		
		TRCell():New(oSection1,"CONHEC" ,"",'Conhecimento',/*Picture*/,09,/*lPixel*/, {|| _cCTO })
		TRCell():New(oSection1,"EMISSAO","",'Emissao'     ,/*Picture*/,10,/*lPixel*/, {|| _cDtemissao })
		TRCell():New(oSection1,"PESO"   ,"",'Peso'        ,"@E 999,999.999",07,/*lPixel*/, {|| _nPesoCub })
		TRCell():New(oSection1,"VALOR"  ,"",'Valor Frete' ,"@E 999,999,999.99",15,/*lPixel*/, {|| _nValorTra })
		TRCell():New(oSection1,"DESOCO" ,"",'Obs.'        ,/*Picture*/,120,/*lPixel*/, {|| _cOcorrencia })
	Case Substr(cAtivo,1,1) == "2"
		cTitulo := "Demonstrativo Registros de Entregas"
		oReport := TReport():New("DFATNF2",cTitulo,/*cPerg*/,{|oReport| ReportPrint(oReport)},cTitulo)
		
		oSection1 := TRSection():New(oReport,'Registros',{},{})
		
		TRCell():New(oSection1,"NF"    ,"",'Nota Fiscal',/*Picture*/,09,/*lPixel*/, {|| aNotas[nI][3] })
		TRCell():New(oSection1,"SERIE" ,"",'Serie'      ,/*Picture*/,03,/*lPixel*/, {|| aNotas[nI][2] })
		TRCell():New(oSection1,"DATOCO","",'Data Ocor.' ,/*Picture*/,10,/*lPixel*/, {|| aNotas[nI][5] })
		TRCell():New(oSection1,"CODOCO","",'Cod. Ocor.' ,/*Picture*/,02,/*lPixel*/, {|| aNotas[nI][4] })
		TRCell():New(oSection1,"DESOCO","",'Desc. Ocor.',/*Picture*/,55,/*lPixel*/, {|| aNotas[nI][8] })
		TRCell():New(oSection1,"STATUS","",'Status'     ,/*Picture*/,100,/*lPixel*/, {|| aNotas[nI][7] })
	Case Substr(cAtivo,1,1) == "3"
		cTitulo := "Demonstrativo de Faturas Importadas"
		oReport := TReport():New("DFATNF3",cTitulo,/*cPerg*/,{|oReport| ReportPrint(oReport)},cTitulo)
		oReport:SetTotalInLine(.F.)
		
		oSection1 := TRSection():New(oReport,'Conhecimentos',{},{})
		oSection1:SetTotalInLine(.F.)
		
		TRCell():New(oSection1,"CTO"   ,"",'Conhecimento',/*Picture*/,09,/*lPixel*/, {|| _cCTO })
		TRCell():New(oSection1,"Serie"   ,"",'Nota Fiscal',/*Picture*/,03,/*lPixel*/, {|| _cSerie })
		TRCell():New(oSection1,"NF"   ,"",'Nota Fiscal',/*Picture*/,09,/*lPixel*/, {|| _cNF })
		TRCell():New(oSection1,"PESOCUB"   ,"",'Peso Cubagem',/*Picture*/,10,/*lPixel*/, {|| _nPesoCub })
		TRCell():New(oSection1,"VALORTRA"   ,"",'Valor Transp.',/*Picture*/,15,/*lPixel*/, {|| _nValorTra })
		TRCell():New(oSection1,"VALORCAL"   ,"",'Valor Calc.',/*Picture*/,16,/*lPixel*/, {|| _nValorCalc })
		TRCell():New(oSection1,"OBS"   ,"",'Obs da Importacao',/*Picture*/,120,/*lPixel*/, {|| _cObs })
		
		TRFunction():New(oSection1:Cell("PESOCUB"),NIL,"SUM",/*oBreak*/,,,,.T.,.T.)
		TRFunction():New(oSection1:Cell("VALORTRA"),NIL,"SUM",/*oBreak*/,,,,.T.,.T.)
		TRFunction():New(oSection1:Cell("VALORCAL"),NIL,"SUM",/*oBreak*/,,,,.T.,.T.)
		
Endcase


ReportDef()
oReport:PrintDialog()

Return

/*
ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณPrograma  ณReportPrintณ Autor ณ Anderson Messias      ณ Data ณ 11.03.11 ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescriÿÿo ณA funcao estatica ReportDef devera ser criada para todos os  ณฑฑ
ฑฑณ          ณrelatorios que poderao ser agendados pelo usuario.           ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณRetorno   ณNenhum                                                       ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณParametrosณExpO1: Objeto Report do Relat๓rio                            ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณ   DATA   ณ Programador   ณManutencao efetuada                          ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณ          ณ               ณ                                             ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function ReportPrint(oReport)

Local oSection1	:= oReport:Section(1)
Local cTitulo := "Demonstrativo Registros de Entregas"
LOCAL nI	:= 0
LOCAL nX	:= 0

Do Case
	Case Substr(cAtivo,1,1) == "1"
		cTitulo := "Demonstrativo de Conhecimentos"
	Case Substr(cAtivo,1,1) == "2"
		cTitulo := "Demonstrativo Registros de Entregas"
	Case Substr(cAtivo,1,1) == "3"
		cTitulo := "Demonstrativo Faturas"
Endcase
oReport:SetTitle(cTitulo)

oReport:SkipLine()
oReport:PrintText(" Arquivo Importado...: "+cArqEnt)
oReport:PrintText("Arquivo Lido Gerado.: "+cArqEDI)

Do Case
	Case Substr(cAtivo,1,1) == "1"
		DBSelectArea("SA4")
		DBSetOrder(3)
		if DBSeek(xFilial("SA4")+alltrim(aConhec[1][20]))
			oReport:PrintText("Transportadora..: "+SA4->A4_COD+" - "+SA4->A4_NOME)
		endif
Endcase

oReport:SkipLine()

Do Case
	Case Substr(cAtivo,1,1) == "1"
		oSection1:Cell("DESOCO"):lLineBreak := .T.
		oSection1:Init()
		For nI := 1 to Len(aConhec)

			_cCTO := StrZero(Val(aConhec[nI][3]),9)
			_cDtemissao := DTOC(aConhec[nI][4])
			_nPesoCub := aConhec[nI][6] 
			_nValorTra:= aConhec[nI][7] 
			_cOcorrencia := aConhec[nI][Len(aConhec[nI])-1]

			oSection1:PrintLine()
		Next nI
		oSection1:Finish()
	Case Substr(cAtivo,1,1) == "2"
		oSection1:Init()
		For nI := 1 to Len(aNotas)
			oSection1:PrintLine()
		Next nI
		oSection1:Finish()
	Case Substr(cAtivo,1,1) == "3"
		For nI := 1 to Len(aFaturas)
			nPosEmp := Ascan(_aEmpresas,{|x| alltrim(x[1]) == aFaturas[nI][10]})
			_cNomeEmp := "Empresa nใo cadastrada no sigamat do protheus"
			if nPosEmp > 0
				_cNomeEmp := _aEmpresas[nPosEmp][2]
			endif
			
			oReport:SkipLine()
			oReport:PrintText("Transportadora.: "+aFaturas[nI][8]+" - "+aFaturas[nI][9])
			oReport:PrintText("Empresa........: "+aFaturas[nI][10]+" - "+_cNomeEmp)
			oReport:PrintText("Fatura.........: "+aFaturas[nI][4])
			oReport:PrintText("Emissao........: "+DTOC(aFaturas[nI][5]))
			oReport:PrintText("Vencimento.....: "+DTOC(aFaturas[nI][6]))
			oReport:SkipLine()
			oSection1:Init()
			For nX := 1 to Len(aFaturas[nI][7])
				_cCTO := StrZero(Val(aFaturas[nI][7][nX][3]),9)
				_nCodTra := GetAdvFval("SA4","A4_COD",xFilial("SA4")+aFaturas[nI][8],3)
				DBSelectArea("PAV")
				DBSetOrder(4)
				_cChave := xFilial("PAV")+_nCodTra+_cCTO
				if PAV->(DBSeek(_cChave))
					While !PAV->(Eof()) .AND. _cChave == PAV->PAV_FILIAL+PAV->PAV_CODTRA+PAV->PAV_CTO
						_cSerie     := PAV->PAV_SERIE
						_cNF        := PAV->PAV_NF
						_nPesoCub   := PAV->PAV_PESOCU
						_nValorTra  := PAV->PAV_FRETRA
						_nValorCalc := PAV->PAV_FRCALC
						_cObs 		:= "Conhecimento OK"
						oSection1:PrintLine()
						PAV->(DBSkip())
					EndDo
				else
					_cSerie     := ""
					_cNF        := ""
					_nPesoCub   := ""
					_nValorTra  := ""
					_nValorCalc := ""
					_cObs 		:= "Conhecimento nใo localizado"
					oSection1:PrintLine()
				endif
			Next nX
			oSection1:Finish()
			oReport:SkipLine()
		Next nI
EndCase


Return

/*
ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ DFATNF99 บAutor  ณ Anderson Messias   บ Data ณ  23/03/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Atualiza a data de embarque na tabela SF2 pela tabela CB7  บฑฑ
ฑฑบ          ณ Carga inicial                                              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ TAIFF                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿

User Function DFATNF99()

cQuery := "SELECT "
cQuery += "  CB7_FILIAL, "
cQuery += "  CB7_NOTA, "
cQuery += "  CB7_SERIE, "
cQuery += "  CB7_DTEMBA, "
cQuery += "  F2_DOC, "
cQuery += "  F2_SERIE, "
cQuery += "  F2_FILIAL, "
cQuery += "  F2_DTEMB, "
cQuery += "  SF2.R_E_C_N_O_ AS SF2RECNO "
cQuery += "FROM  "
cQuery += "  "+RetSQLName("CB7")+" CB7 "
cQuery += "  LEFT JOIN "+RetSQLName("SF2")+" SF2 ON F2_FILIAL=CB7_FILIAL AND F2_DOC=CB7_NOTA AND F2_SERIE=CB7_SERIE AND SF2.D_E_L_E_T_='' "
cQuery += "WHERE  "
cQuery += "  CB7.D_E_L_E_T_='' AND "
cQuery += "  CB7_DTEMBA<>'' AND "
cQuery += "  F2_DOC IS NOT NULL "

If Select("TSQL") > 0
dbSelectArea("TSQL")
dbCloseArea()
EndIf

//* Cria a Query e da Um Apelido
TCQUERY cQuery NEW ALIAS "TSQL"

dbSelectArea("TSQL")
DbGotop()

While !TSQL->(Eof())

DBSelectArea("SF2")
DBGoTo(TSQL->SF2RECNO)
RecLock("SF2",.F.)
SF2->F2_DTEMB := STOD(TSQL->CB7_DTEMBA)
MsUnlock()

DBSelectArea("TSQL")
TSQL->(DBSkip())
EndDo

Return
*/

/*
ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ DFATNF01 บAutor  ณ Anderson Messias   บ Data ณ  23/03/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Rotina para informar manualmente a data de embarque da notaบฑฑ
ฑฑบ          ณ Rotina desenvolvida para atender necessidade PRO-ART       บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ TAIFF                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function DFATNF01()

Local dDataRet
Local cSerieNF
Local cNumeroNF
Local aSavATU := GetArea()
Local aSavSF2 := SF2->(GetArea())

dDataRet  := STOD("")
While .T. // Fa็o um While para nao ter que ficar clicando toda ves no botใo, a rotina fica em loop at้ cancelar ela
	
	cSerieNF  := Space(TamSx3("F2_SERIE")[1])
	cNumeroNF := Space(TamSx3("F2_DOC")[1])
	
	nOpc := 0
	@ 0,0 TO 130,270 DIALOG oDlgData TITLE "Data de Coleta"
	
	@ 10,10 SAY "Serie N.F."	Size 90
	@ 10,50 MSGET oSerieNF VAR cSerieNF SIZE 020,07 OF oDlgData PIXEL
	
	@ 20,10 SAY "Numero N.F."	Size 90
	@ 20,50 MSGET oNumeroNF VAR cNumeroNF F3 "SF2" SIZE 050,07 OF oDlgData PIXEL
	
	@ 30,10 SAY "Data de Coleta"	Size 90
	@ 30,50 MSGET oDataRet VAR dDataRet SIZE 050,07 OF oDlgData PIXEL Valid !Empty(dDataRet)
	
	@ 45,10 BMPBUTTON TYPE 1 ACTION iif(!Empty(dDataRet) .AND. ExistCPO("SF2",cNumeroNF+cSerieNF),(nOpc := 1,Close(oDlgData)),Alert("Informe uma nota fiscal e sua data de embarque vแlida!"))
	@ 45,40 BMPBUTTON TYPE 2 ACTION (nOpc := 2,Close(oDlgData))
	
	ACTIVATE MSDIALOG oDlgData CENTERED
	
	if nOpc == 1
		DBSelectArea("SF2")
		DBSetOrder(1)
		if DBSeek(xFilial("SF2")+cNumeroNF+cSerieNF)
			RecLock("SF2",.F.)
			SF2->F2_DTEMB  := dDataRet
			MsUnlock()
		endif
	endif
	
	if nOpc == 2
		Exit
	endif
	
enddo

RestArea(aSavSF2)
RestArea(aSavATU)

Return

/*
ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ DFATNF02 บAutor  ณ Anderson Messias   บ Data ณ  23/03/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Rotina para informar manualmente a data de entrega da nota บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ TAIFF                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function DFATNF02()

Local dDataEnt
Local cSerieNF
Local cNumeroNF
Local aSavATU := GetArea()
Local aSavSF2 := SF2->(GetArea())

dDataEnt  := STOD("")
While .T. // Fa็o um While para nao ter que ficar clicando toda ves no botใo, a rotina fica em loop at้ cancelar ela
	
	cSerieNF  := Space(TamSx3("F2_SERIE")[1])
	cNumeroNF := Space(TamSx3("F2_DOC")[1])
	
	nOpc := 0
	@ 0,0 TO 130,270 DIALOG oDlgData TITLE "Data de Entrega"
	
	@ 10,10 SAY "Serie N.F."	Size 90
	@ 10,50 MSGET oSerieNF VAR cSerieNF SIZE 020,07 OF oDlgData PIXEL
	
	@ 20,10 SAY "Numero N.F."	Size 90
	@ 20,50 MSGET oNumeroNF VAR cNumeroNF F3 "SF2" SIZE 050,07 OF oDlgData PIXEL
	
	@ 30,10 SAY "Data de Entrega"	Size 90
	@ 30,50 MSGET oDataEnt VAR dDataEnt SIZE 050,07 OF oDlgData PIXEL Valid !Empty(dDataEnt)
	
	@ 45,10 BMPBUTTON TYPE 1 ACTION iif(!Empty(dDataEnt) .AND. ExistCPO("SF2",cNumeroNF+cSerieNF),(nOpc := 1,Close(oDlgData)),Alert("Informe uma nota fiscal e sua data de embarque vแlida!"))
	@ 45,40 BMPBUTTON TYPE 2 ACTION (nOpc := 2,Close(oDlgData))
	
	ACTIVATE MSDIALOG oDlgData CENTERED
	
	if nOpc == 1
		DBSelectArea("SF2")
		DBSetOrder(1)
		if DBSeek(xFilial("SF2")+cNumeroNF+cSerieNF)
			RecLock("SF2",.F.)
			SF2->F2_DTRECEB  := dDataEnt
			SF2->F2_OCOENT   := "**"
			SF2->F2_OCODES   := "PREENCHIMENTO MANUAL PELO USUARIO : "+Alltrim(Substr(cUsuario,7,15))
			SF2->F2_OCODAT   := dDataBase
			SF2->F2_OCOARQ   := "*** MANUAL ***"
			MsUnlock()
		endif
	endif
	
	if nOpc == 2
		Exit
	endif
	
enddo

RestArea(aSavSF2)
RestArea(aSavATU)

Return

/*
ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ TAEDIS01 บAutor  ณ Anderson Messias   บ Data ณ  15/02/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Rotina Schedulada que le um diretorio no servidor e proces-บฑฑ
ฑฑบDesc.     ณ sa os arquivos EDI Proceda                                 บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ TAIFF                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function TAEDIS01()

Local aWFSend1 := {}
Local aWFSend2 := {}
Local aWFSend3 := {}
Local lPAVeof	:= .F.
LOCAL _nI	:= 0
LOCAL _nElem:= 0
LOCAL _nX	:= 0

Private _lEDIAutoMail := .T.
Private _aEmpresas := {}
Private _aDir := {}
Private _lAuto := .F.

//VERIFICA SE ESTA RODANDO VIA MENU OU SCHEDULE
If Select("SX6") == 0
	_lAuto := .T.
EndIf

//RpcSetType(3)
RPCSetEnv("01","01") //Posiciono na primeira empresa somente para iniciar o processo, internamente o sistema posiciona a empresa e filial no processamento
// Leitura de Todos os Arquivos da Pasta
_cNomeArq := "LOGEDIPROC.TXT"
_cDir := "EDI\"
ADir(_cDir+"*.TXT",_aDir)
_cDirLog  := "LOG\"
_cDirProc := "PROCESSADOS\"
_aStru	:= {}
AADD(_aStru,{"CONTEUDO","C",121,0})

//MakeDir(_cDir+_cDirLog)
//MakeDir(_cDir+_cDirProc)

// Arquivo de log do Processamento
If File(_cDir+_cDirProc+_cNomeArq)
	_nArqProc := FOpen(_cDir+_cDirProc+_cNomeArq,2)
	Fseek(_nArqProc,0,2) // Move o Ponteiro para o Final do Arquivo
	Fwrite(_nArqProc,CRLF)
Else
	_nArqProc := FCreate(_cDir+_cDirProc+_cNomeArq,1)
Endif

For _nElem := 1 To Len(_aDir)
	_cArq  	 := _aDir[_nElem]
	_cArqAtu := _cDir+_cArq
	
	// Cria็ใo do Arquivo de LOG apenas do Arquivo Lido
	// Verifica a Existencia do Arquivo de Log de todos os arquivos Processados e efetua a Cria็ใo caso nใo exista
	_cNomeArq := "LOG"+_cArq
	// Log Individual do arquivo processado
	If File(_cDir+_cDirLog+_cNomeArq)
		_nArqLog := FOpen(_cDir+_cDirLog+_cNomeArq,2)
		Fseek(_nArqLog,0,2) // Move o Ponteiro para o Final do Arquivo
		Fwrite(_nArqLog,CRLF)
	Else
		_nArqLog := FCreate(_cDir+_cDirLog+_cNomeArq,1)
	Endif
	
	_lArqOk := .T.
	_nLinha := 0
	// Iniciando leitura do arquivo
	Fwrite(_nArqLog,"Iniciando Processamento em "+Dtoc(dDataBase)+" as " + Time()+CRLF)
	
	//******************** Iniciando leitura do arquivo ***************************
	_aDados := {}
	_cAtivo := ""
	u_DFATNF(_lAuto,_cArqAtu,@_aDados,@_cAtivo)
	_nLinha := Len(_aDados)
	_cLinha := ""
	For _nI := 1 to Len(_aDados)
		Do Case
			Case Substr(_cAtivo,1,1) == "1" //Conhecimentos de Transporte
				_cLinha := "Linha: "+StrZero(_aDados[_nI][Len(_aDados[_nI])]+2,6)+" Conhecimento: "+StrZero(Val(_aDados[_nI][3]),9)+" Data : "+DTOC(Date())+" - "+Time()+ " OBS. do Processamento: "+_aDados[_nI][Len(_aDados[_nI])-4]
				if _aDados[_nI][Len(_aDados[_nI])-3]
					_cLinha := "OK ===> "+_cLinha
				else
					_cLinha := "ERRO==> "+_cLinha
				endif
				if !_aDados[_nI][Len(_aDados[_nI])-3]
					_lArqOk := .F.
				endif
				aadd(aWFSend1,_aDados[_nI])
			Case Substr(_cAtivo,1,1) == "2" //Entregas
				_cLinha := "Linha: "+StrZero(_aDados[_nI][10]+2,6)+" Serie: "+_aDados[_nI][2]+" Doc: "+_aDados[_nI][3]+" Data : "+DTOC(Date())+" - "+Time()+ " OBS. do Processamento: "+_aDados[_nI][7]
				if _aDados[_nI][9]
					_cLinha := "OK ===> "+_cLinha
				else
					_cLinha := "ERRO==> "+_cLinha
				endif
				if !_aDados[_nI][9]
					_lArqOk := .F.
				endif
				aadd(aWFSend2,_aDados[_nI])
			Case Substr(_cAtivo,1,1) == "3" //Faturas de Transporte
				_cLinha := "Fatura: " //+StrZero(_aDados[_nI][Len(_aDados[_nI])]+2,6)+" Conhecimento: "+StrZero(Val(_aDados[_nI][3]),9)+" Data : "+DTOC(Date())+" - "+Time()+ " OBS. do Processamento: "+_aDados[_nI][Len(_aDados[_nI])-4]
				/* Gravando Log do arquivo importado
				if _aDados[_nI][Len(_aDados[_nI])-3]
				_cLinha := "OK ===> "+_cLinha
				else
				_cLinha := "ERRO==> "+_cLinha
				endif
				if !_aDados[_nI][Len(_aDados[_nI])-3]
				_lArqOk := .F.
				endif
				*/
				aadd(aWFSend3,_aDados[_nI])
		Endcase
		Fwrite(_nArqLog,_cLinha+CRLF)
	Next _nI
	//******************** Finalizando leitura do arquivo **************************
	
	// Fecha o Log do Arquivo processado
	Fwrite(_nArqLog,"Final de Processamento em "+Dtoc(dDataBase)+" as " + Time()+CRLF)
	Fclose(_nArqLog)
	
	// Copia o Arquivo para a Pasta de Processados
	_cArqDest := _cDir+_cDirProc+_cArq
	Copy File &_cArqAtu to &_cArqDest
	
	// Apaga arquivo da pasta de leitura
	If File(_cArqDest)
		Ferase(_cArqAtu)
	Endif
	
	//Gravando Log no arquivo geral de processamento
	_cOk := IIF(_lArqOk," OK->"," E R R O->")
	Fwrite(_nArqProc,_cOk+" Arquivo "+_cArq+" Processado em " +Dtoc(dDataBase)+" as " + Time()+" Total de Registros ->"+StrZero(_nLinha,5)+CRLF)
Next _nElem

Fclose(_nArqProc)

//******************** Preparando envio do workflow para os responsaveis **************************
RPCClearEnv()
RpcSetType(3)
RPCSetEnv("01","01") //Posiciono na empresa 01 e filial 01 pois ้ onde estแ configurado o workflow de envio do email

//Enviando Conhecimento importados
if Len(aWFSend1) > 0
	aSort(aWFSend1,,,{|x,y| x[20]+x[3] < y[20]+y[3] })
	
	oProcess := TWFProcess():New( "WFEDIPRO", "Workflow EDI Proceda - Conhecimentos" )
	oProcess:NewTask( "WFEDIPROC", "\WORKFLOW\WFEDIPROC2.HTM" )
	oHTML := oProcess:oHTML
	oHtml:ValByName("TITULO","Workflow EDI Proceda - Conhecimentos")
	
	_cArq := aWFSend1[1][20]
	lImpr := .T.
	lFirst:= .T.
	
	_cFileOld := ""     // Tratamento de quebra por arquivo
	
	For _nI := 1 to len(aWFSend1)
		
		if _cArq <> aWFSend1[_nI][20]
			lImpr := .T.
		endif
		
		if lImpr .AND. !lFirst
			_cLinha += '</table>'
			_cLinha += '&nbsp;'
			aadd((oHtml:ValByName( "it.LINHA")),_cLinha)
		endif
		
		// Tratamento de quebra por arquivo
		If _cFileOld <> aWFSend1[_nI][Len(aWFSend1[_nI])-5]
			
			lImpr := .T.
			
		EndIf
		
		if lImpr
			_cLinha := ''
			_cLinha += '<table width="100%">'
			_cLinha += '	<tr>'
			_cLinha += '		<td><b>Empresa</b> : '+aWFSend1[_nI][Len(aWFSend1[_nI])-2]+'</td>'
			_cLinha += '	</tr>'
			_cLinha += '	<tr>'
			_cLinha += '		<td><b>Transportadora</b> : '+aWFSend1[_nI][Len(aWFSend1[_nI])-4]+'</td>'
			_cLinha += '	</tr>'
			_cLinha += '	<tr>'
			_cLinha += '		<td><b>Processado</b> : '+DTOC(Date())+' - '+Time()+' - Arquivo : '+aWFSend1[_nI][Len(aWFSend1[_nI])-5]+'</td>'
			_cLinha += '	</tr>'
			_cLinha += '</table>'
			_cLinha += '<table width="100%">'
			_cLinha += '	<tr>'
			_cLinha += '		<td class="grid_titulo">Status</td>'
			_cLinha += '		<td class="grid_titulo">CNPJ Emissor</td>'
			_cLinha += '		<td class="grid_titulo">Linha</td>'
			_cLinha += '		<td class="grid_titulo">Conhecimento</td>'
			_cLinha += '		<td class="grid_titulo">Observacao Importacao</td>'
			_cLinha += '	</tr>'
			lImpr := .F.
			lFirst:= .F.
		endif
		
		_cLinha += '	<tr>'
		_cLinha += '		<td class="grid_par">'+iif(aWFSend1[_nI][Len(aWFSend1[_nI])-3],"OK","ERRO")+'</td>'
		_cLinha += '		<td class="grid_par">'+aWFSend1[_nI][20]+'</td>'
		_cLinha += '		<td class="grid_par">'+StrZero(aWFSend1[_nI][Len(aWFSend1[_nI])]+2,6)+'</td>'
		_cLinha += '		<td class="grid_par">'+aWFSend1[_nI][3]+'</td>'
		_cLinha += '		<td class="grid_par">'+aWFSend1[_nI][Len(aWFSend1[_nI])-1]+'</td>'
		_cLinha += '	</tr>'
		
		_cArq := aWFSend1[_nI][20]
		
		_cFileOld := aWFSend1[_nI][Len(aWFSend1[_nI])-5] // Tratamento de quebra por arquivo
		
	Next _nI
	
	_cLinha += '</table>'
	_cLinha += '&nbsp;'
	aadd((oHtml:ValByName( "it.LINHA")),_cLinha)
	
	oProcess:ClientName( Subs(cUsuario,7,15) )
	eMail := SuperGetMv("MV_XMAILED",,"grp_sistemas@taiff.com.br") //"amessias@deltadecisao.com.br" //
	oProcess:cSubject 	:= "Workflow EDI Proceda - Conhecimentos"
	oProcess:cTo 		:= eMail
	oProcess:UserSiga	:= __CUSERID
	oProcess:Start()
	oProcess:Free()
Endif

//Enviando Entregas importadas
if Len(aWFSend2) > 0
	aSort(aWFSend2,,,{|x,y| x[11]+x[1] < y[11]+y[1] })
	
	oProcess := TWFProcess():New( "WFEDIPRO", "Workflow EDI Proceda - Entregas" )
	oProcess:NewTask( "WFEDIPROC", "\WORKFLOW\WFEDIPROC2.HTM" )
	oHTML := oProcess:oHTML
	oHtml:ValByName("TITULO","Workflow EDI Proceda - Entregas")
	
	_cArq := aWFSend2[1][11]
	lImpr := .T.
	lFirst:= .T.
	For _nI := 1 to len(aWFSend2)
		
		if _cArq <> aWFSend2[_nI][11]
			lImpr := .T.
		endif
		
		if lImpr .AND. !lFirst
			_cLinha += '</table>'
			_cLinha += '&nbsp;'
			aadd((oHtml:ValByName( "it.LINHA")),_cLinha)
		endif
		
		if lImpr
			_cLinha := ''
			_cLinha += '<table width="100%">'
			_cLinha += '	<tr>'
			_cLinha += '		<td><b>Empresa</b> : '+aWFSend2[_nI][13]+'</td>'
			_cLinha += '	</tr>'
			_cLinha += '	<tr>'
			_cLinha += '		<td><b>Transportadora</b> : '+aWFSend2[_nI][12]+'</td>'
			_cLinha += '	</tr>'
			_cLinha += '	<tr>'
			_cLinha += '		<td><b>Processado</b> : '+DTOC(Date())+' - '+Time()+' - Arquivo : '+aWFSend2[_nI][11]+'</td>'
			_cLinha += '	</tr>'
			_cLinha += '</table>'
			_cLinha += '<table width="100%">'
			_cLinha += '	<tr>'
			_cLinha += '		<td class="grid_titulo">Status</td>'
			_cLinha += '		<td class="grid_titulo">CNPJ Emissor</td>'
			_cLinha += '		<td class="grid_titulo">Linha</td>'
			_cLinha += '		<td class="grid_titulo">Serie</td>'
			_cLinha += '		<td class="grid_titulo">Documento</td>'
			_cLinha += '		<td class="grid_titulo">Observacao Importacao</td>'
			_cLinha += '	</tr>'
			lImpr := .F.
			lFirst:= .F.
		endif
		
		_cLinha += '	<tr>'
		_cLinha += '		<td class="grid_par">'+iif(aWFSend2[_nI][9],"OK","ERRO")+'</td>'
		_cLinha += '		<td class="grid_par">'+aWFSend2[_nI][1]+'</td>'
		_cLinha += '		<td class="grid_par">'+StrZero(aWFSend2[_nI][10]+2,6)+'</td>'
		_cLinha += '		<td class="grid_par">'+aWFSend2[_nI][2]+'</td>'
		_cLinha += '		<td class="grid_par">'+aWFSend2[_nI][3]+'</td>'
		_cLinha += '		<td class="grid_par">'+aWFSend2[_nI][7]+'</td>'
		_cLinha += '	</tr>'
		
		_cArq := aWFSend2[_nI][11]
	Next _nI
	
	_cLinha += '</table>'
	_cLinha += '&nbsp;'
	aadd((oHtml:ValByName( "it.LINHA")),_cLinha)
	
	oProcess:ClientName( Subs(cUsuario,7,15) )
	eMail := SuperGetMv("MV_XMAILED",,"grp_sistemas@taiff.com.br") // "amessias@deltadecisao.com.br"
	oProcess:cSubject 	:= "Workflow EDI Proceda - Entregas"
	oProcess:cTo 		:= eMail
	oProcess:UserSiga	:= __CUSERID
	oProcess:Start()
	oProcess:Free()
Endif

//Enviando Faturas importadas
if Len(aWFSend3) > 0
	aSort(aWFSend3,,,{|x,y| x[10]+x[1] < y[10]+y[1] })
	
	oProcess := TWFProcess():New( "WFEDIPRO", "Workflow EDI Proceda - Faturas" )
	oProcess:NewTask( "WFEDIPROC", "\WORKFLOW\WFEDIPROC2.HTM" )
	oHTML := oProcess:oHTML
	oHtml:ValByName("TITULO","Workflow EDI Proceda - Faturas")
	aSavATU := GetArea()
	aSavSM0 := SM0->(GetArea())
	
	_cArq := aWFSend3[1][10]
	lImpr := .T.
	lFirst:= .T.
	For _nI := 1 to len(aWFSend3)
		DBSelectArea("SM0")
		DBGoTop()
		While !SM0->(Eof()) //.AND. SM0->M0_CODIGO >= "01" .AND. SM0->M0_CODIGO <= "07"
			IF SM0->M0_CODIGO >= "01" .AND. SM0->M0_CODIGO <= "04"
				if alltrim(aWFSend3[1][10]) == alltrim(SM0->M0_CGC)
					//Se Achar o CNPJ no Sigamat aponto o RPC
					cEmpAnt := SM0->M0_CODIGO
					cFilAnt := SM0->M0_CODFIL
					RPCClearEnv()
					RpcSetType(3)
					RPCSetEnv(cEmpAnt,cFilAnt)
					Exit
				endif
			ENDIF
			SM0->(DBSkip())
		EndDo
		
		nPosEmp := Ascan(_aEmpresas,{|x| alltrim(x[1]) == aWFSend3[_nI][10]})
		_cNomeEmp := "Empresa nใo cadastrada no sigamat do protheus"
		if nPosEmp > 0
			_cNomeEmp := _aEmpresas[nPosEmp][2]
		endif
		
		_cLinha := ''
		_cLinha += '<table width="100%">'
		_cLinha += '	<tr>'
		_cLinha += '		<td><b>Empresa</b> : '+aWFSend3[_nI][10]+" - "+_cNomeEmp+'</td>'
		_cLinha += '	</tr>'
		_cLinha += '	<tr>'
		_cLinha += '		<td><b>Transportadora</b> : '+aWFSend3[_nI][8]+" - "+aWFSend3[_nI][9]+'</td>'
		_cLinha += '	</tr>'
		_cLinha += '	<tr>'
		_cLinha += '		<td><b>Fatura</b> : '+aWFSend3[_nI][4]+'</td>'
		_cLinha += '	</tr>'
		_cLinha += '	<tr>'
		_cLinha += '		<td><b>Emissao</b> : '+DTOC(aWFSend3[_nI][5])+'</td>'
		_cLinha += '	</tr>'
		_cLinha += '	<tr>'
		_cLinha += '		<td><b>Vencimento</b> : '+DTOC(aWFSend3[_nI][6])+'</td>'
		_cLinha += '	</tr>'
		_cLinha += '	<tr>'
		_cLinha += '		<td><b>Processado</b> : '+DTOC(Date())+' - '+Time()+' - Arquivo : '+aWFSend3[_nI][11]+'</td>'
		_cLinha += '	</tr>'
		_cLinha += '</table>'
		_cLinha += '<table width="100%">'
		_cLinha += '	<tr>'
		_cLinha += '		<td class="grid_titulo">Conhecimento</td>'
		_cLinha += '		<td class="grid_titulo">Serie</td>'
		_cLinha += '		<td class="grid_titulo">Documento</td>'
		_cLinha += '		<td class="grid_titulo">Peso Cubagem</td>'
		_cLinha += '		<td class="grid_titulo">Valor Transp.</td>'
		_cLinha += '		<td class="grid_titulo">Valor Calc.</td>'
		_cLinha += '		<td class="grid_titulo">Observacao Importacao</td>'
		_cLinha += '	</tr>'
		
		For _nX := 1 to len(aWFSend3[_nI][7])
			
			_cCTO := StrZero(Val(aWFSend3[_nI][7][_nX][3]),9)
			_nCodTra := GetAdvFval("SA4","A4_COD",xFilial("SA4")+aWFSend3[_nI][8],3)
			lPAVeof	:= .F.
			If nPosEmp > 0
				DBSelectArea("PAV")
				DBSetOrder(4)
				_cChave := xFilial("PAV")+_nCodTra+_cCTO
				lPAVeof := PAV->(DBSeek(_cChave))
			EndIf
			if lPAVeof
				While !PAV->(Eof()) .AND. _cChave == PAV->PAV_FILIAL+PAV->PAV_CODTRA+PAV->PAV_CTO
					_cSerie     := PAV->PAV_SERIE
					_cNF        := PAV->PAV_NF
					_nPesoCub   := PAV->PAV_PESOCU
					_nValorTra  := PAV->PAV_FRETRA
					_nValorCalc := PAV->PAV_FRCALC
					_cObs 		:= "Conhecimento OK"
					
					_cLinha += '	<tr>'
					_cLinha += '		<td class="grid_par">'+_cCTO+'</td>'
					_cLinha += '		<td class="grid_par">'+_cSerie+'</td>'
					_cLinha += '		<td class="grid_par">'+_cNF+'</td>'
					_cLinha += '		<td class="grid_par">'+Transform(_nPesoCub,"@E 999,999.9999")+'</td>'
					_cLinha += '		<td class="grid_par">'+Transform(_nValorTra,"@E 999,999.99")+'</td>'
					_cLinha += '		<td class="grid_par">'+Transform(_nValorCalc,"@E 999,999.99")+'</td>'
					_cLinha += '		<td class="grid_par">'+_cObs+'</td>'
					_cLinha += '	</tr>'
					
					PAV->(DBSkip())
				EndDo
			else
				_cSerie     := ""
				_cNF        := ""
				_nPesoCub   := ""
				_nValorTra  := ""
				_nValorCalc := ""
				_cObs 		:= "Conhecimento nใo localizado"
				
				_cLinha += '	<tr>'
				_cLinha += '		<td class="grid_par">'+_cCTO+'</td>'
				_cLinha += '		<td class="grid_par">'+_cSerie+'</td>'
				_cLinha += '		<td class="grid_par">'+_cNF+'</td>'
				_cLinha += '		<td class="grid_par">'+_nPesoCub+'</td>'
				_cLinha += '		<td class="grid_par">'+_nValorTra+'</td>'
				_cLinha += '		<td class="grid_par">'+_nValorCalc+'</td>'
				_cLinha += '		<td class="grid_par">'+_cObs+'</td>'
				_cLinha += '	</tr>'
			endif
			
		Next _nX
		
		_cLinha += '</table>'
		_cLinha += '&nbsp;'
		aadd((oHtml:ValByName( "it.LINHA")),_cLinha)
		
	Next _nI
	
	RPCClearEnv()
	RpcSetType(3)
	RPCSetEnv("01","01")
	RestArea(aSavSM0)
	RestArea(aSavATU)
	oProcess:ClientName( Subs(cUsuario,7,15) )
	eMail := SuperGetMv("MV_XMAILED",,"grp_sistemas@taiff.com.br") //"amessias@deltadecisao.com.br"
	oProcess:cSubject 	:= "Workflow EDI Proceda - Faturas"
	oProcess:cTo 		:= eMail
	oProcess:UserSiga	:= __CUSERID
	oProcess:Start()
	oProcess:Free()
Endif

RPCClearEnv()

Return

/*
ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ TAEDIS02 บAutor  ณ Anderson Messias   บ Data ณ  22/02/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Rotina Schedulada que verifica transportadoras com notas   บฑฑ
ฑฑบDesc.     ณ em aberto e faz o envio de email avisando o transportador  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ TAIFF                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function TAEDIS02(_cTipo)

LOCAL _nI	:= 0

Private _cQuery
Private _aDados := {}
Private  __cTipo 

//DEFAULT _cTipo := "C" //E = Entregas - C = Coletas - A = Agendamentos

//Preparo o Ambiente como primeira empresa do sigamat para comecar a correr o arquivo
RpcSetType(3)
RPCSetEnv("01","01")

DBSelectArea("SM0")
DBGoTop()
While !SM0->(Eof()) .AND. SM0->M0_CODIGO >= "01" .AND. SM0->M0_CODIGO <= "02"
	cEmpAnt := SM0->M0_CODIGO
	cFilAnt := SM0->M0_CODFIL
	aSavATU := GetArea()
	aSavSM0 := SM0->(GetArea())
	
	RPCClearEnv() //Fecho o ambiente
	RpcSetType(3)
	RPCSetEnv(cEmpAnt,cFilAnt) //Reabro com a proxima empresa / filial do arquivo
	Sleep(1500) // Pausa para poder realizar alteracao de Empresa - Edson Hornberger - 04/07/2014
	
	__cTipo := _cTipo
	
	_cQuery := ""
	_cQuery += "SELECT "+CRLF
	_cQuery += "  F2_TRANSP, "+CRLF
	_cQuery += "  SA4.A4_NOME, "+CRLF
	_cQuery += "  SA4.A4_EMAIL, "+CRLF
	_cQuery += "  SA4.A4_CGC, "+CRLF
	_cQuery += "  F2_TIPO, "+CRLF
	_cQuery += "  F2_DOC, "+CRLF
	_cQuery += "  F2_EMISSAO, "+CRLF
	_cQuery += "  F2_SERIE, "+CRLF
	_cQuery += "  F2_CLIENTE, "+CRLF
	_cQuery += "  F2_LOJA, "+CRLF
	_cQuery += "  CASE WHEN LTRIM(RTRIM(F2_REDESP))<>'' THEN SA4R.A4_NREDUZ ELSE CASE WHEN F2_TIPO IN ('D','B') THEN A2_NREDUZ ELSE A1_NREDUZ END END A1_NREDUZ, "+CRLF
	_cQuery += "  CASE WHEN LTRIM(RTRIM(F2_REDESP))<>'' THEN SA4R.A4_MUN  ELSE CASE WHEN F2_TIPO IN ('D','B') THEN A2_MUN  ELSE A1_MUN  END END A1_MUN, "+CRLF
	_cQuery += "  CASE WHEN LTRIM(RTRIM(F2_REDESP))<>'' THEN SA4R.A4_CEP  ELSE CASE WHEN F2_TIPO IN ('D','B') THEN A2_CEP  ELSE A1_CEP  END END A1_CEP, "+CRLF
	_cQuery += "  CASE WHEN LTRIM(RTRIM(F2_REDESP))<>'' THEN SA4R.A4_EST  ELSE CASE WHEN F2_TIPO IN ('D','B') THEN A2_EST  ELSE A1_EST  END END A1_EST, "+CRLF
	_cQuery += "  F2_DTEMB, "+CRLF
	_cQuery += "  F2_DTAGEND "+CRLF
	_cQuery += "FROM  "+CRLF
	_cQuery += "  "+RetSQLName("SF2")+" SF2 WITH (NOLOCK) "+CRLF
	_cQuery += "  LEFT JOIN "+RetSQLName("SA1")+" SA1 WITH (NOLOCK) ON A1_COD=F2_CLIENTE AND A1_LOJA=F2_LOJA AND SA1.D_E_L_E_T_='' "+CRLF
	_cQuery += "  LEFT JOIN "+RetSQLName("SA2")+" SA2 WITH (NOLOCK) ON A2_COD=F2_CLIENTE AND A2_LOJA=F2_LOJA AND SA2.D_E_L_E_T_='' "+CRLF
	_cQuery += "  LEFT JOIN "+RetSQLName("SA4")+" SA4 WITH (NOLOCK) ON A4_COD=F2_TRANSP AND SA4.D_E_L_E_T_='' "+CRLF
	_cQuery += "  LEFT JOIN "+RetSQLName("SA4")+" SA4R WITH (NOLOCK) ON SA4R.A4_COD=F2_REDESP AND SA4.D_E_L_E_T_='' "+CRLF
	_cQuery += "  LEFT JOIN "+RetSQLName("SX5")+" SX5 WITH (NOLOCK) ON F2_OCOENT=X5_CHAVE AND SX5.D_E_L_E_T_='' AND X5_TABELA='ZI' "+CRLF
	_cQuery += "  LEFT JOIN "+RetSQLName("SC5")+" SC5 WITH (NOLOCK) ON C5_NOTA=F2_DOC AND C5_SERIE=F2_SERIE AND SC5.D_E_L_E_T_='' "+CRLF
	_cQuery += "WHERE  "+CRLF
	_cQuery += "  SF2.D_E_L_E_T_ = ' ' AND "+CRLF
	_cQuery += "  SF2.F2_FILIAL = '" + xFilial("SF2") + "' AND "+CRLF
	if __cTipo == "A"
		_cQuery += "  F2_DTAGEND >= '20120524' AND F2_DTAGEND <= '"+DTOS(Date()-2)+"' AND "+CRLF
		_cQuery += "  F2_OCOENT >= '  ' AND F2_OCOENT <= 'ZZ' AND "+CRLF
	elseif __cTipo == "E"
		_cQuery += "  F2_DTRECEB = '' AND "+CRLF
		_cQuery += "  F2_DTEMB >= '20120101' AND F2_DTEMB <= '"+DTOS(Date()-2)+"' AND "+CRLF
		_cQuery += "  F2_OCOENT >= '  ' AND F2_OCOENT <= 'ZZ' AND "+CRLF
		_cQuery += "  C5_TPFRETE = 'C' AND "+CRLF
	else
		_cQuery += "  F2_DTEMB = '' AND "+CRLF
		_cQuery += "  F2_EMISSAO >= '20120101' AND F2_EMISSAO <= '"+DTOS(Date()-2)+"' AND "+CRLF
		_cQuery += "  F2_OCOENT >= '  ' AND F2_OCOENT <= 'ZZ' AND "+CRLF
		_cQuery += "  C5_TPFRETE = 'C' AND "+CRLF
	endif
	_cQuery += "  F2_TIPO = 'N' AND "+CRLF
	_cQuery += "  F2_TRANSP NOT IN ('000526') "+CRLF
	_cQuery += "ORDER BY  "+CRLF
	_cQuery += "  F2_TRANSP, "+CRLF
	_cQuery += "  F2_DOC "+CRLF
	
	If Select("TSQL") > 0
		dbSelectArea("TSQL")
		dbCloseArea()
	EndIf
	
	//* Cria a Query e da Um Apelido
	TCQUERY _cQuery NEW ALIAS "TSQL"
	dbSelectArea("TSQL")
	
	While !TSQL->(Eof())
		
		if __cTipo == "E"
			//Verifico se o prazo de entrega estแ vencido para so entao avisar a transportadora
			_nDiasTra := 0
			_nDiasVr  := 0
			_nDiasReal:= 0
			// Pegar Prazo de entrega da tabela de frete
			_aCalTrans := U_SeleFrete(0,0,TSQL->A1_EST,TSQL->A1_CEP,"N",TSQL->F2_TRANSP,STOD(TSQL->F2_EMISSAO))
			_nDiasTra  := 0
			If Len(_aCalTrans)>0
				_nDiasTra  := _aCalTrans[1,5]
			Endif
			// Calculo dos dias de entrega apenas dias uteis.
			_dDtUtil		:= STOD(TSQL->F2_DTEMB)
			_nDiasReal	    := 0
			While .T.
				_dDtUtil++
				_dDtValida	:= DataValida(_dDtUtil)
				If _dDtValida == _dDtUtil
					_nDiasReal++
					If _nDiasReal >= _nDiastra // Se Transportador entregou atrasado considerar todos os dias corridos
						_nDiasReal := _nDiasReal+(Date()-_dDtUtil)
						Exit
					Endif
				Endif
				If _dDtUtil >= Date()
					Exit
				Endif
			EndDo
			_nDiasVr := _nDiasReal-_nDiasTra
			
			_lEnvia := _nDiasReal > _nDiasTra
		elseif __cTipo == "A"
			_nDiasVr := Date() - STOD(TSQL->F2_DTAGEND)
			_lEnvia := .T.
		else
			_nDiasVr := Date() - STOD(TSQL->F2_EMISSAO)
			_lEnvia := .T.
		endif
		
		//Se o numero de dias reais de atrazo for maior que o numero de dias que a transportadora da para entregar, gera base para cobranca de informa็ใo
		if _lEnvia
			aadd(_aDados,{;
			SM0->M0_CODIGO,;
			SM0->M0_CODFIL,;
			SM0->M0_NOME,;
			TSQL->F2_TRANSP,;
			TSQL->A4_NOME,;
			TSQL->A4_EMAIL,;
			TSQL->A4_CGC,;
			TSQL->F2_TIPO,;
			TSQL->F2_DOC,;
			TSQL->F2_SERIE,;
			TSQL->F2_CLIENTE,;
			TSQL->F2_LOJA,;
			TSQL->A1_NREDUZ,;
			TSQL->A1_MUN,;
			TSQL->A1_CEP,;
			TSQL->A1_EST,;
			iif(_cTipo=="E",DTOC(STOD(TSQL->F2_DTEMB)),iif(_cTipo=="A",DTOC(STOD(TSQL->F2_DTAGEND)),DTOC(STOD(TSQL->F2_EMISSAO)))),;
			alltrim(Str(_nDiasVr))})
		endif
		TSQL->(DBSkip())
	EndDo
	
	If Select("TSQL") > 0
		dbSelectArea("TSQL")
		dbCloseArea()
	EndIf
	
	RestArea(aSavSM0)
	RestArea(aSavATU)
	
	SM0->(DBSkip())
EndDo

RPCClearEnv() //Fecho o ambiente

//******************** Preparando envio do workflow para os responsaveis **************************

RpcSetType(3)
RPCSetEnv("01","01") //Posiciono na empresa 01 e filial 01 pois ้ onde estแ configurado o workflow de envio do email

aSort(_aDados,,,{|x,y| x[7]+x[1]+x[2] < y[7]+y[1]+y[2] })

aWFSend := aClone(_aDados)

if Len(aWFSend) > 0
	
	//Enviando email para as transportadoras - Um email por transportadora
	_cArq    := aWFSend[1][7]
	lImpr    := .T.
	lFirst   := .T.
	loProcess:= .F.
	For _nI := 1 to len(aWFSend)
		//Verifico se o registro tem email da transportadora, se nao tiver ้ desprezado
		_cEmail := alltrim(aWFSend[_nI][6])
		if len(_cEmail) == 0
			Loop
		endif
		
		//Vejo se o email possui arroba para evitar que seja enviado para um email invalido
		if At("@",_cEmail) == 0
			Loop
		endif
		
		if _cArq <> aWFSend[_nI][7]
			lImpr := .T.
		endif
		
		if lImpr .AND. !lFirst
			_cLinha += '</table>'
			_cLinha += '&nbsp;'
			aadd((oHtml:ValByName( "it.LINHA")),_cLinha)
			
			oProcess:ClientName( Subs(cUsuario,7,15) )
			eMail := SuperGetMv("MV_XMAILED",,"grp_sistemas@taiff.com.br") //"amessias@deltadecisao.com.br"
			if _cTipo == "A"
				oProcess:cSubject 	:= "Workflow Agendamento de Coletas (AVISO)"
			elseif _cTipo == "E"
				oProcess:cSubject 	:= "Workflow EDI Proceda - Entregas (AVISO)"
			else
				oProcess:cSubject 	:= "Workflow - Coletas (AVISO)"
			endif
			oProcess:cTo 		:= eMail
			oProcess:UserSiga	:= __CUSERID
			oProcess:Start()
			oProcess:Free()
			loProcess := .F.
		endif
		
		if lImpr
			if _cTipo == "A"
				_cTitulo := "Workflow Agendamento de Coletas (AVISO)"
			elseif _cTipo == "E"
				_cTitulo := "Workflow EDI Proceda - Entregas (Aviso)"
			else
				_cTitulo := "Workflow - Coleta (Aviso)"
			endif
			oProcess := TWFProcess():New( "WFEDITRA", _cTitulo )
			oProcess:NewTask( "WFEDITRANS", "\WORKFLOW\WFEDIPROC2.HTM" )
			oHTML := oProcess:oHTML
			oHtml:ValByName("TITULO",_cTitulo)
			loProcess := .T.
			
			_cLinha := ''
			_cLinha += '<table width="100%">'
			_cLinha += '	<tr>'
			_cLinha += '		<td><b>Transportadora</b> : '+aWFSend[_nI][4]+" - "+aWFSend[_nI][5]+'</td>'
			_cLinha += '	</tr>'
			_cLinha += '	<tr>'
			_cLinha += '		<td><b>Email</b> : '+iif(Len(Alltrim(aWFSend[_nI][6]))>0,aWFSend[_nI][6],"Email da transportadora nao cadastrado!")+'</td>'
			_cLinha += '	</tr>'
			_cLinha += '	<tr>'
			_cLinha += '		<td><b>Processado</b> : '+DTOC(Date())+' - '+Time()+'</td>'
			_cLinha += '	</tr>'
			_cLinha += '</table>'
			_cLinha += '<table width="100%">'
			_cLinha += '	<tr>'
			_cLinha += '		<td class="grid_titulo">Empresa</td>'
			_cLinha += '		<td class="grid_titulo">Serie</td>'
			_cLinha += '		<td class="grid_titulo">Documento</td>'
			_cLinha += '		<td class="grid_titulo">Cliente</td>'
			_cLinha += '		<td class="grid_titulo">Nome</td>'
			_cLinha += '		<td class="grid_titulo">Estado</td>'
			_cLinha += '		<td class="grid_titulo">Municipio</td>'
			if _cTipo == "A"
				_cLinha += '		<td class="grid_titulo">Dt. Agendamento</td>'
			elseif _cTipo == "E"
				_cLinha += '		<td class="grid_titulo">Dt. Embarque</td>'
			else
				_cLinha += '		<td class="grid_titulo">Dt. Coleta</td>'
			endif
			if _cTipo == "A"
				_cLinha += '		<td class="grid_titulo">Dias Faltantes</td>'
			else
				_cLinha += '		<td class="grid_titulo">Dias Atrazo</td>'
			endif
			_cLinha += '	</tr>'
			lImpr := .F.
			lFirst:= .F.
		endif
		
		_cLinha += '	<tr>'
		_cLinha += '		<td class="grid_par">'+aWFSend[_nI][3]+'</td>'
		_cLinha += '		<td class="grid_par">'+aWFSend[_nI][10]+'</td>'
		_cLinha += '		<td class="grid_par">'+aWFSend[_nI][9]+'</td>'
		_cLinha += '		<td class="grid_par">'+aWFSend[_nI][11]+"/"+aWFSend[_nI][12]+'</td>'
		_cLinha += '		<td class="grid_par">'+aWFSend[_nI][13]+'</td>'
		_cLinha += '		<td class="grid_par">'+aWFSend[_nI][16]+'</td>'
		_cLinha += '		<td class="grid_par">'+aWFSend[_nI][14]+'</td>'
		_cLinha += '		<td class="grid_par">'+aWFSend[_nI][17]+'</td>'
		_cLinha += '		<td class="grid_par">'+aWFSend[_nI][18]+'</td>'
		_cLinha += '	</tr>'
		
		_cArq := aWFSend[_nI][7]
	Next _nI
	
	if loProcess
		_cLinha += '</table>'
		_cLinha += '&nbsp;'
		aadd((oHtml:ValByName( "it.LINHA")),_cLinha)
		oProcess:ClientName( Subs(cUsuario,7,15) )
		eMail := SuperGetMv("MV_XMAILED",,"grp_sistemas@taiff.com.br") //"amessias@deltadecisao.com.br"
		if __cTipo == "A"
			oProcess:cSubject 	:= "Workflow Agendamento de Coletas (AVISO)"
		elseif __cTipo == "E"
			oProcess:cSubject 	:= "Workflow EDI Proceda - Entregas (AVISO)"
		else
			oProcess:cSubject 	:= "Workflow - Coletas (AVISO)"
		endif
		oProcess:cTo 		:= eMail
		oProcess:UserSiga	:= __CUSERID
		oProcess:Start()
		oProcess:Free()
	endif
	
	//Enviando email para o Supervisor com todas as transportadoras, inclusive sem email cadastrado
	if __cTipo == "A"
		_cTitulo := "Workflow Agendamento de Coletas (AVISO)"
	elseif __cTipo == "E"
		_cTitulo := "Workflow EDI Proceda - Entregas (Aviso)"
	else
		_cTitulo := "Workflow - Coleta (Aviso)"
	endif
	oProcess := TWFProcess():New( "WFEDITRA", _cTipo )
	oProcess:NewTask( "WFEDITRANS", "\WORKFLOW\WFEDIPROC2.HTM" )
	oHTML := oProcess:oHTML
	oHtml:ValByName("TITULO",_cTitulo)
	
	_cArq := aWFSend[1][7]
	lImpr := .T.
	lFirst:= .T.
	For _nI := 1 to len(aWFSend)
		//Verifico se o registro tem email da transportadora, se nao tiver ้ desprezado
		if _cArq <> aWFSend[_nI][7]
			lImpr := .T.
		endif
		
		if lImpr .AND. !lFirst
			_cLinha += '</table>'
			_cLinha += '&nbsp;'
			aadd((oHtml:ValByName( "it.LINHA")),_cLinha)
		endif
		
		if lImpr
			_cLinha := ''
			_cLinha += '<table width="100%">'
			_cLinha += '	<tr>'
			_cLinha += '		<td><b>Transportadora</b> : '+aWFSend[_nI][4]+" - "+aWFSend[_nI][5]+'</td>'
			_cLinha += '	</tr>'
			_cLinha += '	<tr>'
			_cLinha += '		<td><b>Email</b> : '+iif(Len(Alltrim(aWFSend[_nI][6]))>0,aWFSend[_nI][6],"Email da transportadora nao cadastrado!")+'</td>'
			_cLinha += '	</tr>'
			_cLinha += '	<tr>'
			_cLinha += '		<td><b>Processado</b> : '+DTOC(Date())+' - '+Time()+'</td>'
			_cLinha += '	</tr>'
			_cLinha += '</table>'
			_cLinha += '<table width="100%">'
			_cLinha += '	<tr>'
			_cLinha += '		<td class="grid_titulo">Empresa</td>'
			_cLinha += '		<td class="grid_titulo">Serie</td>'
			_cLinha += '		<td class="grid_titulo">Documento</td>'
			_cLinha += '		<td class="grid_titulo">Cliente</td>'
			_cLinha += '		<td class="grid_titulo">Nome</td>'
			_cLinha += '		<td class="grid_titulo">Estado</td>'
			_cLinha += '		<td class="grid_titulo">Municipio</td>'
			if __cTipo == "A"
				_cLinha += '		<td class="grid_titulo">Dt. Agendamento</td>'
			elseif __cTipo == "E"
				_cLinha += '		<td class="grid_titulo">Dt. Embarque</td>'
			else
				_cLinha += '		<td class="grid_titulo">Dt. Coleta</td>'
			endif
			if __cTipo == "A"
				_cLinha += '		<td class="grid_titulo">Dias Faltantes</td>'
			else
				_cLinha += '		<td class="grid_titulo">Dias Atrazo</td>'
			endif
			_cLinha += '	</tr>'
			lImpr := .F.
			lFirst:= .F.
		endif
		
		_cLinha += '	<tr>'
		_cLinha += '		<td class="grid_par">'+aWFSend[_nI][3]+'</td>'
		_cLinha += '		<td class="grid_par">'+aWFSend[_nI][10]+'</td>'
		_cLinha += '		<td class="grid_par">'+aWFSend[_nI][9]+'</td>'
		_cLinha += '		<td class="grid_par">'+aWFSend[_nI][11]+"/"+aWFSend[_nI][12]+'</td>'
		_cLinha += '		<td class="grid_par">'+aWFSend[_nI][13]+'</td>'
		_cLinha += '		<td class="grid_par">'+aWFSend[_nI][16]+'</td>'
		_cLinha += '		<td class="grid_par">'+aWFSend[_nI][14]+'</td>'
		_cLinha += '		<td class="grid_par">'+aWFSend[_nI][17]+'</td>'
		_cLinha += '		<td class="grid_par">'+aWFSend[_nI][18]+'</td>'
		_cLinha += '	</tr>'
		
		_cArq := aWFSend[_nI][7]
	Next _nI
	
	_cLinha += '</table>'
	_cLinha += '&nbsp;'
	aadd((oHtml:ValByName( "it.LINHA")),_cLinha)
	oProcess:ClientName( Subs(cUsuario,7,15) )
	eMail := SuperGetMv("MV_XMAILED",,"grp_sistemas@taiff.com.br") //"amessias@deltadecisao.com.br"
	if __cTipo == "A"
		oProcess:cSubject 	:= "Workflow Agendamento de Coletas (AVISO SUPERVISOR)"
	elseif __cTipo == "E"
		oProcess:cSubject 	:= "Workflow EDI Proceda - Entregas (AVISO SUPERVISOR)"
	else
		oProcess:cSubject 	:= "Workflow - Coletas (AVISO)"
	endif
	
	oProcess:cTo 		:= eMail
	oProcess:UserSiga	:= __CUSERID
	oProcess:Start()
	oProcess:Free()
endif

RPCClearEnv()

Return

/*
ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ GRAVAPAU บ Autor ณ Anderson Messias   บ Data ณ  22/02/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Efetua a gravacao de informacoes de Ocorrencias das Trans- บฑฑ
ฑฑบDesc.     ณ portadoras.                                                บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ TAIFF                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function GravaPAU(aNotas,_N)

Local aAreaAtu	:= GetArea()

_lImpDat := AllTrim(GetSx3Cache("PAU_IMPDAT", "X3_CAMPO")) == "PAU_IMPDAT"
_lImpHor := AllTrim(GetSx3Cache("PAU_IMPHOR", "X3_CAMPO")) == "PAU_IMPHOR"

DbSelectArea("PAU")
DbSetOrder(1)
// neste momento, 06/12/2012, nใo serแ feito tratamento para barrar registros com a mesma ocorr๊ncia
RecLock("PAU",.T.)
PAU_FILIAL	:= SF2->F2_FILIAL
PAU_DOC		:= SF2->F2_DOC
PAU_SERIE	:= SF2->F2_SERIE
PAU_CLIENT	:= SF2->F2_CLIENTE
PAU_LOJA	:= SF2->F2_LOJA
PAU_EMISSA	:= SF2->F2_EMISSAO
PAU_DTEMB	:= SF2->F2_DTEMB
PAU_CODOCO	:= aNotas[_N][4]
PAU_DESCOC	:= aNotas[_N][8]
PAU_DATAOC	:= aNotas[_N][5]
PAU_HORAOC	:= aNotas[_N][6]
PAU_CODTRA	:= SF2->F2_TRANSP
PAU_DESCTR	:= GetAdvFval("SA4","A4_NOME",xFilial("SA4")+SF2->F2_TRANSP, 1)
PAU_UFNFS	:= SF2->F2_EST
PAU_OBSERV	:= aNotas[_N][14]

If _lImpDat .and. _lImpHor
	
	PAU_IMPDAT := dDataBase
	PAU_IMPHOR := Time()
	
EndIf


MsUnlock()

RestArea(aAreaAtu)

Return()
