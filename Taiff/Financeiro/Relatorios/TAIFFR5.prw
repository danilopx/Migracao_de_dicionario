#INCLUDE "Protheus.ch"
#INCLUDE "Topconn.ch"
#INCLUDE "TBICONN.ch"
#INCLUDE "REPORT.CH"   		

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTAIFFR5   บ Autor ณ Microsiga          บ Data ณ  17/02/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Relatario de Comissใo 2-Todas (Emitidas).                  บฑฑ
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
User Function TAIFFR5()
                       
Private cAliasTrb	:= GetNextAlias()
Private cPerg     	:= 'TAIFFR5'
Private	cString   	:= 'Query'                                     
Private oReport

AjustaSx1( cPerg ) // Chama funcao de pergunta

If pergunte(cPerg,.T.)
 			
	oReport:= ReportDef()
	oReport:PrintDialog()
	
EndIf
     
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑณFunca o   ณReportDef ณ Autor ณ Microsiga          ณData  ณ 26/10/10    ณฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณImpressao do Relatorio.              					      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ TAIFF 				                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function ReportDef()
                 
//Local oBreak
Local oSection1
Local oSection2

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณCriacao dos componentes de impressao                                    ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
oReport := TReport():New('TAIFFR5','Relat๓rio de Comiss๕es (Emitidas): ',cPerg, {|oReport| RunReport( oReport )}, 'Comiss๕es - 2-Todas (Emitidas)') 
oReport:SetLandscape(.T.) 

//---------------------------------------------------------------------------------------------------------------//
	DEFINE SECTION oSection1 OF oReport TITLE 'SECAOO1'
		
		DEFINE CELL NAME 'F2_FILIAL'		OF oSection1 TITLE 'Filial'      		ALIAS cString SIZE 06 
	    DEFINE CELL NAME 'F2_VEND1'			OF oSection1 TITLE 'C๓d. Vend.'   		ALIAS cString SIZE 10
	    DEFINE CELL NAME 'A3_NOME'			OF oSection1 TITLE 'Nome Vend.'   		ALIAS cString SIZE 30 
                				
	DEFINE SECTION oSection2 OF oSection1 TITLE 'SECAOO2'

	DEFINE CELL NAME 'F2_EMISSAO' 	OF oSection2 TITLE 'Emissao'   		ALIAS cString SIZE 11 
	DEFINE CELL NAME 'F2_DOC'			OF oSection2 TITLE 'Documento' 		ALIAS cString SIZE 10 
	DEFINE CELL NAME 'F2_SERIE'  		OF oSection2 TITLE 'Prefixo'     	ALIAS cString SIZE 06                          
	DEFINE CELL NAME 'F2_CLIENTE'  	OF oSection2 TITLE 'Cliente'       	ALIAS cString SIZE 10
	DEFINE CELL NAME 'F2_LOJA'    	OF oSection2 TITLE 'Loja'     		ALIAS cString SIZE 06
	DEFINE CELL NAME 'A1_NOME'   		OF oSection2 TITLE 'Nome Cliente' 	ALIAS cString SIZE 30 		
	DEFINE CELL NAME 'F2_VALBRUT'   	OF oSection2 TITLE 'Vlr. Bruto'		ALIAS cString SIZE 12 Picture '@E@Z 999,999.99' Align RIGHT 
	DEFINE CELL NAME 'F2_BASEICM'		OF oSection2 TITLE 'Vlr. Base'		ALIAS cString SIZE 12 Picture '@E@Z 999,999.99' Align RIGHT          	 
	DEFINE CELL NAME 'POR_COMIS'   	OF oSection2 TITLE 'Percentual'		ALIAS cString SIZE 12 Picture '@E@Z 99,999.99' Align RIGHT Block{||PorComis()} 
	DEFINE CELL NAME 'VLR_COMIS'   	OF oSection2 TITLE 'Vlr. Comis.'		ALIAS cString SIZE 12 Picture '@E@Z 999,999.99' Align RIGHT Block{||VlrComis()}
 
	oSection1:SetTotalInLine(.F.)
	oSection2:SetLeftMargin(10)	
	DEFINE BREAK oBreak1 OF oSection1 WHEN oSection1:CELL('F2_VEND1')    // Quebra linha por vendedor.
	//DEFINE BREAK oBreak2 OF oSection1 WHEN {||(cAliasTrb)->F2_DOC+(cAliasTrb)->D2_DOC}
   DEFINE FUNCTION FROM oSection2:Cell('F2_VALBRUT') FUNCTION SUM BREAK oBreak1 NO END SECTION PICTURE '@E@Z 99,999,999.99'
   DEFINE FUNCTION FROM oSection2:Cell('F2_BASEICM') FUNCTION SUM BREAK oBreak1 NO END SECTION PICTURE '@E@Z 99,999,999.99'
   DEFINE FUNCTION FROM oSection2:Cell('VLR_COMIS')  FUNCTION SUM BREAK oBreak1 NO END SECTION PICTURE '@E@Z 99,999,999.99'
