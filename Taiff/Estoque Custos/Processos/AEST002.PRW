#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Funcao    �  AEST002 � Autor � Fernando Salvatori � Data �  16/11/09   ���
�������������������������������������������������������������������������͹��
���Descricao � Familia x Sub-Familia.                                     ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Generico                                                   ���
�������������������������������������������������������������������������͹��
���           ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL.           ���
�������������������������������������������������������������������������͹��
��� PROGRAMADOR  � DATA   � BOPS �  MOTIVO DA ALTERACAO                   ���
�������������������������������������������������������������������������͹��
���              �        �      �                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function AEST002

//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������
Private cCadastro := "Familia x Sub-Familia"

//���������������������������������������������������������������������Ŀ
//� Monta um aRotina proprio                                            �
//�����������������������������������������������������������������������
Private aRotina := MenuDef()

dbSelectArea("ZA1")
dbSetOrder(1)
mBrowse( 6,1,22,75,"ZA1" )

Return Nil

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MenuDef   �Autor  �Microsiga           � Data �  11/25/09   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function MenuDef()

Local  aRotina := {	{"Pesquisar"	,"AxPesqui",0,1} ,;
						{"Visualizar"	,"U_AEST001M",0,2} ,;
						{"Alterar"		,"U_AEST001M",0,4} ,;
						{"Excluir"		,"U_AEST001M",0,5} ,;
						{"Legenda"		,"U_AEST001L",0,6} }

Return aRotina

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �AEST001M  �Autor  �Fernando Salvatori  � Data �  16/11/09   ���
�������������������������������������������������������������������������͹��
���Desc.     � Chamada do menu principal                                  ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � CADSZB                                                     ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function AEST001M(cAlias,nReg,nOpc)

Local aSize     := MsAdvSize()  //Size da tela.
Local aObjects  := {}           //Objetos da tela
Local aPosObj   := {}           //Posicoes do objeto
Local aInfo     := {}           //Posicoes do objeto
Local lOk       := .F.          //Confirmacao da tela
Local nAcaoGetD := 0            //Acao a ser tomado no MsGetDados
Local aCriaCols := {}           //Variavel que guarda o retorno da funcao A610CriaCols

Private aHeader   := {}         //aHeader da msgetdados
Private aCols     := {}         //aCols da Msgetdados
Private aColsR    := {}         //Recno dos registros da MsGetDados para ser utilizado nas gravacoes
Private N         := 1          //Posicao da linha da GetDados
Private nOpcX     := aRotina[nOpc,4] //Opcao selecionada no sistema
Private aGets, aTela            //Variaveis auxiliares da Enchoice
Private oDlg                    //Objeto da dialog
Private oGetDados               //Objeto da msgetdados
Private oEnch                   //Objeto da Enchoice

//�������������������������������������������������������������������������Ŀ
//� Carrega variaveis da enchoice na memoria.                               �
//���������������������������������������������������������������������������
RegToMemory( "ZA1", .F. )

//�������������������������������������������������������������������������Ŀ
//� Cria aHeader para MsGetDados.                                           �
//���������������������������������������������������������������������������
aHeader := aClone( APBuildHeader("ZA2",{"ZA2_CODFAM"}) )

//�������������������������������������������������������������������������Ŀ
//� Carregando informacoes para a grade do MsGetDados.                      �
//���������������������������������������������������������������������������
dbSelectArea("ZA2")
dbSetOrder(1)
If ! dbSeek( xFilial("ZA2") + ZA1->ZA1_CODIGO )
	aCriaCols := aClone( A610CriaCols("ZA2", aHeader, xFilial("ZA2") + ZA1->ZA1_CODIGO, {|| .F.}) )
Else
	aCriaCols := aClone( A610CriaCols("ZA2", aHeader, xFilial("ZA2") + ZA1->ZA1_CODIGO,;
						{|| ZA2->ZA2_FILIAL + ZA2->ZA2_CODFAM == xFilial("ZA2") + ZA1->ZA1_CODIGO }) )
EndIf

//�������������������������������������������������������������������������Ŀ
//� Faco a distribuicao dos dados de retorno da a610CriaCols                �
//���������������������������������������������������������������������������
aCols  := aClone( aCriaCols[1] )
aColsR := aClone( aCriaCols[2] )

