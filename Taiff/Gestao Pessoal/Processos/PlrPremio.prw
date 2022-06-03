#INCLUDE "PROTHEUS.CH"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �PLRPREMIO �Autor  �Ricardo Duarte Costa� Data �  25/02/2013 ���
�������������������������������������������������������������������������͹��
���Desc.     � C�lculo da Provis�o de Pr�mio e PLR sobre a folha de pagto.���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Protheus 10 e 11                                           ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������*/
User Function PlrPremio()

Local aAux		:= {}
Local aPremio	:= {}
Local aInssEmp_	:= {}
Local aAfasto_	:= {}
Local cTipo		:= If(cEmpAnt<>"01","2","1")	//--SRA->RA_TPBONIF		//-- 1=PLR;2=Premio;3=Misto   
Local nBasePrem	:= 0.00													//--SRA->RA_PREMIO_		//-- N�mero de sal�rios
Local nBasePLR	:= 0
Local nValorPrem:= 0
Local nVlPreInss:= 0
Local nVlPreFgts:= 0
Local nVlPreFer := 0
Local nVlPre13o := 0
Local nValorPLR	:= 0
Local nValorGlob:= 0
Local nAvosBonif:= 0
Local nAvosAf_	:= 0
Local nDiasAf_	:= 0
Local nDiasAfT_	:= 0
Local nx		:= 0
Local nAux		:= 0
Local nPos		:= 0
Local lPlr		:= cTipo == "1" .Or. cTipo == "3"
Local lPremio	:= cTipo == "2" .Or. cTipo == "3"
Local lJaneiro	:= right(CPERIODO,2) == "01"
Local _dDtIniBon	:= stod(left(CPERIODO,4)+"0101")
Local _dDtFimBon	:= stod(CPERIODO+strzero(f_ultdia(stod(CPERIODO+"01")),2))

//-- Menores aprendizes ou demais categorias n�o ter�o c�lculo de PLR nem de Pr�mio
If SRA->RA_CATEG == "07" .Or. !SRA->RA_CATFUNC $"M,H"
	Return
Endif

//-- Carrega valor base de PLR
fCarrTab( @aAux,"U003",stod(CPERIODO+"01"),.T. )

//-- Carrega percentuais de Pr�mio por Fun��o
fCarrTab( @aPremio,"U005",stod(CPERIODO+"01"),.T. )

//-- Ajusta a data de in�cio da apura��o do direito
If year(SRA->RA_ADMISSA) == val(left(CPERIODO,4))
	_dDtIniBon	:= SRA->RA_ADMISSA
Endif

//-- C�lcula os avos adquiridos
nAvosBonif:= DateDiffMonth(_dDtIniBon,_dDtFimBon)+1

//-- Deduz o 1o m�s caso a admiss�o no m�s n�o tenha mais de 15 dias trabalhados.
If AnoMes(SRA->RA_ADMISSA) == AnoMes(_dDtIniBon)
	If _dDtFimBon-SRA->RA_ADMISSA+1 < 15
		nAvosBonif -= 1
	Endif
Endif

//-- Busca os afastamentos do funcion�rio se existirem
fRetAfas(_dDtIniBon,_dDtFimBon,"O*P*W*R*X",@nAvosAf_,,aAfasto_)
For nx := 1 to len(aAfasto_)
	nDiasAf_ += aAfasto_[nx,2]
Next nx

//-- Busca os afastamentos projetando afastamentos at� o final do ano corrente
fRetAfas(_dDtIniBon,stod(left(CPERIODO,4)+"1231"),"O*P*W*R*X",,,aAfasto_)
For nx := 1 to len(aAfasto_)
	nDiasAfT_ += aAfasto_[nx,2]
Next nx

//-- Verifica a quantidade de dias de afastamento
If nDiasAf_ > 90 .Or. nDiasAFT_ > 90
	nAvosBonif	:= 0
