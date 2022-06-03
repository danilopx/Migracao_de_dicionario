#include "protheus.ch"
#include "topconn.ch"
#DEFINE ENTER Chr(13)+Chr(10)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³TFRECEETQ ºAutor  ³Carlos Torres       º Data ³  23/07/13   º±±
±±ºReferencia³PRTR0002  ºAutor  ³Thiago Comelli      º Data ³  26/07/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³IMPRESSAO DE ETIQUETAS "FANTASMA" DE SEPARACAO DE CAIXAS 	  º±±
±±º          ³AVULSAS ESTEIRA                             					  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Específico PROART                                          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function TFETIQ_OS()

	Local Arq  			:= CriaTrab(,.F.)+".TXT" //Nome do Arquivo a Gerar
	Local Path 			:= GetTempPath() + Arq //Local de Geração do Arquivo
	Local cPedAt 		:= ""
	Local cUserAut 		:= GETMV("MV_REIMPET") //Alterado por Thiago 02-05-13
	Local cUsu			:= ALLTRIM(RetCodUsr())
	Local cSeqL			:= '1'
	Local lReimp		:= .F.
	//Local Path := StrTran(GetSrvProfString("StartPath","") + Arq,":","") //Local de Geração do Arquivo
	Private cPerg 		:= PADR("TFTR00016",10) //Pergunta
	Private cPorta		:= AllTrim(SuperGetMV("PRT_ETQ002",.F., "LPT1")) //Define a porta padrão da impressora
	Private nHdl


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Verifica a Existencia de Parametro PRT_ETQ002³
//³Caso nao exista. Cria o parametro.           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SX6")
	If ! dbSeek("  "+"PRT_ETQ002")
		RecLock("SX6",.T.)
		X6_VAR    	:= "PRT_ETQ002"
		X6_TIPO 	:= "C"
		X6_CONTEUD 	:= "LPT1"
		X6_CONTENG 	:= "LPT1"
		X6_CONTSPA 	:= "LPT1"
		X6_DESCRIC	:= "DEFINE A PORTA DA IMPRESSORA DE ETIQUETAS PARA A  "
		X6_DESC1	:= "ROTINA PRTR00002                                  "
		X6_DESC2	:= "                                                  "
		MsUnlock("SX6")
	EndIf

	ValidPerg()

	If Pergunte(cPerg,.T.)

