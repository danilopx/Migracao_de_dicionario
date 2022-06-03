#include "PROTHEUS.CH"

#DEFINE ENTER Chr(13)+Chr(10)
//-------------------------------------------------------------------------------------------------------------------------------
// PONTO DE ENTRADA: M410PVNF                              						AUTOR: CARLOS TORRES                 DATA: 20/07/2011
// DESCRICAO:  1º Funcionalidade: Validar o inicio do processo denominado Guia de Embarque quando pedido da MERCABEL
//					2º Funcionalidade: Validar concessao do regime especial
//					3º Permitir informar a data de saida da NF quando emitida NF individual
//	OBSERVACAO: PE utilizado na rotina MATA410 especificamente no botão "Prep.Doc.Saída"
//-------------------------------------------------------------------------------------------------------------------------------
User Function M410PVNF
	Local lRetorno := .T.
	Local __cLojaI	:= GETNEWPAR("MV_TFEMPAT","02")
	Local cAliasSA1:= SA1->(GetArea())
	Local nUltSele	:= Select()
	Local _cInfoDt	:= GETNEWPAR("TF_DTSAINF","S")
	Local _cProgMn := FunName()
	Local lArmCen	:= SUPERGETMV("MV_ARMCEN",.F.,.T.) //Parametro para ativar o Processo do Projeto Avante - Fase II
	Local cMensPad	:= ""	
	LOCAL CC6LOCAL	:= ""
	LOCAL CZASTIPLIB:= ""
	LOCAL CCB7STATUS:= ""
	Local NDIALIMT	:= GETNEWPAR("TF_DATFAT",31)

	/*
	|=================================================================================
	|   COMENTARIO
	|---------------------------------------------------------------------------------
	|	Tratamento para que nao seja permitido o Faturamento de Pedidos que nao sejam 
	| da Empresa/Filial atual
	|	Projeto Avante - Fase II 
	|	Edson Hornberger - 17/09/2013 
	|=================================================================================
	*/
			
	IF lArmCen
		
		IF !((ALLTRIM(SC5->C5_EMPDES) + ALLTRIM(SC5->C5_FILDES)) $ (CEMPANT+CFILANT))
			
			MSGALERT(OEMTOANSI("Somente é permitido Pedidos onde a Empresa/Filial Destino sejam o mesmo da Atual!"),"Projeto Avante/Crossdocking")
			Return(.F.)
			
		ENDIF
		
	ENDIF
	
	Public dTFDtSaidaNfe := Ctod("  /  /  ")
	Public cTFHrSaidaNfe := Space(05)

	If !(SC5->C5_TIPO$"D/B") 
//
// Chamada de função para validar a concessao do regime especial, a função se encontra em: M460MARK
//
		If (lRetorno := U_TFRetConcessaoOK(  SC5->C5_NUM , SC5->C5_CLIENTE , SC5->C5_LOJACLI  )  )   // C. Torres 10/01/2012
			SA1->( dbSetOrder( 1 ) )

			If ( SA1->( dbSeek( xFilial( "SA1" ) + SC5->C5_CLIENTE + SC5->C5_LOJACLI ) ) )

				/***********************************************************************/
// VALIDAÇÃO PARA CLIENTES QUE PERTENCEM A AMAZONIA OCIDENTAL
				/***********************************************************************/
				If (U_RetAmOcidental(SA1->A1_EST, SA1->A1_COD_MUN) .And. SA1->A1_CALCSUF <> "N")
					Alert( "Não será possível faturar os pedidos do cliente " +  SC5->C5_CLIENTE + ". Município do cliente pertence a Amazonia Ocidental, e o campo Desc.Suframa deveria estar parametrizado como (Não). ","")
					lRetorno := .F.
				EndIf
				/***********************************************************************/
