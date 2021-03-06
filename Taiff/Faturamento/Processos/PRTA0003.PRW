#include "protheus.ch"
#include "topconn.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �PRTA0003  �Autor  �Veti FSW            � Data �  16/10/11   ���
�������������������������������������������������������������������������͹��
���Desc.     �Cadastro de Compradores         x Grupos de Produtos        ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �PROART                                                      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function PRTA0003()

	Local aCores 	:= {{ ".T.", "BR_VERDE"}}

	Private cCadastro	:= OemToAnsi("Compradores x Grupos de Produtos")
	Private aRotina 	:= MenuDef()

	mBrowse(6,1  ,22,75,"ZZJ" ,,    ,     ,    ,        ,aCores  ,       ,       ,        ,         ,          ,        ,       ,)

Return .T.

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MenuDef   �Autor  �Veti FSW            � Data �  16/10/11   ���
�������������������������������������������������������������������������͹��
���Desc.     �Define as rotinas do mbrowse                                ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �PROART                                                      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function MenuDef()

	Private aRotina := {	{ OemtoAnsi( "Pesquisar"  		),	'PesqBrw',		0, 1,	0,	.F. },;
		{ OemtoAnsi( "Visualizar"  		),	'U_A0003MAN(2)',	0, 2,	0,	NIL },;
		{ OemtoAnsi( "Incluir"    		),	'U_A0003MAN(3)',	0, 3,	0,	NIL },;
		{ OemtoAnsi( "Alterar"    		),	'U_A0003MAN(4)',	0, 4,	0,	NIL },;
		{ OemtoAnsi( "Excluir" 	   		),	'U_A0003MAN(5)',	0, 5,	0,	NIL }}

Return(aRotina)


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �PRTA0003  �Autor  �Veti FSW            � Data �  16/10/11   ���
�������������������������������������������������������������������������͹��
���Desc.     �Efetua a manutencao do cadastro                             ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �PROART                                                      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function A0003MAN(nOpcao)

	Local cFilZZK	:= xFilial("ZZK")

//����������������������������������������Ŀ
//�Vari�veis Utilizadas na Montagem da Tela�
//������������������������������������������
	Local aSize  	:= {}
	Local aObjects  := {}
	Local aInfo 	:= {}
	Local aPosObj	:= {}
	Local nOpcoes 	:= 0
	Local cTitulo 	:= "Compradores x Grupos de Produtos"
	Local lOk		:= .F.
	Local _nx		:= 0

	Private aHeader	:= {}
	Private aCols	:= {}
	Private aGets   := {}
	Private aTela   := {}
	Private nUsado	:= 0
	Private INCLUI	:= IIF(nOpcao == 3,.T.,.F.)
	Private oGetD

	Default nOpcao := 1

	nOpcoes := Iif(nOpcao == 3 .or. nOpcao == 4,GD_INSERT + GD_DELETE + GD_UPDATE,0)


//���������������Ŀ
//�Monta a aHeader�
//�����������������
	SX3->(DbSetOrder(1))
	SX3->(DbSeek("ZZK"))
	While SX3->(!Eof()) .AND. SX3->X3_ARQUIVO == "ZZK"
		If X3USO(SX3->X3_USADO) .AND. cNivel >= SX3->X3_NIVEL
			nUsado++
			aAdd(aHeader, { Alltrim(SX3->X3_DESCRIC),;
				SX3->X3_CAMPO,;
				SX3->X3_PICTURE,;
				SX3->X3_TAMANHO,;
				SX3->X3_DECIMAL,;
				SX3->X3_VALID,;
				SX3->X3_USADO,;
				SX3->X3_TIPO,;
				SX3->X3_F3,;
				SX3->X3_CONTEXT,;
				SX3->X3_CBOX,;
				SX3->X3_RELACAO})
		Endif
		SX3->(DbSkip())
	EndDo

//FillGetDados(3,"ZZK",1,/*cSeek*/,/*{|| &cWhile }*/,/*{{bCond,bAction1,bAction2}}*/,/*aNoFields*/,/*aYesFields*/,/*lOnlyYes*/,/*cQuery*/,/*bMontCols*/,.T.,aHeader,aCols,/*bMountFile*/,/*bAfterCols*/)

	aCols := {}

	nUsado:=Len(aHeader)

//nPosRecWT := aScan(aHeader,{|x| alltrim(x[2]) == "ZZK_REC_WT"})
//nPosAliWT := aScan(aHeader,{|x| alltrim(x[2]) == "ZZK_ALI_WT"})

