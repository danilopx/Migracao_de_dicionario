#INCLUDE "totvs.ch"            
#INCLUDE "PRTOPDEF.CH"
#DEFINE CRLF Chr(13) + Chr(10)

/*
=================================================================================
=================================================================================
||   Arquivo:   RFISA90.PRW
=================================================================================
||   Funcao:    RFISA90
=================================================================================
||   Descricao: Programa de preenchimento de Chaves Eletronicas
=================================================================================
||   Autor:     Marcelo Cardoso Barbosa
||   Data:      30/06/2014
=================================================================================
=================================================================================
*/                                                               

User Function RFISA90

Private _nExecFunc := 2
Private _cTMPSF1   := GetNextAlias()
Private _cFail     := ""
Private _aBotoes   := {OEMTOANSI("Prosseguir"), OEMTOANSI("Cancelar")}
Private _nTamChv   := TamSX3("F1_CHVNFE")[1]
Private _cEleKey   := Space(_nTamChv)
Private _cKey      := ""
Private _cAno      := ""
Private _cMes      := ""
Private _cCGC      := ""
Private _cNot      := ""
Private _cNFn      := ""
Private _cQuery    := ""
Private _nAtuSF3   := 0
Private _nAtuSFT   := 0
Private _aSrcKey   := {}   
Private aObjects   := {}
Private aDados     := {}
Private aCabec     := {}

Aadd(aObjects, {100, 100, .T., .T., .F.}) // Indica dimensoes x e y e indica que redimensiona x e y e assume que retorno sera em linha final coluna final (.F.)
aSize	 :=	MsAdvSize ()
aInfo	 :=	{aSize[1], aSize[2], aSize[3], aSize[4], 3, 3}
aPosObj	 :=	MsObjSize(aInfo,aObjects,.T.)
_nTamChv := TamSX3("F1_CHVNFE")[1]

While _nExecFunc <> 0  

	oDlg := Nil
	
	DEFINE MSDIALOG oDlg TITLE "Atualizador de Chave Eletronica" FROM aSize[7], 0 TO aSize[6], aSize[5] OF oMainWnd PIXEL
	
	@ 015, 015 Say   "Informe a Chave a ser atualizada" SIZE 230, 008 PIXEL OF oDlg
	
	@ 030, 015 Say   "Chave "          SIZE 065, 008 PIXEL OF oDlg
	@ 040, 015 MSGET _cEleKey          SIZE 180, 010 PIXEL OF oDlg VALID AdjChv(_cEleKey, @aDados)
	
	@ 090, 015 BUTTON "&Sair"   SIZE 36,16 PIXEL ACTION (_nExecFunc := 0, oDlg:End() )
	@ 090, 115 BUTTON "&Continuar"  SIZE 36,16 PIXEL ACTION (_nExecFunc := 2, oDlg:End() )
	
	ACTIVATE MSDIALOG oDlg CENTER
	
	oDlg := Nil
	
End                            

If !Empty(AllTrim(_cEleKey))

	AdjChv(_cEleKey, @aDados)
	
EndIf

If Len(aDados) > 0
                    
	_cDateTime := DToS(dDataBase) + StrTran(Time(), ":", "")    
	
	aCabec := {"Sequencia", "Chave Eletronica", "Resultado"}

	DlgToExcel({ {"ARRAY", "Log Chaves Eletronicas " + _cDateTime, aCabec, aDados} })

EndIf

Return

Static Function AdjChv(_cKeyEle, aDados)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

_cFail := ""

_cAno  := SubStr(_cKeyEle, 03, 02)
_cMes  := SubStr(_cKeyEle, 05, 02)
_cCGC  := SubStr(_cKeyEle, 07, 14)
_cNot  := SubStr(_cKeyEle, 26, 09)
_cNFn  := AllTrim(Str(Val(_cNot)))
_cSerNf:= SubStr(_cKeyEle, 23, 03)

_cKey  := _cKeyEle