// VALIDAÇÃO PARA CLIENTES QUE TENHAM O SUFRAMA VENCIDO
				/***********************************************************************/
				If (!Empty(SA1->A1_SUFRAMA) .And. (Empty(SA1->A1_VLDSUFR) .Or. SA1->A1_VLDSUFR < Date())) .AND. lRetorno
					Alert( "Não será possível faturar os pedidos do cliente " +  SC5->C5_CLIENTE + ". Cliente possui código Suframa com Data de Validade vencida ou vazia.","")
					lRetorno := .F.
				EndIf
			EndIf
		EndIf
        
        //VERIFICA SE É PEDIDO FILIAL 0302 E PROART - STATUS DA PESAGEM - TRADE
            IF  cEmpAnt + cfilAnt == "0302" .AND. alltrim(SC5->C5_XITEMC) == "PROART" .AND. CB7->(FIELDPOS("CB7_X_QTVO")) > 0
            
              	_cQuery := "SELECT ISNULL(COUNT(*),0) AS NPESPENDENTE " + ENTER
            	_cQuery += "FROM "+RETSQLNAME("ZAR")+" ZAR " 		+ ENTER
				_cQuery += "JOIN "+RETSQLNAME("CB7")+" CB7 ON "     + ENTER
				_cQuery += "ZAR_FILIAL = CB7_FILIAL AND ZAR_ORDSEP = CB7_ORDSEP AND CB7.D_E_L_E_T_ = '' " + ENTER 
				_cQuery += "WHERE ZAR_FILIAL = '"+ XFILIAL("ZAR")+"' AND "	+ ENTER
				_cQuery += "CB7_PEDIDO = '"+SC5->C5_NUM+"' AND ZAR_STATUS <> 'F' "		+ ENTER
				_cQuery += "AND ZAR.D_E_L_E_T_ = ''  
			
				IF  SELECT("TZAR")
					TZAR->(Dbclosearea())
				ENDIF	
				DbUseArea( .T.,"TOPCONN",TCGenQry(,,_cQuery),'TZAR',.F.,.T.)
				Dbselectarea("TZAR")
				Dbgotop()
				IF   TZAR->NPESPENDENTE > 0
					Alert( "Não será possível faturar o pedidos " +  SC5->C5_NUM + ". Pesagem não Finalizada.","")
					lRetorno := .F.
				ENDIF	
			ENDIF	

        //
//** INICIO - INCUIDO POR VETI - THIAGO COMELLI - 26/11/2012
		/*
		|---------------------------------------------------------------------------------
		| Incluido verificacao de Unidade de Negocio ao ser realizado faturamento
		|---------------------------------------------------------------------------------
		*/
		If (cEmpAnt+cFilAnt) $ SuperGetMV("MV__SEPA01",.F.,"") .AND. lRetorno .And. SC5->C5_INTER != "S" .And. AllTrim(SC5->C5_XITEMC) != "TAIFF"
			If SC5->C5_XLIBCR <> 'L'
				Alert( "Pedido não está com o crédito liberado!","")
				lRetorno := .F.
			EndIf
			If SC5->C5_LIBCOM = "2"
				Alert( "Pedido está com bloqueio comercial, faturamento não permidito!","")
				lRetorno := .F.
			EndIf
			// Início - Verifica Status do Pedido - Arlete - 24/04/2013
			SC9->(DbSetOrder(1))
			SC9->(DbSeek( xFilial("SC9") + SC5->C5_NUM ))
			While SC9->C9_FILIAL = xFilial("SC9") .AND. SC9->C9_PEDIDO = SC5->C5_NUM .AND. !SC9->(Eof())
				If (ALLTRIM(SC5->C5_YSTSEP) $ 'S/C/E' .OR. alltrim(SC5->C5_YSTSEP) = '' .OR. EMPTY(ALLTRIM(SC9->C9_ORDSEP))) .AND. SC9->C9_NFISCAL = '' .AND. SC9->C9_LOCAL = '21' .AND. lRetorno
					If alltrim(SC5->C5_YSTSEP) = '' .OR. EMPTY(ALLTRIM(SC9->C9_ORDSEP))
						Alert( "Status do pedido "+SC5->C5_NUM+" não permite emissão de NF. Não foram calculadas embalagens !","")
					ElseIf alltrim(SC5->C5_YSTSEP) $ 'S/G'
						Alert( "Status do pedido "+SC5->C5_NUM+" não permite emissão de NF. A Etiqueta de Separação já foi emitida!","")
					ElseIf alltrim(SC5->C5_YSTSEP) $ 'E'
						Alert( "Status do pedido "+SC5->C5_NUM+" não permite emissão de NF. Existe erro no calculo de embalagem!","")
					EndIf
					lRetorno := .F.
				Endif
				SC9->(DbSkip())
			EndDo
			
			// Final - Verifica Status do Pedido - Arlete - 24/04/2013
		EndIf
