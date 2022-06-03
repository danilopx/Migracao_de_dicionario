#include "protheus.ch"
#include "topconn.ch"

#define CPL CHR(13) + CHR(10)
#define ENTER CHR(13) + CHR(10)

/*
ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ MTA410   ºAutor  ³ Fernando Salvatori º Data ³  12/15/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ponto de Entrada executado para validar toda a Getdados    º±±
±±º          ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function MTA410T()

Local nQtdSal := 0
local lflag := .T.
Local nX := 0
Local nI := 0
Local aAreaAtu		:= GetArea()
Local cAliasBKP		:= Alias()
Local aOrdBKP 		:= SaveOrd({"SC9","SC5","SC6"})

PRIVATE cCusMed  		:= GetMv("MV_CUSMED")	// CT - transf I
PRIVATE aRegSD3  		:= {} 					// CT - transf I

PRIVATE LMSHELPAUTO 	:= .T.
PRIVATE LMSERROAUTO 	:= .F.
PRIVATE NRECORIG		:= 0 
PRIVATE NRECDEST		:= 0
PRIVATE CLOCORIG		:= ""
PRIVATE CLOCDEST		:= ""
PRIVATE AAREASD3

If altera 
	cItem      := aScan( aHeader, {|x| Alltrim(x[2]) == "C6_ITEM"} )
	cProduto   := aScan( aHeader, {|x| Alltrim(x[2]) == "C6_PRODUTO"} )
	cAlmox     := aScan( aHeader, {|x| Alltrim(x[2]) == "C6_LOCAL"  } )
	cCli       := aScan( aHeader, {|x| Alltrim(x[2]) == "C6_CLI"    } )
	cLoj       := aScan( aHeader, {|x| Alltrim(x[2]) == "C6_LOJA"   } )
	nPosQtdLib := aScan( aHeader, {|x| Alltrim(x[2]) == "C6_QTDLIB" } )
	nPosQtdVen := aScan( aHeader, {|x| Alltrim(x[2]) == "C6_QTDVEN" } )
	
	For nI := 1 To Len(aCOLS)
				
		_nQtdent:=Posicione("SC6",1,xFilial("SC6")+M->C5_NUM+aCols[ni,cItem]+aCols[ni,cProduto],"C6_QTDENT" )
		_nQtdEmp:=Posicione("SC6",1,xFilial("SC6")+M->C5_NUM+aCols[ni,cItem]+aCols[ni,cProduto],"C6_QTDEMP" )
		nQtdSal := ( ACOLS[NI,nPosQtdVen] - (  _nQtdEmp +  _nQtdent ))
		
		If (IsInCallStack("MATA440") .Or. IsInCallStack("U_FATMI006")) .and. ACOLS[NI,nPosQtdVen] > (  _nQtdEmp +  _nQtdent ) .And. (ACOLS[NI,nPosQtdLib] < nQtdSal )
			Reclock("SC5",.F.)
			SC5->C5_LIBPARC := 'S '
			Msunlock()
			lflag:=.f.
		Endif
		
		IF  (IsInCallStack("MATA440") .Or. IsInCallStack("U_FATMI006"))
			If SC5->C5_LIBPARC=='S ' .And. nQtdSal==0 .And. lflag
				Reclock("SC5",.F.)
				SC5->C5_LIBPARC := '  '
				Msunlock()
			Endif
		ENDIF
		
		If funname()=="MATA410" .And. ALTERA
			Reclock("SC5",.F.)
			SC5->C5_LIBPARC := '  '
			Msunlock()
		Endif
	NEXT nI
	
	If Len(aCOLS)> 1 .And. (IsInCallStack("MATA440") .Or. IsInCallStack("U_FATMI006"))
		For nI := 1 To Len(aCOLS)
			_nQtdent:=Posicione("SC6",1,xFilial("SC6")+M->C5_NUM+aCols[ni,cItem]+aCols[ni,cProduto],"C6_QTDENT" )
			_nQtdEmp:=Posicione("SC6",1,xFilial("SC6")+M->C5_NUM+aCols[ni,cItem]+aCols[ni,cProduto],"C6_QTDEMP" )
			nQtdSal := ( ACOLS[NI,nPosQtdVen] - (  _nQtdEmp +  _nQtdent ))
			IF  nQtdSal > 0
				Reclock("SC5",.F.)
				SC5->C5_LIBPARC := 'S '
				Msunlock()
			Endif
		NEXT nI
	Endif
Endif

//Verificacao do preenchimento da aliquota de ST no final do Pedido de Venda\
For nX := 1 to Len( aCols )
	N := nX
Next nX

RestOrd(aOrdBKP)
DbSelectArea(cAliasBKP)
RestArea(aAreaAtu)

Return
