#INCLUDE "Protheus.ch"
#INCLUDE "Topconn.ch"
#INCLUDE "TBICONN.ch"
#INCLUDE "REPORT.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTAIFFR3   บ Autor ณ Microsiga          บ Data ณ  29/10/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Relatario de Faturamento por vendedor.                     บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametrosณ Nao ha										              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบRetorno   ณ Nao ha                                                     บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAplicacao ณ                                  		                  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ TAIFF                                                      บฑฑ
ฑฑฬออออออออออุออออออออัออออออัออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAnalista  ณData    ณBops  ณManutencao Efetuada                         บฑฑ
ฑฑฬออออออออออุออออออออุออออออุออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ          ณ        ณ      ณ                                            บฑฑ
ฑฑศออออออออออฯออออออออฯออออออฯออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿                           
*/
User Function TAIFFR3()
                       
Private cAliasTrb	:= GetNextAlias()
Private cPerg     	:= 'TAIFFR3'
Private	cString   	:= 'Query'                         
Private	oReport
               
AjustaSx1( cPerg ) // Chama funcao de pergunta

If Pergunte(cPerg,.T.)
 			
	oReport:= ReportDef()
	oReport:PrintDialog()
	
EndIf
     
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑณFunca o   ณReportDef ณ Autor ณ Microsiga          ณData  ณ 29/10/10    ณฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณImpressao do Relatorio.              					      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ TAIFF 				                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function ReportDef()
                 
Local oSection1
Local oSection2
Local oSection3

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณCriacao dos componentes de impressao                                    ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If MV_PAR01 == 1 // Analitico
	oReport := TReport():New('TAIFFR3','Relat๓rio de Faturamento por vendedor (Analitico):',cPerg, {|oReport| RunRepo( oReport )}, 'Faturamento por vendedor (Analitico)')
Else // 2 = Sint้tico
	oReport := TReport():New('TAIFFR3','Relat๓rio de Faturamento por vendedor (Sint้tico):',cPerg, {|oReport| RunRepo1( oReport )}, 'Faturamento por vendedor (Sint้tico)')
Endif
oReport:SetLandscape(.T.)

