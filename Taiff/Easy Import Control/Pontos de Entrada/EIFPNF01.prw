#INCLUDE 'TOPCONN.CH'
#INCLUDE 'PROTHEUS.CH'
#DEFINE ENTER CHR(13) + CHR(10)

/*
=================================================================================
=================================================================================
||   Arquivo:	EIFPNF01.PRW
=================================================================================
||   Funcao: 	EIFPNF01
=================================================================================
||   Descricao
||-------------------------------------------------------------------------------
|| 		Ponto de Entrada ao final da Geracao da NF de Importacao.
|| 		Sera utilizado para correcao do campo D1_SERIE que, por validacao de 
|| 	campo no SX3, esta sendo preenchido com Zeros a esquerda, ocasionando erros
|| 	nos processos de Classificacao e Exclusao da NF.
|| 
=================================================================================
=================================================================================
||   Autor:	Edson Hornberger 
||   Data:	08/04/2015
=================================================================================
=================================================================================
*/

USER FUNCTION EIFPNF01()

LOCAL AAREA 	:= GETAREA()
LOCAL CNOTA		:= SF1->F1_DOC
LOCAL CSERIE	:= SF1->F1_SERIE
LOCAL CFORNECE	:= SF1->F1_FORNECE
LOCAL CLOJA		:= SF1->F1_LOJA
LOCAL CQUERY	:= ""

CQUERY := "UPDATE" 										+ ENTER
CQUERY += "	" + RETSQLNAME("SD1") 						+ ENTER
CQUERY += "SET" 										+ ENTER
CQUERY += "	D1_SERIE = '" + CSERIE + "'" 				+ ENTER
CQUERY += "WHERE" 										+ ENTER
CQUERY += "	D1_FILIAL = '" + XFILIAL("SD1") + "' AND" 	+ ENTER
CQUERY += "	D1_DOC = '" + CNOTA + "' AND" 				+ ENTER
CQUERY += "	D1_FORNECE = '" + CFORNECE + "' AND" 		+ ENTER
CQUERY += "	D1_LOJA = '" + CLOJA + "' AND" 				+ ENTER
CQUERY += "	D_E_L_E_T_ = ''"

IF TCSQLEXEC(CQUERY) < 0 
	
	MSGALERT("Erro na Execução da Query no Banco de Dados!","EIFPNF01")
	
ENDIF 	

RESTAREA(AAREA)

RETURN