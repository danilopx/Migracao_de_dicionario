#include "rwmake.ch"
#DEFINE VALMERC  	 1  // Valor total do mercadoria 
#DEFINE VALDESC 	 2  // Valor total do desconto
#DEFINE FRETE   	 3  // Valor total do Frete
#DEFINE VALDESP 	 4  // Valor total da despesa

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
��� Programa � COMRD002 � Autor � Paulo Bindo           � Data � 28/09/15 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � BUSCA ESTRUTUR A PARTIR DA OP NO PEDIDO DE COMPRAS         ���
�������������������������������������������������������������������������Ĵ��
��� Uso      �                                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function COMRD002()
	Private cOP1 	:= Space(13)

If MaFisFound("NF") .And. !Empty(cA120Forn) .And. !Empty(cA120Loj) .And. !Empty(cCondicao)

	@ 100,55 To 280,500 Dialog oDlg1 Title OemToAnsi("Estrutura")
	@ 10,020  Say OemToAnsi("Informe a OP de que deseja buscar a estrutura") Size 300,8
	@ 35,020  Say OemToAnsi("OP 1  :")  Size 20,8
	@ 35,050  Get cOP1 Picture "@!" F3 "SC2" VALID EXISTCPO("SC2",cOP1 ,1)Size 53,10
	

	@ 70,20 Button OemToAnsi("_Confirmar") Size 32,12 Action Estrutura()
	@ 70,60 Button OemToAnsi("_Sair")      Size 32,12 Action Close(oDlg1)
	Activate Dialog oDlg1 Centered
Else
	Help("  ",1,"A120CAB") // Campos obrigatorios do cabecalho nao preenchidos.
EndIf
Return


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �ESTRUTURA �Autor  �Microsiga           � Data �  07/19/05   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static FUNCTION ESTRUTURA()
	Local nPosCod	:= aScan(aHeader,{|x| AllTrim(x[2])=='C7__OPBNFC'})
	Local oOk		:= LoadBitMap(GetResources(), "LBOK")
	Local oNo		:= LoadBitMap(GetResources(), "LBNO")
	Local oDlg
	Local oListBox
	//Local cListBox
	Local lContinua := .T.
	Local nOpc		:= 0
	Local nOld		:= n
	Local aArea     := GetArea()
	Local nFator 	:= 0
	Local aRefImpSC7:= MaFisRelImp('MT100',{"SC7"})
	Local _ny		:= 1
	Local nY		:= 1
	Local nx		:= 1

	Private nEstq	:= 0

	//ORDEM PRODUCAO
	dbSelectArea("SC2")
	dbSetOrder(1)
	DbSeek(xFilial()+cOP1)
	nQtdOP := SC2->C2_QUANT
	cFornece :=SC2->C2__FORNEC
	
	
	//VALIDA FORNECEDOR
	If Empty(cFornece)
		MsgStop("A OP1 selecionada n�o possui um fornecedor, contacte Compras!","Aten��o! - COMRD001")
		Close(oDlg1)
		Return
	EndIf


// Declara Arrays p/ Consultas
	_aArqC1 := {}
	AADD(_aArqC1,{"CODCOMP"	,"C",15,0})
	AADD(_aArqC1,{"QTDCOMP"	,"N",12,6})
	AADD(_aArqC1,{"LOCCOMP"	,"C",02,0})
	AADD(_aArqC1,{"QTBNFC"	,"N",09,0})
	AADD(_aArqC1,{"QTDORI"	,"N",12,6})

