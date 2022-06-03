#INCLUDE "RWMAKE.CH"      
#INCLUDE "AP5MAIL.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "XMLXFUN.CH"
#INCLUDE "TBICONN.CH"

//Fun็ใo responsavel por verificar diferen็as no saldo em estoque baseado nas tabelas SB2, SBF e SA
//DAC - Denilso 18/02/2014
//TAF05M001
User Function TAF05M001(aParams)
  Local _cArqHtm   := "TAIFFSDLEST.HTML"
  Local _cBranco   := ' '
  Local _cSubject  := "DIVERGสNCIA EM ESTOQUE"
  Local _Destinat  
  Local _cCopia    

  Local _lSchedule := .F.
  Local _cProg     := Procname()  
  Local _cAliasTRB
  Begin Sequence
    //indica็ใo da Chamada por Schedule
    If aParams <> Nil
      //Tem que ser array e 2 posi็oes
      If ValType(aParams) <> "A" .or. Len(aParams) <> 2
        CONOUT("Funcionalidade TAF99DE1 chamada por Schedule nใo configurada corretamente a chamada comparโmetros Empresa e Filial, corrigir chamada !") 
        Return Nil  
      Endif
      CONOUT(" INICIO JOB Funcionalidade "+ _cProg)
      CONOUT("Empresa " + aParams[1])   //Empresa
      CONOUT("Filial  " + aParams[2])   //Filial     
      //Preparar a Empresa              
      WfPrepEnv(aParams[1], aParams[2], "Imp.Clientes")  
      _lSchedule := .T. 
    Endif
    _Destinat  := AllTrim(SuperGetMV("TF_DES05M1",,""))
    _cCopia    := AllTrim(SuperGetMV("TF_COP05M1",,""))

    //Nใo deixar prosseguir caso nใo tenha destinatario de e-mail    
    If Empty(_Destinat)
      If ! _lSchedule
      Aviso( _cProg+"001", "Nao informado Destinatario para o envio do Email parametro TF_DES05M1 !", {"Ok"} ) 
      Else
        CONOUT("Nao informado Destinatario para o envio do Email parametro TF_DES05M1 ! "+_cProg)
      EndIf                                                      
      Break
    Endif
    
    Private _cLin  := ""
    //Verificar se exist problemas no saldo em estoque fazendo a sele็ใo com coparativo das tabelas SB2, SBF e SDA
    _cAliasTRB := GetNextAlias()    
    BeginSql Alias _cAliasTRB 
      SELECT SB2.B2_COD,                
             SB2.B2_LOCAL, 
             SB1.B1_DESC,
             SB1.B1_LOCALIZ, 
             SUM(B2_QATU) AS SLD_SB2,
             ISNULL( (SELECT SUM(SBF.BF_QUANT) 
                      FROM %Table:SBF% SBF
                      WHERE SBF.BF_PRODUTO = SB2.B2_COD 
                        AND SBF.BF_LOCAL   = SB2.B2_LOCAL
                        AND SBF.D_E_L_E_T_ = %Exp:_cBranco% ) , 0) AS SLD_SBF,
             ISNULL( (SELECT SUM(SDA.DA_SALDO) 
                      FROM %Table:SDA% SDA
                      WHERE SDA.DA_PRODUTO = SB2.B2_COD
                        AND SDA.DA_LOCAL   = SB2.B2_LOCAL                       
                        AND SDA.D_E_L_E_T_ = %Exp:_cBranco%) , 0)  AS SLD_SDA
      FROM %Table:SB2% SB2
      LEFT JOIN  %Table:SB1% SB1 ON
                SB1.B1_COD = SB2.B2_COD 
            AND SB1.D_E_L_E_T_ =  %Exp:_cBranco%  
      WHERE SB2.D_E_L_E_T_ = %Exp:_cBranco%      
        AND SB1.B1_LOCALIZ = 'S'
      GROUP BY SB2.B2_COD, SB2.B2_LOCAL,SB1.B1_DESC,SB1.B1_LOCALIZ 
      ORDER BY SB2.B2_COD, SB2.B2_LOCAL       
    EndSql
    
    If (_cAliasTRB)->(EOF()) 
      Break
    Endif
    (_cAliasTRB)->(DbGoTop())
    While (_cAliasTRB)->(!EOF()) 
      //Somente Pegar os valores divergentes
      If (_cAliasTRB)->SLD_SB2 - ( (_cAliasTRB)->SLD_SBF + (_cAliasTRB)->SLD_SDA )  <> 0 
        //gravar HTMl     
        TAF99DEGH( (_cAliasTRB)->B2_COD,;         
                   (_cAliasTRB)->B1_DESC,;
                   (_cAliasTRB)->B2_LOCAL,;        
                   (_cAliasTRB)->SLD_SB2,;
                   (_cAliasTRB)->SLD_SBF,;
                   (_cAliasTRB)->SLD_SDA,;
                   _cSubject ) 
      Endif
      (_cAliasTRB)->(DbSkip())
    Enddo    

    If !Empty(_cLin) 
      _cLin += "     </I>"
      _cLin += " </TR>"
      _cLin += "</TABLE>"
      _cLin += " <BR>"
      _cLin += " <BR><BR>"
      _cLin += " <BR><BR>"
      _cLin += " <BR><BR>"
      _cLin += " <I> Obs.: Nใo responder a esse e.mail, pois o mesmo foi enviado automaticamente pelo Protheus </I>"
      _cLin += "     <Font size=2>"  
      _cLin += "        <CENTER>"
      _cLin += "        <BR> <BR>"
      _cLin += "          TOTVS"
      _cLin += "     </font>"
      _cLin += "        </CENTER>"
      _cLin += "        </center> "
      _cLin += " </BODY>"
      _cLin += "</HTML>"
      MemoWrit(_cArqHtm,_cLin)
      TAF99EMAI(/* _cServ*/, /*_cConta*/, /*_cSenha*/, /*_cFrom*/, _Destinat, _cSubject, _cLin, _cCopia ,/*_aAttach*/, _lSchedule,Procname() )
    Endif  

  End Begin
  If Select(_cAliasTRB) > 0           // Verificar se o Alias ja esta aberto.
    DbSelectArea(_cAliasTRB)        // Se estiver, devera ser fechado.
    DbCloseArea()
  EndIf

  If _lSchedule
    RESET ENVIRONMENT                                                                  
  Endif  
  CONOUT(" Termino JOB Funcionalidade "+Procname())
  Return Nil    
      

