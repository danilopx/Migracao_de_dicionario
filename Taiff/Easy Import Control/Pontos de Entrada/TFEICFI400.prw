#Include 'Protheus.ch'

#DEFINE ENTER CHR(13) + CHR(10)

User Function EICFI400()
	Local cMensEmail := ""
	Local cParam := If(Type("PARAMIXB") = "A",PARAMIXB[1],If(Type("PARAMIXB") = "C",PARAMIXB,"")) 
	
	If cParam="FI400TITFIN_EXCLUSAO"
		//cEmail := "carlos.torres@taiffproart.com.br;jaqueline.silva@taiffproart.com.br" //;grp_comex@taiffproart.com.br'
		cEmail := "grp_comex@taiff.com.br;valdineia.farias@taiff.com.br;thiago.miele@taiff.com.br;ana.paula@taiff.com.br;jaqueline.silva@taiff.com.br"
		
		cMensEmail := "O TITULO NO FINANCEIRO SOFREU EXCLUSÃO ATRAVES DO MODULO SIGAEIC" + ENTER 
		cMensEmail += "TITULO: " + SWB->WB_NUMDUP + ENTER
		cMensEmail += "PREFIXO: " + SWB->WB_PREFIXO + ENTER
		cMensEmail += "FORNECEDOR: " + SWB->WB_FORN + ENTER
		cMensEmail += "LOJA: " + SWB->WB_LOJA + ENTER
		cMensEmail += "PROCESSO: " + SWB->WB_HAWB + ENTER
		
		If !Empty(cMensEmail)
			U_2EnvMail('pedidos@actionmotors.com.br',RTrim(cEmail)	,'',cMensEmail	,'Exclusão de título EIC' ,'')
		EndIf
		
	EndIf
Return .T.

