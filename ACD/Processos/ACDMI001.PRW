#Include "Protheus.ch"

#DEFINE ENTER Chr(13)+Chr(10)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณFun…o    ณ ACDA030  ณ Autor ณ Ricardo               ณ Data ณ 23/03/01 ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescri…o ณ Programa de manutencao no arquivo mestre de inventario     ณฑฑ
ฑฑณ          ณ                                                            ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณ Uso      ณ SIGAACD                                                    ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤมฤฤฤยฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณ PROGRAMADOR  ณ DATA   ณ BOPS ณ  MOTIVO DA ALTERACAO                   ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤลฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณ              ณ        ณ      ณ                                        ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
User Function ACDMI001()

Local aCores := {}
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Define Array contendo as Rotinas a executar do programa      ณ
//ณ ----------- Elementos contidos por dimensao ------------     ณ
//ณ 1. Nome a aparecer no cabecalho                              ณ
//ณ 2. Nome da Rotina associada                                  ณ
//ณ 3. Usado pela rotina                                         ณ
//ณ 4. Tipo de Transao a ser efetuada                          ณ
//ณ    1 - Pesquisa e Posiciona em um Banco de Dados             ณ
//ณ    2 - Simplesmente Mostra os Campos                         ณ
//ณ    3 - Inclui registros no Bancos de Dados                   ณ
//ณ    4 - Altera o registro corrente                            ณ
//ณ    5 - Remove o registro corrente do Banco de Dados          ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
PRIVATE aRotina := {	{ "Pesquisar", "AxPesqui",		0, 1}     ,;
{ "Visualizar", "AxVisual",		0, 2}     ,;
{ "Incluir", "U_ACDA30Inc",	0, 3}     ,;
{ "Alterar", "U_ACDA30Alt",	0, 4, 17} ,;
{ "Excluir", "U_ACDA30Del",	0, 5, 17} ,;
{ "Automatico", "U_AIVA30Aut",	0, 3, 17} ,;
{ "Monitor", "ACDA032",		0, 4, 17} ,;
{ "Rel. Mestre Prod.", "U_ImprimeInv(1,'P')",		0, 1}     ,;
{ "Rel. Mestre Ender.", "U_ImprimeInv(1,'E')",		0, 1}     ,;
{ "Rel.Padrao", "ACDR030",		0, 1}     ,;
{ "Acompanhamento", "U_ACD009",		0, 1}     ,;
{ "Legenda", "U_AIVA30Lg",	0, 3} }

PRIVATE cDelFunc := "ACDA30Exc()"
PRIVATE lLocaliz := GetMv('MV_LOCALIZ')=='S'

//CBChkTemplate()
If ! IntAcd(.t.)
	Return .f.
EndIf


If ! SuperGetMV("MV_CBPE012",.F.,.F.)
	CBAlert("Necessario ativar o parametro MV_CBPE012") //
	Return .F.
EndIf


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Define o cabecalho da tela de atualizacoes                   ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
PRIVATE cCadastro := "Mestre de inventario" // //

aCores := {	{ "CBA->CBA_STATUS == '0'", "BR_VERDE"},;
{ "CBA->CBA_STATUS == '1'", "BR_AMARELO"},;
{ "CBA->CBA_STATUS == '2'", "BR_CINZA"},;
{ "CBA->CBA_STATUS == '3'", "BR_LARANJA"},;
{ "CBA->CBA_STATUS == '4'", "BR_AZUL"},;
{ "CBA->CBA_STATUS == '5'", "BR_VERMELHO"}}
mBrowse( 6, 1, 22, 75, "CBA", , , , , , aCores, , , ,{|x|TimerBrw(x)})
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAcda30Inc บAutor  ณEduardo Motta       บ Data ณ  08/03/02   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Inclusao do mestre de inventario                           บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ SIGAACD                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function ACDA30Inc(cAlias,nReg,nOPc)
Private lInclui := .t.
Return AxInclui(cAlias,nReg,nOPc,nil,nil,nil,"ACDA30Chk()")

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAcda30Alt บAutor  ณEduardo Motta       บ Data ณ  08/03/02   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Alteracao do mestre de inventario                          บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ SIGAACD                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function ACDA30Alt(cAlias,nReg,nOPc)
Private lInclui := .f.
If CBA->CBA_STATUS=="1"
	Alert("Inventario em andamento, nao sera possivel alterar!!!") //
	Return
EndIf

If CBA->CBA_STATUS=="2"
	Alert("Inventario em pausa, nao sera possivel alterar!!!") //
	Return
EndIf

If CBA->CBA_STATUS$"543"
	Alert("Inventario concluido, nao sera possivel alterar!!!") //
	Return
EndIf
Return AxAltera(cAlias,nReg,nOPc,nil,nil,nil,"ACDA30Chk()")

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAcda30Del บAutor  ณAnderson Rodrigues  บ Data ณ  18/02/03   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณExclusao do Mestre de inventario                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ SIGAACD                                                    บฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤมฤฤฤยฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณ PROGRAMADOR  ณ DATA   ณ BOPS ณ  MOTIVO DA ALTERACAO                   ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤลฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณErike Yuri    ณ13/07/04ณ      ณAlteracao que permite excluir SB7 quandoณฑฑ
ฑฑณ              ณ        ณ      ณo Status estiver finalizado,CBA_STATUS=4ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function Acda30Del(cAlias,nReg,nOPc)
Local nI      := 0
Local aSB7    := GetArea('SB7')
Local cCodInv := CBA->CBA_CODINV
Local aProdDel:= {}
Private lInclui := .f.
If CBA->CBA_STATUS == "5" // processadoo
	MsgAlert("Nao e permitida a exclusao de Mestres de Inventario ja processado !!!") //
	Return .f.
ElseIf CBA->CBA_STATUS == "4" // finalizado
	MsgAlert('Este Mestre de Inventario esta finalizado, se o mesmo for excluido, sera efetuada a exclusao de '+; //'Este Mestre de Inventario esta finalizado, se o mesmo for excluido, sera efetuada a exclusao de '
	'todos "Lancamentos Inventariados" (SB7) deste Mestre, e este Mestre de Inventario ficara com '+; //'todos "Lancamentos Inventariados" (SB7) deste Mestre, e este Mestre de Inventario ficara com '
	'Status de "Em Andamento".'+chr(13)+chr(10)+chr(13)+chr(10)+'Para excluir definitivamente este '+; //'Status de "Em Andamento".'###'Para excluir definitivamente este '
	'Mestre de Inventario, esta rotina devera ser executada ate que o Mestre de inventario esteja com '+; //'Mestre de Inventario, esta rotina devera ser executada ate que o Mestre de inventario esteja com '
	'Status de "Nao Iniciado" ou "Em Andamento".') //'Status de "Nao Iniciado" ou "Em Andamento".'
	
	If !IW_MSGBOX("Deseja prosseguir com a exclusao?","Atencao","YESNO") //###
		Return .f.
	Endif
	
	//Carrega array com produtos do inventario para desbloqueio
	CBLoadEst(aProdDel,.f.)
	For nI:=1 To Len(aProdDel)
		CBUnBlqInv(cCodInv,aProdDel[nI,1])
	Next
	
	//Como nao existe rotina automatica para a exclusao do SB7(Mata270), a exclusao sera feita diretamente
	Begin Transaction
	DbSelectArea("SB7")
	SB7->(DbOrderNickName("ACDSB701"))
	SB7->(DbSeek(xFilial("SB7")+CBA->CBA_CODINV))
	While SB7->(!Eof() .AND. B7_FILIAL+B7_DOC==xFilial("SB7")+CBA->CBA_CODINV)
		RecLock("SB7",.F.)
		SB7->(DbDelete())
		SB7->(MsUnLock())
		SB7->(DbSkip())
	EndDo
	
	RecLock("CBA",.F.)
	CBA->CBA_STATUS := "3" // contado
	CBA->(MsUnLock())
	End Transaction
	RestArea(aSB7)
