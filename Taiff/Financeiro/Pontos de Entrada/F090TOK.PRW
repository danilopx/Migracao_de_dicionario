#include "Protheus.ch"
#include "TbiConn.ch" 

/*                     
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �F090TOK  �Autor  �WAGNER MONTENEGRO   � Data �  03/07/2013  ���
�������������������������������������������������������������������������͹��
���Desc.     �Ponto de Entrada na confirma��o de baixa automatica a pagar.���
���          �BackLog Financeiro - Bloquear baixa Normal na Baixa Autom.  ���
�������������������������������������������������������������������������͹��
���Uso       � TODAS EMPRESAS 							                       ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
USER FUNCTION F090TOK
Local lRet:=.T.
If cMotBx=='NORMAL'
	lRet:=.F.
	Help(,,'F090TOK',,"O tipo de Baixa 'NORMAL' est� bloqueada para uso em Baixas Automaticas. Por favor, utilize outro tipo de baixa.",1,0)
Endif	
Return(lRet)