#INCLUDE "Protheus.ch"
#INCLUDE "Topconn.ch"
#INCLUDE "TBICONN.ch"
#INCLUDE "REPORT.CH"   		

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTAIFFR4   บ Autor ณ Microsiga          บ Data ณ  17/02/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Relatario de Comissoes.			                          บฑฑ
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
User Function TAIFFR4()
                       
Private cAliasTrb	:= GetNextAlias()
Private cPerg     	:= 'TAIFFR4'
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
                 
Local oSection1
Local oSection2
Local __cNmRsc := GETNEWPAR("MV_TFRSCCO","")

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณCriacao dos componentes de impressao                                    ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If MV_PAR15 == 1 // Recebidas	
	oReport := TReport():New('TAIFFR4','Relat๓rio de Comiss๕es (Recebidas) ' + __cNmRsc ,cPerg, {|oReport| RunReport( oReport )}, 'Comiss๕es Recebidas') 
Elseif MV_PAR15 == 2 // Todos
	oReport := TReport():New('TAIFFR4','Relat๓rio de Comiss๕es (Todos): '               ,cPerg, {|oReport| RunReport( oReport )}, 'Comiss๕es Todos') 	 
Else // MV_PAR15 == 3 // Em aberto                                                                                                                            
	oReport := TReport():New('TAIFFR4','Relat๓rio de Comiss๕es (Em Aberto): '           ,cPerg, {|oReport| RunReport( oReport )}, 'Comiss๕es em Aberto') 	 
Endif

oReport:SetLandscape(.T.) 

//---------------------------------------------------------------------------------------------------------------//
	DEFINE SECTION oSection1 OF oReport TITLE 'SECAOO1'
			
		DEFINE CELL NAME 'F2_FILIAL'		OF oSection1 TITLE 'Filial'      		ALIAS cString SIZE 12
		DEFINE CELL NAME 'F2_VEND1'			OF oSection1 TITLE 'C๓d. Vend.'   		ALIAS cString SIZE 20
		DEFINE CELL NAME 'A3_NOME'			OF oSection1 TITLE 'Nome Vend.'   		ALIAS cString SIZE 60 
   								
	DEFINE SECTION oSection2 OF oSection1 TITLE 'SECAOO2'
		
		DEFINE CELL NAME 'F2_DOC'			OF oSection2 TITLE 'Num. NF' 			ALIAS cString SIZE 15
		DEFINE CELL NAME 'F2_SERIE'  		OF oSection2 TITLE 'Prefixo'     	ALIAS cString SIZE 09                          
		DEFINE CELL NAME 'F2_EMISSAO'  	OF oSection2 TITLE 'Emissao'    		ALIAS cString SIZE 12
		DEFINE CELL NAME 'F2_CLIENTE'  	OF oSection2 TITLE 'Cliente'     	ALIAS cString SIZE 09
		DEFINE CELL NAME 'F2_LOJA'  		OF oSection2 TITLE 'Loja'       		ALIAS cString SIZE 06		
		DEFINE CELL NAME 'A1_NREDUZ'  	OF oSection2 TITLE 'Nome'       		ALIAS cString SIZE 60		
		DEFINE CELL NAME 'F2_VALBRUT'		OF oSection2 TITLE 'Vl Bruto'			ALIAS cString SIZE 20 Picture '@E 99,999,999,999.99' ALIGN RIGHT         	 
		DEFINE CELL NAME 'F2_VALMERC'		OF oSection2 TITLE 'Vl. Liq'			ALIAS cString SIZE 20 Picture '@E 99,999,999,999.99' ALIGN RIGHT
	 	DEFINE CELL NAME 'E1_PARCELA' 	OF oSection2 TITLE 'Parcela' 			ALIAS cString SIZE 08 ALIGN RIGHT
	 	DEFINE CELL NAME 'QT_PARCELA'		OF oSection2 TITLE 'Qt.Parc'			ALIAS cString SIZE 08
		DEFINE CELL NAME 'E1_VENCREA'  	OF oSection2 TITLE 'Venc. Real'  	ALIAS cString SIZE 12					     	
		DEFINE CELL NAME 'E3_EMISSAO'		OF oSection2 TITLE 'Dt. Baixa'		ALIAS cString SIZE 12
		DEFINE CELL NAME 'E1_VALOR'  		OF oSection2 TITLE 'Valor'		  		ALIAS cString SIZE 20 Picture '@E@Z 99,999,999,999.99' ALIGN RIGHT
		DEFINE CELL NAME 'E3_BASE'  		OF oSection2 TITLE 'Vl Base'  	   ALIAS cString SIZE 20 Picture '@E@Z 99,999,999,999.99' ALIGN RIGHT
		DEFINE CELL NAME 'E3_PORC'  		OF oSection2 TITLE 'Percentual'		ALIAS cString SIZE 12 Picture '@E@Z 999.99' ALIGN RIGHT
		DEFINE CELL NAME 'E3_COMIS'   	OF oSection2 TITLE 'Comissใo'			ALIAS cString SIZE 15 Picture '@E@Z 99,999,999,999.99' ALIGN RIGHT
		
	oSection1:SetTotalInLine(.F.)
	oSection2:SetLeftMargin(5)		
	DEFINE BREAK oBreak1 OF oSection1 WHEN oSection1:CELL('F2_VEND1')    // Quebra linha por vendedor.	
	DEFINE FUNCTION FROM oSection2:Cell('E1_VALOR') FUNCTION SUM BREAK oBreak1 NO END SECTION PICTURE '@E@Z 99,999,999,999.99'
   DEFINE FUNCTION FROM oSection2:Cell('E3_BASE') 	FUNCTION SUM BREAK oBreak1 NO END SECTION PICTURE '@E@Z 99,999,999,999.99'
   DEFINE FUNCTION FROM oSection2:Cell('E3_COMIS') FUNCTION SUM BREAK oBreak1 NO END SECTION PICTURE '@E@Z 99,999,999,999.99'
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
Local _cVenFilial := xFilial("SA3")
Local _cCliFilial := xFilial("SA1")