ElseIf CBA->CBA_STATUS$"3|2|1" // contado/em pausa/em andamento
	CBB->(DbSetOrder(1))
	CBB->(DbSeek(xFilial("CBB")+CBA->CBA_CODINV))
	While ! CBB->(EOF()) .and. CBB->(CBB_FILIAL+CBB_CODINV) == xFilial("CBB")+CBA->CBA_CODINV
		If CBB->CBB_STATUS == "1"
			MsgAlert("Nao e permitida a exclusao de Mestres de Inventario com contagens em andamento!!!"+chr(13)+CHR(10)+; //
			"Necessario excluir ou finalizar a contagem em andamento." ) //
			Return .f.
		Endif
		CBB->(DbSkip())
	Enddo
	
	MsgAlert("Ja foram realizadas contagens para este Mestre de Inventario, "+; //
	"se o mesmo for excluido todas as contagens realizadas tambem serao excluidas !!!")           //
	If !IW_MSGBOX("Deseja prosseguir com a exclusao?","Atencao","YESNO") //###
		Return .f.
	Endif
	If AxDeleta(cAlias,nReg,nOPc,nil,nil,nil) == 2
		CBB->(DbSetOrder(1))
		CBB->(DbSeek(xFilial("CBB")+cCodInv))
		While ! CBB->(EOF()) .and. CBB->(CBB_FILIAL+CBB_CODINV) == xFilial("CBB")+cCodInv
			While CBC->(DbSeek(xFilial("CBC")+CBB->CBB_NUM))
				ACD35CBM(5,CBA->CBA_CODINV,CBC->CBC_COD,CBC->CBC_LOCAL,CBC->CBC_LOCALI,CBC->CBC_LOTECT,CBC->CBC_NUMLOT,CBC->CBC_NUMSER)
				RecLock("CBC",.f.)
				CBC->(DbDelete())
				CBC->(MsUnlock())
			Enddo
			RecLock("CBB",.f.)
			CBB->(DbDelete())
			CBB->(MsUnlock())
			CBB->(DbSkip())
		Enddo
		If CBA->CBA_STATUS == '0'
			ACDA30Exc()
		EndIf
	EndIf
Else
	AxDeleta(cAlias,nReg,nOPc,nil,nil,nil)
	If CBA->CBA_STATUS == '0'
		ACDA30Exc()
	EndIf
Endif
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณACDA30Chk บAutor  ณEduardo Motta       บ Data ณ  08/03/02   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณExecuta as validacoes padroes                               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ SIGAACD                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function ACDA30Chk()
If	M->CBA_TIPINV == "2" // Por endereco
	If Empty(M->CBA_LOCALI)
		Alert("O campo endereco nao pode ficar em branco.") //
		Return .F.
	EndIf
EndIf

If ! lInclui
	Return .t.
EndIf
If M->CBA_DATA < dDataBase
	Alert("Data do Inventario menor que a database")  //
	Return .f.
EndIf
If M->CBA_TIPINV=="1" // por produto
	CBA->(DbSetOrder(3)) //CBA_FILIAL+CBA_TIPINV+CBA_STATUS+CBA_LOCAL+CBA_PROD+CBA_DATA
	If	CBA->(DbSeek(xFilial("CBA")+"1"+"0"+M->CBA_LOCAL+Padr(M->CBA_PROD,Tamsx3("B1_COD")[1])+DTOS(M->CBA_DATA))) .or. ;
		CBA->(DbSeek(xFilial("CBA")+"1"+"1"+M->CBA_LOCAL+Padr(M->CBA_PROD,Tamsx3("B1_COD")[1])+DTOS(M->CBA_DATA)))
		Alert("Inventario ja cadastrado ") //
		Return .f.
	EndIf
Else  // por endereco
	CBA->(DbSetOrder(2)) //CBA_FILIAL+CBA_TIPINV+CBA_STATUS+CBA_LOCAL+CBA_LOCALI+CBA_DATA
	If	CBA->(DbSeek(xFilial("CBA")+"2"+"0"+M->CBA_LOCAL+Padr(M->CBA_LOCALI,15)+DTOS(M->CBA_DATA))) .or. ;
		CBA->(DbSeek(xFilial("CBA")+"2"+"1"+M->CBA_LOCAL+Padr(M->CBA_LOCALI,15)+DTOS(M->CBA_DATA)))
		Alert("Inventario ja cadastrado ") //
		Return .f.
	EndIf
EndIf
If ExistBlock('ACDA30OK')
	If ! Execblock('ACDA30OK',.F.,.F.)
		Return .f.
	Endif
Endif
Return .T.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAcda30Exc บAutor  ณEduardo Motta       บ Data ณ  04/02/02   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Exclusao do mestre de inventario, libera o endereco        บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ SIGAACD                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function ACDA30Exc()
If	CBA->CBA_STATUS$"54" //If CBA->CBA_STATUS #"1"
	Return .t.
EndIf
If	CBA->CBA_TIPINV== "1"
	SB2->(DbSetorder(1))
	If	SB2->(DbSeek(xFilial("SB2")+CBA->(CBA_PROD+CBA_LOCAL)))
		RecLock("SB2")
		SB2->B2_DTINV := CTOD("")
		SB2->(MsUnlock())
	EndIf
Else
	SBE->(DbSetOrder(1))
	If	SBE->(DbSeek(xFilial("SBE")+CBA->CBA_LOCAL+CBA->CBA_LOCALI))
		RecLock("SBE")
		SBE->BE_STATUS := " "
		SBE->BE_DTINV  := CTOD('')
		SBE->(MsUnlock())
	EndIf
EndIf
Return .T.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAIVA30Aut บAutor  ณRicardo             บ Data ณ  20/04/01   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Gera mestre inventario automaticamente conf. parametros    บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ SIGAACD                                                    บฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤมฤฤฤยฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณ PROGRAMADOR  ณ DATA   ณ BOPS ณ  MOTIVO DA ALTERACAO                   ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤลฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณ Erike Yuri   ณ08/10/04ณ      ณ Inclusao de opcoes automaticas incluin-ณฑฑ
ฑฑณ              ณ        ณ      ณ do Geracao automatica de Mestre de in- ณฑฑ
ฑฑณ              ณ        ณ      ณ ventario,Lancamento SB7,Acerto e Exclu-ณฑฑ
ฑฑณ              ณ        ณ      ณ sao automatica de lancamento SB7.      ณฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function AIVA30Aut()
Local nAcao    := 0
Local nOpca    := 0
Local aSays    := {}
Local aButtons := {}
Private cCadastro := OemToAnsi("Geracao automatica") //


AADD(aButtons, { 1,.T.,{|o| nOpca:= 1, o:oWnd:End()}})
AADD(aButtons, { 2,.T.,{|o| o:oWnd:End()}})

If ! Pergunte("AIA033",.T.)
	Return
EndIf

nAcao := MV_PAR01

