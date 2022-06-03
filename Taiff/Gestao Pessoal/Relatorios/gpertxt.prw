#INCLUDE "PROTHEUS.CH"
#INCLUDE "RPTDEF.CH"  
#INCLUDE "FWPrintSetup.ch"
#IFNDEF CRLF
	#DEFINE CRLF ( chr(13)+chr(10) )
#ENDIF

#DEFINE Imp_Spool      	2
#DEFINE ALIGN_H_LEFT   	0
#DEFINE ALIGN_H_RIGHT  	1
#DEFINE ALIGN_H_CENTER 	2
#DEFINE ALIGN_V_CENTER 	0
#DEFINE ALIGN_V_TOP	   	1
#DEFINE ALIGN_V_BOTTON 	2

/*
���������������������������������������������������������������������������������������
���������������������������������������������������������������������������������������
�����������������������������������������������������������������������������������Ŀ��
���Fun��o    � GPER030  � Autor � R.H. - Ze Maria       � Data � 14.03.95 	        ���
�����������������������������������������������������������������������������������Ĵ��
���Descri��o � Emissao de Recibos de Pagamento                                      ���
�����������������������������������������������������������������������������������Ĵ��
���Sintaxe   � GPER030(void)                                             	        ���
�����������������������������������������������������������������������������������Ĵ��
��� Uso      � Generico                                               		   		���
�����������������������������������������������������������������������������������Ĵ��
���         ATUALIZACOES SOFRIDAS DESDE A CONSTRU�AO INICIAL                        ���
�����������������������������������������������������������������������������������Ĵ��
���Programador � Data   � Chd./Requisito �  Motivo da Alteracao                     ���
�����������������������������������������������������������������������������������Ĵ��
���Ademar Jr.  �22/03/13�Requisito:      �-Unificacao dos fontes da fase padrao com ���
���            �        �RHU210_09_13    � a fase 4 (localizacoes).                 ���
���Sidney O.   �02/04/14�M_RH007   TPDCQD�Alteracao da funcao f030Roteiro - nao     ���
���            �        �                �exibe mais os roteiros G e J (INC e MUV)  ���
���Raquel Hager�02/09/14�TQM075			 �Utilizacao de tabela S036 para Mensagens. ���
���Renan Borges�09/10/14�TQNUVG          �Ajuste para imprimir log de ocorr�ncias   ���
���			   � 		�                �corretamente e sem gerar um relat�rio va- ���
���			   � 		�                �zio ap�s a impress�o do log de ocorr�ncias���
���Wag Mobile  �31/10/14�TQTXLQ          �Ajuste para imprimir verificando filtro da���
���			   � 		�                �aba de filtro corretamente.               ���
���Allyson M   �19/02/15�TRMMMT          �Ajuste na validacao da data de aniversario���
���			   � 		�                �no recibo enviado por email.	 			���
���Mariana M   �08/04/15�TRVPPK        	 �Ajuste no relatorio Zebrado para que no   ���
���			   � 		�                �mes do aniversario do funcionario,apresen-���
���			   � 		�                �tando a mensagem "Feliz Aniversario"		���
���	Emerson Ca�09/07/15� PCREQ-4461      �Criar a op��o de envio de PDF por email   ���
���	          �        �                 �Changset 294739                           ���
���Renan Borges�03/12/15�TTTLGI          �Ajuste para enviar recibo de pagamento no ���
���			   � 		�                �formato pdf por e-mail.                   ���
���C�cero Alves�17/12/15�TUABIP          �Ajuste para imprimir bases no recibo da 1����
���			   � 		�                �parcela do 13� em PDF				        ���
���Victor A.   �03/05/16�TUOBR0          �Ajuste na impress�o direto na LPT1.       ���
���P. Pompeu...|30/06/16|TVNITS          |Quebra por Func. e � Exibir Bases no Zebr.|��
������������������������������������������������������������������������������������ٱ�
���������������������������������������������������������������������������������������
���������������������������������������������������������������������������������������
*/
User Function GPERTXT(lTerminal,cFilTerminal,cMatTerminal,cProcTerminal,nRecTipo,cPerTerminal,cSemanaTerminal)

//��������������������������������������������������������������Ŀ
//� Define Variaveis Locais (Basicas)                            �
//����������������������������������������������������������������
Local cString:="SRA"        // alias do arquivo principal (Base)

//��������������������������������������������������������������Ŀ
//� Define Variaveis Locais (Programa)                           �
//����������������������������������������������������������������
Local cRotBlank := Space(GetSx3Cache( "RCH_ROTEIR", "X3_TAMANHO" ))
Local cHtml 	:= ""

Private cMes	  := ""
Private cAno    := ""
Private aEmail  := {}

//��������������������������������������������������������������Ŀ
//� Define Variaveis Private(Basicas)                            �
//����������������������������������������������������������������
Private nomeprog :="GPER030"
Private aLinha   := { }
Private nLastKey := 0
Private cPerg    :="GPER030"
Private cSem_De  := "  /  /    "
Private cSem_Ate := "  /  /    "
Private nAteLim , nBaseFgts , nFgts , nBaseIr , nBaseIrFe , nTipRel

//��������������������������������������������������������������Ŀ
//� Define Variaveis Private(Programa)                           �
//����������������������������������������������������������������
Private aLanca 			:= {}
Private aProve 			:= {}
Private aDesco 			:= {}
Private aBases 			:= {}
Private aInfo  			:= {}
Private aCodFol			:= {}
Private li     			:= _PROW()
Private Titulo 			:= "GERACAO DE RECIBOS DE PAGAMENTOS EM TXT"	
Private lEnvioOk 		:= .F.
Private lRetCanc		:= .t.
Private cIRefSem    	:= GetMv("MV_IREFSEM",,"S")
Private aPerAberto		:= {}
Private aPerFechado		:= {}
Private cProcesso		:= "" // Armazena o processo selecionado na Pergunte GPR040 (mv_par01).
Private cRoteiro		:= "" // Armazena o Roteiro selecionado na Pergunte GPR040 (mv_par02).
Private cPeriodo		:= "" // Armazena o Periodo selecionado na Pergunte GPR040 (mv_par03).
Private cCcto			:= ""
Private cCond			:= ""
Private cRot			:= ""
Private lDepSf			:= Iif(SRA->(FieldPos("RA_DEPSF"))>0,.T.,.F.)
Private lLpt1			:= .F.
Private lFase4  		:= (cPaisLoc $ "ANG|ARG|COL|PTG|VEN")

