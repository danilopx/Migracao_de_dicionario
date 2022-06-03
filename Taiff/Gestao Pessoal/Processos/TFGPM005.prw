#INCLUDE "PROTHEUS.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³TFGPM005  ºAutor  ³Ricardo Duarte Costaº Data ³  16/06/2020 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Rotina que calcula o inss a ser diferenciado de encargos.  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ TaiffProart - Atende a liminar/processo de redução de      º±±
±±º          ³ encargos de inss                                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function TFGPM005()

Local nRet		:= 0
Local nx		:= 0
Local aCodReduc	:= {}
Local aInssEnc	:= Array(23,2)

//-- Carrega tabela com as verbas a serem tratadas.
fCarrTab( @aCodReduc,"U008",stod(CPERIODO+"01"),.T.)

//-- Carrega a tabela de encargos
If !fInssEmp(SRA->RA_FILIAL,@aInssEnc,,CPERIODO)
	Return
Endif

//-- Testar se informação a ser processada
If Len(aCodReduc) > 0
	For nx := 1 to len(aCodReduc)
		//-- Verificar se existe configuração realizada
		If !Empty(alltrim(aCodReduc[nx,9])) .And. ( !Empty(alltrim(aCodReduc[nx,5])) .Or. !Empty(alltrim(aCodReduc[nx,6])) .Or. !Empty(alltrim(aCodReduc[nx,7])) )
			//-- Tratamento quando tiver pelo menos um código de verba a ser reduzido e base de cálculo informada.
			If !Empty(alltrim(aCodReduc[nx,5]))
				fGeraVerba(aCodReduc[nx,5],Round(fBuscaPd(aCodReduc[nx,9],"V",cSemana)*aInssEnc[1,1],2),,,,,,,,,.T.,,,,)
			Endif
			If !Empty(alltrim(aCodReduc[nx,6]))
				fGeraVerba(aCodReduc[nx,6],Round(fBuscaPd(aCodReduc[nx,9],"V",cSemana)*aInssEnc[2,1],2),,,,,,,,,.T.,,,,)
			Endif
			If !Empty(alltrim(aCodReduc[nx,7]))
				fGeraVerba(aCodReduc[nx,7],Round(fBuscaPd(aCodReduc[nx,9],"V",cSemana)*aInssEnc[3,1],2),,,,,,,,,.T.,,,,)
			Endif
		Endif
	Next nx
Endif

Return(nRet)
