#INCLUDE "MATR285.CH"
#INCLUDE "PROTHEUS.CH"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������calc
�������������������������������������������������������������������������Ŀ��
���Fun��o    � MATR285  � Autor � Marcos V. Ferreira    � Data � 20/06/06 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Listagem dos itens inventariados                           ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Generico                                                   ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function TFTR285()

Local oReport

If TRepInUse()
	//������������������������������������������������������������������������Ŀ
	//�Interface de impressao                                                  �
	//��������������������������������������������������������������������������
	oReport:= ReportDef()
	oReport:PrintDialog()
EndIf

Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �ReportDef � Autor �Marcos V. Ferreira     � Data �20/06/06  ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �A funcao estatica ReportDef devera ser criada para todos os ���
���          �relatorios que poderao ser agendados pelo usuario.          ���
�������������������������������������������������������������������������Ĵ��
���Parametros�Nenhum                                                      ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � MATR285			                                          ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function ReportDef()

Local aOrdem    := {OemToAnsi(STR0005),OemToAnsi(STR0006),OemToAnsi(STR0007),OemToAnsi(STR0008),OemToAnsi(STR0009)}		//' Por Codigo    '###' Por Tipo      '###' Por Grupo   '###' Por Descricao '###' Por Local    '
Local cPictQFim := PesqPict("SB2",'B2_QFIM' )
Local cPictQtd  := PesqPict("SB7",'B7_QUANT')
Local cPictVFim := PesqPict("SB2",'B2_VFIM1')
Local cTamQFim  := TamSX3('B2_QFIM' )[1]
Local cTamQtd   := TamSX3('B7_QUANT')[1]
Local cTamVFim  := TamSX3('B2_VFIM1')[1]
Local cAliasSB1 := GetNextAlias()    
Local cAliasSB2 := cAliasSB1
Local cAliasSB7 := cAliasSB1
Local oSection1
//������������������������������������������������������������������������Ŀ
//�Criacao do componente de impressao                                      �
//�                                                                        �
//�TReport():New                                                           �
//�ExpC1 : Nome do relatorio                                               �
//�ExpC2 : Titulo                                                          �
//�ExpC3 : Pergunte                                                        �
//�ExpB4 : Bloco de codigo que sera executado na confirmacao da impressao  �
//�ExpC5 : Descricao                                                       �
//�                                                                        �
//��������������������������������������������������������������������������
oReport:= TReport():New("MATR285",STR0001,"MTR285", {|oReport| ReportPrint(oReport,aOrdem,cAliasSB1,cAliasSB2,cAliasSB7)},STR0002+" "+STR0003+" "+STR0004)
oReport:DisableOrientation()
oReport:SetLandscape() //Define a orientacao de pagina do relatorio como paisagem.

//��������������������������������������������������������������Ŀ
//� Verifica as perguntas selecionadas                           �
//����������������������������������������������������������������
//��������������������������������������������������������������Ŀ
//� Variaveis utilizadas para parametros                         �
//� mv_par01             // Produto de                           �
//� mv_par02             // Produto ate                          �
//� mv_par03             // Data de Selecao                      �
//� mv_par04             // De  Tipo                             �
//� mv_par05             // Ate Tipo                             �
//� mv_par06             // De  Local                            �
//� mv_par07             // Ate Local                            �
//� mv_par08             // De  Grupo                            �
//� mv_par09             // Ate Grupo                            �
//� mv_par10             // Qual Moeda (1 a 5)                   �
//� mv_par11             // Imprime Lote/Sub-Lote                �
//� mv_par12             // Custo Medio Atual/Ultimo Fechamento  �
//� mv_par13             // Imprime Localizacao ?                �
//����������������������������������������������������������������
Pergunte(oReport:uParam,.F.)

//������������������������������������������������������������������������Ŀ
//�Criacao da secao utilizada pelo relatorio                               �
//�                                                                        �
//�TRSection():New                                                         �
//�ExpO1 : Objeto TReport que a secao pertence                             �
//�ExpC2 : Descricao da secao                                              �
//�ExpA3 : Array com as tabelas utilizadas pela secao. A primeira tabela   �
//�        sera considerada como principal para a secao.                   �
//�ExpA4 : Array com as Ordens do relatorio                                �
//�ExpL5 : Carrega campos do SX3 como celulas                              �
//�        Default : False                                                 �
//�ExpL6 : Carrega ordens do Sindex                                        �
//�        Default : False                                                 �
//��������������������������������������������������������������������������

//��������������������������������������������������������������Ŀ
//� Criacao da Sessao 1                                          �
//����������������������������������������������������������������
oSection1:= TRSection():New(oReport,STR0050,{"SB1","SB7","SB2"},aOrdem) // "Lancamentos para Inventario"
oSection1:SetTotalInLine(.F.)
oSection1:SetNoFilter("SB7")
oSection1:SetNoFilter("SB2")

TRCell():New(oSection1,'B1_CODITE'	,cAliasSB1	,STR0027				,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,'B1_COD'		,cAliasSB1	,STR0027				,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,'B1_DESC'	,cAliasSB1	,STR0028				,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,'B7_LOTECTL'	,cAliasSB7	,STR0029				,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,'B7_NUMLOTE'	,cAliasSB7	,STR0030+CRLF+STR0029	,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,'B7_LOCALIZ'	,cAliasSB7	,STR0031				,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,'B7_NUMSERI'	,cAliasSB7	,STR0032				,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,'B1_TIPO'	,cAliasSB1	,STR0033				,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,'B1_GRUPO'	,cAliasSB1	,STR0034				,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,'B1_UM'		,cAliasSB1	,STR0035				,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,'B2_LOCAL'	,cAliasSB2	,STR0036				,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,'B7_DOC'		,cAliasSB7	,STR0037				,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,'B7_QUANT'	,cAliasSB7	,STR0038+CRLF+STR0039	,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/,,,"RIGHT")
TRCell():New(oSection1,'QUANTDATA'	,'   '		,STR0040+CRLF+STR0041	,cPictQFim	,cTamQFim	,/*lPixel*/,/*{|| code-block de impressao }*/,,,"RIGHT")
TRCell():New(oSection1,'DIFQUANT'	,'   '		,STR0042+CRLF+STR0043	,cPictQtd	,cTamQtd	,/*lPixel*/,/*{|| code-block de impressao }*/,,,"RIGHT")
TRCell():New(oSection1,'DIFVALOR'	,'   '		,STR0042+CRLF+STR0044	,cPictVFim	,cTamVFim	,/*lPixel*/,/*{|| code-block de impressao }*/,,,"RIGHT")

oSection1:SetHeaderPage()
oSection1:SetTotalText(STR0049) // "T o t a l  G e r a l :"

Return(oReport)

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �ReportPrint � Autor �Marcos V. Ferreira   � Data �20/06/06  ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �A funcao estatica ReportPrint devera ser criada para todos  ���
���          �os relatorios que poderao ser agendados pelo usuario.       ���
�������������������������������������������������������������������������Ĵ��
���Retorno   �Nenhum                                                      ���
�������������������������������������������������������������������������Ĵ��
���Parametros�ExpO1: Objeto Report do Relatorio                           ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � MATR285			                                          ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function ReportPrint(oReport,aOrdem,cAliasSB1,cAliasSB2,cAliasSB7)