//�������������������������������������������������������������������������Ŀ
//� Define as posicoes da GetDados e Paineis.                               �
//���������������������������������������������������������������������������
AAdd( aObjects, {  030, 030, .T., .T. } )      //Enchoice
AAdd( aObjects, {  080, 080, .T., .T. } )      //GetDados
aInfo 	 := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 2, 2 }
aPosObj  := MsObjSize( aInfo, aObjects, .T. , .F. )

//�������������������������������������������������������������������������Ŀ
//� Montagem da tela.                                                       �
//���������������������������������������������������������������������������
DEFINE MSDIALOG oDlg TITLE cCadastro From aSize[7],00 To aSize[6],aSize[5] OF oMainWnd PIXEL

//�������������������������������������������������������������������������Ŀ
//� Enchoice                                                                �
//���������������������������������������������������������������������������
oEnchoice := Enchoice( "ZA1",nReg,2,,,,,{aPosObj[1,1],aPosObj[1,2],aPosObj[1,3],aPosObj[1,4]},,3,,,,,,.T.)

If nOpcX == 4
	nAcaoGetD := GD_INSERT+GD_DELETE+GD_UPDATE
EndIf

//�������������������������������������������������������������������������Ŀ
//� MsGetDados.                                                             �
//���������������������������������������������������������������������������
oGetDados := MsNewGetDados():New(aPosObj[2][1],aPosObj[2][2],aPosObj[2][3],aPosObj[2][4],;
									nAcaoGetD,"U_AE001LOK",,,,,999,,,,oDlg,aHeader,aCols)

ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{|| IIf(lOk := A002TOk(),oDlg:End(),lOk := .F.)},{||oDlg:End()})

//�������������������������������������������������������������������������Ŀ
//� Confirmacao da gravacao dos dados.                                      �
//���������������������������������������������������������������������������
If lOk .And. nOpcX != 2
	Processa({|| A002Grv()})
EndIf

dbSelectArea("ZA2")
dbSetOrder(1)

dbSelectArea("ZA1")

Return Nil

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �AE001LOK  �Autor  � Fernando Salvatori � Data �  11/16/09   ���
�������������������������������������������������������������������������͹��
���Desc.     � Validacao da Linha do GetDados                             ���
���          �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function AE001LOK

Local lRet := .T.

If !aTail(aCols[n])
	lRet := GDCheckKey({"ZA2_CODSUB"},4)
EndIf

Return lRet
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �A002TOk   �Autor  �Fernando Salvatori  � Data �  14/02/05   ���
�������������������������������������������������������������������������͹��
���Desc.     �Validacao dos dados digitados na tela                       ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function A002TOk()

Local nX   := 0      	//Contador
Local nY   := 0     	//Contador
Local lRet := .t.	 	//Retorno da Funcao

aCols   := aClone(oGetDados:aCols)
aHeader := aClone(oGetDados:aHeader)
N       := oGetDados:nAt

If !aTail(aCols[n])
	lRet := GDCheckKey({"ZA2_CODSUB"},4)
EndIf

//�������������������������������������������������������������������������Ŀ
//� Valida obrigatoriedade dos campos caso a opcao seja alteracao/inclusao  �
//���������������������������������������������������������������������������
If nOpcX != 2 .And. nOpcX != 5 .And. lRet
	For nX := 1 to Len( oGetDados:aCols )
		If !oGetDados:aCols[N,Len(aHeader)+1]
			For nY := 1 to Len( aHeader )
				If X3Obrigat(aHeader[nY][2]) .And. Empty( oGetDados:aCols[nX][nY] )
					MsgStop("Existe registros obrigat�rios em branco."+Chr(13)+Chr(10)+"Item: "+oGetDados:aCols[nX][GDFieldPos("ZA2_CODSUB")],"Aten��o")
					lRet := .F.
					Exit
				EndIf
			Next nY
		EndIf
		If !lRet
			Exit
		EndIf
	Next nX
EndIf

Return lRet

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �A002Grv   �Autor  �Fernando Salvatori  � Data �  14/02/05   ���
�������������������������������������������������������������������������͹��
���Desc.     �Gravacao dos dados na base.                                 ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � vCADSZB                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function A002Grv()

Local cSeekWhile := "" // Variavel que guarda a chave de loop do arquivo

dbSelectArea("ZA2")
dbSetOrder(1)
ProcRegua( 2 )

