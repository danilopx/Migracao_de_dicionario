#Include "RwMake.ch"

/*
=================================================================================
=================================================================================
||   Arquivo:	IMPMEMO.PRW
=================================================================================
||   Funcao: 	IMPMEMO
=================================================================================
||   Descricao
||-------------------------------------------------------------------------------
|| 		Funcao que realiza a impressao de campos Memo em relaotorios graficos
|| 	com quebra de linha. 
|| 
=================================================================================
=================================================================================
||	 Parametros
=================================================================================
|| OPRINT     || Objeto Print
|| _CMEMO     || Variavel tipo Caracter com o conteudo que sera impresso
|| _NTAMANHO  || Tamanho da linha antes da quebra
|| _NLIN      || Posicao da Linha
|| _NCOL      || Posicao da Coluna
|| OFNT       || Objeto Fonte
=================================================================================
=================================================================================
||   Autor:	Edson Hornberger
||   Data:	06/05/2014
=================================================================================
=================================================================================
*/

User Function IMPMEMO(oPrint,_cMEMO,_nTAMANHO,_nLIN,_nCOL,oFnt)

	Local i := 0

	Private ENTER 		:= CHR(13)
	Private ESPACO  	:= CHR(32)
	Private nPosENTER
	Private nPosSPACE
	Private nPosINI		:= 1
	Private nLinhas

	nLinhas := MlCount(_cMEMO,_nTAMANHO)

	For i := 1 to nLinhas
		nPosENTER := AT(ENTER,SubStr(_cMEMO,nPosINI,_nTAMANHO))
		nPosSPACE := RAT(ESPACO,SubStr(_cMEMO,nPosINI,_nTAMANHO))
		If nPosENTER < _nTAMANHO .And. nPosENTER > 0
			oPrint:Say		(_nLIN,_nCOL,SubStr(_cMEMO,nPosINI,(nPosENTER - 1)),oFnt)
			_nLIN += 012
			nPosINI := nPosINI + nPosENTER + 1
			Loop
		EndIf
		If nPosSPACE < _nTAMANHO .And. SubStr(_cMEMO,(Iif((nPosINI+_nTAMANHO)>Len(_cMEMO),Len(_cMEMO)+1,(nPosINI+_nTAMANHO))),1) <> ""
			oPrint:Say 		(_nLIN , _nCOL, SubStr(_cMEMO,nPosINI,nPosSPACE),oFnt)
			_nLIN += 012
			nPosINI := nPosINI + nPosSPACE
			Loop
		Else
			oPrint:Say		(_nLIN , _nCOL, SubStr(_cMEMO,nPosINI,_nTAMANHO),oFnt)
			_nLIN += 012
			nPosINI := nPosINI + _nTAMANHO
		EndIf
	Next i
	_nLIN -= 012

Return(_nLIN)