If	nAcao==1 //Geracao automatica de mestre de inventario
	AADD(aSays,OemToAnsi("Esta rotina tem o objetivo de efetuar a geracao")) //
	AADD(aSays,OemToAnsi("automatica de mestres de inventario, a partir do")) //
	AADD(aSays,OemToAnsi("range informado pelo operador nos parametros.")) //
	FormBatch(cCadastro, aSays, aButtons,,200,450 ) // Monta Caixa de dialogo
	If	nOpca <> 1
		Return
	EndIf
	If	lLocaliz //Utiliza Controle de Localizacao == Gera por Produto ou Endereco
		If ! Pergunte("AIA031",.T.)  //Seleciona Produto ou Endereco
			Return
		EndIf
		If mv_par01 == 01 //Produto
			If ! Pergunte("AIA032",.T.)
				Return
			EndIf
			Processa({|| AI031( )})
		Else //Endereco
			If ! Pergunte("AIA030",.T.)
				Return
			EndIf
			Processa({|| AI030( )})
		EndIf
	Else //Nao utiliza Controle de Localizacao == Gera por Produto
		If ! Pergunte("AIA032",.T.)
			Return
		EndIf
		Processa({|| AI031( )})
	EndIf
ElseIf nAcao==2 //Exclusao automatica de mestre de inventario
	AADD(aSays,OemToAnsi("A T E N C A O:")) //
	AADD(aSays,OemToAnsi("Esta rotina tem o objetivo de efetuar a exclusao")) //
	AADD(aSays,OemToAnsi("automatica de mestres de inventarios informados ")) //
	AADD(aSays,OemToAnsi("nos parametros solicitados.")) //
	FormBatch(cCadastro, aSays, aButtons,,200,450 ) // Monta Caixa de dialogo
	If nOpca == 1
		If	!Pergunte("AIA034",.T.)  //Seleciona o Mestre de Inventario de Ate
			Return
		EndIf
		Processa({||ExcluiCBA()})
	EndIf
ElseIf nAcao==3 //Geracao automatica do lancamento de inventario
	AADD(aSays,OemToAnsi('Esta rotina tem o objetivo de efetuar a geracao automatica')) //
	AADD(aSays,OemToAnsi('do lancamento de inventario (tabela SB7), atraves da tabela')) //
	AADD(aSays,OemToAnsi('de mestre de inventario (CBA), que ja foi finalizada. Caso')) //
	AADD(aSays,OemToAnsi('o modelo do inventario seja o "2", so sera gerado lancamento')) //
	AADD(aSays,OemToAnsi('para os totais inventariados diferentes do saldo em estoque.')) //
	FormBatch(cCadastro, aSays, aButtons,,200,450 ) // Monta Caixa de dialogo
	If	nOpca == 1
		If	!Pergunte("AIA034",.T.) //Seleciona o Mestre de Inventario de Ate
			Return
		EndIf
		Processa({||GeraSB7Auto()})
	EndIf
ElseIf nAcao==4 //Exclusao automatica do lancamento de inventario
	AADD(aSays,OemToAnsi("A T E N C A O:")) //
	AADD(aSays,OemToAnsi("Esta rotina tem o objetivo de efetuar a exclusao")) //
	AADD(aSays,OemToAnsi("automatica dos lancamentos de inventarios infor-")) //
	AADD(aSays,OemToAnsi("mados nos parametros solicitados.")) //
	FormBatch(cCadastro, aSays, aButtons,,200,450 ) // Monta Caixa de dialogo
	If nOpca == 1
		If	!Pergunte("AIA034",.T.)  //Seleciona o Mestre de Inventario de Ate
			Return
		EndIf
		Processa({||ExcluiSB7()})
	EndIf
ElseIf nAcao==5 //Geracao de acerto automatico
	AADD(aSays,OemToAnsi('Esta rotina ira gerar movimentacoes de ajuste para corrigir o saldo do')) //
	AADD(aSays,OemToAnsi('estoque. Estas movimentacoes serao baseadas nas contagens realizadas e')) //
	AADD(aSays,OemToAnsi('cadastradas na rotina de inventario.')) //
	AADD(aSays,OemToAnsi('Esta rotina tambem ira efetuar o ajuste das etiquetas (CB0), caso o')) //
	AADD(aSays,OemToAnsi('cliente utilize codigo interno.')) //
	FormBatch(cCadastro, aSays, aButtons,,200,450 ) // Monta Caixa de dialogo
	If nOpca == 1
		If	!Pergunte("AIA036",.T.)  //Seleciona o Mestre de Inventario de Ate
			Return
		EndIf
		Processa({||GeraAcerto()})
	EndIf
EndIf
Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAI030     บAutor  ณMicrosiga           บ Data ณ  20/04/01   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Geracao do CBA                                             บฑฑ
ฑฑบ          ณ Por Endereco                                               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ SIGAACD                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function AI030()
Local cCodInv   := ""
Local lACDA30VE := ExistBlock("ACDA30VE") // Por Endereco
Local aArea     := GetArea()
Private aLog := {}

SGetArea(aArea,"CBA")

If MV_PAR05 < 1
	MsgAlert("O numero de contagens nao pode ser igual ou inferior a zero, favor verificar !!!") //
	Return
EndIf

//verifica se ficaram registros de outros inventarios em aberto, e aborta caso exista
cQuery := " SELECT * FROM "+RetSqlName("CBA")+" WHERE CBA_STATUS <> '5' AND D_E_L_E_T_ <> '*' AND CBA_DATA < '"+Dtos(MV_PAR06)+"' AND CBA_FILIAL = '"+xFilial("CBA")+"'"

MEMOWRITE("ACDMI001R.SQL",cQuery)
dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),"TRB", .F., .T.)

Count To nRec
If nRec > 0
	MsgStop("Existem registros pendentes de invetแrios anteriores, rotina cancelada!","ACDMI001")
	TRB->(dbCloseArea())
	Return
EndIf
TRB->(dbCloseArea())

cQuery := " SELECT * FROM "+RetSqlName("SBE")
cQuery += " WHERE BE_FILIAL = '"+xFilial("SBE")+"'"
cQuery += " AND BE_LOCAL BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"'"
cQuery += " AND BE_LOCALIZ BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"'"
cQuery += " AND D_E_L_E_T_ <> '*'"

MemoWrite("ACDMI001E.SQL",cQuery)
dbUseArea(.T.,"TOPCONN", TCGenQry(,,cQuery),"TRB", .F., .T.)

Count To nRec

ProcRegua(nRec)
dbSelectArea("TRB")
dbGoTop()


While !Eof()
	
	dbSelectArea("SBE")
	dbSetOrder(1)
	dbSeek(xFilial("SBE")+TRB->BE_LOCAL+TRB->BE_LOCALIZ,.T.)
	
	
	CBA->(dbSetOrder(2)) //CBA_FILIAL+CBA_TIPINV+CBA_STATUS+CBA_LOCAL+CBA_LOCALI+CBA_DATA
	If	CBA->(dbSeek(xFilial("CBA")+"2"+"0"+SBE->BE_LOCAL+SBE->BE_LOCALIZ+DTOS(MV_PAR06))) .OR.;
		CBA->(dbSeek(xFilial("CBA")+"2"+"1"+SBE->BE_LOCAL+SBE->BE_LOCALIZ+DTOS(MV_PAR06)))
		IncProc()
		dbSelectArea("TRB")
		DbSkip()
		Loop
	EndIf
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Ponto de Entrada para Validar o SBE                          ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If lACDA30VE
		lOK := ExecBlock("ACDA30VE",.F.,.F.) //Por Endereco
		If (ValType(lOk) == "L")
			If !lOK
				aadd(aLog,{"AI030","98",NIL,NIL,SBE->BE_LOCAL,SBE->BE_LOCALIZ})
				IncProc()
				dbSelectArea("TRB")
				dbSkip()
				Loop
			EndIf
		EndIf
	EndIf
	
	cCodInv := GetSXENum("CBA","CBA_CODINV")
	RecLock("CBA",.T.)
	CBA->CBA_Filial := xFilial("CBA")
	CBA->CBA_CODINV := cCodInv
	CBA->CBA_DATA   := MV_PAR06
	CBA->CBA_CONTS  := MV_PAR05
	CBA->CBA_STATUS := "0"
	CBA->CBA_TIPINV := "2"
	CBA->CBA_LOCAL  := SBE->BE_LOCAL
	CBA->CBA_LOCALI := SBE->BE_LOCALIZ
	CBA->CBA_CLASSA := Str(MV_PAR07,1)
	CBA->CBA_CLASSB := Str(MV_PAR08,1)
	CBA->CBA_CLASSC := Str(MV_PAR09,1)
	CBA->(MsUnlock())
	If __lSX8
		ConfirmSx8()
	EndIf
	//Mestres de Inventario gerados
	aadd(aLog,{"AI030","01",CBA_CODINV,NIL,CBA->CBA_LOCAL,CBA->CBA_LOCALI})
	
	IncProc()
	dbSelectArea("TRB")
	dbSkip()
