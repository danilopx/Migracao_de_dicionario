#Include "PROTHEUS.CH"
#Include "TOPCONN.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CALFRETE  ºAutor  ³Eduardo Barbosa     º Data ³  01/10/03   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ CALCULO DO VALOR DE FRETE DE ACORDO COM A TABELA FRETE     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºObs.      ³ Deve estar Posicinado na tabela de Frete PAX               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³  DeltaDecisao                                              º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function CALFRETE(_nValor,_nPeso,_cTxEsp,_nAliqIcm,_lTDE)
	Local   _nElem		:= 0
	Private _nValBase	:= _nValor
	Private _nPesBase	:= _nPeso
	Private _nICMOutr   := 0
	Private _lDistrICM  := .F.
	Private _lEmbutICM  := .T.

	If _cTxEsp == NIL   // Identifica se Deve Considerar taxa Especifica Para a Regiao
		_cTxEsp := "N"   // Exemplo : Para determinada regiao, alem do Advalore existe taxa para a Travessia de Balsa
	Endif
	DEFAULT _nAliqIcm := 1
	DEFAULT _lTDE     := .F.

	if _nAliqIcm == 0
		_nAliqIcm := 1
	endif

	_aArea	:= GetArea()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Selecao da Tabela de Frete       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	DbSelectArea("PAX")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Regras Para Arredodamento de Peso³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ


// Exemplo
// Peso = 483,85
//--- Resultados
// Arredondamento para Cima := 484
// Arredondamento Para Baixo:= 483
// Arredondamento Fracionado:= 483,85
// Arredondamento Normal := 484

	If PAX->PAX_ARRED	== 'C' // Acima
		_nPesBase	:=	Int(_nPesbase) + 1
	ElseIf PAX->PAX_ARRED	== 'B' // Abaixo
		_nPesBase	:=	Int(_nPesbase)
	ElseIf PAX->PAX_ARRED	== 'F' // Fracionado
		_nPesBase	:=	Round(_nPesbase,2)
	ElseIf Empty(PAX->PAX_ARRED) .OR. PAX->PAX_ARRED == 'N' // Normal
		_nPesBase	:=	Round(_nPesbase,0)
	Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Calculo do Frete                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

// Taxa por Conhecimento
	_nTaxaCto	:= PAX->PAX_TXACTO

// Valor Pedagio // Quando Nao houver fracionamento do Valor de Pedagio , ou seja, quando não existir regra de pedagio por KG
// Exemplo :
// Peso : a cada 100kgs cobra pedagio de R$1,00 logo 350 kg ira cobrar pedagio de R$4,00

	If PAX->PAX_PEDFRA<>'S'
		_nBasePed	:=  _nPesBase / PAX->PAX_PESPED   // EX. 315/100=3,15
		_nIntPed		:= Int(_nBasePed)                                // RETORNO = 3
		If  _nBasePed > _nIntPed                                         // RESULTADO = 0,15
			_nIntPed	:= _nIntPed + 1                                       // O Valor de Pedagio deve ser multiplicado Por Quatro
		Endif
		_nValPeda 	:=	_nIntPed * PAX->PAX_VLRPED
	Else
		// quando existir fracionamento do pedagio.
		// Exemplo :
		// Ate 100kgs valor do pedagio 1,40
		// acima de 100Kgs valor de 0,014 por KG
		_nValPeda	:=	PAX->PAX_VLRPED
		_nBasePed	:=	_nPesBase - PAX->PAX_PESPED
		If _nBasePed > 0
			_nValPeda	:=	_nValPeda + ( _nBasePed * PAX->PAX_PEDEXC)
		Endif
	Endif
	_nValPeda	:=	Round(_nValPeda,2)

// Outras Taxas
	_nOtrTaxa	:=	PAX->PAX_OTRTXA

// Gerenciamento de Risco (GRIS)
	_nPerGris	:=	PAX->PAX_GRIS / 100
	_nValGris	:=	_nValBase * _nPerGris
	If _nValGris < PAX->PAX_GRISMI  // Gris Minimo
		_nValGris:= PAX->PAX_GRISMI
	Endif
	_nValGris	:=	Round(_nValGris,2)

// Taxa Para Percentual Especifico da Regiao ( Exemplo : Frete Fluvial que existe para o Estado do PARA)
	_nValEsp 	:= 0
	If _cTxEsp =="S"
		_nPerEsp:=	PAX->PAX_TXESPE / 100
		_nValEsp:=	_nValBase * _nPerEsp
	Endif
	_nValEsp	:=	Round(_nValEsp,2)