Local oSection1	:= oReport:Section(1)
Local nOrdem   	:= oSection1:GetOrder()
local oSaldoWMS	:= Nil
Local cSeek    	:= ''
Local cCompara 	:= ''
Local cLocaliz 	:= ''
Local cNumSeri 	:= ''
Local cLoteCtl 	:= ''
Local cNumLote 	:= ''
Local cProduto 	:= ''
Local cLocal   	:= ''
Local cTipo     := ''
Local cGrupo    := ''
Local cWhere   	:= ''
Local cOrderBy 	:= ''
//Local cFiltro  	:= ''
//Local cNomArq	:= ''
//Local cOrdem	:= ''
Local nSB7Cnt  	:= 0
Local nTotal   	:= 0
Local nX       	:= 0
Local nTotRegs  := 0
Local nCellTot	:= 11
Local aSaldo   	:= {}
Local aSalQtd  	:= {}
Local aCM      	:= {}
Local lImprime  := .T.
Local lContagem	:= SuperGetMv('MV_CONTINV',.F.,.F.)
Local lVeic		:= Upper(GetMV("MV_VEICULO"))=="S"
Local lWmsNew   := SuperGetMV("MV_WMSNEW",.F.,.F.)
Local oBreak
Local oBreak01
Local lFirst := .F.

//��������������������������������������������������������������Ŀ
//� Variaveis utilizadas qdo almoxarifado do CQ                  �
//����������������������������������������������������������������
Local   cLocCQ  := GetMV("MV_CQ")
Private	lLocCQ  :=.T.

//������������������������������������������������������������Ŀ
//� Adiciona a ordem escolhida ao titulo do relatorio          �
//��������������������������������������������������������������
oReport:SetTitle(oReport:Title()+' (' + AllTrim(aOrdem[nOrdem]) + ')')

//��������������������������������������������������������������Ŀ
//� Definicao da linha de SubTotal                               |
//����������������������������������������������������������������  
oBreak01 := TRBreak():New(oSection1,oSection1:Cell("B1_COD"),STR0045,.F.)                          
TRFunction():New(oSection1:Cell('B7_QUANT'	),NIL,"SUM",oBreak01,/*Titulo*/,/*cPicture*/,/*uFormula*/,.F.,.F.)  
TRFunction():New(oSection1:Cell('QUANTDATA'	),NIL,"SUM",oBreak01,/*Titulo*/,/*cPicture*/,/*uFormula*/,.F.,.F.)
TRFunction():New(oSection1:Cell('DIFQUANT'	),NIL,"SUM",oBreak01,/*Titulo*/,/*cPicture*/,/*uFormula*/,.F.,.F.)  
TRFunction():New(oSection1:Cell('DIFVALOR'	),NIL,"SUM",oBreak01,/*Titulo*/,/*cPicture*/,/*uFormula*/,.F.,.F.)  

If nOrdem == 2 .Or. nOrdem == 3 .Or. nOrdem == 5
	If nOrdem == 2
		//-- SubtTotal por Tipo
		oBreak := TRBreak():New(oSection1,oSection1:Cell("B1_TIPO"),STR0046,.F.) //"SubTotal do Tipo : "
	ElseIf nOrdem == 3
		//-- SubtTotal por Grupo
		oBreak := TRBreak():New(oSection1,oSection1:Cell("B1_GRUPO"),STR0047,.F.) //"SubTotal do Grupo : "
	ElseIf nOrdem == 5
		//-- SubtTotal por Armazem
		oBreak := TRBreak():New(oSection1,oSection1:Cell("B2_LOCAL"),STR0048,.F.) //"SubTotal do Armazem : "
	EndIf
	TRFunction():New(oSection1:Cell('B7_QUANT'	),NIL,"SUM",oBreak,/*Titulo*/,/*cPicture*/,/*uFormula*/,.F.,.F.)
	TRFunction():New(oSection1:Cell('QUANTDATA'	),NIL,"SUM",oBreak,/*Titulo*/,/*cPicture*/,/*uFormula*/,.F.,.F.)
	TRFunction():New(oSection1:Cell('DIFQUANT'	),NIL,"SUM",oBreak,/*Titulo*/,/*cPicture*/,/*uFormula*/,.F.,.F.)
	TRFunction():New(oSection1:Cell('DIFVALOR'	),NIL,"SUM",oBreak,/*Titulo*/,/*cPicture*/,/*uFormula*/,.F.,.F.)
EndIf

//��������������������������������������������������������������Ŀ
//� Definicao do Total Geral do Relatorio                        �
//����������������������������������������������������������������
TRFunction():New(oSection1:Cell('B7_QUANT'	),NIL,"SUM",/*oBreak*/,/*Titulo*/,/*cPicture*/,/*uFormula*/,.T.,.F.)
TRFunction():New(oSection1:Cell('QUANTDATA'	),NIL,"SUM",/*oBreak*/,/*Titulo*/,/*cPicture*/,/*uFormula*/,.T.,.F.)
TRFunction():New(oSection1:Cell('DIFQUANT'	),NIL,"SUM",/*oBreak*/,/*Titulo*/,/*cPicture*/,/*uFormula*/,.T.,.F.)
TRFunction():New(oSection1:Cell('DIFVALOR'	),NIL,"SUM",/*oBreak*/,/*Titulo*/,/*cPicture*/,/*uFormula*/,.T.,.F.)

//��������������������������������������������������������������Ŀ
//� Desliga as colunas que nao serao utilizadas no relatorio     �
//����������������������������������������������������������������
If !lVeic
	oSection1:Cell('B1_CODITE'	):Disable()
Else
	oSection1:Cell('B1_COD'		):Disable()
EndIf	

If !(mv_par11 == 1)
	oSection1:Cell('B7_LOTECTL'	):Disable()
	oSection1:Cell('B7_NUMLOTE'	):Disable()
	nCellTot-= 2
EndIf

If !(mv_par13 == 1)
	oSection1:Cell('B7_LOCALIZ'	):Disable()
	oSection1:Cell('B7_NUMSERI'	):Disable()
	nCellTot-= 2
EndIf

dbSelectArea('SB2')
dbSetOrder(1)

dbSelectArea('SB7')
dbSetOrder(1)

dbSelectArea('SB1')
dbSetOrder(1)

nTotRegs += SB2->(LastRec())
nTotRegs += SB7->(LastRec())

//��������������������������������������������������������������Ŀ
//� ORDER BY - Adicional                                         �
//����������������������������������������������������������������
cOrderBy := "%"
If nOrdem == 1 //-- Por Codigo
	If lVeic
		cOrderBy += " B1_FILIAL, B1_CODITE "
	Else
		cOrderBy += " B1_FILIAL, B1_COD , B7_LOTECTL, B7_NUMLOTE, B7_LOCALIZ "
	EndIf	
ElseIf nOrdem == 2 //-- Por Tipo
	cOrderBy += " B1_FILIAL, B1_TIPO, B1_COD " 
ElseIf nOrdem == 3 //-- Por Grupo
	If lVeic
		cOrderBy += " B1_FILIAL, B1_GRUPO, B1_CODITE "
	Else
		cOrderBy += " B1_FILIAL, B1_GRUPO, B1_COD "
	EndIf	
	cOrderBy += ", B2_LOCAL" 
ElseIf nOrdem == 4 //-- Por Descricao
	cOrderBy += "B1_FILIAL, B1_DESC, B1_COD"
ElseIf nOrdem == 5 //-- Por Local
	If lVeic
		cOrderBy += " B1_FILIAL, B2_LOCAL, B1_CODITE"
	Else
		cOrderBy += " B1_FILIAL, B2_LOCAL, B1_COD"
	EndIf	
