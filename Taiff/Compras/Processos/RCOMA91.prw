#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "TOTVS.CH"
#INCLUDE "XMLXFUN.CH"

#DEFINE ENTER 	CHR(13) + CHR(10)
#DEFINE TAB 	CHR(03)

/*
=================================================================================
=================================================================================
||   ARQUIVO:	RCOMA91.PRW
=================================================================================
||   FUNCAO: 	RCOMA91
=================================================================================
||   DESCRICAO
||-------------------------------------------------------------------------------
|| 		FUNCAO PARA LEITURA DE ARQUIVOS XML REFERENTES A NOTAS FISCAIS DE 
|| 	ENTRADA.
|| 		SERA UTILIZADA COM O SCHEDULE DO SISTEMA PROTHEUS. 
|| 
=================================================================================
=================================================================================
||   AUTOR:	MARCELO CARDOSO 
||   DATA:	??/??/????
=================================================================================
||	 REMODELAGEM DO FONTE
||   AUTOR:	EDSON HORNBERGER
||   DATA:	16/09/2015
=================================================================================
=================================================================================
*/
/*
=================================================================================
||	 LAYOUT DO ARQUIVO DE CONFIGURAÇÃO RCOMA91.INI
||	 Tamanho do Registro 158 bytes
=================================================================================
---------------------------------------------------------------------------------
||	Registro T - Tipo de Nota Fiscal 
---------------------------------------------------------------------------------
||N.| CAMPO							|FORMATO TAM.|POSICAO| NOTAS
---------------------------------------------------------------------------------
||01| IDENTIFICADOR					|CARACTER 01 | 01	 	| "T"
||02| TIPO DA NF   					|NUMERICO 01 | 02	 	| 1=PRE-NOTA 2=NF
||03| (BRANCOS)        				|CARACTER 156| 03	 	| ESPACOS
---------------------------------------------------------------------------------
||	Registro S - Amarração Produto X Fornecedor 
---------------------------------------------------------------------------------
||N.| CAMPO							|FORMATO TAM.|POSICAO| NOTAS
---------------------------------------------------------------------------------
||01| IDENTIFICADOR					|CARACTER 01 | 01	 	| "S"
||02| TIPO DA AMARRACAO				|NUMERICO 01 | 02	 	| 1=SA5 2=EAN 3=B1_COD
||03| (BRANCOS)        				|CARACTER 156| 03	 	| ESPACOS              
---------------------------------------------------------------------------------
||	Registro C - Cabecalho da Nota Fiscal (Campos e Identificadores)
---------------------------------------------------------------------------------
||N.| CAMPO							|FORMATO TAM.|POSICAO| NOTAS
---------------------------------------------------------------------------------
||01| IDENTIFICADOR					|CARACTER 01 | 01	 	| "C"
||02| NOME DO CAMPO NO SF1			|CARACTER 10 | 02	 	| 
||03| CAMPO IDENT. NO XML 			|CARACTER 68 | 12	 	|
||04| UTILIZA DBSEEK      			|CARACTER 01 | 80	 	| 1=SIM 2=NAO
||05| ALIAS DO DBSEEK   	   			|CARACTER 03 | 81	 	|
||06| INDICE DO DBSEEK    			|CARACTER 02 | 84	 	|
||07| CHAVE DE PESQUISA   			|CARACTER 50 | 86		|
||08| CAMPO DE RETORNO DO DBSEEK	|CARACTER 10 | 136	|
||09| TIPO DO CAMPO NO SF1			|CARACTER 01 | 146   | C=CARACTER D=DATA N=NUMERICO
||10| UTILIZA STRZERO      			|CARACTER 01 | 147	| 1=SIM 2=NAO
||11| INICIO NA SUBSTR    			|CARACTER 03 | 148	| 
||12| TAMANHO DA SUBSTR   			|CARACTER 03 | 151	|
||13| VERSAO DO XML UTILIZADO		|CARACTER 04 | 154	| "2.00" "3.10" 
---------------------------------------------------------------------------------
||	Registro I - Item da Nota Fiscal (Campos e Identificadores)
---------------------------------------------------------------------------------
||N.| CAMPO							|FORMATO TAM.|POSICAO| NOTAS
---------------------------------------------------------------------------------
||01| IDENTIFICADOR					|CARACTER 01 | 01	 	| "I"
||02| NOME DO CAMPO NO SD1			|CARACTER 10 | 02	 	| 
||03| CAMPO IDENT. NO XML 			|CARACTER 68 | 12	 	|
||04| UTILIZA DBSEEK      			|CARACTER 01 | 80	 	| 1=SIM 2=NAO
||05| ALIAS DO DBSEEK   	   			|CARACTER 03 | 81		|
||06| INDICE DO DBSEEK    			|CARACTER 02 | 84		|
||07| CHAVE DE PESQUISA   			|CARACTER 50 | 86	 	|
||08| CAMPO DE RETORNO DO DBSEEK	|CARACTER 10 | 136 	|
||09| TIPO DO CAMPO NO SF1			|CARACTER 01 | 146   | C=CARACTER D=DATA N=NUMERICO
||10| UTILIZA STRZERO      			|CARACTER 01 | 147	| 1=SIM 2=NAO
||11| INICIO NA SUBSTR    			|CARACTER 03 | 148	| 
||12| TAMANHO DA SUBSTR   			|CARACTER 03 | 151	|
||13| (BRANCOS)           			|CARACTER 04 | 154	| ESPACOS
---------------------------------------------------------------------------------
=================================================================================
*/

