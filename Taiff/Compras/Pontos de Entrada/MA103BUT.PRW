//#include "rwmake.ch"
//#INCLUDE "FIVEWIN.CH"
#Include "Protheus.Ch"
/*
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅДїпїЅпїЅ
пїЅпїЅпїЅ Programa пїЅ MA103BUT пїЅ Autor пїЅ Thiago Comelli        пїЅ Data пїЅ 24/03/11 пїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅДґпїЅпїЅ
пїЅпїЅпїЅDescriзгo пїЅ Ponto de Entrada Inclusao de Botao na digitaзгo de NF Entr.пїЅпїЅпїЅ
пїЅпїЅпїЅ          пїЅ Traz os itens em poder de terceiros conforme o OP     	  пїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅп
пїЅпїЅпїЅ Uso      пїЅ CIS                                                        пїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅп
їЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
*/

User Function MA103BUT()

Local aArea		:= GetArea()
Local aBotao 	:= {}

Aadd(aBotao	, {'MATERIAL',{||FEOP()},"Ret Benef. TAIFF"})
Aadd(aBotao	, {'Preenche TES',{||PTES1()},"PREENCHE TES DOS ITENS <CTRL+F> "})


//SET KEY 6 TO PTES1()
//SET KEY 5 TO FEOP()

RestArea(aArea)

Return(aBotao)
/*
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅН»пїЅпїЅ
пїЅпїЅпїЅPrograma  пїЅFEOP      пїЅ Autor пїЅ Thiago Comelli        пїЅ Data пїЅ 24/03/11 пїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅН№пїЅпїЅ
пїЅпїЅпїЅDesc.     пїЅ                                                            пїЅпїЅпїЅ
пїЅпїЅпїЅ          пїЅ                                                            пїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅН№пїЅпїЅ
пїЅпїЅпїЅUso       пїЅ AP                                                         пїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅНјпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
*/
Static FUNCTION FEOP()

Local oChk1
Private lTudo := .F.

cOP1	:= Space(13)
cNota1 := Space(9)
cNota2 := Space(9)
cNota3 := Space(9)
cNota4 := Space(9)
cNota5 := Space(9)
cNota6 := Space(9)
cNota7 := Space(9)
cNota8 := Space(9)
nQuant1 := 0

DEFINE MSDIALOG oDlg1 TITLE OemToAnsi("OP") From 100,55 To 670,400 OF oMainWnd PIXEL
@ 10,25  Say OemToAnsi("Informe o Cуdigo da OP")      Size 160,8 OF oDlg1 PIXEL
@ 25,25  Say OemToAnsi("de que deseja buscar a estrutura") Size 160,8 OF oDlg1 PIXEL
@ 40,25  Say OemToAnsi("OP 1 :")   Size 20,8  OF oDlg1 PIXEL
@ 40,50  MSGet cOP1 Picture "@!" F3 "SC2" VALID EXISTCPO("SC2",cOP1 ,1)Size 53,10 OF oDlg1 PIXEL
@ 55,25  Say OemToAnsi("Quant 1:")  Size 20,8 OF oDlg1 PIXEL
@ 55,50  MSGet nQuant1 Size 53,10 Picture "999,999.99" OF oDlg1 PIXEL
@ 100,25 Say OemToAnsi("N.F. 1 :")   Size 20,8 OF oDlg1 PIXEL
@ 100,50 MSGet cNota1 Size 43,10 OF oDlg1 PIXEL
@ 115,25 Say OemToAnsi("     2 :")   Size 20,8 OF oDlg1 PIXEL
@ 115,50 MSGet cNota2 Size 43,10 OF oDlg1 PIXEL
@ 130,25 Say OemToAnsi("     3 :")   Size 20,8 OF oDlg1 PIXEL
@ 130,50 MSGet cNota3 Size 43,10 OF oDlg1 PIXEL
@ 145,25 Say OemToAnsi("     4 :")   Size 20,8 OF oDlg1 PIXEL
@ 145,50 MSGet cNota4 Size 43,10 OF oDlg1 PIXEL
@ 160,25 Say OemToAnsi("     5 :")   Size 20,8 OF oDlg1 PIXEL
@ 160,50 MSGet cNota5 Size 43,10 OF oDlg1 PIXEL
@ 175,25 Say OemToAnsi("     6 :")   Size 20,8 OF oDlg1 PIXEL
@ 175,50 MSGet cNota6 Size 43,10 OF oDlg1 PIXEL
@ 190,25 Say OemToAnsi("     7 :")   Size 20,8 OF oDlg1 PIXEL
@ 190,50 MSGet cNota7 Size 43,10 OF oDlg1 PIXEL
@ 210,25 Say OemToAnsi("     8 :")   Size 20,8 OF oDlg1 PIXEL
@ 210,50 MSGet cNota8 Size 43,10 OF oDlg1 PIXEL
@ 225,25 CHECKBOX oChk1 VAR lTudo PROMPT OemToAnsi("Todo Material") SIZE 80, 10 OF oDlg1 PIXEL ;oChk1:oFont := oDlg1:oFont