ElseIf nDiasAf_ > 0 .And. nDiasAf_ <= 90
	nAvosBonif	:= nAvosBonif - nAvosAf_
Endif
	
//-- Apura��o do valor do PLR
If lPLR

	//-- Carrega o valor base para c�lculo da PLR
	If len(aAux) > 0
		If ( nPos := Ascan(aAux,{|X| X[5] == val(left(CPERIODO,4))} ) ) > 0
			nBasePLR	:= aAux[nPos,06]
		Endif
	Endif
	
	//-- C�lculo do valor do PLR
	If nAvosBonif > 0
		nValorPLR	:= Round(nBasePLR/12*nAvosBonif,2)
	Endif
	
	//-- Pr�mio - se o tipo for Misto ( Premio + PLR ) ent�o salva o valor do PLR para abater do c�lculo Pr�mio
	If lPremio
		nValorGlob	:= nValorPLR
	Endif
	
	//-- Gera a verba de provis�o PLR
	fGeraVerba("979",nValorPLR,nAvosBonif)
	nAux	:= If(lJaneiro,0,fBuscaAcm("979",,MonthSub( _dDtFimBon , 1 ),MonthSub( _dDtFimBon , 1 ),"V"))
	If nAux < nValorPLR
		fGeraVerba("980",Round(nValorPLR-nAux,2),nAvosBonif)
	Else
		//-- Tratamento de valores negativos
		fGeraVerba("980",0.01,nAvosBonif)
		nPos	:= fLocaliapd("980")
		aPd[nPos,5]	:= Round(nValorPLR-nAux,2)
	Endif

Endif

//-- Apura��o do valor do Pr�mio
If lPremio

	//-- Retirar esta distribui��o ap�s a cria��o dos novos campos
