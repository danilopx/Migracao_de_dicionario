#INCLUDE "rwmake.ch"
#INCLUDE "Protheus.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CFGAT002  � Autor � Paulo Bindo        � Data �  15/04/11   ���
�������������������������������������������������������������������������͹��
���Descricao � Cadastro de Usuario x Rotinas                              ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP6 IDE                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function CFGAT002(cCodUsu,cRotUsu)

//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������

	Private cCadastro := "Cadastro de Usuarios x Rotinas"
	Private NOPCX := 0

//���������������������������������������������������������������������Ŀ
//� Monta um aRotina proprio                                            �
//�����������������������������������������������������������������������

	Private aRotina := { {"Pesquisar","AxPesqui",0,1} ,;
		{"Visualizar","U_CFGAT2Vis",0,2} ,;
		{"Incluir","U_CFGAT2Inc",0,3} ,;
		{"Alterar","U_CFGAT2Alt",0,4} ,;
		{"Copiar","U_CFGAT2Cop",0,4} ,;
		{"Excluir","U_CFGAT2Exc",0,5}}//,;



	Private cString := "SZV"

	dbSelectArea("SZV")
	dbSetOrder(1)

	dbSelectArea(cString)
	mBrowse( 6,1,22,75,cString)


Return


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CFGAT2Vis �Autor  �Paulo Bindo         � Data �  03/17/04   ���
�������������������������������������������������������������������������͹��
���Desc.     �Visualizacao do SZV                                         ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function CFGAT2Vis(cAlias,nReg,nOpcX)

	Local i := 0
	Local nB := 0

	Private NUSADO,AHEADER,ACOLS,CCLIENTE,CLOJA
	Private DDATA,NLINGETD,CTITULO,AC,AR,ACGD
	Private CLINHAOK,CTUDOOK,LRETMOD2
	Private nTotaNota := 0
//��������������������������������������������������������������Ŀ
//� Opcao de acesso para o Modelo 2                              �
//����������������������������������������������������������������
// 3,4 Permitem alterar getdados e incluir linhas
// 6 So permite alterar getdados e nao incluir linhas
// Qualquer outro numero so visualiza
	nOpcx:=2
//��������������������������������������������������������������Ŀ
//� Montando aHeader                                             �
//����������������������������������������������������������������
	dbSelectArea("Sx3")
	dbSetOrder(1)
	dbSeek("SZV")
	nUsado:=0
	aHeader:={}
	aGetSD := {}
	While !Eof() .And. (x3_arquivo == "SZV")
		IF X3USO(x3_usado) .AND. cNivel >= x3_nivel .And. Trim(SX3->X3_CAMPO) <> "ZV_CODUSU" .And. ;
				Trim(SX3->X3_CAMPO) <> "ZV_NOMEUSU" .And. Trim(SX3->X3_CAMPO) <> "ZV_MSBLQL"
			nUsado++
			AADD(aHeader,{ TRIM(x3_titulo), x3_campo, x3_picture,;
				x3_tamanho, x3_decimal,x3_valid,;
				x3_usado, x3_tipo, x3_arquivo, x3_context } )
			Aadd( aGetSD, X3_CAMPO)
		Endif
		dbSkip()
	End
//��������������������������������������������������������������Ŀ
//� Montando aCols                                               �
//����������������������������������������������������������������
	aCOLS := Array(1,Len(aHeader)+1)

	For i:=1 to Len(aHeader)
		cCampo:=Alltrim(aHeader[i,2])
		If alltrim(aHeader[i,2])=="ZV_ITEM"
			aCOLS[1][i] := "0001"
		Else
			aCols[1][i]   := CRIAVAR(alltrim(aHeader[i][2]))
		Endif
	Next i
	aCOLS[1][Len(aHeader)+1] := .F.
//��������������������������������������������������������������Ŀ
//� Variaveis do Cabecalho do Modelo 2                           �
//����������������������������������������������������������������

	cCodigo := SZV->ZV_CODUSU
	cNomeU	:= SZV->ZV_NOMEUSU
//cBloq   := SZV->ZV_MSBLQL
	nCnt := 0

	dbSelectArea("SZV")
	dbSetOrder(1)
	If dbSeek(xFilial()+cCodigo)
		While !EOF() .And. ZV_CODUSU ==  cCodigo
			nCnt:=nCnt+1
			dbSkip()
		End
	EndIf
	aCols:=Array(nCnt,Len(aHeader)+1)

	nCnt := 0
	dbSelectArea("SZV")
	dbSetOrder(4)
	If dbSeek(xFilial()+cCodigo)
		While !EOF() .And. ZV_CODUSU ==  cCodigo
			nCnt:=nCnt+1
			For nB:=1 To Len(aHeader)
				cVar      := AScan( aHeader, { |x| AllTrim( x[2] ) == AllTrim(aHeader[nB][2]) } )
				cCampo := AllTrim(aHeader[nB][2])
				aCols[nCnt, cVar] := &cCampo
			Next
			dbSelectArea("SZV")
			dbSkip()
		End
	EndIf
//��������������������������������������������������������������Ŀ
//� Variaveis do Rodape do Modelo 2                              �
//����������������������������������������������������������������
	nLinGetD:=0

//��������������������������������������������������������������Ŀ
//� Array com descricao dos campos do Cabecalho do Modelo 2      �
//����������������������������������������������������������������
	aC:={}
