#INCLUDE "Protheus.ch"
#include "TbiConn.ch"
#include "TbiCode.ch"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CFGMI002  º Autor ³ Paulo Bindo        º Data ³  09/09/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ SCHEDULE DE IMPORTACAO DE PEDIDOS                          º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP6 IDE                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function CFGMI002(_cBase)

	LOCAL nLoopMI2 := 0

	/* {Empresa,Filial,1,Marca,ClassePedido} */
	/* Prioridade para a Marca e a Filial sempre começando por Extrema e produtos TAIFF */
	Public aEmpMI2	:= {{"03","02",1,"TAIFF",""},{"03","01",1,"TAIFF",""},{"03","02",1,"PROART",""},{"03","01",1,"PROART",""},{"03","01",1,"TAIFF","A"}}
	Public cMarcMI2	:= ""
	//Default _cBase := "T"
	
	If _cBase == "T"
		cMarcMI2 := "TAIFF"
	ElseIf _cBase == "P"
		cMarcMI2 := "PROART"
	EndIf

	/*
	CONOUT(_cBase)
	conout(cMarcMI2)
	CONOUT(SubStr(Time(),4,5))
	*/
	
	//ROTINA DE HORA EM HORA
	If (SubStr(Time(),4,5) >= "30:00" .And. SubStr(Time(),4,5) < "45:00"  .And. Time() >= "08:30:00" .And. Time() < "23:59:00")

		Conout("INICIO DAS ROTINAS HORA EM HORA "+Dtoc(Date())+"-"+Time())
		For nLoopMI2 := 1 to Len(aEmpMI2)

			If cMarcMI2 = aEmpMI2[nLoopMI2][4] .OR. Empty(cMarcMI2) 
				
				If aEmpMI2[nLoopMI2][5] != "A" // Não faz importação de orçamentos da ASTEC 
					Conout("Executando a Rotina FATMI001(INICIO) em "+Dtoc(Date())+"-"+Time() + " na empresa/filial " + aEmpMI2[nLoopMI2][1] + "/" +aEmpMI2[nLoopMI2][2] + " da Marca: " + aEmpMI2[nLoopMI2][4])
					U_FATMI001( aEmpMI2[nLoopMI2][1],aEmpMI2[nLoopMI2][2],aEmpMI2[nLoopMI2][4] )	//IMPORTACAO DE ORCAMENTOS
					RESET ENVIRONMENT
					
					Conout("Executando a Rotina FATMI007 em "+Dtoc(Date())+"-"+Time() + " na empresa/filial " + aEmpMI2[nLoopMI2][1] + "/" +aEmpMI2[nLoopMI2][2] + " da Marca: " + aEmpMI2[nLoopMI2][4])
					U_FATMI007( aEmpMI2[nLoopMI2][1],aEmpMI2[nLoopMI2][2],aEmpMI2[nLoopMI2][4],aEmpMI2[nLoopMI2][5] )	//EFETIVACAO DE ORCAMENTOS
					RESET ENVIRONMENT
				Else
					Conout("Executando a Rotina FATMI007 em "+Dtoc(Date())+"-"+Time() + " na empresa/filial " + aEmpMI2[nLoopMI2][1] + "/" +aEmpMI2[nLoopMI2][2] + " da Marca: " + aEmpMI2[nLoopMI2][4] + " - ASTEC")
					U_FATMI007( aEmpMI2[nLoopMI2][1],aEmpMI2[nLoopMI2][2],aEmpMI2[nLoopMI2][4],aEmpMI2[nLoopMI2][5] )	//EFETIVACAO DE ORCAMENTOS
					RESET ENVIRONMENT
				EndIf
				
			EndIf
			
		Next
		Conout("FIM DAS ROTINAS HORA EM HORA "+Dtoc(Date())+"-"+Time())
		
	EndIf


