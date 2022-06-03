/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³SD1100I   ºAutor  ³TOTVS ABM           º Data ³  12/06/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ PE para efetuar o enderecamento automatico dos materiais   º±±
±±º          ³que retornao de beneficiamento.                             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
#INCLUDE "PROTHEUS.CH"

/*
|---------------------------------------------------------------------------------
|	Inserido variavel array com informacoes da Area Atual para poder restaurar
| antes de sair do PE.
|
|	Edson Hornberger - 24/06/2014
|---------------------------------------------------------------------------------
*/

User Function SD1100I()
	Local cAlias := Alias()
	Local aAreaAtual  := GetArea()
	Local _arSBE := SBE->(GetArea())
	Local _arSBF := SBF->(GetArea())
	Local _arSDA := SDA->(GetArea())
	Local _arSF4 := SF4->(GetArea())
	Local _arSD4 := SD4->(GetArea())
	Local _arSD3 := SD3->(GetArea())
	
	Local aCabec := {}
	Local aItem  := {}
	Local _lStatusFaseII := GetNewPar("MV_ARMCEN",.F.)
	Local CLOCALIZ		:= SuperGetMV("MV_CDENDD",.F.,"EXP")
	 	
	lMsErroAuto := .F.
	
	If _lStatusFaseII .and. cempant = "03" .and. cfilant != '02' .and. SF1->(FieldPos("F1_NUMRM")) > 0
		/*                               PROJETO AVANTE - fase II                                      */
		/* Endereçamento automatico para a operação de classificação da nota fiscal com ORDEM DE CARGA */
		/*
		|---------------------------------------------------------------------------------
		|	Somente realiza o processo de o tipo for Normal
		|---------------------------------------------------------------------------------
		Para o projeto Cross Docking Remodelado o campo F1_NUMRM não conterá o numero da Ormde Carga
		pois o conceito foi descontinuado, terá apenas um codigo alfanumerico identico.
		*/
		
		If !Empty(SF1->F1_NUMRM) .AND. SF1->F1_TIPO = "N"
			
			//U_TfCriaEnderco("EXPEDICAO")
			
			/*
			|=================================================================================
			|   COMENTARIO
			|---------------------------------------------------------------------------------
			| 	Realizado alteracao no Array do Cabecalho e dos itens para que nao seja
			| passado a Segunda Unidade de Medida, pois estava ocorrendo erro no Enderecamento
			|
			| Edson Hornberger - 04/04/2014
			|=================================================================================
			*/
			
			aCabec:={{"DA_PRODUTO" ,SD1->D1_COD		,Nil},;
				{"DA_QTDORI"  ,SD1->D1_QUANT		,Nil},;
				{"DA_SALDO"   ,0					   ,Nil},;
				{"DA_DATA"    ,dDataBase			,Nil},;
				{"DA_LOCAL"   ,SD1->D1_LOCAL		,Nil},;
				{"DA_DOC"     ,SD1->D1_DOC		,Nil},;
				{"DA_SERIE"   ,SD1->D1_SERIE		,Nil},;
				{"DA_CLIFOR"  ,SD1->D1_FORNECE	,Nil},;
				{"DA_LOJA"    ,SD1->D1_LOJA		,Nil},;
				{"DA_NUMSEQ"  ,SD1->D1_NUMSEQ	,Nil}}
			
			/*
			{"DA_LOTECTL" ,SDA->DA_LOTECTL ,Nil},;
				{"DA_NUMLOTE" ,SDA->DA_NUMLOTE ,Nil},;
				{"DA_TIPONF"  ,SDA->DA_TIPONF  ,Nil},;
				{"DA_ORIGEM"  ,SDA->DA_ORIGEM  ,Nil},;
				{"DA_EMPENHO" ,SDA->DA_EMPENHO ,Nil},;
				{"DA_QTDORI2" ,SDA->DA_QTDORI2 ,Nil},;
				{"DA_EMP2"    ,SDA->DA_EMP2    ,Nil},;
				{"DA_REGWMS"  ,SDA->DA_REGWMS  ,Nil}}
			*/
			
			
			aAdd(aItem,{{"DB_ITEM"		,"0001"				,Nil},;
				{"DB_PRODUTO"	,SD1->D1_COD		,Nil},;
				{"DB_LOCAL"		,SD1->D1_LOCAL		,Nil},;
				{"DB_LOCALIZ"	,CLOCALIZ		,Nil},;
				{"DB_DATA"		,dDataBase			,Nil},;
				{"DB_QUANT"		,SD1->D1_QUANT		,Nil},;
				{"DB_DOC"		,SD1->D1_DOC		,Nil},;
				{"DB_SERIE"		,SD1->D1_SERIE		,Nil},;
				{"DB_CLIFOR"	,SD1->D1_FORNECE	,Nil},;
				{"DB_LOJA"		,SD1->D1_LOJA		,Nil},;
				{"DB_NUMSEQ"	,SD1->D1_NUMSEQ	,Nil}})
			
			MsExecAuto({|x,y,z|MATA265(x,y,z)},aCabec, aItem, 3)
			If lMsErroAuto
				MsgInfo("Nao foi possivel enderecar automaticamente o material, favor informar ao TI <SD1100I> e enviar a proxima tela via email.")
				MostraErro()
				lMsErroAuto := .F.
			Endif
		EndIf
	EndIf
	/*
	***********************************************************************************************
	Desativar o apontamento de MO ao ativar a nova rotina de gestão de beneficiamento na DAIHATSU 
	***********************************************************************************************
	*/
	If SM0->M0_CODIGO == "01" 
		//ROTINA DE BENEFICIMANETO ANTIGA
		If !Empty(SD1->D1_NUMOP) 
			SF4->(DbSetOrder(1))
			SF4->(DbSeek(xFilial("SF4") + SD1->D1_TES, .F.))
			If SF4->F4_ESTOQUE == "N" .AND. SD1->D1_TP = 'MO'
				SD4->(DbSetOrder(1))
				If SD4->(DbSeek(xFilial("SD4") + SD1->D1_COD + SubStr(SD1->D1_NUMOP, 1, 8), .F.))
					
					/*
					|---------------------------------------------------------------------------------
					|	Realizado tratamento de RecLock. Passado o MsUnlock antes das funcoes Protheus
					|
					|	Edson Hornberger - 25/06/2014
					|---------------------------------------------------------------------------------
					*/
					//Gera mov. de entrada p/produtos que não movimentam estoque e possuem empenho.
					If RecLock("SD3",.T.)
						
						Replace ;
							D3_FILIAL  With xFilial("SD3") ,D3_COD     With SD1->D1_COD,;
							D3_QUANT   With SD1->D1_QUANT  ,D3_TM      With "499",;
							D3_OP      With SD1->D1_OP     ,D3_LOCAL   With SD1->D1_LOCAL,;
							D3_DOC     With SD1->D1_DOC    ,D3_EMISSAO With SD1->D1_DTDIGIT,;
							D3_NUMSEQ  With SD1->D1_NUMSEQ ,D3_UM      With SD1->D1_UM,;
							D3_GRUPO   With SD1->D1_GRUPO  ,D3_TIPO    With SD1->D1_TP,;
							D3_SEGUM   With SD1->D1_SEGUM  ,D3_CONTA   With SD1->D1_CONTA,;
							D3_CF      With "DE5"          ,D3_QTSEGUM With SD1->D1_QTSEGUM,;
							D3_CUSTO1  With SD1->D1_CUSTO  ,D3_CUSTO2  With SD1->D1_CUSTO2,;
							D3_CUSTO3  With SD1->D1_CUSTO3 ,D3_CUSTO4  With SD1->D1_CUSTO4,;
							D3_CUSTO5  With SD1->D1_CUSTO5 ,D3_NUMLOTE With SD1->D1_NUMLOTE,;
							D3_LOTECTL With SD1->D1_LOTECTL,D3_DTVALID With SD1->D1_DTVALID,;
							D3_USUARIO With SubStr(cUsuario,7,15)
						MsUnLock()
						
						B2AtuComD3({SD3->D3_CUSTO1,SD3->D3_CUSTO2,SD3->D3_CUSTO3,SD3->D3_CUSTO4,SD3->D3_CUSTO5})
						C2AtuComD3({SD3->D3_CUSTO1,SD3->D3_CUSTO2,SD3->D3_CUSTO3,SD3->D3_CUSTO4,SD3->D3_CUSTO5})
						
					EndIf
					
				EndIf
			EndIf
		EndIf
	EndIf
	/*
		Em 01/01/2019 a funcionalidade de endereçamento automatico da OP de beneficiamento deixou de funcionar na 
		empresa ACTION este processo será atendido pelo padrão por isso foi removida da condição abaixo SM0->M0_CODIGO == "04".
	*/
	If SM0->M0_CODIGO == "01" 
		/*
		|---------------------------------------------------------------------------------
		|	Foi inserido a validação dos campos de Nota/Serie/Item de origem, pois ao
		|	usar o campo padrão D1_OP, e os campos acima citados, retornando NF de 
		|	Beneficiamento o próprio Sistema já realiza o endereçamento.
		|	
		|	Edson Hornberger - 10/05/2016
		|---------------------------------------------------------------------------------
		*/
		/*
		A definição do armazem 53 é "Ass. Tecnica- Ctb"
		*/
		If (!Empty(SD1->D1_OP) .AND. EMPTY(SD1->D1_NFORI+SD1->D1_SERIORI+SD1->D1_ITEMORI)) .or. SD1->D1_LOCAL == "53"
			SBE->(DbsetOrder(1))  //Cadastro de enderecos
			SBE->(DbGoTop())
			If !SBE->(DbSeek(xFilial("SBE") + SD1->D1_LOCAL + "ALMOX", .F.))
				SBE->(RecLock("SBE", .T.))
				SBE->BE_FILIAL := xFilial("SBE")
				SBE->BE_LOCAL  := SD1->D1_LOCAL
				If SD1->D1_LOCAL != "53"
					SBE->BE_LOCALIZ:= "ALMOX"
					SBE->BE_DESCRIC:= "ALMOX. DE MATARIAL"
				Else
					SBE->BE_LOCALIZ:= ""
					SBE->BE_DESCRIC:= ""
				EndIf
				SBE->BE_PRIOR  := "ZZZ"
				SBE->BE_STATUS := "1"
				SBE->(MsUnLock())
			EndIf
			
			SBF->(DbSetOrder(1))  //Saldos por endereco
			If !SBF->(Dbseek(xFilial("SBF") + SD1->D1_LOCAL + "ALMOX          " + SD1->D1_COD, .F.))
				SBF->(RecLock("SBF", .T.))
				SBF->BF_FILIAL  := xFilial("SBF")
				SBF->BF_PRODUTO := SD1->D1_COD
				SBF->BF_LOCAL   := SD1->D1_LOCAL
				SBF->BF_PRIOR   := "ZZZ"
				If SD1->D1_LOCAL != "53"
					SBF->BF_LOCALIZ := "ALMOX"
				Else
					SBF->BF_LOCALIZ := ""
				EndIf
				SBF->(MsUnLock())
			EndIf
			
			SDA->(DbSetOrder(1))
			If SD1->D1_LOCAL != "53"
				If SDA->(DbSeek(SD1->(D1_FILIAL + D1_COD + D1_LOCAL + D1_NUMSEQ + D1_DOC + D1_SERIE + D1_FORNECE + D1_LOJA), .F.))
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
						{"DA_EMP2"    ,SDA->DA_EMP2    ,Nil},;
						{"DA_REGWMS"  ,SDA->DA_REGWMS  ,Nil}}
					//{"DA_QTSEGUM" ,SDA->DA_QTSEGUM ,Nil},;
						//{"DA_QTDORI2" ,SDA->DA_QTDORI2 ,Nil},;
						
					aAdd(aItem,{{"DB_ITEM"   ,"001"          ,Nil},;
						{"DB_LOCALIZ","ALMOX"        ,Nil},;
						{"DB_DATA"   ,dDataBase      ,Nil},;
						{"DB_QUANT"  ,SDA->DA_SALDO  ,Nil}})
					//,;
						//{"DB_QTSEGUM",SDA->DA_QTSEGUM,Nil}})
				EndIf
			Else
				// Atenção: Rotina não está bem definida para o armazem 53!
				//
				// Em que momento a tabela SD3 é posicionada? Na rotina que antecede este PE?
				//
				// Quem aciona a execução deste PE?
				//
				If SDA->(DbSeek(SD3->(D3_FILIAL + D3_COD + D3_LOCAL + D3_NUMSEQ + D3_DOC ), .F.))
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
						{"DA_EMP2"    ,SDA->DA_EMP2    ,Nil},;
						{"DA_REGWMS"  ,SDA->DA_REGWMS  ,Nil}}
					//{"DA_QTSEGUM" ,SDA->DA_QTSEGUM ,Nil},;
						//{"DA_QTDORI2" ,SDA->DA_QTDORI2 ,Nil},;
						
					aAdd(aItem,{{"DB_ITEM"   ,"001"          ,Nil},;
						{"DB_LOCALIZ",               ,Nil},;
						{"DB_DATA"   ,dDataBase      ,Nil},;
						{"DB_QUANT"  ,SDA->DA_SALDO  ,Nil}})
					//,;
						//{"DB_QTSEGUM",SDA->DA_QTSEGUM,Nil}})
				EndIf
			EndIf
			If Len(aCabec) > 0
				MsExecAuto({|x,y,z|MATA265(x,y,z)},aCabec, aItem, 3)
				If lMsErroAuto
					MsgInfo("Nao foi possivel enderecar automaticamente o material, favor informar ao TI <SD1100I> e enviar a proxima tela via email.")
					MostraErro()
					lMsErroAuto := .F.
				Endif
			EndIf
			//ROTINA DE BENEFICIMANETO ANTIGA
			If !Empty(SD1->D1_OP) .and. 1 = 2
				SF4->(DbSetOrder(1))
				SF4->(DbSeek(xFilial("SF4") + SD1->D1_TES, .F.))
				If SF4->F4_ESTOQUE == "N" .AND. SD1->D1_TP = 'MO'
					SD4->(DbSetOrder(1))
					If SD4->(DbSeek(xFilial("SD4") + SD1->D1_COD + SubStr(SD1->D1_OP, 1, 8), .F.))
						
						/*
						|---------------------------------------------------------------------------------
						|	Realizado tratamento de RecLock. Passado o MsUnlock antes das funcoes Protheus
						|
						|	Edson Hornberger - 25/06/2014
						|---------------------------------------------------------------------------------
						*/
						//Gera mov. de entrada p/produtos que não movimentam estoque e possuem empenho.
						If RecLock("SD3",.T.)
							
							Replace ;
								D3_FILIAL  With xFilial("SD3") ,D3_COD     With SD1->D1_COD,;
								D3_QUANT   With SD1->D1_QUANT  ,D3_TM      With "499",;
								D3_OP      With SD1->D1_OP     ,D3_LOCAL   With SD1->D1_LOCAL,;
								D3_DOC     With SD1->D1_DOC    ,D3_EMISSAO With SD1->D1_DTDIGIT,;
								D3_NUMSEQ  With SD1->D1_NUMSEQ ,D3_UM      With SD1->D1_UM,;
								D3_GRUPO   With SD1->D1_GRUPO  ,D3_TIPO    With SD1->D1_TP,;
								D3_SEGUM   With SD1->D1_SEGUM  ,D3_CONTA   With SD1->D1_CONTA,;
								D3_CF      With "DE5"          ,D3_QTSEGUM With SD1->D1_QTSEGUM,;
								D3_CUSTO1  With SD1->D1_CUSTO  ,D3_CUSTO2  With SD1->D1_CUSTO2,;
								D3_CUSTO3  With SD1->D1_CUSTO3 ,D3_CUSTO4  With SD1->D1_CUSTO4,;
								D3_CUSTO5  With SD1->D1_CUSTO5 ,D3_NUMLOTE With SD1->D1_NUMLOTE,;
								D3_LOTECTL With SD1->D1_LOTECTL,D3_DTVALID With SD1->D1_DTVALID,;
								D3_USUARIO With SubStr(cUsuario,7,15)
							MsUnLock()
							
							B2AtuComD3({SD3->D3_CUSTO1,SD3->D3_CUSTO2,SD3->D3_CUSTO3,SD3->D3_CUSTO4,SD3->D3_CUSTO5})
							C2AtuComD3({SD3->D3_CUSTO1,SD3->D3_CUSTO2,SD3->D3_CUSTO3,SD3->D3_CUSTO4,SD3->D3_CUSTO5})
							
						EndIf
						
					EndIf
				EndIf
			EndIf
			
			
		EndIf
	EndIf
	
	aCabec := {}
	aItem  := {}
	DbSelectArea(cAlias)
	RestArea(_arSD3)
	RestArea(_arSD4)
	RestArea(_arSF4)
	RestArea(_arSDA)
	RestArea(_arSBF)
	RestArea(_arSBE)
	RestArea(aAreaAtual)
	
Return
