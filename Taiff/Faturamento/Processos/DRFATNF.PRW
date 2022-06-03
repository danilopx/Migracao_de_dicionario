#include "rwmake.ch"
#include "topconn.ch"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TbiConn.ch"
#INCLUDE "TbiCode.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ DRFATNF  ºAutor  ³Anderson Messias    º Data ³  10/03/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Demonstrativo Performance do Transportador                 º±±
±±º          ³ Programa original criado por Eduardo Barbosa como RFATNF   º±±
±±º          ³ mas convertido para treport por Anderson Messias           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ TAIFF                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function DRFATNF()

Private oReport  
Private cPerg   := PADR("RFATNF",10)
Private cTitulo := "Demonstrativo da Performance do Transportador"
Private TREL    := nil
Private aStruREL:= {}

ValidPerg(cPerg)
Pergunte(cPerg,.F.)
/*
if !Pergunte(cPerg,.T.)
	Return
Endif
*/

ReportDef()
oReport:PrintDialog()

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ ReportDef³ Autor ³ Anderson Messias      ³ Data ³ 10.03.11 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Definicao do layout do Relatorio	                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ ReportDef(void)                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function ReportDef()

Local oSection1,nI
Local aSavAtu := GetArea()
Local aSavSX3 := SX3->(GetArea())
Local aCampos := {'F2_DOC'  ,'F2_SERIE','F2_VALBRUT','F2_PBRUTO' ,'F2_CLIENTE','F2_LOJA','A1_NREDUZ'    ,'A1_MUN'   ,'A1_EST','F2_EMISSAO','F2_DTEMB','F2_DTRECEB'}
Local aTitulo := {'N.Fiscal','Ser.'    ,'Vlr.Bruto' ,'Peso Bruto','Cliente'   ,'Loja'   ,'Nome Reduzido','Municipio','UF'    ,'Emissao'   ,'Coleta'  ,'Entrega'   }

oReport := TReport():New("DRFATNF",cTitulo,cPerg,{|oReport| ReportPrint(oReport)},'Relatorio de Refaturamento')
oReport:SetLandScape(.T.)

oSection1 := TRSection():New(oReport,'Registros',{"TREL"},{"Transportadora"})
//oSection1:SetLineBreak(.T.)

For nI := 1 to len(aCampos)
	DBSelectArea("SX3")
	DBSetOrder(2)
	if DBSeek(PADR(aCampos[nI],10))
		_nTamanho := SX3->X3_TAMANHO
		if aCampos[nI] == "A1_NREDUZ"
			_nTamanho := 30			        	
		endif
		if SX3->X3_TIPO == "D"
			_nTamanho := 10
		endif
		TRCell():New(oSection1,SX3->X3_CAMPO,"TREL",aTitulo[nI],SX3->X3_PICTURE,_nTamanho,.F.,)
	endif
Next
TRCell():New(oSection1,"D.REAL"       ,"   ",'D.Real',/*Picture*/,4,/*lPixel*/, {|| _nDiasReal })
TRCell():New(oSection1,"D.TAB."       ,"   ",'D.Tab.',/*Picture*/,4,/*lPixel*/, {|| _nDiasTra })
TRCell():New(oSection1,"D.VAR."       ,"   ",'D.Var.',/*Picture*/,4,/*lPixel*/, {|| _nDiasVr })
TRCell():New(oSection1,"CLASSIFICACAO","   ",'Classificação',/*Picture*/,20,/*lPixel*/, {|| _cClass })
TRCell():New(oSection1,"F2_OCOENT","TREL","Ocor.","",4,.F.,)
TRCell():New(oSection1,"X5_DESCRI","TREL","Descricao Ocor.","",40,.F.,)

RestArea(aSavSX3)
RestArea(aSavAtu)

Return
                             
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ReportPrint³ Autor ³Anderson Messias       ³ Data ³01.02.11  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³A funcao estatica ReportDef devera ser criada para todos os  ³±±
±±³          ³relatorios que poderao ser agendados pelo usuario.           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nenhum                                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpO1: Objeto Report do Relatório                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao efetuada                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                             ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function ReportPrint(oReport)
Local oSection1	:= oReport:Section(1)

oReport:SetTitle(cTitulo)

MsgRun("Selecionando Registros, Aguarde...",,{|| AbrirQuery("TREL",oSection1)})
dbSelectArea("TREL")
           
_nSubOtm	:= 0
_nSubBom	:= 0
_nSubReg	:= 0
_nSubRui	:= 0
_nSubNF	:= 0

