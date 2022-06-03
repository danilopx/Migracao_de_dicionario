/*ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³EMP650    ºAutor  ³Marcos J.           º Data ³  11/26/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ PE para manipular o local de empenho da OP.                º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
#include "protheus.ch"
User Function EMP650()
	Local cAlias   := Alias()
	Local aAreaB1  := SB1->(GetArea())
	Local nPosCod  := aScan(aHeader,{|x|AllTrim(x[2])=="G1_COMP"})
	Local nPosQuant:= aScan(aHeader,{|x|AllTrim(x[2])=="D4_QUANT"})
	Local nPosLocal:= aScan(aHeader,{|x|AllTrim(x[2])=="D4_LOCAL"})
	Local nPosEnder:= aScan(aHeader,{|x|AllTrim(x[2])=="DC_LOCALIZ"})
	//Local nPosQtBuf:= aScan(aHeader,{|x|AllTrim(x[2])=="D4_QTBUFF"})
	//Local cCodPai  := Right(Rtrim(ParamIxb[1]), 9)
	Local nI       := 0
	Local lOPBenef := .F.
	Private cMVLOCPROC := GetMV("MV_LOCPROC")		

	If SM0->M0_CODIGO == "01" .OR. (SM0->M0_CODIGO == "04" .AND. xFilial("SB1")='02')

		lOPBenef := POSICIONE("SB1",1,XFILIAL("SB1") + SC2->C2_PRODUTO,"B1_TIPO") == "BN"

		SB1->(DbSetOrder(1))
		SB1->(DbGoTop())
		
		For nI := 1 To Len(aCols)

			SB1->(DbSeek(xFilial("SB1") + aCols[nI, nPosCod], .F.)) 
			//Verifica se deve arredondar a quantidade empenhada
			If SB1->B1_AREDEMP == "S"
				aCols[nI, nPosQuant] := Round(aCols[nI, nPosQuant], 0)
			EndIf
			If SB1->B1_APROPRI == "D"
				If lOPBenef
					aCols[nI, nPosLocal] := "31"
					aCols[nI, nPosEnder] := ""
				ELSE
					aCols[nI, nPosLocal] := SB1->B1_LOCPAD
				ENDIF
				/*
				SB1->(DbSeek(xFilial("SB1") + cCodPai, .F.))
				If SB1->B1_TIPO == "PB"
					aCols[nI, nPosLocal] := "31"
				ElseIf SB1->B1_TIPO == "IB"
					aCols[nI, nPosLocal] := "31"
				ElseIf lOPBenef
					aCols[nI, nPosLocal] := "31"
				Else
					aCols[nI, nPosLocal] := "11"
				EndIf
				*/
			ElseIf SB1->B1_APROPRI == "I"
				aCols[nI, nPosLocal] := cMVLOCPROC
			Else
				aCols[nI, nPosLocal] := SB1->B1_LOCPAD
			EndIf

		Next nI 
	EndIf

/*
Autor....: Carlos Torres
Data.....: 09/08/2021
Descri??o: Regra para empresa ACTION - Indaiatuba, os produtos de OP de terceiros que podem ser PA ou PI ser?o
           empenhados no armaz?m 31 de opera??o de terceiros, o campo C2_TPPR quando igual a E se enquadra nesta regra
*/

	If (CEMPANT = "04" .AND. CFILANT="01") 
	
		lOPBenef := SC2->C2_TPPR="E"
		
		SB1->(DbSetOrder(1))
		
		For nI := 1 To Len(aCols)

			SB1->(DbSeek(xFilial("SB1") + aCols[nI, nPosCod], .F.)) 
			If SB1->B1_APROPRI == "I"
				aCols[nI, nPosLocal] := cMVLOCPROC
			ELSE
				If lOPBenef
					aCols[nI, nPosLocal] := "31"
					aCols[nI, nPosEnder] := ""
				ELSE
					aCols[nI, nPosLocal] := SB1->B1_LOCPAD
				ENDIF
			EndIf

		Next nI 
	EndIf

	RestArea(aAreaB1)
	DbSelectArea(cAlias)
	Return
	
/*ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³A650LEMP  ºAutor  ³TOTVS ABM           º Data ³  12/09/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ PE para alterar o empenho e op do item PB                  º±±
±±º          ³Ordens intermediarias                                       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function A650LEMP()
	Local aDados := aClone(ParamIxb)
	Local cAlmox := aDados[3]
	Local cAlias := Alias()
	Local lOPBenef := .F.

	If SM0->M0_CODIGO == "01" .OR. (SM0->M0_CODIGO == "04" .AND. xFilial("SB1")='02')
	
		lOPBenef := POSICIONE("SB1",1,XFILIAL("SB1") + SC2->C2_PRODUTO,"B1_TIPO") == "BN"
		SB1->(DbSetOrder(1))	
		SB1->(DbSeek(xFilial("SB1") + aDados[1], .F.))
		
		If SB1->B1_TIPO == "ET|MN"
			cAlmox := "11"
		ElseIf SB1->B1_TIPO == "IB"
			cAlmox := "31"
		ElseIf SB1->B1_TIPO == "PB"
			cAlmox := "11"
		ElseIf lOPBenef
			cAlmox := "31"
		EndIf
	EndIf

	DbSelectArea(cAlias)	
	Return(cAlmox)
