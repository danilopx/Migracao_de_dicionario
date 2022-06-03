#INCLUDE 'TOTVS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'TOPCONN.CH'
#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'TBICONN.CH'
#INCLUDE 'TBICODE.CH'
#INCLUDE 'TOPCONN.CH'

#DEFINE PULA CHR(13) + CHR(10)

/*
=================================================================================
=================================================================================
||   Arquivo: FISP001.PRW
=================================================================================
||   Funcao: 	FISP001
=================================================================================
||   Descricao
||-------------------------------------------------------------------------------
|| 		Tela para que o Departamento Contábil/Fiscal possa realizar o controle
||  de datas limites de movimentações.
|| 
=================================================================================
=================================================================================
*/

USER FUNCTION FISP001()
                     
/*
|---------------------------------------------------------------------------------
|	USUARIOS QUE PODERAO REALIZAR ALTERACOES NOS PARAMETROS ( = CONTROLE DO TES)
|   000703 - PATRICIA LIMA
|   000979 - JOSE ROBERTO LEANDRO
|---------------------------------------------------------------------------------
*/

LOCAL _CTESUSERS	:= GETNEWPAR( "TF_USERMVS", "000703|000979" )

/*
|---------------------------------------------------------------------------------
|	USUARIOS QUE PODERAO REALIZAR ALTERACOES NOS PARAMETROS DO ESTOQUE
|   000068 - ROSE ARAÚJO
|   000120 - DOUGLAS RODRIGUES FORNAZIER
|---------------------------------------------------------------------------------
*/
LOCAL _CUSERSEST	:= GETNEWPAR( "TF_USEREST", "000068|000120" )

/*
|---------------------------------------------------------------------------------
| 	VARIAVEIS PARA REALIZAR QUERY NO BANCO DE DADOS
|---------------------------------------------------------------------------------
*/

LOCAL CQUERY 		:= ""
LOCAL AINFO		:= {}

/*
|---------------------------------------------------------------------------------
|	VALORES DOS PARAMETROS
|---------------------------------------------------------------------------------
*/

LOCAL CDTAFISCAL 	:= ""
LOCAL CDTADECONT	:= ""
LOCAL CDTAATCONT	:= ""
LOCAL QTHRCANCNF	:= Space(3) 
 
LOCAL CDTAMOVEST	:= "" 
LOCAL CDTAFECEST	:= ""
LOCAL CANTMOVEST	:= "" 
LOCAL CANTFECEST	:= ""

LOCAL CDTAFINANC	:= ""
 
LOCAL CDTAFOLHAP	:= "" 
LOCAL CBLQFOLHAP	:= ""
 

/*
|---------------------------------------------------------------------------------
|	VARIAVEIS PARA MONTAGEM DA TELA
|---------------------------------------------------------------------------------
*/

PRIVATE ODLG001

PRIVATE OGRPCTB
PRIVATE OGRPFIN
PRIVATE OGRPEST
PRIVATE OGRPGPE
PRIVATE OGRPHLP

PRIVATE OLBL1CTB
PRIVATE OLBL2CTB
PRIVATE OLBL3CTB
PRIVATE OLBL4CTB

PRIVATE OLBL1EST
PRIVATE OLBL2EST

PRIVATE OLBL1FIN

PRIVATE OLBL1GPE
PRIVATE OLBL2GPE

PRIVATE OGET1CTB
PRIVATE OGET2CTB
PRIVATE OGET3CTB
PRIVATE OGET4CTB

PRIVATE OGET1EST
PRIVATE OGET2EST

PRIVATE OGET1FIN

PRIVATE OGET1GPE
PRIVATE OGET2GPE

PRIVATE OFONT001	:= TFONT():NEW('COURIER NEW',,-15,.T.)
PRIVATE OFONT002	:= TFONT():NEW('COURIER NEW',,-14,.T.)
PRIVATE OFONT003	:= TFONT():NEW('COURIER NEW',,-12,.F.)

PRIVATE OBTN001
PRIVATE OBTN002

PRIVATE LEND 		:= .F.

PRIVATE OLBLHLP
PRIVATE CLBLHLP	:= ""

