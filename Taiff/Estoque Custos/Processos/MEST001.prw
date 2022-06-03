#INCLUDE "rwmake.ch"
#INCLUDE "protheus.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ MEST001  º Autor ³ AP6 IDE            º Data ³  24/01/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Endereçamentos por lote                                    º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ TAIFF                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function MEST001
Local cPerg    := "MEST001"	    

Private cIndTmp1  := "" 
Private cIndTmp2  := "" 

Private cCadastro := "Enderecamento por Lote"  
Private aRotina   := {}    
Private cDestino
Private cQuery := ""
Private cDelFunc := ".T." // Validacao para a exclusao. Pode-se utilizar ExecBlock
Private aStru := {}
Private cMarca := GetMark()
Private cTRB   
Private aCampos := {{"DA_FLAG"    ,"", ""}, ;
					{"DA_PRODUTO" ,"", "Produto"  }, ;
					{"DESCPROD"   ,"", "Desc Prod" }, ;
					{"DA_QTDORI"  ,"", "Qtd Orig",PesqPict("SDA", "DA_QTDORI")}, ;
					{"DA_DOC2"    ,"", "DOC 2"  }, ;
					{"NomeForn"    ,"", "Nome Forn"}, ;  
					{"DA_Data"    ,"", "Data" }, ;
					{"DA_DOC"     ,"", "DOC"}, ;  
					{"DA_SERIE"   ,"", "Serie"}, ;  
					{"DA_LOCAL"   ,"", "Armazen"}, ;
					{"DA_SALDO"   ,"", "Saldo",   PesqPict("SDA", "DA_SALDO")}, ; 
					{"DA_LOTECTL" ,"", "Lote"}, ;  
					{"DA_USERORI" ,"", "Usuario" }, ;
					{"DA_ORIGEM"  ,"", "Origem"} }  
					         					

//***** definindo menu    
// 1=Pesquisa 2=Visualização 3=Inclusão 4=Alteração 5=Exclusão				
aadd(aRotina, {"Pesquisar"  ,"U_MESTPESQ", 0, 1})
aadd(aRotina, {"Visualizar" ,"AxVisual"  , 0, 2})
aadd(aRotina, {"Enderecar"  ,"U_M001GRV" , 0, 4, 0 , NIL})  
aadd(aRotina, {"Filtro"     ,"U_MESTFIL" , 0, 4, 0, NIL}) 

