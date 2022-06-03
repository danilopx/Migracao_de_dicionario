#INCLUDE "Protheus.ch"
#INCLUDE "Topconn.ch"
#IFNDEF CRLF
	#DEFINE CRLF ( chr(13)+chr(10) )
#ENDIF

//
// Funcao: Permitir ao usuario alterar a data de embarque da NF e atualizar o status do embarque
//
//
User Function TAIFACD1
Local xAlias	 := GetArea()

U_ViewOS()

RestArea(xAlias)
Return(.T.)

//
// Funçao para montar a BROWSE
//
User Function ViewOS()

Local aCampos := {}
Private cAlias    := "OSS"
Private cCadastro := "Status e emissao da OS"
Private aRotina   := { { "STATUS"	,"U_StatusOs()", 0 , 6 }} 

_cQuery := "SELECT '  ' AS STA_OK, CB7_ORDSEP, CB7_STATUS, CB7_NOTA, " 
_cQuery += "   CONVERT(char(12), CONVERT(DATETIME,CB7_DTFIMS), 103) AS CB7_DTFIMS , '          ' AS OBSERVA, "
_cQuery += "        ( CASE WHEN ( SELECT TMPC5.C5_TIPO FROM SC5010 TMPC5 WHERE CB7.CB7_FILIAL=TMPC5.C5_FILIAL AND TMPC5.C5_NUM = 
_cQuery += "        			(
_cQuery += "        				SELECT DISTINCT SC9.C9_PEDIDO FROM SC9010 SC9
_cQuery += "        					WHERE CB7.CB7_FILIAL=SC9.C9_FILIAL AND CB7.CB7_NOTA=SC9.C9_NFISCAL AND CB7.CB7_SERIE=SC9.C9_SERIENF 
_cQuery += "        				      AND CB7.CB7_CLIENT=SC9.C9_CLIENTE AND CB7.CB7_LOJA=SC9.C9_LOJA AND SC9.D_E_L_E_T_ != '*'
_cQuery += "        			) AND TMPC5.D_E_L_E_T_!='*') IN ('D','B') 
_cQuery += "            THEN Left(SA2.A2_NOME,40)     "
_cQuery += "            ELSE Left(SA1.A1_NOME,40) END "
_cQuery += "        ) AS CLIENTE "
_cQuery += "  FROM " + RetSqlName("CB7") + " CB7 " 
_cQuery += "  LEFT OUTER JOIN " + RetSqlName("SA1") + " SA1 ON SA1.A1_FILIAL='"+xFilial("SA1")+"' AND SA1.A1_COD=CB7.CB7_CLIENT AND SA1.A1_LOJA=CB7.CB7_LOJA AND SA1.D_E_L_E_T_ != '*'" 
_cQuery += "  LEFT OUTER JOIN " + RetSqlName("SA2") + " SA2 ON SA2.A2_FILIAL='"+xFilial("SA2")+"' AND SA2.A2_COD=CB7.CB7_CLIENT AND SA2.A2_LOJA=CB7.CB7_LOJA AND SA2.D_E_L_E_T_ != '*'" 
_cQuery += " WHERE CB7.CB7_FILIAL = '" + xFilial("CB7") + "' "
_cQuery += "   AND CB7.D_E_L_E_T_ != '*' "    
_cQuery += "   AND CB7.CB7_STATUS > '1' AND CB7.CB7_STATUS < '9' AND CB7.CB7_LOCAL IN ('21','96') "  
_cQuery += "  ORDER BY CB7.CB7_NOTA "  

If Select("OSS") > 0
   OSS->(DbCloseArea())
Endif

TcQuery _cQuery NEW ALIAS ("OSS")

DbSelectArea("OSS")

cArq := CriaTrab(NIL,.F.)
Copy To &cArq

dbUseArea(.T.,,cArq,"OS2",.F.)

DbSelectArea("OS2")
OS2->(DBGotop())

