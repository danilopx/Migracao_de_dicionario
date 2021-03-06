#include 'protheus.ch'
#include 'TOPCONN.CH'

/*
|-----------------------------------------------------------------------------------------------------
|	Rotina para cria��o da tabela no banco de dados
|	Data: 17/05/2020 
|	Analista: Gilberto Ribeiro Junior
|-----------------------------------------------------------------------------------------------------
*/
User Function CriaZAS()
    AxCadastro("ZAS")
    Msgalert("Tabela criada com sucesso!")
Return

/*
|-----------------------------------------------------------------------------------------------------
|	Rotina para Opera��es na tabela ZAS (Pedidos Liberados para Faturamento fora do per�odo permitido)
|	Data: 15/05/2020 
|	Analista: Gilberto Ribeiro Junior
|-----------------------------------------------------------------------------------------------------
*/
User Function FATMI014()

    Local aCores := {}
    Local ODLG
    Local OSAY01
    Local OSAY02
    Local CSAY01 := "Registro de Pedidos Liberados para Faturamento fora do per�odo permitido."
    Local CSAY02 := "N�o dispon�vel nesta empresa/filial."
    Local OBTN
    Local LOK := .F.
    Local _cFuncao := "FATMI014"

    Public _cAlias := "ZAS"
    Public _cCodUser := RetCodUsr()

    Private cTitulo := "Registro de Pedidos que poder�o ser Liberados fora do per�odo permitido para Faturamento"
    Private cCadastro := OEMTOANSI (cTitulo)
    Private aRotina := {}

    // Somente Empresa 03, Filial 02
    If cEmpAnt == "03" .and. cFilAnt $ "02"

        /*-----------------------------------------------------------------------------------------------------
        |	Valida se o usu�rio tem permiss�o para acessar a rotina
        |-----------------------------------------------------------------------------------------------------*/
        dbSelectArea("SZV")
        dbSetOrder(1)
        If !dbSeek(xFilial() + _cCodUser + _cFuncao)
            MsgAlert("Acesso n�o permitido! Solicite ao time de sistemas o cadastro de acessos atrav�s de formul�rio com autoriza��o.")
            Return .F.
        EndIf
        /*----------------------------------------------------------------------------------------------------*/
  
        aCores := { {'ZAS->ZAS_TIPLIBE == "1"'  ,'BR_VERDE'    },;
            {'ZAS->ZAS_TIPLIBE == "2"'  ,'BR_AMARELO'  },;
            {'ZAS->ZAS_TIPLIBE == "3"'  ,'BR_VERMELHO' }}

        AADD(aRotina, { "Pesquisar"  , "AxPesqui", 0, 1 })
        AADD(aRotina, { "Visualizar" , "U_OPERACAO(2)", 0, 2 })
        AADD(aRotina, { "Incluir"    , "U_OPERACAO(3)", 0, 3 })
        //AADD(aRotina, { "Alterar"    , "U_OPERACAO(4)" , 0, 4 })
        AADD(aRotina, { "Excluir"    , "U_FAT014DEL", 0, 5 })
        AADD(aRotina, { "Legenda"    , "U_FAT014LEG", 0, 6 })
 
        dbselectarea(_cAlias)
        dbsetorder(1)
        dbGoTop()

        MBrowse(6 , 1 , 22, 75,"ZAS",,,,,,aCores)
    Else
        ODLG   := MSDIALOG():NEW(001, 001, 400, 400, "Registro de Pedidos para Libera��o",,,,,CLR_BLACK,CLR_WHITE,,,.T.)
        OSAY01 := TSAY():NEW(010,010, {|| CSAY01},ODLG,,,,,, .T., CLR_BLUE,CLR_WHITE )
        OSAY02 := TSAY():NEW(030,010, {|| CSAY02},ODLG,,,,,, .T., CLR_BLUE,CLR_WHITE )
        OBTN   := TBUTTON():NEW(090,050,'OK', ODLG,{|| LOK 		:= .T.,ODLG:END()},40,10,,,,.T.)

        ODLG:ACTIVATE(,,,.T.)

        WHILE !LOK

        ENDDO

    EndIf

Return()

