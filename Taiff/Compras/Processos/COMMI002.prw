#include "Protheus.ch"
#include "Rwmake.ch"
#include "TbiConn.ch"
#include "TbiCode.ch"
#INCLUDE 'TOPCONN.CH'


#DEFINE ENTER Chr(13) + Chr(10)
#DEFINE MAXGETDAD 99999
#DEFINE MAXSAVERESULT 99999

/*/
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅН»пїЅпїЅ
пїЅпїЅпїЅPrograma  пїЅCOMMI001  пїЅ Autor пїЅ PAULO BINDO        пїЅ Data пїЅ  03/03/08   пїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅН№пїЅпїЅ
пїЅпїЅпїЅDescricao пїЅ PROGRMA PARA GERAR A TABELA DE PRECO DE COMPRAS            пїЅпїЅпїЅ
пїЅпїЅпїЅ          пїЅ EM FUNCAO DO CADASTRO DE PRODUTOS                          пїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅН№пїЅпїЅ
пїЅпїЅпїЅUso       пїЅ AP6 IDE                                                    пїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅНјпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
/*/

User Function COMMI002()

Local aCores     := {}
Private cPerg		:= "COMI01"
Private cMailDest := U_TFmaisx6() 
Private aRotina := {{ OemToAnsi("Pesquisar"),"AxPesqui"		,0,1,0,.F.},;
{ OemToAnsi("Visualizar"),"AxVisual"		,0,2,0,.F.},;
{ OemToAnsi("Reajuste"),"U_COMI001C"		,0,5,,.T.},;
{ OemToAnsi("Aprovar"),"U_COMI1Aprov()"		,0,3,,.T.},;
{ OemToAnsi("Exp.Excel"),"U_COMI01EX()"		,0,3,,.T.},;
{ OemToAnsi("Imp.Excel"),"U_COMI01IP()"		,0,3,,.T.}}


cCadastro := OemToAnsi("Manutencao da Tabela de Precos")
//пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅДї
//пїЅVerifica as cores da MBrowse                                            пїЅ
//пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
Aadd(aCores,{"Dtos(AIA_DATATE) < Dtos(dDataBase).And. !Empty(Dtos(AIA_DATATE))","DISABLE"}) //inativa
Aadd(aCores,{"(Dtos(AIA_DATATE) >= Dtos(dDataBase) .Or. Empty(Dtos(AIA_DATATE)))","ENABLE"})    //Ativa simples

//пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅДї
//пїЅHabilita as perguntas da Rotina                                         пїЅ
//пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
ValidPerg(cPerg)
Pergunte(cPerg,.F.)
SetKey(VK_F12,{|| Pergunte(cPerg,.T.)})
//пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅДї
//пїЅEndereca para a funcao MBrowse                                          пїЅ
//пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
dbSelectArea("AIA")
dbSetOrder(1)
MsSeek(xFilial("AIA"))
mBrowse(06,01,22,75,"AIA",,,,,,aCores)
//пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅДї
//пїЅRestaura a Integridade da Rotina                                        пїЅ
//пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
dbSelectArea("AIA")
dbSetOrder(1)
dbClearFilter()
SetKey(VK_F12,Nil)
Return



/*
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅН»пїЅпїЅ
пїЅпїЅпїЅPrograma  пїЅCOMMI001  пїЅAutor  пїЅMicrosiga           пїЅ Data пїЅ  03/03/08   пїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅН№пїЅпїЅ
пїЅпїЅпїЅDesc.     пїЅ                                                            пїЅпїЅпїЅ
пїЅпїЅпїЅ          пїЅ                                                            пїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅН№пїЅпїЅ
пїЅпїЅпїЅUso       пїЅ AP                                                        пїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅНјпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
*/

Static Function COMMI002B(nOpcao,aHeader,aCols)

Local lGravou   := .F.
//Local lTravou   := .T.
Local nX        := 0
Local nY        := 0
Local nCntfor   := 0
//Local nPosRecNo := Len(aHeader)
Local bCampo 	:= {|nCPO| Field(nCPO) }
Local cItem     := Repl("0",Len(AIB->AIB_ITEM))

dbSelectArea("AIB")
dbSetOrder(1)

For nX := 1 To Len(aCols)

	Begin Transaction
	
		If nX == 1
			dbSelectArea("AIA")
			dbSetOrder(1)
			If DbSeek(xFilial("AIA")+M->AIA_CODFOR+M->AIA_LOJFOR+M->AIA_CODTAB)
				MsgStop("Tabela de preзo jб cadastrada para este fornecedor","Atenзгo - COMMI002")
				DisarmTransaction()
				Break
			Else
				RecLock("AIA",.T.)
			EndIf
			For nCntFor := 1 TO FCount()
				FieldPut(nCntFor,M->&(EVAL(bCampo,nCntFor)))
			Next nCntFor
			AIA->AIA_FILIAL := xFilial("AIA")
			AIA->(MsUnLock())
		EndIf
		
		
		If !aCols[nX,Len(aCols[nX])]
			RecLock("AIB",.T.)
			For nY := 1 to Len(aHeader)
				If aHeader[nY][10] <> "V"
					AIB->(FieldPut(FieldPos(aHeader[nY][2]),aCols[nX][nY]))
				EndIf
			Next nY
			cItem := Soma1(cItem,Len(AIB->AIB_ITEM))
			AIB->AIB_FILIAL := xFilial("AIB")
			AIB->AIB_CODFOR := AIA->AIA_CODFOR
			AIB->AIB_LOJFOR := AIA->AIA_LOJFOR
			AIB->AIB_CODTAB := AIA->AIA_CODTAB
			AIB->AIB_ITEM   := cItem
			AIB->AIB_INDLOT := StrZero(AIB->AIB_QTDLOT,18,2)
			AIB->(MsUnLock())
			lGravou := .T.
		EndIf
		//MsUnLock()
	End Transaction

Next nX

If !lGravou
	dbSelectArea("AIA")
	dbSetOrder(1)
	If DbSeek(xFilial("AIA")+M->AIA_CODFOR+M->AIA_LOJFOR+M->AIA_CODTAB)
		RecLock("AIA")
		dbDelete()
		AIA->(MsUnLock())
	EndIf
EndIf

Return(lGravou)



/*
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅН»пїЅпїЅ
пїЅпїЅпїЅPrograma  пїЅCOMI001C  пїЅAutor  пїЅPaulo Bindo         пїЅ Data пїЅ  03/04/08   пїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅН№пїЅпїЅ
пїЅпїЅпїЅDesc.     пїЅ Faz o reajuste na tabela de preco                          пїЅпїЅпїЅ
пїЅпїЅпїЅ          пїЅ                                                            пїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅН№пїЅпїЅ
пїЅпїЅпїЅUso       пїЅ AP                                                         пїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅНјпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
*/
User Function COMI001C()

If Pergunte(cPerg,.T.)
	
	If Empty(mv_par09)
		MsgStop("Para esta rotina й necessбrio preencher a tabela do fornecedor","Atenзгo - COMMMI001!")
		Return
	EndIf
	
	dbSelectArea("AIA")
	dbSetOrder(1)
	If !dbSeek(xFilial()+mv_par07+"01"+mv_par09)
		MsgStop("Tabela do Fornecedor nгo encontrada!","Atenзгo - COMMMI001!")
		Return
	EndIf
	
	cQuery := "UPDATE "+RetSqlName("AIB")
	cQuery += " SET AIB__DESCO = '"+Alltrim(Str(mv_par08))+"', AIB_PRCCOM = AIB__VLRCH *'"+Alltrim(Str(((100-mv_par08)/100)))+"'"
	cQuery += " FROM  "+RetSqlName("SB1")+" B1 "
	cQuery += " WHERE B1_COD = AIB_CODPRO AND "
	cQuery += " B1_FILIAL ='"+xFilial("SB1")+"' AND "
	cQuery += " AIB_FILIAL ='"+xFilial("AIB")+"' AND "
	cQuery += " B1_COD >= '"+mv_par01+"' AND "
	cQuery += " B1_COD <= '"+mv_par02+"' AND "
	cQuery += " B1_GRUPO >= '"+mv_par03+"' AND "
	cQuery += " B1_GRUPO <= '"+mv_par04+"' AND "
	cQuery += " B1_TIPO >= '"+mv_par05+"' AND "
	cQuery += " B1_TIPO <= '"+mv_par06+"' AND "
	cQuery += " AIB_CODFOR = '"+mv_par07+"' AND "
	cQuery += " AIB_CODTAB = '"+mv_par09+"' AND "
	cQuery += " B1.D_E_L_E_T_ = ' '"
	MemoWrite("COMMI002C.SQL",cQuery)
	If TcSqlExec(cQuery) <0
		UserException( "Erro na atualizaзгo"+ Chr(13)+Chr(10) + "Processo com erros"+ Chr(13)+Chr(10) + TCSqlError() )
	EndIf
	
EndIf
Return
/*
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅН»пїЅпїЅ
пїЅпїЅпїЅPrograma  пїЅValidPerg пїЅAutor  пїЅPaulo Bindo         пїЅ Data пїЅ  12/01/05   пїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅН№пїЅпїЅ
пїЅпїЅпїЅDesc.     пїЅCria pergunta no e o help do SX1                            пїЅпїЅпїЅ
пїЅпїЅпїЅ          пїЅ                                                            пїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅН№пїЅпїЅ
пїЅпїЅпїЅUso       пїЅ AP                                                         пїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅНјпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
*/

Static Function ValidPerg(cPerg)

Local cKey := ""
Local aHelpEng := {}
Local aHelpPor := {}
Local aHelpSpa := {}

//PutSx1(cGrupo,cOrdem,cPergunt               ,cPerSpa               ,cPerEng          ,cVar		,cTipo ,nTamanho ,nDecimal,nPresel,cGSC,cValid	,cF3   , cGrpSxg   ,cPyme,cVar01    ,cDef01     ,cDefSpa1 ,cDefEng1,cCnt01,cDef02  		,cDefSpa2,cDefEng2,cDef03    ,cDefSpa3,cDefEng3,cDef04,cDefSpa4,cDefEng4,cDef05,cDefSpa5,cDefEng5,aHelpPor,aHelpEng,aHelpSpa,cHelp)
PutSx1(cPerg,"01"   ,"Produto inicial?	",""                    ,""                    ,"mv_ch1","C"   ,15      ,0       ,0      , "G",""    			,"SB1" ,""         ,""   ,"mv_par01",""        	 ,""      ,""      ,""    ,""      		,""     ,""      ,""    	  ,""      ,""      ,""    ,""      ,""     ,""    ,""      ,""      ,""      ,""      ,""      ,"")
PutSx1(cPerg,"02"   ,"Produto Final?	",""                    ,""                    ,"mv_ch2","C"   ,15      ,0       ,0      , "G",""    			,"SB1" ,""         ,""   ,"mv_par02",""		  	 ,""      ,""      ,""    ,""	        	,""     ,""      ,""  	 	  ,""      ,""      ,""    ,""      ,""     ,""    ,""      ,""      ,""      ,""      ,""      ,"")
PutSx1(cPerg,"03"   ,"Grupo Inicial?	",""                    ,""                    ,"mv_ch3","C"   ,04      ,0       ,0      , "G",""    			,"SBM" ,""         ,""   ,"mv_par03",""        	 ,""      ,""      ,""    ,""      		,""     ,""      ,""    	  ,""      ,""      ,""    ,""      ,""     ,""    ,""      ,""      ,""      ,""      ,""      ,"")
PutSx1(cPerg,"04"   ,"Grupo Final?		",""                    ,""                    ,"mv_ch4","C"   ,04      ,0       ,0      , "G",""    			,"SBM" ,""         ,""   ,"mv_par04",""		  	 ,""      ,""      ,""    ,""	        	,""     ,""      ,""    	  ,""      ,""      ,""    ,""      ,""     ,""    ,""      ,""      ,""      ,""      ,""      ,"")
PutSx1(cPerg,"05"   ,"Tipo Inicial?		",""                    ,""                    ,"mv_ch5","C"   ,02      ,0       ,0      , "G",""    			,"02"  ,""         ,""   ,"mv_par05",""        	 ,""      ,""      ,""    ,""      		,""     ,""      ,""    	  ,""      ,""      ,""    ,""      ,""     ,""    ,""      ,""      ,""      ,""      ,""      ,"")
PutSx1(cPerg,"06"   ,"Tipo Final?		",""                    ,""                    ,"mv_ch6","C"   ,02      ,0       ,0      , "G",""    			,"02"  ,""         ,""   ,"mv_par06",""		  	 ,""      ,""      ,""    ,""	        	,""     ,""      ,""    	  ,""      ,""      ,""    ,""      ,""     ,""    ,""      ,""      ,""      ,""      ,""      ,"")
PutSx1(cPerg,"07"   ,"Fornecedor?     	",""                    ,""                    ,"mv_ch7","C"   ,06      ,0       ,0      , "G",""    			,"SA2" ,""         ,""	  ,"mv_par07",""		  	 ,""      ,""      ,""    ,""	        	,""     ,""      ,""    	  ,""      ,""      ,""    ,""      ,""     ,""    ,""      ,""      ,""      ,""      ,""      ,"")
PutSx1(cPerg,"08"   ,"Desconto?     	",""                    ,""                    ,"mv_ch8","N"   ,05      ,2       ,0      , "G",""    			,""  	 ,""         ,""    ,"mv_par08",""		  	 ,""      ,""      ,""    ,""	        	,""     ,""      ,""    	  ,""      ,""      ,""    ,""      ,""     ,""    ,""      ,""      ,""      ,""      ,""      ,"")
PutSx1(cPerg,"09"   ,"Tabela?			  	",""                    ,""                    ,"mv_ch9","C"   ,03      ,0       ,0      , "G",""    			,""  	 ,""         ,""    ,"mv_par09",""		  	 ,""      ,""      ,""    ,""	        	,""     ,""      ,""    	  ,""      ,""      ,""    ,""      ,""     ,""    ,""      ,""      ,""      ,""      ,""      ,"")
PutSx1(cPerg,"10"   ,"Data de Vigencia? ",""                    ,""                    ,"mv_chA","D"   ,08      ,0       ,0      , "G",""    			,""  	 ,""         ,""    ,"mv_par10",""		  	 ,""      ,""      ,""    ,""	        	,""     ,""      ,""    	  ,""      ,""      ,""    ,""      ,""     ,""    ,""      ,""      ,""      ,""      ,""      ,"")