//---------------------------------------------------------------------------------------------------------------//
					
Return( oReport )   

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRunReport บ Autor ณ Microsiga          บ Data ณ  26/10/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ TAIFF                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function RunReport( oReport )

Local oSection1 := oReport:Section(1)  // Define a secao 1 do relatorio
Local oSection2	:= oReport:Section(1):Section(1) // Define a secao 2 do relatorio

oSection1:BeginQuery()
		BeginSql Alias cAliasTrb
			Column F2_EMISSAO  AS DATE 
			Column E1_EMISSAO  AS DATE 
			SELECT  F2_FILIAL , F2_DOC    , F2_SERIE  , F2_CLIENTE, F2_LOJA   , F2_EMISSAO , 
					F2_VALBRUT, F2_VALMERC, F2_CLIENTE, F2_LOJA   , F2_VEND1  , 
						 CASE WHEN F2_BASEICM = 0
							THEN F2_VALMERC
							ELSE F2_BASEICM
						END AS F2_BASEICM ,  
			        A1_COD    , A1_LOJA   , A1_NOME   , A1_CODCAN , A1_DESCCAN, 
					A3_COD    , A3_NOME   
					
			FROM %table:SF2% SF2, %table:SA3% SA3, %table:SA1% SA1
			WHERE   
					    SF2.D_E_L_E_T_  <> '*'
					AND SA3.D_E_L_E_T_  <> '*'
			        AND SA1.D_E_L_E_T_  <> '*'
			        
			        AND SA1.A1_FILIAL = %exp:xFilial("SA1")%
			        AND SA3.A3_FILIAL = %exp:xFilial("SA3")%
			        			        	        
			        AND SF2.F2_CLIENTE  = A1_COD
					AND SF2.F2_LOJA   	= A1_LOJA
					AND SF2.F2_VEND1	= A3_COD
									
					AND	SF2.F2_FILIAL 	>= %exp:mv_par01%
					AND SF2.F2_FILIAL 	<= %exp:mv_par02%
					AND SF2.F2_EMISSAO 	>= %exp:DTOS(mv_par03)%
					AND SF2.F2_EMISSAO 	<= %exp:DTOS(mv_par04)%
					AND SF2.F2_VEND1 	>= %exp:mv_par05%
					AND SF2.F2_VEND1 	<= %exp:mv_par06%                                            	
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
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณPorComis  บ Autor ณ Microsiga          บ Data ณ  26/10/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Pega o Valor da Comissใo total da NF, conforme os itens.   บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ TAIFF                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/ 
Static Function PorComis()

Local nPorComis	 	:= 0 
Local cQuery       	:= ''
Local cDoc       	:= (cAliasTrb)->F2_DOC
Local cSerie       	:= (cAliasTrb)->F2_SERIE
Local cCli       	:= (cAliasTrb)->F2_CLIENTE
Local cLojCLi      	:= (cAliasTrb)->F2_LOJA
Local cAliasQuery	:= GETNEXTALIAS()
Local aAreaAtu      := GetArea()