// aC[n,1] = Nome da Variavel Ex.:"cCliente"
// aC[n,2] = Array com coordenadas do Get [x,y], em Windows estao em PIXEL
// aC[n,3] = Titulo do Campo
// aC[n,4] = Picture
// aC[n,5] = Validacao
// aC[n,6] = F3
// aC[n,7] = Se campo e' editavel .t. se nao .f.

	AADD(aC,{"cCodigo"	,{15,010} ,"Codigo          :"	,"@R 99999999"	,".T.","USR"	,.F.})
	AADD(aC,{"cNomeU"	,{15,100} ,"Nome            :"	,""				,".T.", 	,.F.})
//AADD(aC,{"cBloq"	,{30,010} ,"Bloqueado       :"	,			  ,		,		,.T.})

//��������������������������������������������������������������Ŀ
//� Array com descricao dos campos do Rodape do Modelo 2         �
//����������������������������������������������������������������
	aR:={}
// aR[n,1] = Nome da Variavel Ex.:"cCliente"
// aR[n,2] = Array com coordenadas do Get [x,y], em Windows estao em PIXEL
// aR[n,3] = Titulo do Campo
// aR[n,4] = Picture
// aR[n,5] = Validacao
// aR[n,6] = F3
// aR[n,7] = Se campo e' editavel .t. se nao .f.

//��������������������������������������������������������������Ŀ
//� Array com coordenadas da GetDados no modelo2                 �
//����������������������������������������������������������������
	aCordW :={125,100,600,735}
	aCGD:={75,5,218,310}
	aGetEdit := {}
//��������������������������������������������������������������Ŀ
//� Validacoes na GetDados da Modelo 2                           �
//����������������������������������������������������������������
	cLinhaOk:="AlwaysTrue()"
	cTudoOk:="AlwaysTrue()"
//��������������������������������������������������������������Ŀ
//� Chamada da Modelo2                                           �
//����������������������������������������������������������������
// lRetMod2 = .t. se confirmou
// lRetMod2 = .f. se cancelou
	lRetMod2:=Modelo2(cCadastro,aC,aR,aCGD,nOpcx,cLinhaOk,cTudoOk,aGetSD,,,,aCordW,.F.)
// No Windows existe a funcao de apoio CallMOd2Obj() que retorna o
// objeto Getdados Corrente

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CFGAT2Inc �Autor  �Paulo Bindo         � Data �  03/16/04   ���
�������������������������������������������������������������������������͹��
���Desc.     �Inclusao de dados no Z07                                    ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function CFGAT2Inc(cAlias,nReg,nOpcX)

	Local i := 0
	Local nA := 0
	Local nB := 0

	Private NUSADO,AHEADER,ACOLS,CCLIENTE,CLOJA
	Private DDATA,NLINGETD,CTITULO,AC,AR,ACGD
	Private CLINHAOK,CTUDOOK,LRETMOD2,cCodigo
	Private nTotaNota := 0
	Private cCodigo
	Private cNomeU

//��������������������������������������������������������������Ŀ
//� Opcao de acesso para o Modelo 2                              �
//����������������������������������������������������������������
// 3,4 Permitem alterar getdados e incluir linhas
// 6 So permite alterar getdados e nao incluir linhas
// Qualquer outro numero so visualiza
	nOpcx:=3
//��������������������������������������������������������������Ŀ
//� Montando aHeader                                             �
//����������������������������������������������������������������
	dbSelectArea("Sx3")
	dbSetOrder(1)
	dbSeek("SZV")
	nUsado:=0
	aHeader:={}
	aGetSD := {}
	While !Eof() .And. (x3_arquivo == "SZV")
		IF X3USO(x3_usado) .AND. cNivel >= x3_nivel .And. Trim(SX3->X3_CAMPO) <> "ZV_CODUSU" .And. ;
				Trim(SX3->X3_CAMPO) <> "ZV_NOMEUSU" .And. Trim(SX3->X3_CAMPO) <> "ZV_MSBLQL"
			nUsado++
			AADD(aHeader,{ TRIM(x3_titulo), x3_campo, x3_picture,;
				x3_tamanho, x3_decimal,x3_valid,;
				x3_usado, x3_tipo, x3_arquivo, x3_context } )
			Aadd( aGetSD, X3_CAMPO)
		Endif
		dbSkip()
	End
//��������������������������������������������������������������Ŀ
//� Montando aCols                                               �
//����������������������������������������������������������������
	aCOLS := Array(1,Len(aHeader)+1)

	For i:=1 to Len(aHeader)
		cCampo:=Alltrim(aHeader[i,2])
		If alltrim(aHeader[i,2])=="ZV_ITEM"
			aCOLS[1][i] := "0001"
		Else
			aCols[1][i]   := CRIAVAR(alltrim(aHeader[i][2]))
		Endif
	Next i
	aCOLS[1][Len(aHeader)+1] := .F.
//��������������������������������������������������������������Ŀ
//� Variaveis do Cabecalho do Modelo 2                           �
//����������������������������������������������������������������
	cCodigo := Space(06)
	cNomeU	:= Space(30)
//cBloq   := Space(01)

//��������������������������������������������������������������Ŀ
//� Variaveis do Rodape do Modelo 2                              �
//����������������������������������������������������������������
	nLinGetD:=0

//��������������������������������������������������������������Ŀ
//� Array com descricao dos campos do Cabecalho do Modelo 2      �
//����������������������������������������������������������������
	aC:={}