//** FIM - INCUIDO POR VETI - THIAGO COMELLI - 26/11/2012

		/* Tratamento para os pedidos que estão disponiveis para fatuamento */
		If SC5->(FIELDPOS("C5__DTLIBF")) > 0 .AND. CEMPANT = "03" .AND. CFILANT = "02"  
			If .NOT. EMPTY( SC5->C5__BLOQF )
				cMensPad := "Pedido está com restrição de faturamento do tipo: " + ENTER
				If SC5->C5__BLOQF = "C"
					cMensPad += SC5->C5__BLOQF + " - Parcela liberada inferior à parcela mínima de faturamento" + ENTER 
				ElseIf SC5->C5__BLOQF = "E"
					cMensPad += SC5->C5__BLOQF + " - Sistema não tem saldo no estoque" + ENTER
				ElseIf SC5->C5__BLOQF = "F"
					cMensPad += SC5->C5__BLOQF + " - Cliente não permite faturamento fracionado" + ENTER
				ElseIf SC5->C5__BLOQF = "P"
					cMensPad += SC5->C5__BLOQF + " - Cliente não permite faturamento parcial" + ENTER
				ElseIf SC5->C5__BLOQF = "S"
					cMensPad += SC5->C5__BLOQF + " - Cliente não aceita saldo" + ENTER
				ElseIf SC5->C5__BLOQF = "V"
					cMensPad += SC5->C5__BLOQF + " - Valor liberado inferior ao valor mínimo de faturamento" + ENTER
				EndIf

				Alert( cMensPad ,"")
				lRetorno := .F.
			else
				/* Funcionalidade do projeto de Faturamento somente com Ordem de Separação */
				/* Data: 11/05/2020                               Responsável: Carlos Torres*/
				/* pedidos TAIFF ou PROART somente serão faturados se a ordem de separação estiver finalizada */
				/* verificar: armazém de processo 21 CB7 com status 9 que seja TAIFF ou PROART */
				IF SC5->(FIELDPOS("C5_XITEMC")) > 0
					IF ALLTRIM(SC5->C5_XITEMC) $ "TAIFF|PROART" .AND. SC5->C5_CLASPED $ "V|X" .AND. SC5->C5_TIPO="N"
						CCB7STATUS	:= ""
						CC6LOCAL 	:= ""
						CZASTIPLIB	:= ""
						CC9ORDSEP	:= ""
						// Início - Verifica Status do Pedido - Arlete - 24/04/2013
						SC6->(DbSetOrder(1))
						SC6->(DbSeek( xFilial("SC6") + SC5->C5_NUM ))
						While SC6->C6_FILIAL = xFilial("SC6") .AND. SC6->C6_NUM = SC5->C5_NUM .AND. !SC6->(Eof())
							CC6LOCAL := SC6->C6_LOCAL
							SC6->(DbSkip())
						EndDo
						
						SC9->(DbSetOrder(1))
						SC9->(DbSeek( xFilial("SC9") + SC5->C5_NUM ))
						While SC9->C9_FILIAL = xFilial("SC9") .AND. SC9->C9_PEDIDO = SC5->C5_NUM .AND. !SC9->(Eof())
							IF EMPTY(SC9->C9_NFISCAL)
								CC9ORDSEP := SC9->C9_ORDSEP
							ENDIF
							SC9->(DbSkip())
						EndDo

						CB7->(DBSETORDER( 1 ))
						IF CB7->(DBSEEK( xFilial("CB7") +  CC9ORDSEP ))
							CCB7STATUS := CB7->CB7_STATUS
						ENDIF 
						IF NDIALIMT != 31  .AND. DAY(DATE()) > NDIALIMT 
							ZAS->(DBSETORDER( 1 ))
							IF ZAS->(DBSEEK( xFilial("ZAS") +  SC5->C5_NUM + "2" ))
								CZASTIPLIB := ZAS->ZAS_TIPLIB
							ENDIF 
						ENDIF
						IF CZASTIPLIB="2" .AND. CC6LOCAL = "21" 
							IF EMPTY(CCB7STATUS)
								Aviso("Validação de Faturamento", "Pedido cadastrado com permissao de faturamento!", {"Ok"}, 3)
								lRetorno := .T.
							ELSE
								Aviso("Validação de Faturamento", "Pedido cadastrado com permissao de faturamento com ordem de separacao em andamento neste caso deverao estornar a OS!", {"Ok"}, 3)
								lRetorno := .F.
							ENDIF
						ELSEIF CC6LOCAL = "21" .AND. CCB7STATUS != "9" 
							Aviso("Ordem de Separação nao finalizada", "Para prosseguir com o faturamento é necessário que a separação/conferencia estejam concluidas", {"Ok"}, 3)
							lRetorno := .F.
						ENDIF
						IF lRetorno .AND. SC5->C5_DTPEDPR > DDATABASE
							Aviso("Validação de faturamento", "Pedido com data programa de faturamento superior à data corrente", {"Ok"}, 3)
							lRetorno := .F.
						ENDIF
					ENDIF
				ENDIF
				/* Fim do controle */
			EndIf
		EndIf
		
	EndIf

	If _cInfoDt='S' .and. lRetorno .AND. _cProgMn='MATA410'
