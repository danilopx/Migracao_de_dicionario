
#INCLUDE "PROTHEUS.CH"
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � ROM06R01 � Autor � DAC-Denilso           � Data �02/2014   ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Relatorio Comparativo de Custo, varia��o de estoque        ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � ROM06R01(void)                                             ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Generico                                                   ���
�������������������������������������������������������������������������Ĵ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
"Criar query para monitoramento das grandes varia��es de estoques, que ser� executada depois do rec�lculo de custo m�dio do m�s e antes da virada de saldo, para compara��o com o fechamento do m�s anterior. Por exemplo : posi��o do dia 31/01/14 X posi��o do dia 31/12/13 (Jorge TOTVS, de 27/01 a 31/01).
/*/
User Function TAF05R01()
  Local oReport
  Local _cPerg   := "TAF05R01"
  Private _nDias
  //��������������������������������������������������������������Ŀ
  //� Ajusta perguntas no SX1 									 �
  //����������������������������������������������������������������
  AjustaSX1(_cPerg)
  oReport := ReportDef(_cPerg)
  oReport:PrintDialog()
  Return Nil
             
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �ReportDef �Autor  �DAC-Denilso            �Data  �11/2013   ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Relatorio Controle de Copias e Impress�o                   ���
�������������������������������������������������������������������������Ĵ��
���Retorno   �ExpO1: Objeto do relat�rio                                  ���
�������������������������������������������������������������������������Ĵ��
���Parametros�Nenhum                                                      ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function ReportDef(_cPerg)
  Local aOrdem   := {}
  Local oReport 
  Local _oCabec
  Local _oItem
  Local cAlias := GetNextAlias()
  
  oReport := TReport():New(_cPerg,"Varia��es de Estoque",_cPerg, {|oReport| ReportPrint(oReport,cAlias)},"Impress�o Varia��o de Estoque") 
  oReport:HideHeader()                    // Nao imprime cabecalho padrao do Protheus

  _oCabec := TRSection():New(oReport,"Varia��o Custo Estoque",{"TRB","SB1"},aOrdem,/*Campos do SX3*/,/*Campos do SIX*/) //"Carga"
  TRCell():New(_oCabec,"ARMAZEM"     ,"TRB","Analise Armazem"         ,PesqPict("SB1","B1_LOCPAD")  ,TamSX3("B1_LOCPAD")[1]  ,/*lPixel*/,{|| TRB->ARMAZEM })
  TRCell():New(_oCabec,"DTFECHA"     ,""   ,"Data Fechamento"         ,"@D"                         ,10                       ,/*lPixel*/,/*{|| TRB->ARMAZEM }*/)
  TRCell():New(_oCabec,"VARIACAO"    ,""   ,"% de Varia�ao Aceitavel" ,"@E 9,999.999"               ,10                       ,/*lPixel*/,/*{|| TRB->ARMAZEM }*/)

  _oItem := TRSection():New(_oCabec  ,"Demonstra��o Custo Por Armazem",{"TRB","SB1","SB2","SB9"}   ,aOrdem,/*Campos do SX3*/,/*Campos do SIX*/) //"Carga"
  TRCell():New(_oItem,"CODPROD."     ,"TRB","C�d.Produto"             ,PesqPict("SB1","B1_COD")    ,TamSX3("B1_COD")   [1]  ,/*lPixel*/ ,{|| TRB->CODPROD } )
  TRCell():New(_oItem,"DESCPRD"      ,"TRB","Descr. Produto"          ,PesqPict("SB1","B1_DESC")   ,TamSX3("B1_DESC")  [1]  ,/*lPixel*/ ,{|| TRB->DESCPRD } )
  TRCell():New(_oItem,"ARMAZEM"      ,"TRB","Armazem"                 ,PesqPict("SB1","B1_LOCPAD") ,TamSX3("B1_LOCPAD")[1]  ,/*lPixel*/ ,{|| TRB->ARMAZEM } )
  TRCell():New(_oItem,"NQTDEB9"      ,"TRB","Qtd.Ult.Fec."            ,PesqPict("SB9","B9_QINI")   ,TamSX3("B9_QINI")  [1]  ,/*lPixel*/ ,{|| TRB->NQTDEB9 } )
  TRCell():New(_oItem,"NVLRSB9"      ,"TRB","Vlr.Ult.Fec."            ,PesqPict("SB9","B9_VINI1")  ,TamSX3("B9_VINI1") [1]  ,/*lPixel*/ ,{|| TRB->NVLRSB9 } )
  TRCell():New(_oItem,"NPERCB9"      ,"TRB","Cst.Ult.Fec   "          ,                            ,12                       ,/*lPixel*/ ,{|| Transform(TRB->NVLRSB9/TRB->NQTDEB9,"@E 99,999.99999") } )
  TRCell():New(_oItem,"NQTDEB2"      ,"TRB","Qtde Final"              ,PesqPict("SB2","B2_QFIM")   ,TamSX3("B2_QFIM")  [1]  ,/*lPixel*/ ,{|| TRB->NQTDEB2 } )
  TRCell():New(_oItem,"NVLRSB2"      ,"TRB","Valor Final"             ,PesqPict("SB2","B2_VFIM1")  ,TamSX3("B2_VFIM1") [1]  ,/*lPixel*/ ,{|| TRB->NVLRSB2 } )
  TRCell():New(_oItem,"NPERCB2"      ,"TRB","Cst.Final"               ,                            ,12                      ,/*lPixel*/ ,{|| Transform(TRB->NVLRSB2/TRB->NQTDEB2,"@E 99,999.99999") } )
  TRCell():New(_oItem,"NPERVAR"      ,""   ,"% Varia��o"              ,                            ,12                      ,/*lPixel*/ ,/*{|| TRB->NVLRSB2/TRB->NQTDEB2 }*/ )
  oReport:SetTotalInLine(.F.)
  Return(oReport)