oSection1:BeginQuery()
	BeginSql Alias cAliasTrb
		Column F2_EMISSAO  AS DATE 
		Column E1_VENCREA  AS DATE 
		Column E1_BAIXA    AS DATE 
		SELECT 
			F2_FILIAL	,
			F2_DOC		,
			F2_SERIE		,
			F2_DUPL		,
			F2_CLIENTE	,
			F2_LOJA		,
			F2_VEND1		,
			F2_EMISSAO	,
			F2_VALBRUT	,
			F2_VALMERC	,
			E1_FILIAL	, 
			E1_NUM    	,
			E1_PREFIXO 	,
			E1_PARCELA 	,
			E1_VALOR  	,
			E1_EMISSAO	,
			E1_VENCREA	,
			E1_BAIXA  	,
			E1_SALDO  	,
			E1_VALLIQ 	,  
			A1_COD   	,
			A1_NREDUZ 	,
			A1_NOME    	,
			A3_COD     	,
			A3_NOME   	,
			E3_BASE  	,
			E3_PORC   	,
			E3_COMIS   	,
			E3_EMISSAO  ,
			QT_PARCELA
		FROM
		(
		SELECT  SF2.F2_FILIAL, SF2.F2_DOC    , SF2.F2_SERIE   , SF2.F2_DUPL    , SF2.F2_CLIENTE, SF2.F2_LOJA   , SF2.F2_VEND1  , SF2.F2_EMISSAO, SF2.F2_VALBRUT, SF2.F2_VALMERC,
				SE1.E1_FILIAL, SE1.E1_NUM    , SE1.E1_PREFIXO , SE1.E1_PARCELA , SE1.E1_VALOR  , SE1.E1_EMISSAO, SE1.E1_VENCREA, SE1.E1_BAIXA  , SE1.E1_SALDO  , SE1.E1_VALLIQ ,  
				SA1.A1_COD   , SA1.A1_NREDUZ , SA1.A1_NOME    , SA3.A3_COD     , SA3.A3_NOME   ,
				SE3.E3_BASE  , SE3.E3_PORC   , SE3.E3_COMIS   , SE3.E3_EMISSAO  , 
				(ISNULL( (
					SELECT MAX(E1_PARCELA)
					FROM %table:SE1% TMP 
					WHERE SE1.E1_FILIAL=TMP.E1_FILIAL AND 
					SE1.E1_NUM=TMP.E1_NUM AND 
					SE1.E1_PREFIXO=TMP.E1_PREFIXO AND 
					SF2.F2_CLIENTE=TMP.E1_CLIENTE AND 
					SF2.F2_LOJA=TMP.E1_LOJA ) ,' ') ) AS QT_PARCELA
				
		FROM %table:SF2% SF2, %table:SE1% SE1, %table:SA1% SA1, %table:SA3% SA3, %table:SE3% SE3
		WHERE   
			     	SF2.D_E_L_E_T_  	<> '*'
				AND SE1.D_E_L_E_T_ 	 	<> '*' 
				AND SA1.D_E_L_E_T_ 	    <> '*'  
				AND SA3.D_E_L_E_T_  	<> '*' 
				AND SE3.D_E_L_E_T_  	<> '*' 
			
				AND SF2.F2_FILIAL 		= %exp:mv_par01%
				AND SA3.A3_FILIAL 		= %exp:_cVenFilial%
				AND SA1.A1_FILIAL 		= %exp:_cCliFilial%
				AND SE1.E1_FILIAL			= %exp:mv_par01% 
				AND SE3.E3_FILIAL			= %exp:mv_par01%

				AND SF2.F2_DOC 			= SE1.E1_NUM
				AND SF2.F2_SERIE			= SE1.E1_PREFIXO
				AND SF2.F2_CLIENTE		= SE1.E1_CLIENTE
				AND SF2.F2_LOJA			= SE1.E1_LOJA
				AND SF2.F2_FILIAL			= SE1.E1_FILIAL
				
				AND SF2.F2_CLIENTE  		= SA1.A1_COD
				AND SF2.F2_LOJA   		= SA1.A1_LOJA
				
				AND SF2.F2_VEND1    		= SA3.A3_COD 
				
				AND SE1.E1_NUM	  			= SE3.E3_NUM 
				AND SE1.E1_PARCELA 		= SE3.E3_PARCELA
				AND SE1.E1_CLIENTE		= SE3.E3_CODCLI
				AND SE1.E1_PREFIXO 		= SE3.E3_PREFIXO
				AND SE1.E1_FILIAL			= SE3.E3_FILIAL
				AND SE1.E1_FATURA			= ' '
				
				
				AND SF2.F2_VEND1  		>= %exp:mv_par03%
				AND SF2.F2_VEND1  		<= %exp:mv_par04%
				
				AND SE1.E1_EMISSAO 		>= %exp:DTOS(mv_par05)%
				AND SE1.E1_EMISSAO 		<= %exp:DTOS(mv_par06)%   		

				AND SE3.E3_EMISSAO 		>= %exp:DTOS(mv_par09)%
				AND SE3.E3_EMISSAO 		<= %exp:DTOS(mv_par10)%   		
						
				AND SE1.E1_VENCREA 		>= %exp:DTOS(mv_par07)%
				AND SE1.E1_VENCREA 		<= %exp:DTOS(mv_par08)%                                         	
				
				AND SA1.A1_COD 	   		>= %exp:mv_par11%
				AND SA1.A1_COD 	   		<= %exp:mv_par12%                                            	
				
				AND SE1.E1_NUM 			>= %exp:mv_par13%	
				AND SE1.E1_NUM 	   		<= %exp:mv_par14%
				
				AND SE1.E1_BAIXA    	<> ' '                                            	                                       					
		UNION ALL
				SELECT  
					SE1.E1_FILIAL	AS F2_FILIAL	, 
					SE1.E1_NUM		AS F2_DOC    	, 
					SE1.E1_PREFIXO	AS F2_SERIE   , 
					SE1.E1_NUM		AS F2_DUPL    , 
					SE1.E1_CLIENTE	AS F2_CLIENTE	, 
					SE1.E1_LOJA		AS F2_LOJA   	, 
					SE3.E3_VEND 	AS F2_VEND1  	, 
					SE1.E1_EMISSAO	AS F2_EMISSAO	, 
					(
						SELECT AUX.F2_VALBRUT FROM %table:SF2% AUX WHERE 
						AUX.F2_SERIE = (CASE SE3.E3_ITEMC WHEN 'PROART' THEN '2' ELSE '1' END) AND
						AUX.D_E_L_E_T_=' ' AND AUX.F2_FILIAL=SE3.E3_FILIAL AND AUX.F2_DOC = 
						(
							SELECT DISTINCT SE1X.E1_NUM AS E1_NUM FROM %table:SE1% SE1X WHERE
							SE1X.D_E_L_E_T_	= ' ' 
							AND SE3.E3_NUM		= SE1X.E1_FATURA
							AND SE3.E3_FILIAL	= SE1X.E1_FILIAL
							AND SE3.E3_CODCLI	= SE1X.E1_CLIENTE
							AND SE3.E3_LOJA   = SE1X.E1_LOJA
							AND SE3.E3_PARCELA	= SE1X.E1_PARCELA
						)
					) AS F2_VALBRUT, 
					(
						SELECT AUX.F2_VALMERC FROM %table:SF2% AUX WHERE 
						AUX.F2_SERIE = (CASE SE3.E3_ITEMC WHEN 'PROART' THEN '2' ELSE '1' END) AND
						AUX.D_E_L_E_T_=' ' AND AUX.F2_FILIAL=SE3.E3_FILIAL AND AUX.F2_DOC = 
						(
							SELECT DISTINCT SE1X.E1_NUM AS E1_NUM FROM %table:SE1% SE1X WHERE
							SE1X.D_E_L_E_T_	= ' ' 
							AND SE3.E3_NUM		= SE1X.E1_FATURA
							AND SE3.E3_FILIAL	= SE1X.E1_FILIAL
							AND SE3.E3_CODCLI	= SE1X.E1_CLIENTE
							AND SE3.E3_LOJA   = SE1X.E1_LOJA
							AND SE3.E3_PARCELA	= SE1X.E1_PARCELA
						)
					) AS F2_VALMERC,
				SE1.E1_FILIAL, SE1.E1_NUM    , SE1.E1_PREFIXO , SE1.E1_PARCELA , SE1.E1_VALOR  , SE1.E1_EMISSAO, SE1.E1_VENCREA, SE1.E1_BAIXA  , SE1.E1_SALDO  , SE1.E1_VALLIQ ,  
				SA1.A1_COD   , SA1.A1_NREDUZ , SA1.A1_NOME    , SA3.A3_COD     , SA3.A3_NOME   ,
				SE3.E3_BASE  , SE3.E3_PORC   , SE3.E3_COMIS   , SE3.E3_EMISSAO  , 
				(ISNULL( (
					SELECT MAX(E1_PARCELA)
					FROM %table:SE1% TMP 
					WHERE SE1.E1_FILIAL=TMP.E1_FILIAL AND 
					SE1.E1_NUM=TMP.E1_NUM AND 
					SE1.E1_PREFIXO=TMP.E1_PREFIXO AND 
					SE1.E1_CLIENTE=TMP.E1_CLIENTE AND 
					SE1.E1_LOJA=TMP.E1_LOJA ) ,' ') ) AS QT_PARCELA
				
		FROM %table:SE3% SE3, %table:SE1% SE1, %table:SA1% SA1, %table:SA3% SA3
		WHERE   
				SE3.D_E_L_E_T_ 	 	<> '*' 
				AND SE1.D_E_L_E_T_  	<> '*' 
				AND SA1.D_E_L_E_T_ 	<> '*'  
				AND SA3.D_E_L_E_T_  	<> '*' 
				
				AND SE3.E3_FILIAL 		= %exp:mv_par01%
				AND SE1.E1_FILIAL			= %exp:mv_par01% 
				AND SA3.A3_FILIAL 		= %exp:_cVenFilial%
				AND SA1.A1_FILIAL 		= %exp:_cCliFilial%

				AND SE3.E3_FILIAL			= SE1.E1_FILIAL
				AND SE3.E3_PREFIXO		= SE1.E1_PREFIXO 
				AND SE3.E3_NUM 	  		= SE1.E1_NUM
				AND SE3.E3_PARCELA 		= SE1.E1_PARCELA
				AND SE3.E3_CODCLI			= SE1.E1_CLIENTE
				AND SE3.E3_LOJA   		= SE1.E1_LOJA

				AND SE3.E3_CODCLI  		= SA1.A1_COD
				AND SE3.E3_LOJA   		= SA1.A1_LOJA

				AND SE3.E3_VEND    		= SA3.A3_COD 
				
				AND ( 
						SE1.E1_FATURA			= 'NOTFAT   '
							OR
						SE1.E1_TIPO				= 'BOL'
							OR
						SE1.E1_TIPO				= 'CH'
							OR
						SE1.E1_TIPO				= 'FI'
							OR
						SE1.E1_TIPO			= 'PRD'
							OR  
						SE1.E1_TIPO			= 'RA' 
							OR  
						(SE1.E1_TIPO			= 'NF' AND SE1.E1_PREFIXO='FIN') 
							OR  
						SE1.E1_NATUREZ	= 'NCCVP'
							OR  
						SE1.E1_NATUREZ	= 'NCCVC'
							OR  
						SE1.E1_NATUREZ	= 'NCCRI'
				    )
				
				AND SE3.E3_VEND  			>= %exp:mv_par03%
				AND SE3.E3_VEND  			<= %exp:mv_par04%
				
				AND SE1.E1_EMISSAO 		>= %exp:DTOS(mv_par05)%
				AND SE1.E1_EMISSAO 		<= %exp:DTOS(mv_par06)%   		

				AND SE3.E3_EMISSAO 		>= %exp:DTOS(mv_par09)%
				AND SE3.E3_EMISSAO 		<= %exp:DTOS(mv_par10)%   		
						
				AND SE1.E1_VENCREA 		>= %exp:DTOS(mv_par07)%
				AND SE1.E1_VENCREA 		<= %exp:DTOS(mv_par08)%                                         	
				
				AND SA1.A1_COD 	   		>= %exp:mv_par11%
				AND SA1.A1_COD 	   		<= %exp:mv_par12%                                            	
				
				AND SE1.E1_NUM 			>= %exp:mv_par13%
				AND SE1.E1_NUM 	   		<= %exp:mv_par14%
				
				AND SE1.E1_BAIXA    	<> ' '                                            	                                       					
		)	TMP
		ORDER BY F2_VEND1, E1_EMISSAO, E3_EMISSAO
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
ฑฑบPrograma  ณValComis  บ Autor ณ Microsiga          บ Data ณ  26/10/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Pega o Valor da Comissใo total da NF, conforme os itens.   บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ TAIFF                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/ /*
Static Function ValComis()

Local nValComis	 	:= 0 
Local cQuery       	:= ''
Local cDoc       	:= (cAliasTrb)->F2_DOC
Local cSerie       	:= (cAliasTrb)->F2_SERIE
Local cAliasQuery	:= GETNEXTALIAS()
                          
cQuery := " SELECT "
cQuery += " SUM(SD2.D2_COMIS1) D2_COMIS1, SD2.D2_FILIAL, SD2.D2_DOC, SD2.D2_SERIE, SD2.D2_CLIENTE, SD2.D2_LOJA " + CRLF

cQuery += " FROM " + RetSQLName("SD2") + " SD2 " + CRLF

cQuery += " WHERE " + CRLF
cQuery += "     SD2.D_E_L_E_T_ <> '*' " + CRLF
cQuery += " AND SD2.D2_DOC 	 = '" + cDoc   + "' " + CRLF
cQuery += " AND SD2.D2_SERIE = '" + cSerie + "' " + CRLF
cQuery += " GROUP BY SD2.D2_FILIAL, SD2.D2_DOC, SD2.D2_SERIE, SD2.D2_CLIENTE, SD2.D2_LOJA " 

cQuery := ChangeQuery(cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasQuery,.F.,.T.)

nValComis	:= (cAliasQuery)->D2_COMIS1

Return( nValComis )
*/
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