//Efetuar grava็ใo em HTML na variavel _cLin
Static Function TAF99DEGH(_cCodProd,_cDescProd,_cLocal,_nSaldoB2,_nSaldoDF,_nSaldoDA,_cSubject)
  //Gera็ใo do Cabe็alho  
  Begin Sequence
    If !Empty(_cLin)  //ja existe cabe็alho
      Break
    Endif
    _cLin += "<HTML>"
    _cLin += "  <BR>"
    _cLin += "     <TR>"
    _cLin += "        <B>"
    _cLin += "            <Font size=5> "
    _cLin += "              "+Upper(_cSubject)
    _cLin += "            </Font> "
    _cLin += "        </B>"
    _cLin += "     </TR>"
    _cLin += "  </BR> "
    _cLin += " <BR>"
    _cLin += "   <I>"
    _cLin += "      <TR> "
    _cLin += "         Ocorreram inconsist๊ncias na analise do saldo em estoque, conforme abaixo"
    _cLin += "      </TR>"
    _cLin += " <BR>"
    _cLin += " <BR>"
    _cLin += "    <TR>"
    _cLin += "         Data da Analise: " + DtoC(Date())
    _cLin += "      <BR>"
    _cLin += "      <BR>"
    _cLin += "         Hora da Analise: " + Time()
    _cLin += "      <BR>"
    _cLin += "      <BR>"
    _cLin += "         Usuario: " + AllTrim(UsrFullName(__CUSERID))
    _cLin += "      <BR>"
    _cLin += "      <BR>"
    _cLin += "    </TR>"
    _cLin += "       <TABLE BORDER = 5>"
    _cLin += "    <TR>"
    _cLin += "      <I>"
    _cLin += "AJUSTES NECESSARIOS APOS ANALISE"  
    _cLin += "         <TD><B>Codigo Prod     </B></TD>"
    _cLin += "         <TD><B>Descri็ใo       </B></TD>"
    _cLin += "         <TD><B>Armazem         </B></TD>"
    _cLin += "         <TD><B>Saldo Atual     </B></TD>"
    _cLin += "         <TD><B>Sld. por End.   </B></TD>"
    _cLin += "         <TD><B>Sld a Enderecar </B></TD>"
    _cLin += "         <TD><B>Diferen็a       </B></TD>"   
    _cLin += "    </TR>"                 
  End Sequence
  _cLin += "      <TD>" + _cCodProd       + "</TD>"
  _cLin += "      <TD>" + _cDescProd      + "</TD>"
  _cLin += "      <TD>" + _cLocal         + "</TD>"
  _cLin += "      <TD>" + Transfor(_nSaldoB2,"@E 999,999,999.99")    + "</TD>"
  _cLin += "      <TD>" + Transfor(_nSaldoDF,"@E 999,999,999.99")    + "</TD>"
  _cLin += "      <TD>" + Transfor(_nSaldoDA,"@E 999,999,999.99")    + "</TD>"
  _cLin += "      <TD>" + Transfor(_nSaldoB2-(_nSaldoDF+_nSaldoDA),"@E 999,999,999.99")    + "</TD>"
  _cLin += "</TR>"
  Return Nil  