End
TRB->(dbCloseArea())
U_ImprimeInv(2,"E")
RestArea(aArea)
MostraLog("AI030","AIA030",aLog)
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAI031     บAutor  ณMicrosiga           บ Data ณ  17/04/02   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Geracao do CBA                                             บฑฑ
ฑฑบ          ณ Por Prduto                                                 บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ SIGAACD                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function AI031()
Local cCodInv := ""
Local aArea:= GetArea()
Private aLog := {}

SGetArea(aArea,"CBA")
If	MV_PAR04 < 1
	MsgAlert("O numero de contagens nao pode ser igual ou inferior a zero, favor verificar !!!") //
	Return
EndIf

//If !xFilial("CBA") $ "01|02"
//	MsgStop("Esta rotina s๓ estแ liberada para a Filial de Sใo Paulo e Itu!","ACDMI001")
//	Return
//EndIf

//verifica se ficaram registros de outros inventarios em aberto, e aborta caso exista
cQuery := " SELECT * FROM "+RetSqlName("CBA")+" WHERE CBA_STATUS <> '5' AND D_E_L_E_T_ <> '*' AND CBA_DATA < '"+Dtos(MV_PAR05)+"' AND CBA_FILIAL = '"+xFilial("CBA")+"'"

MEMOWRITE("ACDMI001R.SQL",cQuery)
dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),"TRB", .F., .T.)

Count To nRec
If nRec > 0
	MsgStop("Existem registros pendentes de invetแrios anteriores, rotina cancelada!","ACDMI001")
	TRB->(dbCloseArea())
	Return
EndIf
TRB->(dbCloseArea())

//verifica se EXISTEM PRODUTO NO ALMOXARIFADO DE TRANSFERENCIA, LOCAL 02
If cFilAnt == "01"
	cQuery := " SELECT TOP 1 * FROM "+RetSqlName("SB2")+" WITH(NOLOCK) WHERE B2_QATU > 0 AND D_E_L_E_T_ <> '*'  AND B2_FILIAL = '"+cFilAnt+"' AND B2_LOCAL = '02'"
	
	MEMOWRITE("ACDMI001Q.SQL",cQuery)
	dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),"TRB", .F., .T.)
	
	Count To nRec
	If nRec > 0
		MsgStop("Existe(m) produto(s) com saldo no almoxarifado de transfer๊ncia, rotina cancelada!","ACDMI001")
		TRB->(dbCloseArea())
		Return
	EndIf
	TRB->(dbCloseArea())
EndIf

//seleciona itens para o invetแrio
cQuery := " SELECT TOP 10 B1_COD
cQuery += " FROM "+RetSqlName("SB1")+" B1
cQuery += " INNER JOIN "+RetSqlName("SB2")+" B2 ON B2_COD = B1_COD
cQuery += " WHERE B1_MSBLQL <> '1' AND B1.D_E_L_E_T_ <> '*'
cQuery += " AND B2_QATU > 0 AND B2_RESERVA = 0
cQuery += " AND B2_LOCAL = '"+mv_par01+"'
cQuery += " AND B2_FILIAL = '"+xFilial("SB2")+"'
cQuery += " AND B1_FILIAL = '"+xFilial("SB1")+"'
cQuery += " AND B1.D_E_L_E_T_ <> '*' AND B2.D_E_L_E_T_ <> '*'"

If MsgYesNo("Deseja fazer inventแrio rotativo?","ACDMI001")
	cQuery += " AND B2_COD NOT IN (SELECT CBA_PROD FROM "+RetSqlName("CBA")+" WHERE CBA_FILIAL = B2_FILIAL AND CBA_PROD  = B2_COD AND CBA_DATA >= '20130501' AND D_E_L_E_T_ <> '*')
	cQuery += " AND B2_COD NOT IN (SELECT B7_COD FROM "+RetSqlName("SB7")+" WHERE B7_FILIAL = B2_FILIAL AND B7_COD   = B2_COD AND B7_DATA  >= '20130501' AND D_E_L_E_T_ <> '*') "	
EndIf
cQuery += " AND B2_COD BETWEEN '"+mv_par02+"' AND '"+mv_par03+"'"

//CONFORME SOLICITADO PERGUNTA SE QUER INVENTARIAR PRODUTOS COM APENAS 1 ENDERECO
If MsgYesNo("Deseja Priorizar itens com 1 endere็o?","ACDMI001")
	cQuery += " AND (SELECT COUNT(BF_LOCALIZ) FROM "+RetSqlName("SBF")+" WHERE BF_FILIAL = B2_FILIAL AND BF_PRODUTO = B2_COD AND BF_LOCAL = B2_LOCAL AND D_E_L_E_T_ <> '*') = 1"
EndIf

cQuery += " ORDER BY B1_COD"
MEMOWRITE("ACDMI001P.SQL",cQuery)
dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),"TRB", .F., .T.)

Count To nRec
If nRec == 0
	MsgStop("Nใo existem mais produtos a inventariar","ACDMI001")
	TRB->(dbCloseArea())
	Return
EndIf

ProcRegua(nRec)
dbSelectArea("SB5")
SB5->(dbSetOrder(1))
dbSelectArea("TRB")
dbGoTop()
While !Eof()
	
	CBA->(dbSetOrder(3)) //CBA_FILIAL+CBA_TIPINV+CBA_STATUS+CBA_LOCAL+CBA_PROD+CBA_DATA
	If	CBA->(dbSeek(xFilial("CBA")+"1"+"0"+MV_PAR01+TRB->B1_COD+DTOS(MV_PAR05))) .OR.;
		CBA->(dbSeek(xFilial("CBA")+"1"+"1"+MV_PAR01+TRB->B1_COD+DTOS(MV_PAR05)))
		IncProc()
		dbSelectArea("TRB")
		dbSkip()
		Loop
	EndIf
	
	
	//So analisa um produto para bloqueio se encontrar na tabela de complemento,
	//caso contrario eu crio o mestre
	If	MV_PAR06==1 .and. SB5->(DbSeek(xFilial("SB5")+TRB->B1_COD))
		If	!Empty(SB5->B5_PERIOT) .And. (SB5->(B5_DTINV+B5_PERIOT)>dDataBase)
			IncProc()
			dbSelectArea("TRB")
			dbSkip()
			Loop
		EndIf
	EndIf
	
	
	cCodInv := GetSXENum("CBA","CBA_CODINV")
	RecLock("CBA",.T.)
	CBA->CBA_Filial := xFilial("CBA")
	CBA->CBA_CODINV := cCodInv
	CBA->CBA_DATA   := MV_PAR05
	CBA->CBA_CONTS  := MV_PAR04
	CBA->CBA_STATUS := "0"
	CBA->CBA_TIPINV := "1"
	CBA->CBA_PROD   := TRB->B1_COD
	CBA->CBA_LOCAL  := MV_PAR01
	CBA->CBA_CLASSA := Str(MV_PAR07,1)
	CBA->CBA_CLASSB := Str(MV_PAR08,1)
	CBA->CBA_CLASSC := Str(MV_PAR09,1)
	CBA->(MsUnlock())
	If __lSX8
		ConfirmSx8()
	EndIf
	//Mestres de Inventario gerados
	aadd(aLog,{"AI031","01",CBA_CODINV,TRB->B1_COD,CBA->CBA_LOCAL})
	
	IncProc()
	dbSelectArea("TRB")
	dbSkip()