//��������������������������������������������������������������Ŀ
//� Define Variaveis da Impressao Grafica                        �
//����������������������������������������������������������������
Private oPrint   
Private oArial08		:= TFont():New("Arial",08,08,,.F.,,,,.T.,.F.)//Normal
Private oArial08N		:= TFont():New("Arial",08,08,,.T.,,,,.T.,.F.)//Negrito
Private oArial10		:= TFont():New("Arial",10,10,,.F.,,,,.T.,.F.)//Normal
Private oArial10N		:= TFont():New("Arial",10,10,,.T.,,,,.T.,.F.)//Negriot
Private oPrinter		:= ""
Private oFont1 			:=	TFont():New( "Verdana", 07, 07, , .F., , , , .T., .F. )//Verbas
Private oFont2 			:=	TFont():New( "Verdana", 09, 09, , .F., , , , .T., .F. )//Cabe�alho e Rodap�
Private oFont2N 		:= 	TFont():New( "Verdana", 09, 09, , .T., , , , .T., .F. )//Cabe�alho e Rodap� Negrito
Private oFont3 			:=	TFont():New( "Verdana", 12, 12, , .T., , , , .T., .F. )//Titulo Interno
Private oFont4 			:=	TFont():New( "Verdana", 14, 14, , .T., , , , .T., .F. )//Titulo Maior
Private Semana
Private cSemana
Private lPDFEmail		:= .T. //PDF � por Email quando for .F. Visualizar o PDF no remote

  
//��������������������������������������������������������������Ŀ
//� Envia controle para a funcao SETPRINT                        �
//����������������������������������������������������������������
wnrel:="GPER030"            //Nome Default do relatorio em Disco

//��������������������������������������������������������������Ŀ
//� Verifica se o programa foi chamado do terminal - TCF         �
//����������������������������������������������������������������
lTerminal := .F.

//��������������������������������������������������������������Ŀ
//� Define a Ordem do Relatorio                                  �
//����������������������������������������������������������������
nOrdem := 1

//��������������������������������������������������������������Ŀ
//� Verifica as perguntas selecionadas                           �
//����������������������������������������������������������������
If !Pergunte(cPerg, .T.)
	Return
EndIf

//��������������������������������������������������������������Ŀ
//� Carregando variaveis mv_par?? para Variaveis do Sistema.     �
//����������������������������������������������������������������
cSemanaTerminal := IF( Empty( cSemanaTerminal ) , Space( Len( SRC->RC_SEMANA ) ) , cSemanaTerminal )
cProcesso  := IF( !( lTerminal ), mv_par01 , cProcTerminal		)   //Processo
cRoteiro   := IF( !( lTerminal ), mv_par02 , nRecTipo			)	//Emitir Recibos(Roteiro)
cPeriodo   := IF( !( lTerminal ), mv_par03 , cPerTerminal		)   //Periodo
Semana     := IF( !( lTerminal ), mv_par04 , cSemanaTerminal	)	//Numero da Semana
cSemana    := Semana

//��������������������������������������������������������������Ŀ
//� Verificar se o sistema esta trabalhando com ou sem roteiro   �
//����������������������������������������������������������������
DbSelectArea( "RCH" )
DbSetOrder( 4 )
DbSeek(  xFilial( "RCH" ) + cProcesso + cRoteiro + cPeriodo + Semana, .F. )
If Eof()
	DbSeek(  xFilial( "RCH" ) + cProcesso + cRotBlank + cPeriodo + Semana, .F. )
Else
	cRotBlank := cRoteiro
EndIf

//Carregar os periodos abertos (aPerAberto) e/ou 
// os periodos fechados (aPerFechado), dependendo 
// do periodo (ou intervalo de periodos) selecionado
RetPerAbertFech(cProcesso	,; // Processo selecionado na Pergunte.
				cRotBlank	,; // Roteiro selecionado na Pergunte.
				cPeriodo	,; // Periodo selecionado na Pergunte.
				Semana		,; // Numero de Pagamento selecionado na Pergunte.
				NIL			,; // Periodo Ate - Passar "NIL", pois neste relatorio eh escolhido apenas um periodo.
				NIL			,; // Numero de Pagamento Ate - Passar "NIL", pois neste relatorio eh escolhido apenas um numero de pagamento.
				@aPerAberto	,; // Retorna array com os Periodos e NrPagtos Abertos
				@aPerFechado ) // Retorna array com os Periodos e NrPagtos Fechados
				
// Retorna o mes e o ano do periodo selecionado na pergunte.
AnoMesPer(	cProcesso	,; // Processo selecionado na Pergunte.
			cRotBlank	,; // Roteiro selecionado na Pergunte.
			cPeriodo	,; // Periodo selecionado na Pergunte.
			@cMes		,; // Retorna o Mes do Processo + Roteiro + Periodo selecionado
			@cAno		,; // Retorna o Ano do Processo + Roteiro + Periodo selecionado     
			Semana		 ) // Retorna a Semana do Processo + Roteiro + Periodo selecionado
			
dDataRef   := CTOD("01/" + cMes + "/" + cAno)

