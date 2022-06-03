#INCLUDE 'PROTHEUS.CH'

/*
=================================================================================
=================================================================================
||   Arquivo:	ESTZC4.PRW
=================================================================================
||   Funcao: 	ESTZC4
=================================================================================
||   Descricao
||-------------------------------------------------------------------------------
|| 		Tela para realizacao de Cadastro de Datas de Excecoes, onde n�o devera
|| 	ser rodado processos Agendados (Schedule do Windows no Servidor) chamado
|| 	pelo Software ProcessProtheus.exe (Desenvolvido em VS - VB.NET). 	
|| 
=================================================================================
=================================================================================
||   Autor:	Edson Hornberger
||   Data:	19/05/2014
=================================================================================
=================================================================================
*/

USER FUNCTION ESTZC4()

PRIVATE CCADASTRO := "Cadastro de Excecoes"
PRIVATE AROTINA     := {}

AXCADASTRO("ZC4",CCADASTRO)

RETURN

