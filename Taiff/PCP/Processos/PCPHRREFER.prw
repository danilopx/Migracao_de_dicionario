#INCLUDE 'TOTVS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'TOPCONN.CH'
#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'TBICONN.CH'
#INCLUDE 'TBICODE.CH'

#DEFINE ENTER CHR(13) + CHR(10)
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � PCPHRREFER � Autor � Carlos Torres     � Data � 19/09/2017 ���                    
�������������������������������������������������������������������������Ĵ��
���Descri��o � Manuten��o em par�metro de referencia da producao          ���
�������������������������������������������������������������������������Ĵ��
���Parametros�                                                            ���
�������������������������������������������������������������������������Ĵ��
��� Uso      �                                                            ���
�������������������������������������������������������������������������Ĵ��
���         ATUALIZACOES SOFRIDAS DESDE A CONSTRU�AO INICIAL.             ���
�������������������������������������������������������������������������Ĵ��
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function PCPHRREFER()
cUsuLib := RetCodUsr()

If U_CHECAFUNC(cUsuLib,"PCPHRREFER")
	U_TFHR001()
Else
	Aviso("ATENCAO","Usu�rio sem acesso � rotina de altera��o do par�metro",{"OK"},3,"")
EndIf


Return


/*
Manuten��o de par�metro
*/

USER FUNCTION TFHR001()

PRIVATE ODLG01
PRIVATE OFNT01
PRIVATE OGET01
PRIVATE CGET01 	:= ""
PRIVATE OBTN01
PRIVATE OBTN02
PRIVATE LPROC	:= .F.

CGET01 	:= TFHRREFsx6()

DEFINE DIALOG ODLG01 TITLE "Hora referencia fim de apontamento" FROM 180,160 TO 380,473 PIXEL

OGET01 := 	TGET():NEW( 		030,005,{|U|IF(PCOUNT()>0,CGET01:=U,CGET01)},ODLG01	,040,010,"@R 99:99"		,,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","CGET01",,,,.F.,.F.,,"Hora fim apontamento: ",2,OFNT01 )

OGET01:OPARENT:CCAPTION := "Hora fim apontamento: "
OGET01:SETCONTENTALIGN(0)
OGET01:LVISIBLE 		:= .T.

OBNT01 :=	TBUTTON():NEW( 		085, 050, "Ok"		,ODLG01,{||LPROC:=.T.,ODLG01:END()},040,010,,,.F.,.T.,.F.,,.F.,,,.F. ) 	
OBNT02 :=	TBUTTON():NEW( 		085, 095, "Cancela"	,ODLG01,{||LPROC:=.F.,ODLG01:END()},040,010,,,.F.,.T.,.F.,,.F.,,,.F. )

ODLG01:CCAPTION := "Par�metro de referencia do apontamento"

ACTIVATE DIALOG ODLG01 CENTERED

If LPROC
	CGET01 	:= TFHRREFsx6(4)
	Aviso("AVISO","Conte�do do par�metro atualizado com sucesso!" + ENTER + "Apontamento ser� at� as " + TRANSF(CGET01,"@R 99:99"),{"OK"},3,"")
EndIf

RETURN


/*
------------------------------------------------------------------------------
Cria parametro com a hora de referencia do apontamento de produ��o 
------------------------------------------------------------------------------
*/
Static Function TFHRREFsx6(nOpcao)
Local aArea	:=	GetArea()
Local cTFhrref	:= ""   

Default nOpcao := 0

dbSelectArea( "SX6" )
dbSetOrder(1)
If !dbSeek( xFilial("SX6") + "MV__HORPCP" )
	RecLock("SX6", .T.)
	SX6->X6_FIL     := xFilial("SX6")
	SX6->X6_VAR     := "MV__HORPCP"
	SX6->X6_TIPO    := "C"
	SX6->X6_DESCRIC := "HORA REFERENCIA FIM DE APONTAMENTO DE PRODUCAO    "
	SX6->X6_CONTEUD := "1700"
	SX6->X6_CONTSPA := "1700"
	SX6->X6_CONTENG := "1700"
	SX6->X6_PROPRI  := "U"
	SX6->X6_PYME    := "S"
	MsUnlock()
EndIf
If nOpcao = 4
	RecLock("SX6", .F.)
	SX6->X6_CONTEUD := CGET01
	SX6->X6_CONTSPA := CGET01
	SX6->X6_CONTENG := CGET01
	MsUnlock()
EndIf

cTFhrref := SX6->X6_CONTEUD   

RestArea(aArea)
Return (cTFhrref)