nTipRel    := 1	//IF( !( lTerminal ), mv_par05 , 3				)	//Tipo de Recibo (Pre-Impress�o/Zebrado/EMail/PDF)
cFilDe     := IF( !( lTerminal ), mv_par06,cFilTerminal		)	//Filial De
cFilAte    := IF( !( lTerminal ), mv_par07,cFilTerminal		)	//Filial Ate
cCcDe      := IF( !( lTerminal ), mv_par08,SRA->RA_CC		)	//Centro de Custo De
cCcAte     := IF( !( lTerminal ), mv_par09,SRA->RA_CC		)	//Centro de Custo Ate
cMatDe     := IF( !( lTerminal ), mv_par10,cMatTerminal		)	//Matricula Des
cMatAte    := IF( !( lTerminal ), mv_par11,cMatTerminal		)	//Matricula Ate
cNomDe     := IF( !( lTerminal ), mv_par12,SRA->RA_NOME		)	//Nome De
cNomAte    := IF( !( lTerminal ), mv_par13,SRA->RA_NOME		)	//Nome Ate
ChapaDe    := IF( !( lTerminal ), mv_par14,SRA->RA_CHAPA	)	//Chapa De
ChapaAte   := IF( !( lTerminal ), mv_par15,SRA->RA_CHAPA	)	//Chapa Ate
Mensag1    := mv_par16										 	//Mensagem 1
Mensag2    := mv_par17											//Mensagem 2
Mensag3    := mv_par18											//Mensagem 3
cSituacao  := IF( !( lTerminal ),mv_par19, fSituacao( NIL , .F. ) )	//Situacoes a Imprimir
cCategoria := IF( !( lTerminal ),mv_par20, fCategoria( NIL , .F. ))	//Categorias a Imprimir
cBaseAux   := IF( !( lTerminal ),If(mv_par21 == 1,"S","N"),"S")	//Imprimir Bases
cDeptoDe   := IF( !( lTerminal ),mv_par22,SRA->RA_DEPTO 	)	//Depto. De
cDeptoAte  := IF( !( lTerminal ),mv_par23,SRA->RA_DEPTO 	)	//Depto. Ate
lQuebraFun := IIF( !( lTerminal ) .And. !Empty(MV_PAR24),(MV_PAR24 == 1),.F.) //Quebra por Funcion�rio?

cMesAnoRef := StrZero(Month(dDataRef),2) + StrZero(Year(dDataRef),4)
nPosPer    := Ascan(aPerAberto,{|X| X[1] == cPeriodo} )
If nPosPer == 0
	nPosPer    := Ascan(aPerFechado,{|X| X[1] == cPeriodo} )
	dDataPagto := aPerFechado[nPosPer,7] 
Else
	dDataPagto := aPerAberto[nPosPer,7] 
Endif

Processa({|lEnd| R030Imp(@lEnd,wnRel,cString,cMesAnoRef,.f.)},Titulo)  // Chamada do Relatorio

Return( IF( lTerminal , cHtml , NIL ) )

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � R030IMP  � Autor � R.H. - Ze Maria       � Data � 14.03.95 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Processamento Para emissao do Recibo                       ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � R030Imp(lEnd,WnRel,cString,cMesAnoRef,lTerminal)			  ���
�������������������������������������������������������������������������Ĵ��
���Parametros�                                                            ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Generico                                                   ���
�������������������������������������������������������������������������Ĵ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function R030Imp(lEnd,WnRel,cString,cMesAnoRef,lTerminal)
//��������������������������������������������������������������Ŀ
//� Define Variaveis Locais (Basicas)                            �
//����������������������������������������������������������������
Local aTInss	  		:= {}
Local cAcessaSR1  	:= &("{ || " + ChkRH("GPER030","SR1","2") + "}")
Local cAcessaSRA  	:= &("{ || " + ChkRH("GPER030","SRA","2") + "}")
Local cAcessaSRC  	:= &("{ || " + ChkRH("GPER030","SRC","2") + "}")
Local cAcessaSRD  	:= &("{ || " + ChkRH("GPER030","SRD","2") + "}")
Local cNroHoras   	:= &("{ || If(aVerbasFunc[nReg,5] > 0 .And. cIRefSem == 'S', aVerbasFunc[nReg,5], aVerbasFunc[nReg,6]) }")
Local cHtml		  	:= ""
Local nHoras      	:= 0
Local nCont			:= 0
Local nReg		  	:= 0
Local cInicio	  	:= ""
Local nBInssPA	  	:= 0 //Teto da base de INSS dos pro-labores/autonomos

Local nTcfDadt		:= if(lTerminal,getmv("MV_TCFDADT",,0),0)		// indica o dia a partir do qual esta liberada a consulta ao TCF 
Local nTcfDfol		:= if(lTerminal,getmv("MV_TCFDFOL",,0),0)		// indica a quantidade de dias a somar ou diminuir no ultimo dia do mes corrente para liberar a consulta do TCF
Local nTcfD131		:= if(lTerminal,getmv("MV_TCFD131",,0),0)		// indica o dia a partir do qual esta liberada a consulta ao TCF
Local nTcfD132		:= if(lTerminal,getmv("MV_TCFD132",,0),0)		// indica o dia a partir do qual esta liberada a consulta ao TCF
Local nTcfDext		:= if(lTerminal,getmv("MV_TCFDEXT",,0),0)		// indica o dia a partir do qual esta liberada a consulta ao TCF
Local nDec
Local nPosMsg1		:= 0
Local nPosMsg2		:= 0
Local nPosMsg3		:= 0

Local cDirTXT := Alltrim(GetMv("MV_DIRFOL"))
Local cArqTxt := Alltrim(GetMv("MV_ARQFOL"))
Local cAno:=Left(MesAno(ddatabase),4)
Local cMes:=Subst(MesAno(ddatabase),5,2)

cArqTxt+=cMes+cAno+".TXT"

Private tamanho   	:= "M"
Private limite		:= 132
Private cDtPago   	:= ""
Private cTipoRot 		:= PosAlias("SRY", cRoteiro, SRA->RA_FILIAL, "RY_TIPO")
Private aVerbasFunc 	:= {}
Private cRotBlank
Private nHraExtra 	:= 0
Private nPagoDom		:= 0

Private cPict1		:= "@E 999,999,999.99"
Private cPict2 		:= "@E 99,999,999.99"
Private cPict3 		:= "@E 999,999.99"

Private nSalario		:= 0

//-Ordem 1 -> RCA_FILIAL+RCA_MNEMON
If FPOSREG("RCA", 1, XFILIAL("RCA")+"RHDECIMAIS")
	nDec := Val(Alltrim(RCA->RCA_CONTEU))
Else
	nDec := MsDecimais(1)
EndIf

If nDec = 0
	cPict1	:=	"@E 99,999,999,999"
	cPict2 	:=	"@E 9,999,999,999"
	cPict3 	:=	"@E 99,999,999"
Endif

