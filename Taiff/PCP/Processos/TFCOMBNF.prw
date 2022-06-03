#INCLUDE 'TOTVS.CH'
#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'PARMTYPE.CH'
#INCLUDE 'TOPCONN.CH'

#DEFINE ENTER CHR(13) + CHR(10)

/*
=================================================================================
=================================================================================
||   Arquivo:	TFCOMBNF.prw
=================================================================================
||   Funcao:	TFCOMBNF 
=================================================================================
||   Descricao
||-------------------------------------------------------------------------------
|| 		Processo de Controle / Consulta / Gestão de Beneficiamentos com base  
|| 	nas Ordens de Produção do Sistema.
|| 
=================================================================================
=================================================================================
||   Autor:	Edson Hornberger 
||   Data:		06/01/2016
=================================================================================
=================================================================================
*/

USER FUNCTION TFCOMBNF()


LOCAL CFILTRO			:= "B1_FILIAL = '" + XFILIAL("SB1") + "' .AND. B1_TIPO='BN'"							// Somente será apresentado no Browse Produtos para Beneficiamento

Private _CBNFALIAS	:= "SB1"
PRIVATE CCADASTRO		:= "Processo de Beneficiamento"
PRIVATE AROTINA		:= MENUDEF()
PRIVATE AINDEXSB1 	:= {}
PRIVATE BFILTRABRW	:= { || FILBROWSE(_CBNFALIAS,@AINDEXSB1,@CFILTRO) }

DBSELECTAREA(_CBNFALIAS)
DBSETORDER(1)
EVAL(BFILTRABRW)
DBGOTOP()

/*
|---------------------------------------------------------------------------------
|	Apresenta a tela inicial para escolha do Produto que será Consultado.
|---------------------------------------------------------------------------------
*/
MBROWSE( 6, 1, 22, 75, _CBNFALIAS)

ENDFILBRW(_CBNFALIAS,AINDEXSB1)

RETURN

/*
=================================================================================
=================================================================================
||   Arquivo:	TFCOMBNF.prw
=================================================================================
||   Funcao: 	SCRBENEF
=================================================================================
||   Descricao
||-------------------------------------------------------------------------------
|| 		Tela do Controle / Consulta / Gestão de Beneficiamentos do produto 
|| 	escolhido pelo usuário.
|| 
=================================================================================
=================================================================================
||   Autor:	Edson Hornberger 
||   Data:	06/01/2016
=================================================================================
=================================================================================
*/

USER FUNCTION SCRBENEF()

LOCAL AROTOLD := ACLONE(AROTINA)

PRIVATE ATELA 		:= MSADVSIZE(.F.) 																	// Dimensões da Tela a ser criada sem EnchoiceBar - Retorna Array com 7 posições
PRIVATE AOBJ001		:= {ATELA[1],ATELA[2],ATELA[3],ATELA[4],10,10}									// Passa dimensionamento da tela para calculo do tamanho dos objetos
PRIVATE AOBJ002		:= {}																					// Passa as dimensoes dos Objetos na Vertical
PRIVATE AOBJ003		:= {}																					// Passa as dimensoes dos Objetos na Horizontal
PRIVATE AOBJ004		:= {}																					// Dimensoes verticais
PRIVATE AOBJ005		:= {}																					// Dimensoes horizontais
PRIVATE ODLGBNF 
PRIVATE OFONT01
PRIVATE OFONT02
PRIVATE OFONT03
PRIVATE ODESCPRO
PRIVATE CDESCPRO		:= ALLTRIM(SB1->B1_COD) + " - " + ALLTRIM(SB1->B1_DESC)
PRIVATE OBTMBNT
PRIVATE OSAYGRD01
PRIVATE OSAYGRD02
PRIVATE OSAYGRD03
PRIVATE OGRID01
PRIVATE AHEADER01		:= {"","Nº. Ordem de Produção","Data da Emissão","Quant. Original","Saldo da OP","Prazo em Dias","% Em Processo",""}
PRIVATE ATAMGRID1		:= {4,TAMSX3("C2_NUM")[1]+TAMSX3("C2_ITEM")[1],TAMSX3("C2_SEQUEN")[1],TAMSX3("C2_EMISSAO")[1],TAMSX3("C2_QUANT")[1],TAMSX3("C2_QUANT")[1],15,5,10}
PRIVATE ACOLS01 		:= {}
PRIVATE OBMPVERM		:= LOADBITMAP(GETRESOURCES(),'BR_VERMELHO_MDI')
PRIVATE OBMPVERD		:= LOADBITMAP(GETRESOURCES(),'BR_VERDE_MDI')
PRIVATE OBMPAMAR		:= LOADBITMAP(GETRESOURCES(),'BR_AMARELO_MDI')
PRIVATE OBMPAZUL		:= LOADBITMAP(GETRESOURCES(),'BR_AZUL_MDI')
PRIVATE OGRID02
PRIVATE AHEADER02		:= {"","Nº. Pedido de Venda","Data da Emissão","Cód.Fornecedor","Loja","Razão Social"}
PRIVATE ATAMGRID2		:= {4,TAMSX3("C5_NUM")[1],TAMSX3("C5_EMISSAO")[1],TAMSX3("C5_CLIENTE")[1],TAMSX3("C5_LOJACLI")[1],TAMSX3("A2_NOME")[1]}
PRIVATE ACOLS02		:= {}
PRIVATE OGRID03
PRIVATE AHEADER03		:= {"","Nº. Pedido de Compra","Data da Emissão","Cód.Fornecedor","Loja","Razão Social"}
PRIVATE ATAMGRID3		:= {4,TAMSX3("C7_NUM")[1],TAMSX3("C7_EMISSAO")[1],TAMSX3("C7_FORNECE")[1],TAMSX3("C7_LOJA")[1],TAMSX3("A2_NOME")[1]}
PRIVATE ACOLS03		:= {}
PRIVATE OBTN_LEGE
PRIVATE OBTN_PROC
PRIVATE OBTN_EXCE
PRIVATE OBTN_ENCE
PRIVATE OBTN_APON
PRIVATE OBTN_NFSA
PRIVATE OBTN_NFEN
PRIVATE OBTN_SAIR

/*
|---------------------------------------------------------------------------------
|	PREENCHO ARRAYS COM AS DIMENSOES DOS OBJETOS
|---------------------------------------------------------------------------------
*/
// OBJETOS PARA CALCULO DAS DIMENSOES VERTICAIS 
AADD(AOBJ002 , {0025,0025,.F.,.F.})						// IMAGEM BMP
AADD(AOBJ002 , {0100,0010,.F.,.F.})						// LABEL      
AADD(AOBJ002 , {1800,0300,.T.,.T.,.T.})					// GRID SUPERIOR
AADD(AOBJ002 , {0050,0015,.T.,.T.})						// BOTAO       
AADD(AOBJ002 , {0100,0010,.F.,.F.})						// LABEL       
AADD(AOBJ002 , {1800,0300,.T.,.T.,.T.})					// GRID INFERIOR
AADD(AOBJ002 , {0050,0015,.T.,.T.})						// BOTAO     
AADD(AOBJ002 , {0050,0015,.T.,.T.})						// BOTAO     

// OBJETOS PARA CALCULO DAS DIMENSOES HORIZONTAL
AADD(AOBJ003 , {1800,0300,.T.,.T.,.T.})					// GRID INFERIOR
AADD(AOBJ003 , {1800,0300,.T.,.T.,.T.})					// GRID INFERIOR

AOBJ004 := MSOBJSIZE(AOBJ001,AOBJ002,.T.,.F.)				// CALCULO DAS DIMENSOES VERTICAL
AOBJ005 := MSOBJSIZE(AOBJ001,AOBJ003,.T.,.T.)				// CALCULO DAS DIMENSOES HORIZONTAL

SETKEY(VK_F6,{|| VEREMPENHOS(OGRID01)})

ODLGBNF 	:= MSDIALOG():NEW(ATELA[7],0,ATELA[6],ATELA[5],"Processos para o Produto " + ALLTRIM(SB1->B1_COD) + " - " + ALLTRIM(SB1->B1_DESC),,,,,CLR_WHITE,CLR_BLACK,,,.T.)

OFONT01	:= TFONT():NEW("Book Antiqua"	,,-16,,.T.) 
OFONT02	:= TFONT():NEW("Calibri"		,,-14,,.F.)
OFONT03	:= TFONT():NEW("Calibri"		,,-11,,.F.)

ODESCPRO	:= TSAY():NEW(ATELA[1] + 10, ATELA[2] + 010 	, {|| "Produto: " + CDESCPRO}	, ODLGBNF,, OFONT01,,,,.T.,8002583)
OBMOBNT	:= TBITMAP():NEW(AOBJ004[1,1], ATELA[3] - 060, 025, 025, "SDUSTRUCT_MDI",,.T., ODLGBNF, {|| GRAPHBNF(OGRID01)}, {||},.F.,.T.,,,,,.T.)
OSAYGRD01	:= TSAY():NEW(AOBJ004[2,1], AOBJ004[2,2]	, {|| "Ordens de Produção"}														, ODLGBNF,, OFONT02,,,,.T.,1381735)

OGRID01	:= TCBROWSE():NEW(AOBJ004[3,1], AOBJ004[3,2], AOBJ004[3,3], AOBJ004[3,4],, AHEADER01, ATAMGRID1, ODLGBNF,,,,, {||},,,,,,,.F.,,.T.,,.F.,,.T.,.T.)

OBTN_LEGE	:= TBUTTON():NEW(AOBJ004[4,1], ATELA[2] + 010, "Legenda"				, ODLGBNF, {|| MontLeg()}, 50, 15,,,.F.,.T.)
OBTN_PROC	:= TBUTTON():NEW(AOBJ004[4,1], ATELA[3] - 240, "Iniciar Processo"	, ODLGBNF, {|| INIPROC(OGRID01)}, 50, 15,,,.F.,.T.)
OBTN_EXCE	:= TBUTTON():NEW(AOBJ004[4,1], ATELA[3] - 180, "Exportar Excel"		, ODLGBNF, {|| PLANFOR(OGRID01)}, 50, 15,,,.F.,.T.)
OBTN_ENCE	:= TBUTTON():NEW(AOBJ004[4,1], ATELA[3] - 120, "Encerrar OP"			, ODLGBNF, {|| ENCEROP(OGRID01,@ACOLS01)}, 50, 15,,,.F.,.T.)
OBTN_APON	:= TBUTTON():NEW(AOBJ004[4,1], ATELA[3] - 060, "Apontamentos"		, ODLGBNF, {|| VERAPONTAM(OGRID01)}, 50, 15,,,.F.,.T.)

OSAYGRD02	:= TSAY():NEW(AOBJ004[5,1], ATELA[2] + 10	, {|| "Pedidos de Venda"}														, ODLGBNF,, OFONT02,,,,.T.,1381735)
OSAYGRD03	:= TSAY():NEW(AOBJ004[5,1], AOBJ005[2,2]	, {|| "Pedidos de Compra"}														, ODLGBNF,, OFONT02,,,,.T.,1381735)

OGRID02	:= TCBROWSE():NEW(AOBJ004[6,1], AOBJ005[1,2]	, AOBJ005[1,3] , AOBJ004[6,4],, AHEADER02, ATAMGRID2, ODLGBNF,,,,, {||},,,,,,,.F.,,.T.,,.F.,,.T.,.T.)
OGRID03	:= TCBROWSE():NEW(AOBJ004[6,1], AOBJ005[2,2]	, AOBJ005[2,3] , AOBJ004[6,4],, AHEADER03, ATAMGRID3, ODLGBNF,,,,, {||},,,,,,,.F.,,.T.,,.F.,,.T.,.T.)

OBTN_NFSA	:= TBUTTON():NEW(AOBJ004[7,1], AOBJ004[7,2]	, "NF Saída"			, ODLGBNF, {|| VERNFS(OGRID02)}, 50, 15,,,.F.,.T.,,,,{|| WHENBTN(ACOLS02,OGRID02)})
OBTN_NFEN	:= TBUTTON():NEW(AOBJ004[7,1], AOBJ005[2,2]	, "NF Entrada"		, ODLGBNF, {|| VERNFE(OGRID03)}, 50, 15,,,.F.,.T.,,,,{|| WHENBTN(ACOLS03,OGRID03)})
OBTN_SAIR	:= TBUTTON():NEW(AOBJ004[8,1], ATELA[3] - 60	, "Sair"				, ODLGBNF, {|| ODLGBNF:End()}, 50, 15,,,.F.,.T.)

/*
|---------------------------------------------------------------------------------
|	Gera informações para o primeiro Grid, informações das OP´s
|---------------------------------------------------------------------------------
*/
IF !DADOSOP(@ACOLS01)
	MESSAGEBOX("Não há dados de Gestão de Beneficamento para o" + ENTER + "Produto " + ALLTRIM(SB1->B1_COD) + " - " + ALLTRIM(SB1->B1_DESC) + "!","ATENÇÃO",16)
	DBSELECTAREA(_CBNFALIAS)
	AROTINA := ACLONE(AROTOLD)
	RETURN .F.
ENDIF 

OGRID01:LADJUSTCOLSIZE := .T.
OGRID01:SETARRAY(ACOLS01)
OGRID01:BLINE	:= {||	{	IIF(ACOLS01[OGRID01:NAT][1]="VERMELHO",OBMPVERM,IIF(ACOLS01[OGRID01:NAT][1]="VERDE",OBMPVERD,IIF(ACOLS01[OGRID01:NAT][1]="AZUL",OBMPAZUL,OBMPAMAR))),;
							ACOLS01[OGRID01:NAT][2],;
							ACOLS01[OGRID01:NAT][3],;
							ACOLS01[OGRID01:NAT][4],;
							ACOLS01[OGRID01:NAT][5],;
							ACOLS01[OGRID01:NAT][6],;
							ACOLS01[OGRID01:NAT][7],;
							ACOLS01[OGRID01:NAT][8];
						};
					}
OGRID01:BLDBLCLICK 	:= {|| MSGRUN("Analisando Pedidos de Venda","Processando...",{|| DADOSPV(OGRID01,OGRID02,@ACOLS02,OBMPVERM,OBMPVERD)}),MSGRUN("Analisando Pedidos de Compra","Processando...",{|| DADOSPC(OGRID01,OGRID03,@ACOLS03,OBMPVERM,OBMPVERD)})}
OGRID01:BDRAWSELECT 	:= {|| MSGRUN("Analisando Pedidos de Venda","Processando...",{|| DADOSPV(OGRID01,OGRID02,@ACOLS02,OBMPVERM,OBMPVERD)}),MSGRUN("Analisando Pedidos de Compra","Processando...",{|| DADOSPC(OGRID01,OGRID03,@ACOLS03,OBMPVERM,OBMPVERD)})}
OGRID01:BCHANGE		:= {|| MSGRUN("Analisando Pedidos de Venda","Processando...",{|| DADOSPV(OGRID01,OGRID02,@ACOLS02,OBMPVERM,OBMPVERD)}),MSGRUN("Analisando Pedidos de Compra","Processando...",{|| DADOSPC(OGRID01,OGRID03,@ACOLS03,OBMPVERM,OBMPVERD)})}
OGRID01:REFRESH()		

AADD(ACOLS02,{.F.,"","","","",""})
OGRID02:LADJUSTCOLSIZE := .T.
OGRID02:SETARRAY(ACOLS02)
OGRID02:BLINE	:= {||	{	IIF(ACOLS02[OGRID02:NAT][1],OBMPVERD,OBMPVERM),;
							ACOLS02[OGRID02:NAT][2],;
							ACOLS02[OGRID02:NAT][3],;
							ACOLS02[OGRID02:NAT][4],;
							ACOLS02[OGRID02:NAT][5],;
							ACOLS02[OGRID02:NAT][6];
						};
					}					

OGRID02:BLDBLCLICK := {|| MSGRUN("Abrindo Pedido de Venda","Processando...",{|| VERPEDVENDA(OGRID02)})}
OGRID02:REFRESH()

AADD(ACOLS03,{.F.,"","","","",""})
OGRID03:LADJUSTCOLSIZE := .T.
OGRID03:SETARRAY(ACOLS03)
OGRID03:BLINE	:= {||	{	IIF(ACOLS03[OGRID03:NAT][1],OBMPVERD,OBMPVERM),;
							ACOLS03[OGRID03:NAT][2],;
							ACOLS03[OGRID03:NAT][3],;
							ACOLS03[OGRID03:NAT][4],;
							ACOLS03[OGRID03:NAT][5],;
							ACOLS03[OGRID03:NAT][6];
						};
					}

OGRID03:BLDBLCLICK := {|| MSGRUN("Abrindo Pedido de Compra","Processando...",{|| VERPEDCOMPRA(OGRID03)})}
OGRID03:REFRESH()

ODLGBNF:ACTIVATE()
	
SETKEY(VK_F6,{||})
	
RETURN .T.

/*
=================================================================================
=================================================================================
||   Arquivo:	TFCOMBNF.prw
=================================================================================
||   Funcao: 	DADOSOP
=================================================================================
||   Descricao
||-------------------------------------------------------------------------------
|| 		Funcao para gerar dados para o primeiro Grid com Informações de 
|| 	Ordens de Produção para o Produto.
|| 
=================================================================================
=================================================================================
||   Autor:	Edson Hornberger  
||   Data:		07/01/2016
=================================================================================
=================================================================================
*/

STATIC FUNCTION DADOSOP(ACOLS01)

LOCAL CQUERY 		:= ""
LOCAL CSTATUS		:= ""
LOCAL NPRZOPBNF	:= GETMV("TF_PRZOPBN",.F.,45)
Local cCodigo		:= CDESCPRO

If SUBSTR(CDESCPRO,10,2)='IP'
	cCodigo		:= SUBSTR(CDESCPRO,1,11)
Else
	cCodigo		:= SUBSTR(CDESCPRO,1,9)
EndIf

IF SELECT("TRB") > 0 
	
	DBSELECTAREA("TRB")
	DBCLOSEAREA()
	
ENDIF 

CQUERY := "SELECT" 																		+ ENTER 
CQUERY += "	SC2.C2_NUM," 																+ ENTER  
CQUERY += "	SC2.C2_ITEM," 															+ ENTER 
CQUERY += "	SC2.C2_SEQUEN," 															+ ENTER 
CQUERY += "	SC2.C2_EMISSAO," 															+ ENTER 
CQUERY += "	SC2.C2_QUANT," 															+ ENTER 
CQUERY += "	(SC2.C2_QUANT - SC2.C2_QUJE - SC2.C2_PERDA) AS C2_SALDO," 			+ ENTER
CQUERY += "	DATEDIFF(DAY, CONVERT(DATETIME,SC2.C2_EMISSAO), CONVERT(DATETIME,'" + DTOS(DDATABASE) + "')) AS 'PRAZO'," + ENTER
CQUERY += "	(	SELECT TOP(1)" 														+ ENTER  
CQUERY += "			SD4.D4__QTBNFC / SG1.G1_QUANT" 									+ ENTER
CQUERY += "		FROM" 																	+ ENTER 
CQUERY += "			" + RETSQLNAME("SD4") + " SD4 " 								+ ENTER
CQUERY += "			INNER JOIN " + RETSQLNAME("SG1") + " SG1 ON" 					+ ENTER 
CQUERY += "				SG1.G1_FILIAL = '" + XFILIAL("SG1") + "' AND" 			+ ENTER 
CQUERY += "				SG1.G1_COD = SC2.C2_PRODUTO AND"							+ ENTER
CQUERY += "				SG1.G1_COMP = SD4.D4_COD AND" 								+ ENTER 
CQUERY += "				SG1.D_E_L_E_T_ = ''" 										+ ENTER
CQUERY += "		WHERE" 																+ ENTER 
CQUERY += "			SD4.D4_FILIAL = '" + XFILIAL("SD4") + "' AND" 				+ ENTER 
CQUERY += "			SD4.D4_OP = SC2.C2_NUM + SC2.C2_ITEM + SC2.C2_SEQUEN AND" 	+ ENTER 
CQUERY += "			SD4.D_E_L_E_T_ = ''" 											+ ENTER
CQUERY += "	) AS 'QTDPROCESSO'," 													+ ENTER  
CQUERY += "	SC2.C2__FORNEC"															+ ENTER
CQUERY += "FROM" 																			+ ENTER  
CQUERY += "	" + RETSQLNAME("SC2") + " SC2" 											+ ENTER 
CQUERY += "WHERE" 																		+ ENTER  
CQUERY += "	SC2.C2_FILIAL = '" + XFILIAL("SC2") + "' AND" 						+ ENTER  
CQUERY += "	SC2.C2_PRODUTO  = '" + ALLTRIM(cCodigo) + "' AND" 				+ ENTER  
CQUERY += "	(SC2.C2_QUANT - SC2.C2_QUJE - SC2.C2_PERDA) > 0 AND" 				+ ENTER  
CQUERY += "	SC2.C2_TPOP = 'F' AND" 													+ ENTER
CQUERY += "	SC2.C2_DATRF = '' AND"													+ ENTER  
//CQUERY += "	SC2.C2_SEQMRP = '' AND" 													+ ENTER  
CQUERY += "	SC2.C2_STATUS IN ('','N') AND" 												+ ENTER  
CQUERY += "	SC2.D_E_L_E_T_ = ''"														+ ENTER
CQUERY += "ORDER BY" 																	+ ENTER 
CQUERY += "	SC2.C2_NUM," 																+ ENTER 
CQUERY += "	SC2.C2_ITEM," 															+ ENTER 
CQUERY += "	SC2.C2_SEQUEN"

MEMOWRITE("TFCOMBNF_DADOSOP.SQL",CQUERY)
TCQUERY CQUERY NEW ALIAS "TRB"
TCSETFIELD("TRB","C2_EMISSAO","D")
DBSELECTAREA("TRB")
DBGOTOP()

ACOLS01 := {}

WHILE TRB->(!EOF())
	
	DO CASE 
	
		CASE TRB->PRAZO > NPRZOPBNF													// Status para OP com Prazo Vencido
			CSTATUS := "AMARELO"
		CASE TRB->QTDPROCESSO = 0													// Status para OP sem Processo Iniciado
			CSTATUS := "VERMELHO"
		CASE TRB->QTDPROCESSO = TRB->C2_QUANT											// Status para OP com Processo Iniciado
			CSTATUS := "VERDE"
		OTHERWISE																		// Status para OP com Processo Iniciado Parcialmente
			CSTATUS := "AZUL"
			
	ENDCASE
	
	AADD(ACOLS01,{CSTATUS,TRB->C2_NUM+TRB->C2_ITEM+TRB->C2_SEQUEN,TRB->C2_EMISSAO,TRB->C2_QUANT,TRB->C2_SALDO,TRB->PRAZO,((TRB->QTDPROCESSO/TRB->C2_QUANT) * 100),""})	
	TRB->(DBSKIP())
	
ENDDO

IF LEN(ACOLS01) <= 0 
	
	AADD(ACOLS01,{"","","","","","","",""})
	RETURN .F.
	