cKey     := "P.COMI0101."
aHelpEng := {}
aHelpPor := {}
aHelpSpa := {}
aAdd(aHelpEng,"")
aAdd(aHelpEng,"")
aAdd(aHelpPor,"Informe o codigo do Produto Inicial")
aAdd(aHelpPor,"")
aAdd(aHelpSpa,"")
aAdd(aHelpSpa,"")
PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa)


cKey     := "P.COMI0102."
aHelpEng := {}
aHelpPor := {}
aHelpSpa := {}
aAdd(aHelpEng,"")
aAdd(aHelpEng,"")
aAdd(aHelpPor,"Informe o codigo do Produto Final")
aAdd(aHelpPor,"")
aAdd(aHelpSpa,"")
aAdd(aHelpSpa,"")
PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa)

cKey     := "P.COMI0103."
aHelpEng := {}
aHelpPor := {}
aHelpSpa := {}
aAdd(aHelpEng,"")
aAdd(aHelpEng,"")
aAdd(aHelpPor,"Informe o Grupo Inicial")
aAdd(aHelpPor,"")
aAdd(aHelpSpa,"")
aAdd(aHelpSpa,"")
PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa)

cKey     := "P.COMI0104."
aHelpEng := {}
aHelpPor := {}
aHelpSpa := {}
aAdd(aHelpEng,"")
aAdd(aHelpEng,"")
aAdd(aHelpPor,"Informe o Grupo Final")
aAdd(aHelpPor,"")
aAdd(aHelpSpa,"")
aAdd(aHelpSpa,"")
PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa)


cKey     := "P.COMI0105."
aHelpEng := {}
aHelpPor := {}
aHelpSpa := {}
aAdd(aHelpEng,"")
aAdd(aHelpEng,"")
aAdd(aHelpPor,"Informe o Tipo de Produto Inicial ")
aAdd(aHelpPor,"")
aAdd(aHelpSpa,"")
aAdd(aHelpSpa,"")
PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa)

cKey     := "P.COMI0106."
aHelpEng := {}
aHelpPor := {}
aHelpSpa := {}
aAdd(aHelpEng,"")
aAdd(aHelpEng,"")
aAdd(aHelpPor,"Informe o Tipo de Produto Final ")
aAdd(aHelpPor,"")
aAdd(aHelpSpa,"")
aAdd(aHelpSpa,"")
PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa)

cKey     := "P.COMI0107."
aHelpEng := {}
aHelpPor := {}
aHelpSpa := {}
aAdd(aHelpEng,"")
aAdd(aHelpEng,"")
aAdd(aHelpPor,"Informe o cуdigo do ")
aAdd(aHelpPor,"Fornecedor")
aAdd(aHelpSpa,"")
aAdd(aHelpSpa,"")
PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa)

cKey     := "P.COMI0108."
aHelpEng := {}
aHelpPor := {}
aHelpSpa := {}
aAdd(aHelpEng,"")
aAdd(aHelpEng,"")
aAdd(aHelpPor,"Procentagem de Desconto do")
aAdd(aHelpPor,"Fornecedor")
aAdd(aHelpSpa,"")
aAdd(aHelpSpa,"")
PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa)

cKey     := "P.COMI0109."
aHelpEng := {}
aHelpPor := {}
aHelpSpa := {}
aAdd(aHelpEng,"")
aAdd(aHelpEng,"")
aAdd(aHelpPor,"Tabela de Preзo")
aAdd(aHelpPor,"Valida somente para reajuste")
aAdd(aHelpSpa,"")
aAdd(aHelpSpa,"")
PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa)

cKey     := "P.COMI0110."
aHelpEng := {}
aHelpPor := {}
aHelpSpa := {}
aAdd(aHelpEng,"")
aAdd(aHelpEng,"")
aAdd(aHelpPor,"Data de Vigкncia")
aAdd(aHelpPor,"Data padrao de vigкncia de todos os ")
aAdd(aHelpPor,"produtos que serгo gerados atraves ")
aAdd(aHelpPor,"da rotina.")
aAdd(aHelpSpa,"")
aAdd(aHelpSpa,"")
PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa)
Return


/*
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅН»пїЅпїЅ
пїЅпїЅпїЅPrograma  пїЅCOMI01EX  пїЅAutor  пїЅMicrosiga           пїЅ Data пїЅ  09/09/09   пїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅН№пїЅпїЅ
пїЅпїЅпїЅDesc.     пїЅEXPORTA A TABELA PARA O EXCEL                               пїЅпїЅпїЅ
пїЅпїЅпїЅ          пїЅ                                                            пїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅН№пїЅпїЅ
пїЅпїЅпїЅUso       пїЅ AP                                                        пїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅНјпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
*/

User Function COMI01EX()

Local n			:= 0

Private cArqTxt := "C:\TEMP\COMI01EXCEL.CSV"
Private nHdl    := fCreate(cArqTxt)
Private cEOL    := "CHR(13)+CHR(10)"
//MakeDir("C:\EXCEL\")


cQuery := " SELECT AIB_CODFOR,AIB_LOJFOR, AIB_CODTAB, AIB_CODPRO, AIB_PRCCOM, AIB__DESCO, AIB__VLRCH, B1_DESC " + ENTER
cQuery += " FROM "+RetSqlName("AIB") +" AIB" + ENTER
cQuery += " INNER JOIN "+RetSqlName("SB1") +" B1 " + ENTER
cQuery += "	ON B1_COD = AIB_CODPRO" + ENTER
cQuery += "	AND B1_FILIAL = '" + xFilial("SB1") + "'" + ENTER
cQuery += " WHERE AIB_FILIAL = '" + xFilial("AIB") + "' " + ENTER
cQuery += " 	AND AIB_CODTAB = '"+AIA->AIA_CODTAB+"'" + ENTER
cQuery += "	AND AIB_CODFOR = '"+AIA->AIA_CODFOR+"'" + ENTER
cQuery += "	AND B1.D_E_L_E_T_ <> '*'" + ENTER 
cQuery += "	AND AIB.D_E_L_E_T_ <> '*'"

MEMOWRIT("COMI01EX.SQL", cQuery )

dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'QUERY', .F., .T.)
Count To nRec

ProcRegua(nRec)

If nRec == 0
	MsgStop("Nгo foram encontrados dados!","Atenзгo - COMI01EX")
	QUERY->(dbCloseArea())
	Return
EndIf

//пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅДї
//пїЅ Cria o arquivo texto                                                пїЅ
//пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ

If Empty(cEOL)
	cEOL := CHR(13)+CHR(10)
Else
	cEOL := Trim(cEOL)
	cEOL := &cEOL
Endif

If nHdl == -1
	MsgAlert("O arquivo de nome "+cArqTxt+" esta em uso ou com probelmas! Verifique os parametros.","Atencao!")
	QUERY->(dbCloseArea())
	Return
Endif


For n := 1 to FCount()
	aTam := TamSX3(FieldName(n))
	If !Empty(aTam) .and. aTam[3] $ "N/D"
		TCSETFIELD('QUERY',FieldName(n),aTam[3],aTam[1],aTam[2])
	EndIf
Next

cLin    := ''
For n := 1 to FCount()
	cLin += AllTrim(Posicione("SX3",2,FieldName(n),"X3_TITULO"))
	
	IF n == FCount()
		cLin += cEOL
	Else
		cLin += ';'
	EndIf
Next

If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
	ConOut("Ocorreu um erro na gravacao do arquivo.")
	dbCloseArea()
	fClose(nHdl)
	Return
Endif



dbSelectArea("QUERY")
dbGotop()

While !Eof()
	
	IncProc("Processando Aguarde...")
	
	cLin    := ''
	For n := 1 to FCount()
		cLin += AllTrim(Transform(FieldGet(n),PesqPict(IIF(At('_',FieldName(n))=3,'S'+Left(FieldName(n),2),Left(FieldName(n),3)),FieldName(n))))
		cLin += IIF(n == FCount(),cEOL,';')
	Next
	
	
	//пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅДї
	//пїЅ Gravacao no arquivo texto. Testa por erros durante a gravacao da    пїЅ
	//пїЅ linha montada.                                                      пїЅ
	//пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
	
	If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
		ConOut("Ocorreu um erro na gravacao do arquivo.")
		TRB->(dbCloseArea())
		fClose(nHdl)
		Return
	Endif
	
	
	dbSelectArea("QUERY")
	dbSkip()
End
QUERY->(dbCloseArea())

fClose(nHdl)
If ! ApOleClient( 'MsExcel' )
	ShellExecute("open",cArqTxt,"","", 1 )
	Return
EndIf

oExcelApp := MsExcel():New()
oExcelApp:WorkBooks:Open( cArqTxt ) // Abre uma planilha
oExcelApp:SetVisible(.T.)

If MsgYesNo("Deseja fechar a planilha do excel?")
	oExcelApp:Quit()
	oExcelApp:Destroy()
EndIf

Return

/*
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅН»пїЅпїЅ
пїЅпїЅпїЅPrograma  пїЅCOMI01IP  пїЅAutor  пїЅPaulo Bindo         пїЅ Data пїЅ  16/04/12   пїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅН№пїЅпїЅ
пїЅпїЅпїЅDesc.     пїЅImporta TABELA PRECO do Fornecedor                          пїЅпїЅпїЅ
пїЅпїЅпїЅ          пїЅ                                                            пїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅН№пїЅпїЅ
пїЅпїЅпїЅUso       пїЅ AP                                                         пїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅНјпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
*/
User Function COMI01IP()
Local oOk		:= LoadBitMap(GetResources(), "LBOK")
Local oNo		:= LoadBitMap(GetResources(), "LBNO")
Local oDlg
Local oListBox
Local cListBox
Local lContinua := .T.
Local nOpc		:= 0
Local nF4For
Local oBmp1, oBmp2, oBmp3
Local lCampos 	:= .F.
Local cPerg2
Local aAreaAIA  := AIA->(GetArea())
Local lNew := .F.
Local lExcAnexo := .T.
Local lAnexo := .F.
Local nCont  := 0
Local l2Anexo := .F.
Local cZNChave := ""
Local lVariacaoPreco := .F.
Local nCMPmargem := U_TFmrgsx6()
Local nCMPdiasOk := U_TFmessx6()
Local nPrcHistorico := 0
Local cMensagem := ""
Local nCntDias := 0
Local cMensFlw := ""
Local nLinhasXls := 0
Local n			 := 0
Local z			 := 0
Local _cUsuario  := Alltrim(UsrRetName(RetCodUsr()))

Private aDados	:= {}
Private oDlgProdutos

cPerg2 := 'COMI1I'

Pergunta2(cPerg2)

cArquivo := RunDlg()

If Empty(cArquivo)
	MsgStop('Informe o Nome do Arquivo Padrao Texto!')
	Return
Endif

If !Pergunte(cPerg2,.T.)
	Return
Endif


If Empty(MV_PAR01)
	MsgStop('Informe a Coluna da Tabela!')
	Return
Endif

If Empty(MV_PAR02)
	MsgStop('Informe a Coluna do Produto!')
	Return
