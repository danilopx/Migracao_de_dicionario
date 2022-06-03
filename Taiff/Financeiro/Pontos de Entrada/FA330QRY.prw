#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �FA330QRY  �Autor  �Ivan Morelatto Tore � Data �  31/03/12   ���
�������������������������������������������������������������������������͹��
���Desc.     � Ponto de Entrada para alterar a Query na selecao de titulos���
���          � desconsiderando a carteira 2 ou o que estiver no parametro ���
���          � do SX6                                                     ���
�������������������������������������������������������������������������͹��
���Uso       � FINA330                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function FA330QRY

Local cRetFun	:= ""
Local cQuery	:= ParamIXB[1]
Local cIniQry	:= SubStr( cQuery, 1, At( "ORDER BY", Upper( cQuery ) ) - 1 )
Local cFimQry	:= SubStr( cQuery, At( "ORDER BY", Upper( cQuery ) ) )
Local cNoCarts	:= GetNewPar( "ES_NOCARTS", "2" )
/*
	Customiza��o: TOTVS - Jorge                            
	Merge.......: TAIFF - C. Torres                          Data: 09/04/2013
*/
Local lUniNeg	:= cEmpAnt+cFilant $ GETNEWPAR('MV_UNINEG'/*cParametro*/, cEmpAnt+cFilant /*cPadrao*/, /*cFilial*/) // -- Separar no parametro as empresas filiais concatenadas. Ex. 0302/0303
Local nTam		:= Len(cQuery)
Local c_Var		:= ''
Local nPos		:= 0
Local cPart1	:= ''
Local cUniNeg 	:= Space(TAMSX3("E1_ITEMC")[1])					//-- Separar no parametro as empresas filiais concatenadas. Ex. 0302/0303
/*
	Fim Customiza��o TOTVS - Jorge
*/

cRetFun += cIniQry
cRetFun += " AND E1_SITUACA NOT IN " + FormatIn( cNoCarts, ";" ) + " "
cRetFun += cFimQry
cQuery	:= cRetFun
nTam		:= Len(cQuery)

/*
	Customiza��o: TOTVS - Jorge                            
	Merge.......: TAIFF - C. Torres                          Data: 09/04/2013
*/
//--Valida se a empresa utiliza ou nao regras de unidade de negocio.
If lUniNeg
	@00,00 TO 125,300 DIALOG oDlg TITLE " Selecione Unidade de Negocio "
	
	@ 10,15 say "Unidade de Negocio : "
	@ 10,60 Get cUniNeg SIZE 22,10 PICTURE "@!"  F3 "CTD" VALID ExistCpo("CTD",cUniNeg,1)
	
	@ 45,070 BMPBUTTON TYPE 01 ACTION CLOSE(oDlg)
	
	Activate Dialog oDlg centered
	
EndIf

If lUniNeg

	c_Var		:= " WHERE SE1.E1_ITEMC = '" + cUniNeg + "' AND "
	nPos		:= At('WHERE' ,cQuery )
		
	cPart1 := SUBS(cQuery,1, nPos - 1)
	cQuery := cPart1  + c_Var + SUBS( cQuery, nPos + 6, ( nTam - Len(cPart1) )   ) 
	
EndIf
/*
	Fim Customiza��o TOTVS - Jorge
*/

//Adicionado filtro de NCC geradas pela transf. de cobran�a descontada.  BackLog Financeiro.
Return StrTran(cQuery, "ORDER BY", " AND SE1.E1_ORIGEM <> 'F060ACT ' ORDER BY")