/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณTAF99EMAI บAutor  ณ DAC-Denilso        บ Data ณ             บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Gerar um e-mail com o arquivo texto e ou HTML              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametrosณ<ExpC1>: Nome / IP do Servidor                              บฑฑ
ฑฑบ          ณ<ExpC2>: Conta a ser utilizada para envio do e-mail         บฑฑ
ฑฑบ          ณ<ExpC3>: Password da conta a ser utilizada para envio do em.บฑฑ
ฑฑบ          ณ<ExpC4>: Remetente                                          บฑฑ
ฑฑบ          ณ<ExpC5>: E-mail de Destino                                  บฑฑ
ฑฑบ          ณ<ExpC6>: Linha do Assunto                                   บฑฑ
ฑฑบ          ณ<ExpC7>: Mensagem do E-Mail.                                บฑฑ
ฑฑบ          ณ<ExpA7>: Array UNIDIMENSIONAL com os arquivos Anexos        บฑฑ
ฑฑบ          ณ<ExpL8>: (.T.) Via WorkFlow/Schedule. (.F.) Via Menu.       บฑฑ
ฑฑบ          ณ<ExpC9>: Nome do programa que efetuou a chamada             บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑบObservacaoณNao esquecer de incluir o #include "Ap5Mail.ch"             บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑบUso       ณGenerico.                                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function TAF99EMAI( _cServidor, _cConta, _cPassWord, _cFrom, _cDestino, _cSubject, _cMensagem,_cCopia,  _aAttach, _lWorkFlow, _cProg )
  Local _cAttach := ""
  Local _nPos, _lConectou, _lEnviado, _lDisConectou
  //parametros Padrใo
  Default _cServidor  := AllTrim(SuperGetMV("MV_RELSERV",,""))
  Default _cConta     := AllTrim(SuperGetMV("MV_EMCONTA",,""))
  Default _cPassWord  := AllTrim(SuperGetMV("MV_EMSENHA",,""))
  Default _cProg      := ""    
  Default _aAttach    := {}   
  Default _cSubject   := ""
  Default _cFrom      := _cConta  
  Default _cCopia     := ""
  
  If _cMensagem == Nil 
    If ! _lWorkFlow
      Aviso( _cProg+"002", "Nao foi enviada dados para mensagem !", {"Ok"} ) 
    Else
      CONOUT("Nao foi enviada dados para mensagem "+_cProg)
    EndIf
    Return .F.
  Endif

  CONNECT SMTP SERVER _cServidor ACCOUNT _cConta PASSWORD _cPassword Result _lConectou

  If ! _lConectou
    If ! _lWorkFlow
      Aviso( _cProg+"003", "Nao foi possivel conectar ao servidor !", {"Ok"} ) 
    Else
      CONOUT("Nao foi possivel conectar ao servidor "+_cProg)
    EndIf
    Return _lConectou
  Endif

  //ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
  //ณ Verifica quais sao os Atachados.             ณ
  //ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

  If Valtype(_aAttach) == "A" .and. Len(_aAttach) > 0
    For _nPos := 1 To Len(_aAttach)
      If _nPos == 1
        _cAttach += _aAttach[_nPos]
      Else
        _cAttach += ", "+aAttach[_nPos]
      EndIf
    Next
  Endif
  If ValType(_cCopia) == 'C' .and. !Empty(_cCopia)
    SEND MAIL From       _cFrom;
              To         _cDestino;
              CC         _cCopia;
              SUBJECT    _cSubject ;
              BODY       _cMensagem ;
              ATTACHMENT _cAttach;
              RESULT     _lEnviado
  Else
    SEND MAIL From       _cFrom;
              To         _cDestino;
              SUBJECT    _cSubject ;
              BODY       _cMensagem ;
              ATTACHMENT _cAttach;
              RESULT     _lEnviado
  EndIf

  If _lEnviado
    If !_lWorkFlow
      Aviso( _cProg+"004", "E-Mail Enviado com Sucesso !", {"Ok"} ) 
    Else
      CONOUT("E-Mail Enviado com Sucesso! "+_cProg)
    EndIf
  Else
    _cMensagem := ""
    GET MAIL ERROR _cMensagem
    If ! _lWorkFlow
      Alert(_cMensagem)
    Else
      CONOUT(_cMensagem)
    EndIf
  Endif
  CONOUT("Destinatario: "+ _cDestino)
  DISCONNECT SMTP SERVER Result _lDisConectou

  If !_lDisConectou
    If ! _lWorkFlow
      Aviso( _cProg+"005", "Nao foi possivel desconectar do servidor de E-Mail - " + _cServidor,"Erro ao Desconectar !", {"Ok"} ) 
    Else
      CONOUT("Nao foi possivel desconectar do servidor de E-Mail - " + _cServidor+" "+_cProg)
    EndIf
  Endif

  Return(_lEnviado)



