#include "protheus.ch"
#DEFINE ENTER Chr(13)+Chr(10)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �PRTR0003  �Autor  �Thiago Comelli      � Data �  26/07/11   ���
�������������������������������������������������������������������������͹��
���Desc.     �IMPRESSAO DE ETIQUETAS DE PRODUTOS PARA PROART              ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Espec�fico PROART                                          ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function PRTR0003()
	Local Arq  := CriaTrab(,.F.)+".TXT" //Nome do Arquivo a Gerar
	Local Path := GetTempPath() + Arq //Local de Gera��o do Arquivo
	Local x := 0
	//Local Path := StrTran(GetSrvProfString("StartPath","") + Arq,":","") //Local de Gera��o do Arquivo

	Private cPerg 		:= PADR("TFPRTR003",10) //Pergunta
	Private cPorta	:= AllTrim(SuperGetMV("PRT_ETQ003",.F., "LPT1")) //Define a porta padr�o da impressora
	Private nHdl

//���������������������������������������������Ŀ
//�Verifica a Existencia de Parametro PRT_ETQ003�
//�Caso nao exista. Cria o parametro.           �
//�����������������������������������������������
	dbSelectArea("SX6")
	If ! dbSeek("  "+"PRT_ETQ003")
		RecLock("SX6",.T.)
		X6_VAR    	:= "PRT_ETQ003"
		X6_TIPO 	:= "C"
		X6_CONTEUD 	:= "LPT1"
		X6_CONTENG 	:= "LPT1"
		X6_CONTSPA 	:= "LPT1"
		X6_DESCRIC	:= "DEFINE A PORTA DA IMPRESSORA DE ETIQUETAS PARA A  "
		X6_DESC1	:= "ROTINA PRTR00003                                  "
		X6_DESC2	:= "                                                  "
		MsUnlock("SX6")
	EndIf

	ValidPerg()

	If Pergunte(cPerg,.T.)

		//Seleciona dados para manipula��o
		cQuery := " SELECT B1_DESC, B1_CODBAR "
		cQuery += " FROM "+RetSqlName("SB1")
		cQuery += " WHERE D_E_L_E_T_ = '' "
		cQuery += " AND B1_FILIAL = '"+xFilial("SB1")+"'"
		cQuery += " AND B1_COD = '"+mv_par01+"' "

		//MemoWrit("PRTR0003.SQL",cQuery)
		dbUseArea(.T.,"TOPCONN", TCGenQry(,,cQuery),(cAliasQry := GetNextAlias()), .F., .T.)

		dbSelectArea(cAliasQry)
		dbGoTop()

		If (cAliasQry)->(EOF()) .OR. mv_par02 <= 0 //verifica se est� no fim do arquivo ou numero de etiquetas a imprimir � Zero.
			cMensagem := " N�o existem etiquetas para serem impressas, nenhum "+Chr(13)+Chr(10)
			cMensagem += " Produto foi selecionado pelos criterios de pesquisa."+Chr(13)+Chr(10)
			MsgStop(cMensagem,"Aten��o - PRTR0003")
			(cAliasQry)->(dbCloseArea())
			Return

		Else //Caso tenha dados come�a impress�o de etiquetas

			nHdl    := fCreate(Path) //Cria Arquivo para grava��o das etiquetas

			//������������������������Ĉ�
			//�Come�a LOOP de impressao�
			//������������������������Ĉ�
			While (cAliasQry)->(!Eof())

				For x:= 1 to ROUND((mv_par02/3),0) //Divide Numero de Etiquetas por 3, pois sao 3 por linha

					cVar := "^XA"+ENTER
					cVar += "^FO030,18^A0N,35,35^FD"	+SubStr((cAliasQry)->B1_DESC,1,10)+		"^FS"+ENTER
					cVar += "^FO030,52^BEN,45,Y,N^FD"	+SubStr((cAliasQry)->B1_CODBAR,1,13)+	"^FS"+ENTER
					cVar += "^FO295,18^A0N,35,35^FD"	+SubStr((cAliasQry)->B1_DESC,1,10)+		"^FS"+ENTER
					cVar += "^FO295,52^BEN,45,Y,N^FD"	+SubStr((cAliasQry)->B1_CODBAR,1,13)+	"^FS"+ENTER
					cVar += "^FO560,18^A0N,35,35^FD"	+SubStr((cAliasQry)->B1_DESC,1,10)+		"^FS"+ENTER
					cVar += "^FO560,52^BEN,45,Y,N^FD"	+SubStr((cAliasQry)->B1_CODBAR,1,13)+	"^FS"+ENTER
					cVar += "^XZ"+ENTER


					Set Century OFF
					If fWrite(nHdl,cVar,Len(cVar)) != Len(cVar) //Gravacao do arquivo
						If !MsgAlert("Ocorreu um erro na gravacao do arquivo !!","Atencao!")
							fClose(nHdl)
							Return
						Endif
					Endif

				Next x

				(cAliasQry)->(DbSkip())
			EndDo

			fClose(nHdl)
			COPY FILE &Path TO LPT1
			MsgAlert("Arquivo  '" + Path + "'  Gerado com Sucesso e Enviado para Impressora na Porta '"+cPorta+"'!","Aten��o")

		EndIf

		If Select(cAliasQry) > 0 //Verifica se o Alias ainda est� aberta
			(cAliasQry)->(DBCLOSEAREA())
		EndIf
	EndIf

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �ValidPerg �Autor  �Thiago Comelli      � Data �  12/01/05   ���
�������������������������������������������������������������������������͹��
���Desc.     �Cria pergunta no e o help do SX1                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function ValidPerg()

	Local cKey := ""
	Local aHelpEng := {}
	Local aHelpPor := {}
	Local aHelpSpa := {}

