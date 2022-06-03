#INCLUDE "Protheus.ch"
#INCLUDE "Topconn.ch"
#INCLUDE "TBICONN.ch"
#INCLUDE "REPORT.CH"   		

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTAIFFR1   บ Autor ณ Microsiga          บ Data ณ  26/10/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Relatario de Provisao de comissoes a receber.              บฑฑ
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
User Function TAIFFR1()
                       
Private oReport
Private cAliasTrb	:= GetNextAlias()
Private cPerg     	:= 'TAIFFR1'
Private	cString   	:= 'Query'                                     

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
                 
Local oBreak1
Local oBreak2
Local oSection1
Local oSection2
Local oSection3

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณCriacao dos componentes de impressao                                    ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If MV_PAR01 == 1 // Analitico
	oReport := TReport():New('TAIFFR1','Relat๓rio de provisใo de comiss๕es a RECEBER (Analitico): ',cPerg, {|oReport| RunReport( oReport )}, 'Provisใo de Comiss๕es a RCEBER')
Else // Sintetico
	oReport := TReport():New('TAIFFR1','Relat๓rio de provisใo de comiss๕es a RECEBER (Sintetico): ',cPerg, {|oReport| RunReport1( oReport )}, 'Provisใo de Comiss๕es a RCEBER')
Endif
oReport:SetLandscape(.T.) 

If MV_PAR01 == 1 // Analitico
//---------------------------------------------------------------------------------------------------------------//
	DEFINE SECTION oSection1 OF oReport TITLE 'SECAOO1'
		
		DEFINE CELL NAME 'E3_FILIAL'		OF oSection1 TITLE 'Filial'      	ALIAS cString SIZE 06 
	    DEFINE CELL NAME 'E3_VEND'			OF oSection1 TITLE 'C๓d. Vend.'   	ALIAS cString SIZE 10
	    DEFINE CELL NAME 'A3_NOME'			OF oSection1 TITLE 'Nome Vend.'   	ALIAS cString SIZE 30 
        DEFINE CELL NAME 'MES_EMISSAO'  	OF oSection1 TITLE 'M๊s Referente' 	ALIAS cString SIZE 11 Block{||Ref()}	
        				
	DEFINE SECTION oSection2 OF oSection1 TITLE 'SECAOO2'

	    DEFINE CELL NAME 'E3_NUM'			OF oSection2 TITLE 'Titulo' 		ALIAS cString SIZE 10 
		DEFINE CELL NAME 'E3_SERIE'  		OF oSection2 TITLE 'Prefixo'     	ALIAS cString SIZE 06                          
		DEFINE CELL NAME 'E3_PARCELA' 		OF oSection2 TITLE 'Parcela'       	ALIAS cString SIZE 06
		DEFINE CELL NAME 'E3_PEDIDO'  		OF oSection2 TITLE 'Pedido'       	ALIAS cString SIZE 10 	
		DEFINE CELL NAME 'F2_VALBRUT'		OF oSection2 TITLE 'Vlr. c/ IPI'	ALIAS cString SIZE 12 Picture '@E@Z 99,999.99' Align RIGHT          	 
		DEFINE CELL NAME 'F2_VALMERC'		OF oSection2 TITLE 'Vlr. s/ IPI'	ALIAS cString SIZE 12 Picture '@E@Z 99,999.99' Align RIGHT          	 
		DEFINE CELL NAME 'E3_PORC'   		OF oSection2 TITLE 'Porcentagem'  	ALIAS cString SIZE 06 Picture '@E@Z 99.99'     Align RIGHT          	 
		DEFINE CELL NAME 'E3_COMIS'   		OF oSection2 TITLE 'Vlr. Comis.'   	ALIAS cString SIZE 12 Picture '@E@Z 99,999.99' Align RIGHT          	 
		DEFINE CELL NAME 'E3_CODCLI'  		OF oSection2 TITLE 'Cliente'       	ALIAS cString SIZE 10
		DEFINE CELL NAME 'E3_LOJA'    		OF oSection2 TITLE 'Loja'     		ALIAS cString SIZE 06
		DEFINE CELL NAME 'A1_NOME'   		OF oSection2 TITLE 'Nome Cliente' 	ALIAS cString SIZE 30 
		DEFINE CELL NAME 'E3_EMISSAO' 		OF oSection2 TITLE 'Emissใo Comissao'   	ALIAS cString SIZE 11 
		DEFINE CELL NAME 'E3_VENCTO'  		OF oSection2 TITLE 'Vencimento Comissao'    ALIAS cString SIZE 11
		DEFINE CELL NAME 'E1_EMISSAO' 		OF oSection2 TITLE 'Emissใo Titulo'   		ALIAS cString SIZE 11 
		DEFINE CELL NAME 'E1_VENCTO'  		OF oSection2 TITLE 'Vencimento Titulo'      ALIAS cString SIZE 11			   
		DEFINE CELL NAME 'E3_ORIGEM'		OF oSection2 TITLE 'Tipo' 		   	ALIAS cString SIZE 12 Block{||Ori()}
		DEFINE CELL NAME 'A1_CODCAN'		OF oSection2 TITLE 'Canal' 		   	ALIAS cString SIZE 12
		DEFINE CELL NAME 'A1_DESCCAN'		OF oSection2 TITLE 'Descri. Canal' 	ALIAS cString SIZE 30 
		
	DEFINE SECTION oSection3 OF oSection2 TITLE 'SECAOO3'
	
		DEFINE CELL NAME 'D2_ITEM'    		OF oSection3 TITLE 'Item'     		ALIAS cString SIZE 06
		DEFINE CELL NAME 'D2_COD'   		OF oSection3 TITLE 'C๓digo'    		ALIAS cString SIZE 12
		DEFINE CELL NAME 'B1_DESC'	 		OF oSection3 TITLE 'Descri็ใo'   	ALIAS cString SIZE 40 	 
		DEFINE CELL NAME 'D2_QUANT' 		OF oSection3 TITLE 'Quantidade'   	ALIAS cString SIZE 11 	
		DEFINE CELL NAME 'D2_COMIS1'   		OF oSection3 TITLE 'Comis. p/ Item'	ALIAS cString SIZE 12 Picture '@E@Z 99,999.99' Align RIGHT          	 
		
	oSection1:SetTotalInLine(.F.)
	oSection2:SetLeftMargin(10)
	oSection3:SetLeftMargin(15)
	DEFINE BREAK oBreak1 OF oSection1 WHEN oSection1:CELL('E3_VEND')    // Quebra linha por vendedor.
    DEFINE BREAK oBreak2 OF oSection1 WHEN {||(cAliasTrb)->E3_VEND+(cAliasTrb)->MES_EMISSAO}
    DEFINE FUNCTION FROM oSection2:Cell('E3_COMIS')   FUNCTION SUM BREAK oBreak1 NO END SECTION PICTURE '@E@Z 999,999.99'
    DEFINE FUNCTION FROM oSection2:Cell('F2_VALBRUT') FUNCTION SUM BREAK oBreak1 NO END SECTION PICTURE '@E@Z 999,999.99'
    DEFINE FUNCTION FROM oSection2:Cell('F2_VALMERC') FUNCTION SUM BREAK oBreak1 NO END SECTION PICTURE '@E@Z 999,999.99'