AjustaSx1( cPerg )
if Pergunte( cPerg, .T., "Dados Origem/Destino" )
	cDestino := mv_par02                

	//***** montando query 
	/*/ 
	select SDA.*, 
	SB1.B1_DESC DESCPROD, 
	SA2.A2_Nome NomeForn
	from SDA010 SDA
	left join 
	sb1010 SB1 on SDA.DA_PRODUTO =  SB1.B1_COD
	left join 
	SA2010 SA2 on SDA.DA_CLIFOR = SA2.A2_COD AND SDA.DA_LOJA = SA2.A2_LOJA 
	where SDA.DA_LOCAL = '02'  and SDA.DA_SALDO > 0 AND
	SDA.D_E_L_E_T_ <> '*' and SB1.D_E_L_E_T_ <> '*' and SA2.D_E_L_E_T_ <> '*'
	ORDER by SDA.DA_PRODUTO 
	/*/
	
	
	/*	
	cQuery := "select DISTINCT SDA.*, "
	cQuery += "SB1.B1_DESC DESCPROD, "
	cQuery += "SA2.A2_NOME NomeForn "
	cQuery += "from " + RetSqlName("SDA") + " SDA "
	cQuery += "left join "
	cQuery += RetSqlName("SB1") + " SB1 on SDA.DA_PRODUTO = SB1.B1_COD "
	cQuery += "left join "
	cQuery += RetSqlName("SA2") + " SA2 on SDA.DA_CLIFOR =  SA2.A2_COD AND SDA.DA_LOJA = SA2.A2_LOJA "
	cQuery += "where SDA.DA_LOCAL = '" + mv_par01 + "' and SDA.DA_SALDO > 0 AND "
	cQuery += "SDA.d_e_l_e_t_ <> '*' and SB1.d_e_l_e_t_ <> '*' and SDA.d_e_l_e_t_ <> '*' "
	cQuery += "ORDER by SDA.DA_PRODUTO "
	*/

	//---------------------------------------------------------------------------------------------------------------------------
	// ID: DESENV001                                                                 Autor: Carlos Torres        Data: 12/12/2012
	// Descrição: Modificação do SCRIPT para apresentação correta do nome do cliente quando a Nf for de devolução.
	//---------------------------------------------------------------------------------------------------------------------------
	/*
	|---------------------------------------------------------------------------------
	|	Alterado a query, pois nao estava sendo realizado o filtro por Filial.
	|
	|	Edson Hornberger - 10/11/2014
	|---------------------------------------------------------------------------------
	*/
	cQuery := "select DISTINCT SDA.*, "
	cQuery += "SB1.B1_DESC DESCPROD, "
	cQuery += "("
	cQuery += "	CASE WHEN SDA.DA_TIPONF='D' "
	cQuery += "		THEN ISNULL((SELECT SA1.A1_NOME FROM " + RetSqlName("SA1") + " SA1 WITH(NOLOCK) WHERE SA1.A1_FILIAL = '" + XFILIAL("SA1") + "' AND SDA.DA_CLIFOR =  SA1.A1_COD AND SDA.DA_LOJA = SA1.A1_LOJA AND SA1.D_E_L_E_T_=' '),'') "
	cQuery += "		ELSE ISNULL((SELECT SA2.A2_NOME FROM " + RetSqlName("SA2") + " SA2 WITH(NOLOCK) WHERE SA2.A2_FILIAL = '" + XFILIAL("SA2") + "' AND SDA.DA_CLIFOR =  SA2.A2_COD AND SDA.DA_LOJA = SA2.A2_LOJA AND SA2.D_E_L_E_T_=' '),'') "
	cQuery += "	END "
	cQuery += ") AS NomeForn "
	cQuery += "from " + RetSqlName("SDA") + " SDA "
	cQuery += "left join "
	cQuery += RetSqlName("SB1") + " SB1 on SDA.DA_PRODUTO = SB1.B1_COD "
	cQuery += "where SDA.DA_FILIAL = '" + XFILIAL("SDA") + "' AND SDA.DA_LOCAL = '" + mv_par01 + "' and SDA.DA_SALDO > 0 AND "
	cQuery += "SDA.D_E_L_E_T_ <> '*' and SB1.D_E_L_E_T_ <> '*' "
	cQuery += "ORDER by SDA.DA_PRODUTO "
	//--------------------------------------------[ Termino do DESENV001 ]-------------------------------------------------------

 	//MemoWrite("c:\lixo\teste.sql",cQuery)

 	//  cQuery := ChangeQuery(cQuery)
 	
 	IF SELECT("TMP") > 0 
 		
 		DBSELECTAREA("TMP")
 		DBCLOSEAREA()
 		
 	ENDIF 

	dbUseArea( .T., 'TOPCONN', TCGENQRY(,,cQuery), 'TMP', .F., .f.)

	if !TMP->( Eof() )
		aStru := TMP->( dbstruct() )  
		aadd(aStru,{"DA_FLAG","C",2,0} ) 
		aadd(aStru,{"DA_DOC2","C",9,0} ) 
		aadd(aStru,{"DA_USERORI","C",9,0} ) 		
		cTRB := criatrab( aStru, .t. )
		
		IF SELECT("TRB") > 0 
 		
	 		DBSELECTAREA("TRB")
	 		DBCLOSEAREA()
	 		
	 	ENDIF
		   
		DbUseArea( .T.,, cTRB,"TRB", .T. , .F. )    
		
		DbSelectArea("TRB")
		MsAppend("TRB", "TMP")       

		cIndTmp1 := CriaTrab(Nil,.F.) 
		IndRegua("TRB",cIndTmp1,"DA_FILIAL+DA_PRODUTO",,.T.,"Gerando arquivo temporário")	 
		
		cIndTmp2 := CriaTrab(Nil,.F.) 
		IndRegua("TRB",cIndTmp2,"DA_FILIAL+DA_DOC",,.T.,"Gerando arquivo temporário")		 
		
		TRB->( DbClearIndex() )
		TRB->( DbSetIndex(cIndTmp1 + OrdBagExt()) )
		TRB->( DbSetIndex(cIndTmp2 + OrdBagExt()) )
		TRB->( DbSetOrder(1) )
		TRB->( DbGoTop() )              
		
		//popula o DOC 2 e usuario original
		while !TRB->( Eof() )                                   
 
			SD7->( DBSetOrder(3) )
			if SD7->( DBSeek( xFilial("SD7")+TRB->DA_PRODUTO+TRB->DA_NUMSEQ+TRB->DA_DOC ) )
				RecLock("TRB", .f.)
            	TRB->DA_DOC2 := SD7->D7_DOC
			    MsUnlock()
          	endif         
          	
			//IF(SDA->DA_ORIGEM=="SD3", FORMULA("900"), "")						
			if TRB->DA_ORIGEM == "SD3"
				RecLock("TRB", .f.)
            	TRB->DA_USERORI := upper( FORMULA("900") )
			    MsUnlock()			
			endif              	          	
          	          
			TRB->( DBSkip() )		
		enddo
        
		TRB->( DBGotop() )
		MarkBrow( "TRB", "DA_FLAG", "", aCampos , , cMarca )  
	
		TRB->( dbCloseArea() )	
	else
		alert( "Não existem registros para esse Almoxarifado: " + mv_par01)
	endif	
  
	TMP->( dbclosearea() )