_cQuery := "SELECT F1.R_E_C_N_O_ AS RECSF1 "
_cQuery += "FROM " + RetSQLName("SF1") + " F1 WITH(NOLOCK), " + RetSQLName("SA2") + " A2 WITH(NOLOCK) "
_cQuery += "WHERE "
_cQuery += "F1_FORNECE = A2_COD    AND "
_cQuery += "F1_LOJA    = A2_LOJA   AND "
_cQuery += "F1_FILIAL  = A2_FILIAL AND "
_cQuery += "F1_FILIAL  = '" + xFilial("SF1") + "' AND "
_cQuery += "F1.D_E_L_E_T_ <> '*' AND "
_cQuery += "A2.D_E_L_E_T_ <> '*' AND "

//	_cQuery += "SUBSTRING(F1_EMISSAO, 3, 2) = '" + _cAno + "' AND "      //  AAmmCNPJ---------v  serNUMERNOTA
//	_cQuery += "SUBSTRING(F1_EMISSAO, 5, 2) = '" + _cMes + "' AND "      //35131212506535000118550010000011051603001290
//31190960664828003515570010000381321241944535
//UFAAMMCNPJxxxxxxxxxxMDSERNfexxxxxxSEQUENCIAL
//12345678901234567890123456789012345678901234
//         1         2         3         4
//MD - Modelo do CTE
//SER - Serie da NFe
//
_cQuery += "A2_CGC                      = '" + _cCGC + "' AND "          //35130159527630000161550010000119481030000095
_cQuery += "( "
_cQuery += "	F1_DOC = '" + _cNot + "' "
_cQuery += "	OR "
_cQuery += "	LTRIM(RTRIM(F1_DOC)) = '" + _cNFn + "' "
_cQuery += ") "
_cQuery += "AND F1_SERIE='" + _cSerNf + "' "

//MEMOWRITE("RFISA90_select_linha_fonte_" + ALLTRIM(STR(PROCLINE())) + ".SQL",_cQuery)				

DBUseArea(.T.,"TOPCONN", TCGenQry(,, _cQuery), _cTMPSF1, .F., .T.)

_aRecSF1 := {}

DBSelectArea(_cTMPSF1)
While !EOF()
	
	AAdd(_aRecSF1, (_cTMPSF1)->RECSF1 )
	
	DBSelectArea(_cTMPSF1)
	DBSkip()
	
	If Len(_aRecSF1) > 2
		
		Exit
		
	EndIf
	
End

DBSelectArea(_cTMPSF1)
DBCloseArea()

Do Case
	
	Case Len(_aRecSF1) == 1
		
