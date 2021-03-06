#Include "Protheus.ch"
#INCLUDE "Topconn.ch"

#DEFINE PULA CHR(13) + CHR(10)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �M410ICM   �Autor  �Microsiga           � Data �  30/07/13   ���
�������������������������������������������������������������������������͹��
���Desc.     � Ponto de Entrada para Redefinir Valores de ICMS.           ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � MATA410                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function M410ICM

Local cMV_ESTADO	:= GetMv('MV_ESTADO')
Local lBonifIVA	:= TFbonifsx6() 
Local cClasPed		:= ""
Local cTipoPed		:= ""

cClasPed		:= M->C5_CLASPED
cTipoPed		:= M->C5_TIPO

/*
Descri��o.: Para pedido bonificado em EXTREMA cujo cliente for de MG ser� sobreposta a aliquota de ICM por 18%
Observa��o: Regra implementada para atender regime especial da TAIFF
Autor.....: CT 		Data: 12/01/2016
*/
If CEMPANT = '03' .AND. CFILANT = '02' .AND. cClasPed $ 'X| ' .AND. SA1->A1_EST=cMV_ESTADO  
	If At( Alltrim(SB1->B1_ORIGEM) , '1|2|3') != 0 .AND.  cTipoPed = "N" .AND. SF4->F4_ISS!="S" .AND. SA1->A1_GRPTRIB='C01' .AND. lBonifIVA
		_ALIQICM	:= 18
		_VALICM		:= _BASEICM * (_ALIQICM/100)
	EndIf
EndIf

Return NIL

/*
------------------------------------------------------------------------------
Cria parametro de regime especial de EXTREMA 
------------------------------------------------------------------------------
*/
Static Function TFbonifsx6()
Local lRetorno := GetNewPar("TF_IVABONI",.F.)
Return (lRetorno)
