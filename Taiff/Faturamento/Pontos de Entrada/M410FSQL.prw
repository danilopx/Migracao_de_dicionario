#Include 'Protheus.ch'
#Include "TopConn.ch"

#Define Pula Chr(13) + Chr(10)

User Function M410FSQL()

	Local cQuery 		:= ""
	
	Local nThread		:= ThreadId() 	// Pega a Thread da Chamada da Funcao do Pedido de Vendas - Edson Hornberger - 07/11/2013
	Local lAvnFSII		:= SUPERGETMV("MV_ARMCEN",.F.,.T.) //Parametro para ativar o Processo do Projeto Avante - Fase II
	Local cUnidNeg		:= ""
	Local cQryUn		:= ''
	Local cCLASSPED	:= ""
	
	Private _nOpc 		:= 0
	
	/*
	|=================================================================================
	|   COMENTARIO
	|---------------------------------------------------------------------------------
	|	Se o Controle de Unidade de Negocios estiver ativada verifica qual a Unidade
	| escolhida no ponto de entrada MA410COR pelo usuario para poder realizar o Filtro.
	|	Edson Hornberger - 07/11/2013
	|=================================================================================
	*/
	
	If lAvnFSII
		
		cQryUn := "SELECT" 								+ Pula 
		cQryUn += "ISNULL(UNNEGOC,'') AS UNNEGOC"		+ Pula 
		cQryUn += ",ISNULL(CLASSPED,'') AS CLASSPED"	+ Pula 
		cQryUn += "FROM" 									+ Pula
		cQryUn += "CONTROLE_LEGENDA" 					+ Pula 
		cQryUn += "WHERE" 								+ Pula
		cQryUn += "EMPRESA = '" + cEmpAnt + "' AND" 	+ Pula
		cQryUn += "FILIAL = '" + cFilAnt + "' AND" 	+ Pula
		cQryUn += "USUARIO = '" + __CUSERID + "' AND" 	+ Pula
		cQryUn += "NTHREAD = " + cValToChar(nThread)
		
		If Select("TMP1") > 0
			
			dbSelectArea("TMP1") 
			dbCloseArea()
			
		EndIf 
		
		TcQuery cQryUn New Alias "TMP1"
		dbSelectArea("TMP1")
		
		cUnidNeg := Iif(TMP1->UNNEGOC = "", "TAIFF", TMP1->UNNEGOC)
		cCLASSPED:= Iif(TMP1->CLASSPED = "", "O", TMP1->CLASSPED) // O - Outros
		
	EndIf

