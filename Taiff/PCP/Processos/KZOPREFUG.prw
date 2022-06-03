#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TBICONN.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±º                ___  "  ___                             		      		   º±±
±±º              ( ___ \|/ ___ ) Kazoolo                   		      		   º±±
±±º               ( __ /|\ __ )  Codefacttory 				      			   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºFuncao    ³KZOPREFUG		 ºAutor  ³Adam Diniz Lima	  º Data ³  15/02/2012 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Funcao responsavel pela chamada do pergunte para preenchimento  º±±
±±º			 ³	dos parametros para geracao de OP DE REFUGO					   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³			                                                       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametros³ 																   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºRetorno   ³ 								                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function KZOPREFUG()

	Local olArmz	:= Nil
	Local olGArm	:= Nil
		
	Local olEnd		:= Nil
	Local olGEnd	:= Nil
	
	Local olProd	:= Nil
	Local olGProd	:= Nil
	
	Local olQtd		:= Nil
	Local olGQtd	:= Nil	

	Local oDlg		:= Nil 
	
	Local alList	:= {}

	Local alBtns	:= {{"AVGBOX1",{|| alList := KzConEst(AllTrim(clArm), AllTrim(clEnd))},"Saldo" }}
	
	Local clArm		:= Space(TAMSX3("BE_LOCAL")[1])
	Local clEnd		:= Space(TAMSX3("BE_LOCALIZ")[1])
	Local clProd	:= Space(TAMSX3("B1_COD")[1])
	Local nlQtd		:= 0

	DEFINE MSDIALOG oDlg  FROM 0,0 TO 170,480 PIXEL TITLE OemToAnsi('OP REFUGO') COLORS 0, 16777215

		@027,010 SAY olArmz PROMPT "Armazem" SIZE 040,015 OF oDlg PIXEL 
		@025,050 MSGET olGArm VAR clArm F3 "KZSBE" SIZE 060,010 OF oDlg Valid Iif(!Empty(clArm),ExistCpo("SBE",AllTrim(clArm),1),.T.) PIXEL  
		
		@027,120 SAY olEnd PROMPT "Endereço" SIZE 040,015 OF oDlg 	PIXEL 
		@025,150 MSGET olGEnd VAR clEnd   SIZE 060,010  OF oDlg	Valid Iif(!Empty(clEnd).And.!Empty(clArm),ExistCpo("SBE",AllTrim(clArm)+AllTrim(clEnd),1),.T.) PIXEL 

		@050,010 SAY olProd PROMPT "Produto Destino" SIZE 040,015 OF oDlg PIXEL 
		@048,050 MSGET olGProd VAR clProd F3 "SB1" SIZE 060,010 OF oDlg Valid Iif(!Empty(clProd),KzProdVld(AllTrim(clProd)),.T.) PIXEL  
		
		@050,120 SAY olQtd PROMPT "Qtde/Peso Destino" SIZE 040,015 OF oDlg 	PIXEL 
		@048,150 MSGET olGQtd VAR nlQtd   SIZE 060,010 PICTURE "@E 999999999.99"  OF oDlg	Valid (nlQtd >= 0) PIXEL 

			
	ACTIVATE MSDIALOG oDlg CENTERED ON INIT (EnchoiceBar(oDlg,		{|| IIf(Empty(clArm).Or.Empty(clEnd).Or.Empty(clProd).Or.(nlQtd <= 0),MsgInfo("Informe corretamente todas as informações para prosseguir",PROCNAME()),(Iif(KzGeraOp(AllTrim(clProd),nlQtd,AllTrim(clArm),AllTrim(clEnd),alList),oDlg:END(),)) ) },; // Botao Ok
									 								{|| oDlg:END() },; // Botao Cancel
									  								.F.,alBtns)) 
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±º                ___  "  ___                             		      		   º±±
±±º              ( ___ \|/ ___ ) Kazoolo                   		      		   º±±
±±º               ( __ /|\ __ )  Codefacttory 				      			   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºFuncao    ³KzConEst		 ºAutor  ³Adam Diniz Lima	  º Data ³  29/02/2012 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Funcao responsavel pela realizacao da consulta de estoque em    º±±
±±º			 ³	funcao da selecao feita na tela anterior					   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³			                                                       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametros³ clArm - Armazem 												   º±±
±±º			 ³ clEnd - Endereco 											   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºRetorno   ³ alDados - Array com as informacoes do saldo dos produtos        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function KzConEst(clArm, clEnd)

	Local alCabec	:= {"Armazem","Endereco","Produto","Saldo"}
	Local alTamanho	:= {TamSx3("BF_LOCAL")[1],TamSx3("BF_LOCALIZ")[1],TamSx3("BF_PRODUTO")[1],TamSx3("BF_QUANT")[1]}
    Local alDados	:= {}

	Local olLista	:= Nil
	Local oDlg		:= Nil

	If Empty(clArm) .Or. Empty(clEnd)
		MsgInfo("Informe um Armazem e um Endereço para realizar a consulta")
		Return Array(1,1)
	EndIf

	DEFINE MSDIALOG oDlg  FROM 0,0 TO 335,396 PIXEL TITLE OemToAnsi('Saldo Estoque')
		
		olLista := TCBrowse():New( 012, 000, 200, 155,,alCabec,alTamanho,oDlg,,,,,{||},,,,,,,.F.,,.T.,,.F.,,.T.,.T.)
	
		alDados := KZLista(clArm, clEnd)
		olLista:lAdjustColSize := .T.
		olLista:SetArray(alDados)
		olLista:bLine 		:= {|| {alDados[olLista:nAt][1],;     
									alDados[olLista:nAt][2],;
									alDados[olLista:nAt][3],;
									alDados[olLista:nAt][4]}}

	ACTIVATE MSDIALOG oDlg CENTERED ON INIT (EnchoiceBar(oDlg,		{|| oDlg:End() },; // Botao Ok
									 								{|| oDlg:END() },; // Botao Cancel
									  								.F. 			,)) 
	
