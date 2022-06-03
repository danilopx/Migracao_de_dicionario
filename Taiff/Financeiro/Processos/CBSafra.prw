#Include "Protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CBSafra   ºAutor  ³TOTVS ABM           º Data ³17/05/2011   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Trata o codigo de barras do titulo a pagar na geracao de    º±±
±±º          ³cnab Safra.                                                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function CBSafra()

Local aAreaSE2     := SE2->( GetArea() )
Local cRet         := ""
Local cBanco       := Substr(SE2->E2_CODBAR,1,3)
Local cMoeda       := Substr(SE2->E2_CODBAR,4,1)
Local cDac         := Substr(SE2->E2_CODBAR,33,1)
Local dDtRef       := CtoD("07/10/97")
Local cVencto      := Strzero((SE2->E2_VENCTO-dDtRef),4,0)
Local cSaldo       := Strzero((SE2->E2_SALDO*100),10,0)
Local cCampoLivre  := Substr(SE2->E2_CODBAR,5,5) + Substr(SE2->E2_CODBAR,11,10) + Substr(SE2->E2_CODBAR,22,10)
Local cSequenc     := "" 
Local nSoma        := 0 
Local cDac2        := ""
Local nCntFor      := 0

cRet := cBanco+cMoeda+cDac+cVencto+cSaldo+cCampolivre

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Calculo do DAC - digito de auto conferencia. Em 25/03/03 o banco Safra  ³
//³passou a validar este digito, fazendo com que boletos pre-impressos fos-³
//³sem rejeitados no envio das remessas.                                   ³
//³O calculo do DAC na 5a. posicao do codigo de barras sera calculado pelo ³
//³modulo 11, multiplicando-se cada algarismo, pela sequencia de 2 a 9, po-³
//³sicionados da direita para a esquerda.                                  ³
//³A 5a posicao da esquerda para a direita nao pode ser considerada.       ³
//³- Somar o resultado da multiplicacao de cada algarismo do codigo de bar-³
//³ras pela sequencia correspondente.                                      ³
//³- Dividir o total da soma por 11.                                       ³
//³- Subtrair a sobra de 11. Ex: sobra=4 ---> 11 - 4 = 7 (DAC 7)           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cSequenc := "4329 876543298765432987654329876543298765432"  // Sequencia de 2 a 9, da direita para a esquerda
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³- Neste momento, cRet contem o codigo de barras no formato que deve     ³
//³ser transmitido, com 44 posicoes. Sera feito o calculo do DAC para ele. ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nSoma := 0
For nCntFor := Len(cSequenc) To 1 Step -1   // De 44 a 1, deve pular a posicao 5
   If ! nCntFor==5 // Pula a posicao 5
      nSoma += ( Val(Substr(cSequenc,nCntFor,1)) * Val(Substr(cRet,nCntFor,1)) )
   EndIf
Next nCntFor
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³- Se o resto da divisao da Soma por 11 for igual a 0, 1 ou 10, o DAC    ³
//³sera considerado sempre como 1.                                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If Mod(nSoma,11)==0 .OR. Mod(nSoma,11)==1 .OR. Mod(nSoma,11)==10
   cDac2 := "1"
Else
   cDac2 := Str( (11-Mod(nSoma,11)), 1, 0 )
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Codigo de barras com o DAC calculado                                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cRet := Substr(cRet,1,4)+cDac2+Substr(cRet,6,39)

RestArea( aAreaSE2 )
Return( cRet )