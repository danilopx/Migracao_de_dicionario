//#Include "FINR002TAIFF.CH"
#Include "PROTHEUS.CH"


/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o	 � FINR002TAIF	� Autor � Carlos Alday    � Data � 16/05/2010 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Relacao por natureza financeira                            ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe e �                                                            ���
�������������������������������������������������������������������������Ĵ��
��� Uso		 � Generico 												  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
����������������������������������������������������������������������������
/*/
User Function FINR002TAI()

Local oReport
Local aAreaR4	:= GetArea()

If FindFunction("TRepInUse") .And. TRepInUse()
	oReport := ReportDef()
	oReport:PrintDialog()
Endif

RestArea(aAreaR4)  

Return
       
/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �ReportDef � Autor � Marco Bianchi         � Data � 21/07/06 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �A funcao estatica ReportDef devera ser criada para todos os ���
���          �relatorios que poderao ser agendados pelo usuario.          ���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
���Retorno   �ExpO1: Objeto do relat�rio                                  ���
�������������������������������������������������������������������������Ĵ��
���Parametros�Nenhum                                                      ���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
���   DATA   � Programador   �Manutencao efetuada                         ���
�������������������������������������������������������������������������Ĵ��
���          �               �                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function ReportDef()
// Local oBreak         
// Local oCell         
Local cPerg	:= "FINR002TAI"
Local oReport 
Local oSection 
//������������������������������������������������������������������������Ŀ
//�Criacao do componente de impressao                                      �
//�                                                                        �
//�TReport():New                                                           �
//�ExpC1 : Nome do relatorio                                               �
//�ExpC2 : Titulo                                                          �
//�ExpC3 : Pergunte                                                        �
//�ExpB4 : Bloco de codigo que sera executado na confirmacao da impressao  �
//�ExpC5 : Descricao                                                       �
//�                                                                        �
//��������������������������������������������������������������������������
oReport := TReport():New("FINR002TAI","Resumo das Despesas por Natureza",cPerg, {|oReport| ReportPrint(oReport)},"Este programa ir� emitir a rela��o de titulos por natureza fin."+" "+"de acordo com os parametros definidos pelo usuario.            ") 
//��������������������������������������������������������������Ŀ
//� Variaveis utilizadas para parametros                         �
//� mv_par01              Data de                                �
//� mv_par02              Data Ate                               �
//� mv_par03              Almoxarifado de                        �
//� mv_par04              Almoxarifado ate                       �
//� mv_par05              OP de                                  �
//� mv_par06              OP Ate                                 �
//����������������������������������������������������������������
Pergunte(cPerg,.F.)

oSection := TRSection():New(oReport,"CODIGO NATUREZA FINANCEIRA                                                    VALOR",{"SE2","SEV","SA2","SED"}) //"Empenhos"
oSection:SetHeaderPage()
oSection:SetTotalInLine(.F.)

TRCell():New(oSection,"ED_CODIGO" ,"SE2",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection,"ED_DESCRIC","SE2")
TRCell():New(oSection,"E2_VALOR"  ,"SE2")

//TRFunction():New(oSection:Cell("nTotal"),/* cID */,"SUM",/*oBreak*/,/*cTitle*/,/*cPicture*/,/*uFormula*/,.T./*lEndSection*/,.F./*lEndReport*/,.F./*lEndPage*/)
//oReport:Section():SetTotalText("TOTAIS")

Return(oReport)


/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �ReportPrin� Autor � Ricardo Berti 		� Data �25.05.2006���
�������������������������������������������������������������������������Ĵ��
���Descri��o �A funcao estatica ReportDef devera ser criada para todos os ���
���          �relatorios que poderao ser agendados pelo usuario.          ���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
���Retorno   �Nenhum                                                      ���
�������������������������������������������������������������������������Ĵ��
���Parametros�ExpO1: Objeto Report do Relat�rio                           ���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
���   DATA   � Programador   �Manutencao efetuada                         ���
�������������������������������������������������������������������������Ĵ��
���          �               �                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function ReportPrint(oReport)

Local oSection  := oReport:Section(1)
Local cAliasQRY := "SE2"
Local lQuery  := .F.
//Local lFirst  := .t.
//Local nTotal  := 0
#IFNDEF TOP
	Local cCondicao := ""
#ENDIF
Local cCabecalho := "Emiss�o de " + dtoc(mv_par01) + " at� " + dtoc(mv_par02)
Local _nVlTotal  := 0

oReport:SetTitle( "Resumo das Despesas por Natureza" + " - " + cCabecalho)	//Altera o Titulo do relatorio