Endif

If Empty(MV_PAR03)
	MsgStop('Informe a Coluna do Preco Cheio!')
	Return
Endif

If Empty(MV_PAR04)
	MsgStop('Informe a Coluna do Desconto!')
	Return
Endif

If Empty(MV_PAR05)
	MsgStop('Informe o Caracter de Separacao. Exemplo ";" !')
	Return
Endif

If Empty(MV_PAR06)
	MsgStop('Informe a Coluna do Fornecedor!')
	Return
Endif

private cArq  :=''
private cArq2 :=''

if msgYesNo("Confirma a Importacao do Arquivo "+Alltrim(cArquivo)+", para anбlise?")
	SZW->(dbclearfil())
	
	CriaDbf2()
	DbSelectArea('TAB')
	append from &cArquivo sdf
	dbGoTop()
	ProcRegua(RecCount())
	_nCont := 0
	nLinhasXls := 0
	do while TAB->(!eof())
		nLinhasXls += 1
		IncProc()
		If Empty(CAMPO) .OR. (nLinhasXls=1 .AND. MV_PAR07=1)  
			DbSkip()
			Loop
		Endif
		lNew := .F.
		cTabela := StrZero(Val(AllTrim(ProcCol(MV_PAR01,CAMPO))),3)
		
		_cProduto := StrZero(Val(AllTrim(ProcCol(MV_PAR02,CAMPO))),9)
		
		nPreco  := 0
		cPreco	:= ProcCol(MV_PAR03,CAMPO)
		cPreco 	:= StrTran(cPreco,".","")
		cPreco 	:= StrTran(cPreco,",",".")
		nPreco  := Val(cPreco)
		
		If nPreco == 0
			MsgAlert("O Produto "+_cProduto+" estб com preзo ZERO e nгo serб importado","Atenзгo - COMI01IP")
			dbSelectArea("TAB")
			dbSkip()
			Loop
		EndIf
		
		
		cDesc	:= ProcCol(MV_PAR04,CAMPO)
		cDesc 	:= StrTran(cDesc,".","")
		cDesc 	:= StrTran(cDesc,",",".")
		nDesc    := Val(cDesc)
		
		cFornece := StrZero(Val(AllTrim(ProcCol(MV_PAR06,CAMPO))),6)
		cLoja := "01"
		If cFornece="001431"
			cLoja := "02"
		EndIf
				
		//IMPORTA A LINHA
		dbSelectArea("AIB")
		dbSetOrder(2)
		If !dbSeek(xFilial()+cFornece+cLoja+cTabela+_cProduto)
			lNew := .T.
		EndIf
		dbSelectArea("SB1")
		dbSetOrder(1)
		If !dbSeek(xFilial()+_cProduto)
			MsgAlert("O Produto "+_cProduto+" nгo foi encontrado no cadastro de produto e nгo serб importado","Atenзгo - COMI01IP")
			dbSelectArea("TAB")
			dbSkip()
			Loop
		EndIf
		lContinua := U_COAT01Busca(_cProduto,cFornece)
		If lContinua
			//01-LEGENDA, 02- OK, 03- FORNECEDOR, 04- LOJA, 05 - TABELA, 06-PRODUTO, 07-DESCRICAO, 08-MARCA, 09- PRECO CHEIO, 10-%DESCONTO
			//aAdd(aDados,{Iif(lNew,LoadBitMap(GetResources(),"BR_VERDE"),LoadBitMap(GetResources(),"BR_BRANCO")),.F.,cFornece, cLoja,cTabela, _cProduto,SB1->B1_DESC, SB1->B1_PYNFORN,nPreco,nDesc})
			aAdd(aDados,{Iif(lNew,LoadBitMap(GetResources(),"BR_VERDE"),LoadBitMap(GetResources(),"BR_BRANCO")),.F.,cFornece, cLoja,cTabela, _cProduto,SB1->B1_DESC, SB1->B1_ITEMCC,nPreco,nDesc})
		EndIf
		dbSelectArea("TAB")
		dbSkip()
	End
	dbSelectArea("TAB")
	dbCloseArea()
	if file(cArq2+".DBF")
		fErase(cArq2+".DBF")
	endif
	
	If Len(aDados) == 0
		MsgStop("Nгo existem dados para este relatуrio!","Atenзгo")
		Return
	EndIf
	//MONTA O CABECALHO
	cFields := " "
	nCampo 	:= 0
	
	//01-LEGENDA, 02- OK, 03- FORNECEDOR, 04- LOJA, 05 - TABELA, 06-PRODUTO, 07-DESCRICAO, 08-MARCA, 09- PRECO CHEIO, 10-%DESCONTO
	aTitCampos := {" "," ",OemToAnsi("Fornecedor"),OemToAnsi("Loja"),OemToAnsi("Tabela"),OemToAnsi("Produto"),OemToAnsi("Descriзгo"),OemToAnsi("Marca"),OemToAnsi("Preco Cheio"),OemToAnsi("Desconto")}
	
	cLine := "{aDados[oListBox:nAT][1],If(aDados[oListBox:nAt,2],oOk,oNo),aDados[oListBox:nAT][3],aDados[oListBox:nAT][4],aDados[oListBox:nAT][5],"
	cLine += " aDados[oListBox:nAT][6],aDados[oListBox:nAT][7],aDados[oListBox:nAT][8],aDados[oListBox:nAT][9],aDados[oListBox:nAT][10],}"
	
	
	bLine := &( "{ || " + cLine + " }" )
	
	@ 100,005 TO 550,950 DIALOG oDlgProdutos TITLE "Produtos"
	
	oListBox := TWBrowse():New( 17,4,450,160,,aTitCampos,,oDlgProdutos,,,,,,,,,,,,.F.,,.T.,,.F.,,,)
	oListBox:SetArray(aDados)
	oListBox:bLDblClick := { || aDados[oListBox:nAt,2] := !aDados[oListBox:nAt,2] }
	
	
	oListBox:bLine := bLine
	
	@ 183,010 BUTTON "Marca Tudo"         SIZE 40,15 ACTION (MarcaTodos(oListBox, .F., .T.,0)) PIXEL OF oDlgProdutos
	@ 183,060 BUTTON "Desm. Tudo"         SIZE 40,15 ACTION (MarcaTodos(oListBox, .F., .F.,0)) PIXEL OF oDlgProdutos
	
	@ 183,110 BUTTON "Atualizar"  SIZE 40,15 ACTION {nOpc :=1,oDlgProdutos:End()}  PIXEL OF oDlgProdutos
	@ 183,160 BUTTON "Sair"       SIZE 40,15 ACTION {nOpc :=0,oDlgProdutos:End()} PIXEL OF oDlgProdutos
	
	@ 205,005 BITMAP oBmp1 ResName "BR_VERDE" OF oDlgProdutos Size 10,10 NoBorder When .F. Pixel
	@ 205,015 SAY "Novo Item" OF oDlgProdutos Color CLR_BLUE,CLR_BLACK PIXEL
	
	@ 205,065 BITMAP oBmp2 ResName "BR_BRANCO" OF oDlgProdutos Size 10,10 NoBorder When .F. Pixel
	@ 205,075 SAY "Item a Alterar" OF oDlgProdutos Color CLR_BLACK,CLR_WHITE PIXEL
	
	ACTIVATE DIALOG oDlgProdutos CENTERED
	
Endif

//ATUALIZA OS ITENS
If nOpc == 1
	
	For n:=1 To Len(aDados)
		If aDados[n][2]
			nCont ++
		EndIf
	Next
	
	
	If nCont > 1
		lAnexo := .T.
	EndIf
	
	cQuery := " SELECT ISNULL(MAX(AIB_ITEM),0) ITEM FROM "+RetSqlName("AIB") +" AIB"
	cQuery += " INNER JOIN "+RetSqlName("SB1") +" B1 ON B1_COD = AIB_CODPRO"
	cQuery += " WHERE AIB_CODTAB = '"+AIA->AIA_CODTAB+"'"
	cQuery += " AND B1.D_E_L_E_T_ <> '*' AND AIB.D_E_L_E_T_ <> '*'"
	
	MEMOWRITE("COMI01IP.SQL", cQuery )
	
	dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'QUERY', .F., .T.)
	dbSelectArea("QUERY")
	dbGoTop()
	cItem := QUERY->ITEM
	QUERY->(dbCloseArea())
	cProCntDias := ""
	
	lVariacaoPreco := .F.
	For z:=1 To Len(aDados)
		If aDados[z][2]
			dbSelectArea("AIB")
			dbSetOrder(2)
			lAumento := .F.
			nPrcBl := 0
			If dbSeek(xFilial()+aDados[z][3]+aDados[z][4]+aDados[z][5]+aDados[z][6]) .And. aDados[z][9] > 0 //ALTERA
				nCntDias := 0
				//Verificar a existencia de alteraпїЅпїЅo de tabela dentro do prazo
				cQuery := " SELECT * FROM "+RetSqlName("SZN") + ENTER
				cQuery += " WHERE ZN_CODFOR = '"+aDados[z][3]+"' AND ZN_CODPRO = '"+aDados[z][6]+"'" + ENTER
				cQuery += " AND D_E_L_E_T_ <> '*' " + ENTER
				cQuery += " AND ZN_DATA >= '" + DTOS( Ddatabase - nCMPdiasOk ) + "' "
				
				MEMOWRITE("COMI01IMPVLD.sql",cQuery)
				dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TRBCM0",.T.,.T.)
				
				Count To nCntDias
				TRBCM0->(dbCloseArea())
				
				RecLock("AIB",.F.)
				nPrcHistorico := AIB_PRCCOM
				
				AIB__VLRCH	:= aDados[z][9]
				AIB__DESCO	:= aDados[z][10]
				AIB__OBS	:= "ATUALIZADO VIA PLANILHA EM "+Dtoc(dDataBase)+" POR "+Substr(cUsuario,7,15)
				nNewPrc := (aDados[z][9] *((100-aDados[z][10])/100))
				//QUANDO O PRECO FOR MAIOR BLOQUEIA PARA ANALISE DA DIRETORIA
				If AIB_PRCCOM = (aDados[z][9] *((100-aDados[z][10])/100))
					AIB_PRCCOM  := aDados[z][9] *((100-aDados[z][10])/100)
				Else
					If AIB->AIB_PRCCOM < nNewPrc
						nAjuste :=  ((nNewPrc/AIB->AIB_PRCCOM)-1)*100
					ElseIf AIB->AIB_PRCCOM > nNewPrc
						nAjuste :=  (1-(nNewPrc/AIB->AIB_PRCCOM))*100
					EndIf
					If ( nAjuste > nCMPmargem ) .OR. nCMPmargem = 0 .or. nCntDias > 0
						AIB__PREPR  := aDados[z][9] *((100-aDados[z][10])/100)
						lAumento := .T.
						lVariacaoPreco := .T.
						nPrcBl   := aDados[z][9] *((100-aDados[z][10])/100)
						If Empty(cMensFlw)
							SA2->(DbSetOrder(1))
							SA2->(DbSeek( xFilial("SA2") + AIB->AIB_CODFOR + AIB->AIB_LOJFOR))
							cMensFlw += CHR(13) + "Tabela de preзo " + Alltrim(AIB->AIB_CODTAB) + " do fornecedor " + AIB->AIB_CODFOR + " - " + Alltrim(SA2->A2_NOME) + " sofreu intervenзгo."
							cMensFlw += CHR(13) + "e estб aguardando aprovaзгo da controladoria."
							cMensFlw += CHR(13) + "Origem: COMMI002 - Manutenзгo Tab. Preзo - Autor: " + _cUsuario 
							cMensFlw += CHR(13) + CHR(13) + space(20) + "** e-mail automбtico, nгo responda! ** "
						EndIf
					Else
						AIB_PRCCOM  := aDados[z][9] *((100-aDados[z][10])/100)
					EndIf
				EndIf
								
				AIB->(MsUnlock())
				
				If lAumento
					  
					//VERIFICA SE JA EXISTE UM REGISTRO SEM APROVACAO E O ALTERA
					cQuery := " SELECT * FROM "+RetSqlName("SZN")
					cQuery += " WHERE ZN_CODFOR = '"+aDados[z][3]+"' AND ZN_CODPRO = '"+aDados[z][6]+"'"
					cQuery += " AND D_E_L_E_T_ <> '*' AND ZN_APROV = ''"
					
					MEMOWRITE("COMI01IMPEXC.sql",cQuery)
					dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TRBCM0",.T.,.T.)
					
					Count To nRec1
					
					If nRec1 > 0
						dbSelectArea("TRBCM0")
						dbGoTop()
					    MsgStop("Jб existe aprovaзгo pendente para o cуdigo do produto: "+aDados[z][6]+", o produto nгo terб seu preзo alterado","COMMI002")
					/*	
						dbSelectArea("SZN")
						dbSetOrder(2)
						If dbSeek(xFilial()+aDados[z][3]+aDados[z][6])
							If Empty(SZN->ZN_APROV)
								RecLock("SZN",.F.)
								ZN_PRCCOM 	:= nPrcBl
								ZN_DATA		:= dDataBase
								ZN_USERINC  := SubStr(cUsuario,7,15)
								ZN_HRINC    := Time()
							EndIf
						EndIf
						//MONTA CHAVE PARA ARQUIVO
						If Empty(cZNChave)
							cZNChave := 'SZN'+xFilial()+TRBCM0->ZN_CODPRO+TRBCM0->ZN_COD
						EndIf
					*/	
					Else
						dbSelectArea("SZN")
						cNumSZN := GetSx8Num("SZN","ZN_COD")
						If Empty(cZNChave)
							cZNChave := 'SZN'+xFilial()+aDados[z][6]+cNumSZN
						EndIf
						
						RecLock("SZN",.T.)
						ZN_FILIAL 	:= xFilial()
						ZN_COD		:= cNumSZN
						ZN_CODTAB	:= aDados[z][5]
						ZN_CODFOR	:= aDados[z][3]
						ZN_CODPRO	:= aDados[z][6]
						ZN_PRCCOM 	:= nPrcBl
						ZN_DATA		:= dDataBase
						ZN_USERINC  := SubStr(cUsuario,7,15)
						ZN_HRINC    := Time()
						ZN_ARQUIVO 	:= cZNChave
						ZN_ANEXO 	:= "S"
						ZN_PRCANT	:= nPrcHistorico
						SZN->(ConfirmSX8())
						SZN->(MsUnlock())
					EndIf
					//EFETUA A PERGUNTA DE ANEXO PARA TUDO E GRAVA PARA O PRIMEIRO ITEM
					If lAnexo .And. nRec1 == 0
						U_SelArqSQL(cZNChave,.T.,.T.)
						l2Anexo := .T.
						lAnexo := .F.
					EndIf
					TRBCM0->(dbCloseArea())					
				EndIf
			ElseIf aDados[z][9] > 0 //INCLUI
				//PEGA O ULTIMO NUMERO
				dbSelectArea("AIB")
				dbSetOrder(1)
				dbSeek(xFilial()+aDados[z][3]+aDados[z][4]+aDados[z][5]) //ALTERA
				While !Eof() .And. AIB->AIB_CODTAB ==aDados[z][5] .And. AIB_CODFOR	 == aDados[z][3]
					cItem := AIB->AIB_ITEM
					dbSkip()
				End
				
				dbSelectArea("AIB")
				cItem := Soma1(cItem,Len(AIB->AIB_ITEM))
				RecLock("AIB",.T.)
				AIB_FILIAL	:= xFilial("AIB")
				AIB_CODFOR	:= aDados[z][3]
				AIB_LOJFOR	:= aDados[z][4]
				AIB_CODTAB	:= aDados[z][5]
				AIB_ITEM	:= cItem
				AIB_CODPRO	:= aDados[z][6]
				AIB_PRCCOM  := aDados[z][9] *((100-aDados[z][10])/100)
				AIB_MOEDA	:= 1
				AIB_DATVIG	:= Ctod("")
				AIB__VLRCH	:= aDados[z][9]
				AIB__DESCO	:= aDados[z][10]
				AIB__OBS	:= "INCLUIDO VIA PLANILHA EM "+Dtoc(dDataBase)+" POR "+Substr(cUsuario,7,15)
				AIB_QTDLOT  := 999999.99
				AIB_INDLOT  := "000000000999999.99"
				AIB->(MsUnlock())
			EndIf
		EndIf
	Next
	cMensPad := "Tabela Atualizada com Sucesso!"
	
	If .NOT. EMPTY(cProCntDias)
		cMensPad := "Tabela Atualizada com restriзхes!"
		cProCntDias := CHR(13) + "Houve alteraзгo recente dentro do prazo estipulado de " + Alltrim(Str(nCMPdiasOk)) + " dias, para os produtos: " + cProCntDias
	EndIf
	
	If lVariacaoPreco
		cMensPad := "Tabela Atualizada com restriзхes!"
		cMensagem := CHR(13) + "Houve variaзгo da tabela de preзo, solicite aprovaзгo da Controladoria"
	EndIf
	MsgInfo(cMensPad + cMensagem + cProCntDias )
	
	If .NOT. Empty(cMensFlw) 
		If U_EnvMail("workflow@taiff.com.br", cMailDest, "Manutenзгo Tabela de Preзo de Compra ", OemToAnsi(cMensFlw))
			conout("workflow enviado para Manutenзгo Tabela de Preзo de Compra")
		EndIf
	EndIf