EndIf
cOrderBy += "%"

//��������������������������������������������������������������Ŀ
//� WHERE - Adicional                                            �
//����������������������������������������������������������������
cWhere := "%"
If lVeic
	cWhere+= "SB1.B1_CODITE	>= '"+mv_par01+"' AND SB1.B1_CODITE <= '"+mv_par02+	"' AND "
Else
	cWhere+= "SB1.B1_COD	>= '"+mv_par01+"' AND SB1.B1_COD	<= '"+mv_par02+	"' AND "
EndIf
    If lContagem
      cWhere+= " SB7.B7_ESCOLHA = 'S' AND "
    EndIf  
cWhere += "%"

//������������������������������������������������������������������������Ŀ
//�Inicio da Query do relatorio                                            �
//��������������������������������������������������������������������������
oSection1:BeginQuery()	

//������������������������������������������������������������������������Ŀ
//�Transforma parametros Range em expressao SQL                            �
//��������������������������������������������������������������������������
MakeSqlExpr(oReport:uParam)

//������������������������������������������������������������������������Ŀ
//�Inicio do Embedded SQL                                                  �
//��������������������������������������������������������������������������
BeginSql Alias cAliasSB1

	SELECT 	SB1.R_E_C_N_O_ SB1REC , SB1.B1_FILIAL, SB1.B1_COD, SB1.B1_LOCPAD, SB1.B1_TIPO, 
	        SB1.B1_GRUPO, SB1.B1_DESC, SB1.B1_UM, SB1.B1_CODITE, SB2.R_E_C_N_O_ SB2REC,
    	    SB2.B2_FILIAL, SB2.B2_COD, SB2.B2_LOCAL, SB2.B2_DINVENT, SB7.R_E_C_N_O_ SB7REC,
        	SB7.B7_FILIAL, SB7.B7_COD, SB7.B7_LOCAL, SB7.B7_DATA,SB7.B7_LOCALIZ,
	        SB7.B7_NUMSERI, SB7.B7_LOTECTL, SB7.B7_NUMLOTE, SB7.B7_DOC, SB7.B7_QUANT,
	        SB7.B7_ESCOLHA, SB7.B7_CONTAGE

	FROM %table:SB1% SB1,%table:SB2% SB2,%table:SB7% SB7

    	WHERE SB1.B1_FILIAL =  %xFilial:SB1%	AND SB1.B1_TIPO  >= %Exp:mv_par04%	AND
    	  SB1.B1_TIPO   <= %Exp:mv_par05%	AND SB1.B1_GRUPO >= %Exp:mv_par08%	AND
    		  SB1.B1_GRUPO  <= %Exp:mv_par09%	AND SB1.%NotDel%					AND
 			  %Exp:cWhere%
		  SB2.B2_FILIAL =  %xFilial:SB2%	AND SB2.B2_COD   =  SB1.B1_COD		AND
		  SB2.B2_LOCAL  =  SB7.B7_LOCAL		AND SB2.%NotDel%					AND
		  SB7.B7_FILIAL =  %xFilial:SB7%	AND SB7.B7_COD   =  SB1.B1_COD		AND
		  SB7.B7_LOCAL  >= %Exp:mv_par06%	AND SB7.B7_LOCAL <= %Exp:mv_par07% 	AND
		  SB7.B7_DATA   =  %Exp:Dtos(mv_par03)% AND SB7.%NotDel%

	ORDER BY %Exp:cOrderBy%

EndSql

oSection1:EndQuery()

//��������������������������������������������������������Ŀ
//� Abertura do Arquivo de Trabalho                        �
//����������������������������������������������������������
dbSelectArea(cAliasSB1)
oReport:SetMeter(nTotRegs)

SB7->(dbSetOrder(1))

