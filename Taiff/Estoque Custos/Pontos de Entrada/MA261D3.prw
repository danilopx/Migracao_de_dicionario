#Include 'Protheus.ch'

//+--------------------------------------------------------------------------------------------------------------
//| PONTO DE ENTRADA: MA261D3 		                    AUTOR: ABM						         DATA: 31/03/2011   |
//+--------------------------------------------------------------------------------------------------------------
//| DESCRICAO: PE para atualização do saldo do empenho na transferencia no modelo II
//| SOLICITANTE: 
//| OBSERVACAO: PE executado pela rotina MATA261
//+---------------------------------------------------------------------------------------------------------------
//| MODIFICAÇÕES                                                                        | AUTOR      | DATA
//+-------------------------------------------------------------------------------------+------------+------------
//| Foram inclusas colunas para gerenciamento do empenho no buffer                      | C. Torres  | 01/04/2011
//| getarea() em redundância, tratamento área SC6, tratamento área SD4,                 | R.Yamashiro| 14.07.14
//| inclusão de selectarea antes while para confirmar SD3 na execução do while          |R.Yamashiro| 14.07.14
//+--------------------------------------------------------------------------------------------------------------
/*
|---------------------------------------------------------------------------------
|	Inserido variavel array com informacoes da Area Atual para poder restaurar 
| antes de sair do PE.
|
|	Edson Hornberger - 24/06/2014
|---------------------------------------------------------------------------------
*/

User Function MA261D3()

Local aAreaAtual := GetArea()
Local aAreaSD3:= SD3->(GetArea())
Local aAreaSC6:= SC6->(GetArea())
Local aAreaSD4:= SD4->(GetArea())
Local cNtrans := SD3->D3_NUMSEQ
Local cNumOP  := "" // aCols[N, aScan(aHeader,{|x| AllTrim(x[2])=="D3_OPTRANS"})]
//incluido por JAR == 17/02/2010
Local cNumPV  := "" // aCols[N, aScan(aHeader,{|x| AllTrim(x[2])=="D3_NUM_PED"})] 
Local __cEndOrigem	:= GETNEWPAR("MV_TFENDES","BUFFER")  

/*
|=================================================================================
|   COMENTARIO
|---------------------------------------------------------------------------------
|	Realizado alteracao da verificacao de qual Modulo esta executando a funcao.
|
|	Edson Hornberger - 15/04/2014	
|=================================================================================
*/

If	Alltrim(cModulo)!="ACD" //Alltrim( _NOMEEXEC ) != 'SIGAACD.EXE'

	If Len( aCols ) > 0
		cNumOP  := aCols[N, aScan(aHeader,{|x| AllTrim(x[2])=="D3_OPTRANS"})]		
		cNumPV  := aCols[N, aScan(aHeader,{|x| AllTrim(x[2])=="D3_NUM_PED"})] 
	EndIf
	
	if !Empty( cNumPV )
		//incluido por JAR == 17/02/2010
		SC6->( DBSetOrder(1) )
		SC6->( DBSeek(xFilial("SC6")+cNumPV ) )
		if RecLock("SC6", .f.)
		   SC6->C6_DOC_END := M->cDOCUMENTO		
		   SC6->(MSUnLock())   
		endif   
		
		SD3->( DbSetOrder(4) )
		SD3->( DbSeek(xFilial("SD3") + cNtrans) )  
		
		/*
		|---------------------------------------------------------------------------------
		|	Alterado o tratamento do RecLock 
		|
		|	Edson Hornberger - 25/06/2014
		|---------------------------------------------------------------------------------
		*/
		//na tabela SD3 tem dois movimentos com o mesmo numero de sequencia
		DbSelectArea("SD3")
		While !Eof() .and. xFilial("SD3") + cNtrans == SD3->(D3_FILIAL + D3_NUMSEQ)
			If RecLock("SD3", .f.)
				SD3->D3_NUM_PED := cNumPV		
				SD3->(MSUnLock())
			EndIF
			
			SD3->( DBSkip() )
		enddo
		
		RestArea( aAreaSD3 )
	else
		If (SM0->M0_CODIGO == "01" .OR. (SM0->M0_CODIGO == "04" .AND. xFilial("SD3")=='02')) .AND. !Empty( cNumOP ) 
	
			SD3->(DbSetOrder(4))
			SD3->(DbGoTop())
			SD3->(DbSeek(xFilial("SD3") + cNtrans))
			
			/*
			|---------------------------------------------------------------------------------
			|	Alterado o tratamento do RecLock 
			|
			|	Edson Hornberger - 25/06/2014
			|---------------------------------------------------------------------------------
			*/			   
			DbSelectArea("SD3")
			While !Eof() .and. xFilial("SD3") + cNtrans == SD3->(D3_FILIAL + D3_NUMSEQ)
				If SD3->(RecLock("SD3", .F.))
					SD3->D3_OPTRANS := cNumOP
					SD3->(MsUnLock())
				EndIf
				SD3->(DbSkip())
			EndDo
					
			If Alltrim(_cOpBuffer) != Alltrim(__cEndOrigem)
				SD4->(DbSetOrder(2))
				SD4->(DbGoTop())
				If SD4->(DbSeek(xFilial("SD4") + CNUMOP + ACOLS[N,6] + ACOLS[N,9], .F.))
					if SD4->(RecLock("SD4", .F.))
					   SD4->D4_QTDPG += aCols[N, 16]
					   SD4->(MsUnLock())
					EndIf
				EndIf
			ElseIf Alltrim(_cOpBuffer) = Alltrim(__cEndOrigem)  // ctorres - 08/04
				SD4->(DbSetOrder(2))
				If SD4->(DbSeek(xFilial("SD4") + CNUMOP + ACOLS[N,6] + '11' , .F.))
					if SD4->(RecLock("SD4", .F.))
					   SD4->D4_QTBUFPG += aCols[N, 16]
					   SD4->(MsUnLock())
					EndIf					
				EndIf
			EndIf
		EndIf
	Endif
    
	SD3->(RestArea(aAreaSD3))

EndIf
                         
SD4->(RestArea(aAreaSD4))
SC6->(RestArea(aAreaSC6))
RestArea(aAreaAtual)

Return