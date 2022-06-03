/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³A410CONS  ºAutor  ³VETI FSW            º Data ³  09/19/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Ponto de Entrada para a adição de botões no pedido de venda º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ProArt                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function A410CONS()
Local aUsrBot := {}

//Executa somente na empresa e filial selecionados
If (cEmpAnt+cFilAnt) $ SuperGetMV("MV__SEPA01",.F.,"") //Rotinas de Expedicao Customizadas
	aadd(aUsrBot,{"BMPVISUAL16",  {|| U_PRTC003V() },                "Consulta Faltas", "Faltas"})
EndIf

If (cEmpAnt+cFilAnt) $ SuperGetMV("MV__MULT06",.F.,"") //Rotinas de Avaliacao de Credito
	If VerSenha(136) //verifica se o usuario logado possui acesso 136-Lib.Pedido Venda
		aadd(aUsrBot,{"SIMULACAO",  {|| U_FINMI001(SC5->C5_CLIENTE, SC5->C5_LOJACLI, "S") },               "Avalia Crédito", "Credito"})
	EndIf
EndIf

If cempant == "04"
	Aadd(aUsrBot	, {'PEDIDO',{||U_FATRD001()},"Estrutura do OP <CTRL+E> "})
	SET KEY 5 TO U_FATRD001()
Endif
Return(aUsrBot)