/*
cQuery := " SELECT "
cQuery += " D2_COMIS1, SD2.D2_FILIAL, SD2.D2_DOC, SD2.D2_SERIE, SD2.D2_CLIENTE, SD2.D2_LOJA " + CRLF

cQuery += " FROM " + RetSQLName("SD2") + " SD2 " + CRLF

cQuery += " WHERE " + CRLF
cQuery += "     SD2.D_E_L_E_T_ <> '*' " + CRLF
cQuery += " AND SD2.D2_FILIAL 	   = '" + xFilial("SD2")    + "' " + CRLF
cQuery += " AND SD2.D2_DOC 	   = '" + cDoc    + "' " + CRLF
cQuery += " AND SD2.D2_SERIE   = '" + cSerie  + "' " + CRLF
cQuery += " AND SD2.D2_CLIENTE = '" + cCli    + "' " + CRLF
cQuery += " AND SD2.D2_LOJA    = '" + cLojCli + "' " + CRLF
cQuery += " ORDER BY SD2.D2_FILIAL, SD2.D2_DOC, SD2.D2_SERIE, SD2.D2_CLIENTE, SD2.D2_LOJA " 
*/

cQuery := " SELECT "
cQuery += " MIN(D2_COMIS1) AS D2_COMIS1 " + CRLF
cQuery += " FROM " + RetSQLName("SD2") + " SD2 " + CRLF
cQuery += " WHERE " + CRLF
cQuery += "     SD2.D_E_L_E_T_ <> '*' " + CRLF
cQuery += " AND SD2.D2_FILIAL 	   = '" + xFilial("SD2")    + "' " + CRLF
cQuery += " AND SD2.D2_DOC 	   = '" + cDoc    + "' " + CRLF
cQuery += " AND SD2.D2_SERIE   = '" + cSerie  + "' " + CRLF
cQuery += " AND SD2.D2_CLIENTE = '" + cCli    + "' " + CRLF
cQuery += " AND SD2.D2_LOJA    = '" + cLojCli + "' " + CRLF

cQuery := ChangeQuery(cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasQuery,.F.,.T.)

nPorComis	:= (cAliasQuery)->D2_COMIS1
   
(cAliasQuery)->(dbCloseArea())
RestArea(aAreaAtu)

Return( nPorComis )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณVlrComis  บ Autor ณ Microsiga          บ Data ณ  26/10/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Pega o Valor da Comissใo total da NF, conforme os itens.   บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ TAIFF                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/ 
Static Function VlrComis() 

Local nVlrComis	 	:= 0 
Local nPorComis	 	:= 0 
Local cQuery       	:= ''
Local cDoc       	:= (cAliasTrb)->F2_DOC
Local cSerie       	:= (cAliasTrb)->F2_SERIE
Local cCli       	:= (cAliasTrb)->F2_CLIENTE
Local cLojCLi      	:= (cAliasTrb)->F2_LOJA
Local nVlrBase    	:= (cAliasTrb)->F2_BASEICM
Local cAliasQuery	:= GETNEXTALIAS()
Local aAreaAtu      := GetArea()


cQuery := " SELECT "
cQuery += " MIN(D2_COMIS1) AS D2_COMIS1 " + CRLF
cQuery += " FROM " + RetSQLName("SD2") + " SD2 " + CRLF
cQuery += " WHERE " + CRLF
cQuery += "     SD2.D_E_L_E_T_ <> '*' " + CRLF
cQuery += " AND SD2.D2_FILIAL 	   = '" + xFilial("SD2")    + "' " + CRLF
cQuery += " AND SD2.D2_DOC 	   = '" + cDoc    + "' " + CRLF
cQuery += " AND SD2.D2_SERIE   = '" + cSerie  + "' " + CRLF
cQuery += " AND SD2.D2_CLIENTE = '" + cCli    + "' " + CRLF
cQuery += " AND SD2.D2_LOJA    = '" + cLojCli + "' " + CRLF

cQuery := ChangeQuery(cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasQuery,.F.,.T.)

nComissZero	:= (cAliasQuery)->D2_COMIS1
   
