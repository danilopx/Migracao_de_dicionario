#Include "Protheus.ch"
#INCLUDE "Topconn.ch"
#INCLUDE "REPORT.CH"   		

#DEFINE LINHAS 999
#DEFINE USADO CHR(0)+CHR(0)+CHR(1)

//--------------------------------------------------------------------------------------------------------------
// PROGRAMA: PCPRELMAP                                     AUTOR: CARLOS TORRES                 DATA: 29/07/2011
// DESCRICAO: Gera planilha em Excel com mapa PCP
//--------------------------------------------------------------------------------------------------------------
User Function PCPRELMAP()
Local aParamBox	:= {}
Local aRet			:= {}
Local _dInicio		:= dDataBase
Local _dFinal		:= dDataBase

Private cCadastro := "Gera Excel PCP"
Private cString := ""

Aadd(aParamBox,{1,"Dt Inicio"	,_dInicio,"@R!","","","",50,.T.})
Aadd(aParamBox,{1,"Dt Fim"		,_dFinal	,"@R!","","","",50,.T.})

IF !ParamBox(aParamBox,"Informe os Parametros",@aRet)
	Return(.F.)
Endif
If !Empty( aRet[1] )
	U_PcpExcel1(  aRet[1] , aRet[2]  )
EndIf

Return Nil


User Function PcpExcel1( __dIni , __dFim )
 
Local aHeader := {}
Local aCols   := {}
Local _cQuery

Local ID_produto
Local NM_produto
Local DT_C2DATPRF
Local QT_C2QUANT
Local QT_D3LOCAL
Local QT_D3TERCE
Local QT_D7EXPED
Local DT_C2DTENTO 

If TCSPExist("SP_REL_PCP_MAPA_DIARIO")

	_cQuery := "EXEC SP_REL_PCP_MAPA_DIARIO '" + Dtos( __dIni ) + "', '"+ Dtos( __dFim ) + "', '" + cEmpAnt + "', '" + cFilAnt + "' "
	
	If Select("PCPSQL") > 0
		dbSelectArea("PCPSQL")
		DbCloseArea()
	EndIf

	TCQUERY _cQuery NEW ALIAS "PCPSQL"

	TCSetField("PCPSQL","C2_DATPRF"	,"D") 	
	TCSetField("PCPSQL","C2_DTENTOR"	,"D") 	

EndIf
 
If !ApOleClient("MSExcel")
 	MsgAlert("Microsoft Excel não instalado!")
	Return
EndIf

aTam := TamSX3('C2_PRODUTO'	); Aadd(aHeader, {'Produto'		, 'ID_PRODUTO'	, PesqPict('SC2', 'C2_PRODUTO', aTam[1])	,	aTam[1], aTam[2], ''	, ""	, 'C'	, ''	, ''}) 
aTam := TamSX3('B1_DESC'		); Aadd(aHeader, {'Descrição'		, 'NM_PRODUTO'	, PesqPict('SB1', 'B1_DESC'	, aTam[1])	,	aTam[1], aTam[2], ''	, ""	, 'C'	, ''	, ''}) 
aTam := TamSX3('C2_DATPRF'		); Aadd(aHeader, {'Data'			, 'DT_C2DATPRF', PesqPict('SC2', 'C2_DATPRF'	, aTam[1])	,	aTam[1], aTam[2], ''	, ""	, 'C'	, ''	, ''}) 
aTam := TamSX3('C2_DTENTOR'	); Aadd(aHeader, {'Prev.Original', 'DT_C2DTENTO', PesqPict('SC2', 'C2_DTENTOR', aTam[1])	,	aTam[1], aTam[2], ''	, ""	, 'C'	, ''	, ''}) 
aTam := TamSX3('C2_QUANT'		); Aadd(aHeader, {'Planejado'		, 'QT_C2QUANT'	, PesqPict('SC2', 'C2_QUANT'	, aTam[1])	,	aTam[1], aTam[2], ''	, ""	, 'C'	, ''	, ''}) 
aTam := TamSX3('D3_QUANT'		); Aadd(aHeader, {'Prod.Local'	, 'QT_D3LOCAL'	, PesqPict('SD3', 'D3_QUANT'	, aTam[1])	,	aTam[1], aTam[2], ''	, ""	, 'C'	, ''	, ''}) 
aTam := TamSX3('D3_QUANT'		); Aadd(aHeader, {'Prod.Terceiro', 'QT_D3TERCE'	, PesqPict('SD3', 'D3_QUANT'	, aTam[1])	,	aTam[1], aTam[2], ''	, ""	, 'C'	, ''	, ''}) 
aTam := TamSX3('D3_QUANT'		); Aadd(aHeader, {'Entrada Exped', 'QT_D7EXPED'	, PesqPict('SD3', 'D3_QUANT'	, aTam[1])	,	aTam[1], aTam[2], ''	, ""	, 'C'	, ''	, ''}) 


While !PCPSQL->(Eof())
	
	ID_produto 	:= PCPSQL->C2_PRODUTO
	NM_produto 	:= PCPSQL->B1_DESC
	DT_C2DATPRF	:= PCPSQL->C2_DATPRF
	QT_C2QUANT	:= PCPSQL->C2_QUANT
	QT_D3LOCAL	:= PCPSQL->D3_LOCAL
	QT_D3TERCE	:= PCPSQL->D3_TERCE
	QT_D7EXPED	:= PCPSQL->D7_EXPED
	DT_C2DTENTO := PCPSQL->C2_DTENTOR

	AAdd(aCols, {ID_produto, NM_produto, DT_C2DATPRF, DT_C2DTENTO, QT_C2QUANT, QT_D3LOCAL, QT_D3TERCE, QT_D7EXPED, .F.})
	
	PCPSQL->(DbSkip())
End

If len( aCols ) > 0 
	DlgToExcel({ {"GETDADOS", "Mapa PCP", aHeader, aCols} })
Else
	MsgAlert("Não há dados a exportar para o Excel!","")
EndIf

Return