//�������������������������������������������������������������������������Ŀ
//� Caso a opcao seja de exclusao, apaga registros de SZB                   �
//���������������������������������������������������������������������������
If nOpcX == 5
	dbSeek( cSeekWhile := xFilial("ZA2") + ZA1->ZA1_CODIGO )

	Do While !Eof() .And. cSeekWhile == ZA2_FILIAL + ZA2_CODFAM
		RecLock("ZA2", .F. )
		dbDelete()
		MsUnlock()

		dbSkip()
	EndDo
Else
	A610GravaCol(oGetDados:aCols, aHeader, aColsR, "ZA2",{|| ZA2->ZA2_CODFAM := ZA1->ZA1_CODIGO } )
EndIf

IncProc();IncProc()

Return Nil

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � AE002Cod �Autor  � Fernando Salvatori � Data �  11/16/09   ���
�������������������������������������������������������������������������͹��
���Desc.     � Retorna Codigo do Produto mascarado                        ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Gatilhos do campos de Familia e Sub-Familia Produto        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function AE002Cod(lVer)

Local cRet    := M->B1_COD
Local cQry    := ""
Local aAreaB1 := SB1->( GetArea() )
Local aArea   := GetArea()
Local cAliasQTC	:= "TRBXX"
Local lExistsID	:= .T.
Local cIDprox		:= ""
Local cQuery		:= ""

Default lVer := .F.

//������������������������������������������������������Ŀ
//�Caso esteja preenchido validar o max do cod.do produto�
//��������������������������������������������������������
If !Empty( M->B1_CODFAM ) .And. !Empty( M->B1_SUBFAM ) .And. ! l010Auto
	If lVer
		SB1->( dbSetOrder(1) )
		If SB1->( dbSeek( xFilial("SB1") + cRet ) ) .And. ! IsBlind()
			MsgInfo("O C�digo do produto ser� substituido pois o c�digo "+AllTrim(cRet)+" acabou de ser utilizado por outra esta��o.")
			lVer := .F.
		EndIf
	EndIf

	If ! lVer
		cRet := M->B1_CODFAM + M->B1_SUBFAM

		cQry := "SELECT Max(B1_COD) AS B1_COD FROM "+RetSQLName("SB1")
		cQry += " WHERE SUBSTRING(B1_COD,1,5) = '"+cRet+"' "
		cQry += "   AND D_E_L_E_T_ = ' ' "
		cQry := ChangeQuery( cQry )

		If Select("TSB1") > 0
			TSB1->( dbCloseArea() )
		EndIf

		TCQUERY cQry ALIAS "TSB1" NEW

		If !Eof()
			cRet += Soma1( SubStr( TSB1->B1_COD,6,4 ) )
		Else
			cRet += "0001"
		EndIf

		/* Verifica se na empresa TAIFFPROART ou ACTION ou DAIHATSU j� existe o codigo oferecido */
		/* Verifica��o implementada em 29/05/2017 autor CT */
		
		cAliasQTC := GetNextAlias()
		lExistsID	:= .T.
		
		While lExistsID
			If Select((cAliasQTC)) > 0
				(cAliasQTC)->( dbCloseArea() )
			EndIf
			cQuery := "SELECT B1_COD FROM SB1030"
			cQuery += " WHERE B1_COD = '"+cRet+"' "
			cQuery += "   AND D_E_L_E_T_ = ' ' "
			cQuery += " UNION ALL "
			cQuery += "SELECT B1_COD FROM SB1040"
			cQuery += " WHERE B1_COD = '"+cRet+"' "
			cQuery += "   AND D_E_L_E_T_ = ' ' "
			cQuery += " UNION ALL "
			cQuery += "SELECT B1_COD FROM SB1010"
			cQuery += " WHERE B1_COD = '"+cRet+"' "
			cQuery += "   AND D_E_L_E_T_ = ' ' "
	
			DbUseArea( .T.,"TOPCONN",TCGenQry(,,cQuery),(cAliasQTC),.F.,.T.)
			nContaRegs := 0
			Count To nContaRegs
			
			(cAliasQTC)->(DbCloseArea())
			If nContaRegs = 0
				lExistsID := .F.
			Else
				cIDprox := Soma1( SubStr( cRet,6,4 ) )	
				cRet := M->B1_CODFAM + M->B1_SUBFAM + cIDprox
			EndIf
		End
		/*------------------------[fim da verifica��o]------------------------*/

		
	EndIf
EndIf