//---------------------------------------------------------------------------------------------------------------//
Else //MV_PAR == 1 - Analitico             
//---------------------------------------------------------------------------------------------------------------//
DEFINE SECTION oSection1 OF oReport TITLE 'SECAOO1'
			
		DEFINE CELL NAME 'E3_FILIAL'		OF oSection1 TITLE 'Filial'      	ALIAS cString SIZE 06 
		DEFINE CELL NAME 'E3_VEND'			OF oSection1 TITLE 'C๓d. Vend.'   	ALIAS cString SIZE 10
		DEFINE CELL NAME 'A3_NOME'			OF oSection1 TITLE 'Nome Vend.'   	ALIAS cString SIZE 30 
        DEFINE CELL NAME 'MES_EMISSAO'  	OF oSection1 TITLE 'M๊s Referente' 	ALIAS cString SIZE 11 Block{||Ref()}     
						
	DEFINE SECTION oSection2 OF oSection1 TITLE 'SECAOO2'
		
	    DEFINE CELL NAME 'E3_NUM'			OF oSection2 TITLE 'Titulo' 		ALIAS cString SIZE 15 
		DEFINE CELL NAME 'E3_SERIE'  		OF oSection2 TITLE 'Prefixo'     	ALIAS cString SIZE 06                          
		DEFINE CELL NAME 'E3_PARCELA' 		OF oSection2 TITLE 'Parcela'       	ALIAS cString SIZE 06
		DEFINE CELL NAME 'E3_PEDIDO'  		OF oSection2 TITLE 'Pedido'       	ALIAS cString SIZE 10
		DEFINE CELL NAME 'F2_VALBRUT'		OF oSection2 TITLE 'Vlr. c/ IPI'	ALIAS cString SIZE 12 Picture '@E@Z 99,999.99' Align RIGHT          	 
		DEFINE CELL NAME 'F2_VALMERC'		OF oSection2 TITLE 'Vlr. s/ IPI'	ALIAS cString SIZE 12 Picture '@E@Z 99,999.99' Align RIGHT
		DEFINE CELL NAME 'E3_PORC'   		OF oSection2 TITLE 'Porcentagem' 	ALIAS cString SIZE 06 Picture '@E@Z 99.99'     Align RIGHT          	 
		DEFINE CELL NAME 'E3_COMIS'   		OF oSection2 TITLE 'Vlr. Comis.'   	ALIAS cString SIZE 12 Picture '@E@Z 99,999.99' Align RIGHT          	 	          	 
		DEFINE CELL NAME 'E3_CODCLI'  		OF oSection2 TITLE 'Cliente'       	ALIAS cString SIZE 10
		DEFINE CELL NAME 'E3_LOJA'    		OF oSection2 TITLE 'Loja'     		ALIAS cString SIZE 06
		DEFINE CELL NAME 'A1_NOME'   		OF oSection2 TITLE 'Nome Cliente' 	ALIAS cString SIZE 30 
		DEFINE CELL NAME 'E3_EMISSAO' 		OF oSection2 TITLE 'Emissใo Comissao'       ALIAS cString SIZE 11 
		DEFINE CELL NAME 'E3_VENCTO'  		OF oSection2 TITLE 'Vencimento Comissao'    ALIAS cString SIZE 11
		DEFINE CELL NAME 'E1_EMISSAO' 		OF oSection2 TITLE 'Emissใo Titulo'   		ALIAS cString SIZE 11 
		DEFINE CELL NAME 'E1_VENCTO'  		OF oSection2 TITLE 'Vencimento Titulo'      ALIAS cString SIZE 11 					     	
		DEFINE CELL NAME 'E3_ORIGEM'		OF oSection2 TITLE 'Tipo' 		   	ALIAS cString SIZE 12 Block{||Ori()}
		DEFINE CELL NAME 'A1_CODCAN'		OF oSection2 TITLE 'Canal' 		   	ALIAS cString SIZE 12
		DEFINE CELL NAME 'A1_DESCCAN'		OF oSection2 TITLE 'Descri. Canal' 	ALIAS cString SIZE 30 
	
	oSection2:SetLeftMargin(10)	
	oSection1:SetTotalInLine(.F.)
	DEFINE BREAK oBreak1 OF oSection1 WHEN oSection1:CELL('E3_VEND')    // Quebra linha por vendedor.
    DEFINE BREAK oBreak2 OF oSection1 WHEN {||(cAliasTrb)->E3_VEND+(cAliasTrb)->MES_EMISSAO}
    DEFINE FUNCTION FROM oSection2:Cell('E3_COMIS')   FUNCTION SUM BREAK oBreak1 NO END SECTION PICTURE '@E@Z 999,999.99'
    DEFINE FUNCTION FROM oSection2:Cell('F2_VALBRUT') FUNCTION SUM BREAK oBreak1 NO END SECTION PICTURE '@E@Z 999,999.99'
    DEFINE FUNCTION FROM oSection2:Cell('F2_VALMERC') FUNCTION SUM BREAK oBreak1 NO END SECTION PICTURE '@E@Z 999,999.99'