If MV_PAR01 == 1 // Analitico 
//---------------------------------------------------------------------------------------------------------------//
	DEFINE SECTION oSection1 OF oReport TITLE 'SECAOO1'
		
		DEFINE CELL NAME 'F2_FILIAL'		OF oSection1 TITLE 'Filial'      	ALIAS cString SIZE 06 
	    DEFINE CELL NAME 'F2_VEND1'			OF oSection1 TITLE 'C๓d. Vend.'   	ALIAS cString SIZE 10
	    DEFINE CELL NAME 'A3_NOME'			OF oSection1 TITLE 'Nome Vend.'   	ALIAS cString SIZE 30 
                				
	DEFINE SECTION oSection2 OF oSection1 TITLE 'SECAOO2'

	    DEFINE CELL NAME 'F2_DOC'			OF oSection2 TITLE 'Documento' 		ALIAS cString SIZE 10 
		DEFINE CELL NAME 'F2_SERIE'  		OF oSection2 TITLE 'Prefixo'     	ALIAS cString SIZE 06                          
		DEFINE CELL NAME 'D2_PEDIDO'  		OF oSection2 TITLE 'Pedido'       	ALIAS cString SIZE 10
		DEFINE CELL NAME 'F2_CLIENTE'  		OF oSection2 TITLE 'Cliente'       	ALIAS cString SIZE 10
		DEFINE CELL NAME 'F2_LOJA'    		OF oSection2 TITLE 'Loja'     		ALIAS cString SIZE 06
		DEFINE CELL NAME 'A1_NOME'   		OF oSection2 TITLE 'Nome Cliente' 	ALIAS cString SIZE 30 	
		DEFINE CELL NAME 'F2_VALBRUT'		OF oSection2 TITLE 'Vlr. c/ IPI'	ALIAS cString SIZE 12 Picture '@E@Z 99,999.99' Align RIGHT          	 
		DEFINE CELL NAME 'F2_VALMERC'		OF oSection2 TITLE 'Vlr. s/ IPI'	ALIAS cString SIZE 12 Picture '@E@Z 99,999.99' Align RIGHT          	  		
		DEFINE CELL NAME 'F2_EMISSAO' 		OF oSection2 TITLE 'Comissao'   	ALIAS cString SIZE 11 
		DEFINE CELL NAME 'A1_CODCAN'		OF oSection2 TITLE 'Canal' 		   	ALIAS cString SIZE 12
		DEFINE CELL NAME 'A1_DESCCAN'		OF oSection2 TITLE 'Descri. Canal' 	ALIAS cString SIZE 30 
		
	DEFINE SECTION oSection3 OF oSection2 TITLE 'SECAOO3'
	
		DEFINE CELL NAME 'D2_ITEM'    		OF oSection3 TITLE 'Item'     		ALIAS cString SIZE 06
		DEFINE CELL NAME 'D2_COD'   		OF oSection3 TITLE 'C๓digo'    		ALIAS cString SIZE 12
		DEFINE CELL NAME 'B1_DESC'	 		OF oSection3 TITLE 'Descri็ใo'   	ALIAS cString SIZE 40 	 
		DEFINE CELL NAME 'D2_QUANT' 		OF oSection3 TITLE 'Quantidade'   	ALIAS cString SIZE 11 	
		DEFINE CELL NAME 'D2_PRCVEN' 		OF oSection3 TITLE 'Val. Item'   	ALIAS cString SIZE 11 	
		DEFINE CELL NAME 'D2_TOTAL' 		OF oSection3 TITLE 'Tot. Itens'   	ALIAS cString SIZE 11 	
		DEFINE CELL NAME 'D2_COMIS1'   		OF oSection3 TITLE 'Comis. p/ Item'	ALIAS cString SIZE 12 Picture '@E@Z 99,999.99' Align RIGHT
		
	oSection1:SetTotalInLine(.F.)
	oSection2:SetLeftMargin(10)
	oSection3:SetLeftMargin(15)
	DEFINE BREAK oBreak1 OF oSection1 WHEN oSection1:CELL('F2_VEND1')    // Quebra linha por vendedor.
	DEFINE BREAK oBreak2 OF oSection1 WHEN {||(cAliasTrb)->F2_DOC+(cAliasTrb)->D2_DOC}
    DEFINE FUNCTION FROM oSection2:Cell('F2_VALBRUT') FUNCTION SUM BREAK oBreak2 NO END SECTION PICTURE '@E@Z 999,999.99'
    DEFINE FUNCTION FROM oSection2:Cell('F2_VALMERC') FUNCTION SUM BREAK oBreak2 NO END SECTION PICTURE '@E@Z 999,999.99'
    DEFINE FUNCTION FROM oSection3:Cell('D2_COMIS1')  FUNCTION SUM BREAK oBreak2 NO END SECTION PICTURE '@E@Z 999,999.99'