USER FUNCTION RCOMA91(AEMP)

	LOCAL   _CERROR   	:= "" //UTILIZADO NA FUNCAO DE LEITURA DO ARQUIVO XML
	LOCAL   _CWARNING 	:= "" //UTILIZADO NA FUNCAO DE LEITURA DO ARQUIVO XML
	LOCAL 	_AOLDAREA
	LOCAL	_NTAMD1		:= 0
	Local   _NLC		:= 0
	Local   NXML		:= 0
	Local   _NREPEAT	:= 0
	Local 	_NITEMD1	:= 1
	Local   _NX			:= 0
	Local   _NXI		:= 0

	PRIVATE	_NATAMD1	:= 0
	PRIVATE _NAITEMD1	:= 1
	/*
	|---------------------------------------------------------------------------------
	|	PREPARA O AMBIENTE QUANDO CHAMADO PELO SCHEDULE 
	|---------------------------------------------------------------------------------
	*/

	IF VALTYPE(AEMP) == "A"

		IF  LEN(AEMP) > 0

			RPCCLEARENV()
			RPCSETTYPE(3)
			RPCSETENV(AEMP[1], AEMP[2])

		ELSE

			RPCCLEARENV()
			RPCSETTYPE(3)
			//RPCSETENV("01", "01")
			PREPARE ENVIRONMENT EMPRESA "01" FILIAL "01" MODULO "COM"

		ENDIF

	ELSE

		RPCCLEARENV()
		RPCSETTYPE(3)
		//RPCSETENV("01", "01")
		PREPARE ENVIRONMENT EMPRESA "01" FILIAL "01" MODULO "COM"

	ENDIF

	_AOLDAREA := GETAREA()

	PRIVATE _CCONFIG       	:= "RCOMA91.INI"																								//Arquivo de Configuração

	PRIVATE _CFILE         	:= ""
	PRIVATE _CNAME         	:= ""
	PRIVATE OXML           	:= NIL
	PRIVATE _ODET
	PRIVATE AXMLDIR        	:= {}

	PRIVATE _CCFOPDEV      	:= GETMV("MV_XXMLDEV") 																							//CFOP´s de Devolucao de Vendas que nao serao Importadas
	PRIVATE _CCFOKPC       	:= SUPERGETMV("MV_X_CFOPC",, "1902/1903/1924/1925/5902/5903/5924/5925/2902/2903/2924/2925/6902/6903/6924/6925") //CFOP´s onde nao eh necessario vinculo com Pedido
	PRIVATE CDIR           	:= ALLTRIM(SUPERGETMV("MV_XXML_IN",, "\XML\IN"))																	//Pasta onde estao os XML para Leitura
	PRIVATE _CDIRNOIMP     	:= ALLTRIM(SUPERGETMV("MV_XXML_NO",, "\XML\NOIMP"))																//Pasta de XML nao Lidos
	PRIVATE _CDIRDEST      	:= ALLTRIM(SUPERGETMV("MV_XXML_DE",, "\XML\DEST"))																//Pasta de XML Lidos
	PRIVATE _CDESTCLI			:= ALLTRIM(SUPERGETMV("MV_XXML_LOG",,"\XML\LOG"))																//Pasta de LOG´s do Processo
	PRIVATE _CDIRGKO      	:= ALLTRIM(SUPERGETMV("MV_XXML_GKO",,"\GKO_XML_NFE"))														//Pasta de XML do tipo modfrete=1 (Nfe devolução)

	PRIVATE _LOKPROD       	:= .T.
	PRIVATE _LAMARRAPRO	   	:= .T.
	PRIVATE _LOKCFOPPC     	:= .T.
	PRIVATE _LVALUNIT	   		:= .T.
	PRIVATE _LDEVOL			:= .F.
	PRIVATE _LOKPED			:= .T.
	PRIVATE _NITPROD       	:= 0
	PRIVATE _NVALUNIT	   	:= 0
	PRIVATE _CKEYNFE       	:= ""
	PRIVATE _CVERXML       	:= ""
	PRIVATE _CERROS        	:= ""
	PRIVATE _CSEEKPRO      	:= "1"
	PRIVATE _CTIPODOC      	:= "1"
	PRIVATE _CFORN         	:= ""
	PRIVATE _CLOJA         	:= ""
	PRIVATE _CNOME         	:= ""
	PRIVATE _CNOTA         	:= ""
	PRIVATE _CSERI         	:= ""
	PRIVATE _CUM           	:= ""
	PRIVATE _CXEST         	:= ""
	PRIVATE _CPEDCOM       	:= ""
	PRIVATE _CPRODOLD      	:= ""
	PRIVATE _CVLCFDEV      	:= ""
	PRIVATE _CTMPALIAS     	:= GETNEXTALIAS()

	PRIVATE CQUERY			:= ""

	PRIVATE LMSERROAUTO    	:= .F.
	PRIVATE LAUTOERRNOFILE 	:= .T.
	PRIVATE _ACABEC        	:= {}
	PRIVATE _AITENS        	:= {}
	PRIVATE _ASD1          	:= {}
	PRIVATE _ACONFCAB      	:= {}
	PRIVATE _ACONFITE      	:= {}
	PRIVATE _ATPFRET       	:= {}
	PRIVATE _ALINCONF      	:= {}
	PRIVATE _AERRO         	:= {}

	PRIVATE _NTXCONV			:= 1
	PRIVATE _NPOSEMIS			:= 0
	PRIVATE _DEMISSAO			:= DDATABASE

	PRIVATE _CMODFRETE		:= ""
	PRIVATE _CFINFE			:= ""
	PRIVATE CID_ENT			:= ""
	PRIVATE _cGKOAlias		:= GetNextAlias()
	PRIVATE _CDESTNAME 		:= ""


	CONOUT("RCOMA91 --> Iniciando processo de Leitura de XML...")

	/*
	|---------------------------------------------------------------------------------
	|	VERIFICA A EXISTENCIA DO ARQUIVO DE CONFIGURACAO
	|---------------------------------------------------------------------------------
	*/
	IF !FILE(LOWER(_CCONFIG))

		AADD(_AERRO, {	"CRITICAL",;									//*01*/	 "OCORRENCIA",
		"N/A",;                                         //*02*/  "EMPRESA",
		"N/A",;                                         //*03*/  "FILIAL",
		DTOC(DDATABASE),;                               //*04*/  "DATA",
		TIME(),;                                        //*05*/  "HORA",
		_CCONFIG,;                                      //*06*/  "ARQUIVO",
		"ARQUIVO DE CONFIGURACAO NAO ENCONTRADO.",;     //*07*/  "MENSAGEM",
		"",;                                            //*08*/  "FORNECEDOR",
		"",;                                            //*09*/  "LOJA",
		"",;                                            //*10*/  "CNPJ",
		"",;                                            //*11*/  "NOME",
		"",;                                            //*12*/  "NOTA",
		"",;                                            //*13*/  "SERIE",
		"",;                                            //*14*/  "CHAVE",
		"",;                                            //*15*/  "ITEM",
		"",;                                            //*16*/  "COD PROD FORNECEDOR",
		"",;                                            //*17*/  "COD PROD INTERNO",
		"",;                                            //*18*/  "DESCRICAO",
		"" } )		                                    //*19*/  "UNIDADE DE MEDIDA",
		CRIAXLS(_AERRO)
		RETURN

	ENDIF

	/*
	|---------------------------------------------------------------------------------
	|	VERIFICA SE EXISTE O DIRETORIO DE IMPORTACAO DE XML 
	|---------------------------------------------------------------------------------
	*/
	IF !EXISTDIR(CDIR)

		AADD(_AERRO, {	"CRITICAL",;							//*01*/	 "OCORRENCIA",
		"N/A",;                                 //*02*/  "EMPRESA",
		"N/A",;                                 //*03*/  "FILIAL",
		DTOC(DDATABASE),;                       //*04*/  "DATA",
		TIME(),;                                //*05*/  "HORA",
		"",;                                    //*06*/  "ARQUIVO",
		"DIRETORIO " + CDIR + "INEXISTENTE.",;  //*07*/  "MENSAGEM",
		"",;                                    //*08*/  "FORNECEDOR",
		"",;                                    //*09*/  "LOJA",
		"",;                                    //*10*/  "CNPJ",
		"",;                                    //*11*/  "NOME",
		"",;                                    //*12*/  "NOTA",
		"",;                                    //*13*/  "SERIE",
		"",;                                    //*14*/  "CHAVE",
		"",;                                    //*15*/  "ITEM",
		"",;                                    //*16*/  "COD PROD FORNECEDOR",
		"",;                                    //*17*/  "COD PROD INTERNO",
		"",;                                    //*18*/  "DESCRICAO",
		""} )		                            //*19*/  "UNIDADE DE MEDIDA",
		CRIAXLS(_AERRO)
		RETURN

	ENDIF

	/*
	|---------------------------------------------------------------------------------
	|	TIPOS DE FRETE PARA PREENCHIMENTO DE ARRAY DA NOTA FISCAIS 
	|---------------------------------------------------------------------------------
	*/
	AADD(_ATPFRET, {"0", "C"})
	AADD(_ATPFRET, {"1", "F"})
	AADD(_ATPFRET, {"2", "T"})
	AADD(_ATPFRET, {"9", "S"})

	/*
	|---------------------------------------------------------------------------------
	|	DELETA QUALQUER ARQUIVO DE LOG QUE PODE ESTAR NO DIRETORIO DE LEITURA DE XML
	|---------------------------------------------------------------------------------
	*/
	AEVAL(DIRECTORY(CDIR + "\LOGIMPORTXML_*.XML"), { |AFILE| FERASE(AFILE[F_NAME]) })

	/*
	|---------------------------------------------------------------------------------
	|	FAZ A LEITURA DOS ARQUIVOS XML EXISTENTES NO DIRETORIO
	|	E ORDENA POR EMPRESA/FILIAL (EVITANDO MUDANCAS DE ENVIRONMENT´S)
	|---------------------------------------------------------------------------------
	*/
	AXMLDIR := DIRECTORY( CDIR + "\*.XML")
	AXMLDIR := SORTXML(AXMLDIR)

	IF LEN(AXMLDIR) <= 0

		RETURN

	ENDIF

	/*
	|---------------------------------------------------------------------------------
	|	REALIZA A LEITURA DO ARQUIVO DE CONFIGURACAO RCOMA91.INI
	|---------------------------------------------------------------------------------
	*/ 
	FT_FUSE(_CCONFIG)

	WHILE !FT_FEOF()

		_CLINCONF := UPPER(ALLTRIM(FT_FREADLN()))
		AADD(_ALINCONF, _CLINCONF)

		FT_FSKIP()

	ENDDO

	FT_FUSE()

	/*
	|=================================================================================
	|   COMENTARIO
	|---------------------------------------------------------------------------------
	|	INICIO DO PROCESSO DE LEITURA DOS AQRUIVOS XML 
	|
	|=================================================================================
	*/
	FOR NXML:= 1 TO LEN(AXMLDIR)

		_LOKPROD  		:= .T.
		_LAMARRAPRO 	:= .T.
		_LVALUNIT		:= .T.
		_LDEVOL   		:= .F.
		_LOKCFOPPC  	:= .T.
		_LOKPED		:= .T.

		_ACABEC   		:= {}
		_AITENS   		:= {}
		_ACONFCAB 		:= {}
		_ACONFITE 		:= {}

		_CERROS 		:= ""
		_CFORN			:= ""
		_CLOJA			:= ""
		_CCNPJ			:= ""

		/*
		|---------------------------------------------------------------------------------
		|	ABRE O ARQUIVO XML
		|---------------------------------------------------------------------------------
		*/
		_CNAME 		:= ALLTRIM(AXMLDIR[NXML,3])
		_CFILE 		:= ALLTRIM(AXMLDIR[NXML,1])


		IF .NOT. (OXML == NIL)
        	FREEOBJ(OXML)
    	ENDIF
	
		OXML   		:= XMLPARSERFILE(_CFILE, "_", @_CERROR, @_CWARNING)

		CONOUT("RCOMA91 - " + STRZERO(NXML,5) + " - " + _CFILE + " - " + _CERROR)

		_LCHANGE 	:= .F.

		/*
		|---------------------------------------------------------------------------------
		|	FOI REALIZADO ALTERACAO, POIS SOMENTE SERAO IMPORTADAS NFS AUTORIZADAS PELA
		|	SEFAZ, SENDO QUE SOMENTE AS QUE CONTEM A TAG _NFEPROC ESTAO AUTORIZADAS.
		|---------------------------------------------------------------------------------
		*/
		
		IF TYPE("OXML:_NFE") <> "U"
		//IF .NOT. (OXML:_NFE == NIL)

			_CCNPJ	:= OXML:_NFE:_INFNFE:_EMIT:_CNPJ:TEXT
			_CFORN	:= POSICIONE("SA2",3,XFILIAL("SA2") + _CCNPJ,"A2_COD")
			_CLOJA	:= POSICIONE("SA2",3,XFILIAL("SA2") + _CCNPJ,"A2_LOJA")

			AADD(_AERRO, {	"ERROR",;      											//*01*/	 "OCORRENCIA",
			SM0->M0_CODIGO,;                                                        //*02*/  "EMPRESA",
			SM0->M0_CODFIL,;                                                        //*03*/  "FILIAL",
			DTOC(DDATABASE),;                                                       //*04*/  "DATA",
			TIME(),;                                                                //*05*/  "HORA",
			_CNAME,;                                                                //*06*/  "ARQUIVO",
			"NOTA FISCAL NÃO AUTORIZADA NO SEFAZ!!!",;    							//*07*/  "MENSAGEM",
			_CFORN,;                                                                //*08*/  "FORNECEDOR",
			_CLOJA,;                                                                //*09*/  "LOJA",
			_CCNPJ,;                                                                //*10*/  "CNPJ",
			POSICIONE("SA2",1,XFILIAL("SA2") + _CFORN + _CLOJA,"A2_NOME"),;  		//*11*/  "NOME",
			"",;                                                                    //*12*/  "NOTA",
			"",;                                                                    //*13*/  "SERIE",
			"",;                                                                    //*14*/  "CHAVE",
			"",;                                                                    //*15*/  "ITEM",
			"",;                                                                    //*16*/  "COD PROD FORNECEDOR",
			"",;                                                                    //*17*/  "COD PROD INTERNO",
			"",;                                                                    //*18*/  "DESCRICAO",
			""} )				                                                    //*19*/  "UNIDADE DE MEDIDA",



			IF !(FILE(_CDIRNOIMP))

				CRIADIR(_CDIRNOIMP)

			ENDIF

			COPY FILE &(ALLTRIM(CDIR) + "\" + _CNAME) TO &(ALLTRIM(_CDIRNOIMP) + "\NOAUT-" + _CNAME)
			FERASE(ALLTRIM(CDIR) + "\" + _CNAME)
			LOOP

		/*
		|---------------------------------------------------------------------------------
		|	REALIZA O PROCESSAMENTO NORMALMENTE
		|---------------------------------------------------------------------------------
		*/
		ELSEIF TYPE("OXML:_NFEPROC") <> "U"
		//ELSEIF .NOT. (OXML:_NFEPROC == NIL)

			_ODET 		:= OXML:_NFEPROC:_NFE:_INFNFE:_DET
			_LCHANGE 	:= .T.
			_CKEYNFE 	:= ALLTRIM(STRTRAN(UPPER(OXML:_NFEPROC:_NFE:_INFNFE:_ID:TEXT), "NFE", ""))
			_CNOTA   	:= PADL(ALLTRIM(OXML:_NFEPROC:_NFE:_INFNFE:_IDE:_NNF:TEXT),   TAMSX3("F1_DOC")[1],   "0")
			_CSERI	 	:= PADL(ALLTRIM(OXML:_NFEPROC:_NFE:_INFNFE:_IDE:_SERIE:TEXT), TAMSX3("F1_SERIE")[1], "0")

			//_NFEPROC:_NFE:_INFNFE:_TRANSP:_MODFRETE:TEXT = 1 (CIF)
			//_NFEPROC:_NFE:_INFNFE:_IDE:_FINNFE:TEXT  = 4 (DEVOLUÇÃO)
			_CMODFRETE	:= PADL(ALLTRIM(OXML:_NFEPROC:_NFE:_INFNFE:_TRANSP:_MODFRETE:TEXT), 1 , "0")
			_CFINFE 	:= PADL(ALLTRIM(OXML:_NFEPROC:_NFE:_INFNFE:_IDE:_FINNFE:TEXT), 1 , "0")

			// FUNCIONALIDADE DESATIVADA EM 19/03
			// FUNCIONALIDADE ATIVADA EM 23/05
			If ALLTRIM(_CFINFE) = "4" // IRÃO TODOS OS TIPOS DE FRETES FOB ou CIF
				CID_ENT := ""
				_CDESTNAME := "DEV_cliente_emp_???_nfe_" + _CKEYNFE
				IF CEMPANT="03" .AND. CFILANT="01"
					CID_ENT:="000002"
					_CDESTNAME := "DEV_cliente_emp_03_01_nfe_" + _CSERI + _CNOTA + ".XML"
				ELSEIF CEMPANT="03" .AND. CFILANT="02"
					CID_ENT:="000011"
					_CDESTNAME := "DEV_cliente_emp_03_02_nfe_" + _CSERI + _CNOTA + ".XML"
				ELSEIF CEMPANT="04" .AND. CFILANT="02"
					CID_ENT:="000010"
					_CDESTNAME := "DEV_cliente_emp_04_02_nfe_" + _CSERI + _CNOTA + ".XML"
				ENDIF

				IF .NOT. EMPTY(CID_ENT)
					cQuery := " SELECT * FROM TAIFF_GKO_NFE WITH(NOLOCK) "
					cQuery += " WHERE  "
					cQuery += " ID_ENT = '" + CID_ENT + "' "
					cQuery += " AND NFE_ID = '" + ALLTRIM(_CKEYNFE) + "' "

					dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),_cGKOAlias,.T.,.T.)

					Count To nRec

					(_cGKOAlias)->(DbCloseArea())

					If nRec == 0

						cQuery := "INSERT INTO TAIFF_GKO_NFE"
						cQuery += "	("
						cQuery += "		ID_ENT"
						cQuery += "		,NFE_ID"
						cQuery += "	)"
						cQuery += "	SELECT "
						cQuery += "		'" + CID_ENT + "'"
						cQuery += "		,'" + _CKEYNFE + "'"

						IF TCSQLEXEC(cQuery) != 0
						ENDIF
						COPY FILE &(ALLTRIM(CDIR) + "\" + _CNAME) TO &(ALLTRIM(_CDIRGKO) + "\" + _CDESTNAME)

					EndIf
				ENDIF
			EndIf

			OALIAS 		:= "OXML:_NFEPROC:_NFE:_INFNFE:_"

		/*
		|---------------------------------------------------------------------------------
		|	SE FOR NOTA FISCAL CANCELADA COPIA PARA DIRETORIO DE NAO IMPORTADOS E
		|	REALIZA LOOP
		|---------------------------------------------------------------------------------
		*/
		ELSEIF TYPE("OXML:_PROCCANCNFE") <> "U"
		//ELSEIF .NOT. (OXML:_PROCCANCNFE == NIL)

			IF !(FILE(_CDIRNOIMP))

				CRIADIR(_CDIRNOIMP)

			ENDIF

			COPY FILE &(ALLTRIM(CDIR) + "\" + _CNAME) TO &(ALLTRIM(_CDIRNOIMP) + "\" + "CANC-" + _CNAME)
			FERASE(ALLTRIM(CDIR) + "\" + _CNAME)
			LOOP

		/*
		|---------------------------------------------------------------------------------
		|	SE FOR NOTA FISCAL DE SERVICO COPIA PARA DIRETORIO DE NAO IMPORTADOS E
		|	REALIZA LOOP
		|---------------------------------------------------------------------------------
		*/					
		ELSEIF TYPE("OXML:_COMPNFSE")<>"U"
		//ELSEIF .NOT. (OXML:_COMPNFSE == NIL)

			IF !(FILE(_CDIRNOIMP))

				CRIADIR(_CDIRNOIMP)

			ENDIF

			COPY FILE &(ALLTRIM(CDIR) + "\" + _CNAME) TO &(ALLTRIM(_CDIRNOIMP) + "\" + "SERV-" + _CNAME)
			FERASE(ALLTRIM(CDIR) + "\" + _CNAME)
			LOOP

		/*
		|---------------------------------------------------------------------------------
		|	SE FOR CONHECIMENTO DE FRETE COPIA PARA DIRETORIO DE NAO IMPORTADOS E
		|	REALIZA LOOP
		|---------------------------------------------------------------------------------
		*/
		ELSEIF TYPE("OXML:_CTEPROC") <> "U"
		//ELSEIF .NOT. (OXML:_CTEPROC == NIL)

			IF !(FILE(_CDIRNOIMP))

				CRIADIR(_CDIRNOIMP)

			ENDIF

			COPY FILE &(ALLTRIM(CDIR) + "\" + _CNAME) TO &(ALLTRIM(_CDIRNOIMP) + "\" + "CTE-" + _CNAME)
			FERASE(ALLTRIM(CDIR) + "\" + _CNAME)
			LOOP

		/*
		|---------------------------------------------------------------------------------
		|	SE FOR REFERENTE A EVENTOS DE NF COPIA PARA DIRETORIO DE NAO IMPORTADOS E
		|	REALIZA LOOP
		|---------------------------------------------------------------------------------
		*/
		ELSEIF TYPE("OXML:_PROCEVENTONFE") <> "U"
		//ELSEIF .NOT. (OXML:_PROCEVENTONFE == NIL)

			IF !(FILE(_CDIRNOIMP))

				CRIADIR(_CDIRNOIMP)

			ENDIF

			COPY FILE &(ALLTRIM(CDIR) + "\" + _CNAME) TO &(ALLTRIM(_CDIRNOIMP) + "\" + "EVENT-" + _CNAME)
			FERASE(ALLTRIM(CDIR) + "\" + _CNAME)
			LOOP

		/*
		|---------------------------------------------------------------------------------
		|	QUALQUER TIPO DE NF DIFERENTES DE QUALQUER SITUACAO ACIMA COPIA PARA 
		|	DIRETORIO DE NAO IMPORTADOS E REALIZA LOOP
		|---------------------------------------------------------------------------------
		*/
		ELSE

			IF !(FILE(_CDIRNOIMP))

				CRIADIR(_CDIRNOIMP)

			ENDIF

			COPY FILE &(ALLTRIM(CDIR) + "\" + _CNAME) TO &(ALLTRIM(_CDIRNOIMP) + "\NOIDENT-" + _CNAME)
			FERASE(ALLTRIM(CDIR) + "\" + _CNAME)
			LOOP

		ENDIF

		/*
		|---------------------------------------------------------------------------------
		|	VERIFICA SE A NFE EM QUESTAO DESTINA-SE A EMPRESA
		|---------------------------------------------------------------------------------
		*/
		IF TYPE("OXML:_NFE") <> "U"
		//IF .NOT. (OXML:_NFE == NIL)

			_CCNPJEMP := IF(TYPE("OXML:_NFE:_INFNFE:_DEST:_CNPJ:TEXT") == "U" , OXML:_NFE:_INFNFE:_DEST:_CPF:TEXT,OXML:_NFE:_INFNFE:_DEST:_CNPJ:TEXT)
			_CTPEX    := OXML:_NFE:_INFNFE:_DEST:_ENDERDEST:_UF:TEXT
			_CNIMP    := OXML:_NFE:_INFNFE:_DEST:_XNOME:TEXT
			_CCNPJ    := OXML:_NFE:_INFNFE:_EMIT:_CNPJ:TEXT

		ELSE


			_CCNPJEMP := IF(TYPE("OXML:_NFEPROC:_NFE:_INFNFE:_DEST:_CNPJ:TEXT") == "U",OXML:_NFEPROC:_NFE:_INFNFE:_DEST:_CPF:TEXT,OXML:_NFEPROC:_NFE:_INFNFE:_DEST:_CNPJ:TEXT)
			_CTPEX    := OXML:_NFEPROC:_NFE:_INFNFE:_DEST:_ENDERDEST:_UF:TEXT
			_CNIMP    := OXML:_NFEPROC:_NFE:_INFNFE:_DEST:_XNOME:TEXT
			_CCNPJ    := OXML:_NFEPROC:_NFE:_INFNFE:_EMIT:_CNPJ:TEXT

		ENDIF

		/*
		|---------------------------------------------------------------------------------
		|	VERIFICA SE EH PRECISO EFETUAR A TROCA DE EMPRESA/FILIAL
		|---------------------------------------------------------------------------------
		*/
		_ANEWSM0 	:= {"",""}

		IF (ALLTRIM(SM0->M0_CGC) <> ALLTRIM(_CCNPJEMP))

			_ANEWSM0 	:= {"",""}
			_COLDAREA 	:= ALIAS()
			_AOLDAREA 	:= GETAREA()
			_ASM0AREA 	:= SM0->(GETAREA())

			CQUERY := "SELECT M0_CODIGO, M0_CODFIL FROM SM0_COMPANY WHERE M0_CGC = '" + _CCNPJEMP + "'"

			IF SELECT("TMP") > 0

				DBSELECTAREA("TMP")
				DBCLOSEAREA()

			ENDIF

			TCQUERY CQUERY NEW ALIAS "TMP"
			DBSELECTAREA("TMP")
			DBGOTOP()
			COUNT TO _NREPEAT

			IF _NREPEAT > 0

				DBGOTOP()
				_ANEWSM0[1]	:= TMP->M0_CODIGO
				_ANEWSM0[2]	:= TMP->M0_CODFIL

			ENDIF

			DBCLOSEAREA()

			/*
			|---------------------------------------------------------------------------------
			|	SE ARRAY SEM INFORMACOES REGISTRA NO ARQUIVO DE LOG E REALIZA LOOP
			|---------------------------------------------------------------------------------
			*/
			IF _ANEWSM0[1] == "" .AND. _ANEWSM0[2] == ""

				AADD(_AERRO, {	"ERROR",;      															//*01*/	 "OCORRENCIA",
				SM0->M0_CODIGO,;                                                        //*02*/  "EMPRESA",
				SM0->M0_CODFIL,;                                                        //*03*/  "FILIAL",
				DTOC(DDATABASE),;                                                       //*04*/  "DATA",
				TIME(),;                                                                //*05*/  "HORA",
				_CNAME,;                                                                //*06*/  "ARQUIVO",
				"NOTA FISCAL DESTINADA A CNPJ INEXISTENTE NO SISTEMA " + _CCNPJEMP,;    //*07*/  "MENSAGEM",
				"",;                                                                    //*08*/  "FORNECEDOR",
				"",;                                                                    //*09*/  "LOJA",
				"",;                                                                    //*10*/  "CNPJ",
				"",;                                                                    //*11*/  "NOME",
				"",;                                                                    //*12*/  "NOTA",
				"",;                                                                    //*13*/  "SERIE",
				"",;                                                                    //*14*/  "CHAVE",
				"",;                                                                    //*15*/  "ITEM",
				"",;                                                                    //*16*/  "COD PROD FORNECEDOR",
				"",;                                                                    //*17*/  "COD PROD INTERNO",
				"",;                                                                    //*18*/  "DESCRICAO",
				""} )				                                                    //*19*/  "UNIDADE DE MEDIDA",

				IF !(FILE(_CDIRNOIMP))

					CRIADIR(_CDIRNOIMP)

				ENDIF

				COPY FILE &(ALLTRIM(CDIR) + "\" + _CNAME) TO &(ALLTRIM(_CDIRNOIMP) + "\" + "EMPNOEXIST-" + _CNAME)
				FERASE(ALLTRIM(CDIR) + "\" + _CNAME)
				LOOP

			ELSE

				/*
				|---------------------------------------------------------------------------------
				|	SE ACHAR O CNPJ E FOR DIFERENTE DA EMPRESA ATUAL ALTERA O 
				|	AMBIENTE COM A EMPRESA CORRETA.
				|---------------------------------------------------------------------------------
				*/
				IF SM0->M0_CODIGO + SM0->M0_CODFIL <> _ANEWSM0[1] + _ANEWSM0[2]

					CEMPANT := SM0->M0_CODIGO
					CFILANT := SM0->M0_CODFIL

					RPCCLEARENV()
					RPCSETTYPE(3)
					//RPCSETENV(_ANEWSM0[1], _ANEWSM0[2])
					PREPARE ENVIRONMENT EMPRESA _ANEWSM0[1] FILIAL _ANEWSM0[2] MODULO "COM"

				ENDIF

			ENDIF

			/*
			|---------------------------------------------------------------------------------
			|	SE O CNPJ DO DESTINATARIO DA NF FOR IGUAL A EMPRESA QUE ESTA TENTANDO IMPOR-
			|	TAR REGISTRA NO LOG E REALIZA O LOOP
			|---------------------------------------------------------------------------------
			*/
			IF ALLTRIM(_CCNPJEMP) == ALLTRIM(_CCNPJ)

				AADD(_AERRO, {	"ERROR",;      										//*01*/	 "OCORRENCIA",
				SM0->M0_CODIGO,;                                    //*02*/  "EMPRESA",
				SM0->M0_CODFIL,;                                    //*03*/  "FILIAL",
				DTOC(DDATABASE),;                                   //*04*/  "DATA",
				TIME(),;                                            //*05*/  "HORA",
				_CNAME,;                                            //*06*/  "ARQUIVO",
				"NOTA FISCAL DESTINADA AO MESMO CNPJ" + _CCNPJEMP,; //*07*/  "MENSAGEM",
				"",;                                                //*08*/  "FORNECEDOR",
				"",;                                                //*09*/  "LOJA",
				"",;                                                //*10*/  "CNPJ",
				"",;                                                //*11*/  "NOME",
				"",;                                                //*12*/  "NOTA",
				"",;                                                //*13*/  "SERIE",
				"",;                                                //*14*/  "CHAVE",
				"",;                                                //*15*/  "ITEM",
				"",;                                                //*16*/  "COD PROD FORNECEDOR",
				"",;                                                //*17*/  "COD PROD INTERNO",
				"",;                                                //*18*/  "DESCRICAO",
				""} )				                                //*19*/  "UNIDADE DE MEDIDA",

				IF !(FILE(_CDIRNOIMP))

					CRIADIR(_CDIRNOIMP)

				ENDIF

				COPY FILE &(ALLTRIM(CDIR) + "\" + _CNAME) TO &(ALLTRIM(_CDIRNOIMP) + "\" + "CNPJIGUAL-" + _CNAME)
				FERASE(ALLTRIM(CDIR) + "\" + _CNAME)
				LOOP

			ENDIF

		ENDIF

		IF TYPE("OXML:_NFE") <> "U"
		//IF .NOT. (OXML:_NFE == NIL)
			_CXEST := OXML:_NFE:_INFNFE:_DEST:_ENDERDEST:_UF:TEXT
		ELSE
			_CXEST := OXML:_NFEPROC:_NFE:_INFNFE:_DEST:_ENDERDEST:_UF:TEXT
		ENDIF

		/*
		|---------------------------------------------------------------------------------
		|	VERIFICA A VERSAO DO XML CRIA O VETOR COM OS DADOS DOS ITENS DA NOTA/PRE NOTA
		|---------------------------------------------------------------------------------
		*/
		IF TYPE("OXML:_NFEPROC:_VERSAO") <> "U"
		//IF .NOT. (OXML:_NFEPROC:_VERSAO == NIL)

			_CVERXML := ALLTRIM(OXML:_NFEPROC:_VERSAO:TEXT)

		ELSEIF TYPE("OXML:_NFE:_INFNFE:_VERSAO") <> "U"
		//ELSEIF .NOT. (OXML:_NFE:_INFNFE:_VERSAO == NIL)

			_CVERXML := ALLTRIM(OXML:_NFE:_INFNFE:_VERSAO:TEXT)

		ENDIF

		IF EMPTY(ALLTRIM(_CVERXML))

			_CVERXML := "2.00"

		ENDIF

		/*
		|---------------------------------------------------------------------------------
		|	CRIA O VETOR COM OS DADOS DOS ITENS DA NOTA/PRE NOTA
		|---------------------------------------------------------------------------------
		*/
		IF VALTYPE(_ODET) == "O"

			_NITPROD := 1
			_COBJDET := "_ODET:"
			_NAITEMD1 	:= 1	// Criada a variavel _NAITEMD1 por causa do erro

		ELSE

			_NITPROD := LEN(_ODET)

			_NAITEMD1 	:= _NITEMD1	// Criada a variavel _NAITEMD1 por causa do erro
									// variable does not exist _NITEMD1 on VALIDNO(RCOMA91.PRW)
									// quando compilado no release 12.1.33


			_COBJDET := "_ODET[_NAITEMD1]:"

		ENDIF

		_AITENS := {}

		/*
		|---------------------------------------------------------------------------------
		|	SE FOR NOTA FISCAL DE IMPORTACAO REALIZA COPIA DO ARQUIVO PARA DIRETORIO DE 
		|	NAO IMPORTADOS DE APAGA DO DIRETORIO DE LEITURA
		|---------------------------------------------------------------------------------
		*/
		IF ALLTRIM(_CXEST) == "EX"

			IF !(FILE(_CDIRNOIMP))

				CRIADIR(_CDIRNOIMP)

			ENDIF

			COPY FILE &(ALLTRIM(CDIR) + "\" + _CNAME) TO &(ALLTRIM(_CDIRNOIMP) + "\" + "IMPORT-" + _CNAME)
			FERASE(ALLTRIM(CDIR) + "\" + _CNAME)

		ELSE

			FOR _NLC := 1 TO LEN(_ALINCONF)

				/*
				|---------------------------------------------------------------------------------
				|	NESTE MOMENTO, JA TEMOS UMA LINHA LIDA. GRAVAMOS OS VALORES OBTIDOS 
				|	RETIRANDO-OS DA LINHA LIDA.
				|---------------------------------------------------------------------------------
				*/
				_CLINCONF := _ALINCONF[_NLC]
				_CTYPE    := UPPER(SUBSTR(_CLINCONF, 001, 001))

				/*
				|---------------------------------------------------------------------------------
				|	VERIFICA SE A LINHA DE CONFIGURACAO DESTINA-SE PARA A MESMA VERSAO DO XML 
				|	LIDO NO MOMENTO. CASO A VERSAO DA LINHA DE CONFIGURACAO ATUAL ESTEJA PREENCHIDA 
				|	E SEJA DIFERENTE DA VERSAO DO XML, A LINHA DE CONFIGURACAO EH IGNORADA
				|---------------------------------------------------------------------------------
				*/
				IF !EMPTY(ALLTRIM(SUBSTR(_CLINCONF, 154, 004))) .AND. (_CVERXML <> ALLTRIM(SUBSTR(_CLINCONF, 154, 004)))

					LOOP

				ENDIF

				/*
				|---------------------------------------------------------------------------------
				|	OBTEM AS CONFIGURACOES DO ARQUIVO DE CONFIGURACAO
				|---------------------------------------------------------------------------------
				*/
				DO CASE

					// Registro T - 1=PRE NOTA, 2=NOTA
				CASE _CTYPE == "T"

					_CTIPODOC := IIF(SUBSTR(_CLINCONF, 002, 001) $ "12", SUBSTR(_CLINCONF, 002, 001), "1")

					// Registro S - 1=SA7, 2=EAN, 3=B1_COD
				CASE _CTYPE == "S"

					_CSEEKPRO := IIF(SUBSTR(_CLINCONF, 002, 001) $ "12", SUBSTR(_CLINCONF, 002, 001), "1")

					// Registro C - Cabecalho da NF
				CASE _CTYPE == "C"

					_COQACHAR := IIF(_LCHANGE, STRTRAN(SUBSTR(_CLINCONF, 012, 068), "OXML:_NFE:_INFNFE:", "OXML:_NFEPROC:_NFE:_INFNFE:"), SUBSTR(_CLINCONF, 012, 068))

					IF VALIDNO(_COQACHAR)

						DBSELECTAREA("SX3")
						DBSETORDER(2)
						IF DBSEEK( ALLTRIM(SUBSTR(_CLINCONF, 002, 010)))

							IF SX3->X3_ARQUIVO == "SF1"

								AADD(_ACONFCAB, {	ALLTRIM(SUBSTR(_CLINCONF, 002, 010)),;
									_COQACHAR,;
									IIF(SUBSTR(_CLINCONF, 080, 001) $ "12", SUBSTR(_CLINCONF, 080, 001), "1"),;
									SUBSTR(_CLINCONF, 081, 003),;
									VAL(SUBSTR(_CLINCONF, 084, 002)),;
									ALLTRIM(SUBSTR(_CLINCONF, 086, 050)),;
									SUBSTR(_CLINCONF, 136, 010),;
									SUBSTR(_CLINCONF, 146, 001) ,;
									SUBSTR(_CLINCONF, 147, 001) ,;
									VAL(SUBSTR(_CLINCONF, 148, 003)) ,;
									VAL(SUBSTR(_CLINCONF, 151, 003))	})

							ELSE

								_CMESS := "CAMPO " + UPPER(ALLTRIM(SUBSTR(_CLINCONF, 002, 010))) + " NAO PERTENCE AO SF1."

								/*
								|---------------------------------------------------------------------------------
								|	CASO O CAMPO INFORMADO NO ARQUIVO DE CONFIGURACAO NAO EXISTA NO SX3
								|	REGISTRA O LOG
								|---------------------------------------------------------------------------------
								*/
								IF ASCAN(_AERRO, {|X| X[7] == _CMESS }) == 0

									AADD(_AERRO, {	"ALERT",;   		//*01*/	 "OCORRENCIA",
									"N/A",;             //*02*/  "EMPRESA",
									"N/A",;             //*03*/  "FILIAL",
									DTOC(DDATABASE),;   //*04*/  "DATA",
									TIME(),;            //*05*/  "HORA",
									_CCONFIG,;          //*06*/  "ARQUIVO",
									_CMESS,;            //*07*/  "MENSAGEM",
									"",;                //*08*/  "FORNECEDOR",
									"",;                //*09*/  "LOJA",
									"",;                //*10*/  "CNPJ",
									"",;                //*11*/  "NOME",
									"",;                //*12*/  "NOTA",
									"",;                //*13*/  "SERIE",
									"",;                //*14*/  "CHAVE",
									"",;                //*15*/  "ITEM",
									"",;                //*16*/  "COD PROD FORNECEDOR",
									"",;                //*17*/  "COD PROD INTERNO",
									"",;                //*18*/  "DESCRICAO",
									""} )               //*19*/  "UNIDADE DE MEDIDA",

								ENDIF

							ENDIF

						ELSE

							_CMESS := "CAMPO " + UPPER(ALLTRIM(SUBSTR(_CLINCONF, 002, 010))) + " INEXISTENTE NO DICIONARIO DE DADOS."

							/*
							|---------------------------------------------------------------------------------
							|	CASO O CAMPO INFORMADO NO ARQUIVO DE CONFIGURACAO NAO EXISTA NO SX3
							|	REGISTRA O LOG
							|---------------------------------------------------------------------------------
							*/
							IF ASCAN(_AERRO, {|X| X[7] == _CMESS }) == 0

								AADD(_AERRO, {	"ALERT",;   		//*01*/	 "OCORRENCIA",
								"N/A",;             //*02*/  "EMPRESA",
								"N/A",;             //*03*/  "FILIAL",
								DTOC(DDATABASE),;   //*04*/  "DATA",
								TIME(),;            //*05*/  "HORA",
								_CCONFIG,;          //*06*/  "ARQUIVO",
								_CMESS,;            //*07*/  "MENSAGEM",
								"",;                //*08*/  "FORNECEDOR",
								"",;                //*09*/  "LOJA",
								"",;                //*10*/  "CNPJ",
								"",;                //*11*/  "NOME",
								"",;                //*12*/  "NOTA",
								"",;                //*13*/  "SERIE",
								"",;                //*14*/  "CHAVE",
								"",;                //*15*/  "ITEM",
								"",;                //*16*/  "COD PROD FORNECEDOR",
								"",;                //*17*/  "COD PROD INTERNO",
								"",;                //*18*/  "DESCRICAO",
								""} )               //*19*/  "UNIDADE DE MEDIDA",

							ENDIF

						ENDIF

					ENDIF

					// CAMPOS DOS ITENS
				CASE _CTYPE == "I"

					_COQACHAR := _COBJDET + ALLTRIM(SUBSTR(_CLINCONF, 012, 068))
					_LVALIT   := .T.

					IF _NITPROD > 1

						FOR _NTAMD1 := 1 TO _NITPROD
							_NATAMD1 	:= _NTAMD1	// Criada a variavel _NATAMD1 por causa do erro
													// variable does not exist _NTAMD1 on VALIDNO(RCOMA91.PRW)
													// quando compilado no release 12.1.33

							_COQACHAR 	:= STRTRAN(_COQACHAR, "[_NITEMD1]", "[_NATAMD1]")
							_LVALIT 	:= VALIDNO(_COQACHAR)
							_COQACHAR 	:= STRTRAN(_COQACHAR, "[_NATAMD1]", "[_NITEMD1]")

							IF _LVALIT

								EXIT

							ENDIF

						NEXT _NTAMD1

					ELSE

						_LVALIT := VALIDNO(_COQACHAR)

					ENDIF

					IF _LVALIT

						DBSELECTAREA("SX3")
						DBSETORDER(2)
						IF DBSEEK( ALLTRIM(SUBSTR(_CLINCONF, 002, 010)))

							IF SX3->X3_ARQUIVO == "SD1"

								AADD(_ACONFITE, {	ALLTRIM(SUBSTR(_CLINCONF, 002, 010)),;
									_COQACHAR,;
									IF(SUBSTR(_CLINCONF, 080, 001) $ "12", SUBSTR(_CLINCONF, 080, 001), "1"),;
										SUBSTR(_CLINCONF, 081, 003),;
										VAL(SUBSTR(_CLINCONF, 084, 002)),;
										ALLTRIM(SUBSTR(_CLINCONF, 086, 050)),;
										SUBSTR(_CLINCONF, 136, 010) ,;
										SUBSTR(_CLINCONF, 146, 001) ,;
										SUBSTR(_CLINCONF, 147, 001) ,;
										VAL(SUBSTR(_CLINCONF, 148, 003)) ,;
										VAL(SUBSTR(_CLINCONF, 151, 003)	)})

								ELSE

									_CMESS := "CAMPO " + UPPER(ALLTRIM(SUBSTR(_CLINCONF, 002, 010))) + " NAO PERTENCE AO SD1."

								/*
								|---------------------------------------------------------------------------------
								|	CASO O CAMPO INFORMADO NO ARQUIVO DE CONFIGURACAO NAO EXISTA NO SX3
								|	REGISTRA O LOG
								|---------------------------------------------------------------------------------
								*/
									IF ASCAN(_AERRO, {|X| X[7] == _CMESS }) == 0

										AADD(_AERRO, {	"ALERT",;   		//*01*/	 "OCORRENCIA",
										"N/A",;             //*02*/  "EMPRESA",
										"N/A",;             //*03*/  "FILIAL",
										DTOC(DDATABASE),;   //*04*/  "DATA",
										TIME(),;            //*05*/  "HORA",
										_CCONFIG,;          //*06*/  "ARQUIVO",
										_CMESS,;            //*07*/  "MENSAGEM",
										"",;                //*08*/  "FORNECEDOR",
										"",;                //*09*/  "LOJA",
										"",;                //*10*/  "CNPJ",
										"",;                //*11*/  "NOME",
										"",;                //*12*/  "NOTA",
										"",;                //*13*/  "SERIE",
										"",;                //*14*/  "CHAVE",
										"",;                //*15*/  "ITEM",
										"",;                //*16*/  "COD PROD FORNECEDOR",
										"",;                //*17*/  "COD PROD INTERNO",
										"",;                //*18*/  "DESCRICAO",
										""} )               //*19*/  "UNIDADE DE MEDIDA",

									ENDIF

								ENDIF

							ELSE

								_CMESS := "CAMPO " + UPPER(ALLTRIM(SUBSTR(_CLINCONF, 002, 010))) + " INEXISTENTE NO DICIONARIO DE DADOS."

							/*
							|---------------------------------------------------------------------------------
							|	CASO O CAMPO INFORMADO NO ARQUIVO DE CONFIGURACAO NAO EXISTA NO SX3
							|	REGISTRA O LOG
							|---------------------------------------------------------------------------------
							*/
								IF ASCAN(_AERRO, {|X| X[7] == _CMESS }) == 0

									AADD(_AERRO, {	"ALERT",;   		//*01*/	 "OCORRENCIA",
									"N/A",;             //*02*/  "EMPRESA",
									"N/A",;             //*03*/  "FILIAL",
									DTOC(DDATABASE),;   //*04*/  "DATA",
									TIME(),;            //*05*/  "HORA",
									_CCONFIG,;          //*06*/  "ARQUIVO",
									_CMESS,;            //*07*/  "MENSAGEM",
									"",;                //*08*/  "FORNECEDOR",
									"",;                //*09*/  "LOJA",
									"",;                //*10*/  "CNPJ",
									"",;                //*11*/  "NOME",
									"",;                //*12*/  "NOTA",
									"",;                //*13*/  "SERIE",
									"",;                //*14*/  "CHAVE",
									"",;                //*15*/  "ITEM",
									"",;                //*16*/  "COD PROD FORNECEDOR",
									"",;                //*17*/  "COD PROD INTERNO",
									"",;                //*18*/  "DESCRICAO",
									""} )               //*19*/  "UNIDADE DE MEDIDA",

								ENDIF

							ENDIF

						ENDIF

					ENDCASE

				NEXT _NLC

				FOR _NREPEAT := 1 TO LEN(_ACONFCAB)

					DO CASE

					CASE _ACONFCAB[_NREPEAT][1] == "F1_FORNECE"

						_UCONTEUDO 	:= TRATCONT(_ACONFCAB[_NREPEAT])
						_CFORN 		:= _UCONTEUDO

					CASE _ACONFCAB[_NREPEAT][1] == "F1_LOJA"

						_UCONTEUDO 	:= TRATCONT(_ACONFCAB[_NREPEAT])
						_CLOJA 		:= _UCONTEUDO

					ENDCASE

				NEXT _NREPEAT

			/*
			|---------------------------------------------------------------------------------
			|	VALIDA SE EXISTE O FORNECEDOR CADASTRADO NO SISTEMA
			|---------------------------------------------------------------------------------
			*/
				IF EMPTY(ALLTRIM(_CFORN)) .OR. EMPTY(ALLTRIM(_CLOJA))

					AADD(_AERRO, {	"ALERT",;      										//*01*/	 "OCORRENCIA",
					SM0->M0_CODIGO,;                                    //*02*/  "EMPRESA",
					SM0->M0_CODFIL,;                                    //*03*/  "FILIAL",
					DTOC(DDATABASE),;                                   //*04*/  "DATA",
					TIME(),;                                            //*05*/  "HORA",
					_CNAME,;                                            //*06*/  "ARQUIVO",
					"FORNECEDOR NAO ESTA CADASTRADO COM CNPJ " + _CCNPJ + " NO SISTEMA",; 	//*07*/  "MENSAGEM",
					"",;                                                //*08*/  "FORNECEDOR",
					"",;                                                //*09*/  "LOJA",
					_CCNPJ,;                                            //*10*/  "CNPJ",
					"",;                                                //*11*/  "NOME",
					_CNOTA,;                                            //*12*/  "NOTA",
					_CSERI,;                                            //*13*/  "SERIE",
					_CKEYNFE,;                                          //*14*/  "CHAVE",
					"",;                                                //*15*/  "ITEM",
					"",;                                                //*16*/  "COD PROD FORNECEDOR",
					"",;                                                //*17*/  "COD PROD INTERNO",
					"",;                                                //*18*/  "DESCRICAO",
					""} )				                                //*19*/  "UNIDADE DE MEDIDA",

					LOOP

				ENDIF

			/*
			|=================================================================================
			|   COMENTARIO
			|---------------------------------------------------------------------------------
			|	ANTES DE REALIZAR QUALQUER VALIDACAO DE CAMPOS DOS ITENS, VERIFICA SE A NF
			|	JA ESTA CADASTRADA NO SISTEMA, EVITANDO PROCESSOS DE ANALISE SEM NECESSIDADE.
			|
			|	EDSON HORNBERGER - 27/04/15
			|=================================================================================
			*/


				DBSELECTAREA("SF1")
				DBSETORDER(8)
				IF DBSEEK(XFILIAL("SF1") + _CKEYNFE)

					AADD(_AERRO, {	"SUCESS",;   				//*01*/	 "OCORRENCIA",
					SM0->M0_CODIGO,;            //*02*/  "EMPRESA",
					SM0->M0_CODFIL,;            //*03*/  "FILIAL",
					DTOC(DDATABASE),;           //*04*/  "DATA",
					TIME(),;                    //*05*/  "HORA",
					_CNAME,;                    //*06*/  "ARQUIVO",
					"NOTA FISCAL JA EXISTE",;   //*07*/  "MENSAGEM",
					_CFORN,;                    //*08*/  "FORNECEDOR",
					_CLOJA,;                    //*09*/  "LOJA",
					_CCNPJ,;                    //*10*/  "CNPJ",
					POSICIONE("SA2", 3, XFILIAL("SA2") + _CCNPJ, "A2_NOME" ),;  //*11*/  "NOME",
					_CNOTA,;                    //*12*/  "NOTA",
					_CSERI,;                    //*13*/  "SERIE",
					_CKEYNFE,;                  //*14*/  "CHAVE",
					"",;                        //*15*/  "ITEM",
					"",;                        //*16*/  "COD PROD FORNECEDOR",
					"",;                        //*17*/  "COD PROD INTERNO",
					"",;                        //*18*/  "DESCRICAO",
					""} )                       //*19*/  "UNIDADE DE MEDIDA",

					IF !(FILE(_CDIRDEST))

						CRIADIR(_CDIRDEST)

					ENDIF

					COPY FILE &(ALLTRIM(CDIR) + "\" + _CNAME) TO &(ALLTRIM(_CDIRDEST) + "\" + _CNAME)
					FERASE(ALLTRIM(CDIR) + "\" + _CNAME)
					LOOP

				ENDIF

			/*
			|---------------------------------------------------------------------------------
			|	VERIFICA SE OS CAMPOS OBRIGATORIOS CONSTAM NA CONFIGURACAO
			|---------------------------------------------------------------------------------
			*/
				FOR _NITEMD1 := 1 TO _NITPROD


					_ASD1    := {}

					_CPRODD1 := ""
					_CUNIDD1 := ""
					_NQUAND1 := 0
					_CUM	 := ""

					FOR _NREPEAT := 1 TO LEN(_ACONFITE)

						IF _NREPEAT == 1

							AADD(_ASD1,    {"D1_ITEM", STRZERO(_NITEMD1, TAMSX3("D1_ITEM")[1] ), NIL } )

						ENDIF

						_UCONTEUDO := TRATCONT(_ACONFITE[_NREPEAT])
						_COLDCONT  := _UCONTEUDO

						IF ALLTRIM(_ACONFITE[_NREPEAT][1]) == "D1_COD"


							_CPRODOLD  := _UCONTEUDO
							_UCONTEUDO := GETCODPRO(_UCONTEUDO, "", _CFORN, _CLOJA )

						/*
						|---------------------------------------------------------------------------------
						|	VERIFICA A AMARRACAO DE PRODUTO X FORNECEDOR
						|---------------------------------------------------------------------------------
						*/
							IF EMPTY(_UCONTEUDO)

								_CMESS := "PRODUTO SEM AMARRACAO PRODUTO X FORNECEDOR"

								AADD(_AERRO, {	"ALERT",;     															//*01*/	 "OCORRENCIA",
								SM0->M0_CODIGO,;                                                        //*02*/  "EMPRESA",
								SM0->M0_CODFIL,;                                                        //*03*/  "FILIAL",
								DTOC(DDATABASE),;                                                       //*04*/  "DATA",
								TIME(),;                                                                //*05*/  "HORA",
								_CNAME,;                                                                //*06*/  "ARQUIVO",
								_CMESS,;                                                                //*07*/  "MENSAGEM",
								_CFORN,;                                                                //*08*/  "FORNECEDOR",
								_CLOJA,;                                                                //*09*/  "LOJA",
								_CCNPJ,;                                                                //*10*/  "CNPJ",
								POSICIONE("SA2", 1, XFILIAL("SA2") + _CFORN + _CLOJA, "A2_NOME" ),;     //*11*/  "NOME",
								_CNOTA,;                                                                //*12*/  "NOTA",
								_CSERI,;                                                                //*13*/  "SERIE",
								_CKEYNFE,;                                                              //*14*/  "CHAVE",
								"",;                                                                    //*15*/  "ITEM",
								_CPRODOLD,;                                                             //*16*/  "COD PROD FORNECEDOR",
								"",;                                                                    //*17*/  "COD PROD INTERNO",
								"",;                                                                    //*18*/  "DESCRICAO",
								""} )							                                        //*19*/  "UNIDADE DE MEDIDA",

								_LAMARRAPRO	:= .F.

							ENDIF

							_CPRODD1   := _UCONTEUDO

						ENDIF

						IF ALLTRIM(_ACONFITE[_NREPEAT][1]) == "D1_QUANT"

							_NQUAND1 := _UCONTEUDO

						ENDIF

						IF ALLTRIM(_ACONFITE[_NREPEAT][1]) == "D1_CF"

							_CVLCFDEV  := ""
							_CVLCFDEV  := IIF(SUBSTR(_UCONTEUDO, 1, 1) <> "5", "5" + SUBSTR(_UCONTEUDO, 2, 3), _UCONTEUDO)

						/*
						|---------------------------------------------------------------------------------
						|	VERIFICA SE EH NOTA FISCAL DE DEVOLUCAO DE VENDAS
						|---------------------------------------------------------------------------------
						*/
							IF _CVLCFDEV $ _CCFOPDEV

								_CMESS := "NOTA FISCAL DE DEVOLUÇÃO DE VENDAS"

								AADD(_AERRO, {	"ERROR",;     															//*01*/	 "OCORRENCIA",
								SM0->M0_CODIGO,;                                                        //*02*/  "EMPRESA",
								SM0->M0_CODFIL,;                                                        //*03*/  "FILIAL",
								DTOC(DDATABASE),;                                                       //*04*/  "DATA",
								TIME(),;                                                                //*05*/  "HORA",
								_CNAME,;                                                                //*06*/  "ARQUIVO",
								_CMESS,;                                                                //*07*/  "MENSAGEM",
								"",;                                                                    //*08*/  "FORNECEDOR",
								"",;                                                                    //*09*/  "LOJA",
								_CCNPJ,;                                                                //*10*/  "CNPJ",
								"",;     																//*11*/  "NOME",
								_CNOTA,;                                                                //*12*/  "NOTA",
								_CSERI,;                                                                //*13*/  "SERIE",
								_CKEYNFE,;                                                              //*14*/  "CHAVE",
								"",;                                                                    //*15*/  "ITEM",
								_CPRODOLD,;                                                             //*16*/  "COD PROD FORNECEDOR",
								"",;                                                                    //*17*/  "COD PROD INTERNO",
								"",;                                                                    //*18*/  "DESCRICAO",
								""} )							                                        //*19*/  "UNIDADE DE MEDIDA",

								IF !(FILE(_CDIRNOIMP))

									CRIADIR(_CDIRNOIMP)

								ENDIF

								COPY FILE &(ALLTRIM(CDIR) + "\" + _CNAME) TO &(ALLTRIM(_CDIRNOIMP) + "\" + "IMPORT-" + _CNAME)
								FERASE(ALLTRIM(CDIR) + "\" + _CNAME)
								_LDEVOL := .T.

							ENDIF

						ENDIF

						IF ALLTRIM(_ACONFITE[_NREPEAT][1]) == "D1_UM"

							_UCONTEUDO := UPPER(_UCONTEUDO)
							_ASAHALIAS := SAH->(GETAREA())

						/*
						|---------------------------------------------------------------------------------
						|	VERIFICA SE EXISTE UNIDADE DE MEDIDA CADASTRADA NO SISTEMA
						|---------------------------------------------------------------------------------
						*/
							DBSELECTAREA("SAH")
							DBSETORDER(1)
							IF !DBSEEK(XFILIAL("SAH") + _UCONTEUDO)

								_CMESS := "UNIDADE DE MEDIDA SEM EQUIVALENCIA NO SISTEMA."

								AADD(_AERRO, {	"ALERT",;			//*01*/	 "OCORRENCIA",
								SM0->M0_CODIGO,;    //*02*/  "EMPRESA",
								SM0->M0_CODFIL,;    //*03*/  "FILIAL",
								DTOC(DDATABASE),;   //*04*/  "DATA",
								TIME(),;            //*05*/  "HORA",
								_CNAME,;            //*06*/  "ARQUIVO",
								_CMESS,;            //*07*/  "MENSAGEM",
								_CFORN,;            //*08*/  "FORNECEDOR",
								_CLOJA,;            //*09*/  "LOJA",
								_CCNPJ,;            //*10*/  "CNPJ",
								POSICIONE("SA2", 3, XFILIAL("SA2") + _CCNPJ, "A2_NOME" ),;  //*11*/  "NOME",
								_CNOTA,;            //*12*/  "NOTA",
								_CSERI,;            //*13*/  "SERIE",
								_CKEYNFE,;          //*14*/  "CHAVE",
								"",;                //*15*/  "ITEM",
								_CPRODOLD,;         //*16*/  "COD PROD FORNECEDOR",
								"",;                //*17*/  "COD PROD INTERNO",
								"",;                //*18*/  "DESCRICAO",
								_UCONTEUDO} )		//*19*/  "UNIDADE DE MEDIDA",

								_LOKPROD := .F.

							ELSE

								_CUNIDD1 := _UCONTEUDO

							ENDIF

							DBSELECTAREA("SAH")
							RESTAREA(_ASAHALIAS)

						ENDIF

						AADD(_ASD1,    {_ACONFITE[_NREPEAT][1], _UCONTEUDO, NIL } )

					NEXT _NREPEAT

				/*
				|---------------------------------------------------------------------------------
				|	VALIDACAO E CONVERSAO DA UNIDADE DE MEDIDA
				|---------------------------------------------------------------------------------
				*/
					_ARETUNI := {}
					_ARETUNI := TRAUNMED(_CPRODD1, _CUNIDD1, _NQUAND1)
					_NRETUNI := LEN(_ARETUNI)

					DO CASE

						//CASO A CONVERSAO TENHA FALHADO
					CASE _NRETUNI == 0


						_CMESS 		:= "UNIDADE DE MEDIDA NAO PREVISTA NO CADASTRO DO PRODUTO"
						_CDESCB1 	:= POSICIONE("SB1", 1, XFILIAL("SB1") + _CPRODD1, "B1_DESC")

						AADD(_AERRO, {	"ALERT",;     		//*01*/	 "OCORRENCIA",
						SM0->M0_CODIGO,;    //*02*/  "EMPRESA",
						SM0->M0_CODFIL,;    //*03*/  "FILIAL",
						DTOC(DDATABASE),;   //*04*/  "DATA",
						TIME(),;            //*05*/  "HORA",
						_CNAME,;            //*06*/  "ARQUIVO",
						_CMESS,;            //*07*/  "MENSAGEM",
						_CFORN,;            //*08*/  "FORNECEDOR",
						_CLOJA,;            //*09*/  "LOJA",
						_CCNPJ,;            //*10*/  "CNPJ",
						POSICIONE("SA2", 3, XFILIAL("SA2") + _CCNPJ, "A2_NOME" ),;  //*11*/  "NOME",
						_CNOTA,;            //*12*/  "NOTA",
						_CSERI,;            //*13*/  "SERIE",
						_CKEYNFE,;          //*14*/  "CHAVE",
						"",;                //*15*/  "ITEM",
						_CPRODOLD,;         //*16*/  "COD PROD FORNECEDOR",
						_CPRODD1,;          ///*17*/  "COD PROD INTERNO",
						_CDESCB1,;          //*18*/  "DESCRICAO",
						_CUNIDD1} )			//*19*/  "UNIDADE DE MEDIDA",

						_LOKPROD := .F.

					CASE _NRETUNI == 1

						_NPOSUM 			:= ASCAN(_ASD1, {|X| X[1] == "D1_UM"    })
						_ASD1[_NPOSUM][2]	:= _ARETUNI[1][1]

						//CASO SEJA POSSIVEL A QUANTIDADE NAS DUAS UNIDADES
					CASE _NRETUNI == 2

						//APENAS ADICIONA A SEGUNDA UNIDADE, JA QUE A UNIDADE INFORMADA FOI A PRIMEIRA
						IF _ARETUNI[1][3] == "1"

							AADD(_ASD1,    {"D1_SEGUM",   _ARETUNI[2][1], NIL } )
							AADD(_ASD1,    {"D1_QTSEGUM", _ARETUNI[2][2], NIL } )

							//COMO A UNIDADE INFORMADA FOI A SEGUNDA, TRATA D1_QUANT, D1_VUNIT
						ELSE

							_NPOSUM := ASCAN(_ASD1, {|X| X[1] == "D1_UM"    })
							_NPOSQT := ASCAN(_ASD1, {|X| X[1] == "D1_QUANT" })
							_NPOSVU := ASCAN(_ASD1, {|X| X[1] == "D1_VUNIT" })
							_NOLDQT := 0

							IF _NPOSUM <> 0 .AND. _NPOSQT <> 0 .AND. _NPOSVU <> 0

								//CAMPO D1_UM
								_ASD1[_NPOSUM][2]	:= _ARETUNI[1][1]

								//GUARDA O D1_QUANT ANTIGO
								_NOLDQT           	:= _ASD1[_NPOSQT][2]

								//ATUALIZA O NOVO D1_QUANT
								_ASD1[_NPOSQT][2] 	:= _ARETUNI[1][2]

								//ATUALIZA O NOVO D1_VUNIT COM O TOTAL MULTIPLICADO PELA QUANTIDADE DIVIDIDO PELO NOVO D1_QUANT
								_ASD1[_NPOSVU][2] 	:= ROUND( (_NOLDQT * _ASD1[_NPOSVU][2]) / _ASD1[_NPOSQT][2], TAMSX3("D1_VUNIT")[2])

							ENDIF

							//E ADICIONA A SEGUNDA UNIDADE
							AADD(_ASD1,    {"D1_SEGUM",   _ARETUNI[2][1], NIL } )
							AADD(_ASD1,    {"D1_QTSEGUM", _ARETUNI[2][2], NIL } )

						ENDIF

					ENDCASE

				/*
				|---------------------------------------------------------------------------------
				|	VALIDACAO DO PEDIDO DE COMPRA
				|---------------------------------------------------------------------------------
				*/				
					_NPOSCOD 	:= 0
					_NPOSPED 	:= 0
					_NPOSITE 	:= 0
					_NPOSCF	 	:= 0
					_NPOSVU		:= 0
					_NPOSQTD	:= 0

					_NPOSCOD 	:= ASCAN(_ASD1, {|X| X[1] == "D1_COD"})
					_NPOSPED 	:= ASCAN(_ASD1, {|X| X[1] == "D1_PEDIDO"})
					_NPOSITE 	:= ASCAN(_ASD1, {|X| X[1] == "D1_ITEMPC"})
					_NPOSCF  	:= ASCAN(_ASD1, {|X| X[1] == "D1_CF"})
					_NPOSVU  	:= ASCAN(_ASD1, {|X| X[1] == "D1_VUNIT" })
					_NPOSQTD	:= ASCAN(_ASD1, {|X| X[1] == "D1_QUANT" })

					_CD1COD    	:= ALLTRIM(IIF(_NPOSCOD <> 0, _ASD1[_NPOSCOD][2], "" ))
					_CD1PEDIDO 	:= ALLTRIM(IIF(_NPOSPED <> 0, _ASD1[_NPOSPED][2], "" ))
					_CD1ITEMPC 	:= ALLTRIM(IIF(_NPOSITE <> 0, _ASD1[_NPOSITE][2], "" ))
					_CD1CF     	:= ALLTRIM(IIF(_NPOSCF  <> 0, _ASD1[_NPOSCF][2],  "" ))
					_NVALUNIT  	:= IIF(_NPOSVU  <> 0, _ASD1[_NPOSVU][2],  0 )
					_ND1QTD		:= IIF(_NPOSQTD  <> 0, _ASD1[_NPOSQTD][2],  0 )

					_NTXCONV := 1 // Reiniciar o conteúdo do fator de conversão ao mudar o pedido de compra

				/*
				|---------------------------------------------------------------------------------
				|	VERIFICA SE ESTE TIPO DE OPERACAO (CFOP) PRECISA DA INFORMACAO DE PEDIDO 
				|	DE COMPRA. SE FOR RETORNO DE BENEFIAMENTO NAO EH NECESSARIO O NUMERO DE  
				|	PEDIDO
				|---------------------------------------------------------------------------------
				*/
					IF _NPOSCOD > 0 .AND. _NPOSCF > 0 .AND. !(_CD1CF $ _CCFOKPC)


						IF EMPTY(_CD1PEDIDO)

							_CMESS := "ITENS DA NOTA FISCAL SEM PEDIDO DE COMPRA"

							AADD(_AERRO, {	"ERROR",;     												//*01*/	"OCORRENCIA",
							SM0->M0_CODIGO,;                                            //*02*/  "EMPRESA",
							SM0->M0_CODFIL,;                                            //*03*/  "FILIAL",
							DTOC(DDATABASE),;                                           //*04*/  "DATA",
							TIME(),;                                                    //*05*/  "HORA",
							_CNAME,;                                                    //*06*/  "ARQUIVO",
							_CMESS,;                                                    //*07*/  "MENSAGEM",
							_CFORN,;                                                    //*08*/  "FORNECEDOR",
							_CLOJA,;                                                    //*09*/  "LOJA",
							_CCNPJ,;                                                    //*10*/  "CNPJ",
							POSICIONE("SA2", 3, XFILIAL("SA2") + _CCNPJ, "A2_NOME" ),;  //*11*/  "NOME",
							_CNOTA,;                                                    //*12*/  "NOTA",
							_CSERI,;                                                    //*13*/  "SERIE",
							_CKEYNFE,;                                                  //*14*/  "CHAVE",
							"",;                                                        //*15*/  "ITEM",
							_CPRODOLD,;                                                 //*16*/  "COD PROD FORNECEDOR",
							ALLTRIM(POSICIONE("SB1",1,XFILIAL("SB1") + _CPRODOLD,"B1_DESC")),; //*17*/  "COD PROD INTERNO",
							"",;                                                        //*18*/  "DESCRICAO",
							""} )						                                //*19*/  "UNIDADE DE MEDIDA",

							IF !(FILE(_CDIRNOIMP))

								CRIADIR(_CDIRNOIMP)

							ENDIF

							COPY FILE &(ALLTRIM(CDIR) + "\" + _CNAME) TO &(ALLTRIM(_CDIRNOIMP) + "\" + "IMPORT-" + _CNAME)
							FERASE(ALLTRIM(CDIR) + "\" + _CNAME)

							_LOKPED := .F.

						ELSE

							IF ALLTRIM(_CFORN) = "001431"
								SA2->(DbSetOrder(3))
								SA2->(DbSeek(XFILIAL("SA2") + _CCNPJ))
								While !SA2->(Eof()) .AND. XFILIAL("SA2")=SA2->A2_FILIAL  .AND. _CCNPJ = SA2->A2_CGC
									If SA2->A2_MSBLQL = "2"
										_CLOJA	:= SA2->A2_LOJA
									EndIf
									SA2->(DbSkip())
								End
								SA2->(DbSetOrder(1))
							EndIF


						/*
						|---------------------------------------------------------------------------------
						|	VERIFICO SE O PEDIDO E/OU ITEM INFORMADOS EXISTEM NO SISTEMA	
						|---------------------------------------------------------------------------------
						*/
							CQUERY := "SELECT" 													+ ENTER
							CQUERY += "	SC7.C7_ITEM," 										+ ENTER
							CQUERY += "	SC7.C7_PRODUTO," 										+ ENTER
							CQUERY += "	SC7.C7_MOEDA," 										+ ENTER
							CQUERY += "	SC7.C7_TXMOEDA," 										+ ENTER
							CQUERY += "	SC7.C7_PRECO," 										+ ENTER
							CQUERY += "	SC7.C7_QUANT," 										+ ENTER
							CQUERY += "	SC7.C7_QUJE"											+ ENTER
							CQUERY += "FROM" 														+ ENTER
							CQUERY += "	" + RETSQLNAME("SC7") + " SC7" 						+ ENTER
							CQUERY += "WHERE" 													+ ENTER
							CQUERY += "	SC7.C7_FILIAL = '" + XFILIAL("SC7") + "' AND" 	+ ENTER
							CQUERY += "	SC7.C7_FORNECE = '" + _CFORN + "' AND" 			+ ENTER
							CQUERY += "	SC7.C7_LOJA = '" + _CLOJA + "' AND" 				+ ENTER
							CQUERY += "	SC7.C7_PRODUTO = '" + _CD1COD + "' AND" 			+ ENTER
							CQUERY += "	SC7.C7_NUM = '" + _CD1PEDIDO + "' AND" 			+ ENTER
							IF !EMPTY(_CD1ITEMPC)
								CQUERY += "	SC7.C7_ITEM = '" + _CD1ITEMPC + "' AND" 			+ ENTER
							ENDIF
							CQUERY += "	SC7.D_E_L_E_T_ = ''"

							IF SELECT("TMP") > 0

								DBSELECTAREA("TMP")
								DBCLOSEAREA()

							ENDIF

							TCQUERY CQUERY NEW ALIAS "TMP"
							DBSELECTAREA("TMP")
							DBGOTOP()
							COUNT TO _NREPEAT

							IF _NREPEAT <= 0
								CQUERY := "SELECT" 													+ ENTER
								CQUERY += "	SC7.C7_ITEM," 										+ ENTER
								CQUERY += "	SC7.C7_PRODUTO," 										+ ENTER
								CQUERY += "	SC7.C7_MOEDA," 										+ ENTER
								CQUERY += "	SC7.C7_TXMOEDA," 										+ ENTER
								CQUERY += "	SC7.C7_PRECO," 										+ ENTER
								CQUERY += "	SC7.C7_QUANT," 										+ ENTER
								CQUERY += "	SC7.C7_QUJE"											+ ENTER
								CQUERY += "FROM" 														+ ENTER
								CQUERY += "	" + RETSQLNAME("SC7") + " SC7" 						+ ENTER
								CQUERY += "WHERE" 													+ ENTER
								CQUERY += "	SC7.C7_FILIAL = '" + XFILIAL("SC7") + "' AND" 	+ ENTER
								CQUERY += "	SC7.C7_FORNECE = '" + _CFORN + "' AND" 			+ ENTER
								CQUERY += "	SC7.C7_LOJA = '" + _CLOJA + "' AND" 				+ ENTER
								CQUERY += "	SC7.C7_PRODUTO = '" + _CD1COD + "' AND" 			+ ENTER
								CQUERY += "	SC7.C7_NUM = '" + _CD1PEDIDO + "' AND" 			+ ENTER
								CQUERY += "	SC7.D_E_L_E_T_ = ''"
								IF SELECT("TMP") > 0

									DBSELECTAREA("TMP")
									DBCLOSEAREA()

								ENDIF

								TCQUERY CQUERY NEW ALIAS "TMP"
								DBSELECTAREA("TMP")
								DBGOTOP()

								COUNT TO _NREPEAT
							EndIf

							IF _NREPEAT <= 0
							/*
							|---------------------------------------------------------------------------------
							|	CASO O PEDIDO DO XML ESTEJA ERRADO NAO IMPORTA
							|---------------------------------------------------------------------------------
							*/
								_LOKPED := .F.

							ELSE

								DBGOTOP()
							/*
							|---------------------------------------------------------------------------------
							|	TRATAMENTO DE TAXA DE CONVERSAO DA MOEDA
							|---------------------------------------------------------------------------------
							*/
								IF TMP->C7_MOEDA != 1
									IF TMP->C7_TXMOEDA > 0
										_NTXCONV := TMP->C7_TXMOEDA
									ELSE
										_NPOSEMIS 	:= ASCAN(_ACONFCAB,{|X| X[1] == "F1_EMISSAO"})
										_DEMISSAO 	:= ALLTRIM(IIF(_NPOSEMIS <> 0, _ACONFCAB[_NPOSEMIS][2], _DEMISSAO ))
										_NTXCONV 	:= RECMOEDA(_DEMISSAO,TMP->C7_MOEDA)
									ENDIF
								ENDIF
							/*
							|---------------------------------------------------------------------------------
							|	VERIFICA SE HA SALDO NESTE PEDIDO PARA ATENDIMENTO DO ITEM DA NF 
							|---------------------------------------------------------------------------------
							*/
								IF (TMP->C7_QUANT - TMP->C7_QUJE) <= 0

									_CMESS := "PEDIDO DE COMPRA SEM SALDO PARA ATENDER NOTA FISCAL"

									AADD(_AERRO, {	"ERROR",;     												//*01*/	"OCORRENCIA",
									SM0->M0_CODIGO,;                                            //*02*/  "EMPRESA",
									SM0->M0_CODFIL,;                                            //*03*/  "FILIAL",
									DTOC(DDATABASE),;                                           //*04*/  "DATA",
									TIME(),;                                                    //*05*/  "HORA",
									_CNAME,;                                                    //*06*/  "ARQUIVO",
									_CMESS,;                                                    //*07*/  "MENSAGEM",
									_CFORN,;                                                    //*08*/  "FORNECEDOR",
									_CLOJA,;                                                    //*09*/  "LOJA",
									_CCNPJ,;                                                    //*10*/  "CNPJ",
									POSICIONE("SA2", 3, XFILIAL("SA2") + _CCNPJ, "A2_NOME" ),;  //*11*/  "NOME",
									_CNOTA,;                                                    //*12*/  "NOTA",
									_CSERI,;                                                    //*13*/  "SERIE",
									_CKEYNFE,;                                                  //*14*/  "CHAVE",
									"",;                                                        //*15*/  "ITEM",
									_CPRODOLD,;                                                 //*16*/  "COD PROD FORNECEDOR",
									ALLTRIM(POSICIONE("SB1",1,XFILIAL("SB1") + _CPRODOLD,"B1_DESC")),; //*17*/  "COD PROD INTERNO",
									"",;                                                        //*18*/  "DESCRICAO",
									""} )						                                //*19*/  "UNIDADE DE MEDIDA",

									IF !(FILE(_CDIRNOIMP))

										CRIADIR(_CDIRNOIMP)

									ENDIF

									COPY FILE &(ALLTRIM(CDIR) + "\" + _CNAME) TO &(ALLTRIM(_CDIRNOIMP) + "\" + "IMPORT-" + _CNAME)
									FERASE(ALLTRIM(CDIR) + "\" + _CNAME)
									_LOKPED := .F.

								ELSEIF (TMP->C7_QUANT - TMP->C7_QUJE) < _ND1QTD

									_CMESS := "PEDIDO DE COMPRA COM SALDO INSUFICIENTE PARA ATENDER NOTA FISCAL"

									AADD(_AERRO, {	"ERROR",;     												//*01*/	"OCORRENCIA",
									SM0->M0_CODIGO,;                                            //*02*/  "EMPRESA",
									SM0->M0_CODFIL,;                                            //*03*/  "FILIAL",
									DTOC(DDATABASE),;                                           //*04*/  "DATA",
									TIME(),;                                                    //*05*/  "HORA",
									_CNAME,;                                                    //*06*/  "ARQUIVO",
									_CMESS,;                                                    //*07*/  "MENSAGEM",
									_CFORN,;                                                    //*08*/  "FORNECEDOR",
									_CLOJA,;                                                    //*09*/  "LOJA",
									_CCNPJ,;                                                    //*10*/  "CNPJ",
									POSICIONE("SA2", 3, XFILIAL("SA2") + _CCNPJ, "A2_NOME" ),;  //*11*/  "NOME",
									_CNOTA,;                                                    //*12*/  "NOTA",
									_CSERI,;                                                    //*13*/  "SERIE",
									_CKEYNFE,;                                                  //*14*/  "CHAVE",
									"",;                                                        //*15*/  "ITEM",
									_CPRODOLD,;                                                 //*16*/  "COD PROD FORNECEDOR",
									ALLTRIM(POSICIONE("SB1",1,XFILIAL("SB1") + _CPRODOLD,"B1_DESC")),; //*17*/  "COD PROD INTERNO",
									"",;                                                        //*18*/  "DESCRICAO",
									""} )						                                //*19*/  "UNIDADE DE MEDIDA",

									IF !(FILE(_CDIRNOIMP))

										CRIADIR(_CDIRNOIMP)

									ENDIF

									COPY FILE &(ALLTRIM(CDIR) + "\" + _CNAME) TO &(ALLTRIM(_CDIRNOIMP) + "\" + "IMPORT-" + _CNAME)
									FERASE(ALLTRIM(CDIR) + "\" + _CNAME)
									_LOKPED := .F.

							/*
							|---------------------------------------------------------------------------------
							|	CASO O ITEM DO PEDIDO NO XML ESTAJA VAZIO OU DIFERENTE REALIZA O ACERTO
							|---------------------------------------------------------------------------------
							*/								
								ELSEIF TMP->C7_ITEM != _CD1ITEMPC

									IF _NPOSITE <= 0

										AADD(_ASD1, {"D1_ITEMPC", TMP->C7_ITEM, NIL})
										_CD1ITEMPC 			:= TMP->C7_ITEM
										_NPOSITE 				:= ASCAN(_ASD1, {|X| X[1] == "D1_ITEMPC"})

									ELSE

										_ASD1[_NPOSITE][2] 	:= TMP->C7_ITEM
										_CD1ITEMPC 			:= TMP->C7_ITEM

									ENDIF

								ENDIF

							/*
							|---------------------------------------------------------------------------------
							|	VALIDA O VALOR UNITARIO DO ITEM DA NOTA FISCAL X PEDIDO DE COMPRA
							|---------------------------------------------------------------------------------
							*/

								IF _LOKPED

									IF ROUND(_NVALUNIT,8) < ROUND(((TMP->C7_PRECO * _NTXCONV) - 0.01),8)

										_CMESS := "NOTA FISCAL COM VALOR UNITÁRIO (" + ALLTRIM(TRANSFORM(_NVALUNIT,"@E 999,999.99")) + ") MENOR QUE NO PEDIDO DE COMPRA (" + ALLTRIM(TRANSFORM((TMP->C7_PRECO * _NTXCONV),"@E 999,999.99")) + ")"

										AADD(_AERRO, {	"ALERT",;     												//*01*/	"OCORRENCIA",
										SM0->M0_CODIGO,;                                            //*02*/  "EMPRESA",
										SM0->M0_CODFIL,;                                            //*03*/  "FILIAL",
										DTOC(DDATABASE),;                                           //*04*/  "DATA",
										TIME(),;                                                    //*05*/  "HORA",
										_CNAME,;                                                    //*06*/  "ARQUIVO",
										_CMESS,;                                                    //*07*/  "MENSAGEM",
										_CFORN,;                                                    //*08*/  "FORNECEDOR",
										_CLOJA,;                                                    //*09*/  "LOJA",
										_CCNPJ,;                                                    //*10*/  "CNPJ",
										POSICIONE("SA2", 3, XFILIAL("SA2") + _CCNPJ, "A2_NOME" ),;  //*11*/  "NOME",
										_CNOTA,;                                                    //*12*/  "NOTA",
										_CSERI,;                                                    //*13*/  "SERIE",
										_CKEYNFE,;                                                  //*14*/  "CHAVE",
										"",;                                                        //*15*/  "ITEM",
										_CPRODOLD,;                                                 //*16*/  "COD PROD FORNECEDOR",
										ALLTRIM(POSICIONE("SB1",1,XFILIAL("SB1") + _CPRODOLD,"B1_DESC")),; //*17*/  "COD PROD INTERNO",
										"",;                                                        //*18*/  "DESCRICAO",
										""} )						                                //*19*/  "UNIDADE DE MEDIDA",

										_LOKPED 	:= .F.
										_LVALUNIT	:= .F.

									ELSEIF ROUND(_NVALUNIT ,8) > ROUND(((TMP->C7_PRECO * _NTXCONV) + 0.01),8)

										_CMESS := "NOTA FISCAL COM VALOR UNITÁRIO (" + ALLTRIM(TRANSFORM(_NVALUNIT,"@E 999,999.99")) + ") MAIOR QUE NO PEDIDO DE COMPRA (" + ALLTRIM(TRANSFORM((TMP->C7_PRECO * _NTXCONV),"@E 999,999.99")) + ")"

										AADD(_AERRO, {	"ALERT",;     												//*01*/	"OCORRENCIA",
										SM0->M0_CODIGO,;                                            //*02*/  "EMPRESA",
										SM0->M0_CODFIL,;                                            //*03*/  "FILIAL",
										DTOC(DDATABASE),;                                           //*04*/  "DATA",
										TIME(),;                                                    //*05*/  "HORA",
										_CNAME,;                                                    //*06*/  "ARQUIVO",
										_CMESS,;                                                    //*07*/  "MENSAGEM",
										_CFORN,;                                                    //*08*/  "FORNECEDOR",
										_CLOJA,;                                                    //*09*/  "LOJA",
										_CCNPJ,;                                                    //*10*/  "CNPJ",
										POSICIONE("SA2", 3, XFILIAL("SA2") + _CCNPJ, "A2_NOME" ),;  //*11*/  "NOME",
										_CNOTA,;                                                    //*12*/  "NOTA",
										_CSERI,;                                                    //*13*/  "SERIE",
										_CKEYNFE,;                                                  //*14*/  "CHAVE",
										"",;                                                        //*15*/  "ITEM",
										_CPRODOLD,;                                                 //*16*/  "COD PROD FORNECEDOR",
										ALLTRIM(POSICIONE("SB1",1,XFILIAL("SB1") + _CPRODOLD,"B1_DESC")),; //*17*/  "COD PROD INTERNO",
										"",;                                                        //*18*/  "DESCRICAO",
										""} )						                                //*19*/  "UNIDADE DE MEDIDA",

										_LOKPED 	:= .F.
										_LVALUNIT	:= .F.

									ENDIF

								ENDIF

							ENDIF

							DBSELECTAREA("TMP")
							DBCLOSEAREA()

						ENDIF

					ELSEIF  _CD1CF $ _CCFOKPC


					/*
					|---------------------------------------------------------------------------------
					|	CASO SEJA UMA NOTA FISCAL DE RETORNO RETIRA OS CAMPOS DE PEDIDO E ITEM DO ARRAY
					|---------------------------------------------------------------------------------
					*/
						IF _NPOSPED > 0
							ADEL(_ASD1, ASCAN(_ASD1, {|X| X[1] == "D1_PEDIDO"}))
							ASIZE(_ASD1,LEN(_ASD1)-1)
						ENDIF

						IF _NPOSITE > 0
							ADEL(_ASD1, ASCAN(_ASD1, {|X| X[1] == "D1_ITEMPC"}))
							ASIZE(_ASD1,LEN(_ASD1)-1)
						ENDIF

					ENDIF

					//EXCLUI O CFOP DO ARRAY _ASD1 ANTES DE ADICIONA-LO EM DEFINITIVO AO _AITENS
					ADEL(_ASD1,ASCAN(_ASD1, {|X| X[1] == "D1_CF"}))
					ASIZE(_ASD1,LEN(_ASD1)-1)
					AADD(_AITENS, _ASD1)

				NEXT _NITEMD1

			/*
			|---------------------------------------------------------------------------------
			|	CRIA O VETOR COM OS DADOS DO CABECALHO DA NOTA/PRE NOTA
			|---------------------------------------------------------------------------------
			*/
				_CCGC  := ""
				_CNOME := ""

				FOR _NREPEAT := 1 TO LEN(_ACONFCAB)

					IF (_ACONFCAB[_NREPEAT][1] == "F1_FORNECE" .OR. _ACONFCAB[_NREPEAT][1] == "F1_LOJA")

						IF _LDEVOL

							_ACONFCAB[_NREPEAT][4] := "SA1"
							_ACONFCAB[_NREPEAT][6] := STRTRAN(_ACONFCAB[_NREPEAT][6], "SA2", "SA1")
							_ACONFCAB[_NREPEAT][7] := STRTRAN(_ACONFCAB[_NREPEAT][7], "A2_", "A1_")
							_CCGC 	:= _ACONFCAB[_NREPEAT][2]
							_CNOME 	:= ALLTRIM(POSICIONE("SA1", 3, XFILIAL("SA1") + _CCGC, "A1_NOME") )

						ELSE

							_CCGC 	:= _ACONFCAB[_NREPEAT][2]
							_CNOME 	:= ALLTRIM(POSICIONE("SA2", 3, XFILIAL("SA2") + _CCGC, "A2_NOME") )

						ENDIF

					ENDIF

					_UCONTEUDO := TRATCONT(_ACONFCAB[_NREPEAT])
					_CTYPENF := IIF(_LDEVOL, "D", "N")

					IF _NREPEAT == 1

						AADD(_ACABEC, {"F1_TIPO"	,_CTYPENF   , 	NIL })
						AADD(_ACABEC, {"F1_ESPECIE"	,"SPED"		, 	NIL })
						AADD(_ACABEC, {"F1_FORMUL"	,"N"		, 	NIL })

					ENDIF

					AADD(_ACABEC, {	_ACONFCAB[_NREPEAT][1], _UCONTEUDO, NIL })

					DO CASE

					CASE _ACONFCAB[_NREPEAT][1] == "F1_FORNECE"

						_CFORN := _UCONTEUDO

					CASE _ACONFCAB[_NREPEAT][1] == "F1_LOJA"

						_CLOJA := _UCONTEUDO

					CASE _ACONFCAB[_NREPEAT][1] == "F1_DOC"

						_ACONFCAB[_NREPEAT][2] 	:= _UCONTEUDO
						_CNOTA 					:= _ACONFCAB[_NREPEAT][2]

					CASE _ACONFCAB[_NREPEAT][1] == "F1_SERIE"

						_CSERI := _UCONTEUDO

					CASE _ACONFCAB[_NREPEAT][1] == "F1_CHVNFE"

						_CKEYNFE := _UCONTEUDO

					CASE _ACONFCAB[_NREPEAT][1] == "F1_TPFRETE"

						_NSCFRT := ASCAN(_ATPFRET, {|X| X[1] == _UCONTEUDO})

						IF _NSCFRT <> 0

							_UCONTEUDO := _ATPFRET[_NSCFRT][2]

						ENDIF

					ENDCASE

				NEXT _NREPEAT

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ?
				//?EXECUTA A ROTINA AUTOMATICA PARA NOTA OU PRE NOTA           ?
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ?

				IF LEN(_ACABEC) > 0 .AND. LEN(_AITENS) > 0 .AND. _LOKPROD .AND. _LVALUNIT .AND. _LAMARRAPRO .AND. !(_LDEVOL) .AND. _LOKPED

					DBSELECTAREA("SD1")
					DBSELECTAREA("SF1")
					DBSETORDER(8)
					LJAEXISTE := (DBSEEK(XFILIAL("SF1") + _CKEYNFE))
					If .NOT. LJAEXISTE
						DBSELECTAREA("SF1")
						DBSETORDER(1) // F1_FILIAL, F1_DOC, F1_SERIE, F1_FORNECE, F1_LOJA, F1_TIPO
						LJAEXISTE := (DBSEEK(XFILIAL("SF1") + _ACABEC[4][2] + _ACABEC[5][2] + _ACABEC[6][2] + _ACABEC[7][2] + _ACABEC[1][2]) )
					EndIf

					If .NOT. LJAEXISTE

						LMSERROAUTO 	:= .F.
						LAUTOERRNOFILE 	:= .T.

						IF _CTIPODOC == "1"

							MSEXECAUTO({|X, Y, Z| MATA140(X, Y, Z)}, _ACABEC, _AITENS, 3)

						ELSE

							MSEXECAUTO({|X, Y, Z| MATA103(X, Y, Z)}, _ACABEC, _AITENS, 3)

						ENDIF

						IF LMSERROAUTO

							AERRO := GETAUTOGRLOG()
							CERRO := ""

							FOR _NX := 1 TO LEN(AERRO)

								IF _NX < 2 .OR. "ERRO" $ UPPER(AERRO[_NX]) .OR. "FALHA" $ UPPER(AERRO[_NX]) .OR. "-->" $ UPPER(AERRO[_NX]) .OR. "INCONSISTENCIA" $ UPPER(AERRO[_NX]) .OR. "INVALIDO" $ UPPER(AERRO[_NX])

									CERRO += ALLTRIM(AERRO[_NX]) + " | "

								ENDIF

							NEXT _NX

							_CMESS := STRTRAN(CERRO, CHR(13) + CHR(10), "")

							IF LEN(ALLTRIM(CERRO)) > 0

								AADD(_AERRO, {	"ALERT",;  	//*01*/	 "OCORRENCIA",
								SM0->M0_CODIGO,;        //*02*/  "EMPRESA",
								SM0->M0_CODFIL,;        //*03*/  "FILIAL",
								DTOC(DDATABASE),;       //*04*/  "DATA",
								TIME(),;                //*05*/  "HORA",
								_CNAME,;                //*06*/  "ARQUIVO",
								_CMESS,;                //*07*/  "MENSAGEM",
								_CFORN,;                //*08*/  "FORNECEDOR",
								_CLOJA,;                //*09*/  "LOJA",
								_CCGC,;                 //*10*/  "CNPJ",
								POSICIONE("SA2", 3, XFILIAL("SA2") + _CCNPJ, "A2_NOME" ),;	//*11*/  "NOME",
								"",;                    //*12*/  "NOTA",
								"",;                    //*13*/  "SERIE",
								_CKEYNFE,;              //*14*/  "CHAVE",
								"",;                    //*15*/  "ITEM",
								"",;                    //*16*/  "COD PROD FORNECEDOR",
								"",;                    //*17*/  "COD PROD INTERNO",
								"",;                    //*18*/  "DESCRICAO",
								""} )					//*19*/  "UNIDADE DE MEDIDA",
								CONOUT( CERRO )

							ENDIF

							IF !(FILE(_CDIRNOIMP))

								CRIADIR(_CDIRNOIMP)

							ENDIF

							COPY FILE &(ALLTRIM(CDIR) + "\" + _CNAME) TO &(ALLTRIM(_CDIRNOIMP) + "\" + "ERREXEC-" + _CNAME)
							FERASE(ALLTRIM(CDIR) + "\" + _CNAME)

							AERRO := GETAUTOGRLOG()
							_CERROS := ""

							FOR _NXI := 1 TO LEN(AERRO)

								IF ALLTRIM(AERRO[_NXI]) == "HELP: NOFUNCW"

									_CERROS += AERRO[_NXI] + " "

								ENDIF

							NEXT _NXI

							IF LEN(ALLTRIM(_CERROS)) > 0

								_CMESS := _CERROS

								AADD(_AERRO, {	"ALERT",;  				//*01*/	 "OCORRENCIA",
								SM0->M0_CODIGO,;        //*02*/  "EMPRESA",
								SM0->M0_CODFIL,;        //*03*/  "FILIAL",
								DTOC(DDATABASE),;       //*04*/  "DATA",
								TIME(),;                //*05*/  "HORA",
								_CNAME,;                //*06*/  "ARQUIVO",
								_CMESS,;                //*07*/  "MENSAGEM",
								_CFORN,;                //*08*/  "FORNECEDOR",
								_CLOJA,;                //*09*/  "LOJA",
								_CCGC,;                 //*10*/  "CNPJ",
								POSICIONE("SA2", 3, XFILIAL("SA2") + _CCNPJ, "A2_NOME" ),;	//*11*/  "NOME",
								"",;                    //*12*/  "NOTA",
								"",;                    //*13*/  "SERIE",
								_CKEYNFE,;              //*14*/  "CHAVE",
								"",;                    //*15*/  "ITEM",
								"",;                    //*16*/  "COD PROD FORNECEDOR",
								"",;                    //*17*/  "COD PROD INTERNO",
								"",;                    //*18*/  "DESCRICAO",
								""} )                   //*19*/  "UNIDADE DE MEDIDA",

							ENDIF

						ELSE

							AADD(_AERRO, {	"SUCESS",;   				//*01*/	"OCORRENCIA",
							SM0->M0_CODIGO,;            //*02*/  "EMPRESA",
							SM0->M0_CODFIL,;            //*03*/  "FILIAL",
							DTOC(DDATABASE),;           //*04*/  "DATA",
							TIME(),;                    //*05*/  "HORA",
							_CNAME,;                    //*06*/  "ARQUIVO",
							"NOTA FISCAL IMPORTADA",;   //*07*/  "MENSAGEM",
							_CFORN,;                    //*08*/  "FORNECEDOR",
							_CLOJA,;                    //*09*/  "LOJA",
							_CCNPJ,;                    //*10*/  "CNPJ",
							POSICIONE("SA2", 3, XFILIAL("SA2") + _CCNPJ, "A2_NOME" ),;  //*11*/  "NOME",
							_CNOTA,;                    //*12*/  "NOTA",
							_CSERI,;                    //*13*/  "SERIE",
							_CKEYNFE,;                  //*14*/  "CHAVE",
							"",;                        //*15*/  "ITEM",
							"",;                        //*16*/  "COD PROD FORNECEDOR",
							"",;                        //*17*/  "COD PROD INTERNO",
							"",;                        //*18*/  "DESCRICAO",
							""} )                       //*19*/  "UNIDADE DE MEDIDA",



							IF !(FILE(_CDIRDEST))

								CRIADIR(_CDIRDEST)

							ENDIF
							COPY FILE &(ALLTRIM(CDIR) + "\" + _CNAME) TO &(ALLTRIM(_CDIRDEST) + "\" + _CNAME)
							FERASE(ALLTRIM(CDIR) + "\" + _CNAME)

						ENDIF

					ELSE

						AADD(_AERRO, {	"SUCESS",; 						//*01*/	"OCORRENCIA",
						SM0->M0_CODIGO,;                //*02*/  "EMPRESA",
						SM0->M0_CODFIL,;                //*03*/  "FILIAL",
						DTOC(DDATABASE),;               //*04*/  "DATA",
						TIME(),;                        //*05*/  "HORA",
						_CNAME,;                        //*06*/  "ARQUIVO",
						"NOTA FISCAL JA EXISTE",;       //*07*/  "MENSAGEM",
						_CFORN,;                        //*08*/  "FORNECEDOR",
						_CLOJA,;                        //*09*/  "LOJA",
						_CCNPJ,;                        //*10*/  "CNPJ",
						_CNOME,;                        //*11*/  "NOME",
						_CNOTA,;                        //*12*/  "NOTA",
						_CSERI,;                        //*13*/  "SERIE",
						_CKEYNFE,;                      //*14*/  "CHAVE",
						"",;                            //*15*/  "ITEM",
						"",;                            //*16*/  "COD PROD FORNECEDOR",
						"",;                            //*17*/  "COD PROD INTERNO",
						"",;                            //*18*/  "DESCRICAO",
						""} )                           //*19*/  "UNIDADE DE MEDIDA",

						IF !(FILE(_CDIRNOIMP))

							CRIADIR(_CDIRNOIMP)

						ENDIF

						COPY FILE &(ALLTRIM(CDIR) + "\" + _CNAME) TO &(ALLTRIM(_CDIRNOIMP) + "\" + "NFJAINC-" + _CNAME)
						FERASE(ALLTRIM(CDIR) + "\" + _CNAME)

					ENDIF

				ENDIF

			ENDIF

			_ACABEC   	:= {}

		NEXT NXML

		IF LEN(_AERRO) > 0

			CRIAXLS(_AERRO)

		ENDIF

		RESTAREA(_AOLDAREA)
		RPCCLEARENV()

		CONOUT("RCOMA91 <-- TERMINANDO PROCESSO DE LEITURA DE XML...")

		RETURN

/*
=================================================================================
=================================================================================
||   Arquivo:	RCOMA91NEW.prw
=================================================================================
||   Funcao: 	GETCODPRO
=================================================================================
||   Descricao
||-------------------------------------------------------------------------------
||		Obtem o codigo interno do Produto 		
|| 
=================================================================================
=================================================================================
||   Autor: 
||   Data:
=================================================================================
=================================================================================
*/

STATIC FUNCTION GETCODPRO(_CCODFORN, _CDESPRO, _CFORNECE, _CXLOJA, _CNUMPED)

	LOCAL _AOLDAREA	:= GETAREA()
	LOCAL _CCODPRO  := ""
	LOCAL _NT01		:= 0
	LOCAL APROD		:= {}
	
	_CCODFORN := UPPER(ALLTRIM(_CCODFORN))
	_CDESPRO  := ALLTRIM(_CDESPRO)
	_CFORNECE := ALLTRIM(_CFORNECE)
	_CXLOJA   := ALLTRIM(_CXLOJA)


	IF _CSEEKPRO == "1" // SA5

		#IFDEF TOP

			_CQUERY := "SELECT  A5_PRODUTO AS CCODPRO "
			_CQUERY += "FROM  " + RETSQLNAME("SA5") + " WITH(NOLOCK) "
			_CQUERY += "WHERE "
			_CQUERY += "A5_CODPRF   = '" +ALLTRIM(_CCODFORN)+ "' AND "
			_CQUERY += "A5_FORNECE  = '" + _CFORNECE    + "' AND "
			_CQUERY += "A5_LOJA     = '" + _CXLOJA   + "' AND "
			_CQUERY += "A5_FILIAL   = '" + XFILIAL("SA5") + "' AND "
			_CQUERY += "D_E_L_E_T_ <> '*' "

			IF SELECT(_CTMPALIAS) > 0

				DBSELECTAREA(_CTMPALIAS)
				DBCLOSEAREA()

			ENDIF

			DBUSEAREA(.T., "TOPCONN", TCGENQRY(,, _CQUERY), _CTMPALIAS, .F., .T.)

			DBSELECTAREA(_CTMPALIAS)
			WHILE !EOF()

				IF EMPTY(_CCODPRO)
					_CCODPRO := ALLTRIM((_CTMPALIAS)->CCODPRO)
				ENDIF

				_NT01++

				AADD(APROD,(_CTMPALIAS)->CCODPRO)

				DBSELECTAREA(_CTMPALIAS)
				DBSKIP()

			ENDDO

			DBSELECTAREA(_CTMPALIAS)
			DBCLOSEAREA()

		#ELSE

			DBSELECTAREA("SA5")
			DBSETORDER(2)
			IF DBSEEK(XFILIAL("SA5") + _CCODFORN)
				WHILE !EOF() .AND. ALLTRIM(SA5->A5_CODPRF) == _CCODFORN .AND. SA5->A5_FILIAL = XFILIAL("SA5")

					IF SA5->A5_FORNECE + SA5->A5_LOJA == SA2->A2_COD + SA2->A2_LOJA

						_CCODPRO := SA5->A5_PRODUTO
						EXIT

					ENDIF

					DBSELECTAREA("SA5")
					DBSKIP()

				ENDDO

			ENDIF

		#ENDIF

	ENDIF

	IF !EMPTY(ALLTRIM(_CCODPRO))

		DBSELECTAREA("SB1")
		DBSETORDER(1)
		IF DBSEEK(XFILIAL("SB1") + _CCODPRO)

			_CUM := SB1->B1_UM

		ENDIF

	ENDIF

	_CERRSA5 := ""

	IF _NT01 > 1

		_CERRSA5 += "EXISTEM MAIS ITENS NA AMARRAÇÃO DO PRODUTO FORN: "+ _CCODFORN + " "

		AEVAL(APROD,{|X| _CERRSA5 += "CODIGO: "+ X +POSICIONE("SB1",1,XFILIAL("SB1")+ X, "B1_DESC") + " "})

		AADD(_AERRO, {	"ALERT",;      			//*01*/	"OCORRENCIA",
		SM0->M0_CODIGO,;        //*02*/  "EMPRESA",
		SM0->M0_CODFIL,;        //*03*/  "FILIAL",
		DTOC(DDATABASE),;       //*04*/  "DATA",
		TIME(),;                //*05*/  "HORA",
		_CNAME,;                //*06*/  "ARQUIVO",
		_CERRSA5,;              //*07*/  "MENSAGEM",
		_CFORNECE,;             //*08*/  "FORNECEDOR",
		_CLOJA,;                //*09*/  "LOJA",
		_CCNPJ,;                //*10*/  "CNPJ",
		POSICIONE("SA2", 3, XFILIAL("SA2") + _CCNPJ, "A2_NOME" ),;  //*11*/  "NOME",
		_CNOTA,;                //*12*/  "NOTA",
		_CSERI,;                //*13*/  "SERIE",
		_CKEYNFE,;              //*14*/  "CHAVE",
		"",;                    //*15*/  "ITEM",
		_CCODFORN,;             //*16*/  "COD PROD FORNECEDOR",
		"",;                    //*17*/  "COD PROD INTERNO",
		"",;                    //*18*/  "DESCRICAO",
		""} )                   //*19*/  "UNIDADE DE MEDIDA",

		_LAMARRAPRO := .F.

	ENDIF

	RESTAREA(_AOLDAREA)

RETURN(_CCODPRO)

/*
=================================================================================
=================================================================================
||   Arquivo:	RCOMA91NEW.prw
=================================================================================
||   Funcao: 	STR2ARR
=================================================================================
||   Descricao
||-------------------------------------------------------------------------------
|| 		Divide um conteudo Texto com separador num array
|| 
=================================================================================
=================================================================================
||   Autor: 
||   Data:
=================================================================================
=================================================================================
*/

STATIC FUNCTION STR2ARR(_CTXT, _CSEPARA)

	LOCAL _AARRAY := {}
	LOCAL _NPOS   := 0

	WHILE LEN(_CTXT) > 0

		_NPOS := AT(_CSEPARA, _CTXT)

		DO CASE

		CASE _NPOS > 1

			AADD(_AARRAY, SUBSTR(_CTXT, 01, _NPOS - 1) )

			_CTXT := SUBSTR(_CTXT, _NPOS + 1, LEN(_CTXT) )

		CASE _NPOS == 1

			AADD(_AARRAY, " ")

			_CTXT := SUBSTR(_CTXT, _NPOS + 1, LEN(_CTXT) )

		CASE _NPOS == 0

			AADD(_AARRAY, SUBSTR(_CTXT, 01, LEN(_CTXT) ) )

			_CTXT := ""

		ENDCASE

	ENDDO

RETURN(_AARRAY)

/*
=================================================================================
=================================================================================
||   Arquivo:	RCOMA91NEW.prw
=================================================================================
||   Funcao: 	VALIDNO
=================================================================================
||   Descricao
||-------------------------------------------------------------------------------
|| 		Valida a existencia de um No (noh) no arquivo XML
|| 
=================================================================================
=================================================================================
||   Autor: 
||   Data:
=================================================================================
=================================================================================
*/

STATIC FUNCTION VALIDNO(_CWHAT)

	//LOCAL OVALXML
	LOCAL _COLDPAR := _CWHAT
	LOCAL _CNEWNO  := SUBSTR(ALLTRIM(_CWHAT), 1, LEN(ALLTRIM(_CWHAT)) - 5)
	LOCAL _ANEWNO  := {}
	LOCAL _LTEMNO  := .F.
	LOCAL _NXN	   := 0

	_CWHAT   := ""
	
	IF ":" $ _COLDPAR

		_ANEWNO := STR2ARR(_CNEWNO, ":")

	ELSE
		_ANEWNO := {_CNEWNO}

	ENDIF


	_NLEN  := LEN(_ANEWNO)
	_NNOTA := _NLEN -1

	IF _NLEN - 1 >= 1

		FOR _NXN := 1 TO _NLEN - 1

			IF _NXN > LEN(_ANEWNO) .OR. _NXN + 1 > LEN(_ANEWNO)

				LOOP

			ENDIF

			_CWHAT +=  IIF(_NXN > 1,  ":","") + ALLTRIM(_ANEWNO[_NXN])

			_CULT   := ALLTRIM(_ANEWNO[_NXN + 1])

			//
			// quando compilado no release 12.1.33 foi necessário criar a variavel _NATAMD1 como PRIVATE
			// pois a variavel _NTAMD1 como LOCAL provocava erro na expressão --> &(_CWHAT) 
			// 
			IF _NAITEMD1 > _NITPROD
			
			ELSEIF VALTYPE(XMLCHILDEX(&(_CWHAT), _CULT)  ) = "O"

				_NNOTA -= 1

			ELSE

				EXIT

			ENDIF

		NEXT _NXN

	ENDIF

	IF _NNOTA <> 0

		_LTEMNO := .F.

	ELSE

		_LTEMNO := .T.

	ENDIF

RETURN(_LTEMNO)

/*
=================================================================================
=================================================================================
||   Arquivo:	RCOMA91NEW.prw
=================================================================================
||   Funcao: 	TRATCONT
=================================================================================
||   Descricao
||-------------------------------------------------------------------------------
|| 		Apura o conteudo da Tag XML conforme arquivo de configuracao
|| 
=================================================================================
=================================================================================
||   Autor: 
||   Data:
=================================================================================
=================================================================================
*/

STATIC FUNCTION TRATCONT(_ALINCONF)

	//LOCAL _UVARCONT
	LOCAL _UCONTENT
	LOCAL _CVAR
	LOCAL _CTYPE    := _ALINCONF[8]
	LOCAL _URETURN
	LOCAL _CFIELD   := ALLTRIM(_ALINCONF[1])
	LOCAL _LNOEXIST := VALIDNO(_ALINCONF[2])

	IF _LNOEXIST

		_UCONTENT := &(_ALINCONF[2])
		_CVAR     := _UCONTENT

		IF _ALINCONF[3] == "2"

			DO CASE

			CASE _CTYPE == "D"

				_URETURN := CTOD( SUBSTR(_CVAR, 9, 2) + "/" + SUBSTR(_CVAR, 6, 2) + "/" + SUBSTR(_CVAR, 1, 4) )

			CASE _CTYPE == "N"

				_URETURN := VAL(_CVAR)

			CASE _CTYPE == "C"

				IF VALTYPE(_CVAR) = "N"

					_URETURN := ALLTRIM(STR(_CVAR))

				ELSE

					_URETURN := _CVAR

				ENDIF

			ENDCASE

			IF _ALINCONF[9] == "1" .AND. _CTYPE $ "NC"

				IF _CTYPE == "C" .OR. VALTYPE(_CVAR) <> "N"

					_NVAR := VAL(_URETURN)

				ENDIF

				_URETURN := STRZERO(_NVAR, TAMSX3(_CFIELD)[1])

			ENDIF

			_NPOSINI := _ALINCONF[10]
			_NTAMSTR := _ALINCONF[11]

			IF _NPOSINI <> 0 .AND. _NTAMSTR <> 0 .AND. _CTYPE == "C"

				_URETURN := ALLTRIM(_URETURN)

				IF _NPOSINI + _NTAMSTR - 1 <= LEN(_URETURN)

					_URETURN := SUBSTR(_URETURN, _NPOSINI, _NTAMSTR)

				ENDIF

			ENDIF

		ELSE

			_CALIAS  := _ALINCONF[4]
			_NINDEX  := _ALINCONF[5]
			_CKEY    := STRTRAN(_ALINCONF[6], "%CVAR%",  + '"' + _UCONTENT + '"' )
			_CFIELD  := _ALINCONF[7]

			_URETURN := POSICIONE(_CALIAS, _NINDEX, &(_CKEY), _CFIELD)

		ENDIF

	ELSE

		DO CASE

		CASE _CTYPE == "D"

			_URETURN := CTOD("")

		CASE _CTYPE == "N"

			_URETURN := 0

		CASE _CTYPE == "C"

			_URETURN := ""

		ENDCASE

	ENDIF

RETURN(_URETURN)

/*
=================================================================================
=================================================================================
||   Arquivo:	RCOMA91NEW.prw
=================================================================================
||   Funcao: 	CRIAXLS
=================================================================================
||   Descricao
||-------------------------------------------------------------------------------
|| 		Cria arquivo XML com as ocorrencias da importacao
|| 
=================================================================================
=================================================================================
||   Autor: 
||   Data:
=================================================================================
=================================================================================
*/

STATIC FUNCTION CRIAXLS(_AERRO)

	//LOCAL		_NX			:= 0
	LOCAL 		AITENS		:= {}
	LOCAL 		AITTT		:= {}
	LOCAL 		OEXCEL 		:= FWMSEXCEL():NEW()
	//LOCAL 		OEXCELAPP
	LOCAL 		CTITSHEET	:= "LOG DE IMPORTACAO XML"
	LOCAL 		CTITTABLE	:= "LOG DE IMPORTACAO XML"
	LOCAL		CARQ        := ""
	//LOCAL 		CTEMP		:= ""
	LOCAL		_NERR		:= 0

	OEXCEL:ADDWORKSHEET(CTITSHEET)
	OEXCEL:ADDTABLE(CTITSHEET,CTITTABLE)
	OEXCEL:SETTITLESIZEFONT(14)
	OEXCEL:SETTITLEBOLD(.T.)
	OEXCEL:SETTITLEFRCOLOR("#000000")
	OEXCEL:SETTITLEBGCOLOR("#778899")
	OEXCEL:SETLINESIZEFONT(12)
	OEXCEL:SET2LINESIZEFONT(12)

	//OCORRENCIA	//EMPRESA	//FILIAL	//DATA	//HORA	//ARQUIVO	//MENSAGEM	//FORNECEDOR	//LOJA//CNPJ	//NOME	//NOTA	//SERIE	//CHAVE//ITEM	//COD PRODUTO NO FORNECEDOR	//COD PRODUTO INTERNO	//DESCRIÇÃO	//UNIDADE DE MEDIDA

	/*01*/ OEXCEL:ADDCOLUMN(CTITSHEET, CTITTABLE, "OCORRENCIA",          2, 1)
	/*02*/ OEXCEL:ADDCOLUMN(CTITSHEET, CTITTABLE, "EMPRESA",             2, 1)
	/*03*/ OEXCEL:ADDCOLUMN(CTITSHEET, CTITTABLE, "FILIAL",              2, 1)
	/*04*/ OEXCEL:ADDCOLUMN(CTITSHEET, CTITTABLE, "DATA",                2, 1)
	/*05*/ OEXCEL:ADDCOLUMN(CTITSHEET, CTITTABLE, "HORA",                2, 1)
	/*06*/ OEXCEL:ADDCOLUMN(CTITSHEET, CTITTABLE, "ARQUIVO",             2, 1)
	/*07*/ OEXCEL:ADDCOLUMN(CTITSHEET, CTITTABLE, "MENSAGEM",            2, 1)
	/*08*/ OEXCEL:ADDCOLUMN(CTITSHEET, CTITTABLE, "FORNECEDOR",          2, 1)
	/*09*/ OEXCEL:ADDCOLUMN(CTITSHEET, CTITTABLE, "LOJA",                2, 1)
	/*10*/ OEXCEL:ADDCOLUMN(CTITSHEET, CTITTABLE, "CNPJ",                2, 1)
	/*11*/ OEXCEL:ADDCOLUMN(CTITSHEET, CTITTABLE, "NOME",                2, 1)
	/*12*/ OEXCEL:ADDCOLUMN(CTITSHEET, CTITTABLE, "NOTA",                2, 1)
	/*13*/ OEXCEL:ADDCOLUMN(CTITSHEET, CTITTABLE, "SERIE",               2, 1)
	/*14*/ OEXCEL:ADDCOLUMN(CTITSHEET, CTITTABLE, "CHAVE",               2, 1)
	/*15*/ OEXCEL:ADDCOLUMN(CTITSHEET, CTITTABLE, "ITEM",                2, 1)
	/*16*/ OEXCEL:ADDCOLUMN(CTITSHEET, CTITTABLE, "COD PROD FORNECEDOR", 2, 1)
	/*17*/ OEXCEL:ADDCOLUMN(CTITSHEET, CTITTABLE, "COD PROD INTERNO",    2, 1)
	/*18*/ OEXCEL:ADDCOLUMN(CTITSHEET, CTITTABLE, "DESCRICAO",           2, 1)
	/*19*/ OEXCEL:ADDCOLUMN(CTITSHEET, CTITTABLE, "UNIDADE DE MEDIDA",   2, 1)

	FOR _NERR := 1 TO LEN(_AERRO)

		AITENS := {}
		AITTT	:= {}

		AADD(AITENS, _AERRO[_NERR][01])
		AADD(AITENS, _AERRO[_NERR][02])
		AADD(AITENS, _AERRO[_NERR][03])
		AADD(AITENS, _AERRO[_NERR][04])
		AADD(AITENS, _AERRO[_NERR][05])
		AADD(AITENS, _AERRO[_NERR][06])
		AADD(AITENS, _AERRO[_NERR][07])
		AADD(AITENS, _AERRO[_NERR][08])
		AADD(AITENS, _AERRO[_NERR][09])
		AADD(AITENS, _AERRO[_NERR][10])
		AADD(AITENS, _AERRO[_NERR][11])
		AADD(AITENS, _AERRO[_NERR][12])
		AADD(AITENS, _AERRO[_NERR][13])
		AADD(AITENS, _AERRO[_NERR][14])
		AADD(AITENS, _AERRO[_NERR][15])
		AADD(AITENS, _AERRO[_NERR][16])
		AADD(AITENS, _AERRO[_NERR][17])
		AADD(AITENS, _AERRO[_NERR][18])
		AADD(AITENS, _AERRO[_NERR][19])

		AADD(AITTT, AITENS)
		OEXCEL:ADDROW(CTITSHEET, CTITTABLE, AITTT[1])

	NEXT

	OEXCEL:ACTIVATE()

	CARQ := "LOGIMPORTXML_" + DTOS(DDATABASE) + STRTRAN(TIME(), ":","") + ".XLS"

	OEXCEL:GETXMLFILE( CARQ )

	SLEEP(9000)

	OEXCEL:DEACTIVATE()

	IF SUBSTR(_CDESTCLI,LEN(_CDESTCLI),1) != "\"

		_CDESTCLI += "\"

	ENDIF

	IF __COPYFILE( CARQ, _CDESTCLI + CARQ )

		WFLOGPROC(_CDESTCLI + CARQ)
		FERASE( CARQ )

	ELSE

		CONOUT( "RCOMA91 - ARQUIVO NÃO COPIADO PARA TEMPORÁRIO DO USUÁRIO." )

	ENDIF

RETURN

/*
=================================================================================
=================================================================================
||   Arquivo:	RCOMA91NEW.prw
=================================================================================
||   Funcao: 	TRAUNMED
=================================================================================
||   Descricao
||-------------------------------------------------------------------------------
|| 		Trata 1a e 2a Unidade de Medida e faz as conversoes
|| 
=================================================================================
=================================================================================
||   Autor: 
||   Data:
=================================================================================
=================================================================================
*/

STATIC FUNCTION TRAUNMED(_CD1PROD, _D1UNID, _ND1QUANT)

	LOCAL _AUNID    := {}
	LOCAL _COLDAREA := ALIAS()
	LOCAL _AOLDAREA := GETAREA()
	LOCAL _ASB1AREA := SB1->(GETAREA())

	DBSELECTAREA("SB1")
	DBSETORDER(1)
	IF DBSEEK(XFILIAL("SB1") + _CD1PROD)

		//EFETUA A EQUIVALENCIA ENTRE UN E PC. TENTA PRIMEIRO PELA 1A UNIDADE DE MEDIDA
		IF SB1->B1_UM $ "UN/PC" .AND. _D1UNID $ "UN/PC" .AND. SB1->B1_UM <> _D1UNID

			_D1UNID := SB1->B1_UM

		ELSE // CASO NAO CONSIGA TENTA PELA 2A UNIDADE DE MEDIDA

			IF SB1->B1_SEGUM $ "UN/PC" .AND. _D1UNID $ "UN/PC" .AND. SB1->B1_SEGUM <> _D1UNID

				_D1UNID := SB1->B1_SEGUM

			ENDIF

		ENDIF


		DO CASE

			//CASO A UNIDADE SEJA A PRIMEIRA DO PRODUTO, APENAS CALCULA A SEGUNDA
		CASE SB1->B1_UM    == _D1UNID

			AADD(_AUNID, {_D1UNID, _ND1QUANT, "1"})

			IF !EMPTY(SB1->B1_SEGUM) .AND. !EMPTY(SB1->B1_CONV) .AND. SB1->B1_TIPCONV $ "MD"

				//DA PRIMEIRA PRA SEGUNDA
				_NNEWQUANT :=  CONVUM(_CD1PROD, _ND1QUANT,   0, 2)

				AADD(_AUNID, {SB1->B1_SEGUM, _NNEWQUANT, "2"})

			ENDIF

			//CASO A UNIDADE SEJA A SEGUNDA DO PRODUTO,
		CASE SB1->B1_SEGUM == _D1UNID

			IF !EMPTY(SB1->B1_SEGUM) .AND. !EMPTY(SB1->B1_CONV) .AND. SB1->B1_TIPCONV $ "MD"

				//DA SEGUNDA PRA PRIMEIRA
				_NNEWQUANT := CONVUM(_CD1PROD,   0,   _ND1QUANT, 1)

				AADD(_AUNID, {SB1->B1_UM,    _NNEWQUANT, "2"})
				AADD(_AUNID, {SB1->B1_SEGUM, _ND1QUANT,  "1"})

			ENDIF

		ENDCASE

	ENDIF

	DBSELECTAREA("SB1")
	RESTAREA(_ASB1AREA)

	DBSELECTAREA(_COLDAREA)
	RESTAREA(_AOLDAREA)

RETURN(_AUNID)

/*
=================================================================================
=================================================================================
||   Arquivo:	RCOMA91NEW.prw
=================================================================================
||   Funcao: 	SORTXML
=================================================================================
||   Descricao
||-------------------------------------------------------------------------------
|| 		Funcao para organizar array por CNPJ de Empresa de Destino. Acerta a 
|| 	ordem dos arquivos XML para facilitar o processo de Leitura e Gravação 
|| 	das NF´s.
|| 
=================================================================================
=================================================================================
||   Autor: 
||   Data:
=================================================================================
=================================================================================
*/

STATIC FUNCTION SORTXML(_ATOSORT)

	LOCAL   _CEXML    := ""
	LOCAL   _CWXML    := ""
	Local   _NSR	  := 0
	PRIVATE OSORTXML  := NIL
	PRIVATE _AUNSORT  := {}
	PRIVATE _ASORTED  := {}
	PRIVATE _CCGCDEST := ""
	PRIVATE _CCGCEMIT := ""
	PRIVATE _CARQ     := ""

	FOR _NSR := 1 TO LEN(_ATOSORT)

		_CNAME := ALLTRIM(_ATOSORT[_NSR][1])

		_CPATH := ALLTRIM(CDIR)

		DO CASE

		CASE (SUBSTR(_CPATH, LEN(_CPATH), 1) == "\" .AND. SUBSTR(_CNAME, 1, 1) <> "\") .OR. (SUBSTR(_CPATH, LEN(_CPATH), 1) <> "\" .AND. SUBSTR(_CNAME, 1, 1) == "\")

			_CARQ := _CPATH + _CNAME

		CASE SUBSTR(_CPATH, LEN(_CPATH), 1) == "\" .AND. SUBSTR(_CNAME, 1, 1) == "\"

			_CARQ := _CPATH + SUBSTR(_CNAME, 2, LEN(_CNAME) )

		CASE SUBSTR(_CPATH, LEN(_CPATH), 1) <> "\" .AND. SUBSTR(_CNAME, 1, 1) <> "\"

			_CARQ := _CPATH + "\" + _CNAME

		ENDCASE

		_CARQ := STRTRAN(_CARQ, "\\", "\")

		OSORTXML   := XMLPARSERFILE(_CARQ, "_", @_CEXML, @_CWXML )

		IF TYPE("OSORTXML:_CTEPROC") <> "U"
		//IF .NOT. (OSORTXML:_CTEPROC == NIL)	// comentado em 22/11/2021 por CT ao executar a função ocorre mensagem de erro  
												// quando compilado no release 12.1.33
												// invalid property _CTEPROC on SORTXML(RCOMA91.PRW) 11/08/2021 12:14:02 line : 2809

			IF !(FILE(_CDIRNOIMP))

				CRIADIR(_CDIRNOIMP)

			ENDIF

			COPY FILE &(ALLTRIM(CDIR) + "\" + _CNAME) TO &(ALLTRIM(_CDIRNOIMP) + "\" + "CTE-" + _CNAME)
			FERASE(ALLTRIM(CDIR) + "\" + _CNAME)

		Else
			IF TYPE("OSORTXML:_NFE") <> "U"
			//IF .NOT. (OSORTXML:_NFE == NIL) -- comentado em 22/11/2021 por CT ao executar a função ocorre mensagem de erro 

				_CCGCDEST := IF(TYPE("OSORTXML:_NFE:_INFNFE:_DEST:_CNPJ:TEXT")=="U" , OSORTXML:_NFE:_INFNFE:_DEST:_CPF:TEXT, OSORTXML:_NFE:_INFNFE:_DEST:_CNPJ:TEXT)
				_CCGCEMIT := OSORTXML:_NFE:_INFNFE:_EMIT:_CNPJ:TEXT

			ELSE

				_CCGCDEST := IF(TYPE("OSORTXML:_NFEPROC:_NFE:_INFNFE:_DEST:_CNPJ:TEXT") == "U", OSORTXML:_NFEPROC:_NFE:_INFNFE:_DEST:_CPF:TEXT, OSORTXML:_NFEPROC:_NFE:_INFNFE:_DEST:_CNPJ:TEXT)
				_CCGCEMIT := OSORTXML:_NFEPROC:_NFE:_INFNFE:_EMIT:_CNPJ:TEXT

			ENDIF

			AADD(_ASORTED, {_CARQ, _CCGCDEST + _CCGCEMIT, _CNAME })
		EndIf

		IF TYPE("OSORTXML") == "O"
		//IF .NOT. (OSORTXML == NIL)

			FREEOBJ(OSORTXML)

		ENDIF

	NEXT

	ASORT(_ASORTED,,, { |X,Y| X[2] < Y[2] } )

RETURN(_ASORTED)

/*
=================================================================================
=================================================================================
||   Arquivo:	WFRCOMA91.PRW
=================================================================================
||   Funcao: 	WFLOGPROC
=================================================================================
||   Descricao
||-------------------------------------------------------------------------------
|| 		Funcao para envio de LOG de Processo.
||
=================================================================================
=================================================================================
||   Autor:	Edson Hornberger
||   Data:	13/11/2014
=================================================================================
=================================================================================
*/

STATIC FUNCTION WFLOGPROC(CPATHXML)

	//LOCAL CEMAIL	:= "carlos.torres@taiffproart.com.br"
	LOCAL CEMAIL	:= SUPERGETMV("MV_XMLRESP",.F.,"grp_sistemas@taiff.com.br")
	LOCAL OPROCESS
	LOCAL CDTAHRA	:= DTOC(DATE()) + " - " + SUBSTR(TIME(),1,5)

	//## Cria processo de Workflow
	OPROCESS 				:= TWFPROCESS():NEW( "WFRCOMA91", OEMTOANSI("WORKFLOW LEITURA XML - LOGS"))
	OPROCESS:NEWTASK( "WFRCOMA91", "\WORKFLOW\WFRCOMA91.HTM" )
	OPROCESS:CTO 			:= CEMAIL
	OPROCESS:CSUBJECT 		:= OEMTOANSI("WORKFLOW - LEITURA XML")
	OHTML 					:= OPROCESS:OHTML

	//## Anexa os arquivos de LOG e preenche a tabela da pagina HTM com as informacoes dos Pedidos
	IF !EMPTY(CPATHXML)
		OPROCESS:ATTACHFILE(CPATHXML)
	ENDIF
	OHTML:VALBYNAME("DATAHORA"		,CDTAHRA)

	//## Envia WorkFlow e Encerra
	OPROCESS:CLIENTNAME( 'edonizetti' )
	OPROCESS:USERSIGA	:= "000748"
	OPROCESS:START()
	OPROCESS:FREE()

RETURN .T.

/*
=================================================================================
=================================================================================
||   Arquivo:	RCOMA91NEW.prw
=================================================================================
||   Funcao: 	CRIADIR
=================================================================================
||   Descricao
||-------------------------------------------------------------------------------
|| 		Funcao para criar Diretorios conforme parametro passado.
|| 
=================================================================================
=================================================================================
||   Autor: 
||   Data:
=================================================================================
=================================================================================
*/

STATIC FUNCTION CRIADIR(_CCAMINHO)

	LOCAL _ACAMINHO := STR2ARR(_CCAMINHO, "\")
	LOCAL _CCRIADIR := ""
	LOCAL _CNIVEL   := ""
	LOCAL _NNIVEL   := 0

	FOR _NNIVEL := 1 TO LEN(_ACAMINHO)

		_CNIVEL := LOWER(ALLTRIM(STRTRAN(_ACAMINHO[_NNIVEL], "\", "")))

		IF !EMPTY(_CNIVEL)

			_CCRIADIR += "\" + _CNIVEL

			MAKEDIR(_CCRIADIR)

		ENDIF

	NEXT _NNIVEL

RETURN