DEFINE SBUTTON FROM 240,20 TYPE 1 ACTION Estrutura() ENABLE OF oDlg1
DEFINE SBUTTON FROM 240,50 TYPE 2 ACTION oDlg1:End() ENABLE OF oDlg1
Activate MSDialog oDlg1 Centered

Return
/*
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅН»пїЅпїЅ
пїЅпїЅпїЅPrograma  пїЅESTRUTURA пїЅ Autor пїЅ Thiago Comelli        пїЅ Data пїЅ 24/03/11 пїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅН№пїЅпїЅ
пїЅпїЅпїЅDesc.     пїЅ                                                            пїЅпїЅпїЅ
пїЅпїЅпїЅ          пїЅ                                                            пїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅН№пїЅпїЅ
пїЅпїЅпїЅUso       пїЅ AP                                                         пїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅНјпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
*/
Static FUNCTION ESTRUTURA()

Local aArea		:= GetArea()
Local aAreaSA2	:= SA2->(GetArea())
Local aAreaSB1	:= SB1->(GetArea())
Local aAreaSB6	:= SB6->(GetArea())
Local aAreaSB8	:= SB8->(GetArea())
Local aAreaSC2	:= SD2->(GetArea())
Local aAreaSD2	:= SD2->(GetArea())
Local aAreaSD4	:= SD4->(GetArea())
Local aAreaSF4	:= SF4->(GetArea())

Local nPosCod	:= aScan(aHeader,{|x| AllTrim(x[2])=='D1_COD'})
Local oOk		:= LoadBitMap(GetResources(), "LBOK")
Local oNo		:= LoadBitMap(GetResources(), "LBNO")
Local oDlg
Local oListBox
//Local cListBox
Local lContinua := .T.
Local nOpc		:= 0
Local nQunt     := 0
Local nSaldo    := 0
Local nY		:= 0
Local nx		:= 0

// Declara Arrays p/ Consultas
_aArqC1 := {}
AADD(_aArqC1,{"CODCOMP","C",15,0})
AADD(_aArqC1,{"QUNCOMP","N",12,5})
AADD(_aArqC1,{"TPOPROD","C",01,0})
// Arquivo Auxiliar para Consultas
_cArqC1 := CriaTrab(_aArqC1,.T.)
dbUseArea(.T.,,_cArqC1,"OP",.F.)