//PutSx1(cGrupo,cOrdem,cPergunt               ,cPerSpa               ,cPerEng          ,cVar	,cTipo  ,nTamanho				,nDecimal,nPresel,cGSC,cValid			,cF3   , cGrpSxg    ,cPyme,cVar01    ,cDef01     ,cDefSpa1,cDefEng1,cCnt01,cDef02    		,cDefSpa2,cDefEng2,cDef03       ,cDefSpa3,cDefEng3,cDef04,cDefSpa4,cDefEng4,cDef05,cDefSpa5,cDefEng5,aHelpPor,aHelpEng,aHelpSpa,cHelp)
	PutSx1(cPerg,"01"   ,"Produto De         ",""                    ,""                    ,"mv_ch1","C"   ,TamSx3("B1_COD")[1]	,0       ,1      , "G",""    			,"SB1" ,""         ,""   ,"mv_par01",""		 	 ,""      ,""      ,""    ,""		  		,""     ,""      ,""		  ,""      ,""      ,""    ,""      ,""     ,""    ,""      ,""      ,""      ,""      ,""      ,"")
	PutSx1(cPerg,"02"   ,"Quantidade de Etiq.",""                    ,""                    ,"mv_ch2","N"   ,10						,0       ,0      , "G",""    			,""    ,""         ,""   ,"mv_par02",""    		 ,""      ,""      ,""    ,""     			,""     ,""      ,""    	  ,""      ,""      ,""    ,""      ,""     ,""    ,""      ,""      ,""      ,""      ,""      ,"")

	cKey     := "P."+cPerg+"01."
	aHelpEng := {}
	aHelpPor := {}
	aHelpSpa := {}
	aAdd(aHelpEng,"")
	aAdd(aHelpEng,"")
	aAdd(aHelpPor,"Produto De")
	aAdd(aHelpPor,"")
	aAdd(aHelpSpa,"")
	aAdd(aHelpSpa,"")
	PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa)


	cKey     := "P."+cPerg+"02."
	aHelpEng := {}
	aHelpPor := {}
	aHelpSpa := {}
	aAdd(aHelpEng,"")
	aAdd(aHelpEng,"")
	aAdd(aHelpPor,"Quantidade de Etiquetas a serem impressas")
	aAdd(aHelpPor,"")
	aAdd(aHelpSpa,"")
	aAdd(aHelpSpa,"")
	PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa)

Return
