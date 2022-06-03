/*
=================================================================================
=================================================================================
||   Arquivo:	A200BOK.prw
=================================================================================
||   Funcao:	A200BOK 
=================================================================================
||   Descricao
||-------------------------------------------------------------------------------
||		Ponto de entrada antes de efetivar as altera��es na estrutura do Produto 
|| 
|| 		Altera��o/Inclus�o/Exclus�o de algum item da Estrutura
|| 
|| 
=================================================================================
=================================================================================
||   Autor:	Gilberto Ribeiro Junior
||   Data:	08/10/2012
=================================================================================
=================================================================================
*/

#define CHR_ENTER			'<br>'  
#define CHR_FONT_DET_OPEN	'<font face="Courier New" size="2">'
#define CHR_FONT_DET_CLOSE	'</font>'

User Function A200BOK

	Local cMensagem 	:= ""
	Local aRegs 		:= PARAMIXB[1]
	Local cCod 			:= PARAMIXB[2]
	Local cMailDest 	:= AllTrim(GETNEWPAR("MV_MAILEST", "", xFilial("SX6"))) // E-mail configurado para receber e-mail para altera��es nas esturuturas dos produtos
	Local cUserName 	:= UsrFullName(RetCodUsr()) // Login do usu�rio logado
	Local i				:= 0

	// Caso n�o tenha nenhum e-mail parametrizado, saio do PE retornando True
	If (cMailDest = "")
		Return(.T.)
	EndIf

	// Verifica se existe conte�do no Array, caso exista � porque algo foi exclu�do, inclu�do ou alterado na estrutura.      
	If Len(aRegs) > 0

		dbSelectArea("SB1")
		dbSetOrder(1)
		dbSeek(xFilial("SB1") + AllTrim(cCod))

		cMensagem += CHR_FONT_DET_OPEN
		cMensagem += "A estrutura do Produto: " + AllTrim(cCod) + " - " + AllTrim(SB1->B1_DESC) + " foi alterada." + CHR_ENTER  
		cMensagem += "O usu�rio: (" + cUserName + ") foi o respons�vel pela altera��o/inclus�o."
		
		/*
		|---------------------------------------------------------------------------------
		|	Inserido informa��o de quais componentes sofreram altera��o.
		|	Edson Hornberger - 26/04/2016
		|   Colocado em Produ��o: 08/09/2016
		|---------------------------------------------------------------------------------
		*/
		If ALTERA 
			
			cMensagem += CHR_ENTER + CHR_ENTER + "Componentes alterados:"
			
			For i := 1 to Len(aRegs)
				If Type("aRegs[i][3]") == "A"
					cMensagem += CHR_ENTER + " - " + AllTrim(aRegs[i][3][3]) + " - " + AllTrim(Posicione("SB1",1,xFilial("SB1") + aRegs[i][3][3],"B1_DESC")) + " - Qtd. Orig.: " + cValToChar(aRegs[i][3][5]) + " - Dta. In�cio: " + DTOC(aRegs[i][3][7]) + " - Dta. Fim: " + DTOC(aRegs[i][3][8]) 
				EndIf
			Next i
			
		EndIf
		/***********************************************************************************/
		 
		cMensagem += CHR_FONT_DET_CLOSE   

		dbCloseArea()

		// Enviar o e-mail     
		U_EnvMail("estrutura@taiff.com.br", cMailDest, "Altera��o/Inclus�o de estrutura", OemToAnsi(cMensagem))		
	Else
		Return(.T.)	
	EndIf

Return(.T.) // Aceito as alteracoes. Para nao aceitar, retornar .F.
