#INCLUDE "Protheus.ch"
#INCLUDE "Topconn.ch"
#INCLUDE "TBICONN.ch"
#INCLUDE "REPORT.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTAIFFR2   บ Autor ณ Microsiga          บ Data ณ  29/10/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Relatario de conferencia de comissoes Devidas do Mes.      บฑฑ
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
User Function TAIFFR2()
                       
Private cAliasTrb	:= GetNextAlias()
Private cPerg     	:= 'TAIFFR2'
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
                 
Local oBreak
Local oSection1
Local oSection2

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณCriacao dos componentes de impressao                                    ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
IF MV_PAR09 == 1
	oReport := TReport():New('TAIFFR2','Relat๓rio de confer๊ncia de comiss๕es - Comiss๕es Liquidadas:',cPerg, {|oReport| RunReport( oReport )}, 'Confer๊ncia de Comiss๕es LOQUIDADAS')
Else
	oReport := TReport():New('TAIFFR2','Relat๓rio de confer๊ncia de comiss๕es - Comiss๕es Devidas:',cPerg, {|oReport| RunReport( oReport )}, 'Confer๊ncia de Comiss๕es DEVIDAS')
Endif	

oReport:SetLandscape(.T.) 

//---------------------------------------------------------------------------------------------------------------//
	DEFINE SECTION oSection1 OF oReport TITLE 'SECAOO1'

		DEFINE CELL NAME 'E3_FILIAL'	OF oSection1 TITLE 'Filial'     	ALIAS cString SIZE 10 
	    DEFINE CELL NAME 'E3_VEND'		OF oSection1 TITLE 'C๓d. Vend.'   	ALIAS cString SIZE 15
	    DEFINE CELL NAME 'A3_NOME'		OF oSection1 TITLE 'Nome Vend.'   	ALIAS cString SIZE 30
	
	DEFINE SECTION oSection2 OF oSection1 TITLE 'SECAOO2'

		DEFINE CELL NAME 'E3_NUM'		OF oSection2 TITLE 'Titulo' 		ALIAS cString SIZE 12 
		DEFINE CELL NAME 'E3_SERIE'  	OF oSection2 TITLE 'Prefixo'    	ALIAS cString SIZE 10                          
		DEFINE CELL NAME 'E3_PARCELA' 	OF oSection2 TITLE 'Parcela'      	ALIAS cString SIZE 10
		DEFINE CELL NAME 'F2_VALBRUT'	OF oSection2 TITLE 'Vlr. c/ IPI'	ALIAS cString SIZE 12 Picture '@E@Z 99,999.99' Align RIGHT          	 
		DEFINE CELL NAME 'F2_VALMERC'	OF oSection2 TITLE 'Vlr. s/ IPI'	ALIAS cString SIZE 12 Picture '@E@Z 99,999.99' Align RIGHT          	 
		DEFINE CELL NAME 'E3_CODCLI' 	OF oSection2 TITLE 'Cliente'       	ALIAS cString SIZE 15
		DEFINE CELL NAME 'E3_LOJA'    	OF oSection2 TITLE 'Loja'     		ALIAS cString SIZE 10
		DEFINE CELL NAME 'A1_NOME'   	OF oSection2 TITLE 'Nome Cliente' 	ALIAS cString SIZE 30 
		DEFINE CELL NAME 'E3_EMISSAO' 	OF oSection2 TITLE 'Emissใo Comissao'       ALIAS cString SIZE 11 
		DEFINE CELL NAME 'E3_VENCTO'  	OF oSection2 TITLE 'Vencimento Comissao'    ALIAS cString SIZE 11
		DEFINE CELL NAME 'E1_EMISSAO' 	OF oSection2 TITLE 'Emissใo Titulo'   		ALIAS cString SIZE 11 
		DEFINE CELL NAME 'E1_VENCTO'  	OF oSection2 TITLE 'Vencimento Titulo'      ALIAS cString SIZE 11 
		DEFINE CELL NAME 'E3_DATA'  	OF oSection2 TITLE 'Pago Dia' 		ALIAS cString SIZE 12 	
	   	DEFINE CELL NAME 'E3_PORC'   	OF oSection2 TITLE '%' 			  	ALIAS cString SIZE 10 Picture '@E@Z 99.99'     Align RIGHT          	 
		DEFINE CELL NAME 'E3_COMIS'  	OF oSection2 TITLE 'Vlr. Comis.'   	ALIAS cString SIZE 12 Picture '@E@Z 99,999.99' Align RIGHT          	 
		DEFINE CELL NAME 'E3_ORIGEM'	OF oSection2 TITLE 'Tipo' 			ALIAS cString SIZE 15 Block{||Ori()}
	
	oSection2:SetLeftMargin(10)
	oSection2:SetTotalInLine(.F.)
	DEFINE BREAK oBreak OF oSection1 WHEN oSection1:CELL('E3_VEND')  // Quebra linha por vendedor.
	DEFINE FUNCTION FROM oSection2:Cell('E3_COMIS') FUNCTION SUM BREAK oBreak NO END SECTION PICTURE '@E@Z 999,999.99'
