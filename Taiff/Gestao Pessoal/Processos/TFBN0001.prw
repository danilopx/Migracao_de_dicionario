#INCLUDE "TFBN0001.CH"
#INCLUDE "Protheus.ch"

User Function TFBN0001()
/*/f/
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
<Descricao> : Cadastro de EndereÁos de Entrega de Beneficios - Visa Vale.
<Autor> : Alexandre Alves da Silva
<Data> : 03/09/2008
<Parametros> : Nenhum	 
<Retorno> : Nenhum          
<Processo> : Nenhum
<Tipo> (Menu,Trigger,Validacao,Ponto de Entrada,Genericas,Especificas) : M
<Obs> : Especifico TAIFF.
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
*/
Local aCores := {}

Private aRotina := {{STR0001,"AxPesqui"	  ,0,1},; //"Pesquisar"
                    {STR0002,"AxVisual"	  ,0,2},; //"Visualizar"
                    {STR0003,"AxInclui"   ,0,3},; //"Incluir"
                    {STR0004,"AxAltera"   ,0,4},; //"Alterar"
                    {STR0005,"U_TFBN1Man" ,0,5},; //"Excluir"
                    {STR0006,"U_TFBN1LEG" ,0,6}} //"Legenda"
                    
Private cCadastro := "EndereÁos para Entrega de Beneficios - Visa Vale"
Private nOpc
Private cAlias
Private nReg

aAdd(aCores,{"ZK_ENDFIL == .F."	, "BR_VERDE"   })
aAdd(aCores,{"ZK_ENDFIL == .T."	, "BR_VERMELHO"})

//Browse Principal	
dbSelectArea("SZK")
dbSetOrder(1)

dbGoTop()        

mBrowse(6,1,22,75,"SZK",,,,,,aCores)

Return()                                        


User Function TFBN1Man(cAlias,nReg,nOpc)
/*/f/
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
<Descricao> : ManutenÁ„o para AlteraÁ„o.
<Autor> : Alexandre Alves da Silva
<Data> : 03/09/2008
<Parametros> : Nenhum	 
<Retorno> : Nenhum          
<Processo> : Nenhum
<Tipo> (Menu,Trigger,Validacao,Ponto de Entrada,Genericas,Especificas) : M
<Obs> : 
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
*/                                          
Local aArea     := GetArea()
Local cQuery 
Local nAuxTabs  := 0


If nOpc = 5 //Exclus„o.

   cQuery := "SELECT RA_MAT FROM "+RetSqlName("SRA")+" SRA "+CRLF
   cQuery += "WHERE SRA.D_E_L_E_T_ <> '*' AND RA_FILIAL+RA_FILPOST = '"+SZK->(ZK_FILIAL+ZK_FILPOST)+"' "+CRLF
   cQuery := ChangeQuery(cQuery)                                              
   
   nAuxTabs := SELECT("BEN")
   If nAuxTabs > 0
	  dbSelectArea("BEN")
	  dbCloseArea()
   Endif
   nAuxTabs  := 0

   dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),"BEN", .F., .F.)

   dbSelectArea("BEN")
   dbGoTop()

   If BEN->( !Eof() )
      MsgStop("Exclus„o n„o permitida!.O endereÁo esta em uso.") 
      RestArea(aArea)           
   ElseIf MsgNoYes( "Confirma Exclus„o do EndereÁo?" ) //

      dbSelectArea("SZK")
      SZK->(RecLock("SZK",.F.))
	   dbDelete()
	   MsUnLock()
   EndIf              

   //Elimina o arquivo tempor·rio.
   BEN->( dbCloseArea() )
   FErase("BEN"+GetDBExtension())

   RestArea(aArea)
EndIf


Return

User Function TFBN1CRG()
/*/f/
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
<Descricao> : Possibilita carregar os campos da tela, com o endereco de entrega da Filial.
<Autor> : Alexandre Alves da Silva
<Data> : 15/09/2008
<Parametros> : Nenhum	 
<Retorno> : Nenhum          
<Processo> : Nenhum
<Tipo> (Menu,Trigger,Validacao,Ponto de Entrada,Genericas,Especificas) : M
<Obs> : 
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
*/    

Local cQuery   := ""
Local nAuxTabs := 0
Local lRet     := .T.

If Inclui
   cQuery := "SELECT ZK_FILIAL, ZK_FILPOST FROM "+RetSqlName("SZK")+" AS SZK "
   cQuery += "WHERE D_E_L_E_T_ <> '*' AND ZK_FILIAL = '"+cFilAnt+"' AND ZK_FILPOST = '"+M->ZK_FILPOST+"' "
   cQuery := ChangeQuery(cQuery)                                              

   nAuxTabs := SELECT("VVE")
   If nAuxTabs > 0
      dbSelectArea("VVE")
      dbCloseArea()
   Endif
   nAuxTabs  := 0

   dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),"VVE", .F., .F.)
   dbSelectArea("VVE")
   dbGoTop()

   If VVE->( !Eof() )      
  	  Aviso("ATEN«√O","N„o È permitido mais de um endereÁo relacionado ‡ mesma Filial.Verifique.",{"OK"})
  	  lRet     := .F.
  	  VVE->( dbCloseArea() )
  	  FErase("VVE"+GetDBExtension())
  	  Return(lRet)
   Else
      VVE->( dbCloseArea() )
      FErase("VVE"+GetDBExtension())
   EndIf
