#include "PROTHEUS.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � A010TOK  �Autor  � Fernando Salvatori � Data �  11/16/09   ���
�������������������������������������������������������������������������͹��
���Desc.     � Ponto de entrada executado durante a validacao da inclusao ���
���          � do produto                                                 ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function A010TOK()
Local lRet := .T.

//---------------------------------------------------------------------------------------------------------------------------- 
// Variaveis: TOTVS 
//---------------------------------------------------------------------------------------------------------------------------- 
Local lUniNeg	:= cEmpAnt+cFilant $ GETNEWPAR('MV_UNINEG'/*cParametro*/, cEmpAnt+cFilant /*cPadrao*/, /*cFilial*/)
//-- Separar no parametro as empresas filiais concatenadas. Ex. 0302/0303
//--------------------------------------------[ Fim Customiza��o TOTVS ]------------------------------------------------------


If Inclui .And. ! l010Auto
	M->B1_COD := U_AE002Cod(.T.)
EndIf


//---------------------------------------------------------------------------------------------------------------------------- 
// Ponto de Valida��o
// Descri��o: Validar campos da tabela SB1 para impedir que o campo B1_IMPZFRC # "S" quando B1_ORIGEM # 0
// Autor: C. Torres                                                                                           Data: 02/02/2012
// Observa��o: Variavel l010Auto criada pela rotina padr�o do PROTHEUS
//----------------------------------------------------------------------------------------------------------------------------
// Por conta da Resolu��o 13 do Senado, o CONFAZ celebrou o Conv�nio ICMS 123 - este controle devera ser retirado pois agora
//    existem novos codigos de origens do produto onde teremos que gerar novas combinacoes.
//    ALTERADO POR EDSON HORNBERGER - 02/05/2013
/*  
If (INCLUI .or. ALTERA) .And. ! l010Auto 
	If M->B1_IMPZFRC != "S" .AND. M->B1_ORIGEM != "0"
		Aviso("Aten��o" , "H� diverg�ncia de informa��es entre os campos Origem e Imp.Z.Franca!", {"Ok"}, 	3)
		lRet := .F.
	EndIf
EndIf
*/
// Conforme solicitacao da usuaria Patricia Lima foi passado nova regra que segue abaixo descrita:
// ## Boa Tarde
// ## 
// ## Edson
// ## 
// ## Como agora existem 2 origens que identificam os produtos nacionais, 0 e 5 esses par�metros devem ser 
// ##     ajustados para que materiais com essas origens fiquem com a informa��o = N�o no campo Imposto ZF.
// ## 
// ## Att
// ## Patricia Lima 
// ## Cont�bil/Fiscal Corporativo
// ## patricia.lima@taiffproart.com.br- www.taiff.com.br
// ## Tel.: +55 (11) 5545-4611 Ramal: 4782
// ## Av. das Na��es Unidas, 21.314 - Cep: 04795-000
//
//	ALTERADO POR EDSON HORNBERGER - 03/05/2013
//
// ESTE CONTROLE FOI MOVIMENTADO PARA A ROTINA mata010_pe.prw
/*
If (INCLUI .or. ALTERA) .And. ! l010Auto 
	If M->B1_IMPZFRC != "S" .AND. !M->B1_ORIGEM $ ("0|5|7")
		Aviso("Aten��o" , "H� diverg�ncia de informa��es entre os campos Origem e Imp.Z.Franca!", {"Ok"}, 	3)
		lRet := .F.
	EndIf
EndIf
*/
//--------------------------------------------[ Fim da validacao ]------------------------------------------------------------ 


//---------------------------------------------------------------------------------------------------------------------------- 
// Ponto de Valida��o: TOTVS 
// Descri��o: Validar unidade de negocio no produto
// Merge.......: TAIFF - C. Torres                                           Data: 10/04/2013
//---------------------------------------------------------------------------------------------------------------------------- 
If lUniNeg

	if Empty(M->B1_ITEMCC) 
		lRet := .F.  // _lRet := .F. 
		Help(nil,1,'Unidade de Negocios',nil,'Obrigat�rio preencher unidade de negocios!',3,0)
	endif
			
EndIf
//--------------------------------------------[ Fim Customiza��o TOTVS ]------------------------------------------------------

Return lRet
