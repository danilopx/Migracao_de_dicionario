#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "topconn.ch"
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � FOLHAXLS �       �RICARDO DUARTE COSTA� Data �  23/07/2012 ���
�������������������������������������������������������������������������͹��
���Descricao � Gerar planilha excel do movimento de folha de pagamento do ���
���          � m�s ou per�odo selecionado.                                 ���
�������������������������������������������������������������������������͹��
���Uso       �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function FOLHAXLS()

Local aArea	:= GetArea()
Private cString, cPerg, oGera

cPerg       := "FOLHAXLS  "

CriaSx1(cPerg)

Pergunte(cPerg, .F.)
dbSelectArea("SRD")
dbSetOrder(1)

//���������������������������������������������������������������������Ŀ
//� Montagem da tela de processamento.                                  �
//�����������������������������������������������������������������������
@ 200,1 TO 400,480 DIALOG oGera TITLE OemToAnsi("Folha em Excel")
@ 02,10 TO 095,230
@ 10,018 Say " Este programa ira gerar uma planilha excel com as verbas da   "
@ 18,018 Say " folha de pagamento do m�s selecionado.                        "

@ 70,128 BMPBUTTON TYPE 05 ACTION Pergunte(cPerg,.T.)
@ 70,158 BMPBUTTON TYPE 02 ACTION Close(oGera)
@ 70,188 BMPBUTTON TYPE 01 ACTION OkGera()

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

Local aPerAberto := aPerFechado := {}
//���������������������������������������������������������������������Ŀ
//� Variaveis                                                           �
//�����������������������������������������������������������������������
cAnoMesDe	:= Right(mv_par01,4)+Left(mv_par01,2)
cAnoMesAte	:= Right(mv_par02,4)+Left(mv_par02,2)
cFilDe		:= mv_par03
cFilAte		:= mv_par04
//cFolMes		:= SuperGetMv("MV_FOLMES",,SPACE(8))

RetPerAbertFech('00001'/*cProcesso*/,'FOL'/*Roteiro*/,cAnoMesDe/*cPeriodo*/,'1'/*cPagamento*/,cAnoMesAte,,@aPerAberto,@aPerFechado)

//-- Confirma a operacao antes de sair executando
If !GPECROk()
	Return()
Endif

If	cFilAte < cFilDe .Or.;
  	(Empty(aPerAberto) .And. Empty(aPerFechado))
	Aviso("Aten��o","Corrija os par�metros, pois existe inconsist�ncia.",{"OK"})
	return
Else
	If (nPos:=aScan(aPerAberto, {|x| x[1] == cAnoMesDe .And. x[2] == '1'})) > 0
		//cMes		:= aPerAberto[nPos,3]
		//cAno		:= aPerAberto[nPos,4]		
		cFolMes := aPerAberto[nPos,4]+aPerAberto[nPos,3] //ano+mes aberto
	Endif 
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

Local nx			:= 0
Local lFirst		:= .T.
Local cDet			:= ""
Local cFilMatAnt	:= "@@@@@@@@"
Local cPERIODOAnt	:= "@@@@@@@"
Local cDirDocs   	:= MsDocPath()
Local cArquivo   	:= CriaTrab(,.F.)
Local cPath		 	:= AllTrim(GetTempPath())
Local oExcelApp
Local nHandle
Local nBaseInss		:= 0
Local nColFixas		:= 13
Local aMatSRE		:= {}
Private aCodFol		:= {}
Private lCont		:= .F.
Private aCabec		:= {"C.C.","Centro de Custos","","Filial","Matricula","CPF","Nome","Admiss�o","Demiss�o","Fun��o","Escolaridade","Compet�ncia","Salario"}
Private aDados		:= {}

//-- Selecionando verbas do movimento
IF Select("WSRV") > 0
	WSRV->(DbCloseArea())
Endif
MsAguarde( {|| lCont := fMtaSRV()}, "Processando...", "Selecionando verbas do movimento..." )

//-- Selecionando transfer�ncias do movimento
IF Select("WSRE") > 0
	WSRE->(DbCloseArea())
Endif
MsAguarde( {|| lCont := fMtaSRE(aMatSRE)}, "Processando...", "Selecionando transferencias do movimento..." )

//-- Selecionando valores por funcion�rio
IF Select("WSRD") > 0
	WSRD->(DbCloseArea())
Endif
MsAguarde( {|| lCont := fMtaSRD()}, "Processando...", "Selecionando valores do movimento..." )

//Aviso que n�o existem dados para gerar
If !lCont
	Aviso("ATENCAO","Nao Existem rescis�es no intervalo de par�metros selecionados. Verifique.",{"Sair"})
	Return
Endif