// aC[n,1] = Nome da Variavel Ex.:"cCliente"
// aC[n,2] = Array com coordenadas do Get [x,y], em Windows estao em PIXEL
// aC[n,3] = Titulo do Campo
// aC[n,4] = Picture
// aC[n,5] = Validacao
// aC[n,6] = F3
// aC[n,7] = Se campo e' editavel .t. se nao .f.


	AADD(aC,{"cCodigo"	,{15,010} ,"Codigo          :"	,"@R 99999999"	,"","US1"	,.T.})
	AADD(aC,{"cNomeU"	,{15,100} ,"Nome            :"	,""				,".T.",	  	,.F.})
//AADD(aC,{"cBloq"	,{30,010} ,"Bloqueado       :"	,			  ,		,		,.T.})

//��������������������������������������������������������������Ŀ
//� Array com descricao dos campos do Rodape do Modelo 2         �
//����������������������������������������������������������������
	aR:={}
// aR[n,1] = Nome da Variavel Ex.:"cCliente"
// aR[n,2] = Array com coordenadas do Get [x,y], em Windows estao em PIXEL
// aR[n,3] = Titulo do Campo
// aR[n,4] = Picture
// aR[n,5] = Validacao
// aR[n,6] = F3
// aR[n,7] = Se campo e' editavel .t. se nao .f.

//��������������������������������������������������������������Ŀ
//� Array com coordenadas da GetDados no modelo2                 �
//����������������������������������������������������������������
	aCordW :={125,100,600,735}
	aCGD:={75,5,218,310}
	aGetEdit := {}
//��������������������������������������������������������������Ŀ
//� Validacoes na GetDados da Modelo 2                           �
//����������������������������������������������������������������
	cLinhaOk:=".T."
	cTudoOk:=".T."
//��������������������������������������������������������������Ŀ
//� Chamada da Modelo2                                           �
//����������������������������������������������������������������
// lRetMod2 = .t. se confirmou
// lRetMod2 = .f. se cancelou
	lRetMod2:=Modelo2(cCadastro,aC,aR,aCGD,nOpcx,cLinhaOk,cTudoOk,aGetSD,,"+ZV_ITEM",,aCordW,.T.)
// No Windows existe a funcao de apoio CallMOd2Obj() que retorna o
// objeto Getdados Corrente
	If lRetMod2
		For nA:=1 To Len(aCols)
			If !( aCols[nA][Len(aHeader)+1] )
				nI	:= aScan(aHeader,{|x| UPPER(AllTrim(x[2]))=="ZV_ITEM" })
				If  !Empty(aCols[nA,nI])
					RecLock("SZV",.T.)
					ZV_CODUSU  	:= cCodigo
					ZV_NOMEUSU 	:=  UsrRetName(cCodigo)
//				ZV_MSBLQL	:= cBloq
					For nB:=1 To Len(aHeader)
						cVar      := AScan( aHeader, { |x| AllTrim( x[2] ) == AllTrim(aHeader[nB][2]) } )
						xConteudo := aCols[ nA, cVar ]
						cCampo := AllTrim(aHeader[nB][2])
						Replace &cCampo With xConteudo
					Next
					ConfirmSX8()
					SZV->(MsUnlock())
				EndIf
			EndIf
		Next
		Return
	Else
		RollBackSX8()
		Return
	EndIf
Return


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �RDTKC7Alt �Autor  �Paulo Bindo         � Data �  03/17/04   ���
�������������������������������������������������������������������������͹��
���Desc.     �Altera a tabela de premissas                                ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function CFGAT2Alt(cAlias,nReg,nOpcX)

	Local i  := 0
	Local nA := 0
	Local nB := 0

	Private NUSADO,AHEADER,ACOLS,CCLIENTE,CLOJA
	Private DDATA,NLINGETD,CTITULO,AC,AR,ACGD
	Private CLINHAOK,CTUDOOK,LRETMOD2
	Private nTotaNota := 0
//��������������������������������������������������������������Ŀ
//� Opcao de acesso para o Modelo 2                              �
//����������������������������������������������������������������
// 3,4 Permitem alterar getdados e incluir linhas
// 6 So permite alterar getdados e nao incluir linhas
// Qualquer outro numero so visualiza
	nOpcx:=4
//��������������������������������������������������������������Ŀ
//� Montando aHeader                                             �
//����������������������������������������������������������������
	dbSelectArea("Sx3")
	dbSetOrder(1)
	dbSeek("SZV")
	nUsado:=0
	aHeader:={}
	aGetSD := {}
	While !Eof() .And. (x3_arquivo == "SZV")
		IF X3USO(x3_usado) .AND. cNivel >= x3_nivel .And. Trim(SX3->X3_CAMPO) <> "ZV_CODUSU" .And. ;
				Trim(SX3->X3_CAMPO) <> "ZV_NOMEUSU" .And. Trim(SX3->X3_CAMPO) <> "ZV_MSBLQL"
			nUsado++
			AADD(aHeader,{ TRIM(x3_titulo), x3_campo, x3_picture,;
				x3_tamanho, x3_decimal,x3_valid,;
				x3_usado, x3_tipo, x3_arquivo, x3_context } )
			Aadd( aGetSD, X3_CAMPO)
		Endif
		dbSkip()
	End
