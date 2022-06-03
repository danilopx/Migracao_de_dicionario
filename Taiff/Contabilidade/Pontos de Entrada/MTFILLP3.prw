#INCLUDE "Protheus.ch"
#INCLUDE "Topconn.ch"
         
//+--------------------------------------------------------------------------------------------------------------
//| FUNCAO: MTFILLP3                                    AUTOR: CARLOS ALDAY TORRES           DATA: 25/10/2012   |
//+--------------------------------------------------------------------------------------------------------------
//| DESCRICAO: Ponto de entrada executado na geração do arquivo de trabalho resultante do processamento dos 
//|				registros relacionados ao poder de terceiros (SB6,SD1,SD2). Este ponto de entrada é executado 
//|				para cada registro da tabela SB6.
//| OBSERVAÇÃO: Função base portal TDN
//+--------------------------------------------------------------------------------------------------------------

User Function MTFILLP3
Local ExpC2		:= PARAMIXB[2]
Local ExpC4		:= PARAMIXB[4]
Local ExpC6		:= PARAMIXB[6]
  
Local nPosQtd	:= aScan(aHeader,{|x| AllTrim(x[2])=="D1_QUANT"})
Local cAtiva	:= GetNewPar("TF_ATIVAP3","N")
//
// Este modelo somente se aplica quando é feito pagamento de OP na Nfe de entrada 
// Exemplo a NFe de entrada da STILLCRAFT a entrada total é de 500 pças porem fazem lançamentos parciais para acompanhar cada OP.
//
If cAtiva="S"
	If nPosQtd != 0
		If ExpC6 == "E" .And. (ExpC4)->D2_PRCVEN <> 0  .AND. (ExpC4)->B6_SALDO!=aCOLS[N,nPosQtd] .AND. aCOLS[N,nPosQtd]!=0 .and. SF4->F4_PODER3="D"
			(ExpC2)->B6_PRCVEN := (ExpC4)->D2_PRCVEN
			(ExpC2)->B6_PRUNIT := (ExpC4)->D2_PRCVEN
		EndIf
	EndIf
EndIf
Return NIL
