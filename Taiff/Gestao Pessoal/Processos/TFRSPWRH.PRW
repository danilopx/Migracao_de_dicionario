#Include "Protheus.Ch"
//*******************************************************************************************
// Funcao:     TFRSPWRH
// Finalidade: Cadastra acesso ao Portal RH (configuracoes, login e senha)
// Autor:      Ronald Piscioneri
// Data:       09-Maio-2022
// Uso:        Especifico Taiff
//*******************************************************************************************
User Function TFRSPWRH()
Local oFt1 := TFont():New("Arial",,018,,.T.,,,,,.F.,.F.)
Local aALbx := {{"","","","","","","","","",0}}
Local cGtPsq := Space(200)
Local oBAtl, oBPq, oBSr, oGtPsq, oSay1, oSay2, oSay3, oSay4, oDlg, oALbx := Nil

DEFINE MSDIALOG oDlg TITLE "Acesso Portal RH" FROM 000, 000  TO 300, 800 COLORS 0, 16777215 PIXEL

    @ 002, 002 SAY oSay1 PROMPT "Nome do Funcionário / Participante:" SIZE 293, 007 OF oDlg COLORS 0, 16777215 PIXEL
    @ 012, 002 MSGET oGtPsq VAR cGtPsq SIZE 305, 012 OF oDlg COLORS 0, 16777215 FONT oFt1 PIXEL
    @ 012, 312 BUTTON oBPq PROMPT "Pesquisa na Empresa "+cEmpAnt+" Filial " +cFilAnt Action(PsqFunc(cGtPsq,@aALbx,@oALbx)) SIZE 085, 016 OF oDlg PIXEL
    @ 028, 002 SAY oSay2 PROMPT 'Resultado da pesquisa. Selecione uma linha abaixo e clique em "Atualizar Login e Reiniciar Senha"' SIZE 392, 009 OF oDlg COLORS 0, 16777215 PIXEL
    @ 037, 002 LISTBOX oALbx Fields HEADER "Matric","Nome Funcionario","CPF","Admissao","Nascto.","Status","Login Portal","Senha","Cargo" SIZE 394, 090 ColSizes 20,55,27,20,20,20,22,12,32 OF oDlg PIXEL
    oALbx:SetArray(aALbx)
    oALbx:bLine := {|| {aALbx[oALbx:nAt,1],aALbx[oALbx:nAt,2],aALbx[oALbx:nAt,3],aALbx[oALbx:nAt,4],aALbx[oALbx:nAt,5],aALbx[oALbx:nAt,6],aALbx[oALbx:nAt,7],aALbx[oALbx:nAt,8],aALbx[oALbx:nAt,9]}}
    oALbx:bChange := {||oBAtl:Refresh()}
    @ 130, 002 SAY oSay3 PROMPT "OBS.: a senha será reiniciada para o padrão do sistema, que é:" SIZE 236, 007 OF oDlg COLORS 0, 16777215 PIXEL
    @ 138, 002 SAY oSay4 PROMPT "Ano de nascimento com 2 dig. + Dia da contratação com 2 dig. + 2 últimos dígitos do CPF (DV)" SIZE 236, 007 OF oDlg COLORS 0, 16777215 PIXEL
    @ 133, 240 BUTTON oBAtl PROMPT "Atualizar Login / Reiniciar Senha" Action(AltLgin(aALbx[oALbx:nAt],@aALbx,@oALbx,@cGtPsq,@oGtPsq,@oDlg)) SIZE 113, 012 OF oDlg PIXEL
    @ 133, 358 BUTTON oBSr PROMPT "Sair" Action(oDlg:End()) SIZE 037, 012 OF oDlg PIXEL

ACTIVATE MSDIALOG oDlg CENTERED

Return(Nil)



//*******************************************************************************************
// Funcao:     PSQFUNC
// Finalidade: Pesquisa funcionario / participante
// Autor:      Ronald Piscioneri
// Data:       09-Maio-2022
// Uso:        Especifico Taiff
//*******************************************************************************************
Static Function PsqFunc( cGtPsq, aALbx, oALbx )
Local cQry := ""
Local cStPsw := ""
Local cStPtl := ""

