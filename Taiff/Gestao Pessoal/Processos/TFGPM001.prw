#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "RWMAKE.CH"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ TFGPM001 บ       ณRICARDO DUARTE COSTAบ Data ณ  09/06/2017 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Importa็ใo da co-participa็ใo dos dependentes para o       บฑฑ
ฑฑบ          ณ movimento mensal ou acumulado.                             บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿/*/
User Function TFGPM001()

Local aArea		:= GetArea()
Local oGera
Private cPerg	:= "TFGPM001  "
AltSXB()

ValidPerg()
pergunte(cPerg,.F.)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Montagem da tela de processamento.                                  ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
@ 200,1 TO 400,480 DIALOG oGera TITLE OemToAnsi("Importa็ใo da Co-Participa็ใo de Assist๊ncia M้dica")
@ 02,10 TO 095,230
@ 35,018 Say " Este programa ira importar os valores descontados a titulo de "
@ 42,018 Say " co-participa็cao de assistencia m้dica para os movimentos da  "
@ 49,018 Say " folha de pagamento e hist๓rico de DIRF.                       "

@ 70,128 BMPBUTTON TYPE 05 ACTION Pergunte(cPerg,.T.)
@ 70,158 BMPBUTTON TYPE 02 ACTION Close(oGera)
@ 70,188 BMPBUTTON TYPE 01 ACTION OkGera(oGera)

Activate Dialog oGera Centered

RestArea(aArea)

Return()

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณ OKGERA   บ Autor ณ PRIMA INFORMATICA  บ Data ณ  17/06/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Funcao chamada pelo botao OK na tela inicial de processamenบฑฑ
ฑฑบ          ณ to. Executa a geracao do arquivo texto.                    บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Programa principal                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿ /*/
Static Function OkGera(oGera)

//-- Confirma a operacao antes de sair executando
If !GPECROk()
	Return()
Endif

Processa( {|| fMtaQuery()}, "Processando...", "Selecionado Registros no Banco de Dados..." )

Close(oGera)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfMtaQuery บAutor  ณ PRIMA INFORMATICA  บ Data ณ  28/11/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณMonta a query para o programa principal                     บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณPrograma principal                                          บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿ */
Static Function fMtaQuery()

Local nHandle
Local nSize		:= 0
Local nx		:= 0
Local TXT		:= ""
Local aInfoFile	:= {}
Local aFields	:= 	{}
//-- Layout antigo unimed paulistana
Local aFieldsBRA:= 	{	;			
					{'TXTCPO'		,'C',300, 0 },;
					{'TIPOREG'		,'C',01, 0 },;
					{'CP0O02'		,'C',06, 0 },;
					{'CP0O03'		,'C',06, 0 },;
					{'CP0O04'		,'C',01, 0 },;
					{'CP1O02'		,'C',40, 0 },;
					{'CP1O03'		,'C',17, 0 },;
					{'CP1O04'		,'C',10, 0 },;
					{'CP1O05'		,'C',40, 0 },;
					{'CP1O06'		,'C',14, 0 },;
					{'CP1O07'		,'C',06, 0 },;
					{'CP1O08'		,'C',20, 0 },;
					{'CP1O09'		,'C',10, 0 },;
					{'CP1O10'		,'C',10, 0 },;
					{'CP1O11'		,'C',10, 0 },;
					{'CP1O12'		,'C',12, 0 },;
					{'CP1O13'		,'C',03, 0 },;
					{'CP2O02'		,'C',10, 0 },;
					{'CP2O03'		,'C',02, 0 },;
					{'CP2O04'		,'C',40, 0 },;
					{'CP2O05'		,'C',70, 0 },;
					{'CP2O06'		,'C',02, 0 },;
					{'CP2O07'		,'C',18, 0 },;
					{'CP2O08'		,'C',25, 0 },;
					{'CP2O09'		,'C',07, 0 },;
					{'CP2O10'		,'N',12, 2 },;
					{'CP2O11'		,'N',12, 2 },;
					{'CP2O12'		,'N',12, 2 },;
					{'CP2O13'		,'N',12, 2 },;
					{'CP2O14'		,'C',12, 0 },;
					{'CP2O15'		,'C',11, 0 },;
					{'CP2O16'		,'C',04, 0 },;
					{'CP2O17'		,'C',07, 0 },;
					{'CP2O18'		,'C',12, 0 },;
					{'CP2O19'		,'C',03, 0 };
					}
Private aLog		:= {}
Private aTitle		:= {}
Private aXlsExp		:= {}
Private cQuery		:= ""
Private cNomeTab	:= "COPARTIC"+cEmpAnt
Private cMesAnoAux:= ""
Private nTamFile, nTamLin, nBtLidos
Private cArqTXT	:= MV_PAR01
Private cArquivo:= CriaTrab(,.F.)
Private cMesAno	:= right(mv_par02,4)+left(mv_par02,2)
Private cCodForn:= mv_par03
Private nLayOut	:= mv_par04
Private lRegrava:= mv_par05 == 1
Private nParcela:= 0
Private cPath	:= AllTrim(GetTempPath())
Private cDirDocs:= MsDocPath()
Private nTotNImp:= 0
Private nTotImp	:= 0

//-- Determina o layout de importa็ใo
aFields	:= aClone(aFieldsBRA)

//-- Iguala a quantidade de parcela a 1 caso seja preenchida quantidade negativa ou zero
If nParcela <= 1
	nParcela	:= 1
Endif

