#include "PROTHEUS.ch"
#include "TopConn.ch"

#DEFINE LINHAS 999
#DEFINE USADO CHR(0)+CHR(0)+CHR(1)

//+--------------------------------------------------------------------------------------------------------------
//| ROTINA: TFRegr241 		                             AUTOR: CARLOS ALDAY TORRES           DATA: 21/11/2011   |
//+--------------------------------------------------------------------------------------------------------------
//| DESCRICAO: Rotina para gerenciar a tabela ZAN 
//| SOLICITANTE: 
//| OBSERVACAO: Nesta tabela são cadastrados os usuarios e regras para acessos à rotina movimento interno mod. II
//+--------------------------------------------------------------------------------------------------------------
User Function TFRegr241()
Private cCadastro	:= "Regras Mov.Interno"
Private aRotina	:=	{{"Pesquisar"	, "axPesqui"	, 0, 1},;
							{"Visualizar"	, "U_VwRegr241(0,2)"	, 0, 2},;
							{"Incluir"		, "U_InRegr241('ZAN',0,3)", 0, 3},;
							{"Alterar"		, "U_InRegr241('ZAN',0,4)", 0, 4},;
							{"Excluir"		, "U_InRegr241('ZAN',0,5)", 0, 5} }

DbSelectArea("ZAN")
DbSetOrder(1)

MBrowse(6,1,22,75,"ZAN")
Return


      
//+--------------------------------------------------------------------------------------------------------------
//| Função Inclusão tabela ZAN
//+--------------------------------------------------------------------------------------------------------------
User Function InRegr241(cAlias, nReg, nOpc)
Local cTudoOk := "(U_TokRegr241())"
Local	lPermissao := .T.

ZAM->(DbSetOrder(1))
If !ZAM->(DbSeek( xFilial("ZAM") + __CUSERID ))
	lPermissao := .F.
Else
	If ZAM->ZAM_VALIDA <= dDataBase .and. !Empty(ZAM->ZAM_VALIDA)
		lPermissao := .F.
	EndIf
EndIf

If .NOT. lPermissao
	Aviso("Inconsistência: Permissão", "Usuário não tem permissão de acesso à rotina!" + chr(13) + chr(10) + "Solicite ao gestor da rotina Movimento Interno II.",	{"Ok"}, 	3)
Else
	If nOpc=3
		nOpcao := AxInclui(cAlias,nReg,nOpc,,,{"ZAN_IDUSER","ZAN_CODTM","ZAN_LOCAL"},cTudoOk)
	ElseIf nOpc=4
		Aviso("Inconsistência", "Alteração não permitida.",	{"Ok"}, 	3)
	ElseIf nOpc=5
		nOpcao := AxDeleta(cAlias,nReg,nOpc) 
	EndIf	
EndIf

Return

//+--------------------------------------------------------------------------------------------------------------
//| Função Valida botão OK da tabela ZAN
//+--------------------------------------------------------------------------------------------------------------
User Function TokRegr241()
Local lRetorno	:= .T.
Local lVerifica:= .F.

ZAN->(DbSetOrder(1))
ZAN->(DbSeek( xFilial("ZAN") + M->ZAN_IDUSER + M->ZAN_CODTM ))
While ZAN->(ZAN_FILIAL+ZAN_IDUSER+ZAN_CODTM) = xFilial("ZAN") + M->ZAN_IDUSER + M->ZAN_CODTM .AND. !ZAN->(Eof())
	If ZAN->ZAN_LOCAL = M->ZAN_LOCAL
		lVerifica := .T.
	EndIf
	ZAN->(DbSkip())
End

If lVerifica
	Aviso("Inconsistência: Inclusão", "Codigo de movimentação já cadastrado para este usuário!" + chr(13) + chr(10) + "Inclusão não realizada.",	{"Ok"}, 	3)
	lRetorno := .F.
Else
	SF5->(DbSetOrder(1))
	If !SF5->(DbSeek( xFilial("SF5") + M->ZAN_CODTM ))
		Aviso("Inconsistência: Inclusão", "Codigo de movimentação não existe!" + chr(13) + chr(10) + "Inclusão não realizada.",	{"Ok"}, 	3)
		lRetorno := .F.
	EndIf