//��������������������������������������������������������Ŀ
//� Processamento do Relatorio                             �
//����������������������������������������������������������
oSection1:Init(.F.)
While !oReport:Cancel() .And. !(cAliasSB7)->(Eof())

	oReport:IncMeter()

	If cSeek <> (cAliasSB7)->&(cCompara)

		nTotal   := 0
		nSB7Cnt  := 0
		lImprime := .T.
		cSeek    := xFilial('SB7')+DTOS(mv_par03)+(cAliasSB7)->B7_COD+(cAliasSB7)->B7_LOCAL+(cAliasSB7)->B7_LOCALIZ+(cAliasSB7)->B7_NUMSERI+(cAliasSB7)->B7_LOTECTL+(cAliasSB7)->B7_NUMLOTE
		cCompara := "B7_FILIAL+DTOS(B7_DATA)+B7_COD+B7_LOCAL+B7_LOCALIZ+B7_NUMSERI+B7_LOTECTL+B7_NUMLOTE"
		cProduto := (cAliasSB2)->B2_COD
		cLocal   := (cAliasSB2)->B2_LOCAL
		cLocaliz := (cAliasSB7)->B7_LOCALIZ
		cNumSeri := (cAliasSB7)->B7_NUMSERI
		cLoteCtl := (cAliasSB7)->B7_LOTECTL
		cNumLote := (cAliasSB7)->B7_NUMLOTE
		cTipo    :=	(cAliasSB1)->B1_TIPO
		cGrupo   :=	(cAliasSB1)->B1_GRUPO
		lFirst := .T.

		SB7->(dbSeek(cSeek))
		While !SB7->(Eof()) .And. SB7->&(cCompara) == cSeek  
			If lContagem 
				If SB7->B7_ESCOLHA == "S"
					nTotal += SB7->B7_QUANT
					nSB7Cnt++
				EndIF
			Else
				nTotal += SB7->B7_QUANT
				nSB7Cnt++
			EndIf
			
			SB7->(dbSkip())
			
		EndDo
		
		If nSB7Cnt > 0
			//������������������������������������������������������������������������Ŀ
			//�Verifica a Quantidade Disponivel/Custo Medio                            �
			//��������������������������������������������������������������������������
			If (Localiza(cProduto,.T.) .And. !Empty(cLocaliz+cNumSeri)) .Or. (Rastro(cProduto) .And. !Empty(cLotectl+cNumLote))
				If IntDl(cProduto) .and. lWmsNew
					oSaldoWMS 	:= WMSDTCEstoqueEndereco():New()	
					aSalQtd   := oSaldoWMS:SldPrdData(cProduto,cLocal,mv_par03+1,cLoteCtl,cNumLote,cLocaliz,cNumSeri)
				Else 
					aSalQtd   := CalcEstL(cProduto,cLocal,mv_par03+1,cLoteCtl,cNumLote,cLocaliz,cNumSeri)
				EndIf	
				aSaldo    := CalcEst(cProduto,cLocal,mv_par03+1)
				aSaldo[2] := (aSaldo[2] / aSaldo[1]) * aSalQtd[1]
				aSaldo[3] := (aSaldo[3] / aSaldo[1]) * aSalQtd[1]
				aSaldo[4] := (aSaldo[4] / aSaldo[1]) * aSalQtd[1]
				aSaldo[5] := (aSaldo[5] / aSaldo[1]) * aSalQtd[1]
				aSaldo[6] := (aSaldo[6] / aSaldo[1]) * aSalQtd[1]
				aSaldo[7] := aSalQtd[7]
				aSaldo[1] := aSalQtd[1]
			Else
				If cLocCQ == cLocal
					aSalQtd	  := A340QtdCQ(cProduto,cLocal,mv_par03+1,"")
					aSaldo	  := CalcEst(cProduto,cLocal,mv_par03+1)
					aSaldo[2] := (aSaldo[2] / aSaldo[1]) * aSalQtd[1]
					aSaldo[3] := (aSaldo[3] / aSaldo[1]) * aSalQtd[1]
					aSaldo[4] := (aSaldo[4] / aSaldo[1]) * aSalQtd[1]
					aSaldo[5] := (aSaldo[5] / aSaldo[1]) * aSalQtd[1]
					aSaldo[6] := (aSaldo[6] / aSaldo[1]) * aSalQtd[1]
					aSaldo[7] := aSalQtd[7]
					aSaldo[1] := aSalQtd[1]
				Else
					aSaldo := CalcEst(cProduto,cLocal,mv_par03+1)
				EndIf
			EndIf
			If mv_par12 == 1
				aCM:={}
				If QtdComp(aSaldo[1]) > QtdComp(0)
					For nX:=2 to Len(aSaldo)
						aAdd(aCM,aSaldo[nX]/aSaldo[1])
					Next nX
	          	Else
					aCM := PegaCmAtu(cProduto,cLocal)
	          	EndIf
			Else
	           aCM := PegaCMFim(cProduto,cLocal)
			EndIf
	
			//������������������������������������������������������������������Ŀ
			//� lImprime - Variavel utilizada para verificar se o usuario deseja |
			//| Listar Produto: 1-Com Diferencas / 2-Sem Diferencas / 3-Todos    |                              |
			//��������������������������������������������������������������������
			If nTotal-aSaldo[1] == 0
				If mv_par14 == 1
					lImprime := .F.
					nCellTot-= 1
				EndIf	
			Else 
			    If mv_par14 == 2
				   lImprime := .F.
   					nCellTot-= 1
				EndIf 
			EndIf
		EndIf
	Else
		lFirst := .F.
	EndIF
		
	//��������������������������������������������������������������Ŀ
	//� Impressao do Inventario                                      �
	//����������������������������������������������������������������
	If nSB7Cnt > 0 .AND.(lImprime .Or. mv_par14 == 3)

		If lFirst
			oSection1:Cell('B1_CODITE'	):Show()
			oSection1:Cell('B1_COD'	 	):Show()
			oSection1:Cell('B1_TIPO'	):Show()
			oSection1:Cell('B1_DESC'	):Show()
			oSection1:Cell('B1_GRUPO'	):Show()
			oSection1:Cell('B1_UM'		):Show()
			oSection1:Cell('B2_LOCAL'	):Show()
			oSection1:Cell('B7_LOTECTL'	):Show()
			oSection1:Cell('B7_NUMLOTE'	):Show()
			oSection1:Cell('B7_LOCALIZ'	):Show()
			oSection1:Cell('B7_NUMSERI'	):Show()
			oSection1:Cell('QUANTDATA'	):Hide()
			oSection1:Cell('DIFQUANT'	):Hide()
			oSection1:Cell('DIFVALOR'	):Hide()
			oSection1:Cell('QUANTDATA'	):SetValue(aSaldo[1])
			oSection1:Cell('DIFQUANT'	):SetValue(nTotal-aSaldo[1])
			oSection1:Cell('DIFVALOR'	):SetValue((nTotal-aSaldo[1])*aCM[mv_par10])
		Else
			oSection1:Cell('B1_CODITE'	):Hide()
			oSection1:Cell('B1_COD'		):Hide()
			oSection1:Cell('B1_TIPO'  	):Hide()
			oSection1:Cell('B1_DESC'  	):Hide()
			oSection1:Cell('B1_GRUPO' 	):Hide()
			oSection1:Cell('B1_UM'    	):Hide()
			oSection1:Cell('B2_LOCAL' 	):Hide()
			oSection1:Cell('B7_LOTECTL'	):Hide()
			oSection1:Cell('B7_NUMLOTE'	):Hide()
			oSection1:Cell('B7_LOCALIZ'	):Hide()
			oSection1:Cell('B7_NUMSERI'	):Hide()
			oSection1:Cell('QUANTDATA'	):SetValue(0)
			oSection1:Cell('DIFQUANT'	):SetValue(0)
			oSection1:Cell('DIFVALOR'	):SetValue(0)
		EndIF
		
		If nSB7Cnt >= 1
			oSection1:Cell('QUANTDATA'	):Show()
			oSection1:Cell('DIFQUANT'	):Show()
			oSection1:Cell('DIFVALOR'	):Show()					
		EndIf
		
		oSection1:PrintLine()
				
	EndIf
	
	(cAliasSB7)->(dbskip())

EndDo

//oSection1:PrintLine()
oSection1:Finish()

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � C285IMP  � Autor � Rodrigo de A. Sartorio� Data � 12.12.95 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Chamada do Relatorio                                       ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � MATR285                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������*/
Static Function C285Imp(aOrd,lEnd,WnRel,cString,titulo,Tamanho)

//��������������������������������������������������������������Ŀ
//� Variaveis locais exclusivas deste programa                   �
//����������������������������������������������������������������
Local oSaldoWMS := Nil
Local nSB7Cnt  := 0
Local i		   := 0
Local nTotal   := 0
Local nTotVal  := 0
Local nSubVal  := 0
Local nCntImpr := 0
Local cAnt     := '',cSeek:='',cCompara :='',cLocaliz:='',cNumSeri:='',cLoteCtl:='',cNumLote:=''
Local cRodaTxt := STR0012 // 'PRODUTO(S)'
Local aSaldo   := {}
Local aSalQtd  := {}
Local aCM      := {}
Local lQuery   := .F.
Local cQuery   := ""
Local cQueryB1 := ""
Local aStruSB1 := {}
Local aStruSB2 := {}
Local aStruSB7 := {}
Local aRegInv  := {}
Local cAliasSB1:= "SB1"
Local cAliasSB2:= "SB2"
Local cAliasSB7:= "SB7"
Local cProduto := ""
Local cLocal   := ""
Local lFirst   := .T.
Local nX       := 0
Local lImprime := .T.
Local lContagem:= SuperGetMv('MV_CONTINV',.F.,.F.)
Local lWmsNew   := SuperGetMV("MV_WMSNEW",.F.,.F.)
Local lB5CtrWms := .F.

//��������������������������������������������������������������Ŀ
//� Variaveis tipo Local para SIGAVEI, SIGAPEC e SIGAOFI         �
//����������������������������������������������������������������
Local cNomArq	:= ""
Local cKey		:= ""
//��������������������������������������������������������������Ŀ
//� Variaveis utilizadas qdo almoxarifado do CQ                  �
//����������������������������������������������������������������
Local	cLocCQ	:= GetMV("MV_CQ")
Private	lLocCQ	:=.T.

//��������������������������������������������������������������Ŀ
//� Variaveis privadas exclusivas deste programa                 �
//����������������������������������������������������������������
Private cCondicao := '!Eof()'

//��������������������������������������������������������������Ŀ
//� Contadores de linha e pagina                                 �
//����������������������������������������������������������������
Private Li    := 80
Private m_Pag := 1

//�������������������������������������������������������������������Ŀ
//� Inicializa os codigos de caracter Comprimido/Normal da impressora �
//���������������������������������������������������������������������
nTipo := If(aReturn[4]==1,15,18)

