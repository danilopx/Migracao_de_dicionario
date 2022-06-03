#INCLUDE "Protheus.ch"
#INCLUDE "Topconn.ch"
#INCLUDE "TBICONN.ch"
#INCLUDE "REPORT.CH"   		

#DEFINE LINHAS 999
#DEFINE USADO CHR(0)+CHR(0)+CHR(1)

//---------------------------------------------------------------------------------------------------------------------------
// Programa: TFCMPR01 																					Autor: C. Torres        Data: 03/08/2011 
// Descricao: Relatario Follow-UP
//---------------------------------------------------------------------------------------------------------------------------
User Function TFCMPR01()
                       
Private cAliasTrb	:= "TMPCM01" // GetNextAlias()
Private cPerg     := 'TFCMPR01'
Private cString	:= 'Query'                                     
Private oReport

// AjustaSx1( cPerg ) // Chama funcao de pergunta
If SM0->M0_CODIGO='01'
	If pergunte(cPerg,.T.)
 			
		Processa( {|lEnd| U_CMPTExcel1(@lEnd) } ,  'Follow-Up da SC' , 'Aguarde, preparando planilha...' , .T. )
		
	EndIf
Else
	Aviso("Modulo não disponivel", "Modulo não disponivel para a empresa selecionada.", {"Ok"}, 3)
EndIF     
Return
  

//--------------------------------------------------------------------------------------------------------------
// Função: TExcel1 - Exportação para Excel
//--------------------------------------------------------------------------------------------------------------
User Function CMPTExcel1(lEnd)
 
Local __aHeader := {}
Local __aCols   := {}
Local __cNomEmitente := ""

aResult := {}
If TCSPExist("SP_REL_CMP_MAPA_SC")


	If !empty(mv_par05)
		__cNomEmitente := USRRETNAME(mv_par05)
	EndIf
	If SM0->M0_CODIGO='01'

		aResult := TCSPEXEC("SP_REL_CMP_MAPA_SC", mv_par01, mv_par02, Dtos(mv_par03), Dtos(mv_par04), __cNomEmitente, mv_par06, DTOS(ddatabase)+SUBSTR(TIME(),1,2)+SUBSTR(TIME(),4,2) )

			/*
				Parametros da procedure SP_REL_CMP_MAPA_SC
				@CFILIALINI		VARCHAR(2),
				@CFILIALFIN		VARCHAR(2),
				@DEMISSAOINI	VARCHAR(10),
				@DEMISSAOFIN	VARCHAR(10),
				@CEMITENTE		VARCHAR(25),
				@CSEQMRP			VARCHAR(6)
			*/
	EndIf
		
	If Select( (cAliasTrb) ) > 0
		dbSelectArea( (cAliasTrb) )
		DbCloseArea()
	EndIf

	TCQUERY _cQuery NEW ALIAS "TMPCM01"

	TCSetField("TMPCM01","C1_DATPRF"	,"D") 	// Dt. necessidade
	TCSetField("TMPCM01","C1_EMISSAO","D") 	// Dt. emissao
	TCSetField("TMPCM01","C1_DTVALID","D") 	// Dt. validade
	TCSetField("TMPCM01","C7_DATPRF"	,"D") 	// Dt. Entrega
	TCSetField("TMPCM01","C7_EMISSAO","D") 	// Dt. emissao

EndIf
dbSelectArea( (cAliasTrb) )

ProcRegua( (cAliasTrb)->(reccount()) )

 
If !ApOleClient("MSExcel")
 	MsgAlert("Microsoft Excel não instalado!")
	Return