EndIf
Return (lRetorno)


//+--------------------------------------------------------------------------------------------------------------
//| Função Visao geral da tabela ZAN
//+--------------------------------------------------------------------------------------------------------------
User Function VwRegr241(nReg,nOpc)
Local nX 	 	:= 0
Local nUsado 	:= 0
Local aButtons	:= {} 
// Local aPos		:= {000,000,080,400}
// Local nModelo	:= 3 
// Local lF3 		:= .F. 
// Local lMemoria	:= .T.
// Local lColumn		:= .F.                         
// Local caTela 		:= "" 
// Local lNoFolder	:= .F.                            
// Local lProperty	:= .F.
Local aCpoGDa       	:= {}
Local cAliasGD	:= "ZAN"
// Local nSuperior    	:= 081	
// Local nEsquerda    	:= 000
// Local nInferior    	:= 250
// Local nDireita     	:= 400
Local cLinOk       	:= "AllwaysTrue" 
Local cTudoOk      	:= "AllwaysTrue" 
Local cIniCpos     	:= "ZAN_ITEM" 
Local nFreeze      	:= 000 
Local nMax         	:= 999
Local cFieldOk     	:= "AllwaysTrue" 
Local cSuperDel     	:= ""
Local cDelOk        	:= "AllwaysFalse" 
Local aHeader       	:= {}
Local aCols         	:= {}                      
Local aAlterGDa	:= {}

Local aObjects 	   := {}
Local aPosObj      := {}
Local aSize    	   := MsAdvSize()
Local aInfo    	   := {aSize[1],aSize[2],aSize[3],aSize[4],3,3}
Local cUsuario := IIF( INCLUI , Space(06) , ZAN->ZAN_IDUSER )

Private oDlg
Private oGetD      
Private oEnch
Private aTELA[0][0]
Private aGETS[0]

DbSelectArea("SX3")
DbSetOrder(1)
MsSeek(cAliasGD)

While !Eof() .And. SX3->X3_ARQUIVO == cAliasGD
	If	!(AllTrim(SX3->X3_CAMPO) $ "ZAN_FILIAL") .And. cNivel >= SX3->X3_NIVEL .And. X3Uso(SX3->X3_USADO)		
		If At( Alltrim(SX3->X3_CAMPO) , "ZAN_CODTM" ) != 0
			AADD(aCpoGDa,SX3->X3_CAMPO)
		EndIf
	EndIf		 
	DbSkip()
End
aAlterGDa := aClone(aCpoGDa)

nUsado:=0
dbSelectArea("SX3")
dbSeek("ZAN")
aHeader:={}
While !Eof().And.(x3_arquivo=="ZAN")
	If X3USO(x3_usado).And.cNivel>=x3_nivel
		If At( Alltrim(x3_campo) , "ZAN_ITEM|ZAN_CODTM|ZAN_NOMETM|ZAN_DTGRAV|ZAN_LOCAL" ) != 0
		  	nUsado:=nUsado+1
			AADD(aHeader,{ TRIM(x3_titulo), x3_campo, x3_picture,x3_tamanho,;
					x3_decimal,"AllwaysTrue()",x3_usado, x3_tipo, x3_arquivo, x3_context } )
		Endif
	EndIf
	dbSkip()
End

If nOpc==3 // Incluir
	aCols:={Array(nUsado+1)}
	aCols[1,nUsado+1]:=.F.
	For nX:=1 to nUsado
		If At( Alltrim(aHeader[nX,2]) , "ZAN_ITEM|ZAN_CODTM|ZAN_NOMETM|ZAN_DTGRAV|ZAN_LOCAL" ) != 0
			IF Alltrim(aHeader[nX,2]) == "ZAN_ITEM"
				aCols[1,nX]:= "0001"
			ELSE
				aCols[1,nX]:=CriaVar(aHeader[nX,2])
			ENDIF
		EndIf
	Next