EndDo
TRB->(dbCloseArea())
U_ImprimeInv(2,"P")
RestArea(aArea)
MostraLog("AI031","AIA032",aLog)
Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณFuno    ณTimerBrw  ณ Autor ณ Eduardo Motta         ณ Data ณ 06/04/01 ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescrio ณ Funcao que cria timer no mbrowse                           ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณParametrosณ cMBrowse -> form em que sera criado o timer                ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณRetorno   ณ .T.                                                        ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณUso       ณ                                                            ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
static Function TimerBrw(oMBrowse)
Local oTimer
DEFINE TIMER oTimer INTERVAL 1000 ACTION TmBrowse(GetObjBrow(),oTimer) OF oMBrowse
oTimer:Activate()
Return .T.


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณFuno    ณ TmBrowse ณ Autor ณ Eduardo Motta         ณ Data ณ 06/04/01 ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescrio ณ Funcao de timer do mbrowse                                 ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณParametrosณ cMBrowse -> objeto mbrowse a dar refresh                   ณฑฑ
ฑฑณ          ณ oTimer   -> objeto timer                                   ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณRetorno   ณ .T.                                                        ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณUso       ณ                                                            ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
static Function TmBrowse(oObjBrow,oTimer)
oTimer:Deactivate()
oObjBrow:Refresh()
oTimer:Activate()
Return .T.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณFuno    ณAIVA030Lg ณ Autor ณ Eduardo Motta         ณ Data ณ 06/04/01 ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescrio ณ Legenda para as cores da mbrowse                           ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณParametrosณ Nenhum                                                     ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณRetorno   ณ .T.                                                        ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณUso       ณ                                                            ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function AIVA30Lg()
Local aCorDesc := {}
aCorDesc := {	{"BR_VERDE",	"Nao Iniciado"},; //
{"BR_AMARELO",	"Em Andamento"},; //
{"BR_CINZA",	"Em Pausa"},; //
{"BR_LARANJA",	"Contado"},; //
{"BR_AZUL",		"Finalizado"},; //
{"BR_VERMELHO",	"Processado"}}  //
BrwLegenda( "Legenda - Mestre Inventario","Status", aCorDesc ) //###
Return( .T. )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษอออออออออัอออออออออออออหอออออัออออออออออออออออออออหออออออัออออออออออออปฑฑ
ฑฑบPrograma ณExcluiCBA()  บAutorณErike Yuri da Silva บ Data ณ 11/01/05   บฑฑ
ฑฑฬอออออออออุอออออออออออออสอออออฯออออออออออออออออออออสออออออฯออออออออออออนฑฑ
ฑฑบDesc.    ณ Exclui os mestres de inventario que estiverem com status deบฑฑ
ฑฑบ         ณ 0 = nao iniciado                                           บฑฑ
ฑฑบ         ณ 2 = Em Pausa                                               บฑฑ
ฑฑบ         ณ 3 = Contado                                                บฑฑ
ฑฑฬอออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso      ณ ACDA030                                                    บฑฑ
ฑฑศอออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function ExcluiCBA()
Local nX       := 0
Local nCount   := 0
Local cProduto := ""
Local cMestre  := ""
Local aProdEnd := {}

MsgAlert('Esta Rotina ira excluir todos "Mestres Inventariados" que possuirem o seguinte status:'+chr(13)+chr(10)+; //
'0 = Nao iniciado'+chr(13)+chr(10)+; //
'2 = Em Pausa'+chr(13)+chr(10)+; //
'3 = Contado'+chr(13)+chr(10)+; //
'Para os mestres que possuirem contagem em andamento, as mesmas deverao ser encerradas antes '+; //
'de sua exclusao!') //

If !IW_MSGBOX("Deseja prosseguir com a exclusao?","Atencao","YESNO") //###
	Return .f.
Endif

//                  1         2         3         4         5         6
//         123456789012345678901234567890123456789012345678901234567890
AutoGRLog(Replicate("=",75))
AutoGRLog("                         I N F O R M A T I V O") //
AutoGRLog("               H I S T O R I C O   D A S   E X C L U S O E S") //
AutoGRLog("                                   D E") //
AutoGRLog("                  M E S T R E S  D E  I N V E N T A R I O") //
AutoGRLog(Replicate("=",75))
AutoGRLog("P A R A M E T R O S:") //
AutoGRLog("Mestre De  : "+MV_PAR01) //
AutoGRLog("Mestre Ate : "+MV_PAR02) //
AutoGRLog(Replicate("=",75))
AutoGRLog("M E S T R E S   P R O C E S S A D O S :") //
AutoGRLog(Replicate("=",75))

CBA->(dbSetOrder(1))
CBB->(dbSetOrder(3))
CBC->(DbSetOrder(2))
CBA->(dbSeek(xFilial("CBA")+MV_PAR01,.T.))
While CBA->(!Eof() .and. CBA_FILIAL==xFilial("CBA") .and.  CBA_CODINV<= MV_PAR02)
	If	CBA->CBA_STATUS $ "1|4|5" // Nao excluir mestres com contagem em andamento e finalizados
		CBA->(DbSkip())
		IncProc()
		Loop
	EndIf
	cMestre := CBA->CBA_CODINV
	Begin Transaction
	CBB->(DbSetOrder(1))
	CBB->(DbSeek(xFilial("CBB")+CBA->CBA_CODINV))
	While ! CBB->(EOF()) .and. CBB->(CBB_FILIAL+CBB_CODINV) == xFilial("CBB")+CBA->CBA_CODINV
		While CBC->(DbSeek(xFilial("CBC")+CBB->CBB_NUM))
			ACD35CBM(5,CBA->CBA_CODINV,CBC->CBC_COD,CBC->CBC_LOCAL,CBC->CBC_LOCALI,CBC->CBC_LOTECT,CBC->CBC_NUMLOT,CBC->CBC_NUMSER)
			RecLock("CBC",.f.)
			CBC->(DbDelete())
			CBC->(MsUnlock())
		Enddo
		RecLock("CBB",.f.)
		CBB->(DbDelete())
		CBB->(MsUnlock())
		CBB->(DbSkip())
	Enddo
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Faz o desbloqueio do inventario                              ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	aProdEnd := {}
	CBLoadEst(aProdEnd,.f.)
	For nX := 1 to len(aProdEnd)
		cProduto := Subs(aProdEnd[nX,1],01,Tamsx3("B1_COD")[1])
		CBUnBlqInv(CBA->CBA_CODINV,cProduto)
	Next
	
	RecLock("CBA",.F.)
	CBA->(DbDelete())
	CBA->(MsUnLock())
	AutoGRLog("Mestre: "+CBA->CBA_CODINV+", excluido com sucesso!") //###
	End Transaction
	CBA->(DbSkip())
	IncProc()
	nCount++
