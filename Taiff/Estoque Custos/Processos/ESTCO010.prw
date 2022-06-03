#Include 'Protheus.ch'
#INCLUDE "TOPCONN.CH"
#Include 'rwmake.ch'

#DEFINE ENTER Chr(13)+Chr(10)
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ESTCO010 ºAutor  ³Carlos Torres       º Data ³  12/04/2016 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Busca e apresenta o endereço picking e estoque             º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Simples consulta da expedição do CD de Extrema             º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function ESTCO010()
	Local xZC5Alias	:= ""
	Local cAlias  := "SB1"
	//Local aCores  := {}
	Local cFiltra := "B1_FILIAL == '"+xFilial('SB1')+"' .AND. B1_ITEMCC='PROART' "
	Local _nX := 0

	Private cCadastro		:= "Endereço de produtos"
	Private aRotina  		:= {}
	Private aIndexZC5		:= {}
	Private bFiltraBrw	:= { || FilBrowse(cAlias,@aIndexZC5,@cFiltra) }
	Private aCampos		:= {}
	Private aCamposBrw	:= {}

	xZc5Alias	:= SF2->(GetArea())

	AADD(aCampos,{'Codigo'		,'B1_COD'    	,'C',15,0,''})
	AADD(aCampos,{'Descricao'		,'B1_DESC'   	,'C',90,0,''})
	AADD(aCampos,{'End. Picking' ,'B1_YENDEST'   	,'C',10,0,''})
	AADD(aCampos,{'Estação' 		,'B1_YESTAC'   	,'C',10,0,''})
	AADD(aCampos,{'End. Estoque' ,'B1_YENDSEP'   	,'C',10,0,''})

	aCamposBrw := {}
	For _nX := 1 To Len(aCampos)
		AaDd(aCamposBrw,{aCampos[_nX,1],aCampos[_nX,2],aCampos[_nX,3],aCampos[_nX,4],aCampos[_nX,5],aCampos[_nX,6]})
	Next

	aRotina	:= { 	{ "Pesquisar" ,"AxPesqui"		, 0 , 1, 0, .F.}}		//"Pesquisar"
	aAdd(aRotina, { "Visualizar" ,"A010Visul"	  		, 0 , 2, 0, nil} )	//"Visualizar"

	dbSelectArea(cAlias)
	dbSetOrder(1)
	Eval(bFiltraBrw)

	MBROWse(6,1,22,75,cAlias,aCamposBrw,,,,,NIL,,,,,.F.)

	EndFilBrw(cAlias,aIndexZC5)


	RestArea(xZC5Alias)

Return NIL