User Function OPERACAO(nOpcx)

    // Diferente de Inclus�o
    If nOpcx <> 3

        If nOpcx == 2
            cTitM2 := "Vizualiza��o - " + cTitulo
            AxVisual("ZAS", Recno(), nOpcx, ,) // Abre a tela de Visualiza��o
        ElseIf nOpcx == 4
            cTitM2 := "Altera��o - " + cTitulo
        Else
            cTitM2 := "Exclus�o - " + cTitulo
            //cTudoOk := "U_FAT014DEL()"
        EndIf

    Else // Inclus�o
        cTitM2 := "Inclusao - " + cTitulo
        cTudoOk  := "U_FATTOK014()"
        AxInclui(_cAlias, Recno(), nOpcx, /*aAcho*/,, /*aCpos*/, cTudoOk, /*lF3*/, /*cTransact*/, /*aButtons*/, /*aParam*/, Nil, .T.)
    EndIf

Return()
/************************************************************/

/*------------------------------------------------------------------------------------------------------------
Fun��o: Legenda
--------------------------------------------------------------------------------------------------------------*/
User Function FAT014LEG()

    Local aLegenda := {}

    Aadd(aLegenda,{"BR_VERDE"	, "Pedido Separ�vel" })
    Aadd(aLegenda,{"BR_AMARELO" , "Pedido Fatur�vel" })
    Aadd(aLegenda,{"BR_VERMELHO", "Desbloqueio de Cr�dito em Per�odo Restritivo" })

    BrwLegenda(cCadastro, "Legenda", aLegenda)

Return Nil

/*
|-----------------------------------------------------------------------------------------------------
|	Rotina que valida a Inclus�o na tabela ZAS (Pedidos Liberados para Fat. fora do per�odo permitido)
|	Data: 15/05/2020 
|	Analista: Gilberto Ribeiro Junior
|-----------------------------------------------------------------------------------------------------
*/
User Function FATTOK014()

    Local lRet     := .T.
    Local _cFilial := "02" // Sempre filial 02 por causa do CrossDocking
    Local _cNumPed := M->ZAS_NUMPED
    Local _cTipLib := M->ZAS_TIPLIB
    Local _cLocal  := ""


    /*-----------------------------------------------------------------------------------------------------
    |	Por conta da tela que abre para selecionar a filial, foi necess�rio colocar esta tratativa 
    |   para somente permitir inclus�o de pedidos somente da filial 02 - Extrema (CrossDocking)
    |-----------------------------------------------------------------------------------------------------*/
    If cFilAnt != "02"
        msgAlert("Somente � permitido pedidos da filial 02 - Extrema")
        Return .F.
    EndIf

    /*-----------------------------------------------------------------------------------------------------
    |	Valida se o pedido existe na tabela SC5 e se � um pedido em aberto
    |-----------------------------------------------------------------------------------------------------*/
    dbSelectArea("SC5")
    dbSetOrder(1)

    If dbSeek(_cFilial + _cNumPed)

        dbSelectArea("SC6")
        dbSetOrder(1)
        If dbSeek(_cFilial + _cNumPed)
            _cLocal := SC6->C6_LOCAL
        EndIf
        SC6->(dbCloseArea())
        
        // Verifica se � realmente um pedido apto a ser cadastrado para Liberar o Fat. fora do per�odo permitido
        If SC5->C5_CLASPED $ ("V|X") .and. SC5->C5_TIPO == "N" .and. SC5->C5_XITEMC != "CORP" .and. _cLocal == "21"
            If AllTrim(SC5->C5_NOTA) == "XXXXXXXXX" .Or. AllTrim(SC5->C5_NOTA) != ""
                SC5->(dbCloseArea())
                MsgAlert("Esse pedido n�o est� mais em aberto, n�o ser� poss�vel grav�-lo.")
                lRet := .F.
                Return lRet
            EndIf
        Else
            SC5->(dbCloseArea())
            MsgAlert("Esse pedido n�o necessita de cadastro para ser faturado fora do per�odo permitido.")
            lRet := .F.
            Return lRet
        EndIf
    Else
        SC5->(dbCloseArea())
        MsgAlert("Pedido n�o encontrado. Lembre-se, o pedido a ser cadastrado, necessita ser da Filial 02 - Extrema.")
        lRet := .F.
        Return lRet
    EndIf

    M->ZAS_NUMOLD := SC5->C5_NUMOLD
    M->ZAS_OPERAD := _cCodUser // AllTrim(UsrFullName(RetCodUsr()))
    M->ZAS_DTLIBE := Date()
    M->ZAS_HRLIBE := Substr(Time(), 1, 5)

    SC5->(dbCloseArea())
    /*-----------------------------------------------------------------------------------------------------*/

    /*-----------------------------------------------------------------------------------------------------
    |	Valida se o pedido j� existe na tabela ZAS, se existir, n�o permite a inclus�o
    |-----------------------------------------------------------------------------------------------------*/
    dbSelectArea(_cAlias)
    dbSetOrder(1)

    If dbSeek(_cFilial + _cNumPed + _cTipLib)
        ZAS->(dbCloseArea())
        MsgAlert("Este pedido j� foi inclu�do nesta filial e com o mesmo Tipo de Desbloqueio.")
        lRet := .F.
        Return lRet
    EndIf
    ZAS->(dbCloseArea())
    /*-----------------------------------------------------------------------------------------------------*/

