#include 'protheus.ch'


user function NFORISBM()
Local aAreaAtu := GetArea()
Local aAreaSB1 := SB1->(GetArea())
Local aAreaSBM := SBM->(GetArea())
Local aAreaSD1 := SD1->(GetArea())
Local aAreaCTT := CTT->(GetArea())
Local CCONTARET := ""
Local cCCusto	:= ""

cNumNFOri := SD2->D2_NFORI
cSerNFOri := SD2->D2_SERIORI
cItemOri  := SD2->D2_ITEMORI
cCodClifor  := SD2->D2_CLIENTE
cLojClifor	:= SD2->D2_LOJA
cCodProdut  := SD2->D2_COD
cGrupoProd  := SD2->D2_GRUPO

DbSelectArea("SD1")
SD1->(DbSetOrder(1))
//D1_FILIAL, D1_DOC, D1_SERIE, D1_FORNECE, D1_LOJA, D1_COD, D1_ITEM

If SD1->(DbSeek(xFilial("SD1") + cNumNFOri + cSerNFOri + cCodClifor + cLojClifor + cCodProdut + cItemOri  ))
	cCCusto := SD1->D1_CC
	CTT->( DBSETORDER(1) )
	CTT->( DBSEEK(XFILIAL("CTT")+cCCusto) )

	Do Case
	   Case Alltrim(CTT->CTT_XGRPCC)=="6203"
	      CCONTARET := Posicione("SBM",1,xFilial("SBM") + cGrupoProd ,"BM_REV")
	   Case Alltrim(CTT->CTT_XGRPCC)=="6204"
	      CCONTARET := Posicione("SBM",1,xFilial("SBM") + cGrupoProd ,"BM_EST")
	   Case Alltrim(CTT->CTT_XGRPCC)=="630"
	      CCONTARET := Posicione("SBM",1,xFilial("SBM") + cGrupoProd ,"BM_DADM")	 
	Endcase
	
Endif

RestArea(aAreaSB1)
RestArea(aAreaSBM)
RestArea(aAreaSD1)
RestArea(aAreaCTT)
RestArea(aAreaAtu)
	
return CCONTARET