PRIVATE LINICIO	:= .T.


IF !(__CUSERID $ _CTESUSERS)
	
	MSGSTOP("Usuário sem direitos para realizar Manutenção em Parâmetros!")
	RETURN

ENDIF

CLBLHLP := 'Informações sobre o Parâmetro. Posicione o Cursor sobre o Parâmetro.'

CDTAFISCAL	:= IIF(EMPTY(ALLTRIM(DTOS(GETMV("MV_DATAFIS")))),SPACE(08), ALLTRIM(DTOS(GETMV("MV_DATAFIS"))))	/* MV_DATAFIS - Ultima data de encerramento de operacoes fiscais.*/
CDTADECONT	:= IIF(EMPTY(ALLTRIM(DTOS(GETMV("MV_DATADE")))),SPACE(08), ALLTRIM(DTOS(GETMV("MV_DATADE"))))	/* MV_DATADE - Data inicio competencia para digitacao dos lanctos. Valido para contabilidade.*/
CDTAATCONT	:= IIF(EMPTY(ALLTRIM(DTOS(GETMV("MV_DATAATE")))),SPACE(08), ALLTRIM(DTOS(GETMV("MV_DATAATE"))))	/* MV_DATAATE - Data fim de competencia para digitacao dos lctos. Valido para Contabilidade.*/
QTHRCANCNF	:= TRANSFORM(GETMV("MV_SPEDEXC"), "@E 999")																			/* MV_SPEDEXC - Indique a quantidade de Horas que o sistema irá permitir para cancelamento de Notas Fiscais. Valor Padrão (24)*/
 
CDTAMOVEST	:= IIF(EMPTY(ALLTRIM(DTOS(GETMV("MV_DBLQMOV")))),SPACE(08), ALLTRIM(DTOS(GETMV("MV_DBLQMOV"))))	/* MV_DBLQMOV - Data para bloqueio de movimentos no estoque. Não podem ser alterados / criados / excluidos movimentos com data menor ou igual a data informada no parametro.*/ 
CDTAFECEST	:= IIF(EMPTY(ALLTRIM(DTOS(GETMV("MV_ULMES")))),SPACE(08), ALLTRIM(DTOS(GETMV("MV_ULMES"))))		/* MV_ULMES - Data ultimo fechamento do estoque.*/
CANTMOVEST	:= IIF(EMPTY(ALLTRIM(DTOS(GETMV("MV_DBLQMOV")))),SPACE(08), ALLTRIM(DTOS(GETMV("MV_DBLQMOV"))))	/* MV_DBLQMOV - Data para bloqueio de movimentos no estoque. Não podem ser alterados / criados / excluidos movimentos com data menor ou igual a data informada no parametro.*/ 
CANTFECEST	:= IIF(EMPTY(ALLTRIM(DTOS(GETMV("MV_ULMES")))),SPACE(08), ALLTRIM(DTOS(GETMV("MV_ULMES"))))		/* MV_ULMES - Data ultimo fechamento do estoque.*/

CDTAFINANC	:= IIF(EMPTY(ALLTRIM(DTOS(GETMV("MV_DATAFIN")))),SPACE(08), ALLTRIM(DTOS(GETMV("MV_DATAFIN"))))	/* MV_DATAFIN - Data limite p/ realizacao de operacoes financeiras.*/
 
CDTAFOLHAP	:= IIF(EMPTY(ALLTRIM(GETMV("MV_FOLMES"))),SPACE(08),	ALLTRIM(GETMV("MV_FOLMES")))			/* MV_FOLMES - Ano e Mes de competencia para calculo da folha*/ 
CBLQFOLHAP	:= IIF(EMPTY(ALLTRIM(GETMV("MV_BLOQSEM"))),SPACE(01), ALLTRIM(GETMV("MV_BLOQSEM")))				/* MV_BLOQSEM - Indique se a rotina de controle de acesso ira validar a semana digitada GPE.*/ 