EndIf
aTam := TamSX3('C1_OK'	  		); Aadd(__aHeader, {'2o. Forn.'		, 'C1_OK'		, PesqPict('SC1', 'C1_OK'		, aTam[1])	,	aTam[1], aTam[2], ''	, USADO, 'C', '', ''}) 
aTam := TamSX3('C1_NUM'	  		); Aadd(__aHeader, {'Numero da SC'	, 'C1_NUMSC'	, PesqPict('SC1', 'C1_NUM'		, aTam[1])	,	aTam[1], aTam[2], ''	, USADO, 'C', '', ''}) 
aTam := TamSX3('C1_ITEM'		); Aadd(__aHeader, {'Item da SC'		, 'C1_ITEMSC'	, PesqPict('SC1', 'C1_ITEM'	, aTam[1])	,	aTam[1], aTam[2], ''	, USADO, 'C', '', ''}) 
aTam := TamSX3('C1_PRODUTO'	); Aadd(__aHeader, {'Produto'			, 'C1_PRODUTO'	, PesqPict('SC1', 'C1_PRODUTO', aTam[1])	,	aTam[1], aTam[2], ''	, USADO, 'C', '', ''}) 
aTam := TamSX3('B1_DESC'		); Aadd(__aHeader, {'Descricao'		, 'B1_DESC'		, PesqPict('SB1', 'B1_DESC'	, aTam[1])	,	aTam[1], aTam[2], ''	, USADO, 'C', '', ''}) 
aTam := TamSX3('C1_CLASCON'	); Aadd(__aHeader, {'Finalidade'		, 'C1_CLASCON'	, PesqPict('SC1', 'C1_CLASCON', aTam[1])	,	aTam[1], aTam[2], ''	, USADO, 'C', '', ''}) 
aTam := TamSX3('C1_LOCAL'		); Aadd(__aHeader, {'Armazem'			, 'C1_LOCAL'	, PesqPict('SC1', 'C1_LOCAL'	, aTam[1])	,	aTam[1], aTam[2], ''	, USADO, 'C', '', ''}) 
aTam := TamSX3('C1_QUANT'		); Aadd(__aHeader, {'Qtd. 1a UM'		, 'C1_QUANTSC'	, PesqPict('SC1', 'C1_QUANT'	, aTam[1])	,	aTam[1], aTam[2], ''	, USADO, 'N', '', ''}) 
aTam := TamSX3('C1_UM'			); Aadd(__aHeader, {'1a UM'			, 'C1_UM'		, PesqPict('SC1', 'C1_UM'		, aTam[1])	,	aTam[1], aTam[2], ''	, USADO, 'C', '', ''}) 
aTam := TamSX3('C1_DTVALID'	); Aadd(__aHeader, {'Dt.Limite'		, 'C1_DTVALID'	, PesqPict('SC1', 'C1_DTVALID', aTam[1])	,	aTam[1], aTam[2], ''	, USADO, 'C', '', ''}) 
aTam := TamSX3('C1_EMISSAO'	); Aadd(__aHeader, {'DT Emissao'		, 'C1_EMISSAO'	, PesqPict('SC1', 'C1_EMISSAO', aTam[1])	,	aTam[1], aTam[2], ''	, USADO, 'C', '', ''}) 
aTam := TamSX3('C1_DATPRF'		); Aadd(__aHeader, {'Necessidade'	, 'C1_DATPRF'	, PesqPict('SC1', 'C1_DATPRF'	, aTam[1])	,	aTam[1], aTam[2], ''	, USADO, 'C', '', ''}) 
aTam := TamSX3('C1_OP'			); Aadd(__aHeader, {'Ord Producao'	, 'C1_OP'		, PesqPict('SC1', 'C1_OP'		, aTam[1])	,	aTam[1], aTam[2], ''	, USADO, 'C', '', ''}) 
aTam := TamSX3('C1_TPOP'		); Aadd(__aHeader, {'Status OP'		, 'C1_TPOP'		, PesqPict('SC1', 'C1_TPOP'	, aTam[1])	,	aTam[1], aTam[2], ''	, USADO, 'C', '', ''}) 
aTam := TamSX3('C1_SEQMRP'		); Aadd(__aHeader, {'Seq MRP'			, 'C1_SEQMRP'	, PesqPict('SC1', 'C1_SEQMRP'	, aTam[1])	,	aTam[1], aTam[2], ''	, USADO, 'C', '', ''}) 
aTam := TamSX3('C1_SOLICIT'	); Aadd(__aHeader, {'Solicitante'	, 'C1_SOLICIT'	, PesqPict('SC1', 'C1_SOLICIT', aTam[1])	,	aTam[1], aTam[2], ''	, USADO, 'C', '', ''}) 
aTam := TamSX3('C1_APROV'		); Aadd(__aHeader, {'Flag Aprov.'	, 'C1_APROV'	, PesqPict('SC1', 'C1_APROV'	, aTam[1])	,	aTam[1], aTam[2], ''	, USADO, 'C', '', ''}) 
aTam := TamSX3('C1_RESIDUO'	); Aadd(__aHeader, {'Elim.Residuo'	, 'C1_RESIDUO'	, PesqPict('SC1', 'C1_RESIDUO', aTam[1])	,	aTam[1], aTam[2], ''	, USADO, 'C', '', ''}) 
aTam := TamSX3('C1_FILIAL'		); Aadd(__aHeader, {'Filial'			, 'C1_FILIAL'	, PesqPict('SC1', 'C1_FILIAL'	, aTam[1])	,	aTam[1], aTam[2], ''	, USADO, 'C', '', ''}) 
aTam := TamSX3('C1_OBS'			); Aadd(__aHeader, {'Observacao'		, 'C1_OBS'		, PesqPict('SC1', 'C1_OBS'		, aTam[1])	,	aTam[1], aTam[2], ''	, USADO, 'C', '', ''}) 
aTam := TamSX3('C7_NUM'	  		); Aadd(__aHeader, {'Numero PC'		, 'C7_NUM' 		, PesqPict('SC7', 'C7_NUM'		, aTam[1])	,	aTam[1], aTam[2], ''	, USADO, 'C', '', ''}) 
aTam := TamSX3('C7_ITEM'	  	); Aadd(__aHeader, {'Item'				, 'C7_ITEM'		, PesqPict('SC7', 'C7_ITEM'	, aTam[1])	,	aTam[1], aTam[2], ''	, USADO, 'C', '', ''}) 
aTam := TamSX3('C7_EMISSAO'	); Aadd(__aHeader, {'DT Emissao'		, 'C7_EMISSAO'	, PesqPict('SC7', 'C7_EMISSAO', aTam[1])	,	aTam[1], aTam[2], ''	, USADO, 'C', '', ''}) 
aTam := TamSX3('C7_DATPRF'		); Aadd(__aHeader, {'Dt. Entrega'	, 'C7_DATPRF'	, PesqPict('SC7', 'C7_DATPRF'	, aTam[1])	,	aTam[1], aTam[2], ''	, USADO, 'C', '', ''}) 
aTam := TamSX3('C7_TIPO'		); Aadd(__aHeader, {'Tipo'				, 'C7_TIPO'		, PesqPict('SC7', 'C7_TIPO'	, aTam[1])	,	aTam[1], aTam[2], ''	, USADO, 'C', '', ''}) 
aTam := TamSX3('C7_UM'			); Aadd(__aHeader, {'1a UM'			, 'C7_UM'		, PesqPict('SC7', 'C7_UM'		, aTam[1])	,	aTam[1], aTam[2], ''	, USADO, 'C', '', ''}) 
aTam := TamSX3('C7_QUANT'		); Aadd(__aHeader, {'Qtd. 1a UM'		, 'C7_QTPED'	, PesqPict('SC7', 'C7_QUANT'	, aTam[1])	,	aTam[1], aTam[2], ''	, USADO, 'N', '', ''}) 
aTam := TamSX3('C7_QUJE'		); Aadd(__aHeader, {'Qtd.Entregue'	, 'C7_QUJE'		, PesqPict('SC7', 'C7_QUJE'	, aTam[1])	,	aTam[1], aTam[2], ''	, USADO, 'N', '', ''}) 
aTam := TamSX3('C7_PRECO'		); Aadd(__aHeader, {'Prc Unitario'	, 'C7_PRECO'	, PesqPict('SC7', 'C7_PRECO'	, aTam[1])	,	aTam[1], aTam[2], ''	, USADO, 'N', '', ''}) 
aTam := TamSX3('C7_RESIDUO'	); Aadd(__aHeader, {'Resid. Elim.'	, 'C7_RESIDUO'	, PesqPict('SC7', 'C7_RESIDUO', aTam[1])	,	aTam[1], aTam[2], ''	, USADO, 'C', '', ''}) 
aTam := TamSX3('C7_ENCER'		); Aadd(__aHeader, {'Ped. Encerr.'	, 'C7_ENCER'	, PesqPict('SC7', 'C7_ENCER'	, aTam[1])	,	aTam[1], aTam[2], ''	, USADO, 'C', '', ''}) 
aTam := TamSX3('C7_USER'		); Aadd(__aHeader, {'Cod. Usuario'	, 'C7_USER'		, PesqPict('SC7', 'C7_USER'	, aTam[1])	,	aTam[1], aTam[2], ''	, USADO, 'C', '', ''}) 
aTam := TamSX3('C7_FORNECE'	); Aadd(__aHeader, {'Fornecedor'		, 'C7_FORNECE'	, PesqPict('SC7', 'C7_FORNECE', aTam[1])	,	aTam[1], aTam[2], ''	, USADO, 'C', '', ''}) 
aTam := TamSX3('C7_DESCFOR'	); Aadd(__aHeader, {'Nome Fornec.'	, 'C7_DESCFOR'	, PesqPict('SC7', 'C7_DESCFOR', aTam[1])	,	aTam[1], aTam[2], ''	, USADO, 'C', '', ''}) 
aTam := TamSX3('C7_SEGUM'		); Aadd(__aHeader, {'2a UM'			, 'C7_SEGUM'	, PesqPict('SC7', 'C7_SEGUM'	, aTam[1])	,	aTam[1], aTam[2], ''	, USADO, 'C', '', ''}) 
aTam := TamSX3('C7_QTSEGUM'	); Aadd(__aHeader, {'Qtd 2a UM'		, 'C7_QTSEGUM'	, PesqPict('SC7', 'C7_QTSEGUM', aTam[1])	,	aTam[1], aTam[2], ''	, USADO, 'N', '', ''}) 