dbSelectArea("SE2")
dbSetOrder(1)
//������������������������������������������������������������������������Ŀ
//�Filtragem do relat�rio                                                  �
//��������������������������������������������������������������������������
#IFDEF TOP
	//������������������������������������������������������������������������Ŀ
	//�Transforma parametros Range em expressao SQL                            �	
	//��������������������������������������������������������������������������
	MakeSqlExpr(oReport:uParam)
	//������������������������������������������������������������������������Ŀ
	//�Query do relat�rio da secao 1                                           �
	//��������������������������������������������������������������������������
	oReport:Section(1):BeginQuery()	
	
	lQuery  := .T.
	cAliasQRY := GetNextAlias()
	BeginSql Alias cAliasQRY

	SELECT 
	    SED.ED_CODIGO     AS ED_CODIGO,
	    SED.ED_DESCRIC    AS ED_DESCRIC,
        SUM(SE2.E2_VALOR) AS E2_VALOR
	FROM %table:SE2% SE2
      LEFT OUTER JOIN %table:SED% SED ON SE2.E2_NATUREZ = SED.ED_CODIGO AND SED.%NotDel% 
	WHERE E2_FILIAL = %xFilial:SE2% AND 
		E2_EMISSAO >= %Exp:Dtos(mv_par01)% AND 
		E2_EMISSAO <= %Exp:Dtos(mv_par02)% AND 
		SE2.%NotDel% AND
		NOT (IsNull(SE2.E2_MULTNAT,' ') != '2' AND IsNull(SE2.E2_MULTNAT,' ') != ' ')
	GROUP BY SED.ED_CODIGO, SED.ED_DESCRIC
    UNION
	SELECT 
	    SEX.ED_CODIGO     AS ED_CODIGO,
	    SEX.ED_DESCRIC    AS ED_DESCRIC,
        SUM(SEV.EV_VALOR) AS E2_VALOR
	FROM %table:SE2% SE2
      LEFT OUTER JOIN %table:SEV% SEV ON SE2.E2_NUM = SEV.EV_NUM AND SEV.EV_RECPAG='P' AND SEV.%NotDel% 
      LEFT OUTER JOIN %table:SED% SEX ON SEV.EV_NATUREZ = SEX.ED_CODIGO AND SEX.%NotDel% 
	WHERE E2_FILIAL = %xFilial:SE2% AND 
		E2_EMISSAO >= %Exp:Dtos(mv_par01)% AND 
		E2_EMISSAO <= %Exp:Dtos(mv_par02)% AND 
		SE2.%NotDel% AND
		(IsNull(SE2.E2_MULTNAT,' ') != '2' AND IsNull(SE2.E2_MULTNAT,' ') != ' ')
	GROUP BY SEX.ED_CODIGO, SEX.ED_DESCRIC
	ORDER BY ED_CODIGO
			
	EndSql 
	//������������������������������������������������������������������������Ŀ
	//�Metodo EndQuery ( Classe TRSection )                                    �
	//�                                                                        �
	//�Prepara o relat�rio para executar o Embedded SQL.                       �
	//�                                                                        �
	//�ExpA1 : Array com os parametros do tipo Range                           �
	//�                                                                        �
	//��������������������������������������������������������������������������
	oReport:Section(1):EndQuery(/*Array com os parametros do tipo Range*/)
	
#ELSE
	//������������������������������������������������������������������������Ŀ
	//�Transforma parametros Range em expressao Advpl                          �
	//��������������������������������������������������������������������������
	MakeAdvplExpr(oReport:uParam)

#ENDIF		


//������������������������������������������������������������������������Ŀ
//�Inicio da impressao do fluxo do relat�rio                               �
//��������������������������������������������������������������������������

oSection:Print()

_nTamanho := 0
_nVlTotal := 0
(cAliasQRY)->(dbgotop())
While !(cAliasQRY)->(Eof())
   _nVlTotal += (cAliasQRY)->E2_VALOR
   (cAliasQRY)->(DbSkip())
End
_nTamanho := Len(spac(11)+ "TOTAL" + spac(25) + Transform( _nVlTotal ,PesqPict("SE2","E2_VALOR")))

oReport:PrintText(replicate("-",_nTamanho))
oReport:PrintText(spac(11)+ "TOTAL" + spac(25) + Transform( _nVlTotal ,PesqPict("SE2","E2_VALOR")))	

(cAliasQRY)->(DbCloseArea())

Return NIL

/*
	SELECT 
	    CASE WHEN IsNull(SE2.E2_MULTNAT,' ') != '2' AND IsNull(SE2.E2_MULTNAT,' ') != ' ' THEN SEX.ED_CODIGO  ELSE SED.ED_CODIGO  END AS ED_CODIGO,
	    CASE WHEN IsNull(SE2.E2_MULTNAT,' ') != '2' AND IsNull(SE2.E2_MULTNAT,' ') != ' ' THEN SEX.ED_DESCRIC  ELSE SED.ED_DESCRIC  END AS ED_DESCRIC,
        SUM(CASE WHEN IsNull(SE2.E2_MULTNAT,' ') != '2' AND IsNull(SE2.E2_MULTNAT,' ') != ' ' THEN SEV.EV_VALOR   ELSE SE2.E2_VALOR   END) AS E2_VALOR
	FROM %table:SE2% SE2
      LEFT OUTER JOIN %table:SEV% SEV ON SE2.E2_NUM = SEV.EV_NUM AND SEV.EV_RECPAG='P' AND SEV.%NotDel% 
      LEFT OUTER JOIN %table:SED% SED ON SE2.E2_NATUREZ = SED.ED_CODIGO AND SED.%NotDel% 
      LEFT OUTER JOIN %table:SED% SEX ON SEV.EV_NATUREZ = SEX.ED_CODIGO AND SEX.%NotDel% 
	WHERE E2_FILIAL = %xFilial:SE2% AND 
		E2_EMISSAO >= %Exp:Dtos(mv_par01)% AND 
		E2_EMISSAO <= %Exp:Dtos(mv_par02)% AND 
		SE2.%NotDel% 
	GROUP BY SE2.E2_MULTNAT, SEX.ED_CODIGO, SEX.ED_DESCRIC, SED.ED_CODIGO, SED.ED_DESCRIC
	ORDER BY ED_CODIGO

*/