//aDel(aHeader,nPosRecWt)	
//aDel(aHeader,nPosAliWt)	

//aSize(aHeader,len(aHeader) - 2)
	RegToMemory("ZZJ",INCLUI)
	RegToMemory("ZZK",.F.)

	SX3->(DbSetOrder(2))

	If nOpcao == 3
		aAdd(aCols,Array(nUsado + 1) )
		nLinha:=len(aCols)
		aCols[nLinha][nUsado + 1] := .F.

		For _nx := 1 to len(aHeader)
			If SX3->(DbSeek(aHeader[_nx][2]))
				CriaVar(aHeader[_nx][2],.T.)
				If Alltrim(SX3->X3_CAMPO) == "ZZK_ITEM"
					aCols[len(aCols)][_nx] := SomaIt(StrZero(0,len(M->ZZK_ITEM)))
				Else
					aCols[len(aCols)][_nx] := CriaVar(aHeader[_nx][2],.T.)
				EndIf
			EndIf
		Next
	Else

		ZZK->(DbSetOrder(1))
		ZZK->(DbSeek(cFilZZK + ZZJ->ZZJ_CODGRP))

		While ZZK->(!Eof()) .AND. ZZK->ZZK_CODGRP == ZZJ->ZZJ_CODGRP
			aAdd(aCols,Array(nUsado + 1) )
			nLinha:=len(aCols)
			aCols[nLinha][nUsado + 1] := .F.

			For _nx := 1 to len(aHeader)
				If SX3->(DbSeek(aHeader[_nx][2]))
					CriaVar(aHeader[_nx][2],.T.)
					if aHeader[_nx][10] <> "V"
						M->&(aHeader[_nx][2]) := ZZK->&(aHeader[_nx][2])
						aCols[nLinha][_nx] := ZZK->&(aHeader[_nx][2])
					Else
						aCols[nLinha][_nx] := &(SX3->X3_RELACAO)
					Endif
				EndIf
			Next
			ZZK->(DbSkip())
		EndDo
	Endif

