#include "PROTHEUS.CH"

User Function MT410ROD
//---------------------------------------------------------------------------------------------------------------------------- 
// Variaveis: TOTVS 
//---------------------------------------------------------------------------------------------------------------------------- 
Local lUniNeg	:= cEmpAnt+cFilant $ GETNEWPAR('MV_UNINEG'/*cParametro*/, cEmpAnt+cFilant /*cPadrao*/, /*cFilial*/)
//--------------------------------------------[ Fim Customização TOTVS ]------------------------------------------------------
Eval(ParamIXB[1],ParamIXB[2],ParamIXB[3], ParamIXB[4],ParamIXB[5])
//---------------------------------------------------------------------------------------------------------------------------- 
// Ponto de Validação: TOTVS 
// Descrição: Validar unidade de negocio no produto
// Merge.......: TAIFF - C. Torres                                           Data: 10/04/2013
//---------------------------------------------------------------------------------------------------------------------------- 
If FunName() == "MATA410" .and. lUniNeg .and.;
	( Type("l410Auto") == "U" .Or. ! l410Auto ) .and. (ALTERA .or. INCLUI) .and. (IsInCallStack("A410Cli") .or. IsInCallStack("A410Loja")) .and. ;
	!IsInCallStack("A410LinOk") 	.and. !IsInCallStack("A410LinOk") 	.and. !IsInCallStack("A410IncRap") 	.and. !IsInCallStack("A410AltRap") .and. ;
	!IsInCallStack("A410ProcDv") 	.and. !IsInCallStack("A410RemBen") 	.and. !IsInCallStack("A410KeyF9") 	.and. !IsInCallStack("A410ReCalc") .and. ; 
	!IsInCallStack("A440Libera")
	//VALIDAÇÃO NA ALTERAÇÃO DE CODIGO DE CLIENTE NA INCLUSAO 
	If Inclui
		If !Empty(M->C5_CLIENTE) .and. !U_SZXVldCli(.F.)
			M->C5_TABELA	:=SPACE(TamSX3("C5_TABELA")[1])
			M->C5_CONDPAG	:=SPACE(TamSX3("C5_CONDPAG")[1])
			M->C5_VEND1		:=SPACE(TamSX3("C5_VEND1")[1])
			M->C5_COMIS1	:=SPACE(TamSX3("C5_COMIS1")[1])
			M->C5_TPFRETE	:=SPACE(TamSX3("C5_TPFRETE")[1])
			M->C5_TIPOCLI	:=SPACE(TamSX3("C5_TIPOCLI")[1])
			M->C5_CLIENT	:=SPACE(TamSX3("C5_CLIENT")[1])
			M->C5_LOJAENT	:=SPACE(TamSX3("C5_LOJAENT")[1])
			M->C5_TRANSP	:=SPACE(TamSX3("C5_TRANSP")[1]) 
			
			M->C5_NOMTABE	:=""
			M->C5_NOMCOND	:=""
			M->C5_NOMVEND	:="" 
			M->C5_NOMTRAN	:=""
		Endif
	Endif
	If ALTERA 
		If M->C5_CLIENTE<>SC5->C5_CLIENTE .AND. U_SZXVldCli(.F.)
			M->C5_TABELA	:=SPACE(TamSX3("C5_TABELA")[1])
			M->C5_CONDPAG	:=SPACE(TamSX3("C5_CONDPAG")[1])
			M->C5_VEND1		:=SPACE(TamSX3("C5_VEND1")[1])
			M->C5_COMIS1	:=SPACE(TamSX3("C5_COMIS1")[1])
			M->C5_TPFRETE	:=SPACE(TamSX3("C5_TPFRETE")[1])
			M->C5_TIPOCLI	:=SPACE(TamSX3("C5_TIPOCLI")[1])
			M->C5_CLIENT	:=SPACE(TamSX3("C5_CLIENT")[1])
			M->C5_LOJAENT	:=SPACE(TamSX3("C5_LOJAENT")[1])
			M->C5_TRANSP	:=SPACE(TamSX3("C5_TRANSP")[1]) 
			
			M->C5_NOMTABE	:=""
			M->C5_NOMCOND	:=""
			M->C5_NOMVEND	:="" 
			M->C5_NOMTRAN	:=""
		  
			M->C5_TABELA	:=SZX->ZX_TABELA
			M->C5_NOMTABE	:=POSICIONE("DA0", 1, XFILIAL("DA0")+SZX->ZX_TABELA, "DA0_DESCRI")
			M->C5_CONDPAG	:=SZX->ZX_CONDPAG
			M->C5_NOMCOND	:=POSICIONE("SE4", 1, XFILIAL("SE4")+SZX->ZX_CONDPAG, "E4_DESCRI")
			M->C5_VEND1		:=SZX->ZX_CODVEN
			M->C5_COMIS1	:=SZX->ZX_COMIS
			M->C5_NOMVEND	:=POSICIONE("SA3", 1, XFILIAL("SA3")+SZX->ZX_CODVEN, "A3_NOME")
			M->C5_TRANSP	:=SA1->A1_TRANSP 
			M->C5_NOMTRAN	:=POSICIONE("SA4", 1, XFILIAL("SA4")+M->C5_TRANSP, "A4_NOME")                                                  
	      M->C5_NOMCLI	:=POSICIONE("SA1", 1, XFILIAL("SA1")+M->C5_CLIENTE+M->C5_LOJACLI , "A1_NOME")
	      M->C5_VEND1		:=SZX->ZX_CODVEN
			M->C5_TPFRETE 	:=SA1->A1_TPFRET
			M->C5_INCISS 	:=SA1->A1_INCISS
			M->C5_TIPOCLI 	:=IIF(M->C5_TIPO $ "DB",IIF(SA2->A2_TIPO=="J","R",SA2->A2_TIPO),SA1->A1_TIPO)
			M->C5_LOJAENT 	:=IIF(M->C5_TIPO $ "DB", SA2->A2_LOJA, SA1->A1_LOJA )
	  	Elseif M->C5_CLIENTE<>SC5->C5_CLIENTE .AND. !U_SZXVldCli(.T.)
			M->C5_TABELA	:=SPACE(TamSX3("C5_TABELA")[1])
			M->C5_CONDPAG	:=SPACE(TamSX3("C5_CONDPAG")[1])
			M->C5_VEND1		:=SPACE(TamSX3("C5_VEND1")[1])
			M->C5_COMIS1	:=SPACE(TamSX3("C5_COMIS1")[1])
			M->C5_TPFRETE	:=SPACE(TamSX3("C5_TPFRETE")[1])
			M->C5_TIPOCLI	:=SPACE(TamSX3("C5_TIPOCLI")[1])
			M->C5_CLIENT	:=SPACE(TamSX3("C5_CLIENT")[1])
			M->C5_LOJAENT	:=SPACE(TamSX3("C5_LOJAENT")[1])
			M->C5_TRANSP	:=SPACE(TamSX3("C5_TRANSP")[1]) 
			
			M->C5_NOMTABE	:=""
			M->C5_NOMCOND	:=""
			M->C5_NOMVEND	:="" 
			M->C5_NOMTRAN	:=""	  	
		Endif
	Endif	