/*
	If cEmpAnt == "02"
		If SRA->RA_MAT $"000531,000190,000197,000648,000604,000631,000646,000532,000046,000640,000602,000210"
			nBasePrem	:= 1.50
		ElseIf SRA->RA_MAT $"000687"
			nBasePrem	:= 3.00
		Endif
	ElseIf cEmpAnt == "03"
		If SRA->RA_MAT $"000011"
			nBasePrem	:= 1.50
		Endif
	ElseIf cEmpAnt == "04"
		If SRA->RA_MAT $"000013,000001,000005"
			nBasePrem	:= 1.50
		Endif
	ElseIf cEmpAnt == "05"
		If SRA->RA_MAT $"000007"
			nBasePrem	:= 1.50
		Endif
	Endif
*/
	//-- Busca Percentual de Pr�mio a partir do c�digo da fun��o
	If ( nPos := Ascan(aPremio,{|X| SRA->RA_CODFUNC $X[7]} ) ) > 0 .Or. ( nPos := Ascan(aPremio,{|X| Empty(X[7])} ) ) > 0 
		nBasePrem	:= aPremio[nPos,6]
	Endif
	
	//-- Carrega percentuais de encargos da empresa
	If !fInssEmp(SRA->RA_FILIAL,@aInssEmp_,,CPERIODO)
		Return                            
	Endif                                 

	//-- Calcula o valor do Pr�mio
	If nBasePrem > 0
		nValorPrem	:= Round(nBasePrem*SALMES/12*nAvosBonif,2)
	Endif
	
	//-- Pr�mio - PLR
	If lPlr
		If nValorPrem >= nValorGlob
			nValorPrem	:= nValorPrem - nValorGlob
		Else
			nValorPrem	:= 0
		Endif
	Endif
	
	//-[1] % Empresa    - [2] % Terceiros    - [3] % Acidente    - [4] % Fgts
	//-- Gera a verba de provis�o de Pr�mio
	fGeraVerba("986",nValorPrem,nAvosBonif)
	//-- Encargos de Inss
	nVlPreInss:= Round(nValorPrem*(aInssEmp_[1,1]+aInssEmp_[2,1]+aInssEmp_[3,1]),2)
	fGeraVerba("987",nVlPreInss,nAvosBonif)
	//-- Encargos de FGTS
	nVlPreFgts:= Round(nValorPrem*aInssEmp_[4,1],2)
	fGeraVerba("988",nVlPreFgts,nAvosBonif)
	//-- 1/12 F�rias sobre Pr�mio
	nVlPreFer := Round((nValorPrem+fBuscaPd("987,988","V"))/12*1.3333,2)
	fGeraVerba("989",nVlPreFer,nAvosBonif)
	//-- 1/12 13o Sal�rio sobre Pr�mio
	nVlPre13o := Round((nValorPrem+fBuscaPd("987,988","V"))/12*1.0000,2)
	fGeraVerba("990",nVlPre13o,nAvosBonif)
	
	//-- Gera a verba de provis�o do m�s / inss / fgts / 1/12 de f�rias e 13o sal�rio
	//-- Provis�o Pr�mio
	nAux	:= If(lJaneiro,0,fBuscaAcm("986",,MonthSub( _dDtFimBon , 1 ),MonthSub( _dDtFimBon , 1 ),"V"))
	If nAux < nValorPrem
		fGeraVerba("981",Round(nValorPrem-nAux,2),nAvosBonif)
	Else
		//-- Tratamento de valores negativos
		fGeraVerba("981",0.01,nAvosBonif)
		nPos	:= fLocaliapd("981")
		aPd[nPos,5]	:= Round(nValorPrem-nAux,2)
	Endif

	//-- Encargos de Inss
	nAux	:= If(lJaneiro,0,fBuscaAcm("987",,MonthSub( _dDtFimBon , 1 ),MonthSub( _dDtFimBon , 1 ),"V"))
	If nAux < nVlPreInss
		fGeraVerba("982",Round(nVlPreInss-nAux,2),nAvosBonif)
	Else
		//-- Tratamento de valores negativos
		fGeraVerba("982",0.01,nAvosBonif)
		nPos	:= fLocaliapd("982")
		aPd[nPos,5]	:= Round(nVlPreInss-nAux,2)
	Endif

	//-- Encargos Fgts
	nAux	:= If(lJaneiro,0,fBuscaAcm("988",,MonthSub( _dDtFimBon , 1 ),MonthSub( _dDtFimBon , 1 ),"V"))
	If nAux < nVlPreFgts
		fGeraVerba("983",Round(nVlPreFgts-nAux,2),nAvosBonif)
	Else
		//-- Tratamento de valores negativos
		fGeraVerba("983",0.01,nAvosBonif)
		nPos	:= fLocaliapd("983")
		aPd[nPos,5]	:= Round(nVlPreFgts-nAux,2)
	Endif

	//-- 1/12 F�rias sobre Pr�mio
	nAux	:= If(lJaneiro,0,fBuscaAcm("989",,MonthSub( _dDtFimBon , 1 ),MonthSub( _dDtFimBon , 1 ),"V"))
	If nAux < nVlPreFer
		fGeraVerba("984",Round(nVlPreFer-nAux,2),nAvosBonif)
	Else
		//-- Tratamento de valores negativos
		fGeraVerba("984",0.01,nAvosBonif)
		nPos	:= fLocaliapd("984")
		aPd[nPos,5]	:= Round(nVlPreFer-nAux,2)
	Endif

	//-- 1/12 13o Sal�rio sobre Pr�mio
	nAux	:= If(lJaneiro,0,fBuscaAcm("990",,MonthSub( _dDtFimBon , 1 ),MonthSub( _dDtFimBon , 1 ),"V"))
	If nAux < nVlPre13o
		fGeraVerba("985",Round(nVlPre13o-nAux,2),nAvosBonif)
	Else
		//-- Tratamento de valores negativos
		fGeraVerba("985",0.01,nAvosBonif)
		nPos	:= fLocaliapd("985")
		aPd[nPos,5]	:= Round(nVlPre13o-nAux,2)
	Endif

Endif

Return(0)