DEFINE MSDIALOG ODLG001 TITLE "Parâmetros de Controle de Alteração" FROM 000,000 TO 545,690 PIXEL

	OGRPHLP 	:= TGROUP():NEW(002,002,050,340,'ESPECIFICAÇÕES DO PARÂMETRO'	,ODLG001,CLR_BLUE,CLR_HGRAY,.T.)
	OLBLHLP 	:= TSAY():NEW(020,010,{||CLBLHLP},OGRPHLP,,OFONT003,,,,.T.,CLR_BLACK,CLR_HGRAY,300,40)
	
	OGRPCTB 	:= TGROUP():NEW(054,002,154,168,'PARÂMETROS CTB / FIS'			,ODLG001,CLR_RED,CLR_HGRAY,.T.)
	OLBL1CTB	:= TSAY():NEW(064,007,{||'MV_DATAFIS'},OGRPCTB,,OFONT001,,,,.T.,CLR_RED,CLR_HGRAY,080,010)
	OGET1CTB	:= TGET():NEW(064,067,{|U| IF(PCOUNT()>0,CDTAFISCAL:=U,CDTAFISCAL)},OGRPCTB,080,010,"@!",,0	,,,.F.,,.T.,,,,,,,,,,'CDTAFISCAL')
	OLBL2CTB	:= TSAY():NEW(084,007,{||'MV_DATADE'},OGRPCTB,,OFONT001,,,,.T.,CLR_RED,CLR_HGRAY,080,010)
	OGET2CTB	:= TGET():NEW(084,067,{|U| IF(PCOUNT()>0,CDTADECONT:=U,CDTADECONT)},OGRPCTB,080,010,"@!",,0	,,,.F.,,.T.,,,,,,,,,,'CDTADECONT')
	OLBL3CTB	:= TSAY():NEW(104,007,{||'MV_DATAATE'},OGRPCTB,,OFONT001,,,,.T.,CLR_RED,CLR_HGRAY,080,010)
	OGET3CTB	:= TGET():NEW(104,067,{|U| IF(PCOUNT()>0,CDTAATCONT:=U,CDTAATCONT)},OGRPCTB,080,010,"@!",,0	,,,.F.,,.T.,,,,,,,,,,'CDTAATCONT')
	OLBL4CTB	:= TSAY():NEW(124,007,{||'MV_SPEDEXC'},OGRPCTB,,OFONT001,,,,.T.,CLR_RED,CLR_HGRAY,080,010)
	OGET4CTB	:= TGET():NEW(124,067,{|U| IF(PCOUNT()>0,QTHRCANCNF:=U,QTHRCANCNF)},OGRPCTB,080,010,"@!",,0	,,,.F.,,.T.,,,,,,,,,,'QTHRCANCNF')
	
	
	OGRPFIN 	:= TGROUP():NEW(054,170,154,340,'PARÂMETROS FIN'					,ODLG001,CLR_RED,CLR_HGRAY,.T.)
	OLBL1FIN	:= TSAY():NEW(064,175,{||'MV_DATAFIN'},OGRPFIN,,OFONT001,,,,.T.,CLR_RED,CLR_HGRAY,080,010)
	OGET1FIN	:= TGET():NEW(064,235,{|U| IF(PCOUNT()>0,CDTAFINANC:=U,CDTAFINANC)},OGRPFIN,080,010,"@!",,0	,,,.F.,,.T.,,,,,,,,,,'CDTAFINANC')
	
	OGRPEST 	:= TGROUP():NEW(156,002,256,168,'PARÂMETROS EST'					,ODLG001,CLR_RED,CLR_HGRAY,.T.)
	OLBL1EST	:= TSAY():NEW(166,007,{||'MV_DBLQMOV'},OGRPEST,,OFONT001,,,,.T.,CLR_RED,CLR_HGRAY,080,010)
							//	1   2   3                                             4       5   6   7   8		
	OGET1EST	:= TGET():NEW(166,067,{|U| IF(PCOUNT()>0,CDTAMOVEST:=U,CDTAMOVEST)},OGRPEST,080,010,"@!",{|lRet| VERIFUSER(_CUSERSEST,CDTAMOVEST,CANTMOVEST,1)},0	,,,.F.,,.T.,,,,,,,,,,'CDTAMOVEST')
	OLBL2EST	:= TSAY():NEW(186,007,{||'MV_ULMES'},OGRPEST,,OFONT001,,,,.T.,CLR_RED,CLR_HGRAY,080,010)
							//	1   2   3                                             4       5   6   7   8	
	OGET2EST	:= TGET():NEW(186,067,{|U| IF(PCOUNT()>0,CDTAFECEST:=U,CDTAFECEST)},OGRPEST,080,010,"@!",{|lRet| VERIFUSER(_CUSERSEST,CDTAFECEST,CANTFECEST,2)},0	,,,.F.,,.T.,,,,,,,,,,'CDTAFECEST')
	
	OGRPGPE 	:= TGROUP():NEW(156,170,256,340,'PARÂMETROS GPE'					,ODLG001,CLR_RED,CLR_HGRAY,.T.)
	OLBL1GPE	:= TSAY():NEW(166,175,{||'MV_FOLMES'},OGRPGPE,,OFONT001,,,,.T.,CLR_RED,CLR_HGRAY,080,010)
	OGET1GPE	:= TGET():NEW(166,235,{|U| IF(PCOUNT()>0,CDTAFOLHAP:=U,CDTAFOLHAP)},OGRPGPE,080,010,"@!",,0	,,,.F.,,.T.,,,,,,,,,,'CDTAFOLHAP')
	OLBL2GPE	:= TSAY():NEW(186,175,{||'MV_BLOQSEM'},OGRPGPE,,OFONT001,,,,.T.,CLR_RED,CLR_HGRAY,080,010)
	OGET2GPE	:= TGET():NEW(186,235,{|U| IF(PCOUNT()>0,CBLQFOLHAP:=U,CBLQFOLHAP)},OGRPGPE,080,010,"@!",,0	,,,.F.,,.T.,,,,,,,,,,'CBLQFOLHAP')
			
	OBTN001 	:= TBUTTON():NEW( 260, 256, "OK",ODLG001,{|| LEND := .T.,ODLG001:END()},40,10,,,.F.,.T.,.F.,,.F.,,,.F. )
	OBTN002 	:= TBUTTON():NEW( 260, 300, "CANCELA",ODLG001,{||ODLG001:END()},40,10,,,.F.,.T.,.F.,,.F.,,,.F. )
 	
 	OGET1CTB:BGOTFOCUS := {|O| U_AltLgda(1,@CLBLHLP,OLBLHLP,LINICIO)}
 	OGET2CTB:BGOTFOCUS := {|O| U_AltLgda(2,@CLBLHLP,OLBLHLP,LINICIO)}
 	OGET3CTB:BGOTFOCUS := {|O| U_AltLgda(3,@CLBLHLP,OLBLHLP,LINICIO)}
 	OGET4CTB:BGOTFOCUS := {|O| U_AltLgda(4,@CLBLHLP,OLBLHLP,LINICIO)}
 	OGET1FIN:BGOTFOCUS := {|O| U_AltLgda(5,@CLBLHLP,OLBLHLP,LINICIO)}
 	OGET1EST:BGOTFOCUS := {|O| U_AltLgda(6,@CLBLHLP,OLBLHLP,LINICIO)}
 	OGET2EST:BGOTFOCUS := {|O| U_AltLgda(7,@CLBLHLP,OLBLHLP,LINICIO)}
 	OGET1GPE:BGOTFOCUS := {|O| U_AltLgda(8,@CLBLHLP,OLBLHLP,LINICIO)}
 	OGET2GPE:BGOTFOCUS := {|O| U_AltLgda(9,@CLBLHLP,OLBLHLP,LINICIO)}
 	
	OLBLHLP:REFRESH()
	LINICIO := .F.