//��������������������������������������������������������������Ŀ
//� Montando aCols                                               �
//����������������������������������������������������������������
	aCOLS := Array(1,Len(aHeader)+1)

	For i:=1 to Len(aHeader)
		cCampo:=Alltrim(aHeader[i,2])
		If alltrim(aHeader[i,2])=="ZV_ITEM"
			aCOLS[1][i] := "0001"
		Else
			aCols[1][i]   := CRIAVAR(alltrim(aHeader[i][2]))
		Endif
	Next i
	aCOLS[1][Len(aHeader)+1] := .F.
//��������������������������������������������������������������Ŀ
//� Variaveis do Cabecalho do Modelo 2                           �
//����������������������������������������������������������������

	cCodigo := SZV->ZV_CODUSU
	cNomeU	:= SZV->ZV_NOMEUSU
//cBloq   := SZV->ZV_MSBLQL

	nCnt := 0

	dbSelectArea("SZV")
	dbSetOrder(1)
	If dbSeek(xFilial()+cCodigo)
		While !EOF() .And. ZV_CODUSU ==  cCodigo
			nCnt:=nCnt+1
			dbSkip()
		End
	EndIf
	If nCnt == 0
		Help(" ",1,"NOITENS")
		Return
	EndIf

	aCols		:=	Array(nCnt,Len(aHeader)+1)
	aRecnos	:=	Array(nCnt)

	nCnt := 0
	dbSelectArea("SZV")
	dbSetOrder(4)
	If dbSeek(xFilial()+cCodigo)
		While !EOF() .And. ZV_CODUSU ==  cCodigo
			nCnt:=nCnt+1
			For nB:=1 To Len(aHeader)
				cVar      := AScan( aHeader, { |x| AllTrim( x[2] ) == AllTrim(aHeader[nB][2]) } )
				cCampo := AllTrim(aHeader[nB][2])
				aCols[nCnt, cVar] := &cCampo
			Next
			aCOLS[nCnt][Len(aHeader)+1] := .F.
			dbSelectArea("SZV")
			dbSkip()
		End
	EndIf
//��������������������������������������������������������������Ŀ
//� Variaveis do Rodape do Modelo 2                              �
//����������������������������������������������������������������
	nLinGetD:=0

//��������������������������������������������������������������Ŀ
//� Array com descricao dos campos do Cabecalho do Modelo 2      �
//����������������������������������������������������������������
	aC:={}
// aC[n,1] = Nome da Variavel Ex.:"cCliente"
// aC[n,2] = Array com coordenadas do Get [x,y], em Windows estao em PIXEL
// aC[n,3] = Titulo do Campo
// aC[n,4] = Picture
// aC[n,5] = Validacao
// aC[n,6] = F3
// aC[n,7] = Se campo e' editavel .t. se nao .f.

	AADD(aC,{"cCodigo"	,{15,010} ,"Codigo          :"	,"@R 99999999"	,".T.","USR"	,.F.})
	AADD(aC,{"cNomeU"	,{15,100} ,"Nome            :"	,""				,".T.",	  	,.F.})
//AADD(aC,{"cBloq"	,{30,010} ,"Bloqueado       :"	,			  ,		,		,.T.})

//��������������������������������������������������������������Ŀ
//� Array com descricao dos campos do Rodape do Modelo 2         �
//����������������������������������������������������������������
	aR:={}
// aR[n,1] = Nome da Variavel Ex.:"cCliente"
// aR[n,2] = Array com coordenadas do Get [x,y], em Windows estao em PIXEL
// aR[n,3] = Titulo do Campo
// aR[n,4] = Picture
// aR[n,5] = Validacao
// aR[n,6] = F3
// aR[n,7] = Se campo e' editavel .t. se nao .f.

//��������������������������������������������������������������Ŀ
//� Array com coordenadas da GetDados no modelo2                 �
//����������������������������������������������������������������
	aCordW :={125,100,600,735}
	aCGD:={75,5,218,310}
	aGetEdit := {}
//��������������������������������������������������������������Ŀ
//� Validacoes na GetDados da Modelo 2                           �
//����������������������������������������������������������������
	cLinhaOk:=".T."
	cTudoOk:=".T."
//��������������������������������������������������������������Ŀ
//� Chamada da Modelo2                                           �
//����������������������������������������������������������������
// lRetMod2 = .t. se confirmou
// lRetMod2 = .f. se cancelou
	lRetMod2:=Modelo2(cCadastro,aC,aR,aCGD,nOpcx,cLinhaOk,cTudoOk,aGetSD,,"+ZV_ITEM",,aCordW,)
// No Windows existe a funcao de apoio CallMOd2Obj() que retorna o
// objeto Getdados Corrente
	If lRetMod2
		nI	:= aScan(aHeader,{|x| UPPER(AllTrim(x[2]))=="ZV_ITEM" })
		cItem := aCols[1,nI]
		dbSelectArea("SZV")
		dbSetOrder(4)
		dbSeek(xFILIAL()+cCodigo+cItem)
		While !EOF() .And. cCodigo== SZV->ZV_CODUSU
			For nA:=1 To Len(aCols)
				nI	:= aScan(aHeader,{|x| UPPER(AllTrim(x[2]))=="ZV_FUNCAO" })
				If  !Empty(aCols[nA,nI])
					nI	:= aScan(aHeader,{|x| UPPER(AllTrim(x[2]))=="ZV_ITEM" })
					If aCols[nA,nI] == SZV->ZV_ITEM
						If !( aCols[nA][Len(aHeader)+1] )	//GRAVA OS CAMPOS DA LINHA
							RecLock("SZV",.F.)
							For nB:=1 To Len(aHeader)
								cVar      := AScan( aHeader, { |x| AllTrim( x[2] ) == AllTrim(aHeader[nB][2]) } )
								xConteudo := aCols[ nA, cVar ]
								cCampo := AllTrim(aHeader[nB][2])
								Replace &cCampo With xConteudo
							Next
							SZV->(MsUnlock())
						Else	//CASO A LINHA ESTEJA DELETADA NO ACOLS APAGA DA BASE
							dbSelectArea("SZV")
							dbSetOrder(4)
							If dbSeek(xFILIAL()+cCodigo+aCols[nA,nI])
								RecLock("SZV",.F.)
								dbDelete()
								MsUnLock()
							EndIf
						EndIf
						dbSkip()
						Loop
					Else	//INCLUI O NOVO REGISTRO
						RecLock("SZV",.T.)
						ZV_CODUSU  	:= cCodigo
						ZV_NOMEUSU 	:= cNomeU