//---------------------------------------------------------------------------------------------------------------//
Else //MV_PAR == 2 - Sint้tico             
//---------------------------------------------------------------------------------------------------------------//
DEFINE SECTION oSection1 OF oReport TITLE 'SECAOO1'
		
		DEFINE CELL NAME 'F2_FILIAL'		OF oSection1 TITLE 'Filial'      	ALIAS cString SIZE 06 
	    DEFINE CELL NAME 'F2_VEND1'			OF oSection1 TITLE 'C๓d. Vend.'   	ALIAS cString SIZE 10
	    DEFINE CELL NAME 'A3_NOME'			OF oSection1 TITLE 'Nome Vend.'   	ALIAS cString SIZE 30 
                				
	DEFINE SECTION oSection2 OF oSection1 TITLE 'SECAOO2'

	    DEFINE CELL NAME 'F2_DOC'			OF oSection2 TITLE 'Documento' 		ALIAS cString SIZE 10 
		DEFINE CELL NAME 'F2_SERIE'  		OF oSection2 TITLE 'Prefixo'     	ALIAS cString SIZE 06                          
		DEFINE CELL NAME 'D2_PEDIDO'  		OF oSection2 TITLE 'Pedido'       	ALIAS cString SIZE 10 	
		DEFINE CELL NAME 'F2_CLIENTE'  		OF oSection2 TITLE 'Cliente'       	ALIAS cString SIZE 10
		DEFINE CELL NAME 'F2_LOJA'    		OF oSection2 TITLE 'Loja'     		ALIAS cString SIZE 06
		DEFINE CELL NAME 'A1_NOME'   		OF oSection2 TITLE 'Nome Cliente' 	ALIAS cString SIZE 30 		
		DEFINE CELL NAME 'F2_VALBRUT'		OF oSection2 TITLE 'Vlr. c/ IPI'	ALIAS cString SIZE 12 Picture '@E@Z 99,999.99' Align RIGHT          	 
		DEFINE CELL NAME 'F2_VALMERC'		OF oSection2 TITLE 'Vlr. s/ IPI'	ALIAS cString SIZE 12 Picture '@E@Z 99,999.99' Align RIGHT          	 
		DEFINE CELL NAME 'F2_EMISSAO' 		OF oSection2 TITLE 'Comissao'   	ALIAS cString SIZE 11 
		DEFINE CELL NAME 'A1_CODCAN'		OF oSection2 TITLE 'Canal' 		   	ALIAS cString SIZE 12
		DEFINE CELL NAME 'A1_DESCCAN'		OF oSection2 TITLE 'Descri. Canal' 	ALIAS cString SIZE 20
		DEFINE CELL NAME 'D2_COMIS1'   		OF oSection2 TITLE 'Comis. p/ Item'	ALIAS cString SIZE 12 Picture '@E@Z 99,999.99' Align RIGHT 
 
	oSection1:SetTotalInLine(.F.)
	oSection2:SetLeftMargin(10)	
	DEFINE BREAK oBreak1 OF oSection1 WHEN oSection1:CELL('F2_VEND1')    // Quebra linha por vendedor.
	DEFINE BREAK oBreak2 OF oSection1 WHEN {||(cAliasTrb)->F2_DOC+(cAliasTrb)->D2_DOC}
    DEFINE FUNCTION FROM oSection2:Cell('F2_VALBRUT') FUNCTION SUM BREAK oBreak1 NO END SECTION PICTURE '@E@Z 999,999.99'
    DEFINE FUNCTION FROM oSection2:Cell('F2_VALMERC') FUNCTION SUM BREAK oBreak1 NO END SECTION PICTURE '@E@Z 999,999.99'
//---------------------------------------------------------------------------------------------------------------//
Endif
				
Return( oReport )   

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRunReport บ Autor ณ Microsiga          บ Data ณ  29/10/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ TAIFF                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function RunRepo( oReport )

// Define as secoes do relatorio
Local oSection1 := oReport:Section(1) 
Local oSection2	:= oReport:Section(1):Section(1)
Local oSection3	:= oReport:Section(1):Section(1):Section(1)

