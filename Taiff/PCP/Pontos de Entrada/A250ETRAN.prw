#include "rwmake.ch"
#INCLUDE "Protheus.ch"
#INCLUDE "Topconn.ch"

//+--------------------------------------------------------------------------------------------------------------
//| PONTO DE ENTRADA: A250ETRAN                         AUTOR: CARLOS ALDAY TORRES           DATA: 17/01/2011   |
//+--------------------------------------------------------------------------------------------------------------
//| DESCRICAO: Rotina para endereçamento automatico no apontamento de etiquetas
//| SOLICITANTE: Jose Antonio / Humberto / Alan
//| OBSERVACAO: PE executado pela rotina MATA250, na rotina PCPPAGOP tambem é chamada a rotina MATA250 por conse-
//| 				quencia executa o PE.
//+--------------------------------------------------------------------------------------------------------------
User Function A250ETRAN()

/*
|=================================================================================
|   COMENTARIO
|---------------------------------------------------------------------------------
|	Inserido variavel array para que seja salva a Area Atual para Restaurar ao 
| Termino deste PE, conforme solicitado e informado pelo Consultor da TOTVS
| Jose Sergio.
| 	Edson Hornberger - 18/06/2014
|=================================================================================
*/

Local cAliasSb1 	:= SB1->(GetArea())
Local cAliasSda 	:= SDA->(GetArea())
Local aAreaGeral	:= GetArea()
Local cEndereco 	:= ""
Local __cOpFilho	:= ""
Local _nPonteiro	:= 0
Local _nDecimalSld:= 0
Local __cEndAutom	:= GetNewPar("MV_ENDAUTO","N") // Parametro exclusivo para desativar a execução do PE