While !(cAliasTrb)->(Eof())

	IncProc()	
   If lEnd
      MsgInfo(cCancela,"Fim")
      Exit
   Endif
	
	AAdd(  __aCols , { ;
							(cAliasTrb)->C1_OK		,;
							(cAliasTrb)->C1_NUMSC	,;
							(cAliasTrb)->C1_ITEMSC	,;
							(cAliasTrb)->C1_PRODUTO ,;
							(cAliasTrb)->B1_DESC		,;
							(cAliasTrb)->C1_CLASCON	,;
							(cAliasTrb)->C1_LOCAL	,;
							(cAliasTrb)->C1_QUANTSC	,;
							(cAliasTrb)->C1_UM		,;
							(cAliasTrb)->C1_DTVALID	,;
							(cAliasTrb)->C1_EMISSAO	,;
							(cAliasTrb)->C1_DATPRF	,;
							(cAliasTrb)->C1_OP		,;
							(cAliasTrb)->C1_TPOP		,;
							(cAliasTrb)->C1_SEQMRP	,;
							(cAliasTrb)->C1_SOLICIT	,;
							(cAliasTrb)->C1_APROV	,;
							(cAliasTrb)->C1_RESIDUO	,;
							(cAliasTrb)->C1_FILIAL	,;
							(cAliasTrb)->C1_OBS		,;
							(cAliasTrb)->C7_NUM		,;
							(cAliasTrb)->C7_ITEM		,;
							(cAliasTrb)->C7_EMISSAO	,;
							(cAliasTrb)->C7_DATPRF	,;
							(cAliasTrb)->C7_TIPO		,;
							(cAliasTrb)->C7_UM		,;
							(cAliasTrb)->C7_QTPED	,;
							(cAliasTrb)->C7_QUJE		,;
							(cAliasTrb)->C7_PRECO	,;
							(cAliasTrb)->C7_RESIDUO	,;
							(cAliasTrb)->C7_ENCER	,;
							USRRETNAME((cAliasTrb)->C7_USER)		,;		
							(cAliasTrb)->C7_FORNECE	,;
							(cAliasTrb)->C7_DESCFOR	,;
							(cAliasTrb)->C7_SEGUM	,;
							(cAliasTrb)->C7_QTSEGUM	,;
							 .F.})

	(cAliasTrb)->(dbSkip())