ENDIF

RETURN .T.

/*
=================================================================================
=================================================================================
||   Arquivo:	TFCOMBNF.prw
=================================================================================
||   Funcao: 	DADOSPV
=================================================================================
||   Descricao
||-------------------------------------------------------------------------------
|| 		Funcao para preenchimento do Grid de Pedidos de Venda referente a OP
|| 	onde foi clicado duas vezes com o botao esquerdo.
|| 
=================================================================================
=================================================================================
||   Autor:	Edson Hornberger 
||   Data:		08/01/2016		
=================================================================================
=================================================================================
*/

STATIC FUNCTION DADOSPV(OGRID1,OGRID2,ACOLS02,OBMPVERM,OBMPVERD)
	
LOCAL CQUERY := ""

IF SELECT("TRB") > 0
	
	DBSELECTAREA("TRB")
	DBCLOSEAREA()
	
ENDIF 

CQUERY := "SELECT" 															+ ENTER  
CQUERY += "	ISNULL((SELECT DISTINCT '.T.' FROM SD2040 SD2 WHERE SD2.D2_FILIAL = '02' AND SD2.D2_PEDIDO = SC6.C6_NUM AND SD2.D_E_L_E_T_ = ''),'.F.') AS NOTA," + ENTER 
CQUERY += "	SC6.C6_NUM," 													+ ENTER 
CQUERY += "	SC5.C5_EMISSAO," 												+ ENTER  
CQUERY += "	SC5.C5_CLIENTE," 												+ ENTER 
CQUERY += "	SC5.C5_LOJACLI," 												+ ENTER 
CQUERY += "	SA2.A2_NOME" 													+ ENTER 
CQUERY += "FROM" 																+ ENTER  
CQUERY += "	" + RETSQLNAME("SC6") + " SC6" 								+ ENTER 
CQUERY += "	INNER JOIN " + RETSQLNAME("SC5") + " SC5 ON" 				+ ENTER  
CQUERY += "		SC5.C5_FILIAL = SC6.C6_FILIAL AND" 					+ ENTER  
CQUERY += "		SC5.C5_NUM = SC6.C6_NUM AND" 							+ ENTER  
CQUERY += "		SC5.D_E_L_E_T_ = ''" 									+ ENTER  
CQUERY += "	INNER JOIN " + RETSQLNAME("SA2") + " SA2 ON" 				+ ENTER  
CQUERY += "		SA2.A2_FILIAL = '" + XFILIAL("SA2") + "' AND" 		+ ENTER  
CQUERY += "		SA2.A2_COD = SC5.C5_CLIENTE AND" 						+ ENTER  
CQUERY += "		SA2.A2_LOJA = SC5.C5_LOJACLI AND" 						+ ENTER  
CQUERY += "		SA2.D_E_L_E_T_ = ''" 									+ ENTER 
CQUERY += "WHERE" 															+ ENTER  
CQUERY += "	SC6.C6_FILIAL = '" + XFILIAL("SC6") + "' AND" 			+ ENTER 
CQUERY += "	RTRIM(SC6.C6__OPBNFC) = '" + OGRID1:AARRAY[OGRID1:NAT][2] + "' AND" 	+ ENTER 
CQUERY += "	SC6.D_E_L_E_T_ = ''" 										+ ENTER 
CQUERY += "GROUP BY" 														+ ENTER  
CQUERY += "	SC6.C6_NUM," 													+ ENTER 
CQUERY += "	SC5.C5_NUM," 													+ ENTER 
CQUERY += "	SC5.C5_EMISSAO," 												+ ENTER  
CQUERY += "	SC5.C5_CLIENTE," 												+ ENTER 
CQUERY += "	SC5.C5_LOJACLI," 												+ ENTER 
CQUERY += "	SA2.A2_NOME" 													+ ENTER 
CQUERY += "ORDER BY" 														+ ENTER  
CQUERY += "	SC5.C5_NUM"

TCQUERY CQUERY NEW ALIAS "TRB"
TCSETFIELD("TRB","C5_EMISSAO","D")
DBSELECTAREA("TRB")
DBGOTOP()

ACOLS02 := {}

WHILE TRB->(!EOF())
	
	AADD(ACOLS02,{&(TRB->NOTA),TRB->C6_NUM,TRB->C5_EMISSAO,TRB->C5_CLIENTE,TRB->C5_LOJACLI,TRB->A2_NOME})
	TRB->(DBSKIP())
	
ENDDO 
	
IF LEN(ACOLS02) <= 0 
	
	AADD(ACOLS02,{.F.,"","","","",""})
	
ENDIF 

OGRID2:SETARRAY(ACOLS02)
OGRID2:BLINE	:= {||	{	IIF(ACOLS02[OGRID2:NAT][1],OBMPVERD,OBMPVERM),;
							ACOLS02[OGRID2:NAT][2],;
							ACOLS02[OGRID2:NAT][3],;
							ACOLS02[OGRID2:NAT][4],;
							ACOLS02[OGRID2:NAT][5],;
							ACOLS02[OGRID2:NAT][6];
						};
					}
					
OGRID2:REFRESH()
OBTN_NFSA:REFRESH()
	
RETURN

/*
=================================================================================
=================================================================================
||   Arquivo:	TFCOMBNF.prw
=================================================================================
||   Funcao: 	INIPROC
=================================================================================
||   Descricao
||-------------------------------------------------------------------------------
|| 		Função para iniciar um processo de Beneficiamento. Será criado um Pedido 
|| 	de Venda para enviar MP´s para Beneficiamento ao Fornecedor, verificação se 
|| 	existe Pedido de Compra total da Mao de Obra, se não existir checa a existen-
|| 	cia de SO´s e gera com base nelas.
|| 
=================================================================================
=================================================================================
||   Autor:	Edson Hornberger
||   Data:		03/02/2016
=================================================================================
=================================================================================
*/

STATIC FUNCTION INIPROC(OGRID)

LOCAL ABOTOES 	:= {OEMTOANSI("Prosseguir"),OEMTOANSI("Cancela")}
LOCAL NRET			:= 0
LOCAL CMSG			:= ""
LOCAL CTIT			:= OEMTOANSI("Geração de Proc. Beneficiamento")
LOCAL CNUMOP		:= ""

CMSG	:= 	ENTER + OEMTOANSI("Este processo irá gerar um Pedido de Venda para envio de Produto") + ;
			ENTER + OEMTOANSI("destinado a Beneficiamento. Será criado Pedido de Compra referente") + ;
			ENTER + OEMTOANSI("a Mão de Obra total referente a Ordem de Produção, caso não exista.") + ;
			ENTER + OEMTOANSI("Pode ser utilizado Solicitações de Compra para geração do Pedido de") + ;
			ENTER + OEMTOANSI("Compra.")
			
NRET := AVISO(CTIT,CMSG,ABOTOES,3,OEMTOANSI("   ATENÇÃO") + ENTER + ENTER ,,"AVN_A3_ALERT",.F.,15000,2)

IF NRET = 2
	
	MESSAGEBOX("Processo Cancelado pelo Operador!","ATENÇÃO",64)
	RETURN .F.
	
ENDIF 

CURSORWAIT()

CNUMOP := OGRID:AARRAY[OGRID:NAT][2] 								// Número da OP

/*
|---------------------------------------------------------------------------------
|	Inicia o Processo verificando se há Pedido de Compra para OP posicionada.
|---------------------------------------------------------------------------------
*/
PROCESSA({|| GERAPDCOM(CNUMOP)},"Verificando Pedido de Compra","Aguarde...",.F.)
/*
|---------------------------------------------------------------------------------
|	Gera o Pedido de Venda para envio de MP´s para Beneficiamento.
|---------------------------------------------------------------------------------
*/
PROCESSA({|| GERAPDVEN(CNUMOP)},"Gerando Pedido de Venda","Aguarde...",.F.)

IF !DADOSOP(@ACOLS01)
	MESSAGEBOX("Não há dados de Gestão de Beneficamento para o" + ENTER + "Produto " + ALLTRIM(SB1->B1_COD) + " - " + ALLTRIM(SB1->B1_DESC) + "!","ATENÇÃO",16)
	RETURN .F.
ENDIF 

OGRID01:LADJUSTCOLSIZE := .T.
OGRID01:SETARRAY(ACOLS01)
OGRID01:BLINE	:= {||	{	IIF(ACOLS01[OGRID01:NAT][1]="VERMELHO",OBMPVERM,IIF(ACOLS01[OGRID01:NAT][1]="VERDE",OBMPVERD,IIF(ACOLS01[OGRID01:NAT][1]="AZUL",OBMPAZUL,OBMPAMAR))),;
							ACOLS01[OGRID01:NAT][2],;
							ACOLS01[OGRID01:NAT][3],;
							ACOLS01[OGRID01:NAT][4],;
							ACOLS01[OGRID01:NAT][5],;
							ACOLS01[OGRID01:NAT][6],;
							ACOLS01[OGRID01:NAT][7],;
							ACOLS01[OGRID01:NAT][8];
						};
					}
OGRID01:REFRESH()

MSGRUN("Analisando Pedidos de Venda","Processando...",{|| DADOSPV(OGRID01,OGRID02,@ACOLS02,OBMPVERM,OBMPVERD)})
MSGRUN("Analisando Pedidos de Compra","Processando...",{|| DADOSPC(OGRID01,OGRID03,@ACOLS03,OBMPVERM,OBMPVERD)})

CURSORARROW()
SETKEY(VK_F6,{|| VEREMPENHOS(OGRID01)})

MESSAGEBOX("Processo Finalizado!","ATENÇÃO",64)

RETURN

/*
=================================================================================
=================================================================================
||   Arquivo:	TFCOMBNF.prw
=================================================================================
||   Funcao: 	GERAPDCOM
=================================================================================
||   Descricao
||-------------------------------------------------------------------------------
|| 		Análise e/ou geração de Pedido de Compra para Mão de Obra de Beneficia-
|| 	mento.
|| 
=================================================================================
=================================================================================
||   Autor:	Edson Hornberger 
||   Data:		03/02/2016
=================================================================================
=================================================================================
*/

STATIC FUNCTION GERAPDCOM(CNUMOP)
	
LOCAL CQUERY 	:= ""
LOCAL NREG		:= 0
LOCAL ACAB		:= {} 
LOCAL AITENS	:= {}
LOCAL ALINHA	:= {}
LOCAL CCODTAB	:= ALLTRIM(GETMV("MV_TABPEDC",.F.,"002"))
LOCAL CCLASSPED 	:= ALLTRIM(GETMV("MV_CLPEDC"))
LOCAL NQTDPED	:= 0
LOCAL CNUMPED	:= "" 
LOCAL CITEPED	:= STRZERO(0,TAMSX3("C7_ITEM")[1])
LOCAL NVLRUNIT:= 0
LOCAL AAREA	:= GETAREA()
LOCAL LCONT	:= .T.
LOCAL CERROS	:= ""

PRIVATE LMSHELPAUTO := .T.
PRIVATE LMSERROAUTO := .F.

IF SELECT("T001") > 0 
	
	DBSELECTAREA("T001")
	DBCLOSEAREA()
	
ENDIF

/*
|---------------------------------------------------------------------------------
|	Verificando quantidade total de Itens empenhados para a OP selecionada. 
|---------------------------------------------------------------------------------
*/
CQUERY := "SELECT" 													+ ENTER  
CQUERY += "	SD4.D4_COD," 											+ ENTER 	
CQUERY += "	(SD4.D4_QTDEORI - SD4.D4__QTPCBN) AS D4_QUANT," 	+ ENTER
CQUERY += "	SD4.D4_LOCAL," 										+ ENTER
CQUERY += "	SB1.B1_DESC," 										+ ENTER
CQUERY += "	SB1.B1_ITEMCC" 										+ ENTER 
CQUERY += "FROM" 														+ ENTER  
CQUERY += "	" + RETSQLNAME("SD4") + " SD4" 						+ ENTER  
CQUERY += "	INNER JOIN " + RETSQLNAME("SB1") + " SB1 ON" 		+ ENTER  
CQUERY += "		SB1.B1_FILIAL = '" + XFILIAL("SB1") + "' AND"	+ ENTER  
CQUERY += "		SB1.B1_COD = SD4.D4_COD AND" 					+ ENTER  
CQUERY += "		SB1.B1_TIPO NOT IN ('MP','BN') AND" 			+ ENTER  
CQUERY += "		SB1.D_E_L_E_T_ = ''" 							+ ENTER
CQUERY += "	LEFT OUTER JOIN " + RETSQLNAME("SC7") + " SC7 ON"+ ENTER
CQUERY += "		SC7.C7_FILIAL = '" + XFILIAL("SC7") + "' AND"	+ ENTER 
CQUERY += "		SC7.C7_PRODUTO =  SD4.D4_COD AND" 				+ ENTER
CQUERY += "		SC7.C7__OPBNFC = '" + CNUMOP + "' AND" 		+ ENTER
CQUERY += "		SC7.D_E_L_E_T_ = ''" 							+ ENTER 
CQUERY += "WHERE" 													+ ENTER 
CQUERY += "	SD4.D4_FILIAL = '" + XFILIAL("SD4") + "' AND" 	+ ENTER  
CQUERY += "	SD4.D4_OP = '" + CNUMOP + "' AND" 					+ ENTER  
CQUERY += "	SD4.D4__QTPCBN < SD4.D4_QTDEORI AND" 				+ ENTER  
CQUERY += "	SD4.D_E_L_E_T_ = ''"
	
TCQUERY CQUERY NEW ALIAS "T001"
DBSELECTAREA("T001")
DBGOTOP()
COUNT TO NREG

/*
|---------------------------------------------------------------------------------
|	Caso exista saldo a atender os Empenhos inicia processo, senao sai  
|---------------------------------------------------------------------------------
*/
IF NREG <= 0 
	MESSAGEBOX("Não existem itens para gerar Pedido de Compra para OP " + CNUMOP + "!","ATENÇÃO",16)
	RETURN .F.	
ENDIF 

PROCREGUA(NREG)

DBSELECTAREA("SC2")
DBSETORDER(1)
DBSEEK(XFILIAL("SC2") + CNUMOP)

/*
|---------------------------------------------------------------------------------
|	Se os campos C2__FORNEC E C2__LOJAFO não estiverem preenchidos sai do processo
|---------------------------------------------------------------------------------
*/
IF EMPTY(ALLTRIM(C2__FORNEC)) .OR. EMPTY(ALLTRIM(C2__LOJAFO))
	
	MESSAGEBOX("Campo de Código e Loja do Fornecedor na OP não estão preenchidos!","ATENÇÃO",16)
	RETURN .F.
	
ENDIF

/*
|---------------------------------------------------------------------------------
|	Verifica se existe tabela de Preco para este Fornecedor
|---------------------------------------------------------------------------------
*/
DBSELECTAREA("AIA")
DBSETORDER(1)
IF !DBSEEK(XFILIAL("AIA") + SC2->C2__FORNEC + SC2->C2__LOJAFO + CCODTAB)
		
	DBSELECTAREA("SA2")
	DBSETORDER(1)
	DBSEEK(XFILIAL("SA2") + SC2->C2__FORNEC + SC2->C2__LOJAFO)
	MsgStop("Não existe Tabela de Preço " + CCODTAB + " para o Fornecedor " + SA2->A2_COD + "/" + SA2->A2_LOJA + " - " + ALLTRIM(SA2->A2_NOME),"TFCOMBNF")
	RETURN .F.

ENDIF
				
CNUMPED := CRIAVAR("C7_NUM",.T.) // Inicia variável verificando e executando o Inicializador Padrão do mesmo

// Array com dados do Cabeçalho do Pedido a ser criado
AADD(ACAB,{"C7_NUM"		,CNUMPED						,NIL})	
AADD(ACAB,{"C7_EMISSAO"	,CRIAVAR("C7_EMISSAO", .T.)	,NIL})
AADD(ACAB,{"C7_FORNECE"	,SC2->C2__FORNEC				,NIL})
AADD(ACAB,{"C7_LOJA"		,SC2->C2__LOJAFO				,NIL})
AADD(ACAB,{"C7_COND"		,IIF(EMPTY(ALLTRIM(AIA->AIA_CONDPG)),SA2->A2_COND,AIA->AIA_CONDPG)		,NIL})
AADD(ACAB,{"C7_CONTATO"	,CRIAVAR("C7_CONTATO", .T.)	,NIL})
AADD(ACAB,{"C7_FILENT"	,CRIAVAR("C7_FILENT", .T.)	,NIL})
AADD(ACAB,{"C7__OPBNFC"	,CNUMOP						,NIL})

T001->(DBGOTOP())
CERROS := "Não existe Preço cadastrado para os Produtos:" + ENTER

WHILE T001->(!EOF())
	
	INCPROC()
	NQTDPED 	:= T001->D4_QUANT
	NVLRUNIT 	:= MATABPRCOM(CCODTAB,T001->D4_COD,1,SC2->C2__FORNEC,SC2->C2__LOJAFO)
	CITEPED 	:= SOMA1(CITEPED,LEN(CITEPED))
	
	/*
	|---------------------------------------------------------------------------------
	|	Se preço do produto não estiver cadastrado sai do processo
	|---------------------------------------------------------------------------------
	*/
	IF NVLRUNIT <= 0 
		
		CERROS += ENTER + ALLTRIM(T001->D4_COD) + " - " + ALLTRIM(T001->B1_DESC)
		LCONT := .F.
		
	ENDIF 
	
	/*
	|---------------------------------------------------------------------------------
	|	Verifica se existem Solicitações de Compra para os itens
	|---------------------------------------------------------------------------------
	*/
	DBSELECTAREA("SC1")
	CQUERY := "SELECT" 													+ ENTER 
	CQUERY += "	SC1.C1_NUM," 											+ ENTER 
	CQUERY += "	SC1.C1_ITEM," 										+ ENTER 
	CQUERY += "	SC1.C1_QUANT," 										+ ENTER
	CQUERY += "	SC1.C1_QUJE," 										+ ENTER
	CQUERY += "	(SC1.C1_QUANT - SC1.C1_QUJE) AS C1_SALDO,"		+ ENTER
	CQUERY += "	SC1.C1_LOCAL,"										+ ENTER
	CQUERY += "	SC1.C1_DATPRF,"										+ ENTER
	CQUERY += "	SC1.C1_DTVALID,"										+ ENTER 
	CQUERY += "	SC1.C1_EMISSAO,"										+ ENTER
	CQUERY += "	SC1.C1_ITEMCTA"										+ ENTER
	CQUERY += "FROM" 														+ ENTER
	CQUERY += "	" + RETSQLNAME("SC1") + " SC1" 						+ ENTER 
	CQUERY += "WHERE" 													+ ENTER 
	CQUERY += "	SC1.C1_FILIAL = '" + XFILIAL("SC1") + "' AND" 	+ ENTER 
	CQUERY += "	SC1.C1_PRODUTO = '" + T001->D4_COD + "' AND" 		+ ENTER 
	CQUERY += "	(SC1.C1_QUANT - SC1.C1_QUJE) > 0 AND" 				+ ENTER 
	CQUERY += "	SC1.C1_ACCPROC <> '1' AND" 							+ ENTER 
	CQUERY += "	SC1.C1_TPSC <> '2' AND" 								+ ENTER 
	CQUERY += "	SC1.C1_TPOP <> 'P' AND" 								+ ENTER 
	CQUERY += "	SC1.C1_APROV IN(' ','L') AND" 						+ ENTER 
	CQUERY += "	(SC1.C1_COTACAO = '" + SPACE(LEN(C1_COTACAO)) + "' OR SC1.C1_COTACAO = '" + REPLICATE("X",LEN(C1_COTACAO)) + "') AND" + ENTER 
	CQUERY += "	SC1.C1_FLAGGCT <> '1' AND" 							+ ENTER  
	CQUERY += "	SC1.D_E_L_E_T_ = ''"
	
	IF SELECT("T002") > 0 
		DBSELECTAREA("T002")
		DBCLOSEAREA()		
	ENDIF 
	
	TCQUERY CQUERY NEW ALIAS "T002"
	DBSELECTAREA("T002")
	DBGOTOP()
	COUNT TO NREG	
	
	/*
	|---------------------------------------------------------------------------------
	|	Com solicitações de compra
	|---------------------------------------------------------------------------------
	*/
	IF NREG > 0 .AND. LCONT
		
		DBGOTOP()		
		WHILE T002->(!EOF()) .AND. NQTDPED > 0  
			
			ALINHA := {}
			AADD(ALINHA,{"C7_NUM"    	, CNUMPED          	, NIL})
			AADD(ALINHA,{"C7_ITEM"   	, CITEPED 	     		, NIL})
			AADD(ALINHA,{"C7_PRODUTO"	, T001->D4_COD		, NIL})
			IF T002->C1_SALDO > NQTDPED
				
				AADD(ALINHA,{"C7_QUANT"		, NQTDPED		, NIL})
				NQTDPED -= NQTDPED
				
			ELSE
			
				AADD(ALINHA,{"C7_QUANT"		, T002->C1_SALDO		, NIL})
				NQTDPED -= T002->C1_SALDO
				IF NQTDPED > 0 
					CITEPED 	:= SOMA1(CITEPED,LEN(CITEPED))
				ENDIF
			
			ENDIF			
			AADD(ALINHA,{"C7_CLASCON"	, CCLASSPED        	, NIL})								
			AADD(ALINHA,{"C7_PRECO"  	, NVLRUNIT         	, NIL})
			AADD(ALINHA,{"C7_CODTAB" 	, CCODTAB				, NIL})
			AADD(ALINHA,{"C7_LOCAL"  	, "31"  				, NIL})
			AADD(ALINHA,{"C7_NUMSC"  	, T002->C1_NUM    	, NIL})
			AADD(ALINHA,{"C7_ITEMSC" 	, T002->C1_ITEM   	, NIL})
			AADD(ALINHA,{"C7_DTENTRG"	, T002->C1_DATPRF 	, NIL}) 
			AADD(ALINHA,{"C7_DTVALID"	, T002->C1_DTVALID	, NIL})
			AADD(ALINHA,{"C7_EMISSSC"	, T002->C1_EMISSAO	, NIL})
			AADD(ALINHA,{"C7_ITEMCTA"	, T002->C1_ITEMCTA	, NIL})
			AADD(ALINHA,{"C7__OPBNFC"	, CNUMOP				, NIL})
			AADD(AITENS,ALINHA)
			
			T002->(DBSKIP())
			
		ENDDO
		
		/*
		|---------------------------------------------------------------------------------
		|	Caso ainda existe saldo para o item, mas nao exista mais SC, deve gerar um
		|	registro com este Saldo
		|---------------------------------------------------------------------------------
		*/
		IF NQTDPED > 0 .AND. LCONT
			
			ALINHA := {}
			AADD(ALINHA,{"C7_NUM"    	, CNUMPED          	, NIL})
			AADD(ALINHA,{"C7_ITEM"   	, CITEPED 	    	 	, NIL})
			AADD(ALINHA,{"C7_PRODUTO"	, T001->D4_COD		, NIL})
			AADD(ALINHA,{"C7_QUANT"		, NQTDPED				, NIL})			
			AADD(ALINHA,{"C7_CLASCON"	, CCLASSPED        	, NIL})								
			AADD(ALINHA,{"C7_PRECO"  	, NVLRUNIT         	, NIL})
			AADD(ALINHA,{"C7_CODTAB" 	, CCODTAB				, NIL})
			AADD(ALINHA,{"C7_LOCAL" 		, "31"  				, NIL})				
			AADD(ALINHA,{"C7_ITEMCTA"	, T001->B1_ITEMCC		, NIL})
			AADD(ALINHA,{"C7__OPBNFC"	, CNUMOP				, NIL})
			AADD(AITENS,ALINHA)
			NQTDPED := 0 
			
		ENDIF
		
	/*
	|---------------------------------------------------------------------------------
	|	Sem solicitações de compra
	|---------------------------------------------------------------------------------
	*/
	ELSE  
			
		ALINHA := {}
		AADD(ALINHA,{"C7_NUM"    	, CNUMPED          	, NIL})
		AADD(ALINHA,{"C7_ITEM"   	, CITEPED 	    	 	, NIL})
		AADD(ALINHA,{"C7_PRODUTO"	, T001->D4_COD		, NIL})
		AADD(ALINHA,{"C7_QUANT"		, NQTDPED				, NIL})			
		AADD(ALINHA,{"C7_CLASCON"	, CCLASSPED        	, NIL})								
		AADD(ALINHA,{"C7_PRECO"  	, NVLRUNIT         	, NIL})
		AADD(ALINHA,{"C7_CODTAB" 	, CCODTAB				, NIL})
		AADD(ALINHA,{"C7_LOCAL" 		, "31"  				, NIL})				
		AADD(ALINHA,{"C7_ITEMCTA"	, T001->B1_ITEMCC		, NIL})
		AADD(ALINHA,{"C7__OPBNFC"	, CNUMOP				, NIL})
		AADD(AITENS,ALINHA)
			
	ENDIF
	
	T001->(DBSKIP())
	
