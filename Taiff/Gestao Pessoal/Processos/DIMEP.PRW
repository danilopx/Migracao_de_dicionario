#INCLUDE "PROTHEUS.CH"
#INCLUDE "topconn.ch"
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � DIMEP    �       �RICARDO DUARTE COSTA� Data �  22/03/2013 ���
�������������������������������������������������������������������������͹��
���Descricao � Exporta��o das informa��es de funcion�rios para importa��o ���
���          � no Dimep.                                                  ���
�������������������������������������������������������������������������͹��
���Uso       �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function DIMEP()

Local aArea	:= GetArea()
Private cString, cPerg, oGera

cPerg       := "DIMEP     "

CriaSx1(cPerg)

Pergunte(cPerg, .F.)
dbSelectArea("SRA")
dbSetOrder(1)

//���������������������������������������������������������������������Ŀ
//� Montagem da tela de processamento.                                  �
//�����������������������������������������������������������������������

DEFINE DIALOG oGera TITLE OemToAnsi("Dimep Gera��o de Cart�es") FROM 200,1 TO 400,480 PIXEL
//@ 200,1 TO 400,480 DIALOG oGera TITLE OemToAnsi("Dimep Gera��o de Cart�es")
@ 02,10 TO 095,230 PIXEL Of oGera
@ 10,018 Say " Este programa ira gerar um arquivo texto com os funcion�rios a" PIXEL Of oGera
@ 18,018 Say " serem importados para o arquivo de rel�gio.                   " PIXEL Of oGera

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
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Fun��o    � OKGERA   � Autor �RICARDO DUARTE COSTA� Data �  17/06/09   ���
�������������������������������������������������������������������������͹��
���Descri��o � Funcao chamada pelo botao OK na tela inicial de processamen���
���          � to. Executa a geracao do arquivo texto.                    ���
�������������������������������������������������������������������������͹��
���Uso       � Programa principal                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
����������������������������������������������������������������������������� /*/
Static Function OkGera

//���������������������������������������������������������������������Ŀ
//� Variaveis                                                           �
//�����������������������������������������������������������������������
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
	Aviso("Aten��o","Corrija os par�metros, pois existe inconsist�ncia.",{"OK"})
	return
Else
	Processa({|| RunCont() },"Processando...")
Endif

Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Fun��o    � RUNCONT  � Autor �RICARDO DUARTE COSTA� Data �  17/06/09   ���
�������������������������������������������������������������������������͹��
���Descri��o � Funcao auxiliar chamada pela PROCESSA.  A funcao PROCESSA  ���
���          � monta a janela com a regua de processamento.               ���
�������������������������������������������������������������������������͹��
���Uso       � Programa principal                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
����������������������������������������������������������������������������� /*/
Static Function RunCont

Local cDet			:= ""
Local cDirDocs   	:= MsDocPath()
Local cArquivo   	:= "CRACHAS_"+Alltrim(SM0->M0_NOME)
Local nHandle
Local aLog			:= {{}}
Local aTitle		:= {"Funcion�rio sem Pis - N�o gerados"}
Private lCont		:= .F.

//-- Selecionando valores por funcion�rio
MsAguarde( {|| lCont := fMtaSRA()}, "Processando...", "Selecionando funcion�rio a exportar..." )

//Aviso que n�o existem dados para gerar
If !lCont
	Aviso("ATENCAO","Nao funcion�rios no intervalo de par�metros selecionados. Verifique.",{"Sair"})
	Return
Endif