// Ad ValoRem ( Percentual sobre a Nota Fiscal)
	_nPerAdVal	:=	PAX->PAX_ADVALO / 100
	_nAdValore	:=	Round(_nValBase * _nPerAdVal,2)

//Adicionado para tratar o Frete Minimo da Transportadora pajuçara - Anderson Messias em 14/04
	If  _nAdValore < PAX->PAX_FREMIN
		_nAdValore	:=	PAX->PAX_FREMIN
	Endif

// Calculo Por Faixa de KG
	_nVlrPeso	:= 0
	_nPesSobra	:= 0
	For _nElem := 1 To 8   // Oito Faixas - Se necessitar de Mais Faixas deve-se Criar Campo
		_cFaxCamp	:= "PAX->PAX_FAXKG"+ALLTRIM(STR(_nElem))  // Exemplo : PAX->PAX_FAXKG1
		_cVlrCamp	:= "PAX->PAX_VLRKG"+ALLTRIM(STR(_nElem))  // Exemplo : PAX->PAX_VLRKG1
		_nFaxPeso	:= &_cFaxCamp
		If _nFaxPeso == 0
			Exit
		Endif
		_nVlrPeso	:= &_cVlrCamp

		If _nPesBase <= _nFaxPeso         // Quando Nao Passar do Limite de Peso
			_nPesSobra := 0
			Exit
		Else  // Se Passar do Limite de Peso
			_nPesSobra	:= _nPesBase - _nFaxPeso // Guardar a Ultima opcao de Peso
		Endif
	Next
	If _nVlrPeso > 0 .AND. _nPesSobra > 0
		_nValSobra	:= _nPesSobra * PAX->PAX_VLADKG // Valor Adicional Por Kilo
		_nVlrPeso	:= _nVlrPeso + _nValSobra
	Endif
	_nVlrPeso	:= Round(_nVlrPeso,2)

// Calculo Ad Valorem Adicional Por KG e Taxa Fixa por Kg ( Quando Exceder)
	_nAdvPeso	:= 0
	_nTxPeso	:= 0
	If _nPesSobra > 0
		_nPerAdPeso	:= PAX->PAX_PRADKG / 100
		_nAdvPeso	:= _nValBase * _nPerAdPeso
		_nTxPeso	:= PAX->PAX_TXFXKG
	Endif
	_nTxPeso	:=	Round(_nTxPeso,2)

// Aplicacao do Frete Por Tonelagem
	_nFreteTol	:= 0
	If PAX->PAX_FRTONE  > 0 .AND. _nPesSobra > 0
		_nBaseTol		:= PAX->PAX_FRTONE / 1000
		_nFreteTol 	:= Round(_nPesBase * _nBaseTol,2)
		_nValFrete	:= _nFreteTol
		_nTxPeso		:= 0
		_nVlrPeso		:= 0
	Else
		// Calculo do Valor Total do Frete
		_nValFrete	:= _nVlrPeso + _nAdvPeso + _nTxPeso  + _nValEsp
	Endif

// Analise das Taxas
/// Verifica se as taxas Compoem o Frete Minimo

	_nTaxas := 0
	If PAX->PAX_OTMIN1 == "N" // Frete Minimo Nao Possui Pedagio
		_nTaxas := _nTaxas + _nValPeda
	Else
		_nValFrete := _nValFrete + _nValPeda
	Endif

	If PAX->PAX_OTMIN2 == "N" // Adicionar Valor da Taxa Por Conhecimento ao Frete Minimo
		_nTaxas := _nTaxas + _nTaxaCto
	Else
		_nValFrete := _nValFrete + _nTaxaCto
	Endif

	If PAX->PAX_OTMIN3 == "N" // Adicionar Valor de Outras Taxas ao Frete Minimo
		_nTaxas := _nTaxas + _nOtrTaxa
	Else
		_nValFrete := _nValFrete + _nOtrTaxa
	Endif

	If PAX->PAX_OTMIN4 == "N" // Adicionar Valor do GRIS ao Frete Minimo
		_nTaxas := _nTaxas + _nValGris
	Else
		_nValFrete := _nValFrete + _nValGris
	Endif

	If PAX->PAX_OTMIN5 == "N" // Adicionar Valor de AdValorem
		_nTaxas := _nTaxas + _nAdValore
	Else
		_nValFrete := _nValFrete + _nAdValore
	Endif