//---------------------------------------------------------------------------------------------------------------//
Endif
					
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
Local oSection2	:= oReport:Section(1):Section(1)
Local oSection3	:= oReport:Section(1):Section(1):Section(1)

oSection1:BeginQuery()
		BeginSql Alias cAliasTrb
			Column E3_EMISSAO  AS DATE 
			Column E3_DATA     AS DATE 
			Column E3_VENCTO   AS DATE
			Column E1_VENCTO   AS DATE
			Column E1_EMISSAO  AS DATE
			SELECT  E3_FILIAL  , E3_VEND    , E3_NUM    , E3_EMISSAO , E3_SERIE   , E3_CODCLI  , E3_LOJA   , 
					E3_BASE    , E3_PORC    , E3_COMIS  , E3_DATA    , E3_PREFIXO , E3_PARCELA , E3_TIPO   , 
					E3_BAIEMI  , E3_PEDIDO  , E3_AJUSTE , E3_SEQ     , E3_VENCTO  , E3_SEQ     , E3_ORIGEM , 
					E3_DEBITO  , E3_CCD     , E3_ITEMD  , E3_CLVLDB  , E3_CREDIT  , E3_CCC     , E3_ITEMC  , 
					E3_CLVLCR  , A3_COD     , A3_NOME   , A1_COD     , A1_LOJA    , A1_NOME    , Substring(E3_EMISSAO,5,2) MES_EMISSAO,
					F2_VALBRUT , F2_VALMERC , F2_DOC    , D2_ITEM    , D2_DOC     , D2_COD     , D2_QUANT   , B1_DESC, A1_CODCAN, 
					A1_DESCCAN , D2_COMIS1  , F2_EMISSAO, E1_NUM     , E1_EMISSAO , E1_VENCTO
			FROM %table:SE3% SE3, %table:SA3% SA3, %table:SA1% SA1, %table:SF2% SF2, %table:SD2% SD2, %table:SB1% SB1, %table:SE1% SE1
			WHERE   
						SE3.D_E_L_E_T_      <> '*'
			        AND SA3.D_E_L_E_T_  	<> '*'
			        AND SA1.D_E_L_E_T_  	<> '*'
			        AND SF2.D_E_L_E_T_  	<> '*'
			        AND SD2.D_E_L_E_T_  	<> '*'
			        AND SB1.D_E_L_E_T_  	<> '*'
			        AND SE1.D_E_L_E_T_  	<> '*'
			        AND SE3.E3_VEND    		= A3_COD
					AND SE3.E3_CODCLI   	= A1_COD
					AND SE3.E3_LOJA     	= A1_LOJA
					AND SE3.E3_NUM	     	= F2_DOC
					AND SF2.F2_DOC	     	= D2_DOC
					AND SD2.D2_COD	     	= B1_COD					
					AND SF2.F2_DOC     		= E1_NUM
					AND SF2.F2_SERIE   		= E1_PREFIXO
					AND SF2.F2_FILIAL  		= E1_FILIAL
					AND	SE3.E3_FILIAL 		>= %exp:mv_par02%
					AND SE3.E3_FILIAL 		<= %exp:mv_par03%
					AND SE3.E3_EMISSAO 		>= %exp:DTOS(mv_par04)%
					AND SE3.E3_EMISSAO 		<= %exp:DTOS(mv_par05)%
					AND SE3.E3_VENCTO 		>= %exp:DTOS(mv_par06)%
					AND SE3.E3_VENCTO 		<= %exp:DTOS(mv_par07)%
					AND SE3.E3_VEND 		>= %exp:mv_par08%
					AND SE3.E3_VEND 		<= %exp:mv_par09%
					AND SA1.A1_COD 			>= %exp:mv_par10%
					AND SA1.A1_COD 			<= %exp:mv_par11%
					AND SA1.A1_CODCAN		>= %exp:mv_par12%
					AND SA1.A1_CODCAN		<= %exp:mv_par13%
					AND SE3.E3_DATA          = ' '
			ORDER BY 
					E3_VEND, E3_VENCTO, E3_NUM, SE3.R_E_C_N_O_
		EndSql 
		oSection1:EndQuery()
		oSection2:SetParentQuery()
		oSection2:SetParentFilter({|cParam| (cAliasTrb)->A3_COD == cParam},{|| (cAliasTrb)->E3_VEND})  
		If MV_PAR01 == 1
			oSection3:SetParentQuery()
			oSection3:SetParentFilter({|cParam| (cAliasTrb)->E3_NUM == cParam},{|| (cAliasTrb)->F2_DOC})  
		Endif
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
Static Function RunReport1( oReport )