Return lRet

/*
|-----------------------------------------------------------------------------------------------------
|	Rotina para Exclus�o na tabela ZAS (Pedidos Liberados para Faturamento fora do per�odo permitido)
|	Data: 18/05/2020 
|	Analista: Gilberto Ribeiro Junior
|-----------------------------------------------------------------------------------------------------
*/
User Function FAT014DEL(cAlias, nReg, nOpc)

    Local nOpcao := 0 // 1 = Cancelado | 2 = Confirmado
    Local _cFilial := ZAS->ZAS_FILIAL
    Local _cNumPed := ZAS->ZAS_NUMPED

    /*-----------------------------------------------------------------------------------------------------
    |	Valida se ja existe Libera��o ou Separa��o em andamento antes de permitir a exclus�o
    |-----------------------------------------------------------------------------------------------------*/
    // Libera��o
    DbSelectArea("SC9")
    DbSetOrder(1)
    If DbSeek(_cFilial + _cNumPed)
        If AllTrim(SC9->C9_NFISCAL) == ""
            MsgAlert("O registro n�o pode ser exclu�do, pois ja existe Libera��o para este pedido.")
            Return .F.
        EndIf
    EndIf
    SC5->(dbCloseArea())
   /*-----------------------------------------------------------------------------------------------------*/
    
    nOpcao := AxDeleta(cAlias,nReg,nOpc)

    // 1 = Cancelado | 2 = Confirmado
    If nOpcao == 2
        MsgInfo("Exclus�o efetuada com sucesso!")
    Else
        MsgInfo("Exclus�o cancelada!")
    EndIf
  
Return


/*
|-----------------------------------------------------------------------------------------------------
|	Rotina para inclus�o na tabela ZAS (Pedidos Liberados para Faturamento fora do per�odo permitido)
|	Data: 14/05/2020 
|	Analista: Gilberto Ribeiro Junior
|-----------------------------------------------------------------------------------------------------
*/
User Function FATLOK10()

    Local lRet := .F.

    alert("Fun��o FATLOK10")
    alert(ZAS->ZAS_NUMPED)
    alert(_cTipLib)

    //Verifica se j� existe o registro na tabela ZAS
    //MsgAlert("Exclus�o de linhas n�o permitido")

    //     dbSelectArea("ZAR")
    //     dbSetOrder(1)
    //     If nI > len(_aAnt)
    //         _uChave := xFilial("ZAR") + _cOrdAnt + aCols[nI,_nPosCod]
    //     Else
    //         _uChave := xFilial("ZAR") + _cOrdAnt + _aAnt[nI,_nPosCod]
    //     endif
    //     If ! aCols[nI,_nPosDel] // Trata somente itens nao deletados. . .
    //         If  !dbSeek(_uChave)
    //             MsgAlert("Inclus�o de novos itens n�o permitido")
    //             lRet := .F.
    //         Endif
    //     Else
    //         MsgAlert("Exclus�o de linhas n�o permitido")
    //         lRet := .F.
    //     Endif
    // Next nI

Return(lRet)
/****************************************************************************************************/