aALbx := {}

If Len(Alltrim(cGtPsq)) > 2

    cQry := "SELECT DISTINCT "
    cQry += "SRA.RA_MAT AS MATR, "
    cQry += "SRA.RA_NOME AS NOME, "
    cQry += "SRA.RA_CIC AS CPF, "
    cQry += "SRA.RA_ADMISSA AS DTADMIS, "
    cQry += "SRA.RA_NASC AS DTNASC, "
    cQry += "SRA.RA_SITFOLH AS STUSR, "
    cQry += "RD0.RD0_LOGIN AS LOGPTAL, "
    cQry += "RD0.RD0_PORTAL AS CODPTAL, "
    cQry += "RD0.RD0_SENHA AS PSWPTAL, "
    cQry += "SQ3.Q3_DESCSUM AS CARGO, "
    cQry += "RD0.RD0_MSBLQL AS BLQPTAL, "
    cQry += "RD0.R_E_C_N_O_ AS RD0RCN, "
    cQry += "SRA.R_E_C_N_O_ AS SRARCN "
    cQry += "FROM "
    cQry += RetSqlName("RDZ")+ " RDZ, "
    cQry += RetSqlName("SRA")+ " SRA, "
    cQry += RetSqlName("RD0")+ " RD0, "
    cQry += RetSqlName("SQ3")+ " SQ3 "
    cQry += "WHERE RDZ.D_E_L_E_T_ = ' ' "
    cQry += "AND RDZ.RDZ_FILIAL = '" +xFilial("RDZ")+ "' "
    cQry += "AND RDZ.RDZ_EMPENT = '" +cEmpAnt+ "' "
    cQry += "AND RDZ.RDZ_FILENT = SRA.RA_FILIAL "
    cQry += "AND RDZ.RDZ_CODENT = SRA.RA_FILIAL + SRA.RA_MAT "
    cQry += "AND RDZ.RDZ_ENTIDA = 'SRA' "
    cQry += "AND SRA.D_E_L_E_T_ = ' ' "
    cQry += "AND SRA.RA_FILIAL = '" +xFilial("SRA")+ "' "
    cQry += "AND SRA.RA_NOME LIKE '%" +Upper(Alltrim(cGtPsq))+ "%' "
    cQry += "AND RD0.D_E_L_E_T_ = ' ' "
    cQry += "AND RD0.RD0_FILIAL = '" +xFilial("RD0")+ "' "
    cQry += "AND RD0.RD0_CODIGO = RDZ.RDZ_CODRD0 "
    cQry += "AND RD0.RD0_CIC = SRA.RA_CIC "
    cQry += "AND SQ3.D_E_L_E_T_ = ' ' "
    cQry += "AND SQ3.Q3_FILIAL = '" +xFilial("SQ3")+ "' "
    cQry += "AND SQ3.Q3_CARGO = SRA.RA_CARGO "
    cQry += "ORDER BY SRA.RA_MAT "

    Iif(Select("WRKXFN")>0,WRKXFN->(dbCloseArea()),Nil)
    dbUseArea(.T.,"TOPCONN",TCGenQry(,,cQry),"WRKXFN",.T.,.T.)
    TcSetField("WRKXFN","RD0RCN","N",14,0)
    TcSetField("WRKXFN","SRARCN","N",14,0)
    TcSetField("WRKXFN","DTADMIS","D",8,0)
    TcSetField("WRKXFN","DTNASC","D",8,0)
    WRKXFN->(dbGoTop())

    While WRKXFN->(!EoF())

        If !Empty(Alltrim(WRKXFN->PSWPTAL))
            cStPsw := "Gerada"
        Else
            cStPsw := ""
        EndIf

        cStPtl := ""
        If WRKXFN->STUSR == "D"
            cStPtl := "Demitido"
        Else
            If WRKXFN->BLQPTAL == "1"
                cStPtl := "Bloqueado"
            Else            
                If Alltrim(WRKXFN->CODPTAL) == "000003"
                    cStPtl := "Portal Ok"
                Else
                    cStPtl := "Nao Config."
                EndIf
            EndIf
        EndIf

        aAdd( aALbx, {  Alltrim(WRKXFN->MATR),;  
                        Alltrim(WRKXFN->NOME),;
                        Alltrim(WRKXFN->CPF),;
                        Alltrim(DtoC(WRKXFN->DTADMIS)),;
                        Alltrim(DtoC(WRKXFN->DTNASC)),;
                        cStPtl,;
                        Alltrim(WRKXFN->LOGPTAL),;
                        cStPsw,;
                        Alltrim(WRKXFN->CARGO),;
                        WRKXFN->RD0RCN,;
                        WRKXFN->SRARCN })
        WRKXFN->(dbSkip())
    EndDo
    WRKXFN->(dbCloseArea())