Local oSection1 := oReport:Section(1)  // Define a secao 1 do relatorio
Local oSection2	:= oReport:Section(1):Section(1)

oSection1:BeginQuery()
		BeginSql Alias cAliasTrb
			Column E3_EMISSAO  AS DATE 
			Column E3_DATA     AS DATE 
			Column E3_VENCTO   AS DATE
			Column E1_VENCTO   AS DATE
			Column E1_EMISSAO  AS DATE
			SELECT  E3_FILIAL  , E3_VEND    , E3_NUM    , E3_EMISSAO , E3_SERIE    , E3_CODCLI  , E3_LOJA   , 
					E3_BASE    , E3_PORC    , E3_COMIS  , E3_DATA    , E3_PREFIXO  , E3_PARCELA , E3_TIPO   , 
					E3_BAIEMI  , E3_PEDIDO  , E3_AJUSTE , E3_SEQ     , E3_VENCTO   , E3_SEQ     , E3_ORIGEM , 
					E3_DEBITO  , E3_CCD     , E3_ITEMD  , E3_CLVLDB  , E3_CREDIT   , E3_CCC     , E3_ITEMC  , 
					E3_CLVLCR  , A3_COD     , A3_NOME   , A1_COD     , A1_LOJA     , A1_NOME    , Substring(E3_EMISSAO,5,2) MES_EMISSAO,
					F2_VALBRUT , F2_VALMERC , F2_DOC    , A1_CODCAN  , A1_DESCCAN  , F2_EMISSAO , E1_NUM    , E1_EMISSAO , E1_VENCTO
			FROM %table:SE3% SE3, %table:SA3% SA3, %table:SA1% SA1, %table:SF2% SF2, %table:SE1% SE1
			WHERE   
						SE3.D_E_L_E_T_      <> '*'
			        AND SA3.D_E_L_E_T_  	<> '*'
			        AND SA1.D_E_L_E_T_  	<> '*'
			        AND SF2.D_E_L_E_T_  	<> '*'
			        AND SE3.E3_VEND    		= A3_COD
					AND SE3.E3_CODCLI   	= A1_COD
					AND SE3.E3_LOJA     	= A1_LOJA
					AND SE3.E3_NUM	     	= F2_DOC
					AND SE3.E3_NUM	     	= F2_DOC
					AND SF2.F2_DOC     		= E1_NUM
					AND SF2.F2_SERIE   		= E1_PREFIXO
					AND SF2.F2_FILIAL  		= E1_FILIAL
					AND	SE3.E3_FILIAL 		>= %exp:mv_par02%
					AND SE3.E3_FILIAL 		<= %exp:mv_par03%
					AND SE3.E3_EMISSAO 		>= %exp:DTOS(mv_par04)%
					AND SE3.E3_EMISSAO 		<= %exp:DTOS(mv_par05)%
					AND SE3.E3_VENCTO 		>= %exp:DTOS(mv_par06)%
					AND SE3.E3_VENCTO 		<= %exp:DTOS(mv_par07)%
					AND SE3.E3_VEND 		>= %exp:mv_par08%
					AND SE3.E3_VEND 		<= %exp:mv_par09%
					AND SA1.A1_COD 			>= %exp:mv_par10%
					AND SA1.A1_COD 			<= %exp:mv_par11%
					AND SA1.A1_CODCAN		>= %exp:mv_par12%
					AND SA1.A1_CODCAN		<= %exp:mv_par13%
					AND SE3.E3_DATA          = ' '
			ORDER BY 
					E3_VEND, E3_VENCTO, E3_NUM, SE3.R_E_C_N_O_
		EndSql 
		oSection1:EndQuery()
		oSection2:SetParentQuery()
		oSection2:SetParentFilter({|cParam| (cAliasTrb)->A3_COD == cParam},{|| (cAliasTrb)->E3_VEND})  
