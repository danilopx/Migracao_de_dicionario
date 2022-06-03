#Include 'Protheus.ch'
/*
=================================================================================
=================================================================================
||   Arquivo:	MA260D3F.prw
=================================================================================
||   Funcao: MA260D3F
=================================================================================
||   Descricao
||-------------------------------------------------------------------------------
|| Apos gravacao dos registros de movimento na inclusao de uma transferencia 
|| fora do controle de transação
|| Necessário para validar o processo de CROSS DOCKING
|| 
|| 
=================================================================================
=================================================================================
||   Autor: 
||   Data: 15/12/2015
=================================================================================
=================================================================================
*/

User Function MA260D3F()
Local lRetorno := PARAMIXB[1] 
LOCAL CSD3GLB	:= "b" + ALLTRIM(UsrRetName()) + cValtoChar(THREADID())
Local ASD3RET	:= {}
	
	AADD(ASD3RET,{lRetorno})
	
	PUTGLBVARS(CSD3GLB, ASD3RET )
	conout( "MA260D3F - retorno do PARAMIXB[1] " )
	conout( lRetorno )

Return (NIL)