//---------------------------------------MV_PAR01-------------------------------------------------- OK
aHelpPor := {'Filial de?'}
aHelpEng := {''}
aHelpSpa := {''}

PutSx1(cPerg,"01","Filial de      ? ","","","mv_ch1","C",02,0,0,"G","","SM0",,,"MV_PAR01")

//---------------------------------------MV_PAR02-------------------------------------------------- OK 
aHelpPor := {'Filial ate?'}
aHelpEng := {''}
aHelpSpa := {''}

PutSx1(cPerg,"02","Filial ate     ? ","","","mv_ch2","C",02,0,0,"G","","SM0",,,"MV_PAR02")

//---------------------------------------MV_PAR03-------------------------------------------------- OK
aHelpPor := {'Vendedor de?'}
aHelpEng := {''}
aHelpSpa := {''}

PutSx1(cPerg,"03","Vendedor de?     ","","","mv_ch3","C",06,0,0,"G","","SA3",,,"MV_PAR03")

//---------------------------------------MV_PAR04-------------------------------------------------- OK
aHelpPor := {'Vendedor ate?'}
aHelpEng := {''}
aHelpSpa := {''}

PutSx1(cPerg,"04","Vendedor ate?    ","","","mv_ch4","C",06,0,0,"G","","SA3",,,"MV_PAR04")   