//Seleciona dados para manipulação

		cQuery := "SELECT C5_NUM, C5_YSTSEP FROM "+RetSqlName("SC5")+" C5 WITH(NOLOCK) " + ENTER
		cQuery += "	INNER JOIN "+RetSqlName("SC9")+" AS SC9"+ENTER
		cQuery += "		ON SC9.D_E_L_E_T_ = ''"+ENTER
		cQuery += "		AND C9_FILIAL = '"+xFilial("SC9")+"'"+ENTER
		cQuery += "		AND C9_PEDIDO = C5.C5_NUM"+ENTER
		cQuery += "		AND C9_NFISCAL='' " + ENTER
		cQuery += "		AND C9_BLEST != '02' " + ENTER
		cQuery += " WHERE C5_FILIAL = '"+xFilial("SC5")+"' " + ENTER
		cQuery += "		AND C5_NUM BETWEEN '"+mv_par01+"' AND '"+mv_par02+"'" + ENTER
		cQuery += " 	AND C5.D_E_L_E_T_ = '' "+ENTER

		If SELECT("TRB") > 0
			DBSELECTAREA("TRB")
			DBCLOSEAREA()
		ENDIF
		TCQUERY CQUERY NEW ALIAS "TRB"
		DBSELECTAREA("TRB")

		TRB->(DbGoTop())
		cC5_IMP		:= ""
		cC5_YSTSEP	:= "X"
		cC5_PEDIDO	:= ""

		/*
		|=================================================================================
		|   COMENTARIO
		|---------------------------------------------------------------------------------
		|	Inserido verificacao de Cliente Bloqueado na Empresa Destino. Caso esteja 
		| nao sera permitido realizar a impressao da Etiqueta.
		|
		|	Edson Hornberger - 26/08/2014
		|=================================================================================
		*/

		While !TRB->(Eof())
			If TRB->C5_YSTSEP = "B"
				cC5_IMP 	:= "BLOQ"
				cC5_PEDIDO	:= TRB->C5_NUM
			EndIf
			If Alltrim(TRB->C5_YSTSEP) == ''
				cC5_YSTSEP 	:= ""
				cC5_PEDIDO	:= TRB->C5_NUM
			EndIf
			If TRB->C5_YSTSEP <> 'N'
				cC5_IMP 	:= "NOIMP"
			EndIf
			TRB->(DbSkip())
		End

		// Mostra Mensagem de Alerta sobre Cliente Bloqueado - Edson Hornberger - 26/08/2014
		If cC5_IMP = "BLOQ"
			MSGALERT("As etiquetas não podem ser impressas: Cliente do pedido "+cC5_PEDIDO+" BLOQUEADO na Empresa Destino.")
			Return
		EndIf

		If Alltrim(cC5_YSTSEP) = '' // Alltrim(TRB->C5_YSTSEP) == ''
			MSGALERT("As etiquetas não podem ser impressas: pedido "+cC5_PEDIDO+" sem cálculo de embalagem.")
			Return
		Endif

		If !cUsu $ cUserAut .AND. cC5_IMP = "NOIMP" //TRB->C5_YSTSEP <> 'N'
			MSGALERT("Usuário " + cUsu + " não autorizado a fazer reimpressão.")
			Return
		Endif
		TRB->(DbGoTop())

		If !Empty(mv_par11)
			SA4->(DbSeek( xFilial("SA4")+mv_par11 ))
		EndIf

		cQuery := " SELECT * FROM ( "+ENTER
		cQuery += " SELECT (SELECT MAX(ZZF_SEQCX) FROM "+RetSqlName("ZZF")+" AS M WHERE M.D_E_L_E_T_ <> '*' AND ZZF_FILIAL+ZZF_PEDIDO+ZZF_DHCALC = ZZG_FILIAL+ZZG_PEDIDO+ZZG_DHCALC ) ZZF_MSEQCX ,"+ENTER
		cQuery += " (CASE WHEN ZZF_TPSEP = 'F' THEN ZZG_ENDEST ELSE '' END) AS ZZG_ENDEST,"+ENTER
		cQuery += " (CASE WHEN ZZF_TPSEP = 'F' THEN ZZG_PRODUT ELSE '' END) AS ZZG_PRODUT,"+ENTER
		cQuery += " (CASE WHEN ZZF_TPSEP = 'F' THEN ZZG_ESTAC ELSE '' END) AS ZZG_ESTAC,"+ENTER
		cQuery += " (CASE WHEN ZZF_TPSEP = 'F' THEN ZZG_YENDSE ELSE '' END) AS ZZG_YENDSE,"+ENTER
		cQuery += " ZZF_PEDIDO,ZZF_SEQCX,ZZF_TPSEP,ZZF_CODEMB,A1_NOME,A1_ENDENT,A1_LOGRE,A1_NUME,A1_BAIRRO,A1_MUN,A1_EST,A1_CEP,A4_NOME, C5_YREIMP "+ENTER
		cQuery += " , C5_NUMOLD, C5_FILDES " +ENTER
		cQuery += " FROM "+RetSqlName("SC5")+" AS C5" +ENTER
		cQuery += " INNER JOIN "+RetSqlName("ZZG")+" AS ZZG ON ZZG.D_E_L_E_T_ = '' AND ZZG_FILIAL = '"+xFilial("ZZG")+"' AND ZZG_PEDIDO = C5_NUM AND ZZG_DHCALC = (SELECT MAX(ZZG_DHCALC) FROM ZZG030 WHERE D_E_L_E_T_ = '' AND ZZG_FILIAL = '"+xFilial("ZZG")+"' AND ZZG_PEDIDO = C5_NUM)"+ENTER
		cQuery += " INNER JOIN "+RetSqlName("ZZF")+" AS ZZF ON ZZF.D_E_L_E_T_ = '' AND ZZF_FILIAL+ZZF_PEDIDO+ZZF_SEQCX+ZZF_CODEMB+ZZF_DHCALC = ZZG_FILIAL+ZZG_PEDIDO+ZZG_SEQCX+ZZG_CODEMB+ZZG_DHCALC"+ENTER
		cQuery += " INNER JOIN "+RetSqlName("SA1")+" AS A1 ON A1.D_E_L_E_T_ = ''  AND A1_FILIAL = '"+xFilial("SA1")+"'  AND A1_COD = C5_CLIENT  AND A1_LOJA = C5_LOJACLI"+ENTER
		cQuery += " LEFT JOIN "+RetSqlName("SA4")+" AS A4  ON A4.D_E_L_E_T_ = ''  AND A4_FILIAL = '"+xFilial("SA4")+"'  AND A4_COD = C5_TRANSP "+ENTER
		cQuery += " WHERE C5.D_E_L_E_T_ = '' "+ENTER
		cQuery += " AND C5_FILIAL = '"+xFilial("SC5")+"'"+ENTER
		cQuery += " AND C5_NUM BETWEEN '"+mv_par01+"' AND '"+mv_par02+"'"+ENTER
		cQuery += " AND C5_CLIENT BETWEEN '"+mv_par03+"' AND '"+mv_par05+"'"+ENTER
		cQuery += " AND C5_LOJACLI BETWEEN '"+mv_par04+"' AND '"+mv_par06+"'"+ENTER
		cQuery += " AND C5_EMISSAO BETWEEN '"+DTOS(mv_par07)+"' AND '"+DTOS(mv_par08)+"'"+ENTER
		cQuery += " AND C5_YSTSEP = '"+TRB->C5_YSTSEP+"' "+ENTER
		If TRB->C5_YSTSEP <> 'N'
			cQuery += " AND ZZF_SEQCX BETWEEN '"+STRZERO(VAL(mv_par09),6)+"' AND '"+STRZERO(VAL(mv_par10),6)+"'"+ENTER
		Endif
		cQuery += " ) AS Q "+ENTER
		cQuery += " GROUP BY Q.ZZF_MSEQCX, Q.ZZG_ENDEST, Q.ZZG_PRODUT, Q.ZZG_ESTAC, Q.ZZG_YENDSE, Q.ZZF_PEDIDO, Q.ZZF_SEQCX, Q.ZZF_TPSEP, Q.ZZF_CODEMB, Q.A1_NOME, Q.A1_ENDENT, Q.A1_LOGRE, Q.A1_NUME, Q.A1_BAIRRO, Q.A1_MUN, Q.A1_EST, Q.A1_CEP, Q.A4_NOME, Q.C5_YREIMP, Q.C5_NUMOLD, Q.C5_FILDES"+ENTER
		cQuery += " ORDER BY ZZF_PEDIDO,ZZF_TPSEP,ZZF_SEQCX "+ENTER

		DBCLOSEAREA()

		//MemoWrit("TFRECEETQ.SQL",cQuery)
		dbUseArea(.T.,"TOPCONN", TCGenQry(,,cQuery),(cAliasQry := GetNextAlias()), .F., .T.)

		dbSelectArea(cAliasQry)
		dbGoTop()

		If (cAliasQry)->(EOF()) //verifica se está no fim do arquivo ou numero de etiquetas a imprimir é Zero.
			cMensagem := " Não existem etiquetas para serem impressas, nenhum "+Chr(13)+Chr(10)
			cMensagem += " produto foi selecionado pelos criterios de pesquisa."+Chr(13)+Chr(10)
			MsgStop(cMensagem,"Atenção - PRTR0002")
			(cAliasQry)->(dbCloseArea())
			Return

		Else //Caso tenha dados começa impressão de etiquetas

			nHdl    := fCreate(Path) //Cria Arquivo para gravação das etiquetas

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄˆ¿
//³Começa LOOP de impressao³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄˆÙ
			While (cAliasQry)->(!Eof())