Return alDados
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±º                ___  "  ___                             		      		   º±±
±±º              ( ___ \|/ ___ ) Kazoolo                   		      		   º±±
±±º               ( __ /|\ __ )  Codefacttory 				      			   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºFuncao    ³KZLista		 ºAutor  ³Adam Diniz Lima	  º Data ³  29/02/2012 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Funcao responsavel pela realizacao da consulta e monta array	   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³			                                                       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametros³ clArm - Armazem 												   º±±
±±º			 ³ clEnd - Endereco 											   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºRetorno   ³ alList - Array com o resultado da consulta de estoque           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function KZLista(clArm, clEnd)
      
	Local clQry		:= ""
	Local alList	:= {} 

	clQry	:= " SELECT BF_LOCAL 	" + CRLF
	clQry	+= " ,BF_LOCALIZ		" + CRLF		
	clQry	+= " ,BF_PRODUTO		" + CRLF
	clQry	+= " ,(BF_QUANT - BF_EMPENHO) as 'SALDO' "	+ CRLF
	clQry	+= " ,BF_LOTECTL as 'LOTE' "	+ CRLF
	clQry	+= " FROM " + RetSqlName("SBF")				+ CRLF
	clQry	+= " WHERE D_E_L_E_T_ = '' "				+ CRLF
	clQry	+= " AND BF_FILIAL = "+ xFilial("SBF")		+ CRLF
	clQry	+= " AND BF_QUANT > 0 "						+ CRLF
	clQry	+= " AND BF_QUANT >= BF_EMPENHO "			+ CRLF
	clQry	+= " AND BF_LOCAL = '" + clArm+ "' "		+ CRLF
	clQry	+= " AND BF_LOCALIZ = '" + clEnd+ "' "		+ CRLF

	If Select("TEMP") > 0
		TEMP->(DbcloseArea())
	EndIf
	DbUseArea(.T.,"TOPCONN",TcGenQry(,,clQry),"TEMP",.F.,.F.)
	
	TEMP->(DbGoTop())
	If TEMP->(EOF()) 
		alList := Array(1,4)
	Else
		While TEMP->(!EOF())
			aAdd(alList, {TEMP->BF_LOCAL, TEMP->BF_LOCALIZ, TEMP->BF_PRODUTO, TEMP->Saldo, TEMP->LOTE})	
			TEMP->(DbSkip())
		EndDo
	EndIf
			