// Ajuste do tipo da variavel
nTcfDadt	:= if(valtype(ntcfdadt)=="C",val(ntcfdadt),ntcfdadt)
nTcfD131	:= if(valtype(nTcfD131)=="C",val(nTcfD131),nTcfD131)
nTcfD132	:= if(valtype(nTcfD132)=="C",val(nTcfD132),nTcfD132)
nTcfDfol	:= if(valtype(ntcfdfol)=="C",val(ntcfdfol),ntcfdfol)
nTcfDext	:= if(valtype(ntcfdext)=="C",val(ntcfdext),ntcfdext)

//��������������������������������������������������������������Ŀ
//� Selecionando a Ordem de impressao escolhida no parametro.    �
//����������������������������������������������������������������
dbSelectArea( "SRA")
dbSetOrder(8)
dbGoTop()
	
//��������������������������������������������������������������Ŀ
//� Selecionando o Primeiro Registro e montando Filtro.          �
//����������������������������������������������������������������
dbSeek(cFilDe + cCcDe + cNomDe,.T.)
cInicio  := "SRA->RA_FILIAL + SRA->RA_CC + SRA->RA_NOME"
cFim     := cFilAte + cCcAte + cNomAte

dbSelectArea("SRA")
//��������������������������������������������������������������Ŀ
//� Carrega Regua Processamento                                  �
//����������������������������������������������������������������
#IFDEF TOP                  
	cAliasTMP := "QNRO"
	BeginSql alias cAliasTMP
		SELECT COUNT(*) as NROREG
		FROM %table:SRA% SRA
		WHERE      SRA.RA_FILIAL BETWEEN %exp:cFilDe%   AND %exp:cFilAte% 
			   AND SRA.RA_MAT    BETWEEN %exp:cMatDe%   AND %exp:cMatAte%
			   AND SRA.RA_CC     BETWEEN %exp:cCCDe%    AND %exp:cCCAte% 
			   AND SRA.RA_DEPTO  BETWEEN %exp:cDeptoDe% AND %exp:cDeptoAte% 
			   AND SRA.%notDel%
	EndSql

	nRegProc := (cAliasTMP)->(NROREG)
	( cAliasTMP )->( dbCloseArea() )	
	IF nTipRel # 3
		ProcRegua(nRegProc)	// Total de elementos da regua
	Else
		IF !( lTerminal )
			ProcRegua(nRegProc)// Total de elementos da regua
		EndIF
	EndIF
	
	dbSelectArea("SRA")
	
#ELSE
	IF nTipRel # 3
		ProcRegua(RecCount())	// Total de elementos da regua
	Else
		IF !( lTerminal )
			ProcRegua(RecCount())// Total de elementos da regua
		EndIF
	EndIF
	
	dbSelectArea("SRA")
	
#ENDIF 

TOTVENC:= TOTDESC:= FLAG:= CHAVE := 0

Desc_Fil := Desc_End := DESC_CC:= DESC_FUNC:= ""
Desc_Comp:= Desc_Est := Desc_Cid:= ""
DESC_MSG1:= DESC_MSG2:= DESC_MSG3:= Space(01)
cFilialAnt := Space(FwGetTamFilial)
Vez        := 0
OrdemZ     := 0

If File(cDirTxt+cArqTxt)
   Ferase(cDirTxt+cArqTxt)
Endif
   
nHdl     := fCreate(cDirTxt+cArqTxt)                  

If nHdl <0
   MsgStop("NAO FOI POSSIVEL CRIAR O ARQUIVO (TXT)","Aten��o")
   Return 
Endif

lGerouTXT:=.f.

