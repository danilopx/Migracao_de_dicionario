
#INCLUDE "PROTHEUS.CH"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ ROM06R01 ³ Autor ³ DAC-Denilso           ³ Data ³02/2014   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Relatorio Comparativo de Custo, variação de estoque        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ ROM06R01(void)                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
"Criar query para monitoramento das grandes variações de estoques, que será executada depois do recálculo de custo médio do mês e antes da virada de saldo, para comparação com o fechamento do mês anterior. Por exemplo : posição do dia 31/01/14 X posição do dia 31/12/13 (Jorge TOTVS, de 27/01 a 31/01).
/*/
User Function TAF05R01()
  Local oReport
  Local _cPerg   := "TAF05R01"
  Private _nDias
  //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  //³ Ajusta perguntas no SX1 									 ³
  //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
  AjustaSX1(_cPerg)
  oReport := ReportDef(_cPerg)
  oReport:PrintDialog()
  Return Nil
             
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ReportDef ³Autor  ³DAC-Denilso            ³Data  ³11/2013   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Relatorio Controle de Copias e Impressão                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ExpO1: Objeto do relatório                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Nenhum                                                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ReportDef(_cPerg)
  Local aOrdem   := {}
  Local oReport 
  Local _oCabec
  Local _oItem
  Local cAlias := GetNextAlias()
  
  oReport := TReport():New(_cPerg,"Variações de Estoque",_cPerg, {|oReport| ReportPrint(oReport,cAlias)},"Impressão Variação de Estoque") 
  oReport:HideHeader()                    // Nao imprime cabecalho padrao do Protheus

  _oCabec := TRSection():New(oReport,"Variação Custo Estoque",{"TRB","SB1"},aOrdem,/*Campos do SX3*/,/*Campos do SIX*/) //"Carga"
  TRCell():New(_oCabec,"ARMAZEM"     ,"TRB","Analise Armazem"         ,PesqPict("SB1","B1_LOCPAD")  ,TamSX3("B1_LOCPAD")[1]  ,/*lPixel*/,{|| TRB->ARMAZEM })
  TRCell():New(_oCabec,"DTFECHA"     ,""   ,"Data Fechamento"         ,"@D"                         ,10                       ,/*lPixel*/,/*{|| TRB->ARMAZEM }*/)
  TRCell():New(_oCabec,"VARIACAO"    ,""   ,"% de Variaçao Aceitavel" ,"@E 9,999.999"               ,10                       ,/*lPixel*/,/*{|| TRB->ARMAZEM }*/)

  _oItem := TRSection():New(_oCabec  ,"Demonstração Custo Por Armazem",{"TRB","SB1","SB2","SB9"}   ,aOrdem,/*Campos do SX3*/,/*Campos do SIX*/) //"Carga"
  TRCell():New(_oItem,"CODPROD."     ,"TRB","Cód.Produto"             ,PesqPict("SB1","B1_COD")    ,TamSX3("B1_COD")   [1]  ,/*lPixel*/ ,{|| TRB->CODPROD } )
  TRCell():New(_oItem,"DESCPRD"      ,"TRB","Descr. Produto"          ,PesqPict("SB1","B1_DESC")   ,TamSX3("B1_DESC")  [1]  ,/*lPixel*/ ,{|| TRB->DESCPRD } )
  TRCell():New(_oItem,"ARMAZEM"      ,"TRB","Armazem"                 ,PesqPict("SB1","B1_LOCPAD") ,TamSX3("B1_LOCPAD")[1]  ,/*lPixel*/ ,{|| TRB->ARMAZEM } )
  TRCell():New(_oItem,"NQTDEB9"      ,"TRB","Qtd.Ult.Fec."            ,PesqPict("SB9","B9_QINI")   ,TamSX3("B9_QINI")  [1]  ,/*lPixel*/ ,{|| TRB->NQTDEB9 } )
  TRCell():New(_oItem,"NVLRSB9"      ,"TRB","Vlr.Ult.Fec."            ,PesqPict("SB9","B9_VINI1")  ,TamSX3("B9_VINI1") [1]  ,/*lPixel*/ ,{|| TRB->NVLRSB9 } )
  TRCell():New(_oItem,"NPERCB9"      ,"TRB","Cst.Ult.Fec   "          ,                            ,12                       ,/*lPixel*/ ,{|| Transform(TRB->NVLRSB9/TRB->NQTDEB9,"@E 99,999.99999") } )
  TRCell():New(_oItem,"NQTDEB2"      ,"TRB","Qtde Final"              ,PesqPict("SB2","B2_QFIM")   ,TamSX3("B2_QFIM")  [1]  ,/*lPixel*/ ,{|| TRB->NQTDEB2 } )
  TRCell():New(_oItem,"NVLRSB2"      ,"TRB","Valor Final"             ,PesqPict("SB2","B2_VFIM1")  ,TamSX3("B2_VFIM1") [1]  ,/*lPixel*/ ,{|| TRB->NVLRSB2 } )
  TRCell():New(_oItem,"NPERCB2"      ,"TRB","Cst.Final"               ,                            ,12                      ,/*lPixel*/ ,{|| Transform(TRB->NVLRSB2/TRB->NQTDEB2,"@E 99,999.99999") } )
  TRCell():New(_oItem,"NPERVAR"      ,""   ,"% Variação"              ,                            ,12                      ,/*lPixel*/ ,/*{|| TRB->NVLRSB2/TRB->NQTDEB2 }*/ )
  oReport:SetTotalInLine(.F.)
  Return(oReport)