// Arquivo Auxiliar para Consultas
	_cArqC1 := CriaTrab(_aArqC1,.T.)
	dbUseArea(.T.,,_cArqC1,"OP")
	Index on CODCOMP to &_cArqC1


	aTerceiros := {}
	aConteudos := {}
	If lContinua
		dbSelectArea("SD4")
		dbSetOrder(2)
		If DbSeek(xFilial()+cOP1)
			MsgRun("Montanto a tela de pedido da 1� OP, Aguarde...","",{|| CursorWait(), Montarq(70,80) ,CursorArrow()})
		Else
			MSGBOX("A OP " + cOP1 + " n�o foi localizada!")
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
			//SOMENTE MAO DE OBRA E MATERIAL AUXILIAR ENTRAM NA ROTINA  
			If SB1->B1_TIPO $ "MO|MA|"
				dbSelectArea("SB2")
				dbSetOrder(1)
				DbSeek(xFilial()+OP->CODCOMP+OP->LOCCOMP)
				 
				//01- MARCA, 02-COR, 03- PRODUTO, 04-DESCRICAO, 05-SC, 06- NECESSIDADE, 07- ALMOX, 08- QTDE JA ENVIADA
				aConteudos := {.T.,fColor(),SB1->B1_COD,SB1->B1_DESC,'',(OP->QTDCOMP-OP->QTBNFC),"31",OP->QTBNFC}
				aadd(aTerceiros, aConteudos)
			EndIf
			DbSelectArea("OP")
			DbSkip()
		Enddo
		If (!Empty(aTerceiros))
			aTitCampos := {" ","",OemToAnsi("Produto"),OemToAnsi("Descricao"),OemToAnsi("S.C."),OemToAnsi("Necessidade"),OemToAnsi("J� Enviado")}
			cLine := "{If(aTerceiros[oListBox:nAt,1],oOk,oNo),aTerceiros[oListBox:nAT][2],aTerceiros[oListBox:nAT][3],aTerceiros[oListBox:nAT][4],Transform(aTerceiros[oListBox:nAT][5],'@E 99999999.99'),Transform(aTerceiros[oListBox:nAT][6],'@E 99999999.99'),Transform(aTerceiros[oListBox:nAT][8],'@E 99999999.99'),} "
			bLine := &( "{ || " + cLine + " }" )
			DEFINE MSDIALOG oDlg FROM 50,40  TO 285,741 TITLE "ESTRUTURA" Of oMainWnd PIXEL
			oListBox := TWBrowse():New( 17,4,343,80,,aTitCampos,,oDlg,,,,,,,,,,,,.F.,,.T.,,.F.,,,)
			oListBox:SetArray(aTerceiros)
			oListBox:bLDblClick := { || Iif(aTerceiros[oListBox:nAt,6]> 0,aTerceiros[oListBox:nAt,1] := !aTerceiros[oListBox:nAt,1],.F.)}
			oListBox:bLine := bLine
			ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{||(nOpc := 1,nF4For := oListBox:nAt,oDlg:End())},{||(nOpc := 0,nF4For := oListBox:nAt,oDlg:End())},,) //aButtons)
		
			If ( nOpc == 1 )
			
				nPosCod	  := aScan(aHeader,{|x| AllTrim(x[2])=='C7_PRODUTO'		})
				nPUM      := aScan(aHeader,{|x| AllTrim(x[2])=="C7_UM"			})
				nPQuant   := aScan(aHeader,{|x| AllTrim(x[2])=="C7_QUANT"		})
				nPDescri  := aScan(aHeader,{|x| AllTrim(x[2])=="C7_DESCRI"		})
				nPLocal   := aScan(aHeader,{|x| AllTrim(x[2])=="C7_LOCAL"		})
				nPPrcVen  := aScan(aHeader,{|x| AllTrim(x[2])=="C7_PRECO"		})
				nPValor   := aScan(aHeader,{|x| AllTrim(x[2])=="C7_TOTAL"		})
				nPTes     := aScan(aHeader,{|x| AllTrim(x[2])=="C7_TES"			})
				nOPBNCF	  := aScan(aHeader,{|x| AllTrim(x[2])=="C7__OPBNFC"		})
				nCC		  := aScan(aHeader,{|x| AllTrim(x[2])=="C7_CC"			})
				cClasCon  := aScan(aHeader,{|x| AllTrim(x[2])=="C7_CLASCON"		}) //1
				cItConta  := aScan(aHeader,{|x| AllTrim(x[2])=="C7_ITEMCTA"		})
				cConta	  := aScan(aHeader,{|x| AllTrim(x[2])=="C7_CONTA"		})
				dEntrega  := aScan(aHeader,{|x| AllTrim(x[2])=="C7_DATPRF"		})
				 
				N    := Len(aCols)
				_Item := aCols[N][nPosCod]
				cItem := BuscaCols("C7_ITEM")
				If !Empty(_Item)
					cItem := SomaIt(cItem)
				Endif
				For nx	:= 1 to Len(aTerceiros)
					If aTerceiros[nx][1]
						_lExiste := .f.
						
						For _ny := 1 to Len(aCols)
						// Verificar se o OP j� foi incluido, se sim adicionar a quantidade, e acertar valor total
							If aCols[_ny][nPosCod]	== aTerceiros[nx][3]
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
								MsgInfo("O item "+aCols[_ny][nPosCod]+" estava deletado e foi recuperado!","COMRD001")
							EndIf
						Else
							If !Empty(_Item)
								aadd(aCols,Array(Len(aHeader)+1))  // linha em branco no aCols
								For nY := 1 to Len(aHeader)
									If Trim(aHeader[nY][2]) == "C7_ITEM"
										aCols[Len(aCols)][nY] 	:=cItem
									Elseif Trim(aHeader[nY][2]) == "C7_ALI_WT"
										aCols[Len(aCols)][nY] 	:="SC7"
									Elseif Trim(aHeader[nY][2]) == "C7_REC_WT"
										aCols[Len(aCols)][nY] 	:= 0
									ElseIf ( aHeader[nY][10] != "V")
										aCols[Len(aCols)][nY] := CriaVar(aHeader[nY][2])
									EndIf
									aCols[Len(aCols)][Len(aHeader)+1] := .F.
								Next nY
							Endif
							_Item := "1"
							N := Len(aCols)
							dbSelectArea("OP")
							DbSeek(aTerceiros[nx][3])
							dbSelectArea("SB1")
							dbSetOrder(1)
							DbSeek(xFilial()+aTerceiros[nx][3])
						//���������������������������������������������������������������������Ŀ
						//� Preenche acols                                                      �
						//�����������������������������������������������������������������������
							If nPosCod <> 0
								aCols[N][nPosCod] := aTerceiros[nx][3]
								A093PROD()
								A120Tabela()
								A120Produto(aCols[N][nPosCod])

							EndIf
							
							If nPLocal <> 0
								aCols[N][nPLocal]   := aTerceiros[nx][7]
							EndIf

							If nPUM <> 0
								aCols[N][nPUM]      := SB1->B1_UM
							EndIf
							If nPDescri <> 0
								aCols[N][nPDescri]  := SB1->B1_DESC
							EndIf
							
							If nPQuant <> 0
								aCols[N][nPQuant]   := aTerceiros[nx][6]
								a120quant(aCols[N][nPQuant],2)

					//���������������������������������������������Ŀ
					//� Inicia a Carga do item nas funcoes MATXFIS  �
					//�����������������������������������������������
								If MaFisFound("IT",n)
									MaFisAlt("IT_QUANT",SuperVal(aTerceiros[nx][6]),nx)
									MaColsToFis(aHeader,aCols,n,"MT120",.T.)
								EndIf
								If nOPBNCF <> 0
									aCols[N][nOPBNCF]   := cOP1
								EndIf

							
								If nCC <> 0
								aCols[N][nCC]   := SB1->B1_CC
								EndIf
								If cClasCon <> 0
									aCols[N][cClasCon]   := SB1->B1_CLASCON
								EndIf
								If cItConta <> 0
							//	aCols[N][cItConta]   := cOP1
								EndIf
								If cConta <> 0
							//	aCols[N][cConta]   := cOP1
								EndIf
								If dEntrega <> 0
							//	aCols[N][dEntrega]   := cOP1
								EndIf
							
								aArea2 := GetArea()
								If nPPrcVen <> 0
									cQuery := " SELECT AIB_CODPRO, AIB_PRCCOM "
									cQuery += " FROM "+RetSqlName("AIB")
									cQuery += " WHERE AIB_CODPRO = '"+aTerceiros[nx][3]+"'"
									cQuery += " AND D_E_L_E_T_ <> '*'"
									cQuery += " AND AIB_DATVIG >= '"+Dtos(dDataBase)+"'"
							
									MemoWrite("COMRD001.SQL",cQuery)
									dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"CAD")
							
									Count To nCount
							
									If nCount >0
										Dbselectarea("CAD")
										DbGoTop()
								
										nPrecoCom := CAD->AIB_PRCCOM
									Else
										nPrecoCom := SB1->B1_UPRC
									EndIf
									CAD->(dbCloseArea())
									RestArea(aArea2)
									aCols[N][nPPrcVen]  := nPrecoCom
								
								EndIf
								If nPValor <> 0
									aCols[N][nPValor] := a410Arred(IIf(aCols[N][nPQuant]==0,1,aCols[N][nPQuant])*aCols[N][nPPrcVen],"C7_TOTAL")
									
								
								Endif

								MaFisAdd(aCols[n][nPosCod],"",aCols[n][nPQuant],aCols[n][nPPrcVen],0,"","",,0,0,0,0,aCols[n][nPValor])
								A120Tabela("C7_QUANT",SuperVal(aCols[n][nPQuant]))

								cItem := SomaIt(cItem)
							Endif

						EndIf
						
					
					EndIf
				Next
			
	Eval(bListRefresh)
	Eval(bGDRefresh)	


			Endif
		
		Else
			MsgBox("Nenhum Item Selecionado")
		Endif
	EndIf


	dbSelectArea("OP")
	DbcloseArea()
	fERASE(_cArqC1+".dbf")
	RestArea(aArea)
	Close(oDlg1)
	n:= nOld