//Se o peso exceder um peso minimo , cobrar taxa unica - Anderson Messias - 13/04/2011
	if _nPesBase > PAX->PAX_TXPESO
		_nTaxas   := _nTaxas + PAX->PAX_TXUNIC
		_nTaxaCto := _nTaxaCto + PAX->PAX_TXUNIC
	endif

//Tratamento para T.E.D
	_nValTDE := 0
	if _lTDE
		_nValTDE := Round(_nValFrete * (PAX->PAX_PERTED/100),2)

		//Valor Minimo
		If _nValTDE < PAX->PAX_MINTED
			_nValTDE := PAX->PAX_MINTED
		Endif
		//Valor Maximo
		If _nValTDE > PAX->PAX_MAXTED .AND. PAX->PAX_MAXTED > 0
			_nValTDE := PAX->PAX_MAXTED
		Endif
		_nTaxas := _nTaxas + _nValTDE
	endif

//Tratamento para T.R.T
	_nValTRT := 0
	_nValTRT := Round(_nValFrete * (PAX->PAX_PERTRT/100),2)
	If _nValTRT < PAX->PAX_MINTRT
		_nValTRT := PAX->PAX_MINTRT
	Endif
	_nTaxas := _nTaxas + _nValTRT

	If  _nValFrete < PAX->PAX_FREMIN + _nValEsp
		_nValFrete	:=	PAX->PAX_FREMIN + _nTaxas
	Else
		_nValFrete	:= _nValFrete + _nTaxas
	Endif

	_nValFrete 	:= Round(_nValFrete,2)
// Tratamento Para Reentrega
	If PAX->PAX_OTMIN2 == 'N' // Subtrair Valor do Conhecimento do Frete
		_nValReent	:= ((_nValfrete - _nTaxaCto ) * (PAX->PAX_REENTR/100 ) )
		If _nValReent < PAX->PAX_FREMIN
			_nValReent := PAX->PAX_FREMIN
		Endif
		If _nValReent < PAX->PAX_MINREE
			_nValReent := PAX->PAX_MINREE
		Endif
		_nValReent	:= _nValReent + _nTaxaCto
	Else
		_nValReent	:= (_nValfrete) * (PAX->PAX_REENTR/100 )
		If _nValReent < PAX->PAX_FREMIN
			_nValReent := PAX->PAX_FREMIN
		Endif
		If _nValReent < PAX->PAX_MINREE
			_nValReent := PAX->PAX_MINREE
		Endif
	Endif

// Tratamento Para Devolucoes
	If PAX->PAX_OTMIN2 == 'N' // Subtrair Valor do Conhecimento do Frete
		_nValDev	:= ((_nValfrete - _nTaxaCto  ) * (PAX->PAX_DEVOLU/100 ) )
		If _nValDev < PAX->PAX_FREMIN
			_nValDev := PAX->PAX_FREMIN
		Endif
		_nValDev	:= _nValDev + _nTaxaCto
	Else
		_nValDev	:= (_nValfrete) * (PAX->PAX_DEVOLU/100 )
		If _nValDev < PAX->PAX_FREMIN
			_nValDev := PAX->PAX_FREMIN
		Endif
	Endif

	if PAX->PAX_TPICM <> "4" //Se nao for Apenas destacar o ICMS
		if PAX->PAX_TPICM == "3" //Nao embuti o ICMS
			_lDistrICM := .F.
			_lEmbutICM := .F.
		elseif PAX->PAX_TPICM == "2" //Distribui o valor do ICMS
			_lDistrICM := .T.
			_lEmbutICM := .T.
		else  //Embuti o ICMS e gera valor de outros com o valor do icms embutido
			_lDistrICM := .F.
			_lEmbutICM := .T.
		endif

		//Gerando valor de outros - ICMS embutido no campo Outros
		if !_lDistrICM

			//Calcula ICM com ICMS Embutido
			if _lEmbutICM
				_nICMEmb    := (_nValFrete/_nAliqIcm) - _nValFrete
			else
				//Calcula ICM sem ICMS Embutido
				_nICMEmb    := (_nValFrete*(100-(_nAliqIcm*100)))/100
				_nValFrete  := _nValFrete + _nICMEmb
			endif

			_nOtrTaxa   := _nOtrTaxa + _nICMEmb
		else
			//Distribuindo ICMS embutido nos Valores Calculados - Transp Favorita
			_nTaxaCto	:= Round(_nTaxaCto  / _nAliqIcm,2)
			_nValPeda	:= Round(_nValPeda  / _nAliqIcm,2)
			_nOtrTaxa	:= Round(_nOtrTaxa  / _nAliqIcm,2)
			_nValGris	:= Round(_nValGris  / _nAliqIcm,2)
			_nAdValore	:= Round(_nAdValore / _nAliqIcm,2)
			_nVlrPeso	:= Round(_nVlrPeso  / _nAliqIcm,2)
			_nAdvPeso	:= Round(_nAdvPeso  / _nAliqIcm,2)
			_nTxPeso	:= Round(_nTxPeso   / _nAliqIcm,2)
			_nFreteTol  := Round(_nFreteTol / _nAliqIcm,2)
			_nValTDE	:= Round(_nValTDE 	/ _nAliqIcm,2)
			_nValTRT	:= Round(_nValTRT 	/ _nAliqIcm,2)
		endif
	else
		_lDistrICM := .F.
		_lEmbutICM := .F.
		_nValFrete := Round(_nValFrete,2)
		_nValReent := Round(_nValReent,2)
		_nValDev   := Round(_nValDev  ,2)
	endif

