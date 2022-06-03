#INCLUDE "Totvs.ch"
/*
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ  TAIFF                                                                                                      บฑฑ
ฑฑอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
*/
User Function LP596DEB()
********************
Local aAREA_ATU           := GetArea()
Local aAREA_SE5             := SE5->( GetArea() )
Local cConta      := ""
Local cChave      := ""
Local cNDCnatur 	:= ""

If Alltrim(SE5->E5_TIPO)=="RA"  
                
                // Procurando o parceiro
                cCHAVE:= Substr(SE5->E5_DOCUMEN,1,3)+;
                Substr(SE5->E5_DOCUMEN,4,9)+;
                Substr(SE5->E5_DOCUMEN,13,2)+;
                Substr(SE5->E5_DOCUMEN,15,3)
                //+;
                //Substr(SE5->E5_DOCUMEN,18,6)+;
                //Substr(SE5->E5_DOCUMEN,24,2)
                               
                DbSelectArea("SE5")
                
                DbSetOrder(7)
                
                DbSeek( xFilial("SE5") + cCHAVE )
                
                SA1->(dbSetOrder(1))
                SA1->(dbSeek(xFilial("SA1") + SE5->E5_CLIFOR + SE5->E5_LOJA ))
                
                IF ALLTRIM(SE5->E5_TIPO) =="NF" .AND. SA1->A1_INTER  =="S"
                               cConta := "2106030002"

                ELSEIF ALLTRIM(SE5->E5_TIPO)=="NF" .And. SA1->A1_INTER =="N"
                               cConta := "2106030001"   

  		ELSEIF ALLTRIM(SE5->E5_TIPO)=="NDC" .And. SA1->A1_INTER =="N"
                               cConta := "2106030001"   

  		ELSEIF ALLTRIM(SE5->E5_TIPO)=="NDC" .And. SA1->A1_INTER =="S"
                               cConta := "2106030002" 
                ENDIF
                               
ElseIf Alltrim(SE5->E5_TIPO)=="NF"  
                
                // Procurando o parceiro
                cCHAVE:= SE5->E5_FILIAL + Substr(SE5->E5_DOCUMEN,1,3)+;
                Substr(SE5->E5_DOCUMEN,4,9)+;
                Substr(SE5->E5_DOCUMEN,13,2)+;
                Substr(SE5->E5_DOCUMEN,15,3)
                //+;
                //Substr(SE5->E5_DOCUMEN,18,6)+;
                //Substr(SE5->E5_DOCUMEN,24,2)
                               
                DbSelectArea("SE5")
                
                DbSetOrder(7)
                
                DbSeek( cCHAVE )
                
                SA1->(dbSetOrder(1))
                SA1->(dbSeek(xFilial("SA1") + SE5->E5_CLIFOR + SE5->E5_LOJA ))
                
                IF ALLTRIM(SE5->E5_TIPO)=="NCC" .AND. SA1->A1_INTER  =="S"
                               cConta := "2106030002"

                ELSEIF ALLTRIM(SE5->E5_TIPO)=="NCC" .AND.SA1->A1_INTER  =="N"
                               cConta := "2106030001"                 
                               
                ELSEIF ALLTRIM(SE5->E5_TIPO) == "RA" .AND.SA1->A1_INTER  =="S"
                               cConta := "2106030002"                               

                ELSEIF ALLTRIM(SE5->E5_TIPO) == "RA" .AND. SA1->A1_INTER  =="N"
                               cConta := "2106030001"                                 
                               
			     ENDIF                                               
                
ElseIf Alltrim(SE5->E5_TIPO)=="NDC"  
                
                cNDCnatur := SE5->E5_NATUREZ 
                
                // Procurando o parceiro
                cCHAVE:= Substr(SE5->E5_DOCUMEN,1,3)+;
                Substr(SE5->E5_DOCUMEN,4,9)+;
                Substr(SE5->E5_DOCUMEN,13,2)+;
                Substr(SE5->E5_DOCUMEN,15,3)
                //+;
                //Substr(SE5->E5_DOCUMEN,18,6)+;
                //Substr(SE5->E5_DOCUMEN,24,2)
                               
                DbSelectArea("SE5")
                
                DbSetOrder(7)
                
                DbSeek( xFilial("SE5") + cCHAVE )
                
                SA1->(dbSetOrder(1))
                SA1->(dbSeek(xFilial("SA1") + SE5->E5_CLIFOR + SE5->E5_LOJA ))
                
                IF ALLTRIM(SE5->E5_TIPO)=="NCC".AND.SA1->A1_INTER  =="S"
                               cConta := " A CLASSIFICAR "    
                ELSEIF ALLTRIM(SE5->E5_TIPO)=="NCC" .AND. SA1->A1_INTER  =="N" .AND. ALLTRIM(cNDCnatur) != "NCCAB+"
                               cConta := "2106030001"                                       

		ELSEIF ALLTRIM(SE5->E5_TIPO)=="RA" .And. SA1->A1_INTER =="N"
                               cConta := "2106030001"   

  		ELSEIF ALLTRIM(SE5->E5_TIPO)=="RA" .And. SA1->A1_INTER =="S"
                               cConta := "2106030002" 
                ENDIF   

ElseIf Alltrim(SE5->E5_TIPO)=="NCC"  
                
                // Procurando o parceiro
                cCHAVE:= SE5->E5_FILIAL + Substr(SE5->E5_DOCUMEN,1,3)+;
                Substr(SE5->E5_DOCUMEN,4,9)+;
                Substr(SE5->E5_DOCUMEN,13,2)+;
                Substr(SE5->E5_DOCUMEN,15,3)
                //+;
                //Substr(SE5->E5_DOCUMEN,18,6)+;
                //Substr(SE5->E5_DOCUMEN,24,2)
                              
                DbSelectArea("SE5")
                
                DbSetOrder(7)
                
                DbSeek( cCHAVE )
                
                SA1->(dbSetOrder(1))
                SA1->(dbSeek(xFilial("SA1") + SE5->E5_CLIFOR + SE5->E5_LOJA ))
                
                IF ALLTRIM(SE5->E5_TIPO)=="NF".AND.SA1->A1_INTER  =="S"
                               cConta := "2106030002"

                ELSEIF ALLTRIM(SE5->E5_TIPO)=="NF" .AND. SA1->A1_INTER  =="N"
                               cConta := "2106030001"                                
                               
				  ELSEIF ALLTRIM(SE5->E5_TIPO)=="NDC" .AND. SA1->A1_INTER  =="S"
                               cConta := " A CLASSIFICAR "    
                ELSEIF ALLTRIM(SE5->E5_TIPO)=="NDC" .AND. SA1->A1_INTER  =="N" .AND. ALLTRIM(SE5->E5_NATUREZ) !='NCCAB+'
                               cConta := "2106030001"                                        
                ENDIF                   

Else
                cConta :=            "A CLASSIFICAR"
EndIf

RestArea(aAREA_SE5)
RestArea(aAREA_ATU)

Return(cConta)