End
 
(cAliasTrb)->(dbCloseArea())

//Exclui a tabela temporaria do Banco de Dados
If TcCanOpen(aResult[1])
	TcSqlExec("DROP TABLE "+aResult[1])
EndIf

If len( __aCols ) > 0 .AND. .NOT. lEnd
	DlgToExcel({ {"GETDADOS", "Follow-Up de SC", __aHeader, __aCols} })
ElseIf .NOT. lEnd
	MsgAlert("Não há dados a exportar para o Excel!","")
EndIf

Return

//---------------------------------------------------------------------------------------------------------------------------
// Função: AjustaSX1 																						Autor: C. Torres  	Data: 03/08/2011
// Descricao: Monta perguntas no SX1.                                    
//---------------------------------------------------------------------------------------------------------------------------
/*
Static Function AjustaSx1(cPerg)

Local aAreaAnt := GetArea()
Local aHelpPor := {}
Local aHelpEng := {}
Local aHelpSpa := {} 


//---------------------------------------MV_PAR01-------------------------------------------------- OK
aHelpPor := {'Filial de?'}
aHelpEng := {''}
aHelpSpa := {''}

PutSx1(cPerg,"01","Filial de      ? ","","","mv_ch1","C",02,0,0,"G","","SM0",,,"MV_PAR01","","","","","","","","","","","","","","","","",{"Digite a Filial"},{},{},"")

//---------------------------------------MV_PAR02-------------------------------------------------- OK 
aHelpPor := {'Filial ate?'}
aHelpEng := {''}
aHelpSpa := {''}

PutSx1(cPerg,"02","Filial ate     ? ","","","mv_ch2","C",02,0,0,"G","","SM0",,,"MV_PAR02")

//---------------------------------------MV_PAR03-------------------------------------------------- OK
aHelpPor := {'Desde a entrega (data) ?'}
aHelpEng := {''}
aHelpSpa := {''}

PutSx1(cPerg,"03","Desde a entrega (data) ?     ","","","mv_ch3","D",08,0,0,"G","","",,,"MV_PAR03")

//---------------------------------------MV_PAR04-------------------------------------------------- OK
aHelpPor := {'Até a entrega (data)?'}
aHelpEng := {''}
aHelpSpa := {''}

PutSx1(cPerg,"04","Até a entrega (data)?    "   ,"","","mv_ch4","D",08,0,0,"G","","",,,"MV_PAR04")   

//---------------------------------------MV_PAR05-------------------------------------------------- OK
aHelpPor := {'Desde a necessidade (data)?'}
aHelpEng := {''}
aHelpSpa := {''}

PutSx1(cPerg,"05","Desde a necessidade (data)? ","","","mv_ch5","D",08,0,0,"G","","",,,"MV_PAR05")

//---------------------------------------MV_PAR06-------------------------------------------------- OK
aHelpPor := {'Até a necessidade (data)?'}
aHelpEng := {''}
aHelpSpa := {''}

PutSx1(cPerg,"06","Até a necessidade (data)? ","","","mv_ch6","D",08,0,0,"G","","",,,"MV_PAR06")                                                                                            

//---------------------------------------MV_PAR07-------------------------------------------------- OK
aHelpPor := {'Desde o produto?'}
aHelpEng := {''}
aHelpSpa := {''}

PutSx1(cPerg,"07","Do produto?     ","","","mv_ch07","C",09,0,0,"G","","SB1",,,"MV_PAR07")

//---------------------------------------MV_PAR08-------------------------------------------------- OK
aHelpPor := {'Até o produto?'}
aHelpEng := {''}
aHelpSpa := {''}

PutSx1(cPerg,"08","Até o produto?     ","","","mv_ch08","C",09,0,0,"G","","SB1",,,"MV_PAR08")
                                                                                                 
RestArea(aAreaAnt)

Return()
*/