oSection1:Print()

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณFuncao   ณ Ori     ณ Autor ณ Microsiga          ณData ณ 26/10/10 ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescricaoณ Trata o campo E3_ORIGEM                               ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑบUso      ณ TAIFF                                                 ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function Ori()

Local cOrigem := ''

If Alltrim(E3_ORIGEM) == 'E'
	cOrigem := 'Emissใo'
Elseif Alltrim(E3_ORIGEM) == 'B'  
	cOrigem := 'Baixa'          
Elseif Alltrim(E3_ORIGEM) == 'F'  
	cOrigem := 'Faturamento'
Elseif Alltrim(E3_ORIGEM) == 'D'  
	cOrigem := 'Dev. de Venda'
Elseif Alltrim(E3_ORIGEM) == 'R'  
	cOrigem := 'Recalculo'
Elseif Alltrim(E3_ORIGEM) == 'L'  
	cOrigem := 'Loja'
Endif

Return ( cOrigem )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณFuncao   ณ Ref     ณ Autor ณ Microsiga          ณData ณ 26/10/10 ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescricaoณ Trata a quebra por Mes.                               ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑบUso      ณ TAIFF                                                 ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function Ref()

Local cMes 	:= ''

If Alltrim(MES_EMISSAO) == '01'
	cMes := 'Janeiro'
