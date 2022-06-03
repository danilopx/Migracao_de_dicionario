#Include 'Protheus.ch'

User Function MT415BRW()
	Local _cFiltro := ""

	If (cEmpAnt+cFilAnt) $ SuperGetMV("MV__MULT08",.F.,"")

		ValidPerg("FATMI00004")
		Pergunte("FATMI00004",.T.)

		_cFiltro += "SCJ->CJ_STATUS=='A' .AND. SCJ->CJ_XLIBCR $ '"+mv_par03+"' .AND. DTOS(SCJ->CJ_EMISSAO) >= '"+DTOS(mv_par01)+"' .AND. DTOS(SCJ->CJ_EMISSAO) <= '"+DTOS(mv_par02)+"' "
	EndIf

	Return(_cFiltro)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �SitCredOrc  �Autor  �Thiago Comelli    � Data �  26/11/12		 ���
�������������������������������������������������������������������������͹��
���Desc.     �Janela de sele��o dos Status do cr�dito para posterior      ���
���          �filtro                                                      ���
�������������������������������������������������������������������������͹��
���Uso       �PROART                                                      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function SitCredOrc(l1Elem,lTipoRet)

	Local cTitulo:=""
	Local MvPar
	Local MvParDef:=""

	Private aSit:={}
	l1Elem := If (l1Elem = Nil , .F. , .T.)

	DEFAULT lTipoRet := .T.

	cAlias := Alias() 					 // Salva Alias Anterior

	IF lTipoRet
		MvPar:=&(Alltrim(ReadVar()))		 // Carrega Nome da Variavel do Get em Questao
		mvRet:=Alltrim(ReadVar())			 // Iguala Nome da Variavel ao Nome variavel de Retorno
	EndIF

	cTitulo := "Situa��es Cr�dito"

	aSit := {	"P - Aguardando Avaliacao Automatica",;
		"M - Aguardando Avaliacao Manual",;
		"A - Aguardando Avaliacao Devido Altera��o de Dados",;
		"L - Cr�dito Aprovado",;
		"B - Cr�dito Bloqueado";
		}

	MvParDef:="PMALB"

	IF lTipoRet
		IF f_Opcoes(@MvPar,cTitulo,aSit,MvParDef,12,49,l1Elem)  // Chama funcao f_Opcoes
			&MvRet := mvpar                                                                          // Devolve Resultado
		EndIF
	EndIF

	dbSelectArea(cAlias) 								 // Retorna Alias

	Return( IF( lTipoRet , .T. , MvParDef ) )

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �ValidPerg �Autor  � Fernando Salvatori � Data � 26/01/2010  ���
�������������������������������������������������������������������������͹��
���Desc.     � Cria Grupo de Perguntas para este Processamento            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � 		                                                     ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function ValidPerg( cPerg )
	Local aHelp := {}

	aHelp := {}
	AAdd( aHelp, 'Informe a emissao inicial' )
	PutSX1( cPerg,"01","Emissao Inicial?","Emissao Inicial?","Emissao Inicial?","mv_ch1","D",8,0,0,"G","","","","","mv_par01","","","","","","","","","","","","","","","","",aHelp,aHelp,aHelp)

	aHelp := {}
	AAdd( aHelp, 'Informe a emissao final' )
	PutSX1( cPerg,"02","Emissao Final?","Emissao Final?","Emissao Final?","mv_ch2","D",8,0,0,"G","","","","","mv_par02","","","","","","","","","","","","","","","","",aHelp,aHelp,aHelp)

	aHelp := {}
	AAdd( aHelp, 'Informe o status do Cr�dito' )
	PutSx1(cPerg,"03","Status ?                      ","Status ?                      ","Status ?                      ","MV_CH3","C",5,0,5,"G","U_SitCredOrc                                                  ","      ","   "," ","MV_PAR03","","               ","               ","                                                            ","","               ","               ","","               ","               ","","               ","               ","   ","               ","          ","","","","")

	Return Nil