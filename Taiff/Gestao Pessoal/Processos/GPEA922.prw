#include 'Protheus.ch'
#Include 'FWMVCDEF.CH'
#include 'GPEA922.CH'
/*
�������������������������������������������������������������������������������������������������������
�������������������������������������������������������������������������������������������������������
���������������������������������������������������������������������������������������������������Ŀ��
���Funcao    	� GPEA922    � Autor � Glaucia M.			  	                � Data � 17/09/2013 ���
���������������������������������������������������������������������������������������������������Ĵ��
���Descricao 	� Fatos Relevantes                                                                  ���
���������������������������������������������������������������������������������������������������Ĵ��
���Sintaxe   	� GPEA922()                                                    	  		            ���
���������������������������������������������������������������������������������������������������Ĵ��
���Uso       	� Menu SIGAGPE e GPEA011                                                            ���
���������������������������������������������������������������������������������������������������Ĵ��
���         ATUALIZACOES SOFRIDAS DESDE A CONSTRU�AO INICIAL.               			            ���
���������������������������������������������������������������������������������������������������Ĵ��
���Analista     � Data     � FNC/Requisito  � Chamado �  Motivo da Alteracao                        ���
���������������������������������������������������������������������������������������������������Ĵ��
���Glaucia M.   �16/09/2013�00000024225/2013�THUXM9   � Inclusao rotina.                            ���
���Glaucia M.   �08/10/2013�00000026196/2013�THWZX9   � Ajuste para nao permitir linha duplicada.   ���
����������������������������������������������������������������������������������������������������ٱ�
�������������������������������������������������������������������������������������������������������
�������������������������������������������������������������������������������������������������������*/
User Function GPEA922()
	Local lRet := .T.
	Local aArea := SRA->(GetArea())
	Local cFiltraRh
	Local oMBrowse
	Private cChaveAux := ""
	setfunname("GPEA922") 
	oMBrowse := FWMBrowse():New()
	oMBrowse:SetAlias("SRA")
 
	oMBrowse:SetDescription(OemToAnsi(STR0014))
	
//	oMBrowse:Activate()

	//������������������������������������������������������������������������Ŀ
	//� Inicializa o filtro utilizando a funcao FilBrowse                      �
	//��������������������������������������������������������������������������
	cFiltraRh := CHKRH("FATOS","SRA","1")
	oMBrowse:SetFilterDefault( cFiltraRh )
	oMBrowse:SetLocate()
	GpLegMVC(@oMBrowse)

	oMBrowse:ExecuteFilter(.T.)

	oMBrowse:Activate()
    RestArea(aArea)

Return

/*
�����������������������������������������������������������������������Ŀ
�Fun��o    � MenuDef		�Autor�  Glaucia M.       � Data �16/09/2013�
�����������������������������������������������������������������������Ĵ
�Descri��o �Criacao do Menu do Browse.                                  �
�����������������������������������������������������������������������Ĵ
�Sintaxe   �< Vide Parametros Formais >									�
�����������������������������������������������������������������������Ĵ
� Uso      �GPEA922                                                     �
�����������������������������������������������������������������������Ĵ
� Retorno  �aRotina														�
�����������������������������������������������������������������������Ĵ
�Parametros�< Vide Parametros Formais >									�
�������������������������������������������������������������������������*/

Static Function MenuDef()

Local aRotina := {}

ADD OPTION aRotina TITLE "Visualizar" ACTION "VIEWDEF.GPEA922"	OPERATION 2	ACCESS 0 //"Visualizar"

//ADD OPTION aRotina TITLE "Incluir" 	  ACTION "VIEWDEF.GPEA922"	OPERATION 3	ACCESS 0 //"Incluir"
	
ADD OPTION aRotina TITLE "Manuten��o" ACTION "VIEWDEF.GPEA922"	OPERATION 4	ACCESS 0 //"Alterar"
	
ADD OPTION aRotina TITLE "Excluir"    ACTION "VIEWDEF.GPEA922"	OPERATION 5	ACCESS 0 //"Excluir"
	

Return(aRotina)

/*
�����������������������������������������������������������������������Ŀ
�Fun���o    � ModelDef		�Autor�  Glaucia M.       � Data �16/09/2013�
�����������������������������������������������������������������������Ĵ
�Descri��o �Regras de Modelagem da gravacao.                            �
�����������������������������������������������������������������������Ĵ
�Sintaxe   �< Vide Parametros Formais >									�
�����������������������������������������������������������������������Ĵ
� Uso      �GPEA922                                                     �
�����������������������������������������������������������������������Ĵ
� Retorno  �Model em uso.												�
�����������������������������������������������������������������������Ĵ
�Parametros�< Vide Parametros Formais >									�
�������������������������������������������������������������������������*/
Static Function ModelDef()

