#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPROGRAMA ณALTPERCPER  บAUTOR  ณ GILBERTO RIBEIRO JRบ Data ณ  29/06/12  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDESC.    ณ ALTERAR O PERCENTUAL DE PERDA DOS PRODUTOS PARA O MRP       บฑฑ
ฑฑบ         ณ                                                             บฑฑ
ฑฑบCHAMADA: U_ALTPERCPER()																  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function ALTPERCPER()

	Local cPerg := "ALTPERCPER"
	Local cTemp := CriaTrab(Nil,.f.)     
	Local _cSQL  := ""
	Local cTipos := ""
	
	PutSX1( cPerg, "01","Produto de?","Produto de?   ","Produto de?   ","mv_ch1","C",09,0,0,"G","","","","","mv_par01"," "," "," ",""," "," "," "," "," "," "," "," "," ","","","")
	PutSX1( cPerg, "02","Produto at้?","Produto at้?","Produto at้?","mv_ch2","C",09,0,0,"G","","","","","mv_par02"," "," "," ",""," "," "," "," "," "," "," "," "," ","","","")
  
	PutSX1( cPerg, "03","Tipos?","Tipos?","Tipos?","mv_ch3","C",20,0,0,"G","","","","","mv_par03"," "," "," ",""," "," "," "," "," "," "," "," "," ","","","") 
	PutSX1( cPerg, "04","%Perda?","%Perda?","%Perda?","mv_ch4","N",01,0,0,"G","","","","","mv_par04"," "," "," ",""," "," "," "," "," "," "," "," "," ","","","")

	PutSX1( cPerg, "05","Excluir PMPs antigos?","Exclui PMPs antigos?","Exclui PMPs antigos?","mv_ch5","N",01,0,0,"C","","","","","mv_par05","Sim","Sim","Sim","","Nao","Nao","Nao"," "," "," "," "," "," ","","","")
		
		
	If Pergunte(cPerg,.t.)
	     
		_cSQL := "UPDATE SG1 SET "
		_cSQL += "	SG1.G1_PERDA = " + ALLTRIM(STR(MV_PAR04)) + " "
		_cSQL += "FROM " + RetSQLName("SG1") + " SG1 "
		_cSQL += "JOIN " + RetSQLName("SB1") + " SB1 "
		_cSQL += "	ON SG1.G1_COMP = SB1.B1_COD " 
		_cSQL += "WHERE B1_TIPO IN (SELECT ITEM FROM FNSPLIT('"  + ALLTRIM(MV_PAR03) + "', ',')) "  
		_cSQL += "  AND SB1.B1_COD BETWEEN '" + ALLTRIM(MV_PAR01) + "' AND '" + ALLTRIM(MV_PAR02) + "' "
		_cSQL += "  AND SB1.B1_FILIAL = '" + xFilial("SB1") + "' "
		_cSQL += "  AND SG1.G1_FILIAL = '" + xFilial("SG1") + "' "
		_cSQL += "  AND SG1.D_E_L_E_T_ = '' "		
		_cSQL += "  AND SB1.D_E_L_E_T_ = '' "		
	  	 
	  	TCSQLExec(_cSQL)
				             
		//VERIFICA SE TEM A NECESSIDADE DE EXCLUIR PLANOS MESTRES ANTIGOS
		If (MV_PAR05 = 1)         
			_cSQL := "UPDATE SHC SET "
			_cSQL += "	SHC.D_E_L_E_T_ = '*' "
			_cSQL += "FROM " + RetSQLName("SHC") + " SHC "
			_cSQL += "WHERE SHC.HC_FILIAL = '" + xFilial("SHC") + "' "
			_cSQL += "  AND SHC.D_E_L_E_T_ = '' "		
		  	 
		  	TCSQLExec(_cSQL)
				
		EndIf		 
				 
		MSGINFO("Rotina finalizada com sucesso!!!.", "Atualiza % Perda")	

	EndIf

Return .T.