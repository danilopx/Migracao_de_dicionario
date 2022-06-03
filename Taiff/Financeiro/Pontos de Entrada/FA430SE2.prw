#Include 'Protheus.ch'
/*
-----------------------------------------------------------------------------------------------------
Arquivo...:	FA430SE2.PRW
Descricao.:	Ponto de Entrada executado na baixa dos tituos em "retorno da comunicação bancaria"  
Autor.....:	Carlos Torres  													
Data......:	31/03/2014
Observaçao:   Este ponto de entrada posiciona a SE2 desconsiderando o padrão do PROTHEUS
				No arquivo de retorno o numero do titulo está em branco ocorrendo baixa indevida
-----------------------------------------------------------------------------------------------------
*/

User Function FA430SE2()
Local _aParam  := PARAMIXB[1]
Local _cNumTit := _aParam[1] //cNumTit
Local _cChave	 := ''
Local _lNewIndice:= .F.
//Local lOk := .F.

If !Empty(_cNumTit)
	
	_lNewIndice := FaVerInd()
	
	If _lNewIndice .and. !Empty(xFilial("SE2"))
		//Busca por IDCNAB sem filial no indice
		dbSelectArea("SE2")
		dbSetOrder(13)
		_cChave := Substr(_cNumTit,1,10)
	Else
		//Busca por IDCNAB com filial no indice
		dbSelectArea("SE2")
		dbSetOrder(11)
		_cChave := xFilial("SE2")+Substr(_cNumTit,1,10)
	Endif
	
	// Busca pelo IdCnab
	MsSeek(_cChave)
Else
	Conout("FA430SE2 - O arquivo de retorno apresenta não confirmadade para o titulo: |"+_aParam[1]+"| valor pago: " + str(_aParam[8],12,2))
	dbSelectArea("SE2")
	DbGoBottom()
	DbSkip()	
EndIf
Return