//
// Função para solicitar ao usuario que informe a data de saida da Nota Fiscal
//
		If .NOT. SC5->C5_TIPO$"D/B"
			U_DtSaidaNfe()
		EndIf
	EndIf


//-----------------------------------------------[ GUIA DE EMBARQUE ]------------------------------------------------------------
//
// Somente ativar a rotina abaixo quando o processo de GUIA DE EMBARQUE for aprovado
//
	IF 1=2
		If lRetorno
			If SM0->M0_CODIGO='01' .and. C5_CLIENTE='000820' .And. At(C5_LOJACLI, __cLojaI ) != 0 .AND. Empty(C5_NOTA)
				SC9->(DbSetOrder(1))
				SC9->(DbSeek( xFilial("SC9") + SC5->C5_NUM ))
				While SC9->C9_FILIAL = xFilial("SC9") .AND. SC9->C9_PEDIDO = SC5->C5_NUM .AND. !SC9->(Eof())
					If Empty(SC9->C9_NFISCAL) .and. Empty(SC9->C9_NMEMBAR)
						lRetorno:=.F.
					EndIf
					SC9->(DbSkip())
				EndDo
				If .not. lRetorno
					Aviso("Embalagem não iniciada", "Para prosseguir com o faturamento solicite a embalagem das mercadorias.", {"Ok"}, 3)
				EndIf
			EndIf
		EndIf
	ENDIF
//-----------------------------------------------[ GUIA DE EMBARQUE ]------------------------------------------------------------

	RestArea(cAliasSA1)
	dbSelectArea( (nUltSele) )

	Return (lRetorno)


//-------------------------------------------------------------------------------------------------------------------------------
// FUNÇÃO: DtSaidaNfe                              						       AUTOR: CARLOS TORRES                 DATA: 10/09/2012
// Descrição: Função para solicitar ao usuario que informe a data de saida da Nota Fiscal
//-------------------------------------------------------------------------------------------------------------------------------
User Function DtSaidaNfe()
	Local lRetorno := .T.
	Local cTitulo		:= "Dados da NFe"
	Local nOpca			:= 0

	DEFINE MSDIALOG oDlg TITLE cTitulo FROM 000,000 TO 120,300 PIXEL

	@ 001,001 TO 060, 150 OF oDlg PIXEL

	@ 010,010 SAY   "Data de Saida" SIZE 55, 07 OF oDlg PIXEL

	@ 025,010 SAY   "Hora de Saida" SIZE 55, 07 OF oDlg PIXEL

	@ 008,050 MSGET dTFDtSaidaNfe   SIZE 55, 11 OF oDlg PIXEL VALID U_TFVlDtSai()

	@ 023,050 MSGET cTFHrSaidaNfe   SIZE 55, 11 OF oDlg PIXEL PICTURE "@R 99:99" VALID U_TFVlHrSai()

	DEFINE SBUTTON FROM 045, 040 TYPE 1 ACTION (nOpca := 1,oDlg:End()) ENABLE OF oDlg

	DEFINE SBUTTON FROM 045, 090 TYPE 2 ACTION (nOpca := 2,oDlg:End()) ENABLE OF oDlg

	ACTIVATE MSDIALOG oDlg CENTERED

	If nOpca=2
		Aviso("ATENÇÃO!", "Não foram atribuidos valores a data e a hora de saida!", {"Ok"}, 3)
		dTFDtSaidaNfe := Ctod("  /  /  ")
		cTFHrSaidaNfe	:= Space(05)
		lRetorno := .F.
	Else
		If !Empty(cTFHrSaidaNfe)
			cTFHrSaidaNfe	:= Transform( cTFHrSaidaNfe , "@R 99:99" )
		EndIf
		lRetorno := .T.
	EndIf


	Return (lRetorno)