ACTIVATE MSDIALOG ODLG001 CENTERED

/*
|---------------------------------------------------------------------------------
|	GRAVA AS INFORMACOES NOS PARAMETROS
|---------------------------------------------------------------------------------
*/

IF LEND
	
	PUTMV("MV_DATAFIS"	,STOD(CDTAFISCAL))
	PUTMV("MV_DATADE"	,STOD(CDTADECONT))
	PUTMV("MV_DATAATE"	,STOD(CDTAATCONT)) 
	PUTMV("MV_SPEDEXC"	,QTHRCANCNF)
	PUTMV("MV_DBLQMOV"	,STOD(CDTAMOVEST)) 
	PUTMV("MV_ULMES"	,STOD(CDTAFECEST))
	PUTMV("MV_DATAFIN"	,STOD(CDTAFINANC))	 
	PUTMV("MV_FOLMES"	,CDTAFOLHAP) 
	PUTMV("MV_BLOQSEM"	,CBLQFOLHAP) 
			
	
	IF SELECT("TRB") > 0 
		
		DBSELECTAREA("TRB")
		DBCLOSEAREA()
		
	ENDIF
	
	/*
	|=================================================================================
	|   COMENTARIO
	|---------------------------------------------------------------------------------
	|	CASO NAO EXISTA A TABELA DE LOG SERA CRIADO AUTOMATICAMENTE. 
	|
	|=================================================================================
	*/
	
	CQUERY := "IF ISNULL(OBJECT_ID('LOG_PARAMETROS'), 0) = 0" 		+ PULA
	CQUERY += "	BEGIN" 												+ PULA
	CQUERY += "		CREATE TABLE"									+ PULA
	CQUERY += "			LOG_PARAMETROS" 							+ PULA 
	CQUERY += " 				("									+ PULA
	CQUERY += "					EMPRESA	VARCHAR(002) NOT NULL,"		+ PULA
	CQUERY += "					FILIAL 	VARCHAR(002) NOT NULL,"		+ PULA
	CQUERY += "					DATAMODIF	VARCHAR(008) NOT NULL,"	+ PULA
	CQUERY += "					HORAMODIF	VARCHAR(008) NOT NULL,"	+ PULA
	CQUERY += "					USUARIO	VARCHAR(050) NOT NULL,"		+ PULA
	CQUERY += "					FISCAL		VARCHAR(008),"			+ PULA /* MV_DATAFIS - Ultima data de encerramento de operacoes fiscais.*/
	CQUERY += "					CONTABDE	VARCHAR(008),"			+ PULA /* MV_DATADE - Data inicio competencia para digitacao dos lanctos. Valido para contabilidade.*/
	CQUERY += "					CONTABATE	VARCHAR(008),"			+ PULA /* MV_DATAATE - Data fim de competencia para digitacao dos lctos. Valido para Contabilidade.*/
	CQUERY += "					MOVEST		VARCHAR(008),"			+ PULA /* MV_DBLQMOV - Data para bloqueio de movimentos no estoque. Não podem ser alterados / criados / excluidos movimentos com data menor ou igual a data informada no parametro.*/
	CQUERY += "					ULMES		VARCHAR(008)," 			+ PULA /* MV_ULMES - Data ultimo fechamento do estoque.*/
	CQUERY += "					FINANC		VARCHAR(008)," 			+ PULA /* MV_DATAFIN - Data limite p/ realizacao de operacoes financeiras.*/
	CQUERY += "					FOLMES		VARCHAR(008),"			+ PULA /* MV_FOLMES - Ano e Mes de competencia para calculo da folha*/
	CQUERY += "					VALIDSEM	VARCHAR(001)," 			+ PULA /* MV_BLOQSEM - Indique se a rotina de controle de acesso ira validar a semana digitada GPE.*/
	CQUERY += "					SPEDEXC		VARCHAR(003)" 			+ PULA /* MV_BLOQSEM - Indique se a rotina de controle de acesso ira validar a semana digitada GPE.*/
	CQUERY += "				)"										+ PULA 
	CQUERY += "	END"
	
	IF TCSQLEXEC(CQUERY) < 0 
		
		//MEMOWRITE(GetTempPath() + "/ln" + ALLTRIM(STR(PROCLINE())) + "_FISP001.QRY",CQUERY)
		MSGSTOP(OEMTOANSI("Erro ao tentar criar Tabela de Log de Parâmetros") + PULA + "FONTE: " + ALLTRIM(PROCNAME()) + " LINHA: " + ALLTRIM(STR(PROCLINE())),OEMTOANSI("Alteração de Parâmetros"))
		RETURN()
		
	ENDIF 
	
	/*
	|---------------------------------------------------------------------------------
	|	REALIZA A GRAVACAO DAS INFORMACOES NA TABELA DE LOG
	|---------------------------------------------------------------------------------
	*/
	
	CQUERY := "BEGIN TRAN" 															+ PULA 
	CQUERY += "	INSERT INTO" 														+ PULA 
	CQUERY += "		LOG_PARAMETROS VALUES" 											+ PULA
	CQUERY += "			(" 															+ PULA
	CQUERY += "				'" + CEMPANT + "'," 									+ PULA
	CQUERY += "				'" + CFILANT + "',"		 								+ PULA 
	CQUERY += "				'" + DTOS(DDATABASE) + "'," 							+ PULA
	CQUERY += "				'" + TIME() + "',"		 								+ PULA
	CQUERY += "				'" + SUBSTR(USRFULLNAME(RETCODUSR()),1,50) + "',"		+ PULA 
	CQUERY += "				'" + CDTAFISCAL + "'," 									+ PULA 
	CQUERY += "				'" + CDTADECONT + "'," 									+ PULA 
	CQUERY += "				'" + CDTAATCONT + "'," 									+ PULA 
	CQUERY += "				'" + CDTAMOVEST + "'," 									+ PULA 
	CQUERY += "				'" + CDTAFECEST + "'," 									+ PULA
	CQUERY += "				'" + CDTAFINANC + "'," 									+ PULA
	CQUERY += "				'" + CDTAFOLHAP + "'," 									+ PULA
	CQUERY += "				'" + CBLQFOLHAP + "'," 									+ PULA
	CQUERY += "				'" + QTHRCANCNF + "'" 									+ PULA
	CQUERY += "			)"															+ PULA 
	CQUERY += "IF @@ERROR <> 0 ROLLBACK ELSE COMMIT"
	
	IF TCSQLEXEC(CQUERY) < 0 
		
		//MEMOWRITE(GetTempPath() + "/ln" + ALLTRIM(STR(PROCLINE())) + "_FISP001.QRY",CQUERY)
		MSGSTOP(OEMTOANSI("Erro ao tentar Inserir registro na Tabela de Log de Parâmetros") + PULA + "FONTE: " + ALLTRIM(PROCNAME()) + " LINHA: " + ALLTRIM(STR(PROCLINE())),OEMTOANSI("Alteração de Parâmetros"))
		RETURN()
		
	ENDIF
	
	AADD(AINFO,{DTOC(DDATABASE),TIME(),SUBSTR(USRFULLNAME(RETCODUSR()),1,50),DTOC(STOD(CDTAFINANC))})
	ENVLOG(AINFO)
	