//---------------------------------------MV_PAR05-------------------------------------------------- OK
aHelpPor := {'Data Emissao de?'}
aHelpEng := {''}
aHelpSpa := {''}

PutSx1(cPerg,"05","Data Emissao de (Tํtulo)? ","","","mv_ch5","D",08,0,0,"G","","",,,"MV_PAR05")

//---------------------------------------MV_PAR06-------------------------------------------------- OK
aHelpPor := {'Data Emissao ate?'}
aHelpEng := {''}
aHelpSpa := {''}

PutSx1(cPerg,"06","Data Emissao ate (Tํtulo)? ","","","mv_ch6","D",08,0,0,"G","","",,,"MV_PAR06")                                                                                            

//---------------------------------------MV_PAR07-------------------------------------------------- OK
aHelpPor := {'Data Vencimento de?'}
aHelpEng := {''}
aHelpSpa := {''}

PutSx1(cPerg,"07","Data Vencimento de (Tํtulo)? ","","","mv_ch7","D",08,0,0,"G","","",,,"MV_PAR07")

//---------------------------------------MV_PAR08-------------------------------------------------- OK
aHelpPor := {'Data Vencimento ate?'}
aHelpEng := {''}
aHelpSpa := {''}

PutSx1(cPerg,"08","Data Vencimento ate (Tํtulo)? ","","","mv_ch8","D",08,0,0,"G","","",,,"MV_PAR08")
                                                                                                 