While SRA->( !Eof() .And. &cInicio <= cFim )

	//��������������������������������������������������������������Ŀ
	//� Movimenta Regua Processamento                                �
	//����������������������������������������������������������������
	IF !( lTerminal )

		IF nTipRel # 3
			IncProc()  // Anda a regua
		ElseIF !( lTerminal )
			IncProc(SRA->RA_FILIAL+" - "+SRA->RA_MAT+" - "+SRA->RA_NOME)
		EndIF

		If lEnd
			Exit
		Endif

		//��������������������������������������������������������������Ŀ
		//� Consiste Parametrizacao do Intervalo de Impressao            �
		//����������������������������������������������������������������
		If (SRA->RA_CHAPA < ChapaDe)   .Or. (SRA->RA_CHAPa > ChapaAte) .Or. ;
			(FtAcento( SRA->RA_NOME )   < cNomDe) .Or. (FtAcento( SRA->RA_NOME ) > cNomAte)   .Or. ;
			(SRA->RA_MAT < cMatDe)     .Or. (SRA->RA_MAT > cMatAte)    .Or. ;
			(SRA->RA_CC < cCcDe)       .Or. (SRA->RA_CC > cCcAte)      .Or. ;
			(SRA->RA_DEPTO < cDeptoDe) .Or. (SRA->RA_DEPTO > cDeptoAte)

			SRA->(dbSkip(1))
			Loop
		EndIf

	EndIF

	aLanca:={}         // Zera Lancamentos
	aProve:={}         // Zera Lancamentos
	aDesco:={}         // Zera Lancamentos
	aBases:={}         // Zera Lancamentos
	nAteLim := nBaseFgts := nFgts := nBaseIr := nBaseIrFe := 0.00
	
	Ordem_rel := 1     // Ordem dos Recibos
	
	//��������������������������������Ŀ
	//� Verifica Data Demissao         �
	//����������������������������������
	cSitFunc := SRA->RA_SITFOLH
	dDtPesqAf:= CTOD("01/" + Left(cMesAnoRef,2) + "/" + Right(cMesAnoRef,4),"DDMMYY")
	If cSitFunc == "D" .And. (!Empty(SRA->RA_DEMISSA) .And. MesAno(SRA->RA_DEMISSA) > MesAno(dDtPesqAf))
		cSitFunc := " "
	Endif
	
	//-Busca o Salario Base do Funcionario
	nSalario := fBuscaSal(dDataRef,,,.F.)
	If nSalario == 0
		nSalario := SRA->RA_SALARIO
	EndIf
	
	IF !( lTerminal )
		
		//��������������������������������������������������������������Ŀ
		//� Consiste situacao e categoria dos funcionarios			     |
		//����������������������������������������������������������������
		If !( cSitFunc $ cSituacao ) .OR.  ! ( SRA->RA_CATFUNC $ cCategoria )
			SRA->(dbSkip())
			Loop
		Endif
		If cSitFunc $ "D" .And. Mesano(SRA->RA_DEMISSA) # Mesano(dDataRef)
			SRA->(dbSkip())
			Loop
		Endif
		
		//��������������������������������������������������������������Ŀ
		//� Consiste controle de acessos e filiais validas				 |
		//����������������������������������������������������������������
		If !(SRA->RA_FILIAL $ fValidFil()) .Or. !Eval(cAcessaSRA)
			SRA->(dbSkip())
			Loop
		EndIf
		
	EndIF
	
	If SRA->RA_Filial # cFilialAnt
		If ! Fp_CodFol(@aCodFol,Sra->Ra_Filial) .Or. ! fInfo(@aInfo,Sra->Ra_Filial)
			Return Nil
		Endif      
		Desc_Fil := If( lLpt1, fTAcento(aInfo[3]), aInfo[3] )
		Desc_End := If( lLpt1, fTAcento(aInfo[4]), aInfo[4] )	// Dados da Filial
		Desc_CGC := aInfo[8]
		DESC_MSG1:= DESC_MSG2:= DESC_MSG3:= Space(01)
		Desc_Est := Substr(fDesc("SX5","12"+If( lLpt1, fTAcento(aInfo[6]), aInfo[6] ),"X5DESCRI()"),1,12)
		Desc_Comp:= If( lLpt1, fTAcento(aInfo[14]), aInfo[14] )	// Complemento Cobranca
		Desc_Cid := If( lLpt1, fTAcento(aInfo[5]), aInfo[5] )
		End_Compl:= aInfo[4] + " " + aInfo[13] + " " + aInfo[05] + " " +;
					aInfo[06] + " " + aInfo[07]//endere�o + bairro + cidade + estado + cep
		Desc_EndC:= If( lLpt1, fTAcento( End_Compl ), End_Compl )
		// MENSAGENS
		If !Empty(MENSAG1)        
		
			nPosMsg1		:= fPosTab("S036",Alltrim(MENSAG1), "==", 4)
			If nPosMsg1 > 0 
				DESC_MSG1	:= fTabela("S036",nPosMsg1,5)
			EndIf
		Endif   
		
		nPosMsg2		:= fPosTab("S036",Alltrim(MENSAG2), "==", 4)
		If nPosMsg2 > 0 
			DESC_MSG2	:= fTabela("S036",nPosMsg2,5)
		EndIf  
		
		nPosMsg3		:= fPosTab("S036",Alltrim(MENSAG3), "==", 4)
		If nPosMsg3 > 0 
			DESC_MSG3	:= fTabela("S036",nPosMsg3,5)
		EndIf
		
		dbSelectArea("SRA")
		cFilialAnt := SRA->RA_FILIAL
	Endif
	
	Totvenc := Totdesc := 0
	            
	//Carrega tabela de INSS para utilizacao nos pro-labores/autonomos
	If !cPaisLoc $ "CHI|PAR" .AND. !lFase4
		Car_inss(@aTInss,MesAno(dDataRef))
	EndIf
	
	If Len(aTinss) > 0
		nBInssPA := aTinss[Len(aTinss),1]
	EndIf
	
	//Retorna as verbas do funcionario, de acordo com os periodos selecionados
	aVerbasFunc	:= RetornaVerbasFunc(	SRA->RA_FILIAL					,; // Filial do funcionario corrente
										SRA->RA_MAT	  					,; // Matricula do funcionario corrente
										NIL								,; // 
										cRoteiro	  					,; // Roteiro selecionado na pergunte
										NIL			  					,; // Array com as verbas que dever�o ser listadas. Se NIL retorna todas as verbas.
										aPerAberto	  					,; // Array com os Periodos e Numero de pagamento abertos
										aPerFechado	 	 				 ) // Array com os Periodos e Numero de pagamento fechados

	If cRoteiro <> "EXT"
		For nReg := 1 to Len(aVerbasFunc)
			If (Len(aPerAberto) > 0 .AND. !Eval(cAcessaSRC)) .OR. (Len(aPerFechado) > 0 .AND. !Eval(cAcessaSRD)) .Or.;
			   ( aVerbasFunc[nReg,7] <= 0 )
				dbSkip()
				Loop
			EndIf
			
			If cPaisLoc $ "ANG*PER" .AND. cBaseAux = "N"
				if PosSrv( aVerbasFunc[nReg,3] , SRA->RA_FILIAL , "RV_TIPOCOD" ) $ "34"
					dbSkip()
		   			Loop
				Endif
			Endif
			
			If PosSrv( aVerbasFunc[nReg,3] , SRA->RA_FILIAL , "RV_TIPOCOD" ) == "1"
				If cPaisLoc == "PAR" .and. Eval(cNroHoras) = 30
					LocGHabRea(Ctod("01/"+SubStr(DTOC(dDataRef),4)), Ctod(StrZero(F_ULTDIA(dDataRef),2)+"/"+Strzero(Month(dDataRef),2)+"/"+right(str(Year(dDataRef)),2),"ddmmyy"),@nHoras)
				Else
					nHoras := aVerbasFunc[nReg,6]	//-Eval(cNroHoras)
				Endif
				fSomaPdRec("P",aVerbasFunc[nReg,3],nHoras,aVerbasFunc[nReg,7])
				TOTVENC += aVerbasFunc[nReg,7]
				
				If cPaisLoc == "BOL"       //soma Horas Extras para localizacao Bolivia
					If PosSrv(aVerbasFunc[nReg,3], SRA->RA_FILIAL, "RV_HE") == "S"
						nHraExtra:= nHraExtra + aVerbasFunc[nReg,6]
					Endif                                          
					//Soma a verba de Horas Trabalhadas no Domingo id 0779
					
					If (aVerbasFunc[nReg,3] == aCodFol[779,1])  
						nPagoDom:= nPagoDom + aVerbasFunc[nReg,6]
					Endif                                        
				Endif 
				
			Elseif SRV->RV_TIPOCOD == "2"
				fSomaPdRec("D",aVerbasFunc[nReg,3],aVerbasFunc[nReg,6],aVerbasFunc[nReg,7])
				TOTDESC += aVerbasFunc[nReg,7]
			Elseif SRV->RV_TIPOCOD $ "3/4"
				//No Paraguai imprimir somente o valor liquido
				If cPaisLoc <> "PAR" .Or. (aVerbasFunc[nReg,3] == aCodFol[047,1])
					fSomaPdRec("B",aVerbasFunc[nReg,3],aVerbasFunc[nReg,6],aVerbasFunc[nReg,7])
				Endif
			Endif
		
			If (aVerbasFunc[nReg,3] $ aCodFol[10,1]+'*'+aCodFol[15,1]+'*'+aCodFol[27,1])
				nBaseIr += aVerbasFunc[nReg,7]
			ElseIf (aVerbasFunc[nReg,3] $ aCodFol[13,1]+'*'+aCodFol[19,1])
				nAteLim += aVerbasFunc[nReg,7]
			Elseif (aVerbasFunc[nReg,3] $ aCodFol[108,1]+'*'+aCodFol[17,1])
				nBaseFgts += aVerbasFunc[nReg,7]
			Elseif (aVerbasFunc[nReg,3] $ aCodFol[109,1]+'*'+aCodFol[18,1])
				nFgts += aVerbasFunc[nReg,7]
			Elseif (aVerbasFunc[nReg,3] == aCodFol[16,1])
				nBaseIrFe += aVerbasFunc[nReg,7]
			Endif
		Next nReg

	Elseif cRoteiro == "EXT"
		dbSelectArea("SR1")
		dbSetOrder(1)
		If dbSeek( SRA->RA_FILIAL + SRA->RA_MAT )
			While !Eof() .And. SRA->RA_FILIAL + SRA->RA_MAT ==	SR1->R1_FILIAL + SR1->R1_MAT
				If Semana # "99"
					If SR1->R1_SEMANA # Semana
						dbSkip()
						Loop
					Endif
				Endif
				If !Eval(cAcessaSR1)
					dbSkip()
					Loop
				EndIf
				If PosSrv( SR1->R1_PD , SRA->RA_FILIAL , "RV_TIPOCOD" ) == "1"
					fSomaPdRec("P",SR1->R1_PD,SR1->R1_HORAS,SR1->R1_VALOR)
					TOTVENC = TOTVENC + SR1->R1_VALOR  
				Elseif SRV->RV_TIPOCOD == "2"
					fSomaPdRec("D",SR1->R1_PD,SR1->R1_HORAS,SR1->R1_VALOR)
					TOTDESC = TOTDESC + SR1->R1_VALOR
				Elseif SRV->RV_TIPOCOD $ "3/4"
					fSomaPdRec("B",SR1->R1_PD,SR1->R1_HORAS,SR1->R1_VALOR)
				Endif
				dbskip()
			Enddo
		Endif
	Endif             
	     
	dbSelectArea("SRA")
	
	If TOTVENC = 0 .And. TOTDESC = 0
		dbSkip()
		Loop
	Endif
	             
	lGerouTXT:=.t.
	
    // Tipo Reg 1
    GeraTXT("1")

    // Tipo Reg 2  PROVENTOS
    For nCont:=1 to Len(aProve)
        aLinha:={aProve[nCont,1],aProve[nCont,2],aProve[nCont,3]}
        GeraTXT("2",aLinha)
    Next nCont

    // Tipo Reg 2  DESCONTOS
    For nCont:=1 to Len(aDesco)
        aLinha:={aDesco[nCont,1],aDesco[nCont,2],aDesco[nCont,3]}
        GeraTXT("2A",aLinha)
    Next nCont                    

    // Tipo Reg 3  - TOTAIS DE VENCIMENTOS, DESCONTOS E LIQUIDOS
    aLinha:={LEFT(SRA->RA_BCDEPSA,3),SUBST(SRA->RA_BCDEPSA,4,5),SRA->RA_CTDEPSA,TOTVENC,TOTDESC,TOTVENC-TOTDESC}
    GeraTXT("3",aLinha)

    // Tipo Reg 4  - BASES
    For nCont:=1 to Len(aBases)
        If !(Left(aBases[nCont,1],3) $ "701,702,703,704,705,706,708,709,710,712,714,720,791,792,811")
           Loop
        Endif
		aLinha:={aBases[nCont,1],aBases[nCont,2],aBases[nCont,3]}
        GeraTXT("4",aLinha)		
    Next nCont       

    // Tipo Reg 5 - DATA PAGTO E MENSAGENS
    GeraTXT("5")
    
	ASize(AProve,0)
	ASize(ADesco,0)
	ASize(aBases,0)

	dbSelectArea("SRA")
	SRA->( dbSkip() )
	TOTDESC := TOTVENC := 0