//������������������������������������������������������������Ŀ
//� Adiciona a ordem escolhida ao titulo do relatorio          �
//��������������������������������������������������������������
If Type('NewHead') # 'U'
	NewHead += ' (' + AllTrim(aOrd[aReturn[8]]) + ')'
Else
	Titulo += ' (' + AllTrim(aOrd[aReturn[8]]) + ')'
EndIf

//��������������������������������������������������������������Ŀ
//� Monta os Cabecalhos                                          �
//����������������������������������������������������������������
If mv_par11 == 1
	If mv_par13 == 1
        Cabec1 := STR0023 // 'CODIGO          DESCRICAO                LOTE       SUB    LOCALIZACAO     NUMERO DE SERIE      TP GRP  UM AL DOCUMENTO            QUANTIDADE         QTD NA DATA   _____________DIFERENCA______________'
        Cabec2 := STR0024 // '                                                    LOTE                                                                         INVENTARIADA       DO INVENTARIO          QUANTIDADE              VALOR'
        //--                  123456789012345 123456789012345678901234 1234567890 123456 123456789012345 12345678901234567890 12 1234 12 12 123456789012 999.999.999.999,99  999.999.999.999,99  999.999.999.999,99 999.999.999.999,99
        //--                  0         1         2         3         4         5         6         7         8         9        10        11        12        13        14        15        16        17        18        19        20
        //--                  012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
	Else
        Cabec1 := STR0013 // 'CODIGO          DESCRICAO                LOTE       SUB    TP GRP  UM AL DOCUMENTO            QUANTIDADE         QTD NA DATA   _____________DIFERENCA______________'
        Cabec2 := STR0014 // '                                                    LOTE                                    INVENTARIADA       DO INVENTARIO          QUANTIDADE              VALOR'
        //--                  123456789012345 123456789012345678901234 1234567890 123456 12 1234 12 12 123456789012 999.999.999.999,99  999.999.999.999,99  999.999.999.999,99 999.999.999.999,99
        //--                  0         1         2         3         4         5         6         7         8         9        10        11        12        13        14        15        16   
        //--                  0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012
	EndIf	
Else
	If mv_par13 == 1
        Cabec1 := STR0025 // 'CODIGO          DESCRICAO                LOCALIZACAO     NUMERO DE SERIE      TP GRP  UM AL DOCUMENTO            QUANTIDADE         QTD NA DATA  _______________DIFERENCA_____________'
        Cabec2 := STR0026 // '                                                                                                               INVENTARIADA       DO INVENTARIO          QUANTIDADE              VALOR'
        //--                  123456789012345 123456789012345678901234 123456789012345 12345678901234567890 12 1234 12 12 123456789012 999.999.999.999,99  999.999.999.999,99  999.999.999.999,99 999.999.999.999,99
        //--                  0         1         2         3         4         5         6         7         8         9        10        11        12        13        14       15        16        17        18
        //--                  01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456780123456789012345678901234567890123456789012
	Else
        Cabec1 := STR0021 // 'CODIGO          DESCRICAO                TP GRP  UM AL DOCUMENTO            QUANTIDADE         QTD NA DATA  _______________DIFERENCA_____________'
        Cabec2 := STR0022 // '                                                                          INVENTARIADA       DO INVENTARIO          QUANTIDADE              VALOR'
        //--                  123456789012345 123456789012345678901234 12 1234 12 12 123456789012 999.999.999.999,99  999.999.999.999,99  999.999.999.999,99 999.999.999.999,99
        //--                  0         1         2         3         4         5         6         7         8         9        10        11        12        13        14
        //--                  0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678012345
	EndIf
EndIf
If lVEIC
   Cabec1 := substr(Cabec1,1,aSB1Cod[1]) + SPACE(nCOL1) + substr(Cabec1,aSB1Cod[1]+1)
   Cabec2 := substr(Cabec2,1,aSB1Cod[1]) + SPACE(nCOL1) + substr(Cabec2,aSB1Cod[1]+1)
EndIf
//��������������������������������������������������������������Ŀ
//� Inicializa os Arquivos e Ordens a serem utilizados           �
//����������������������������������������������������������������
dbSelectArea('SB2')
dbSetOrder(1)

dbSelectArea('SB7')
dbSetOrder(1)

dbSelectArea('SB1')
SetRegua(LastRec())

If aReturn[8] == 2
	dbSetOrder(2) //-- Tipo
ElseIf aReturn[8] == 3
	If lVEIC
		dbSetOrder(7) //--  B1_FILIAL+B1_GRUPO+B1_CODITE
	Else
		dbSetOrder(4) //-- Grupo
	EndIf	
ElseIf aReturn[8] == 4
	dbSetOrder(3) //-- Descricao
ElseIf aReturn[8] == 5
	If lVEIC
		cKey    := ' B1_FILIAL, B1_LOCPAD, B1_CODITE'
	Else
		cKey    := ' B1_FILIAL, B1_LOCPAD, B1_COD'
	EndIf	
	cKey    := Upper(cKey)
Else
	If lVEIC
		cKey    := ' B1_FILIAL, B1_CODITE'
		cKey    := Upper(cKey)
	Else
	dbSetOrder(1) //-- Codigo
	EndIf	
EndIf

lQuery 	  := .T.
aStruSB1  := SB1->(dbStruct())
aStruSB2  := SB2->(dbStruct())
aStruSB7  := SB7->(dbStruct())

cAliasSB1 := "R285IMP"
cAliasSB2 := "R285IMP"
cAliasSB7 := "R285IMP"

    If Empty(aReturn[7])
	cQuery    := "SELECT "
	cQuery    += "SB1.R_E_C_N_O_ SB1REC, "
	cQuery    += "SB1.B1_FILIAL, SB1.B1_COD, SB1.B1_LOCPAD, SB1.B1_TIPO, SB1.B1_GRUPO, SB1.B1_DESC, SB1.B1_UM , "
	If lVEIC
		cQuery    += "SB1.B1_CODITE , "
	EndIf
    Else
	cQueryB1    += "SB1.B1_FILIAL, SB1.B1_COD, SB1.B1_LOCPAD, SB1.B1_TIPO, SB1.B1_GRUPO, SB1.B1_DESC, SB1.B1_UM , "
	If lVEIC
		cQueryB1+= "SB1.B1_CODITE , "
	EndIf
    	cQuery	  := "SELECT "
	cQuery    += "SB1.R_E_C_N_O_ SB1REC, "
        //Adiciona os campos do filtro na Query
    	cQuery    += cQueryB1 + Atf285QryFil("SB1",cQueryB1,aReturn[7])
    EndIf	
cQuery    += "SB2.R_E_C_N_O_ SB2REC, "
cQuery    += "SB2.B2_FILIAL, SB2.B2_COD, SB2.B2_LOCAL, SB2.B2_DINVENT, "
cQuery    += "SB7.R_E_C_N_O_ SB7REC, "
cQuery    += "SB7.B7_FILIAL, SB7.B7_COD, SB7.B7_LOCAL, SB7.B7_DATA, SB7.B7_LOCALIZ, SB7.B7_NUMSERI, SB7.B7_LOTECTL, SB7.B7_NUMLOTE, SB7.B7_DOC, SB7.B7_QUANT "
If lContagem
	cQuery += " ,SB7.B7_ESCOLHA ,SB7.B7_CONTAGE " 				
