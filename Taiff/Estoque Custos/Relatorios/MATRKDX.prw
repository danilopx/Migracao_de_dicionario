#Include "MATRKDX.CH"
#INCLUDE "Protheus.ch"
#INCLUDE "Topconn.ch"

//+--------------------------------------------------------------------------------------------------------------
//| ROTINA: MATRKDX                                     AUTOR: CARLOS ALDAY TORRES           DATA: 04/02/2011   |
//+--------------------------------------------------------------------------------------------------------------
//| DESCRICAO: Relatorio demonstrativo sintetico da movimentação de estoque dos produtos tipo PA
//| SOLICITANTE: Marcelo Conceição / R. Brito
//+--------------------------------------------------------------------------------------------------------------
User Function MATRKDX()
Local oReport 

If FindFunction("TRepInUse") .And. TRepInUse()
	oReport := ReportDef()
	oReport:PrintDialog()
EndIf

Return NIL

//--------------------------------------------------------------------------------------------------------------
// Função Static de preparação dos objetos
//--------------------------------------------------------------------------------------------------------------
Static Function ReportDef()
Local oReport
#IFDEF TOP
	Local cAliasQry := GetNextAlias()
#ELSE
	Local cAliasQry := "SD1"
#ENDIF	         

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Criacao do componente de impressao                                      ³
//³                                                                        ³
//³TReport():New                                                           ³
//³ExpC1 : Nome do relatorio                                               ³
//³ExpC2 : Titulo                                                          ³
//³ExpC3 : Pergunte                                                        ³
//³ExpB4 : Bloco de codigo que sera executado na confirmacao da impressao  ³
//³ExpC5 : Descricao                                                       ³
//³                                                                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oReport := TReport():New("MATRKDX","MAPA SEMANAL DE MOVIMENTAÇÕES","MATRKDX", {|oReport| ReportPrint(oReport,cAliasQry)},"Este programa ira emitir o Demonstrativo Sintetico Kardex" + " " + "")	
oReport:SetPortrait() 
oReport:SetTotalInLine(.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Pergunte(oReport:uParam,.F.)


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Definicao da Secao                                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oNFTransp := TRSection():New(oReport,"Semana 1",{"SD1","SD2","SD3"},/*{Array com as ordens do relatório}*/,/*Campos do SX3*/,/*Campos do SIX*/)
oNFTransp:SetTotalInLine(.F.)

TRCell():New(oNFTransp,"MOVIMENTO"	,/*Tabela*/	,"MOVIMENTO"						,/*Picture*/						,TamSx3("B1_DESC")[1]	,/*lPixel*/,{|| (cAliasQry)->MOVIMENTO })	
TRCell():New(oNFTransp,"ORIGEM"		,/*Tabela*/	,"Origem"						,/*Picture*/						,TamSx3("F4_TEXTO")[1]	,/*lPixel*/,{|| (cAliasQry)->ORIGEM		})	
TRCell():New(oNFTransp,"NQUANT1"		,/*Tabela*/	,"Semana 1"						,PesqPict("SD2","D2_QUANT")	,TamSx3("D2_QUANT")[1]	,/*lPixel*/,{|| nQuant1						},,,"RIGHT")	
TRCell():New(oNFTransp,"NQUANT2"		,/*Tabela*/	,"Semana 2"						,PesqPict("SD2","D2_QUANT")	,TamSx3("D2_QUANT")[1]	,/*lPixel*/,{|| nQuant2						},,,"RIGHT")	
TRCell():New(oNFTransp,"NQUANT3"		,/*Tabela*/	,"Semana 3"						,PesqPict("SD2","D2_QUANT")	,TamSx3("D2_QUANT")[1]	,/*lPixel*/,{|| nQuant3						},,,"RIGHT")	
TRCell():New(oNFTransp,"NQUANT4"		,/*Tabela*/	,"Semana 4"						,PesqPict("SD2","D2_QUANT")	,TamSx3("D2_QUANT")[1]	,/*lPixel*/,{|| nQuant4						},,,"RIGHT")	
TRCell():New(oNFTransp,"NQUANT5"		,/*Tabela*/	,"Semana 5"						,PesqPict("SD2","D2_QUANT")	,TamSx3("D2_QUANT")[1]	,/*lPixel*/,{|| nQuant5						},,,"RIGHT")	

TRFunction():New(oNFTransp:Cell("NQUANT1"		),/* cID */,"SUM"		,/*oBreak*/,/*cTitle*/,/*cPicture*/,/*uFormula*/,.T./*lEndSection*/,.F./*lEndReport*/,/*lEndPage*/)
TRFunction():New(oNFTransp:Cell("NQUANT2"		),/* cID */,"SUM"		,/*oBreak*/,/*cTitle*/,/*cPicture*/,/*uFormula*/,.T./*lEndSection*/,.F./*lEndReport*/,/*lEndPage*/)
TRFunction():New(oNFTransp:Cell("NQUANT3"		),/* cID */,"SUM"		,/*oBreak*/,/*cTitle*/,/*cPicture*/,/*uFormula*/,.T./*lEndSection*/,.F./*lEndReport*/,/*lEndPage*/)
TRFunction():New(oNFTransp:Cell("NQUANT4"		),/* cID */,"SUM"		,/*oBreak*/,/*cTitle*/,/*cPicture*/,/*uFormula*/,.T./*lEndSection*/,.F./*lEndReport*/,/*lEndPage*/)
TRFunction():New(oNFTransp:Cell("NQUANT5"		),/* cID */,"SUM"		,/*oBreak*/,/*cTitle*/,/*cPicture*/,/*uFormula*/,.T./*lEndSection*/,.F./*lEndReport*/,/*lEndPage*/)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Impressao do Cabecalho no top da pagina                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oReport:Section(1):SetHeaderPage()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Salta Pagina na Quebra da Secao                                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oNFTransp:SetPageBreak(.T.)

//TRPosition():New(oReport:Section(1),"SA1",1,{|| xFilial("SA1")+(cAliasQry)->F2_CLIENTE+(cAliasQry)->F2_LOJA})

Return(oReport)


//--------------------------------------------------------------------------------------------------------------
// Função Static de execução do Script SQL para alimentar os objetos
//--------------------------------------------------------------------------------------------------------------
Static Function ReportPrint(oReport,cAliasQry)

//Local cCliente	:= ""
Local cPictQIni:= PesqPict('SD2','D2_QUANT')
Local nTqSem1	:= nTqSem2	:= nTqSem3	:= nTqSem4	:= nTqSem5	:= 0

#IFNDEF TOP
	Local cCondicao := ""
#ELSE
	Local cWhere    := ""
#ENDIF
Local nDiaSemana	:= 1
Local cA_empresa	:= Strzero( Val(cEmpAnt) ,2)
//Local cTabSB1		:= "SB1010"

Public dSemDe1	:=	mv_par05 
Public dSemDe2	:=	mv_par05 
Public dSemDe3	:=	mv_par05 
Public dSemDe4	:=	mv_par05 
Public dSemDe5	:=	mv_par05 
Public dSemAte1:=	mv_par05 
Public dSemAte2:=	mv_par05 
Public dSemAte3:=	mv_par05 
Public dSemAte4:=	mv_par05 
Public dSemAte5:=	mv_par05 

dSemAte1 := dSemDe1
While Dow(dSemAte1)<7
	dSemAte1 := dSemDe1 + nDiaSemana
	nDiaSemana++
End

dSemDe2 	:= dSemAte1 + 1
dSemAte2 := dSemDe2 + ( 7 - dow( dSemDe2 ) )

dSemDe3 	:= dSemAte2 + 1
dSemAte3 := dSemDe3 + ( 7 - dow( dSemDe3 ) )

dSemDe4 	:= dSemAte3 + 1
dSemAte4 := dSemDe4 + ( 7 - dow( dSemDe4 ) )

dSemDe5 	:= dSemAte4 + 1
dSemAte5 := dSemDe5 + ( 7 - dow( dSemDe5 ) )
While Month(dSemDe5) != Month(dSemAte5)
	dSemAte5 -= 1
End

nTsldSem1 := 0
nTsldSem2 := 0
nTsldSem3 := 0
nTsldSem4 := 0
nTsldSem5 := 0

Processa({|| U_Sb2Inicial( mv_par02, mv_par03, mv_par04, mv_par01 ) },"Aguarde, Calculando Saldo Inicial...")

nQuant1	:= nTsldSem1
nQuant2	:= nTsldSem2
nQuant3	:= nTsldSem3
nQuant4	:= nTsldSem4
nQuant5	:= nTsldSem5

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ SetBlock: faz com que as variaveis locais possam ser         ³
//³ utilizadas em outras funcoes nao precisando declara-las      ³
//³ como private											  	 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oReport:Section(1):Cell("NQUANT1" 	):SetBlock({|| nQuant1		})
oReport:Section(1):Cell("NQUANT2" 	):SetBlock({|| nQuant2		})
oReport:Section(1):Cell("NQUANT3" 	):SetBlock({|| nQuant3		})
oReport:Section(1):Cell("NQUANT4" 	):SetBlock({|| nQuant4		})
oReport:Section(1):Cell("NQUANT5" 	):SetBlock({|| nQuant5		})

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Altera o Titulo do Relatorio de acordo com parametros	 	 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oReport:SetTitle(oReport:Title() )	

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Transforma parametros Range em expressao SQL                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
MakeSqlExpr(oReport:uParam)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Filtragem do relatório                                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
#IFDEF TOP

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Query do relatório da secao 1                                           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	cWhere := "% AND 1=1 %"
	
	dbSelectArea("SF2")				// Cabecalho da Nota de Saida
	dbSetOrder(1)					// Documento,Serie,Cliente,Loja
	
	oReport:Section(1):BeginQuery()	
	BeginSql Alias cAliasQry
		SELECT 
			MOVIMENTO,
			ORIGEM,
			TIPO,
			Isnull(SUM(SM1_QUANT),0) AS SM1_QTD,
			Isnull(SUM(SM2_QUANT),0) AS SM2_QTD,
			Isnull(SUM(SM3_QUANT),0) AS SM3_QTD,
			Isnull(SUM(SM4_QUANT),0) AS SM4_QTD,
			Isnull(SUM(SM5_QUANT),0) AS SM5_QTD
		FROM 
			(
				SELECT	'SALDO INICIAL' AS MOVIMENTO,
						'SB2' AS ORIGEM,
						'A' AS TIPO,
						0 AS SM1_QUANT,
						0 AS SM2_QUANT,
						0 AS SM3_QUANT,
						0 AS SM4_QUANT,
						0 AS SM5_QUANT
				FROM %Table:SB2% SB2
				INNER JOIN SB1010 SB1 ON SB2.B2_COD=SB1.B1_COD AND SB1.B1_TIPO=%Exp:mv_par02% AND SB1.%notdel% 
				WHERE SB2.B2_LOCAL=%Exp:mv_par01% AND SB2.%notdel%
			UNION ALL                 
				SELECT 	MOVIMENTO,
							ORIGEM,
							TIPO,
							Isnull(SUM(SM1_QTD),0) AS SM1_QUANT,
							Isnull(SUM(SM2_QTD),0) AS SM2_QUANT,
							Isnull(SUM(SM3_QTD),0) AS SM3_QUANT,
							Isnull(SUM(SM4_QTD),0) AS SM4_QUANT,
							Isnull(SUM(SM5_QTD),0) AS SM5_QUANT
				FROM MAPA_MOVIMENTOS_SEMANA1
				WHERE B1_TIPO=%Exp:mv_par02% AND MOV_LOCAL=%Exp:mv_par01% 
					AND B1_COD>=%Exp:mv_par03% AND B1_COD<=%Exp:mv_par04% 
					AND DT_MOVTO>=%Exp:DTOS(dSemDe1)% AND DT_MOVTO<=%Exp:DTOS(dSemAte1)% 
					AND EMPRESA = %Exp:cA_empresa%
				GROUP BY TIPO, MOVIMENTO, ORIGEM, B1_TIPO
			UNION ALL                 
				SELECT 	MOVIMENTO,
							ORIGEM,
							TIPO,
							Isnull(SUM(SM1_QTD),0) AS SM1_QUANT,
							Isnull(SUM(SM2_QTD),0) AS SM2_QUANT,
							Isnull(SUM(SM3_QTD),0) AS SM3_QUANT,
							Isnull(SUM(SM4_QTD),0) AS SM4_QUANT,
							Isnull(SUM(SM5_QTD),0) AS SM5_QUANT
				FROM MAPA_MOVIMENTOS_SEMANA2
				WHERE B1_TIPO=%Exp:mv_par02% AND MOV_LOCAL=%Exp:mv_par01% 
					AND B1_COD>=%Exp:mv_par03% AND B1_COD<=%Exp:mv_par04% 
					AND DT_MOVTO>=%Exp:DTOS(dSemDe2)% AND DT_MOVTO<=%Exp:DTOS(dSemAte2)% 
					AND EMPRESA = %Exp:cA_empresa%
				GROUP BY TIPO, MOVIMENTO, ORIGEM, B1_TIPO
			UNION ALL                 
				SELECT 	MOVIMENTO,
							ORIGEM,
							TIPO,
							Isnull(SUM(SM1_QTD),0) AS SM1_QUANT,
							Isnull(SUM(SM2_QTD),0) AS SM2_QUANT,
							Isnull(SUM(SM3_QTD),0) AS SM3_QUANT,
							Isnull(SUM(SM4_QTD),0) AS SM4_QUANT,
							Isnull(SUM(SM5_QTD),0) AS SM5_QUANT
				FROM MAPA_MOVIMENTOS_SEMANA3
				WHERE B1_TIPO=%Exp:mv_par02% AND MOV_LOCAL=%Exp:mv_par01% 
					AND B1_COD>=%Exp:mv_par03% AND B1_COD<=%Exp:mv_par04% 
					AND DT_MOVTO>=%Exp:DTOS(dSemDe3)% AND DT_MOVTO<=%Exp:DTOS(dSemAte3)% 
					AND EMPRESA = %Exp:cA_empresa%
				GROUP BY TIPO, MOVIMENTO, ORIGEM, B1_TIPO
			UNION ALL                 
				SELECT 	MOVIMENTO,
							ORIGEM,
							TIPO,
							Isnull(SUM(SM1_QTD),0) AS SM1_QUANT,
							Isnull(SUM(SM2_QTD),0) AS SM2_QUANT,
							Isnull(SUM(SM3_QTD),0) AS SM3_QUANT,
							Isnull(SUM(SM4_QTD),0) AS SM4_QUANT,
							Isnull(SUM(SM5_QTD),0) AS SM5_QUANT
				FROM MAPA_MOVIMENTOS_SEMANA4
				WHERE B1_TIPO=%Exp:mv_par02% AND MOV_LOCAL=%Exp:mv_par01% 
					AND B1_COD>=%Exp:mv_par03% AND B1_COD<=%Exp:mv_par04% 
					AND DT_MOVTO>=%Exp:DTOS(dSemDe4)% AND DT_MOVTO<=%Exp:DTOS(dSemAte4)% 
					AND EMPRESA = %Exp:cA_empresa%
				GROUP BY TIPO, MOVIMENTO, ORIGEM, B1_TIPO
			UNION ALL                 
				SELECT 	MOVIMENTO,
							ORIGEM,
							TIPO,
							Isnull(SUM(SM1_QTD),0) AS SM1_QUANT,
							Isnull(SUM(SM2_QTD),0) AS SM2_QUANT,
							Isnull(SUM(SM3_QTD),0) AS SM3_QUANT,
							Isnull(SUM(SM4_QTD),0) AS SM4_QUANT,
							Isnull(SUM(SM5_QTD),0) AS SM5_QUANT
				FROM MAPA_MOVIMENTOS_SEMANA5
				WHERE B1_TIPO=%Exp:mv_par02% AND MOV_LOCAL=%Exp:mv_par01% 
					AND B1_COD>=%Exp:mv_par03% AND B1_COD<=%Exp:mv_par04% 
					AND DT_MOVTO>=%Exp:DTOS(dSemDe5)% AND DT_MOVTO<=%Exp:DTOS(dSemAte5)% 
					AND EMPRESA = %Exp:cA_empresa%
				GROUP BY TIPO, MOVIMENTO, ORIGEM, B1_TIPO
			) TMP
		GROUP BY TIPO, MOVIMENTO, ORIGEM
		ORDER BY TIPO, MOVIMENTO, ORIGEM
				   
	EndSql 
	oReport:Section(1):EndQuery(/*Array com os parametros do tipo Range*/)
		
#ELSE
#ENDIF		

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Inicio da impressao do fluxo do relatório                               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oReport:SetMeter((cAliasQry)->(LastRec()))
dbSelectArea(cAliasQry)
oReport:Section(1):Init()
                          
cLinDet := "Total da Entrada" + Space(40)
cTipoDet:= "A"
While !oReport:Cancel() .And. !(cAliasQry)->(Eof())

	If cTipoDet = "A"
		//oReport:skipLine()
		cLinDet:= Space(75)
		oReport:ThinLine() //-- Impressao de Linha Simples
		oReport:PrintText(cLinDet,oReport:Row() )
		oReport:PrintText( Dtoc(dSemDe1) + Space(04),oReport:Row() )
		oReport:PrintText( Dtoc(dSemDe2) + Space(04),oReport:Row() )
		oReport:PrintText( Dtoc(dSemDe3) + Space(04),oReport:Row() )
		oReport:PrintText( Dtoc(dSemDe4) + Space(04),oReport:Row() )
		oReport:PrintText( Dtoc(dSemDe5) + Space(04),oReport:Row() )
		//oReport:ThinLine() //-- Impressao de Linha Simples
	EndIf
	

	nTqSem1	:=	0   
	nTqSem2	:=	0   
	nTqSem3	:=	0   
	nTqSem4	:=	0   
	nTqSem5	:=	0   
	While !oReport:Cancel() .And. !(cAliasQry)->(Eof()) .And. (cAliasQry)->TIPO=cTipoDet

		If cTipoDet != "A"
			nQuant1	:= (cAliasQry)->SM1_QTD
			nQuant2	:= (cAliasQry)->SM2_QTD
			nQuant3	:= (cAliasQry)->SM3_QTD
			nQuant4	:= (cAliasQry)->SM4_QTD
			nQuant5	:= (cAliasQry)->SM5_QTD
		EndIf

		nTqSem1	+= (cAliasQry)->SM1_QTD
		nTqSem2	+= (cAliasQry)->SM2_QTD
		nTqSem3	+= (cAliasQry)->SM3_QTD
		nTqSem4	+= (cAliasQry)->SM4_QTD
		nTqSem5	+= (cAliasQry)->SM5_QTD

		oReport:Section(1):PrintLine()
		dbSelectArea(cAliasQry)
		dbSkip()
		oReport:IncMeter()
	End
	

	If cTipoDet != "A"
		oReport:ThinLine() //-- Impressao de Linha Simples
		oReport:PrintText(cLinDet,oReport:Row() )
		oReport:PrintText(Transform(nTqSem1,cPictQIni) + Space(01),oReport:Row() )
		oReport:PrintText(Transform(nTqSem2,cPictQIni) + Space(01),oReport:Row() )
		oReport:PrintText(Transform(nTqSem3,cPictQIni) + Space(01),oReport:Row() )
		oReport:PrintText(Transform(nTqSem4,cPictQIni) + Space(01),oReport:Row() )
		oReport:PrintText(Transform(nTqSem5,cPictQIni) + Space(01),oReport:Row() )
		oReport:skipLine()
		oReport:skipLine()
	EndIf
	oReport:skipLine()
	
	Do Case
		Case cTipoDet="A"
			cLinDet := "Total da Entrada" + Space(56)
			cTipoDet:= "E"
		Case cTipoDet="E"
			cLinDet := "Total da Saída" + Space(58)
			cTipoDet:= "S"
	EndCase
End

oReport:Section(1):SetPageBreak(.T.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Fecha Query/SetFilter                                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
(cAliasQry)->(dbCloseArea())

Return

//
// Função para calculo do saldo inicial da range de produtos
//
User Function Sb2Inicial( cTipoSb1, cCodInicial, cCodFinal, cLocalSb1 )
Local aSalAtu	:= { 0,0,0,0,0,0,0 }
Local cQuery	:= ""

cQuery := "SELECT SB1.B1_COD AS B1_COD "
cQuery += " FROM SB1010 SB1 " 
cQuery += " WHERE  SB1.B1_FILIAL='"+xFilial("SB1")+"' "
cQuery += "		AND SB1.B1_TIPO = '" + cTipoSb1 + "' "
cQuery += "		AND SB1.D_E_L_E_T_ != '*' "
cQuery += "		AND SB1.B1_COD >= '" + cCodInicial + "' AND B1_COD <= '" + cCodFinal + "' "

If Select("TMPSB1") > 0
	TMPSB1->(DbCloseArea())
Endif
	
TcQuery cQuery NEW ALIAS ("TMPSB1")
ProcRegua( SB1->(reccount()) ) 

DbSelectArea("TMPSB1")
While !TMPSB1->(Eof())
	IncProc()

	// produto , local , da data
	aSalAtu	:= CalcEst(	TMPSB1->B1_COD , cLocalSb1 ,dSemDe1,,, .F. )
	nTsldSem1+= aSalAtu[1]	

	aSalAtu	:= CalcEst(	TMPSB1->B1_COD , cLocalSb1 ,dSemDe2,,, .F. )
	nTsldSem2+= aSalAtu[1]	

	aSalAtu	:= CalcEst(	TMPSB1->B1_COD , cLocalSb1 ,dSemDe3,,, .F. )
	nTsldSem3+= aSalAtu[1]	

	aSalAtu	:= CalcEst(	TMPSB1->B1_COD , cLocalSb1 ,dSemDe4,,, .F. )
	nTsldSem4+= aSalAtu[1]	

	aSalAtu	:= CalcEst(	TMPSB1->B1_COD , cLocalSb1 ,dSemDe5,,, .F. )
	nTsldSem5+= aSalAtu[1]	
	
	TMPSB1->(DbSkip())
End	
TMPSB1->(DbCloseArea())
RETURN NIL