//U_ApontaArm31()
If __cEndAutom == "S"
	//
	// A tabela PAGOPS é criada na rotina de aponamento de etiquetas (PCPPAGOP.PRW)
	//
	If Select("PAGOPS") > 0
	
		__cOpFilho:= Alltrim(PAGOPS->C2_NUM + PAGOPS->C2_ITEM + PAGOPS->C2_SEQUEN)
		SD3->(DbSetOrder(1))
		SD3->(DbSeek( xFilial("SD3") + __cOpFilho ))
		While SD3->(D3_FILIAL + D3_OP ) == xFilial("SD3") + __cOpFilho  .and.  !SD3->(Eof())
			If SD3->D3_TM == '03' .and. SD3->D3_COD == PAGOPS->C2_PRODUTO
				_nPonteiro := SD3->(recno())
			Endif
			SD3->(DbSkip())		
		End
		
		SB1->(DbSetOrder(1))
		SB1->(DbSeek( xFilial("SB1") + PAGOPS->C2_PRODUTO ))
		
		If SB1->B1_TIPO == 'ET' .and. _nPonteiro != 0
		
			SD3->(DbGoTo( _nPonteiro ))
			//Alert("Produto "+SD3->D3_COD+" no. Seq:"+SD3->D3_OP+" Documento:"+SD3->D3_DOC,"PE customizado")
		
			//
			// SDA Order 1 = DA_FILIAL, DA_PRODUTO, DA_LOCAL, DA_NUMSEQ, DA_DOC, DA_SERIE, DA_CLIFOR, DA_LOJA, 
			//
			SDA->(DbSetOrder(1))     //Posicionar na TABELA SDA no registro que acaba de ser criado e que
			If SDA->(DbSeek( SD3->(D3_FILIAL + D3_COD + D3_LOCAL + D3_NUMSEQ + D3_DOC), .F.)) //esteja pendente de endereçamento.
	
				_nDecimalSld := SDA->DA_SALDO - Int(SDA->DA_SALDO)
				
				aItem	:= {}
				aCabec:={{"DA_PRODUTO" ,SDA->DA_PRODUTO ,Nil},;
							{"DA_QTDORI"  ,SDA->DA_QTDORI  ,Nil},;
							{"DA_SALDO"   ,SDA->DA_SALDO   ,Nil},;
							{"DA_DATA"    ,SDA->DA_DATA    ,Nil},;
							{"DA_LOTECTL" ,SDA->DA_LOTECTL ,Nil},;
							{"DA_NUMLOTE" ,SDA->DA_NUMLOTE ,Nil},;
							{"DA_LOCAL"   ,SDA->DA_LOCAL   ,Nil},;
							{"DA_DOC"     ,SDA->DA_DOC     ,Nil},;
							{"DA_SERIE"   ,SDA->DA_SERIE   ,Nil},;
							{"DA_CLIFOR"  ,SDA->DA_CLIFOR  ,Nil},;
							{"DA_LOJA"    ,SDA->DA_LOJA    ,Nil},;
							{"DA_TIPONF"  ,SDA->DA_TIPONF  ,Nil},;
							{"DA_ORIGEM"  ,SDA->DA_ORIGEM  ,Nil},;
							{"DA_NUMSEQ"  ,SDA->DA_NUMSEQ  ,Nil},;
							{"DA_EMPENHO" ,SDA->DA_EMPENHO ,Nil},;
							{"DA_QTSEGUM" ,SDA->DA_QTSEGUM ,Nil},;
							{"DA_QTDORI2" ,SDA->DA_QTDORI2 ,Nil},;
							{"DA_EMP2"    ,SDA->DA_EMP2    ,Nil},;
							{"DA_REGWMS"  ,SDA->DA_REGWMS  ,Nil}}
				
				If SD3->D3_LOCAL == "02"
					cEndereco := "ALMOX"
				ElseIf SD3->D3_LOCAL == "11"
					cEndereco := "PROD"
				Endif
						
				aAdd(aItem,{{"DB_ITEM"   ,"001"				,Nil},;
								{"DB_LOCALIZ",cEndereco			,Nil},; //Local onde será realizado o endereçamento.
								{"DB_DATA"   ,dDataBase			,Nil},;
								{"DB_QUANT"  ,SDA->DA_SALDO   ,Nil},;
								{"DB_QTSEGUM",SDA->DA_QTSEGUM	,Nil}})
			
				lMsErroAuto := .F.
				MsExecAuto({|x,y,z|MATA265(x,y,z)},aCabec, aItem, 3)
				If lMsErroAuto
					MostraErro()
				Endif          
				aCabec := {}
				aItem  := {}
				
				//U_RESTA_SLD( _nDecimalSld , _nPonteiro )
				
			EndIf
		EndIf
		SB1->(RestArea(cAliasSb1))
		SDA->(RestArea(cAliasSda))
		DbSelectArea("PAGOPS")
	Else
		If _mD3TM == '04'
		
			//
			// Busca o numero sequencial da OP registrada na tabela SD3
			//
			cQuery := "SELECT IsNull(MAX(D3_NUMSEQ),0) AS D3_NUMSEQ "
			cQuery += " FROM " + RetSqlName("SD3") + " SD3 WITH(NOLOCK) " 
			cQuery += " WHERE SD3.D3_FILIAL = '" + xFilial("SD3") + "' "
			cQuery += "   AND SD3.D_E_L_E_T_ != '*' "
			cQuery += "   AND SD3.D3_ESTORNO != 'S' "
			cQuery += "   AND SD3.D3_TM = '"+ Alltrim( _mD3TM ) + "'"
			cQuery += "   AND SD3.D3_OP = '" + Alltrim( _mD3OP ) + "'"
			cQuery += "   AND SD3.D3_LOCAL = '" + Alltrim( _mD3LOCAL ) + "'"
			cQuery += "   AND SD3.D3_COD = '" + Alltrim( _mD3COD ) + "'"
			cQuery += "   AND SD3.D3_DOC = '" + Alltrim( _mD3DOC ) + "'"

			If Select("TMPSD3") > 0
				TMPSD3->(DbCloseArea())
			Endif
			
			TcQuery cQuery NEW ALIAS ("TMPSD3")
			
			DbSelectArea("TMPSD3")
		
			_mD3NUMSEQ := TMPSD3->D3_NUMSEQ
			
			TMPSD3->(DbCloseArea())
			//                                        	
			// SDA Order 1 = DA_FILIAL, DA_PRODUTO, DA_LOCAL, DA_NUMSEQ, DA_DOC, DA_SERIE, DA_CLIFOR, DA_LOJA, 
			//
			DbSelectArea("SDA")
			SDA->(DbSetOrder(1))     //Posicionar na TABELA SDA no registro que acaba de ser criado e que
			//If SDA->(DbSeek( SD3->(D3_FILIAL + D3_COD + D3_LOCAL + D3_NUMSEQ + D3_DOC), .F.)) //esteja pendente de endereçamento.
			If SDA->(DbSeek( xFilial("SD3") + _mD3COD + _mD3LOCAL + _mD3NUMSEQ + _mD3DOC, .F.)) //esteja pendente de endereçamento.
	
				aItem	:= {}
				aCabec:={{"DA_PRODUTO" ,SDA->DA_PRODUTO ,Nil},;
							{"DA_QTDORI"  ,SDA->DA_QTDORI  ,Nil},;
							{"DA_SALDO"   ,SDA->DA_SALDO   ,Nil},;
							{"DA_DATA"    ,SDA->DA_DATA    ,Nil},;
							{"DA_LOTECTL" ,SDA->DA_LOTECTL ,Nil},;
							{"DA_NUMLOTE" ,SDA->DA_NUMLOTE ,Nil},;
							{"DA_LOCAL"   ,SDA->DA_LOCAL   ,Nil},;
							{"DA_DOC"     ,SDA->DA_DOC     ,Nil},;
							{"DA_SERIE"   ,SDA->DA_SERIE   ,Nil},;
							{"DA_CLIFOR"  ,SDA->DA_CLIFOR  ,Nil},;
							{"DA_LOJA"    ,SDA->DA_LOJA    ,Nil},;
							{"DA_TIPONF"  ,SDA->DA_TIPONF  ,Nil},;
							{"DA_ORIGEM"  ,SDA->DA_ORIGEM  ,Nil},;
							{"DA_NUMSEQ"  ,SDA->DA_NUMSEQ  ,Nil},;
							{"DA_EMPENHO" ,SDA->DA_EMPENHO ,Nil},;
							{"DA_QTSEGUM" ,SDA->DA_QTSEGUM ,Nil},;
							{"DA_QTDORI2" ,SDA->DA_QTDORI2 ,Nil},;
							{"DA_EMP2"    ,SDA->DA_EMP2    ,Nil},;
							{"DA_REGWMS"  ,SDA->DA_REGWMS  ,Nil}}
				
				If _mD3LOCAL == "02"
					cEndereco := "ALMOX"
				ElseIf _mD3LOCAL == "11"
					cEndereco := "PROD"
				ElseIf _mD3LOCAL == "31"
					cEndereco := "TERC"
				Endif
						
				aAdd(aItem,{{"DB_ITEM"   ,"001"				,Nil},;
								{"DB_LOCALIZ",cEndereco			,Nil},; //Local onde será realizado o endereçamento.
								{"DB_DATA"   ,dDataBase			,Nil},;
								{"DB_QUANT"  ,SDA->DA_SALDO   ,Nil},;
								{"DB_QTSEGUM",SDA->DA_QTSEGUM	,Nil}})
			
				lMsErroAuto := .F.
				MsExecAuto({|x,y,z|MATA265(x,y,z)},aCabec, aItem, 3)
				If lMsErroAuto
					MostraErro()
				Endif          
				aCabec := {}
				aItem  := {}
				
			EndIf
			SB1->(RestArea(cAliasSb1))
			SDA->(RestArea(cAliasSda))
		EndIf
	EndIf
