/*
=================================================================================
=================================================================================
||   Arquivo:	A200BOK.prw
=================================================================================
||   Funcao:	A200BOK 
=================================================================================
||   Descricao
||-------------------------------------------------------------------------------
||		Ponto de entrada antes de efetivar as alterações na estrutura do Produto 
|| 
|| 		Alteração/Inclusão/Exclusão de algum item da Estrutura
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
	Local cMailDest 	:= AllTrim(GETNEWPAR("MV_MAILEST", "", xFilial("SX6"))) // E-mail configurado para receber e-mail para alterações nas esturuturas dos produtos
	Local cUserName 	:= UsrFullName(RetCodUsr()) // Login do usuário logado
	Local i				:= 0

	// Caso não tenha nenhum e-mail parametrizado, saio do PE retornando True
	If (cMailDest = "")
		Return(.T.)
	EndIf

	// Verifica se existe conteúdo no Array, caso exista é porque algo foi excluído, incluído ou alterado na estrutura.      
	If Len(aRegs) > 0

		dbSelectArea("SB1")
		dbSetOrder(1)
		dbSeek(xFilial("SB1") + AllTrim(cCod))

		cMensagem += CHR_FONT_DET_OPEN
		cMensagem += "A estrutura do Produto: " + AllTrim(cCod) + " - " + AllTrim(SB1->B1_DESC) + " foi alterada." + CHR_ENTER  
		cMensagem += "O usuário: (" + cUserName + ") foi o responsável pela alteração/inclusão."
		
		/*
		|---------------------------------------------------------------------------------
		|	Inserido informação de quais componentes sofreram alteração.
		|	Edson Hornberger - 26/04/2016
		|   Colocado em Produção: 08/09/2016
		|---------------------------------------------------------------------------------
		*/
		If ALTERA 
			
			cMensagem += CHR_ENTER + CHR_ENTER + "Componentes alterados:"
			
			For i := 1 to Len(aRegs)
				If Type("aRegs[i][3]") == "A"
					cMensagem += CHR_ENTER + " - " + AllTrim(aRegs[i][3][3]) + " - " + AllTrim(Posicione("SB1",1,xFilial("SB1") + aRegs[i][3][3],"B1_DESC")) + " - Qtd. Orig.: " + cValToChar(aRegs[i][3][5]) + " - Dta. Início: " + DTOC(aRegs[i][3][7]) + " - Dta. Fim: " + DTOC(aRegs[i][3][8]) 
				EndIf
			Next i
			
		EndIf
		/***********************************************************************************/
		 
		cMensagem += CHR_FONT_DET_CLOSE   

		dbCloseArea()

		// Enviar o e-mail     
		U_EnvMail("estrutura@taiff.com.br", cMailDest, "Alteração/Inclusão de estrutura", OemToAnsi(cMensagem))		
	Else
		Return(.T.)	
	EndIf

Return(.T.) // Aceito as alteracoes. Para nao aceitar, retornar .F.