//					ZV_MSBLQL	:= cBloq
						If !( aCols[nA][Len(aHeader)+1] )
							For nB:=1 To Len(aHeader)
								cVar      := AScan( aHeader, { |x| AllTrim( x[2] ) == AllTrim(aHeader[nB][2]) } )
								xConteudo := aCols[ nA, cVar ]
								cCampo := AllTrim(aHeader[nB][2])
								Replace &cCampo With xConteudo
							Next
						EndIf
						SZV->(MsUnlock())
						dbSkip()
						Loop
					EndIf
				EndIf
			Next
		End
		Return

	Else
		Return
	EndIf

Return


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CFGAT2Exc �Autor  �Paulo Bindo         � Data �  03/16/04   ���
�������������������������������������������������������������������������͹��
���Desc.     �Exclusao de dados no Z07                                    ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function CFGAT2Exc(cAlias,nReg,nOpcX)

	Local i  := 0
	Local nA := 0
	Local nB := 0

	Private NUSADO,AHEADER,ACOLS,CCLIENTE,CLOJA
	Private DDATA,NLINGETD,CTITULO,AC,AR,ACGD
	Private CLINHAOK,CTUDOOK,LRETMOD2
	Private nTotaNota := 0
//��������������������������������������������������������������Ŀ
//� Opcao de acesso para o Modelo 2                              �
//����������������������������������������������������������������
// 3,4 Permitem alterar getdados e incluir linhas
// 6 So permite alterar getdados e nao incluir linhas
// Qualquer outro numero so visualiza
	nOpcx:=5
//��������������������������������������������������������������Ŀ
//� Montando aHeader                                             �
//����������������������������������������������������������������
	dbSelectArea("Sx3")
	dbSetOrder(1)
	dbSeek("SZV")
	nUsado:=0
	aHeader:={}
	aGetSD := {}
	While !Eof() .And. (x3_arquivo == "SZV")
		IF X3USO(x3_usado) .AND. cNivel >= x3_nivel .And. Trim(SX3->X3_CAMPO) <> "ZV_CODUSU" .And. ;
				Trim(SX3->X3_CAMPO) <> "ZV_NOMEUSU" .And. Trim(SX3->X3_CAMPO) <> "ZV_MSBLQL"
			nUsado++
			AADD(aHeader,{ TRIM(x3_titulo), x3_campo, x3_picture,;
				x3_tamanho, x3_decimal,x3_valid,;
				x3_usado, x3_tipo, x3_arquivo, x3_context } )
			Aadd( aGetSD, X3_CAMPO)
		Endif
		dbSkip()
	End
//��������������������������������������������������������������Ŀ
//� Montando aCols                                               �
//����������������������������������������������������������������
	aCOLS := Array(1,Len(aHeader)+1)

	For i:=1 to Len(aHeader)
		cCampo:=Alltrim(aHeader[i,2])
		If alltrim(aHeader[i,2])=="ZV_ITEM"
			aCOLS[1][i] := "0001"
		Else
			aCols[1][i]   := CRIAVAR(alltrim(aHeader[i][2]))
		Endif
	Next i
	aCOLS[1][Len(aHeader)+1] := .F.
//��������������������������������������������������������������Ŀ
//� Variaveis do Cabecalho do Modelo 2                           �
//����������������������������������������������������������������

	cCodigo := SZV->ZV_CODUSU
	cNomeU	:= SZV->ZV_NOMEUSU
//cBloq   := SZV->ZV_MSBLQL

	nCnt := 0

	dbSelectArea("SZV")
	dbSetOrder(1)
	If dbSeek(xFilial()+cCodigo)
		While !EOF() .And. ZV_CODUSU ==  cCodigo
			nCnt:=nCnt+1
			dbSkip()
		End
	EndIf
	aCols:=Array(nCnt,i)

	nCnt := 0
	dbSelectArea("SZV")
	dbSetOrder(4)
	If dbSeek(xFilial()+cCodigo)
		While !EOF() .And. ZV_CODUSU ==  cCodigo
			nCnt:=nCnt+1
			For nB:=1 To Len(aHeader)
				cVar      := AScan( aHeader, { |x| AllTrim( x[2] ) == AllTrim(aHeader[nB][2]) } )
				cCampo := AllTrim(aHeader[nB][2])
				aCols[nCnt, cVar] := &cCampo
			Next
			dbSelectArea("SZV")
			dbSkip()
		End
	EndIf