//Tratamento ICMS
	if _lEmbutICM
		_nValFrete := Round(_nValFrete/_nAliqIcm,2)
		_nValReent := Round(_nValReent/_nAliqIcm,2)
		_nValDev   := Round(_nValDev/0.88,2)
	endif

	_aRet	:= {}
	AADD(_aRet,_nTaxaCto)  // Taxa Por Conhecimento
	AADD(_aRet,_nValPeda)  // Valor do Pedagio
	AADD(_aRet,_nOtrTaxa)  // Outras Taxas
	AADD(_aRet,_nValGris)  // Valor Do Gris
	AADD(_aRet,_nAdValore) // Valor do Advalorem
	AADD(_aRet,_nVlrPeso)  // Valor Frete Peso
	AADD(_aRet,_nAdvPeso)  // AdValorem Por Peso Adicional
	AADD(_aRet,_nTxPeso)   // Taxa Fixa por peso Adicional
	AADD(_aRet,_nValFrete) // Valor do Frete
	AADD(_aRet,_nFreteTol) // Valor do Frete Por Tonelagem
	AADD(_aRet,_nValReent) // Valor do Frete de Reentrega
	AADD(_aRet,_nValDev)   // Valor do Frete De Devolucao
	AADD(_aRet,_nValTDE)   // Valor do T.E.D ( Taxa de Dificuldade de Entrega )
	AADD(_aRet,_nValTRT)   // Valor do T.R.T ( Taxa de Restricao ao Transito )
	AADD(_aRet,_nPesBase)  // Peso Utilizado no calculo do Frete

Return(_aRet)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³SELEFRETE ºAutor  ³Eduardo Barbosa     º Data ³  01/10/03   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Posiciona Na Tabela de frete de acordo com Parametros      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico DeltaDecisao                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function SeleFrete(_nValDoc,_nPesDoc,_cEst,_cCep,_cTpCalc,_cCodTra,_dEmissao,_lTDE,_lCalcPeso,_lDevol)