_nTotOtm := 0
_nTotbom := 0
_nTotReg := 0
_nTotRui := 0
_nTotNF	 := 0
_lImpTra := .T.

_cTransp	:= ""
_cNomeTra	:= ""

While !TREL->( Eof() )

	If _lImpTra
		oSection1:Init()
		_lImpTra	:= 	.F.
		// Posicionamento do Transportador
		DbSelectArea("SA4")
		DbSetOrder(1)
		DbSeek(xFilial("SA4")+TREL->F2_TRANSP,.F.)
	
		oReport:SkipLine()
		oReport:PrintText("Transp.: "+TREL->F2_TRANSP+" - "+SA4->A4_NOME)
		oReport:SkipLine()

		_cTransp	:=	 TREL->F2_TRANSP
		_cNomeTra	:=	 SA4->A4_NOME
	Endif

	_nDiasTra := 0
	_nDiasVr  := 0
	_nDiasReal:= 0
	If !EMPTY(TREL->F2_DTRECEB)
		If  TREL->F2_DTRECEB>=TREL->F2_DTEMB
			// Pegar Prazo de entrega da tabela de frete
			_aCalTrans := U_SeleFrete(0,0,TREL->A1_EST,TREL->A1_CEP,"N",TREL->F2_TRANSP,TREL->F2_EMISSAO)
			_nDiasTra  := 0
			If Len(_aCalTrans)>0
				_nDiasTra  := _aCalTrans[1,5]
			Endif
			//_nDiasTra := 3
			// Calculo dos dias de entrega apenas dias uteis.
			_dDtUtil		:= TREL->F2_DTEMB
			_nDiasReal	    := 0
			While .T.
				_dDtUtil++
				_dDtValida	:= DataValida(_dDtUtil)
				If _dDtValida	== _dDtUtil
					_nDiasReal++
					If _nDiasReal >= _nDiastra // Se Transportador entregou atrasado considerar todos os dias corridos
						_nDiasReal := _nDiasReal+(TREL->F2_DTRECEB-_dDtUtil)
						Exit
					Endif
				Endif
				If _dDtUtil >= TREL->F2_DTRECEB
					Exit
				Endif
			EndDo
		Endif
		_nDiasVr	:= _nDiasReal-_nDiasTra
	Endif  
	_cClass := "" 
	If  ! EMPTY(TREL->F2_DTRECEB )
		_nSubNf	:= _nSubNf + 1
		If _nDiasVr <= 0
			_cClass		:=	"Dentro do Prazo"
			_nSubOtm	:= _nSubOtm+1
		ElseIf _nDiasVr >=1 //.AND. _nDiasVr<= 2
			_cClass		:=	"Fora do Prazo"
			_nSubReg	:= _nSubReg+1
		Endif
	Endif

	oSection1:PrintLine()
	TREL->(dbSkip())

	If TREL->F2_TRANSP <> _cTransp
		_lImpTra := .T.
		_nTotOtm := _nTotOtm + _nSubOtm
		_nTotbom := _nTotBom + _nSubBom
		_nTotReg := _nTotReg + _nSubReg
		_nTotRui := _nTotRui + _nSubRui
		_nTotNF	 := _nTotNF  + _nSubNF
		
		oReport:SkipLine()
		oReport:PrintText("Resumo Classificacao Transp.: "+_cTransp+" - "+_cNomeTra)
		oReport:PrintText("Total NFS Entregues ->"+ TransForm(_nSubNf,"@E 9,999"))
		oReport:PrintText("Dentro do Prazo     ->"+ TransForm(_nSubOtm,"@E 9,999")+" - "+TransForm(_nSubOtm/_nSubNf*100,"@E 999")+" %")
		oReport:PrintText("Fora do Prazo       ->"+ TransForm(_nSubReg,"@E 9,999")+" - "+TransForm(_nSubReg/_nSubNf*100,"@E 999")+" %")
		oReport:SkipLine()
		
		_nSubOtm := 0
		_nSubBom := 0
		_nSubReg := 0
		_nSubRui := 0
		_nSubNF	 := 0
		oSection1:Finish()
		oReport:EndPage()
	Endif
	
EndDo