EndDo

IF !( lTerminal ).And.cPaisLoc<>"PTG" 
	
	//��������������������������������������������������������������Ŀ
	//� Termino do relatorio                                         �
	//����������������������������������������������������������������
	dbSelectArea("SRC")
	dbSetOrder(1)          // Retorno a ordem 1
	dbSelectArea("SRD")
	dbSetOrder(1)          // Retorno a ordem 1
	dbSelectArea("SRA")
	SET FILTER TO
	RetIndex("SRA")
	
	If !(Type("cArqNtx") == "U")
		fErase(cArqNtx + OrdBagExt())
	Endif
	
EndIF

fClose(nHdl)

If lGerouTXT
   MsgInfo("ARQUIVO "+cArqTXT+" GERADO NA PASTA "+cDirTxt,"Recibo TXT")
Endif

Return

Return( cHtml )

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �fSomaPdRec� Autor � R.H. - Mauro          � Data � 24.09.95 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Somar as Verbas no Array                                   ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � fSomaPdRec(Tipo,Verba,Horas,Valor)                         ���
�������������������������������������������������������������������������Ĵ��
���Parametros�                                                            ���
�������������������������������������������������������������������������Ĵ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function fSomaPdRec(cTipo,cPd,nHoras,nValor)

Local Desc_paga

Static lAglutPd // Sera utilizada em todas as chamadas da funcao fSomaPdRec()

If lAglutPd == Nil
	 lAglutPd := ( GetMv("MV_AGLUTPD",,"1") == "1" ) // 1-Aglutina verbas   2-Nao Aglutina
EndIf