//-------------------------------------------------------------------------------------------------------------------------------
// FUNÇÃO: TFVlDtSai                              						       AUTOR: CARLOS TORRES                 DATA: 10/09/2012
// Descrição: Função para validar o conteudo da variavel data de saida
//-------------------------------------------------------------------------------------------------------------------------------
User Function TFVlDtSai()
	Local lReturn := .T.
	Local nMaxDias	:= GETNEWPAR("TF_DIASSAI",365)

	If dTFDtSaidaNfe < dDataBase .and. !Empty(dTFDtSaidaNfe)
		Aviso("ATENÇÃO!", "Data de saida não pode ser menor que a data base do sistema!", {"Ok"}, 3)
		lReturn := .F.
	EndIf

	If lReturn .and. dTFDtSaidaNfe >= dDataBase + nMaxDias .and. !Empty(dTFDtSaidaNfe)
		Aviso("ATENÇÃO!", "Data de saida ultrapassa a data de referencia!" + chr(13) + chr(10) + "Data de referencia = data base do sistema mais numero de dias permitidos para data de saida apos a emissao da nota (parametro: TF_DIASSAI = "+Alltrim(Str(nMaxDias))+")", {"Ok"}, 3)
		lReturn := .F.
	EndIf

	Return (lReturn)

//-------------------------------------------------------------------------------------------------------------------------------
// FUNÇÃO: TFVlHrSai                              						       AUTOR: CARLOS TORRES                 DATA: 10/09/2012
// Descrição: Função para validar o conteudo da variavel hora de saida
//-------------------------------------------------------------------------------------------------------------------------------
User Function TFVlHrSai()
	Local lReturn := .T.
//
// A variavel cTFHrSaidaNfe deve ser compativel com o formato HH:MM ( HH intevalo 00 a 24 e MM intervalo 00 a 59 )
//
	If !Empty(cTFHrSaidaNfe)
		If (.NOT. (Substr(cTFHrSaidaNfe,1,2) >= "00" .and. Substr(cTFHrSaidaNfe,1,2) <= "24")) .OR. (.NOT. (Substr(cTFHrSaidaNfe,3,2) >= "00" .and. Substr(cTFHrSaidaNfe,3,2) <= "59"))
			Aviso("ATENÇÃO!", "Hora de saida inválida!", {"Ok"}, 3)
			lReturn := .F.
		EndIf
	EndIf
	If lReturn .and. !Empty(cTFHrSaidaNfe) .and. Empty(dTFDtSaidaNfe)
		Aviso("ATENÇÃO!", "Informe a data de saida quando a hora de saida for informada!", {"Ok"}, 3)
		lReturn := .F.
	EndIf
	If lReturn .and. !Empty(dTFDtSaidaNfe) .and. dTFDtSaidaNfe!=dDatabase .and. Empty(cTFHrSaidaNfe)
		Aviso("ATENÇÃO!", "Informe a hora de saida!", {"Ok"}, 3)
		lReturn := .F.
	EndIf
//
// Regra acordada com Odair, Fernando Andrade e Patricia Lima em 12/09/2012
// a) Quando a data de saida for igual a data de emissao e a hora estiver vazia ou for menor a hora atual,
//		será assumida a hora da transmissão da Nfe. Ocorrerá atualização do campo hora na rotina NFESEFAZ.PRW
//
	If lReturn .and. !Empty(dTFDtSaidaNfe) .and. dTFDtSaidaNfe=dDatabase
		If Empty(cTFHrSaidaNfe) .OR. Transform( cTFHrSaidaNfe , "@R 99:99" ) < Substr(Time(),1,5)
			Aviso("ATENÇÃO!", "Para a hora de saida será atrubuida a hora da transmissão da nota fiscal, com base rotina NFESEFAZ!", {"Ok"}, 3)
			cTFHrSaidaNfe := Space(05) // NÃO MUDAR ESTE ATRIBUTO SEM ANALISAR A ROTINA NFESEFAZ.PRW
		EndIf
	EndIf
	Return (lReturn)

