#include "protheus.ch"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �PRTC0003  �Autor  �VETI FSW            � Data �  09/19/11   ���
�������������������������������������������������������������������������͹��
���Desc.     �Programa para a libera�a de estoques                        ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �ProArt                                                      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function PRTC0003()

Local cAliasBKP		:= Iif(Empty(Alias()),"SB2",Alias())
Local aOrdBKP		:= SaveOrd({cAliasBKP,"SB2","SC6"})
Local nPosItem     	:= GdFieldPos("C6_ITEM")
Local nPosProd   	:= GdFieldPos("C6_PRODUTO")
Local nPosAlm     	:= GdFieldPos("C6_LOCAL")
Local nPosQtdLib 	:= GdFieldPos("C6_QTDLIB")
Local nPosQtdVen 	:= GdFieldPos("C6_QTDVEN")
Local nPosPrc		:= GdFieldPos("C6_PRCVEN")
Local nMinTot		:= GetNewPar("PRT_SEP025",100 )
Local nParcMin		:= GetNewPar("PRT_SEP026",50 )
Local cFilSC6		:= xFilial("SC6")
Local cFilSB2		:= xFilial("SB2")
Local _nx			:= 0
Local nEstoque		:= 0
Local nQtdEnt		:= 0
Local nQtdEmp		:= 0
Local nPrcVen		:= 0
Local aFaltas		:= {}
Local aPosicao		:= {}
Local nSaldo		:= 0
Local aLibera		:= {}
Local aHeaFalta		:= {}
Local nTotPed		:= 0
Local nValFalta		:= 0
Local nConta		:= 0

//����������������������������������������Ŀ
//�Vari�veis Utilizadas na Montagem da Tela�
//������������������������������������������
Local aSize  	:= {}
Local aObjects  := {}
Local aInfo 	:= {}
Local aPosObj	:= {}
//Local nOpcoes 	:= 0
Local nOpcoes 	:=	GD_UPDATE
Local cTitulo 	:= "Produtos em Falta"
Local lOk		:= .F.
Local aParc		:= {}  

Local nQAtu02	:=0
Local nQReser02	:=0
Local nQDisp02	:=0

Local nQAtu11	:=0
Local nQReser11	:=0
Local nQDisp11	:=0

Local nQAtu21	:=0
Local nQReser21	:=0
Local nQDisp21	:=0

Local nQAtu31	:=0
Local nQReser31	:=0
Local nQDisp31	:=0

Local aAlterGDa := {}

Private oDlgFalta
Private oGetFalta

SB2->(DbSetOrder(1))

If IsInCallStack("U_TF_2AVN_A2")
	
	RestOrd(aOrdBKP)
	DbSelectArea(cAliasBKP)
	Return .T.
	
EndIf

For _nx := 1 to len(aCols)
	If !aCols[_nx][len(aHeader) + 1]
		nEstoque	:= 0
		nQtdEnt		:= 0
		nQtdEmp		:= 0
		nPrcVen		:= 0
		
		If SB2->(DbSeek(cFilSB2 + aCols[_nx][nPosProd]+ aCols[_nx][nPosAlm]))
			
			nQtdent := Posicione("SC6",1,cFilSC6 + M->C5_NUM + aCols[_nx][nPosItem] + aCols[_nx][nPosProd],"C6_QTDENT" )
			nQtdEmp := SC6->C6_QTDEMP
			nEstoque:= SaldoSb2(,GetNewPar("MV_QEMPV",.T.)) + nQtdEmp
			nPrcVen := aCols[_nx][nPosPrc]
			nSaldo	:= aCols[_nx][nPosQtdVen]
			
			nQAtu02:=Posicione("SB2",1,xFilial("SB2")+aCols[_nx][nPosProd]+"02","B2_QATU")
			nQReser02:=Posicione("SB2",1,xFilial("SB2")+aCols[_nx][nPosProd]+"02","B2_RESERVA")
			nQDisp02:=nQAtu02-nQReser02
			
			nQAtu11:=Posicione("SB2",1,xFilial("SB2")+aCols[_nx][nPosProd]+"11","B2_QATU")
			nQReser11:=Posicione("SB2",1,xFilial("SB2")+aCols[_nx][nPosProd]+"11","B2_RESERVA")
			nQDisp11:=nQAtu11-nQReser11
			
			nQAtu21:=Posicione("SB2",1,xFilial("SB2")+aCols[_nx][nPosProd]+"21","B2_QATU")
			nQReser21:=Posicione("SB2",1,xFilial("SB2")+aCols[_nx][nPosProd]+"21","B2_RESERVA")
			nQDisp21:=nQAtu21-nQReser21
			
			nQAtu31:=Posicione("SB2",1,xFilial("SB2")+aCols[_nx][nPosProd]+"31","B2_QATU")
			nQReser31:=Posicione("SB2",1,xFilial("SB2")+aCols[_nx][nPosProd]+"31","B2_RESERVA")
			nQDisp31:=nQAtu31-nQReser31

