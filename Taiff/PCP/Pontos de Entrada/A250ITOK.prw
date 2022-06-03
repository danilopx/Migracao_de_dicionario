#INCLUDE "Protheus.ch"
#INCLUDE "Topconn.ch"

//+--------------------------------------------------------------------------------------------------------------
//| PONTO DE ENTRADA: A250ITOK                          AUTOR: CARLOS ALDAY TORRES           DATA: 17/01/2011   |
//+--------------------------------------------------------------------------------------------------------------
//| DESCRICAO: Rotina de apoio ao endereçamento automatico, é executado após pressionar o botão OK
//| SOLICITANTE: Jose Antonio / Humberto / Alan
//| OBSERVACAO: PE executado pela rotina MATA250, na rotina PCPPAGOP tambem é chamada a rotina MATA250 por conse-
//| 				quencia executa o PE.
//+--------------------------------------------------------------------------------------------------------------

User Function A250ITOK()
Public _mD3TM		
Public _mD3COD		
Public _mD3LOCAL	
Public _mD3NUMSEQ	
Public _mD3DOC		
Public _mD3OP

If Type( M->D3_TM ) != "U"
	_mD3TM		:= M->D3_TM
	_mD3COD		:= M->D3_COD 
	_mD3LOCAL	:= M->D3_LOCAL 
	_mD3NUMSEQ	:= M->D3_NUMSEQ 
	_mD3DOC		:=	M->D3_DOC
	_mD3OP		:=	M->D3_OP
EndIf

Return NIL