Return
/* chamada da função generica por marca PROART */
User Function CFGMI02P

	LOCAL nLoopMI2 := 0

	/* {Empresa,Filial,1,Marca,ClassePedido} */
	/* Prioridade para a Marca e a Filial sempre começando por Extrema e produtos TAIFF */
	Public aEmpMI2	:= {{"03","02",1,"TAIFF",""},{"03","01",1,"TAIFF",""},{"03","02",1,"PROART",""},{"03","01",1,"PROART",""},{"03","01",1,"TAIFF","A"}}
	Public cMarcMI2	:= ""
	PUBLIC _cBase := "P"
	
	If _cBase == "T"
		cMarcMI2 := "TAIFF"
	ElseIf _cBase == "P"
		cMarcMI2 := "PROART"
	EndIf

	/*
	CONOUT(_cBase)
	conout(cMarcMI2)
	CONOUT(SubStr(Time(),4,5))
	*/
	
	//ROTINA DE HORA EM HORA
	If (((SubStr(Time(),4,5) >= "40:00" .And. SubStr(Time(),4,5) < "50:00") .OR. ((SubStr(Time(),4,5) >= "10:00" .And. SubStr(Time(),4,5) < "15:00"))) .And. Time() >= "08:30:00" .And. Time() < "23:59:00")

		Conout("INICIO DAS ROTINAS HORA EM HORA "+Dtoc(Date())+"-"+Time())
		For nLoopMI2 := 1 to Len(aEmpMI2)

			If cMarcMI2 = aEmpMI2[nLoopMI2][4] .OR. Empty(cMarcMI2) 
				
				If aEmpMI2[nLoopMI2][5] != "A" // Não faz importação de orçamentos da ASTEC 
					Conout("Executando a Rotina FATMI001(INICIO) em "+Dtoc(Date())+"-"+Time() + " na empresa/filial " + aEmpMI2[nLoopMI2][1] + "/" +aEmpMI2[nLoopMI2][2] + " da Marca: " + aEmpMI2[nLoopMI2][4])
					U_FATMI001( aEmpMI2[nLoopMI2][1],aEmpMI2[nLoopMI2][2],aEmpMI2[nLoopMI2][4] )	//IMPORTACAO DE ORCAMENTOS
					RESET ENVIRONMENT
					
					Conout("Executando a Rotina FATMI007 em "+Dtoc(Date())+"-"+Time() + " na empresa/filial " + aEmpMI2[nLoopMI2][1] + "/" +aEmpMI2[nLoopMI2][2] + " da Marca: " + aEmpMI2[nLoopMI2][4])
					U_FATMI007( aEmpMI2[nLoopMI2][1],aEmpMI2[nLoopMI2][2],aEmpMI2[nLoopMI2][4],aEmpMI2[nLoopMI2][5] )	//EFETIVACAO DE ORCAMENTOS
					RESET ENVIRONMENT
				EndIf
				
			EndIf
			
		Next
		Conout("FIM DAS ROTINAS HORA EM HORA "+Dtoc(Date())+"-"+Time())
		
	EndIf

RETURN

/* chamada da função generica por marca TAIFF */
User Function CFGMI02T

	Local nLoopMI2	:=0

	/* {Empresa,Filial,1,Marca,ClassePedido} */
	/* Prioridade para a Marca e a Filial sempre começando por Extrema e produtos TAIFF */
	Public aEmpMI2	:= {{"03","02",1,"TAIFF",""},{"03","01",1,"TAIFF",""},{"03","02",1,"PROART",""},{"03","01",1,"PROART",""},{"03","01",1,"TAIFF","A"}}
	Public cMarcMI2	:= ""
	PUBLIC _cBase := "T"
	
	If _cBase == "T"
		cMarcMI2 := "TAIFF"
	ElseIf _cBase == "P"
		cMarcMI2 := "PROART"
	EndIf
	
	//ROTINA DE HORA EM HORA
	If (((SubStr(Time(),4,5) >= "30:00" .And. SubStr(Time(),4,5) < "45:00") .OR. ((SubStr(Time(),4,5) >= "00:00" .And. SubStr(Time(),4,5) < "05:00"))) ) //.And. Time() >= "08:30:00" .And. Time() < "23:59:00")

		Conout("INICIO DAS ROTINAS HORA EM HORA "+Dtoc(Date())+"-"+Time())
		For nLoopMI2 := 1 to Len(aEmpMI2)

			If cMarcMI2 = aEmpMI2[nLoopMI2][4] .OR. Empty(cMarcMI2) 
				
				If aEmpMI2[nLoopMI2][5] != "A" .AND. (Time() >= "08:30:00" .And. Time() < "23:59:00")
				  
					// IMPORTAÇÃO DE PRODUTOS TAIFF EXCETO ASSISTENCIA TECNICA
					
					Conout("Executando a Rotina FATMI001(INICIO) em "+Dtoc(Date())+"-"+Time() + " na empresa/filial " + aEmpMI2[nLoopMI2][1] + "/" +aEmpMI2[nLoopMI2][2] + " da Marca: " + aEmpMI2[nLoopMI2][4])
					//U_FATMI001( aEmpMI2[nLoopMI2][1],aEmpMI2[nLoopMI2][2],aEmpMI2[nLoopMI2][4] )	//IMPORTACAO DE ORCAMENTOS
					U_IMPSALES( aEmpMI2[nLoopMI2][1],aEmpMI2[nLoopMI2][2],aEmpMI2[nLoopMI2][4] )	//IMPORTACAO DE ORCAMENTOS

					RESET ENVIRONMENT
					
					Conout("Executando a Rotina FATMI007 em "+Dtoc(Date())+"-"+Time() + " na empresa/filial " + aEmpMI2[nLoopMI2][1] + "/" +aEmpMI2[nLoopMI2][2] + " da Marca: " + aEmpMI2[nLoopMI2][4])
					U_FATMI007( aEmpMI2[nLoopMI2][1],aEmpMI2[nLoopMI2][2],aEmpMI2[nLoopMI2][4],aEmpMI2[nLoopMI2][5] )	//EFETIVACAO DE ORCAMENTOS
					RESET ENVIRONMENT
					
					
				ElseIf aEmpMI2[nLoopMI2][5] = "A" .AND. ((Time() >= "05:30:00" .And. Time() < "06:59:00") .OR. (Time() >= "09:30:00" .And. Time() < "23:59:00"))
				 
					// IMPORTAÇÃO DE PRODUTOS TAIFF APENAS ASSISTENCIA TECNICA
					
					Conout("Executando a Rotina FATMI001(INICIO) em " + Dtoc(Date()) + "-" + Time() + " na empresa/filial 03/01 da Marca: TAIFF - ASTEC")
					U_IMPASSTEC( "03","01","TAIFF" )	
					RESET ENVIRONMENT
					
					Conout("Executando a Rotina FATMI007 em " + Dtoc(Date()) + "-" + Time() + " na empresa/filial 03/01 da Marca: TAIFF - ASTEC") 
					U_FATMI007( "03","01","TAIFF","A" )	
					RESET ENVIRONMENT
				EndIf
				
			EndIf
			
		Next
		Conout("FIM DAS ROTINAS HORA EM HORA "+Dtoc(Date())+"-"+Time())
		
	EndIf