/*			nQAtu11:=Posicione("SB2",1,xFilial("SB2")+aCols[_nx][nPosProd]+"11","B2_QATU")
			nQAtu21:=Posicione("SB2",1,xFilial("SB2")+aCols[_nx][nPosProd]+"21","B2_QATU")
			nQAtu31:=Posicione("SB2",1,xFilial("SB2")+aCols[_nx][nPosProd]+"31","B2_QATU")
*/
			
			nTotPed += nPrcVen * nSaldo
			
			If nSaldo > 0
				If nSaldo > nEstoque .AND. Empty(SC6->C6_NOTA)
//					aAdd(aFaltas,{aCols[_nx][nPosItem],aCols[_nx][nPosProd],Posicione("SB1",1,xFilial("SB1") + aCols[_nx][nPosProd],"B1_DESC"),nSaldo - Iif(nEstoque<0,0,nEstoque),nEstoque,nQtdAlm02,nQtdAlm11,nQtdAlm21,nQtdAlm31,.F.})
					aAdd(aFaltas,{aCols[_nx][nPosItem],aCols[_nx][nPosProd],Posicione("SB1",1,xFilial("SB1") + aCols[_nx][nPosProd],"B1_DESC"),nSaldo ,nEstoque,nQDisp21,nQDisp02,nQDisp11,nQDisp31,.F.})
					nValFalta += (nSaldo - nEstoque) * nPrcVen
					aAdd(aPosicao,_nx)
				Else
					If Empty(SC6->C6_NOTA)
						aAdd(aLibera,{_nx,nSaldo})
					Endif	
				EndIf
			EndIf
		Endif
	EndIf

	 nQAtu02	:=0
	 nQReser02	:=0
	 nQDisp02	:=0
	 nQAtu11	:=0
	 nQReser11	:=0
	 nQDisp11	:=0
	 nQAtu21	:=0
	 nQReser21	:=0
	 nQDisp21	:=0
	 nQAtu31	:=0
	 nQReser31	:=0
	 nQDisp31	:=0

Next

//������������������������������������������������������������������������Ŀ
//�Caso nao tenha encontrado as faltas, realiza a liberacao total do pedido�
//��������������������������������������������������������������������������
If Empty(aFaltas)
	If (IsInCallStack("U_PRTC003V"))   
		If len(aLibera)>0
			If Aviso("PRTC0003","Pedido pode ser liberado totalmente. Confirma a liberacao?",{"Sim","Nao"}) == 1
				For _nx := 1 to len(aLibera)
					aCols[aLibera[_nx][1]][nPosQtdLib] := aLibera[_nx][2]
				Next
				lOk := .T.
			EndIf                                
		Else
			Alert("N�o Existe Itens Disponiveis para Libera��o")
		Endif
	Else
//		Alert("N�o Existe Faltas para esse Pedido!")
		Aviso("PRTC0003","N�o Existe Faltas para esse Pedido!",{"OK"})
	EndIf
	//�������������������������������������������������������������������������Ŀ
	//�Caso haja faltas, exibe a tela informando os produtos que possuem faltas.�
	//���������������������������������������������������������������������������
Else
	//�����������������������������Ŀ                 
	//�Realiza a Montagem do aHeader�
	//�������������������������������
