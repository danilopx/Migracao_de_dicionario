// #########################################################################################
// Projeto:
// Modulo :
// Fonte  : new_source14.prw
// -----------+-------------------+---------------------------------------------------------
// Data       | Autor             | Descricao
// -----------+-------------------+---------------------------------------------------------
// 17/10/2016 | pbindo            | Gerado com auxílio do Assistente de Código do TDS.
// -----------+-------------------+---------------------------------------------------------

#include "protheus.ch"
#include "vkey.ch"
#include "TbiConn.ch"
#include "TbiCode.ch"
//------------------------------------------------------------------------------------------
/*/{Protheus.doc} new_source14
EFETUA LIBERACAO DE ORÇAMENTOS VIA JOB

@author    pbindo
@version   11.3.2.201607211753
@since     17 /10/2016
/*/
//------------------------------------------------------------------------------------------
user function FATMI007(cEmpSch,cFilialSch,cMarcaSch,cClasseSch)
	Local aArea     := GetArea()

	Local cAliasSCJ := "SCJ"

	Local cQuery    := ""
	Local lQuery    := .F.
	Local lBaixa    := .T. 
	Local lMTA416BX := ExistBlock( "MTA416BX" )

	Local aStruSCJ  := {} 
	Local nLoop     := 0 	               
	Local lImporta	:= .T.
	Local cHoraProc:=""

	//DEFAULT aEmpresas	:= {{"03","01",1},{"03","02",1}}
	
	//VERIFICA SE ESTA SENDO EXECUTADO VIA MENU OU SCHEDULE
	If Select("SX6") == 0 

		RPCSetType(3)  // Nao utilizar licenca
		PREPARE ENVIRONMENT EMPRESA cEmpSch FILIAL cFilialSch MODULO "FAT"
		lImporta := Iif(GetMV("MV__FTMI07")=="N",.F.,.T.) //VERIFICA SE A ROTINA ESTA SENDO UTILIZADA
		If lImporta
			cEmail := "grp_sistemas@taiff.com.br"
			U_2EnvMail("workflow@taiff.com.br", RTrim(cEmail) ,""," *** ATENCAO *** revisar parametro MV__FTMI07" , "Importação automatica " + PROCNAME() ,'')
		Else		
			PutMv("MV__FTMI07","S")


			titulo      	:= "Efetivação Orçamento Empresa "+AllTrim(SM0->M0_NOME)+"/"+ALLTRIM(SM0->M0_FILIAL) + " da Marca: " + cMarcaSch
			If cClasseSch = "A"
				titulo +=" - ASTEC "
				cEmail := 'bruna.cavalcante@taiff.com.br;geovana.silva@taiff.com.br;layane.ferreira@taiff.com.br;jacqueline.teles@taiff.com.br'
				//cEmail := 'carlos.torres@taiffproart.com.br;assistenciatecnica@taiff.com.br'
			Else
				cEmail := 'grp_vendas@taiff.com.br'
				//cEmail := 'carlos.torres@taiffproart.com.br'
			EndIf

			//U_2EnvMail('pedidos@actionmotors.com.br',RTrim(cEmail)	,'',''	,titulo+'Inicio em '+Dtoc(Date())+"-"+Time()	,'')

			cHoraProc := " Inicio " + Time()


			Pergunte("MT416A",.F.)
			mv_par01 := ""
			mv_par02 := "ZZZZZZ"
			mv_par03 := dDataBase-120
			mv_par04 := dDataBase
			mv_par05 := 1

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ mv_par01 Orcamento de       ?                                 ³
			//³ mv_par02 Orcamento ate      ?                                 ³
			//³ mv_par03 Emissao de         ?                                 ³
			//³ mv_par04 Emissao ate        ?                                 ³
			//³ mv_par05 Libera PV          ?                                 ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Monta aHeader do SC6                                 ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			aHeadC6 := {}
			dbSelectArea("SX3")
			dbSetOrder(1)
			MsSeek("SC6",.T.)
			While ( !Eof() .And. (SX3->X3_ARQUIVO == "SC6") )
				If (  ((X3Uso(SX3->X3_USADO) .And. ;
				!( Trim(SX3->X3_CAMPO) == "C6_NUM" ) .And.;
				Trim(SX3->X3_CAMPO) != "C6_QTDEMP"  .And.;
				Trim(SX3->X3_CAMPO) != "C6_QTDENT") .And.;
				cNivel >= SX3->X3_NIVEL) .Or.;
				Trim(SX3->X3_CAMPO)=="C6_NUMORC" .Or. ;
				Trim(SX3->X3_CAMPO)=="C6_NUMOP"  .Or. ;
				Trim(SX3->X3_CAMPO)=="C6_ITEMOP" .Or. ;
				Trim(SX3->X3_CAMPO)=="C6_OP" .Or. ;
				Trim(SX3->X3_CAMPO)=="C6_OPC" )	
					Aadd(aHeadC6,{TRIM(X3Titulo()),;
					SX3->X3_CAMPO,;
					SX3->X3_PICTURE,;
					SX3->X3_TAMANHO,;
					SX3->X3_DECIMAL,;
					If(Trim(SX3->X3_CAMPO)=="C6_NUMORC",".F.",SX3->X3_VALID),;
					SX3->X3_USADO,;
					SX3->X3_TIPO,;
					SX3->X3_ARQUIVO,;
					SX3->X3_CONTEXT } )
				EndIf
				dbSelectArea("SX3")
				dbSkip()
			EndDo
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Monta aHeader do SD4                                 ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			dbSelectArea("SX3")
			dbSetOrder(1)
			MsSeek("SD4")
			aHeadD4 :={}
			While ( !Eof() .And. SX3->X3_ARQUIVO == "SD4" )
				If ( X3Uso(SX3->X3_USADO) .And. cNivel >= SX3->X3_NIVEL )
					Aadd(aHeadD4,{ Trim(X3Titulo()),;
					SX3->X3_CAMPO,;
					SX3->X3_PICTURE,;
					SX3->X3_TAMANHO,;
					SX3->X3_DECIMAL,;
					SX3->X3_VALID,;
					SX3->X3_USADO,;
					SX3->X3_TIPO,;
					SX3->X3_ARQUIVO,;
					SX3->X3_CONTEXT })
				EndIf
				dbSelectArea("SX3")
				dbSkip()
			EndDo


			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Selecao dos orcamentos a serem baixados                      ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			dbSelectArea("SCJ")
			dbSetOrder(1)
			lQuery    := .T.
			cAliasSCJ := "MA416PROC"

			If lMTA416BX                           
				cQuery := "SELECT * "	
			Else
				cQuery := "SELECT  CJ_FILIAL,CJ_NUM "
			EndIf 	

			cQuery += "FROM "+RetSqlName("SCJ")+" SCJ "
			cQuery += "WHERE SCJ.CJ_FILIAL='"+xFilial("SCJ")+"' AND "
			cQuery += "SCJ.CJ_NUM >= '"+MV_PAR01+"' AND "
			cQuery += "SCJ.CJ_NUM <= '"+MV_PAR02+"' AND "
			cQuery += "SCJ.CJ_EMISSAO >= '"+Dtos(MV_PAR03)+"' AND "
			cQuery += "SCJ.CJ_EMISSAO <= '"+Dtos(MV_PAR04)+"' AND "	
			If SuperGetMV("MV_ORCCOT")
				cQuery += "SCJ.CJ_COTCLI='"+Space(Len(SCJ->CJ_COTCLI))+"' AND "
			EndIf
			cQuery += "SCJ.CJ_STATUS='A' AND "
			cQuery += "SCJ.D_E_L_E_T_=' ' AND "
			cQuery += "SCJ.CJ_XITEMC = '" + cMarcaSch + "' "
			If !Empty(cClasseSch)
				cQuery += "AND SCJ.CJ_XCLASPD = '" + cClasseSch + "' "
			Else
				cQuery += "AND SCJ.CJ_XCLASPD != 'A' "
			EndIf				
			cQuery += "ORDER BY CJ_XITEMC DESC"

			//MemoWrite("FATMI007.SQL",cQuery)

			dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSCJ,.T.,.T.)

			If lMTA416BX 
				aStruSCJ := SCJ->( dbStruct() ) 
				For nLoop := 1 To Len( aStruSCJ ) 
					If aStruSCJ[ nLoop, 2 ] <> "C" 
						TcSetField( cAliasSCJ, aStruSCJ[ nLoop, 1 ],aStruSCJ[ nLoop, 2 ],aStruSCJ[ nLoop, 3 ],aStruSCJ[ nLoop, 4 ])
					EndIf 		
				Next nLoop
			EndIf 	 	

			dbSelectArea(cAliasSCJ)
			ProcRegua(SCJ->(LastRec()))
			While ( !Eof() .And. (cAliasSCJ)->CJ_FILIAL == xFilial("SCJ") )

				lBaixa := .T. 
				If lMTA416BX 
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Ponto de entrada para selecionar os itens a serem baixados   ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					lBaixa := ExecBlock( "MTA416BX", .F., .F., { cAliasSCJ } )
				EndIf 	

				If lBaixa	
					MaBxOrc((cAliasSCJ)->CJ_NUM,.F.,.F.,.T.,.F.,aHeadC6,aHeadD4,MV_PAR05==1)
					FreeUsedCode(.T.)
				EndIf 		

				IncProc()

				dbSelectArea(cAliasSCJ)
				dbSkip()
			EndDo
			If lQuery
				dbSelectArea(cAliasSCJ)
				dbCloseArea()
				dbSelectArea("SCJ")
			EndIf
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Restaura a integridade da rotina                             ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			cHoraProc += " Termino " + Time()
			
			U_2EnvMail('pedidos@actionmotors.com.br',RTrim(cEmail)	,'',''	,titulo + ' em '+Dtoc(Date()) + cHoraProc	,'')
			RestArea(aArea)
			PutMv("MV__FTMI07","N")
		EndIf
		RESET ENVIRONMENT

	EndIf
return