Else
	MsgInfo("Tabela nгo Atualizada!")
EndIf

RestArea(aAreaAIA)
return

/*
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅН»пїЅпїЅ
пїЅпїЅпїЅPrograma  пїЅCOMMI001  пїЅAutor  пїЅMicrosiga           пїЅ Data пїЅ  05/05/12   пїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅН№пїЅпїЅ
пїЅпїЅпїЅDesc.     пїЅ                                                            пїЅпїЅпїЅ
пїЅпїЅпїЅ          пїЅ                                                            пїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅН№пїЅпїЅ
пїЅпїЅпїЅUso       пїЅ AP                                                        пїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅНјпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
*/

static function Pergunta2(cPerg2)
Local cKey := ""
Local aHelpEng := {}
Local aHelpPor := {}
Local aHelpSpa := {}

//PutSx1(cGrupo,cOrdem,cPergunt               ,cPerSpa               ,cPerEng               ,cVar	 ,cTipo ,nTamanho,nDecimal,nPresel,cGSC,cValid			,cF3   	, cGrpSxg    ,cPyme,cVar01    ,cDef01     ,cDefSpa1,cDefEng1,cCnt01,cDef02    		,cDefSpa2,cDefEng2,cDef03       ,cDefSpa3,cDefEng3,cDef04,cDefSpa4,cDefEng4,cDef05,cDefSpa5,cDefEng5,aHelpPor,aHelpEng,aHelpSpa,cHelp)
PutSx1(cPerg2,"01"   ,"Coluna Tabela   		?",""                    ,""                    ,"mv_ch1","N"   ,02      ,0       ,0      , "G",""    			,"" 	,""         ,""   ,"mv_par01",""		   	 ,""      ,""      ,""    ,""	        	,""     ,""      ,""  	 	  ,""      ,""      ,""    ,""      ,""     ,""    ,""      ,""      ,""      ,""      ,""      ,"")
PutSx1(cPerg2,"02"   ,"Coluna Produto  		?",""                    ,""                    ,"mv_ch2","N"   ,02      ,0       ,0      , "G",""    			,"" 	,""         ,""   ,"mv_par02",""		   	 ,""      ,""      ,""    ,""	        	,""     ,""      ,""  	 	  ,""      ,""      ,""    ,""      ,""     ,""    ,""      ,""      ,""      ,""      ,""      ,"")
PutSx1(cPerg2,"03"   ,"Coluna Preco   		?",""                    ,""                    ,"mv_ch3","N"   ,02      ,0       ,0      , "G",""    			,"" 	,""         ,""   ,"mv_par03",""		   	 ,""      ,""      ,""    ,""	        	,""     ,""      ,""  	 	  ,""      ,""      ,""    ,""      ,""     ,""    ,""      ,""      ,""      ,""      ,""      ,"")
PutSx1(cPerg2,"04"   ,"Coluna Desconto 		?",""                    ,""                    ,"mv_ch4","N"   ,02      ,0       ,0      , "G",""    			,"" 	,""         ,""   ,"mv_par04",""		   	 ,""      ,""      ,""    ,""	        	,""     ,""      ,""  	 	  ,""      ,""      ,""    ,""      ,""     ,""    ,""      ,""      ,""      ,""      ,""      ,"")
PutSx1(cPerg2,"05"   ,"Caracter Separacao	?",""                    ,""                    ,"mv_ch5","C"   ,01      ,0       ,0      , "G",""    			,"" 	,""         ,""   ,"mv_par05",""		   	 ,""      ,""      ,""    ,""	        	,""     ,""      ,""  	 	  ,""      ,""      ,""    ,""      ,""     ,""    ,""      ,""      ,""      ,""      ,""      ,"")
PutSx1(cPerg2,"06"   ,"Coluna Fornecedor	?",""                    ,""                    ,"mv_ch6","N"   ,02      ,0       ,0      , "G",""    			,"" 	,""         ,""   ,"mv_par06",""		   	 ,""      ,""      ,""    ,""	        	,""     ,""      ,""  	 	  ,""      ,""      ,""    ,""      ,""     ,""    ,""      ,""      ,""      ,""      ,""      ,"")
PutSx1(cPerg2,"07"   ,"1a. Linha cabeзalho	?",""                    ,""                    ,"mv_ch7","N"   ,01      ,0       ,0      , "C",""    			,"" 	,""         ,""   ,"mv_par07","Sim"	    ,""      ,""      ,""    ,"Nao"	        	,""     ,""      ,""  	 	  ,""      ,""      ,""    ,""      ,""     ,""    ,""      ,""      ,""      ,""      ,""      ,"")

cKey     := "P."+cPerg2+"01."
aHelpEng := {}
aHelpPor := {}
aHelpSpa := {}
aAdd(aHelpEng,"")
aAdd(aHelpEng,"")
aAdd(aHelpPor,"Informe a coluna da planilha")
aAdd(aHelpPor,"que contem o cуdigo da tabela de preзo")
aAdd(aHelpSpa,"")
aAdd(aHelpSpa,"")
PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa)

cKey     := "P."+cPerg2+"02."
aHelpEng := {}
aHelpPor := {}
aHelpSpa := {}
aAdd(aHelpEng,"")
aAdd(aHelpEng,"")
aAdd(aHelpPor,"Informe a coluna da planilha")
aAdd(aHelpPor,"que contem o cуdigo do Produto")
aAdd(aHelpSpa,"")
aAdd(aHelpSpa,"")
PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa)

cKey     := "P."+cPerg2+"03."
aHelpEng := {}
aHelpPor := {}
aHelpSpa := {}
aAdd(aHelpEng,"")
aAdd(aHelpEng,"")
aAdd(aHelpPor,"Informe a coluna da planilha")
aAdd(aHelpPor,"que contem o preзo sem desconto")
aAdd(aHelpSpa,"")
aAdd(aHelpSpa,"")
PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa)


cKey     := "P."+cPerg2+"04."
aHelpEng := {}
aHelpPor := {}
aHelpSpa := {}
aAdd(aHelpEng,"")
aAdd(aHelpEng,"")
aAdd(aHelpPor,"Informe a coluna da planilha")
aAdd(aHelpPor,"que contem a porcentagem de desconto")
aAdd(aHelpSpa,"")
aAdd(aHelpSpa,"")
PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa)


cKey     := "P."+cPerg2+"05."
aHelpEng := {}
aHelpPor := {}
aHelpSpa := {}
aAdd(aHelpEng,"")
aAdd(aHelpEng,"")
aAdd(aHelpPor,"Informe qual o caracter")
aAdd(aHelpPor,"que separa as colunas no arquivo")
aAdd(aHelpPor,"geralmente й ponto e virgula")
aAdd(aHelpSpa,"")
aAdd(aHelpSpa,"")
PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa)

cKey     := "P."+cPerg2+"06."
aHelpEng := {}
aHelpPor := {}
aHelpSpa := {}
aAdd(aHelpEng,"")
aAdd(aHelpEng,"")
aAdd(aHelpPor,"Informe a coluna da planilha")
aAdd(aHelpPor,"que contem o codigo do Fornecedor")
aAdd(aHelpSpa,"")
aAdd(aHelpSpa,"")
PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa)

cKey     := "P."+cPerg2+"07."
aHelpEng := {}
aHelpPor := {}
aHelpSpa := {}
aAdd(aHelpEng,"")
aAdd(aHelpEng,"")
aAdd(aHelpPor,"Informe se 1a. linha do arquivo")
aAdd(aHelpPor,"й apenas cabeзalho")
aAdd(aHelpSpa,"")
aAdd(aHelpSpa,"")
PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa)

return
/*
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅН»пїЅпїЅ
пїЅпїЅпїЅPrograma  пїЅMarcaTodosпїЅAutor  пїЅPaulo Carnelossi    пїЅ Data пїЅ  04/11/04   пїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅН№пїЅпїЅ
пїЅпїЅпїЅDesc.     пїЅMarca todos as opcoes do list box - totalizadores           пїЅпїЅпїЅ
пїЅпїЅпїЅ          пїЅ                                                            пїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅН№пїЅпїЅ
пїЅпїЅпїЅUso       пїЅ AP                                                         пїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅНјпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
*/
Static Function MarcaTodos(oListBox, lInverte, lMarca,nItem,nPos)
Local nX