ENDDO

/*
|---------------------------------------------------------------------------------
|	Executa o ExecAuto para Gerar o Pedido de Compra 
|---------------------------------------------------------------------------------
*/

IF LEN(AITENS) > 0 .AND. LCONT 
	
	BEGIN TRANSACTION 
		
		//                                       |PEDIDO OU AUTORIZACAO  |CAB.PEDIDO   |ITENS PEDIDO	  |3-INCLUSAO 4-ALTERACAO 5-EXCLUSAO
		MSEXECAUTO({|V,X,Y,Z| MATA120(V,X,Y,Z)}, 1						, ACAB			, AITENS			, 3)
						
		IF LMSERROAUTO
			MOSTRAERRO()
			DISARMTRANSACTION()
		ENDIF 
		
	END TRANSACTION 

ELSE 
	
	/*
	|---------------------------------------------------------------------------------
	|	Apresenta os itens que não tem Tabela de Preço cadastradas
	|---------------------------------------------------------------------------------
	*/
	IF !LCONT
	
		DBSELECTAREA("SA2")
		DBSETORDER(1)
		DBSEEK(XFILIAL("SA2") + SC2->C2__FORNEC + SC2->C2__LOJAFO)
		XMAGHELPFIS("Problemas na Geração do Pedido", CERROS, "Realizar manutenção na Tabela de Preço " + CCODTAB + ENTER + "para os produtos, acima informados, do Fornecedor" + ENTER + SA2->A2_COD + "/" + SA2->A2_LOJA + " - " + ALLTRIM(SA2->A2_NOME))
		
	ENDIF 

ENDIF 

RESTAREA(AAREA)

RETURN .T.

/*
=================================================================================
=================================================================================
||   Arquivo:	TFCOMBNF.prw
=================================================================================
||   Funcao: 	GERAPDVEN
=================================================================================
||   Descricao
||-------------------------------------------------------------------------------
||		Funcao que irá gerar Pedido de Venda para Beneficiamento conforme quanti-   		
|| 	dade informada pelo usuário e saldo disponível.
|| 
=================================================================================
=================================================================================
||   Autor:	Edson Hornberger 
||   Data:		04/02/2016
=================================================================================
=================================================================================
*/

STATIC FUNCTION GERAPDVEN(CNUMOP)

LOCAL APARAMB	:= {}
LOCAL CTITULO	:= "Envio para Beneficiamento"
LOCAL ARESP	:= {}
LOCAL AAREA	:= GETAREA()
LOCAL ACAB		:= {}
LOCAL AITENS	:= {}
LOCAL AAUX		:= {}
LOCAL ATMP		:= {}
LOCAL CQUERY	:= ""
LOCAL NPRCVEN	:= 0
LOCAL NREG		:= 0
LOCAL CITEM	:= STRZERO(0,TAMSX3("C6_ITEM")[1])
	
PRIVATE LCREDITO 	:= .T.
PRIVATE LESTOQUE	:= .T.
PRIVATE LLIBER		:= .T.
PRIVATE LTRANSF		:= .T.
PRIVATE LAVEST		:= IIF(GETMV("MV_ESTNEG")="S",.F.,.T.)
PRIVATE LMSHELPAUTO := .T.
PRIVATE LMSERROAUTO := .F.

/*
|---------------------------------------------------------------------------------
|	Inicia verificando se campos de código de Fornecedor/Loja estejam preenchidos 
|	na OP posicionada
|---------------------------------------------------------------------------------
*/
DBSELECTAREA("SC2")
DBSETORDER(1)
DBSEEK(XFILIAL("SC2") + CNUMOP)

IF EMPTY(ALLTRIM(SC2->C2__FORNEC)) .OR. EMPTY(ALLTRIM(SC2->C2__LOJAFO))
	
	MESSAGEBOX("Campo de Código e Loja do Fornecedor na OP não estão preenchidos!","ATENÇÃO",16)
	RETURN .F.
	
ENDIF

/*
|---------------------------------------------------------------------------------
|	Verifica se existe estrutura cadastrada para o Produto
|---------------------------------------------------------------------------------
*/
DBSELECTAREA("SG1")
DBSETORDER(1)
IF !DBSEEK(XFILIAL("SG1") + SC2->C2_PRODUTO)
	
	MESSAGEBOX("Produto sem Estrutura cadastrada!","ATENÇÃO",16)
	RETURN .F.
	
ENDIF

/*
|---------------------------------------------------------------------------------
|	Realiza cálculo para saber qual a quantidade (saldo) da OP que ainda não tem 
|	processo iniciado.
|---------------------------------------------------------------------------------
*/
IF SELECT("T003") > 0 
	DBSELECTAREA("T003")
	DBCLOSEAREA()	
ENDIF

CQUERY := "SELECT TOP(1)" 														+ ENTER 
CQUERY += "	SG1.G1_COD," 														+ ENTER  				
CQUERY += "	(SD4.D4_QTDEORI - SD4.D4__QTBNFC) / G1_QUANT AS G1_QUANT" 	+ ENTER 
CQUERY += "FROM" 																	+ ENTER  												
CQUERY += "	" + RETSQLNAME("SG1") + " SG1" 									+ ENTER 
CQUERY += "	INNER JOIN " + RETSQLNAME("SB1") + " SB1 ON" 					+ ENTER 	
CQUERY += "		B1_FILIAL = '" + XFILIAL("SB1") + "' AND" 				+ ENTER 	
CQUERY += "		B1_COD = G1_COMP AND" 										+ ENTER  						
CQUERY += "		B1_TIPO = 'MP' AND" 											+ ENTER  						
CQUERY += "		SB1.D_E_L_E_T_ = ''" 										+ ENTER  
CQUERY += "	LEFT OUTER JOIN " + RETSQLNAME("SD4") + " SD4 ON" 			+ ENTER  
CQUERY += "		D4_FILIAL = '" + XFILIAL("SD4") + "' AND" 				+ ENTER  
CQUERY += "		D4_COD = B1_COD AND" 										+ ENTER  
CQUERY += "		D4_OP = '" + CNUMOP + "' AND" 								+ ENTER  
CQUERY += "		SD4.D_E_L_E_T_ = ''" 										+ ENTER 						
CQUERY += "WHERE" 																+ ENTER  												
CQUERY += "	G1_FILIAL = '" + XFILIAL("SG1") + "' AND" 					+ ENTER  		
CQUERY += "	G1_COD = '" + SC2->C2_PRODUTO + "' AND" 						+ ENTER 			
CQUERY += "	SG1.D_E_L_E_T_ = ''" 											+ ENTER 
CQUERY += "GROUP BY" 															+ ENTER  
CQUERY += "	G1_COD," 															+ ENTER 
CQUERY += "	D4_QTDEORI," 														+ ENTER 
CQUERY += "	D4__QTBNFC," 														+ ENTER 
CQUERY += "	G1_QUANT" 															+ ENTER 
CQUERY += "HAVING" 																+ ENTER  
CQUERY += "	(SD4.D4_QTDEORI - SD4.D4__QTBNFC) > 0 AND"						+ ENTER 
CQUERY += "	((SD4.D4_QTDEORI - SD4.D4__QTBNFC) / G1_QUANT) > 0"

MEMOWRITE("TFCOMBNF_GERAPDVEN_I.SQL",CQUERY)

TCQUERY CQUERY NEW ALIAS "T003"
DBSELECTAREA("T003")
DBGOTOP()
COUNT TO NREG
IF NREG <= 0
	
	MESSAGEBOX("Sem saldo para iniciar novo Processo!","ATENÇÃO",64)
	RETURN .F.
	
ENDIF 
DBGOTOP()

/*
|---------------------------------------------------------------------------------
|	Abre tela de parâmetros para que seja informado a quantidade a ser gerada
|---------------------------------------------------------------------------------
*/
AADD(APARAMB,{01,"Qtd. a ser enviada"	,T003->G1_QUANT	,"@E 999,999,999.99",,,,,.T.})
AADD(APARAMB,{11,"Observações"			,SPACE(800)		,,,.F.})

IF !PARAMBOX(APARAMB,@CTITULO,@ARESP)
	
	MESSAGEBOX("Operação Cancelada pelo Usuário!","ATENÇÃO",64)
	RETURN .F.

ELSE

	IF ARESP[1] <= 0 .OR. ARESP[1] > T003->G1_QUANT 
		
		MESSAGEBOX("Quantidade informada inválida (" + CVALTOCHAR(ARESP[1]) + ")!","ATENÇÃO",16)
		RETURN .F.
		
	ENDIF 
	
ENDIF

/*
|---------------------------------------------------------------------------------
|	Inicia a montagem dos dados para geração do Pedido de Venda
|---------------------------------------------------------------------------------
*/
AADD(ACAB,{"C5_TIPO"		,"B"					,NIL})
AADD(ACAB,{"C5_CLIENTE"	,SC2->C2__FORNEC		,NIL})
AADD(ACAB,{"C5_LOJACLI"	,SC2->C2__LOJAFO		,NIL})
AADD(ACAB,{"C5_CLIENT"	,SC2->C2__FORNEC    	,NIL})
AADD(ACAB,{"C5_LOJAENT"	,SC2->C2__LOJAFO		,NIL})
AADD(ACAB,{"C5_EMISSAO"	,DDATABASE				,NIL})
AADD(ACAB,{"C5_TPFRETE"	,"C"					,NIL})
AADD(ACAB,{"C5_FINALID"	,"1"					,NIL})
AADD(ACAB,{"C5_INTER"  	,"N"					,NIL})
AADD(ACAB,{"C5_CLASPED"	,"B"					,NIL})
AADD(ACAB,{"C5_OBSERVA"	,"REMESSA DE MATERIAL P/ INDUSTRIALIZAÇÃO CONFORME O.P.: " + CNUMOP + ENTER + ALLTRIM(ARESP[2])	,NIL})
AADD(ACAB,{"C5_MENNOTA"	,"REMESSA DE MATERIAL P/ INDUSTRIALIZAÇÃO CONFORME O.P.: " + CNUMOP	,NIL})
AADD(ACAB,{"C5_XLIBCR"	,"L"					,NIL})
AADD(ACAB,{"C5_XITEMC"	,"TAIFF"				,NIL})

IF SELECT("T003") > 0 
	DBSELECTAREA("T003")
	DBCLOSEAREA()	
ENDIF

CQUERY := "SELECT" 												+ ENTER 
CQUERY += "	SG1.G1_COMP," 									+ ENTER
CQUERY += "	(SG1.G1_QUANT *  " + CVALTOCHAR(ARESP[1]) + ")  AS G1_QUANT," 	+ ENTER
CQUERY += "	SB1.B1_DESC," 									+ ENTER 
CQUERY += "	SB1.B1_UM" 										+ ENTER 
CQUERY += "FROM" 													+ ENTER 
CQUERY += "	" + RETSQLNAME("SG1") + " SG1" 					+ ENTER
CQUERY += "	INNER JOIN " + RETSQLNAME("SB1") + " SB1 ON"	+ ENTER
CQUERY += "		B1_FILIAL = '" + XFILIAL("SB1") + "' AND"	+ ENTER 
CQUERY += "		B1_COD = G1_COMP AND" 						+ ENTER 
CQUERY += "		B1_TIPO NOT IN ('MO','MA') AND"				+ ENTER 
CQUERY += "		SB1.D_E_L_E_T_ = ''" 						+ ENTER
CQUERY += "	LEFT OUTER JOIN " + RETSQLNAME("SD4") + " SD4 ON" + ENTER  
CQUERY += "		D4_FILIAL = '" + XFILIAL("SD4") + "' AND"	+ ENTER 
CQUERY += "		D4_COD = B1_COD AND" 						+ ENTER  
CQUERY += "		D4_OP = '" + CNUMOP + "' AND" 				+ ENTER  
CQUERY += "		SD4.D_E_L_E_T_ = ''" 						+ ENTER 						
CQUERY += "WHERE" 												+ ENTER 
CQUERY += "	G1_FILIAL = '" + XFILIAL("SG1") + "' AND" 	+ ENTER 
CQUERY += "	G1_COD = '" + SC2->C2_PRODUTO + "' AND" 		+ ENTER 
CQUERY += "	SG1.D_E_L_E_T_ = ''" 							+ ENTER
CQUERY += "GROUP BY" 											+ ENTER 
CQUERY += "	G1_COMP," 											+ ENTER
CQUERY += "	B1_DESC," 											+ ENTER 
CQUERY += "	B1_UM," 											+ ENTER 
CQUERY += "	D4_QTDEORI," 										+ ENTER
CQUERY += "	D4__QTBNFC," 										+ ENTER
CQUERY += "	G1_QUANT" 											+ ENTER
CQUERY += "HAVING" 												+ ENTER 
CQUERY += "	(SD4.D4_QTDEORI - SD4.D4__QTBNFC) > 0 AND"		+ ENTER
CQUERY += "	(SG1.G1_QUANT *  " + CVALTOCHAR(ARESP[1]) + ") > 0"

MEMOWRITE("TFCOMBNF_GERAPDVEN_II.SQL",CQUERY)

TCQUERY CQUERY NEW ALIAS "T003"
DBSELECTAREA("T003")
DBGOTOP()

COUNT TO NREG

IF NREG <= 0 
	
	MESSAGEBOX("Sem saldo para Beneficiamento!","ATENÇÃO",16)
	RETURN .F. 
	
ENDIF 

DBGOTOP()

WHILE T003->(!EOF())
	
	AAUX 	:= {}
	ATMP	:= {}
	CITEM 	:= SOMA1(CITEM,LEN(CITEM))
	
	/*
	|---------------------------------------------------------------------------------
	|	Verifica o valor que está cadastrado na Tabela de Preço de Compra
	|	Se não houver pega o valor de última compra no Cadastro do Produto
	|---------------------------------------------------------------------------------
	*/
	CQUERY := "SELECT" 														+ ENTER  
	CQUERY += "	AIB.AIB_PRCCOM" 											+ ENTER  
	CQUERY += "FROM" 															+ ENTER  
	CQUERY += "	" + RETSQLNAME("AIB") + " AIB" 							+ ENTER  
	CQUERY += "WHERE" 														+ ENTER  
	CQUERY += "	AIB.AIB_FILIAL = '" + XFILIAL("AIB") + "' AND" 		+ ENTER  
	CQUERY += "	AIB.AIB_CODPRO = '" + T003->G1_COMP + "' AND" 		+ ENTER  
	CQUERY += "	AIB.AIB_CODFOR = '" + SC2->C2__FORNEC + "' AND" 		+ ENTER  
	CQUERY += "	AIB.AIB_LOJFOR = '" + SC2->C2__LOJAFO + "' AND" 		+ ENTER  
	CQUERY += "	AIB.AIB_DATVIG <= '" + DTOS(DDATABASE) + "' AND" 	+ ENTER  
	CQUERY += "	AIB.D_E_L_E_T_= ''"
	
	IF SELECT("T004") > 0 
		DBSELECTAREA("T004")
		DBCLOSEAREA()
	ENDIF 
	
	TCQUERY CQUERY NEW ALIAS "T004" 
	DBSELECTAREA("T004")
	DBGOTOP()
	COUNT TO NREG
	
	IF NREG <= 0 
		
		CQUERY := "SELECT" 													+ ENTER  
		CQUERY += "	SB1.B1_UPRC" 											+ ENTER  
		CQUERY += "FROM" 														+ ENTER  
		CQUERY += "	" + RETSQLNAME("SB1") + " SB1" 						+ ENTER  
		CQUERY += "WHERE" 													+ ENTER  
		CQUERY += "	SB1.B1_FILIAL = '" + XFILIAL("SB1") + "' AND" 	+ ENTER  
		CQUERY += "	SB1.B1_COD = '" + T003->G1_COMP + "' AND" 		+ ENTER  
		CQUERY += "	SB1.D_E_L_E_T_= ''"
		
		DBSELECTAREA("T004")
		DBCLOSEAREA()
				
		TCQUERY CQUERY NEW ALIAS "T004" 
		DBSELECTAREA("T004")
		DBGOTOP()

				
		NPRCVEN := a410Arred(T004->B1_UPRC,"C6_VALOR")
		If T004->B1_UPRC != 0
			NPRCVEN := Iif(NPRCVEN=0,0.01,NPRCVEN )
		EndIf
		
	ELSE 
		
		DBGOTOP()
		NPRCVEN := a410Arred(T004->AIB_PRCCOM,"C6_VALOR")
		If T004->AIB_PRCCOM != 0
			NPRCVEN := Iif(NPRCVEN=0,0.01,NPRCVEN )
		EndIf
		
	ENDIF 
	
	CTES 	:= MATESINT(2,"16",SC2->C2__FORNEC,SC2->C2__LOJAFO,"F",PADR(T003->G1_COMP,15))
	NTOTAL	:= A410ARRED(T003->G1_QUANT * NPRCVEN,"C6_VALOR")
	
	AADD(AAUX,{"C6_ITEM"			,CITEM						})
	AADD(AAUX,{"C6_PRODUTO"		,T003->G1_COMP			})
	AADD(AAUX,{"C6_QTDVEN"		,T003->G1_QUANT			})
	AADD(AAUX,{"C6_PRCVEN"		,NPRCVEN					})
	AADD(AAUX,{"C6_TES"			,CTES						})
	AADD(AAUX,{"C6_LOCAL"		,"31"						})
	AADD(AAUX,{"C6_UM"			,T003->B1_UM				})
	AADD(AAUX,{"C6_DESCRI"		,ALLTRIM(T003->B1_DESC)	})
	AADD(AAUX,{"C6_CLI"			,SC2->C2__FORNEC			})
	AADD(AAUX,{"C6_LOJA"			,SC2->C2__LOJAFO			})
	AADD(AAUX,{"C6_XITEMC"		,"TAIFF"					})
	AADD(AAUX,{"C6_VALOR"		,NTOTAL					})
	AADD(AAUX,{"C6_PRUNIT"		,NPRCVEN					})
	AADD(AAUX,{"C6__OPBNFC"		,CNUMOP					})
	
	ATMP := U_FCARRAYEXEC("SC6",AAUX,.F.)
	
	AADD(AITENS,ATMP)
	T003->(DBSKIP())
	
ENDDO

IF LEN(AITENS) > 0 
	/*
	|---------------------------------------------------------------------------------
	|	GERA O PEDIDO DE VENDA
	|---------------------------------------------------------------------------------
	*/
	BEGIN TRANSACTION 
		
		MSEXECAUTO({|X,Y,Z| MATA410(X,Y,Z)},ACAB,AITENS,3)
		
		IF LMSERROAUTO
			MOSTRAERRO()
			DISARMTRANSACTION()
		ENDIF
		
	END TRANSACTION 
	
	/*
	|---------------------------------------------------------------------------------
	|	LIBERA O PEDIDO DE VENDA
	|---------------------------------------------------------------------------------
	*/
	IF !LMSERROAUTO
		
		DBSELECTAREA("SC6")
		DBSETORDER(1)
		IF DBSEEK(XFILIAL("SC6") + SC5->C5_NUM)
		
			WHILE SC6->(!EOF()) .AND. SC6->C6_NUM = SC5->C5_NUM
	
				DBSELECTAREA("SC9")
				DBSETORDER(1)
				MALIBDOFAT(SC6->(RECNO()),SC6->C6_QTDVEN,@LCREDITO,@LESTOQUE,.F.,LAVEST,LLIBER,LTRANSF)
									
				SC6->(DBSKIP())
				
			ENDDO
			
			MALIBEROK({SC5->C5_NUM},.F.)
			
		ENDIF 
		
	ENDIF 
	
ENDIF 

RESTAREA(AAREA)

RETURN 

/*
=================================================================================
=================================================================================
||   Arquivo:	TFCOMBNF.prw
=================================================================================
||   Funcao: 	DADOSPC
=================================================================================
||   Descricao
||-------------------------------------------------------------------------------
|| 		Funcao para preenchimento do Grid de Pedidos de Compra referente a OP
|| 	onde foi clicado duas vezes com o botao esquerdo.
|| 
=================================================================================
=================================================================================
||   Autor: 	Edson Hornberger
||   Data:		08/01/2016
=================================================================================
=================================================================================
*/

STATIC FUNCTION DADOSPC(OGRID1,OGRID3,ACOLS03,OBMPVERM,OBMPVERD)

LOCAL CQUERY := ""

IF SELECT("TRB") > 0
	
	DBSELECTAREA("TRB")
	DBCLOSEAREA()
	
ENDIF 