AADD(aCampos, {"STA_OK"     , NIL ,"Ok"  })
AADD(aCampos, {"CB7_NOTA"   , NIL ,"n. NF"})
AADD(aCampos, {"CLIENTE"    , NIL ,"Cliente"})
AADD(aCampos, {"CB7_STATUS" , NIL ,"Status"})
AADD(aCampos, {"CB7_DTFIMS" , NIL ,"Embarque"})
AADD(aCampos, {"OBSERVA"    , NIL ,"Observação"})
AADD(aCampos, {"CB7_ORDSEP" , NIL ,"Nro.OS"})

cMarca := GetMark()

MarkBrow("OS2","STA_OK",,aCampos,,GetMark(,"OS2", "STA_OK"))

OSS->(DbCloseArea())

If Select("OS2") > 0
	DbCloseArea()
	Ferase(cArq+".DTC")
Endif

Return(.T.)


User Function StatusOs()
Local aParamBox := {}
Local aRet		:= {}
//Local sConteudo
Local dData     := dDataBase - 1
Local _dEmissao := dDataBase
Local _cEmissao := ""
Local _nQtdDaOS := 0
Local _nEmbarOS := 0

Private cString := ""

Aadd(aParamBox,{1,"Data do Embarque",dData,PesqPict("ZA4","ZA4_DTFAB") ,"",""   ,"",50,.T.})

IF !ParamBox(aParamBox,"Informe os Parametros",@aRet)
	Return(.F.)
Endif
_dEmissao := aRet[1]
_cEmissao := Strzero( Day(_dEmissao) ,2) + "/" + Strzero( MONTH(_dEmissao),2) + "/" + Strzero( Year(_dEmissao) ,4)

DbSelectArea("OS2")
DbGotop()
While !OS2->(Eof())

   OS2->OBSERVA := ""

   IF Empty(OS2->STA_OK) 
      OS2->(DbSkip())
      Loop
   EndIF
   _nQtdDaOS := 0
   _nEmbarOS := 0
  
   dbSelectArea("CB7")
   dbSetOrder(1)
   If dbSeek( xFilial("CB7") + OS2->CB7_ORDSEP )

      dbSelectArea("CB8")
      dbSetOrder(1)
      dbSeek( xFilial("CB8") + OS2->CB7_ORDSEP )
      While CB8->CB8_ORDSEP = OS2->CB7_ORDSEP .AND. !CB8->(EOF()) 
         If CB8->CB8_LOCAL $ '21|96'
            _nQtdDaOS += CB8->CB8_QTDORI
            If CB8->CB8_SALDOS=0 .AND. CB8->CB8_SALDOE = CB8->CB8_QTDORI 
               _nEmbarOS += CB8_SALDOE
            Endif  
         Endif
         CB8->(DbSkip())
      End
      If _nQtdDaOS > 0 .and. _nEmbarOS=0
         OS2->CB7_DTFIMS := _cEmissao
         OS2->STA_OK     := ""
         OS2->CB7_STATUS := "9"
         OS2->OBSERVA    := ""
         
         CB7->(RecLock("CB7",.f.))
         CB7->CB7_STATUS := "9"
         CB7->CB7_STATPA := " "
         CB7->CB7_DTFIMS := Ctod( _cEmissao )
         CB7->CB7_DTEMBA := Ctod( _cEmissao )
         CB7->(MsUnlock())

		//MJL ini 06/6/2011 solicitacao DELTA
		SF2->(DbSetOrder(1))
		If SF2->(DbSeek(xFilial("SF2") + CB7->(CB7_NOTA + CB7_SERIE), .F.))
			SF2->(RecLock("SF2", .F.))
			SF2->F2_DTEMB := CB7->CB7_DTEMBA
			SF2->(MsUnLock())
		EndIf
		//MJL fim 06/6/2011

      Else   
         OS2->OBSERVA    := "com saldo"
      Endif
   Else
      OS2->OBSERVA    := "OS N/E"
   Endif
   OS2->(DbSkip())
End
DbSelectArea("OS2")
DbGotop()

Return(.T.)