oReport:SkipLine()
oReport:PrintText("Resumo Classificacao Transp.: "+_cTransp+" - "+_cNomeTra)
oReport:PrintText("Total NFS Entregues ->"+ TransForm(_nSubNf,"@E 9,999"))
oReport:PrintText("Dentro do Prazo     ->"+ TransForm(_nSubOtm,"@E 9,999")+" - "+TransForm(_nSubOtm/_nSubNf*100,"@E 999")+" %")
oReport:PrintText("Fora do Prazo       ->"+ TransForm(_nSubReg,"@E 9,999")+" - "+TransForm(_nSubReg/_nSubNf*100,"@E 999")+" %")
oReport:SkipLine()

oSection1:Finish()

If Select("TREL") > 0
	DBSelectArea("TREL")
	DBCloseArea()
EndIf

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³VALIDPERG ³ Autor ³ Anderson Messias      ³ Data ³ 10/03/11 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Verifica as perguntas incluindo-as caso nao existam		  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ TAIFF                                                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function VALIDPERG(cPerg)

cPerg := PADR(cPerg,10)

//Grupo/Ordem/Pergunta/Perg.Esp./Perg.English/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/DefEsp01/DefEng01/Cnt01/Var02/Def02/DefEsp02/DefEng02/Cnt02/Var03/Def03/DefEsp03/DefEng03/Cnt03/Var04/Def04/DefEsp04/DefEng04/Cnt04/Var05/Def05/DefEsp05/DefEng05/Cnt05/F3/GRPSXG
PutSx1(cPerg,"01","Nota de          ?","","","mv_ch1","C",09,00,0,"G","","","","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","","")
PutSx1(cPerg,"02","Nota Ate         ?","","","mv_ch2","C",09,00,0,"G","","","","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","","")
PutSx1(cPerg,"03","Transportador de ?","","","mv_ch3","C",06,00,0,"G","","SA4","","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","","")
PutSx1(cPerg,"04","Transportador Ate?","","","mv_ch4","C",06,00,0,"G","","SA4","","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","","")
PutSx1(cPerg,"05","Emissao de       ?","","","mv_ch5","D",08,00,0,"G","","","","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","",""," ","")
PutSx1(cPerg,"06","Emissao Ate      ?","","","mv_ch6","D",08,00,0,"G","","","","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","",""," ","")
PutSx1(cPerg,"07","Tipo Analise     ?","","","mv_ch7","N",01,00,1,"C","","","","","mv_par07","Entregues","","","","Nao Entregues","","","Ambos","","","","","","","","","","","","","","","")
PutSx1(cPerg,"08","Salta Pagina     ?","","","mv_ch8","N",01,00,1,"C","","","","","mv_par08","Sim","","","","Nao","","","Ambos","","","","","","","","","","","","","","","")
PutSx1(cPerg,"09","Estado de        ?","","","mv_ch9","C",02,00,0,"G","","12","","","mv_par09","","","","","","","","","","","","","","","","","","","","","","","","","","")
PutSx1(cPerg,"10","Estado Ate       ?","","","mv_chA","C",02,00,0,"G","","12","","","mv_par10","","","","","","","","","","","","","","","","","","","","","","","","","","")
PutSx1(cPerg,"11","Representante de ?","","","mv_chB","C",06,00,0,"G","","SA3","","","mv_par11","","","","","","","","","","","","","","","","","","","","","","","","","","")
PutSx1(cPerg,"12","Representante Ate?","","","mv_chC","C",06,00,0,"G","","SA3","","","mv_par12","","","","","","","","","","","","","","","","","","","","","","","","","","")
PutSx1(cPerg,"13","Ocorrencia de    ?","","","mv_chD","C",02,00,0,"G","","ZI","","","mv_par13","","","","","","","","","","","","","","","","","","","","","","","","","","")
PutSx1(cPerg,"14","Ocorrencia Ate   ?","","","mv_chE","C",02,00,0,"G","","ZI","","","mv_par14","","","","","","","","","","","","","","","","","","","","","","","","","","")

Return Nil 

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³ AbrirQuery()                                               º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function AbrirQuery(cAliasQ,oSection1)

Local cQuery