//Executa somente nas empresas parametrizadas
	If (cEmpAnt+cFilAnt) $ SuperGetMV("MV__MULT06",.F.,"") .AND. !(cEmpAnt+cFilAnt) $ SuperGetMV("MV__SEPA01",.F.,"") //Rotinas de Avaliacao de Credito Ativadas e Expedicao desativadas
		
		U_PMALBC_X1()
		Pergunte("FATMI00005",.T.)
		cQuery += " C5_XLIBCR $ '["+mv_par03+"]' .AND. C5_EMISSAO>='"+DTOS(mv_par01)+"' .AND. C5_EMISSAO <= '"+DTOS(mv_par02)+"'"
		
		/*
		|=================================================================================
		|   COMENTARIO
		|---------------------------------------------------------------------------------
		|	Trata filtro com a Unidade de Negocio
		|	Edson Hornberger - 07/11/2013
		|=================================================================================
		*/
		
		If lAvnFSII
			
			cQuery += " .AND. (C5_XITEMC = '" + cUnidNeg + "' .OR. C5_XITEMC = '')"	
			If cCLASSPED = "A"
				cQuery += " .AND. (C5_CLASPED = '" + cCLASSPED + "' )"
			Else
				cQuery += " .AND. (C5_CLASPED != 'A' )"
			EndIf	
			
			//Deleta o controle da Tabela e Controle de Filtro
			cQryUn := "DELETE" + Pula
			cQryUn += "CONTROLE_LEGENDA" + Pula 
			cQryUn += "WHERE" + Pula 
			cQryUn	+= "EMPRESA = '" + cEmpAnt + "' AND" + Pula
			cQryUn	+= "FILIAL = '" + cFilAnt + "' AND" + Pula 
			cQryUn	+= "USUARIO = '" + __cUserID + "' AND" + Pula
			cQryUn	+= "NTHREAD = " + cValToChar(nThread) + " AND" + Pula
			cQryUn	+= "UNNEGOC = '" + cUnidNeg + "'"
			 
			
			If TcSQLExec(cQryUn) < 0 
			
				MSGSTOP(OEMTOANSI("Erro ao tentar excluir o Controle Unidade de Neg�cio!") + Pula + "FONTE: " + ALLTRIM(PROCNAME()) + " LINHA: " + ALLTRIM(STR(PROCLINE())),OEMTOANSI("Unidade de Neg�cio"))
				//MEMOWRITE(GetTempPath() + "/ln" + ALLTRIM(STR(PROCLINE())) + "_M410FSQL.QRY",cQryUn)
			
			EndIf
			
		EndIf 
		
		If !Empty(mv_par04)
			If (At("M",mv_par03)!=0 .or. At("P",mv_par03)!=0) .AND. At( Alltrim(__CUSERID) , GETNEWPAR("TF_CRDFILT","000348|000134") ) != 0
				cQuery += " AND EXISTS ("
				cQuery += " SELECT 'X' FROM " + RetSqlName("SC9") + " SC9 WITH(NOLOCK) "
				cQuery += "	WHERE SC9.D_E_L_E_T_=' ' "
				cQuery += "	AND SC9.C9_FILIAL='" + xFilial("SC9") + "' "
				cQuery += "	AND SC9.C9_NFISCAL=' ' "
				cQuery += "	AND SC9.C9_BLCRED ='09' "
				cQuery += "	AND SC9.C9_FILIAL=C5_FILIAL "
				cQuery += "	AND SC9.C9_PEDIDO=C5_NUM "
				cQuery += "	AND SC9.C9_CLIENTE=C5_CLIENTE "
				cQuery += "	AND SC9.C9_LOJA=C5_LOJACLI "
				cQuery += "	AND SC9.C9_DATALIB = '" +Dtos(mv_par04)+"' "
				cQuery += " )"
			EndIf
			If At("L",mv_par03)!=0 .AND. At( Alltrim(__CUSERID) , GETNEWPAR("TF_CRDFILT","000348|000134") ) != 0
				cQuery += " AND EXISTS ("
				cQuery += " SELECT 'X' FROM " + RetSqlName("SC9") + " SC9 WITH(NOLOCK) "
				cQuery += "	WHERE SC9.D_E_L_E_T_=' ' "
				cQuery += "	AND SC9.C9_FILIAL='" + xFilial("SC9") + "' "
				cQuery += "	AND SC9.C9_NFISCAL=' ' "
				cQuery += "	AND SC9.C9_BLCRED ='' "
				cQuery += "	AND SC9.C9_FILIAL=C5_FILIAL "
				cQuery += "	AND SC9.C9_PEDIDO=C5_NUM "
				cQuery += "	AND SC9.C9_CLIENTE=C5_CLIENTE "
				cQuery += "	AND SC9.C9_LOJA=C5_LOJACLI "
				cQuery += "	AND SC9.C9_DATALIB = '" +Dtos(mv_par04)+"' "
				cQuery += " )"
			EndIf
		EndIF
		
		If MV_PAR05 = 2
		
			cQuery += " .AND. C5_FILDES = '" + CFILANT + "' "
			
		EndIf
		
	ElseIf !(cEmpAnt+cFilAnt) $ SuperGetMV("MV__MULT06",.F.,"") .AND. (cEmpAnt+cFilAnt) $ SuperGetMV("MV__SEPA01",.F.,"") //Rotinas de Avaliacao de Credito Desativadas e Expedicao ativadas
		
		ValidP01("SEPMI00001")
		Pergunte("SEPMI00001",.T.)
		cQuery += " (C5_YSTSEP $ '["+mv_par03+" ]' .OR. C5_YSTSEP = '') .AND. C5_EMISSAO>='"+DTOS(mv_par01)+"' .AND. C5_EMISSAO <= '"+DTOS(mv_par02)+"'"
		
		/*
		|=================================================================================
		|   COMENTARIO
		|---------------------------------------------------------------------------------
		|	Trata filtro com a Unidade de Negocio
		|	Edson Hornberger - 07/11/2013
		|=================================================================================
		*/
		
		If lAvnFSII
			
			cQuery += " .AND. (C5_XITEMC = '" + cUnidNeg + "' .OR. C5_XITEMC = '')"	
			If cCLASSPED = "A"
				cQuery += " .AND. (C5_CLASPED = '" + cCLASSPED + "' )"
			Else
				cQuery += " .AND. (C5_CLASPED != 'A' )"
			EndIf	
			
			//Deleta o controle da Tabela e Controle de Filtro
			cQryUn := "DELETE" + Pula
			cQryUn += "CONTROLE_LEGENDA" + Pula 
			cQryUn += "WHERE" + Pula 
			cQryUn	+= "EMPRESA = '" + cEmpAnt + "' AND" + Pula
			cQryUn	+= "FILIAL = '" + cFilAnt + "' AND" + Pula 
			cQryUn	+= "USUARIO = '" + __cUserID + "' AND" + Pula
			cQryUn	+= "NTHREAD = " + cValToChar(nThread) + " AND" + Pula
			cQryUn	+= "UNNEGOC = '" + cUnidNeg + "'"
			
			If TcSQLExec(cQryUn) < 0 
			
				MSGSTOP(OEMTOANSI("Erro ao tentar excluir o Controle Unidade de Neg�cio!") + Pula + "FONTE: " + ALLTRIM(PROCNAME()) + " LINHA: " + ALLTRIM(STR(PROCLINE())),OEMTOANSI("Unidade de Neg�cio"))
				//MEMOWRITE(GetTempPath() + "/ln" + ALLTRIM(STR(PROCLINE())) + "_M410FSQL.QRY",cQryUn)
			
			EndIf
			
		EndIf
		
		If !Empty(mv_par04)
			If (At("M",mv_par03)!=0 .or. At("P",mv_par03)!=0) .AND. At( Alltrim(__CUSERID) , GETNEWPAR("TF_CRDFILT","000348|000134") ) != 0
				cQuery += " AND EXISTS ("
				cQuery += " SELECT 'X' FROM " + RetSqlName("SC9") + " SC9 WITH(NOLOCK) "
				cQuery += "	WHERE SC9.D_E_L_E_T_=' ' "
				cQuery += "	AND SC9.C9_FILIAL='" + xFilial("SC9") + "' "
				cQuery += "	AND SC9.C9_NFISCAL=' ' "
				cQuery += "	AND SC9.C9_BLCRED ='09' "
				cQuery += "	AND SC9.C9_FILIAL=C5_FILIAL "
				cQuery += "	AND SC9.C9_PEDIDO=C5_NUM "
				cQuery += "	AND SC9.C9_CLIENTE=C5_CLIENTE "
				cQuery += "	AND SC9.C9_LOJA=C5_LOJACLI "
				cQuery += "	AND SC9.C9_DATALIB = '" +Dtos(mv_par04)+"' "
				cQuery += " )"
			EndIf
			If At("L",mv_par03)!=0 .AND. At( Alltrim(__CUSERID) , GETNEWPAR("TF_CRDFILT","000348|000134") ) != 0
				cQuery += " AND EXISTS ("
				cQuery += " SELECT 'X' FROM " + RetSqlName("SC9") + " SC9 WITH(NOLOCK) "
				cQuery += "	WHERE SC9.D_E_L_E_T_=' ' "
				cQuery += "	AND SC9.C9_FILIAL='" + xFilial("SC9") + "' "
				cQuery += "	AND SC9.C9_NFISCAL=' ' "
				cQuery += "	AND SC9.C9_BLCRED ='' "
				cQuery += "	AND SC9.C9_FILIAL=C5_FILIAL "
				cQuery += "	AND SC9.C9_PEDIDO=C5_NUM "
				cQuery += "	AND SC9.C9_CLIENTE=C5_CLIENTE "
				cQuery += "	AND SC9.C9_LOJA=C5_LOJACLI "
				cQuery += "	AND SC9.C9_DATALIB = '" +Dtos(mv_par04)+"' "
				cQuery += " )"
			EndIf
		EndIF
	ElseIf (cEmpAnt+cFilAnt) $ SuperGetMV("MV__MULT06",.F.,"") .AND. (cEmpAnt+cFilAnt) $ SuperGetMV("MV__SEPA01",.F.,"") //Rotinas de Avaliacao de Credito Ativadas e Expedicao Ativadas
		_nOpc := Aviso("M410FSQL - Filtro de Pedidos","Deseja Realizar o filtro para Analise de Credito ou Rotinas de Expedicao?",{"Credito","Expedicao"})
		If _nOpc == 1
			U_PMALBC_X1()
			Pergunte("FATMI00005",.T.)
			cQuery += " C5_XLIBCR $ '["+mv_par03+"]' .AND. C5_EMISSAO>='"+DTOS(mv_par01)+"' .AND. C5_EMISSAO <= '"+DTOS(mv_par02)+"'"
			If MV_PAR05 = 2
				cQuery += " .AND. C5_FILDES = '" + CFILANT + "' "
			EndIf
		ElseIf _nOpc == 2
			ValidP01("SEPMI00001")
			Pergunte("SEPMI00001",.T.)
			cQuery += " (C5_YSTSEP $ '["+mv_par03+" ]' .OR. C5_YSTSEP = '') .AND. C5_XLIBCR = 'L' .AND. C5_EMISSAO>='"+DTOS(mv_par01)+"' .AND. C5_EMISSAO <= '"+DTOS(mv_par02)+"'"
			If MV_PAR04 = 2
				cQuery += " .AND. C5_FILDES = '" + CFILANT + "' "
			EndIf
		EndIf
		
		/*
		|=================================================================================
		|   COMENTARIO
		|---------------------------------------------------------------------------------
		|	Trata filtro com a Unidade de Negocio
		|	Edson Hornberger - 07/11/2013
		|=================================================================================
		*/
		
		If lAvnFSII
			
			cQuery += " .AND. (C5_XITEMC = '" + cUnidNeg + "' .OR. C5_XITEMC = '')"	
			If cCLASSPED = "A"
				cQuery += " .AND. (C5_CLASPED = '" + cCLASSPED + "' )"
			Else
				cQuery += " .AND. (C5_CLASPED != 'A' )"
			EndIf	
			
			//Deleta o controle da Tabela e Controle de Filtro
			cQryUn := "DELETE" + Pula
			cQryUn += "CONTROLE_LEGENDA" + Pula 
			cQryUn += "WHERE" + Pula 
			cQryUn	+= "EMPRESA = '" + cEmpAnt + "' AND" + Pula
			cQryUn	+= "FILIAL = '" + cFilAnt + "' AND" + Pula 
			cQryUn	+= "USUARIO = '" + __cUserID + "' AND" + Pula
			cQryUn	+= "NTHREAD = " + cValToChar(nThread) + " AND" + Pula
			cQryUn	+= "UNNEGOC = '" + cUnidNeg + "'"
			
			If TcSQLExec(cQryUn) < 0 
			
				MSGSTOP(OEMTOANSI("Erro ao tentar excluir o Controle Unidade de Neg�cio!") + Pula + "FONTE: " + ALLTRIM(PROCNAME()) + " LINHA: " + ALLTRIM(STR(PROCLINE())),OEMTOANSI("Unidade de Neg�cio"))
				//MEMOWRITE(GetTempPath() + "/ln" + ALLTRIM(STR(PROCLINE())) + "_M410FSQL.QRY",cQryUn)
			
			EndIf
			
		EndIf
		
	EndIf