//Início - Verifica número da liberação do pedido

				cQuery := " SELECT TOP 1 RANK() OVER (ORDER BY ZZG_DHCALC) AS 'LIBERACAO' FROM "+RetSqlName("ZZG")+" "
				cQuery += " WHERE ZZG_FILIAL = '"+xFilial("ZZG")+"'"
				cQuery += " AND ZZG_PEDIDO = "+(cAliasQry)->ZZF_PEDIDO+" "
				cQuery += " AND "+RetSqlName("ZZG")+".D_E_L_E_T_ <> '*' "
				cQuery += " GROUP BY ZZG_DHCALC "
				cQuery += " ORDER BY LIBERACAO DESC "
				If SELECT("TRB") > 0
					DBSELECTAREA("TRB")
					DBCLOSEAREA()
				ENDIF
				TCQUERY CQUERY NEW ALIAS "TRB"
				DBSELECTAREA("TRB")
				cSeqL := TRB->LIBERACAO
//Fim - Verifica número da liberação do pedido

				If (cAliasQry)->ZZF_PEDIDO <> cPedAt

					SC5->(DbSetOrder(1))
					SC5->(DbSeek(xFilial("SC5") + (cAliasQry)->ZZF_PEDIDO))

					If SC5->C5_YSTSEP <> 'N'
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Realiza a Gravacao do Log de Pre-Pedido³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						U_M003LOG(,(cAliasQry)->ZZF_PEDIDO,"Reimpressao de Etiquetas de Separacao ")
						lReimp := .T.
					Else
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Realiza a Gravacao do Log de Pre-Pedido³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						U_M003LOG(,(cAliasQry)->ZZF_PEDIDO,"Impressao de Etiquetas de Separacao.")
						lReimp := .F.
					EndIf

					//if SC5->(DbSeek(xFilial("SC5") + cPedAt))
					If RecLock("SC5",.F.)
						If SC5->C5_YSTSEP = 'N'
							SC5->C5_YSTSEP	:=	"S"
						Endif
						SC5->(MsUnLock())
					EndIf
					//endif
					cPedAt := (cAliasQry)->ZZF_PEDIDO
				EndIf

				If At(Alltrim(SC5->C5_FILDES),'01|03') != 0
					cVar := "^XA"+ENTER
					cVar += "^LRY"+ENTER
					cVar += "^FO000,000^GB1000,100,120^FS"+ENTER
					cVar += "^FO000,130^GB1000,1,1^FS"+ENTER
					cVar += "^FO015,30^A0N,85,120^FD"	+ALLTRIM((cAliasQry)->ZZF_PEDIDO)+" "+PADL(cSeqL,1)+"^FS"+ENTER
					cVar += "^FO400,140^A0N,85,120^FD"	+ "CD "+(cAliasQry)->C5_FILDES +			"^FS"+ENTER
					cVar += "^FO015,140^A0N,85,120^FD"	+ALLTRIM((cAliasQry)->C5_NUMOLD)+			"^FS"+ENTER
					If !Empty(mv_par11)
						cVar += "^FO015,220^A0N,25,25^FD"	+ALLTRIM((cAliasQry)->A4_NOME)+				"^FS"+ENTER
					EndIf
					cVar += "^FO420,320^A0N,90,70^FD"	+ALLTRIM(STR(VAL((cAliasQry)->ZZF_SEQCX))) + " / "+Alltrim(STR(VAL((cAliasQry)->ZZF_MSEQCX)))+		"^FS"+ENTER

					If lReimp //SC5->C5_YREIMP > 0
						cVar += "^FO700,200^A0N,25,25^FDREIMP.^FS"+ENTER
					EndIf

					cVar += "^FO700,240^A0N,25,25^FD"	+IIF(ALLTRIM((cAliasQry)->ZZF_TPSEP) =="F","E. EST","CAIXA")+		"^FS"+ENTER
					cVar += "^FO700,275^A0N,35,35^FD"	+IIF(ALLTRIM((cAliasQry)->ZZF_TPSEP) =="F",ALLTRIM((cAliasQry)->ZZG_ENDEST),Posicione("ZZD",1,xFilial("ZZD") + ALLTRIM((cAliasQry)->ZZF_CODEMB),"ZZD_DESEMB") )+"^FS"+ENTER
					cVar += "^FO700,305^A0N,25,35^FD"	+IIF(ALLTRIM((cAliasQry)->ZZF_TPSEP) =="F",ALLTRIM((cAliasQry)->ZZG_ESTAC) + " " + ALLTRIM((cAliasQry)->ZZG_YENDSE) ,"" )+"^FS"+ENTER
					cVar += "^FO000,320^GB370,1,1^FS"+ENTER
					cVar += "^FO015,330^BCN,90,Y,N,N^FD"+((cAliasQry)->ZZF_PEDIDO+(cAliasQry)->ZZF_SEQCX)+		"^FS"+ENTER
					cVar += "^FO000,450^GB1000,1,1^FS"+ENTER
					If (cAliasQry)->ZZF_TPSEP =="F"
						cVar += "^FO015,460^A0N,12,27^FD" + Alltrim((cAliasQry)->ZZG_PRODUT) + Alltrim(Posicione("SB1",1,xFilial("SB1") +(cAliasQry)->ZZG_PRODUT,"B1_DESC" ))  + "^FS"+ENTER
					Else
						cVar += "^FO015,460^A0N,12,27^FD"+AllTrim(SM0->M0_NOMECOM)+" - "+AllTrim(SM0->M0_FILIAL)+"^FS"+ENTER
					Endif
					cVar += "^LRN"+ENTER
					cVar += "^XZ"+ENTER
				Else
					cVar := "^XA"+ENTER
					cVar += "^LRY"+ENTER
					cVar += "^FO000,000^GB1000,100,120^FS"+ENTER
					cVar += "^FO000,130^GB1000,1,1^FS"+ENTER
					cVar += "^FO010,30^A0N,85,120^FDPED "	+ALLTRIM((cAliasQry)->ZZF_PEDIDO)+" "+PADL(cSeqL,1)+"^FS"+ENTER
					cVar += "^FO015,160^A0N,25,25^FD"	+ALLTRIM((cAliasQry)->A1_NOME)+			"^FS"+ENTER
					cVar += "^FO015,190^A0N,25,25^FD"	+ALLTRIM((cAliasQry)->A1_LOGRE)+" "+ALLTRIM((cAliasQry)->A1_ENDENT)+", "+ALLTRIM((cAliasQry)->A1_NUME)+			"^FS"+ENTER
					cVar += "^FO015,220^A0N,25,25^FD"	+ALLTRIM((cAliasQry)->A1_BAIRRO)+		"^FS"+ENTER
					cVar += "^FO015,250^A0N,25,25^FD"	+ALLTRIM((cAliasQry)->A1_MUN)+" - "+AllTrim((cAliasQry)->A1_EST)+		"^FS"+ENTER
					cVar += "^FO015,280^A0N,25,25^FD"	+ALLTRIM(Substr((cAliasQry)->A1_CEP,1,5))+"-"+ALLTRIM(Substr((cAliasQry)->A1_CEP,6,3))+		"^FS"+ENTER
					cVar += "^FO420,320^A0N,90,70^FD"	+ALLTRIM(STR(VAL((cAliasQry)->ZZF_SEQCX))) + " / "+Alltrim(STR(VAL((cAliasQry)->ZZF_MSEQCX)))+		"^FS"+ENTER
					cVar += "^FO420,400^A0N,25,25^FD"	+ALLTRIM((cAliasQry)->A4_NOME)+				"^FS"+ENTER

					If lReimp //SC5->C5_YREIMP > 0
						cVar += "^FO700,200^A0N,25,25^FDREIMP.^FS"+ENTER
					EndIf

					cVar += "^FO700,240^A0N,25,25^FD"	+IIF(ALLTRIM((cAliasQry)->ZZF_TPSEP) =="F","E. EST","CAIXA")+		"^FS"+ENTER
					cVar += "^FO700,275^A0N,35,35^FD"	+IIF(ALLTRIM((cAliasQry)->ZZF_TPSEP) =="F",ALLTRIM((cAliasQry)->ZZG_ENDEST),Posicione("ZZD",1,xFilial("ZZD") + ALLTRIM((cAliasQry)->ZZF_CODEMB),"ZZD_DESEMB") )+"^FS"+ENTER
					cVar += "^FO700,305^A0N,25,35^FD"	+IIF(ALLTRIM((cAliasQry)->ZZF_TPSEP) =="F",ALLTRIM((cAliasQry)->ZZG_ESTAC) + " " + ALLTRIM((cAliasQry)->ZZG_YENDSE) ,"" )+"^FS"+ENTER
					cVar += "^FO000,320^GB370,1,1^FS"+ENTER
					cVar += "^FO015,330^BCN,90,Y,N,N^FD"+((cAliasQry)->ZZF_PEDIDO+(cAliasQry)->ZZF_SEQCX)+		"^FS"+ENTER
					cVar += "^FO000,450^GB1000,1,1^FS"+ENTER
					If (cAliasQry)->ZZF_TPSEP =="F"
						cVar += "^FO015,460^A0N,12,27^FD" + Alltrim((cAliasQry)->ZZG_PRODUT) + Alltrim(Posicione("SB1",1,xFilial("SB1") +(cAliasQry)->ZZG_PRODUT,"B1_DESC" ))  + "^FS"+ENTER
					Else
						cVar += "^FO015,460^A0N,12,27^FD"+AllTrim(SM0->M0_NOMECOM)+" - "+AllTrim(SM0->M0_FILIAL)+"^FS"+ENTER
					Endif
					cVar += "^LRN"+ENTER
					cVar += "^XZ"+ENTER

				EndIf

				Set Century OFF
				If fWrite(nHdl,cVar,Len(cVar)) != Len(cVar) //Gravacao do arquivo
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Realiza a Gravacao do Log de Pre-Pedido³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					U_M003LOG(,(cAliasQry)->ZZF_PEDIDO,"Tentativa de impressão de etiquetas de separação. Erro na gravação do Arquivo.")

					If !MsgAlert("Ocorreu um erro na gravacao do arquivo !!","Atencao!")
						fClose(nHdl)
						Return
					Endif
				Endif


				(cAliasQry)->(DbSkip())

			EndDo