//��������������������������������������������������������������Ŀ
//� Variaveis do Rodape do Modelo 2                              �
//����������������������������������������������������������������
	nLinGetD:=0

//��������������������������������������������������������������Ŀ
//� Array com descricao dos campos do Cabecalho do Modelo 2      �
//����������������������������������������������������������������
	aC:={}
// aC[n,1] = Nome da Variavel Ex.:"cCliente"
// aC[n,2] = Array com coordenadas do Get [x,y], em Windows estao em PIXEL
// aC[n,3] = Titulo do Campo
// aC[n,4] = Picture
// aC[n,5] = Validacao
// aC[n,6] = F3
// aC[n,7] = Se campo e' editavel .t. se nao .f.

	AADD(aC,{"cCodigo"	,{15,010} ,"Codigo          :"	,"@R 99999999"	,".T.","USR"	,.F.})
	AADD(aC,{"cNomeU"	,{15,100} ,"Nome            :"	,""				,".T.",	  	,.F.})
//AADD(aC,{"cBloq"	,{30,010} ,"Bloqueado       :"	,			  ,		,		,.F.})

//��������������������������������������������������������������Ŀ
//� Array com descricao dos campos do Rodape do Modelo 2         �
//����������������������������������������������������������������
	aR:={}
// aR[n,1] = Nome da Variavel Ex.:"cCliente"
// aR[n,2] = Array com coordenadas do Get [x,y], em Windows estao em PIXEL
// aR[n,3] = Titulo do Campo
// aR[n,4] = Picture
// aR[n,5] = Validacao
// aR[n,6] = F3
// aR[n,7] = Se campo e' editavel .t. se nao .f.

//��������������������������������������������������������������Ŀ
//� Array com coordenadas da GetDados no modelo2                 �
//����������������������������������������������������������������
	aCordW :={125,100,600,735}
	aCGD:={75,5,218,310}
	aGetEdit := {}
//��������������������������������������������������������������Ŀ
//� Validacoes na GetDados da Modelo 2                           �
//����������������������������������������������������������������
	cLinhaOk:="AlwaysTrue()"
	cTudoOk:="AlwaysTrue()"
//��������������������������������������������������������������Ŀ
//� Chamada da Modelo2                                           �
//����������������������������������������������������������������
// lRetMod2 = .t. se confirmou
// lRetMod2 = .f. se cancelou
	lRetMod2:=Modelo2(cCadastro,aC,aR,aCGD,nOpcx,cLinhaOk,cTudoOk,aGetSD,,,,aCordW,.F.)
// No Windows existe a funcao de apoio CallMOd2Obj() que retorna o
// objeto Getdados Corrente

	If lRetMod2
		dbSelectArea("SZV")
		dbSetOrder(4)
		IF dbSeek(xFilial()+cCodigo)
			While !Eof() .and. ZV_CODUSU == cCodigo
				RecLock("SZV",.F.)
				dbDelete()
				MsUnLock()
				dbSkip()
			End
		EndIf
	EndIf
Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �RDTKC7Cop �Autor  �Paulo Bindo         � Data �  03/23/04   ���
�������������������������������������������������������������������������͹��
���Desc.     �Copia de registro p/ Inclusao de dados no Z07               ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function CFGAT2Cop(cAlias,nReg,nOpcX)

	Local i := 0
	Local nA := 0
	Local nB := 0

	Private NUSADO,AHEADER,ACOLS,CCLIENTE,CLOJA
	Private DDATA,NLINGETD,CTITULO,AC,AR,ACGD
	Private CLINHAOK,CTUDOOK,LRETMOD2,cCodigo
	Private nTotaNota := 0
//��������������������������������������������������������������Ŀ
//� Opcao de acesso para o Modelo 2                              �
//����������������������������������������������������������������
// 3,4 Permitem alterar getdados e incluir linhas
// 6 So permite alterar getdados e nao incluir linhas
// Qualquer outro numero so visualiza
	nOpcx:=3
//��������������������������������������������������������������Ŀ
//� Montando aHeader                                             �
//����������������������������������������������������������������
	dbSelectArea("Sx3")
	dbSetOrder(1)
	dbSeek("SZV")
	nUsado:=0
	aHeader:={}
	aGetSD := {}
	While !Eof() .And. (x3_arquivo == "SZV")
		IF X3USO(x3_usado) .AND. cNivel >= x3_nivel .And. Trim(SX3->X3_CAMPO) <> "ZV_CODUSU" .And. ;
				Trim(SX3->X3_CAMPO) <> "ZV_NOMEUSU" .And. Trim(SX3->X3_CAMPO) <> "ZV_MSBLQL"
			nUsado++
			AADD(aHeader,{ TRIM(x3_titulo), x3_campo, x3_picture,;
				x3_tamanho, x3_decimal,x3_valid,;
				x3_usado, x3_tipo, x3_arquivo, x3_context } )
			Aadd( aGetSD, X3_CAMPO)
		Endif
		dbSkip()
	End
//��������������������������������������������������������������Ŀ
//� Montando aCols                                               �
//����������������������������������������������������������������
	aCOLS := Array(1,Len(aHeader)+1)

	For i:=1 to Len(aHeader)
		cCampo:=Alltrim(aHeader[i,2])
		If alltrim(aHeader[i,2])=="ZV_ITEM"
			aCOLS[1][i] := "0001"
		Else
			aCols[1][i]   := CRIAVAR(alltrim(aHeader[i][2]))
		Endif
	Next i
	aCOLS[1][Len(aHeader)+1] := .F.