Return


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �Montarq   �Autor  �Microsiga           � Data �  07/19/05   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function Montarq(n1, n2)

	While !Eof() .and. Left(SD4->D4_OP,6)==Left(cOP1,6)
		DbSelectArea("OP")
		DbGoTop()
		Locate for SD4->D4_COD == OP->CODCOMP
		If !Found()
			RecLock("OP",.T.)
			OP->CODCOMP  := SD4->D4_COD
			OP->QTDCOMP  := SD4->D4_QUANT
			OP->LOCCOMP  := "31"
			OP->QTBNFC	 := SD4->D4__QTPCBN
			OP->QTDORI	 := SD4->D4_QTDEORI
		Else
			RecLock("OP",.F.)
			OP->CODCOMP  := OP->CODCOMP+SD4->D4_COD
			OP->QTDCOMP  := OP->QTDCOMP+SD4->D4_QUANT
			OP->QTBNFC	 := OP->QTBNFC+SD4->D4__QTPCBN
		Endif
		dbSelectArea("SD4")
		DbSkip()
		IncProc()
	End
Return


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �Montarq2  �Autor  �Microsiga           � Data �  07/19/05   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
/*
Static Function Montarq2()
While !Eof() .and. Left(SD4->D4_OP,6)==Left(cOP2,6)
DbSelectArea("OP")
DbGoTop()
Locate for SD4->D4_COD == OP->CODCOMP
If !Found()
RecLock("OP",.T.)
OP->CODCOMP  := SD4->D4_COD
OP->QTDCOMP  := SD4->D4_QUANT
Else
RecLock("OP",.F.)
OP->CODCOMP  := OP->CODCOMP+SD4->D4_COD
OP->QTDCOMP  := OP->QTDCOMP+SD4->D4_QUANT
Endif
dbSelectArea("SD4")
DbSkip()
IncProc()
Enddo
Return
*/

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �FCOLOR    �Autor  �Microsiga           � Data �  09/22/08   ���
�������������������������������������������������������������������������͹��
���Desc.     � RETORNA O STATUS DO PEDIDO                                 ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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