Local oModel		:= Nil
Local oStruSRA 		:= FWFormStruct(1,"SRA",{|cCampo|  AllTrim(cCampo) $ "|RA_MAT|RA_NOME|RA_ADMISSA|"})
Local oStruRAE		:= FWFormStruct(1, 'RAE')

oModel     	:= MPFormModel():New('MGPEA922')
oModel:SetDescription('Funcionarios')
oModel:AddFields( 'SRATITLE',				, oStruSRA )
oModel:AddGrid( 'RAEMASTER1', 'SRATITLE', oStruRAE,,)
oModel:SetRelation('RAEMASTER1', {{'RAE_FILIAL', 'xFilial("RAE")'}, {'RAE_MAT', 'RA_MAT'}}, RAE->(IndexKey(1)))

oModel:GetModel( 'RAEMASTER1' ):SetDescription(OemToAnsi(STR0014)) //Fatos Relevantes

oModel:GetModel( "SRATITLE" ):SetOnlyQuery(.T.)

oModel:SetPrimaryKey({'RA_FILIAL', 'RA_MAT'})

oModel:GetModel('RAEMASTER1'):SetUniqueLine({'RAE_FILIAL','RAE_MAT', 'RAE_SEQ','RAE_DATA', 'RAE_COD'})

//Permite grid sem dados
oModel:GetModel('RAEMASTER1'):SetOptional(.T.)
oModel:AddRules( 'RAEMASTER1','RAE_COD' , 'RAEMASTER1', 'RAE_DATA', 1 )
oModel:AddRules( 'RAEMASTER1','RAE_DESC' , 'RAEMASTER1', 'RAE_COD', 1 )


Return( oModel )
/*
�����������������������������������������������������������������������Ŀ
�Fun��o    � ViewDef		�Autor�  Glaucia M.       � Data �16/09/2013�
�����������������������������������������������������������������������Ĵ
�Descri��o �Regras de Interface com o Usuario                           �
�����������������������������������������������������������������������Ĵ
�Sintaxe   �< Vide Parametros Formais >									�
�����������������������������������������������������������������������Ĵ
� Uso      �GPEA922                                                     �
�����������������������������������������������������������������������Ĵ
� Retorno  �View em uso.    											�
�����������������������������������������������������������������������Ĵ
�Parametros�< Vide Parametros Formais >									�
�������������������������������������������������������������������������*/

Static Function ViewDef()  

Local oView
Local oModel := ModelDef()
Local oStruSRA	:= FWFormStruct(2,"SRA",{|cCampo|  AllTrim(cCampo) $ "|RA_MAT|RA_NOME|RA_ADMISSA|"})
Local oStruRAE := FWFormStruct(2, 'RAE')

oView := FWFormView():New()
oView:SetModel(oModel)
oView:AddField("VIEW_SRA",oStruSRA,"SRATITLE")
oView:AddGrid("VIEW_RAE", oStruRAE, 'RAEMASTER1')

oStruSRA:RemoveField("RA_FILIAL")
oStruRAE:RemoveField( 'RAE_MAT' )
oStruSRA:SetNoFolder()

oView:SetOnlyView('VIEW_SRA')
oView:CreateHorizontalBox( 'SUPERIOR', 20 )
oView:CreateHorizontalBox( 'INFERIOR', 80 )

oView:SetOwnerView('VIEW_SRA', 'SUPERIOR')
oView:SetOwnerView('VIEW_RAE', 'INFERIOR')

oView:EnableTitleView('VIEW_SRA', OemToAnsi(STR0013)) // "Funcion�rio"
oView:EnableTitleView('VIEW_RAE', OemToAnsi(STR0014)) // "Fatos Relevantes"

Return oView

/*
�����������������������������������������������������������������������Ŀ
�Fun��o    � fGP922FaVl()	�Autor�  Equipe RH        � Data �11/07/2013�
�����������������������������������������������������������������������Ĵ
�Descri��o �Complemento da valida��o do campo RAE_DATA                  �
�����������������������������������������������������������������������Ĵ
�Sintaxe   �fGP922FaVl()             									�
�����������������������������������������������������������������������Ĵ
� Uso      �GPEA922 - Campo RAE_DATA                                    �
�����������������������������������������������������������������������Ĵ
� Retorno  �Boolean														�
�����������������������������������������������������������������������Ĵ
�Parametros�Nenhum                            	     					�
�������������������������������������������������������������������������*/
User Function fGP922FaVl()
Local lRet	:=	.T.
Local dDataFato	:= FwfldGet("RAE_DATA")