//	AADD(aAlter,"C6_QTDLIB")

	Aadd(aHeaFalta,{RTrim(RetTitle("C6_ITEM"	))	,"C6_ITEM"		,"@!"				,TamSx3("C6_ITEM")[1]		,0,"AllwaysTrue()"	,"�","C","" } )
	Aadd(aHeaFalta,{RTrim(RetTitle("C6_PRODUTO"	))	,"C6_PRODUTO"	,"@!"				,TamSx3("C6_PRODUTO")[1]	,0,"AllwaysTrue()"	,"�","C","" } )
	Aadd(aHeaFalta,{RTrim(RetTitle("B1_DESC"	))	,"B1_DESC"		,"@!"				,TamSx3("B1_DESC")[1]		,0,"AllwaysTrue()"	,"�","C","" } )
	Aadd(aHeaFalta,{RTrim(RetTitle("C6_QTDVEN"	))	,"FALTA"		,"@!"				,TamSx3("C6_QTDVEN")[1]		,2,"AllwaysTrue()"	,"�","N","" } )
	Aadd(aHeaFalta,{RTrim(RetTitle("C6_QTDLIB"	))	,"C6_QTDLIB"	,"@!"				,TamSx3("C6_QTDLIB")[1]		,2,"AllwaysTrue()"	,"�","N","" } )
	Aadd(aHeaFalta,{"Disp. 21"	,"B2_QATU"	,"@!"				,TamSx3("B2_QATU")[1]		,2,"AllwaysTrue()"	,"�","N","" } )
	Aadd(aHeaFalta,{"Disp. 02"	,"B2_QATU"	,"@!"				,TamSx3("B2_QATU")[1]		,2,"AllwaysTrue()"	,"�","N","" } )
	Aadd(aHeaFalta,{"Disp. 11"	,"B2_QATU"	,"@!"				,TamSx3("B2_QATU")[1]		,2,"AllwaysTrue()"	,"�","N","" } )
	Aadd(aHeaFalta,{"Disp. 31"	,"B2_QATU"	,"@!"				,TamSx3("B2_QATU")[1]		,2,"AllwaysTrue()"	,"�A","N","" } )	

	Aadd(aAlterGDa,{RTrim(RetTitle("C6_QTDLIB"	))	,"C6_QTDLIB"	,"@!"				,TamSx3("C6_QTDLIB")[1]		,2,"AllwaysTrue()"	,"�","N","" } )
		
	//������������������������������������������������������Ŀ
	//� Faz o calculo automatico de dimensoes de objetos     �
	//��������������������������������������������������������
	aSize := MsAdvSize(.T.,.T.)
	aObjects := {}
	AAdd( aObjects, {   1  ,  120, .T., .T. } )
	aInfo := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ] ,3, 3 }
	aPosObj := MsObjSize( aInfo, aObjects )
	
	DEFINE MSDIALOG oDlg TITLE OemToAnsi(cTitulo) From aSize[7],0 to aSize[6]+100,aSize[5]+390 OF oMainWnd PIXEL
	
//	oGetFalta := MSNewGetDados():New( aPosObj[1,1],aPosObj[1,2],aPosObj[1,3],aPosObj[1,4]+200,nOpcoes,"AllwaysTrue()", "AllwaysTrue()","AllwaysTrue()",      ,       ,99999,"AllwaysTrue()",         ,"AllwaysTrue()",    ,@aHeaFalta  ,@aFaltas )