Else
	cZanUser := ZAN->ZAN_IDUSER
	aCols:={}
	dbSelectArea("ZAN")
	dbSetOrder(1)
	dbSeek(xFilial("ZAN")+ cZanUser )
	While !eof() .and. ZAN->ZAN_IDUSER==cZanUser
		AADD(aCols,Array(nUsado+1))
		For nX:=1 to nUsado
			If At( Alltrim(aHeader[nX,2]) , "ZAN_ITEM|ZAN_CODTM|ZAN_NOMETM|ZAN_DTGRAV|ZAN_LOCAL" ) != 0
				aCols[Len(aCols),nX]:=FieldGet(FieldPos(aHeader[nX,2]))
			EndIf
		Next 
		aCols[Len(aCols),nUsado+1]:=.F.
		dbSkip()
	End
Endif

AADD(aObjects,{100,020,.T.,.F.,.F.})
AADD(aObjects,{100,100,.T.,.T.,.F.})

aPosObj := MsObjSize(aInfo,aObjects)


oDlg 	:= MSDIALOG():New(aSize[7],0,aSize[6],aSize[5], cCadastro,,,,,,,,,.T.)

RegToMemory("ZAN", If(nOpc==3,.T.,.F.))
				
@ 1.6,00.7  SAY "Usuario" OF oDlg 	
@ 1.5,08.0  MSGET cUsuario F3 "USR" Picture PesqPict("ZAN","ZAN_IDUSER") Valid CheckSX3("ZAN_IDUSER") .And. VldUser('ZAN_IDUSER') 

oGetD:= MsNewGetDados():New(aPosObj[2,1],aPosObj[2,2],aPosObj[2,3],aPosObj[2,4],;
        nOpc,cLinOk,cTudoOk, cIniCpos, aAlterGDa, nFreeze, nMax,cFieldOk,;
        cSuperDel,cDelOk, oDLG, aHeader, aCols)
				
oDlg:bInit := {|| EnchoiceBar(oDlg, {||oDlg:End()},{||oDlg:End()},,aButtons)}
oDlg:lCentered := .T.
oDlg:Activate()

Return




//+--------------------------------------------------------------------------------------------------------------
//| Função validação de usuario da tabela ZAN
//+--------------------------------------------------------------------------------------------------------------
User Function TFRegrZAN()
Local lRetorno := .T.
Local	lVerifica := .F.

If FunName() = "MATA241"
	If INCLUI
		ZAM->(DbSetOrder(1))
		If !ZAM->(DbSeek( xFilial("ZAM") + __CUSERID ))
			lVerifica := .T.
		Else
			If ZAM->ZAM_VALIDA <= dDataBase .and. !Empty(ZAM->ZAM_VALIDA)
				lVerifica := .T.
			EndIf
		EndIf
		If lVerifica
			ZAN->(DbSetOrder(1))
			If !ZAN->(DbSeek( xFilial("ZAN") + __CUSERID + cTM  ))
				Aviso("Inconsistência: Permissão", "Usuário não tem permissão de uso para o codigo " + cTM +" !!!" + chr(13) + chr(10) + "Comunique ao gestor da rotina Movimento Interno II.",	{"Ok"}, 	3)
				lRetorno := .F.
			EndIf		
		EndIf
	EndIf
EndIf	
Return (lRetorno)



//+--------------------------------------------------------------------------------------------------------------
//| Função validação de usuario da tabela ZAN para o movimento do armazem
//+--------------------------------------------------------------------------------------------------------------
User Function TF241Local()
Local lRetorno := .T.
Local	lVerifica := .T.

If FunName() = "MATA241"
	If INCLUI
		ZAN->(DbSetOrder(1))
		ZAN->(DbSeek( xFilial("ZAN") + __CUSERID + cTM  ))
		While ZAN->(ZAN_FILIAL+ZAN_IDUSER+ZAN_CODTM) = xFilial("ZAN") + __CUSERID + cTM .AND. !ZAN->(Eof())
			If ZAN->ZAN_LOCAL = M->D3_LOCAL
				lVerifica := .F.
			EndIf
			ZAN->(DbSkip())
		End
		
		If lVerifica 
			Aviso("Inconsistência: Permissão", "Usuário não tem permissão para movimentar o armazem: " + M->D3_LOCAL +" !!!" + chr(13) + chr(10) + "Comunique ao gestor da rotina Movimento Interno II.",	{"Ok"}, 	3)
			lRetorno := .F.
		EndIf		
	EndIf
EndIf	
Return (lRetorno)

