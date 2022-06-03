#INCLUDE "PROTHEUS.CH"
#include "rwmake.ch"
#include "topconn.ch"
#INCLUDE "AP5MAIL.CH"

#DEFINE ENTER CHR(13) + CHR(10)

/*
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ								пїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅН»																								пїЅпїЅпїЅ
пїЅпїЅпїЅPrograma  пїЅCNT260GRV пїЅAutor  пїЅ MMS           пїЅ Data пїЅ  05/02/16   																пїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅН№																										пїЅпїЅпїЅ
пїЅпїЅпїЅDesc.     пїЅ   Ponto de entrada no fim da mediпїЅпїЅo automпїЅtica, para enviar e-mail para o dono do contrato          пїЅпїЅпїЅ
пїЅпїЅпїЅ          пїЅ                                                            																							пїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ																											пїЅпїЅпїЅ
пїЅпїЅпїЅUso       пїЅ GestпїЅo de contratos                                                       															пїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ																											пїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ								пїЅпїЅпїЅ
пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
*/
user function CNT260GRV()                      
   
	Local _cDe        	:= 'workflow@taiff.com.br'            
	Local _cDono 		:= SUBSTR( EMBARALHA(CN9->CN9_USERGI,1),3,6 ) 
	Local _cAssunto    := 'Mediзгo de contrato SIGAGCT"
	Local _cMensagem := "<html>"
	Local cQuery	:= ""
 	PsWorder(1)
	PswSeek(_cDono, .T.)	 
	Priva  aInfUser 		:= pswret(NIl)
	Priva _cPara			:= alltrim(aInfUser[1,14])                     
	Priva _cPed :=		Posicione("SC7",1, xFilial("SC7")+CND->CND_PEDIDO, "C7_NUM")                                                                                         
	
	cQuery := "SELECT CN9_EMAIL, CND_PEDIDO, CND_DTFIM, CND_AUTFRN, CND_SERVIC, CND_FORNEC, CND_LJFORN, CND_VLTOT " + ENTER
	cQuery += " FROM " + RetSQLName("CN9")+" CN9 WITH(NOLOCK)" + ENTER
	cQuery += " INNER JOIN " + RetSQLName("CND")+" CND WITH(NOLOCK)" + ENTER
	cQuery += " ON CND.CND_FILIAL=CN9_FILIAL" + ENTER
	cQuery += " AND CND_CONTRA=CN9_NUMERO" + ENTER
	cQuery += " AND CND_REVISA=CN9_REVISA" + ENTER
	cQuery += " AND CND.D_E_L_E_T_=''" + ENTER
	cQuery += " AND CND.CND_DTFIM=''" + ENTER
	cQuery += " WHERE CN9.D_E_L_E_T_='' "
	
	MemoWrite("CNT260GRV_PEDIDOS_FIM_ATUAL.SQL",cQuery)
				
	IF SELECT("AUX") > 0 
		DBSELECTAREA("AUX")
		DBCLOSEAREA()
	ENDIF 
	
	TCQUERY CQUERY NEW ALIAS "AUX"
	DBSELECTAREA("AUX")

	AUX->(DbGotop())
	While !AUX->(Eof())
		If .NOT. EMPTY(AUX->CND_PEDIDO)
			_cPed := Posicione("SC7",1, xFilial("SC7") + AUX->CND_PEDIDO, "C7_NUM")                                                                                         
			If .NOT. (!Empty(AUX->CND_DTFIM) .And. AUX->CND_AUTFRN == "1" .And. AUX->CND_SERVIC == "1") //"Medicao Encerrada"
				If CN9->(FIELDPOS("CN9_EMAIL")) > 0
					_cPara += ";" + ALLTRIM(AUX->CN9_EMAIL)
				EndIf
				
				_cMensagem += "<head>"
				_cMensagem += " <title></title>"
				_cMensagem += "</head>"
				_cMensagem += "<body>"
				_cMensagem += " <br>"
				_cMensagem += " O Pedido de compra "+_cPed
				_cMensagem += " <br>"
				_cMensagem += " Do fornecedor - "+AUX->CND_FORNEC+"-"+AUX->CND_LJFORN+" - "+posicione("SA2",1, xFilial("SA2")+AUX->CND_FORNEC+AUX->CND_LJFORN,"A2_NOME")    
				_cMensagem += " <br>"
				_cMensagem += " Do produto - "+sc7->c7_produto + " - "+ sc7->c7_descri
				_cMensagem += " <br>"
				_cMensagem += " No valor de - "+Transform(AUX->CND_VLTOT,'@E 999,999.99')
				_cMensagem += " <br>"               
				_cMensagem += " <br>"                                                                   
				_cMensagem += " Foi gerado e aguarda seus ajustes para aprovaзгo"
				_cMensagem += " <br>"
				_cMensagem += " <br>"
				_cMensagem += " Obrigado."
				_cMensagem += " <br>"
				_cMensagem += " <br>"
				_cMensagem += "=============================================================================="
				_cMensagem += " <br>"
				_cMensagem += " Workflow encaminhado por..: "+_cDe
				_cMensagem += " <br>"
				_cMensagem += " Ambiente no Protheus.........: "+GetEnvServer()
				_cMensagem += " <br>"
				_cMensagem += " Empresa/Filial.....................: "+SM0->M0_CODIGO+"/"+SM0->M0_CODFIL+" - "+Alltrim(SM0->M0_NOME)+"/"+Alltrim(SM0->M0_FILIAL)
				_cMensagem += " <br>"
				_cMensagem += " Rotina.................................: Mediзгo de contratos - SIGAGCT "
				_cMensagem += " <br>"
				_cMensagem += "=============================================================================="
				_cMensagem += "</body>"
			    
				U_2EnvMail(_cDe,_cPara,"",_cMensagem,_cAssunto,"") 
			EndIf
		EndIf
	End While	
	
Return