aTerceiros := {}
aConteudos := {}
If lContinua
	dbSelectArea("SD4")
	dbSetOrder(2)
	If DbSeek(xFilial("SD4")+cOP1)
		Processa({|| Montarq1() },"Aguarde! Processando...",,.T.)
	Else
		MSGBOX("OP 1 nгo foi localizada!")
		dbSelectArea("OP")
		OP->(DbcloseArea())
		fERASE(_cArqC1+".dbf")
		RestArea(aArea)
		Return
	Endif
	
	If !Empty(cNota1+cNota2+cNota3+cNota4+cNota5+cNota6+cNota7+cNota8)
		cNota := cNota1+"\"+cNota2+"\"+cNota3+"\"+cNota4+"\"+cNota5+"\"+cNota6+"\"+cNota7+"\"+cNota8
	Else
		cNota := ""
	Endif
	dbSelectArea("OP")
	dbGoTop()
	While !Eof()
		If OP->TPOPROD == "1"
			nQOP1 := Posicione("SC2",1,xFilial("SC2")+cOP1,"C2_QUANT")
			nQuje := Posicione("SC2",1,xFilial("SC2")+cOP1,"C2_QUJE")
			nQunt := (OP->QUNCOMP/(nQOP1-nQuje)) * nQuant1
		EndIf
		nSaldo := 0
		dbSelectArea("SB6")
		dbSetOrder(2)
		DbSeek(xFilial()+OP->CODCOMP+SUBS(CA100FOR,1,6)+CLOJA+"R")
		If lTudo
			While !Eof() .and. B6_PRODUTO==OP->CODCOMP .and. B6_CLIFOR+B6_LOJA==SUBS(CA100FOR,1,6)+CLOJA .and. B6_PODER3=="R"
				If B6_SALDO > 0 .And. B6_TIPO = "E"
					If Empty(cNota)
						nSaldo := B6_SALDO
						aConteudos := {.T.,B6_PRODUTO,B6_DOC,STR(nSaldo,11,2),B6_IDENT,SB6->(Recno())}
						aadd(aTerceiros, aConteudos)
					ElseIf B6_DOC$cNota
						nSaldo := B6_SALDO
						aConteudos := {.T.,B6_PRODUTO,B6_DOC,STR(nSaldo,11,2),B6_IDENT,SB6->(Recno())}
						aadd(aTerceiros, aConteudos)
					Endif
				Endif
				DbSkip()
			Enddo
		Else
			While !Eof() .and. B6_PRODUTO==OP->CODCOMP .and. B6_CLIFOR+B6_LOJA==SUBS(CA100FOR,1,6)+CLOJA .and. B6_PODER3=="R";
				.And. nQunt > 0
				If B6_SALDO > 0 .And. B6_TIPO = "E"
					If Empty(cNota)
						//VERIFICA A QUANTIDADE NO SB6 EM RELACAO AO ENTREGUE
						If B6_SALDO > nQunt
							nSaldo := nQunt
						ElseIf B6_SALDO <= nQunt
							nSaldo := B6_SALDO
						EndIf
						aConteudos := {.T.,B6_PRODUTO,B6_DOC,STR(nSaldo,11,2),B6_IDENT,SB6->(Recno())}
						aadd(aTerceiros, aConteudos)
					Else
						If B6_DOC$cNota
							//VERIFICA A QUANTIDADE NO SB6 EM RELACAO AO ENTREGUE
							If B6_SALDO > nQunt
								nSaldo := nQunt
							ElseIf B6_SALDO <= nQunt
								nSaldo := B6_SALDO
							EndIf
							aConteudos := {.T.,B6_PRODUTO,B6_DOC,STR(nSaldo,11,2),B6_IDENT,SB6->(Recno())}
							aadd(aTerceiros, aConteudos)
						Endif
					Endif
					nQunt -= nSaldo
				Endif
				DbSkip()
			Enddo
		EndIf
		DbSelectArea("OP")
		DbSkip()
	Enddo
	If ( !Empty(aTerceiros) )
		aTitCampos := {" ",OemToAnsi("Produto"),OemToAnsi("NF Orig"),OemToAnsi("Qtde"),OemToAnsi("Ident")}
		cLine := "{If(aTerceiros[oListBox:nAt,1],oOk,oNo),aTerceiros[oListBox:nAT][2],aTerceiros[oListBox:nAT][3],aTerceiros[oListBox:nAT][4],aTerceiros[oListBox:nAT][5]} "
		bLine := &( "{ || " + cLine + " }" )
		DEFINE MSDIALOG oDlg FROM 50,40  TO 285,541 TITLE "NOTAS DE ORIGEM" Of oMainWnd PIXEL
		oListBox := TWBrowse():New( 17,4,243,80,,aTitCampos,,oDlg,,,,,,,,,,,,.F.,,.T.,,.F.,,,)
		oListBox:SetArray(aTerceiros)
		oListBox:bLDblClick := { || aTerceiros[oListBox:nAt,1] := !aTerceiros[oListBox:nAt,1] }
		oListBox:bLine := bLine
		ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{||(nOpc := 1,nF4For := oListBox:nAt,oDlg:End())},{||(nOpc := 0,nF4For := oListBox:nAt,oDlg:End())},,) //aButtons)
		CursorWait()
		If ( nOpc == 1 )
			nCC       := aScan(aHeader,{|x| AllTrim(x[2])=='D1_CC'})       //CENTRO DE CUSTO
			nPosCod	  := aScan(aHeader,{|x| AllTrim(x[2])=='D1_COD'})       //
			nPosDescr := aScan(aHeader,{|x| AllTrim(x[2])=='D1_DESCR'})       //
			nPUM      := aScan(aHeader,{|x| AllTrim(x[2])=="D1_UM"})
			nPSegUM   := aScan(aHeader,{|x| AllTrim(x[2])=="D1_SEGUM"})
			nPQuant   := aScan(aHeader,{|x| AllTrim(x[2])=="D1_QUANT"})     //
			nPPrcVen  := aScan(aHeader,{|x| AllTrim(x[2])=="D1_VUNIT"})     //
			nPValor   := aScan(aHeader,{|x| AllTrim(x[2])=="D1_TOTAL"})       //
			nPTesB6   := aScan(aHeader,{|x| AllTrim(x[2])=="D1_TES"})       //
			nPCFB6    := aScan(aHeader,{|x| AllTrim(x[2])=="D1_CF"})        //
			nPQuant2UM:= aScan(aHeader,{|x| AllTrim(x[2])=="D1_QTSEGUM"})   //
			nPValDesc := aScan(aHeader,{|x| AllTrim(x[2])=="D1_VALDESC"})     //
			nPDesc    := aScan(aHeader,{|x| AllTrim(x[2])=="D1_DESC"})
			nPNfOri   := aScan(aHeader,{|x| AllTrim(x[2])=="D1_NFORI"})     //
			nPSerOri  := aScan(aHeader,{|x| AllTrim(x[2])=="D1_SERIORI"})   //
			nPItemOri := aScan(aHeader,{|x| AllTrim(x[2])=="D1_ITEMORI"})   //
			nPLocal   := aScan(aHeader,{|x| AllTrim(x[2])=="D1_LOCAL"})     //
			nPLoteCtl := aScan(aHeader,{|x| AllTrim(x[2])=="D1_LOTECTL"})   //
			nPNumLote := aScan(aHeader,{|x| AllTrim(x[2])=="D1_NUMLOTE"})   //
			nPDtValid := aScan(aHeader,{|x| AllTrim(x[2])=="D1_DTVALID"})   //
			nPIdentB6 := aScan(aHeader,{|x| AllTrim(x[2])=="D1_IDENTB6"})   //
			nPClasCon := aScan(aHeader,{|x| AllTrim(x[2])=="D1_CLASCON"})   //
			nPConta   := aScan(aHeader,{|x| AllTrim(x[2])=="D1_CONTA"})   //
			nPNumOP   := aScan(aHeader,{|x| AllTrim(x[2])=="D1_NUMOP"})
			nPOP	  := aScan(aHeader,{|x| AllTrim(x[2])=="D1_OP"})      
			_N    := Len(aCols)
			_Item := aCols[_N][nPosCod]
			cItem := Strzero(Len(aCols),4)
			IF !Empty(_Item)
				cItem := Strzero(Len(aCols)+1,4)
			Endif
			For nx	:= 1 to Len(aTerceiros)
				If aTerceiros[nx][1]
					If !Empty(_Item)
						//пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅДї
						//пїЅCria Linha adicional em Branco no aColsпїЅ
						//пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
						aadd(aCols,Array(Len(aHeader)+1)) // linha em branco no aCols
						For nY:=1 to Len(aHeader)
							cCampo:=Alltrim(aHeader[ny,2])
							SX3->(DbSetOrder(2))
							If !SX3->(DbSeek(cCampo))
								If aHeader[ny,8] == "C" .AND. Trim(aHeader[ny][2]) == "D1_ITEM"
									aCols[Len(aCols)][ny]	:= IIF(cItem<>Nil,cItem,"0001")
								ELSEIF aHeader[ny,8] == "C" .AND. Trim(aHeader[ny][2]) <> "D1_ITEM"
									aCols[Len(aCols)][ny]	:= SPACE(aHeader[ny,4])
								ELSEIF aHeader[ny,8] == "N"
									aCols[Len(aCols)][ny]	:= 0
								ELSEIF aHeader[ny,8] == "D"
									aCols[Len(aCols)][ny]	:= Ctod("")//CriaVar(alltrim(aHeader[2]))
								ELSEIF aHeader[ny,8] == "M"
									aCols[Len(aCols)][ny]	:= ""
								Endif
							Else
								If Trim(aHeader[ny][2]) == "D1_ITEM"
									aCols[Len(aCols)][ny]	:= IIF(cItem<>Nil,cItem,"0001")
								ELSE
									aCols[Len(aCols)][ny]	:= CriaVar(alltrim(cCampo),.T.)
								EndIf
							EndIf
							aCols[Len(aCols)][Len(aHeader)+1] := .F.
						Next nY
						
					Endif
					_Item := "1"
					_N := Len(aCols)
					dbSelectArea("SD2")
					dbSetOrder(4)
					DbSeek(xFilial()+aTerceiros[nx][5])
					dbSelectArea("SB6")
					dbGoTo(aTerceiros[nx][6])
					dbSelectArea("SF4")
					dbSetOrder(1)
					DbSeek(xFilial()+"148")
					dbSelectArea("SB1")
					dbSetOrder(1)
					DbSeek(xFilial()+SB6->B6_PRODUTO)
					//пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅДї
					//пїЅ Preenche acols                                                      пїЅ
					//пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
					If nPosCod <> 0
						aCols[_N][nPosCod] := aTerceiros[nx][2]
					EndIf
					If nPosCod <> 0
						aCols[_N][nPosDescr] := SB1->B1_DESC
					EndIf
					If nPIdentB6 <> 0
						aCols[_N][nPIdentB6] := aTerceiros[nx][5]
					EndIf
					If nPNfOri <> 0
						aCols[_N][nPNfOri]   := SD2->D2_DOC
					EndIf
					If nPSerOri <> 0
						aCols[_N][nPSerOri]  := SD2->D2_SERIE
					EndIf
					If nPItemOri <> 0
						aCols[_N][nPItemOri] := SD2->D2_ITEM
					EndIf
					If nPLocal <> 0
						aCols[_N][nPLocal]   := SD2->D2_LOCAL
					EndIf
					If nPNumOP <> 0
				//		aCols[_N][nPNumOP]   := cOP1
					EndIf
					If nPOP <> 0
						aCols[_N][nPOP]	   := cOP1
					EndIf

					If nPPrcVen <> 0
						aCols[_N][nPPrcVen]  := SB6->B6_PRUNIT
					EndIf
					If nPTesB6 <> 0
						aCols[_N][nPTesB6]   := "148"
					EndIf
					If nPClasCon <> 0
						aCols[_N][nPClasCon]   := "5"
					EndIf
					If nPCFB6 <> 0
						aCols[_N][nPCFB6]    := SF4->F4_CF
					EndIf
					If nPUM <> 0
						aCols[_N][nPUM]      := SD2->D2_UM
					EndIf
					If nPSegUM <> 0
						aCols[_N][nPSegUM]   := SD2->D2_SEGUM
					EndIf
					If nPConta <> 0
						aCols[_N][nPConta]   := SB1->B1_CONTA
					EndIf
					If nPQuant <> 0
						aCols[_N][nPQuant]   := Val(aTerceiros[nx][4])
						If nPQuant2UM <> 0
							aCols[_N][nPQuant2UM] := ConvUm(aTerceiros[nx][2],aCols[_N][nPQuant],0,2)
						EndIf
					EndIf
					If Rastro(aTerceiros[nx][2])
						If nPLoteCtl <> 0
							aCols[_N][nPLoteCtl] := SD2->D2_LOTECTL
						EndIf
						If nPNumLote <> 0
							aCols[_N][nPNumLote] := SD2->D2_NUMLOTE
						EndIf
						If nPDtValid <> 0
							dbSelectArea("SB8")
							dbSetOrder(3)
							If MsSeek(xFilial("SB8")+aTerceiros[nx][2]+aCols[_N][nPLocal]+aCols[_N][nPLoteCtl]+IIf(Rastro(cOP1,"S"),aCols[_N][nPNumLote],""))
								aCols[_N][nPDtValid] := SB8->B8_DTVALID
							EndIf
						EndIf
					EndIf
					If nPValDesc <> 0 .And. nPQuant <> 0 .And. nPDesc <> 0
						aCols[_N][nPValDesc] := a410Arred( ( (SB6->B6_PRUNIT-SD2->D2_PRCVEN) *IIf(aCols[_N][nPQuant]==0,1,aCols[_N][nPQuant])) ,"D1_VALDESC")
					EndIf
					aCols[_N][nPValor] := a410Arred(IIf(aCols[_N][nPQuant]==0,1,aCols[_N][nPQuant])*aCols[_N][nPPrcVen],"D1_TOTAL")
					aCols[_N][nCC]     := ""
					dbSelectArea("SD2")
					dbSetOrder(4)
					DbSeek(xFilial()+aTerceiros[nx][5])
					A103SD2toaCols(SD2->(RecNo()),_N)
					cItem := SomaIt(cItem)
				EndIf
				
			Next
			
			//пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅДї
			//пїЅCria Linha adicional em Branco no aColsпїЅ
			//пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
			aadd(aCols,Array(Len(aHeader)+1)) // linha em branco no aCols
			For nY:=1 to Len(aHeader)
				cCampo:=Alltrim(aHeader[ny,2])
				SX3->(DbSetOrder(2))
				If !SX3->(DbSeek(cCampo))
					If aHeader[ny,8] == "C" .AND. Trim(aHeader[ny][2]) == "D1_ITEM"
						aCols[Len(aCols)][ny]	:= IIF(cItem<>Nil,cItem,"0001")
					ELSEIF aHeader[ny,8] == "C" .AND. Trim(aHeader[ny][2]) <> "D1_ITEM"
						aCols[Len(aCols)][ny]	:= SPACE(aHeader[ny,4])
					ELSEIF aHeader[ny,8] == "N"
						aCols[Len(aCols)][ny]	:= 0
					ELSEIF aHeader[ny,8] == "D"
						aCols[Len(aCols)][ny]	:= Ctod("")//CriaVar(alltrim(aHeader[2]))
					ELSEIF aHeader[ny,8] == "M"
						aCols[Len(aCols)][ny]	:= ""
					Endif
				Else
					If Trim(aHeader[ny][2]) == "D1_ITEM"
						aCols[Len(aCols)][ny]	:= IIF(cItem<>Nil,cItem,"0001")
					ELSE
						aCols[Len(aCols)][ny]	:= CriaVar(alltrim(cCampo),.T.)
					EndIf
				EndIf
				aCols[Len(aCols)][Len(aHeader)+1] := .F.
			Next nY
			
		Endif
		
		CursorArrow()
	Else
		MsgBox("Nenhum Item Selecionado")
	Endif