CQUERY := "SELECT" 																	+ ENTER  
CQUERY += "	DISTINCT(ISNULL((SELECT DISTINCT '.T.' FROM " + RETSQLNAME("SD1") + " SD1 WHERE SD1.D1_FILIAL = '" + XFILIAL("SD1") + "' AND SD1.D1_PEDIDO = SC7.C7_NUM AND SD1.D1_COD = SC7.C7_PRODUTO AND SD1.D_E_L_E_T_ = ''),'.F.')) AS NOTA," + ENTER
CQUERY += "	SC7.C7_NUM," 															+ ENTER
CQUERY += "	SC7.C7_EMISSAO," 														+ ENTER
CQUERY += "	SC7.C7_FORNECE," 														+ ENTER
CQUERY += "	SC7.C7_LOJA," 														+ ENTER
CQUERY += "	SA2.A2_NOME" 															+ ENTER
CQUERY += "FROM" 																		+ ENTER 
CQUERY += "	" + RETSQLNAME("SC7") + " SC7" 										+ ENTER
CQUERY += "	INNER JOIN " + RETSQLNAME("SA2") + " SA2 ON" 						+ ENTER 
CQUERY += "		SA2.A2_FILIAL = '" + XFILIAL("SA2") + "' AND" 				+ ENTER 
CQUERY += "		SA2.A2_COD = SC7.C7_FORNECE AND" 								+ ENTER 
CQUERY += "		SA2.A2_LOJA = SC7.C7_LOJA AND" 									+ ENTER 
CQUERY += "		SA2.D_E_L_E_T_ = ''" 											+ ENTER
CQUERY += "WHERE" 																	+ ENTER 
CQUERY += "	SC7.C7_FILIAL = '" + XFILIAL("SC7") + "' AND" 					+ ENTER 
CQUERY += "	SC7.C7__OPBNFC = '" + OGRID1:AARRAY[OGRID1:NAT][2] + "' AND" 	+ ENTER 
CQUERY += "	SC7.D_E_L_E_T_ = ''" 												+ ENTER
CQUERY += "GROUP BY" 																+ ENTER 
CQUERY += "	SC7.C7_NUM," 															+ ENTER
CQUERY += "	SC7.C7_EMISSAO," 														+ ENTER
CQUERY += "	SC7.C7_FORNECE," 														+ ENTER
CQUERY += "	SC7.C7_LOJA," 														+ ENTER
CQUERY += "	SA2.A2_NOME," 														+ ENTER
CQUERY += "	SC7.C7_ITEM," 														+ ENTER
CQUERY += "	SC7.C7_PRODUTO"

TCQUERY CQUERY NEW ALIAS "TRB"
TCSETFIELD("TRB","C7_EMISSAO","D")
DBSELECTAREA("TRB")
DBGOTOP()	
	
ACOLS03 := {}

WHILE TRB->(!EOF())
	
	AADD(ACOLS03,{&(TRB->NOTA),TRB->C7_NUM,TRB->C7_EMISSAO,TRB->C7_FORNECE,TRB->C7_LOJA,TRB->A2_NOME})
	TRB->(DBSKIP())
	
ENDDO 
	
IF LEN(ACOLS03) <= 0 
	
	AADD(ACOLS03,{.F.,"","","","",""})
	
ENDIF 

OGRID3:SETARRAY(ACOLS03)
OGRID3:BLINE	:= {||	{	IIF(ACOLS03[OGRID3:NAT][1],OBMPVERD,OBMPVERM),;
							ACOLS03[OGRID3:NAT][2],;
							ACOLS03[OGRID3:NAT][3],;
							ACOLS03[OGRID3:NAT][4],;
							ACOLS03[OGRID3:NAT][5],;
							ACOLS03[OGRID3:NAT][6];
						};
					}
					
OGRID3:REFRESH()
OBTN_NFEN:REFRESH()
	
RETURN

/*
=================================================================================
=================================================================================
||   Arquivo:	TFCOMBNF.prw
=================================================================================
||   Funcao: 	VERNFS
=================================================================================
||   Descricao
||-------------------------------------------------------------------------------
|| 		Verifica se existem Notas Fiscais de Saída para o Pedido de Venda sele-
|| 	cionado na Grid.
|| 
=================================================================================
=================================================================================
||   Autor:	Edson Hornberger 
||   Data:		08/01/2016
=================================================================================
=================================================================================
*/

STATIC FUNCTION VERNFS(OGRID)
	
LOCAL CQUERY 			:= ""
LOCAL NREGS			:= 0
LOCAL AAREASF2		:= SF2->(GETAREA())
LOCAL AAREASD2		:= SD2->(GETAREA())
PRIVATE ODLGNFS
PRIVATE OBTNNFS
PRIVATE OGRIDNFS
PRIVATE AHEADERNFS	:= {"Número NF","Série NF","Emissão","Cód. Fornecedor","Loja","Razão Social","Código Produto","Descrição","Qtd. Original","Sld. Devolução"}
PRIVATE ATAMNFS		:= {TAMSX3("D2_DOC")[1],TAMSX3("D2_SERIE")[1],TAMSX3("D2_EMISSAO")[1],TAMSX3("D2_CLIENTE")[1],TAMSX3("D2_LOJA")[1],TAMSX3("A2_NOME")[1],TAMSX3("D2_COD")[1],TAMSX3("B1_DESC")[1],TAMSX3("D2_QUANT")[1],TAMSX3("B6_SALDO")[1]}
PRIVATE ACOLSNFS		:= {}

IF SELECT("TRB") > 0 
	
	DBSELECTAREA("TRB")
	DBCLOSEAREA()
	
ENDIF 

CQUERY := "SELECT" 																+ ENTER  
CQUERY += "	SD2.D2_DOC," 														+ ENTER 
CQUERY += "	SD2.D2_SERIE," 													+ ENTER 
CQUERY += "	SD2.D2_EMISSAO," 													+ ENTER 
CQUERY += "	SD2.D2_CLIENTE," 													+ ENTER 
CQUERY += "	SD2.D2_LOJA," 													+ ENTER 
CQUERY += "	SA2.A2_NOME," 													+ ENTER
CQUERY += "	SD2.D2_COD," 														+ ENTER 
CQUERY += "	SB1.B1_DESC," 													+ ENTER 
CQUERY += "	SD2.D2_QUANT," 													+ ENTER 
CQUERY += "	SB6.B6_SALDO" 													+ ENTER 
CQUERY += "FROM" 																	+ ENTER  
CQUERY += "	" + RETSQLNAME("SD2") + " SD2" 									+ ENTER 
CQUERY += "	INNER JOIN " + RETSQLNAME("SA2") + " SA2 ON" 					+ ENTER  
CQUERY += "		SA2.A2_FILIAL = '" + XFILIAL("SA2") + "' AND" 			+ ENTER  
CQUERY += "		SA2.A2_COD = SD2.D2_CLIENTE AND" 							+ ENTER  
CQUERY += "		SA2.A2_LOJA = SD2.D2_LOJA AND" 								+ ENTER  
CQUERY += "		SA2.D_E_L_E_T_ = ''" 										+ ENTER 
CQUERY += "	INNER JOIN " + RETSQLNAME("SB6") + " SB6 ON" 					+ ENTER  
CQUERY += "		SB6.B6_FILIAL = '" + XFILIAL("SB6") + "' AND" 			+ ENTER  
CQUERY += "		SB6.B6_DOC = SD2.D2_DOC AND" 								+ ENTER  
CQUERY += "		SB6.B6_SERIE = SD2.D2_SERIE AND" 							+ ENTER  
CQUERY += "		SB6.B6_PRODUTO = SD2.D2_COD AND" 							+ ENTER  
CQUERY += "		SB6.D_E_L_E_T_ = ''" 										+ ENTER 
CQUERY += "	INNER JOIN " + RETSQLNAME("SB1") + " SB1 ON" 					+ ENTER 
CQUERY += "		SB1.B1_FILIAL = '" + XFILIAL("SB1") + "' AND" 			+ ENTER
CQUERY += "		SB1.B1_COD = SD2.D2_COD AND" 								+ ENTER
CQUERY += "		SB1.D_E_L_E_T_ = ''" 										+ ENTER
CQUERY += "WHERE" 																+ ENTER  
CQUERY += "	SD2.D2_FILIAL	= '" + XFILIAL("SD2") + "'	AND" 				+ ENTER  
CQUERY += "	SD2.D2_PEDIDO	= '" + OGRID:AARRAY[OGRID:NAT][2] + "'	AND" 	+ ENTER     
CQUERY += "	SD2.D_E_L_E_T_	= ''" 											+ ENTER
CQUERY += "ORDER BY" 															+ ENTER
CQUERY += "	SD2.D2_EMISSAO"

MEMOWRITE("\TFCOMBNF_01.SQL",CQUERY)
TCQUERY CQUERY NEW ALIAS "TRB"
TCSETFIELD("TRB","D2_EMISSAO","D")
TCSETFIELD("TRB","D2_QUANT","N",13,4)
TCSETFIELD("TRB","B6_SALDO","N",12,2)
DBSELECTAREA("TRB")
DBGOTOP()
COUNT TO NREGS

IF NREGS > 0 
	
	TRB->(DBGOTOP())
	
	WHILE TRB->(!EOF()) 
		
		AADD(ACOLSNFS,{TRB->D2_DOC,TRB->D2_SERIE,TRB->D2_EMISSAO,TRB->D2_CLIENTE,TRB->D2_LOJA,TRB->A2_NOME,TRB->D2_COD,TRB->B1_DESC,TRB->D2_QUANT,TRB->B6_SALDO})
		TRB->(DBSKIP())
		
	ENDDO
	
	ODLGNFS := MSDIALOG():NEW(0,0,300,500,"Notas Fiscais de Saída",,,,,CLR_WHITE,CLR_BLACK,,,.T.)
	OGRIDNFS:= TCBROWSE():NEW(10, 10, 232, 110,, AHEADERNFS, ATAMNFS, ODLGNFS,,,,, {||},,,,,,,.F.,,.T.,,.F.,,.T.,.T.)
	OBTNNFS := TBUTTON():NEW(127, 010, "Visualizar"	, ODLGNFS, {|| MSGRUN("Abrindo Nota Fiscal","Processando...",{|| ABRENF("S",OGRIDNFS)})}, 50, 15,,,.F.,.T.) 
	OBTNNFS := TBUTTON():NEW(127, 195, "Sair"			, ODLGNFS, {|| ODLGNFS:END()}, 50, 15,,,.F.,.T.)
	
	OGRIDNFS:LADJUSTCOLSIZE := .T.
	OGRIDNFS:SETARRAY(ACOLSNFS)
	OGRIDNFS:BLINE	:= {||	{	ACOLSNFS[OGRIDNFS:NAT][1],;
									ACOLSNFS[OGRIDNFS:NAT][2],;
									ACOLSNFS[OGRIDNFS:NAT][3],;
									ACOLSNFS[OGRIDNFS:NAT][4],;
									ACOLSNFS[OGRIDNFS:NAT][5],;
									ACOLSNFS[OGRIDNFS:NAT][6],;
									ACOLSNFS[OGRIDNFS:NAT][7],;
									ACOLSNFS[OGRIDNFS:NAT][8],;
									ACOLSNFS[OGRIDNFS:NAT][9],;
									ACOLSNFS[OGRIDNFS:NAT][10];
								};
							}
							
	OGRIDNFS:REFRESH()
	ODLGNFS:ACTIVATE(,,,.T.)
	
ELSE

	MESSAGEBOX("Não existem Notas Ficais de Saída!","ATENÇÃO",0)

ENDIF 

RESTAREA(AAREASD2)
RESTAREA(AAREASF2)
	
RETURN()

/*
=================================================================================
=================================================================================
||   Arquivo:	TFCOMBNF.prw
=================================================================================
||   Funcao: 	VERNFE
=================================================================================
||   Descricao
||-------------------------------------------------------------------------------
|| 		Verifica se existem Notas Fiscais de Entrada para o Pedido de Compra sele-
|| 	cionado na Grid.
|| 
=================================================================================
=================================================================================
||   Autor: 	Edson Hornberger
||   Data:		08/01/2016
=================================================================================
=================================================================================
*/

STATIC FUNCTION VERNFE(OGRID)
	
LOCAL CQUERY 			:= ""
LOCAL NREGS			:= 0
LOCAL AAREASF1		:= SF1->(GETAREA())
LOCAL AAREASD1		:= SD1->(GETAREA())
PRIVATE ODLGNFE
PRIVATE OBTNNFE
PRIVATE OGRIDNFE
PRIVATE AHEADERNFE	:= {"Número NF","Série NF","Emissão","Cód. Fornecedor","Loja","Razão Social","Código Produto","Descrição","Qtd. Original"}
PRIVATE ATAMNFE		:= {TAMSX3("D1_DOC")[1],TAMSX3("D1_SERIE")[1],TAMSX3("D1_EMISSAO")[1],TAMSX3("D1_FORNECE")[1],TAMSX3("D1_LOJA")[1],TAMSX3("A2_NOME")[1],TAMSX3("D1_COD ")[1],TAMSX3("B1_DESC")[1],TAMSX3("D1_QUANT")[1]}
PRIVATE ACOLSNFE		:= {}

IF SELECT("TRB") > 0 
	
	DBSELECTAREA("TRB")
	DBCLOSEAREA()
	
ENDIF 

CQUERY := "SELECT" 																+ ENTER  
CQUERY += "	SD1.D1_DOC," 														+ ENTER 
CQUERY += "	SD1.D1_SERIE," 													+ ENTER 
CQUERY += "	SD1.D1_EMISSAO," 													+ ENTER 
CQUERY += "	SD1.D1_FORNECE," 													+ ENTER 
CQUERY += "	SD1.D1_LOJA," 													+ ENTER 
CQUERY += "	SA2.A2_NOME," 													+ ENTER
CQUERY += "	SD1.D1_COD," 														+ ENTER 
CQUERY += "	SB1.B1_DESC," 													+ ENTER 
CQUERY += "	SD1.D1_QUANT" 													+ ENTER  
CQUERY += "FROM" 																	+ ENTER  
CQUERY += "	" + RETSQLNAME("SD1") + " SD1" 									+ ENTER 
CQUERY += "	INNER JOIN " + RETSQLNAME("SA2") + " SA2 ON" 					+ ENTER  
CQUERY += "		SA2.A2_FILIAL = '" + XFILIAL("SA2") + "' AND" 			+ ENTER  
CQUERY += "		SA2.A2_COD = SD1.D1_FORNECE AND" 							+ ENTER  
CQUERY += "		SA2.A2_LOJA = SD1.D1_LOJA AND" 								+ ENTER  
CQUERY += "		SA2.D_E_L_E_T_ = ''" 										+ ENTER
CQUERY += "	INNER JOIN " + RETSQLNAME("SB1") + " SB1 ON" 					+ ENTER 
CQUERY += "		SB1.B1_FILIAL = '" + XFILIAL("SB1") + "' AND" 			+ ENTER 
CQUERY += "		SB1.B1_COD = SD1.D1_COD AND" 								+ ENTER 
CQUERY += "		SB1.D_E_L_E_T_ = ''" 										+ ENTER 
CQUERY += "WHERE" 																+ ENTER  
CQUERY += "	SD1.D1_FILIAL	= '" + XFILIAL("SD1") + "'	AND" 				+ ENTER  
CQUERY += "	SD1.D1_PEDIDO	= '" + OGRID:AARRAY[OGRID:NAT][2] + "'	AND" 	+ ENTER      
CQUERY += "	SD1.D_E_L_E_T_ = ''" 											+ ENTER 
CQUERY += "ORDER BY" 															+ ENTER 
CQUERY += "	SD1.D1_EMISSAO"

TCQUERY CQUERY NEW ALIAS "TRB"
TCSETFIELD("TRB","D1_EMISSAO","D")
TCSETFIELD("TRB","D1_QUANT","N",13,4)
DBSELECTAREA("TRB")
DBGOTOP()

COUNT TO NREGS

IF NREGS > 0 
	
	//AROTINA //versao 12
	
	TRB->(DBGOTOP())
	
	WHILE TRB->(!EOF()) 
		
		AADD(ACOLSNFE,{TRB->D1_DOC,TRB->D1_SERIE,TRB->D1_EMISSAO,TRB->D1_FORNECE,TRB->D1_LOJA,TRB->A2_NOME,TRB->D1_COD,TRB->B1_DESC,TRB->D1_QUANT})
		TRB->(DBSKIP())
		
	ENDDO
	
	ODLGNFE := MSDIALOG():NEW(0,0,300,500,"Notas Fiscais de Saída",,,,,CLR_WHITE,CLR_BLACK,,,.T.)
	OGRIDNFE:= TCBROWSE():NEW(10, 10, 232, 110,, AHEADERNFE, ATAMNFE, ODLGNFE,,,,, {||},,,,,,,.F.,,.T.,,.F.,,.T.,.T.)
	OBTNNFE := TBUTTON():NEW(127, 010, "Vizualizar"	, ODLGNFE, {|| MSGRUN("Abrindo Nota Fiscal","Processando...",{|| ABRENF("E",OGRIDNFE)})}, 50, 15,,,.F.,.T.) 
	OBTNNFE := TBUTTON():NEW(127, 195, "Sair"			, ODLGNFE, {|| ODLGNFE:END()}, 50, 15,,,.F.,.T.)
	
	OGRIDNFE:LADJUSTCOLSIZE := .T.
	OGRIDNFE:SETARRAY(ACOLSNFE)
	OGRIDNFE:BLINE	:= {||	{	ACOLSNFE[OGRIDNFE:NAT][1],;
									ACOLSNFE[OGRIDNFE:NAT][2],;
									ACOLSNFE[OGRIDNFE:NAT][3],;
									ACOLSNFE[OGRIDNFE:NAT][4],;
									ACOLSNFE[OGRIDNFE:NAT][5],;
									ACOLSNFE[OGRIDNFE:NAT][6],;
									ACOLSNFE[OGRIDNFE:NAT][7],;
									ACOLSNFE[OGRIDNFE:NAT][8],;
									ACOLSNFE[OGRIDNFE:NAT][9];
								};
							}
							
	OGRIDNFE:REFRESH()
	ODLGNFE:ACTIVATE(,,,.T.)

ELSE

	MESSAGEBOX("Não existem Notas Ficais de Entrada!","ATENÇÃO",0)

ENDIF

RESTAREA(AAREASD1)
RESTAREA(AAREASF1)
	
RETURN()

/*
=================================================================================
=================================================================================
||   Arquivo:	TFCOMBNF.prw
=================================================================================
||   Funcao: 	VERPEDVENDA
=================================================================================
||   Descricao
||-------------------------------------------------------------------------------
|| 		Caso seja clicado duas vezes sobre um Pedido de Venda abre a visualizacao 
|| 	Padrao do Sistema.
|| 
=================================================================================
=================================================================================
||   Autor:	Edson Hornberger 
||   Data:		08/01/2016
=================================================================================
=================================================================================
*/

STATIC FUNCTION VERPEDVENDA(OGRID)

LOCAL AAREASC5 := SC5->(GETAREA())
LOCAL AAREASC6 := SC6->(GETAREA())

DBSELECTAREA("SC5")
DBSETORDER(1)
IF DBSEEK(XFILIAL("SC5") + OGRID:AARRAY[OGRID:NAT][2]) .AND. !EMPTY(ALLTRIM(OGRID:AARRAY[OGRID:NAT][2]))
	
	A410VISUAL("SC5",SC5->(RECNO()),2)
	
ELSE
	
	MESSAGEBOX("Problemas para achar o Pedido de Venda!","ATENÇÃO",16)
	
ENDIF 

SETKEY(VK_F6,{|| VEREMPENHOS(OGRID01)})
RESTAREA(AAREASC5)
RESTAREA(AAREASC6)

RETURN

/*
=================================================================================
=================================================================================
||   Arquivo:	TFCOMBNF.prw
=================================================================================
||   Funcao: 	VERPEDCOMPRA
=================================================================================
||   Descricao
||-------------------------------------------------------------------------------
|| 		Caso seja clicado duas vezes sobre um Pedido de Compra abre a visualizacao 
|| 	Padrao do Sistema.
|| 
=================================================================================
=================================================================================
||   Autor: 	Edson Hornberger
||   Data:		08/01/2016
=================================================================================
=================================================================================
*/

STATIC FUNCTION VERPEDCOMPRA(OGRID)

LOCAL AAREASC7 	:= SC7->(GETAREA())
PRIVATE L120AUTO 	:= .F.
PRIVATE LVLDHEAD	:= .T.
PRIVATE LGATILHA	:= .T.
PRIVATE NTIPOPED 	:= 1

DBSELECTAREA("SC7")
DBSETORDER(1)
IF DBSEEK(XFILIAL("SC7") + OGRID:AARRAY[OGRID:NAT][2]) .AND. !EMPTY(ALLTRIM(OGRID:AARRAY[OGRID:NAT][2]))  
	
	A120PEDIDO("SC7",SC7->(RECNO()),2)
	
ELSE
	
	MESSAGEBOX("Problemas para achar o Pedido de Compra!","ATENÇÃO",16)
	
ENDIF 

SETKEY(VK_F6,{|| VEREMPENHOS(OGRID01)})
RESTAREA(AAREASC7)

RETURN

/*
=================================================================================
=================================================================================
||   Arquivo:	TFCOMBNF.prw
=================================================================================
||   Funcao: 	VERAPONTAM
=================================================================================
||   Descricao
||-------------------------------------------------------------------------------
|| 		Mostra os Apontamentos de Produção referente a Ordem de Produção que esta
|| 	selecionado na Grid.
|| 
=================================================================================
=================================================================================
||   Autor:	Edson Hornberger 
||   Data:		08/01/2016
=================================================================================
=================================================================================
*/

STATIC FUNCTION VERAPONTAM(OGRID)

LOCAL CQUERY 			:= ""
LOCAL NREGS			:= 0
LOCAL CNAMEUSER		:= ""
PRIVATE ODLGAPT
PRIVATE OBTNAPT
PRIVATE OGRIDAPT
PRIVATE AHEADERAPT	:= {"Data Apontamento","Documento","Qtd. Produzida","Quem apontou"}
PRIVATE ATAMAPT		:= {TAMSX3("D3_EMISSAO")[1],TAMSX3("D3_DOC")[1],TAMSX3("D3_QUANT")[1],30}
PRIVATE ACOLSAPT		:= {}

IF SELECT("TRB") > 0 
	
	DBSELECTAREA("TRB")
	DBCLOSEAREA()
	
ENDIF

CQUERY := "SELECT" 															+ ENTER 
CQUERY += "	SD3.D3_QUANT," 												+ ENTER 
CQUERY += "	SD3.D3_DOC," 													+ ENTER 
CQUERY += "	SD3.D3_EMISSAO," 												+ ENTER 
CQUERY += "	SD3.D3_USUARIO" 												+ ENTER
CQUERY += "FROM" 																+ ENTER  
CQUERY += "	" + RETSQLNAME("SD3") + " SD3" 								+ ENTER  
CQUERY += "WHERE" 															+ ENTER  
CQUERY += "	SD3.D3_FILIAL = '" + XFILIAL("SD3") + "' AND" 			+ ENTER
CQUERY += "	SD3.D3_OP = '" + OGRID:AARRAY[OGRID:NAT][2] + "' AND" 	+ ENTER 
CQUERY += "	LEFT(SD3.D3_CF,2) = 'PR' AND" 								+ ENTER  
CQUERY += "	SD3.D_E_L_E_T_ = ''" 										+ ENTER 
CQUERY += "ORDER BY" 														+ ENTER 
CQUERY += "	SD3.D3_EMISSAO"