oSection1:BeginQuery()
		BeginSql Alias cAliasTrb
			Column F2_EMISSAO  AS DATE 
			Column E1_EMISSAO  AS DATE 
			SELECT  F2_FILIAL , F2_DOC    , F2_SERIE  , F2_CLIENTE, F2_LOJA   , F2_EMISSAO, 
					F2_VALBRUT, F2_VALMERC, F2_CLIENTE, F2_LOJA   , F2_VEND1  ,  
			        D2_FILIAL , D2_ITEM   , D2_DOC    , D2_COD    , D2_QUANT  , D2_TOTAL  , 
			        D2_TES    , D2_QUANT  , D2_TOTAL  , D2_COMIS1 , D2_PEDIDO , D2_PRCVEN , 
					A1_COD    , A1_LOJA   , A1_NOME   , A1_CODCAN , A1_DESCCAN, 
					A3_COD    , A3_NOME   , B1_COD    , B1_DESC   
					
			FROM %table:SF2% SF2, %table:SD2% SD2, %table:SA3% SA3, %table:SA1% SA1, %table:SB1% SB1 
			WHERE   
					    SF2.D_E_L_E_T_  <> '*'
					AND SD2.D_E_L_E_T_  <> '*'						
			        AND SA3.D_E_L_E_T_  <> '*'
			        AND SA1.D_E_L_E_T_  <> '*'
			        AND SB1.D_E_L_E_T_  <> '*'
			        
			        AND SF2.F2_DOC  	= D2_DOC				        
			        AND SF2.F2_VEND1	= A3_COD
			        AND SF2.F2_CLIENTE  = A1_COD
					AND SF2.F2_LOJA   	= A1_LOJA
					AND SD2.D2_COD   	= B1_COD
				
					AND	SF2.F2_FILIAL 	>= %exp:mv_par02%
					AND SF2.F2_FILIAL 	<= %exp:mv_par03%
					AND SF2.F2_EMISSAO 	>= %exp:DTOS(mv_par04)%
					AND SF2.F2_EMISSAO 	<= %exp:DTOS(mv_par05)%
					AND SF2.F2_VEND1 	>= %exp:mv_par06%
					AND SF2.F2_VEND1 	<= %exp:mv_par07%                                            	
			ORDER BY 
					F2_EMISSAO, F2_DOC, A3_COD
	EndSql
	oSection1:EndQuery()
	oSection2:SetParentQuery()
	oSection2:SetParentFilter({|cParam| (cAliasTrb)->F2_VEND1 == cParam},{|| (cAliasTrb)->A3_COD})
	oSection3:SetParentQuery()
	oSection3:SetParentFilter({|cParam| (cAliasTrb)->F2_DOC == cParam},{|| (cAliasTrb)->D2_DOC})    
oSection1:Print()

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRunReport1บ Autor ณ Microsiga          บ Data ณ  26/10/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ TAIFF                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function RunRepo1( oReport )

// Define as secoes do relatorio
Local oSection1 := oReport:Section(1)  
Local oSection2	:= oReport:Section(1):Section(1)

oSection1:BeginQuery()
		BeginSql Alias cAliasTrb
			Column F2_EMISSAO  AS DATE 
			Column E1_EMISSAO  AS DATE 
			SELECT  F2_FILIAL , F2_DOC    , F2_SERIE  , F2_CLIENTE, F2_LOJA   , F2_EMISSAO , 
					F2_VALBRUT, F2_VALMERC, F2_CLIENTE, F2_LOJA   , F2_VEND1  ,  
			        D2_FILIAL , D2_ITEM   , D2_DOC    , D2_COD    , D2_QUANT  , D2_TOTAL  , 
			        D2_TES    , D2_QUANT  , D2_TOTAL  , D2_COMIS1 , D2_PEDIDO , D2_PRCVEN , 
					A1_COD    , A1_LOJA   , A1_NOME   , A1_CODCAN , A1_DESCCAN, 
					A3_COD    , A3_NOME   
					
			FROM %table:SF2% SF2, %table:SD2% SD2, %table:SA3% SA3, %table:SA1% SA1
			WHERE   
					    SF2.D_E_L_E_T_  <> '*'
					AND SD2.D_E_L_E_T_  <> '*'						
			        AND SA3.D_E_L_E_T_  <> '*'
			        AND SA1.D_E_L_E_T_  <> '*'
			        			        
			        AND SF2.F2_DOC  	= D2_DOC				        
			        AND SF2.F2_VEND1	= A3_COD
			        AND SF2.F2_CLIENTE  = A1_COD
					AND SF2.F2_LOJA   	= A1_LOJA
									
					AND	SF2.F2_FILIAL 	>= %exp:mv_par02%
					AND SF2.F2_FILIAL 	<= %exp:mv_par03%
					AND SF2.F2_EMISSAO 	>= %exp:DTOS(mv_par04)%
					AND SF2.F2_EMISSAO 	<= %exp:DTOS(mv_par05)%
					AND SF2.F2_VEND1 	>= %exp:mv_par06%
					AND SF2.F2_VEND1 	<= %exp:mv_par07%                                            	
			ORDER BY 
					F2_EMISSAO, F2_DOC, A3_COD
		EndSql 
		oSection1:EndQuery()
   		oSection2:SetParentQuery()
  		oSection2:SetParentFilter({|cParam| (cAliasTrb)->F2_VEND1 == cParam},{|| (cAliasTrb)->A3_COD})  