EndIf
cQuery    += "FROM "
cQuery    += RetSqlName("SB1")+" SB1, "
cQuery    += RetSqlName("SB2")+" SB2, "
cQuery    += RetSqlName("SB7")+" SB7  "

cQuery    += "WHERE "
cQuery    += "SB1.B1_FILIAL = '"+xFilial("SB1")+"' And "

cQuery += "SB1.B1_TIPO  >= '"+mv_par04+"' And SB1.B1_TIPO  <= '"+mv_par05+"' And "
cQuery += "SB1.B1_GRUPO >= '"+mv_par08+"' And SB1.B1_GRUPO <= '"+mv_par09+"' And "

If aReturn[8] == 5
	cQuery += "SB1.B1_LOCPAD>= '"+mv_par06+"' And SB1.B1_LOCPAD<= '"+mv_par07+"' And "
EndIf

If lVEIC
	cQuery += "SB1.B1_CODITE >= '"+mv_par01+"' And SB1.B1_CODITE <= '"+mv_par02+"' And "
Else
	cQuery += "SB1.B1_COD    >= '"+mv_par01+"' And SB1.B1_COD   <= '"+mv_par02+"' And "
EndIf			
cQuery    += "SB1.D_E_L_E_T_ = ' ' And "

cQuery    += "SB2.B2_FILIAL = '"+xFilial("SB2")+"' And "
cQuery    += "SB2.B2_COD = SB1.B1_COD And "
cQuery    += "SB2.B2_LOCAL = SB7.B7_LOCAL And "
cQuery    += "SB2.D_E_L_E_T_ = ' ' And "
cQuery    += "SB7.B7_FILIAL = '"+xFilial("SB7")+"' And "
cQuery    += "SB7.B7_COD = SB1.B1_COD And "
cQuery    += "SB7.B7_LOCAL >= '"+mv_par06+"' And SB7.B7_LOCAL <= '"+mv_par07+"' And "
cQuery    += "SB7.B7_DATA   = '"+DtoS(mv_par03)+"' And "
cQuery    += "SB7.D_E_L_E_T_ = ' ' "
If lContagem
	cQuery += " AND SB7.B7_ESCOLHA = 'S' " 				
EndIf

If lVEIC
	If aReturn[8] == 1 // codite
		cQuery    += "ORDER BY " +	cKey // B1_FILIAL , B1_CODITE
	ElseIf aReturn[8] == 5 // local
		cQuery    += "ORDER BY " + cKey // B1_FILIAL, B1_LOCPAD, B1_CODITE
	Else
		cQuery    += "ORDER BY "+SqlOrder(SB1->(IndexKey()))
	EndIf	
Else
	If aReturn[8] == 5 // local
		cQuery    += "ORDER BY " + cKey // B1_FILIAL, B1_LOCPAD, B1_COD
	Else	
		cQuery    += "ORDER BY "+SqlOrder(SB1->(IndexKey()))
		cQuery		+= ",B7_LOTECTL,B7_NUMLOTE,B7_LOCALIZ"
	EndIf	
EndIf			

cQuery    := ChangeQuery(cQuery)

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSB1,.T.,.T.)

For nX := 1 To Len(aStruSB1)
	If ( aStruSB1[nX][2] <> "C" ) 
		TcSetField(cAliasSB1,aStruSB1[nX][1],aStruSB1[nX][2],aStruSB1[nX][3],aStruSB1[nX][4])
	EndIf
Next nX

For nX := 1 To Len(aStruSB2)
	If ( aStruSB2[nX][2] <> "C" ) 
		TcSetField(cAliasSB2,aStruSB2[nX][1],aStruSB2[nX][2],aStruSB2[nX][3],aStruSB2[nX][4])
	EndIf
Next nX

For nX := 1 To Len(aStruSB7)
	If ( aStruSB7[nX][2] <> "C" ) 
		TcSetField(cAliasSB7,aStruSB7[nX][1],aStruSB7[nX][2],aStruSB7[nX][3],aStruSB7[nX][4])
	EndIf
Next nX
cAnt:= ""
If aReturn[8] == 2
	cAnt	:= (cAliasSB1)->B1_TIPO
ElseIf aReturn[8] == 3
	cAnt	:= (cAliasSB1)->B1_GRUPO
EndIf


nTotVal := 0
nSubVal := 0

