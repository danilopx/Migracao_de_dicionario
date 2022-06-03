#include "protheus.ch"



/*/
+---------------------------------------------------------------------------+
| Programa  | DELTAXLS   | Autor | Cristiano Gomes Cunha  | Data | 01/08/08 |
|-----------+---------------------------------------------------------------|
| Descrição | Exporta os dados para um planilha Excel.                      |
|-----------+---------------------------------------------------------------|
| Uso       | Clientes Delta                                                |
+---------------------------------------------------------------------------+
/*/

User Function DELTAXLS(_aHeader,_aCols,_cPathArq)
//    Processa( {|| WinExec( "taskKill  /F /IM EXCEL.EXE" ) }, "Finalizando Excel, Caso esteja Aberto...","Processo em Execução", .T. )
	Processa({||ExpExcel(_aHeader,_aCols,_cPathArq)}, "Exportando Dados")

Return



/*/
	+---------------------------------------------------------------------------+
	| Função    | ExpExcel   | Autor | Cristiano Gomes Cunha  | Data | 01/08/08 |
	|-----------+---------------------------------------------------------------|
	| Descrição | Processa os dados e exibe a planilha.                         |
	|-----------+---------------------------------------------------------------|
	| Uso       | Específico DELTAXLS                                           |
	+---------------------------------------------------------------------------+
/*/

Static Function ExpExcel(_aHeader,_aCols,_cPathArq)

	Local _aStru     := {}
	Local _nx        := 0
	Local _ny		 := 0
	Local _cDirDocs  := MsDocPath()
	Local _cArquivo  := CriaTrab(,.F.)
	Local _cPath     := AllTrim(GetTempPath())
	Local _cNomeArq  := Iif(_cPathArq == Nil,'',_cPathArq)

	If _cPathArq == Nil

		_nQtdReg := Len(_aCols)
		_nRegAtu := 0
		ProcRegua(_nQtdReg)

		For _nx := 1 to Len(_aHeader)
			aAdd(_aStru,{_aHeader[_nx,1],_aHeader[_nx,2],_aHeader[_nx,3],_aHeader[_nx,4]})
		Next _nx

		dbCreate(_cDirDocs + "\" + _cArquivo,_aStru)
		dbUseArea(.T.,,_cDirDocs + "\" + _cArquivo,_cArquivo,.F.,.F.)

		For _nx := 1 to Len(_aCols)
			RecLock(_cArquivo,.T.)
			IncProc("Concluindo ..." + AllTrim(Str((_nRegAtu / _nQtdReg) * 100,5)) + " %")
			_nRegAtu++
			For _ny := 1 to Len(_aHeader)
				(_cArquivo)->&(_aHeader[_ny, 1])	:= _aCols[_nx,_ny]
			Next _ny
			MsUnlock()
		Next _nx
		dbSelectArea(_cArquivo)
		COPY TO &(_cDirDocs + "\" + _cArquivo) VIA 'DBFCDXADS' //Utilizado quando CTREE
		IncProc("Gerando arquivo para o Excel")
		Sleep(3000)
		dbCloseArea()
		_cNomeArq := _cDirDocs + "\" + _cArquivo + ".DBF"
	EndIf

	CpyS2T(_cNomeArq,_cPath,.T.)

	If !ApOleClient('MsExcel')
		MsgStop('MsExcel nao Instalado!!!')
		Return
	EndIf

	IncProc("Abrindo arquivo no Excel")
	Sleep(3000)
	oExcelApp := MsExcel():New()
	oExcelApp:WorkBooks:Open(_cPath + _cArquivo + ".DBF")   // Abre uma planilha
	oExcelApp:Run("Main")
	oExcelApp:SetVisible(.T.)
	oExcelApp:Destroy()
	oExcelApp	:= Nil

Return