If (SRA->RA_ADMISSA > dDataFato	  )
	lRet:= .F.
	Help( ,, 'Help',, OemtoAnsi(STR0015), 1, 0 ) //A data do fato relevante devera ser maior que a data de admissao do funcionario.
ElseIf (dDataFato > dDataBase )
	lRet:= .F.
	Help( ,, 'Help',, OemtoAnsi(STR0016), 1, 0 ) //"A data do fato relevante devera ser anterior ou igual a data sistema."
ElseIf !Empty(SRA->RA_DEMISSA) .AND. dDataFato > SRA->RA_DEMISSA
	lRet:= .F.
	Help( ,, 'Help',, OemtoAnsi(STR0017+"("+DTOC(SRA->RA_DEMISSA)+")"), 1, 0 ) //"A data do fato relevante devera ser anterior ou igual a data demiss�o."
EndIf

Return lRet

/*
�����������������������������������������������������������������������Ŀ
�Fun��o    � fGP922PosL()	�Autor�  Glaucia M.       � Data �16/09/2013�
�����������������������������������������������������������������������Ĵ
�Descri��o �Gatilho Inicializa campo RAE_SEQ, ao digitar o campo        �
�          �RAE_DATA e RAE_COD, onde remonta as sequencias com mesma    �
�          �data, ao incluir e/ou alterar RAE_DATA e RAE_COD            �
�����������������������������������������������������������������������Ĵ
�Sintaxe   �< Vide Parametros Formais >									�
�����������������������������������������������������������������������Ĵ
� Uso      �GPEA922                                                     �
�����������������������������������������������������������������������Ĵ
� Retorno  �Nenhum														�
�����������������������������������������������������������������������Ĵ
�Parametros�Nao se aplica.                   	     					�
�������������������������������������������������������������������������*/
User Function fGP922PosL()
local aArea			:= GetArea()
local oMdl			:= FWModelActive()
Local oGridRAE		:= oMdl:GetModel('RAEMASTER1')
Local nLinRAE		:= oGridRAE:nLine
Local nOperation	:= oMdl:GetOperation()
Local dData			:= FwfldGet('RAE_DATA')
Local cCod			:= FwFldGet('RAE_COD')
Local aLines
Local cSeq			:= ''
Local nX			:= 0
Local nCount		:= 0
Local cCount		:= ''
Local nPos			:= 0
Local aS051			:= {}

If len(aS051) == 0
	dbSelectArea( "RCC" )
	dbSetOrder(1)
	MsSeek(xFilial("RCC")+ 'S051')
	While !Eof() .AND. RCC->RCC_FILIAL+RCC_CODIGO == xFilial("RCC")+'S051'
		If RCC->RCC_FILIAL+RCC_CODIGO == xFilial("RCC")+'S051'
			Aadd(aS051,{Substr(RCC->RCC_CONTEU,1,2),0})
		EndIf
		dBSkip()
	EndDo
EndIf

If  (!EMPTY(cCod) .AND. !EMPTY(dData) .AND. (nOperation # MODEL_OPERATION_DELETE) .AND. oGridRAE:GetQtdLine() >= 1)
	aLines		:= FwSaveRows()
	For nX := 1 to oGridRAE:GetQtdLine()
		oGridRAE:GoLine( nX )
		If	(!oGridRAE:IsDeleted() .AND. oGridRAE:GetValue("RAE_DATA", nX) == dData)
			nPos := aScan( aS051, {|X| X[1] == oGridRAE:GetValue("RAE_COD", nX)})
			aS051[nPos][2] := aS051[nPos][2] + 1
			cCount := STRZERO(aS051[nPos][2],2)
		 	If oGridRAE:GetValue("RAE_SEQ", nX) != cCount
				FwFldPut('RAE_SEQ',cCount,nX,oMdl,.F.,.T.)
			EndIf
		EndIf
	Next nX

	cSeq := IIf (EMPTY(oGridRAE:GetValue("RAE_SEQ", nLinRAE)),"01",oGridRAE:GetValue("RAE_SEQ", nLinRAE))
	FwRestRows(aLines)
	oGridRAE:GoLine( nLinRAE )
EndIf

cSeq:= IIf(EMPTY(cSeq),'01',cSeq)

RestArea(aArea)
Return (cSeq)