endif

Return               

//------------------------------- 
//Endereça os produtos 
//by JAR in TAIFF  **  24/01/2011
//-------------------------------
user function M001GRV()
local aCabec := {}
local aItem := {} 
Local cItemDB := "001"     

lMsErroAuto := .F.                  
                    
TRB->( DBGoTop() )
while !TRB->( Eof() )
                       
	if TRB->(IsMark("DA_FLAG",cMarca) ) 
	
		cItemDB := MEST001MAX( TRB->DA_NUMSEQ )
	
		aCabec:={{"DA_PRODUTO" ,TRB->DA_PRODUTO ,Nil},;
        		 {"DA_QTDORI"  ,TRB->DA_QTDORI  ,Nil},;
				 {"DA_SALDO"   ,TRB->DA_SALDO   ,Nil},;
				 {"DA_DATA"    ,TRB->DA_DATA    ,Nil},;
				 {"DA_LOTECTL" ,TRB->DA_LOTECTL ,Nil},;
				 {"DA_NUMLOTE" ,TRB->DA_NUMLOTE ,Nil},;
				 {"DA_LOCAL"   ,TRB->DA_LOCAL   ,Nil},;
				 {"DA_DOC"     ,TRB->DA_DOC     ,Nil},;
				 {"DA_SERIE"   ,TRB->DA_SERIE   ,Nil},;
				 {"DA_CLIFOR"  ,TRB->DA_CLIFOR  ,Nil},;
				 {"DA_LOJA"    ,TRB->DA_LOJA    ,Nil},;
				 {"DA_TIPONF"  ,TRB->DA_TIPONF  ,Nil},;
				 {"DA_ORIGEM"  ,TRB->DA_ORIGEM  ,Nil},;
				 {"DA_NUMSEQ"  ,TRB->DA_NUMSEQ  ,Nil},;
				 {"DA_EMPENHO" ,TRB->DA_EMPENHO ,Nil},;
				 {"DA_QTSEGUM" ,TRB->DA_QTSEGUM ,Nil},;
				 {"DA_QTDORI2" ,TRB->DA_QTDORI2 ,Nil},;
				 {"DA_EMP2"    ,TRB->DA_EMP2    ,Nil},;
				 {"DA_REGWMS"  ,TRB->DA_REGWMS  ,Nil}}
	
		aItem := {{"DB_ITEM"   ,cItemDB        ,Nil},;
				  {"DB_LOCALIZ",cDestino       ,Nil},; 					
				  {"DB_DATA"   ,dDataBase      ,Nil},;
				  {"DB_QUANT"  ,TRB->DA_SALDO  ,Nil},;
				  {"DB_QTSEGUM",TRB->DA_QTSEGUM,Nil}}
	
            
		If Len(aCabec) > 0
			MsExecAuto({|x,y,z|MATA265(x,y,z)},aCabec, {aItem}, 3)			
			If lMsErroAuto
				MsgInfo("Nao foi possivel enderecar automaticamente o material, favor informar ao TI <MEST001> e enviar a proxima tela via email.")
				MostraErro()
				lMsErroAuto := .F.
			Endif
		EndIf
    endif

	TRB->( DbSkip() )
enddo

MarkBRefresh( )
QUIT

return       


//--------------------------------
//function: MEST001MAX
//by JAR in TAIFF
//--------------------------------
Static function MEST001MAX( cNSeq )
Local cMaxSQL  
Local cItem := "001"