ENDIF

RETURN

/*
=================================================================================
=================================================================================
||   Arquivo: FISP001.PRW
=================================================================================
||   Funcao: 	ALTLGDA
=================================================================================
||   Descricao
||-------------------------------------------------------------------------------
|| 		Funcao que atualiza as informacoes dos parametros no momento em que  
|| 	recebem o Focu no objeto Get.
|| 
=================================================================================
=================================================================================
*/


USER FUNCTION ALTLGDA(NOPCAO,CLABEL,OLABEL,LINICIO)

DO CASE 
	
	CASE NOPCAO = 1 .AND. !LINICIO
		CLABEL := 'Ultima data de encerramento de operacoes fiscais.' 
	CASE NOPCAO = 2 .AND. !LINICIO
		CLABEL := 'Data inicio competencia para digitacao dos lanctos. Valido para contabilidade.'
	CASE NOPCAO = 3 .AND. !LINICIO
		CLABEL := 'Data fim de competencia para digitacao dos lctos. Valido para Contabilidade.'
	CASE NOPCAO = 4 .AND. !LINICIO
		CLABEL := 'Valor em horas que o sistema deverá permitir efetuar cancelamento de Notas Fiscais. Valor Padrão (24)'	
	CASE NOPCAO = 5 .AND. !LINICIO
		CLABEL := 'Data limite p/ realizacao de operacoes financeiras.'
	CASE NOPCAO = 6 .AND. !LINICIO
		CLABEL := 'Data para bloqueio de movimentos no estoque. Não podem ser alterados / criados / excluidos movimentos com data menor ou igual a data informada no parametro.'
	CASE NOPCAO = 7 .AND. !LINICIO
		CLABEL := 'Data ultimo fechamento do estoque.'
	CASE NOPCAO = 8 .AND. !LINICIO
		CLABEL := 'Ano e Mes de competencia para calculo da folha.'
	CASE NOPCAO = 9 .AND. !LINICIO
		CLABEL := 'Indique se a rotina de controle de acesso ira validar a semana digitada GPE.'  			
			