Endif

OP->(dbCloseArea())
fERASE(_cArqC1)

//пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅДї
//пїЅ Restaura a Integrida dos dados de Entrada                пїЅ
//пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ

// Close(oDlg1)

RestArea(aAreaSF4)
RestArea(aAreaSD4)
RestArea(aAreaSD2)
RestArea(aAreaSC2)
RestArea(aAreaSB8)
RestArea(aAreaSB6)
RestArea(aAreaSB1)
RestArea(aAreaSA2)
RestArea(aArea)

Return(.T.)
/*
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅН»пїЅпїЅ
пїЅпїЅпїЅPrograma  пїЅMontarq1  пїЅ Autor пїЅ Thiago Comelli        пїЅ Data пїЅ 24/03/11 пїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅН№пїЅпїЅ
пїЅпїЅпїЅDesc.     пїЅGrava os dados da estrutura no arquivo temporario           пїЅпїЅпїЅ
пїЅпїЅпїЅ          пїЅ                                                            пїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅН№пїЅпїЅ
пїЅпїЅпїЅUso       пїЅ AP                                                         пїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅНјпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
*/
Static Function Montarq1()

dbSelectArea("SD4")
While !Eof() .and. Left(SD4->D4_OP,6)==Left(cOP1,6)

	DbSelectArea("OP")
	Locate for OP->CODCOMP == SD4->D4_COD  //	Locate for cOP1 == SG1->G1_COMP
	If !Found()
		RecLock("OP",.T.)
		OP->CODCOMP  := SD4->D4_COD
		OP->QUNCOMP  := SD4->D4_QUANT
		OP->TPOPROD  := "1"
		OP->(MsUnlock()) // // Eduardo Alberti Em 10/Jul/2014 -> Rotina Nao Estava Destravando a Tabela
	Endif
	dbSelectArea("SD4")
	DbSkip()
	IncProc()