//---------------------------------------------------------------------------------------------------------------//
					
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
Static Function RunReport( oReport )

Local oSection1 	:= oReport:Section(1)  // Define a secao 1 do relatorio
Local oSection2 	:= oReport:Section(1):Section(1)
Local cCond			:= Iif(MV_PAR09 == 1,"%SE3.E3_DATA <> ' '%","%SE3.E3_DATA = ' '%")

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
					E3_CLVLCR  , A3_COD     , A3_NOME   , A1_COD     , A1_LOJA     , A1_NOME    , F2_VALBRUT, 
					F2_VALMERC , F2_DOC    , A1_CODCAN  , A1_DESCCAN  , F2_EMISSAO , E1_NUM     , E1_EMISSAO , E1_VENCTO
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
					AND	SE3.E3_FILIAL 		>= %exp:mv_par01%
					AND SE3.E3_FILIAL 		<= %exp:mv_par02%
					AND SE3.E3_EMISSAO 		>= %exp:DTOS(mv_par03)%
					AND SE3.E3_EMISSAO 		<= %exp:DTOS(mv_par04)%
					AND SE3.E3_VENCTO 		>= %exp:DTOS(mv_par05)%
					AND SE3.E3_VENCTO 		<= %exp:DTOS(mv_par06)%
					AND SE3.E3_VEND 		>= %exp:mv_par07%
					AND SE3.E3_VEND 		<= %exp:mv_par08%
					AND %exp:cCond%                                                   	
			ORDER BY 
					E3_VEND, E3_EMISSAO, E3_NUM, SE3.R_E_C_N_O_
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
ฑฑณFuncao   ณ Ori     ณ Autor ณ Microsiga          ณData ณ 29/10/10 ณฑฑ
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
aHelpPor := {'Data Emissใo de ? '}
aHelpEng := {''}
aHelpSpa := {''}

PutSx1(cPerg,"03","Data Emissใo de (Comissao)? ","","","mv_ch3","D",08,0,0,"G","","",,,"MV_PAR03")

//---------------------------------------MV_PAR04-------------------------------------------------- 
aHelpPor := {'Data Emissใo ate?'}
aHelpEng := {''}
aHelpSpa := {''}

PutSx1(cPerg,"04","Data Emissใo ate (Comissao)?","","","mv_ch4","D",08,0,0,"G","","",,,"MV_PAR04")

//---------------------------------------MV_PAR05-------------------------------------------------- 
aHelpPor := {'Data Vencimento de?'}
aHelpEng := {''}
aHelpSpa := {''}

PutSx1(cPerg,"05","Data Vencimento de (Comissao)? ","","","mv_ch5","D",08,0,0,"G","","",,,"MV_PAR05")

//---------------------------------------MV_PAR06-------------------------------------------------- 
aHelpPor := {'Data Vencimento ate?'}
aHelpEng := {''}
aHelpSpa := {''}

PutSx1(cPerg,"06","Data Vencimento ate (Comissao)?","","","mv_ch6","D",08,0,0,"G","","",,,"MV_PAR06")

//---------------------------------------MV_PAR07-------------------------------------------------- 
aHelpPor := {'Vendedor de?'}
aHelpEng := {''}
aHelpSpa := {''}

PutSx1(cPerg,"07","Vendedor de?     ","","","mv_ch7","C",06,0,0,"G","","SA3",,,"MV_PAR07")

//---------------------------------------MV_PAR08-------------------------------------------------- 
aHelpPor := {'Vendedor ate?'}
aHelpEng := {''}
aHelpSpa := {''}

PutSx1(cPerg,"08","Vendedor ate?    ","","","mv_ch8","C",06,0,0,"G","","SA3",,,"MV_PAR08")

//---------------------------------------MV_PAR09-------------------------------------------------- 
aHelpPor := {'Liquidado/Devido?'}
aHelpEng := {''}
aHelpSpa := {''}

PutSx1(cPerg,"09","Liquidado / Devido? ","","","mv_ch9","C",01,0,0,"C","","","","","MV_PAR09","Liquidado","","","","Devido","","") //,"Ambos","","","","","") 

//----------------

RestArea(aAreaAnt)

Return()