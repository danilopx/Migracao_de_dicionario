#Include "Protheus.ch"
#INCLUDE "Topconn.ch"
#INCLUDE "REPORT.CH"   		

#DEFINE LINHAS 999
#DEFINE USADO CHR(0)+CHR(0)+CHR(1)

//--------------------------------------------------------------------------------------------------------------
// PROGRAMA: FATRELCOM                                     AUTOR: CARLOS TORRES                 DATA: 05/12/2011
// DESCRICAO: Gera planilha em Excel com comissoes 
//--------------------------------------------------------------------------------------------------------------
User Function FATRELCOM()
Local aParamBox	:= {}
Local aRet			:= {}
Local _dInicio		:= dDataBase
Local _dFinal		:= dDataBase
Local lUniNeg		:= cEmpAnt+cFilant $ GETNEWPAR('MV_UNINEG'/*cParametro*/, cEmpAnt+cFilant /*cPadrao*/, /*cFilial*/)
Local cUniNeg		:= Space(09)


Private cCadastro := "Gera Excel Comiss"
Private cString := ""

Aadd(aParamBox,{1,"Dt Inicio"	,_dInicio,"@R!","","","",50,.T.})
Aadd(aParamBox,{1,"Dt Fim"		,_dFinal	,"@R!","","","",50,.T.})
If lUniNeg
	Aadd(aParamBox,{1,"Unid. Neg"	,cUniNeg	,"@R!","","CTD","",50,.T.})
EndIF

IF !ParamBox(aParamBox,"Informe os Parametros",@aRet)
	Return(.F.)
Endif
If !Empty( aRet[1] )
	U_FatExcel1(  aRet[1] , aRet[2]  , IIF(lUniNeg,aRet[3],"") )
EndIf

Return Nil


User Function FatExcel1( __dIni , __dFim , __cUniNeg )
 
Local aHeader := {}
Local aCols   := {}

Local NM_REPRES	:= ""
Local VL_0101		:= 0
Local VL_0201		:= 0
Local VL_0202		:= 0
Local VL_0000		:= 0
Local VL_TOTAL		:= 0
Local VL_0301		:= 0
Local VL_0302U1	:= 0
Local VL_0302U2	:= 0
Local VL_0303U1	:= 0
Local VL_0303U2	:= 0

aResult := {}
If TCSPExist("SP_REL_COMISSAO_A_PAGAR")	
	aResult := TCSPEXEC("SP_REL_COMISSAO_A_PAGAR", Dtos( __dIni ), Dtos( __dFim ), DTOS(ddatabase)+SUBSTR(TIME(),1,2)+SUBSTR(TIME(),4,2) )
Endif
IF !Empty(aResult)
	If Select("FATSQL") > 0
		dbSelectArea("FATSQL")
		DbCloseArea()
	EndIf
	TCQuery "SELECT * FROM " + aResult[1] NEW ALIAS "FATSQL"
Else
	Final('Erro na execucao da Stored Procedure SP_REL_COMISSAO_A_PAGAR: '+TcSqlError())
EndIf 

If !ApOleClient("MSExcel")
 	MsgAlert("Microsoft Excel não instalado!")
	Return
EndIf