/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �ReportPrin�Autor  �DAC-Denilso            �Data  �02/2014   ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Relatorio Diverg�ncias Fechamento                           ���
�������������������������������������������������������������������������Ĵ��
���Retorno   �Nenhum                                                      ���
�������������������������������������������������������������������������Ĵ��
���Parametros�ExpO1: Objeto Report do Relat�rio                           ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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
        //Caso o B2 esteja zerado n�o trazer
        If TRB->NVLRSB2 == 0 .and. TRB->NQTDEB2 == 0
          TRB->(DbSkip())
          Loop
        Endif
        //Se n�o for para travez os valores de fechamento igual a zero
        If mv_par04 == 2 .and. TRB->NVLRSB9 == 0 .and. TRB->NQTDEB9  == 0 
          TRB->(DbSkip())
          Loop
        Endif

        //Achar custo unitario
        _nCustoB9 := TRB->NVLRSB9/TRB->NQTDEB9 
        _nCustoB2 := TRB->NVLRSB2/TRB->NQTDEB2 

        //Verificar como deduzir diretamente para achar pecentual em vez de testar        
        If _nCustoB2 <> _nCustoB9 //.or. _nCustoB2 == _nCustoB9
           //para calcular n�o pode ter valores zerados
           If _nCustoB9 <> 0 .and. _nCustoB2 <> 0
             _nPercCus :=  ((_nCustoB9 -_nCustoB2)  / _nCustoB9) * 100   //_nPercCus :=  (_nCustoB9/_nCustoB2) * 100   //Achar a diferenca em precentual
             //Se ocorrer de um valor zerado tratarei a diferen�a como 100%
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
          //Impress�o cabe�alho pela primeira vez
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
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � AjustaSX1� Autor � DAC - DENILSO         � Data �02/2014   ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Grava�ao de perguntas e helps                              ���
�������������������������������������������������������������������������Ĵ��
���Solicit.  � Eletrozema                                                 ���
�������������������������������������������������������������������������Ĵ��
���Arquivos  � SX1                                                        ���
�������������������������������������������������������������������������Ĵ��
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function AjustaSX1(_cPerg)
  Local _aHelpPor := {}
  Local _aHelpSpa := {}
  Local _aHelpEng := {}   
  Local _nPosHelp := 1

  DbSelectArea('SX1')
  DbSetOrder(1)

  Aadd(_aHelpPor,{"Informe armazem De, ref. ao produto ",;
                  "para impress�o dos dados"})

  Aadd(_aHelpPor,{"Informe armazem Ate, ref. ao produto ",;
                  "para impress�o dos dados"})

  Aadd(_aHelpPor,{"Informe o percentual de Varia��o aceitavel ",;
                  "entre o valor do fechamento e o custo final"})

  Aadd(_aHelpPor,{"Informe se deseja imprimir os registros ",;
                  "em que oa quantidade e o valor do fechamento",;
                  "Est�o zerados"})

  _aHelpSpa := _aHelpPor
  _aHelpEng := _aHelpPor
 
  //     cGrupo ,cOrdem ,cPergunt                                 ,cPergSpa ,cPergEng ,cVar     ,cTipo,nTamanho                ,nDecimal               ,nPreSel ,cGSC>,cValid              ,cF3           ,cGrpSXG,cPyme,cVar01    ,cDef01    ,cDefSpa1  ,cDefEng1  ,cCnt01        ,cDef02     ,cDefSpa2     ,cDefEng2     ,cDef03,cDefSpa3,cDefEng3,cDef04,cDefSpa4,cDefEng4,cDef05,cDefSpa5,cDefEng5,aHelpPor,aHelpEng,aHelpSpa,cHelp       )
  PutSx1(_cPerg ,"01"   ,"Armazem De                       ?"    ,""       ,""       ,"mv_ch1" ,"C"  ,TamSX3("B1_LOCPAD")[1],TamSX3("B1_LOCPAD")[2] ,0      ,"G"   ,                   ,              ,""     ,"S"  ,"mv_par01",""        ,""        ,""        ,""            ,""           ,""           ,""        ,""    ,""      ,""      ,""    ,""      ,""      ,""    ,""      ,""      ,_aHelpPor[_nPosHelp],_aHelpSpa[_nPosHelp],_aHelpEng[_nPosHelp])//,_cPerg)
  _nPosHelp ++
  PutSx1(_cPerg ,"02"   ,"Armazem Ate                      ?"    ,""       ,""       ,"mv_ch2" ,"C"  ,TamSX3("B1_LOCPAD")[1],TamSX3("B1_LOCPAD")[2] ,0      ,"G"   ,                   ,              ,""     ,"S"  ,"mv_par02",""        ,""        ,""        ,""            ,""           ,""           ,""        ,""    ,""      ,""      ,""    ,""      ,""      ,""    ,""      ,""      ,_aHelpPor[_nPosHelp],_aHelpSpa[_nPosHelp],_aHelpEng[_nPosHelp])//,_cPerg)
  _nPosHelp ++
  PutSx1(_cPerg ,"03"   ,"Percentual de Varia��o Custo     ?"    ,""       ,""       ,"mv_ch3" ,"N"  ,8                      ,3                      ,0      ,"G"   ,                   ,              ,""     ,"S"  ,"mv_par03",""        ,""        ,""        ,""            ,""           ,""           ,""        ,""    ,""      ,""      ,""    ,""      ,""      ,""    ,""      ,""      ,_aHelpPor[_nPosHelp],_aHelpSpa[_nPosHelp],_aHelpEng[_nPosHelp])//,_cPerg)
  _nPosHelp ++
  PutSx1(_cPerg ,"04"   ,"Fechamento c/Qtde e Valor Zerado ? "    ,""       ,""       ,"mv_ch4" ,"C"  ,1                      ,0                      ,0      ,"C"   ,                   ,              ,""     ,"S"  ,"mv_par04","Sim"     ,"Sim"     ,"Yes"     ,""            ,"Nao"        ,"N�o"        ,"No"      ,""    ,""      ,""      ,""    ,""      ,""      ,""    ,""      ,""      ,_aHelpPor[_nPosHelp],_aHelpSpa[_nPosHelp],_aHelpEng[_nPosHelp])//,_cPerg)

  Return Nil