EndDo
AutoGRLog(Replicate("=",75))
AutoGRLog("Quantidade de mestres de inventarios excluidos.: "+AllTrim(Str(nCount)) ) //
MOSTRAERRO()
Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษอออออออออัอออออออออออออหอออออัออออออออออออออออออออหออออออัออออออออออออปฑฑ
ฑฑบPrograma ณGeraSB7Auto()บAutorณErike Yuri da Silva บ Data ณ 08/10/04   บฑฑ
ฑฑฬอออออออออุอออออออออออออสอออออฯออออออออออออออออออออสออออออฯออออออออออออนฑฑ
ฑฑบDesc.    ณ Geracao de Lancamento de Inventario (SB7) Automatico       บฑฑ
ฑฑบ         ณ                                                            บฑฑ
ฑฑฬอออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso      ณ ACDA030                                                    บฑฑ
ฑฑศอออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function GeraSB7Auto()
Local cMestreAte := MV_PAR02
Local lLoop      := .F.
Local nCountDocs := 0
Local nCountOk   := 0
Local nI         := 0
Local aAreaCBA   := SGetArea()
Local lI         := 0
Private lModelo1    := GetMV("MV_CBINVMD") =="1"
Private lUsaCB001   := UsaCB0("01")
Private aProdEnd    := {}
Private lMsErroAuto := .F.
Private aLogMestre  := {}

SGetArea(aAreaCBA,"CBA")

MsgAlert('Esta Rotina ira gerar "Lancamentos Inventariados" (SB7) dos '+; //
'Mestres de Inventario informados no range, alterando o Status para "Finalizado"') //

If !IW_MSGBOX('Deseja prosseguir com a geracao de "Lancamentos de Inventario"?',"Atencao","YESNO") //###
	Return .f.
Endif

//                  1         2         3         4         5         6
//         123456789012345678901234567890123456789012345678901234567890
AutoGRLog(Replicate("=",75))
AutoGRLog("                         I N F O R M A T I V O") //
AutoGRLog("               H I S T O R I C O   D A S   G E R A C O E S") //
AutoGRLog("                                   D E") //
AutoGRLog("            L A N C A M E N T O  D O  I N V E N T A R I O (SB7)") //
AutoGRLog(Replicate("=",75))
AutoGRLog("P A R A M E T R O S:") //
AutoGRLog("Mestre De  : "+MV_PAR01) //
AutoGRLog("Mestre Ate : "+cMestreAte) //
AutoGRLog(Replicate("=",75))
AutoGRLog("I T E N S   P R O C E S S A D O S :") //
AutoGRLog(Replicate("=",75))

CBA->(dbSetOrder(1))
CBB->(dbSetOrder(3))
CBC->(DbSetOrder(2))
CBA->(dbSeek(xFilial("CBA")+MV_PAR01,.T.))
While CBA->(!Eof() .and. CBA_FILIAL==xFilial("CBA") .and.  CBA_CODINV <= cMestreAte)
	If CBA->CBA_STATUS # "3"  //processa somente os mestre contados
		CBA->(DbSkip())
		IncProc()
		Loop
	EndIf
	
	If !CBB->(dbSeek(xFilial("CBB")+CBA->CBA_CODINV))
		CBA->(DbSkip())
		IncProc()
		Loop
	EndIf
	
	//Verifica se existe contagem em andamento
	lLoop := .F.
	While CBB->(!Eof() .and. CBB->CBB_FILIAL+CBB_CODINV == xFilial("CBB")+CBA->CBA_CODINV)
		If CBB->CBB_STATUS=="1"
			lLoop := .T.
			Exit
		EndIf
		CBB->(dbSkip())
	EndDo
	
	If lLoop
		CBA->(DbSkip())
		IncProc()
		Loop
	EndIf
	
	//Analisa produto a produto e gera SB7
	aProdEnd := {}
	CBLoadEst(aProdEnd,.f.)
	lMsErroAuto	:= .F.
	CBAnaInv(.t.,.t.)
	
	CBA->(dbSkip())
	IncProc()
	nCountDocs++
EndDo

//Gravacao do Log
For nI:=1 To Len(aLogMestre)
	AutoGRLog(Space(aLogMestre[nI,2]*2)+aLogMestre[nI,3])
	If Empty(aLogMestre[nI,2]) .and. aLogMestre[nI,4]
		nCountOk++ //Contagens Ok
	EndIf
Next

AutoGRLog(Replicate("=",75))
AutoGRLog("Quantidade de mestres de inventarios analisados.: "+AllTrim(Str(nCountDocs))) //
AutoGRLog("Quantidade de mestres de inventarios Ok.........: "+AllTrim(Str(nCountOk)))   //
AutoGRLog("Quantidade de mestres de inventarios Divergentes: "+AllTrim(Str(nCountDocs-nCountOk))) //

If ExistBlock('ACDA30LG')
	aUserLog := ExecBlock('ACDA30LG',.F.,.F.)
	If ValType(aUserLog) == 'A'
		AutoGRLog(Replicate("=",75))
		For lI := 1 To Len(aUserLog)
			AutoGRLog(aUserLog[lI,1]+aUserLog[lI,2])
		Next
	Endif
Endif

MOSTRAERRO()
SRestArea(aAreaCBA)
Return



Static Function ExcluiSB7()
Local nCountM := 0
Local nCountD := 0
Local aCBA    := GetArea('CBA')
Local aSB7    := GetArea('SB7')

MsgAlert('Esta Rotina ira excluir todos "Lancamentos Inventariados" (SB7) dos '+; //
'Mestres de Inventario informados no range, alterando o Status para "Em Andamento"') //

If !IW_MSGBOX("Deseja prosseguir com a exclusao?","Atencao","YESNO") //###
	Return .f.
Endif


//                  1         2         3         4         5         6
//         123456789012345678901234567890123456789012345678901234567890
AutoGRLog(Replicate("=",75))
AutoGRLog("                         I N F O R M A T I V O") //
AutoGRLog("               H I S T O R I C O   D A S   E X C L U S O E S") //
AutoGRLog("                                   D E")  //
AutoGRLog("            L A N C A M E N T O  D O  I N V E N T A R I O (SB7)") //
AutoGRLog(Replicate("=",75))
AutoGRLog("P A R A M E T R O S:") //
AutoGRLog("Mestre De  : "+MV_PAR01) //
AutoGRLog("Mestre Ate : "+MV_PAR02) //
AutoGRLog(Replicate("=",75))
AutoGRLog("D O C U M E N T O S   P R O C E S S A D O S :") //
AutoGRLog(Replicate("=",75))

CBA->(dbSetOrder(1))
CBB->(dbSetOrder(3))
CBC->(DbSetOrder(2))
CBA->(dbSeek(xFilial("CBA")+MV_PAR01,.T.))
While CBA->(!Eof() .and. CBA_FILIAL==xFilial("CBA") .and.  CBA_CODINV<= MV_PAR02)
	
	If CBA->CBA_STATUS # "4" // Nao faz diferente de finalizado (status = 4 indica que gerou sb7)
		CBA->(DbSkip())
		IncProc()
		Loop
	EndIf
	nCountD := 0
	//Como nao existe rotina automatica para a exclusao do SB7(Mata270), a exclusao sera feita diretamente
	Begin Transaction
	DbSelectArea("SB7")
	SB7->(DbOrderNickName("ACDSB701"))
	SB7->(DbSeek(xFilial("SB7")+CBA->CBA_CODINV))
	While SB7->(!Eof() .AND. B7_FILIAL+B7_DOC==xFilial("SB7")+CBA->CBA_CODINV)
		RecLock("SB7",.F.)
		SB7->(DbDelete())
		SB7->(MsUnLock())
		nCountD++
		SB7->(DbSkip())
	EndDo
	AutoGRLog("Mestre:"+CBA->CBA_CODINV+", foram excluidos "+AllTrim(Str(nCountD))+ " documentos na tabela de lanc. invent.") //######
	RecLock("CBA",.F.)
	CBA->CBA_STATUS := "3" // Contado
	CBA->(MsUnLock())
	End Transaction
	CBA->(DbSkip())
	IncProc()
	nCountM++