Enddo

Return
/*
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅДїпїЅпїЅ
пїЅпїЅпїЅFunзгo    пїЅA103SD2ToaCпїЅAutor пїЅ Thiago Comelli        пїЅ Data пїЅ 24/03/11 пїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅДґпїЅпїЅ
пїЅпїЅпїЅDescriзгo пїЅ Programa de atualizacao do acols com base no item de saida пїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅДґпїЅпїЅ
пїЅпїЅпїЅSintaxe   пїЅ A103SD2ToAc(ExpN1,Expn2)                                   пїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅДґпїЅпїЅ
пїЅпїЅпїЅParametrosпїЅ ExpN1 = Registro do item de saida                          пїЅпїЅпїЅ
пїЅпїЅпїЅ          пїЅ ExpN2 = Item do Acols                                      пїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅДґпїЅпїЅ
пїЅпїЅпїЅ Uso      пїЅ MATA103                                                    пїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅЩ±пїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
*/
Static Function A103SD2ToaCols(nRecSD2,nItem)

Local aArea		:= GetArea()
Local aAreaSD2	:= SD2->(GetArea())  
Local aAreaSF2	:= SF2->(GetArea())  

PRIVATE bListRefresh	:= {|| (MaFisToCols(aHeader,aCols,,"MT100")),Eval(bRefresh),Eval(bGdRefresh)}	// Carrega os valores da Funcao fiscal e executa o Refresh
//пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅДї
//пїЅ Posiciona na item da Nota Original          пїЅ
//пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
dbSelectArea("SD2")
MsGoto(nRecSD2)
dbSelectArea("SF2")
dbSetOrder(1)
MsSeek(xFilial("SF2")+SD2->D2_DOC+SD2->D2_SERIE+SD2->D2_CLIENTE+SD2->D2_LOJA)
//пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅДї
//пїЅ Atualiza a Funcao Fiscal                    пїЅ
//пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
MaColsToFis(aHeader,aCols,nItem,"MT100",.F.)
MaFisAlt("IT_RECORI",nRecSD2,nItem)
MaFisAlt("NF_UFORIGEM",SF2->F2_EST)
Eval(bListRefresh)