TCQUERY CQUERY NEW ALIAS "TRB"
TCSETFIELD("TRB","D3_EMISSAO","D")
TCSETFIELD("TRB","D3_QUANT","N",12,02)
DBSELECTAREA("TRB")
DBGOTOP()

COUNT TO NREGS

IF NREGS > 0 
	
	TRB->(DBGOTOP())
	
	WHILE TRB->(!EOF())
		
		PSWORDER(2)
		IF PSWSEEK( TRB->D3_USUARIO, .T. ) 
			CNAMEUSER := SUBSTR(USRFULLNAME(PSWID()),1,30)
		ELSE
			CNAMEUSER := TRB->D3_USUARIO
		ENDIF 
		AADD(ACOLSAPT,{TRB->D3_EMISSAO,TRB->D3_DOC,TRB->D3_QUANT,CNAMEUSER})
		TRB->(DBSKIP())
		
	ENDDO
	
	ODLGAPT := MSDIALOG():NEW(0,0,300,500,"Apontamentos de Produção",,,,,CLR_WHITE,CLR_BLACK,,,.T.)
	OGRIDAPT:= TCBROWSE():NEW(10, 10, 232, 110,, AHEADERAPT, ATAMAPT, ODLGAPT,,,,, {||},,,,,,,.F.,,.T.,,.F.,,.T.,.T.) 
	OBTNAPT := TBUTTON():NEW(127, 195, "Sair"	, ODLGAPT, {|| ODLGAPT:END()}, 50, 15,,,.F.,.T.)
	
	OGRIDAPT:LADJUSTCOLSIZE := .T.
	OGRIDAPT:SETARRAY(ACOLSAPT)
	OGRIDAPT:BLINE	:= {||	{	ACOLSAPT[OGRIDAPT:NAT][1],;
									ACOLSAPT[OGRIDAPT:NAT][2],;
									ACOLSAPT[OGRIDAPT:NAT][3],;
									ACOLSAPT[OGRIDAPT:NAT][4];
								};
							}
							
	OGRIDAPT:REFRESH()
	ODLGAPT:ACTIVATE(,,,.T.)
	
ELSE

	MESSAGEBOX("Não existem Produções para esta OP!","ATENÇÃO",0)

ENDIF

SETKEY(VK_F6,{|| VEREMPENHOS(OGRID01)})

RETURN

/*
=================================================================================
=================================================================================
||   Arquivo:	TFCOMBNF.prw
=================================================================================
||   Funcao: 	ENCEROP
=================================================================================
||   Descricao
||-------------------------------------------------------------------------------
|| 		Função para Encerramento/Exclução da Ordem de Produção. 
|| 
=================================================================================
=================================================================================
||   Autor:	Edson Hornberger 
||   Data:		11/01/2016
=================================================================================
=================================================================================
*/

STATIC FUNCTION ENCEROP(OGRID,ACOLS01)
	
LOCAL ADADOS 			:= {}
LOCAL NOPC				:= 6
LOCAL LACHOU			:= .F.
LOCAL LCONTINUA		:= .F.

PRIVATE LMSERROAUTO 	:= .F.

/*
|---------------------------------------------------------------------------------
|	Verifica se existem movimentos internos para a OP
|---------------------------------------------------------------------------------
*/
DBSELECTAREA("SD3")
DBSETORDER(1)
IF DBSEEK(XFILIAL("SD3") + OGRID:AARRAY[OGRID:NAT][2])
	
	LACHOU := .T.
	WHILE SD3->(!EOF()) .AND. SD3->D3_OP = OGRID:AARRAY[OGRID:NAT][2]
		
		/*
		|---------------------------------------------------------------------------------
		|	Se existir acha um movimento de Produção para poder realizar o Encerramento
		|---------------------------------------------------------------------------------
		*/
		IF LEFT(SD3->D3_CF,2) = "PR"
			
			LCONTINUA := .T.
			EXIT
			
		ENDIF 
		SD3->(DBSKIP())
		
	ENDDO 

ENDIF 

IF LACHOU .AND. LCONTINUA

	NOPC := 6
	IF MESSAGEBOX("Confirma o Encerramento da OP " + OGRID:AARRAY[OGRID:NAT][2] + "?","ATENÇÃO",1) = 2
	
		MESSAGEBOX("Encerramento Cancelado!","ATENÇÃO",64)
		RETURN
		
	ELSE
	
		DBSELECTAREA("SC2")
		DBSETORDER(1)
		IF !DBSEEK(XFILIAL("SC2") + OGRID:AARRAY[OGRID:NAT][2])
			
			MESSAGEBOX("Problemas para achar a OP!","ATENÇÃO",64)
			RETURN
			
		ENDIF 
		
	ENDIF 
	
ELSE
	
	/*
	|---------------------------------------------------------------------------------
	|	Se não existir movimento Internos de produção exclui a OP
	|---------------------------------------------------------------------------------
	*/
	NOPC := 5
	IF MESSAGEBOX("Não existe apontamentos para a OP " + OGRID:AARRAY[OGRID:NAT][2] + ENTER + "Deseja excluir a mesma?","ATENÇÃO",1) = 2
	
		MESSAGEBOX("Exclusão Cancelada!","ATENÇÃO",64)
		RETURN
		
	ENDIF
	
ENDIF

IF NOPC = 5
	
	DBSELECTAREA("SC2")
	DBSETORDER(1)
	IF DBSEEK(XFILIAL("SC2") + OGRID:AARRAY[OGRID:NAT][2])
	
		ADADOS := {	{"C2_FILIAL"	,XFILIAL("SC2")	,NIL},;
						{"C2_PRODUTO"	,C2_PRODUTO		,NIL},;
						{"C2_NUM"		,C2_NUM			,NIL},;
						{"C2_ITEM"		,C2_ITEM			,NIL},;
						{"C2_SEQUEN"	,C2_SEQUEN			,NIL},;
						{"C2_LOCAL"	,C2_LOCAL			,NIL},;
						{"C2_TPOP"		,C2_TPOP			,NIL},;
						{"C2_CC"		,C2_CC				,NIL},;
						{"C2_UM"		,C2_UM				,NIL},;
						{"C2_QUANT"	,C2_QUANT			,NIL},;
						{"C2_DTPRI"	,C2_DATPRI			,NIL},;
						{"C2_DATPRF"	,C2_DATPRF			,NIL},;
						{"C2_EMISSAO"	,C2_EMISSAO		,NIL};
					}
					
	ELSE
	
		MESSAGEBOX("Problemas para encontrar a OP na Tabela de Dados!","ATENÇÃO",16)
		RETURN .F.
	
	ENDIF
	
ELSE

	ADADOS := {	{"D3_OP"		,PADR(OGRID:AARRAY[OGRID:NAT][2],TAMSX3("D3_OP")[1])	,NIL},;
					{"D3_TM"		,"100"														,NIL},;
					{"D3_COD"		,SB1->B1_COD												,NIL},;
					{"D3_EMISSAO"	,DDATABASE													,NIL},;
					{"D3_DOC"		,GETSXENUM("SD3","D3_DOC",1)							,NIL};
				}
				
ENDIF 

BEGIN TRANSACTION
 	
 	IF NOPC = 5 
 		// 	Exclusão de OP
 		MSEXECAUTO({|X, Y| MATA650(X, Y)}, ADADOS, NOPC)
 		
 	ELSE
 		// Encerramento de OP
		MSEXECAUTO({|X, Y| MATA250(X, Y)}, ADADOS, NOPC)
		
	ENDIF 
	
	IF LMSERROAUTO
		
		MESSAGEBOX("Ocorreu um erro no processo de " + IIF(NOPC = 5,"Exclusão","Encerramento") + " da OP!","ATENÇÃO",16)
		MOSTRAERRO()
		DISARMTRANSACTION()
		
	ENDIF 
		
	
END TRANSACTION

/*
|---------------------------------------------------------------------------------
|	Atualiza o Grid de Ordens de Produção
|---------------------------------------------------------------------------------
*/
IF !LMSERROAUTO

	MESSAGEBOX("OP " + OGRID:AARRAY[OGRID:NAT][2] + IIF(NOPC = 5," excluída"," encerrada") + " com sucesso!","ATENÇÃO",64)
	IF !DADOSOP(@ACOLS01)
		MESSAGEBOX("Não há dados para Gestão de Beneficamento para o" + ENTER + "Produto " + ALLTRIM(SB1->B1_COD) + " - " + ALLTRIM(SB1->B1_DESC) + "!","ATENÇÃO",16)
		RETURN .F.
	ENDIF 
	
	OGRID:SETARRAY(ACOLS01)
	OGRID:BLINE	:= {||	{	IIF(ACOLS01[OGRID:NAT][1]="VERMELHO",OBMPVERM,IIF(ACOLS01[OGRID:NAT][1]="VERDE",OBMPVERD,IIF(ACOLS01[OGRID:NAT][1]="AZUL",OBMPAZUL,OBMPAMAR))),;
								ACOLS01[OGRID:NAT][2],;
								ACOLS01[OGRID:NAT][3],;
								ACOLS01[OGRID:NAT][4],;
								ACOLS01[OGRID:NAT][5],;
								ACOLS01[OGRID:NAT][6],;
								ACOLS01[OGRID:NAT][7],;
								ACOLS01[OGRID:NAT][8];
							};
						}
	OGRID:REFRESH()

ENDIF   

RETURN

/*
=================================================================================
=================================================================================
||   Arquivo:	TFCOMBNF.prw
=================================================================================
||   Funcao: 	VEREMPENHOS
=================================================================================
||   Descricao
||-------------------------------------------------------------------------------
|| 		Função chamada pela tecla F6 para visualizar os Empenhos da OP 
|| 	selecionada.
|| 
=================================================================================
=================================================================================
||   Autor:	Edson Hornberger 
||   Data:		08/01/2016
=================================================================================
=================================================================================
*/

STATIC FUNCTION VEREMPENHOS(OGRID)
	
LOCAL AAREASD4 	:= SD4->(GETAREA())
LOCAL NOPC 		:= 4

/*
|=================================================================================
|   COMENTARIO
|---------------------------------------------------------------------------------
|	Verificar SD4->D4_TRT pois estava como não usado no Ambiente DESENV04
|	gerando erro nesta função.
|=================================================================================
*/

DBSELECTAREA("SD4")
DBSETORDER(2)
IF DBSEEK(XFILIAL("SD4") + OGRID:AARRAY[OGRID:NAT][2])
	
	A381Manut("SD4",SD4->(RECNO()),NOPC)
	
ELSE

	MESSAGEBOX("Não foi encontrado empenhos para a OP " + OGRID:AARRAY[OGRID:NAT][2],"ATENÇÃO", 64)
	
ENDIF

SETKEY(VK_F6,{|| VEREMPENHOS(OGRID01)})

RESTAREA(AAREASD4)
	
RETURN

/*
=================================================================================
=================================================================================
||   Arquivo:	TFCOMBNF.prw
=================================================================================
||   Funcao: 	ABRENF
=================================================================================
||   Descricao
||-------------------------------------------------------------------------------
|| 		Funcao para visualização de Notas Fiscais, podendo ser Notas de Entrada
|| 	ou Notas de Saída.
|| 
=================================================================================
=================================================================================
||   Autor:	Edson Hornberger  
||   Data:		12/01/2016
=================================================================================
=================================================================================
*/

STATIC FUNCTION ABRENF(CTIPO,OGRID)

LOCAL AROTOLD := ACLONE(AROTINA)

/*
|---------------------------------------------------------------------------------
|	Caso seja Nota Fiscal de Saída, posiciona os Registros e mostra
|---------------------------------------------------------------------------------
*/
IF CTIPO = "S"
	
	DBSELECTAREA("SD2")
	DBSETORDER(3)
	DBSEEK(XFILIAL("SD2") + OGRID:AARRAY[OGRID:NAT][1] + OGRID:AARRAY[OGRID:NAT][2])
	
	DBSELECTAREA("SF2")
	DBSETORDER(1)
	IF DBSEEK(XFILIAL("SF2") + OGRID:AARRAY[OGRID:NAT][1] + OGRID:AARRAY[OGRID:NAT][2])
		
		MC090VISUAL("SF2",SF2->(RECNO()),2)		
		
	ELSE
		
		MESSAGEBOX("Problemas ao tentar visualizar a NF de Saída!","ATENÇÃO",16)
		RETURN
		
	ENDIF
	
ELSE
	/*
	|---------------------------------------------------------------------------------
	|	Caso seja Nota Fiscal de Entrada, posiciona os Registros e mostra
	|---------------------------------------------------------------------------------
	*/	
	DBSELECTAREA("SD1")
	DBSETORDER(1)
	DBSEEK(XFILIAL("SD1") + OGRID:AARRAY[OGRID:NAT][1] + OGRID:AARRAY[OGRID:NAT][2] + OGRID:AARRAY[OGRID:NAT][4] + OGRID:AARRAY[OGRID:NAT][5])
	
	DBSELECTAREA("SF1")
	DBSETORDER(1)
	IF DBSEEK(XFILIAL("SF1") + OGRID:AARRAY[OGRID:NAT][1] + OGRID:AARRAY[OGRID:NAT][2] + OGRID:AARRAY[OGRID:NAT][4] + OGRID:AARRAY[OGRID:NAT][5])
		
		AROTINA := {}
		AADD(AROTINA,{"Pesquisar", "AXPESQUI"   , 0 , 1, 0, .F.}) 		//"PESQUISAR"
		AADD(AROTINA,{"Visualizar", "A103NFISCAL", 0 , 2, 0, NIL}) 		//"VISUALIZAR"
		
		A103NFISCAL("SF1",SF1->(RECNO()),2,.F.)
		
		AROTINA := ACLONE(AROTOLD)
		
	ELSE
		
		MESSAGEBOX("Problemas ao tentar visualizar a NF de Entrada!","ATENÇÃO",16)
		RETURN
		
	ENDIF 
	
ENDIF 

SETKEY(VK_F6,{|| VEREMPENHOS(OGRID01)})

RETURN

/*
=================================================================================
=================================================================================
||   Arquivo:	TFCOMBNF.prw
=================================================================================
||   Funcao: 	GRAPHBNF
=================================================================================
||   Descricao
||-------------------------------------------------------------------------------
|| 		Apresenta gráfico de rastreabilidade no processo de Beneficiamento
|| 
=================================================================================
=================================================================================
||   Autor:	Edson Hornberger 
||   Data:		10/02/2016
=================================================================================
=================================================================================
*/

STATIC FUNCTION GRAPHBNF(OGRID)

LOCAL CQUERY 		:= ""
LOCAL CNUMOP 		:= OGRID:AARRAY[OGRID:NAT][2]
LOCAL NREG			:= 0 
LOCAL CGRUPO		:= ""

PRIVATE ODLGGRP	
PRIVATE OGRAPH
PRIVATE OMENUTREE
PRIVATE AOBJ006	:= {ATELA[1]/1.5,ATELA[2]/1.5,ATELA[3]/1.5,ATELA[4]/1.5,1,1}					// Passa dimensionamento da tela para calculo do tamanho dos objetos
PRIVATE AOBJ007	:= {}																					// Passa as dimensoes dos Objetos na Vertical
PRIVATE AOBJ008	:= {}  

// OBJETOS PARA CALCULO DAS DIMENSOES HORIZONTAL
AADD(AOBJ007 , {0500,0500,.T.,.T.})						// GRID INFERIOR

AOBJ008 := MSOBJSIZE(AOBJ006,AOBJ007,.T.,.T.)				// CALCULO DAS DIMENSOES VERTICAL

CURSORWAIT()