EndDo
AutoGRLog(Replicate("=",75))
AutoGRLog("Quantidade de mestres de inventarios analisados.: "+AllTrim(Str(nCountM)) ) //
MostraErro()

RestArea(aSB7)
RestArea(aCBA)
Return




/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษอออออออออัอออออออออออออหอออออัออออออออออออออออออออหออออออัออออออออออออปฑฑ
ฑฑบPrograma ณGeraAcerto() บAutorณErike Yuri da Silva บ Data ณ 08/10/04   บฑฑ
ฑฑฬอออออออออุอออออออออออออสอออออฯออออออออออออออออออออสออออออฯออออออออออออนฑฑ
ฑฑบDesc.    ณ Geracao o acerto do inventario a partir no cod. do mestre  บฑฑ
ฑฑบ         ณ                                                            บฑฑ
ฑฑฬอออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso      ณ ACDA030                                                    บฑฑ
ฑฑศอออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function GeraAcerto()
Local cMestreDe  := MV_PAR01
Local cMestreAte := MV_PAR02
Local nRecnoSB7  := 0
Local aAreaCBA   := SGetArea()
Private lModelo1  := GetMV("MV_CBINVMD") =="1"
Private lUsaCB001 := UsaCB0("01")

SGetArea(aAreaCBA,"CBA")

If !IW_MSGBOX('Deseja prosseguir com o "Acerto de Inventario"?',"Atencao","YESNO") //###
	Return .f.
Endif

SB7->(DbOrderNickName("ACDSB701"))
CBA->(dbSetOrder(1))
CBA->(dbSeek(xFilial("CBA")+cMestreDe,.T.))
While CBA->(!Eof() .and. CBA_FILIAL==xFilial("CBA") .and.  CBA_CODINV<= cMestreAte)
	If CBA->CBA_STATUS # "4"  //Somente gera acerto do mestre de inventario que ja esta finalizado (SB7 gerado)
		CBA->(DbSkip())
		IncProc()
		Loop
	EndIf
	
	SB7->(DbSeek(xFilial("SB7")+CBA->CBA_CODINV))
	While SB7->(!Eof() .AND. B7_FILIAL+B7_DOC==xFilial("SB7")+CBA->CBA_CODINV)
		nRecnoSB7 := SB7->(Recno())
		MATA340(.t.,CBA->CBA_CODINV)
		SB7->(DbOrderNickName("ACDSB701"))
		SB7->(DbGoto(nRecnoSB7))
		SB7->(DbSkip())
	End
	
	CBA->(dbSkip())
	IncProc()
EndDo
SRestArea(aAreaCBA)
Return



Static Function MostraLog(cRotina,cPerg,aLog)
Local nI       := 0
Local nOk      := 0
Local nNo      := 0
Local aExcecao := {}

AutoGRLog(Replicate("=",75))
AutoGRLog("                         I N F O R M A T I V O") //
If cRotina=="AI031"
	AutoGRLog("               H I S T O R I C O   D A S   G E R A C O E S") //
	AutoGRLog("                                   D E") //
	AutoGRLog("                 M E S T R E   D E   I N V E N T A R I O") //
ElseIf cRotina=="AI030"
	AutoGRLog("               H I S T O R I C O   D A S   G E R A C O E S") //
	AutoGRLog("                                   D E") //
	AutoGRLog("                 M E S T R E   D E   I N V E N T A R I O") //
EndIf
/*
--------------------------------------------------------------------------------------------
Ronald Piscioneri, 18-Ago-2021: alterar para imprimir MV_PARnn (da memoria), ao inves do SX1
--------------------------------------------------------------------------------------------
AutoGRLog(Replicate("=",75))
AutoGRLog("P A R A M E T R O S:") //
cPerg := PADR(cPerg,nTamSX1)
SX1->(DbSetOrder(1))
SX1->(DbSeek(cPerg))
While SX1->(!Eof() .AND. X1_GRUPO == cPerg)
	If SX1->X1_GSC == 'G'
		SX1->(AutoGRLog("Pergunta "+X1_ORDEM+": "+X1_PERGUNT+Alltrim(X1_CNT01))) //
	Else
		SX1->(AutoGRLog("Pergunta "+X1_ORDEM+": "+X1_PERGUNT+If(X1_PRESEL==1,'Sim','Nao'))) // //###
	Endif
	SX1->(DbSkip())
Enddo
*/
AutoGRLog(Replicate("=",75))
AutoGRLog("I T E N S   P R O C E S S A D O S :") //
AutoGRLog(Replicate("=",75))

For nI:=1 To Len(aLog)
	If aLog[nI,2]=="98"
		aadd(aExcecao,{aLog[nI,1],NIL,aLog[nI,3],aLog[nI,4],aLog[nI,5],aLog[nI,6]})
		Loop
	EndIf
	If cRotina == "AI030"
		AutoGRLog("Mestre: "+aLog[nI,3]+" - Local: "+aLog[nI,5]+" - Endereco: "+aLog[nI,6]) //######
	ElseIf cRotina == "AI031"
		AutoGRLog("Mestre: "+aLog[nI,3]+" - Produto: "+aLog[nI,4]+" - Local: "+aLog[nI,5]) //######
	EndIf
	nOk++
Next

If !Empty(aExcecao)
	AutoGRLog("")
	AutoGRLog(Replicate("=",75))
	AutoGRLog("E X C E C O E S:") //
	AutoGRLog("- Nao foi gerado mestre de inventario para o(s) item(s) abaixo.") //
EndIf

For nI:=1 To Len(aExcecao)
	If cRotina == "AI030"
		AutoGRLog("Local: "+aExcecao[nI,5]+" - Endereco: "+aExcecao[nI,6]) //###
	ElseIf cRotina == "AI031"
		AutoGRLog("Produto: "+aExcecao[nI,4]+" - Local: "+aExcecao[nI,5]) //###
	EndIf
	nNo++
Next
AutoGRLog(Replicate("=",75))
AutoGRLog("Sucesso(s)....:"+Str(nOk)) //
AutoGRLog("Divergencia(s):"+Str(nNo)) //
MostraErro()
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณACDMI001  บAutor  ณMicrosiga           บ Data ณ  02/17/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function ImprimeInv(nImp,cRelTipo)

Local titulo       := "Itens a Inventariar por Produto"
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private limite           := 80
Private tamanho          := "P"
Private nomeprog         := "ACDMI001"
Private nTipo            := 18
Private aReturn          := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey        := 0
Private cbtxt      := Space(10)
Private cbcont     := 00
Private CONTFL     := 01
Private m_pag      := 01
Private wnrel      := "ACDMI001"
Private cPerg
Private cString
Private nOpcInv  := nImp

//QUANDO FOR VIA MENU
If nOpcInv == 1
	//Produto
	If ! Pergunte("AIA030",.T.)
		Return
	EndIf
Else
	Pergunte("AIA030",.F.)
EndIf


RptStatus({|| RunReport(Titulo,cRelTipo) },Titulo)
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณRUNREPORT บ Autor ณ AP6 IDE            บ Data ณ  05/02/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS บฑฑ
ฑฑบ          ณ monta a janela com a regua de processamento.               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Programa principal                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

Static Function RunReport(Titulo,cRelTipo)

Local cLin
local cDirDocs  := MsDocPath()
Local cArquivo 	:= "ACDMI001.CSV"
Local cPath		:= "C:\EXCEL\"
Local oExcelApp
Local n