aTam := TamSX3('A3_COD'  		); Aadd(aHeader, {'Codigo Repre.', 'A3_NOME'		, PesqPict('SA3', 'A3_NOME'	, aTam[1])	,	aTam[1], aTam[2], ''	, ""	, 'C'	, ''	, ''}) 
aTam := TamSX3('A3_NOME'  		); Aadd(aHeader, {'Representante', 'A3_NOME'		, PesqPict('SA3', 'A3_NOME'	, aTam[1])	,	aTam[1], aTam[2], ''	, ""	, 'C'	, ''	, ''}) 
aTam := TamSX3('E3_COMIS'		); Aadd(aHeader, {'DAIHATSU'		, 'VL_EMP101'	, PesqPict('SE3', 'E3_COMIS'	, aTam[1])	,	aTam[1], aTam[2], ''	, ""	, 'C'	, ''	, ''}) 
aTam := TamSX3('E3_COMIS'		); Aadd(aHeader, {'MERCABEL SP'	, 'VL_EMP201'	, PesqPict('SE3', 'E3_COMIS'	, aTam[1])	,	aTam[1], aTam[2], ''	, ""	, 'C'	, ''	, ''}) 
aTam := TamSX3('E3_COMIS'		); Aadd(aHeader, {'MERCABEL GO'	, 'VL_EMP202'	, PesqPict('SE3', 'E3_COMIS'	, aTam[1])	,	aTam[1], aTam[2], ''	, ""	, 'C'	, ''	, ''}) 
aTam := TamSX3('E3_COMIS'		); Aadd(aHeader, {'TAIFF'			, 'VL_EMP000'	, PesqPict('SE3', 'E3_COMIS'	, aTam[1])	,	aTam[1], aTam[2], ''	, ""	, 'C'	, ''	, ''}) 
aTam := TamSX3('E3_COMIS'		); Aadd(aHeader, {'PROART'			, 'VL_EMP301'	, PesqPict('SE3', 'E3_COMIS'	, aTam[1])	,	aTam[1], aTam[2], ''	, ""	, 'C'	, ''	, ''}) 
aTam := TamSX3('E3_COMIS'		); Aadd(aHeader, {'TAIFFPROART EXTREMA - TAIFF'	, 'VL_UN1302'	, PesqPict('SE3', 'E3_COMIS'	, aTam[1])	,	aTam[1], aTam[2], ''	, ""	, 'C'	, ''	, ''}) 
aTam := TamSX3('E3_COMIS'		); Aadd(aHeader, {'TAIFFPROART EXTREMA - PROART', 'VL_UN2302'	, PesqPict('SE3', 'E3_COMIS'	, aTam[1])	,	aTam[1], aTam[2], ''	, ""	, 'C'	, ''	, ''}) 
aTam := TamSX3('E3_COMIS'		); Aadd(aHeader, {'TAIFFPROART BARUERI	- TAIFF'	, 'VL_UN1303'	, PesqPict('SE3', 'E3_COMIS'	, aTam[1])	,	aTam[1], aTam[2], ''	, ""	, 'C'	, ''	, ''}) 
aTam := TamSX3('E3_COMIS'		); Aadd(aHeader, {'TAIFFPROART BARUERI - PROART', 'VL_UN2303'	, PesqPict('SE3', 'E3_COMIS'	, aTam[1])	,	aTam[1], aTam[2], ''	, ""	, 'C'	, ''	, ''}) 
aTam := TamSX3('E3_COMIS'		); Aadd(aHeader, {'TAIFFPROART MATRIZ	- TAIFF'	, 'VL_UN1301'	, PesqPict('SE3', 'E3_COMIS'	, aTam[1])	,	aTam[1], aTam[2], ''	, ""	, 'C'	, ''	, ''}) 
aTam := TamSX3('E3_COMIS'		); Aadd(aHeader, {'TAIFFPROART MATRIZ - PROART', 'VL_UN2301'	, PesqPict('SE3', 'E3_COMIS'	, aTam[1])	,	aTam[1], aTam[2], ''	, ""	, 'C'	, ''	, ''}) 
aTam := TamSX3('E3_COMIS'		); Aadd(aHeader, {'TOTAL_GERAL'	, 'VL_TOTAL'	, PesqPict('SE3', 'E3_COMIS'	, aTam[1])	,	aTam[1], aTam[2], ''	, ""	, 'C'	, ''	, ''}) 
//aTam := TamSX3('E3_COMIS'		); Aadd(aHeader, {'BEAUTYFAIR'	, 'VL_EMP501'	, PesqPict('SE3', 'E3_COMIS'	, aTam[1])	,	aTam[1], aTam[2], ''	, ""	, 'C'	, ''	, ''}) 
//aTam := TamSX3('E3_COMIS'		); Aadd(aHeader, {'VIVABELEZA'	, 'VL_EMP502'	, PesqPict('SE3', 'E3_COMIS'	, aTam[1])	,	aTam[1], aTam[2], ''	, ""	, 'C'	, ''	, ''}) 
//aTam := TamSX3('E3_COMIS'		); Aadd(aHeader, {'TOTAL_BF'		, 'VL_TOTBF'	, PesqPict('SE3', 'E3_COMIS'	, aTam[1])	,	aTam[1], aTam[2], ''	, ""	, 'C'	, ''	, ''}) 

While !FATSQL->(Eof())
	
	ID_REPRES	:= FATSQL->A3_COD
	NM_REPRES	:= FATSQL->A3_NOME
	VL_0101		:= FATSQL->VL_EMP101
	VL_0201		:= FATSQL->VL_EMP201
	VL_0202		:= FATSQL->VL_EMP202
	VL_0000		:= FATSQL->VL_EMP000
	VL_0301		:= FATSQL->VL_EMP301
	VL_0302U1	:= FATSQL->VL_UN1302
	VL_0302U2	:= FATSQL->VL_UN2302
	VL_0303U1	:= FATSQL->VL_UN1303
	VL_0303U2	:= FATSQL->VL_UN2303
	VL_0301U1	:= FATSQL->VL_UN1301
	VL_0301U2	:= FATSQL->VL_UN2301
	VL_TOTAL	:= FATSQL->VL_TOTAL
//	VL_0501		:= FATSQL->VL_EMP501
//	VL_0502		:= FATSQL->VL_EMP502
//	VL_TOTBF		:= FATSQL->VL_TOTBF

	AAdd(aCols, {ID_REPRES, NM_REPRES, VL_0101, VL_0201, VL_0202, VL_0000, VL_0301, VL_0302U1, VL_0302U2, VL_0303U1, VL_0303U2, VL_0301U1, VL_0301U2, VL_TOTAL, .F.})
	
	FATSQL->(DbSkip())
End

If len( aCols ) > 0 
	DlgToExcel({ {"GETDADOS", "Comissoes a Pagar - " + Dtoc(__dIni) + " a " + Dtoc(__dFim) , aHeader, aCols} })
Else
	MsgAlert("Não há dados a exportar para o Excel!","")
EndIf

//Fecha Alias Temporario
If Select("FATSQL")
	FATSQL->(dbCloseArea())
EndIf
//Exclui a tabela temporaria do Banco de Dados
If TcCanOpen(aResult[1])
	TcSqlExec("DROP TABLE "+aResult[1])
EndIf

Return