/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ReportPrin³Autor  ³DAC-Denilso            ³Data  ³02/2014   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Relatorio Divergências Fechamento                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpO1: Objeto Report do Relatório                           ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ReportPrint(oReport,cAlias)
  Local _oCab       := oReport:Section(1) 
  Local _oItem      := oReport:Section(1):Section(1)  
  //Local _cTitulo    := oReport:cdescription 
  Local _dDataPesq  := DtOS( SuperGetMV( "MV_ULMES"  ,,StoD("") ))
  Local _nToleranc  := mv_par03   //SuperGetMV( "TF_TOLVEST"  ,, 1 )
  Local _cAlias
  //Local _nPos
  Local _cCodArm
  Local _nPercCus, _nCustoB9, _nCustoB2, _lCab
  
//--        AND SB1.B1_LOCALIZ = 'S' 

  Begin Sequence
    _cAlias := "TRB"  //GetNextAlias()      
    BeginSql Alias _cAlias
      SELECT SB2.B2_COD  CODPROD,
             SB1.B1_DESC DESCPRD, 
             SB2.B2_LOCAL ARMAZEM, 
             SUM(SB2.B2_QFIM)  NQTDEB2, 
             SUM(SB2.B2_VFIM1) NVLRSB2,
             SUM(SB9.B9_QINI)  NQTDEB9, 
             SUM(SB9.B9_VINI1) NVLRSB9
      FROM %table:SB2% SB2     
      LEFT JOIN %table:SB1% SB1 ON 
                SB1.B1_COD   = SB2.B2_COD 
            AND SB1.%notDel%
      LEFT JOIN %table:SB9% SB9 ON 
                SB9.B9_COD   = SB2.B2_COD 
            AND SB9.B9_LOCAL = SB2.B2_LOCAL 
            AND SB9.B9_DATA  = %Exp:_dDataPesq%
            AND SB9.%notDel%
      WHERE SB2.B2_FILIAL =  %xFilial:SB2%
        AND SB2.%notDel%  
        AND SB2.B2_LOCAL BETWEEN %Exp:mv_par01% AND %Exp:mv_par02%
      GROUP BY SB2.B2_LOCAL,
               SB2.B2_COD, 
               SB2.B2_LOCAL,
               SB1.B1_DESC      
      ORDER BY SB2.B2_LOCAL,
               SB2.B2_COD
    EndSql  
	oReport:StartPage()     //-- Inicia a pagina
    _oCab:Init()
    _oItem:Init()
    While TRB->(!Eof()) 
      If oReport:Cancel()
        Exit
      EndIf                                     
      _cCodArm := TRB->ARMAZEM    
      _lCab    := .F.
      While TRB->(!Eof()) .and. TRB->ARMAZEM == _cCodArm
        oReport:IncMeter()
        If oReport:Cancel()
          Exit
        EndIf                                     
        //Caso o B2 esteja zerado não trazer
        If TRB->NVLRSB2 == 0 .and. TRB->NQTDEB2 == 0
          TRB->(DbSkip())
          Loop
        Endif
        //Se não for para travez os valores de fechamento igual a zero
        If mv_par04 == 2 .and. TRB->NVLRSB9 == 0 .and. TRB->NQTDEB9  == 0 
          TRB->(DbSkip())
          Loop
        Endif

        //Achar custo unitario
        _nCustoB9 := TRB->NVLRSB9/TRB->NQTDEB9 
        _nCustoB2 := TRB->NVLRSB2/TRB->NQTDEB2 

        //Verificar como deduzir diretamente para achar pecentual em vez de testar        
        If _nCustoB2 <> _nCustoB9 //.or. _nCustoB2 == _nCustoB9
           //para calcular não pode ter valores zerados
           If _nCustoB9 <> 0 .and. _nCustoB2 <> 0
             _nPercCus :=  ((_nCustoB9 -_nCustoB2)  / _nCustoB9) * 100   //_nPercCus :=  (_nCustoB9/_nCustoB2) * 100   //Achar a diferenca em precentual
             //Se ocorrer de um valor zerado tratarei a diferença como 100%
           Else
             _nPercCus := 100
           Endif  
        Else
          _nPercCus := 0
        Endif  
   
        If _nPercCus  < 0   //significa valor negativo passar para positivo
          _nPercCus   := (_nPercCus) * -1                                   
        Endif
          
        If _nToleranc <= _nPercCus   
          //Impressão cabeçalho pela primeira vez
          If !_lCab
            _oCab:Cell("DTFECHA"):SetBlock(  { || StoD(_dDataPesq) } )
            _oCab:Cell("VARIACAO"):SetBlock( { || mv_par03 } )
            TRB->(_oCab:PrintLine())
            _oItem:Init()
            _lCab    := .T.
          Endif          
          _oItem:Cell("NPERVAR"):SetBlock( { || TransForm(_nPercCus,"@E 99,999.99999") } )
          TRB->(_oItem:PrintLine())
        Endif  
        TRB->(DbSkip())
      Enddo
      If _lCab
        oReport:EndPage()  //reinicia a pagina  
        oReport:Section(1):SetPageBreak(.T.)
        _oItem:Finish()
      Endif   
    Enddo

    _oItem:Finish()
    _oCab:Finish()

    oReport:Section(1):SetPageBreak(.T.)

  End Begin

  If Select(_cAlias) <> 0
    (_cAlias)->(DbCloseArea())
    Ferase(_cAlias+GetDBExtension())
  Endif  

  Return Nil
  


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡Æo    ³ AjustaSX1³ Autor ³ DAC - DENILSO         ³ Data ³02/2014   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡Æo ³ Gravaçao de perguntas e helps                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Solicit.  ³ Eletrozema                                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Arquivos  ³ SX1                                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function AjustaSX1(_cPerg)
  Local _aHelpPor := {}
  Local _aHelpSpa := {}
  Local _aHelpEng := {}   
  Local _nPosHelp := 1

  DbSelectArea('SX1')
  DbSetOrder(1)

  Aadd(_aHelpPor,{"Informe armazem De, ref. ao produto ",;
                  "para impressão dos dados"})

  Aadd(_aHelpPor,{"Informe armazem Ate, ref. ao produto ",;
                  "para impressão dos dados"})

  Aadd(_aHelpPor,{"Informe o percentual de Variação aceitavel ",;
                  "entre o valor do fechamento e o custo final"})

  Aadd(_aHelpPor,{"Informe se deseja imprimir os registros ",;
                  "em que oa quantidade e o valor do fechamento",;
                  "Estão zerados"})

  _aHelpSpa := _aHelpPor
  _aHelpEng := _aHelpPor
 
  //     cGrupo ,cOrdem ,cPergunt                                 ,cPergSpa ,cPergEng ,cVar     ,cTipo,nTamanho                ,nDecimal               ,nPreSel ,cGSC>,cValid              ,cF3           ,cGrpSXG,cPyme,cVar01    ,cDef01    ,cDefSpa1  ,cDefEng1  ,cCnt01        ,cDef02     ,cDefSpa2     ,cDefEng2     ,cDef03,cDefSpa3,cDefEng3,cDef04,cDefSpa4,cDefEng4,cDef05,cDefSpa5,cDefEng5,aHelpPor,aHelpEng,aHelpSpa,cHelp       )
  PutSx1(_cPerg ,"01"   ,"Armazem De                       ?"    ,""       ,""       ,"mv_ch1" ,"C"  ,TamSX3("B1_LOCPAD")[1],TamSX3("B1_LOCPAD")[2] ,0      ,"G"   ,                   ,              ,""     ,"S"  ,"mv_par01",""        ,""        ,""        ,""            ,""           ,""           ,""        ,""    ,""      ,""      ,""    ,""      ,""      ,""    ,""      ,""      ,_aHelpPor[_nPosHelp],_aHelpSpa[_nPosHelp],_aHelpEng[_nPosHelp])//,_cPerg)
  _nPosHelp ++
  PutSx1(_cPerg ,"02"   ,"Armazem Ate                      ?"    ,""       ,""       ,"mv_ch2" ,"C"  ,TamSX3("B1_LOCPAD")[1],TamSX3("B1_LOCPAD")[2] ,0      ,"G"   ,                   ,              ,""     ,"S"  ,"mv_par02",""        ,""        ,""        ,""            ,""           ,""           ,""        ,""    ,""      ,""      ,""    ,""      ,""      ,""    ,""      ,""      ,_aHelpPor[_nPosHelp],_aHelpSpa[_nPosHelp],_aHelpEng[_nPosHelp])//,_cPerg)
  _nPosHelp ++
  PutSx1(_cPerg ,"03"   ,"Percentual de Variação Custo     ?"    ,""       ,""       ,"mv_ch3" ,"N"  ,8                      ,3                      ,0      ,"G"   ,                   ,              ,""     ,"S"  ,"mv_par03",""        ,""        ,""        ,""            ,""           ,""           ,""        ,""    ,""      ,""      ,""    ,""      ,""      ,""    ,""      ,""      ,_aHelpPor[_nPosHelp],_aHelpSpa[_nPosHelp],_aHelpEng[_nPosHelp])//,_cPerg)
  _nPosHelp ++
  PutSx1(_cPerg ,"04"   ,"Fechamento c/Qtde e Valor Zerado ? "    ,""       ,""       ,"mv_ch4" ,"C"  ,1                      ,0                      ,0      ,"C"   ,                   ,              ,""     ,"S"  ,"mv_par04","Sim"     ,"Sim"     ,"Yes"     ,""            ,"Nao"        ,"Não"        ,"No"      ,""    ,""      ,""      ,""    ,""      ,""      ,""    ,""      ,""      ,_aHelpPor[_nPosHelp],_aHelpSpa[_nPosHelp],_aHelpEng[_nPosHelp])//,_cPerg)

  Return Nil