Private cString := "TRB"
Private nHdl    := MsfCreate(cDirDocs+"\"+cArquivo,0)
Private cEOL    := "CHR(13)+CHR(10)"

//CRIA DIRETORIO
MakeDir(Trim(cPath))

FERASE( "C:\EXCEL\"+cArquivo )

if file(cArquivo) .and. ferase(cArquivo) == -1
	msgstop("Nใo foi possํvel abrir o arquivo ACDMI001.CSV pois ele pode estar aberto por outro usuแrio.")
	return(.F.)
endif
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Cria o arquivo texto                                                ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

If Empty(cEOL)
	cEOL := CHR(13)+CHR(10)
Else
	cEOL := Trim(cEOL)
	cEOL := &cEOL
Endif

If nHdl == -1
	MsgAlert("O arquivo de nome "+cArquivo+" nao pode ser executado! Verifique os parametros.","Atencao!")
	Return
Endif

if cRelTipo = "P" // Por produto
	//cQuery := " SELECT CBA_CODINV, CBA_PROD , B1_DESC, B1_PYMARCA , BF_LOCALIZ "
	cQuery := " SELECT CBA_CODINV, CBA_PROD , B1_DESC, B1_ITEMCC , BF_LOCALIZ "
	cQuery += " FROM "+RetSqlName("CBA")+" CBA"
	cQuery += " INNER JOIN "+RetSqlName("SBF")+" BF ON CBA_FILIAL = BF_FILIAL AND CBA_PROD = BF_PRODUTO AND CBA_LOCAL = BF_LOCAL"
	cQuery += " INNER JOIN "+RetSqlName("SB1")+" B1 ON CBA_FILIAL = B1_FILIAL AND B1_COD = CBA_PROD "
	cQuery += " WHERE"
	cQuery += " CBA_FILIAL = '"+xFilial("CBA")+"'"
	cQuery += " AND CBA.D_E_L_E_T_ <> '*' AND BF.D_E_L_E_T_ <> '*' AND B1.D_E_L_E_T_ <> '*'"
	//OPCAO GERACAO
	If nOpcInv == 2
		//	aadd(aLog,{"AI031","01",CBA_CODINV,TRB->B1_COD,CBA->CBA_LOCAL})
		ASort(aLog,,,{|x,y|x[3]<y[3]})
		cQuery += " AND CBA_CODINV BETWEEN '"+aLog[1][3]+"' AND '"+aLog[Len(aLog)][3]+"'"
		cQuery += " AND CBA_LOCAL = '"+mv_par01+"'"
	Else
		cQuery += " AND CBA_DATA = '"+Dtos(mv_par05)+"'"
		cQuery += " AND CBA_PROD BETWEEN '"+mv_par02+"' AND '"+mv_par03+"'"
		cQuery += " AND CBA_LOCAL = '"+mv_par01+"'"
	EndIf
	cQuery += " AND CBA_STATUS = '0'"
	cQuery += " ORDER BY CBA_PROD , BF_LOCALIZ"
Elseif cRelTipo = "E" // Por endere็o
	//cQuery := " SELECT CBA_CODINV, CBA_PROD , B1_DESC, B1_PYMARCA , BF_LOCALIZ "
	cQuery := " SELECT CBA_CODINV, BF_PRODUTO , B1_DESC, B1_ITEMCC , CBA_LOCALI " + ENTER
	cQuery += " FROM "+RetSqlName("CBA")+" CBA" + ENTER
	cQuery += " LEFT OUTER JOIN "+RetSqlName("SBF")+" BF ON CBA_FILIAL = BF_FILIAL AND CBA_LOCAL = BF_LOCAL AND CBA_LOCALI=BF_LOCALIZ AND BF.D_E_L_E_T_ <> '*'" + ENTER
	cQuery += " LEFT OUTER JOIN "+RetSqlName("SB1")+" B1 ON CBA_FILIAL = B1_FILIAL AND B1_COD = BF_PRODUTO AND B1.D_E_L_E_T_ <> '*' " + ENTER
	cQuery += " WHERE" + ENTER
	cQuery += " CBA_FILIAL = '"+xFilial("CBA")+"'" + ENTER
	cQuery += " AND CBA.D_E_L_E_T_ <> '*'  " + ENTER
	//OPCAO GERACAO
	If nOpcInv == 2
		//	aadd(aLog,{"AI031","01",CBA_CODINV,TRB->B1_COD,CBA->CBA_LOCAL})
		ASort(aLog,,,{|x,y|x[3]<y[3]})
		cQuery += " AND CBA_CODINV BETWEEN '"+aLog[1][3]+"' AND '"+aLog[Len(aLog)][3]+"'" + ENTER
		cQuery += " AND CBA_LOCAL = '"+mv_par01+"'" + ENTER
	Else
		cQuery += " AND CBA_DATA = '"+Dtos(mv_par06)+"'" + ENTER
		cQuery += " AND CBA_LOCALI BETWEEN '"+mv_par03+"' AND '"+mv_par04+"'" + ENTER
		cQuery += " AND CBA_LOCAL = '"+mv_par01+"'" + ENTER
	EndIf
	cQuery += " AND CBA_STATUS = '0'" + ENTER
	cQuery += " ORDER BY CBA_LOCALI, BF_PRODUTO "
EndIf

MemoWrite("ACDMI001REL.SQL",cQuery)
dbUseArea(.T.,"TOPCONN", TCGenQry(,,cQuery),"TRB", .F., .T.)
Count To nRec

If nRec == 0
	msgstop("Nใo existem dados para este relat๓rio","Aten็ใo!")
	TRB->(dbCloseArea())
	Return
EndIf


SetRegua(nRec)

For n := 1 to FCount()
	aTam := TamSX3(FieldName(n))
	If !Empty(aTam) .and. aTam[3] $ "N/D"
		TCSETFIELD('TRB',FieldName(n),aTam[3],aTam[1],aTam[2])
	EndIf
Next

cLin    := ''
For n := 1 to FCount()
	cLin += AllTrim(Posicione("SX3",2,FieldName(n),"X3_TITULO"))
	
	IF n == FCount()
		cLin += cEOL
	Else
		cLin += ';'
	EndIf
Next

If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
	//ConOut("Ocorreu um erro na gravacao do arquivo.")
	dbCloseArea()
	fClose(nHdl)
	Return
Endif

dbSelectArea("TRB")
dbGoTop()
While !EOF()
	
	
	If lAbortPrint
		@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
		TRB->(dbCloseArea())
		Exit
	Endif
	
	cLin    := ''
	
	For n := 1 to FCount()
		
		cLin += AllTrim(Transform(FieldGet(n),PesqPict(IIF(At('_',FieldName(n))=3,'S'+Left(FieldName(n),2),Left(FieldName(n),3)),FieldName(n))))
		cLin += ';'
	Next
	//PULA LINHA
	cLin += cEOL
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Gravacao no arquivo texto. Testa por erros durante a gravacao da    ณ
	//ณ linha montada.                                                      ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	
	If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
		//ConOut("Ocorreu um erro na gravacao do arquivo.")
		TRB->(dbCloseArea())
		fClose(nHdl)
		Return
	Endif
	
	
	dbSelectArea("TRB")
	dbSkip()
EndDo

fClose(nHdl)

CpyS2T( cDirDocs+"\"+cArquivo, cPath, .T. )

If ! ApOleClient( 'MsExcel' )
	ShellExecute("open",cPath+cArquivo,"","", 1 )
	TRB->(dbCloseArea())
	Return
EndIf

oExcelApp := MsExcel():New()
oExcelApp:WorkBooks:Open( cPath+cArquivo ) // Abre uma planilha
oExcelApp:SetVisible(.T.)

If MsgYesNo("Deseja fechar a planilha do excel?")
	oExcelApp:Quit()
	oExcelApp:Destroy()
EndIf


TRB->(dbCloseArea())

Return
