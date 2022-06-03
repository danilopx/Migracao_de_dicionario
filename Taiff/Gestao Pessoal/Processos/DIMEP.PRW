#INCLUDE "PROTHEUS.CH"
#INCLUDE "topconn.ch"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ DIMEP    บ       ณRICARDO DUARTE COSTAบ Data ณ  22/03/2013 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Exporta็ใo das informa็๕es de funcionแrios para importa็ใo บฑฑ
ฑฑบ          ณ no Dimep.                                                  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
User Function DIMEP()

Local aArea	:= GetArea()
Private cString, cPerg, oGera

cPerg       := "DIMEP     "

CriaSx1(cPerg)

Pergunte(cPerg, .F.)
dbSelectArea("SRA")
dbSetOrder(1)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Montagem da tela de processamento.                                  ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

DEFINE DIALOG oGera TITLE OemToAnsi("Dimep Gera็ใo de Cart๕es") FROM 200,1 TO 400,480 PIXEL
//@ 200,1 TO 400,480 DIALOG oGera TITLE OemToAnsi("Dimep Gera็ใo de Cart๕es")
@ 02,10 TO 095,230 PIXEL Of oGera
@ 10,018 Say " Este programa ira gerar um arquivo texto com os funcionแrios a" PIXEL Of oGera
@ 18,018 Say " serem importados para o arquivo de rel๓gio.                   " PIXEL Of oGera

DEFINE SBUTTON FROM 70,188	  TYPE 1 ACTION OkGera()			ENABLE pixel OF oGera
DEFINE SBUTTON FROM 70,158	  TYPE 2 ACTION oGera:end()			ENABLE pixel OF oGera
DEFINE SBUTTON FROM 70,128    TYPE 5 ACTION Pergunte(cPerg,.T.) ENABLE pixel OF oGera
//@ 70,128 BMPBUTTON TYPE 05 ACTION Pergunte(cPerg,.T.)
//@ 70,158 BMPBUTTON TYPE 02 ACTION Close(oGera)
//@ 70,188 BMPBUTTON TYPE 01 ACTION OkGera()

Activate Dialog oGera Centered

RestArea(aArea)

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณ OKGERA   บ Autor ณRICARDO DUARTE COSTAบ Data ณ  17/06/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Funcao chamada pelo botao OK na tela inicial de processamenบฑฑ
ฑฑบ          ณ to. Executa a geracao do arquivo texto.                    บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Programa principal                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿ /*/
Static Function OkGera

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Variaveis                                                           ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
cFilDe		:= mv_par01
cFilAte		:= mv_par02
cMatDe		:= mv_par03
cMatAte		:= mv_par04
cSit		:= fSqlIN( mv_par05, 1 )
cCat		:= fSqlIN( mv_par06, 1 )
cDestino	:= Alltrim(MV_PAR07)
cTurnoDe	:= mv_par08
cTurnoAte	:= mv_par09

//-- Confirma a operacao antes de sair executando
If !GPECROk()
	Return()
Endif

If	cFilAte < cFilDe .Or.;
	cMatAte < cMatDe
	Aviso("Aten็ใo","Corrija os parโmetros, pois existe inconsist๊ncia.",{"OK"})
	return
Else
	Processa({|| RunCont() },"Processando...")
Endif

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณ RUNCONT  บ Autor ณRICARDO DUARTE COSTAบ Data ณ  17/06/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Funcao auxiliar chamada pela PROCESSA.  A funcao PROCESSA  บฑฑ
ฑฑบ          ณ monta a janela com a regua de processamento.               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Programa principal                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿ /*/
Static Function RunCont

Local cDet			:= ""
Local cDirDocs   	:= MsDocPath()
Local cArquivo   	:= "CRACHAS_"+Alltrim(SM0->M0_NOME)
Local nHandle
Local aLog			:= {{}}
Local aTitle		:= {"Funcionแrio sem Pis - Nใo gerados"}
Private lCont		:= .F.

//-- Selecionando valores por funcionแrio
MsAguarde( {|| lCont := fMtaSRA()}, "Processando...", "Selecionando funcionแrio a exportar..." )

//Aviso que nใo existem dados para gerar
If !lCont
	Aviso("ATENCAO","Nao funcionแrios no intervalo de parโmetros selecionados. Verifique.",{"Sair"})
	Return
Endif