//-- Ajusta o arquivo gerado trocando virgula por ponto para fazer a importacao dos valores corretamente.
nHandle := MsfCreate(cDirDocs+"\"+cArquivo+".PRN",0)
If nHandle > 0
	//-- Abre arquivo texto informado
	nHandle1 := fOpen( cArqTXT, 64)
	If Ferror() # 0 .or. nHandle1 < 0
	    Alert("Nใo foi possํvel abrir o arquivo selecionado.")
	    fClose(nHandle)
	    Return( Nil )
	Endif
	
	//-- Troca a virgula por ponto
	aInfoFile	:= Directory( cArqTXT )
	nSize		:= aInfoFile[1,2]

	nTamFile:= fSeek(nHandle1,0,2)
	fSeek(nHandle1,0,0)
	nTamLin	:= 200
	TXT  	:= Space(nTamLin) // Variavel para criacao da linha do registro para leitura
	nBtLidos:= fRead(nHandle1,@TXT,nTamLin) // Leitura da primeira linha do arquivo texto
	nLinha_ := 0
	
	While nBtLidos >= nTamLin
		
		//-- Retira todas as virgulas do texto e troca os ; por virgula para utilizar o delimitador padrใo do ADVPL
		TXT			:= StrTran(TXT,",",".")
	
		//-- Salva novo arquivo texto com o conteudo ajustado
		fWrite(nHandle,TXT)
	    //ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	    //ณ Leitura da proxima linha do arquivo texto.                          ณ
	    //ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	    nBtLidos := fRead(nHandle1,@TXT,nTamLin) // Leitura da proxima linha do arquivo texto
	Enddo
	
	//-- Trata a ๚ltima informa็ใo lida
	If nBtLidos > 0
		TXT			:= StrTran(TXT,",",".")
		//-- Salva novo arquivo texto com o conteudo ajustado
		fWrite(nHandle,TXT)
	Endif
	fClose(nHandle)
    fClose(nHandle1)
Endif

//-- Inicia o tratamento da importacao arquivo de coparticipa็ใo.
If Len(aFields) > 0

	// Exclui tabela temporaria co-participa็ใo
	If TCCanOpen(cNomeTab)
		TcDelFile(cNomeTab) 
	EndIf    

	//-- For็a a abertura da tabela mensal de co-participa็ใo pelo ํndice customizado 2
	DbSelectArea("RHO")
	cArqNtx  	:= CriaTrab(NIL,.F.) 
	cIndCond	:= "RHO_FILIAL+RHO_MAT+DTOS(RHO_DTOCOR)+RHO_TPFORN+RHO_CODFOR+RHO_ORIGEM+RHO_CODIGO+RHO_PD+RHO_COMPPG"
	IndRegua("RHO",cArqNtx,cIndCond,,,"Selecionando Registros Coparticipa็ใo")				//"Selecionando Registros..."
	DbGoTop()
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Cria arquivo de trabalho co-participa็ใo 							ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	MsCreate(cNomeTab,aFields,__cRdd) 
	DbUseArea( .T.,__cRdd , cNomeTab, "DEPASS", .F. )
	If Select("DEPASS") == 0
		Aviso("Aten็ใo","Rotina estแ sendo usada por outro usuแrio",{"OK"})
		Return
	EndIf                  
	
	/*
	ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	ณ Importa o arquivo do dissidio                       	     ณ
	ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู*/
	MsAguarde({|| fAppendD() },OemToAnsi("Preparando dados de co-participa็๕es."),OemToAnsi("Aguarde..."))

	//-- Testa quantidade de registros a serem importados
	ProcRegua( (nRegistros	:= DEPASS->( reccount() )) )
	If nRegistros == 0
		Aviso("Aten็ใo","O arquivo de Co-Participa็ใo nใo cont้m dados a serem importados.",{"OK"})
		//-- Fecha o alias do arquivo temporario
		dbSelectArea( "DEPASS" )
		dbCloseArea()
		return
	Endif
	
	//-- Ajusta campos de carteirinha e valor.
	DEPASS->(Dbgotop())
	While !DEPASS->(eof())
		cTipoReg	:= left(DEPASS->TXTCPO,1)
		Reclock("DEPASS",.F.)
		DEPASS->TIPOREG	:= cTipoReg
		If cTipoReg == "0"
			DEPASS->CP0O02	:= Substring(DEPASS->TXTCPO,02,6)
			DEPASS->CP0O03	:= Substring(DEPASS->TXTCPO,08,6)
			DEPASS->CP0O04	:= Substring(DEPASS->TXTCPO,14,1)
		ElseIf cTipoReg == "1"
			DEPASS->CP1O02	:= Substring(DEPASS->TXTCPO,002,40)
			DEPASS->CP1O03	:= Substring(DEPASS->TXTCPO,042,17)
			DEPASS->CP1O04	:= Substring(DEPASS->TXTCPO,060,10)
			DEPASS->CP1O05	:= Substring(DEPASS->TXTCPO,070,40)
			DEPASS->CP1O06	:= Substring(DEPASS->TXTCPO,110,14)
			DEPASS->CP1O07	:= Substring(DEPASS->TXTCPO,124,06)
			DEPASS->CP1O08	:= Substring(DEPASS->TXTCPO,130,20)
			DEPASS->CP1O09	:= Substring(DEPASS->TXTCPO,150,10)
			DEPASS->CP1O10	:= Substring(DEPASS->TXTCPO,160,10)
			DEPASS->CP1O11	:= Substring(DEPASS->TXTCPO,170,10)
			DEPASS->CP1O12	:= Substring(DEPASS->TXTCPO,180,12)
			DEPASS->CP1O13	:= Substring(DEPASS->TXTCPO,192,03)
		ElseIf cTipoReg == "2"
			DEPASS->CP2O02	:= Substring(DEPASS->TXTCPO,002,10)
			DEPASS->CP2O03	:= Substring(DEPASS->TXTCPO,012,02)
			DEPASS->CP2O04	:= Substring(DEPASS->TXTCPO,014,40)
			DEPASS->CP2O05	:= Substring(DEPASS->TXTCPO,054,70)
			DEPASS->CP2O06	:= Substring(DEPASS->TXTCPO,124,02)
			DEPASS->CP2O07	:= Substring(DEPASS->TXTCPO,126,18)
			DEPASS->CP2O08	:= Substring(DEPASS->TXTCPO,144,25)
			DEPASS->CP2O09	:= Substring(DEPASS->TXTCPO,169,07)
			DEPASS->CP2O10	:= Val(Substring(DEPASS->TXTCPO,176,12))
			DEPASS->CP2O11	:= Val(Substring(DEPASS->TXTCPO,188,12))
			DEPASS->CP2O12	:= Val(Substring(DEPASS->TXTCPO,200,12))
			DEPASS->CP2O13	:= Val(Substring(DEPASS->TXTCPO,212,12))
			DEPASS->CP2O14	:= Substring(DEPASS->TXTCPO,224,12)
			DEPASS->CP2O15	:= Substring(DEPASS->TXTCPO,236,11)
			DEPASS->CP2O16	:= Substring(DEPASS->TXTCPO,247,04)
			DEPASS->CP2O17	:= Substring(DEPASS->TXTCPO,251,07)
			DEPASS->CP2O18	:= Substring(DEPASS->TXTCPO,258,12)
			DEPASS->CP2O19	:= Substring(DEPASS->TXTCPO,270,03)
		Endif
		DEPASS->(MsUnlock())
		DEPASS->(Dbskip())
	Enddo
	
	//-- Define o layout a ser processado
	fLayOut3()
	
	//-- Fecha a tabela de co-participa็ใo
	If Select("COPART") > 0
		COPART->(DbCloseArea())
	Endif

	//-- Exclui tabela temporaria
	If TCCanOpen(cNomeTab)
		dbSelectArea( "DEPASS" )
		dbCloseArea()
		TcDelFile(cNomeTab) 
	EndIf

	//-- Grava Exporta็ใo do Log em Planilha excel para facilitar a confer๊ncia.
	nHandle := MsfCreate(cDirDocs+"\"+cArquivo+".CSV",0)
	If nHandle > 0

		//-- Grava cabe็alho
		fWrite(nHandle,"Status; Usuแrio; Titular; Empresa; Fatura; Carteirinha; Carteirinha Usuario; Filial; Matricula; Nome; Usuแrio; Sequencia; Situa็ใo Folha; Tipo Rescisใo; Valor Total; Funcionแrio; Empresa"+CRLF)
		//-- Descarrega a informa็ใo em um arquivo texto
		For nx := 1 to len(aXlsExp)
			fWrite(nHandle,aXlsExp[nx])
		Next nx
		fClose(nHandle)

		//-- Executa a abertura da planilha Excel
		CpyS2T( cDirDocs+"\"+cArquivo+".CSV" , cPath , .T. )
		Ferase(cDirDocs+"\"+cArquivo+".CSV")
		Aviso("Aten็ใo","A planilha foi gerada em "+cPath+cArquivo+".CSV",{"Ok"})
		If ! ApOleClient( 'MsExcel' )
			MsgAlert( 'MsExcel nao instalado' )
		Else
			oExcelApp := MsExcel():New()
			oExcelApp:WorkBooks:Open( cPath+cArquivo+".CSV" ) // Abre uma planilha
			oExcelApp:SetVisible(.T.)
		EndIf

	Endif
	
	//-- Imprime o log
	If Len(aLog) > 0
		Aadd(aLog[2], Right(space(91)+"Total nใo importado: ",91)+Transform(nTotNImp,"@E 99,999,999.99") )
		fMakeLog(aLog,aTitle,,,"TFGPM001",,"G","P",,.F.)
	Endif

Endif

Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ GPECROk  บAutor  ณPrima Informatica   บ Data ณ  10/11/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Funcao GPECROK() - Confirmacao da execucao da geracao das  บฑฑ
ฑฑบ          ณ                    parcelas.                               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Estatica                                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function GPECROk() 
Return ( MsgYesNo( OemToAnsi( "Confirma processamento?" ), OemToAnsi( "Atencao" ) ) )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfappendD  บAutor  ณPrima Informatica   บ Data ณ  08/06/01   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Executa o append do arquivo do dissidio para o banco Oracleบฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function fAppendD()

//Append From (cDirDocs+"\"+cArquivo+".PRN") DELIMITED WITH (";")
Append From (cDirDocs+"\"+cArquivo+".PRN") SDF

Return()

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณVALIDPERG บ Autor ณ Prima Informatica  บ Data ณ  14/06/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Verifica a existencia das perguntas criando-as caso seja   บฑฑ
ฑฑบ          ณ necessario (caso nao existam).                             บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Programa principal                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿ /*/
Static Function ValidPerg()

Local _sAlias, aRegs, i,j

_sAlias := Alias()
aRegs := {}
I := 0
J := 0

dbSelectArea("SX1")
dbSetOrder(1)
cPerg := PADR(cPerg,10)

// Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05
//          Grupo/Ordem    /Pergunta/ /                                                        /Var	/Tipo/Tam/Dec/Pres/GSC/Valid/                    Var01      /Def01    /DefSpa01    /DefIng1      /Cnt01/Var02    /Def02   /DefSpa2     /DefIng2          /Cnt02   /Var03 /Def03   /DefSpa3  /DefIng3  /Cnt03 /Var04   /Def04    /Cnt04    /Var05  /Def05	/Cnt05  /XF3
Aadd(aRegs,{cPerg,"01","Local do arquivo?","Local do arquivo?","Local do arquivo?"                           ,"mv_ch1","C",99,0,0,"G" ,"U_fOpenAr1()","mv_par01","","","","","","","","","","","","","","","","","","","","",""	,""	,"","","",""})
Aadd(aRegs,{cPerg,"02","Mes/Ano (MMAAAA)?","Mes/Ano (MMAAAA)?","Mes/Ano (MMAAAA)?"                           ,"mv_ch2","C",06,0,0,"G" ,""            ,"mv_par02","","","","","","","","","","","","","","","","","","","","",""	,""	,"","","",""})
Aadd(aRegs,{cPerg,"03","Cod.Fornecedor   ","Codigo Fornecedor","Codigo Fornecedor"                           ,"mv_ch3","C",03,0,0,"G" ,""            ,"mv_par03",""       ,"" ,"" ,"","",""     ,"" ,"" ,"","","","","","","","","","","","","","","","","TFGP01","","",""})
Aadd(aRegs,{cPerg,"04","LayOut Coparticip?","LayOut Coparticip?","LayOut Coparticip?"                        ,"mv_ch4","N",01,0,2,"C" ,""            ,"mv_par05","Bradesco","" ,"" ,"","","","" ,"" ,"","","","","","","","","","","","","","","","","","","",""})
Aadd(aRegs,{cPerg,"05","Lan็amento existente?","Lan็amento existente?","Lan็amento existente?"               ,"mv_ch5","N",01,0,1,"C" ,""            ,"mv_par06","Regravar","" ,"" ,"","","Somar"     ,"" ,"" ,"","","","","","","","","","","","","","","","","","","",""})

For i:=1 to Len(aRegs)
	If !dbSeek(cPerg+aRegs[i,2])
		RecLock("SX1",.T.)
		For j:=1 to FCount()
			If j <= Len(aRegs[i])
				FieldPut(j,aRegs[i,j])
			Endif
		Next
		MsUnlock()
	Endif
Next

dbSelectArea(_sAlias)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfOpenArq  บAutor  ณ Prima Informtica   บ Data ณ  19/08/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Seleciona o arquivo a importar.                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP5                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
User Function fOpenAr1()

Local cSvAlias		:= Alias()
Local lAchou		:= .F.
Local cTipo			:= "Arquivo Texto(*.*)  |*.*| "
Local cNewPathArq	:= cGetFile( cTipo , "Selecione o arquivo" )

IF !Empty( cNewPathArq )
		Aviso( "Aten็ใo","Arquivo selecionado: " + cNewPathArq , { "OK" } )								
Else
    Aviso("Aten็ใo","Sele็ใo cancelada" ,{ "OK" })
    Return
EndIF

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณLimpa o parametro para a Carga do Novo Arquivo                         ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
dbSelectArea("SX1")  
IF lAchou := ( SX1->( dbSeek( cPerg + "01" , .T. ) ) )
	RecLock("SX1",.F.,.T.)
	SX1->X1_CNT01 := Space( Len( SX1->X1_CNT01 ) )
	mv_par01 := cNewPathArq
	MsUnLock()
EndIF	
dbSelectArea( cSvAlias )

Return(lAchou)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfVerbQry  บAutor  ณ Prima Informtica   บ Data ณ  19/08/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Devolve a verba da coparticipa็cao a ser importada.        บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP5                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
User Function fVerbQry(cSequenc,cTipo)
Local cRet	:= ftabela("U007",1,5)
If valtype(cRet) <> "C" .Or. Empty(cRet)
	cRet	:= "530"
Endif
Return(cRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAltSXB    บAutor  ณRicardo Duarte Costaบ Data ณ  16/10/2013 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Monta consulta padrao para fornecedor de assistencia medicaบฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function AltSXB()

Local _aArea	:= GetArea()
Local aCampos	:= {}
Local nx		:= 0

// Monta nova estrutura
// { "XB_ALIAS", XB_TIPO, XB_SEQ, XB_COLUNA	, XB_DESCRI"				, "XB_DESCSPA"			, "XB_DESCENG"			, "XB_CONTEM"		, "XB_WCONTEM"	}
aAdd( aCampos, { "TFGP01" , "1" , "01" , "DB" , "Fornecedor As.Medica" , "Fornecedor As.Medica" , "Fornecedor As.Medica" , "RCC" , "" } )
aAdd( aCampos, { "TFGP01" , "2" , "01" , "01" , "Codigo + Filial + Me" , "Codigo + Sucursal +" , "Code + Branch + Mont" , "" , "" } )
aAdd( aCampos, { "TFGP01" , "4" , "01" , "01" , "Codigo Fornecedor AM" , "Codigo Fornecedor AM" , "Codigo Fornecedor AM" , "substr(RCC_CONTEU,1,3)" , "" } )
aAdd( aCampos, { "TFGP01" , "4" , "01" , "02" , "Nome Fornecedor" , "Nome Fornecedor" , "Nome Fornecedor" , "substr(RCC_CONTEU,4,150)" , "" } )
aAdd( aCampos, { "TFGP01" , "5" , "01" , "" , "" , "" , "" , "LEFT(RCC->RCC_CONTEU,3)" , "" } )
aAdd( aCampos, { "TFGP01" , "6" , "01" , "" , "" , "" , "" , 'RCC->RCC_CODIGO == "S016"' , "" } )

SXB->( DbSetorder( 1 ) )
If !SXB->( dbSeek( "TFGP01" ) )
	
	For nX := 1 To Len( aCampos )
		SXB->( Reclock("SXB", .T. ) )
		SXB->XB_ALIAS	:= aCampos[ nX, 1 ]
		SXB->XB_TIPO	:= aCampos[ nX, 2 ]
		SXB->XB_SEQ		:= aCampos[ nX, 3 ]
		SXB->XB_COLUNA	:= aCampos[ nX, 4 ]
		SXB->XB_DESCRI	:= aCampos[ nX, 5 ]
		SXB->XB_DESCSPA	:= aCampos[ nX, 6 ]
		SXB->XB_DESCENG	:= aCampos[ nX, 7 ]
		SXB->XB_CONTEM	:= aCampos[ nX, 8 ]
		SXB->XB_WCONTEM	:= aCampos[ nX, 9 ]
		SXB->( MsUnlock() )
	Next nX
Endif

RestARea( _aArea )

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ fLayOut3 บAutor  ณRicardo Duarte Costaบ Data ณ  24/03/2014 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Processa o layout antigo da Unimed Paulistana              บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function fLayOut3()

Local nTetoCopart	:= ftabela("U007",1,4)
Local nx			:= 0
If valtype(nTetoCopart) <> "N"
	nTetoCopart	:= 80.00
Endif

	//-- Total agrupado por usuแrio
	cQuery := " SELECT RA_FILIAL, RA_MAT, RA_COD, NOMETITULAR, NOMEUSUARIO, EMPRESA, FATURA, NOME, CPF, CARTEIRINHA, TITULAR, USUARIO, CERTIFICADO, SEQUENCIA, CARTEIRAUSU, SUM(VALORCP) VALORCP, RA_SITFOLH, RA_RESCRAI, RA_CATFUNC, RA_CODFUNC"
	cQuery += " FROM ("

	//-- Titulares Carteirinha RA_XCRTATU
	cQuery += " SELECT C.RA_FILIAL, C.RA_MAT, '00' RA_COD, C.RA_NOME NOMETITULAR, C.RA_NOME NOMEUSUARIO, A.CP1O02 EMPRESA, A.CP1O13 FATURA, A.CP1O05 NOME, A.CP1O06 CPF, A.CP1O08 CARTEIRINHA, SUBSTRING(A.CP1O08,7,6) TITULAR, B.CP2O04 USUARIO, B.CP2O17 CERTIFICADO, B.CP2O03 SEQUENCIA, B.CP2O17||B.CP2O03 CARTEIRAUSU, B.CP2O02 DATA, B.CP2O12 VALORCP, C.RA_SITFOLH, C.RA_RESCRAI, C.RA_CATFUNC, C.RA_CODFUNC
	cQuery += " FROM "+cNomeTab+" A
	cQuery += " INNER JOIN "+cNomeTab+" B ON B.D_E_L_E_T_ = ' ' AND SUBSTRING(A.CP1O08,7,6) = SUBSTRING(B.CP2O17,2,6) AND B.TIPOREG = '2'
	cQuery += " INNER JOIN "+RetSqlName( "SRA" ) + " C ON C.D_E_L_E_T_ = ' '  AND SUBSTRING(C.RA_XCRTATU,7,8) = SUBSTRING(B.CP2O17,2,6)||B.CP2O03 
	cQuery += " WHERE
	cQuery += " A.TIPOREG = '1'
	//-- Dependentes Carteirinha RB_XCRTATU
	cQuery += " UNION ALL
	cQuery += " SELECT C.RB_FILIAL RA_FILIAL, C.RB_MAT RA_MAT, C.RB_COD RA_COD, D.RA_NOME NOMETITULAR, C.RB_NOME NOMEUSUARIO, A.CP1O02 EMPRESA, A.CP1O13 FATURA, A.CP1O05 NOME, A.CP1O06 CPF, A.CP1O08 CARTEIRINHA, SUBSTRING(A.CP1O08,7,6) TITULAR, B.CP2O04 USUARIO, B.CP2O17 CERTIFICADO, B.CP2O03 SEQUENCIA, B.CP2O17||B.CP2O03 CARTEIRAUSU, B.CP2O02 DATA, B.CP2O12 VALORCP, D.RA_SITFOLH, D.RA_RESCRAI, D.RA_CATFUNC, D.RA_CODFUNC
	cQuery += " FROM "+cNomeTab+" A
	cQuery += " INNER JOIN "+cNomeTab+" B ON B.D_E_L_E_T_ = ' ' AND SUBSTRING(A.CP1O08,7,6) = SUBSTRING(B.CP2O17,2,6) AND B.TIPOREG = '2'
	cQuery += " INNER JOIN "+RetSqlName( "SRB" ) + " C ON C.D_E_L_E_T_ = ' '  AND SUBSTRING(C.RB_XCRTATU,7,8) = SUBSTRING(B.CP2O17,2,6)||B.CP2O03 
	cQuery += " INNER JOIN "+RetSqlName( "SRA" ) + " D ON D.D_E_L_E_T_ = ' '  AND RA_FILIAL = RB_FILIAL AND RA_MAT = RB_MAT
	cQuery += " WHERE
	cQuery += " A.TIPOREG = '1'
	//-- Titulares Carteirinha RA_XCRTANT
	cQuery += " UNION ALL
	cQuery += " SELECT C.RA_FILIAL, C.RA_MAT, '00' RA_COD, C.RA_NOME NOMETITULAR, C.RA_NOME NOMEUSUARIO, A.CP1O02 EMPRESA, A.CP1O13 FATURA, A.CP1O05 NOME, A.CP1O06 CPF, A.CP1O08 CARTEIRINHA, SUBSTRING(A.CP1O08,7,6) TITULAR, B.CP2O04 USUARIO, B.CP2O17 CERTIFICADO, B.CP2O03 SEQUENCIA, B.CP2O17||B.CP2O03 CARTEIRAUSU, B.CP2O02 DATA, B.CP2O12 VALORCP, C.RA_SITFOLH, C.RA_RESCRAI, C.RA_CATFUNC, C.RA_CODFUNC
	cQuery += " FROM "+cNomeTab+" A
	cQuery += " INNER JOIN "+cNomeTab+" B ON B.D_E_L_E_T_ = ' ' AND SUBSTRING(A.CP1O08,7,6) = SUBSTRING(B.CP2O17,2,6) AND B.TIPOREG = '2'
	cQuery += " INNER JOIN "+RetSqlName( "SRA" ) + " C ON C.D_E_L_E_T_ = ' '  AND SUBSTRING(C.RA_XCRTANT,7,8) = SUBSTRING(B.CP2O17,2,6)||B.CP2O03 
	cQuery += " WHERE
	cQuery += " A.TIPOREG = '1'
	//-- Dependentes Carteirinha RB_XCRTANT
	cQuery += " UNION ALL
	cQuery += " SELECT C.RB_FILIAL RA_FILIAL, C.RB_MAT RA_MAT, C.RB_COD RA_COD, D.RA_NOME NOMETITULAR, C.RB_NOME NOMEUSUARIO, A.CP1O02 EMPRESA, A.CP1O13 FATURA, A.CP1O05 NOME, A.CP1O06 CPF, A.CP1O08 CARTEIRINHA, SUBSTRING(A.CP1O08,7,6) TITULAR, B.CP2O04 USUARIO, B.CP2O17 CERTIFICADO, B.CP2O03 SEQUENCIA, B.CP2O17||B.CP2O03 CARTEIRAUSU, B.CP2O02 DATA, B.CP2O12 VALORCP, D.RA_SITFOLH, D.RA_RESCRAI, D.RA_CATFUNC, D.RA_CODFUNC
	cQuery += " FROM "+cNomeTab+" A
	cQuery += " INNER JOIN "+cNomeTab+" B ON B.D_E_L_E_T_ = ' ' AND SUBSTRING(A.CP1O08,7,6) = SUBSTRING(B.CP2O17,2,6) AND B.TIPOREG = '2'
	cQuery += " INNER JOIN "+RetSqlName( "SRB" ) + " C ON C.D_E_L_E_T_ = ' '  AND SUBSTRING(C.RB_XCRTANT,7,8) = SUBSTRING(B.CP2O17,2,6)||B.CP2O03 
	cQuery += " INNER JOIN "+RetSqlName( "SRA" ) + " D ON D.D_E_L_E_T_ = ' '  AND RA_FILIAL = RB_FILIAL AND RA_MAT = RB_MAT
	cQuery += " WHERE
	cQuery += " A.TIPOREG = '1'

	cQuery += " ) TMP
	cQuery += " GROUP BY TMP.RA_FILIAL, TMP.RA_MAT, TMP.RA_COD, TMP.NOMETITULAR, TMP.NOMEUSUARIO, TMP.EMPRESA, TMP.FATURA, TMP.NOME, TMP.CPF, TMP.CARTEIRINHA, TMP.TITULAR, TMP.USUARIO, TMP.CERTIFICADO, TMP.SEQUENCIA, TMP.CARTEIRAUSU, TMP.RA_SITFOLH, TMP.RA_RESCRAI, TMP.RA_CATFUNC, TMP.RA_CODFUNC

	cQueryTot := ChangeQuery(cQuery)
    TCQuery cQueryTot New Alias "COPART"
    
	//-- Totaliza o valor de coparticipa็ใo para determinar 
	//-- o n๚mero de parcelas a ser concedido a cada funcionแrio
	
	//-- Inicializa log de registros importados
	Aadd(aLog,{})
	Aadd(aLog,{})
	Aadd(aTitle,"TFGPM001 - Importa็ใo do rateio de co-participa็ใo de assist๊ncia m้dica")
	Aadd(aLog[1],"Registros importados:")
	Aadd(aLog[1],"=====================")
	Aadd(aLog[1],"Usuแrio Titular Empresa Fatura Carteirinha Carteirinha Usuario Filial Matricula Nome Usuแrio Sequencia Situa็ใo Folha Tipo Rescisใo")

	//-- Grava a distribuicao da co-participacao nas tabelas de movimento.
	While COPART->(!eof())
		IncProc()

		//-- Tratamento do Log de Funcionแrios Demitidos/Transferidos
		If COPART->RA_SITFOLH == "D"

			If Len(aLog[2]) == 0
				Aadd(aLog[2],"Registros nใo importados:")
				Aadd(aLog[2],"=====================")
				Aadd(aLog[2],"Usuแrio Funcionแrio Empresa Fatura Certificado Carteirinha Usuario Filial  Matricula Nome Titular Nome Usuแrio Sequencia Situacao Codigo Rescisใo Valor CoParticipacao")
				Aadd(aXlsExp,"Usuแrio; Funcionแrio; Empresa; Fatura; Certificado; Carteirinha; Usuario; Filial;  Matricula; Nome Titular; Nome Usuแrio; Sequencia; Situacao; Codigo Rescisใo; Valor CoParticipacao"+CRLF)

			Endif

			//-- Alimenta o log de processamento da rotina
			Aadd(aLog[2],	;
							COPART->NOMEUSUARIO + " - " +;
							COPART->NOMETITULAR + " - " +;
							COPART->EMPRESA + " - " +;
							COPART->FATURA + " - " +;
							COPART->CARTEIRINHA + " - " +;
							COPART->CARTEIRAUSU + " - " +;
							COPART->RA_FILIAL + " - " +;
							COPART->RA_MAT + " - " +;
							COPART->NOME + " - " +;
							COPART->USUARIO + " - " +;
							COPART->SEQUENCIA + " - " +;
							COPART->RA_SITFOLH + " - " +;
							COPART->RA_RESCRAI + " - " +;
							Transform(COPART->VALORCP,"@E 99,999,999.99") )
			nTotNImp	+= COPART->VALORCP

			//-- Grava็ใo de Excel
			Aadd(aXlsExp,	If(COPART->RA_RESCRAI$"30,31","Transferido Nใo Importado","Demitido Nใo importado")+";"+;
							COPART->NOMEUSUARIO+";"+;
							COPART->NOMETITULAR+";"+;
							COPART->EMPRESA+";"+;
							COPART->FATURA+";"+;
							COPART->CARTEIRINHA+";"+;
							COPART->CARTEIRAUSU+";"+;
							COPART->RA_FILIAL+";"+;
							COPART->RA_MAT+";"+;
							COPART->NOME+";"+;
							COPART->USUARIO+";"+;
							COPART->SEQUENCIA+";"+;
							COPART->RA_SITFOLH+";"+;
							COPART->RA_RESCRAI+";"+;
							Transform(COPART->VALORCP,"@E 99,999,999.99")+CRLF)
			//-- Proximo registro
			COPART->(DbSkip())
			Loop
		Endif

		//-- Verificar se o funcionแrio ้ aprendiz ou estagiแrio.
		lAprendEstag	:= ( COPART->RA_CATFUNC $"EG" ) .Or. ( Posicione("SRJ",1,xFilial("SRJ",COPART->RA_FILIAL)+COPART->RA_CODFUNC,"RJ_CARGO") == "00276" )

		//-- Grava็ใo da informa็ใo no movimento mensal de plano de sa๚de "RHO"
		For nx := 1 to nParcela
			//-- Acrescenta um m๊s a compet๊ncia a ser importada.
			If nx <> 1
				cMesAnoAux	:= AnoMes(MonthSum( stod(cMesAnoAux+"01") , 1 ))
			Else
				cMesAnoAux	:= cMesAno
			Endif
			//-- ํndice 2 - RHO_FILIAL+RHO_MAT+DTOS(RHO_DTOCOR)+RHO_TPFORN+RHO_CODFOR+RHO_ORIGEM+RHO_CODIGO+RHO_PD+RHO_COMPPG
			cChave_	:= COPART->(RA_FILIAL+RA_MAT+cMesAnoAux+"01"+"1"+cCodForn+If(Val(COPART->RA_COD)==0,"1","2")+If(Val(COPART->RA_COD)==0,"  ",COPART->RA_COD)+U_fVerbQry(COPART->RA_COD,"2")+cMesAnoAux)
			lNovoReg	:= !RHO->(DbSeek(cChave_))
			RecLock("RHO",lNovoReg)
			RHO->RHO_FILIAL		:= COPART->RA_FILIAL
			RHO->RHO_MAT		:= COPART->RA_MAT
			RHO->RHO_DTOCOR		:= stod(cMesAnoAux+"01")
			RHO->RHO_ORIGEM		:= If(Val(COPART->RA_COD)==0,"1","2")
			RHO->RHO_TPFORN		:= "1"
			RHO->RHO_CODFOR		:= cCodForn		//-- Fixado o c๓digo da Unimed
			RHO->RHO_CODIGO		:= If(Val(COPART->RA_COD)==0,"  ",COPART->RA_COD)
			RHO->RHO_TPLAN		:= "1"
			RHO->RHO_PD			:= U_fVerbQry(COPART->RA_COD,"2")
			RHO->RHO_VLRFUN		:= If(lAprendEstag,0.00,Min(COPART->VALORCP + If(lRegrava,0,RHO->RHO_VLRFUN),nTetoCopart))
			RHO->RHO_VLREMP		:= If(lAprendEstag,COPART->VALORCP,If((COPART->VALORCP + If(lRegrava,0,RHO->RHO_VLRFUN)) > nTetoCopart,COPART->VALORCP + If(lRegrava,0,RHO->RHO_VLRFUN)-nTetoCopart,0))
			RHO->RHO_COMPPG		:= cMesAnoAux
			RHO->(MsUnLock())

			//-- Alimenta o log de processamento da rotina
			Aadd(aLog[1],	;
						COPART->NOMEUSUARIO + " - " +;
						COPART->NOMETITULAR + " - " +;
						COPART->EMPRESA + " - " +;
						COPART->FATURA + " - " +;
						COPART->CARTEIRINHA + " - " +;
						COPART->CARTEIRAUSU + " - " +;
						COPART->RA_FILIAL + " - " +;
						COPART->RA_MAT + " - " +;
						COPART->NOME + " - " +;
						COPART->USUARIO + " - " +;
						COPART->SEQUENCIA + " - " +;
						COPART->RA_SITFOLH + " - " +;
						COPART->RA_RESCRAI + " - " +;
						Transform(COPART->VALORCP,"@E 99,999,999.99") + " - "+;
						Transform(If(lAprendEstag,0.00,Min(COPART->VALORCP + If(lRegrava,0,RHO->RHO_VLRFUN),nTetoCopart)),"@E 99,999,999.99") + " - "+;
						Transform(If(lAprendEstag,COPART->VALORCP,If((COPART->VALORCP + If(lRegrava,0,RHO->RHO_VLRFUN)) > nTetoCopart,COPART->VALORCP + If(lRegrava,0,RHO->RHO_VLRFUN)-nTetoCopart,0)),"@E 99,999,999.99") )
			nTotImp	+= COPART->VALORCP
			//-- Grava็ใo de Excel
			Aadd(aXlsExp,	"Importado"+";"+;
						COPART->NOMEUSUARIO+";"+;
						COPART->NOMETITULAR+";"+;
						COPART->EMPRESA+";"+;
						COPART->FATURA+";"+;
						COPART->CARTEIRINHA+";"+;
						COPART->CARTEIRAUSU+";"+;
						COPART->RA_FILIAL+";"+;
						COPART->RA_MAT+";"+;
						COPART->NOME+";"+;
						COPART->USUARIO+";"+;
						COPART->SEQUENCIA+";"+;
						COPART->RA_SITFOLH+";"+;
						COPART->RA_RESCRAI+";"+;
						Transform(COPART->VALORCP,"@E 99,999,999.99")+";"+;
						Transform(If(lAprendEstag,0.00,Min(COPART->VALORCP + If(lRegrava,0,RHO->RHO_VLRFUN),nTetoCopart)),"@E 99,999,999.99")+";"+;
						Transform(If(lAprendEstag,COPART->VALORCP,If((COPART->VALORCP + If(lRegrava,0,RHO->RHO_VLRFUN)) > nTetoCopart,COPART->VALORCP + If(lRegrava,0,RHO->RHO_VLRFUN)-nTetoCopart,0)),"@E 99,999,999.99")+CRLF)
		Next nx

		//-- Proximo registro
		COPART->(DbSkip())
	Enddo
	//-- Acrescenta informa็ใo de total importado
	If Len(aLog) > 0
		Aadd(aLog[1], Right(space(91)+"Total importado:     ",91)+Transform(nTotImp,"@E 99,999,999.99") )
	Endif

	//-- Fecha a tabela de co-participa็ใo
	COPART->(DbCloseArea())

	//-- Verifica registros nใo importados
	cQuery := " SELECT *
	cQuery += " FROM "+cNomeTab+" A"
	cQuery += " WHERE"
	cQuery += " ( NOT EXISTS(SELECT 1 FROM "+RetSqlName( "SRA" ) + " WHERE D_E_L_E_T_ = ' ' AND (SUBSTRING(RA_XCRTATU,7,8) = SUBSTRING(A.CP2O17,2,6)||A.CP2O03  OR SUBSTRING(RA_XCRTANT,7,8) = SUBSTRING(A.CP2O17,2,6)||A.CP2O03 ))"
	cQuery += " AND NOT EXISTS(SELECT 1 FROM "+RetSqlName( "SRB" ) + " WHERE D_E_L_E_T_ = ' ' AND (SUBSTRING(RB_XCRTATU,7,8) = SUBSTRING(A.CP2O17,2,6)||A.CP2O03  OR SUBSTRING(RB_XCRTANT,7,8) = SUBSTRING(A.CP2O17,2,6)||A.CP2O03)) )"
	cQuery += " ORDER BY A.R_E_C_N_O_"
	cQuery := ChangeQuery(cQuery)
    TCQuery cQuery New Alias "COPART"
    If COPART->(!eof())
		Aadd(aLog[2],"Registros nใo importados:")
		Aadd(aLog[2],"=========================")
		Aadd(aLog[2],"Unimed Filial  Dependente                       Titular                          CPF           Carteirinha                 Valor")
	Endif
	//-- Gera o Log de importa็ใo.
	While COPART->(!eof())
		If COPART->TIPOREG == "2"
			Aadd(aLog[2],	;
						COPART->CP2O04 + " - " +;
						COPART->CP2O03 + " - " +;
						COPART->CP2O05 + " - " +;
						Transform(COPART->CP2O12,"@99,999,999.99") + " - " +;
						COPART->CP2O14 + " - " +;
						COPART->CP2O15 + " - " +;
						COPART->CP2O16 + " - " +;
						COPART->CP2O17 + " - " +;
						COPART->CP2O18 + " - " +;
						COPART->CP2O19 )
			nTotNImp	+= COPART->CP2O12

			//-- Grava็ใo de Excel
			Aadd(aXlsExp,	"Nใo importado"+";"+;
						COPART->CP2O04 + ";" +;
						COPART->CP2O03 + ";" +;
						COPART->CP2O05 + ";" +;
						Transform(COPART->CP2O12,"@99,999,999.99") + ";" +;
						COPART->CP2O14 + ";" +;
						COPART->CP2O15 + ";" +;
						COPART->CP2O16 + ";" +;
						COPART->CP2O17 + ";" +;
						COPART->CP2O18 + ";" +;
						COPART->CP2O19 +CRLF)
			//-- Proximo registro
			COPART->(DbSkip())
		Endif
	Enddo
	
Return