Endif
//--------------------------------------------[ Fim Customização TOTVS ]------------------------------------------------------

If  (IsInCallStack("MATA440") .Or. IsInCallStack("U_FATMI006")) .and. ! U_EntFracCli(SC5->C5_CLIENTE)   // Cliente Nao Aceita Entrega Fracionada
   MT410QtdLib()
Endif

Return Nil

Static Function MT410QtdLib()
Local nQtdLib, nQtdVen, cProduto, cLocal     	
Local nQuantB2  :=0
Local cFilSB2 :=xFilial("SB2")
            									
Local nMax:=Len(aCols), nx
Local nPProduto	 :=aScan(aHeader,{|x| AllTrim(x[2])=="C6_PRODUTO"})
Local nPLocal	 :=aScan(aHeader,{|x| AllTrim(x[2])=="C6_LOCAL"})
Local nPosQtdVen :=aScan(aHeader,{|x| AllTrim(x[2])=="C6_QTDVEN"})
Local nPosQtdLib :=aScan(aHeader,{|x| AllTrim(x[2])=="C6_QTDLIB"})
Local nDeleted   :=Len(aHeader)+1

For nx:=1 to nMax 
	
	If aCols[nX][nDeleted]
	   Loop
	Endif
	
    cProduto:= aCols[nx][nPProduto]
    cLocal  := aCols[nx][nPLocal]    
    nQtdVen := aCols[nx][nPosQtdVen]
    nQtdLib := aCols[nx][nPosQtdLib]
        
	If SB2->(dbSeek(cFilSB2+cProduto+cLocal))
	   nQuantB2:=SaldoSB2()
	EndIf    
   
    nQtdLib := nQtdVen 

    If nQuantB2 < nQtdVen
       nQtdLib:=nQuantB2
    Endif
    
    nNvQtdLib:= U_CalcMultLib(cProduto,nQtdLib)    // Funcao Definida no fonte MFAT022.PRW - ROBSON SANCHEZ  - 08/01/10
    aCols[nx][nPosQtdLib]:=nNvQtdLib

