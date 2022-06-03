#INCLUDE "PROTHEUS.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ MA415COR ºAutor  ³Daniel Tadashi Batori                º Data ³  10/12/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ponto de entrada para incluir itens na legenda da tela de orcamento         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                                          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function MA415COR()
	Local _aCores := PARAMIXB

	//-----------------------------------------------------------------------------------------------
//Adicionado por Thiago Comelli em 16/10/2012
//Executa somente na empresa e filial selecionados
	If (cEmpAnt+cFilAnt) $ SuperGetMV("MV__MULT05",.F.,"")
	
//SCJ->CJ_XLIBCR (L=Credito Liberado; P=Credito Pendente; B=Credito Bloqueado; M=Avaliacao Manual)
	_aCores := {{ 'SCJ->CJ_STATUS=="A" .And. SCJ->CJ_XLIBCR="L"' , 'ENABLE' },; 	//Orcamento em Aberto  (verde)
	{ 'SCJ->CJ_STATUS=="B" ' , 'DISABLE' },;	//Orcamento Baixado
	{ 'SCJ->CJ_STATUS=="C"'  , 'BR_PRETO'},;	//Orcamento Cancelado
	{ 'SCJ->CJ_STATUS=="D"' , 'BR_AMARELO'},;	//Orcamento nao Orcado
	{ 'SCJ->CJ_STATUS=="F" ' , 'BR_MARROM' },;	//Orcamento bloqueado
	{ 'SCJ->CJ_STATUS=="A" .And. SCJ->CJ_XLIBCR="P"' , 'V_CRED_AZUL'},; //Orcamento Pendente Cred.
	{ 'SCJ->CJ_STATUS=="A" .And. SCJ->CJ_XLIBCR="B"' , 'V_CRED_VERMELHO'},; //Orcamento Bloqueado Crédito
	{ 'SCJ->CJ_STATUS=="A" .And. SCJ->CJ_XLIBCR="A"' , 'V_CRED_ROSA'},; //Pendente Avaliação Crédito por Alteração de Preco ou Condicao
	{ 'SCJ->CJ_STATUS=="A" .And. SCJ->CJ_XLIBCR="M"' , 'V_CRED_LARANJA' }}	//Orcamento Avaliacao Manual Cred.
	EndIf

	Return _aCores

