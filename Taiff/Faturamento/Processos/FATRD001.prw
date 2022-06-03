#include "rwmake.ch"

#DEFINE ENTER CHR(13) + CHR(10)
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Programa ³ FATRD001 ³ Autor ³ Paulo Bindo           ³ Data ³ 28/09/15 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ BUSCA ESTRUTUR A PARTIR DA OP NO PEDIDO DE VENDAS          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ CIS                                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function FATRD001()
	Private nQtde		:= 0
	Private cAlmox 	:= Space(02)
	Private cOP1 	:= Space(13)
	Private cTes 	:= Space(03)
	PRIVATE NOPC	:= 0


	If M->C5_TIPO<>"B"
		MsgBox("Opção permitida somente para Pedido de Beneficiamento.")
		Return
	Endif

	@ 100,55 To 280,500 Dialog oDlg1 Title OemToAnsi("Estrutura")
	@ 10,020  Say OemToAnsi("Informe a OP de que deseja buscar a estrutura") Size 300,8
	@ 35,020  Say OemToAnsi("OP 1  :")  Size 20,8
	@ 35,050  Get cOP1 Picture "@!" F3 "SC2" VALID EXISTCPO("SC2",cOP1 ,1)Size 53,10
	@ 35,120 Say OemToAnsi("TES  :")  Size 20,8
	@ 35,150 Get cTes Picture "@!" F3 "SF4" VALID EXISTCPO("SF4",cTes ,1) Size 53,10
	@ 50,020 Say OemToAnsi("Qtde  :")  Size 20,8
	@ 50,050 Get nQtde Picture "9999999"   Size 53,10


	@ 70,20 Button OemToAnsi("_Confirmar") Size 32,12 Action Estrutura()
	@ 70,60 Button OemToAnsi("_Sair")      Size 32,12 Action {nOpc :=0,oDlg1:End()} 
	Activate Dialog oDlg1 Centered

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ESTRUTURA ºAutor  ³Microsiga           º Data ³  07/19/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static FUNCTION ESTRUTURA()
	Local nPosCod	:= aScan(aHeader,{|x| AllTrim(x[2])=='C6_OP'})
	Local oOk		:= LoadBitMap(GetResources(), "LBOK") // a variavel é usada em cLine, portanto deve ser mantida
	Local oNo		:= LoadBitMap(GetResources(), "LBNO") // a variavel é usada em cLine, portanto deve ser mantida
	Local oDlg
	LOCAL oListBox
	Local lContinua := .T.
	Local nOpc		:= 0
	Local nOld		:= n
	Local aArea     := GetArea()
	Local nFator 	:= 0
	Local nY		:= 0
	Local _ny 		:= 0
	Local nx		:= 0
	LOCAL NCUSTO_INI := 0
	LOCAL CMAXDATA_SB9 := ""

	Private nEstq	:= 0

	//ORDEM PRODUCAO
	dbSelectArea("SC2")
	dbSetOrder(1)
	DbSeek(xFilial()+cOP1)
	nQtdOP := SC2->C2_QUANT
	cFornece :=SC2->C2__FORNEC

	//VALIDA QUANTIDADE
	If nQtde > nQtdOP
		MsgStop("A quantidade informada e maior que a OP!","Atenção! - FATRD001")
		Close(oDlg1)
		Return
	EndIf

	//VALIDA FORNECEDOR
	If Empty(cFornece)
		MsgStop("A OP1 selecionada não possui um fornecedor, contacte Compras!","Atenção! - FATRD001")
		Close(oDlg1)
		Return
	EndIf
	/*
	If ! Empty(cOP2)
		cFornece1 := Posicione("SC2",1,xFilial("SC2")+Left(cOP1,6),"C2_FORNECE")
		If Empty(cFornece1)
			MsgRun("A OP1 selecionada não possui um fornecedor, contacte o PCP!")
			Return
		EndIf
	EndIf
	*/

	// Declara Arrays p/ Consultas
	_aArqC1 := {}
	AADD(_aArqC1,{"CODCOMP"	,"C",15,0})
	AADD(_aArqC1,{"QTDCOMP"	,"N",14,6})
	AADD(_aArqC1,{"LOCCOMP"	,"C",02,0})
	AADD(_aArqC1,{"QTBNFC"	,"N",09,0})
	AADD(_aArqC1,{"QTDORI"	,"N",14,6})

	// Arquivo Auxiliar para Consultas
	_cArqC1 := CriaTrab(_aArqC1,.T.)
	dbUseArea(.T.,,_cArqC1,"OP")
	Index on CODCOMP to &_cArqC1


	aTerceiros := {}
	aConteudos := {}
	If lContinua
		//	cOP := aCols[n][nPosCod]
		dbSelectArea("SD4")
		dbSetOrder(2)
		If DbSeek(xFilial()+cOP1)
			MsgRun("Montanto a tela de pedido da 1ª OP, Aguarde...","",{|| CursorWait(), montarq() ,CursorArrow()})
		Else
			MSGBOX("A OP " + cOP1 + " não foi localizada!")
			dbSelectArea("OP")
			DbcloseArea()
			Ferase(_cArqC1+".dbf")
			Return
		Endif

		dbSelectArea("OP")
		dbGoTop()
		While !Eof()
			//CADASTRO DE PRODUTO
			dbSelectArea("SB1")
			dbSetOrder(1)
			DbSeek(xFilial()+OP->CODCOMP)

			//CALCULA A QUANTIDADE PADRAO SOBRE O TOTAL
			nFator := OP->QTDORI/nQtdOP
			//MAO DE OBRA E MATERIAL AUXILIAR NAO ENTRAM NA ROTINA
			If !SB1->B1_TIPO $ "MO|MA|"
				dbSelectArea("SB2")
				dbSetOrder(1)
				DbSeek(xFilial()+OP->CODCOMP+OP->LOCCOMP)
				IF CEMPANT="04" .AND. CFILANT="01"
					nEstq := SB2->B2_QATU //SaldoMov()
					nDispo:= OP->QTBNFC
				ELSE
					nEstq := SaldoMov()+SB2->B2_QACLASS-SB2->B2_QPEDVEN-SB2->B2_QEMP+((OP->QTDORI-OP->QTBNFC))
					//AVALIA SE A QUANTIDADE DESEJADA E MAIOR QUE A JA ENVIADA
					nDispo:= Iif (((OP->QTDORI-OP->QTBNFC))>nQtde,nQtde,((OP->QTDORI-OP->QTBNFC)))
				ENDIF

				//01- MARCA, 02-COR, 03- PRODUTO, 04-DESCRICAO, 05-ESTOQUE DISP, 06- NECESSIDADE, 07- ALMOX, 08- QTDE JA ENVIADA
				aConteudos := {Iif(nEstq>0,.T.,.F.),fColor(),SB1->B1_COD,SB1->B1_DESC,nEstq,nDispo,"31",OP->QTBNFC}
				aadd(aTerceiros, aConteudos)
			EndIf
			DbSelectArea("OP")
			DbSkip()
		Enddo
		If (!Empty(aTerceiros))
			aTitCampos := {" ","",OemToAnsi("Produto"),OemToAnsi("Descricao"),OemToAnsi("Saldo Estoque"),OemToAnsi("Necessidade"),OemToAnsi("Já Enviado")}
			cLine := "{If(aTerceiros[oListBox:nAt,1],oOk,oNo),aTerceiros[oListBox:nAT][2],aTerceiros[oListBox:nAT][3],aTerceiros[oListBox:nAT][4],Transform(aTerceiros[oListBox:nAT][5],'@E 99999999.99'),Transform(aTerceiros[oListBox:nAT][6],'@E 99999999.99'),Transform(aTerceiros[oListBox:nAT][8],'@E 99999999.99'),} "
			bLine := &( "{ || " + cLine + " }" )
			DEFINE MSDIALOG oDlg FROM 50,40  TO 285,741 TITLE "ESTRUTURA" Of oMainWnd PIXEL
			oListBox := TWBrowse():New( 17,4,343,80,,aTitCampos,,oDlg,,,,,,,,,,,,.F.,,.T.,,.F.,,,)
			oListBox:SetArray(aTerceiros)
			oListBox:bLDblClick := { || Iif(aTerceiros[oListBox:nAt,6]> 0,aTerceiros[oListBox:nAt,1] := !aTerceiros[oListBox:nAt,1],.F.)}
			oListBox:bLine := bLine
			ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{||(nOpc := 1,nF4For := oListBox:nAt,oDlg:End())},{||(nOpc := 0,nF4For := oListBox:nAt,oDlg:End())},,) //aButtons)

			If ( nOpc == 1 )

				nPosCod	  := aScan(aHeader,{|x| AllTrim(x[2])=='C6_PRODUTO'		})
				nPUM      := aScan(aHeader,{|x| AllTrim(x[2])=="C6_UM"			})
				nPQuant   := aScan(aHeader,{|x| AllTrim(x[2])=="C6_QTDVEN"		})
				nPDescri  := aScan(aHeader,{|x| AllTrim(x[2])=="C6_DESCRI"		})
				nPLocal   := aScan(aHeader,{|x| AllTrim(x[2])=="C6_LOCAL"		})
				nPPrcVen  := aScan(aHeader,{|x| AllTrim(x[2])=="C6_PRCVEN"		})
				nPValor   := aScan(aHeader,{|x| AllTrim(x[2])=="C6_VALOR"		})
				nPTes     := aScan(aHeader,{|x| AllTrim(x[2])=="C6_TES"			})
				nPCF      := aScan(aHeader,{|x| AllTrim(x[2])=="C6_CF"			})
				nOPBNCF	  := aScan(aHeader,{|x| AllTrim(x[2])=="C6__OPBNFC"		})
				nOP	  		:= aScan(aHeader,{|x| AllTrim(x[2])=="C6_NUMOP"		})
				_N    := Len(aCols)
				_Item := aCols[_N][nPosCod]
				cItem := BuscaCols("C6_ITEM")
				If !Empty(_Item)
					cItem := SomaIt(cItem)
				Endif
				For nx	:= 1 to Len(aTerceiros)
					If aTerceiros[nx][1]
						_lExiste := .f.

						For _ny := 1 to Len(aCols)
							// Verificar se o OP já foi incluido, se sim adicionar a quantidade, e acertar valor total
							If aCols[_ny][nPosCod]	== aTerceiros[nx][3] .and. aCols[_ny][nOPBNCF] == cOP1
								_lExiste := .t.
								Exit
							EndIf
						Next _ny

						If _lExiste
							dbSelectArea("OP")
							DbSeek(aTerceiros[nx][3])
							aCols[_ny][nPQuant] := aTerceiros[nx][6] //aCols[_ny][nPQuant] + aTerceiros[nx][6]
							aCols[_ny][nPValor] := a410Arred(IIf(aCols[_ny][nPQuant]==0,1,aCols[_ny][nPQuant])*aCols[_ny][nPPrcVen],"C6_VALOR")
							//QUANDO ESTA DELETADO TIRA O STATUS E AVISA O USUARIO
							If aCols[_ny,Len(aCols[_ny])]
								aCols[_ny,Len(aCols[_ny])] := .F.
								MsgInfo("O item "+aCols[_ny][nPosCod]+" estava deletado e foi recuperado!","FATRD001")
							EndIf
						Else
							If !Empty(_Item)
								aadd(aCols,Array(Len(aHeader)+1))  // linha em branco no aCols
								For nY := 1 to Len(aHeader)
									If Trim(aHeader[ny][2]) == "C6_ITEM"
										aCols[Len(aCols)][ny] 	:= IIF(cItem<>Nil,cItem,"01")
									ElseIf ( aHeader[ny][10] <> "V")
										aCols[Len(aCols)][ny] := CriaVar(aHeader[ny][2])
									EndIf
									aCols[Len(aCols)][Len(aHeader)+1] := .F.
								Next ny
							Endif
							_Item := "1"
							_N := Len(aCols)
							dbSelectArea("SF4")
							dbSetOrder(1)
							DbSeek(xFilial()+cTes)
							dbSelectArea("OP")
							DbSeek(aTerceiros[nx][3])
							dbSelectArea("SB1")
							dbSetOrder(1)
							DbSeek(xFilial()+aTerceiros[nx][3])
							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³ Preenche acols                                                      ³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
							If nPosCod <> 0
								aCols[_N][nPosCod] := aTerceiros[nx][3]
							EndIf
							If nPLocal <> 0
								aCols[_N][nPLocal]   := aTerceiros[nx][7]
							EndIf
							If nPTes <> 0
								aCols[_N][nPTes]     := cTes
							EndIf
							If nPCF <> 0
								aCols[_N][nPCF]      := SF4->F4_CF
							EndIf
							If nPUM <> 0
								aCols[_N][nPUM]      := SB1->B1_UM
							EndIf
							If nPDescri <> 0
								aCols[_N][nPDescri]  := SB1->B1_DESC
							EndIf
							If nPQuant <> 0
								aCols[_N][nPQuant]   := aTerceiros[nx][6]
							EndIf
							If nOPBNCF <> 0
								aCols[_N][nOPBNCF]   := cOP1
							EndIf
							If nOP <> 0
								aCols[_N][nOP]   := cOP1
							EndIf
							IF CEMPANT="04" .AND. CFILANT="01"
								NCUSTO_INI := 0
								CMAXDATA_SB9 := ""
								// Busca o custo do último de fechamento 
								cQuery := " SELECT MAX(B9_DATA) AS CMAXDATA, B9_CM1"
								cQuery += " FROM " + RetSqlName("SB9") + " SB9 "
								cQuery += " WHERE B9_COD = '"+aTerceiros[nx][3]+"'"
								cQuery += " AND B9_LOCAL = '"+aTerceiros[nx][7]+"'"
								cQuery += " AND B9_FILIAL = '" + xFILIAL("SB9") + "'"
								cQuery += " AND D_E_L_E_T_ <> '*'"
								CQUERY += " GROUP BY B9_CM1"

								MemoWrite("FATRD001.SQL",cQuery)
								dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"AUX")
								Count To nCount
								If nCount >0
									Dbselectarea("AUX")
									DbGoTop()
									NCUSTO_INI := AUX->B9_CM1
								ENDIF
								AUX->(dbCloseArea())

								// Caso não custo do último de fechamento, busca do custo médio do dia
								IF NCUSTO_INI=0
									dbSelectArea("SB2")
									dbSetOrder(1)
									DbSeek(xFilial("SB2") + aTerceiros[nx][3] + aTerceiros[nx][7] )
									NCUSTO_INI := SB2->B2_CM1
								ENDIF
								// Caso nenhuma das opções anteriores busca o preço unitário de compra
								IF NCUSTO_INI=0
									dbSelectArea("SB1")
									dbSetOrder(1)
									DbSeek(xFilial("SB1") + aTerceiros[nx][3] )
									NCUSTO_INI := SB1->B1_UPRC
								ENDIF
								aCols[_N][nPPrcVen]  := NCUSTO_INI
							ELSE
								If nPPrcVen <> 0
									cQuery := " SELECT AIB_CODPRO, AIB_PRCCOM "
									cQuery += " FROM "+RetSqlName("AIB")
									cQuery += " WHERE AIB_CODPRO = '"+aTerceiros[nx][3]+"'"
									cQuery += " AND D_E_L_E_T_ <> '*'"
									cQuery += " AND AIB_DATVIG >= '"+Dtos(dDataBase)+"'"

									//MemoWrite("FATRD001.SQL",cQuery)
									dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"CAD")

									Count To nCount

									If nCount >0
										Dbselectarea("CAD")
										DbGoTop()

										nPrecoCom := CAD->AIB_PRCCOM
										If CAD->AIB_PRCCOM != 0
											nPrecoCom := Iif(a410Arred(nPrecoCom,"C6_VALOR") != 0 , a410Arred(nPrecoCom,"C6_VALOR") , 0.01 )
										EndIf
									Else
										nPrecoCom := SB1->B1_UPRC
										If SB1->B1_UPRC != 0
											nPrecoCom := Iif(a410Arred(nPrecoCom,"C6_VALOR") != 0 , a410Arred(nPrecoCom,"C6_VALOR") , 0.01 )
										EndIf
									EndIf
									CAD->(dbCloseArea())

									aCols[_N][nPPrcVen]  := nPrecoCom
								EndIf
							ENDIF
							If nPValor <> 0
								aCols[_N][nPValor] := a410Arred(IIf(aCols[_N][nPQuant]==0,1,aCols[_N][nPQuant])*aCols[_N][nPPrcVen],"C6_VALOR")
							Endif
							cItem := SomaIt(cItem)
							//						If cItem > "11"
							//							MsgInfo("O número de itens selcionados ultrapassou 11, será necessário fazer mais um pedido complementar","ITENS FALTANTES!")
							//							Exit
							//						Endif
						Endif
					EndIf
				Next
			Endif

		Else
			MsgBox("Nenhum Item Selecionado")
		Endif
	EndIf

	//ADICIONA DADOS AO CABECALHO DO PEDIDO
	dbSelectArea("SC2")
	dbSetOrder(1)
	DbSeek(xFilial()+cOP1)

	M->C5_CLIENTE := SC2->C2__FORNEC
	M->C5_LOJACLI := SC2->C2__LOJAFO
	//M->C5_CLIENT  := Space(06)
	M->C5_CLIENT  	:= SC2->C2__FORNEC
	M->C5_LOJAENT	:= SC2->C2__LOJAFO
	IF CEMPANT="04" .AND. CFILANT="01"
		M->C5_CONDPAG := "045"
	ELSE
		M->C5_CONDPAG := "001"
	ENDIF
	If ! "REMESSA" $ M->C5_MENNOTA
		M->C5_MENNOTA := "REMESSA DE MATERIAL P/ INDUSTRIALIZAÇÃO CONFORME O.P " + SC2->C2_NUM+"."+SC2->C2_ITEM+"."+SC2->C2_SEQUEN
	ElseIf !(SC2->C2_NUM+"."+SC2->C2_ITEM+"."+SC2->C2_SEQUEN) $ M->C5_MENNOTA
		M->C5_MENNOTA := AllTrim(M->C5_MENNOTA)+", " + SC2->C2_NUM+"."+SC2->C2_ITEM+"."+SC2->C2_SEQUEN
	EndIf
	M->C5_TIPOCLI	:= "F"

	dbSelectArea("OP")
	DbcloseArea()
	fERASE(_cArqC1+".dbf")
	RestArea(aArea)
	Close(oDlg1)
	n:= nOld
Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Montarq   ºAutor  ³Microsiga           º Data ³  07/19/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function Montarq()

	While !Eof() .and. Left(SD4->D4_OP,6)==Left(cOP1,6)
		DbSelectArea("OP")
		DbGoTop()
		Locate for SD4->D4_COD == OP->CODCOMP
		If !Found()
			RecLock("OP",.T.)
			OP->CODCOMP  := SD4->D4_COD
			OP->QTDCOMP  := SD4->D4_QUANT
			OP->LOCCOMP  := "31"
			OP->QTBNFC	 := IIF( CEMPANT="04" .AND. CFILANT="01",SD4->D4_QUANT,SD4->D4__QTBNFC)
			OP->QTDORI	 := SD4->D4_QTDEORI
		Else
			RecLock("OP",.F.)
			OP->CODCOMP  := OP->CODCOMP+SD4->D4_COD
			OP->QTDCOMP  := OP->QTDCOMP+SD4->D4_QUANT
			OP->QTBNFC	 := IIF( CEMPANT="04" .AND. CFILANT="01",OP->QTBNFC+SD4->D4_QUANT,OP->QTBNFC+SD4->D4__QTBNFC) 
		Endif
		dbSelectArea("SD4")
		DbSkip()
		IncProc()
	End
Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FCOLOR    ºAutor  ³Microsiga           º Data ³  09/22/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ RETORNA O STATUS DO PEDIDO                                 º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
//SEM SALDO - "BR_VERMELHO"
//COM SALDO - "BR_VERDE"

Static Function fColor()
	//QUANDO FOR DEVOLUCAO

	//LIBERADO
	If nEstq > 0
		Return(LoadBitMap(GetResources(),"BR_VERDE"   ))
	Endif


	//FATURADO
	If nEstq <= 0
		Return(LoadBitMap(GetResources(),"BR_VERMELHO"   ))
	Endif


Return
