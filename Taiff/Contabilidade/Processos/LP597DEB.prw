#INCLUDE "rwmake.ch"
/*
臼様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様融臼
臼�ExecBlock � LP597     �Autor  �WALDIR ARRUDA       12/01/12        				           艮�
臼麺様様様様様様様様様様様様様詫様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様恒�
臼�Desc.     �  CONTABILIZA巴O DE COMPENSA巴O DE T�TULO A PAGAR DEBIT       艮�
臼麺様様様様謡様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様恒�
臼�Uso       �  TAIFF                                                                                                      艮�
臼様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様夕臼
*/
User Function LP597DEB()
********************
Local aAREA_ATU	:= GetArea()
Local aAREA_SE5	:= SE5->( GetArea() )
Local aAREA_SA2	:= SA2->( GetArea() )
Local aAREA_SED	:= SED->( GetArea() )
Local cConta	:= ""
Local cChave      := ""

If Alltrim(SE5->E5_TIPO)=="PA"
	
	// Procurando o parceiro
	
	cCHAVE:= Substr(SE5->E5_DOCUMEN,1,3)+;
	Substr(SE5->E5_DOCUMEN,4,9)+;
	Substr(SE5->E5_DOCUMEN,13,2)+;
	Substr(SE5->E5_DOCUMEN,15,3)+;
	Substr(SE5->E5_DOCUMEN,18,6)+;
	Substr(SE5->E5_DOCUMEN,24,2)
	DbSelectArea("SE5")
	
	DbSetOrder(7)
	DbSeek( xFilial("SE5") + cCHAVE )

	SA2->(dbSetOrder(1))
	SA2->(dbSeek(xFilial("SA2") + SE5->E5_CLIFOR + SE5->E5_LOJA ))
	
	IF ALLTRIM(SE5->E5_TIPO)=="NF".AND.SA2->A2_INTER =="S"
		cConta := "1103020003"
		
	ELSEIF ALLTRIM(SE5->E5_TIPO)$ "NF/INV" .AND.SA2->A2_TIPO =="X"
		cConta := "1103020002"
	ELSE
		cConta	:= "1103020001"
	ENDIF
	
ELSEIF ALLTRIM(SE5->E5_TIPO)=="TX"
	SED->(DbSetOrder(1))
	If SED->(DbSeek( xFilial("SED") + SE5->E5_NATUREZ ))
		cConta := SED->ED_CONTA
	EndIf
	
Else
	
	SA2->(dbSetOrder(1))
	SA2->(dbSeek(xFilial("SA2") + SE5->E5_CLIFOR + SE5->E5_LOJA ))
	
	IF ALLTRIM(SE5->E5_TIPO)=="NF".AND.SA2->A2_INTER =="S"
		cConta := "1103020003"
		
	ELSEIF ALLTRIM(SE5->E5_TIPO)$ "NF/INV".AND.SA2->A2_TIPO =="X"
		cConta := "1103020002"
	ELSE
		cConta	:= "1103020001"
	ENDIF
EndIf

RestArea(aAREA_SE5)
RestArea(aAREA_SA2)
RestArea(aAREA_SED)
RestArea(aAREA_ATU)
Return(cConta)