While &cCondicao

	If lWmsNew
		lB5CtrWms:= .F.
		DbSelectArea("SB5")
		DbSetOrder(1)
		If SB5->(MsSeek (xFilial("SB5") + (cAliasSB1)->B1_COD)) 
			If SB5->B5_CTRWMS == "1"
				lB5CtrWms := .T.
			EndIf
		EndIf
	EndIf

    If !Empty(aReturn[7]) .And. !&(aReturn[7])
       (cAliasSB1)->(dbSkip())
		Loop
	EndIf

	If lFirst  
		If aReturn[8] == 2 .and. cAnt <> (cAliasSB1)->B1_TIPO
			cAnt := (cAliasSB1)->B1_TIPO
			lFirst := .F.
		ElseIf aReturn[8] == 3 .and. cAnt <> (cAliasSB1)->B1_GRUPO
			cAnt := (cAliasSB1)->B1_GRUPO
			lFirst := .F.
		EndIf
	EndIf	
	If lEnd
		@ pRow()+1, 000 PSAY STR0016 // 'CANCELADO PELO OPERADOR'
		Exit
	EndIF
	
	IncRegua()
		cProduto := (cAliasSB2)->B2_COD
		cLocal   := (cAliasSB2)->B2_LOCAL

		While !(cAliasSB7)->(Eof()) .And. (cAliasSB7)->(B7_FILIAL+DtoS(B7_DATA)+B7_COD+B7_LOCAL) == xFilial('SB7')+DtoS(mv_par03)+cProduto+cLocal
				
			nTotal   := 0
			nSB7Cnt  := 0
			aRegInv  := {}
			cSeek    := xFilial('SB7')+DtoS(mv_par03)+(cAliasSB7)->B7_COD+(cAliasSB7)->B7_LOCAL+(cAliasSB7)->B7_LOCALIZ+(cAliasSB7)->B7_NUMSERI+(cAliasSB7)->B7_LOTECTL+(cAliasSB7)->B7_NUMLOTE
			cCompara := "B7_FILIAL+DTOS(B7_DATA)+B7_COD+B7_LOCAL+B7_LOCALIZ+B7_NUMSERI+B7_LOTECTL+B7_NUMLOTE"
			cLocaliz := (cAliasSB7)->B7_LOCALIZ
			cNumSeri := (cAliasSB7)->B7_NUMSERI
			cLoteCtl := (cAliasSB7)->B7_LOTECTL
			cNumLote := (cAliasSB7)->B7_NUMLOTE
			lImprime := .T.
			
			While !(cAliasSB7)->(Eof()) .And. cSeek == (cAliasSB7)->&(cCompara)
				
				nSB7Cnt++
				
				aAdd(aRegInv,{	Left(cProduto,15)					,; //B2_COD
								Left((cAliasSB1)->B1_DESC,30)		,; //B1_DESC
								Left((cAliasSB7)->B7_LOTECTL,10)	,; //B7_LOTECTL
								Left((cAliasSB7)->B7_NUMLOTE,06)	,; //B7_NUMLOTE
								Left((cAliasSB7)->B7_LOCALIZ,15)	,; //B7_LOCALIZ
								Left((cAliasSB7)->B7_NUMSERI,20)	,; //B7_NUMSERI
								Left((cAliasSB1)->B1_TIPO ,02)		,; //B1_TIPO
								Left((cAliasSB1)->B1_GRUPO,04)		,; //B1_GRUPO
								Left((cAliasSB1)->B1_UM   ,02)		,; //B1_UM
								Left((cAliasSB2)->B2_LOCAL,02)		,; //B2_LOCAL
								(cAliasSB7)->B7_DOC					,; //B7_DOC
								Transform((cAliasSB7)->B7_QUANT,(cAliasSB7)->(PesqPict("SB7",'B7_QUANT', 15)) ) } ) //B7_QUANT

				nTotal += (cAliasSB7)->B7_QUANT
				
				(cAliasSB7)->(dbSkip())
			EndDo

			If (Localiza(cProduto,.T.) .And. !Empty(cLocaliz+cNumSeri)) .Or. (Rastro(cProduto) .And. !Empty(cLotectl+cNumLote))
				If lB5CtrWms
					aSalQtd[1]:= GetSldEnd(cProduto,cLocal,cLocaliz,cLoteCtl,cNumLote,cNumSeri)[1,6] 
				Else
					If IntDl(cProduto) .and. lWmsNew
						oSaldoWMS 	:= WMSDTCEstoqueEndereco():New()	
						aSalQtd   := oSaldoWMS:SldPrdData(cProduto,cLocal,mv_par03+1,cLoteCtl,cNumLote,cLocaliz,cNumSeri)
					Else 
						aSalQtd   := CalcEstL(cProduto,cLocal,mv_par03+1,cLoteCtl,cNumLote,cLocaliz,cNumSeri)
					EndIf
				EndIf
				aSaldo    := CalcEst(cProduto,cLocal,mv_par03+1)
				aSaldo[2] := (aSaldo[2] / aSaldo[1]) * aSalQtd[1]
				aSaldo[3] := (aSaldo[3] / aSaldo[1]) * aSalQtd[1]
				aSaldo[4] := (aSaldo[4] / aSaldo[1]) * aSalQtd[1]
				aSaldo[5] := (aSaldo[5] / aSaldo[1]) * aSalQtd[1]
				aSaldo[6] := (aSaldo[6] / aSaldo[1]) * aSalQtd[1]
				aSaldo[7] := aSalQtd[7]
				aSaldo[1] := aSalQtd[1]
			Else
				If cLocCQ == cLocal
					aSalQtd	  := A340QtdCQ(cProduto,cLocal,mv_par03+1,"")
					aSaldo	  := CalcEst(cProduto,cLocal,mv_par03+1)
					aSaldo[2] := (aSaldo[2] / aSaldo[1]) * aSalQtd[1]
					aSaldo[3] := (aSaldo[3] / aSaldo[1]) * aSalQtd[1]
					aSaldo[4] := (aSaldo[4] / aSaldo[1]) * aSalQtd[1]
					aSaldo[5] := (aSaldo[5] / aSaldo[1]) * aSalQtd[1]
					aSaldo[6] := (aSaldo[6] / aSaldo[1]) * aSalQtd[1]
					aSaldo[7] := aSalQtd[7]
					aSaldo[1] := aSalQtd[1]
				Else
					aSaldo := CalcEst(cProduto,cLocal,mv_par03+1)
				EndIf
			EndIf
			
			//��������������������������������������������������������������Ŀ
			//� Validacao do Total da Diferenca X Saldo Disponivel           �
			//����������������������������������������������������������������
			If nTotal-aSaldo[1] == 0
				If mv_par14 == 1
					lImprime := .F.
				EndIf	
			Else 
			    If mv_par14 == 2
				   lImprime := .F.
				EndIf 
			EndIf
			
			//��������������������������������������������������������������Ŀ
			//� Impressao do Inventario                                      �
			//����������������������������������������������������������������
			If lImprime .Or. mv_par14 == 3
						
				For nX:=1 to Len(aRegInv)
					
					If Li > 55
						Cabec(titulo,cabec1,cabec2,wnrel,Tamanho,nTipo)
					EndIf
					
					If nX == 1
						@ Li, 000 PSAY aRegInv[nX,01] //B1_CODITE
						@ Li, 016 + nCOL1 PSAY aRegInv[nX,02] //B1_COD
					EndIf
	
					If mv_par11 == 1  
						@ Li, 047 + nCOL1 PSAY aRegInv[nX,03] //B7_LOTECTL
						@ Li, 058 + nCOL1 PSAY aRegInv[nX,04] //B7_NUMLOTE
						If mv_par13 == 1                            
							@ Li, 065 + nCOL1 PSAY aRegInv[nX,05] //B7_LOCALIZ
							@ Li, 081 + nCOL1 PSAY aRegInv[nX,06] //B7_NUMSERI
						EndIf
						If nX == 1
							@ Li,If(mv_par13==1,102,065) + nCOL1 PSAY aRegInv[nX,07] //B1_TIPO
							@ Li,If(mv_par13==1,105,068) + nCOL1 PSAY aRegInv[nX,08] //B1_GRUPO
							@ Li,If(mv_par13==1,109,073) + nCOL1 PSAY aRegInv[nX,09] //B1_UM
							@ Li,If(mv_par13==1,113,076) + nCOL1 PSAY aRegInv[nX,10] //B2_LOCAL 
						EndIf
						@ Li,If(mv_par13==1,116,079) + nCOL1 PSAY aRegInv[nX,11] //B7_DOC
						@ Li,If(mv_par13==1,129,092) + nCOL1 PSAY aRegInv[nX,12] //B7_QUANT
					Else
						If mv_par13 == 1
							@ Li, 047 + nCOL1 PSAY aRegInv[nX,05] //B7_LOCALIZ
							@ Li, 063 + nCOL1 PSAY aRegInv[nX,06] //B7_NUMSERI
						EndIf
						If nX == 1							
							@ Li,If(mv_par13==1,084,047) + nCOL1 PSAY aRegInv[nX,07] //B1_TIPO
							@ Li,If(mv_par13==1,087,050) + nCOL1 PSAY aRegInv[nX,08] //B1_GRUPO
							@ Li,If(mv_par13==1,092,054) + nCOL1 PSAY aRegInv[nX,09] //B1_UM
							@ Li,If(mv_par13==1,095,057) + nCOL1 PSAY aRegInv[nX,10] //B2_LOCAL 							
						EndIf
						@ Li,If(mv_par13==1,098,061) + nCOL1 PSAY aRegInv[nX,11] //B7_DOC
						@ Li,If(mv_par13==1,111,074) + nCOL1 PSAY aRegInv[nX,12] //B7_QUANT						
					EndIf
	
					Li++
			
				Next nX
					
				//�������������������������������������������������������Ŀ
				//� Adiciona 1 ao contador de registros impressos         �
				//���������������������������������������������������������
				nCntImpr++
			
				If nSB7Cnt == 1
					Li--
				ElseIf nSB7Cnt > 1
					If mv_par11 == 1
						@ Li,If(mv_par13==1,106,069) + nCOL1 PSAY STR0017 // 'TOTAL .................'
						@ Li,If(mv_par13==1,129,092) + nCOL1 PSAY Transform(nTotal, (cAliasSB7)->(PesqPict("SB7",'B7_QUANT', 15)))
					Else
						@ Li,If(mv_par13==1,088,050) + nCOL1 PSAY STR0017 // 'TOTAL .................'
						@ Li,If(mv_par13==1,111,074) + nCOL1 PSAY Transform(nTotal, (cAliasSB7)->(PesqPict("SB7",'B7_QUANT', 15)))
					EndIf
				EndIf

				If mv_par11 == 1
					@ Li,If(mv_par13==1,149,112) + nCOL1 PSAY Transform(aSaldo[1], (cAliasSB2)->(PesqPict("SB2",'B2_QFIM', 15)))
				Else
					@ Li,If(mv_par13==1,131,094) + nCOL1 PSAY Transform(aSaldo[1], (cAliasSB2)->(PesqPict("SB2",'B2_QFIM', 15)))
				EndIf
				
				If nSB7Cnt > 0
					If mv_par12 == 1
						aCM:={}
						If QtdComp(aSaldo[1]) > QtdComp(0)
							For i:=2 to Len(aSaldo)
								AADD(aCM,aSaldo[i]/aSaldo[1])
							Next i
        	    		Else
							aCm := PegaCmAtu(cProduto,cLocal)
	            		EndIf
                	Else
            	    	aCM := PegaCMFim(cProduto,cLocal)
					EndIf
		            dbSelectArea(cAliasSB7)

					If mv_par11 == 1 
						@ Li,If(mv_par13==1,169,132) + nCOL1 PSAY Transform(nTotal-aSaldo[1], (cAliasSB7)->(PesqPict("SB7",'B7_QUANT', 15)))
						@ Li,If(mv_par13==1,188,151) + nCOL1 PSAY Transform((nTotal-aSaldo[1])*aCM[mv_par10], (cAliasSB2)->(PesqPict("SB2",'B2_VFIM1', 15)))
					Else
						@ Li,If(mv_par13==1,152,114) + nCOL1 PSAY Transform(nTotal-aSaldo[1], (cAliasSB7)->(PesqPict("SB7",'B7_QUANT', 15)))
						@ Li,If(mv_par13==1,171,133) + nCOL1 PSAY Transform((nTotal-aSaldo[1])*aCM[mv_par10], (cAliasSB2)->(PesqPict("SB2",'B2_VFIM1', 15)))
					EndIf
					nTotVal += (nTotal-aSaldo[1])*aCM[mv_par10]
					nSubVal += (nTotal-aSaldo[1])*aCM[mv_par10]
				EndIf
				Li++
			EndIf
		EndDo
		
	
	If aReturn[8] == 2
		If cAnt # B1_TIPO .And. nSB7Cnt >= 1
			If mv_par11 == 1
				@ Li,If(mv_par13==1,158,120) + nCOL1 PSAY STR0018 + Left(cAnt,2) + ' .............' // 'TOTAL DO TIPO '
				@ Li,If(mv_par13==1,188,151) + nCOL1 PSAY Transform(nSubVal, (cAliasSB2)->(PesqPict("SB2",'B2_QFIM', 15)))
			Else     
				@ Li,If(mv_par13==1,142,098) + nCOL1 PSAY STR0018 + Left(cAnt,2) + ' ............' // 'TOTAL DO TIPO '
				@ Li,If(mv_par13==1,171,133) + nCOL1 PSAY Transform(nSubVal, (cAliasSB2)->(PesqPict("SB2",'B2_QFIM', 15)))
			EndIf
			cAnt    := B1_TIPO
			nSubVal := 0
			Li += 2
			nSB7Cnt := 0
		EndIf
	ElseIf aReturn[8] == 3
		If cAnt # B1_GRUPO  .And. nSB7Cnt >= 1
			If mv_par11 == 1 
				@ Li,If(mv_par13==1,155,117) + nCOL1 PSAY STR0019 + Left(cAnt,4) + ' .............' // 'TOTAL DO GRUPO '
				@ Li,If(mv_par13==1,188,151) + nCOL1 PSAY Transform(nSubVal, (cAliasSB2)->(PesqPict("SB2",'B2_QFIM', 15)))
			Else
				@ Li,If(mv_par13==1,135,096) + nCOL1 PSAY STR0019 + Left(cAnt,4) + ' .............' // 'TOTAL DO GRUPO '
				@ Li,If(mv_par13==1,171,133) + nCOL1 PSAY Transform(nSubVal, (cAliasSB2)->(PesqPict("SB2",'B2_QFIM', 15)))
			EndIf
			cAnt    := B1_GRUPO
			nSubVal := 0
			Li += 2
			nSB7Cnt := 0
		EndIf
	EndIf
	