// **** Parametros ******
// Valor do Documento
// Peso dos Produtos
// Estado
// Cep
// Tipo de Calculo -> N=Normal, C=Carreta e F= Veiculo Fechado
// Transportador -> Se nao for passado ira Calcular Frete de Todos os Transportadores que atendem a Regiao
// Emissao do Conhecimento
// Taxa de Dificuldade de entrega
// Calcula Peso - Verifica se deve multiplicar o Peso enviado ( Peso Bruto ) X o Fator de M3 da transportadora

	Local _lTransp	:= .T.
	Local _nReg		:= 0
	Local _nPesoAtu := _nPesDoc

	DEFAULT _lCalcPeso := .F.
	DEFAULT _lDevol    := .F.

	If _cCodTra == NIL
		_lTransp := .F.
	Endif
	If _dEmissao == NIL
		_dEmissao := dDataBase
	Endif

	_aArea	:= GetArea()
	_aRetorno:= {}

	_nIcms	:= 0.88
	If _cEst $ Getmv("MV_NORTE")
		_nIcms := 0.93
	Endif

	If _lTransp       // Localiza a Tabela de Frete do Transportador
		DbSelectArea("PAX")
		DbSetorder(1)
		DbSeek(xFilial("PAX")+_cCodTra+_cEst,.F.)
		_lContinua	:=  .T.
		_nMVICMPAD := SUPERGETMV("MV_ICMPAD",,12)
		While ! PAX->(Eof()) .AND. PAX->(PAX_FILIAL+PAX_CODTRA+PAX_EST) = xFilial("PAX") + _cCodTra + _cEst .AND. _lContinua
			// Valida a Data de Vigencia da Tabela
			If PAX->PAX_VIGINI > _dEmissao .OR. PAX->PAX_FIMVIG < _dEmissao
				PAX->(DbSkip())
				Loop
			Endif
			// Valida o Tipo de Calculo Sendo N=Normal, C=Carreta e F= Veiculo Fechado
			If PAX->PAX_TIPANA <> _cTpCalc
				PAX->(DbSkip())
				Loop
			Endif
			//Verificando se tabela tem % ICMS Diferenciado - Anderson Messias - 13/04/2011
			if PAX->PAX_PERICM > 0
				_nIcms	:= (100 - PAX->PAX_PERICM) / 100
			endif
			//Verificando se devo processar PesoBruto X Fator da transportadora para gerar peso Cubado
			if _lCalcPeso
				if PAX->PAX_FATM3 <> 0
					_nPesoAtu := _nPesDoc * PAX->PAX_FATM3
				endif
			endif
			//Se For devolução - aplica o icms do destinatario que se encontra no MV_ICMPAD
			if _lDevol
				_nIcms	:= (100 - _nMVICMPAD) / 100
			endif
			// Procura Pela Regiao Principal Do Estado
			DbSelectArea("PAZ")
			DbSetOrder(1)
			DbSeek(xFilial("PAZ")+PAX->PAX_REGIAO,.F.)
			If (_cCep >= PAZ->PAZ_CEPINI .AND. _cCep <= PAZ->PAZ_CEPFIM)  // Consistencia do CEP
				_aFretes	:= U_CALFRETE(_nValDoc,_nPesoAtu,PAZ->PAZ_TXESPE,_nIcms,_lTDE)
				AADD(_aRetorno,{PAX->PAX_CODTRA,PAX->PAX_CODIGO,_aFretes,PAX->PAX_SEQCON,PAX->PAX_PRZENT,PAX->PAX_REENTR/100,PAX->PAX_DEVOLU/100,PAX->PAX_PERCAJ})
				Exit
			Endif
			// Procura Por Regioes complementares Caso Nao Localize a regiao Principal
			For _nReg	:= 1 to 8
				_cCampo	:= "PAX->PAX_REGCL"+ALLTRIM(STR(_nReg))
				_cReg   := &_cCampo
				DbSelectArea("PAZ")
				DbSetOrder(1)
				DbSeek(xFilial("PAZ")+_cReg,.F.)
				If _cCep >= PAZ->PAZ_CEPINI .AND. _cCep <= PAZ->PAZ_CEPFIM
					_aFretes	:= U_CALFRETE(_nValDoc,_nPesoAtu,PAZ->PAZ_TXESPE,_nIcms,_lTDE)
					AADD(_aRetorno,{PAX->PAX_CODTRA,PAX->PAX_CODIGO,_aFretes,PAX->PAX_SEQCON,PAX->PAX_PRZENT,PAX->PAX_REENTR/100,PAX->PAX_DEVOLU/100,PAX->PAX_PERCAJ})
					_lContinua := .F.
					Exit
				Endif
			Next
			DbSelectArea("PAX")
			PAX->(DbSkip())
		Enddo
	Endif
// Retorno desta Funcao
// _aRet[1][1]  	  // Transportador
// _aRet[1][2]  	  // Codigo do Contrato
// _aRet[1][3]  	  // Valores de Frete Calculado
// _aRet[1][3][1]    // Taxa Por Conhecimento
// _aRet[1][3][2]    // Valor do Pedagio
// _aRet[1][3][3]    // Outras Taxas
// _aRet[1][3][4]    // Valor do Gris
// _aRet[1][3][5]    // Valor do AdValorem
// _aRet[1][3][6]    // Valor do Frete Peso
// _aRet[1][3][7]    // Valor do AdValorem Quando Exceder o Peso
// _aRet[1][3][8]    // Valor da Taxa Quando Exceder o Peso
// _aRet[1][3][9]    // Valor  Total do Frete
// _aRet[1][3][10]   // Valor  Do Frete Por Tonelagem
// _aRet[1][3][11]   // Valor do Frete de Reentrega
// _aRet[1][3][12]   // Valor do Frete De Devolucao
// _aRet[1][3][13]   // Valor do T.E.D ( Taxa de Dificuldade de Entrega )
// _aRet[1][3][14]   // Valor do T.R.T ( Taxa de Restricao ao Transito )
// _aRet[1][3][15]   // Peso Utilizado no calculo do Frete
// _aRet[1][4]  	  // Sequencia do Contrato
// _aRet[1][5]  	  // Prazo de entrega
// _aRet[1][6]  	  // Reentrega
// _aRet[1][7]  	  // Devolução
// _aRet[1][8]  	  // Perc Ajuste Automatico

	RestArea(_aArea)