nHandle := MsfCreate(cDirDocs+"\"+cArquivo+".CSV",0)
If nHandle > 0
	//-- Processa as rescis�es encontradas
	While !WSRD->(eof())
		IncProc("Exportando folha para o Excel")
		//-- Grava o cabe�alho no primeiro registro
		If lFirst

			//-- Grava o cabe�alho
			fWrite(nHandle,"Per�odo Gerado: "+mv_par01+" a "+mv_par02+CRLF)
			fWrite(nHandle,"" +CRLF)

			//-- Monta o cabe�alho da Planilha
			cDet	:= ""
			For nx := 1 to nColFixas
				cDet += aCabec[nx]
				If nx <> nColFixas
					cDet += ";"
				Endif
			Next nx
			cDet += ";Tipo da Verba;Verba;Valor"
			cDet += CRLF

			//-- Grava o cabe�alho
			fWrite(nHandle,cDet)
			lFirst := .F.

		Endif
		
		//-- Inicia acumulo do novo funcion�rio
		If cFilMatAnt <> WSRD->(RD_FILIAL+RD_MAT) .Or. right(WSRD->RD_PERIODO,2)+"/"+left(WSRD->RD_PERIODO,4) <> cPERIODOAnt
			aDados	:= array(len(aCabec))
			Afill(aDados,0)
			nBaseInss	:= 0
			cCatFunc	:= WSRD->RA_CATFUNC
			aDados[1]	:= WSRD->RA_CC
			aDados[2]	:= WSRD->CTT_DESC01
			aDados[3]	:= ""
			aDados[4]	:= WSRD->RD_FILIAL
			aDados[5]	:= WSRD->RD_MAT
			aDados[6]	:= WSRD->RA_CIC
			aDados[7]	:= WSRD->RA_NOME
			aDados[8]	:= WSRD->RA_ADMISSA
			aDados[9]	:= If(AnoMes(WSRD->RA_DEMISSA) < cAnoMesAte .Or. (AnoMes(WSRD->RA_DEMISSA) >= cAnoMesDe .And. AnoMes(WSRD->RA_DEMISSA) <= cAnoMesAte),WSRD->RA_DEMISSA,ctod(""))
			aDados[10]	:= WSRD->RJ_DESC
			aDados[11]	:= fDesc("SX5","26"+WSRD->RA_GRINRAI,"X5DESCRI()",,SRA->RA_FILIAL)
			aDados[12]	:= right(WSRD->RD_PERIODO,2)+"/"+left(WSRD->RD_PERIODO,4)
			aDados[13]	:= WSRD->RA_SALARIO

			//-- Busca os valores de provis�es calculados
			_nVlPrvFAT	:= _nVlPrvFAn := _nMdPrvFAT	:= _nMdPrvFAn := _n13PrvFAT	:= _n13PrvFAn := _nVlINSSFT := _nVlINSSFa := _nVlFGTSFT := _nVlFGTSFa := 0
			_nVlPrvDAt 	:= _nVlPrvDAn := _nMdPrvDAt := _nMdPrvDAn := _nVlINSSDT := _nVlINSSDa := _nVlFGTSDT := _nVlFGTSDa := 0
			_dDataAnt	:= stod(WSRD->RD_PERIODO+"01")-1
			_dDataAtu	:= stod(WSRD->RD_PERIODO+"01")

			//-- Pesquisa o mes anterior
			fMtaSRT(AnoMes(_dDataAnt))
			While !WSRT->(Eof()) .And. (WSRD->RD_FILIAL + WSRD->RD_MAT)=(WSRT->RT_FILIAL + WSRT->RT_MAT)
				//-- Provis�o de f�rias
				If WSRT->RT_VERBA $ acodfol[130,1]	//"851"	
					_nVlPrvFAn += WSRT->RT_VALOR
				ElseIf WSRT->RT_VERBA $ acodfol[254,1]	//"852"	
					_nMdPrvFAn += WSRT->RT_VALOR
				ElseIf WSRT->RT_VERBA $ acodfol[255,1]	//"853"	
					_n13PrvFAn += WSRT->RT_VALOR
				ElseIf WSRT->RT_VERBA $ acodfol[131,1]	//"854"		
					_nVlINSSFa += WSRT->RT_VALOR
				ElseIf WSRT->RT_VERBA $ acodfol[132,1]	//"855"		
					_nVlFGTSFa += WSRT->RT_VALOR
				//-- Provis�o de 13o sal�rio
				ElseIf WSRT->RT_VERBA $ acodfol[136,1]	//"921*"	
					_nVlPrvDAn += WSRT->RT_VALOR
				ElseIf WSRT->RT_VERBA $ acodfol[267,1]	//"922*"	
					_nMdPrvDAn += WSRT->RT_VALOR
				ElseIf WSRT->RT_VERBA $ acodfol[137,1]	//"924"
					_nVlINSSDa += WSRT->RT_VALOR
				ElseIf WSRT->RT_VERBA $ acodfol[138,1]	//"925"		
					_nVlFGTSDa += WSRT->RT_VALOR
				EndIf
				WSRT->(dbSkip())
			EndDo
			
			//-- Pesquisa o mes atual
			fMtaSRT(AnoMes(_dDataAtu))
			While !WSRT->(Eof()) .And. (WSRD->RD_FILIAL + WSRD->RD_MAT)=(WSRT->RT_FILIAL + WSRT->RT_MAT)
				//-- Provis�o de f�rias
//				If WSRT->RT_VERBA $ "851,852,853,871,872,873,876,877,878,881,882,883"
				If WSRT->RT_VERBA $ acodfol[130,1]+","+acodfol[254,1]+","+acodfol[255,1]+","+;
									acodfol[233,1]+","+acodfol[258,1]+","+acodfol[259,1]+","+;
									acodfol[239,1]+","+acodfol[261,1]+","+acodfol[260,1]+","+;
									acodfol[262,1]+","+acodfol[263,1]+","+acodfol[264,1]
					//-- Rescis�es
					IF !Empty(aDados[10]) .And. AnoMes(_dDataAtu) == AnoMes(aDados[10]) .And. WSRT->RT_VERBA$acodfol[130,1]+","+acodfol[254,1]+","+acodfol[255,1]	//"851,852,853"
						WSRT->(DbSkip())
						loop
					Endif
					//-- Transfer�ncias
					IF Ascan(aMatSre,{|X| X[1]==AnoMes(_dDataAtu) .And. X[2]+X[3] == WSRD->RD_FILIAL + WSRD->RD_MAT }) > 0 .And. WSRT->RT_VERBA$acodfol[239,1]+","+acodfol[261,1]+","+acodfol[260,1]	//"876,877,878"
						WSRT->(DbSkip())
						loop
					Endif
					If WSRT->RT_VERBA $ acodfol[130,1]+","+acodfol[233,1]+","+acodfol[239,1]+","+acodfol[262,1]	//"851,871,876,881"
						_nVlPrvFAT += WSRT->RT_VALOR
					ElseIf WSRT->RT_VERBA $ acodfol[254,1]+","+acodfol[258,1]+","+acodfol[261,1]+","+acodfol[263,1]	//"852,872,878,882"
						_nMdPrvFAT += WSRT->RT_VALOR
					ElseIf WSRT->RT_VERBA $ acodfol[255,1]+","+acodfol[259,1]+","+acodfol[260,1]+","+acodfol[264,1]	//"853,873,877,883"
						_n13PrvFAT += WSRT->RT_VALOR
					Endif
				ElseIf WSRT->RT_VERBA $ acodfol[131,1]+","+acodfol[234,1]+","+acodfol[240,1]+","+acodfol[265,1]	//"854,874,879,884"
					//-- Rescis�es
					IF !Empty(aDados[10]) .And. AnoMes(_dDataAtu) == AnoMes(aDados[10]) .And. WSRT->RT_VERBA$acodfol[131,1]	//"854"
						WSRT->(DbSkip())
						loop
					Endif
					//-- Transfer�ncias
					IF Ascan(aMatSre,{|X| X[1]==AnoMes(_dDataAtu) .And. X[2]+X[3] == WSRD->RD_FILIAL + WSRD->RD_MAT }) > 0 .And. WSRT->RT_VERBA$acodfol[240,1]	//"879"
						WSRT->(DbSkip())
						loop
					Endif
					_nVlINSSFT += WSRT->RT_VALOR
				ElseIf WSRT->RT_VERBA $ acodfol[132,1]+","+acodfol[235,1]+","+acodfol[241,1]+","+acodfol[266,1]	//"855,875,880,885"
					//-- Rescis�es
					IF !Empty(aDados[10]) .And. AnoMes(_dDataAtu) == AnoMes(aDados[10]) .And. WSRT->RT_VERBA$acodfol[132,1]	//"855"
						WSRT->(DbSkip())
						loop
					Endif
					//-- Transfer�ncias
					IF Ascan(aMatSre,{|X| X[1]==AnoMes(_dDataAtu) .And. X[2]+X[3] == WSRD->RD_FILIAL + WSRD->RD_MAT }) > 0 .And. WSRT->RT_VERBA$acodfol[241,1]	//"880"
						WSRT->(DbSkip())
						loop
					Endif
					_nVlFGTSFT += WSRT->RT_VALOR
				//-- Provis�o de 13o sal�rio
//				ElseIf WSRT->RT_VERBA $ "921,922,926,927,931,932,936,937"
				ElseIf WSRT->RT_VERBA $ acodfol[136,1]+","+acodfol[267,1]+","+;
										acodfol[270,1]+","+acodfol[271,1]+","+;
										acodfol[274,1]+","+acodfol[275,1]+","+;
										acodfol[332,1]+","+acodfol[333,1]
					//-- Rescis�es
					IF !Empty(aDados[10]) .And. AnoMes(_dDataAtu) == AnoMes(aDados[10]) .And. WSRT->RT_VERBA$acodfol[136,1]+","+acodfol[267,1]	//"921,922"
						WSRT->(DbSkip())
						loop
					Endif
					//-- Transfer�ncias
					IF Ascan(aMatSre,{|X| X[1]==AnoMes(_dDataAtu) .And. X[2]+X[3] == WSRD->RD_FILIAL + WSRD->RD_MAT }) > 0 .And. WSRT->RT_VERBA$acodfol[270,1]+","+acodfol[271,1]	//"926,927"
						WSRT->(DbSkip())
						loop
					Endif
					If WSRT->RT_VERBA $ acodfol[136,1]+","+acodfol[270,1]+","+acodfol[274,1]+","+acodfol[332,1]	//"921,926,931,936"
						_nVlPrvDAt += WSRT->RT_VALOR
					ElseIf WSRT->RT_VERBA $ acodfol[267,1]+","+acodfol[271,1]+","+acodfol[275,1]+","+acodfol[333,1]	//"922,927,932,937"
						_nMdPrvDAt += WSRT->RT_VALOR
					Endif
				ElseIf WSRT->RT_VERBA $ acodfol[137,1]+","+acodfol[272,1]+","+acodfol[276,1]+","+acodfol[335,1]	//"924,928,934,939"
					//-- Rescis�es
					IF !Empty(aDados[10]) .And. AnoMes(_dDataAtu) == AnoMes(aDados[10]) .And. WSRT->RT_VERBA$acodfol[137,1]	//"924"
						WSRT->(DbSkip())
						loop
					Endif
					//-- Transfer�ncias
					IF Ascan(aMatSre,{|X| X[1]==AnoMes(_dDataAtu) .And. X[2]+X[3] == WSRD->RD_FILIAL + WSRD->RD_MAT }) > 0 .And. WSRT->RT_VERBA$acodfol[272,1]	//"928"
						WSRT->(DbSkip())
						loop
					Endif
					_nVlINSSDT += WSRT->RT_VALOR
				ElseIf WSRT->RT_VERBA $ acodfol[138,1]+","+acodfol[273,1]+","+acodfol[277,1]+","+acodfol[336,1]	//"925,929,935,940"
					//-- Rescis�es
					IF !Empty(aDados[10]) .And. AnoMes(_dDataAtu) == AnoMes(aDados[10]) .And. WSRT->RT_VERBA$acodfol[138,1]	//"925"
						WSRT->(DbSkip())
						loop
					Endif
					//-- Transfer�ncias
					IF Ascan(aMatSre,{|X| X[1]==AnoMes(_dDataAtu) .And. X[2]+X[3] == WSRD->RD_FILIAL + WSRD->RD_MAT }) > 0 .And. WSRT->RT_VERBA$acodfol[273,1]	//"929"
						WSRT->(DbSkip())
						loop
					Endif
					_nVlFGTSDT += WSRT->RT_VALOR
				EndIf
				WSRT->(dbSkip())
			EndDo
			If Select("WSRT") > 0
				WSRT->(DbCloseArea())
			Endif
			//-- Pesquisa a posi��o da verba no cabe�alho
			If (_nVlPrvFAT+_nMdPrvFAT+_n13PrvFAT+_nVlINSSFT+_nVlFGTSFT+_nVlPrvDAt+_nMdPrvDAt+_nVlINSSDT+_nVlFGTSDT) > 0 .Or. ;
				( Empty(AnoMes(aDados[10])) .Or. AnoMes(_dDataAtu) <= AnoMes(aDados[10]) )
				nPosPd	:= Ascan(aCabec,{|X| left(X,3) == acodfol[130,1]})
				aDados[nPosPd]	+= _nVlPrvFAT - _nVlPrvFAn	// Prov Fer
				nPosPd	:= Ascan(aCabec,{|X| left(X,3) == acodfol[254,1]})
				aDados[nPosPd]	+= _nMdPrvFAT - _nMdPrvFAn	// Prov Fer M�dias
				nPosPd	:= Ascan(aCabec,{|X| left(X,3) == acodfol[255,1]})
				aDados[nPosPd]	+= _n13PrvFAT - _n13PrvFAn	// Prov Fer 1/3
				nPosPd	:= Ascan(aCabec,{|X| left(X,3) == acodfol[131,1]})
				aDados[nPosPd]	+= _nVlINSSFT - _nVlINSSFa	// Prov Inss Fer
				nPosPd	:= Ascan(aCabec,{|X| left(X,3) == acodfol[132,1]})
				aDados[nPosPd]	+= _nVlFGTSFT - _nVlFGTSFa	// Prov Fgts Fer
				nPosPd	:= Ascan(aCabec,{|X| left(X,3) == acodfol[136,1]})
				aDados[nPosPd]	+= _nVlPrvDAt - _nVlPrvDAn	// Prov 13oS
				nPosPd	:= Ascan(aCabec,{|X| left(X,3) == acodfol[267,1]})
				aDados[nPosPd]	+= _nMdPrvDAt - _nMdPrvDAn	// Prov 13oS Medias
				nPosPd	:= Ascan(aCabec,{|X| left(X,3) == acodfol[137,1]})
				aDados[nPosPd]	+= _nVlINSSDT - _nVlINSSDa	// Prov Inss 13o
				nPosPd	:= Ascan(aCabec,{|X| left(X,3) == acodfol[138,1]})
				aDados[nPosPd]	+= _nVlFGTSDT - _nVlFGTSDa	// Prov Fgts 13o
			Endif

			DbSelectArea("WSRD")

			cFilMatAnt	:= WSRD->(RD_FILIAL+RD_MAT)
			cPERIODOAnt	:= right(WSRD->RD_PERIODO,2)+"/"+left(WSRD->RD_PERIODO,4)
		Endif
		
		//-- Pesquisa a posi��o da verba no cabe�alho
		nPosPd	:= Ascan(aCabec,{|X| left(X,3) == WSRD->RD_PD})
		aDados[nPosPd]	:= WSRD->RD_VALOR

		//-- Atualiza Total de Proventos e Descontos
		If Possrv(WSRD->RD_PD,WSRD->RD_FILIAL,"RV_TIPOCOD",,.F.) == "1"
			aDados[len(aDados)-1]	+= WSRD->RD_VALOR	// Total Proventos
		ElseIf Possrv(WSRD->RD_PD,WSRD->RD_FILIAL,"RV_TIPOCOD",,.F.) == "2"
			aDados[len(aDados)]	+= WSRD->RD_VALOR	// Total Descontos
		Endif
		
		//-- Vai para o pr�ximo registro
		WSRD->(DbSkip())
		
		//-- Se iniciar um novo funcion�rio executa a grava��o do funcion�rio anterior
		If cFilMatAnt <> WSRD->(RD_FILIAL+RD_MAT) .Or. WSRD->(Eof()) .Or. right(WSRD->RD_PERIODO,2)+"/"+left(WSRD->RD_PERIODO,4) <> cPERIODOAnt
			//-- Grava a exporta��o para o excel
			//-- Monta a parte fixa das colunas
			cDet	:= ""
			For nx := 1 to nColFixas
				If valtype(aDados[nx]) == "N"
					cDet	+= Transform(aDados[nx],"@E 999,999,999.99")
				ElseIf valtype(aDados[nx]) == "D"
					cDet	+= Dtoc(aDados[nx],"DDMMYYYY")
				Else
					cDet	+= aDados[nx]
				Endif
				If nx <> len(aDados)
					cDet += ";"
				Endif
			Next nx

			//-- Grava os itens por linha mantendo sempre a parte fixa
			cDetAux	:= ""
			For nx := (nColFixas+1) to len(aDados)
				//-- Salta a verba quando n�o tiver valor a gravar
				If aDados[nx] == 0
					loop
				Endif
				
				cTipoCod:= Possrv(aCabec[nx],Left(cFilMatAnt,2),"RV_TIPOCOD",,.F.)
				
				cDetAux := If(cTipoCod=="1","Provento",If(cTipoCod=="2","Desconto","Base"))+";"
				cDetAux	+= aCabec[nx]+";"
				cDetAux	+= Transform(aDados[nx],"@E 999,999,999.99")
				cDetAux += CRLF
				//-- Grava a linha do funcion�rio
				fWrite(nHandle,cDet+cDetAux)
			Next nx
		Endif
	Enddo
	fClose(nHandle)
	CpyS2T( cDirDocs+"\"+cArquivo+".CSV" , cPath, .T. )
	Ferase(cDirDocs+"\"+cArquivo+".CSV")
	Aviso("Aten��o","A planilha foi gerada em "+cPath+cArquivo+".CSV",{"Ok"})
	If ! ApOleClient( 'MsExcel' )
		MsgAlert( 'MsExcel nao instalado' )
		Return
	EndIf
	
	oExcelApp := MsExcel():New()
	oExcelApp:WorkBooks:Open( cPath+cArquivo+".CSV" ) // Abre uma planilha
	oExcelApp:SetVisible(.T.)
Else
	MsgAlert( "Falha na cria��o do arquivo" )
EndIf

//-- Fecha a query corrente
WSRD->(DbCloseArea())
DbSelectArea("SRA")
Close(oGera)

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �fMtaSRV   �Autor  �RICARDO DUARTE COSTA� Data �  17/06/09   ���
�������������������������������������������������������������������������͹��
���Desc.     �Monta a query de verbas do movimento                       ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �Programa principal                                          ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
����������������������������������������������������������������������������� */
Static Function fMtaSRV()

Local lRet	:= .F.
Local cQuery

cQuery := " "
cQuery += " SELECT RV_COD, RV_DESC, RV_TIPOCOD
cQuery += " FROM "+RetSqlName("SRV")+" SRV"
cQuery += " WHERE"
cQuery += " SRV.D_E_L_E_T_ = ''"
If Empty(xFilial("SRV"))
	cQuery += " AND RV_FILIAL = '  '"
Else
	cQuery += " AND RV_FILIAL BETWEEN '"+cFilDe+"' AND '"+cFilAte+"'"
Endif
cQuery += " ORDER BY 3,1,2"
cQuery := ChangeQuery( cQuery )
TCQuery cQuery New Alias "WSRV"
dbSelectArea( "WSRV" )
While !WSRV->(Eof())
	lRet := .T.
	Aadd(aCabec,WSRV->RV_COD+" - "+WSRV->RV_DESC)
	WSRV->(DbSkip())
Enddo
Aadd(aCabec,"Total Proventos")
Aadd(aCabec,"Total Descontos")

WSRV->(DbCloseArea())
DbSelectArea("SRD")

//-- Carrega lista de verbas por identificador de c�lculo
IF !FP_CODFOL(@aCodFol,cFilAnt)
	Alert("N�o foi poss�vel carregar as verbas de provis�es. Verifique configura��es da tabela SRV junto ao administrador do sistema.")
Endif

Return( lRet )

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �fMtaSRD   �Autor  �RICARDO DUARTE COSTA� Data �  17/06/09   ���
�������������������������������������������������������������������������͹��
���Desc.     �Monta a query de movimento de folha de pagamento.           ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �Programa principal                                          ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
����������������������������������������������������������������������������� */
Static Function fMtaSRD()

Local lRet	:= .F.
Local cQuery

cQuery := " "

//-- Folha do m�s em aberto
If cFolMes >= cAnoMesDe .And. cFolMes <= cAnoMesAte
	cQuery += " SELECT RD_FILIAL, RD_MAT, RD_PD, SUM(RD_VALOR) RD_VALOR, RD_PERIODO"
	cQuery += " , RA_CIC, RA_GRINRAI, RA_NOME, RA_CC, RJ_DESC, RA_SITFOLH, RA_CATFUNC, MAX(RA_SALARIO) RA_SALARIO, CTT_DESC01, '' CTT_TPCONT, RA_ADMISSA, RA_DEMISSA"
	cQuery += " FROM ( "
	cQuery += " SELECT RC_FILIAL RD_FILIAL, RC_MAT RD_MAT, RC_PD RD_PD, SUM(RC_VALOR) RD_VALOR, '"+cFolMes+"' RD_PERIODO"
	cQuery += " , RA_CIC, RA_GRINRAI, RA_NOME, RA_CC, RJ_DESC, RA_SITFOLH, RA_CATFUNC, RA_SALARIO, CTT_DESC01, '' CTT_TPCONT, RA_ADMISSA, RA_DEMISSA"
	cQuery += " FROM "+RetSqlName("SRC")+" SRC, "+RetSqlName("SRV")+" SRV, "+RetSqlName("SRA")+" SRA, "+RetSqlName("CTT")+" CTT, "+RetSqlName("SRJ")+" SRJ"
	cQuery += " WHERE"
	cQuery += " SRC.D_E_L_E_T_ = ''"
	cQuery += " AND SRV.D_E_L_E_T_ = ''"
	cQuery += " AND SRA.D_E_L_E_T_ = ''"
	cQuery += " AND CTT.D_E_L_E_T_ = ''"
	cQuery += " AND SRJ.D_E_L_E_T_ = ''"
	cQuery += " AND RC_FILIAL BETWEEN '"+cFilDe+"' AND '"+cFilAte+"'"
	cQuery += " AND RV_COD = RC_PD"
	If Empty(xFilial("SRV"))
		cQuery += " AND RV_FILIAL = '  '"
	Else
		cQuery += " AND RV_FILIAL = RC_FILIAL"
	Endif
	cQuery += " AND RC_FILIAL = RA_FILIAL AND RC_MAT = RA_MAT"
	If Empty(xFilial("CTT"))
		cQuery += " AND CTT_FILIAL = '  '"
	Else
		cQuery += " AND CTT_FILIAL = RC_FILIAL"
	Endif
	cQuery += " AND RA_CC = CTT_CUSTO"
	If Empty(xFilial("SRJ"))
		cQuery += " AND RJ_FILIAL = '  '"
	Else
		cQuery += " AND RJ_FILIAL = RC_FILIAL"
	Endif
	cQuery += " AND RA_CODFUNC = RJ_FUNCAO"
	cQuery += " GROUP BY RC_FILIAL, RC_MAT, RC_PD, RA_CIC, RA_GRINRAI, RA_NOME, RA_CC, RJ_DESC, RA_SITFOLH, RA_CATFUNC, RA_SALARIO, CTT_DESC01, RA_ADMISSA, RA_DEMISSA"
	cQuery += " UNION ALL"

/*	//-- 13o sal�rio do per�odo em aberto.
	If right(cFolMes,2) == "12" .Or. ( left(cAnoMesAte,4) > left(cAnoMesDe,4) )
		cQuery += " SELECT RI_FILIAL RD_FILIAL, RI_MAT RD_MAT, RI_PD RD_PD, SUM(RI_VALOR) RD_VALOR, '"+cFolMes+"' RD_PERIODO"
		cQuery += " , RA_CIC, RA_GRINRAI, RA_NOME, RA_CC, RJ_DESC, RA_SITFOLH, RA_CATFUNC, RA_SALARIO, CTT_DESC01, '' CTT_TPCONT, RA_ADMISSA, RA_DEMISSA"
		cQuery += " FROM "+RetSqlName("SRI")+" SRI, "+RetSqlName("SRV")+" SRV, "+RetSqlName("SRA")+" SRA, "+RetSqlName("CTT")+" CTT, "+RetSqlName("SRJ")+" SRJ"
		cQuery += " WHERE"
		cQuery += " SRI.D_E_L_E_T_ = ''"
		cQuery += " AND SRV.D_E_L_E_T_ = ''"
		cQuery += " AND SRA.D_E_L_E_T_ = ''"
		cQuery += " AND CTT.D_E_L_E_T_ = ''"
		cQuery += " AND SRJ.D_E_L_E_T_ = ''"
		cQuery += " AND RI_FILIAL BETWEEN '"+cFilDe+"' AND '"+cFilAte+"'"
		cQuery += " AND RV_COD = RI_PD"
		If Empty(xFilial("SRV"))
			cQuery += " AND RV_FILIAL = '  '"
		Else
			cQuery += " AND RV_FILIAL = RI_FILIAL"
		Endif
		cQuery += " AND RI_FILIAL = RA_FILIAL AND RI_MAT = RA_MAT"
		If Empty(xFilial("CTT"))
			cQuery += " AND CTT_FILIAL = '  '"
		Else
			cQuery += " AND CTT_FILIAL = RI_FILIAL"
		Endif
		cQuery += " AND RA_CC = CTT_CUSTO"
		If Empty(xFilial("SRJ"))
			cQuery += " AND RJ_FILIAL = '  '"
		Else
			cQuery += " AND RJ_FILIAL = RI_FILIAL"
		Endif
		cQuery += " AND RA_CODFUNC = RJ_FUNCAO"
		cQuery += " GROUP BY RI_FILIAL, RI_MAT, RI_PD, RA_CIC, RA_GRINRAI, RA_NOME, RA_CC, RJ_DESC, RA_SITFOLH, RA_CATFUNC, RA_SALARIO, CTT_DESC01, RA_ADMISSA, RA_DEMISSA"
		cQuery += " UNION ALL"
	Endif*/
Endif

//-- Demais folha dos per�odos fechados
cQuery += " SELECT RD_FILIAL, RD_MAT, RD_PD, SUM(RD_VALOR) RD_VALOR, "
/*
cQuery += "        Case When Substring(RD_PERIODO,5,2) = '13'"
cQuery += "             Then Substring(RD_PERIODO,1,4)+'12'"
cQuery += "             Else RD_PERIODO"
cQuery += "        End AS RD_PERIODO"
*/
cQuery += " RD_PERIODO"

cQuery += " , RA_CIC, RA_GRINRAI, RA_NOME, RA_CC, RJ_DESC, RA_SITFOLH, RA_CATFUNC, RA_SALARIO, CTT_DESC01, '' CTT_TPCONT, RA_ADMISSA, RA_DEMISSA"
cQuery += " FROM "+RetSqlName("SRD")+" SRD, "+RetSqlName("SRV")+" SRV, "+RetSqlName("SRA")+" SRA, "+RetSqlName("CTT")+" CTT, "+RetSqlName("SRJ")+" SRJ"
cQuery += " WHERE"
cQuery += " SRD.D_E_L_E_T_ = ''"
cQuery += " AND SRV.D_E_L_E_T_ = ''"
cQuery += " AND SRA.D_E_L_E_T_ = ''"
cQuery += " AND CTT.D_E_L_E_T_ = ''"
cQuery += " AND SRJ.D_E_L_E_T_ = ''"
cQuery += " AND RD_EMPRESA = '  '"
cQuery += " AND RD_FILIAL BETWEEN '"+cFilDe+"' AND '"+cFilAte+"'"
cQuery += " AND RD_PERIODO BETWEEN '"+cAnoMesDe+"' AND '"+cAnoMesAte+"'"
cQuery += " AND RV_COD = RD_PD"
If Empty(xFilial("SRV"))
	cQuery += " AND RV_FILIAL = '  '"
Else
	cQuery += " AND RV_FILIAL = RD_FILIAL"
Endif
cQuery += " AND RD_FILIAL = RA_FILIAL AND RD_MAT = RA_MAT"
If Empty(xFilial("CTT"))
	cQuery += " AND CTT_FILIAL = '  '"
Else
	cQuery += " AND CTT_FILIAL = RD_FILIAL"
Endif
cQuery += " AND RA_CC = CTT_CUSTO"
If Empty(xFilial("SRJ"))
	cQuery += " AND RJ_FILIAL = '  '"
Else
	cQuery += " AND RJ_FILIAL = RD_FILIAL"
Endif
cQuery += " AND RA_CODFUNC = RJ_FUNCAO"
cQuery += " GROUP BY RD_FILIAL, RD_MAT, RD_PD, RA_CIC, RA_GRINRAI, RA_NOME, RA_CC, RJ_DESC, RA_SITFOLH, RA_CATFUNC, RA_SALARIO, CTT_DESC01, RA_ADMISSA, RA_DEMISSA, "
/*
cQuery += "        Case When Substring(RD_PERIODO,5,2) = '13'"
cQuery += "             Then Substring(RD_PERIODO,1,4)+'12'"
cQuery += "             Else RD_PERIODO End"
cQuery += "				as RD_PERIODO"
*/
cQuery += " RD_PERIODO"

If cFolMes >= cAnoMesDe .And. cFolMes <= cAnoMesAte
	cQuery += " ) TMP GROUP BY RD_FILIAL, RD_MAT, RD_PD, RA_CIC, RA_GRINRAI, RA_NOME, RA_CC, RJ_DESC, RA_SITFOLH, RA_CATFUNC, CTT_DESC01, RA_ADMISSA, RA_DEMISSA, RD_PERIODO"
Endif

cQuery += " ORDER BY RD_FILIAL, RA_NOME, RD_PERIODO"
cQuery := ChangeQuery( cQuery )
TCQuery cQuery New Alias "WSRD"
TcSetField("WSRD","RD_VALOR","N",14,2)
TcSetField("WSRD","RA_SALARIO","N",14,2)
TcSetField("WSRD","RA_ADMISSA","D",8,0)
TcSetField("WSRD","RA_DEMISSA","D",8,0)

dbSelectArea( "WSRD" )
If !WSRD->(Eof())
	lRet := .T.
EndIf

Return( lRet )

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �fMtaSRT   �Autor  �RICARDO DUARTE COSTA� Data �  17/06/09   ���
�������������������������������������������������������������������������͹��
���Desc.     �Monta a query de movimento de folha de pagamento.           ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �Programa principal                                          ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
����������������������������������������������������������������������������� */
Static Function fMtaSRT(cPeriodo)

Local lRet	:= .F.
Local cQuery

If Select("WSRT") > 0
	WSRT->(DbCloseArea())
Endif

cQuery := " "
cQuery += " SELECT RT_FILIAL, RT_MAT, RT_VERBA, RT_VALOR"
cQuery += " FROM "+RetSqlName("SRT")+" SRT"
cQuery += " WHERE"
cQuery += " SRT.D_E_L_E_T_ = ''"
cQuery += " AND RT_FILIAL = '"+WSRD->RD_FILIAL+"'"
cQuery += " AND RT_MAT = '"+WSRD->RD_MAT+"'"
cQuery += " AND SUBSTRING(RT_DATACAL,1,6) = '"+cPeriodo+"'"
cQuery += " ORDER BY RT_FILIAL, RT_MAT, RT_VERBA"
cQuery := ChangeQuery( cQuery )
TCQuery cQuery New Alias "WSRT"
TcSetField("WSRT","RT_VALOR","N",14,2)

dbSelectArea( "WSRT" )
If !WSRT->(Eof())
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
Aadd(aRegs,{cPerg,"01","Mes/Ano De?"         ,"","","mv_ch1","C",06,0,0,"G","NaoVazio()"                ,"MV_PAR01",""       ,"" ,"" ,"","",""     ,"" ,"" ,"","","","","","","","","","","","","","","","",""   ,"","",""})
Aadd(aRegs,{cPerg,"02","Mes/Ano Ate?"        ,"","","mv_ch2","C",06,0,0,"G","NaoVazio()"                ,"MV_PAR02",""       ,"" ,"" ,"","",""     ,"" ,"" ,"","","","","","","","","","","","","","","","",""   ,"","",""})
Aadd(aRegs,{cPerg,"03","Filial de ?"         ,"","","mv_ch3","C",02,0,0,"G",""                          ,"MV_PAR03",""       ,"" ,"" ,"","",""     ,"" ,"" ,"","","","","","","","","","","","","","","","","XM0","","",""})
Aadd(aRegs,{cPerg,"04","Filial Ate?"         ,"","","mv_ch4","C",02,0,0,"G","NaoVazio()"                ,"MV_PAR04",""       ,"" ,"" ,"","",""     ,"" ,"" ,"","","","","","","","","","","","","","","","","XM0","","",""})

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
���Programa  �GPECR010  �Autor  �Prima Informatica   � Data �  08/06/01   ���
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


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �fMtaSRZ   �Autor  �Ricardo Duarte Costa� Data � 18/04/2012  ���
�������������������������������������������������������������������������͹��
���Desc.     �Monta a query para o programa principal                     ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �Programa principal                                          ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
����������������������������������������������������������������������������� */
Static Function fMtaSRE(aMatSRE)

Local lRet		:= .F.
Local cQuery

cQuery := " "
cQuery += " SELECT *"
cQuery += " FROM "+ RetSqlName( "SRE" ) + " SRE "
cQuery += " WHERE "
cQuery += " SRE.D_E_L_E_T_ = ' '"
cQuery += " AND RE_EMPD = RE_EMPP"
cQuery += " AND RE_FILIALD = RE_FILIALP"
cQuery += " AND RE_CCD <> RE_CCP"
cQuery += " AND SUBSTRING(RE_DATA,1,6) BETWEEN '"+cAnoMesDe+"' AND '"+cAnoMesAte+"'"
cQuery += " AND RE_FILIALD BETWEEN '"+cFilDe+"' AND '"+cFilAte+"'"
cQuery += " AND EXISTS( SELECT 1 FROM "+ RetSqlName( "SRT" ) + " SRT WHERE SRT.D_E_L_E_T_ = ' ' AND RT_FILIAL = RE_FILIALD AND RT_MAT = RE_MATD"
//cQuery += " AND SUBSTRING(RE_DATA,1,6) = SUBSTRING(RT_DATACAL,1,6) AND RT_VERBA IN('876','877','878','879','880') )"
cQuery += " AND SUBSTRING(RE_DATA,1,6) = SUBSTRING(RT_DATACAL,1,6) AND RT_VERBA IN('"+acodfol[239,1]+"','"+acodfol[261,1]+"','"+acodfol[260,1]+"','"+acodfol[240,1]+"','"+acodfol[241,1]+"') )"
cQuery := ChangeQuery(cQuery)
TCQuery cQuery New Alias "WSRE"

lRet	:= !WSRE->(Eof())

If lRet
	While WSRE->(!Eof())
		WSRE->( Aadd(aMatSRE,{left(RE_DATA,6),left(RE_FILIALD,len(cFilAnt)),RE_MATD,RE_CCD,left(RE_FILIALP,len(cFilAnt)),RE_MATP,RE_CCP}) )
		WSRE->(DbSkip())
	Enddo
Endif

WSRE->(DbCloseArea())

Return( lRet )