If nItem = 0
	For nX := 1 TO Len(oListbox:aArray)
		InverteSel(oListBox,nX, lInverte, lMarca,0)
	Next
Else
	lRet := InverteSel(oListBox,nPos, lInverte, lMarca,1)
	Return(lRet)
EndIf

Return

/*
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅН»пїЅпїЅ
пїЅпїЅпїЅPrograma  пїЅInverteSelпїЅAutor  пїЅPaulo Carnelossi    пїЅ Data пїЅ  04/11/04   пїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅН№пїЅпїЅ
пїЅпїЅпїЅDesc.     пїЅInverte Selecao do list box - totalizadores                 пїЅпїЅпїЅ
пїЅпїЅпїЅ          пїЅ                                                            пїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅН№пїЅпїЅ
пїЅпїЅпїЅUso       пїЅ AP                                                         пїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅНјпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
*/
Static Function InverteSel(oListBox,nLin, lInverte, lMarca,nItem)


If lInverte
	oListbox:aArray[nLin,2] := ! oListbox:aArray[nLin,2]
Else
	If lMarca
		oListbox:aArray[nLin,2] := .T.
	Else
		oListbox:aArray[nLin,2] := .F.
	EndIf
EndIf
Return

/*/
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅН»пїЅпїЅ
пїЅпїЅпїЅFunпїЅпїЅo    пїЅ RUNDLG   пїЅ Autor пїЅ Luiz Carlos Vieira пїЅ Data пїЅThu  24/09/98пїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅН№пїЅпїЅ
пїЅпїЅпїЅDescriпїЅпїЅo пїЅ Executa o dialogo selecionado pelo usuario em FunNovos     пїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅН№пїЅпїЅ
пїЅпїЅпїЅUso		 пїЅ EspecпїЅfico para clientes Microsiga						  пїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅНјпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
/*/


Static Function RunDlg()
Private cFile

cTipo :=         "Retorno (*.CSV)          | *.CSV | "
cTipo := cTipo + "Todos os Arquivos  (*.*) |   *.*   |"

cFile := cGetFile(cTipo,"Dialogo de Selecao de Arquivos")

If Empty(cFile)
	MsgStop("Cancelada a Selecao!","Voce cancelou o Processo.")
	Return
EndIf
Return(cFile)

/*
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅН»пїЅпїЅ
пїЅпїЅпїЅPrograma  пїЅcriaDBF2  пїЅAutor  пїЅMicrosiga           пїЅ Data пїЅ  06/25/09   пїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅН№пїЅпїЅ
пїЅпїЅпїЅDesc.     пїЅ                                                            пїЅпїЅпїЅ
пїЅпїЅпїЅ          пїЅ                                                            пїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅН№пїЅпїЅ
пїЅпїЅпїЅUso       пїЅ AP                                                         пїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅНјпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
*/

static function criaDBF2()
aFields :={}
aadd(aFields,{"CAMPO","C",200,0})
cArq2:=criatrab(aFields,.T.)
dbUseArea(.t.,,cArq2,"TAB")
return

/*
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅН»пїЅпїЅ
пїЅпїЅпїЅPrograma  пїЅRFATM09   пїЅAutor  пїЅMicrosiga           пїЅ Data пїЅ  06/25/09   пїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅН№пїЅпїЅ
пїЅпїЅпїЅDesc.     пїЅ                                                            пїЅпїЅпїЅ
пїЅпїЅпїЅ          пїЅ                                                            пїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅН№пїЅпїЅ
пїЅпїЅпїЅUso       пїЅ AP                                                        пїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅНјпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
*/

Static Function ProcCol(nCol,cString)
Local cTexto := ""
Local nX	 := 0

cString := cString+";"

nPos 	:= 1
For nX := 1 To nCol
	cTexto  := SubStr(cString,1,At(";",cString)-1)
	nPos := At(";",cString)+1
	cString :=  SubStr(cString,nPos,Len(cString))
Next

Return(cTexto)

/*
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅН»пїЅпїЅ
пїЅпїЅпїЅPrograma  пїЅCOAT01Simu  пїЅAutor  пїЅMicrosiga         пїЅ Data пїЅ  08/09/12   пїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅН№пїЅпїЅ
пїЅпїЅпїЅDesc.     пїЅ SIMULA A DIGITACAO DA POLITICA DE PRECO                    пїЅпїЅпїЅ
пїЅпїЅпїЅ          пїЅ                                                            пїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅН№пїЅпїЅ
пїЅпїЅпїЅUso       пїЅ AP                                                         пїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅНјпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
*/

User Function COAT01Simu()
Local cCampo    := AllTrim(ReadVar())
Local cConteudo := &(ReadVar())
Local cProd 	:= Buscacols("AIB_CODPRO")
/*
Na TAIFF nпїЅo se aplica
dbSelectArea("SZW")
dbSetOrder(1)
If dbSeek(xFilial()+cProd)
	AxAltera("SZW",recno(),4,,,,,".F.")
Else
	MsgStop("PolпїЅtica ainda nпїЅo cadastrada!","COMMI001")
EndIf
*/
Return(cConteudo)


/*
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅН»пїЅпїЅ
пїЅпїЅпїЅPrograma  пїЅCOAT01BuscaпїЅAutor  пїЅMicrosiga          пїЅ Data пїЅ  08/14/12   пїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅН№пїЅпїЅ
пїЅпїЅпїЅDesc.     пїЅVERIFICA SE O PRODUTO JA EXISTE NA TABELA DE PRECOS DE      пїЅпїЅпїЅ
пїЅпїЅпїЅ          пїЅFORNECEDOR                                                  пїЅпїЅпїЅ
пїЅпїЅпїЅ          пїЅEXP1 - CODIGO PRODUTO                                       пїЅпїЅпїЅ
пїЅпїЅпїЅ          пїЅEXP2 - CODIGO FORNECEDOR                                    пїЅпїЅпїЅ
пїЅпїЅпїЅ          пїЅEXP3 - VALIDA DUPLICIDADE MESMA TABELA                      пїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅН№пїЅпїЅ
пїЅпїЅпїЅUso       пїЅ AP                                                         пїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅНјпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
*/
User Function COAT01Busca(cCodPro, cCodFor, lDupli)
Local nRecBus := 0
Local lExiste := .T.
Local aArea := GetArea()
Local nPosProd
Local nPosItem
Local _nVez	:= 0

If lDupli
	nPosProd  := AsCan(aHeader,{|x|Alltrim(Upper(x[2]))=='AIB_CODPRO'})
	nPosItem	:= AsCan(aHeader,{|x|Alltrim(Upper(x[2]))=='AIB_ITEM'})
EndIf
If ValType(lDupli) == 'U'
	lDupli := .F.
EndIf

cQuery := " SELECT * FROM "+RetSqlName("AIB")
//cQuery += " WHERE AIB_CODPRO = '"+cCodPro+"' AND AIB_CODFOR <> '"+cCodFor+"'" // Regra nпїЅo valida na TAIFF
cQuery += " WHERE AIB_CODPRO = '"+cCodPro+"' AND AIB_CODFOR = '"+cCodFor+"'" 
cQuery += " AND D_E_L_E_T_ <> '*'"
cQuery += " AND AIB_FILIAL='" + xFilial("AIB") + "'"