//Grava status no último pedido
			SC5->(DbSeek(xFilial("SC5") + cPedAt))
			If RecLock("SC5",.F.)
				If SC5->C5_YSTSEP = 'N'
					SC5->C5_YSTSEP	:= "S"
				Endif
				SC5->(MsUnLock())
				/*
				|---------------------------------------------------------------------------------
				|	Altera o Status do Pedido de Venda no CD de SP
				|---------------------------------------------------------------------------------
				*/
				CQUERY := "UPDATE SC5030 SET C5_STCROSS = 'PROSEP' WHERE C5_FILIAL = '01' AND C5_NUM = '" + C5_NUMORI + "' AND D_E_L_E_T_ = ''"
				IF TCSQLEXEC(CQUERY) != 0

					MSGALERT(OEMTOANSI(	"Erro ao tentar alterar o Status do Pedido de Vendas no CD de SP!")  + ENTER + ;
						"Entre em contato com Dep. TI." + ENTER + "FONTE: " + ALLTRIM(PROCNAME()) + " LINHA: " + ALLTRIM(STR(PROCLINE())),OEMTOANSI("ERRO"))

				ENDIF

			EndIf

			fClose(nHdl)
			COPY FILE &Path TO LPT1
			MsgAlert("Arquivo  '" + Path + "'  Gerado com Sucesso e Enviado para Impressora na Porta '"+cPorta+"'!","Atenção")

		EndIf

		If Select(cAliasQry) > 0 //Verifica se o Alias ainda está aberta
			(cAliasQry)->(DBCLOSEAREA())
		EndIf
	EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ValidPerg ºAutor  ³Thiago Comelli      º Data ³  12/01/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Cria pergunta no e o help do SX1                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function ValidPerg()

	Local cKey := ""
	Local aHelpEng := {}
	Local aHelpPor := {}
	Local aHelpSpa := {}