Return alList


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±º                ___  "  ___                             		      		   º±±
±±º              ( ___ \|/ ___ ) Kazoolo                   		      		   º±±
±±º               ( __ /|\ __ )  Codefacttory 				      			   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºFuncao    ³KzGeraOp		 ºAutor  ³Adam Diniz Lima	  º Data ³  15/02/2012 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Funcao responsavel pela Gravacao da Nova Ordem de producao e	   º±±
±±º		     ³	Gravacao no campo C2_OBS da OP Origem 						   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³			                                                       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametros³	clProd -  Produto Destino		   							   º±±
±±º		     ³	nlQtd - Quantidade/Peso Prod Destino	  					   º±±
±±º			 ³  clArm - Armazem												   º±±
±±º			 ³  clEnd - Endereco											   º±± 
±±º			 ³  alList - Array com produtos e saldos						   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºRetorno   ³ 								                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function KzGeraOp(clProd,nlQtd,clArm,clEnd,alList)

	Local clArmRef	:= AllTrim(GetMv("KZ_ARMREF"))
	Local clNxtNum	:= ""
	Local aMata650	:= {}
	Local alArea	:= {}
	Local nlI		:= 0 
	Local llOk		:= .T.
	Local _aCabSD3  := {}
	Local _aIteSD3  := {} 


	Private lmsErroAuto := .F.      
	
	If Len(alList) == 0 .Or. (Len(alList) == 1 .And. Empty(alList[1][1]))
		alArea := GetArea()
		alList := KZLista(clArm, clEnd)
		RestArea(alArea)
	EndIf
	
	If Len(alList) == 0 .Or. (Len(alList) == 1 .And. Empty(alList[1][1]))
		llOk := .F.
		MsgStop("Não existem produtos com saldo no Armazem e Endereço informado")
	Else
		Begin Transaction     
			clNxtNum	:= KzC2Prox()
			
			aMata650  := {;
				{'C2_NUM'		,clNxtNum			,NIL},;
				{'C2_ITEM'		,'01'	 			,NIL},;
				{'C2_SEQUEN'	,'001'	  			,NIL},;
				{'C2_PRODUTO'	,clProd				,NIL},;
				{'C2_LOCAL'		,clArmRef			,NIL},;
				{'C2_QUANT'		,nlQtd				,NIL},;
				{'C2_UM'		,Posicione("SB1",1,xFilial("SB1")+clProd,"B1_UM")	,NIL},;
				{'C2_EMISSAO'	,dDataBase 			,NIL},;
				{'C2_DATPRI'	,dDataBase 			,NIL},;
				{'C2_DATPRF'	,dDataBase 			,NIL},;
				{'C2_BATCH'		,"S" 				,NIL},;
				{'C2_TPOP'		,'F'				,NIL}}
	        
	        //Altera parametro MV_SAIDA para outro TM para geracao do SD3 correto
	        lAlterouMV:= .F.
	        cMVAntigo := ""       
	        cMVAtual  := SuperGetMV("KZ_ALTSAI")

	        dbselectarea("SX6")
			dbsetorder(1)
			If dbSeek("  MV_SAIDA")	
		        lAlterouMV:= .T.
		        cMVAntigo := AllTrim(SX6->X6_CONTEUD)

	  			RecLock("SX6",.F.)
	  		    SX6->X6_CONTEUD:= cMVAtual
  				MSUnlock()
	    	EndIf

	
			//-- Chamada da rotina automatica para GRAVACAO - INCLUSAO               0
			msExecAuto({|x,Y| Mata650(x,Y)},aMata650,3)
		
			If lmsErroAuto //-- Verifica se houve algum erro
				llOk := .F.
				MsgStop("Não foi possível realizar a inclusão da Nova Ordem de Produção")
				MostraErro()
				DISARMTRANSACTION()

				//Volta o parametro MV_SAIDA ao normal
		        If lAlterouMV
			        dbselectarea("SX6")
					dbsetorder(1)
					If dbSeek("  MV_SAIDA")	
			  			RecLock("SX6",.F.)
			  		    SX6->X6_CONTEUD:= cMVAntigo 
		  				MSUnlock()
			    	EndIf
			    	lAlterouMV:= .F.
		        EndIf
	
			Else 
				// ExecAuto raalizou a inclusao da OP NOVA
			
				_aCabSD3 :={{"D3_DOC" 		,GetSx8Num("SD3","D3_DOC") ,NIL},;
						    {"D3_TM"  		,cMVAtual	,NIL},;
				 		    {"D3_EMISSAO"	,DDATABASE	,Nil}} 
				_aIteSD3 := {}
				
				DbSelectArea("SB2")
				SB2->(DbSetOrder(1)) // Produto + Armazem
				SB2->(DbGoTop())
		
				DbSelectArea("SBF")
				SBF->(DbSetOrder(1)) // Armazem + Endereco + Produto
				SBF->(DbGoTop())
	
				For nlI := 1 to Len(alList)
					SBF->(DbGoTop())
					If SBF->(DbSeek(xFilial("SBF") + PadR(alList[nlI][1],TamSx3("BF_LOCAL")[1]) + PadR(alList[nlI][2],TamSx3("BF_LOCALIZ")[1]) + PadR(alList[nlI][3],TamSx3("B1_COD")[1])  ))
						SB2->(DbGoTop())
						If SB2->(DbSeek(xFilial("SB2")+ PadR(alList[nlI][3],TamSx3("B1_COD")[1]) + PadR(alList[nlI][1],TamSx3("BF_LOCAL")[1]) ))
				
							//CRIA SD4 DE CADA REGISTRO (EMPENHO)
							Grava_SD4(PadR(alList[nlI][3],TamSx3("B1_COD")[1]),;
							          PadR(alList[nlI][1],TamSx3("BF_LOCAL")[1]),;
							          dDataBase,;
							          SBF->BF_QUANT,;
							          clNxtNum,;
							          "",;
							          "",;
							          PadR(alList[nlI][2],TamSx3("BF_LOCALIZ")[1]),;
									  ALLTRIM(alList[nlI][5]))
                        
							If RecLock("SB2",.F.)
								//SB2->B2_QATU := SB2->B2_QATU - SBF->BF_QUANT
								SB2->B2_QEMP := SB2->B2_QEMP + SBF->BF_QUANT
								SB2->(MsUnlock())
							EndIf
				
							If RecLock("SBF", .F.)
								//SBF->BF_QUANT := 0    
								SBF->BF_EMPENHO := SBF->BF_EMPENHO + SBF->BF_QUANT
								SBF->(MsUnlock())
							EndIf
						
							
							/*
							aAdd(_aIteSD3, {{"D3_COD"	 ,PadR(alList[nlI][3],TamSx3("B1_COD")[1])      ,NIL},;
										    {"D3_UM"	 ,Posicione("SB1",1,PadR(alList[nlI][3],TamSx3("B1_COD")[1]),"B1_UM") ,NIL},;
										    {"D3_QUANT"	 ,SBF->BF_QUANT	   							    ,NIL},;
										    {"D3_OP"     ,clNxtNum+"01001" 				  	 		    ,NIL},;
										    {"D3_LOCAL"	 ,PadR(alList[nlI][1],TamSx3("BF_LOCAL")[1])	,NIL},;
										    {"D3_LOCALIZ",PadR(alList[nlI][2],TamSx3("BF_LOCALIZ")[1])	,NIL}})
		                                                                                                          
							*/
						Else
							llOk := .F.
							DISARMTRANSACTION()
							Exit
						EndIF
					Else
						llOk := .F.
						DISARMTRANSACTION()
						Exit
					EndIF
				Next nlI  
				

				//criar requisicao amarrado a OP gerada para produto destino tipo 
                /*
				MsExecAuto({|x,y,z|mata241(x,y,z)}, _aCabSD3, _aIteSD3, 3) // 4=estorno 3=distribuicao
				
				If lMsErroAuto
				    MostraErro()
					llOk := .F.
					DISARMTRANSACTION()
				Endif
				*/		
								
				If llOk	// Alerta ao usuario
					MsgInfo("Ordem de Produção gerada com sucesso"+CRLF+"OP Número: "+ clNxtNum +" 01 001")
				Else
			   		MsgStop("Erro no processo de geração da OP ou no momento de Zerar o estoque dos produtos")
				EndIf
				
			EndIf

			//Volta o parametro MV_SAIDA ao normal
	        If lAlterouMV
		        dbselectarea("SX6")
				dbsetorder(1)
				If dbSeek("  MV_SAIDA")	
		  			RecLock("SX6",.F.)
		  		    SX6->X6_CONTEUD:= cMVAntigo 
	  				MSUnlock()
		    	EndIf
		    	lAlterouMV:= .F.
	        EndIf
			
		End Transaction
	EndIf