//		MsprocTxt(AllTrim(Str(_nIx)) + "/" + _cTotRec + " | Atualizando Informacoes ")
		
		Begin Transaction
		
		DBSelectArea("SF1")
		DBGoTo(_aRecSF1[1])
		
		RecLock("SF1", .F.)
		
		SF1->F1_CHVNFE := _cKey
		
		MSUnLock()
		
		//	_cQuery += "SUBSTRING(F1_EMISSAO, 3, 2) = '" + _cAno + "' AND "      //  AAmmCNPJ---------v  serNUMERNOTA
		//	_cQuery += "SUBSTRING(F1_EMISSAO, 5, 2) = '" + _cMes + "' AND "      //35131212506535000118550010000011051603001290
		
		_cF1Emiss := DToS(SF1->F1_EMISSAO)
		_cF1Mes   := SubStr(_cF1Emiss, 5, 2)
		_cF1Ano   := SubStr(_cF1Emiss, 3, 2)
		
		
		If _cF1Mes + _cF1Ano <> _cMes + _cAno
			
			Do Case
				
				Case _cF1Mes + _cF1Ano <> _cMes + _cAno
					
					_cFail += "CHAVE ATUALIZADA COM MES E ANO DE EMISSAO DIVERGENTE DA CHAVE "  
					
				Case _cF1Mes == _cMes .and. _cF1Ano <> _cAno
					
					_cFail += "CHAVE ATUALIZADA COM ANO DE EMISSAO DIVERGENTE DA CHAVE "
					
				Case _cF1Mes <> _cMes .and. _cF1Ano == _cAno
					
					_cFail += "CHAVE ATUALIZADA COM MES DE EMISSAO DIVERGENTE DA CHAVE "
					
			EndCase
			
		Else
			
			_cFail += "CHAVE ATUALIZADA SEM DIVERGENCIAS "
			
		EndIf
		
		//(4) F3_FILIAL+F3_SERIE+F3_NFISCAL+F3_CLIEFOR+F3_LOJA+F3_IDENTFT

		_nAtuSF3 := 0

		DBSelectArea("SF3")
		DBSetOrder(4)
		If DBSeek(SF1->F1_FILIAL + SF1->F1_FORNECE + SF1->F1_LOJA + SF1->F1_DOC + SF1->F1_SERIE )
			
			RecLock("SF3", .F.)
			
			SF3->F3_CHVNFE := _cKey
			
			MSUnLock()
			
			_nAtuSF3 += 1
			
		EndIf
		
		//(1) FT_FILIAL+FT_TIPOMOV+FT_SERIE+FT_NFISCAL+FT_CLIEFOR+FT_LOJA+FT_ITEM+FT_PRODUTO

		_nAtuSFT := 0

		DBSelectArea("SFT")
		DBSetOrder(1)
		If DBSeek(SF1->F1_FILIAL + "E" + SF1->F1_SERIE + SF1->F1_DOC + SF1->F1_FORNECE + SF1->F1_LOJA)
			
			While !EOF() .and. 	SF1->F1_FILIAL + "E"             	+ SF1->F1_SERIE + SF1->F1_DOC     	+ SF1->F1_FORNECE + SF1->F1_LOJA == ;
				SFT->FT_FILIAL + SFT->FT_TIPOMOV 	+ SFT->FT_SERIE + SFT->FT_NFISCAL 	+ SFT->FT_CLIEFOR + SFT->FT_LOJA
				
				RecLock("SFT", .F.)
				
				SFT->FT_CHVNFE := _cKey
				
				MSUnLock()
				
				_nAtuSFT += 1
				
				DBSelectArea("SFT")
				DBSkip()
				
			End
			
		EndIf
		
		If _nAtuSF3 == 0
			
			_cFail += SF1->F1_SERIE + " " + SF1->F1_DOC + " " + SF1->F1_FORNECE + " " + SF1->F1_LOJA + " SF3 NAO ENCONTRADO " 
			
		EndIf
		
		If _nAtuSFT == 0
			
			_cFail += SF1->F1_SERIE + " " + SF1->F1_DOC + " " + SF1->F1_FORNECE + " " + SF1->F1_LOJA + " SFT NAO ENCONTRADO " 
			
		EndIf
		
		If _nAtuSFT == 0 .or. _nAtuSF3 == 0
			
			DisarmTransaction()
			
		EndIf
		
		End Transaction
		
	Case Len(_aRecSF1) == 0
		
		_cFail += "SF1 NAO ENCONTRADO "  
		
	Case Len(_aRecSF1) >  1
		
		_cFail += "MAIS DE UM SF1 ENCONTRADO "  
		
EndCase

If "CHAVE ATUALIZADA SEM DIVERGENCIAS" $ _cFail
	
	_cAtt := "SUCESSO"
	
Else
	
	_cAtt := "ATENCAO"
	
EndIf

_nBotao := AVISO("Status da Chave Eletronica", _cFail, _aBotoes, 3, OEMTOANSI(_cAtt) + CRLF + CRLF,, "CHVNFE", .F., 15000, 2)

If _nBotao == 2 

	_nExecFunc := 0        
	
EndIf

_cEleKey := Space(_nTamChv)

_nLen    := Len(aDados) + 1

AAdd(aDados, {_nLen, "NFE " + _cKey, _cFail})

Return(.T.)
