#Include "PROTHEUS.CH"
#Include "TOPCONN.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � TaFRECon �Autor  � Anderson Messias   � Data �  05/22/12   ���
�������������������������������������������������������������������������͹��
���Desc.     � Rotina que simula provisao de frete por peso bruto e peso  ���
���          � cubado para verifica��o de distor��o                       ���
�������������������������������������������������������������������������͹��
���Uso       � TAIFF                                                      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function TaFRECon()

Local oReport

Local cRotina := "TaFRECon"

private cPerg := PADR("TaFRECon",10)

ValidPerg()
if !Pergunte(cPerg,.T.)
	Return
endif

//������������������������������������������������������Ŀ
//|verifica se relatorios personalizaveis esta disponivel|
//��������������������������������������������������������
oReport := ReportDef(cRotina)
//oReport:SetTotalInLine(.T.)
oReport:PrintDialog()

Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Descri��o � Impressao do relat�rio personalizavel		              |��
�������������������������������������������������������������������������Ĵ��
���Uso       � Yokogawa  			                                      ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

Static Function ReportDef(cRotina)

Local oReport
//Local oSection

//�������������������Ŀ
//�Imprime relatorio  �
//���������������������
oReport := TReport():New(cRotina,"Transferencias de Estoque",cPerg,{|oReport| PrintReport(oReport,cRotina)},"Este relatorio ira imprimir as transferencias de estoque")
oReport:SetLandScape(.T.)

oSection1 := TRSection():New(oReport,OemToAnsi("Transferencias"),)

//�����������������������������������������������������������������Ŀ
//�Define as colunas a serem mostradas na SECAO 2 - Dados do pedido �
//�������������������������������������������������������������������
TRCell():New(oSection1,"NUMSEQ","TRB","Num.Seq",/*"@E 9999.99"*/,10)

TRCell():New(oSection1,"F2_SERIE","TRB",,/*"@E 9999.99"*/,)
TRCell():New(oSection1,"F2_DOC","TRB",,/*"@E 9999.99"*/,)
TRCell():New(oSection1,"F2_CONHECI","TRB",,/*"@E 9999.99"*/,)
TRCell():New(oSection1,"F2_PBRUTO","TRB",,"@E 9999999.999",)
TRCell():New(oSection1,"PAV_PESOCU","TRB",,"@E 9999999.999",)
TRCell():New(oSection1,"PAV_FRETRA","TRB",,"@E 999,999.99",)
TRCell():New(oSection1,"FREPESO",,"Frete PBruto","@E 999,999.99",15,,{|| _nFrePeso })
TRCell():New(oSection1,"FRECUB",,"Frete Cubagem","@E 999,999.99",15,,{|| _nFreCub })

Return oReport

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Descri��o � Impressao do relat�rio personalizavel		              |��
�������������������������������������������������������������������������Ĵ��
���Uso       � GLASSEC	 			                                      ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

Static Function PrintReport(oReport,cRotina)

Local oSection1 := oReport:Section(1)
oSection1:SetTotalInLine(.T.)
//oReport:OnPageBreak(,.T.)

_cQuery := "SELECT  "+CRLF
_cQuery += "  F2_SERIE, "+CRLF
_cQuery += "  F2_DOC, "+CRLF
_cQuery += "  F2_CONHECI, "+CRLF
_cQuery += "  F2_PBRUTO, "+CRLF
_cQuery += "  SF2.R_E_C_N_O_ AS F2_RECNO, "+CRLF
_cQuery += "  PAV_PESOCU, "+CRLF
_cQuery += "  PAV_FRETRA "+CRLF
_cQuery += "FROM  "+CRLF
_cQuery += "  "+RetSQLName("SF2")+" SF2 "+CRLF
_cQuery += "  LEFT JOIN "+RetSQLName("PAV")+" PAV ON PAV.PAV_NF = SF2.F2_DOC AND PAV.PAV_CTO = SF2.F2_CONHECI AND PAV.D_E_L_E_T_='' "+CRLF
_cQuery += "WHERE  "+CRLF
_cQuery += "  SF2.D_E_L_E_T_='' AND  "+CRLF
_cQuery += "  F2_EMISSAO BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' AND "+CRLF
_cQuery += "  F2_CONHECI<>'' "+CRLF
_cQuery += "ORDER BY "+CRLF
_cQuery += "  F2_TRANSP, "+CRLF
_cQuery += "  F2_CONHECI, "+CRLF
_cQuery += "  F2_DOC "+CRLF