Return cQuery


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �SitCredPed  �Autor  �Thiago Comelli    � Data �  26/11/12   ���
�������������������������������������������������������������������������͹��
���Desc.     �Janela de sele��o dos Status do cr�dito para posterior      ���
���          �filtro                                                      ���
�������������������������������������������������������������������������͹��
���Uso       �PROART                                                      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function SitCredPed(l1Elem,lTipoRet)

	Local cTitulo:=""
	Local MvPar
	Local MvParDef:=""

	Private aSit:={}
	l1Elem := If (l1Elem = Nil , .F. , .T.)

	DEFAULT lTipoRet := .T.

	cAlias := Alias() 					 							// Salva Alias Anterior

	IF lTipoRet
		MvPar:=&(Alltrim(ReadVar()))		 						// Carrega Nome da Variavel do Get em Questao
		mvRet:=Alltrim(ReadVar())			 						// Iguala Nome da Variavel ao Nome variavel de Retorno
	EndIF

	cTitulo := "Situa��es Cr�dito"

	aSit := {	"P - Aguardando Avaliacao Automatica",;
				"M - Aguardando Avaliacao Manual",;
				"A - Aguardando Avaliacao Devido Altera��o de Dados",;
				"L - Cr�dito Aprovado",;
				"B - Cr�dito Bloqueado",;
				"C - Aguardando Avalia��o Complementar"}

	MvParDef:="PMALB"

	IF lTipoRet
		IF f_Opcoes(@MvPar,cTitulo,aSit,MvParDef,12,49,l1Elem)  	// Chama funcao f_Opcoes
			&MvRet := mvpar                                     	// Devolve Resultado
		EndIF
	EndIF

	dbSelectArea(cAlias) 								 			// Retorna Alias