//	oGetDados:=  MsNewGetDados():New( nSuperior   ,nEsquerda   , nInferior  , nDireita       ,nOpc   ,cLinOk         , cTudoOk        , cIniCpos      ,aAlterGDa,nFreeze,nMax  ,cFieldOk      ,cSuperDel ,cDelOk        ,oDLG ,aHeader     ,aCols)
	oGetFalta := MSNewGetDados():New( aPosObj[1,1],aPosObj[1,2],aPosObj[1,3],aPosObj[1,4]+200,nOpcoes,"AllwaysTrue()", "AllwaysTrue()","AllwaysTrue()",         ,   6  ,9999   ,"AllwaysTrue()",         ,"AllwaysTrue()",    ,@aHeaFalta  ,@aFaltas )

	
	@aPosObj[1,3] + 10,aPosObj[1,2]    say "Total Pedido" of oDlg PIXEL
	@aPosObj[1,3] + 10,aPosObj[1,2]+40 say nTotPed PICTURE "@E 999,999,999.99" of oDlg PIXEL

	TotFat:=U_TotFAT()
	@aPosObj[1,3] + 20,aPosObj[1,2]    say "Total Faturado"  of oDlg PIXEL
	@aPosObj[1,3] + 20,aPosObj[1,2]+40 say TotFat PICTURE "@E 999,999,999.99" of oDlg PIXEL
	
	TotRS:=U_Residuo()
	@aPosObj[1,3] + 30,aPosObj[1,2]    say "Eliminado Residuo"  of oDlg PIXEL
	@aPosObj[1,3] + 30,aPosObj[1,2]+40 say TotRS PICTURE "@E 999,999,999.99" of oDlg PIXEL

	Saldo:=nTotPed - TotFat-TotRS  
	@aPosObj[1,3] + 40,aPosObj[1,2]    say "SALDO A FAT."  of oDlg PIXEL
	@aPosObj[1,3] + 40,aPosObj[1,2]+40 say Saldo PICTURE "@E 999,999,999.99" of oDlg PIXEL

	@aPosObj[1,3] + 10,aPosObj[1,2]+100    say "Total de Faltas"  of oDlg PIXEL
	@aPosObj[1,3] + 10,aPosObj[1,2]+170 say nValFalta PICTURE "@E 999,999,999.99" of oDlg PIXEL

	@aPosObj[1,3] + 20,aPosObj[1,2]+100    say "Total do Pedido (Com Faltas)"  of oDlg PIXEL
	@aPosObj[1,3] + 20,aPosObj[1,2]+170 say (Saldo - nValFalta) PICTURE "@E 999,999,999.99" of oDlg PIXEL
	

	
	ACTIVATE MSDIALOG oDlg CENTERED ON INIT EnchoiceBar(oDlg,{||lOk := .T., oDlg:End()},{||oDlg:End()}            ,,)
	
	If !(IsInCallStack("U_PRTC003V"))
		If (nTotPed - nValFalta) < nMinTot
			Aviso("PRTC0003","Total a ser liberado inferior ao valor minimo de pedido. Pedido nao sera liberado.",{"Ok"})
			lOk := .F.
		EndIf
	EndIf
	
	aParc := Condicao(nTotPed - nValFalta,M->C5_CONDPAG,0,dDataBase)
	
	nConta := 0
	aEval(aParc,{|x| Iif(x[2] < nParcMin,nConta++,.T.)})
	
	If !(IsInCallStack("U_PRTC003V"))
		If nConta > 0
			Aviso("PRTC0003","Valor da parcela inferior ao valor minimo de parcela. Pedido nao sera liberado.",{"Ok"})
			lOk := .F.
		Endif
	EndIf
	
	If !(IsInCallStack("U_PRTC003V"))                                                               
		If len(aLibera)>0 .OR. len(aFaltas)>0
			If lOk .and. Aviso("PRTC0003","Confirma a liberacao parcial do pedido?",{"Sim","Nao"}) == 1 
				//���������������������������������������Ŀ
				//�Realiza a liberacao dos itens sem falta�
				//�����������������������������������������
				For _nx := 1 to len(aLibera)
					aCols[aLibera[_nx][1]][nPosQtdLib] := aLibera[_nx][2]
				Next
				
				//����������������������������������������������Ŀ
				//�Realiza a liberacao parcial dos itens em falta�
				//������������������������������������������������
				For _nx := 1 to len(aFaltas)
					aCols[aPosicao[_nx]][nPosQtdLib] := aFaltas[_nx][5]
				Next
			Else
				Alert("N�o Existe Itens Disponiveis para Libera��o")
			Endif
		EndIf
	EndIf
Endif

//���������������������������������������������������������������������������
//�Restaura a Ordem Original dos arquivos, mantendo a integridade do sistema�
//���������������������������������������������������������������������������
RestOrd(aOrdBKP)
DbSelectArea(cAliasBKP)

Return lOk
