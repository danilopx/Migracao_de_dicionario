#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'TOPCONN.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'TOTVS.CH'
/*
=================================================================================
=================================================================================
||   Arquivo:	ACDREL01.prw
=================================================================================
||   Funcao:	ACDREL01 
=================================================================================
||   Descricao
||-------------------------------------------------------------------------------
|| 		Função que gera planilha Excel com informações de Apontamentos de 
|| 	Produção com o Coletor de Dados. 
|| 
=================================================================================
=================================================================================
||   Autor:	Edson Hornberger 
||   Data:	25/04/16
=================================================================================
=================================================================================
*/

USER FUNCTION ACDREL01()

LOCAL		NX			:= 0
LOCAL 		AITENS		:= {}
LOCAL 		AITTT		:= {}
LOCAL 		ASTRUCT	:= {}
LOCAL 		OEXCEL 		:= FWMSEXCEL():NEW()
LOCAL 		OEXCELAPP
LOCAL 		CTITSHEET	:= "Análise de Apontamentos"
LOCAL 		CTITTABLE	:= "Análise de Apontamentos"
LOCAL		CARQ
LOCAL		CPERG		:= PADL("ACDREL01",10)
LOCAL		APERG		:= {}

/*01*/AADD(APERG,{"OP de:"			,"C",11,00,"G","","","","","","","SC2"})
/*02*/AADD(APERG,{"OP ate:"			,"C",11,00,"G","","","","","","","SC2"})
/*03*/AADD(APERG,{"Dt. Ini. de:"	,"D",08,00,"G","","","","","","",""})
/*04*/AADD(APERG,{"Dt. Ini. ate:"	,"D",08,00,"G","","","","","","",""})
/*05*/AADD(APERG,{"Dt. Fim de:"		,"D",08,00,"C","","","","","","",""})	
/*06*/AADD(APERG,{"Dt. Fim ate:"	,"D",08,00,"C","","","","","","",""})
/*07*/AADD(APERG,{"Recurso de:"		,"C",10,00,"C","","","","","","","SH1"})
/*08*/AADD(APERG,{"Recurso ate:"	,"C",10,00,"C","","","","","","","SH1"})
/*09*/AADD(APERG,{"Operador de:"	,"C",06,00,"C","","","","","","","CB1"})
/*10*/AADD(APERG,{"Operador ate:"	,"C",06,00,"C","","","","","","","CB1"})
/*11*/AADD(APERG,{"Operacao de:"	,"C",02,00,"C","","","","","","","SG2"})
/*12*/AADD(APERG,{"Operacao de:"	,"C",02,00,"C","","","","","","","SG2"})

U_GERAPERG(CPERG,APERG)

IF !PERGUNTE(CPERG,.T.)
	
	MSGALERT(OEMTOANSI("Operação Cancelada pelo Usuário"),"Análise de Estoques")
	RETURN()
	
ENDIF

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

aResult := {}
If TCSPExist("SP_ANALISE_APONTAM")

	aResult := TCSPEXEC("SP_ANALISE_APONTAM", CEMPANT, CFILANT, MV_PAR01, MV_PAR02, DTOS(MV_PAR03), DTOS(MV_PAR04), DTOS(MV_PAR05), DTOS(MV_PAR06), MV_PAR07, MV_PAR08, MV_PAR09, MV_PAR10, MV_PAR11, MV_PAR12, DTOS(ddatabase)+SUBSTR(TIME(),1,2)+SUBSTR(TIME(),4,2) )
	If Select("TRBEXC") > 0
		dbSelectArea("TRBEXC")
		DbCloseArea()
	EndIf
	TCQuery "SELECT * FROM " + aResult[1] NEW ALIAS "TRBEXC"
	
Else

	Final("Erro na Procedure SP_ANALISE_APONTAM")	

EndIf

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

TRBEXC->(dbCloseArea())

//Exclui a tabela temporaria do Banco de Dados
If TcCanOpen(aResult[1])
	TcSqlExec("DROP TABLE "+aResult[1])
EndIf

///<---- inicio da construção da segunda planilha com dados da SH6
CTITSHEET	:= "Apontamento SH6"
CTITTABLE	:= "Apontamento SH6"
OEXCEL:ADDWORKSHEET(CTITSHEET)
OEXCEL:ADDTABLE(CTITSHEET,CTITTABLE)
OEXCEL:SETTITLESIZEFONT(14)
OEXCEL:SETTITLEBOLD(.T.)
OEXCEL:SETTITLEFRCOLOR("#000000")
OEXCEL:SETTITLEBGCOLOR("#778899")
OEXCEL:SETLINESIZEFONT(12)
OEXCEL:SET2LINESIZEFONT(12)

aResult := {}
If TCSPExist("SP_ANALISE_APONTAM_SH6")

	aResult := TCSPEXEC("SP_ANALISE_APONTAM_SH6", CEMPANT, CFILANT, MV_PAR01, MV_PAR02, DTOS(MV_PAR03), DTOS(MV_PAR04), DTOS(MV_PAR05), DTOS(MV_PAR06), MV_PAR07, MV_PAR08, MV_PAR09, MV_PAR10, MV_PAR11, MV_PAR12, DTOS(ddatabase)+SUBSTR(TIME(),1,2)+SUBSTR(TIME(),4,2) )
	If Select("TMPBM") > 0
		dbSelectArea("TMPBM")
		DbCloseArea()
	EndIf
	TCQuery "SELECT * FROM " + aResult[1] NEW ALIAS "TMPBM"
	
Else

	Final("Erro na Procedure SP_ANALISE_APONTAM_SH6")	

EndIf

DBSELECTAREA("TMPBM")

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

WHILE TMPBM->(!EOF()) 
	
	AITENS := {}
	AITTT	:= {}
	
	FOR NX := 1 TO FCOUNT()
	
		AADD(AITENS,&("TMPBM->" + FIELDNAME(NX)))
		
	NEXT NX  
	
	AADD(AITTT,AITENS)
	OEXCEL:ADDROW(CTITSHEET,CTITTABLE,AITTT[1])
	
	TMPBM->(DBSKIP())
	
ENDDO

TMPBM->(dbCloseArea())


//Exclui a tabela temporaria do Banco de Dados
If TcCanOpen(aResult[1])
	TcSqlExec("DROP TABLE "+aResult[1])
EndIf

///<---- fim da segunda planilha com dados da SH6
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
	
RETURN