nHandle := MsfCreate(cDirDocs+"\"+cArquivo+".TXT",0)
If nHandle > 0

	//-- Processamento
	While !WSRA->(eof())
		IncProc("Gerando arquivo texto")
		cDet	:= ""
		
		//-- Pis inv�lido n�o ser�o considerados e v�o para o Log de funcion�rios n�o considerados na gera��o
		If Empty(WSRA->RA_PIS)
			Aadd(aLog[1],"Pis n�o cadastrado: "+WSRA->RA_FILIAL+"/"+WSRA->RA_MAT+"/"+WSRA->RA_NOME)
			WSRA->(Dbskip())
			loop
		Endif

		//-- Prepara a matricula antes da grava��o
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
		
		//-- Matr�cula no TXT			//-- 01 a 20 - Matr�cula / Cracha
		cDet	+= cAux
		
		//-- Pis no TXT					//-- 21 a 31 - Pis
		cDet	+= Left(Alltrim(WSRA->RA_PIS)+space(11),11)
		
		//-- Senha do Funcion�rio		//-- 32 a 37 - Senha - fixo 00000
		cDet	+= "000000"
		
		//-- Data de admiss�o			//-- 38 a 45 - Data de admiss�o DDMMYYYY
		cDet	+= right(WSRA->RA_ADMISSA,2)+Substr(WSRA->RA_ADMISSA,5,2)+Left(WSRA->RA_ADMISSA,4)
		
		//-- Nome do funcion�rio		//-- 46 a 97 - Nome do funcion�rio com 52 caracteres no m�ximo
		cDet	+= Left(WSRA->RA_NOME+space(52),52)
		
		//-- Descri��o da Fun��o		//-- 98 a 127 -Descri��o da Fun��o
		cDet	+= Left(WSRA->RJ_DESC+space(30),30)
		
		//-- N�mero da credencial		//--128 a 147 -N�mero da credencial - Fixo 20 espa�os
//		cDet	+= Space(20)			//-- n�O ENVIAR NUMERO DA CREDENCIAL
		
		//-- Final de linha
		cDet	+= CRLF
		//-- Grava a linha do funcion�rio
		fWrite(nHandle,cDet)
		
		//-- Vai para o pr�ximo registro
		WSRA->(DbSkip())
		
	Enddo
	fClose(nHandle)
	If File(cDestino+cArquivo+".TXT")
		fErase(cDestino+cArquivo+".TXT")
	Endif
	CpyS2T( cDirDocs+"\"+cArquivo+".TXT" , cDestino, .T. )
	Ferase(cDirDocs+"\"+cArquivo+".TXT")
	Aviso("Aten��o","O arquivo foi gravado em "+cDestino+cArquivo+".TXT",{"Ok"})
Else
	MsgAlert( "Falha na cria��o do arquivo" )
EndIf

//-- Fecha a query corrente
WSRA->(DbCloseArea())
DbSelectArea("SRA")
oGera:end()

//-- Imprime o Log caso tenha algum funcion�rio n�o gerado
If len(aLog[1]) > 0
	fMakeLog(aLog,aTitle,,.T.,"DIMEP","Log da gera��o do arquivo de importa��o cadastral","M","P",,.F.)
Endif

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �fMtaSRA   �Autor  �RICARDO DUARTE COSTA� Data �  17/06/09   ���
�������������������������������������������������������������������������͹��
���Desc.     �Monta a query de movimento de folha de pagamento.           ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �Programa principal                                          ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
����������������������������������������������������������������������������� */
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
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � FSQLIN   �Autor  � PRIMA INFORMATICA  � Data �  19/06/09   ���
�������������������������������������������������������������������������͹��
���Desc.     � Funcao para Montar a Selecao da Clausula IN do SQL.        ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � MP8                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CriaSX1   � Autor �RICARDO DUARTE COSTA� Data �  17/06/09   ���
�������������������������������������������������������������������������͹��
���Descricao �Objetivo desta funcao e verificar se existe o grupo de      ���
���          �perguntas, se nao existir a funcao ira cria-lo.             ���
�������������������������������������������������������������������������͹��
���Uso       �cPerg -> Nome com  grupo de perguntas em quest�o.           ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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
Aadd(aRegs,{cPerg,"07","Pasta de grava��o?  ","","","mv_ch7","C",60,0,0,"G","NaoVazio()"                ,"MV_PAR07",""       ,"" ,"" ,"","",""     ,"" ,"" ,"","","","","","","","","","","","","","","","","   ","","",""})
Aadd(aRegs,{cPerg,"08","Turno de?    "       ,"","","mv_ch8","C",03,0,0,"G",""                          ,"MV_PAR08",""       ,"" ,"" ,"","",""     ,"" ,"" ,"","","","","","","","","","","","","","","","","SR6","","",""})
Aadd(aRegs,{cPerg,"09","Turno At�?    "      ,"","","mv_ch9","C",03,0,0,"G","NaoVazio()"                ,"MV_PAR09",""       ,"" ,"" ,"","",""     ,"" ,"" ,"","","","","","","","","","","","","","","","","SR6","","",""})

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
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GPECR010  �Autor  �Ricardo Duarte Costa� Data �  06/08/2012 ���
�������������������������������������������������������������������������͹��
���Desc.     � Funcao GPECROK() - Confirmacao da execucao da geracao das  ���
���          �                    parcelas.                               ���
�������������������������������������������������������������������������͹��
���Uso       � Estatica                                                   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������*/
Static Function GPECROk() 
Return ( MsgYesNo( OemToAnsi( "Confirma processamento?" ), OemToAnsi( "Atencao" ) ) )