Desc_paga := DescPd(cPd,Sra->Ra_Filial)  // mostra como pagto

If cTipo # 'B'
	//--Array para Recibo Pre-Impresso
	nPos := Ascan(aLanca,{ |X| X[2] = cPd })
	If nPos == 0 .Or. !lAglutPd
		Aadd(aLanca,{cTipo,cPd,Desc_Paga,nHoras,nValor})
	Else
		aLanca[nPos,4] += nHoras
		aLanca[nPos,5] += nValor
	Endif
Endif

//--Array para o Recibo Pre-Impresso
If cTipo = 'P'
	cArray := "aProve"
Elseif cTipo = 'D'
	cArray := "aDesco"
Elseif cTipo = 'B'
	cArray := "aBases"
Endif

nPos := Ascan(&cArray,{ |X| X[1] = cPd })
If nPos == 0 .Or. !lAglutPd
	Aadd(&cArray,{cPd+" "+Desc_Paga,nHoras,nValor })
Else
	&cArray[nPos,2] += nHoras
	&cArray[nPos,3] += nValor
Endif

Return







Static Function GeraTXT(cTipoReg,aLinha)

Local cLin:=""
Local cEmpresa,cCNPJ
Local cData,cAno,cMes,cMesAno,cRegFunc,cArea

Local cCodFunc	:= ""		//-- codigo da Funcao do funcionario 
Local cDescFunc	:= ""		//-- Descricao da Funcao do Funcionario 
Local nValSal   := 0
Local cPict     := "@E 9,999,999.99"
/*
1012006EMPRESA                                 99.999.999/0009-99000001NOMEFUNCIONARIO                         AREA                          FUNCAO                        11/11/20069.999.999,990101                                                     
2777777 40,00ADIANTAMENTO (VALE)                           9.999,99                                                                                                                                                                                       
2666666  7,65I.N.S.S.                                         53,83                                                                                                                                                                                       
2555555  0,00VALE                                            100,00                                                                                                                                                                                       
2444444  1,00FALTAS (DIAS)                                    25,46                                                                                                                                                                                       
2333333 10,00FALTAS E ATRASOS (T/H)                           34,72                                                                                                                                                                                       
2000000  0,00DESCONTOS                                        15,00                                                                                                                                                                                       
2111111  1,00SEGURO DE VIDA                                    5,00                                                                                                                                                                                       
*/

Do Case
   Case cTipoReg == "1"
		/*
		1012006EMPRESA                                 99.999.999/0009-99000001NOMEFUNCIONARIO                         AREA                          FUNCAO                        11/11/20069.999.999,990101                                                     
        */
        
        cData:=dtos(dDataPagto)
        cAno :=subst(cData,1,4)
        cMes :=subst(cData,5,2)
        cDia :=subst(cData,7,2)

        cData:=cDia+'/'+cMes+'/'+cAno
                
        cMesAno:=cMes+cAno//Mesano(dDataBase)  
        cEmpresa:=subst(aInfo[3],1,40)
		cCNPJ   :=Transform( aInfo[8] , "@R 99.999.999/9999-99")
        
        cRegFunc:=strzero(val(SRA->RA_MAT),6)

	    nValSal := 0
	    nValSal := fBuscaSal(dDataRef)
        If nValSal ==0
       		nValSal := SRA->RA_SALARIO
        EndIf

        cValSal:=trans(nValSal,cPict)
        
        /*��������������������������������������������������������������Ŀ
		  � Carrega Funcao do Funcion. de acordo com a Dt Referencia     �
		  ����������������������������������������������������������������*/
		
		cNome:=sra->ra_nome+space(10)  		  
		fBuscaFunc(dDataRef, @cCodFunc, @cDescFunc)         
		cDescFunc:=Left(cDescFunc,20)+SPACE(10) // Funcao
		
        cArea:=Left(FDESC("SI3",sra->ra_cc,"I3_DESC"),25)   //Posicione("SQB",1,xFilial("SQB")+SRA->RA_DEPTO,"QB_DESCRIC")
        cArea+=SPACE(30-Len(cArea))
		
        cLin:=cTipoReg+cMesAnoRef+cEmpresa+cCNPJ+cRegFunc+cNome+cArea+cDescFunc+cData+cValSal+strzero(Val(SRA->RA_DEPIR),2)+strzero(val(SRA->RA_DEPSF),2)

   Case cTipoReg == "2"  // Proventos
		/*2999999 30,00SAL�RIO                       9.999.999,99                                                                                                                                                                                                   
		  2888888  1,00VALE REFEICAO                     9.999,99*/
		cCodVerba := strzero(val(Left(aLinha[1],3)),6) 
		cQtVerba  :=trans(aLinha[2],'@E 999.99')
		cDescVerba:=Left(Subst(aLinha[1],5),20)+SPACE(10)
		cValor    :=trans(aLinha[3],cPict)
		
        cLin:="2"+cCodVerba+cQtVerba+cDescVerba+cValor   

   Case cTipoReg == "2A"  // Descontos
		/*2777777 40,00ADIANTAMENTO (VALE)                           9.999,99                                                                                                                                                                                       
		  2666666  7,65I.N.S.S.                                         53,83                                                                                                                                                                                       
          2555555  0,00VALE                                            100,00                                                                                                                                                                                       
          2444444  1,00FALTAS (DIAS)                                    25,46                                                                                                                                                                                       
          2333333 10,00FALTAS E ATRASOS (T/H)                           34,72                                                                                                                                                                                       
          2000000  0,00DESCONTOS                                        15,00                                                                                                                                                                                       
          2111111  1,00SEGURO DE VIDA                                    5,00*/                                                                                                                                                                                       
		cCodVerba := strzero(val(Left(aLinha[1],3)),6) 
		cQtVerba  :=trans(aLinha[2],'@E 999.99')
		cDescVerba:=Left(Subst(aLinha[1],5),20)+SPACE(10)
		cValor    :=trans(aLinha[3],cPict)
	
        cLin:="2"+cCodVerba+cQtVerba+cDescVerba+SPACE(12)+cValor   
   Case cTipoReg == "3"
		/*300000000000000000000000      863,89    1.539,57    1.324,32*/
		cBanco  :=Strzero(val(aLinha[1]),5)
		cAgencia:=strzero(val(aLinha[2]),6)
		cConta  :=aLinha[3]
		cTotVenc:=trans(aLinha[4],cPict)   // Total Vencimentos
		cTotDesc:=trans(aLinha[5],cPict)   // Total Descontos
		cTotLiq :=trans(aLinha[6],cPict)   // Total Liquido       
		
		cLin:="3"+cBanco+cAgencia+cConta+cTotVenc+cTotDesc+cTotLiq

   Case cTipoReg == "4"
		/*49999SALARIO BASE            R$9.999.999,99                                                                                                                                                                                                               
		  49999BASE DE CALC. INSS      R$9.999.999,99                                                                                                                                                                                                               
		  49999BASE DE FGTS            R$      703,71                                                                                                                                                                                                               
		  49999FGTS DO MES             R$       56,30                                                                                                                                                                                                               
		  49999BASE DE CALC IRRF       R$      521,05                                                                                                                                                                                                               
		  49999FAIXA DE IRRF                     0,00*/                                                                                                                                                                                                               		  

		cCodVerba := space(04)
		cDescVerba:= Left(Subst(aLinha[1],5),20)+SPACE(06) 
		cValor    :="R$"+trans(aLinha[3],cPict)
		cLin:="4"+cCodVerba+cDescVerba+cValor  
		