CQUERY := "SELECT" 																			+ ENTER  
CQUERY += "	'01'	AS 'TIPO'," 															+ ENTER 
CQUERY += "	LEFT('01' + SC2.C2_NUM + SC2.C2_ITEM + SC2.C2_SEQUEN + SPACE(014),14) AS 'DOCUMENTO',"	+ ENTER 
CQUERY += "	SC2.C2_PRODUTO AS 'PRODUTO'," 												+ ENTER 
CQUERY += "	SB1.B1_DESC AS 'DESCRICAO'," 												+ ENTER 
CQUERY += "	SC2.C2_QUANT AS 'QUANTIDADE'," 												+ ENTER 
CQUERY += "	SC2.C2_EMISSAO AS 'DATA'," 													+ ENTER 
CQUERY += "	(" 																				+ ENTER 
CQUERY += "		SELECT TOP(1)" 															+ ENTER  												
CQUERY += "			(SD4.D4_QUANT - SD4.D4__QTBNFC) / G1_QUANT" 						+ ENTER 
CQUERY += "		FROM" 																		+ ENTER  																							
CQUERY += "			" + RETSQLNAME("SG1") + " SG1" 										+ ENTER  							
CQUERY += "			INNER JOIN " + RETSQLNAME("SB1") + " SB1 ON" 						+ ENTER  			
CQUERY += "				B1_FILIAL = '" + XFILIAL("SB1") + "' AND" 					+ ENTER  			
CQUERY += "				B1_COD = G1_COMP AND" 											+ ENTER  										
CQUERY += "				B1_TIPO != 'MP' AND" 											+ ENTER  										
CQUERY += "				SB1.D_E_L_E_T_ = ''" 											+ ENTER  								
CQUERY += "			LEFT OUTER JOIN " + RETSQLNAME("SD4") + " SD4 ON" 				+ ENTER  		
CQUERY += "				D4_FILIAL = '" + XFILIAL("SD4") + "' AND" 					+ ENTER  			
CQUERY += "				D4_COD = B1_COD AND" 											+ ENTER  								
CQUERY += "				D4_OP = SC2.C2_NUM + SC2.C2_ITEM + SC2.C2_SEQUEN AND" 		+ ENTER  						
CQUERY += "				SD4.D_E_L_E_T_ = ''" 											+ ENTER  										
CQUERY += "		WHERE" 																	+ ENTER  																						
CQUERY += "			G1_FILIAL = '" + XFILIAL("SG1") + "' AND" 						+ ENTER  				
CQUERY += "			G1_COD = SC2.C2_PRODUTO AND" 										+ ENTER  					
CQUERY += "			SG1.D_E_L_E_T_ = ''" 												+ ENTER  									
CQUERY += "		GROUP BY" 																	+ ENTER  													
CQUERY += "			G1_COD," 																+ ENTER  												
CQUERY += "			D4_QUANT," 															+ ENTER  												
CQUERY += "			D4__QTBNFC," 															+ ENTER  											
CQUERY += "			G1_QUANT" 																+ ENTER  												
CQUERY += "		HAVING" 																	+ ENTER  													
CQUERY += "			(SD4.D4_QUANT - SD4.D4__QTBNFC) > 0 AND" 							+ ENTER 					
CQUERY += "			((SD4.D4_QUANT - SD4.D4__QTBNFC) / G1_QUANT) > 0" 				+ ENTER 
CQUERY += "	) AS 'SALDO'," 																+ ENTER 
CQUERY += "	SPACE(014) AS 'ORIGEM'" 														+ ENTER 
CQUERY += "FROM" 																				+ ENTER  
CQUERY += "	" + RETSQLNAME("SC2") + " SC2" 												+ ENTER  
CQUERY += "	INNER JOIN " + RETSQLNAME("SB1") + " SB1 ON" 								+ ENTER  
CQUERY += "		SB1.B1_FILIAL = '" + XFILIAL("SB1") + "' AND" 						+ ENTER  
CQUERY += "		SB1.B1_COD = SC2.C2_PRODUTO AND" 										+ ENTER  
CQUERY += "		SB1.D_E_L_E_T_ = ''" 													+ ENTER 
CQUERY += "WHERE" 																			+ ENTER  
CQUERY += "	SC2.C2_FILIAL = '" + XFILIAL("SC2") + "' AND" 							+ ENTER  
CQUERY += "	SC2.C2_NUM = '" + SUBSTR(CNUMOP,1,6) + "' AND" 							+ ENTER  
CQUERY += "	SC2.C2_ITEM = '" + SUBSTR(CNUMOP,7,2) + "' AND" 							+ ENTER  
CQUERY += "	SC2.C2_SEQUEN = '" + SUBSTR(CNUMOP,9,3) + "' AND" 						+ ENTER 
CQUERY += "	SC2.D_E_L_E_T_ = ''" 														+ ENTER 
CQUERY += "" 																					+ ENTER 
CQUERY += "UNION ALL" 																		+ ENTER 
CQUERY += "" 																					+ ENTER 
CQUERY += "SELECT" 																			+ ENTER  
CQUERY += "	'02' AS 'TIPO'," 																+ ENTER  
CQUERY += "	LEFT('02' + SD4.D4_OP + SPACE(014),14) AS 'DOCUMENTO'," 				+ ENTER 
CQUERY += "	SD4.D4_COD	AS 'PRODUTO'," 													+ ENTER 
CQUERY += "	SB1.B1_DESC AS 'DESCRICAO'," 												+ ENTER 
CQUERY += "	SD4.D4_QTDEORI	AS 'QUANTIDADE'," 										+ ENTER 
CQUERY += "	SD4.D4_DATA AS 'DATA'," 														+ ENTER 
CQUERY += "	(SD4.D4_QTDEORI - SD4.D4_QUANT) AS 'SALDO'," 								+ ENTER 
CQUERY += "	LEFT('01' + SD4.D4_OP + SPACE(014),14) AS 'ORIGEM'" 						+ ENTER 
CQUERY += "FROM" 																				+ ENTER  
CQUERY += "	" + RETSQLNAME("SD4") + " SD4" 												+ ENTER 
CQUERY += "	INNER JOIN " + RETSQLNAME("SB1") + " SB1 ON" 								+ ENTER  
CQUERY += "		SB1.B1_FILIAL = '" + XFILIAL("SB1") + "' AND" 						+ ENTER  
CQUERY += "		SB1.B1_COD = SD4.D4_COD AND" 											+ ENTER  
CQUERY += "		SB1.D_E_L_E_T_ = ''" 													+ ENTER 
CQUERY += "WHERE" 																			+ ENTER  
CQUERY += "	SD4.D4_FILIAL = '" + XFILIAL("SD4") + "' AND" 							+ ENTER  
CQUERY += "	SD4.D4_OP = '" + CNUMOP + "' AND" 											+ ENTER   
CQUERY += "	SD4.D_E_L_E_T_ = ''" 														+ ENTER 
CQUERY += "" 																					+ ENTER 
CQUERY += "UNION ALL" 																		+ ENTER 
CQUERY += "" 																					+ ENTER 
CQUERY += "SELECT" 																			+ ENTER  
CQUERY += "	'03' AS 'TIPO'," 																+ ENTER  
CQUERY += "	LEFT('03' + SC7.C7_NUM + SPACE(014),14) AS 'DOCUMENTO'," 				+ ENTER 
CQUERY += "	SC7.C7_PRODUTO AS 'PRODUTO'," 												+ ENTER 
CQUERY += "	SB1.B1_DESC AS 'DESCRICAO'," 												+ ENTER 
CQUERY += "	SC7.C7_QUANT AS 'QUANTIDADE'," 												+ ENTER 
CQUERY += "	SC7.C7_EMISSAO AS 'DATA'," 													+ ENTER 
CQUERY += "	(SC7.C7_QUANT - SC7.C7_QUJE) AS 'SALDO'," 								+ ENTER 
CQUERY += "	LEFT('01' + SC7.C7__OPBNFC + SPACE(014),14) AS 'ORIGEM'" 				+ ENTER 
CQUERY += "FROM" 																				+ ENTER  
CQUERY += "	" + RETSQLNAME("SC7") + " SC7" 												+ ENTER 
CQUERY += "	INNER JOIN " + RETSQLNAME("SB1") + " SB1 ON" 								+ ENTER  
CQUERY += "		SB1.B1_FILIAL = '" + XFILIAL("SB1") + "' AND" 						+ ENTER  
CQUERY += "		SB1.B1_COD = SC7.C7_PRODUTO AND" 										+ ENTER  
CQUERY += "		SB1.D_E_L_E_T_ = ''" 													+ ENTER 
CQUERY += "WHERE" 																			+ ENTER 
CQUERY += "	SC7.C7_FILIAL = '" + XFILIAL("SC7") + "' AND" 							+ ENTER  
CQUERY += "	SC7.C7__OPBNFC = '" + CNUMOP + "' AND" 									+ ENTER  
CQUERY += "	SC7.D_E_L_E_T_ = ''" 														+ ENTER 
CQUERY += "" 																					+ ENTER 
CQUERY += "UNION ALL" 																		+ ENTER 
CQUERY += "" 																					+ ENTER 
CQUERY += "SELECT" 																			+ ENTER  
CQUERY += "	'04' AS 'TIPO'," 																+ ENTER 
CQUERY += "	LEFT('04' + SD1.D1_DOC + '/' + SD1.D1_SERIE + SPACE(014),14) AS 'DOCUMENTO',"	+ ENTER 
CQUERY += "	SD1.D1_COD	AS 'PRODUTO'," 													+ ENTER 
CQUERY += "	SB1.B1_DESC AS 'DESCRICAO'," 												+ ENTER 
CQUERY += "	SD1.D1_QUANT AS 'QUANTIDADE'," 												+ ENTER 
CQUERY += "	SD1.D1_EMISSAO AS 'DATA'," 													+ ENTER 
CQUERY += "	0 AS 'SALDO'," 																+ ENTER 
CQUERY += "	LEFT('03' + SD1.D1_PEDIDO + SPACE(014),14) AS 'ORIGEM'" 				+ ENTER 
CQUERY += "FROM" 																				+ ENTER  
CQUERY += "	" + RETSQLNAME("SD1") + " SD1" 												+ ENTER 
CQUERY += "	INNER JOIN " + RETSQLNAME("SB1") + " SB1 ON" 								+ ENTER 
CQUERY += "		SB1.B1_FILIAL = '" + XFILIAL("SB1") + "' AND" 						+ ENTER  
CQUERY += "		SB1.B1_COD = SD1.D1_COD AND" 											+ ENTER  
CQUERY += "		SB1.D_E_L_E_T_ = ''" 													+ ENTER 
CQUERY += "	INNER JOIN " + RETSQLNAME("SC7") + " SC7 ON" 								+ ENTER 
CQUERY += "		SC7.C7_FILIAL = '" + XFILIAL("SC7") + "' AND" 						+ ENTER  
CQUERY += "		SC7.C7_NUM = SD1.D1_PEDIDO AND" 										+ ENTER  
CQUERY += "		SC7.C7_ITEM = SD1.D1_ITEMPC AND" 										+ ENTER  
CQUERY += "		SC7.C7_PRODUTO = SD1.D1_COD AND" 										+ ENTER  
CQUERY += "		SC7.C7__OPBNFC = '" + CNUMOP + "' AND" 								+ ENTER 
CQUERY += "		SC7.D_E_L_E_T_ = ''" 													+ ENTER 
CQUERY += "WHERE" 																			+ ENTER  
CQUERY += "	SD1.D1_FILIAL = '" + XFILIAL("SD1") + "' AND" 							+ ENTER  
CQUERY += "	SD1.D_E_L_E_T_ = ''" 														+ ENTER 
CQUERY += "" 																					+ ENTER 
CQUERY += "UNION ALL" 																		+ ENTER 
CQUERY += "" 																					+ ENTER 
CQUERY += "SELECT" 																			+ ENTER  
CQUERY += "	'05' AS 'TIPO'," 																+ ENTER  
CQUERY += "	LEFT('05' + SC6.C6_NUM + SPACE(014),14) AS 'DOCUMENTO'," 				+ ENTER 
CQUERY += "	SC6.C6_PRODUTO AS 'PRODUTO'," 												+ ENTER 
CQUERY += "	SB1.B1_DESC AS 'DESCRICAO'," 												+ ENTER 
CQUERY += "	SC6.C6_QTDVEN AS 'QUANTIDADE'," 											+ ENTER 
CQUERY += "	SC5.C5_EMISSAO AS 'DATA'," 													+ ENTER 
CQUERY += "	(SC6.C6_QTDVEN - SC6.C6_QTDENT) AS 'SALDO'," 								+ ENTER 
CQUERY += "	LEFT('01' + SC6.C6__OPBNFC + SPACE(014),14) AS 'ORIGEM'" 				+ ENTER 
CQUERY += "FROM" 																				+ ENTER  
CQUERY += "	" + RETSQLNAME("SC6") + " SC6" 												+ ENTER 
CQUERY += "	INNER JOIN " + RETSQLNAME("SB1") + " SB1 ON" 								+ ENTER  
CQUERY += "		SB1.B1_FILIAL = '" + XFILIAL("SB1") + "' AND" 						+ ENTER  
CQUERY += "		SB1.B1_COD = SC6.C6_PRODUTO AND" 										+ ENTER  
CQUERY += "		SB1.D_E_L_E_T_ = ''" 													+ ENTER 
CQUERY += "	INNER JOIN " + RETSQLNAME("SC5") + " SC5 ON" 								+ ENTER  
CQUERY += "		SC5.C5_FILIAL = '" + XFILIAL("SC5") + "' AND" 						+ ENTER  
CQUERY += "		SC5.C5_NUM = SC6.C6_NUM AND" 											+ ENTER  
CQUERY += "		SC5.D_E_L_E_T_= ''" 														+ ENTER 
CQUERY += "WHERE" 																			+ ENTER 
CQUERY += "	SC6.C6_FILIAL = '" + XFILIAL("SC6") + "' AND" 							+ ENTER  
CQUERY += "	RTRIM(SC6.C6__OPBNFC) = '" + CNUMOP + "' AND" 							+ ENTER  
CQUERY += "	SC6.D_E_L_E_T_ = ''" 														+ ENTER 
CQUERY += "" 																					+ ENTER 
CQUERY += "UNION ALL" 																		+ ENTER 
CQUERY += "" 																					+ ENTER 
CQUERY += "SELECT" 																			+ ENTER  
CQUERY += "	'06' AS 'TIPO'," 																+ ENTER 
CQUERY += "	LEFT('06' + SD2.D2_DOC + '/' + SD2.D2_SERIE + SPACE(014),14) AS 'DOCUMENTO',"	+ ENTER 
CQUERY += "	SD2.D2_COD	AS 'PRODUTO'," 													+ ENTER 
CQUERY += "	SB1.B1_DESC AS 'DESCRICAO'," 												+ ENTER 
CQUERY += "	SD2.D2_QUANT AS 'QUANTIDADE'," 												+ ENTER 
CQUERY += "	SD2.D2_EMISSAO AS 'DATA'," 													+ ENTER 
CQUERY += "	(SELECT B6_SALDO FROM " + RETSQLNAME("SB6") + " SB6 WHERE SB6.B6_FILIAL = '" + XFILIAL("SB6") + "' AND SB6.B6_DOC = SD2.D2_DOC AND SB6.B6_SERIE = SD2.D2_SERIE AND SB6.B6_PRODUTO = SD2.D2_COD AND SB6.D_E_L_E_T_ = '') AS 'SALDO',"	+ ENTER 
CQUERY += "	LEFT('05' + SD2.D2_PEDIDO + SPACE(014),14) AS 'ORIGEM'"					+ ENTER 
CQUERY += "FROM" 																				+ ENTER  
CQUERY += "	" + RETSQLNAME("SD2") + " SD2" 												+ ENTER 
CQUERY += "	INNER JOIN " + RETSQLNAME("SB1") + " SB1 ON" 								+ ENTER 
CQUERY += "		SB1.B1_FILIAL = '" + XFILIAL("SB1") + "' AND" 						+ ENTER  
CQUERY += "		SB1.B1_COD = SD2.D2_COD AND" 											+ ENTER  
CQUERY += "		SB1.D_E_L_E_T_ = ''" 													+ ENTER 
CQUERY += "	INNER JOIN " + RETSQLNAME("SC6") + " SC6 ON" 								+ ENTER 
CQUERY += "		SC6.C6_FILIAL = '" + XFILIAL("SC6") + "' AND" 						+ ENTER  
CQUERY += "		SC6.C6_NUM = SD2.D2_PEDIDO AND" 										+ ENTER  
CQUERY += "		SC6.C6_ITEM = SD2.D2_ITEMPV AND" 										+ ENTER  
CQUERY += "		SC6.C6_PRODUTO = SD2.D2_COD AND" 										+ ENTER  
CQUERY += "		RTRIM(SC6.C6__OPBNFC) = '" + CNUMOP + "' AND" 								+ ENTER 
CQUERY += "		SC6.D_E_L_E_T_ = ''" 													+ ENTER 
CQUERY += "WHERE" 																			+ ENTER  
CQUERY += "	SD2.D2_FILIAL = '" + XFILIAL("SD2") + "' AND" 							+ ENTER  
CQUERY += "	SD2.D_E_L_E_T_ = ''" 														+ ENTER 
CQUERY += "" 																					+ ENTER 
CQUERY += "UNION ALL" 																		+ ENTER 
CQUERY += "" 																					+ ENTER 
CQUERY += "SELECT" 																			+ ENTER  
CQUERY += "	'07' AS 'TIPO'," 																+ ENTER 
CQUERY += "	LEFT('07' + SD1.D1_DOC + '/' + SD1.D1_SERIE + SPACE(014),14) AS 'DOCUMENTO'," 	+ ENTER 
CQUERY += "	SD1.D1_COD	AS 'PRODUTO'," 													+ ENTER 
CQUERY += "	SB1.B1_DESC AS 'DESCRICAO'," 												+ ENTER 
CQUERY += "	SD1.D1_QUANT AS 'QUANTIDADE'," 												+ ENTER 
CQUERY += "	SD1.D1_EMISSAO AS 'DATA'," 													+ ENTER 
CQUERY += "	0 AS 'SALDO'," 																+ ENTER 
CQUERY += "	LEFT('06' + SD1.D1_NFORI + '/' + SD1.D1_SERIORI + SPACE(014),14) AS 'ORIGEM'" 	+ ENTER 
CQUERY += "FROM" 																				+ ENTER  
CQUERY += "	" + RETSQLNAME("SD1") + " SD1" 												+ ENTER 
CQUERY += "	INNER JOIN " + RETSQLNAME("SB1") + " SB1 ON" 								+ ENTER 
CQUERY += "		SB1.B1_FILIAL = '" + XFILIAL("SB1") + "' AND" 						+ ENTER  
CQUERY += "		SB1.B1_COD = SD1.D1_COD AND" 											+ ENTER  
CQUERY += "		SB1.D_E_L_E_T_ = ''" 													+ ENTER 
CQUERY += "WHERE" 																			+ ENTER  
CQUERY += "	SD1.D1_FILIAL = '" + XFILIAL("SD1") + "' AND" 							+ ENTER  
CQUERY += "	SD1.D1_NFORI + SD1.D1_SERIORI + SD1.D1_ITEMORI IN" 						+ ENTER  
CQUERY += "		(" 																			+ ENTER 
CQUERY += "			SELECT" 																+ ENTER  				
CQUERY += "				SD2.D2_DOC + SD2.D2_SERIE + SD2.D2_ITEM" 						+ ENTER 
CQUERY += "			FROM" 																	+ ENTER  
CQUERY += "				" + RETSQLNAME("SD2") + " SD2" 									+ ENTER 
CQUERY += "				INNER JOIN " + RETSQLNAME("SC6") + " SC6 ON" 					+ ENTER 
CQUERY += "					SC6.C6_FILIAL = '" + XFILIAL("SC6") + "' AND" 			+ ENTER  
CQUERY += "					SC6.C6_NUM = SD2.D2_PEDIDO AND" 							+ ENTER  
CQUERY += "					SC6.C6_ITEM = SD2.D2_ITEMPV AND" 							+ ENTER  
CQUERY += "					SC6.C6_PRODUTO = SD2.D2_COD AND" 							+ ENTER   
CQUERY += "					RTRIM(SC6.C6__OPBNFC) = '" + CNUMOP + "' AND" 					+ ENTER 
CQUERY += "					SC6.D_E_L_E_T_ = ''" 										+ ENTER 
CQUERY += "			WHERE" 																+ ENTER  
CQUERY += "				SD2.D2_FILIAL = '" + XFILIAL("SD2") + "' AND" 				+ ENTER  
CQUERY += "				SD2.D_E_L_E_T_ = ''" 											+ ENTER 
CQUERY += "		) AND" 																	+ ENTER  
CQUERY += "	SD1.D_E_L_E_T_ = ''" 

IF SELECT("RST") > 0 
	DBSELECTAREA("RST")
	DBCLOSEAREA()
ENDIF 

MEMOWRITE("C:\TEMP\TRACKER.SQL",CQUERY)
TCQUERY CQUERY NEW ALIAS "RST" 
DBSELECTAREA("RST")
DBGOTOP()
COUNT TO NREG 

IF NREG > 0 
	
	ODLGGRP 	:= MSDIALOG():NEW(ATELA[7] / 1.5,0,ATELA[6] / 1.5,ATELA[5] / 1.5,"Rastreabilidade Beneficiamento",,,,,CLR_WHITE,CLR_BLACK,,ODLGBNF,.T.)
	
	MENU OMENUTREE POPUP
	MENUITEM "Visualizar" ACTION VISUALTREE(OGRAPH)
	ENDMENU
		
	OGRAPH		:= DBTREE():NEW(AOBJ008[1,1],AOBJ008[1,2],AOBJ008[1,3],AOBJ008[1,4],ODLGGRP,,,.T.,,)
	OGRAPH:LSHOWHINT := .F.
	OGRAPH:SETSCROLL(1,.T.)
	OGRAPH:SETSCROLL(2,.T.)
	OGRAPH:BRCLICKED := {|O,NX,NY| OMENUTREE:ACTIVATE(NX,NY,O)}
	
	OGRAPH:BEGINUPDATE()
	
	DBGOTOP()
	WHILE RST->(!EOF())
		
		IF EMPTY(ALLTRIM(CGRUPO)) 
			CGRUPO := RST->DOCUMENTO
		ENDIF  
		DO CASE
			CASE RST->TIPO = "01"	//SE FOR OP
				OGRAPH:ADDTREE("Ordem de Produção: " + RIGHT(ALLTRIM(RST->DOCUMENTO),LEN(ALLTRIM(RST->DOCUMENTO))-2) + " Produto: " + ALLTRIM(RST->PRODUTO) + " - " + ALLTRIM(RST->DESCRICAO) + " - Emissão: " + DTOC(STOD(RST->DATA)) + " - Qtd.: "  + TRANSFORM(RST->QUANTIDADE,"@E 999,999.99") + " - Saldo: " + TRANSFORM(RST->SALDO,"@E 999,999.99"),.T.,"FOLDER01","FOLDER01",,,RST->DOCUMENTO)
			CASE RST->TIPO = "02"	// EMPENHOS
				IF OGRAPH:TREESEEK(RST->ORIGEM)
					OGRAPH:ADDITEM("Empenho Produto: " + ALLTRIM(RST->PRODUTO) + " - " + ALLTRIM(RST->DESCRICAO) + " - Qtd.: " + TRANSFORM(RST->QUANTIDADE,"@E 999,999.99") + " - Saldo: " + TRANSFORM(RST->SALDO,"@E 999,999.99"),"02" + ALLTRIM(RST->PRODUTO) ,"FOLDER02","FOLDER02",,,2)
				ENDIF
			CASE RST->TIPO = "03"	// PEDIDOS DE COMPRA
				IF CGRUPO = RST->DOCUMENTO
					OGRAPH:ADDITEM("Produto: " + ALLTRIM(RST->PRODUTO) + " - " + ALLTRIM(RST->DESCRICAO) + " - Qtd.: " + TRANSFORM(RST->QUANTIDADE,"@E 999,999.99"),"03" + ALLTRIM(RST->PRODUTO),"FOLDER08","FOLDER08",,,2)
				ELSEIF OGRAPH:TREESEEK(RST->ORIGEM)
					CGRUPO := RST->DOCUMENTO
					OGRAPH:ADDITEM("Pedido Compra: " + RIGHT(ALLTRIM(RST->DOCUMENTO),LEN(ALLTRIM(RST->DOCUMENTO))-2),RST->DOCUMENTO ,"FOLDER03","FOLDER03",,,2)
					OGRAPH:TREESEEK(RST->DOCUMENTO)
					OGRAPH:ADDITEM("Produto: " + ALLTRIM(RST->PRODUTO) + " - " + ALLTRIM(RST->DESCRICAO) + " - Qtd.: " + TRANSFORM(RST->QUANTIDADE,"@E 999,999.99"),"03" + ALLTRIM(RST->PRODUTO),"FOLDER08","FOLDER08",,,2)
				ENDIF
			CASE RST->TIPO = "04"	// NOTAS DE ENTRADA MO/MA
				IF CGRUPO = RST->DOCUMENTO
					 OGRAPH:ADDITEM("Produto: " + ALLTRIM(RST->PRODUTO) + " - " + ALLTRIM(RST->DESCRICAO) + " - Qtd.: " + TRANSFORM(RST->QUANTIDADE,"@E 999,999.99"),"04" + ALLTRIM(RST->PRODUTO),"FOLDER08","FOLDER08",,,2)
				ELSEIF OGRAPH:TREESEEK(RST->ORIGEM)
					CGRUPO := RST->DOCUMENTO
					OGRAPH:ADDITEM("NF Serviço: " + RIGHT(ALLTRIM(RST->DOCUMENTO),LEN(ALLTRIM(RST->DOCUMENTO))-2),RST->DOCUMENTO ,"FOLDER04","FOLDER04",,,2)
					OGRAPH:TREESEEK(RST->DOCUMENTO)
					OGRAPH:ADDITEM("Produto: " + ALLTRIM(RST->PRODUTO) + " - " + ALLTRIM(RST->DESCRICAO) + " - Qtd.: " + TRANSFORM(RST->QUANTIDADE,"@E 999,999.99"),"04" + ALLTRIM(RST->PRODUTO),"FOLDER08","FOLDER08",,,2)
				ENDIF
			CASE RST->TIPO = "05"	// PEDIDOS DE VENDA
				IF CGRUPO = RST->DOCUMENTO
					OGRAPH:ADDITEM("Produto: " + ALLTRIM(RST->PRODUTO) + " - " + ALLTRIM(RST->DESCRICAO) + " - Qtd.: " + TRANSFORM(RST->QUANTIDADE,"@E 999,999.99"),"05" + ALLTRIM(RST->PRODUTO),"FOLDER08","FOLDER08",,,2)
				ELSEIF OGRAPH:TREESEEK(RST->ORIGEM)
					CGRUPO := RST->DOCUMENTO
					OGRAPH:ADDITEM("Pedido Venda: " + RIGHT(ALLTRIM(RST->DOCUMENTO),LEN(ALLTRIM(RST->DOCUMENTO))-2),RST->DOCUMENTO ,"FOLDER05","FOLDER05",,,2)
					OGRAPH:TREESEEK(RST->DOCUMENTO)
					OGRAPH:ADDITEM("Produto: " + ALLTRIM(RST->PRODUTO) + " - " + ALLTRIM(RST->DESCRICAO) + " - Qtd.: " + TRANSFORM(RST->QUANTIDADE,"@E 999,999.99"),"05" + ALLTRIM(RST->PRODUTO),"FOLDER08","FOLDER08",,,2)
				ENDIF				
			CASE RST->TIPO = "06"	// NOTAS DE SAIDA
				IF CGRUPO = RST->DOCUMENTO
					OGRAPH:ADDITEM("Produto: " + ALLTRIM(RST->PRODUTO) + " - " + ALLTRIM(RST->DESCRICAO) + " - Qtd.: " + TRANSFORM(RST->QUANTIDADE,"@E 999,999.99"),"06" + ALLTRIM(RST->PRODUTO),"FOLDER08","FOLDER08",,,2)
				ELSEIF OGRAPH:TREESEEK(RST->ORIGEM)
					CGRUPO := RST->DOCUMENTO
					OGRAPH:ADDITEM("NF Benef.: " + RIGHT(ALLTRIM(RST->DOCUMENTO),LEN(ALLTRIM(RST->DOCUMENTO))-2),RST->DOCUMENTO ,"FOLDER06","FOLDER06",,,2)
					OGRAPH:TREESEEK(RST->DOCUMENTO)
					OGRAPH:ADDITEM("Produto: " + ALLTRIM(RST->PRODUTO) + " - " + ALLTRIM(RST->DESCRICAO) + " - Qtd.: " + TRANSFORM(RST->QUANTIDADE,"@E 999,999.99"),"06" + ALLTRIM(RST->PRODUTO),"FOLDER08","FOLDER08",,,2)
				ENDIF
			CASE RST->TIPO = "07"	// NOTAS ENTRADA RETORNO
				IF CGRUPO = RST->DOCUMENTO
					OGRAPH:ADDITEM("Produto: " + ALLTRIM(RST->PRODUTO) + " - " + ALLTRIM(RST->DESCRICAO) + " - Qtd.: " + TRANSFORM(RST->QUANTIDADE,"@E 999,999.99"),"07" + ALLTRIM(RST->PRODUTO),"FOLDER08","FOLDER08",,,2)
				ELSEIF OGRAPH:TREESEEK(RST->ORIGEM)
					CGRUPO := RST->DOCUMENTO
					OGRAPH:ADDITEM("NF Retorno: " + RIGHT(ALLTRIM(RST->DOCUMENTO),LEN(ALLTRIM(RST->DOCUMENTO))-2),RST->DOCUMENTO ,"FOLDER07","FOLDER07",,,2)
					OGRAPH:TREESEEK(RST->DOCUMENTO)
					OGRAPH:ADDITEM("Produto: " + ALLTRIM(RST->PRODUTO) + " - " + ALLTRIM(RST->DESCRICAO) + " - Qtd.: " + TRANSFORM(RST->QUANTIDADE,"@E 999,999.99"),"07" + ALLTRIM(RST->PRODUTO),"FOLDER08","FOLDER08",,,2)
				ENDIF
		ENDCASE
		RST->(DBSKIP())
		
	ENDDO	
	
	OGRAPH:ENDUPDATE()
	OGRAPH:CURRENTNODEID := 1	
	ODLGGRP:ACTIVATE(,,,.T.)
	
	CURSORARROW()
	