//PutSx1(cGrupo,cOrdem,cPergunt               ,cPerSpa               ,cPerEng          ,cVar	,cTipo  ,nTamanho				,nDecimal,nPresel,cGSC,cValid			,cF3   , cGrpSxg    ,cPyme,cVar01    ,cDef01     ,cDefSpa1,cDefEng1,cCnt01,cDef02    		,cDefSpa2,cDefEng2,cDef03       ,cDefSpa3,cDefEng3,cDef04,cDefSpa4,cDefEng4,cDef05,cDefSpa5,cDefEng5,aHelpPor,aHelpEng,aHelpSpa,cHelp)
	//PutSx1(cPerg,"01"   ,"Ordem Faturamento  ",""                    ,""                    ,"mv_chx","C"   ,TamSx3("ZC1_NUMOF")[1]	,0       ,0      , "G",""    			,"ZC1" ,""         ,""   ,"mv_par01",""		 	 ,""      ,""      ,""    ,""		  		,""     ,""      ,""		  ,""      ,""      ,""    ,""      ,""     ,""    ,""      ,""      ,""      ,""      ,""      ,"")
	PutSx1(cPerg,"02"   ,"Pedido De          ",""                    ,""                    ,"mv_ch1","C"   ,TamSx3("C5_NUM")[1]	,0       ,0      , "G",""    			,"SC5" ,""         ,""   ,"mv_par01",""		 	 ,""      ,""      ,""    ,""		  		,""     ,""      ,""		  ,""      ,""      ,""    ,""      ,""     ,""    ,""      ,""      ,""      ,""      ,""      ,"")
	PutSx1(cPerg,"03"   ,"Pedido Ate         ",""                    ,""                    ,"mv_ch2","C"   ,TamSx3("C5_NUM")[1]	,0       ,0      , "G",""    			,"SC5" ,""         ,""   ,"mv_par02",""        	 ,""      ,""      ,""    ,""        		,""     ,""      ,""    	  ,""      ,""      ,""    ,""      ,""     ,""    ,""      ,""      ,""      ,""      ,""      ,"")
	PutSx1(cPerg,"04"   ,"Cliente De         ",""                    ,""                    ,"mv_ch3","C"   ,TamSx3("A1_COD")[1]	,0       ,0      , "G",""    			,"SA1" ,""         ,""   ,"mv_par03",""		 	 ,""      ,""      ,""    ,""		  		,""     ,""      ,""		  ,""      ,""      ,""    ,""      ,""     ,""    ,""      ,""      ,""      ,""      ,""      ,"")
	PutSx1(cPerg,"05"   ,"Loja De            ",""                    ,""                    ,"mv_ch4","C"   ,TamSx3("A1_LOJA")[1]	,0       ,0      , "G",""    			,""	 	,""         ,""   ,"mv_par04",""		 	 ,""      ,""      ,""    ,""		  		,""     ,""      ,""		  ,""      ,""      ,""    ,""      ,""     ,""    ,""      ,""      ,""      ,""      ,""      ,"")
	PutSx1(cPerg,"06"   ,"Cliente Ate        ",""                    ,""                    ,"mv_ch5","C"   ,TamSx3("A1_COD")[1]	,0       ,0      , "G",""    			,"SA1" ,""         ,""   ,"mv_par05",""        	 ,""      ,""      ,""    ,""        		,""     ,""      ,""    	  ,""      ,""      ,""    ,""      ,""     ,""    ,""      ,""      ,""      ,""      ,""      ,"")
	PutSx1(cPerg,"07"   ,"Loja Ate           ",""                    ,""                    ,"mv_ch6","C"   ,TamSx3("A1_LOJA")[1]	,0       ,0      , "G",""    			,""    ,""         ,""   ,"mv_par06",""        	 ,""      ,""      ,""    ,""        		,""     ,""      ,""    	  ,""      ,""      ,""    ,""      ,""     ,""    ,""      ,""      ,""      ,""      ,""      ,"")
	PutSx1(cPerg,"08"   ,"Emissao De         ",""                    ,""                    ,"mv_ch7","D"   ,8                    ,0       ,0      , "G",""    			,""    ,""         ,""   ,"mv_par07",""		 	 ,""      ,""      ,""    ,""		  		,""     ,""      ,""		  ,""      ,""      ,""    ,""      ,""     ,""    ,""      ,""      ,""      ,""      ,""      ,"")
	PutSx1(cPerg,"09"   ,"Emissao Ate        ",""                    ,""                    ,"mv_ch8","D"   ,8                   	,0       ,0      , "G",""    			,""    ,""         ,""   ,"mv_par08",""        	 ,""      ,""      ,""    ,""        		,""     ,""      ,""    	  ,""      ,""      ,""    ,""      ,""     ,""    ,""      ,""      ,""      ,""      ,""      ,"")
	PutSx1(cPerg,"10"   ,"Do Volume          ",""                    ,""                    ,"mv_ch9","C"   ,6                 	,0       ,0      , "G",""    			,""    ,""         ,""   ,"mv_par09",""		 	 ,""      ,""      ,""    ,""		  		,""     ,""      ,""		  ,""      ,""      ,""    ,""      ,""     ,""    ,""      ,""      ,""      ,""      ,""      ,"")
	PutSx1(cPerg,"11"   ,"Ate o Volume       ",""                    ,""                    ,"mv_cha","C"   ,6                 	,0       ,0      , "G",""    			,""    ,""         ,""   ,"mv_par10",""        	 ,""      ,""      ,""    ,""        		,""     ,""      ,""    	  ,""      ,""      ,""    ,""      ,""     ,""    ,""      ,""      ,""      ,""      ,""      ,"")
	PutSx1(cPerg,"12"   ,"A transportar por  ",""                    ,""                    ,"mv_chb","C"   ,TamSx3("A4_COD")[1]	,0       ,0      , "G",""    			,"SA4" ,""         ,""   ,"mv_par11",""        	 ,""      ,""      ,""    ,""        		,""     ,""      ,""    	  ,""      ,""      ,""    ,""      ,""     ,""    ,""      ,""      ,""      ,""      ,""      ,"")