Return( IF( lTipoRet , .T. , MvParDef ) )

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �SitSepPed  �Autor  �Thiago Comelli    � Data �  26/11/12		 ���
�������������������������������������������������������������������������͹��
���Desc.     �Janela de sele��o dos Status do cr�dito para posterior      ���
���          �filtro                                                      ���
�������������������������������������������������������������������������͹��
���Uso       �PROART                                                      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function SitSepPed(l1Elem,lTipoRet)

	Local cTitulo:=""
	Local MvPar
	Local MvParDef:=""

	Private aSit:={}
	l1Elem := If (l1Elem = Nil , .F. , .T.)

	DEFAULT lTipoRet := .T.

	cAlias := Alias() 					 							// Salva Alias Anterior

	IF lTipoRet
		MvPar:=&(Alltrim(ReadVar()))		 						// Carrega Nome da Variavel do Get em Questao
		mvRet:=Alltrim(ReadVar())			 						// Iguala Nome da Variavel ao Nome variavel de Retorno
	EndIF

	cTitulo := "Situa��es da Separacao"

	aSit := {	"S - Etiquetas Impressas",;
				"C - Em Separa��o/Conferencia",;
				"G - Conferencia Finalizada",;
				"E - Erro no Calculo de Embalagens",;
				"N - Separacao Nao Iniciada/Calculado";
			}

	MvParDef:="SCGEN"

	IF lTipoRet
		IF f_Opcoes(@MvPar,cTitulo,aSit,MvParDef,12,49,l1Elem)  	// Chama funcao f_Opcoes
			&MvRet := mvpar                                         // Devolve Resultado
		EndIF
	EndIF

	dbSelectArea(cAlias) 								 			// Retorna Alias