EndIf
   
If (Altera .Or. Inclui).And. M->ZK_ENDFIL = .T. 
   If Aviso("EndereÁos","Deseja carregar o EndereÁo de Entrega da Filial ?",{"Sim","N„o"}) = 1
      M->ZK_LOGRADO := SM0->M0_ENDENT
      M->ZK_COMPLEM := SM0->M0_COMPENT
      M->ZK_BAIRRO  := SM0->M0_BAIRENT
      M->ZK_CEP     := SM0->M0_CEPENT
      M->ZK_CIDADE  := SM0->M0_CIDENT
      M->ZK_ESTADO  := SM0->M0_ESTENT
   EndIf
EndIf

Return(lRet)



User Function TFBN1LEG()
/*/f/
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
<Descricao> : Legenda para as Cores do Semaforo do Mbrowse.
<Autor> : Alexandre Alves da Silva
<Data> : 15/09/2008
<Parametros> : Nenhum	 
<Retorno> : Nenhum          
<Processo> : Nenhum
<Tipo> (Menu,Trigger,Validacao,Ponto de Entrada,Genericas,Especificas) : M
<Obs> : 
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
*/    

Local _aLegenda := {}

aAdd(_aLegenda,{ "BR_VERDE"	  , "EndereÁo Pessoa Fisica (sem CNPJ)" }) 
aAdd(_aLegenda,{ "BR_VERMELHO", "EndereÁo Pessoa Juridica (filial)" }) 

BrwLegenda(cCadastro,"Legenda", _aLegenda)

Return()


User Function fCodVR(l1Elem)
/*/f/
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
<Descricao> :  Monta tela para seleÁ„o de multiplos Codigos de VR a processar.
<Autor> : Alexandre
<Data> : 29/09/2008
<Parametros> : Nenhum
<Retorno> : Logico
<Processo> : Especifico Galvao Engenharia - GPE - Beneficios.
<Tipo> (Menu,Trigger,Validacao,Ponto de Entrada,Genericas,Especificas ) : V
<Obs> : Funcao chamada na digitacao dos beneficios.
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
*/

Local cTitulo:=""
Local MvPar
Local MvParDef:=""

Private aCodVR :={}
l1Elem := If (l1Elem = Nil , .F. , .T.)

lTipoRet := .T.

cAlias := Alias() 					 // Salva Alias Anterior

IF lTipoRet
	MvPar:=&(Alltrim(ReadVar()))		 // Carrega Nome da Variavel do Get em Questao
	mvRet:=Alltrim(ReadVar())			 // Iguala Nome da Variavel ao Nome variavel de Retorno
EndIF

cTitulo := "Codigos VR"
dbSelectArea("SRX")
dbGoTop()
dbSeek(xFilial("SRX")+"26")
If !SRX->( Eof() ) .And. SRX->RX_TIP = '26'

  CursorWait()
    	While !Eof() .And. SRX->RX_TIP = '26'
	   	   Aadd(aCodVR, SubStr(SRX->RX_TXT,1,16))
   		   MvParDef+=Subs(SRX->RX_COD,3,2)
   		dbSkip()
   	Enddo
  CursorArrow()

Else

	Help(" ",1,"O parametro 26 esta vazio.Verifique.") //
	MvParDef:=" "
Endif

IF lTipoRet
	IF f_Opcoes(@MvPar,cTitulo,aCodVR,MvParDef,12,49,l1Elem,2)  
		&MvRet := mvpar                                                                          
	EndIF	
EndIF

dbSelectArea(cAlias) 								 

Return( IF( lTipoRet , .T. , MvParDef ) )


/*
Function f_Opcoes(	uVarRet			,;	//Variavel de Retorno
					cTitulo			,;	//Titulo da Coluna com as opcoes
					aOpcoes			,;	//Opcoes de Escolha (Array de Opcoes)
					cOpcoes			,;	//String de Opcoes para Retorno
					nLin1			,;	//Nao Utilizado
					nCol1			,;	//Nao Utilizado
					l1Elem			,;	//Se a Selecao sera de apenas 1 Elemento por vez
					nTam			,;	//Tamanho da Chave
					nElemRet		,;	//No maximo de elementos na variavel de retorno
					lMultSelect		,;	//Inclui Botoes para Selecao de Multiplos Itens
					lComboBox		,;	//Se as opcoes serao montadas a partir de ComboBox de Campo ( X3_CBOX )
					cCampo			,;	//Qual o Campo para a Montagem do aOpcoes
					lNotOrdena		,;	//Nao Permite a Ordenacao
					lNotPesq		,;	//Nao Permite a Pesquisa	
					lForceRetArr    ,;	//Forca o Retorno Como Array
					cF3				 ;	//Consulta F3	
				  )