Elseif Alltrim(MES_EMISSAO) == '02'  
	cMes := 'Fevereiro'          
Elseif Alltrim(MES_EMISSAO) == '03'  
	cMes := 'Mar็o'
Elseif Alltrim(MES_EMISSAO) == '04'  
	cMes := 'Abril'
Elseif Alltrim(MES_EMISSAO) == '05'  
	cMes := 'Maio'
Elseif Alltrim(MES_EMISSAO) == '06'  
	cMes := 'Junho'
Elseif Alltrim(MES_EMISSAO) == '07'  
	cMes := 'Julho'
Elseif Alltrim(MES_EMISSAO) == '08'  
	cMes := 'Agosto'
Elseif Alltrim(MES_EMISSAO) == '09'  
	cMes := 'Setembro'
Elseif Alltrim(MES_EMISSAO) == '10'  
	cMes := 'Outubro'          
Elseif Alltrim(MES_EMISSAO) == '11'  
	cMes := 'Novembro'
Elseif Alltrim(MES_EMISSAO) == '12'  
	cMes := 'Dezembro'
Endif

Return ( cMes )

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

PutSx1(cPerg,"04","Data Emissใo de (Comissao)? ","","","mv_ch4","D",08,0,0,"G","","",,,"MV_PAR04")

//---------------------------------------MV_PAR05-------------------------------------------------- 
aHelpPor := {'Data Emissใo ate?'}
aHelpEng := {''}
aHelpSpa := {''}

PutSx1(cPerg,"05","Data Emissใo ate (Comissao)? ","","","mv_ch5","D",08,0,0,"G","","",,,"MV_PAR05")

//---------------------------------------MV_PAR06-------------------------------------------------- 
aHelpPor := {'Data Vencimento de?'}
aHelpEng := {''}
aHelpSpa := {''}

PutSx1(cPerg,"06","Data Vencimento de (Comissao)? ","","","mv_ch6","D",08,0,0,"G","","",,,"MV_PAR06")

//---------------------------------------MV_PAR07-------------------------------------------------- 
aHelpPor := {'Data Vecnimento ate?'}
aHelpEng := {''}
aHelpSpa := {''}

PutSx1(cPerg,"07","Data Vecnimento ate (Comissao)? ","","","mv_ch7","D",08,0,0,"G","","",,,"MV_PAR07")

//---------------------------------------MV_PAR08-------------------------------------------------- 
aHelpPor := {'Vendedor de?'}
aHelpEng := {''}
aHelpSpa := {''}

PutSx1(cPerg,"08","Vendedor de?     ","","","mv_ch8","C",06,0,0,"G","","SA3",,,"MV_PAR08")

//---------------------------------------MV_PAR09-------------------------------------------------- 
aHelpPor := {'Vendedor ate?'}
aHelpEng := {''}
aHelpSpa := {''}

PutSx1(cPerg,"09","Vendedor ate?    ","","","mv_ch9","C",06,0,0,"G","","SA3",,,"MV_PAR09")

//---------------------------------------MV_PAR10-------------------------------------------------- 
aHelpPor := {'Cliente de?'}
aHelpEng := {''}
aHelpSpa := {''}

PutSx1(cPerg,"10","Cliente de?     ","","","mv_ch10","C",06,0,0,"G","","SA1",,,"MV_PAR10")

//---------------------------------------MV_PAR11-------------------------------------------------- 
aHelpPor := {'Cliente ate?'}
aHelpEng := {''}
aHelpSpa := {''}

PutSx1(cPerg,"11","Cliente ate?    ","","","mv_ch11","C",06,0,0,"G","","SA1",,,"MV_PAR11")
//---------------------------------------MV_PAR12-------------------------------------------------- 
aHelpPor := {'Canal de?'}
aHelpEng := {''}
aHelpSpa := {''}

PutSx1(cPerg,"12","C๓d. Canal de?     ","","","mv_ch12","C",06,0,0,"G","","ZA8",,,"MV_PAR12")

//---------------------------------------MV_PAR13-------------------------------------------------- 
aHelpPor := {'Canal ate?'}
aHelpEng := {''}
aHelpSpa := {''}

PutSx1(cPerg,"13","C๓d. Canal ate?    ","","","mv_ch13","C",06,0,0,"G","","ZA8",,,"MV_PAR13")

//------------------------------------------------------------------------------------------------- 

RestArea(aAreaAnt)

Return()