Return( IF( lTipoRet , .T. , MvParDef ) )

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �ValidPerg �Autor  � Fernando Salvatori � Data � 26/01/2010  ���
�������������������������������������������������������������������������͹��
���Desc.     � Cria Grupo de Perguntas para este Processamento            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � 		                                                     ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function ValidPerg( cPerg )

	Local aSX1    	:= {}
	Local aEstrut 	:= {}
	Local i       	:= 0
	Local j      	:= 0
	Local aHelp		:={}
	Local aArea		:= GetArea()
	
	aEstrut:= { "X1_GRUPO"  ,"X1_ORDEM","X1_PERGUNT","X1_PERSPA","X1_PERENG" ,"X1_VARIAVL","X1_TIPO" ,"X1_TAMANHO","X1_DECIMAL","X1_PRESEL" ,;
				"X1_GSC"    ,"X1_VALID","X1_VAR01"  ,"X1_DEF01" ,"X1_DEFSPA1","X1_DEFENG1","X1_CNT01","X1_VAR02"  ,"X1_DEF02"  ,"X1_DEFSPA2",;
				"X1_DEFENG2","X1_CNT02","X1_VAR03"  ,"X1_DEF03" ,"X1_DEFSPA3","X1_DEFENG3","X1_CNT03","X1_VAR04"  ,"X1_DEF04"  ,"X1_DEFSPA4",;
				"X1_DEFENG4","X1_CNT04","X1_VAR05"  ,"X1_DEF05" ,"X1_DEFSPA5","X1_DEFENG5","X1_CNT05","X1_F3"     ,"X1_GRPSXG" ,"X1_PYME"}

	aHelp := {}
	AAdd( aHelp, 'Informe a emissao inicial' )
	PutSX1( cPerg,"01","Emissao Inicial?","Emissao Inicial?","Emissao Inicial?","mv_ch1","D",8,0,0,"G","","","","","mv_par01","","","","","","","","","","","","","","","","",aHelp,aHelp,aHelp)

	aHelp := {}
	AAdd( aHelp, 'Informe a emissao final' )
	PutSX1( cPerg,"02","Emissao Final?","Emissao Final?","Emissao Final?","mv_ch2","D",8,0,0,"G","","","","","mv_par02","","","","","","","","","","","","","","","","",aHelp,aHelp,aHelp)

	aHelp := {}
	AAdd( aHelp, 'Informe o status do Cr�dito' )
	PutSx1(cPerg,"03","Status ?                      ","Status ?                      ","Status ?                      ","MV_CH3","C",5,0,5,"G","U_SitCredPed                                                  ","      ","   "," ","MV_PAR03","","               ","               ","                                                            ","","               ","               ","","               ","               ","","               ","               ","   ","               ","          ","","","","")
    
	aHelp := {}
	AAdd( aHelp, 'Informe data libera�ao do pedido para ' )
	AAdd( aHelp, 'compor filtro de pedidos nao faturados' )
	PutSx1(cPerg,"04","Data Lib. Pedido ?","Data Lib. Pedido ?","Data Lib. Pedido ? ","MV_CH4","D",8,0,0,"G","","","","","MV_PAR04","","","","","","","","","","","","","","","","",aHelp,aHelp,aHelp)
	
	aHelp := {}
	AAdd( aHelp, 'Filtro dos Pedidos Atendimento SP?' ) 	
	PutSx1(cPerg,"05","Mostra SP?"	,"Mostra SP?"	,"Mostra SP?"	,"MV_CH5","C",1,0,0,"G","","","","","MV_PAR05","Sim","","","","Nao","","","","","","","","","","","",aHelp,aHelp,aHelp)
	
	dbSelectArea("SX1")
	dbSetOrder(1)
	For i:= 1 To Len(aSX1)
		If !Empty(aSX1[i][1])
			If !dbSeek( PadR( aSX1[i,1], 10 ) + aSX1[i,2] )
				RecLock("SX1",.T.)
			Else
				RecLock("SX1",.F.)
			Endif
			For j:=1 To Len(aSX1[i])
				If !Empty(FieldName(FieldPos(aEstrut[j])))
					FieldPut(FieldPos(aEstrut[j]),aSX1[i,j])
				EndIf
			Next j
			MsUnLock()
		EndIf
	Next i
	RestArea(aArea)
	