//   Case cTipoReg == "4A"		
		/*49999SALARIO BASE            R$9.999.999,99                                                                                                                                                                                                               
		  49999BASE DE CALC. INSS      R$9.999.999,99                                                                                                                                                                                                               
		  49999BASE DE FGTS            R$      703,71                                                                                                                                                                                                               
		  49999FGTS DO MES             R$       56,30                                                                                                                                                                                                               
		  49999BASE DE CALC IRRF       R$      521,05                                                                                                                                                                                                               
		  49999FAIXA DE IRRF                     0,00*/                                                                                                                                                                                                               		  
/*
		cCodVerba := space(04)
		cDescVerba:="BASE DE FGTS"+space(14)
        cBaseFgts :="R$"+trans(nBaseFgts,cPict)

        cFgts     :="R$"+trans(nFgts,cPict)
        cBaseIr   :="R$"+trans(nBaseIr,cPict)
        cVlFaixaIr:=trans(0,cPict)               
        
		cLin:="4"+cCodVerba+cDescVerba+cBaseFgts+CRLF  // BASE DE FGTS
		fWrite(nHdl,cLin,Len(cLin))

		cDescVerba:="FGTS DO MES"+space(15)		      //  FGTS DO MES
		cLin:="4"+cCodVerba+cDescVerba+cFgts+CRLF
		fWrite(nHdl,cLin,Len(cLin))

		cDescVerba:="BASE DE CALC IRRF"+space(9)      //  BASE DE IRRF
		cLin:="4"+cCodVerba+cDescVerba+cBaseIr+CRLF
		fWrite(nHdl,cLin,Len(cLin))

		cDescVerba:="FAIXA DE IRRF"+space(13)      	  //  FAIXA DE IRRF
		cLin:="4"+cCodVerba+cDescVerba+cVlFaixaIr
//		fWrite(nHdl,cLin,Len(cLin))
*/
   Case cTipoReg == "5"    		  
		//5DATA PAGTO: 11/11/2006                                                                                                                                                                                                                                   
        cData:=dtos(dDataPagto)
        cAno :=subst(cData,1,4)
        cMes :=subst(cData,5,2)
        cDia :=subst(cData,7,2)

        cData:=cDia+'/'+cMes+'/'+cAno
         
        cMsg1:=""
        cMsg2:=""
        cMsg3:=""
        
		// MENSAGENS
		If !Empty(MENSAG1)
			If FPHIST82(SRA->RA_FILIAL,"06",SRA->RA_FILIAL+MENSAG1)
				//cMsg1 += Left(SRX->RX_TXT,60)
				cMsg1 += PadR( Left(SRX->RX_TXT,60), 70, Space(01))
			ElseIf FPHIST82(SRA->RA_FILIAL,"06","  "+MENSAG1)
				//cMsg1 += Left(SRX->RX_TXT,60)
				cMsg1 += PadR( Left(SRX->RX_TXT,60), 70, Space(01))
			Endif
		Endif
        
		If !Empty(MENSAG2)
			If FPHIST82(SRA->RA_FILIAL,"06",SRA->RA_FILIAL+MENSAG2)
				//cMsg2 += Left(SRX->RX_TXT,60)
				cMsg2 += PadR( Left(SRX->RX_TXT,60), 70, Space(01))
			ElseIf FPHIST82(SRA->RA_FILIAL,"06","  "+MENSAG2)
				//cMsg2 += Left(SRX->RX_TXT,60)
				cMsg2 += PadR( Left(SRX->RX_TXT,60), 70, Space(01))
			Endif
		Endif

		If !Empty(MENSAG3)
			If FPHIST82(SRA->RA_FILIAL,"06",SRA->RA_FILIAL+MENSAG3)
				//cMsg3 += Left(SRX->RX_TXT,60)
				cMsg3 += SM0->M0_CODIGO +" - "+ PadR( SM0->M0_NOME, 15, SPACE(01)) +" - "+ PadR( SRA->RA_NOME, 30, SPACE(01))
			ElseIf FPHIST82(SRA->RA_FILIAL,"06","  "+MENSAG3)
				//cMsg3 += Left(SRX->RX_TXT,60)
                cMsg3 += SM0->M0_CODIGO +" - "+ PadR( SM0->M0_NOME, 15, SPACE(01)) +" - "+ PadL(SRA->RA_MAT, 6, SPACE(1)) +" - "+ PadR( SRA->RA_NOME, 30, SPACE(01))
			Endif
		Endif

        //cLin:="5"+cMsg1+SPACE(20)+cMsg2+SPACE(20)+cMsg3+SPACE(20)
        cLin:=""
        cLin+=If(!Empty(cMsg1),"5"+cMsg1+CRLF,"")
        cLin+=If(!Empty(cMsg2),"5"+cMsg2+CRLF,"")
        cLin+=If(!Empty(cMsg3),"5"+cMsg3,"")
        
EndCase

cLin+=CRLF
fWrite(nHdl,cLin,Len(cLin))

Return