//������������������������������������������������������Ŀ
//� Faz o calculo automatico de dimensoes de objetos     �
//��������������������������������������������������������
	aSize := MsAdvSize(.T.,.F.)
	aObjects := {}
	`
//                  C    L    C    L
	AAdd( aObjects, {   1  ,  120, .T., .T. } )
	AAdd( aObjects, {   1  ,  120, .T., .T. } )


	aInfo := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 3, 3 }
	aPosObj := MsObjSize( aInfo, aObjects )

	DEFINE MSDIALOG oDlg TITLE OemToAnsi(cTitulo) From aSize[7],0 to aSize[6],aSize[5] OF oMainWnd PIXEL

//�����������������������������������������������Ŀ
//�Monta a Enchoice superior com os Dados da Carga�
//�������������������������������������������������      
	Enchoice( "ZZJ", ZZJ->(Recno()), nOpcao, , , , , {aPosObj[1,1],aPosObj[1,2],aPosObj[1,3],aPosObj[1,4]}, , 1, , ,"AllwaysTrue()", oDlg, .F.,  .T., .F., , .F., .F.)
	//New ( nTop        ,nLeft        ,nBottom     ,nRight       ,nStyle ,uLinhaOk      ,uTudoOk        ,cIniCpos   ,aAlter,nFreeze,nMax  ,cFieldOk     ,uSuperDel,uDelOk          ,oWnd,aParHeader,aParCols,uChange) CLASS MsNewGetDados
	oGetD := MSNewGetDados():New( aPosObj[2,1],aPosObj[2,2],aPosObj[2,3],aPosObj[2,4],nOpcoes,"U_A0003LOK()", "U_A0003TOK()","+ZZK_ITEM",      ,       ,99999,"AllwaysTrue()",         ,"AllwaysTrue()",    ,@aHeader  ,@aCols )

	ACTIVATE MSDIALOG oDlg CENTERED ON INIT EnchoiceBar(oDlg,{|| IIF( Obrigatorio(aGets,aTela) .and. U_A0003TOK(),(oDlg:End()          ,lOk := .T.),.F.)},{||oDlg:End()}            ,,)


//����������������������������������������������������Ŀ
//�Caso tenha confirmado, efetua a grava��o do cadastro�
//������������������������������������������������������                                       
	If lOk .and. nOpcao >= 3 .and. nOpcao <= 5
		Begin Transaction

			GravaCad(nOpcao)

		End Transaction
	Endif

Return .T.

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �A0003LOK  �Autor  �Veti FSW            � Data �  16/10/11   ���
�������������������������������������������������������������������������͹��
���Desc.     �Fun��o de Valida��o de Linha (LinhaOK) na getdados          ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �PROART                                                      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function A0003LOK()

	Local cAliasBKP	:= Alias()
	Local aOrdBKP   := SaveOrd({cAliasBKP,"ZZK"})
	Local nPosCod 	:= GdFieldPos("ZZK_GRPPRD",oGetD:aHeader)
	Local nPosFim 	:= GdFieldPos("ZZK_GRPFIM",oGetD:aHeader)
	Local nPosItem 	:= GdFieldPos("ZZK_ITEM",oGetD:aHeader)
	Local lRet 	  	:= .T.
	Local _nx		:= 0


//��������������������������������������������������������Ŀ
//�Caso o registro esteja deletado, n�o realiza a valida��o�
//����������������������������������������������������������
	If oGetD:aCols[oGetD:nAt][nUsado + 1]
		Return .T.
	Endif

//������������������������������������������Ŀ
//�Verifica se o campo c�digo est� preenchido�
//��������������������������������������������
	If Empty(oGetD:aCols[oGetD:nAt][nPosCod])
		Aviso("A0003LOK","Campo Grupo de Produtos Obrigatorio",{"Ok"})
		Return .F.
	EndIf

	If Empty(oGetD:aCols[oGetD:nAt][nPosFim])
		Aviso("A0003LOK","Campo Grupo de Produtos Final Obrigatorio",{"Ok"})
		Return .F.
	EndIf

//�����������������������������������������������������������Ŀ
//�Verifica se o Grupo Inicial � menor ou igual ao grupo Final�
//�������������������������������������������������������������
	If oGetD:aCols[oGetD:nAt][nPosCod] > oGetD:aCols[oGetD:nAt][nPosFim]
		Aviso("A0003LOK","Grupo Inicial n�o pode ser maior que o grupo final.",{"Ok"})
		Return .F.
	EndIf

//��������������������������������������������Ŀ
//�Verifica se o registro j� existe na GetDados�
//����������������������������������������������
	For _nx := 1 to len(oGetD:aCols)
		If _nx == oGetD:nAt .or. oGetD:aCols[_nx][nUsado + 1]
			Loop
		ElseIf (Alltrim(oGetD:aCols[oGetD:nAt][nPosCod]) >= Alltrim(oGetD:aCols[_nx][nPosCod]) .and. ;
				Alltrim(oGetD:aCols[oGetD:nAt][nPosCod]) <= Alltrim(oGetD:aCols[_nx][nPosFim])  ) .or. ;
				(Alltrim(oGetD:aCols[oGetD:nAt][nPosFim]) >= Alltrim(oGetD:aCols[_nx][nPosCod]) .and. ;
				Alltrim(oGetD:aCols[oGetD:nAt][nPosFim]) <= Alltrim(oGetD:aCols[_nx][nPosFim])  )
			Aviso("A0003LOK","Range de Produtos ja informado no item " + Alltrim(oGetD:aCols[_nx][nPosItem]),{"Ok"})
			Return .F.
		Endif
	Next

/*
//��������������������������������������������������������������������������������Ŀ
//�Verifica se o range de grupos de produtos j� foi utilizado para outro aprovador.�
//����������������������������������������������������������������������������������
cQuery := "SELECT ZZK_CODGRP, ZZK_ITEM FROM " + cNameZZK + " ZZK "
cQuery += "WHERE ( '" + oGetD:aCols[oGetD:nAt][nPosCod] + "'  BETWEEN ZZK_GRPPRD AND ZZK_GRPFIM "
cQuery += "OR '" + oGetD:aCols[oGetD:nAt][nPosFim] + "'  BETWEEN ZZK_GRPPRD AND ZZK_GRPFIM ) "
cQuery += "AND ZZK_CODGRP <> '" + M->ZZJ_CODGRP + "' "
cQuery += "AND ZZK_FILIAL = '" + cFilZZK + "' "
cQuery += "AND ZZK.D_E_L_E_T_ <> '*' "         

TcQuery cQuery ALIAS &(cAliasTRB) NEW

	While (cAliasTRB)->(!Eof())
	cGrpErr += "Grupo: " + (cAliasTRB)->ZZK_CODGRP + " - Item: " + (cAliasTRB)->ZZK_ITEM + Chr(13) + Chr(10)
	(cAliasTRB)->(DbSkip())	
	EndDo

(cAliasTRB)->(DbCloseArea())

	If !Empty(cGrpErr)
	Aviso("A0003LOK","Esse range de grupo de produtos conflita com o range dos seguintes compradores: " + ;
					Chr(13) + Chr(10) + cGrpErr,{"Ok"},3)
	lRet := .F.
	EndIf

*/
/*ZZK->(DbSetOrder(2))        
ZZK->(DbSeek(cFilZZK + oGetD:aCols[oGetD:nAt][nPosCod]))

	While ZZK->(!Eof()) .AND. ZZK->ZZK_GRPPRD == oGetD:aCols[oGetD:nAt][nPosCod]
		If ZZK->ZZK_CODGRP <> M->ZZJ_CODGRP
		Aviso("A0003LOK","Esse grupo de produtos ja esta cadastrado para o grupo de aprovacao " + ZZK->ZZK_CODGRP,{"Ok"})
		lRet := .F.
		Exit
		EndIf
	ZZK->(DbSkip())		
	EndDo                       */

//��������������������������������������Ŀ
//�Restaura a Ordem Original dos Arquivos�
//����������������������������������������
RestOrd(aOrdBKP)                     
DbSelectArea(cAliasBKP)

Return(lRet)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �A0003TOK  �Autor  �Veti FSW            � Data �  16/10/11   ���
�������������������������������������������������������������������������͹��
���Desc.     �Fun��o de Valida��o de GetDados (tudoOk)                    ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �PROART                                                      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function A0003TOK()

	Local lRet 		:= .T.
	Local cAliasBKP	:= Alias()
	Local aOrdBKP   := SaveOrd({"ZZK"})
	Local nPosCod 	:= GdFieldPos("ZZK_GRPPRD",oGetD:aHeader)
	Local nPosFim 	:= GdFieldPos("ZZK_GRPFIM",oGetD:aHeader)
	Local nPosItem 	:= GdFieldPos("ZZK_ITEM",oGetD:aHeader)
	Local _nx 		:= 0
	Local _ny 		:= 0

//�������������������������������������������������������������������Ŀ
//�Verifica se j� existe o range de grupos cadastrados para cada linha�
//���������������������������������������������������������������������
	For _nx := 1 to len(oGetD:aCols)

		//���������������������������������������������������������
		//�Se o Registro estiver deletado, n�o realiza a valida��o�
		//���������������������������������������������������������
		If oGetD:aCols[_nx][nUsado+1]
			Loop
		Endif


		//������������������������������������������Ŀ
		//�Verifica se o campo c�digo est� preenchido�
		//��������������������������������������������
		If Empty(oGetD:aCols[_nx][nPosCod])
			Aviso("A0003TOK","Campo Grupo de Produtos Obrigatorio no item " + oGetD:aCols[_nx][nPosItem],{"Ok"})

			//��������������������������������������Ŀ
			//�Restaura a Ordem Original dos Arquivos�
			//����������������������������������������
			RestOrd(aOrdBKP)
			DbSelectArea(cAliasBKP)

			Return .F.
		EndIf

		If Empty(oGetD:aCols[_nx][nPosFim])
			Aviso("A0003TOK","Campo Grupo de Produtos Final Obrigatorio no item " + oGetD:aCols[_nx][nPosItem],{"Ok"})

			//��������������������������������������Ŀ
			//�Restaura a Ordem Original dos Arquivos�
			//����������������������������������������
			RestOrd(aOrdBKP)
			DbSelectArea(cAliasBKP)

			Return .F.
		EndIf

		//�����������������������������������������������������������Ŀ
		//�Verifica se o Grupo Inicial � menor ou igual ao grupo Final�
		//�������������������������������������������������������������
		If oGetD:aCols[_nx][nPosCod] > oGetD:aCols[_nx][nPosFim]
			Aviso("A0003TOK","Grupo Inicial n�o pode ser maior que o grupo final no item " + oGetD:aCols[_nx][nPosItem],{"Ok"})

			//��������������������������������������Ŀ
			//�Restaura a Ordem Original dos Arquivos�
			//����������������������������������������
			RestOrd(aOrdBKP)
			DbSelectArea(cAliasBKP)

			Return .F.
		EndIf


		//��������������������������������������������Ŀ
		//�Verifica se o registro j� existe na GetDados�
		//����������������������������������������������
		For _ny := 1 to len(oGetD:aCols)
			If _ny == _nx .or. oGetD:aCols[_ny][nUsado + 1]
				Loop
			ElseIf (Alltrim(oGetD:aCols[_nx][nPosCod]) >= Alltrim(oGetD:aCols[_ny][nPosCod]) .and. ;
					Alltrim(oGetD:aCols[_nx][nPosCod]) <= Alltrim(oGetD:aCols[_ny][nPosFim])  ) .or. ;
					(Alltrim(oGetD:aCols[_nx][nPosFim]) >= Alltrim(oGetD:aCols[_ny][nPosCod]) .and. ;
					Alltrim(oGetD:aCols[_nx][nPosFim]) <= Alltrim(oGetD:aCols[_ny][nPosFim])  )
				Aviso("A0003TOK","Range de Produtos em duplicidade nos  itens " + Alltrim(oGetD:aCols[_ny][nPosItem]) + " e " +;
					Alltrim(oGetD:aCols[_nx][nPosItem]),{"Ok"})

				//��������������������������������������Ŀ
				//�Restaura a Ordem Original dos Arquivos�
				//����������������������������������������
				RestOrd(aOrdBKP)
				DbSelectArea(cAliasBKP)

				Return .F.
			Endif
		Next
    /*
	//��������������������������������������������������������������������������������Ŀ
	//�Verifica se o range de grupos de produtos j� foi utilizado para outro aprovador.�
	//����������������������������������������������������������������������������������
	cQuery := "SELECT ZZK_CODGRP, ZZK_ITEM FROM " + cNameZZK + " ZZK "
	cQuery += "WHERE ( '" + oGetD:aCols[_nx][nPosCod] + "'  BETWEEN ZZK_GRPPRD AND ZZK_GRPFIM "
	cQuery += "OR '" + oGetD:aCols[_nx][nPosFim] + "'  BETWEEN ZZK_GRPPRD AND ZZK_GRPFIM ) "
	cQuery += "AND ZZK_CODGRP <> '" + M->ZZJ_CODGRP + "' "
	cQuery += "AND ZZK_FILIAL = '" + cFilZZK + "' "
	cQuery += "AND ZZK.D_E_L_E_T_ <> '*' "         
	
	TcQuery cQuery ALIAS &(cAliasTRB) NEW
	
		While (cAliasTRB)->(!Eof())
		cGrpErr += cGrpErr += "Grupo: " + (cAliasTRB)->ZZK_CODGRP + " - Item: " + (cAliasTRB)->ZZK_ITEM + Chr(13) + Chr(10)
		(cAliasTRB)->(DbSkip())	
		EndDo
	
	(cAliasTRB)->(DbCloseArea())
	
		If !Empty(cGrpErr)
		Aviso("A0003TOK","O range de grupo de produtos do item " + Alltrim(oGetD:aCols[_nx][nPosItem]) + ;
					" conflita com o range dos seguintes compradores: " + ;
						Chr(13) + Chr(10) + cGrpErr,{"Ok"},3)

		//��������������������������������������Ŀ
		//�Restaura a Ordem Original dos Arquivos�
		//����������������������������������������                                                                          
		RestOrd(aOrdBKP)                     
		DbSelectArea(cAliasBKP)

		Return .F.
		EndIf
	*/
	Next

//��������������������������������������Ŀ
//�Restaura a Ordem Original dos Arquivos�
//����������������������������������������                                                                          
	RestOrd(aOrdBKP)
	DbSelectArea(cAliasBKP)

Return lRet

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �A0003FOK  �Autor  �Veti FSW            � Data �  16/11/10   ���
�������������������������������������������������������������������������͹��
���Desc.     �Fun��o de Valida��o de Campos(FieldOk)                      ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �UAM                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
/*                      
User Function A0003FOK()

Local lRet		:= .T.        
Local cAliasBKP	:= Alias()    
Local aOrdBKP   := SaveOrd({"ZZK"})
Local cFilZZK	:= xFilial("ZZK")
Local nPosCod 	:= GdFieldPos("ZZK_GRPPRD",oGetD:aHeader)
Local nPosFim 	:= GdFieldPos("ZZK_GRPFIM",oGetD:aHeader)
Local nPosItem 	:= GdFieldPos("ZZK_ITEM",oGetD:aHeader)
Local nLinCod 	:= 0
Local cQuery	:= ""
Local cAliasTRB	:= GetNextAlias()
Local cNameZZK	:= RetSQLName("ZZK")
Local cFilZZK	:= xFilial("ZZK")
Local cGrpErr	:= ""


	If Alltrim(ReadVar()) == "M->ZZK_GRPPRD" .and. !oGetD:aCols[oGetD:nAt][nUsado + 1] .and. !Empty(Alltrim(oGetD:aCols[oGetD:nAt][nPosCod]))

	//��������������������������������������������Ŀ
	//�Verifica se o registro j� existe na GetDados�
	//����������������������������������������������
		For _nx := 1 to len(oGetD:aCols)
			If _nx == oGetD:nAt .or. oGetD:aCols[_nx][nUsado + 1]
			Loop
			ElseIf (Alltrim(oGetD:aCols[oGetD:nAt][nPosCod]) >= Alltrim(oGetD:aCols[_nx][nPosCod]) .and. ;
					Alltrim(oGetD:aCols[oGetD:nAt][nPosCod]) <= Alltrim(oGetD:aCols[_nx][nPosFim])  ) .or. ;
			Aviso("A0003FOK","Grupo de Produtos ja informado no item " + Alltrim(oGetD:aCols[_nx][nPosItem]),{"Ok"})

			//��������������������������������������Ŀ
			//�Restaura a Ordem Original dos Arquivos�
			//����������������������������������������                                                                          
			RestOrd(aOrdBKP)                     
			DbSelectArea(cAliasBKP)
			Return .F.
				Endif

		//��������������������������������������������������������������������������������Ŀ
		//�Verifica se o range de grupos de produtos j� foi utilizado para outro aprovador.�
		//����������������������������������������������������������������������������������
		cQuery := "SELECT ZZK_CODGRP FROM " + cNameZZK + " ZZK "
		cQuery += "WHERE ( '" + oGetD:aCols[oGetD:nAt][nPosCod] + "'  BETWEEN ZZK_GRPPRD AND ZZK_GRPFIM )"
		cQuery += "AND ZZK_CODGRP <> '" + M->ZZJ_CODGRP + "' "
		cQuery += "AND ZZK_FILIAL = '" + cFilZZK + "' "
		cQuery += "AND ZZK.D_E_L_E_T_ <> '*' "         
		
		TcQuery cQuery ALIAS &(cAliasTRB) NEW
		
			While (cAliasTRB)->(!Eof())
			cGrpErr += (cAliasTRB)->ZZK_CODGRP + Chr(13) + Chr(10)
			(cAliasTRB)->(DbSkip())	
			EndDo
		
		(cAliasTRB)->(DbCloseArea())
		
			If !Empty(cGrpErr)
			Aviso("A0003FOK","Esse range de grupo de produtos conflita com o range dos seguintes grupos de aprovacao: " + ;
							Chr(13) + Chr(10) + cGrpErr,{"Ok"},3)

			//��������������������������������������Ŀ
			//�Restaura a Ordem Original dos Arquivos�
			//����������������������������������������                                                                          
			RestOrd(aOrdBKP)                     
			DbSelectArea(cAliasBKP)

			Return .F.
			EndIf
		Next
	EndIf

	If Alltrim(ReadVar()) == "M->ZZK_GRPFIM" .and. !oGetD:aCols[oGetD:nAt][nUsado + 1] .and. !Empty(Alltrim(oGetD:aCols[oGetD:nAt][nPosFim]))

	//��������������������������������������������Ŀ
	//�Verifica se o registro j� existe na GetDados�
	//����������������������������������������������
		For _nx := 1 to len(oGetD:aCols)
			If _nx == oGetD:nAt .or. oGetD:aCols[_nx][nUsado + 1]
			Loop
			ElseIf (Alltrim(oGetD:aCols[oGetD:nAt][nPosFim]) >= Alltrim(oGetD:aCols[_nx][nPosCod]) .and. ;
					Alltrim(oGetD:aCols[oGetD:nAt][nPosFim]) <= Alltrim(oGetD:aCols[_nx][nPosFim])  ) .or. ;
			Aviso("A0003FOK","Grupo de Produtos ja informado no item " + Alltrim(oGetD:aCols[_nx][nPosItem]),{"Ok"})
			
			//��������������������������������������Ŀ
			//�Restaura a Ordem Original dos Arquivos�
			//����������������������������������������                                                                          
			RestOrd(aOrdBKP)                     
			DbSelectArea(cAliasBKP)
						
			Return .F.
				Endif

		//��������������������������������������������������������������������������������Ŀ
		//�Verifica se o range de grupos de produtos j� foi utilizado para outro aprovador.�
		//����������������������������������������������������������������������������������
		cQuery := "SELECT ZZK_CODGRP FROM " + cNameZZK + " ZZK "
		cQuery += "WHERE ( '" + oGetD:aCols[oGetD:nAt][nPosFim] + "'  BETWEEN ZZK_GRPPRD AND ZZK_GRPFIM) "
		cQuery += "AND ZZK_CODGRP <> '" + M->ZZJ_CODGRP + "' "
		cQuery += "AND ZZK_FILIAL = '" + cFilZZK + "' "
		cQuery += "AND ZZK.D_E_L_E_T_ <> '*' "         
		
		TcQuery cQuery ALIAS &(cAliasTRB) NEW
		
			While (cAliasTRB)->(!Eof())
			cGrpErr += (cAliasTRB)->ZZK_CODGRP + Chr(13) + Chr(10)
			(cAliasTRB)->(DbSkip())	
			EndDo
		
		(cAliasTRB)->(DbCloseArea())
		
			If !Empty(cGrpErr)
			Aviso("A0003FOK","Esse range de grupo de produtos conflita com o range dos seguintes grupos de aprovacao: " + ;
							Chr(13) + Chr(10) + cGrpErr,{"Ok"},3)

			//��������������������������������������Ŀ
			//�Restaura a Ordem Original dos Arquivos�
			//����������������������������������������                                                                          
			RestOrd(aOrdBKP)                     
			DbSelectArea(cAliasBKP)							
			Return .F.
			EndIf
		          
		Next
	EndIf


RestOrd(aOrdBKP)
                                                      
Return lRet
                                                      */

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GravaCad  �Autor  �Veti FSW            � Data �  16/10/11   ���
�������������������������������������������������������������������������͹��
���Desc.     �Efetua a Grava��o do Cadastro, conforme a op��o informada   ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �PROART                                                      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function GravaCad(nOption)

	Local cAliasBKP	:= Alias()
	Local aOrdBKP	:= SaveOrd({cAliasBKP,"ZZJ","ZZK"})
	Local cFilZZJ	:= xFilial("ZZJ")
	Local cFilZZK	:= xFilial("ZZK")
	Local lInclui	:= .F.
	Local nPosItem	:= GdFieldPos("ZZK_ITEM",oGetD:aHeader)
	Local _nx		:= 0
	Local _ny		:= 0

	Default nOption	:= 0

//����������������������������������������������
//�Valida se a Op�ao foi informada corretamente�
//����������������������������������������������
	If nOption <= 2 .or. nOption >= 6
		Aviso("PRTA0003 - GravaCad","Op��o de grava��o n�o Informada corretamente!",{"Ok"})

		//��������������������������������������Ŀ
		//�Restaura a Ordem Original dos Arquivos�
		//����������������������������������������
		RestOrd(aOrdBKP)
		DbSelectArea(cAliasBKP)

		Return .F.
	Endif

	ZZJ->(DbSetOrder(1))
	ZZK->(DbSetOrder(1))

//����������������������������������������������������������������������������������������������Ŀ
//�Em caso de Inclus�o, verifica se o registro j� existe nas tabelas. Se existir, aborta a rotina�
//������������������������������������������������������������������������������������������������
	If nOption == 3 .AND. (ZZJ->(DbSeek(cFilZZJ + M->ZZJ_CODGRP)) .OR. ZZK->(DbSeek(cFilZZK + M->ZZJ_CODGRP)))
		Aviso("PRTA0003 - GravaCad","Registro j� existente. Entre em contato com Administrador!",{"Ok"})

		//��������������������������������������Ŀ
		//�Restaura a Ordem Original dos Arquivos�
		//����������������������������������������
		RestOrd(aOrdBKP)
		DbSelectArea(cAliasBKP)

		Return .F.
	Endif

//�����������������������������������������������������������
//�Inicia a Grava��o dos arquivos conforme a Op��o Informada�
//�����������������������������������������������������������
//��������������������������������Ŀ
//�Em caso de Inclus�o ou Altera��o�
//����������������������������������
	If nOption == 3 .or. nOption == 4

		DbSelectArea("ZZJ")
		ZZJ->(DbSetOrder(1))
		lInclui := !ZZJ->(DbSeek(cFilZZJ + M->ZZJ_CODGRP))

		//������������������������������������������Ŀ
		//�Efetua a Grava��o do Cabe�alho (Aprovador)�
		//��������������������������������������������
		If RecLock("ZZJ",lInclui)
			If Inclui
				ZZJ->ZZJ_FILIAL := cFilZZJ
			Endif

			For _nx := 1 to ZZJ->(Fcount())
				If Alltrim(ZZJ->(FieldName(_nx))) <> "ZZJ_FILIAL"
					ZZJ->&(FieldName(_nx)) := M->&(FieldName(_nx))
				Endif
			Next
			ZZJ->(MsUnLock())
		Endif

		//��������������������������������������������
		//�Efetua a Grava��o dos Itens (Solicitantes)�
		//��������������������������������������������
		DbSelectArea("ZZK")
		ZZK->(DbSetOrder(1))
		For _ny := 1 to len(oGetD:aCols)

			//�����������������������������������������������������������
			//�Se a linha n�o estiver excluida, prossegue com a Inclus�o�
			//�����������������������������������������������������������
			If !oGetD:aCols[_ny][nUsado + 1]

				lInclui := !ZZK->(DbSeek(cFilZZK + M->ZZJ_CODGRP + oGetD:aCols[_ny][nPosItem]))

				If RecLock("ZZK",lInclui)
					If lInclui
						ZZK->ZZK_FILIAL := cFilZZK
						ZZK->ZZK_CODGRP	:= M->ZZJ_CODGRP
					Endif

					For _nx := 1 to ZZK->(Fcount())
						If !Alltrim(ZZK->(FieldName(_nx))) $ "ZZK_FILIAL|ZZK_CODGRP"
							nFieldAtu := GdFieldPos(Alltrim(ZZK->(FieldName(_nx))),oGetD:aHeader)
							If nFieldAtu <> 0
								ZZK->&(FieldName(_nx)) := oGetD:aCols[_ny][nFieldAtu]
							Endif
						Endif
					Next
					ZZK->(MsUnLock())
				EndIf
			Else
				//�������������������������������������������������������������������������������Ŀ
				//�Se o registro estiver deletado na GetDados e existir na base, efetua a exclus�o�
				//���������������������������������������������������������������������������������
				If ZZK->(DbSeek(cFilZZK + M->ZZJ_CODGRP + oGetD:aCols[_ny][nPosItem]))
					If RecLock("ZZK",.F.)
						ZZK->(DbDelete())
						ZZK->(MsUnLock())
					EndIf
				Endif

			Endif
		Next


//���������������������������������������Ŀ
//�Somente em Caso de Exclus�o das rotinas�
//�����������������������������������������
	ElseIf nOption == 5

		//�����������������������������������������Ŀ
		//�Exclui o cabe�alho do cadastro(Aprovador)�
		//�������������������������������������������
		ZZJ->(DbSetOrder(1))

		If ZZJ->(DbSeek(cFilZZJ + M->ZZJ_CODGRP))
			If RecLock("ZZJ",.F.)
				ZZJ->(DbDelete())
				ZZJ->(MsUnLock())
			EndIf
		Endif

		//�����������������������������������������Ŀ
		//�Exclui os itens do cadastro (Solicitante)�
		//�������������������������������������������
		ZZK->(DbSetOrder(1))
		ZZK->(DbSeek(cFilZZK + M->ZZJ_CODGRP))
		While ZZK->(!Eof()) .AND. ZZK->ZZK_FILIAL = cFilZZK .AND. Alltrim(ZZK->ZZK_CODGRP) == Alltrim(M->ZZJ_CODGRP)
			If RecLock("ZZK",.F.)
				ZZK->(DbDelete())
				ZZK->(MsUnLock())
			Endif
			ZZK->(DbSkip())
		EndDo
	Else
		Aviso("PRTA0003 - GravaCad","Op��o de grava��o n�o Informada corretamente!",{"Ok"})

		//��������������������������������������Ŀ
		//�Restaura a Ordem Original dos Arquivos�
		//����������������������������������������
		RestOrd(aOrdBKP)
		DbSelectArea(cAliasBKP)

		Return .F.
	Endif

//��������������������������������������Ŀ
//�Restaura a Ordem Original dos Arquivos�
//����������������������������������������
	RestOrd(aOrdBKP)
	DbSelectArea(cAliasBKP)

Return .T.