//��������������������������������������������������������������Ŀ
//� Variaveis do Cabecalho do Modelo 2                           �
//����������������������������������������������������������������
	cCodigo := Space(06)
	cNomeU	:= Space(30)
	cCodCop := SZV->ZV_CODUSU

	nCnt := 0

	dbSelectArea("SZV")
	dbSetOrder(1)
	If dbSeek(xFilial()+cCodCop)
		While !EOF() .And. ZV_CODUSU ==  cCodCop
			nCnt:=nCnt+1
			dbSkip()
		End
	EndIf
	If nCnt == 0
		MsgInfo("Nenhum item foi selecionado!","SEM REGISTROS!")
		Return
	EndIf

	aCols		:=	Array(nCnt,Len(aHeader)+1)
	aRecnos	:=	Array(nCnt)

	nCnt := 0
	dbSelectArea("SZV")
	dbSetOrder(4)
	If dbSeek(xFilial()+cCodCop)
		While !EOF() .And. ZV_CODUSU ==  cCodCop
			nCnt:=nCnt+1
			For nB:=1 To Len(aHeader)
				cVar      := AScan( aHeader, { |x| AllTrim( x[2] ) == AllTrim(aHeader[nB][2]) } )
				cCampo := AllTrim(aHeader[nB][2])
				aCols[nCnt, cVar] := &cCampo
			Next
			aCOLS[nCnt][Len(aHeader)+1] := .F.
			dbSelectArea("SZV")
			dbSkip()
		End
	EndIf


//��������������������������������������������������������������Ŀ
//� Variaveis do Rodape do Modelo 2                              �
//����������������������������������������������������������������
	nLinGetD:=0

//��������������������������������������������������������������Ŀ
//� Array com descricao dos campos do Cabecalho do Modelo 2      �
//����������������������������������������������������������������
	aC:={}
// aC[n,1] = Nome da Variavel Ex.:"cCliente"
// aC[n,2] = Array com coordenadas do Get [x,y], em Windows estao em PIXEL
// aC[n,3] = Titulo do Campo
// aC[n,4] = Picture
// aC[n,5] = Validacao
// aC[n,6] = F3
// aC[n,7] = Se campo e' editavel .t. se nao .f.

	AADD(aC,{"cCodigo"	,{15,010} ,"Codigo          :"	,"@R 99999999",".T.","USR"	,.T.})
//AADD(aC,{"cNomeU"	,{15,100} ,"Nome            :"	,"@R 99999999",".T.",	  	,.T.})

///��������������������������������������������������������������Ŀ
//� Array com descricao dos campos do Rodape do Modelo 2         �
//����������������������������������������������������������������
	aR:={}
// aR[n,1] = Nome da Variavel Ex.:"cCliente"
// aR[n,2] = Array com coordenadas do Get [x,y], em Windows estao em PIXEL
// aR[n,3] = Titulo do Campo
// aR[n,4] = Picture
// aR[n,5] = Validacao
// aR[n,6] = F3
// aR[n,7] = Se campo e' editavel .t. se nao .f.

//AADD(aR,{"nTotaNota"  ,{220,010},"Total Nota","@E 999",,,.F.})
//��������������������������������������������������������������Ŀ
//� Array com coordenadas da GetDados no modelo2                 �
//����������������������������������������������������������������
	aCordW :={125,100,600,735}
	aCGD:={75,5,218,310}
	aGetEdit := {}
//��������������������������������������������������������������Ŀ
//� Validacoes na GetDados da Modelo 2                           �
//����������������������������������������������������������������
	cLinhaOk:=".T."
	cTudoOk:=".T."
//��������������������������������������������������������������Ŀ
//� Chamada da Modelo2                                           �
//����������������������������������������������������������������
// lRetMod2 = .t. se confirmou
// lRetMod2 = .f. se cancelou
	lRetMod2:=Modelo2(cCadastro,aC,aR,aCGD,nOpcx,cLinhaOk,cTudoOk,aGetSD,,"+ZV_ITEM",,aCordW,.T.)
// No Windows existe a funcao de apoio CallMOd2Obj() que retorna o
// objeto Getdados Corrente

	If lRetMod2
		For nA:=1 To Len(aCols)
			If !( aCols[nA][Len(aHeader)+1] )
				nI	:= aScan(aHeader,{|x| UPPER(AllTrim(x[2]))=="ZV_ITEM" })
				If  !Empty(aCols[nA,nI])
					RecLock("SZV",.T.)
					ZV_CODUSU  	:= cCodigo
					ZV_NOMEUSU 	:=  UsrRetName(cCodigo)
//				ZV_MSBLQL	:= cBloq
					For nB:=1 To Len(aHeader)
						cVar      := AScan( aHeader, { |x| AllTrim( x[2] ) == AllTrim(aHeader[nB][2]) } )
						xConteudo := aCols[ nA, cVar ]
						cCampo := AllTrim(aHeader[nB][2])
						Replace &cCampo With xConteudo
					Next
					ConfirmSX8()
					SZV->(MsUnlock())
				EndIf
			EndIf
		Next
	EndIf