EndIf

RestArea(aAreaGeral)

RETURN NIL

//+--------------------------------------------------------------------------------------------------------------
//| PONTO DE ENTRADA: RESTA_SLD                         AUTOR: CARLOS ALDAY TORRES           DATA: 21/01/2011   |
//+--------------------------------------------------------------------------------------------------------------
//| DESCRICAO: Rotina para endereçar saldo automatico no apontamento de etiquetas, quando o saldo é > 0 e < 1
//+--------------------------------------------------------------------------------------------------------------
User Function RESTA_SLD( __nDecimais , __nPonteiro )
Local cEndereco 	:= ""
Local aArea	:= GetArea()

If __nDecimais > 0 .and. __nDecimais < 1
	SD3->(DbGoTo( __nPonteiro ))
	//Alert("Produto "+SD3->D3_COD+" no. Seq:"+SD3->D3_OP+" Documento:"+SD3->D3_DOC,"PE customizado")

	//
	// SDA Order 1 = DA_FILIAL, DA_PRODUTO, DA_LOCAL, DA_NUMSEQ, DA_DOC, DA_SERIE, DA_CLIFOR, DA_LOJA, 
	//
	SDA->(DbSetOrder(1))     //Posicionar na TABELA SDA no registro que acaba de ser criado e que
	If SDA->(DbSeek( SD3->(D3_FILIAL + D3_COD + D3_LOCAL + D3_NUMSEQ + D3_DOC), .F.)) //esteja pendente de endereçamento.
		aItem	:= {}
		aCabec:={{"DA_PRODUTO" ,SDA->DA_PRODUTO ,Nil},;
					{"DA_QTDORI"  ,SDA->DA_QTDORI  ,Nil},;
					{"DA_SALDO"   ,SDA->DA_SALDO   ,Nil},;
					{"DA_DATA"    ,SDA->DA_DATA    ,Nil},;
					{"DA_LOTECTL" ,SDA->DA_LOTECTL ,Nil},;
					{"DA_NUMLOTE" ,SDA->DA_NUMLOTE ,Nil},;
					{"DA_LOCAL"   ,SDA->DA_LOCAL   ,Nil},;
					{"DA_DOC"     ,SDA->DA_DOC     ,Nil},;
					{"DA_SERIE"   ,SDA->DA_SERIE   ,Nil},;
					{"DA_CLIFOR"  ,SDA->DA_CLIFOR  ,Nil},;
					{"DA_LOJA"    ,SDA->DA_LOJA    ,Nil},;
					{"DA_TIPONF"  ,SDA->DA_TIPONF  ,Nil},;
					{"DA_ORIGEM"  ,SDA->DA_ORIGEM  ,Nil},;
					{"DA_NUMSEQ"  ,SDA->DA_NUMSEQ  ,Nil},;
					{"DA_EMPENHO" ,SDA->DA_EMPENHO ,Nil},;
					{"DA_QTSEGUM" ,SDA->DA_QTSEGUM ,Nil},;
					{"DA_QTDORI2" ,SDA->DA_QTDORI2 ,Nil},;
					{"DA_EMP2"    ,SDA->DA_EMP2    ,Nil},;
					{"DA_REGWMS"  ,SDA->DA_REGWMS  ,Nil}}
		
		If SD3->D3_LOCAL == "02"
			cEndereco := "ALMOX"
		ElseIf SD3->D3_LOCAL == "11"
			cEndereco := "PROD"
		Endif
				
		aAdd(aItem,{{"DB_ITEM"   ,"002"				,Nil},;
						{"DB_LOCALIZ",cEndereco			,Nil},; //Local onde será realizado o endereçamento.
						{"DB_DATA"   ,dDataBase			,Nil},;
						{"DB_QUANT"  ,SDA->DA_SALDO   ,Nil},;
						{"DB_QTSEGUM",SDA->DA_QTSEGUM	,Nil}})
	
		lMsErroAuto := .F.
		MsExecAuto({|x,y,z|MATA265(x,y,z)},aCabec, aItem, 3)
		If lMsErroAuto
			MostraErro()
		Endif          
		aCabec := {}
		aItem  := {}
	EndIf