Next

Return nil






/*
User Function TelaF3(nColBrw)
                                                 
Local nPProduto	 :=aScan(aHeader,{|x| AllTrim(x[2])=="C6_PRODUTO"})
Local nPosSerDe  :=aScan( aHeader, {|z| Alltrim(z[2]) $ "C6_SERDE"})
Local nPosSerAte :=aScan( aHeader, {|z| Alltrim(z[2]) $ "C6_SERATE"})
Local nPosQtdVen :=aScan(aHeader,{|x| AllTrim(x[2])=="C6_QTDVEN"})
Local nQtdVen

M->AA3_CODPRO:= aCols[n][nPProduto]                // Utilizada na consulta padrao SXB 
M->AA3_CODCLI:=GetMv("MV_ATESTCL")                 // Utilizada na consulta padrao SXB 

If Empty( M->AA3_CODPRO )
   MsgStop('Codigo do Produto deve ser informado','Atencao')
   Return nil
Endif

If ConPad1(,,,"AA3A",,,.F.)

//   aCols[n,aScan( aHeader, {|z| Alltrim(z[2]) $ "C6_SERDE,C6_SERATE"} )] := AA3->AA3_NUMSER

   aCols[n,nColBrw] := AA3->AA3_NUMSER

   If nColBrw == nPosSerDe
      
      nQtdVen:=Int(aCols[n,nPosQtdVen])
      
      aCols[n,nPosSerAte]:=U_ApuraSerieAte(nQtdVen,AA3->AA3_NUMSER)
      
   Endif

EndIf
 

Return Nil

User Function MTEC001(pCampo)
Return ""

User Function MTEC002()
Return ""

User Function ChkCols(nColBrw)

Local lRet:=.f.
Local nPosSerDe :=aScan( aHeader, {|z| Alltrim(z[2]) $ "C6_SERDE"})
Local nPosSerAte:=aScan( aHeader, {|z| Alltrim(z[2]) $ "C6_SERATE"})

If nColBrw == nPosSerDe .or. nColBrw == nPosSerAte
   lRet:=.t.
Endif

Return lRet

User Function chkSerie()

Local nPosSerDe  :=aScan( aHeader, {|z| Alltrim(z[2]) $ "C6_SERDE"})
Local nPosSerAte :=aScan( aHeader, {|z| Alltrim(z[2]) $ "C6_SERATE"})

Local nPosQtdVen :=aScan(aHeader,{|x| AllTrim(x[2])=="C6_QTDVEN"})
Local nQtdVen,cSerieIni,cSerieAte

nQtdVen    :=Acols[n,nPosQtdVen]
cSerieIni  :=Acols[n,nPosSerDe]

cSerieAte:=U_ApuraSerie(nQtdVen,cSerieIni)

If Empty(cSerieAte)
   Return .t.
Endif

aCols[n,nPosSerAte]:=cSerieAte
Return .t.



User Function ApuraSeriAte(nQtde,cSerieIni)

Local cSerie:=cSerieIni

If Empty(cSerieIni) .and. !Empty(nQtDe)
   MsgInfo("SERIE INICIAL DEVE SER INFORMADA","Atencao")
   Return ""
Endif   

For nx:=1 to nQtde-1
	cSerie:=Soma1(cSerie)
Next

Return cSerie
*/