Return(_aRetorno)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RECALFRE  ºAutor  ³Eduardo Barbosa     º Data ³  07/03/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Recalculo do Frete Por Romaneio                             ±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºObs.      ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico DeltaDecisao                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function RECALFRE()
	cPerg      := "WMSR17"
	PERGUNTE(cPerg,.T.)
	U_ATUFREF2(MV_PAR01,MV_PAR02,"NOTA",'1-A')
Return



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ATUFREF2  ºAutor  ³Eduardo Barbosa     º Data ³  07/03/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Atualizacao do SF2 com o Valor do Frete                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºObs.      ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico DeltaDecisao                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function ATUFREF2(_cDocIni,_cDocFim,_cTipoDoc,_cSerie)

/// Parametros

// _cDocIni			 := Documento Inicial -> Pode ser carga, Romaneio ou Nota Fiscal
// _cDocFim			 := Documento Final -> Pode ser carga, Romaneio ou Nota Fiscal
// Tipo do Documento := CARGA, ROMANEIO ou NOTA FISCAL

// Ordem do Indices no SF2 ->
// Ordem 1 -> Doc + Serie
// Ordem 5 -> Carga
// Ordem 12 -> Romaneio

	Local	_aArea		:= 	GetArea()
	Local	_aAreaF2	:=	{}
	Local 	_aAreaD2	:=  {}
	Local   _aAreaC5	:=  {}
	Local   _nElem		:= 0

	DbSelectArea("SF2")
	_aAreaF2	:= GetArea()
	DbSelectArea("SD2")
	_aAreaD2	:= GetArea()
	DbSelectArea("SC5")
	_aAreaC5	:= GetArea()

	If _cTipoDoc == NIL
		_cTipoDoc := "NOTA"
	Endif
	_cProcura	:=	xFilial("SF2")+_cDocIni
	_cEnquanto	:=	xFilial("SF2")+_cDocFim
	If Upper(_cTipoDoc) == "NOTA"
		_cTipoCalc	:=  "N"
		_cCgc		:= ' '
		_lTDE   	:= .F.
		If SF2->F2_TIPO== 'B'
			DbSelectArea("SA2")
			DbSetOrder(1)
			DbSeek(xFilial("SA2")+SF2->F2_CLIENTE+SF2->F2_LOJA,.F.)
			_cCep		:= SA2->A2_CEP
			_cCgc		:= Left(SA2->A2_CGC,8)
		Else
			DbSelectArea("SA1")
			DbSetOrder(1)
			DbSeek(xFilial("SA1")+SF2->F2_CLIENTE+SF2->F2_LOJA,.F.)
			_cCep	:= SA1->A1_CEP
			_cCgc	:= Left(SA1->A1_CGC,8)
			_lTDE   := SA1->A1_FRETED == "S"
		Endif
		// Averigua se trata-se de Redespacho
		_cEst	:= SF2->F2_EST
		_lCalc	:= .T.
		If ! Empty(SF2->F2_REDESP)
			DbSelectArea("SA4")
			DbSetOrder(1)
			DbSeek(xFilial("SA4")+SF2->F2_REDESP,.F.)
			_cCep	:= SA4->A4_CEP
			_cEst	:= SA4->A4_EST
		Else
			// Ira Considerar apenas Frete CIF
			DbSelectArea("SD2")
			DbSetOrder(3)
			DbSeek(xFilial("SD2")+SF2->F2_DOC+SF2->F2_SERIE,.F.)

			DbSelectArea("SC5")
			DbSetOrder(1)
			DbSeek(xFilial("SC5")+SD2->D2_PEDIDO,.F.)
			// Tratamento do Tipo de Frete
			If SC5->C5_TPFRETE == "C" // CIF
				_lCalc	:= .T.
			Else
				_lCalc	:= .F.
			Endif
		Endif

		// Calculo do Frete
		If _lCalc
			_aCalTrans := U_SeleFrete(SF2->F2_VALBRUT,iif(SF2->F2_PESOCUB>0,SF2->F2_PESOCUB,SF2->F2_PBRUTO),_cEst,_cCep,_cTipoCalc,SF2->F2_TRANSP,SF2->F2_EMISSAO,_lTDE, .T. )
			_nVlrFre	:= 0
			If Len(_aCalTrans) > 0
				_nVlrFre   := _aCalTrans[1,3,09]
			Endif
		/*
		_nIcms	:= 0.88
		//If SF2->F2_EST $ Getmv("MV_NORTE") // VERIFICAR REGRA
		//	_nIcms := 0.93
		//Endif
		*/
			DbSelectArea("SF2")
			If _nVlrFre > 0 .AND. SF2->F2_PRVFRE == 0 //So Atualizo se ainda nao foi gerado provisao de frete
				Reclock("SF2",.F.)
				//SF2->F2_PRVFRE	:= _nVlrFre
				SF2->F2_TIPROMA	:= "N"
				msUnlock()
			Endif
		Endif
	ElseIf Upper(_cTipoDoc) == "ROMANEIO"
		// Efetua Select Com Todas as Notas Fiscais do Romaneio
		cQuery := " SELECT F2_DOC,F2_SERIE,F2_CLIENTE "
		cQuery += " FROM "+RETSQLNAME('SF2')
		cQuery += " WHERE F2_FILIAL='"+xFilial("SF2")+"'"
		cQuery += " AND   F2_ROMANEI >='"+_cDocIni+"'"
		cQuery += " AND   F2_ROMANEI <='"+_cDocFim+"'"
		cQuery += " AND   D_E_L_E_T_=' ' "
		If Sele("TRB") <> 0
			DbSelectArea("TRB")
			DbCloseArea()
		Endif
		TCQUERY cQuery NEW ALIAS "TRB"

		_aNotas 	:= {}
		_nPeso		:= 0
		_nValor		:= 0
		_nQuant		:= 0
		_cEst		:= " "
		_cCep		:= " "
		_cTipoCalc	:= " "
		_cTransp	:= " "
		_dEmissao	:= dDataBase
		_lContinua 	:= .T.
		DbSelectArea("TRB")
		DbGotop()
		While ! Eof()
			DbSelectArea("SF2")
			DbSetOrder(1)
			DbSeek(xFilial("SF2")+TRB->(F2_DOC+F2_SERIE+F2_CLIENTE),.F.)
			AADD(_aNotas,TRB->(F2_DOC+F2_SERIE+F2_CLIENTE))
			// Averigua se Romaneio ja possui Frete Negociado
			If !Empty(SF2->F2_NUMNEG)
				_lContinua	:= .F.
			Endif
			If !Empty(SF2->F2_FATURA)
				_lContinua	:= .F.
			Endif
			If !_lContinua
				Exit
			Endif
			_cTipoCalc	:=  IIF(EMPTY(SF2->F2_TIPROMA),"N", SF2->F2_TIPROMA)
			_lTDE   	:= .F.
			If SF2->F2_TIPO== 'B'
				DbSelectArea("SA2")
				DbSetOrder(1)
				DbSeek(xFilial("SA2")+SF2->F2_CLIENTE+SF2->F2_LOJA,.F.)
				_cCep		:= SA2->A2_CEP
			Else
				DbSelectArea("SA1")
				DbSetOrder(1)
				DbSeek(xFilial("SA1")+SF2->F2_CLIENTE+SF2->F2_LOJA,.F.)
				_cCep	:= SA1->A1_CEP
				_lTDE   := SA1->A1_FRETED == "S"
			Endif
			// Averigua se trata-se de Redespacho
			_cEst	:= SF2->F2_EST
			If ! Empty(SF2->F2_REDESP)
				DbSelectArea("SA4")
				DbSetOrder(1)
				DbSeek(xFilial("SA4")+SF2->F2_REDESP,.F.)
				_cCep	:= SA4->A4_CEP
				_cEst	:= SA4->A4_EST
			Else
				// Ira Considerar apenas Frete CIF
				DbSelectArea("SD2")
				DbSetOrder(3)
				DbSeek(xFilial("SD2")+SF2->F2_DOC+SF2->F2_SERIE,.F.)
				DbSelectArea("SC5")
				DbSetOrder(1)
				DbSeek(xFilial("SC5")+SD2->D2_PEDIDO,.F.)
				// Tratamento do Tipo de Frete
				If SC5->C5_TPFRETE == "F" // FOB
					_lContinua := .F.
					Exit
				Endif
			Endif
			_cTransp	:= SF2->F2_TRANSP
			_dEmissao	:= SF2->F2_EMISSAO
			_nPeso	:=	_nPeso  + iif(SF2->F2_PESOCUB>0,SF2->F2_PESOCUB,SF2->F2_PBRUTO)
			_nValor :=  _nValor + SF2->F2_VALBRUT
			_nQuant:= _nQuant + 1
			DbSelectArea("TRB")
			DbSkip()
		Enddo
		If !_lContinua
			RestArea(_aArea)
			Return
		Endif
		// Calculo do Frete
		_aCalTrans := U_SeleFrete(_nValor,_nPeso,_cEst,_cCep,_cTipoCalc,_cTransp,_dEmissao,_lTDE, .T.)
		_nVlrFre	:= 0
		If Len(_aCalTrans) > 0
			_nVlrFre   := _aCalTrans[1,3,09]
		Endif
		//_nIcms	:= 0.88
		//If SF2->F2_EST $ Getmv("MV_NORTE")
		//	_nIcms := 0.93
		//Endif
		//_nVlrFre := _nVlrFre / _nIcms

		// Posiciona Novamente no primeiro Romaneio Para Fazer Rateio Do Valor do Frete Nas Notas Fiscais
		_nCont		:= 0
		_nSobra		:= _nValorFre
		_cNumNeg    := GETMV("MV_FRENEG")
		For _nElem := 1 To Len(_aNotas)
			IncProc()
			DbSelectArea("SF2")
			DbSetOrder(1)
			DbSeek(xFilial("SF2")+_aNotas[_nElem],.F.)
			_nCont 	:= _nCont + 1
			_nPesoNf	:= Round(iif(SF2->F2_PESOCUB>0,SF2->F2_PESOCUB,SF2->F2_PBRUTO),2)
			_nPerPeso  := Round(_nPesoNF/_nPeso,4)
			If _nQuant == _nCont
				_nFreteNf	:= _nSobra
			Else
				_nFreteNf	:= Round(_nValorFre * _nPerPeso,2)
			Endif
			_nSobra		:= _nSobra - _nFreteNf

			_lTDE   	:= .F.
			// Calculo do Frete Original
			If SF2->F2_TIPO== 'B'
				DbSelectArea("SA2")
				DbSetOrder(1)
				DbSeek(xFilial("SA2")+SF2->F2_CLIENTE+SF2->F2_LOJA,.F.)
				_cCep	:= SA2->A2_CEP
			Else
				DbSelectArea("SA1")
				DbSetOrder(1)
				DbSeek(xFilial("SA1")+SF2->F2_CLIENTE+SF2->F2_LOJA,.F.)
				_cCep	:= SA1->A1_CEP
				_lTDE   := SA1->A1_FRETED == "S"
			Endif
			DbSelectArea("SF2")
			_cTipoCalc	:=  IIF(EMPTY(SF2->F2_TIPROMA),"N", SF2->F2_TIPROMA)
			_nPesProd := iif(SF2->F2_PESOCUB>0,SF2->F2_PESOCUB,SF2->F2_PBRUTO)
			_cTransp  := MV_PAR06
			_aCalTrans:= U_SeleFrete(SF2->F2_VALBRUT,_nPesProd,SF2->F2_EST,_cCep,_cTipoCalc,_cTransp,"ATU",SF2->F2_EMISSAO,_lTDE, .T. )
			_nFreOri	:= 0
			If Len(_aCalTrans) > 0
				_nFreOri   := _aCalTrans[1,3,09]
			Endif
			RecLock("SF2",.F.)
			SF2->F2_FREORI	:= _nFreOri
			SF2->F2_VALCON	:= _nFreteNF
			SF2->F2_NUMNEG	:= _cNumNeg
			MsUnlock()
			DbSkip()
		Next _nElem

		PutMV("MV_FRENEG",Soma1(_cNumNeg,6))

	Endif

	RestArea(_aAreaC5)
	RestArea(_aAreaD2)
	RestArea(_aAreaF2)

	RestArea(_aArea)
Return