MEMOWRITE("COMMI002C.sql",cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TRBBUS",.T.,.T.)

Count To nRecBus

dbSelectArea("TRBBUS")
dbGoTop()


If nRecBus > 1 // 
	MsgStop("O produto "+cCodPro+"jб existe na tabela de preco do fornecedor "+TRBBUS->AIB_CODFOR+" !","Atenзгo - COAT01Busca")
	lExiste := .F.
EndIf

TRBBUS->(dbCloseArea())

If lDupli
	
	for _nVez:=1 to len(aCols)
		If !( aCols[_nVez][Len(aHeader)+1] )
			//VERIFICA PRODUTO DUPLICADO
			If  aCols[n,nPosProd] == aCols[_nVez,nPosProd] .And. _nVez # n
				MsgStop("Este Produto "+aCols[_nVez,nPosProd]+" jб existe neste tabela na Linha "+aCols[_nVez,nPosItem]+"!")
				lExiste := .F.
			EndIf
			
		Endif
	Next
	
EndIf
RestArea(aArea)
Return(lExiste)


/*
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅН»пїЅпїЅ
пїЅпїЅпїЅPrograma  пїЅCOMMI001  пїЅAutor  пїЅMicrosiga           пїЅ Data пїЅ  08/12/13   пїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅН№пїЅпїЅ
пїЅпїЅпїЅDesc.     пїЅ                                                            пїЅпїЅпїЅ
пїЅпїЅпїЅ          пїЅ                                                            пїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅН№пїЅпїЅ
пїЅпїЅпїЅUso       пїЅ AP                                                        пїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅНјпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
*/
User Function COMI1PRC()
Local nNewPrc 	:= Buscacols("AIB_PRCCOM")
Local cProdTab 	:= Buscacols("AIB_CODPRO")
Local nPrc		:= aScan(aHeader,{|x| AllTrim(x[2])=="AIB__PREPR"})
Local nCMPmargem := U_TFmrgsx6()
Local nCMPdiasOk := U_TFmessx6()
Local cMensj := ""
Local nAjuste := 0

If !INCLUI
	dbSelectArea("AIB")
	dbSetOrder(2)
	If dbSeek(xFilial()+M->AIA_CODFOR+M->AIA_LOJFOR+M->AIA_CODTAB+cProdTab) //ALTERA
	
		nCntDias := 0
		//Verificar a existencia de alteraпїЅпїЅo de tabela dentro do prazo
		cQuery := " SELECT * FROM "+RetSqlName("SZN") + ENTER
		cQuery += " WHERE ZN_CODFOR = '"+AIA->AIA_CODFOR+"' AND ZN_CODPRO = '"+Buscacols("AIB_CODPRO")+"'" + ENTER
		cQuery += " AND D_E_L_E_T_ <> '*' " + ENTER
		cQuery += " AND ZN_DATA >= '" + DTOS( Ddatabase - nCMPdiasOk ) + "' "
				
		MEMOWRITE("COMI1PRC_IMPVLD.sql",cQuery)
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TRBCM0",.T.,.T.)
				
		Count To nCntDias
		
		TRBCM0->(dbCloseArea())
		dbSelectArea("AIB")
		If AIB->AIB_PRCCOM < nNewPrc
			nAjuste :=  ((nNewPrc/AIB->AIB_PRCCOM)-1)*100
		ElseIf AIB->AIB_PRCCOM > nNewPrc
			nAjuste :=  (1-(nNewPrc/AIB->AIB_PRCCOM))*100
		EndIf
		If nCMPmargem = 0
			cMensj := "Margem de validaзгo nгo existe, e passarб por liberaзгo da Diretoria!"
		EndIf
		If ( nAjuste > nCMPmargem ) .OR. nCMPmargem = 0 .OR. nCntDias>0
			If nCntDias > 0
				cMensj += CHR(13) + "Alteraзгo dentro do intervalo de tempo permitido desde a ultima intervenзгo"
			EndIf
			aCols[n][nPrc] := nNewPrc
			MsgAlert("Este item estб tendo alteraзгo de preзo, e passarб por liberaзгo da Diretoria!" + CHR(13) + cMensj,"COMMI002")
			Return(AIB->AIB_PRCCOM)
		Else
			aCols[n][nPrc]:= 0
		EndIf
	Else
		MsgAlert("Item nгo encontrado na tabela")
	EndIf
	dbSelectArea("AIB")
EndIf
Return(nNewPrc)




/*
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅН»пїЅпїЅ
пїЅпїЅпїЅPrograma  пїЅCOMMI001  пїЅAutor  пїЅMicrosiga           пїЅ Data пїЅ  08/13/13   пїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅН№пїЅпїЅ
пїЅпїЅпїЅDesc.     пїЅ                                                            пїЅпїЅпїЅ
пїЅпїЅпїЅ          пїЅ                                                            пїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅН№пїЅпїЅ
пїЅпїЅпїЅUso       пїЅ AP                                                        пїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅНјпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
*/

User Function COMI1Aprov()

Local oOk		:= LoadBitMap(GetResources(), "LBOK")
Local oNo		:= LoadBitMap(GetResources(), "LBNO")
Local cCodUsu
Local c2Perg	:= "COMI1A"
Local lConsulta := .F.
Local mv_parA01  := mv_par01
Local mv_parA02  := mv_par02
Local mv_parA03  := mv_par03
Local mv_parA04  := mv_par04
Local mv_parA05  := mv_par05
Local cNmFornece:= Left(Posicione("SA2",1, xFilial("SA2") + AIA->AIA_CODFOR + AIA->AIA_LOJFOR,"A2_NOME"),30)
Private oDlgPeds

If !MsgYesNo("A tabela de preзo a considerar serб a do fornecedor selecionado." + ENTER + "Fornecedor: " + AIA->AIA_CODFOR + " - " + cNmFornece + ENTER + "Deseja efetuar liberaзгo de preзos?","COMMI002")
	Valid2Perg(c2Perg)
	If !Pergunte(c2Perg,.T.)
		mv_par01 := mv_parA01
		mv_par02 := mv_parA02
		mv_par03 := mv_parA03
		mv_par04 := mv_parA04
		mv_par05 := mv_parA05
		
		Return
	EndIf
	lConsulta := .T.
Endif


//VERIFICA SE EXISTEM REGISTROS SEM APROVACAO
cQuery := " SELECT * FROM "+RetSqlName("SZN")+" ZN" + ENTER
cQuery += " INNER JOIN "+RetSqlName("SA2")+" A2 ON A2_COD = ZN_CODFOR" + ENTER
IF AIA->AIA_CODFOR = "001431"
	cQuery += " AND A2_LOJA = '02' " + ENTER
EndIf
cQuery += " INNER JOIN "+RetSqlName("SB1")+" B1 ON B1_COD = ZN_CODPRO AND B1_FILIAL='"+xFilial("SB1")+"'" + ENTER
cQuery += " LEFT JOIN "+RetSqlName("AIB")+" AIB ON AIB_CODTAB = ZN_CODTAB " + ENTER
cQuery += " 	AND AIB_CODPRO = ZN_CODPRO " + ENTER
cQuery += " 	AND AIB_FILIAL='"+xFilial("AIB")+"' " + ENTER
cQuery += " 	AND AIB_CODFOR = ZN_CODFOR" + ENTER
cQuery += "	AND AIB.D_E_L_E_T_='' " + ENTER
cQuery += " WHERE ZN.D_E_L_E_T_ <> '*' " + ENTER
If !lConsulta
	cQuery += "	AND ZN_APROV =''" + ENTER
Else
	cQuery += " AND ZN_CODPRO BETWEEN '"+mv_par01+"' AND '"+mv_par02+"'" + ENTER
	cQuery += " AND ZN_DATA BETWEEN '"+Dtos(mv_par03)+"' AND '"+Dtos(mv_par04)+"' " + ENTER
	If !Empty(mv_par05)
		//cQuery += " AND B1_PYMARCA = '"+mv_par05+"'" + ENTER
	EndIf
EndIf
cQuery += " AND A2.D_E_L_E_T_ <> '*' AND B1.D_E_L_E_T_ <> '*'" + ENTER
cQuery += " AND ZN_CODFOR='" + AIA->AIA_CODFOR + "'" + ENTER
cQuery += " ORDER BY ZN_CODPRO" + ENTER

MEMOWRITE("COMI1Aprov.sql",cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TRBCM0",.T.,.T.)

Count To nRec1

If nRec1 == 0
	MsgStop("Nгo existe preзo com bloqueio!","COMMI002")
	TRBCM0->(dbCloseArea())
	mv_par01 := mv_parA01
	mv_par02 := mv_parA02
	mv_par03 := mv_parA03
	mv_par04 := mv_parA04
	mv_par05 := mv_parA05
	
	Return
Else
	aAprov := {}
	dbSelectArea("TRBCM0")
	dbGoTop()
	While !Eof()
		//1- SEMAFORO, 2-CODIGO PRODUTO, 3-DESCRICAO, 4-FORNECEDOR, 5- PRECO ATUAL, 6-NOVO PRECO, 7- %, 8- ANEXO ,9-CODIGO ZN,10-MARK, 11-TIPO, 12 - IPI ATUAL, 13- NOVO IPI, 14- ICMS ATUAL, 15- NOVO ICMS, 16- ARQUIVO
		cCor := Iif(Empty(TRBCM0->ZN_APROV) .And. TRBCM0->ZN_TIPO # "F",LoadBitMap(GetResources(),"BR_VERMELHO"),Iif( AllTrim(TRBCM0->ZN_APROV)=="REJEITADO",LoadBitMap(GetResources(),"BR_AMARELO"),Iif(Empty(TRBCM0->ZN_APROV) .And. TRBCM0->ZN_TIPO=="F",LoadBitMap(GetResources(),"BR_PRETO"),LoadBitMap(GetResources(),"BR_VERDE"))))
		cTipo := Iif(TRBCM0->ZN_TIPO=="F","Fiscal","Compras")
		If  TRBCM0->AIB_PRCCOM > TRBCM0->AIB__PREPR //REDUCAI
			nPorcP :=  (1-(TRBCM0->AIB_PRCCOM/TRBCM0->AIB__PREPR))*100
		Else //AUMENTO
			nPorcP :=(1-(TRBCM0->AIB__PREPR/TRBCM0->AIB_PRCCOM))*-100
		EndIf
		
		aAdd(aAprov,{cCor,TRBCM0->ZN_CODPRO, TRBCM0->B1_DESC,TRBCM0->ZN_CODFOR,TRBCM0->AIB_PRCCOM,TRBCM0->AIB__PREPR,Transform(nPorcP,"999.99"),TRBCM0->ZN_ANEXO,TRBCM0->ZN_COD,.F.,cTipo,Iif(cTipo=="Compras",0,TRBCM0->B1_IPI),Iif(cTipo=="Compras",0,TRBCM0->B1__IPI), Iif(cTipo=="Compras",0,TRBCM0->B1_PICM),Iif(cTipo=="Compras",0,TRBCM0->B1__ICMS),TRBCM0->ZN_ARQUIVO })
		dbSkip()
	End
EndIf

TRBCM0->(dbCloseArea())
dbSelectArea("SM0")
cCodUsu:= RetCodUsr()

//tela para LIBERACAO/REJEICAO
c5Fields := " "
n5Campo 	:= 0

//1- SEMAFORO,02- ok, 3-anexo, 4-CODIGO PRODUTO, 5-DESCRICAO, 6-FORNECEDOR, 7- PRECO ATUAL, 8-NOVO PRECO, 9- %, 10- ANEXO
a5TitCampos := {'','',OemToAnsi("Anexo"),OemToAnsi("Cod.Prod."),OemToAnsi("DescriпїЅпїЅo"),OemToAnsi("Fornecedor"),OemToAnsi("PreпїЅo atual"),OemToAnsi("Novo PreпїЅo"),OemToAnsi("%"),OemToAnsi("Tipo"),OemToAnsi("Codigo"),OemToAnsi("IPI Atual"),OemToAnsi("Novo IPI"),OemToAnsi("ICMS Atual"),OemToAnsi("Novo ICMS"),''}
nMult := 7
aCoord := {nMult*1,nMult*1,nMult*2,nMult*6,nMult*8,nMult*8,nMult*6,nMult*6,nMult*5,''}


c5Line := "{aAprov[o5ListBox:nAT][1],If(aAprov[o5ListBox:nAT][10],oOk,oNo),aAprov[o5ListBox:nAT][8],aAprov[o5ListBox:nAT][2],aAprov[o5ListBox:nAT][3],aAprov[o5ListBox:nAT][4],aAprov[o5ListBox:nAT][5],"
c5Line += " aAprov[o5ListBox:nAT][6],aAprov[o5ListBox:nAT][7],aAprov[o5ListBox:nAT][11],aAprov[o5ListBox:nAT][9],aAprov[o5ListBox:nAT][12],aAprov[o5ListBox:nAT][13],aAprov[o5ListBox:nAT][14],aAprov[o5ListBox:nAT][15],''}"

b5Line := &( "{ || " + c5Line + " }" )

@050,005 TO 450,950  DIALOG oDlgPeds TITLE "Aumento Preзo Fornecedor"
o5ListBox := TWBrowse():New( 10,4,450,130,,a5TitCampos,aCoord,oDlgPeds,,,,,,,,,,,,.F.,,.T.,,.F.,,,)
o5ListBox:SetArray(aAprov)
If !lConsulta
	o5ListBox:bLDblClick := { || (U_COM1MARK(aAprov[o5ListBox:nAT][4],o5Listbox,o5Listbox:nAt),o5Listbox:Refresh()) }
EndIf
o5ListBox:bLine := b5Line


@ 170, 005 BITMAP oBmp1 ResName 	"BR_VERDE" OF oDlgPeds Size 15,15 NoBorder When .F. Pixel
@ 170, 015 SAY "Aprovado" OF oDlgPeds Color CLR_GREEN PIXEL

@ 170, 080 BITMAP oBmp2 ResName 	"BR_VERMELHO" OF oDlgPeds Size 15,15 NoBorder When .F. Pixel
@ 170, 095 SAY "Pendente PreпїЅo" OF oDlgPeds Color CLR_RED PIXEL

@ 170, 155 BITMAP oBmp3 ResName 	"BR_PRETO" OF oDlgPeds Size 15,15 NoBorder When .F. Pixel
@ 170, 170 SAY "Pendente Imposto" OF oDlgPeds Color CLR_RED PIXEL


@ 170, 230 BITMAP oBmp3 ResName 	"BR_AMARELO" OF oDlgPeds Size 15,15 NoBorder When .F. Pixel
@ 170, 245 SAY "Rejeitado" OF oDlgPeds Color CLR_RED PIXEL

If U_CHECAFUNC(cCodUsu,"COMMI002") .And. !lConsulta
	@ 180,005 BUTTON "Aprovar"    	SIZE 40,15 ACTION (U_COMILib("1"),o5ListBox:Refresh()) PIXEL OF oDlgPeds
EndIf
If !lConsulta
	@ 180,050 BUTTON "Rejeitar"   	SIZE 40,15 ACTION (U_COMILib("2"),o5ListBox:Refresh()) PIXEL OF oDlgPeds
EndIf


@ 180,095 BUTTON "Anexo"   		SIZE 40,15 ACTION (U_SelArqSQL(aAprov[o5ListBox:nAt,16],.F.,.F.)) PIXEL OF oDlgPeds
@ 180,140 BUTTON "Ults.Aumentos"   	SIZE 40,15 ACTION (U_COMRL002(aAprov[o5ListBox:nAt,2])) PIXEL OF oDlgPeds
@ 180,185 BUTTON "An.Inventario"	SIZE 40,15 ACTION {U_RCOMA11(aAprov[o5ListBox:nAt,2],"01")} PIXEL OF oDlgPeds
If !lConsulta
	@ 180,230 BUTTON "Marca Tudo"   SIZE 40,15 ACTION (M2arcaTodos(o5ListBox, .F., .T.,0)) PIXEL OF oDlgPeds
	@ 180,275 BUTTON "Desm. Tudo"   SIZE 40,15 ACTION (M2arcaTodos(o5ListBox, .F., .F.,0)) PIXEL OF oDlgPeds
EndIf
@ 180,320 BUTTON "Imprimir"   		SIZE 40,15 ACTION (U_ImpOlist(a5TitCampos,c5Line,o5ListBox,"COMMI002.CSV")) PIXEL OF oDlgPeds
@ 180,420 BUTTON "Sair" 			SIZE 40,15 ACTION (oDlgPeds:End()) PIXEL OF oDlgPeds


ACTIVATE DIALOG oDlgPeds CENTERED


mv_par01 := mv_parA01
mv_par02 := mv_parA02
mv_par03 := mv_parA03
mv_par04 := mv_parA04
mv_par05 := mv_parA05
Return


/*
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅН»пїЅпїЅ
пїЅпїЅпїЅPrograma  пїЅCOMILib   пїЅAutor  пїЅMicrosiga           пїЅ Data пїЅ  08/13/13   пїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅН№пїЅпїЅ
пїЅпїЅпїЅDesc.     пїЅAPROVA OU REJEITA PRECO DE COMPRAS                          пїЅпїЅпїЅ
пїЅпїЅпїЅ          пїЅ                                                            пїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅН№пїЅпїЅ
пїЅпїЅпїЅUso       пїЅ AP                                                         пїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅНјпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
*/
User Function COMILib(cExec)
Local cProdRej 	:= "PRODUTOS"+ENTER
Local cEmailAdm	:= GETMV("MV_WFADMIN")
Local cEmalCom 	:= "compras@inforshop.com.br;marinho.britto@inforshop.com.br"
Local cMensEr2		:= ""
Local CFORNLOJA	:= "01"
Local Kx		:= 0


If cExec == "1" //LIBERA
	For Kx:=1 To Len(aAprov)
		If aAprov[Kx][10]
			//1- SEMAFORO, 2-CODIGO PRODUTO, 3-DESCRICAO, 4-FORNECEDOR, 5- PRECO ATUAL, 6-NOVO PRECO, 7- %, 8- ANEXO ,9-CODIGO ZN,10-MARK, 11-TIPO, 12 - IPI ATUAL, 13- NOVO IPI, 14- ICMS ATUAL, 15- NOVO ICMS
			//ENVIA EMAIL PARA COMPRAS
			cMensEr2 += "Produto: "+aAprov[Kx][2]+"-"+aAprov[Kx][3] + ENTER
			cMensEr2 += "R$ Antigo:"+ Transform(aAprov[Kx][5],"@E 9,999,999.99")  +ENTER
			cMensEr2 += "R$ Novo:"+ Transform(aAprov[Kx][6],"@E 9,999,999.99") +ENTER
			cMensEr2 += "%:"+ Transform(aAprov[Kx][7],"@E 999.99") +ENTER

			//ATUALIZA TABELA DE APROVACAO
			dbSelectArea("SZN")
			dbSetOrder(3)
			If dbSeek(xFilial()+aAprov[Kx][9])
				RecLock("SZN",.F.)
				ZN_DATAAPR	:= dDataBase
				ZN_APROV  := SubStr(cUsuario,7,15)
				ZN_HRAPROV  := Time()
				SZN->(MsUnlock())
				
				If aAprov[Kx][11] == "Compras"
					CFORNLOJA := "01"
					IF SZN->ZN_CODFOR = "001431"
						CFORNLOJA := "02"
					EndIf
					//ATUALIZA TABELA DE PRECO
					dbSelectArea("AIB")
					dbSetOrder(2)
					If dbSeek(xFilial()+SZN->ZN_CODFOR+CFORNLOJA+AllTrim(SZN->ZN_CODTAB)+SZN->ZN_CODPRO)
						If AIB__PREPR > 0
							RecLock("AIB",.F.)
							AIB_PRCCOM := AIB__PREPR
							AIB__PREPR := 0
							AIB->(MsUnlock())
						Else
							conout("preco negativo")
							conout(xFilial()+SZN->ZN_CODFOR+CFORNLOJA+AllTrim(SZN->ZN_CODTAB)+SZN->ZN_CODPRO)
							conout(RECNO())
						EndIf
					Else
						CONOUT("NГO ACHOU AIB")
					EndIf
				EndIf
				o5ListBox:aArray[Kx,10] := .F.
				o5ListBox:aArray[Kx,1] := LoadBitMap(GetResources(),"BR_VERDE"   )
			EndIf
		EndIf
	Next
	
	//U_EnvMail('avisos@inforshop.net.br',cEmailAdm+";"+cEmalCom,'',cMensEr2,'Aprovacao de Reajuste de Compras/impostos' ,"")
ElseIf cExec == "2" //REJEITA
	cMotivo := Space(74)
	c2Motivo:= Space(74)
	
	While Empty(cMotivo)
		@ 65,153 To 229,635 Dialog oDlg Title OemToAnsi("REJEICAO DE PRECOS")
		@ 9,9 Say OemToAnsi("MOTIVO DA REJEICAO") Size 99,10
		@ 28,9 Get cMotivo Picture "@!" Size 190,10
		@ 47,9 Get c2Motivo Picture "@!" Size 190,10
		
		@ 62,39 BMPBUTTON TYPE 1 ACTION Close(oDlg)
		Activate Dialog oDlg Centered
	End
	
	//ENVIA EMAIL PARA COMPRAS
	cMensEr2 := AllTrim(cMotivo)+ ENTER
	cMensEr2 += AllTrim(c2Motivo)+ENTER
	cMensEr2 += cProdRej
	
	//ATUALIZA TABELA DE APROVACAO
	For Kx:=1 To Len(aAprov)
		If aAprov[Kx][10]
			
			cMensEr2 += "Produto: "+aAprov[Kx][2]+"-"+aAprov[Kx][3] + ENTER
			cMensEr2 += "R$ Antigo:"+ Transform(aAprov[Kx][5],"@E 9,999,999.99")  +ENTER
			cMensEr2 += "R$ Novo:"+ Transform(aAprov[Kx][6],"@E 9,999,999.99") +ENTER
			cMensEr2 += "%:"+ Transform(aAprov[Kx][7],"@E 999.99") +ENTER
			
			dbSelectArea("SZN")
			dbSetOrder(3)
			If dbSeek(xFilial()+aAprov[Kx][9])
				While ! Eof() .And. aAprov[Kx][9] == SZN->ZN_COD
					If !Empty(SZN->ZN_APROV)
						dbSkip()
						Loop
					EndIf
					cProdRej += aAprov[Kx][2]+"-"+aAprov[Kx][3]+ENTER
					RecLock("SZN",.F.)
					ZN_DATAAPR	:= dDataBase
					ZN_APROV    := "REJEITADO"
					ZN_HRAPROV  := Time()
					ZN_MOTIVO   := 	AllTrim(cMotivo)+ Space(2)+AllTrim(	c2Motivo)
					
					SZN->(MsUnlock())
					If 	aAprov[Kx][11] == "Compras"
						//ATUALIZA TABELA DE PRECO
						//ATUALIZA TABELA DE PRECO
						CFORNLOJA := "01"
						IF SZN->ZN_CODFOR = "001431"
							CFORNLOJA := "02"
						EndIf
						dbSelectArea("AIB")
						dbSetOrder(2)
						If dbSeek(xFilial()+SZN->ZN_CODFOR+CFORNLOJA+AllTrim(SZN->ZN_CODTAB)+SZN->ZN_CODPRO)
							RecLock("AIB",.F.)
							AIB__PREPR := 0
							AIB->(MsUnlock())
						EndIf
					Else
						dbSelectArea("SB1")
						dbSetOrder(1)
						dbSeek(xFilial()+SZN->ZN_CODPRO)
						RecLock("SB1",.F.)
						//B1__IPI := 0
						//B1__ICMS := 0
						SB1->(MsUnlock())
					EndIf
					
					dbSelectArea("SZN")
					dbSkip()
				End
			EndIf
			o5ListBox:aArray[Kx,10] := .F.
			o5ListBox:aArray[Kx,1] := LoadBitMap(GetResources(),"BR_AMARELO")
		EndIf
	Next
	
	
	//U_EnvMail('avisos@inforshop.net.br',cEmailAdm+";"+cEmalCom,'',cMensEr2,'Rejeicao de Reajuste de Compras/impostos' ,"")
EndIf


Return

/*
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅН»пїЅпїЅ
пїЅпїЅпїЅPrograma  пїЅCOM1MARK  пїЅAutor  пїЅMicrosiga           пїЅ Data пїЅ  08/20/13   пїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅН№пїЅпїЅ
пїЅпїЅпїЅDesc.     пїЅVERIFICA SE EXISTE MAIS QUE UM PRODUTO DO MESMO FORNECEDOR  пїЅпїЅпїЅ
пїЅпїЅпїЅ          пїЅE MARCA TODOS                                               пїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅН№пїЅпїЅ
пїЅпїЅпїЅUso       пїЅ AP                                                         пїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅНјпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
*/
User Function COM1MARK(cFornecedor,o5Listbox,nPos )
Local lFirst := .F.
Local lMarkOk := .T.
Local cCodUsu
Local z := 0

dbSelectArea("SM0")
cCodUsu:= RetCodUsr()

For z:=1 To Len(o5Listbox:aArray)
	If cFornecedor == o5Listbox:aArray[z,4]
		lFirst := .T.
	EndIf
Next

If lFirst
	If !MsgYesNo("Deseja marcar todos os produtos do mesmo fornecedor?","COMMI002")
		//MARCA SOMENTE DO QUE FOI CLICADO
		If o5Listbox:aArray[nPos,10]
			o5Listbox:aArray[nPos,10] := .F.
		Else
			o5Listbox:aArray[nPos,10] := .T.
		EndIf
		Return
	EndIf
	
	For z:=1 To Len(o5Listbox:aArray)
		If cFornecedor == o5Listbox:aArray[z,4]
			o5Listbox:aArray[z,10] := .T.
		EndIf
	Next
EndIf

Return
/*
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅН»пїЅпїЅ
пїЅпїЅпїЅPrograma  пїЅInverteSelпїЅAutor  пїЅPaulo Carnelossi    пїЅ Data пїЅ  04/11/04   пїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅН№пїЅпїЅ
пїЅпїЅпїЅDesc.     пїЅInverte Selecao do list box - totalizadores                 пїЅпїЅпїЅ
пїЅпїЅпїЅ          пїЅ                                                            пїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅН№пїЅпїЅ
пїЅпїЅпїЅUso       пїЅ AP                                                         пїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅНјпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
*/
Static Function I2nverteSel(oListBox,nLin, lInverte, lMarca,nItem)


If lInverte
	oListbox:aArray[nLin,10] := ! oListbox:aArray[nLin,10]
Else
	If lMarca
		oListbox:aArray[nLin,10] := .T.
	Else
		oListbox:aArray[nLin,10] := .F.
	EndIf
EndIf

Return

/*
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅН»пїЅпїЅ
пїЅпїЅпїЅPrograma  пїЅMarcaTodosпїЅAutor  пїЅPaulo Carnelossi    пїЅ Data пїЅ  04/11/04   пїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅН№пїЅпїЅ
пїЅпїЅпїЅDesc.     пїЅMarca todos as opcoes do list box - totalizadores           пїЅпїЅпїЅ
пїЅпїЅпїЅ          пїЅ                                                            пїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅН№пїЅпїЅ
пїЅпїЅпїЅUso       пїЅ AP                                                         пїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅНјпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
*/
Static Function M2arcaTodos(oListBox, lInverte, lMarca,nItem,nPos)

Local nX
//Local cQPedido := ""

If nItem = 0
	For nX := 1 TO Len(oListbox:aArray)
		lRet := I2nverteSel(oListBox,nX, lInverte, lMarca,0)
	Next
Else
	lRet := I2nverteSel(oListBox,nPos, lInverte, lMarca,1)
EndIf

oDlgPeds:Refresh()

Return

/*
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅН»пїЅпїЅ
пїЅпїЅпїЅPrograma  пїЅVERIMPSB1 пїЅAutor  пїЅMicrosiga           пїЅ Data пїЅ  08/20/13   пїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅН№пїЅпїЅ
пїЅпїЅпїЅDesc.     пїЅVALIDA SE HOUBE AUMENTO ICMS OU IPI NO CADSATRO DO PRODUTO  пїЅпїЅпїЅ
пїЅпїЅпїЅ          пїЅ                                                            пїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅН№пїЅпїЅ
пїЅпїЅпїЅUso       пїЅ AP                                                         пїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅНјпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
*/
User Function VERIMPSB1()
Local aArea	    :=GetArea()
Local cCampo    := AllTrim(ReadVar())
Local cConteudo := &(ReadVar())
If ALTERA .And. M->B1__BLQFIS # "S"
	If cCampo == "M->B1_IPI"
		If M->B1_IPI > SB1->B1_IPI
			M->B1__IPI  := M->B1_IPI
			M->B1__ICMS := M->B1_PICM
			cConteudo  := SB1->B1_IPI
			MsgAlert("O Campo de IPI foi alterado e passarб por aprovaзгo da Diretoria!","COMI001")
		Else
			M->B1__IPI := 0
		EndIf
	ElseIf cCampo == "M->B1_PICM"
		If M->B1_PICM > SB1->B1_PICM
			M->B1__ICMS := M->B1_PICM
			M->B1__IPI  := M->B1_IPI
			cConteudo  := SB1->B1_PICM
			MsgAlert("O Campo de ICMS foi alterado e passarб por aprovaзгo da Diretoria!","COMI001")
		Else
			M->B1__ICMS := 0
		EndIf
	EndIf
EndIf


Return(cConteudo)



/*
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅН»пїЅпїЅ
пїЅпїЅпїЅPrograma  пїЅVERFISSB1 пїЅAutor  пїЅMarcelo Sanches     пїЅ Data пїЅ  11/12/2013 пїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅН№пїЅпїЅ
пїЅпїЅпїЅDesc.     пїЅVALIDA SE QUEM ESTA ALTERANDO OS CAMPOS DA ABA FISCAL DA    пїЅпїЅпїЅ
пїЅпїЅпїЅ          пїЅTABELA SB1 FAZ PARTE DO GRUPO DE USUARIOS FISCAL            пїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅН№пїЅпїЅ
пїЅпїЅпїЅUso       пїЅINFORSHOP                                                   пїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅНјпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
*/
User Function VERFISSB1()

Local _aGrpUSR := " "
Local _lAutFis := .T.
Local _cCampo  := AllTrim(ReadVar())
Local _nTamCPO := Len(_cCampo)
Local _cCampo2 := SubStr(_cCampo,4,_nTamCPO)
Local _xVarMem := &(ReadVar())
Local _xContBD := "SB1->"+_cCampo2

If ALTERA
	_aGrpUSR := UsrRetGrp()
	
	If AllTrim(_aGrpUSR[1]) <> "000015" .And. RetCodUsr() # "000000"
		
		If _xVarMem <> &_xContBD
			_lAutFis := .F.
			&(_cCampo) := _xContBD
			MsgAlert("Vocк nгo tem autorizaзгo para modificar campos da aba Fiscal/Impostos!","COMI001")
			Return (&_xContBD)
		EndIf
		
	EndIf
EndIf

Return (_xVarMem)

/*
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅН»пїЅпїЅ
пїЅпїЅпїЅPrograma  пїЅValidPerg пїЅAutor  пїЅPaulo Bindo         пїЅ Data пїЅ  12/01/05   пїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅН№пїЅпїЅ
пїЅпїЅпїЅDesc.     пїЅCria pergunta no e o help do SX1                            пїЅпїЅпїЅ
пїЅпїЅпїЅ          пїЅ                                                            пїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅН№пїЅпїЅ
пїЅпїЅпїЅUso       пїЅ AP                                                         пїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅНјпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
*/

Static Function Valid2Perg(c2Perg)

Local cKey := ""
Local aHelpEng := {}
Local aHelpPor := {}
Local aHelpSpa := {}

//PutSx1(cGrupo,cOrdem,cPergunt               ,cPerSpa               ,cPerEng          ,cVar		,cTipo ,nTamanho ,nDecimal,nPresel,cGSC,cValid	,cF3   , cGrpSxg   ,cPyme,cVar01    ,cDef01     ,cDefSpa1 ,cDefEng1,cCnt01,cDef02  		,cDefSpa2,cDefEng2,cDef03    ,cDefSpa3,cDefEng3,cDef04,cDefSpa4,cDefEng4,cDef05,cDefSpa5,cDefEng5,aHelpPor,aHelpEng,aHelpSpa,cHelp)
PutSx1(c2Perg,"01"   ,"Produto inicial?	",""                    ,""                    ,"mv_ch1","C"   ,15      ,0       ,0      , "G",""    			,"SB1" 	,""         ,""   ,"mv_par01",""        	 ,""      ,""      ,""    ,""      		,""     ,""      ,""    	  ,""      ,""      ,""    ,""      ,""     ,""    ,""      ,""      ,""      ,""      ,""      ,"")
PutSx1(c2Perg,"02"   ,"Produto Final?	",""                    ,""                    ,"mv_ch2","C"   ,15      ,0       ,0      , "G",""    			,"SB1" 	,""         ,""   ,"mv_par02",""		  	 ,""      ,""      ,""    ,""	       	,""     ,""      ,""  	 	  ,""      ,""      ,""    ,""      ,""     ,""    ,""      ,""      ,""      ,""      ,""      ,"")
PutSx1(c2Perg,"03"   ,"Da Data?			",""                    ,""                    ,"mv_ch3","D"   ,08      ,0       ,0      , "G",""    			,""	 	,""         ,""   ,"mv_par03",""        	 ,""      ,""      ,""    ,""      		,""     ,""      ,""    	  ,""      ,""      ,""    ,""      ,""     ,""    ,""      ,""      ,""      ,""      ,""      ,"")
PutSx1(c2Perg,"04"   ,"Ate a Data?		",""                    ,""                    ,"mv_ch4","D"   ,08      ,0       ,0      , "G",""    			,"" 	,""         ,""   ,"mv_par04",""		  	 ,""      ,""      ,""    ,""	       	,""     ,""      ,""    	  ,""      ,""      ,""    ,""      ,""     ,""    ,""      ,""      ,""      ,""      ,""      ,"")
PutSx1(c2Perg,"05"   ,"Marca?	     	",""                    ,""                    ,"mv_ch5","C"   ,15      ,0       ,0      , "G",""    			,"" 	,""         ,""	  ,"mv_par05",""		  	 ,""      ,""      ,""    ,""	       	,""     ,""      ,""    	  ,""      ,""      ,""    ,""      ,""     ,""    ,""      ,""      ,""      ,""      ,""      ,"")



cKey     := "P.COMI1A01."
aHelpEng := {}
aHelpPor := {}
aHelpSpa := {}
aAdd(aHelpEng,"")
aAdd(aHelpEng,"")
aAdd(aHelpPor,"Informe o codigo do Produto Inicial")
aAdd(aHelpPor,"")
aAdd(aHelpSpa,"")
aAdd(aHelpSpa,"")
PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa)


cKey     := "P.COMI1A02."
aHelpEng := {}
aHelpPor := {}
aHelpSpa := {}
aAdd(aHelpEng,"")
aAdd(aHelpEng,"")
aAdd(aHelpPor,"Informe o codigo do Produto Final")
aAdd(aHelpPor,"")
aAdd(aHelpSpa,"")
aAdd(aHelpSpa,"")
PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa)

cKey     := "P.COMI1A03."
aHelpEng := {}
aHelpPor := {}
aHelpSpa := {}
aAdd(aHelpEng,"")
aAdd(aHelpEng,"")
aAdd(aHelpPor,"Informe a Data Inicial")
aAdd(aHelpPor,"")
aAdd(aHelpSpa,"")
aAdd(aHelpSpa,"")
PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa)