/*
	cKey     := "P."+cPerg+"01."
	aHelpEng := {}
	aHelpPor := {}
	aHelpSpa := {}
	aAdd(aHelpEng,"")
	aAdd(aHelpEng,"")
	aAdd(aHelpPor,"Ordem de Faturamento")
	aAdd(aHelpPor,"")
	aAdd(aHelpSpa,"")
	aAdd(aHelpSpa,"")
	PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa)
*/

	cKey     := "P."+cPerg+"02."
	aHelpEng := {}
	aHelpPor := {}
	aHelpSpa := {}
	aAdd(aHelpEng,"")
	aAdd(aHelpEng,"")
	aAdd(aHelpPor,"Pedido Inicial")
	aAdd(aHelpPor,"")
	aAdd(aHelpSpa,"")
	aAdd(aHelpSpa,"")
	PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa)


	cKey     := "P."+cPerg+"03."
	aHelpEng := {}
	aHelpPor := {}
	aHelpSpa := {}
	aAdd(aHelpEng,"")
	aAdd(aHelpEng,"")
	aAdd(aHelpPor,"Pedido Final")
	aAdd(aHelpPor,"")
	aAdd(aHelpSpa,"")
	aAdd(aHelpSpa,"")
	PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa)

	cKey     := "P."+cPerg+"04."
	aHelpEng := {}
	aHelpPor := {}
	aHelpSpa := {}
	aAdd(aHelpEng,"")
	aAdd(aHelpEng,"")
	aAdd(aHelpPor,"Cliente Inicial")
	aAdd(aHelpPor,"")
	aAdd(aHelpSpa,"")
	aAdd(aHelpSpa,"")
	PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa)


	cKey     := "P."+cPerg+"05."
	aHelpEng := {}
	aHelpPor := {}
	aHelpSpa := {}
	aAdd(aHelpEng,"")
	aAdd(aHelpEng,"")
	aAdd(aHelpPor,"Cliente Final")
	aAdd(aHelpPor,"")
	aAdd(aHelpSpa,"")
	aAdd(aHelpSpa,"")
	PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa)

	cKey     := "P."+cPerg+"06."
	aHelpEng := {}
	aHelpPor := {}
	aHelpSpa := {}
	aAdd(aHelpEng,"")
	aAdd(aHelpEng,"")
	aAdd(aHelpPor,"Loja Inicial")
	aAdd(aHelpPor,"")
	aAdd(aHelpSpa,"")
	aAdd(aHelpSpa,"")
	PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa)

	cKey     := "P."+cPerg+"07."
	aHelpEng := {}
	aHelpPor := {}
	aHelpSpa := {}
	aAdd(aHelpEng,"")
	aAdd(aHelpEng,"")
	aAdd(aHelpPor,"Loja Final")
	aAdd(aHelpPor,"")
	aAdd(aHelpSpa,"")
	aAdd(aHelpSpa,"")
	PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa)

	cKey     := "P."+cPerg+"08."
	aHelpEng := {}
	aHelpPor := {}
	aHelpSpa := {}
	aAdd(aHelpEng,"")
	aAdd(aHelpEng,"")
	aAdd(aHelpPor,"Emissao Inicial")
	aAdd(aHelpPor,"")
	aAdd(aHelpSpa,"")
	aAdd(aHelpSpa,"")
	PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa)

	cKey     := "P."+cPerg+"09."
	aHelpEng := {}
	aHelpPor := {}
	aHelpSpa := {}
	aAdd(aHelpEng,"")
	aAdd(aHelpEng,"")
	aAdd(aHelpPor,"Emissao Final")
	aAdd(aHelpPor,"")
	aAdd(aHelpSpa,"")
	aAdd(aHelpSpa,"")
	PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa)

	cKey     := "P."+cPerg+"10."
	aHelpEng := {}
	aHelpPor := {}
	aHelpSpa := {}
	aAdd(aHelpEng,"")
	aAdd(aHelpEng,"")
	aAdd(aHelpPor,"Volume Inicial")
	aAdd(aHelpPor,"")
	aAdd(aHelpSpa,"")
	aAdd(aHelpSpa,"")
	PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa)

	cKey     := "P."+cPerg+"11."
	aHelpEng := {}
	aHelpPor := {}
	aHelpSpa := {}
	aAdd(aHelpEng,"")
	aAdd(aHelpEng,"")
	aAdd(aHelpPor,"Volume Final")
	aAdd(aHelpPor,"")
	aAdd(aHelpSpa,"")
	aAdd(aHelpSpa,"")
	PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa)

	cKey     := "P."+cPerg+"12."
	aHelpEng := {}
	aHelpPor := {}
	aHelpSpa := {}
	aAdd(aHelpEng,"")
	aAdd(aHelpEng,"")
	aAdd(aHelpPor,"A transportar por?")
	aAdd(aHelpPor,"")
	aAdd(aHelpSpa,"")
	aAdd(aHelpSpa,"")
	PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa)

Return