//---------------------------------------MV_PAR09-------------------------------------------------- OK
aHelpPor := {'Data Baixa de?'}
aHelpEng := {''}
aHelpSpa := {''}

PutSx1(cPerg,"09","Data Baixa de (Tํtulo)? ","","","mv_ch9","D",08,0,0,"G","","",,,"MV_PAR09")

//---------------------------------------MV_PAR10-------------------------------------------------- OK
aHelpPor := {'Data Baixa ate?'}
aHelpEng := {''}
aHelpSpa := {''}

PutSx1(cPerg,"10","Data Baixa ate (Tํtulo)? ","","","mv_ch10","D",08,0,0,"G","","",,,"MV_PAR10")

//---------------------------------------MV_PAR11-------------------------------------------------- OK
aHelpPor := {'Cliente de?'}
aHelpEng := {''}
aHelpSpa := {''}

PutSx1(cPerg,"11","Cliente de?     ","","","mv_ch11","C",06,0,0,"G","","SA1",,,"MV_PAR11")

//---------------------------------------MV_PAR12-------------------------------------------------- OK
aHelpPor := {'Cliente ate?'}
aHelpEng := {''}
aHelpSpa := {''}

PutSx1(cPerg,"12","Cliente ate?    ","","","mv_ch12","C",06,0,0,"G","","SA1",,,"MV_PAR12")

//---------------------------------------MV_PAR13-------------------------------------------------- OK
aHelpPor := {'Titulo de?'}
aHelpEng := {''}
aHelpSpa := {''}

PutSx1(cPerg,"13","Titulo de?     ","","","mv_ch13","C",09,0,0,"G","","SE1",,,"MV_PAR13")

//---------------------------------------MV_PAR14-------------------------------------------------- OK
aHelpPor := {'Titulo ate?'}
aHelpEng := {''}
aHelpSpa := {''}

PutSx1(cPerg,"14","Titulo ate?    ","","","mv_ch14","C",09,0,0,"G","","SE1",,,"MV_PAR14")  

//---------------------------------------MV_PAR15-------------------------------------------------- OK
aHelpPor := {'Tipo?'}
aHelpEng := {''}
aHelpSpa := {''}

PutSx1(cPerg,"15","Tipo ? ","","","mv_ch15"	,"C",01,0,0,"C","","","","","MV_PAR15","Recebidas","","","","Vencidas","","","A Vencer","","","","","") 

//------------------------------------------------------------------------------------------------- 

RestArea(aAreaAnt)

Return()