Else

    Alert("Informe pelo menos 3 caracteres para pesquisar os funcionários")

EndIf

If Len(aALbx) == 0
    aALbx := {{"","","","","","","","","",0}}
EndIf

oALbx:nAt := 1
oALbx:aArray := aClone(aALbx)
oALbx:Refresh()

Return(Nil)



//*******************************************************************************************
// Funcao:     ALTLGIN
// Finalidade: Tela de alteracao de login
// Autor:      Ronald Piscioneri
// Data:       09-Maio-2022
// Uso:        Especifico Taiff
//*******************************************************************************************
Static Function AltLgin(aUsr,aALbx,oALbx,cGtPsq,oGtPsq,oDlg)
Local oBNo, oBOk, oGtLogin, oDgA, oSay1, oSay2, oSay3 := Nil
Local cGtLogin := Space(11)
Local lGOk := .F.

If aALbx[oALbx:nAt,6] $ "|Portal Ok|Nao Config.|"

    //Sugere CPF como login, caso ja' nao esteja em uso
    If Len(aUsr[3]) == 11
        If !HasLgin(aUsr[3],aUsr[10])
            cGtLogin := aUsr[3]
        EndIf
    EndIf

    DEFINE MSDIALOG oDgA TITLE "Atualizar Login / Reiniciar Senha do Portal" FROM 000, 000  TO 100, 460 COLORS 0, 16777215 PIXEL

        @ 002, 002 SAY oSay1 PROMPT "Informe o novo login para: " SIZE 148, 007 OF oDgA COLORS 0, 16777215 PIXEL
        @ 012, 002 SAY oSay2 PROMPT Alltrim(aUsr[2])+" ("+Alltrim(aUsr[9])+")" SIZE 224, 007 OF oDgA COLORS 0, 16777215 PIXEL
        @ 022, 002 MSGET oGtLogin VAR cGtLogin Picture "@!" SIZE 161, 012 OF oDgA COLORS 0, 16777215 PIXEL
        @ 038, 002 SAY oSay3 PROMPT 'OBS.: a senha do portal será reiniciada para o padrão do sistema ao clicar em "Confirma"' SIZE 223, 009 OF oDgA COLORS 0, 16777215 PIXEL
        @ 022, 166 BUTTON oBOk PROMPT "Confirma" Action(lGOk:=GPsw(cGtLogin,aUsr),Iif(lGOk,oDgA:End(),Nil)) SIZE 030, 012 OF oDgA PIXEL
        @ 022, 199 BUTTON oBNo PROMPT "Cancela" Action(oDgA:End()) SIZE 027, 012 OF oDgA PIXEL

    ACTIVATE MSDIALOG oDgA CENTERED

    If lGOk

        PsqFunc( cGtPsq, aALbx, oALbx )
        oALbx:nAt := 1
        oALbx:aArray := aClone(aALbx)
        oALbx:Refresh()
        oGtPsq:Refresh()
        oDlg:Refresh()

    EndIf

Else
    Alert("ATENÇÃO: o status deste funcionário não permite atualização (" +Lower(aALbx[oALbx:nAt,6])+ ")")
EndIf


Return(Nil)



//*******************************************************************************************
// Funcao:     GPSW
// Finalidade: Gera senha inicial e a grava, juntamente com o login, nas tabelas proprias
// Autor:      Ronald Piscioneri
// Data:       09-Maio-2022
// Uso:        Especifico Taiff
//*******************************************************************************************
Static Function GPsw(cGtLogin,aUsr)
Local lRet := .F.
Local cSenha := ""
Local cSenhaC := ""
Local nPolSeg := 0
Local lSHA512 := .F.
Local cCmd := ""
Local cMsg := ""

