#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE 'TOPCONN.CH'
#INCLUDE "TOTVS.CH"
#INCLUDE "XMLXFUN.CH"

#DEFINE ENTER CHR(13) + CHR(10)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ MT103CTE บAutor  ณ CARLOS TORRES     บ Data ณ  19/02/2021  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Busca com chave eletronica do CTe os dados do municipio e  บฑฑ
ฑฑบ          ณ da UF contidos no XML do CTe, para carga no documento      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
Alteracao:
*/


USER FUNCTION MT103CTE( cChvCte, cF1MUORITR, cF1UFORITR, cF1MUDESTR, cF1UFDESTR, lUpd )

Local cDir := ""
Local cDirImp := ""
Local cFileN := ""
Local cXmlFl := ""
Local cAviso := ""
Local cErro := ""
Local cUpd := ""
Local lArq := .T.
Local lMov := .F.
Default cChvCte := ""
Default cF1MUORITR := ""
Default cF1UFORITR := ""
Default cF1MUDESTR := ""
Default cF1UFDESTR := ""
Default lUpd := .F.
Private oNfeXMLF := Nil

If !Empty( cChvCte )

    cDir := "\XML\IN_CTE\"
    cDirImp := "\XML\IN_CTE\PROCESSADO\"
    cFileN := Alltrim(cChvCte) + "-procCTe.xml"

    If File( cDir + cFileN )
        cXmlFl := cDir + cFileN
        lMov := .T.
    Else
        If File( cDirImp + cFileN )
            cXmlFl := cDirImp + cFileN
        Else
            lArq := .F.
        EndIf
    EndIf

    If lArq 

        oNfeXMLF := XmlParserFile( cXmlFl, "_", @cAviso, @cErro )

        Iif( Type("oNfeXMLF:_CTEPROC:_CTe:_INFCTE:_IDE:_UFIni:TEXT")<>"U", cF1UFORITR:=oNfeXMLF:_CTEPROC:_CTe:_INFCTE:_IDE:_UFIni:TEXT, cF1UFORITR:="" )
        Iif( Type("oNfeXMLF:_CTEPROC:_CTe:_INFCTE:_IDE:_cMunIni:TEXT")<>"U", cF1MUORITR:=oNfeXMLF:_CTEPROC:_CTe:_INFCTE:_IDE:_cMunIni:TEXT, cF1MUORITR:="" )
        Iif( Type("oNfeXMLF:_CTEPROC:_CTe:_INFCTE:_IDE:_UFFim:TEXT")<>"U", cF1UFDESTR:=oNfeXMLF:_CTEPROC:_CTe:_INFCTE:_IDE:_UFFim:TEXT, cF1UFDESTR:="" )
        Iif( Type("oNfeXMLF:_CTEPROC:_CTe:_INFCTE:_IDE:_cMunFim:TEXT")<>"U", cF1MUDESTR:=oNfeXMLF:_CTEPROC:_CTe:_INFCTE:_IDE:_cMunFim:TEXT, cF1MUDESTR:="" )

        cF1MUORITR := SubStr( cF1MUORITR, 3, 5 )
        cF1MUDESTR := SubStr( cF1MUDESTR, 3, 5 )

        If lUpd

            cUpd := "UPDATE " +RetSqlName("SF1")+ " "
            cUpd += "SET "
		    cUpd += "F1_MUORITR = '" +cF1MUORITR+ "', "
		    cUpd += "F1_UFORITR = '" +cF1UFORITR+ "', "
		    cUpd += "F1_MUDESTR = '" +cF1MUDESTR+ "', "
		    cUpd += "F1_UFDESTR = '" +cF1UFDESTR+ "' "
            cUpd += "WHERE D_E_L_E_T_ = ' ' "
            cUpd += "AND F1_CHVNFE = '" +cChvCte+ "'"

            TcSqlExec(cUpd)

        Else

            If lMov

                Copy File &( cXmlFl ) To &( cDirImp + cFileN )
                FERase( cXmlFl )

            EndIf

        EndIf

    EndIf

EndIf

Return(Nil)



USER FUNCTION MT103PUT

LOCAL CQUERY := ""

PRIVATE nHdl    := ""
PRIVATE oNFChv
PRIVATE oIdent
PRIVATE CDIR := "\XML\IN_CTE\"
PRIVATE _CDIRNOIMP:= "C:\lixo\CTE_PROCESSADO\"
PRIVATE _CDIRIMP:= "\XML\IN_CTE\PROCESSADO\"
PRIVATE _CNAME  := ""
PRIVATE _CFILE	:= ""
PRIVATE _CHAVECTE := ""
PRIVATE _ONFE := TYPE("oNfe")

RPCCLEARENV()
RPCSETTYPE(3)
PREPARE ENVIRONMENT EMPRESA "01" FILIAL "01" MODULO "COM"