ENDIF 

SETKEY(VK_F6,{|| VEREMPENHOS(OGRID01)})

RETURN

/*
=================================================================================
=================================================================================
||   Arquivo:	TFCOMBNF.prw
=================================================================================
||   Funcao: 	VISUALTREE
=================================================================================
||   Descricao
||-------------------------------------------------------------------------------
|| 		Função para visualização do Item selecionado na dbTree.
|| 
=================================================================================
=================================================================================
||   Autor:	Edson Hornberger 
||   Data:		11/02/2016
=================================================================================
=================================================================================
*/

STATIC FUNCTION VISUALTREE(OTREE) 
		
DO CASE 
	
	CASE OTREE:NIVEL() = 1
		MESSAGEBOX("NIVEL " + STR(OTREE:NIVEL()) + " - CARGO " + OTREE:GETCARGO(),"ATENÇÃO",64)
	OTHERWISE
		MESSAGEBOX("NIVEL " + STR(OTREE:NIVEL()) + " - CARGO " + OTREE:GETCARGO(),"ATENÇÃO",64)
	
ENDCASE
		
RETURN


/*
=================================================================================
=================================================================================
||   Arquivo:	TFCOMBNF.prw
=================================================================================
||   Funcao: 	WHENBTN
=================================================================================
||   Descricao
||-------------------------------------------------------------------------------
|| 		Função para Habilitar os Botões de Notas Fiscais (Saída/Entrada)
|| 
=================================================================================
=================================================================================
||   Autor:	Edson Hornberger 
||   Data:		08/01/2016
=================================================================================
=================================================================================
*/

STATIC FUNCTION WHENBTN(ACOLS,OGRID)

LOCAL LRET := .T.
LOCAL NROW := 0 

IF VALTYPE(OGRID:NAT) != "U" .AND. !EMPTY(OGRID:NAT)  
	
	NROW := OGRID:NAT
	LRET := ACOLS[NROW,1] 

ELSE
	
	LRET := .F.
	
ENDIF 

RETURN(LRET)


/*
=================================================================================
=================================================================================
||   Arquivo:	TFCOMBNF.prw
=================================================================================
||   Funcao:	MENUDEF 
=================================================================================
||   Descricao
||-------------------------------------------------------------------------------
|| 		Funcao para gerar as Rotinas Padroes do Processo.
|| 
=================================================================================
=================================================================================
||   Autor:	Edson Hornberger 
||   Data:	06/01/2016
=================================================================================
=================================================================================
*/

STATIC FUNCTION MENUDEF()

PRIVATE aRotina	:= {}

AADD(AROTINA,{"Pesquisar"		,"AXPESQUI"		,0	,1})
AADD(AROTINA,{"Processo"			,"U_SCRBENEF()"	,0	,4})
AADD(AROTINA,{"Apont.Pendentes"	,"U_PRODPEND()"	,0	,4})
AADD(AROTINA,{"Visualizar"		,"A010VISUL"		,0	,2})
AADD(AROTINA,{"Terminar"		,"__QUIT()"		,0	,6})

RETURN(aRotina)

/*
=================================================================================
=================================================================================
||   Arquivo:	TFCOMBNF.prw
=================================================================================
||   Funcao: 	MONTLEG
=================================================================================
||   Descricao
||-------------------------------------------------------------------------------
||		Função para Montagem e Apresentação de Legenda referente a Grid 
|| 	das Ordens de Produção.
|| 
=================================================================================
=================================================================================
||   Autor:	Edson Hornberger 
||   Data:	07/01/2016
=================================================================================
=================================================================================
*/

STATIC FUNCTION MONTLEG()

LOCAL ALEGENDA 	:= 	{}
	
AADD(ALEGENDA, {"BR_VERMELHO_MDI"	,OEMTOANSI("  Processo não Iniciado")})
AADD(ALEGENDA, {"BR_VERDE_MDI"		,OEMTOANSI("  Processo Iniciado")})
AADD(ALEGENDA, {"BR_AZUL_MDI"		,OEMTOANSI("  Processo Iniciado Parcialmente")})
AADD(ALEGENDA, {"BR_AMARELO_MDI"	,OEMTOANSI("  Prazo de Atendimento vencido")})

BRWLEGENDA(CCADASTRO,"LEGENDA",ALEGENDA,15)

RETURN   

/*
=================================================================================
=================================================================================
||   Arquivo:	TFCOMBNF.prw
=================================================================================
||   Funcao: 	PRODPEND
=================================================================================
||   Descricao
||-------------------------------------------------------------------------------
|| 		Função para gerar Planilha em Excel com as Ordens de Produção que estão
|| 	com apontamentos de Produção pendentes.
|| 
=================================================================================
=================================================================================
||   Autor:	Edson Hornberger 
||   Data:		29/02/2016
=================================================================================
=================================================================================
*/

USER FUNCTION PRODPEND()

LOCAL CQUERY 		:= ""
LOCAL NX			:= 0
LOCAL AITENS		:= {}
LOCAL AITTT		:= {}
LOCAL ASTRUCT		:= {}
LOCAL OEXCEL 		:= FWMSEXCEL():NEW()
LOCAL OEXCELAPP
LOCAL CTITSHEET	:= "APONTAMENTOS DE PRODUÇÃO PENDENTES"
LOCAL CTITTABLE	:= "APONTAMENTOS DE PRODUÇÃO PENDENTES"
LOCAL CARQ

CURSORWAIT()

CQUERY := "SELECT "
CQUERY +=  "	SC2.C2_PRODUTO					AS 'PRODUTO', "
CQUERY +=  "	SB1.B1_DESC						AS 'DESCRICAO', "
CQUERY +=  "	SC2.C2_NUM + SC2.C2_ITEM + SC2.C2_SEQUEN	AS 	'OP', "
CQUERY +=  "	SC2.C2_QUANT					AS 'QTD_ORIGINAL', "
CQUERY +=  "	(SC2.C2_QUANT - SC2.C2_QUJE)		AS 'SALDO_DA_OP', "
CQUERY +=  "	SUM(ISNULL(SD3.D3_QUANT,0))		AS 'QTD_JA_PRODUZIDA', "
CQUERY +=  "	( "
CQUERY +=  "		( "
CQUERY +=  "			SELECT TOP(1) "
CQUERY +=  "				(SD4.D4_QTDEORI / (SELECT TOP(1) SG1.G1_QUANT FROM " + RETSQLNAME("SG1") + " SG1 WHERE SG1.G1_FILIAL = '" + XFILIAL("SG1") + "' AND SG1.G1_COD = SC2.C2_PRODUTO AND SG1.D_E_L_E_T_ = '')) -  "
CQUERY +=  "				(SD4.D4_QUANT / (SELECT TOP(1) SG1.G1_QUANT FROM " + RETSQLNAME("SG1") + " SG1 WHERE SG1.G1_FILIAL = '" + XFILIAL("SG1") + "' AND SG1.G1_COD = SC2.C2_PRODUTO AND SG1.D_E_L_E_T_ = '')) "
CQUERY +=  "			FROM  "
CQUERY +=  "				" + RETSQLNAME("SD4") + " SD4  "
CQUERY +=  "			WHERE  "
CQUERY +=  "				SD4.D4_FILIAL = '" + XFILIAL("SD4") + "' AND  "
CQUERY +=  "				SD4.D4_OP = SC2.C2_NUM + SC2.C2_ITEM + SC2.C2_SEQUEN AND  "
CQUERY +=  "				SD4.D_E_L_E_T_ = '' "
CQUERY +=  "		) "
CQUERY +=  "		- SUM(ISNULL(SD3.D3_QUANT,0)) "
CQUERY +=  "	)								AS 'QTD_A_PRODUZIR', "
CQUERY +=  "	DATEDIFF(DAY, CONVERT(DATETIME,SC2.C2_EMISSAO), CONVERT(DATETIME,'" + DTOS(DDATABASE) + "')) AS 'PRAZO' "
CQUERY +=  "FROM  "
CQUERY +=  "	" + RETSQLNAME("SC2") + " SC2  "
CQUERY +=  "	INNER JOIN " + RETSQLNAME("SB1") + " SB1 ON  "
CQUERY +=  "		SB1.B1_FILIAL = '" + XFILIAL("SB1") + "' AND  "
CQUERY +=  "		SB1.B1_COD = SC2.C2_PRODUTO AND  "
CQUERY +=  "		SB1.B1_TIPO = 'BN' AND " 
CQUERY +=  "		SB1.D_E_L_E_T_ = '' "
CQUERY +=  "	LEFT OUTER JOIN " + RETSQLNAME("SD3") + " SD3 ON  "
CQUERY +=  "		SD3.D3_FILIAL = '" + XFILIAL("SD3") + "' AND  "
CQUERY +=  "		SD3.D3_COD = SC2.C2_PRODUTO AND  "
CQUERY +=  "		LEFT(SD3.D3_CF,2) = 'PR' AND "
CQUERY +=  "		SD3.D3_OP = SC2.C2_NUM + SC2.C2_ITEM + SC2.C2_SEQUEN AND "
CQUERY +=  "		SD3.D_E_L_E_T_ = '' "
CQUERY +=  "WHERE  "
CQUERY +=  "	SC2.C2_FILIAL = '" + XFILIAL("SC2") + "' AND  "
CQUERY +=  "	(SC2.C2_QUANT - SC2.C2_QUJE - SC2.C2_PERDA) > 0 AND  "
CQUERY +=  "	SC2.C2__FORNEC != '' AND  "
CQUERY +=  "	SC2.D_E_L_E_T_ = '' "
CQUERY +=  "GROUP BY  "
CQUERY +=  "	SC2.C2_PRODUTO, "
CQUERY +=  "	SB1.B1_DESC, "
CQUERY +=  "	SC2.C2_NUM, "
CQUERY +=  "	SC2.C2_ITEM, "
CQUERY +=  "	SC2.C2_SEQUEN, "
CQUERY +=  "	SC2.C2_QUANT,  "
CQUERY +=  "	SC2.C2_QUJE, "
CQUERY +=  "	SC2.C2_EMISSAO "
CQUERY +=  "ORDER BY  "
CQUERY +=  "	SC2.C2_NUM "

IF .NOT.( APOLECLIENT("MSEXCEL") )
	ALERT("Aplicativo MS Office Excel não está instalado!")
	BREAK
ENDIF

OEXCEL:ADDWORKSHEET(CTITSHEET)
OEXCEL:ADDTABLE(CTITSHEET,CTITTABLE)
OEXCEL:SETTITLESIZEFONT(14)
OEXCEL:SETTITLEBOLD(.T.)
OEXCEL:SETTITLEFRCOLOR("#000000")
OEXCEL:SETTITLEBGCOLOR("#778899")
OEXCEL:SETLINESIZEFONT(12)
OEXCEL:SET2LINESIZEFONT(12)

IF SELECT("TRBEXC") > 0 
	
	DBSELECTAREA("TRBEXC")
	DBCLOSEAREA()
	
ENDIF 

MEMOWRITE("\SYSTEM\BENF_001.SQL",CQUERY)
TCQUERY CQUERY NEW ALIAS "TRBEXC"
DBSELECTAREA("TRBEXC")

ASTRUCT := DBSTRUCT()

FOR NX := 1 TO FCOUNT()
	
	DO CASE
		CASE ASTRUCT[NX,02] = "C"  
			OEXCEL:ADDCOLUMN(CTITSHEET,CTITTABLE,FIELDNAME(NX),2,1)
		CASE ASTRUCT[NX,02] = "N"
			OEXCEL:ADDCOLUMN(CTITSHEET,CTITTABLE,FIELDNAME(NX),2,2)
		CASE ASTRUCT[NX,02] = "D"
			OEXCEL:ADDCOLUMN(CTITSHEET,CTITTABLE,FIELDNAME(NX),2,4)
	ENDCASE 
	
NEXT NX

WHILE TRBEXC->(!EOF()) 
	
	AITENS := {}
	AITTT	:= {}
	
	FOR NX := 1 TO FCOUNT()
	
		AADD(AITENS,&("TRBEXC->" + FIELDNAME(NX)))
		
	NEXT NX  
	
	AADD(AITTT,AITENS)
	OEXCEL:ADDROW(CTITSHEET,CTITTABLE,AITTT[1])
	
	TRBEXC->(DBSKIP())
	
ENDDO