cQuery := " SELECT F2_TIPO,F2_DOC,F2_SERIE,F2_TRANSP, F2_CLIENTE,F2_LOJA,F2_EMISSAO,F2_DTEMB,F2_DTRECEB,F2_VALBRUT ,F2_PBRUTO,F2_CARGA,F2_REDESP, "+CRLF
cQuery += " CASE WHEN LTRIM(RTRIM(F2_REDESP))<>'' THEN A4_NREDUZ ELSE CASE WHEN F2_TIPO IN ('D','B') THEN A2_NREDUZ ELSE A1_NREDUZ END END A1_NREDUZ, "+CRLF
cQuery += " CASE WHEN LTRIM(RTRIM(F2_REDESP))<>'' THEN A4_MUN  ELSE CASE WHEN F2_TIPO IN ('D','B') THEN A2_MUN  ELSE A1_MUN  END END A1_MUN, "+CRLF
cQuery += " CASE WHEN LTRIM(RTRIM(F2_REDESP))<>'' THEN A4_CEP  ELSE CASE WHEN F2_TIPO IN ('D','B') THEN A2_CEP  ELSE A1_CEP  END END A1_CEP, "+CRLF
cQuery += " CASE WHEN LTRIM(RTRIM(F2_REDESP))<>'' THEN A4_EST  ELSE CASE WHEN F2_TIPO IN ('D','B') THEN A2_EST  ELSE A1_EST  END END A1_EST, "+CRLF
cQuery += " F2_OCOENT, ISNULL(X5_DESCRI,'') X5_DESCRI "
cQuery += " FROM " + RETSQLNAME('SF2') + " SF2 "+CRLF
cQuery += " LEFT JOIN " + RETSQLNAME('SA1') + " SA1 ON A1_COD=F2_CLIENTE AND A1_LOJA=F2_LOJA AND SA1.D_E_L_E_T_='' "+CRLF
cQuery += " LEFT JOIN " + RETSQLNAME('SA2') + " SA2 ON A2_COD=F2_CLIENTE AND A2_LOJA=F2_LOJA AND SA2.D_E_L_E_T_='' "+CRLF
cQuery += " LEFT JOIN " + RETSQLNAME('SA4') + " SA4 ON A4_COD=F2_REDESP AND SA4.D_E_L_E_T_='' "+CRLF
cQuery += " LEFT JOIN " + RETSQLNAME('SX5') + " SX5 ON F2_OCOENT=X5_CHAVE AND SX5.D_E_L_E_T_='' AND X5_TABELA='ZI'"+CRLF
cQuery += " WHERE F2_FILIAL = '"+xFilial("SF2")+"' AND SF2.D_E_L_E_T_ = ' ' AND"+CRLF
cQuery += " F2_DOC >= '"+MV_PAR01+"' AND F2_DOC <= '"+MV_PAR02+"' AND"+CRLF
cQuery += " F2_TRANSP >= '"+MV_PAR03+"' AND F2_TRANSP <= '"+MV_PAR04+"' AND"+CRLF
cQuery += " F2_EMISSAO >= '"+DTOS(MV_PAR05)+"' AND F2_EMISSAO <= '"+DTOS(MV_PAR06)+"' AND "+CRLF
cQuery += " F2_EST >= '"+MV_PAR09+"' AND F2_EST <= '"+MV_PAR10+"' AND "+CRLF
cQuery += " F2_VEND1 >= '"+MV_PAR11+"' AND F2_VEND1 <= '"+MV_PAR12+"' AND "+CRLF
cQuery += " F2_OCOENT >= '"+MV_PAR13+"' AND F2_OCOENT <= '"+MV_PAR14+"' AND "+CRLF
cQuery += " F2_TIPO ='N'  "+CRLF
If MV_PAR07 == 1 // Apenas Entregues
	cQuery += " AND F2_DTRECEB<>' '"+CRLF
Endif
If MV_PAR07 == 2 // Nao Entregues
	cQuery += " AND F2_DTRECEB=' '"+CRLF
Endif
cQuery += " ORDER BY F2_TRANSP,F2_DOC "+CRLF
//aviso("Query",cQuery,{"OK"},3)

// Regra para avaliacao do nivel de entrega do transportador
// Tempo de entrega Avaliacao ( Tempo Real - Tempo tabela combinada )
// <=1 otimo
// =0 Bom
// =2 Regular
// >= 2 Ruim
//

//* Verifica se a Query Existe, se existir fecha
If Select(cAliasQ) > 0
	dbSelectArea(cAliasQ)
	dbCloseArea()
EndIf

//* Cria a Query e da Um Apelido
TCQUERY cQuery NEW ALIAS &cAliasQ
TCSETFIELD(cAliasQ,"F2_EMISSAO","D",10)
TCSETFIELD(cAliasQ,"F2_DTEMB","D",10)
TCSETFIELD(cAliasQ,"F2_DTRECEB","D",10)
TCSETFIELD(cAliasQ,"F2_VALBRUT","N",14,2)
TCSETFIELD(cAliasQ,"F2_PBRUTO","N",14,2)

dbSelectArea(cAliasQ)

Return