ENDCASE 

OLABEL:CCAPTION := CLABEL
OLABEL:REFRESH()

RETURN(.T.)

/*
=================================================================================
=================================================================================
||   Arquivo:	FISP001.PRW
=================================================================================
||   Funcao:	ENVLOG 
=================================================================================
||   Descricao
||-------------------------------------------------------------------------------
|| 		Funcao para enviar Workflow para o Departamento Financeiro  
|| 
=================================================================================
=================================================================================
||   Autor:	Edson Hornberger
||   Data:		30/01/2014
=================================================================================
==========================================================''=======================
*/

STATIC FUNCTION ENVLOG(ADADOS)

	LOCAL CEMAIL 	:= SUPERGETMV("MV_WORKFIN",.F.,"grp_financeiro@taiff.com.br") 
	LOCAL OPROCESS

//## Cria processo de Workflow
	OPROCESS 				:= TWFPROCESS():NEW( "WFAV3LOG", OEMTOANSI("WORKFLOW - ALTERAÇÕES NO PARÂMETRO MV_DATAFIN - LOGS"))
	OPROCESS:NEWTASK( "WFFINLOG", "\WORKFLOW\WFFINLOG.HTM" )
	OPROCESS:CTO 			:= CEMAIL
	OPROCESS:CSUBJECT 	:= OEMTOANSI("WORKFLOW - ALTERAÇÕES NO PARÂMETRO MV_DATAFIN - LOGS")
	OHTML 					:= OPROCESS:OHTML