cMaxSQL := "Select MAX(SDB.DB_ITEM) as MaiorNum "
cMaxSQL += "From " + RetSqlName("SDB") + " SDB "			
cMaxSQL += "Where SDB.DB_NUMSEQ = '" + cNSeq + "' and "
cMaxSQL += "SDB.D_E_L_E_T_ <> '*' "

cQuery := ChangeQuery(cQuery)
dbUseArea( .T., 'TOPCONN', TCGENQRY(,,cMaxSQL), 'TMPMAX', .F., .f.)			
		
cItem := strzero( val( TMPMAX->MaiorNum ) + 1 , 3 )
            
TMPMAX->( DBCloseArea() )

return( cItem )

               
//------------------------------- 
//Cria as perguntas  
//by JAR in TAIFF  **  24/01/2011
//-------------------------------

Static Function AjustaSx1(cPerg)

PutSx1(cPerg,"01","Local","Local","Local","mv_ch1","C",02,0,0,"G",,,,,"mv_par01",,,,,,,,,,,,,,,,,)
PutSx1(cPerg,"02","Destino","Destino","Destino","mv_ch2","C",06,0,0,"G",,,,,"mv_par02",,,,,,,,,,,,,,,,,)

Return Nil
           
//--------------------------------
//function: MESTPESQ
//by JAR in TAIFF ** 15/02/2011
//--------------------------------
User Function MESTPESQ( cAlias, nReg, nOpc )
Local aOrdem := {}
Local lSeek  := .F.
Local cChave := Space(255)
Local oChave
Local oDlg
Local oCbx
Local nOrd := 1

aAdd(aOrdem, "Produto")
aAdd(aOrdem, "Nota")

Define MsDialog oDlg From 00,00 To 100,490 Pixel Title "Pesquisa"         
                                                                   
@ 05,05 MSComboBox oCBX Var nOrd Items aOrdem Size 206,36 Pixel Of oDlg 
@ 22,05 MSGET oChave VAR cChave SIZE 206, 10 OF oDlg COLORS 0, 16777215 PIXEL
                                                   
Define Sbutton From 05,215 Type 1 Of oDlg Enable Action (lSeek := .T.,oDlg:End())
Define Sbutton From 20,215 Type 2 Of oDlg Enable Action (lSeek := .F.,oDlg:End())
Activate MsDialog oDlg Centered

If lSeek
	TRB->( DBSetOrder( nOrd ) )
	TRB->( DbSeek(xFilial("SDA") + Alltrim(cChave), .T.) )
EndIf

Return

//--------------------------------
//function: MESTFIL
//by JAR in TAIFF ** 15/02/2011
//--------------------------------
User Function MESTFIL()
Local cFiltra := ""
Local cFiltro := ""

cFiltro := BuildExpr("SDA")

If !Empty(cFiltro)
	cFiltra := "(" + cFiltra + ") .and. " + cFiltro
	TRB->(MsFilter(cFiltro))
Else
	TRB->(DbClearFilter())
	TRB->(MsFilter(cFiltra))
EndIf

Return Nil

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ"±±
±±ºPROGRAMA  ³VERSALDO   ºAUTOR  ³TOTVS ABM           º DATA ³  16/07/12  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDESC.     ³ VERIFICA SE EXISTE SALDO EM ESTOQUE, USAR NA VALIDAçãO NOS º±±
±±º          ³ CAMPOS B1_RASTRO E B1_LOCALIZ.                             º±±
±±ºEXEMPLO   ³ U_VERSALDO()							                          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function VERSALDO()

	Local cAlias := Alias()
	Local aArea  := GetArea()
	Local lRet   := .T.
	Local nSld   := 0
	       
	SB2->(DbSetOrder(1))
	If SB2->(Dbseek(xFilial("SB2") + M->B1_COD, .F.))
		While SB2->(!Eof()) .and. SB2->B2_COD == M->B1_COD
	   	nSld += SB2->B2_QATU
	      SB2->(DbSkip())	
	 	EndDo
	   
	   If nSld > 0
	   	lRet := .F.
	      MsgAlert("Produto com saldo em estoque, não é permitido alterar sua configuração.", "Atenção")
	   EndIf
	EndIf  
	
	DbSelectArea(cAlias)
	RestArea(aArea)

Return(lRet)