Return Nil

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �ValidPerg �Autor  � Fernando Salvatori � Data � 26/01/2010  ���
�������������������������������������������������������������������������͹��
���Desc.     � Cria Grupo de Perguntas para este Processamento            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � 		                                                     ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function ValidP01( cPerg )
	
	Local aSX1    	:= {}
	Local aEstrut 	:= {}
	Local i       	:= 0
	Local j      	:= 0
	Local aHelp		:= {}
	Local aArea		:= GetArea()
	//          1            2          3            4           5            6            7          8            9            10
	aEstrut:= { "X1_GRUPO"  ,"X1_ORDEM","X1_PERGUNT","X1_PERSPA","X1_PERENG" ,"X1_VARIAVL","X1_TIPO" ,"X1_TAMANHO","X1_DECIMAL","X1_PRESEL" ,;
				"X1_GSC"    ,"X1_VALID","X1_VAR01"  ,"X1_DEF01" ,"X1_DEFSPA1","X1_DEFENG1","X1_CNT01","X1_VAR02"  ,"X1_DEF02"  ,"X1_DEFSPA2",;
				"X1_DEFENG2","X1_CNT02","X1_VAR03"  ,"X1_DEF03" ,"X1_DEFSPA3","X1_DEFENG3","X1_CNT03","X1_VAR04"  ,"X1_DEF04"  ,"X1_DEFSPA4",;
				"X1_DEFENG4","X1_CNT04","X1_VAR05"  ,"X1_DEF05" ,"X1_DEFSPA5","X1_DEFENG5","X1_CNT05","X1_F3"     ,"X1_GRPSXG" ,"X1_PYME"}

	aHelp := {}
	AAdd( aHelp, 'Informe a emissao inicial' )
	PutSX1Help("P." + cPerg + "01.",aHelp,aHelp,aHelp)
	aAdd(aSX1,{cPerg		,"01","Emissao Inicial?","Emissao Inicial?","Emissao Inicial?"	,"mv_ch1","D",8,0,0,"G","","mv_par01"})

	aHelp := {}
	AAdd( aHelp, 'Informe a emissao final' )
	PutSX1Help("P." + cPerg + "02.",aHelp,aHelp,aHelp)
	aAdd(aSX1,{cPerg		,"02","Emissao Final?"	,"Emissao Final?"	,"Emissao Final?"	,"mv_ch2","D",8,0,0,"G","","mv_par02"})

	aHelp := {}
	AAdd( aHelp, 'Informe o status da Separacao' )
	PutSX1Help("P." + cPerg + "03.",aHelp,aHelp,aHelp)
	aAdd(aSX1,{cPerg		,"03","Status?"			,"Status?"			,"Status?"			,"MV_CH3","C",5,0,5,"G","U_SitSepPed","MV_PAR03"})
	
	aHelp := {}
	AAdd( aHelp, 'Filtro dos Pedidos Atendimento SP?' )
	PutSX1Help("P." + cPerg + "04.",aHelp,aHelp,aHelp) 	
	aAdd(aSX1,{cPerg		,"04","Mostra SP?"		,"Mostra SP?"		,"Mostra SP?"		,"MV_CH4","C",1,0,2,"C","","MV_PAR04","Sim","","","","","Nao"})
	
	dbSelectArea("SX1")
	dbSetOrder(1)
	For i:= 1 To Len(aSX1)
		If !Empty(aSX1[i][1])
			If !dbSeek( PadR( aSX1[i,1], 10 ) + aSX1[i,2] )
				RecLock("SX1",.T.)
			Else
				RecLock("SX1",.F.)
			Endif
			For j:=1 To Len(aSX1[i])
				If !Empty(FieldName(FieldPos(aEstrut[j])))
					FieldPut(FieldPos(aEstrut[j]),aSX1[i,j])
				EndIf
			Next j
			MsUnLock()
		EndIf
	Next i
	RestArea(aArea)
	