oSection1:Print()

Return                                                                                    	
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณPrograma  ณAjustaSX1 ณ Autor ณ Microsiga             ณ Data ณ29/10/10  ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescricao ณ Monta perguntas no SX1.                                    ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function AjustaSx1(cPerg)

Local aAreaAnt := GetArea()
Local aHelpPor := {}
Local aHelpEng := {}
Local aHelpSpa := {}

//---------------------------------------MV_PAR01--------------------------------------------------
aHelpPor := {'Anแlitico ou Sint้tico?'}
aHelpEng := {''}
aHelpSpa := {''}

PutSx1(cPerg,"01","Anแlitico / Sint้tico? ","","","mv_ch1"	,"C",01,0,0,"C","","","","","MV_PAR01","Anแlitico","","","","Sint้tico","","") //,"Ambos","","","","","") 
//---------------------------------------MV_PAR02-------------------------------------------------- 
aHelpPor := {'Filial de ?'}
aHelpEng := {''}
aHelpSpa := {''}

PutSx1(cPerg,"02","Filial de      ? ","","","mv_ch2","C",02,0,0,"G","","SM0",,,"MV_PAR02")

//---------------------------------------MV_PAR03-------------------------------------------------- 
aHelpPor := {'Filial ate?'}
aHelpEng := {''}
aHelpSpa := {''}

PutSx1(cPerg,"03","Filial ate     ? ","","","mv_ch3","C",02,0,0,"G","","SM0",,,"MV_PAR03")

//---------------------------------------MV_PAR04-------------------------------------------------- 
aHelpPor := {'Data Emissใo de?'}
aHelpEng := {''}
aHelpSpa := {''}

PutSx1(cPerg,"04","Data Emissใo de? ","","","mv_ch4","D",08,0,0,"G","","",,,"MV_PAR04")

//---------------------------------------MV_PAR05-------------------------------------------------- 
aHelpPor := {'Data Emissใo ate?'}
aHelpEng := {''}
aHelpSpa := {''}

PutSx1(cPerg,"05","Data Emissใo ate?","","","mv_ch5","D",08,0,0,"G","","",,,"MV_PAR05")

//---------------------------------------MV_PAR06-------------------------------------------------- 
aHelpPor := {'Vendedor de?'}
aHelpEng := {''}
aHelpSpa := {''}

PutSx1(cPerg,"06","Vendedor de?     ","","","mv_ch6","C",06,0,0,"G","","SA3",,,"MV_PAR06")

//---------------------------------------MV_PAR07-------------------------------------------------- 
aHelpPor := {'Vendedor ate?'}
aHelpEng := {''}
aHelpSpa := {''}

PutSx1(cPerg,"07","Vendedor ate?    ","","","mv_ch7","C",06,0,0,"G","","SA3",,,"MV_PAR07")

//----------------

RestArea(aAreaAnt)

Return()
