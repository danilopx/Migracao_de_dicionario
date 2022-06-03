#Include "Protheus.Ch"
//-----------------------------------------------------------------------------
// Programa      MT140TOK
// Autor         Ronald Piscioneri
// Data          16-Junho-2021
// Descricao     Ponto de Entrada para validar todos os dados antes de gravar
//               a Pre-Nota
// Uso           Especifico Taiff - Proart
//-----------------------------------------------------------------------------
User Function MT140TOK()
Local cChkTDev := SuperGetMV("MT140TOK01",,"|0301|0302|") // Exemplo de conteudo: "|0301|0302|"
Local lRet := .T.

If cTipo == "D"
    If !Empty( cChkTDev ) 
        If ( Alltrim(cEmpAnt) + Alltrim(cFilAnt) ) $ cChkTDev
            lRet := U_TFRTTDV()
        EndIf
    EndIf
EndIf

Return(lRet)



//-----------------------------------------------------------------------------------
// Programa      TFRTTDV
// Autor         Ronald Piscioneri
// Data          28-Junho-2021
// Descricao     Preenche campo "Tipo Devolucao" da Pre-Nota ou Documento de Entrada
// Uso           Especifico Taiff - Proart
//-----------------------------------------------------------------------------------
User Function TFRTTDV()
Local lRet := .T.
Local lNInfTDv := .F.
Local cCodDev := ""
Local nPTDev := 0
Local nNx := 0
Local aTDevs := {}

nPTDev := ASCAN(aHeader,{|x| ALLTRIM(x[2]) == "D1_TFDEVOL"})
If nPTDev > 0
    For nNx := 1 to Len(aCols)
        If !aCols[ nNx, Len(aCols[nNx]) ]
            If !Empty( aCols[nNx,nPTDev] )
                If ASCAN( aTDevs, {|x| x == aCols[nNx,nPTDev]} ) == 0
                    aAdd( aTDevs, aCols[nNx,nPTDev] )
                EndIf
            Else
                lNInfTDv := .T.
            EndIf
        EndIf
    Next nNx
    If ( lNInfTDv .Or. Len(aTDevs) <> 1 ) .Or. ALTERA
        cCodDev := RetCDev()
        For nNx := 1 to Len(aCols)
            If !aCols[ nNx, Len(aCols[nNx]) ]
                aCols[nNx,nPTDev] := cCodDev
            EndIf
        Next nNx
    EndIf
EndIf

Return( lRet )



//-----------------------------------------------------------------------------
// Programa      RetCDev
// Autor         Ronald Piscioneri
// Data          28-Junho-2021
// Descricao     Exibe lista de tipos de devolucao disponiveis, para uso na 
//               Pre-Nota e Documento de Entrada.
// Uso           Especifico Taiff - Proart
//-----------------------------------------------------------------------------
Static Function RetCDev()
Local cZAETbl := RetSqlName("ZAE")
Local cZAEFil := xFilial("ZAE")
Local cQry := ""
Local cRet := ""
Local nPAt := 0
Local aLbxA := {}
Local oBtOk := Nil
Local oSy1 := Nil
Local oSy2 := Nil
Local oLbxA := Nil
Local oDgA := Nil

cQry := "SELECT ZAE_COD, ZAE_DESCR "
cQry += "FROM " +cZAETbl+ " WHERE D_E_L_E_T_ = ' ' "
cQry += "AND ZAE_FILIAL = '" +cZAEFil+ "' "
cQry += "AND ZAE_TIPO = '1' "
cQry += "ORDER BY ZAE_COD, ZAE_DESCR"

Iif(Select("WRKXZAE")>0,WRKXZAE->(dbCloseArea()),Nil)
dbUseArea(.T.,"TOPCONN",TCGenQry(,,cQry),"WRKXZAE",.T.,.T.)
WRKXZAE->(dbGoTop())

While WRKXZAE->(!EoF())
    aAdd( aLbxA, { WRKXZAE->ZAE_COD, WRKXZAE->ZAE_DESCR } )
    WRKXZAE->(dbSkip())
EndDo
WRKXZAE->(dbCloseArea())

If Len(aLbxA) > 0

    While Empty(cRet)

        DEFINE MSDIALOG oDgA TITLE "Tipos de Devolução" FROM 000, 000  TO 300, 500 COLORS 0, 16777215 PIXEL STYLE DS_MODALFRAME
            oDgA:lEscClose := .F.
            @ 003, 003 SAY oSy1 PROMPT "Para NFs de devolução, é obrigatório escolher um tipo na lista abaixo:" SIZE 242, 007 OF oDgA COLORS 0, 16777215 PIXEL
            @ 014, 003 LISTBOX oLbxA Fields HEADER "Codigo","Descrição" SIZE 244, 118 OF oDgA PIXEL ColSizes 50,50
            oLbxA:SetArray(aLbxA)
            oLbxA:bLine := {||{aLbxA[oLbxA:nAt,1],aLbxA[oLbxA:nAt,2]}}
            oLbxA:bLDblClick := {||nPAt:=oLbxA:nAt,oDgA:End()}
            @ 136, 003 SAY oSy2 PROMPT "Selecione uma opção, dê um duplo-clique na linha ou botão Ok" SIZE 205, 007 OF oDgA COLORS 0, 16777215 PIXEL
            @ 134, 210 BUTTON oBtOk PROMPT "Ok" Action(nPAt:=oLbxA:nAt,oDgA:End()) SIZE 037, 012 OF oDgA PIXEL
        ACTIVATE MSDIALOG oDgA CENTERED

        If MsgYesNo("Confirma a escolha do tipo de devolução:"+CRLF+CRLF+Alltrim(aLbxA[nPAt,1])+" - "+Alltrim(aLbxA[nPAt,2])+" ?")
            cRet := aLbxA[nPAt,1]
        Else
            cRet := ""
        EndIf

    EndDo

EndIf

Return(cRet)