Return Nil

/*
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
����������������������������������������������������������������������������Ŀ��
���Fun��o    � PMALBC_X1 � Autor � WAGNER MONTENEGRO       � Data � 19/02/13 ���
����������������������������������������������������������������������������Ĵ��
���Descri��o � Funcao de Ajuste do SX1                                       ���
����������������������������������������������������������������������������Ĵ��
��� Uso      � ATUALIZACAO PERGUNTA FATMI00005                               ���
��������������������������������������������������������������������������������
*/
USER Function PMALBC_X1()
	
	Local aSX1    	:= {}
	Local aEstrut 	:= {}
	Local i       	:= 0
	Local j      	:= 0
	Local aHelp		:= {}
	Local aArea		:= GetArea()
	aEstrut:= { "X1_GRUPO"  ,"X1_ORDEM","X1_PERGUNT","X1_PERSPA","X1_PERENG" ,"X1_VARIAVL","X1_TIPO" ,"X1_TAMANHO","X1_DECIMAL","X1_PRESEL" ,;
				"X1_GSC"    ,"X1_VALID","X1_VAR01"  ,"X1_DEF01" ,"X1_DEFSPA1","X1_DEFENG1","X1_CNT01","X1_VAR02"  ,"X1_DEF02"  ,"X1_DEFSPA2",;
				"X1_DEFENG2","X1_CNT02","X1_VAR03"  ,"X1_DEF03" ,"X1_DEFSPA3","X1_DEFENG3","X1_CNT03","X1_VAR04"  ,"X1_DEF04"  ,"X1_DEFSPA4",;
				"X1_DEFENG4","X1_CNT04","X1_VAR05"  ,"X1_DEF05" ,"X1_DEFSPA5","X1_DEFENG5","X1_CNT05","X1_F3"     ,"X1_GRPSXG" ,"X1_PYME"}

	aHelp := {}
	AAdd( aHelp, 'Informe a emissao inicial' )
	PutSX1Help("P.FATMI0000501.",aHelp,aHelp,aHelp)
	aAdd(aSX1,{"FATMI00005","01","Emissao Inicial?"		,"Emissao Inicial?"		,"Emissao Inicial?"		,"mv_ch1","D",8,0,0,"G",""				,"mv_par01"})

	aHelp := {}
	AAdd( aHelp, 'Informe a emissao final' )
	PutSX1Help("P.FATMI0000502.",aHelp,aHelp,aHelp)
	aAdd(aSX1,{"FATMI00005","02","Emissao Final?"		,"Emissao Final?"		,"Emissao Final?"		,"mv_ch2","D",8,0,0,"G",""				,"mv_par02"})

	aHelp := {}
	AAdd( aHelp, 'Informe o status do Cr�dito' )
	PutSX1Help("P.FATMI0000503.",aHelp,aHelp,aHelp)
	aAdd(aSX1,{"FATMI00005","03","Status ?"				,"Status ?"				,"Status ?"				,"MV_CH3","C",6,0,6,"G","U_SitCredPed"	,"MV_PAR03"})

	aHelp := {}
	AAdd( aHelp, 'Informe data libera�ao do pedido para ' )
	AAdd( aHelp, 'compor filtro de pedidos nao faturados' )
	PutSX1Help("P.FATMI0000504.",aHelp,aHelp,aHelp)
	aAdd(aSX1,{"FATMI00005","04" 	,"Data Lib. Pedido ?"  	,"Data Lib. Pedido ?"	,"Data Lib. Pedido ? "  ,"MV_CH4","D",8,0,0,"G","" 				,"MV_PAR04"})
	
	aHelp := {}
	AAdd( aHelp, 'Filtro dos Pedidos Atendimento SP?' )
	PutSX1Help("P.FATMI0000505.",aHelp,aHelp,aHelp) 	
	aAdd(aSX1,{"FATMI00005","05"	,"Mostra SP?"			,"Mostra SP?"			,"Mostra SP?"			,"MV_CH5","C",1,0,0,"C",""				,"MV_PAR05","Sim","","","","","Nao"})
	
	dbSelectArea("SX1")
	dbSetOrder(1)
	For i:= 1 To Len(aSX1)
		If !Empty(aSX1[i][1])
			If !dbSeek( PadR( aSX1[i,1], 10 ) + aSX1[i,2] )
				RecLock("SX1",.T.)
			Else
				RecLock("SX1",.F.)
			Endif
			For j:=1 To Len(aSX1[i])
				If !Empty(FieldName(FieldPos(aEstrut[j])))
					FieldPut(FieldPos(aEstrut[j]),aSX1[i,j])
				EndIf
			Next j
			MsUnLock()
		EndIf
	Next i
	RestArea(aArea)
	
Return