Return llOk
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±º                ___  "  ___                             		      		   º±±
±±º              ( ___ \|/ ___ ) Kazoolo                   		      		   º±±
±±º               ( __ /|\ __ )  Codefacttory 				      			   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºFuncao    ³KzProdVld		 ºAutor  ³Adam Diniz Lima	  º Data ³  15/02/2012 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Funcao responsavel pela validacao do PRODUTO selecionado 	   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³			                                                       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametros³ clProd - Codigo do Produto									   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºRetorno   ³ Logico - Produto Valido ou nao                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function KzProdVld(clProd)

	Local llOk		:= .F.
	Local alArea	:= GetArea()

	DbSelectArea("SB1")
	SB1->(DbSetOrder(1))
	SB1->(DbGoTop())
	
	If SB1->(FieldPos("B1_REFUGO")) == 0
		ShowHelpDlg(OEMTOANSI("Atenção"), {OEMTOANSI("Campo B1_REFUGO não encontrado")},5,{OEMTOANSI("Rode o Update - UPDTAIFF")},5)
	Else
		If SB1->(DbSeek(xFilial("SB1")+clProd)) // MV_PAR01 -> PRODUTO DESTINO
			If SB1->B1_REFUGO == '1'
				llOk := .T.
			Else
				ShowHelpDlg(OEMTOANSI("Atenção"), {OEMTOANSI("Produto selecionado não é um produto de Refugo")},5,{OEMTOANSI("Vide campo B1_REFUGO, deve estar como '1-Sim'")},5)				
			EndIf
		Else
			ShowHelpDlg(OEMTOANSI("Atenção"), {OEMTOANSI("Produto não existe")},5,{OEMTOANSI("Insira um codigo válido de produto")},5)				
		EndIf
	EndIf
	RestArea(alArea)
	