RestArea(aAreaSD2)
RestArea(aAreaSF2)
RestArea(aArea)

Return(.T.)

/*
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅН»пїЅпїЅ
пїЅпїЅпїЅPrograma  пїЅ1PTES     пїЅAutor  пїЅPaulo Bindo         пїЅ Data пїЅ  05/02/16   пїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅН№пїЅпїЅ
пїЅпїЅпїЅDesc.     пїЅ Carrega a regua											  пїЅпїЅпїЅ
пїЅпїЅпїЅ          пїЅ                                                            пїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅН№пїЅпїЅ
пїЅпїЅпїЅUso       пїЅ AP                                                         пїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅНјпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
*/


Static Function PTES1()
	Processa({||PTES()})
Return



/*
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅН»пїЅпїЅ
пїЅпїЅпїЅPrograma  пїЅPTES      пїЅAutor  пїЅPaulo Bindo         пїЅ Data пїЅ  05/02/16   пїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅН№пїЅпїЅ
пїЅпїЅпїЅDesc.     пїЅ PREENCHE TES NA NOTA DE ENTRADA CONFORME TES INTELIGENTE   пїЅпїЅпїЅ
пїЅпїЅпїЅ          пїЅ                                                            пїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅН№пїЅпїЅ
пїЅпїЅпїЅUso       пїЅ AP                                                         пїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅНјпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
*/

