#INCLUDE "PROTHEUS.CH"    

#define ENTER CHR(13)+CHR(10)  
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  |F040ALT   ºAutor  ³Carlos Torres       º Data ³  25/11/2020 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ O ponto de entrada F040ALT valida os dados da alteração    º±±
±±º          ³ apos a confirmação da mesma. Programa Fonte FINA040.       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ FINA040                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function F040ALT()

LOCAL aSe1Area    := SE1->(Getarea())
LOCAL dE1VENCE    := SE1->E1_VENCREA
LOCAL cE1CLI      := SE1->E1_CLIENTE
LOCAL cE1LOJA     := SE1->E1_LOJA
LOCAL cE1NUM      := SE1->E1_NUM 
LOCAL cE1PARCELA  := SE1->E1_PARCELA
LOCAL cZA6Prefixo := ""
LOCAL NPOSSE1     := SE1->(Recno())
LOCAL CTPNCC      := "NCC"

If alltrim(SE1->E1_TIPO)="NF" .AND. alltrim(SE1->E1_ITEMC)="TAIFF" .AND. CEMPANT="03"
    ZA6->(DbSetOrder(1))
    ZA6->(DbSeek( xFilial("ZA6") + cE1CLI + cE1LOJA))
    While .NOT. ZA6->(Eof()) .AND. ZA6->ZA6_FILIAL=xFilial("ZA6") .AND. ZA6->ZA6_CLIENT=cE1CLI .AND. ZA6->ZA6_LOJA=cE1LOJA
      cZA6Prefixo := LEFT(ALLTRIM(ZA6->ZA6_TPBON) + SPAC(02),3)
    	// (2) - E1_FILIAL, E1_CLIENTE, E1_LOJA, E1_PREFIXO, E1_NUM, E1_PARCELA, E1_TIPO, R_E_C_N_O_, D_E_L_E_T_
		  SE1->(DbSetOrder(2))
			IF SE1->(DbSeek( xFilial("SE1") + cE1CLI + cE1LOJA + cZA6Prefixo + cE1NUM + cE1PARCELA + CTPNCC ))
        IF SE1->(RecLock("SE1",.F.))
          SE1->E1_VENCREA := dE1VENCE
        Endif
        SE1->(MsUnlock())  
			End
			ZA6->(DbSkip())
    End
    SE1->(DbGoto( NPOSSE1 ))
Endif

RestArea(aSe1area)
Return