//## Anexa os arquivos de LOG e preenche a tabela da pagina HTM com as informacoes dos Pedidos
	OHTML:VALBYNAME("EMPRESA"	,ALLTRIM(SM0->M0_NOME) + " - " + ALLTRIM(SM0->M0_FILIAL))
	AADD(OHTML:VALBYNAME("it.DATA")		,ADADOS[1][1])
	AADD(OHTML:VALBYNAME("it.HORA")		,ADADOS[1][2])
	AADD(OHTML:VALBYNAME("it.USER")		,ADADOS[1][3])
	AADD(OHTML:VALBYNAME("it.PARAM")	,ADADOS[1][4])

//## Envia WorkFlow e Encerra
	OPROCESS:CLIENTNAME( SUBS(CUSUARIO,7,15) )
	OPROCESS:USERSIGA	:= __CUSERID
	OPROCESS:START()
	OPROCESS:FREE()

RETURN()


STATIC FUNCTION VERIFUSER(_CUSERSEST,CDATA1,CDATA2,NGET)

LOCAL LRET := .T. 

IF !(__CUSERID $ _CUSERSEST) .AND. CDATA1 = CDATA2

	LRET := .T.

ELSEIF !(__CUSERID $ _CUSERSEST) .AND. CDATA1 != CDATA2

	LRET := .T.
	
	MSGINFO(OEMTOANSI("Usuário sem direitos para Alterar este Parâmetro!"),OEMTOANSI("Alterações de Parâmetros"))
	
	IF NGET = 1 
		
		OGET1EST:CTEXT := CDATA2
		
	ELSE
	
		OGET2EST:CTEXT := CDATA2
	
	ENDIF 

ELSE
	
	LRET := .T.
	
ENDIF

RETURN(LRET)