Return


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �RDTKC7LIOK�Autor  �Paulo Bindo         � Data �  03/17/04   ���
�������������������������������������������������������������������������͹��
���Desc.     �Valida se alinha esta OK                                    ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
/*
User Function RDTKC7LIOK()
Local nN     := 0
Local nC     := 0
lRet	     := .T.
nTotaNota    := 0

	For nA:=1 To Len(aHeader)
		If Alltrim(aHeader[nA][2])=="Z07_NOTAMX"
		nN := nA
		EndIf
		If Alltrim(aHeader[nA][2])=="Z07_ITENSC"
		nC := nA
		cItem:= aCols[n][nC]
		EndIf
	Next
//VERIFICA A EXISTENCIA DE DUPLICIDADE
	If !aCols[n,Len(aCols[n])]
		For nT:= 1 To Len(aCols)
			If !aCols[nT,Len(aCols[nT])]       /// Se NAO esta Deletado
				If cItem == aCols[nT][nC] .and. nT <> n
				lRet := .F.
				MsgStop("Este item ja foi utilizado anteriormente.","ITEM DUPLICADO!")
				Return(lRet)
				EndIf
			EndIf
		Next
	EndIf
//SOMA O TOTAL DE PONTOS
	For nT:= 1 To Len(aCols)
		If !aCols[nT,Len(aCols[nT])]      /// Se esta Deletado
		nTotaNota += aCols[nT][nN]
		EndIf
	Next

cQuery := " SELECT Z07_NOTAMX FROM Z07010 "
cQuery += "WHERE Z07_AVLIAC = '"+cAVLCRS+"' AND Z07_ITENSC = '"+cITNCRS+"' AND Z07_CODEMP = '"+cCodEmp+"' "
cQuery += " AND Z07_DEPTO = '"+cDEPTO+"' AND D_E_L_E_T_ <> '*'"

cQuery  := ChangeQuery(cQuery)
MemoWrit("RDTKC7LIOK.sql",cQuery)
dbUseArea(.T.,"TOPCONN", TCGenQry(,,cQuery),'TRB', .F., .T.)
Count To nCount

	If nCount > 0
	dbSelectArea("TRB")
	dbGotop()	
		If nTotaNota > TRB->Z07_NOTAMX .And. !aCols[n,Len(aCols[n])]
		MsgStop("Os valores de nota inseridos ultrapassaram o m�ximo do Item da Premissa principal, O Valor m�ximo �: "+AllTrim(Str(TRB->Z07_NOTAMX))+"!")
		lRet := .F.
		TRB->(dbCloseArea())
		Return(lRet)
		EndIf
	EndIf
TRB->(dbCloseArea())
Return(lRet)
*/

/*/
	�����������������������������������������������������������������������������
	�����������������������������������������������������������������������������
	�������������������������������������������������������������������������Ŀ��
	���Fun��o	 �FATRD010  � Autor �Paulo Bindo	        � Data � 24/11/05 ���
	�������������������������������������������������������������������������Ĵ��
	���Descri��o �ABRE DIAS DA SEMANA PARA ENTREGAS                 		  ���
	�������������������������������������������������������������������������Ĵ��
	���Sintaxe	 �          												  ���
	�������������������������������������������������������������������������Ĵ��
	��� Uso		 � Generico 												  ���
	��������������������������������������������������������������������������ٱ�
	�����������������������������������������������������������������������������
�����������������������������������������������������������������������������/*/
User Function CFGAT2FIL(l1Elem,lTipoRet)

	Local cTitulo := ""
	Local MvPar
	Local MvParDef:= ""

	Private aSit:={}
	l1Elem := If (l1Elem = Nil , .F. , .T.)

	DEFAULT lTipoRet := .T.

	cAlias := Alias() 					 // Salva Alias Anterior

	IF lTipoRet
		MvPar:=&(Alltrim(ReadVar()))	 // Carrega Nome da Variavel do Get em Questao
		mvRet:=Alltrim(ReadVar())		 // Iguala Nome da Variavel ao Nome variavel de Retorno
	EndIF

	aSit := {;
		"0101 - " + "DAIHATSU - MATRIZ",;
		"0102 - " + "DAIHATSU - NACOES",;
		"0301 - " + "PROART - MATRIZ",;
		"0302 - " + "EXTREMA",;
		"0303 - " + "BARUERI",;
		"0401 - " + "ACTION - SP",;
		"0402 - " + "ACTION - MG",;
		"0201 - " + "MERCABEL - SP",;
		"0202 - " + "MERCABEL - GO",;
		"0403 - " + "ACTION - SC";
		}

	MvParDef:= "123456789A"

/*               
f_Opcoes(Variavel de Retorno,;
					Titulo da Coluna com as opcoes,;
					Opcoes de Escolha (Array de Opcoes),;
					String de Opcoes para Retorno,;
					Nao Utilizado,;
					Nao Utilizado,;
					Se a Selecao sera de apenas 1 Elemento por vez,;
					Tamanho da Chave,;
					No maximo de elementos na variavel de retorno,;
					Inclui Botoes para Selecao de Multiplos Itens,;
					Se as opcoes serao montadas a partir de ComboBox de Campo ( X3_CBOX ),;
					Qual o Campo para a Montagem do aOpcoes,;
					Nao Permite a Ordenacao,;
					Nao Permite a Pesquisa	 )
*/					

	IF lTipoRet
		IF f_Opcoes(@MvPar,cTitulo,aSit,MvParDef,12,49,l1Elem)  // Chama funcao f_Opcoes
			&MvRet := mvpar                                                                          // Devolve Resultado
		EndIF
	EndIF

	dbSelectArea(cAlias) 								 // Retorna Alias

Return( IF( lTipoRet , .T. , MvParDef ) )