If !HasLgin(cGtLogin,aUsr[10])

    If MsgYesNo("Confirma o novo login e reset da senha?")
    
        cSenha	:= SubStr(DtoS(CtoD(aUsr[5])),3,2) + SubStr(DtoS(CtoD(aUsr[4])),-2) + SubStr(aUsr[3],-2)
        cSenhaC := cSenha
        cSenha	:= Embaralha(cSenha, 0) 
        nPolSeg := SuperGetMv("MV_POLSEG", .F. , 0)
        lSHA512 := IIf(TamSX3("RD0_SENHAC")[1]==128, .T. , .F.)

        If nPolSeg > 0 //Inicializa senha criptografada
            If lSHA512  //Tamanho do campo RD0_SENHAC atualizado no dicionario
                cSenhaC := SHA512(AllTrim(cSenhaC))
            Else //Tamanho padrão(40) do campo RD0_SENHAC no dicionario
                cSenhaC := SHA1(AllTrim(cSenhaC))
            EndIf
        EndIf

        cCmd := "UPDATE " +RetSqlName("RD0")+ " "
        cCmd += "SET "
        cCmd += "RD0_PORTAL = '000003', "
        cCmd += "RD0_MSBLQL = '2', "
        cCmd += "RD0_LOGIN = '"+cGtLogin+"', "
        cCmd += "RD0_SENHA = '"+cSenha+"', "
        cCmd += "RD0_SENHAC = '"+cSenhaC+"' "
        cCmd += "WHERE R_E_C_N_O_ = " +Alltrim(Str(aUsr[10]))

        BeginTran()

        lRet := ( TcSqlExec( cCmd ) == 0 )

        If lRet

            cCmd := "UPDATE " +RetSqlName("SRA")+ " "
            cCmd += "SET "
            cCmd += "RA_SENHA = '" +cSenha+ "' "
            cCmd += "WHERE R_E_C_N_O_ = " +Alltrim(Str(aUsr[11]))

            lRet := ( TcSqlExec( cCmd ) == 0 )

        EndIf

        If !lRet
            DisarmTransaction()
            cMsg := "Erro ao gravar novo login e reset da senha. Tente novamente. Se o problema persistir, contacte o administrador do sistema"
        EndIf

        EndTran()

    EndIf

Else

    cMsg := "Já existe cadastro com o login informado. Escolha outro login."

EndIf

If lRet
    MsgRun("Funcionário atualizado com sucesso","",{||Sleep(3000)})
Else
    If !Empty(cMsg)
        Alert(cMsg)
    EndIf
EndIf

Return(lRet)



//*******************************************************************************************
// Funcao:     HASLGIN
// Finalidade: Verifica se o login informado ja' existe no banco de dados
// Autor:      Ronald Piscioneri
// Data:       09-Maio-2022
// Uso:        Especifico Taiff
//*******************************************************************************************
Static Function HasLgin( cLgin, nRcn )
Local cQry := ""
Local lRet := .F.

cQry := "SELECT TOP 1 RD0_CODIGO AS CODUSR "
cQry += "FROM " +RetSqlName("RD0")+ " WHERE D_E_L_E_T_ = ' '
cQry += "AND RD0_FILIAL = '" +xFilial("RD0")+ "' "
cQry += "AND RD0_LOGIN = '" +cLgin+ "' "
cQry += "AND R_E_C_N_O_ <> " +Alltrim(Str(nRcn))

Iif(Select("WRKXFN")>0,WRKXLG->(dbCloseArea()),Nil)
dbUseArea(.T.,"TOPCONN",TCGenQry(,,cQry),"WRKXLG",.T.,.T.)
WRKXLG->(dbGoTop())

If WRKXLG->(!EoF())
    If !Empty(Alltrim(WRKXLG->CODUSR))
        lRet := .T.
    EndIf
EndIf
WRKXLG->(dbCloseArea())

Return(lRet)