OEXCEL:ACTIVATE()
CARQ := CRIATRAB( NIL, .F. ) + ".XML"
LJMSGRUN( "GERANDO O ARQUIVO, AGUARDE...", CTITTABLE, {|| OEXCEL:GETXMLFILE( CARQ ) } )
SLEEP(3000)
IF __COPYFILE( CARQ, "C:\TEMP\" + CARQ )
		OEXCELAPP := MSEXCEL():NEW()
		OEXCELAPP:WORKBOOKS:OPEN( "C:\TEMP\" + CARQ )
		OEXCELAPP:SETVISIBLE(.T.)
		MSGINFO( "ARQUIVO " + CARQ + " GERADO COM SUCESSO NO DIRETÓRIO C:\TEMP" )
		FERASE( CARQ )
		OEXCELAPP:DESTROY()
ELSE
	MSGINFO( "ARQUIVO NÃO COPIADO PARA TEMPORÁRIO DO USUÁRIO." )
ENDIF

OEXCEL:DEACTIVATE()
CURSORARROW()

RETURN

/*
=================================================================================
=================================================================================
||   Arquivo:	TFCOMBNF.prw
=================================================================================
||   Funcao: 	PLANFOR
=================================================================================
||   Descricao
||-------------------------------------------------------------------------------
|| 		Gera Planilha Excel para enviar para Fornecedor com informações de todos 
|| 	os processos relacionados ao Produto Beneficiado.
|| 
=================================================================================
=================================================================================
||   Autor:	Edson Hornberger 
||   Data:		01/03/2016
=================================================================================
=================================================================================
*/

STATIC FUNCTION PLANFOR(OGRID)

LOCAL CQUERY 		:= ""
LOCAL NX			:= 0
LOCAL AITENS		:= {}
LOCAL AITTT		:= {}
LOCAL ASTRUCT		:= {}
LOCAL OEXCEL 		:= FWMSEXCEL():NEW()
LOCAL OEXCELAPP
LOCAL CTITSHEET	:= "PLANILHA DE PROCESSOS DE BENEFICIAMENTO"
LOCAL CTITTABLE	:= "PLANILHA DE PROCESSOS DE BENEFICIAMENTO"
LOCAL CARQ
LOCAL COP			:= OGRID:AARRAY[OGRID:NAT][2]

CURSORWAIT()

CQUERY := "SELECT" 																							+ ENTER 
CQUERY += "	'ORDEM DE PRODUÇÃO'	AS 'TIPO'," 															+ ENTER 
CQUERY += "	SC2.C2__FORNEC AS 'COD_FORNEC'," 															+ ENTER 
CQUERY += "	SC2.C2__LOJAFO AS 'LOJA'," 																	+ ENTER 
CQUERY += "	SA2.A2_NOME AS 'RAZAO_SOCIAL'," 															+ ENTER 
CQUERY += "	LEFT(SC2.C2_NUM + SC2.C2_ITEM + SC2.C2_SEQUEN + SPACE(014),14) AS 'DOCUMENTO',"		+ ENTER 
CQUERY += "	SC2.C2_PRODUTO AS 'PRODUTO'," 																+ ENTER 
CQUERY += "	SB1.B1_DESC AS 'DESCRICAO'," 																+ ENTER 
CQUERY += "	SC2.C2_QUANT AS 'QUANTIDADE'," 																+ ENTER 
CQUERY += "	CONVERT(VARCHAR(010),CONVERT(DATETIME,SC2.C2_EMISSAO),103) AS 'DATA',"	 			+ ENTER 
CQUERY += "	(SC2.C2_QUANT - SC2.C2_QUJE - SC2.C2_PERDA) AS 'SALDO',"								+ ENTER
CQUERY += "	(" 																								+ ENTER 
CQUERY += "		SELECT TOP(1)" 																			+ ENTER
CQUERY += "			(" 																						+ ENTER
CQUERY += "				SD4.D4_QTDEORI	/ (SELECT TOP(1) SG1.G1_QUANT FROM SG1040 SG1 WHERE SG1.G1_FILIAL = '" + XFILIAL("SG1") + "' AND SG1.G1_COD = SC2.C2_PRODUTO AND SG1.G1_COMP = SD4.D4_COD AND SG1.G1_FIM >= '" + DTOS(DDATABASE) + "' AND D_E_L_E_T_ = '') -" 	+ ENTER 
CQUERY += "				SD4.D4__QTBNFC	/ (SELECT TOP(1) SG1.G1_QUANT FROM SG1040 SG1 WHERE SG1.G1_FILIAL = '" + XFILIAL("SG1") + "' AND SG1.G1_COD = SC2.C2_PRODUTO AND SG1.G1_COMP = SD4.D4_COD AND SG1.G1_FIM >= '" + DTOS(DDATABASE) + "' AND D_E_L_E_T_ = '')" 		+ ENTER 
CQUERY += "			)" 																						+ ENTER 
CQUERY += "		FROM" 																						+ ENTER 
CQUERY += "			" + RETSQLNAME("SD4") + " SD4" 														+ ENTER 
CQUERY += "		WHERE" 																					+ ENTER 
CQUERY += "			SD4.D4_FILIAL = '" + XFILIAL("SD4") + "' AND" 									+ ENTER 
CQUERY += "			SD4.D4_OP = SC2.C2_NUM + SC2.C2_ITEM + SC2.C2_SEQUEN AND" 						+ ENTER 
CQUERY += "			SD4.D_E_L_E_T_ = ''" 																+ ENTER
CQUERY += "	) AS 'SALDO_PROCESSO'," 																		+ ENTER 
CQUERY += "	SPACE(014) AS 'VALORES'" 																	+ ENTER 
CQUERY += "FROM" 																								+ ENTER 
CQUERY += "	" + RETSQLNAME("SC2") + " SC2" 																+ ENTER 
CQUERY += "	INNER JOIN " + RETSQLNAME("SB1") + " SB1 ON" 												+ ENTER 
CQUERY += "		SB1.B1_FILIAL = '" + XFILIAL("SB1") + "' AND" 										+ ENTER 
CQUERY += "		SB1.B1_COD = SC2.C2_PRODUTO AND" 														+ ENTER 
CQUERY += "		SB1.D_E_L_E_T_ = ''" 																	+ ENTER 
CQUERY += "	INNER JOIN " + RETSQLNAME("SA2") + " SA2 ON" 												+ ENTER  
CQUERY += "		SA2.A2_FILIAL = '" + XFILIAL("SA2") + "' AND" 										+ ENTER  
CQUERY += "		SA2.A2_COD = SC2.C2__FORNEC AND" 														+ ENTER  
CQUERY += "		SA2.A2_LOJA = SC2.C2__LOJAFO AND" 														+ ENTER  
CQUERY += "		SA2.D_E_L_E_T_ = ''" 																	+ ENTER 
CQUERY += "WHERE" 																							+ ENTER 
CQUERY += "	SC2.C2_FILIAL = '" + XFILIAL("SC2") + "' AND" 											+ ENTER 
CQUERY += "	SC2.C2_NUM + SC2.C2_ITEM + SC2.C2_SEQUEN = '" + COP + "' AND" 							+ ENTER  
CQUERY += "	SC2.D_E_L_E_T_ = ''" 																		+ ENTER 

CQUERY += "UNION ALL" 																						+ ENTER 

CQUERY += "SELECT" 																							+ ENTER 
CQUERY += "	'EMPENHOS' AS 'TIPO'," 																		+ ENTER 
CQUERY += "	SA2.A2_COD	AS 'COD_FORNEC'," 																+ ENTER 
CQUERY += "	SA2.A2_LOJA AS 'LOJA'," 																		+ ENTER 
CQUERY += "	SA2.A2_NOME AS 'RAZAO_SOCIAL'," 															+ ENTER 
CQUERY += "	LEFT(SD4.D4_OP + SPACE(014),14) AS 'DOCUMENTO'," 										+ ENTER 
CQUERY += "	SD4.D4_COD	AS 'PRODUTO'," 																	+ ENTER 
CQUERY += "	SB1.B1_DESC AS 'DESCRICAO'," 																+ ENTER 
CQUERY += "	SD4.D4_QTDEORI	AS 'QUANTIDADE'," 														+ ENTER 
CQUERY += "	CONVERT(VARCHAR(010),CONVERT(DATETIME,SD4.D4_DATA),103) AS 'DATA'," 					+ ENTER 
CQUERY += "	(SD4.D4_QTDEORI - SD4.D4_QUANT) AS 'SALDO'," 												+ ENTER
CQUERY += "	0 AS 'SALDO_PROCESSO'," 																		+ ENTER 
CQUERY += "	SPACE(014) AS 'VALORES'" 																	+ ENTER 
CQUERY += "FROM" 																								+ ENTER 
CQUERY += "	" + RETSQLNAME("SD4") + " SD4" 																+ ENTER 
CQUERY += "	INNER JOIN " + RETSQLNAME("SB1") + " SB1 ON" 												+ ENTER 
CQUERY += "		SB1.B1_FILIAL = '" + XFILIAL("SB1") + "' AND" 										+ ENTER 
CQUERY += "		SB1.B1_COD = SD4.D4_COD AND" 															+ ENTER 
CQUERY += "		SB1.D_E_L_E_T_ = ''" 																	+ ENTER 
CQUERY += "	INNER JOIN " + RETSQLNAME("SC2") + " SC2 ON" 												+ ENTER  
CQUERY += "		SC2.C2_FILIAL = '" + XFILIAL("SC2") + "' AND" 										+ ENTER  
CQUERY += "		SC2.C2_NUM + SC2.C2_ITEM + SC2.C2_SEQUEN = SD4.D4_OP AND" 							+ ENTER 
CQUERY += "		SC2.D_E_L_E_T_ = ''" 																	+ ENTER 
CQUERY += "	INNER JOIN " + RETSQLNAME("SA2") + " SA2 ON" 												+ ENTER  
CQUERY += "		SA2.A2_FILIAL  = '" + XFILIAL("SA2") + "' AND" 										+ ENTER  
CQUERY += "		SA2.A2_COD = SC2.C2__FORNEC AND" 														+ ENTER  
CQUERY += "		SA2.A2_LOJA = SC2.C2__LOJAFO AND" 														+ ENTER  
CQUERY += "		SA2.D_E_L_E_T_ = ''" 																	+ ENTER 
CQUERY += "WHERE" 																							+ ENTER 
CQUERY += "	SD4.D4_FILIAL = '" + XFILIAL("SD4") + "' AND" 											+ ENTER 
CQUERY += "	SD4.D4_OP = '" + COP + "' AND" 																+ ENTER 
CQUERY += "	SD4.D_E_L_E_T_ = ''" 																		+ ENTER 

CQUERY += "UNION ALL" 																						+ ENTER 

CQUERY += "SELECT" 																							+ ENTER 
CQUERY += "	'PEDIDO DE COMPRA' AS 'TIPO'," 																+ ENTER 
CQUERY += "	SC7.C7_FORNECE AS 'COD_FORNEC'," 															+ ENTER 
CQUERY += "	SC7.C7_LOJA AS 'LOJA'," 																		+ ENTER 
CQUERY += "	SA2.A2_NOME AS 'RAZAO_SOCIAL'," 															+ ENTER 
CQUERY += "	LEFT(SC7.C7_NUM + SPACE(014),14) AS 'DOCUMENTO'," 										+ ENTER 
CQUERY += "	SC7.C7_PRODUTO AS 'PRODUTO'," 																+ ENTER 
CQUERY += "	SB1.B1_DESC AS 'DESCRICAO'," 																+ ENTER 
CQUERY += "	SC7.C7_QUANT AS 'QUANTIDADE'," 																+ ENTER 
CQUERY += "	CONVERT(VARCHAR(010),CONVERT(DATETIME,SC7.C7_EMISSAO),103) AS 'DATA'," 				+ ENTER 
CQUERY += "	(SC7.C7_QUANT - SC7.C7_QUJE) AS 'SALDO'," 												+ ENTER 
CQUERY += "	0 AS 'SALDO_PROCESSO'," 																		+ ENTER
CQUERY += "	SPACE(014) AS 'VALORES'" 																	+ ENTER 
CQUERY += "FROM" 																								+ ENTER 
CQUERY += "	" + RETSQLNAME("SC7") + " SC7" 																+ ENTER 
CQUERY += "	INNER JOIN " + RETSQLNAME("SB1") + " SB1 ON" 												+ ENTER 
CQUERY += "		SB1.B1_FILIAL = '" + XFILIAL("SB1") + "' AND" 										+ ENTER 
CQUERY += "		SB1.B1_COD = SC7.C7_PRODUTO AND" 														+ ENTER 
CQUERY += "		SB1.D_E_L_E_T_ = ''" 																	+ ENTER 
CQUERY += "	INNER JOIN " + RETSQLNAME("SA2") + " SA2 ON" 												+ ENTER  
CQUERY += "		SA2.A2_FILIAL = '" + XFILIAL("SA2") + "' AND" 										+ ENTER  
CQUERY += "		SA2.A2_COD = SC7.C7_FORNECE AND" 														+ ENTER  
CQUERY += "		SA2.A2_LOJA = SC7.C7_LOJA AND" 															+ ENTER  
CQUERY += "		SA2.D_E_L_E_T_ = ''" 																	+ ENTER 
CQUERY += "WHERE" 																							+ ENTER 
CQUERY += "	SC7.C7_FILIAL = '" + XFILIAL("SC7") + "' AND" 											+ ENTER 
CQUERY += "	SC7.C7__OPBNFC = '" + COP + "' AND" 														+ ENTER 
CQUERY += "	SC7.D_E_L_E_T_ = ''" 																		+ ENTER 

CQUERY += "UNION ALL" 																						+ ENTER 

CQUERY += "SELECT" 																							+ ENTER 
CQUERY += "	'NF DE SERVIÇO' AS 'TIPO'," 																+ ENTER 
CQUERY += "	SD1.D1_FORNECE AS 'COD_FORNEC'," 															+ ENTER 
CQUERY += "	SD1.D1_LOJA AS 'LOJA'," 																		+ ENTER 
CQUERY += "	SA2.A2_NOME AS 'RAZAO_SOCIAL'," 															+ ENTER 
CQUERY += "	LEFT(SD1.D1_DOC + '/' + SD1.D1_SERIE + SPACE(014),14) AS 'DOCUMENTO'," 				+ ENTER 
CQUERY += "	SD1.D1_COD	AS 'PRODUTO'," 																	+ ENTER 
CQUERY += "	SB1.B1_DESC AS 'DESCRICAO'," 																+ ENTER 
CQUERY += "	SD1.D1_QUANT AS 'QUANTIDADE'," 																+ ENTER 
CQUERY += "	CONVERT(VARCHAR(010),CONVERT(DATETIME,SD1.D1_EMISSAO),103) AS 'DATA'," 				+ ENTER 
CQUERY += "	0 AS 'SALDO'," 																				+ ENTER 
CQUERY += "	0 AS 'SALDO_PROCESSO'," 																		+ ENTER
CQUERY += "	SD1.D1_TOTAL AS 'VALORES'" 																	+ ENTER 
CQUERY += "FROM" 																								+ ENTER 
CQUERY += "	" + RETSQLNAME("SD1") + " SD1" 																+ ENTER 
CQUERY += "	INNER JOIN " + RETSQLNAME("SB1") + " SB1 ON" 												+ ENTER 
CQUERY += "		SB1.B1_FILIAL = '" + XFILIAL("SB1") + "' AND" 										+ ENTER 
CQUERY += "		SB1.B1_COD = SD1.D1_COD AND" 															+ ENTER 
CQUERY += "		SB1.D_E_L_E_T_ = ''" 																	+ ENTER 
CQUERY += "	INNER JOIN " + RETSQLNAME("SC7") + " SC7 ON" 												+ ENTER 
CQUERY += "		SC7.C7_FILIAL = '" + XFILIAL("SC7") + "' AND" 										+ ENTER 
CQUERY += "		SC7.C7_NUM = SD1.D1_PEDIDO AND" 														+ ENTER 
CQUERY += "		SC7.C7_ITEM = SD1.D1_ITEMPC AND" 														+ ENTER 
CQUERY += "		SC7.C7_PRODUTO = SD1.D1_COD AND" 														+ ENTER 
CQUERY += "		SC7.C7__OPBNFC = '" + COP + "' AND" 													+ ENTER 
CQUERY += "		SC7.D_E_L_E_T_ = ''" 																	+ ENTER 
CQUERY += "	INNER JOIN " + RETSQLNAME("SA2") + " SA2 ON" 												+ ENTER  
CQUERY += "		SA2.A2_FILIAL = '" + XFILIAL("SA2") + "' AND" 										+ ENTER  
CQUERY += "		SA2.A2_COD = SD1.D1_FORNECE AND" 														+ ENTER  
CQUERY += "		SA2.A2_LOJA = SD1.D1_LOJA AND" 															+ ENTER  
CQUERY += "		SA2.D_E_L_E_T_ = ''" 																	+ ENTER 
CQUERY += "WHERE" 																							+ ENTER 
CQUERY += "	SD1.D1_FILIAL = '" + XFILIAL("SD1") + "' AND" 											+ ENTER 
CQUERY += "	SD1.D_E_L_E_T_ = ''" 																		+ ENTER 
 
CQUERY += "UNION ALL" 																						+ ENTER 

CQUERY += "SELECT" 																							+ ENTER 
CQUERY += "	'PEDIDOS DE VENDA' AS 'TIPO'," 																+ ENTER 
CQUERY += "	SC2.C2__FORNEC AS 'COD_FORNEC'," 															+ ENTER 
CQUERY += "	SC2.C2__LOJAFO AS 'LOJA'," 																	+ ENTER 
CQUERY += "	SA2.A2_NOME AS 'RAZAO_SOCIAL'," 															+ ENTER 
CQUERY += "	LEFT(SC6.C6_NUM + SPACE(014),14) AS 'DOCUMENTO'," 										+ ENTER 
CQUERY += "	SC6.C6_PRODUTO AS 'PRODUTO'," 																+ ENTER 
CQUERY += "	SB1.B1_DESC AS 'DESCRICAO'," 																+ ENTER 
CQUERY += "	SC6.C6_QTDVEN AS 'QUANTIDADE'," 															+ ENTER 
CQUERY += "	CONVERT(VARCHAR(010),CONVERT(DATETIME,SC5.C5_EMISSAO),103) AS 'DATA'," 				+ ENTER 
CQUERY += "	(SC6.C6_QTDVEN - SC6.C6_QTDENT) AS 'SALDO'," 												+ ENTER
CQUERY += "	0 AS 'SALDO_PROCESSO'," 																		+ ENTER 
CQUERY += "	SPACE(014) AS 'VALORES'" 																	+ ENTER 
CQUERY += "FROM" 																								+ ENTER 
CQUERY += "	" + RETSQLNAME("SC6") + " SC6" 																+ ENTER 
CQUERY += "	INNER JOIN " + RETSQLNAME("SB1") + " SB1 ON" 												+ ENTER 
CQUERY += "		SB1.B1_FILIAL = '" + XFILIAL("SB1") + "' AND" 										+ ENTER 
CQUERY += "		SB1.B1_COD = SC6.C6_PRODUTO AND" 														+ ENTER 
CQUERY += "		SB1.D_E_L_E_T_ = ''" 																	+ ENTER 
CQUERY += "	INNER JOIN " + RETSQLNAME("SC5") + " SC5 ON" 												+ ENTER 
CQUERY += "		SC5.C5_FILIAL = '" + XFILIAL("SC5") + "' AND" 										+ ENTER 
CQUERY += "		SC5.C5_NUM = SC6.C6_NUM AND" 															+ ENTER 
CQUERY += "		SC5.D_E_L_E_T_= ''" 																		+ ENTER 
CQUERY += "	INNER JOIN " + RETSQLNAME("SC2") + " SC2 ON" 												+ ENTER  
CQUERY += "		SC2.C2_FILIAL = '" + XFILIAL("SC2") + "' AND" 										+ ENTER  
CQUERY += "		SC2.C2_NUM + SC2.C2_ITEM + SC2.C2_SEQUEN = RTRIM(SC6.C6__OPBNFC) AND" 					+ ENTER 
CQUERY += "		SC2.D_E_L_E_T_ = ''" 																	+ ENTER 
CQUERY += "	INNER JOIN " + RETSQLNAME("SA2") + " SA2 ON" 												+ ENTER  
CQUERY += "		SA2.A2_FILIAL  = '" + XFILIAL("SA2") + "' AND" 										+ ENTER  
CQUERY += "		SA2.A2_COD = SC2.C2__FORNEC AND" 														+ ENTER  
CQUERY += "		SA2.A2_LOJA = SC2.C2__LOJAFO AND" 														+ ENTER  
CQUERY += "		SA2.D_E_L_E_T_ = ''" 																	+ ENTER 
CQUERY += "WHERE" 																							+ ENTER 
CQUERY += "	SC6.C6_FILIAL = '" + XFILIAL("SC6") + "' AND" 											+ ENTER 
CQUERY += "	RTRIM(SC6.C6__OPBNFC) = '" + COP + "' AND" 														+ ENTER 
CQUERY += "	SC6.D_E_L_E_T_ = ''" 																		+ ENTER 

CQUERY += "UNION ALL" 																						+ ENTER 

CQUERY += "SELECT" 																							+ ENTER 
CQUERY += "	'NF DE BENEFICIAMENTO' AS 'TIPO'," 														+ ENTER 
CQUERY += "	SC2.C2__FORNEC AS 'COD_FORNEC'," 															+ ENTER 
CQUERY += "	SC2.C2__LOJAFO AS 'LOJA'," 																	+ ENTER 
CQUERY += "	SA2.A2_NOME AS 'RAZAO_SOCIAL'," 															+ ENTER 
CQUERY += "	LEFT(SD2.D2_DOC + '/' + SD2.D2_SERIE + SPACE(014),14) AS 'DOCUMENTO'," 				+ ENTER 
CQUERY += "	SD2.D2_COD	AS 'PRODUTO'," 																	+ ENTER 
CQUERY += "	SB1.B1_DESC AS 'DESCRICAO'," 																+ ENTER 
CQUERY += "	SD2.D2_QUANT AS 'QUANTIDADE'," 																+ ENTER 
CQUERY += "	CONVERT(VARCHAR(010),CONVERT(DATETIME,SD2.D2_EMISSAO),103) AS 'DATA'," 				+ ENTER 
CQUERY += "	(SELECT B6_SALDO FROM " + RETSQLNAME("SB6") + " SB6 WHERE SB6.B6_FILIAL = '" + XFILIAL("SB6") + "' AND SB6.B6_DOC = SD2.D2_DOC AND SB6.B6_SERIE = SD2.D2_SERIE AND SB6.B6_PRODUTO = SD2.D2_COD AND SB6.D_E_L_E_T_ = '') AS 'SALDO'," + ENTER
CQUERY += "	0 AS 'SALDO_PROCESSO'," 																		+ ENTER 
CQUERY += "	SD2.D2_TOTAL AS 'VALORES'" 																	+ ENTER 
CQUERY += "FROM" 																								+ ENTER 
CQUERY += "	" + RETSQLNAME("SD2") + " SD2" 																+ ENTER 
CQUERY += "	INNER JOIN " + RETSQLNAME("SB1" ) + " SB1 ON" 											+ ENTER 
CQUERY += "		SB1.B1_FILIAL = '" + XFILIAL("SB1") + "' AND" 										+ ENTER 
CQUERY += "		SB1.B1_COD = SD2.D2_COD AND" 															+ ENTER 
CQUERY += "		SB1.D_E_L_E_T_ = ''" 																	+ ENTER 
CQUERY += "	INNER JOIN " + RETSQLNAME("SC6") + " SC6 ON" 												+ ENTER 
CQUERY += "		SC6.C6_FILIAL = '" + XFILIAL("SC6") + "' AND" 										+ ENTER 
CQUERY += "		SC6.C6_NUM = SD2.D2_PEDIDO AND" 														+ ENTER 
CQUERY += "		SC6.C6_ITEM = SD2.D2_ITEMPV AND" 														+ ENTER 
CQUERY += "		SC6.C6_PRODUTO = SD2.D2_COD AND" 														+ ENTER 
CQUERY += "		RTRIM(SC6.C6__OPBNFC) = '" + COP + "' AND" 											+ ENTER 
CQUERY += "		SC6.D_E_L_E_T_ = ''" 																	+ ENTER 
CQUERY += "	INNER JOIN " + RETSQLNAME("SC2") + " SC2 ON" 												+ ENTER  
CQUERY += "		SC2.C2_FILIAL = '" + XFILIAL("SC2") + "' AND" 										+ ENTER  
CQUERY += "		SC2.C2_NUM + SC2.C2_ITEM + SC2.C2_SEQUEN = RTRIM(SC6.C6__OPBNFC) AND" 			+ ENTER 
CQUERY += "		SC2.D_E_L_E_T_ = ''" 																	+ ENTER 
CQUERY += "	INNER JOIN " + RETSQLNAME("SA2") + " SA2 ON" 												+ ENTER  
CQUERY += "		SA2.A2_FILIAL  = '" + XFILIAL("SA2") + "' AND" 										+ ENTER  
CQUERY += "		SA2.A2_COD = SC2.C2__FORNEC AND" 														+ ENTER  
CQUERY += "		SA2.A2_LOJA = SC2.C2__LOJAFO AND" 														+ ENTER  
CQUERY += "		SA2.D_E_L_E_T_ = ''" 																	+ ENTER 
CQUERY += "WHERE" 																							+ ENTER 
CQUERY += "	SD2.D2_FILIAL = '02' AND" 																	+ ENTER 
CQUERY += "	SD2.D_E_L_E_T_ = ''" 																		+ ENTER 

CQUERY += "UNION ALL" 																						+ ENTER 

CQUERY += "SELECT" 																							+ ENTER 
CQUERY += "	'NF DE RETORNO' AS 'TIPO'," 																+ ENTER 
CQUERY += "	SD1.D1_FORNECE AS 'COD_FORNEC'," 															+ ENTER 
CQUERY += "	SD1.D1_LOJA AS 'LOJA'," 																		+ ENTER 
CQUERY += "	SA2.A2_NOME AS 'RAZAO_SOCIAL'," 															+ ENTER 
CQUERY += "	LEFT(SD1.D1_DOC + '/' + SD1.D1_SERIE + SPACE(014),14) AS 'DOCUMENTO'," 				+ ENTER 
CQUERY += "	SD1.D1_COD	AS 'PRODUTO'," 																	+ ENTER 
CQUERY += "	SB1.B1_DESC AS 'DESCRICAO'," 																+ ENTER 
CQUERY += "	SD1.D1_QUANT AS 'QUANTIDADE'," 																+ ENTER 
CQUERY += "	CONVERT(VARCHAR(010),CONVERT(DATETIME,SD1.D1_EMISSAO),103) AS 'DATA'," 				+ ENTER 
CQUERY += "	0 AS 'SALDO'," 																				+ ENTER 
CQUERY += "	0 AS 'SALDO_PROCESSO'," 																		+ ENTER
CQUERY += "	SD1.D1_TOTAL AS 'VALORES'" 																	+ ENTER 
CQUERY += "FROM" 																								+ ENTER 
CQUERY += "	" + RETSQLNAME("SD1") + " SD1" 																+ ENTER 
CQUERY += "	INNER JOIN " + RETSQLNAME("SB1") + " SB1 ON" 												+ ENTER 
CQUERY += "		SB1.B1_FILIAL = '" + XFILIAL("SB1") + "' AND" 										+ ENTER 
CQUERY += "		SB1.B1_COD = SD1.D1_COD AND" 															+ ENTER 
CQUERY += "		SB1.D_E_L_E_T_ = ''" 																	+ ENTER 
CQUERY += "	INNER JOIN " + RETSQLNAME("SA2") + " SA2 ON" 												+ ENTER  
CQUERY += "		SA2.A2_FILIAL = '" + XFILIAL("SA2") + "' AND" 										+ ENTER  
CQUERY += "		SA2.A2_COD = SD1.D1_FORNECE AND" 														+ ENTER  
CQUERY += "		SA2.A2_LOJA = SD1.D1_LOJA AND" 															+ ENTER  
CQUERY += "		SA2.D_E_L_E_T_ = ''" 																	+ ENTER 
CQUERY += "WHERE" 																							+ ENTER 
CQUERY += "	SD1.D1_FILIAL = '" + XFILIAL("SD1") + "' AND" 											+ ENTER 
CQUERY += "	SD1.D1_NFORI + SD1.D1_SERIORI + SD1.D1_ITEMORI IN" 										+ ENTER 
CQUERY += "		(" 																							+ ENTER 
CQUERY += "			SELECT" 																				+ ENTER 
CQUERY += "				SD2.D2_DOC + SD2.D2_SERIE + SD2.D2_ITEM" 										+ ENTER 
CQUERY += "			FROM" 																					+ ENTER 
CQUERY += "				" + RETSQLNAME("SD2") + " SD2" 													+ ENTER 
CQUERY += "				INNER JOIN " + RETSQLNAME("SC6") + " SC6 ON" 									+ ENTER 
CQUERY += "					SC6.C6_FILIAL = '" + XFILIAL("SC6") + "' AND" 							+ ENTER 
CQUERY += "					SC6.C6_NUM = SD2.D2_PEDIDO AND" 											+ ENTER 
CQUERY += "					SC6.C6_ITEM = SD2.D2_ITEMPV AND" 											+ ENTER 
CQUERY += "					SC6.C6_PRODUTO = SD2.D2_COD AND" 											+ ENTER 
CQUERY += "					RTRIM(SC6.C6__OPBNFC) = '" + COP + "' AND" 										+ ENTER 
CQUERY += "					SC6.D_E_L_E_T_ = ''" 														+ ENTER 
CQUERY += "			WHERE" 																				+ ENTER 
CQUERY += "				SD2.D2_FILIAL = '" + XFILIAL("SS2") + "' AND" 								+ ENTER 
CQUERY += "				SD2.D_E_L_E_T_ = ''" 															+ ENTER 
CQUERY += "		) AND" 																					+ ENTER 
CQUERY += "	SD1.D_E_L_E_T_ = ''"

IF .NOT.( APOLECLIENT("MSEXCEL") )
	ALERT("Aplicativo MS Office Excel não está instalado!")
	BREAK
ENDIF

OEXCEL:ADDWORKSHEET(CTITSHEET)
OEXCEL:ADDTABLE(CTITSHEET,CTITTABLE)
OEXCEL:SETTITLESIZEFONT(14)
OEXCEL:SETTITLEBOLD(.T.)
OEXCEL:SETTITLEFRCOLOR("#000000")
OEXCEL:SETTITLEBGCOLOR("#778899")
OEXCEL:SETLINESIZEFONT(12)
OEXCEL:SET2LINESIZEFONT(12)

IF SELECT("TRBEXC") > 0 
	
	DBSELECTAREA("TRBEXC")
	DBCLOSEAREA()
	
ENDIF 

MEMOWRITE("\SYSTEM\PLANILHA_FOR.SQL",CQUERY)
TCQUERY CQUERY NEW ALIAS "TRBEXC"
DBSELECTAREA("TRBEXC")

ASTRUCT := DBSTRUCT()

FOR NX := 1 TO FCOUNT()
	
	DO CASE
		CASE ASTRUCT[NX,02] = "C"  
			OEXCEL:ADDCOLUMN(CTITSHEET,CTITTABLE,FIELDNAME(NX),2,1)
		CASE ASTRUCT[NX,02] = "N"
			OEXCEL:ADDCOLUMN(CTITSHEET,CTITTABLE,FIELDNAME(NX),2,2)
		CASE ASTRUCT[NX,02] = "D"
			OEXCEL:ADDCOLUMN(CTITSHEET,CTITTABLE,FIELDNAME(NX),2,4)
	ENDCASE 
	
NEXT NX

WHILE TRBEXC->(!EOF()) 
	
	AITENS := {}
	AITTT	:= {}
	
	FOR NX := 1 TO FCOUNT()
	
		AADD(AITENS,&("TRBEXC->" + FIELDNAME(NX)))
		
	NEXT NX  
	
	AADD(AITTT,AITENS)
	OEXCEL:ADDROW(CTITSHEET,CTITTABLE,AITTT[1])
	
	TRBEXC->(DBSKIP())
	
ENDDO

OEXCEL:ACTIVATE()
CARQ := CRIATRAB( NIL, .F. ) + ".XML"
LJMSGRUN( "GERANDO O ARQUIVO, AGUARDE...", CTITTABLE, {|| OEXCEL:GETXMLFILE( CARQ ) } )
SLEEP(3000)
IF __COPYFILE( CARQ, "C:\TEMP\" + CARQ )
		OEXCELAPP := MSEXCEL():NEW()
		OEXCELAPP:WORKBOOKS:OPEN( "C:\TEMP\" + CARQ )
		OEXCELAPP:SETVISIBLE(.T.)
		MSGINFO( "ARQUIVO " + CARQ + " GERADO COM SUCESSO NO DIRETÓRIO C:\TEMP" )
		FERASE( CARQ )
		OEXCELAPP:DESTROY()
ELSE
	MSGINFO( "ARQUIVO NÃO COPIADO PARA TEMPORÁRIO DO USUÁRIO." )
ENDIF

OEXCEL:DEACTIVATE()

CURSORARROW()

RETURN 
