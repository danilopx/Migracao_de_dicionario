#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'TOPCONN.CH'

STATIC cMoeda330C := SuperGetMv('MV_MOEDACM',.F.,"2345")

/*
=================================================================================
=================================================================================
||   Arquivo:	A330QTMO.prw
=================================================================================
||   Funcao: 	A330QTMO
=================================================================================
||   Descricao
||-------------------------------------------------------------------------------
|| 
|| 
|| 
|| 
|| 
=================================================================================
=================================================================================
||   Autor: 
||   Data:
=================================================================================
=================================================================================
*/

USER FUNCTION A330QTMO()

	LOCAL AAREA 		:= GETAREA()
	LOCAL AAREASB2		:= SB2->(GETAREA())
	LOCAL AAREASD3		:= SD3->(GETAREA())
	LOCAL AAREASH6		:= SH6->(GETAREA())
	LOCAL NPOS			:= 0 
	PRIVATE ACSTUNIT 	:= {}

	/*
	|---------------------------------------------------------------------------------
	|	Faz a leitura da variavel Global declarada no PE MA330OK com os valores. 
	|---------------------------------------------------------------------------------
	*/
	GETGLBVARS("aGlbMT330",@ACSTUNIT)

	NPOS := ASCAN(ACSTUNIT,{|X| X[1] = SB2->B2_COD})

	IF NPOS > 0 

		dbSelectArea("SB2")
		RecLock("SB2",.F.)
		// Atualizacao do campo B2_VFIM
		Replace B2_VFIM1 With ACSTUNIT[NPOS,3] * ACSTUNIT[NPOS,2]
		Replace B2_VFIM2 With If("2" $ cMoeda330C,XMOEDA((ACSTUNIT[NPOS,3] * ACSTUNIT[NPOS,2]),1,2,DDATABASE),0)
		Replace B2_VFIM3 With If("3" $ cMoeda330C,XMOEDA((ACSTUNIT[NPOS,3] * ACSTUNIT[NPOS,2]),1,3,DDATABASE),0)
		Replace B2_VFIM4 With If("4" $ cMoeda330C,XMOEDA((ACSTUNIT[NPOS,3] * ACSTUNIT[NPOS,2]),1,4,DDATABASE),0)
		Replace B2_VFIM5 With If("5" $ cMoeda330C,XMOEDA((ACSTUNIT[NPOS,3] * ACSTUNIT[NPOS,2]),1,5,DDATABASE),0)			

		// Atualiza o campo B2_CM somente para manter legado
		Replace B2_CM1 With ACSTUNIT[NPOS,3]
		Replace B2_CM2 With If("2" $ cMoeda330C,XMOEDA(ACSTUNIT[NPOS,3],1,2,DDATABASE),0)
		Replace B2_CM3 With If("3" $ cMoeda330C,XMOEDA(ACSTUNIT[NPOS,3],1,3,DDATABASE),0)
		Replace B2_CM4 With If("4" $ cMoeda330C,XMOEDA(ACSTUNIT[NPOS,3],1,4,DDATABASE),0)
		Replace B2_CM5 With If("5" $ cMoeda330C,XMOEDA(ACSTUNIT[NPOS,3],1,5,DDATABASE),0)

		// Atualiza o campo B2_CMFIM
		Replace B2_CMFIM1 With ACSTUNIT[NPOS,3]
		Replace B2_CMFIM2 With If("2" $ cMoeda330C,XMOEDA(ACSTUNIT[NPOS,3],1,2,DDATABASE),0)
		Replace B2_CMFIM3 With If("3" $ cMoeda330C,XMOEDA(ACSTUNIT[NPOS,3],1,3,DDATABASE),0)
		Replace B2_CMFIM4 With If("4" $ cMoeda330C,XMOEDA(ACSTUNIT[NPOS,3],1,4,DDATABASE),0)
		Replace B2_CMFIM5 With If("5" $ cMoeda330C,XMOEDA(ACSTUNIT[NPOS,3],1,5,DDATABASE),0)

		Replace B2_QFIM With ACSTUNIT[NPOS,2]  


		dbSelectArea("SD3")
		dbSetOrder(7)
		dbSeek(xFilial("SD3") + SB2->B2_COD + SB2->B2_LOCAL + DTOS(GetMv("MV_ULMES") + 1))

		WHILE SD3->(!EOF()) .AND. SD3->D3_COD = SB2->B2_COD .AND. SD3->D3_EMISSAO <= MV_PAR01


			RecLock("SD3",.F.)
			SD3->D3_CUSTO1 = ACSTUNIT[NPOS,3] * SD3->D3_QUANT 

			SD3->(MsUnlock())
			dbSelectArea("SD3")
			DbSkip()	
		END

	ENDIF

	RESTAREA(AAREASD3)
	RESTAREA(AAREASB2)
	RESTAREA(AAREASH6)
	RESTAREA(AAREA)

RETURN