(cAliasQuery)->(dbCloseArea())


cQuery := " SELECT "
cQuery += " D2_COMIS1, SD2.D2_FILIAL, SD2.D2_DOC, SD2.D2_SERIE, SD2.D2_CLIENTE, SD2.D2_LOJA " + CRLF

cQuery += " FROM " + RetSQLName("SD2") + " SD2 " + CRLF

cQuery += " WHERE " + CRLF
cQuery += "     SD2.D_E_L_E_T_ <> '*' " + CRLF
cQuery += " AND SD2.D2_FILIAL 	   = '" + xFilial("SD2")    + "' " + CRLF
cQuery += " AND SD2.D2_DOC 	   = '" + cDoc    + "' " + CRLF
cQuery += " AND SD2.D2_SERIE   = '" + cSerie  + "' " + CRLF
cQuery += " AND SD2.D2_CLIENTE = '" + cCli    + "' " + CRLF
cQuery += " AND SD2.D2_LOJA    = '" + cLojCli + "' " + CRLF
cQuery += " ORDER BY SD2.D2_FILIAL, SD2.D2_DOC, SD2.D2_SERIE, SD2.D2_CLIENTE, SD2.D2_LOJA " 

cQuery := ChangeQuery(cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasQuery,.F.,.T.)

If nComissZero = 0
	nPorComis	:= 0
Else
	nPorComis	:= (cAliasQuery)->D2_COMIS1
EndIf

If Empty(nPorComis)
	nPorComis := 0 	
Endif

If SM0->M0_CODIGO='02' .OR. SM0->M0_CODIGO='03' 
	nVlrComis	:= (cAliasTrb)->F2_VALMERC * (nPorComis / 100) 
Else
	nVlrComis	:= nVlrBase * (nPorComis / 100) 
EndIf
   
(cAliasQuery)->(dbCloseArea())
RestArea(aAreaAtu)

Return( nVlrComis ) 
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณPrograma  ณAjustaSX1 ณ Autor ณ Microsiga             ณ Data ณ26/10/10  ณฑฑ
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
aHelpPor := {'Filial de ?'}
aHelpEng := {''}
aHelpSpa := {''}

PutSx1(cPerg,"01","Filial de      ? ","","","mv_ch1","C",02,0,0,"G","","SM0",,,"MV_PAR01")

//---------------------------------------MV_PAR02-------------------------------------------------- 
aHelpPor := {'Filial ate?'}
aHelpEng := {''}
aHelpSpa := {''}

PutSx1(cPerg,"02","Filial ate     ? ","","","mv_ch2","C",02,0,0,"G","","SM0",,,"MV_PAR02")

//---------------------------------------MV_PAR03-------------------------------------------------- 
aHelpPor := {'Data Emissใo de?'}
aHelpEng := {''}
aHelpSpa := {''}

PutSx1(cPerg,"03","Data Emissใo de? ","","","mv_ch3","D",08,0,0,"G","","",,,"MV_PAR03")

//---------------------------------------MV_PAR04-------------------------------------------------- 
aHelpPor := {'Data Emissใo ate?'}
aHelpEng := {''}
aHelpSpa := {''}

PutSx1(cPerg,"04","Data Emissใo ate?","","","mv_ch4","D",08,0,0,"G","","",,,"MV_PAR04")

//---------------------------------------MV_PAR05-------------------------------------------------- 
aHelpPor := {'Vendedor de?'}
aHelpEng := {''}
aHelpSpa := {''}

PutSx1(cPerg,"05","Vendedor de?     ","","","mv_ch5","C",06,0,0,"G","","SA3",,,"MV_PAR05")

//---------------------------------------MV_PAR06-------------------------------------------------- 
aHelpPor := {'Vendedor ate?'}
aHelpEng := {''}
aHelpSpa := {''}

PutSx1(cPerg,"06","Vendedor ate?    ","","","mv_ch6","C",06,0,0,"G","","SA3",,,"MV_PAR06")

//----------------

RestArea(aAreaAnt)

Return()