If Select("TRB") > 0
	DbSelectArea("TRB")
	DbCloseArea()
Endif

// Monta Query
TCQUERY _cQuery NEW ALIAS "TRB"
TcSetField("TRB", "F2_PBRUTO", "N",12,3)
TcSetField("TRB", "PAV_PESOCU", "N",12,3)
TcSetField("TRB", "PAV_FRETRA", "N",12,2)

// Impressao da Primeira secao
DbSelectArea("TRB")
DbGoTop()
nTotal := 0
dbEval( {|| nTotal++ } )
DbGoTop()

oReport:SetMeter(nTotal)
oSection1:Init()
While !TRB->(Eof())
	If oReport:Cancel()
		Exit
	EndIf
	
	DbSelectArea("SF2")
	DbSetOrder(3)
	DBGoTo(TRB->F2_RECNO)
	
	_cTipoCalc	:=  "N"
	_lTDE    := .F.
	If SF2->F2_TIPO== 'B'
		DbSelectArea("SA2")
		DbSetOrder(1)
		DbSeek(xFilial("SA2")+SF2->F2_CLIENTE+SF2->F2_LOJA,.F.)
		_cCep	:= SA2->A2_CEP
		_cTpCalc := 'N'
	Else
		DbSelectArea("SA1")
		DbSetOrder(1)
		DbSeek(xFilial("SA1")+SF2->F2_CLIENTE+SF2->F2_LOJA,.F.)
		_cCep	:= SA1->A1_CEP
		_lTDE   := SA1->A1_FRETED == "S"
	Endif
	
	// Averigua se trata-se de Redespacho
	_cEst	:= SF2->F2_EST
	If ! Empty(SF2->F2_REDESP)
		DbSelectArea("SA4")
		DbSetOrder(1)
		DbSeek(xFilial("SA4")+SF2->F2_REDESP,.F.)
		_cCep	:= SA4->A4_CEP
		_cEst	:= SA4->A4_EST
	Endif

	//Calculando Frete pelo peso bruto
	_aCalTrans := U_SeleFrete(SF2->F2_VALBRUT,SF2->F2_PBRUTO,_cEst,_cCep,_cTipoCalc,SF2->F2_TRANSP,SF2->F2_EMISSAO,_lTDE)
	_nFrePeso := 0
	If Len(_aCalTrans) > 0
		_nFrePeso   := _aCalTrans[1,3,09]
	Endif
	
	//Calculando Frete pelo peso cubado
	_aCalTrans := U_SeleFrete(SF2->F2_VALBRUT,TRB->PAV_PESOCU,_cEst,_cCep,_cTipoCalc,SF2->F2_TRANSP,SF2->F2_EMISSAO,_lTDE)
	_nFreCub := 0
	If Len(_aCalTrans) > 0
		_nFreCub   := _aCalTrans[1,3,09]
	Endif

	oSection1:PrintLine()
	
	TRB->(DbSkip())
	oReport:IncMeter()
EndDo
oSection1:Finish()

If Sele("TRB") <> 0
	TRB->(DbCloseArea())
Endif

Return


/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �VALIDPERG � Autor �  Anderson Messias     � Data � 23/04/12 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Verifica as perguntas inclu�ndo-as caso n�o existam        ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Espec�fico para clientes Microsiga                         ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

Static Function ValidPerg

//Grupo/Ordem/Pergunta/Perg.Esp./Perg.English/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/DefEsp01/DefEng01/Cnt01/Var02/Def02/DefEsp02/DefEng02/Cnt02/Var03/Def03/DefEsp03/DefEng03/Cnt03/Var04/Def04/DefEsp04/DefEng04/Cnt04/Var05/Def05/DefEsp05/DefEng05/Cnt05/F3/GRPSXG
PutSx1(cPerg,"01","Periodo De"   ,"","","mv_ch1","D",08,00,0,"G","","" ,"","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","","")
PutSx1(cPerg,"02","Periodo At�"  ,"","","mv_ch2","D",08,00,0,"G","","" ,"","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","","")

Return
