#Include "Rwmake.ch"
#include "tbiconn.ch"
#include "tbicode.ch"
#include "topconn.ch"
#include "protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ GP010VALPE       ³Ricardo Duarte Costaº Data ³ 15/03/2013  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ponto de entrada cadastramento de funcionarios.            º±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Alterado  ³  EM    ³                Motivo                ³Solicitante ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±ºUso       ³ Taiff - numeracao automatica de matriculas                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function GP010VALPE()

Local _aArea:=GETAREA()

RCA->(DbSetorder(1))
//busca o numero sequencial da matricula, de acordo com o mnemonico M_MATRFUNC no RCA            
cMnem_ := cFaixa_ := cUltima_ := ""
If INCLUI 
	cMnem_  := "P_MATRFU"+ALLTRIM(cFilAnt)
	cFaixa_ := "899999"  //limita a faixa

	//-- Pesquisa mnemonico
	If !RCA->(Dbseek(xFilial("RCA",ALLTRIM(cFilAnt))+cMnem_))
		MsgAlert( OemToAnsi( "Erro ao ler a proxima sequencia de matricula na empresa destino. Ajuste o mnemônico: "+cMnem_ )  )
		Return(.f.)
	Endif
	cUltima_ := alltrim(Posicione("RCA",1,"  "+cMnem_,"RCA_CONTEU")) //Busca conteudo do mnemonico
	
	RCA->(Reclock("RCA",.f.))
	cUltima_ := Soma1(ALLTRIM(RCA->RCA_CONTEU))
	If M->RA_MAT <> "999999" .and. M->RA_MAT < cUltima_
		cUltima_ := M->RA_MAT  
	Else
		RCA->RCA_CONTEU := cUltima_
	EndIf
	If cUltima_ > cFaixa_
		MsgAlert("Atenção: a sequencia de matricula excedeu a faixa permitida para esta categoria")
	EndIf
	RCA->(MSUnlock())

	//-- Atualiza o número de matricula do funcionário
	M->RA_MAT    := cUltima_
EndIf

RestArea(_aArea)

Return(.T.)
