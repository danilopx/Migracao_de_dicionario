#Include "Protheus.ch"
#Include "Topconn.ch"
#include "TbiConn.ch"
#include "TbiCode.ch"
#DEFINE ENTER CHR(13) + CHR(10)
/*/
ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ FINMI003 º Autor ³ Carlos Torres      º Data ³  05/06/2020 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Grava o valor do pedido na analise de crédito em SZA010    º±±
±±º          ³ Funcionalidade do projeto financeiro de analise de crédito º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
USER FUNCTION FINMI003(CROTINA,CPEDIDO,CITEPED,CPROPED,NTTANTE)
LOCAL LRETURN   := .T.
//LOCAL CQUERY    := ""
LOCAL CRAIZCGC  := ""
LOCAL xSc5Alias	:= SC5->(GETAREA())
LOCAL xSc6Alias	:= SC6->(GETAREA())
LOCAL xSa1Alias	:= SA1->(GETAREA())
LOCAL xSd2Alias	:= SD2->(GETAREA())
LOCAL NVLPEDIDO := 0
//LOCAL cArqLog 	:= "FINANCEIRO_LOG_FINM003_"+DTOS(DDATABASE)+LEFT( TIME(), 2 )+".TXT"
//LOCAL nRec      := 0
//LOCAL NLIMANTES := 0
LOCAL __aRet    := ""

DEFAULT CITEPED := ""   // Item do pedido
DEFAULT CPROPED := ""   // Código do produto do pedido 
DEFAULT NTTANTE := 0    // Valor total do pedido

/* 
    CROTINA = E - Eliminação de residuo do pedido 
    CROTINA = X - Exclusão de pedido de venda
    CROTINA = I - Inclusão de pedido de venda
    CROTINA = F - Faturamento de pedido de venda
    CROTINA = L - Libera credito de pedido venda (FINMI001.PRW)
    CROTINA = B - Bloqueia credito de pedido venda (FINMI001.PRW)    
    CROTINA = A - Alteração de pedido de venda
*/
IF CEMPANT = "03"
    // A ANALISE DE CREDITO SERÁ EXECUTADA NA EMPRESA 03 - TAIFFPROART
    IF CROTINA = "E" // Eliminação de residuo do pedido 
        SC5->(DBSETORDER( 1 ))
        IF SC5->(DBSEEK( xFilial("SC5") + CPEDIDO ))
            IF SC5->C5_TIPO="N" .AND. ALLTRIM(SC5->C5_NUMOC) != "CROSS" .AND. ALLTRIM(SC5->C5_XITEMC) $ "TAIFF|PROART" .AND. SC5->C5_CLASPED $ "V|X|A" .AND. SC5->C5_XLIBCR = 'L'
                SA1->(DBSEEK( xFilial("SA1") + SC5->C5_CLIENTE + SC5->C5_LOJACLI ))
                CRAIZCGC := IIF( SA1->A1_TIPO="F",SUBSTRING(SA1->A1_CGC , 1 , 11),SUBSTRING(SA1->A1_CGC , 1 , LEN(SA1->A1_CGC) - 6))
                
                SC6->(DBSETORDER( 1 )) // C6_FILIAL, C6_NUM, C6_ITEM, C6_PRODUTO, R_E_C_N_O_, D_E_L_E_T_
                SC6->(DBSEEK( xFilial("SC6") + CPEDIDO + CITEPED + CPROPED ))
                IF SC6->C6_BLQ = "R" .AND. ALLTRIM(SC6->C6_LOCAL) $ "21|51" .AND. (ALLTRIM(SC6->C6_OPER) $ "V3|V5" .OR. ALLTRIM(SC6->C6_XOPER) $ "V3|V5")
                NVLPEDIDO := ((SC6->C6_QTDVEN - SC6->C6_QTDENT) * SC6->C6_PRCVEN)
                ENDIF
            ENDIF
        ENDIF
    ELSEIF CROTINA = "X"  // Exclusão de pedido de venda
        SC5->(DBSETORDER( 1 ))
        IF SC5->(DBSEEK( xFilial("SC5") + CPEDIDO ))
            IF SC5->C5_TIPO="N" .AND. ALLTRIM(SC5->C5_NUMOC) != "CROSS" .AND. ALLTRIM(SC5->C5_XITEMC) $ "TAIFF|PROART" .AND. SC5->C5_CLASPED $ "V|X|A" .AND. SC5->C5_XLIBCR = 'L' 
                SA1->(DBSEEK( xFilial("SA1") + SC5->C5_CLIENTE + SC5->C5_LOJACLI ))
                CRAIZCGC := IIF( SA1->A1_TIPO="F",SUBSTRING(SA1->A1_CGC , 1 , 11),SUBSTRING(SA1->A1_CGC , 1 , LEN(SA1->A1_CGC) - 6))
                
                SC6->(DBSETORDER( 1 ))
                SC6->(DBSEEK( xFilial("SC6") + CPEDIDO ))
                WHILE .NOT. SC6->(EOF()) .AND. SC6->C6_FILIAL=xFilial("SC6") .AND. SC6->C6_NUM=CPEDIDO
                    IF SC6->C6_BLQ != "R" .AND. ALLTRIM(SC6->C6_LOCAL) $ "21|51" .AND. (ALLTRIM(SC6->C6_OPER) $ "V3|V5" .OR. ALLTRIM(SC6->C6_XOPER) $ "V3|V5")
                        NVLPEDIDO += ((SC6->C6_QTDVEN - SC6->C6_QTDENT) * SC6->C6_PRCVEN)
                    ENDIF
                    SC6->(DBSKIP())
                END
            ENDIF
        ENDIF
    ELSEIF CROTINA = "I"  // Inclusão de pedido de venda
        SC5->(DBSETORDER( 1 ))
        IF SC5->(DBSEEK( xFilial("SC5") + CPEDIDO ))
            IF SC5->C5_TIPO="N" .AND. ALLTRIM(SC5->C5_NUMOC) != "CROSS" .AND. ALLTRIM(SC5->C5_XITEMC) $ "TAIFF|PROART" .AND. SC5->C5_CLASPED $ "V|X|A" .AND. SC5->C5_XLIBCR = 'L' 
                SA1->(DBSEEK( xFilial("SA1") + SC5->C5_CLIENTE + SC5->C5_LOJACLI ))
                CRAIZCGC := IIF( SA1->A1_TIPO="F",SUBSTRING(SA1->A1_CGC , 1 , 11),SUBSTRING(SA1->A1_CGC , 1 , LEN(SA1->A1_CGC) - 6))
                
                SC6->(DBSETORDER( 1 ))
                SC6->(DBSEEK( xFilial("SC6") + CPEDIDO ))
                WHILE .NOT. SC6->(EOF()) .AND. SC6->C6_FILIAL=xFilial("SC6") .AND. SC6->C6_NUM=CPEDIDO
                    IF ALLTRIM(SC6->C6_LOCAL) $ "21|51" .AND. (ALLTRIM(SC6->C6_OPER) $ "V3|V5" .OR. ALLTRIM(SC6->C6_XOPER) $ "V3|V5")
                        NVLPEDIDO += (SC6->C6_QTDVEN * SC6->C6_PRCVEN)
                    ENDIF
                    SC6->(DBSKIP())
                END
                NVLPEDIDO := NVLPEDIDO * (-1) // Multiplicado por -1 para inverter o valor que será submetido no saldo do pedido
            ENDIF
        ENDIF
    ELSEIF CROTINA = "F"  // Faturamento de pedido de venda
        SC5->(DBSETORDER( 1 ))
        IF SC5->(DBSEEK( xFilial("SC5") + CPEDIDO ))
            IF SC5->C5_TIPO="N" .AND. ALLTRIM(SC5->C5_NUMOC) != "CROSS" .AND. ALLTRIM(SC5->C5_XITEMC) $ "TAIFF|PROART" .AND. SC5->C5_CLASPED $ "V|X|A" .AND. SC5->C5_XLIBCR = 'L' 
                SA1->(DBSEEK( xFilial("SA1") + SC5->C5_CLIENTE + SC5->C5_LOJACLI ))
                CRAIZCGC := IIF( SA1->A1_TIPO="F",SUBSTRING(SA1->A1_CGC , 1 , 11),SUBSTRING(SA1->A1_CGC , 1 , LEN(SA1->A1_CGC) - 6))

                SC6->(DBSETORDER( 1 ))

                SD2->(DbSetOrder(3))
                SD2->(DbSeek(xFilial("SD2")+SF2->F2_DOC+SF2->F2_SERIE+SF2->F2_CLIENTE+SF2->F2_LOJA))
                While SD2->D2_FILIAL+SD2->D2_DOC+SD2->D2_SERIE+SD2->D2_CLIENTE+SD2->D2_LOJA = SF2->F2_FILIAL+SF2->F2_DOC+SF2->F2_SERIE+SF2->F2_CLIENTE+SF2->F2_LOJA .And. !SD2->(Eof())
                    IF SD2->D2_TIPO = "N" .AND. ALLTRIM(SD2->D2_LOCAL) $ "21|51" .AND. SD2->D2_PEDIDO = CPEDIDO
                        IF SC6->(DBSEEK( xFilial("SC6") + CPEDIDO + SD2->D2_ITEMPV)) 
                            IF ALLTRIM(SC6->C6_OPER) $ "V3|V5" .OR. ALLTRIM(SC6->C6_XOPER) $ "V3|V5"
                                NVLPEDIDO += (SD2->D2_QUANT * SD2->D2_PRCVEN)
                            ENDIF
                        ENDIF
                    ENDIF
                    SD2->(DBSKIP())
                END
            ENDIF
        ENDIF
    ELSEIF CROTINA = "L"  // Libera credito de pedido venda (FINMI001.PRW)
        SC5->(DBSETORDER( 1 ))
        IF SC5->(DBSEEK( xFilial("SC5") + CPEDIDO ))
            IF SC5->C5_TIPO="N" .AND. ALLTRIM(SC5->C5_NUMOC) != "CROSS" .AND. ALLTRIM(SC5->C5_XITEMC) $ "TAIFF|PROART" .AND. SC5->C5_CLASPED $ "V|X|A" .AND. SC5->C5_XLIBCR = 'L' 
                SA1->(DBSEEK( xFilial("SA1") + SC5->C5_CLIENTE + SC5->C5_LOJACLI ))
                CRAIZCGC := IIF( SA1->A1_TIPO="F",SUBSTRING(SA1->A1_CGC , 1 , 11),SUBSTRING(SA1->A1_CGC , 1 , LEN(SA1->A1_CGC) - 6))
                
                SC6->(DBSETORDER( 1 ))
                SC6->(DBSEEK( xFilial("SC6") + CPEDIDO ))
                WHILE .NOT. SC6->(EOF()) .AND. SC6->C6_FILIAL=xFilial("SC6") .AND. SC6->C6_NUM=CPEDIDO
                    IF SC6->C6_BLQ != "R" .AND. ALLTRIM(SC6->C6_LOCAL) $ "21|51" .AND. (ALLTRIM(SC6->C6_OPER) $ "V3|V5" .OR. ALLTRIM(SC6->C6_XOPER) $ "V3|V5") 
                        NVLPEDIDO += ((SC6->C6_QTDVEN - SC6->C6_QTDENT) * SC6->C6_PRCVEN)
                    ENDIF
                    SC6->(DBSKIP())
                END
                NVLPEDIDO := NVLPEDIDO * (-1) // Multiplicado por -1 para inverter o valor que será submetido no saldo do pedido
            ENDIF
        ENDIF
    ELSEIF CROTINA = "B"  // Bloquea credito de pedido venda (FINMI001.PRW)
        SC5->(DBSETORDER( 1 ))
        IF SC5->(DBSEEK( xFilial("SC5") + CPEDIDO ))
            IF SC5->C5_TIPO="N" .AND. ALLTRIM(SC5->C5_NUMOC) != "CROSS" .AND. ALLTRIM(SC5->C5_XITEMC) $ "TAIFF|PROART" .AND. SC5->C5_CLASPED $ "V|X|A" .AND. SC5->C5_XLIBCR != 'L' 
                SA1->(DBSEEK( xFilial("SA1") + SC5->C5_CLIENTE + SC5->C5_LOJACLI ))
                CRAIZCGC := IIF( SA1->A1_TIPO="F",SUBSTRING(SA1->A1_CGC , 1 , 11),SUBSTRING(SA1->A1_CGC , 1 , LEN(SA1->A1_CGC) - 6))
                
                SC6->(DBSETORDER( 1 ))
                SC6->(DBSEEK( xFilial("SC6") + CPEDIDO ))
                WHILE .NOT. SC6->(EOF()) .AND. SC6->C6_FILIAL=xFilial("SC6") .AND. SC6->C6_NUM=CPEDIDO
                    IF SC6->C6_BLQ != "R" .AND. ALLTRIM(SC6->C6_LOCAL) $ "21|51" .AND. (ALLTRIM(SC6->C6_OPER) $ "V3|V5" .OR. ALLTRIM(SC6->C6_XOPER) $ "V3|V5") 
                        NVLPEDIDO += ((SC6->C6_QTDVEN - SC6->C6_QTDENT) * SC6->C6_PRCVEN)
                    ENDIF
                    SC6->(DBSKIP())
                END

            ENDIF
        ENDIF
    ELSEIF CROTINA = "A"  // Alteração de pedido de venda, neste caso assumiremos o valor total passado pela rotina
        SC5->(DBSETORDER( 1 ))
        IF SC5->(DBSEEK( xFilial("SC5") + CPEDIDO ))
            IF SC5->C5_TIPO="N" .AND. ALLTRIM(SC5->C5_NUMOC) != "CROSS" .AND. ALLTRIM(SC5->C5_XITEMC) $ "TAIFF|PROART" .AND. SC5->C5_CLASPED $ "V|X|A" .AND. SC5->C5_XLIBCR = 'L' 
                SA1->(DBSEEK( xFilial("SA1") + SC5->C5_CLIENTE + SC5->C5_LOJACLI ))
                CRAIZCGC := IIF( SA1->A1_TIPO="F",SUBSTRING(SA1->A1_CGC , 1 , 11),SUBSTRING(SA1->A1_CGC , 1 , LEN(SA1->A1_CGC) - 6))
                
                SC6->(DBSETORDER( 1 ))
                SC6->(DBSEEK( xFilial("SC6") + CPEDIDO ))
                WHILE .NOT. SC6->(EOF()) .AND. SC6->C6_FILIAL=xFilial("SC6") .AND. SC6->C6_NUM=CPEDIDO
                    IF SC6->C6_BLQ != "R" .AND. ALLTRIM(SC6->C6_LOCAL) $ "21|51" .AND. (ALLTRIM(SC6->C6_OPER) $ "V3|V5" .OR. ALLTRIM(SC6->C6_XOPER) $ "V3|V5")
                        NVLPEDIDO := NTTANTE
                    ENDIF
                    SC6->(DBSKIP())
                END

            ENDIF
        ENDIF
    ENDIF
    If TCSPExist("SP_FIN_LIMITE_DISP")
        __aRet := TCSPExec("SP_FIN_LIMITE_DISP",  CEMPANT, CFILANT, alltrim(CRAIZCGC))
    EndIf
ENDIF
RestArea(xSc5Alias)
RestArea(xSc6Alias)
RestArea(xSa1Alias)
RestArea(xSd2Alias)

RETURN (LRETURN)

