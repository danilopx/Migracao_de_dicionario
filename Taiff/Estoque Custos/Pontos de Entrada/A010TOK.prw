#include "PROTHEUS.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ A010TOK  ºAutor  ³ Fernando Salvatori º Data ³  11/16/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ponto de entrada executado durante a validacao da inclusao º±±
±±º          ³ do produto                                                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function A010TOK()
Local lRet := .T.

//---------------------------------------------------------------------------------------------------------------------------- 
// Variaveis: TOTVS 
//---------------------------------------------------------------------------------------------------------------------------- 
Local lUniNeg	:= cEmpAnt+cFilant $ GETNEWPAR('MV_UNINEG'/*cParametro*/, cEmpAnt+cFilant /*cPadrao*/, /*cFilial*/)
//-- Separar no parametro as empresas filiais concatenadas. Ex. 0302/0303
//--------------------------------------------[ Fim Customização TOTVS ]------------------------------------------------------


If Inclui .And. ! l010Auto
	M->B1_COD := U_AE002Cod(.T.)
EndIf


//---------------------------------------------------------------------------------------------------------------------------- 
// Ponto de Validação
// Descrição: Validar campos da tabela SB1 para impedir que o campo B1_IMPZFRC # "S" quando B1_ORIGEM # 0
// Autor: C. Torres                                                                                           Data: 02/02/2012
// Observação: Variavel l010Auto criada pela rotina padrão do PROTHEUS
//----------------------------------------------------------------------------------------------------------------------------
// Por conta da Resolução 13 do Senado, o CONFAZ celebrou o Convênio ICMS 123 - este controle devera ser retirado pois agora
//    existem novos codigos de origens do produto onde teremos que gerar novas combinacoes.
//    ALTERADO POR EDSON HORNBERGER - 02/05/2013
/*  
If (INCLUI .or. ALTERA) .And. ! l010Auto 
	If M->B1_IMPZFRC != "S" .AND. M->B1_ORIGEM != "0"
		Aviso("Atenção" , "Há divergência de informações entre os campos Origem e Imp.Z.Franca!", {"Ok"}, 	3)
		lRet := .F.
	EndIf
EndIf
*/
// Conforme solicitacao da usuaria Patricia Lima foi passado nova regra que segue abaixo descrita:
// ## Boa Tarde
// ## 
// ## Edson
// ## 
// ## Como agora existem 2 origens que identificam os produtos nacionais, 0 e 5 esses parâmetros devem ser 
// ##     ajustados para que materiais com essas origens fiquem com a informação = Não no campo Imposto ZF.
// ## 
// ## Att
// ## Patricia Lima 
// ## Contábil/Fiscal Corporativo
// ## patricia.lima@taiffproart.com.br- www.taiff.com.br
// ## Tel.: +55 (11) 5545-4611 Ramal: 4782
// ## Av. das Nações Unidas, 21.314 - Cep: 04795-000
//
//	ALTERADO POR EDSON HORNBERGER - 03/05/2013
//
// ESTE CONTROLE FOI MOVIMENTADO PARA A ROTINA mata010_pe.prw
/*
If (INCLUI .or. ALTERA) .And. ! l010Auto 
	If M->B1_IMPZFRC != "S" .AND. !M->B1_ORIGEM $ ("0|5|7")
		Aviso("Atenção" , "Há divergência de informações entre os campos Origem e Imp.Z.Franca!", {"Ok"}, 	3)
		lRet := .F.
	EndIf
EndIf
*/
//--------------------------------------------[ Fim da validacao ]------------------------------------------------------------ 


//---------------------------------------------------------------------------------------------------------------------------- 
// Ponto de Validação: TOTVS 
// Descrição: Validar unidade de negocio no produto
// Merge.......: TAIFF - C. Torres                                           Data: 10/04/2013
//---------------------------------------------------------------------------------------------------------------------------- 
If lUniNeg

	if Empty(M->B1_ITEMCC) 
		lRet := .F.  // _lRet := .F. 
		Help(nil,1,'Unidade de Negocios',nil,'Obrigatório preencher unidade de negocios!',3,0)
	endif
			
EndIf
//--------------------------------------------[ Fim Customização TOTVS ]------------------------------------------------------

Return lRet