Static Function PTES()
	
	Local oEstoque
	Local nOpc := 0
	Local cOper := Space(02)
	Local nPosTes := 0
	Local nPosCF := 0
	Local nNx := 0
	Local aBkpaCols := {}

	Define msDialog oEstoque from 0,0 to 120,290 title "Tipo Operaзгo" Of oEstoque Pixel
	@ 005,005 say "Selecione a operaзгo" size  90,07 Of oEstoque Pixel
	@ 018,005 say "Cod.:" size 21,07 Of oEstoque Pixel
	@ 018,037 MSget cOper F3 "DJ" size 49,08 Of oEstoque Pixel
	define sButton from 040,080 type 1 action(oEstoque:End(),nOpc := 1) enable  Of oEstoque Pixel
	define sButton from 040,110 type 2 action(oEstoque:End(),cOper:="",nOpc := 2)  enable Of oEstoque Pixel
	Activate msDialog oEstoque center

	If nOpc == 1

		//oGetDados:oBrowse:lDisablePaint := .T.
		cGrupTrib   := Posicione("SA2",1,xFilial("SA2")+ cA100FOR+cLoja,"A2_GRPTRIB")
		nPosTes 	:= aScan(aHeader,{|e|Trim(e[2])=="D1_TES"})
		nPosOper 	:= aScan(aHeader,{|e|Trim(e[2])=="D1_OPER"})
		nPosCF 		:= aScan(aHeader,{|e|Trim(e[2])=="D1_CF"})
		nPosClasCon	:= aScan(aHeader,{|e|Trim(e[2])=="D1_CLASCON"})
		aBkpaCols   := aClone(aCols)
	
		ProcRegua(Len(aCols))
	
		For nNx := 1 To Len(aCols)

			IncProc("Classificando Item "+StrZero(nNx,3)+" de"+StrZero(Len(aCols),3) )
			ProcessMessages()
			N := nNx
			oGetDados:oBrowse:nAt := nNx

			CriaVar("D1_COD")
			If ExistTrigger("D1_COD")
				RunTrigger( 2, nNx, Nil, , "D1_COD" )
			EndIf

			CriaVar("D1_QUANT")
			If ExistTrigger("D1_QUANT")
				RunTrigger( 2, nNx, Nil, , "D1_QUANT" )
			EndIf

			CriaVar("D1_VUNIT")
			If ExistTrigger("D1_VUNIT")
				RunTrigger( 2, nNx, Nil, , "D1_VUNIT" )
			EndIf

			CriaVar("D1_TOTAL")
			If ExistTrigger("D1_TOTAL")
				RunTrigger( 2, nNx, Nil, , "D1_TOTAL" )
			EndIf

			CriaVar("D1_OPER")
			aCols[nNx,nPosOper] := cOper
			M->D1_OPER := cOper

			If ExistTrigger("D1_OPER")
				RunTrigger( 2, nNx, Nil, , "D1_OPER" )
			EndIf

			If ExistTrigger("D1_TES")
				RunTrigger( 2, nNx, Nil, , "D1_TES" )
			EndIf

		Next nNx

		For nNx := 1 to Len(aCols)
			aCols[nNx,nPosClasCon] := aBkpaCols[nNx,nPosClasCon]
		Next nNx

		N := 1
		oGetDados:oBrowse:nAt := 1

		MAFISSAVE()
		MaFisToCols(aHeader,aCols,,"MT100")
		Eval(bRefresh)
		Eval(bGdRefresh)

	EndIf

Return(Nil)
