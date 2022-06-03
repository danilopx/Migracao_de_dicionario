#INCLUDE "protheus.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � M261BCHOI � Autor �  JAR              � Data �  16/02/11   ���
�������������������������������������������������������������������������͹��
���Descricao � Endere�amentos por lote                                    ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � to TAIFF from ABM                                          ���
�������������������������������������������������������������������������ͼ��
** 14.07.14 - inclus�o getarea() e restarea()
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
#include "Totvs.ch"
User Function M261BCHOI() 
Local aAreaAtual := GetArea()
Local aButRet := {}
Local __ProIdUser := GETNEWPAR("MV_TFBUFPR","000348")  

If SM0->M0_CODIGO='01'
	DbSelectArea("ZAH")
	DbSetOrder(1)
	DbSetFilter( {|| recno() > 15 }, "recno() > 15" )  
	ZAH->(DbSeek( xFilial("ZAH") + __CUSERID )) 
	
	If ZAH->(found()) .or. At(  Alltrim(__CUSERID)  , GetNewPar("TF_USERZAH","") ) != 0
		aAdd(aButRet, {"AVGARMAZEM", {|| U_TFLoad02B()}, "Carrega OP do 02-Buffer para 11-Producao", "02Buff->11"})
	Else
		aAdd(aButRet, {"AVGARMAZEM", {|| Alert("Usu�rio com restri��o de acesso, veja cadastro 02-Buffer","Inconsist�ncia")}, "Carrega OP do 02-Buffer para 11-Producao", "02Buff->11"})
	EndIf
	
	DbSelectArea("ZAH")
	DBCLEARFILTER()
	DbSelectArea("ZAH")
	DbSetOrder(1)
	DbSetFilter( {|| recno() <= 15 }, "recno() <= 15" )  
	
	ZAH->(DbSeek( xFilial("ZAH") + __CUSERID )) 
		
	If !ZAH->(found()) .or. At( __CUSERID, __ProIdUser ) != 0
		aAdd(aButRet, {"AUTOM", {|| U_TFLoadEmp()}, "Carrega OP", "Carrega OP."})
		aAdd(aButRet, {"AUTOM", {|| U_TFLoadPED()}, "Carrega PV", "Carrega PV."})
	Else
		aAdd(aButRet, {"AUTOM", {|| Alert("Usu�rio com restri��o de acesso!","Inconsist�ncia")}, "Carrega OP", "Carrega OP."})
		aAdd(aButRet, {"AUTOM", {|| Alert("Usu�rio com restri��o de acesso!","Inconsist�ncia")}, "Carrega PV", "Carrega PV."})
	EndIf	   
	
	/*
	|=================================================================================
	|   COMENTARIO
	|---------------------------------------------------------------------------------
	|	Os Botoes "Carrega OP no Buffer" e "Carrega OP na Producao" foram retirados 
	|	pois as Funcoes TFLOADBUFFER e TFBUFPROD foram retiradas do Projeto do 
	|	Grupo
	|
	|	Edson Hornberger - 27/11/2014
	|=================================================================================
	*/
	
	/*
	If ZAH->(found())
		aAdd(aButRet, {"HISTORIC", {|| U_TFLoadBuf()}, "Carrega OP no Buffer", "OP->Buffer"})   // ctorres - 08/04
	Else
		aAdd(aButRet, {"HISTORIC", {|| Alert("Usu�rio com restri��o de acesso!","Inconsist�ncia")}, "Carrega OP no Buffer", "OP->Buffer"})   // ctorres - 08/04
	EndIf
	
	If At( __CUSERID, __ProIdUser ) != 0
		aAdd(aButRet, {"PAP06", {|| U_TFBufProd()}, "Carrega OP na Producao", "Buff->Prod"}) // ctorres - 08/04
	Else
		aAdd(aButRet, {"PAP06", {|| Alert("Usu�rio com restri��o de acesso!","Inconsist�ncia") }, "Carrega OP na Producao", "Buff->Prod"})
	EndIf
	*/
Else
	aAdd(aButRet, {"AVGARMAZEM",	{|| U_TFLoad02B()}, "Carrega OP do 02-Buffer para 11-Producao"	, "02Buff->11"		})
	//aAdd(aButRet, {"AUTOM",			{|| U_TFLoadEmp()}, "Carrega OP"									, "Carrega OP."	})
	aAdd(aButRet, {"AUTOM",			{|| U_TFLoadPED()}, "Carrega PV"								, "Carrega PV."		})
	aAdd(aButRet, {"HISTORIC", 		{|| U_TFLoadBuf()}, "Carrega OP no Buffer"						, "OP->Buffer"		}) // ctorres - 08/04
	//aAdd(aButRet, {"PAP06",			{|| U_TFBufProd()}, "Carrega OP na Producao"						, "Buff->Prod"		}) // ctorres - 08/04
Endif		                 

RestArea(aAreaAtual)
Return aClone(aButRet)
