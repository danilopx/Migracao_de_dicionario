#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "TBICONN.CH"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ SX5NOTA  ºAutor  ³ Jorge Tavares      º Data ³  12/07/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Valida qual serie pode ser usada por unidade de negocios.  º±±
±±º          ³ Usado em conjunto com pontos M460FIL e M460QRY			  º±±
±±º          ³  													      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function SX5NOTA()

Local lRet		:= .T.
Local aSx1area 	:= {}
Local aSxkarea 	:= {}
Local lUniNeg	:= cEmpAnt+cFilant $ GETNEWPAR('MV_UNINEG'/*cParametro*/, cEmpAnt+cFilant /*cPadrao*/, /*cFilial*/)
Local cSerie	:= ''
Local _lStatusFaseII := GetNewPar("MV_ARMCEN",.F.)


If lUniNeg .or. _lStatusFaseII
	If IsinCallStack("MATA410")  //Pedido de Vendas
		cSerie :=   Iif( SC5->C5_CLASPED="A","3",Iif(Alltrim(SC5->C5_XITEMC)=='TAIFF','1',Iif(Alltrim(SC5->C5_XITEMC)=='PROART','2','4') ))
		If Alltrim(SX5->X5_CHAVE) <> cSerie  // 1 - Taiff, 2 - Proart, 4 - Corp, ASSTEC
			lRet := .F. // Nao mostra a Serie
		Endif
		
		/*
		|---------------------------------------------------------------------------------
		|	Alterado para que verifique as Series de Contigencia
		|
		|	Edson Hornberger - 02//05/2014
		|---------------------------------------------------------------------------------
		*/
		
		If Alltrim(SX5->X5_CHAVE) >= '900' .AND. Alltrim(SX5->X5_CHAVE) <= '999'//Serie para contigencia
			lRet := .T. // mostra a Serie
		Endif
		cSerie :=   Iif( SC5->C5_CLASPED="A","7",Iif(Alltrim(SC5->C5_XITEMC)=='TAIFF','5',Iif(Alltrim(SC5->C5_XITEMC)=='PROART','6','4') ))
		If Alltrim(SX5->X5_CHAVE) = cSerie  
			lRet := .T. 
		Endif
		If Alltrim(SX5->X5_CHAVE) = "AJU" //Serie para BENEFICIAMENTO de ajuste VER CHAMADO 10669 
			lRet := .T. // mostra a Serie
		Endif
	ElseIf IsinCallStack("MATA103")	.OR. IsinCallStack("MATA140")//Documento de Entrada(Devolucao de Vendas) e Pre-Nota
		If getServerIP()="192.168.0.8" /* servidor de testes */
			If Len(acols)>0
				cSerie := 	Iif( Alltrim(acols[1][GdFieldPos('D1_ITEMCTA')])=='TAIFF' ,'5',;
							Iif( Alltrim(acols[1][GdFieldPos('D1_ITEMCTA')])=='PROART','6','4') )// 1 - Taiff, 2 - Proart, 3 - Corp
							
				If Alltrim(acols[1][GdFieldPos('D1_ITEMCTA')])=='TAIFF' .AND. Alltrim(acols[1][GdFieldPos('D1_SERIORI')]) != ""
					cSerie:=Alltrim(acols[1][GdFieldPos('D1_SERIORI')])
				EndIf
			EndIf				//-- Valido somente 1. item do acols pois ja foram validados todos os itens pelo
								//-- PE. MT100TOK antes.
		Else
			If Len(acols)>0
				cSerie := 	Iif( Alltrim(acols[1][GdFieldPos('D1_ITEMCTA')])=='TAIFF' ,'1',;
							Iif( Alltrim(acols[1][GdFieldPos('D1_ITEMCTA')])=='PROART','2','4') )// 1 - Taiff, 2 - Proart, 3 - Corp
				If Alltrim(acols[1][GdFieldPos('D1_ITEMCTA')])=='TAIFF' .AND. Alltrim(acols[1][GdFieldPos('D1_SERIORI')]) != ""
					cSerie:=Alltrim(acols[1][GdFieldPos('D1_SERIORI')])
				EndIf
				If Alltrim(acols[1][GdFieldPos('D1_LOCAL')])=="51" .AND. Alltrim(acols[1][GdFieldPos('D1_CLASCON')])=="7" .AND. CEMPANT="03" .AND. CFILANT="01" 
					cSerie := "3"
				EndIf
			EndIf				//-- Valido somente 1. item do acols pois ja foram validados todos os itens pelo
								//-- PE. MT100TOK antes.
		EndIf
		If Alltrim(SX5->X5_CHAVE) <> cSerie  // 1 - Taiff, 2 - Proart, 3 - Corp
			lRet := .F. // Nao mostra a Serie
		Endif		
	ElseIf IsinCallStack("U_FATAT063") .OR. IsinCallStack("FATAT063") 	

		aSx1area 	:= SX1->(Getarea())
		SX1->(DbsetOrder(1))  // Documento de Saida
		If SX1->( Dbseek(PADR('FTAT63',Len(SX1->X1_GRUPO))+'09') )
			If Left(Alltrim(SX5->X5_CHAVE),1) <> Alltrim(Str(SX1->X1_PRESEL))  // 1 - Taiff, 2 - Proart, 3 - Corp
				lRet := .F. // Nao mostra a Serie
			Endif
			If Alltrim(SX5->X5_CHAVE) = '5' .AND. Alltrim(Str(SX1->X1_PRESEL))='1'
				lRet := .T. // mostra a Serie
			Endif
			If Alltrim(SX5->X5_CHAVE) = '6' .AND. Alltrim(Str(SX1->X1_PRESEL))='2'
				lRet := .T. // mostra a Serie
			Endif
			
		EndIf
		RestArea(aSx1area)
	Else
		aSx1area 	:= SX1->(Getarea())
		aSxkarea 	:= SXK->(Getarea())
		/*
		|---------------------------------------------------------------------------------
		|	Realizado alteracao no fonte Linha 62 passando a pesquisa de 13 para 16, pois
		|	o Consultor Jorge "amarrou" esta pesquisa.
		| 	Edson Hornberger - 11/06/2014
		|---------------------------------------------------------------------------------
		*/
		cNfeAstec := ""
		
		SXK->(DbsetOrder(1))  // Documento de Saida
		SX1->(DbsetOrder(1))  // Documento de Saida
		If SXK->( Dbseek(PADR('MT461A',Len(SXK->XK_GRUPO)) + "19" + "U" + __CUSERID) )
			cNfeAstec := Iif(LEFT(SXK->XK_CONTEUD,1) = "2" ,"A","")
		ElseIf SX1->( Dbseek(PADR('MT461A',Len(SX1->X1_GRUPO))+'19') )
			cNfeAstec := LEFT(SX1->X1_CNT01,1)
		EndIf
		If SXK->( Dbseek(PADR('MT461A',Len(SXK->XK_GRUPO)) + "17" + "U" + __CUSERID) )

			nSelecSerie := Iif( LEFT(SXK->XK_CONTEUD,1)="T","1",Iif(LEFT(SXK->XK_CONTEUD,1)="P","2","4"))
			If cNfeAstec = "A"
				nSelecSerie := "3"  
			EndIf
			If At( "DESENV",GetEnvServer()) != 0  /* Nos ambientes DESENV a serie é diferente ao da PRODUCAO */
				nSelecSerie := Iif(nSelecSerie="1","5",Iif(nSelecSerie="2","6",nSelecSerie))  
				If cNfeAstec = "A"
					nSelecSerie := "7"  
				EndIf
			EndIf
						
			If Left(Alltrim(SX5->X5_CHAVE),1) <> nSelecSerie  // 1 - Taiff, 2 - Proart, 4 - Corp
				lRet := .F. // Nao mostra a Serie
			Endif

			/* Nos ambiente DESENV não mostra as series de produção */
			If At( "DESENV",GetEnvServer()) != 0  .and. Left(Alltrim(SX5->X5_CHAVE),1) < "5"
				lRet := .F. // Nao mostra a Serie
			EndIf
			If Alltrim(SX5->X5_CHAVE) = "AJU" //Serie para BENEFICIAMENTO de ajuste VER CHAMADO 10669 
				lRet := .T. // mostra a Serie
			Endif
			
		ElseIf SX1->( Dbseek(PADR('MT461A',Len(SX1->X1_GRUPO))+'17') )

			nSelecSerie := Alltrim(Str(SX1->X1_PRESEL))
			If cNfeAstec = "A"
				nSelecSerie := "3"  
			EndIf
			If At( "DESENV",GetEnvServer()) != 0  /* Nos ambientes DESENV a serie é diferente ao da PRODUCAO */
				nSelecSerie := Iif(nSelecSerie="1","5",Iif(nSelecSerie="2","6",nSelecSerie))  
				If cNfeAstec = "A"
					nSelecSerie := "7"  
				EndIf
			EndIf
						
			If Left(Alltrim(SX5->X5_CHAVE),1) <> nSelecSerie  // 1 - Taiff, 2 - Proart, 4 - Corp
				lRet := .F. // Nao mostra a Serie
			Endif

			/* Nos ambiente DESENV não mostra as series de produção */
			If At( "DESENV",GetEnvServer()) != 0  .and. Left(Alltrim(SX5->X5_CHAVE),1) < "5"
				lRet := .F. // Nao mostra a Serie
			EndIf
			If Alltrim(SX5->X5_CHAVE) = "AJU" //Serie para BENEFICIAMENTO de ajuste VER CHAMADO 10669 
				lRet := .T. // mostra a Serie
			Endif
			
			
		EndIf
		RestArea(aSx1area)
		RestArea(aSxkarea)
				
	EndIf
EndIf

Return lRet