nHandle := MsfCreate(cDirDocs+"\"+cArquivo+".TXT",0)
If nHandle > 0

	//-- Processamento
	While !WSRA->(eof())
		IncProc("Gerando arquivo texto")
		cDet	:= ""
		
		//-- Pis invแlido nใo serใo considerados e vใo para o Log de funcionแrios nใo considerados na gera็ใo
		If Empty(WSRA->RA_PIS)
			Aadd(aLog[1],"Pis nใo cadastrado: "+WSRA->RA_FILIAL+"/"+WSRA->RA_MAT+"/"+WSRA->RA_NOME)
			WSRA->(Dbskip())
			loop
		Endif

		//-- Prepara a matricula antes da grava็ใo
		If cEmpAnt == "01"		//-- Daihatsu
			cAux	:= "0"
		ElseIf cEmpAnt == "02"	//-- Mercabel
			cAux	:= "5"
		ElseIf cEmpAnt == "03"	//-- Proart
			cAux	:= "4"
		ElseIf cEmpAnt == "04"	//-- Action
			cAux	:= "3"
		ElseIf cEmpAnt == "05"	//-- Beutyfair
			cAux	:= "6"
		Else
			cAux	:= "0"
		Endif
		cAux	+= Right(WSRA->RA_MAT,5)
		cAux	:= Strzero(val(cAux),20)
		
		//-- Matrํcula no TXT			//-- 01 a 20 - Matrํcula / Cracha
		cDet	+= cAux
		
		//-- Pis no TXT					//-- 21 a 31 - Pis
		cDet	+= Left(Alltrim(WSRA->RA_PIS)+space(11),11)
		
		//-- Senha do Funcionแrio		//-- 32 a 37 - Senha - fixo 00000
		cDet	+= "000000"
		
		//-- Data de admissใo			//-- 38 a 45 - Data de admissใo DDMMYYYY
		cDet	+= right(WSRA->RA_ADMISSA,2)+Substr(WSRA->RA_ADMISSA,5,2)+Left(WSRA->RA_ADMISSA,4)
		
		//-- Nome do funcionแrio		//-- 46 a 97 - Nome do funcionแrio com 52 caracteres no mแximo
		cDet	+= Left(WSRA->RA_NOME+space(52),52)
		
		//-- Descri็ใo da Fun็ใo		//-- 98 a 127 -Descri็ใo da Fun็ใo
		cDet	+= Left(WSRA->RJ_DESC+space(30),30)
		
		//-- N๚mero da credencial		//--128 a 147 -N๚mero da credencial - Fixo 20 espa็os
//		cDet	+= Space(20)			//-- nรO ENVIAR NUMERO DA CREDENCIAL
		
		//-- Final de linha
		cDet	+= CRLF
		//-- Grava a linha do funcionแrio
		fWrite(nHandle,cDet)
		
		//-- Vai para o pr๓ximo registro
		WSRA->(DbSkip())
		
	Enddo
	fClose(nHandle)
	If File(cDestino+cArquivo+".TXT")
		fErase(cDestino+cArquivo+".TXT")
	Endif
	CpyS2T( cDirDocs+"\"+cArquivo+".TXT" , cDestino, .T. )
	Ferase(cDirDocs+"\"+cArquivo+".TXT")
	Aviso("Aten็ใo","O arquivo foi gravado em "+cDestino+cArquivo+".TXT",{"Ok"})
Else
	MsgAlert( "Falha na cria็ใo do arquivo" )
EndIf

//-- Fecha a query corrente
WSRA->(DbCloseArea())
DbSelectArea("SRA")
oGera:end()

//-- Imprime o Log caso tenha algum funcionแrio nใo gerado
If len(aLog[1]) > 0
	fMakeLog(aLog,aTitle,,.T.,"DIMEP","Log da gera็ใo do arquivo de importa็ใo cadastral","M","P",,.F.)
Endif

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfMtaSRA   บAutor  ณRICARDO DUARTE COSTAบ Data ณ  17/06/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณMonta a query de movimento de folha de pagamento.           บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณPrograma principal                                          บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿ */
Static Function fMtaSRA()

Local lRet	:= .F.
Local cQuery

cQuery := " "
cQuery += " SELECT RA_FILIAL, RA_MAT, RA_PIS, RA_NOME, RA_NOMECMP, RJ_DESC, RA_ADMISSA"
cQuery += " FROM "+RetSqlName("SRA")+" SRA, "+RetSqlName("SRJ")+" SRJ"
cQuery += " WHERE"
cQuery += " SRJ.D_E_L_E_T_ = ' '"
cQuery += " AND SRA.D_E_L_E_T_ = ' '"
If !Empty(xFilial("SRJ"))
	cQuery += " AND RA_FILIAL = RJ_FILIAL"
Else
	cQuery += " AND RJ_FILIAL = '  '"
Endif
cQuery += " AND RA_CODFUNC = RJ_FUNCAO"
cQuery += " AND RA_FILIAL BETWEEN '"+cFilDe+"' AND '"+cFilAte+"'"
cQuery += " AND RA_MAT BETWEEN '"+cMatDe+"' AND '"+cMatAte+"'"
cQuery += " AND RA_TNOTRAB BETWEEN '"+cTurnoDe+"' AND '"+cTurnoAte+"'"
cQuery += " AND RA_SITFOLH IN("+cSit+")"
cQuery += " AND RA_CATFUNC IN("+cCat+")"
cQuery += " ORDER BY RA_FILIAL, RA_MAT"
cQuery := ChangeQuery( cQuery )
TCQuery cQuery New Alias "WSRA"

dbSelectArea( "WSRA" )
If !WSRA->(Eof())
	lRet := .T.
EndIf

Return( lRet )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ FSQLIN   บAutor  ณ PRIMA INFORMATICA  บ Data ณ  19/06/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Funcao para Montar a Selecao da Clausula IN do SQL.        บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP8                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function fSqlIN( cTexto, nStep )

 Local cRet := ""
 Local i
 
 cTexto := Rtrim( cTexto )

 If Len( cTexto ) > 0
    For i := 1 To Len( cTexto ) Step nStep
        cRet += "'" + SubStr( cTexto, i, nStep ) + "'"
        
        If i + nStep <= Len( cTexto )
           cRet += ","
        EndIf
    Next
 EndIf

Return( cRet )

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCriaSX1   บ Autor ณRICARDO DUARTE COSTAบ Data ณ  17/06/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณObjetivo desta funcao e verificar se existe o grupo de      บฑฑ
ฑฑบ          ณperguntas, se nao existir a funcao ira cria-lo.             บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณcPerg -> Nome com  grupo de perguntas em questใo.           บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

Static Function CriaSx1(cPerg)

Local _sAlias, aRegs, i,j

_sAlias := Alias()
aRegs := {}
I := 0
J := 0

dbSelectArea("SX1")
dbSetOrder(1)
cPerg := PADR(cPerg,10)
Aadd(aRegs,{cPerg,"01","Filial de ?"         ,"","","mv_ch1","C",02,0,0,"G",""                          ,"MV_PAR01",""       ,"" ,"" ,"","",""     ,"" ,"" ,"","","","","","","","","","","","","","","","","XM0","","",""})
Aadd(aRegs,{cPerg,"02","Filial Ate?"         ,"","","mv_ch2","C",02,0,0,"G","NaoVazio()"                ,"MV_PAR02",""       ,"" ,"" ,"","",""     ,"" ,"" ,"","","","","","","","","","","","","","","","","XM0","","",""})
Aadd(aRegs,{cPerg,"03","Matricula de?"       ,"","","mv_ch3","C",06,0,0,"G",""                          ,"MV_PAR03",""       ,"" ,"" ,"","",""     ,"" ,"" ,"","","","","","","","","","","","","","","","","SRA","","",""})
Aadd(aRegs,{cPerg,"04","Matricula Ate?"      ,"","","mv_ch4","C",06,0,0,"G","NaoVazio()"                ,"MV_PAR04",""       ,"" ,"" ,"","",""     ,"" ,"" ,"","","","","","","","","","","","","","","","","SRA","","",""})
Aadd(aRegs,{cPerg,"05","Situacoes ?"         ,"","","MV_CH5","C",5 ,0,0,"G","fSituacao()"               ,"MV_PAR05",""       ,"" ,"" ,"ADFT"       ,"","" ,"" ,"","","","","","","","","","","","","","","","","","","","",""})
Aadd(aRegs,{cPerg,"06","Categorias ?"        ,"","","MV_CH6","C",12,0,0,"G","fCategoria()"              ,"MV_PAR06",""       ,"" ,"" ,"ACDEGHMPST" ,"","" ,"" ,"","","","","","","","","","","","","","","","","","","","",""})
Aadd(aRegs,{cPerg,"07","Pasta de grava็ใo?  ","","","mv_ch7","C",60,0,0,"G","NaoVazio()"                ,"MV_PAR07",""       ,"" ,"" ,"","",""     ,"" ,"" ,"","","","","","","","","","","","","","","","","   ","","",""})
Aadd(aRegs,{cPerg,"08","Turno de?    "       ,"","","mv_ch8","C",03,0,0,"G",""                          ,"MV_PAR08",""       ,"" ,"" ,"","",""     ,"" ,"" ,"","","","","","","","","","","","","","","","","SR6","","",""})
Aadd(aRegs,{cPerg,"09","Turno At้?    "      ,"","","mv_ch9","C",03,0,0,"G","NaoVazio()"                ,"MV_PAR09",""       ,"" ,"" ,"","",""     ,"" ,"" ,"","","","","","","","","","","","","","","","","SR6","","",""})

For i:=1 to Len(aRegs)
	If !dbSeek(cPerg+aRegs[i,2])
		RecLock("SX1",.T.)
		For j:=1 to FCount()
			If j <= Len(aRegs[i])
				FieldPut(j,aRegs[i,j])
			Endif
		Next
		MsUnlock()
	Endif
Next

dbSelectArea(_sAlias)

Return Nil


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGPECR010  บAutor  ณRicardo Duarte Costaบ Data ณ  06/08/2012 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Funcao GPECROK() - Confirmacao da execucao da geracao das  บฑฑ
ฑฑบ          ณ                    parcelas.                               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Estatica                                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function GPECROk() 
Return ( MsgYesNo( OemToAnsi( "Confirma processamento?" ), OemToAnsi( "Atencao" ) ) )