EndIf		
RestArea(aArea)
RETURN NIL

//+--------------------------------------------------------------------------------------------------------------
//| Função: ApontaArm31                                     AUTOR: CARLOS ALDAY TORRES           DATA: 25/05/2011   
//| Descrição: Endereçamento Automatico para o armazem 31
//+--------------------------------------------------------------------------------------------------------------
User Function ApontaArm31()   
Local _aArea     := GetArea()
Local __c31EndAutom	:= GetNewPar("MV_TFENDAU","N") // Parametro exclusivo para desativar a execução do PE
Local aItem	:= {}
Local	aCabec := {}
Local cQuery := ""

If __c31EndAutom == "S"
	If _mD3LOCAL == '31'

		//
		// Busca o numero sequencial da OP registrada na tabela SD3
		//
		cQuery := "SELECT IsNull(MAX(D3_NUMSEQ),0) AS D3_NUMSEQ "
		cQuery += " FROM " + RetSqlName("SD3") + " SD3 WITH(NOLOCK) " 
		cQuery += " WHERE SD3.D3_FILIAL = '" + xFilial("SD3") + "' "
		cQuery += "   AND SD3.D_E_L_E_T_ != '*' "
		cQuery += "   AND SD3.D3_ESTORNO != 'S' "
		cQuery += "   AND SD3.D3_TM = '"+ Alltrim( _mD3TM ) + "'"
		cQuery += "   AND SD3.D3_OP = '" + Alltrim( _mD3OP ) + "'"
		cQuery += "   AND SD3.D3_LOCAL = '" + Alltrim( _mD3LOCAL ) + "'"
		cQuery += "   AND SD3.D3_COD = '" + Alltrim( _mD3COD ) + "'"
		cQuery += "   AND SD3.D3_DOC = '" + Alltrim( _mD3DOC ) + "'"

		If Select("TMPSD3") > 0
			TMPSD3->(DbCloseArea())
		Endif
			
		TcQuery cQuery NEW ALIAS ("TMPSD3")
			
		DbSelectArea("TMPSD3")
		
		_mD3NUMSEQ := TMPSD3->D3_NUMSEQ
			
		TMPSD3->(DbCloseArea())
		//                                        	
		// SDA Order 1 = DA_FILIAL, DA_PRODUTO, DA_LOCAL, DA_NUMSEQ, DA_DOC, DA_SERIE, DA_CLIFOR, DA_LOJA, 
		//
		DbSelectArea("SDA")
		SDA->(DbSetOrder(1))     //Posicionar na TABELA SDA no registro que acaba de ser criado e que
		If SDA->(DbSeek( xFilial("SD3") + _mD3COD + _mD3LOCAL + _mD3NUMSEQ + _mD3DOC, .F.)) //esteja pendente de endereçamento.
	
			aCabec:={{"DA_PRODUTO" ,SDA->DA_PRODUTO ,Nil},;
						{"DA_QTDORI"  ,SDA->DA_QTDORI  ,Nil},;
						{"DA_SALDO"   ,SDA->DA_SALDO   ,Nil},;
						{"DA_DATA"    ,SDA->DA_DATA    ,Nil},;
						{"DA_LOTECTL" ,SDA->DA_LOTECTL ,Nil},;
						{"DA_NUMLOTE" ,SDA->DA_NUMLOTE ,Nil},;
						{"DA_LOCAL"   ,SDA->DA_LOCAL   ,Nil},;
						{"DA_DOC"     ,SDA->DA_DOC     ,Nil},;
						{"DA_SERIE"   ,SDA->DA_SERIE   ,Nil},;
						{"DA_CLIFOR"  ,SDA->DA_CLIFOR  ,Nil},;
						{"DA_LOJA"    ,SDA->DA_LOJA    ,Nil},;
						{"DA_TIPONF"  ,SDA->DA_TIPONF  ,Nil},;
						{"DA_ORIGEM"  ,SDA->DA_ORIGEM  ,Nil},;
						{"DA_NUMSEQ"  ,SDA->DA_NUMSEQ  ,Nil},;
						{"DA_EMPENHO" ,SDA->DA_EMPENHO ,Nil},;
						{"DA_QTSEGUM" ,SDA->DA_QTSEGUM ,Nil},;
						{"DA_QTDORI2" ,SDA->DA_QTDORI2 ,Nil},;
						{"DA_EMP2"    ,SDA->DA_EMP2    ,Nil},;
						{"DA_REGWMS"  ,SDA->DA_REGWMS  ,Nil}}
		
			aAdd(aItem,{{"DB_ITEM"   ,"001"				,Nil},;
							{"DB_LOCALIZ","TERC"				,Nil},; //Local onde será realizado o endereçamento.
							{"DB_DATA"   ,dDataBase			,Nil},;
							{"DB_QUANT"  ,SDA->DA_SALDO   ,Nil},;
							{"DB_QTSEGUM",SDA->DA_QTSEGUM	,Nil}})
		
			lMsErroAuto := .F.
			MsExecAuto({|x,y,z|MATA265(x,y,z)},aCabec, aItem, 3)
			If lMsErroAuto
				MostraErro()
			Endif
		EndIf
	EndIf	
EndIf
RestArea(_aArea) 
RETURN NIL