cKey     := "P.COMI1A04."
aHelpEng := {}
aHelpPor := {}
aHelpSpa := {}
aAdd(aHelpEng,"")
aAdd(aHelpEng,"")
aAdd(aHelpPor,"Informe a Data Final")
aAdd(aHelpPor,"")
aAdd(aHelpSpa,"")
aAdd(aHelpSpa,"")
PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa)


cKey     := "P.COMI1A05."
aHelpEng := {}
aHelpPor := {}
aHelpSpa := {}
aAdd(aHelpEng,"")
aAdd(aHelpEng,"")
aAdd(aHelpPor,"Informe a Marca do Produto ")
aAdd(aHelpPor,"")
aAdd(aHelpSpa,"")
aAdd(aHelpSpa,"")
PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa)


Return


/*
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅН»пїЅпїЅ
пїЅпїЅпїЅPrograma  пїЅChecaFunc пїЅAutor  пїЅPaulo Bindo         пїЅ Data пїЅ  04/18/11   пїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅН№пїЅпїЅ
пїЅпїЅпїЅDesc.     пїЅVERIFICA SE O USUARIO TEM PERMISSAO PARA USAR A ROTINA      пїЅпїЅпїЅ
пїЅпїЅпїЅ          пїЅ                                                            пїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅН№пїЅпїЅ
пїЅпїЅпїЅUso       пїЅ AP                                                         пїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅНјпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
*/