RETURN

/* chamada da função generica por marca TAIFF */

/* PARA EXECUÇÃO INDIVIDUAL */
User Function CFGMI02I
	
	Local nLoopMI2	:=0
	
	/* {Empresa,Filial,1,Marca,ClassePedido} */
	/* Prioridade para a Marca e a Filial sempre começando por Extrema e produtos TAIFF */
	Public aEmpMI2	:= {{"03","02",1,"TAIFF",""},{"03","01",1,"TAIFF",""}} //{{"03","02",1,"TAIFF",""},{"03","01",1,"TAIFF",""},{"03","02",1,"PROART",""},{"03","01",1,"PROART",""},{"03","01",1,"TAIFF","A"}}
	Public cMarcMI2	:= ""
	PUBLIC _cBase := "T"
	
	If _cBase == "T"
		cMarcMI2 := "TAIFF"
	ElseIf _cBase == "P"
		cMarcMI2 := "PROART"
	EndIf
	
	//ROTINA DE HORA EM HORA
	If 1=1 //(((SubStr(Time(),4,5) >= "30:00" .And. SubStr(Time(),4,5) < "45:00") .OR. ((SubStr(Time(),4,5) >= "00:00" .And. SubStr(Time(),4,5) < "05:00"))) ) //.And. Time() >= "08:30:00" .And. Time() < "23:59:00")

		Conout("INICIO DAS ROTINAS HORA EM HORA "+Dtoc(Date())+"-"+Time())
		For nLoopMI2 := 1 to Len(aEmpMI2)

			If cMarcMI2 = aEmpMI2[nLoopMI2][4] .OR. Empty(cMarcMI2) 
				
				If 1=1 //aEmpMI2[nLoopMI2][5] != "A" .AND. (Time() >= "08:30:00" .And. Time() < "23:59:00")
				  
					// IMPORTAÇÃO DE PRODUTOS TAIFF EXCETO ASSISTENCIA TECNICA
					
					Conout("Executando a Rotina FATMI001(INICIO) em "+Dtoc(Date())+"-"+Time() + " na empresa/filial " + aEmpMI2[nLoopMI2][1] + "/" +aEmpMI2[nLoopMI2][2] + " da Marca: " + aEmpMI2[nLoopMI2][4])
					//U_FATMI001( aEmpMI2[nLoopMI2][1],aEmpMI2[nLoopMI2][2],aEmpMI2[nLoopMI2][4] )	//IMPORTACAO DE ORCAMENTOS
					U_IMPSALES( aEmpMI2[nLoopMI2][1],aEmpMI2[nLoopMI2][2],aEmpMI2[nLoopMI2][4] )	//IMPORTACAO DE ORCAMENTOS

					RESET ENVIRONMENT
					
					Conout("Executando a Rotina FATMI007 em "+Dtoc(Date())+"-"+Time() + " na empresa/filial " + aEmpMI2[nLoopMI2][1] + "/" +aEmpMI2[nLoopMI2][2] + " da Marca: " + aEmpMI2[nLoopMI2][4])
					U_FATMI007( aEmpMI2[nLoopMI2][1],aEmpMI2[nLoopMI2][2],aEmpMI2[nLoopMI2][4],aEmpMI2[nLoopMI2][5] )	//EFETIVACAO DE ORCAMENTOS
					RESET ENVIRONMENT
				ENDIF
					
			EndIf
			
		Next
		Conout("FIM DAS ROTINAS HORA EM HORA "+Dtoc(Date())+"-"+Time())
		
	EndIf

RETURN