If Select("TSB1") > 0
	TSB1->( dbCloseArea() )
EndIf

RestArea(aAreaB1)
RestArea(aArea)
Return cRet

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � AE002Fam �Autor  � Richard N. Cabral  � Data �  24/11/09   ���
�������������������������������������������������������������������������͹��
���Desc.     � Valida se a familia de produtos eh da empresa de login     ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function AE002Fam()

Local cCodFam
Local cEmpres
Local _aEmpAtu
Local nEmpAtu

If l010Auto
	Return(.T.)
Endif

cCodFam := M->B1_CODFAM
cEmpres := Posicione("ZA1",1,xFilial("ZA1")+cCodFam,"ZA1_EMPRES")

If ! Empty(cEmpres)
	If cEmpres <> cEmpAnt
		MsgAlert("Familia n�o pertence a esta empresa !!!","STOP")
		Return(.F.)
	Endif
Else

	//��������������������������������������������������������Ŀ
	//�Valida se eh a empresa da Central de Cadastro (DAIHATSU)�
	//����������������������������������������������������������
	_aEmpAtu := U_CrgaEmp()
	nEmpAtu := Ascan(_aEmpAtu, { | x | x[1] = cEmpAnt .and. x[2] = cFilAnt } )

	If ! ( (nEmpAtu > 0) .And. ( Alltrim(_aEmpAtu[nEmpAtu,1]) = AllTrim(GetMV("MV_GRPCAD",,"01")) ) )
		MsgAlert("Inclus�o n�o permitida nesta empresa !!!","STOP")
		Return(.F.)
	EndIf

Endif

Return(.T.)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � AE002Emp �Autor  � Richard N. Cabral  � Data �  25/11/09   ���
�������������������������������������������������������������������������͹��
���Desc.     � Valida se a familia de produtos eh da empresa selecionada  ���
���          � de acordo com os parametros da tabela SX5 - Z9             ���
�������������������������������������������������������������������������͹��
���Uso       �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function AE002Emp()

Local cCodFam := M->ZA1_CODIGO
Local cEmpres := M->ZA1_EMPRES
Local cRange := Alltrim(Posicione("SX5",1,xFilial("SX5")+"Z9"+cEmpres,"X5_DESCRI"))
Local lRet := .F.

Do While ! Empty(cRange)
	If cCodFam >= Substr(cRange,1,3) .And. cCodFam <= Substr(cRange,5,3)
		lRet := .T.
		Exit
	Else
		cRange := Alltrim(Substr(cRange,9))
	Endif
EndDo

If ! lRet
	MsgAlert("Empresa fora do Range de Familia !!!")
Endif

Return(lRet)

/*
Valida a inclus�o do produto nas demais empresa
Fun��o instalada nos atributos do produto em "Valida��es do Usu�rio" ver dicionario de dados
--> IIF(INCLUI.AND.FINDFUNCTION("U_TFVALEMP"),U_TFVALEMP(M->B1_COD),.T.)
*/
User Function TFVALEMP(cIDproduto)
Local lRetorno		:= .T.
Local cAliasQTC := ""
Local cQuery := ""
Local aAreaSB1 := SB1->( GetArea() )

IF CEMPANT = "01"
	cAliasQTC := GetNextAlias()
	If Select((cAliasQTC)) > 0
		(cAliasQTC)->( dbCloseArea() )
	EndIf
	cQuery := "SELECT B1_COD FROM SB1030"
	cQuery += " WHERE B1_COD = '"+cIDproduto+"' "
	cQuery += "   AND D_E_L_E_T_ = ' ' "
	cQuery += " UNION ALL "
	cQuery += "SELECT B1_COD FROM SB1040"
	cQuery += " WHERE B1_COD = '"+cIDproduto+"' "
	cQuery += "   AND D_E_L_E_T_ = ' ' "
	
	DbUseArea( .T.,"TOPCONN",TCGenQry(,,cQuery),(cAliasQTC),.F.,.T.)
	nContaRegs := 0
	Count To nContaRegs
	
	(cAliasQTC)->(DbCloseArea())
	If nContaRegs != 0
		MsgStop("Este codigo de produto j� existe em outra empresa." + Chr(13) + Chr(10) + "Inclus�o n�o permitida","Aten��o")
		lRetorno		:= .F.
	EndIf
	RestArea(aAreaSB1)
EndIf
Return (lRetorno)