User Function ChecaFunc(cUsuCod,cFuncaoU)
Local lRet := .F.
Local aArea := GetArea()
Local cQuery
Local cParFil := "1"

If ValType(cUsuCod) == "U"
              MsgStop("Usuбrio sem premissгo para utilizar esta rotina","CHECAFUNC")
              RestArea(aArea)
              Return(lRet)
ElseIf    ValType(cFuncaoU) == "U"
              RestArea(aArea)
              MsgStop("Usuбrio sem premissгo para utilizar esta rotina","CHECAFUNC")
              Return(lRet)
EndIf

//quando for adminitrador libera
If cUsuCod $ "000000"
              Return(.T.)
EndIf

If cFilAnt == "01" .And. cEmpAnt == "01"
              cParFil := "1"
ElseIf cFilAnt == "02" .And. cEmpAnt == "01"
              cParFil := "2"
ElseIf cFilAnt == "01" .And. cEmpAnt == "03"
              cParFil := "3"
ElseIf cFilAnt == "02" .And. cEmpAnt == "03"
              cParFil := "4"
ElseIf cFilAnt == "03" .And. cEmpAnt == "03"
              cParFil := "5"
ElseIf cFilAnt == "01" .And. cEmpAnt == "04"
              cParFil := "6"
ElseIf cFilAnt == "02" .And. cEmpAnt == "04"
              cParFil := "7"
EndIf

cQuery := " SELECT COUNT(ZV_CODUSU) NCOUNT FROM "+RetSqlName("SZV")+" WITH(NOLOCK)"
cQuery += " WHERE ZV_CODUSU = '"+cUsuCod+"' AND ZV_FUNCAO = '"+cFuncaoU+"'"
cQuery += " AND ZV_MSBLQL <> '1' AND D_E_L_E_T_ <> '*' AND ZV_ATIVO = 'S'"
cQuery += " AND ZV_FILUSO LIKE '%"+cParFil+"%'"

MemoWrite("CHECAFUNC.SQL",cQuery)
dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),"TRBCH", .F., .T.)

dbSelectArea("TRBCH")
If TRBCH->NCOUNT > 0
              lRet := .T.
EndIf
TRBCH->(dbCloseArea())
RestArea(aArea)
Return(lRet)

/*
------------------------------------------------------------------------------
Cria parametro com margem de percentual de preпїЅo 
------------------------------------------------------------------------------
*/
User Function TFmrgsx6()
Local aArea	:=	GetArea()

dbSelectArea( "SX6" )
dbSetOrder(1)
If !dbSeek( xFilial("SX6") + "TF_CMPMARG" )
	RecLock("SX6", .T.)
	SX6->X6_FIL     := xFilial("SX6")
	SX6->X6_VAR     := "TF_CMPMARG"
	SX6->X6_TIPO    := "N"
	SX6->X6_DESCRIC := "Margem de rejeiзгo de tabela de preзo"
	SX6->X6_DESC1		:= ""
	SX6->X6_CONTEUD	:= "1"
	SX6->X6_CONTSPA := ""
	SX6->X6_CONTENG := ""
	SX6->X6_PROPRI  := "U"
	SX6->X6_PYME    := "S"
	MsUnlock()
EndIf
                                                                                                                                                                                                                          
nCMPmargem := GetNewPar("TF_CMPMARG",0) 

RestArea(aArea)
Return (nCMPmargem)


/*
------------------------------------------------------------------------------
Cria parametro com margem de percentual de preпїЅo 
------------------------------------------------------------------------------
*/
User Function TFmessx6()
Local aArea	:=	GetArea()

dbSelectArea( "SX6" )
dbSetOrder(1)
If !dbSeek( xFilial("SX6") + "TF_CMPAPRO" )
	RecLock("SX6", .T.)
	SX6->X6_FIL     := xFilial("SX6")
	SX6->X6_VAR     := "TF_CMPAPRO"
	SX6->X6_TIPO    := "N"
	SX6->X6_DESCRIC	:= "Numero de dias permitido para registro de uma nova"
	SX6->X6_DESC1		:= " tabela de preзo"
	SX6->X6_CONTEUD := "180"
	SX6->X6_CONTSPA := ""
	SX6->X6_CONTENG := ""
	SX6->X6_PROPRI  := "U"
	SX6->X6_PYME    := "S"
	MsUnlock()
EndIf
                                                                                                                                                                                                                          
nCMPdiasOk := GetNewPar("TF_CMPAPRO",2) 

RestArea(aArea)
Return (nCMPdiasOk)


/*
------------------------------------------------------------------------------
Cria parametro com margem de percentual de preпїЅo 
------------------------------------------------------------------------------
*/
User Function TFmaisx6()
Local aArea	:=	GetArea()

dbSelectArea( "SX6" )
dbSetOrder(1)
If !dbSeek( xFilial("SX6") + "TF_CMPFLOW" )
	RecLock("SX6", .T.)
	SX6->X6_FIL		:= xFilial("SX6")
	SX6->X6_VAR		:= "TF_CMPFLOW"
	SX6->X6_TIPO		:= "C"
	SX6->X6_DESCRIC	:= "e-mail de workflow de alteraзгo da tabela de preco"
	SX6->X6_DESC1		:= " de compra"
	SX6->X6_CONTEUD	:= "rose.araujo@taiff.com.br;douglas.fornazier@taiff.com.br"
	SX6->X6_CONTSPA	:= ""
	SX6->X6_CONTENG	:= ""
	SX6->X6_PROPRI		:= "U"
	SX6->X6_PYME		:= "S"
	MsUnlock()
EndIf
                                                                                                                                                                                                                          
cMailDest := GetNewPar("TF_CMPFLOW","rose.araujo@taiff.com.br;") 

RestArea(aArea)
Return (cMailDest)

Static Function FINFKSID(cAliasFks, cCampoFks)
Local cIdFks := ""
Local aArea 	:= GetArea()

DbSelectArea(cAliasFks)
DbSetOrder(1)

While .T.
	cIdFks:=GetSx8Num(cAliasFks, cCampoFks)
	If !(Dbseek(xFilial(cAliasFks)+cIdFks))
	 	confirmsx8()
	 	exit 
	Endif
Enddo

RestArea(aArea)

Return cIdFks