Return llOk 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±º                ___  "  ___                             		      		   º±±
±±º              ( ___ \|/ ___ ) Kazoolo                   		      		   º±±
±±º               ( __ /|\ __ )  Codefacttory 				      			   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºFuncao    ³KzProdVld		 ºAutor  ³Adam Diniz Lima	  º Data ³  15/02/2012 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Funcao que busca e retorna proximo codigo de OP disponivel 	   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³			                                                       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametros³ 																   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºRetorno   ³ clNum - Proximo numero disponivel                               º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function KzC2Prox()

	Local clQry		:= ""
	Local clNum		:= ""
	Local alArea	:= GetArea()
	
	/*
	|---------------------------------------------------------------------------------
	|	Foi necessario alterar a Query abaixo, pois a mesma nao estava filtrando
	|	registros deletados, retornando numeracao errada.
	|
	|	Edson Hornberger - 20/01/2015
	|---------------------------------------------------------------------------------
	*/
	CLQRY += " SELECT MAX(C2_NUM) AS 'NUM' FROM " + RETSQLNAME("SC2") + " WHERE D_E_L_E_T_ = ''"
	
	If Select("TEMP") > 0
		TEMP->(DbcloseArea())
	EndIf
	DbUseArea(.T.,"TOPCONN",TcGenQry(,,clQry),"TEMP",.F.,.F.)
	
	TEMP->(DbGoTop())
	clNum := Soma1(TEMP->NUM)
	
	TEMP->(DbcloseArea())
	
	RestArea(alArea)
	