EndDo

If nTotVal # 0
	Li++
	If mv_par11 == 1
		@ Li,If(mv_par13==1,145,107) + nCOL1 PSAY STR0020 // 'TOTAL DAS DIFERENCAS EM VALOR .............'
		@ Li,If(mv_par13==1,188,151) + nCOL1 PSAY Transform(nTotVal, (cAliasSB2)->(PesqPict("SB2",'B2_VFIM1', 15)))
	Else
		@ Li,If(mv_par13==1,120,086) + nCOL1 PSAY STR0020 // 'TOTAL DAS DIFERENCAS EM VALOR .............'
		@ Li,If(mv_par13==1,171,133) + nCOL1 PSAY Transform(nTotVal, (cAliasSB2)->(PesqPict("SB2",'B2_VFIM1', 15)))
	EndIf
EndIf

If Li # 80
	Roda(nCntImpr, cRodaTxt, Tamanho)
EndIf

//��������������������������������������������������������������Ŀ
//� Devolve a condicao original do arquivo principal             �
//����������������������������������������������������������������
dbSelectArea(cString)
RetIndex(cString)
dbSetOrder(1)
dbClearFilter()

dbSelectArea(cAliasSB1)
dbCloseArea()

If !empty(cNomArq)
	If aReturn[8] == 5 .or. (lVEIC .And. (aReturn[8] == 1 .or. aReturn[8] == 2))
		If File(cNomArq + OrdBagExt())
			fErase(cNomArq + OrdBagExt())
		EndIf
	EndIf
EndIf

If aReturn[5] == 1
	Set Printer To
	dbCommitAll()
	OurSpool(wnrel)
EndIf

MS_FLUSH()

Return Nil

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �Atf285QryFil� Autor � Marcos V. Ferreira    � Data � 15.04.05 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Funcao utilizada para adicionar no select os campos        ���
���			 � utilizados no filtro de usuario.                           ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � MATR285                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������*/

User Function Atf285QryFil(cAlias,cQuery,cFilUser)
Local cQryAd	:= ""
Local cName		:= ""
Local aStruct	:= (cAlias)->(dbStruct())
Local nX		:= 0
Default cAlias  := ""
Default cQuery  := ""
Default cFilUser:= ""

//�������������������������������������������������������������������Ŀ
//�Esta rotina foi escrita para adicionar no select os campos         �
//�usados no filtro do usuario quando houver, a rotina acrecenta      �
//�somente os campos que forem adicionados ao filtro testando         �
//�se os mesmo j� existem no select ou se forem definidos novamente   �
//�pelo o usuario no filtro.                                          �
//���������������������������������������������������������������������	   	
If !Empty(cFilUser)
	For nX := 1 To (cAlias)->(FCount())
		cName := (cAlias)->(FieldName(nX))
		If AllTrim( cName ) $ cFilUser
	    	If aStruct[nX,2] <> "M"  
	      	    If !cName $ cQuery .And. !cName $ cQryAd
		    		cQryAd += cName +","
	            EndIf 	
			EndIf
		EndIf 			       	
	Next nX
EndIf    

Return cQryAd