CQUERY := "SELECT DISTINCT F1_CHVNFE AS CHAVECTE,SF1.R_E_C_N_O_ AS POSICAO" + ENTER
CQUERY += "FROM SF1040 SF1" + ENTER
CQUERY += "INNER JOIN SD1040 SD1" + ENTER
CQUERY += "ON D1_FILIAL=F1_FILIAL" + ENTER
CQUERY += "AND D1_DOC=F1_DOC" + ENTER
CQUERY += "AND D1_SERIE=F1_SERIE" + ENTER
CQUERY += "AND D1_FORNECE=F1_FORNECE" + ENTER
CQUERY += "AND SD1.D_E_L_E_T_=''" + ENTER
CQUERY += "AND D1_DTDIGIT>='20210201'" + ENTER
CQUERY += "WHERE F1_FILIAL='02' " + ENTER
CQUERY += "AND SF1.D_E_L_E_T_=''" + ENTER
CQUERY += "AND F1_ESPECIE='CTE'" + ENTER
CQUERY += "AND F1_UFORITR=''" + ENTER
CQUERY += "AND F1_CHVNFE!=''" + ENTER

IF SELECT("CTES") > 0 
    DBSELECTAREA("CTES")
    DBCLOSEAREA()
ENDIF 
TCQUERY CQUERY NEW ALIAS "CTES"
DBSELECTAREA("CTES")
DBGOTOP()
WHILE .NOT. CTES->(EOF())

    IF .NOT. (oNfe == NIL)
        FREEOBJ(oNfe)
    ENDIF

    _CFILE	:= ALLTRIM(CTES->CHAVECTE) + "-PROCCTE.XML"

    cAviso := ""
    cErro  := ""
    oNfe := XMLPARSERFILE(CDIR + _CFILE,"_",@cAviso,@cErro)
    If (oNfe == NIL )
        CONOUT(PROCNAME() + " - " + ALLTRIM(STR(PROCLINE())) + " Falha ao gerar Objeto XML : " + cAviso + " / " + cErro)
    ELSE
        CF1MUORITR := oNfe:_CTEPROC:_CTe:_INFCTE:_IDE:_cMunIni:TEXT
        CF1UFORITR := oNfe:_CTEPROC:_CTe:_INFCTE:_IDE:_UFIni:TEXT
        CF1UFDESTR := oNfe:_CTEPROC:_CTe:_INFCTE:_IDE:_UFFim:TEXT
        CF1MUDESTR := oNfe:_CTEPROC:_CTe:_INFCTE:_IDE:_cMunFim:TEXT

        CF1MUORITR := SUBSTRING(CF1MUORITR,3,5)
        CF1MUDESTR := SUBSTRING(CF1MUDESTR,3,5)

        CQUERY := "UPDATE SF1 SET " + ENTER
        CQUERY += " F1_MUORITR = '" + CF1MUORITR + "' " + ENTER
        CQUERY += " ,F1_UFORITR = '" + CF1UFORITR + "' " + ENTER
        CQUERY += " ,F1_UFDESTR = '" + CF1UFDESTR + "' " + ENTER
        CQUERY += " ,F1_MUDESTR = '" + CF1MUDESTR + "' " + ENTER
        CQUERY += "FROM SF1030 SF1 " + ENTER 
        CQUERY += "WHERE " + ENTER 
        CQUERY += "SF1.R_E_C_N_O_ = " + ALLTRIM(STR(CTES->POSICAO)) + ENTER 

        IF TCSQLEXEC(CQUERY) != 0 
            
            CONOUT(PROCNAME() + " - Erro ao tentar alterar conte๚do dos campos de frete!"  + ENTER + ;
                 " ARQUIVO: " + _CFILE )
            
        ELSE
			COPY FILE &(ALLTRIM(CDIR) +  _CFILE) TO &(ALLTRIM(_CDIRIMP) + _CFILE)
			FERASE(ALLTRIM(CDIR) + _CFILE)
            CONOUT(PROCNAME() + " - " + ALLTRIM(STR(PROCLINE())) + " CARGA DA CHAVE OK : " + _CFILE )
        ENDIF 

    ENDIF

    CTES->(DBSKIP())

END

RETURN



User Function TFQBG001()
Local dDtProc := ( dDataBase - 45 )

If IsBlind()
    Prc001(DtoS(dDtProc))
Else
    MsgRun("Gravando Dados de Municipio/UF em CT-e desde " +DtoC(dDtProc)+ "...","",{||CursorWait(),Prc001(DtoS(dDtProc)),CursorArrow()})
EndIf

Return(Nil)

Static Function Prc001(cDtProc)
Local cQry := ""

cQry := "SELECT "
cQry += "F1_CHVNFE AS F1CHVNFE "
cQry += "FROM " +RetSqlName("SF1")+ " WHERE D_E_L_E_T_ = ' ' "
cQry += "AND F1_ESPECIE = 'CTE' "
cQry += "AND F1_MUORITR = '' "
cQry += "AND F1_EMISSAO >= '" +cDtProc+ "' "
cQry += "AND F1_CHVNFE <> '' "

Iif(Select("WQBG01")>0,WQBG01->(dbCloseArea()),Nil)
dbUseArea(.T.,"TOPCONN",TCGenQry(,,cQry),"WQBG01",.T.,.T.)
WQBG01->(dbGoTop())

While WQBG01->(!EoF())

    U_MT103CTE( WQBG01->F1CHVNFE ,,,,, .T. )

    WQBG01->(dbSkip())
EndDo
WQBG01->(dbCloseArea())

Return(Nil)