Return clNum 


    
//Grava empenho na SD4/SDC
Static Function Grava_SD4(cProduto,cLocal,dEntrega,nQuantItem,cOp,cTrt,cOpOrig,cLocaliza,cLoteCtl)
*************************

/*
|=================================================================================
|   COMENTARIO
|---------------------------------------------------------------------------------
|		Realizada alteracao para que seja feito o tratamento de Lote para 
|	componentes que controlem Rastro.
|
|	Edson Hornberger - 18/11/2014
|=================================================================================
*/

//Local nSaldo 	:= 0
//Local cLoteCtl 	:= "" 
Local dLoteVld	:= CTOD("  /  /  ")
Local aArea		:= GetArea()
Local aAreaSBF 	:= SBF->(GetArea())

/*
IF RASTRO(CPRODUTO)

	SB8->(dbSetOrder( 3 ))
	cChave := xFilial( "SB8" ) + cProduto + cLocal + cLoteCtl
	SB8->(MsSeek( cChave, .f. ))
	
	While nSaldo <= 0 .And. cProduto = SB8->B8_PRODUTO .And. cLocal = SB8->B8_LOCAL .And. SB8->(!EOF())
	
		nSaldo := SaldoLote( cProduto, cLocal, cLoteCtl )
		DBSELECTAREA("SD4")
		DBSETORDER(1)
		IF DBSEEK(XFILIAL("SD4") + CPRODUTO + AllTrim(cOp)+"01001")
			
			IF SD4->D4_LOTECTL = CLOTECTL
			
				nSaldo -= SD4->D4_QUANT
			
			ENDIF 
			
		ENDIF
	
		If nSaldo > 0
			cLoteCtl 	:= SB8->B8_LOTECTL
			dLoteVld	:= SB8->B8_DTVALID	
		EndIf
		
		SB8->(dbSkip())
		
	EndDo
	
ELSE

	nSaldo := nQuantItem

ENDIF
*/
//controle de empenhos
RecLock("SD4",/* IIf(Eof(),*/.T.) //,!(SD4->D4_OPORIG == cOpOrig)))
SD4->D4_FILIAL  := xFilial("SD4")
SD4->D4_COD   	:= cProduto
SD4->D4_OP		:= AllTrim(cOp)+"01001"
SD4->D4_TRT     := cTrt
SD4->D4_DATA	:= dEntrega
SD4->D4_LOCAL	:= cLocal
SD4->D4_QUANT	:= nQuantItem //nSaldo/*D4_QUANT+ nQuantItem*/
SD4->D4_QTDEORI	:= nQuantItem //nSaldo/*D4_QTDEORI+ nQuantItem*/
SD4->D4_OPORIG	:= cOpOrig
SD4->D4_LOTECTL	:= cLoteCtl
SD4->D4_DTVALID	:= dLoteVld
SD4->D4_NUMLOTE	:= ""
MsUnlock()

//empenhos por endereco
RecLock("SDC",.t.)
SDC->DC_FILIAL  := xFilial("SDC")
SDC->DC_ORIGEM  := "SD3" 
SDC->DC_PRODUTO := cProduto
SDC->DC_LOCAL	:= cLocal
SDC->DC_LOCALIZ	:= cLocaliza
SDC->DC_LOTECTL := cLoteCtl
SDC->DC_QUANT	:= /*D4_QUANT+*/ nQuantItem
SDC->DC_OP		:= AllTrim(cOp)+"01001"
SDC->DC_SEQ		:= "01" 
SDC->DC_TRT     := cTrt
MsUnlock()

RestArea(aAreaSBF)
RestArea(aArea)

Return(.T.)
