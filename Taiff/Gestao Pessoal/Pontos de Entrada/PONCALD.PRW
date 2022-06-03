#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"

User Function PONCALD()
/*/f/
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
<Descricao> : Ponto de Entrada excutado logo apÛs a finalizaÁ„o da gravaÁ„o das tabelas SPB e SPI, na rotina de Calculo Mensal.
<Autor> : Alexandre Alves da Silva
<Data> : 27/10/2011
<Parametros> : Nenhum
<Retorno> : ParamIxb
<Processo> : Intervem na totalizaÁ„o dos eventos contadores, dos eventos de Faltas Integrais.
<Tipo> (Menu,Trigger,Validacao,Ponto de Entrada,Genericas,Especificas) : M
<Obs> : Especifico cliente TAIFF.

Esse PE foi criado devido a um gap existente no sistema.
O sistema permite que se crie um evento contador, que ligado ao evento a ser contado, registra o numero de ocorrencias do evento.
Segundo o Help do campo P9_EVECONT, um evento contador poder· ser ligado ao evento de Falta Integral, que acumular· a quantidade de dias de faltas.
Ocorre que isso funciona se o campo R6_APTPMAR, do cadastro de Turno de Trabalho do colaborador, estiver preenchido com "N„o".
Do contrario, como os apontamentos ser„o demonstrados conforme o Tipo de MarcaÁ„o (1E, 1S, 2E, 2S), o evento de Falta Integral aparecer· duas vezes
para o mesmo dia.
Nesse caso, o contador acumular· duas Faltas Integrais para o mesmo dia.

Esse PE conta as ocorrencias do evento de Falta Integral nos apontamentos (SPC), considerando os apontamentos que n„o possuem Abonos e que n„o possuem
eventos informados.
Se o Turno de Trabalho do apontamento estiver com o campo Apon.Tip.Mar com "Sim", significa que o dia esta sendo apresentado em dois periodos e aÌ È necess·rio
contar as ocorrencias das Faltas Integrais considerando a Data de LanÁamento, somando as duas ocorrencias do evento para o mesmo dia.
Em seguida, acerta o lanÁamento do evento contador registrado nos resultados (SPB).

ATEN«√O!! Foi solicitado ao TI nessa data (27/10/2011) a abertura de um chamado com essa quest„o, solicitando uma intervenÁ„o da TOTVS.
Quando essa quest„o for resolvida pela TOTVS, esse PE deve ser DESABILITADO.
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
*/
Local aAreaSPC  := SPC->( GetArea() )
Local aAreaSPB  := SPB->( GetArea() )
Local aArea     := GetArea()
Local cEveFalt  := Posicione("SP9",2,xFilial("SP9")+"010A","P9_CODIGO")
Local cEveCont  := Posicione("SP9",2,xFilial("SP9")+"010A","P9_EVECONT")
Local cVerbFal  := If( !Empty(cEveCont), Posicione("SP9",1,xFilial("SP9")+cEveCont,"P9_CODFOL"), "")

Private aApont  := {}

If Empty(cEveCont) .Or. Empty(cVerbFal)
   Return
EndIf


//Processa({|lEnd| U_PNCLD01(cEveFalt,cEveCont,cVerbFal)},"Verificando quantidade de Faltas Integrais...") 
U_PNCLD01(cEveFalt,cEveCont,cVerbFal)

//Processa({|lEnd| U_PNCLD02()},"Ajustando Faltas Integrais nos Resultados...") 
U_PNCLD02()


RestArea( aArea )
RestArea( aAreaSPC )
RestArea( aAreaSPB )

Return


User Function PNCLD01(cEveFalt,cEveCont,cVerbFal)
/*/f/
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
<Descricao> : PNCLD01(cEveFalt,cEveCont,cVerbFal) - Faz a ApuraÁ„o das Faltas Integrais nos Apontamentos.
<Autor> : Alexandre Alves da Silva
<Data> : 27/10/2011
<Parametros> : Nenhum
<Retorno> : ParamIxb
<Processo> : Intervem na totalizaÁ„o dos eventos contadores, dos eventos de Faltas Integrais.
<Tipo> (Menu,Trigger,Validacao,Ponto de Entrada,Genericas,Especificas) : M
<Obs> : Especifico cliente TAIFF.
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
*/
Local nRecMatris := 0
Local nPosApont  := 0

dbSelectArea("SPC")
dbSetOrder(2) //PC_FILIAL+PC_MAT+DTOS(PC_DATA)+PC_PD+PC_TPMARCA+PC_CC+PC_DEPTO+PC_POSTO+PC_CODFUNC
dbGoTop()

//ProcRegua(LastRec())

If dbSeek( SRA->(RA_FILIAL+RA_MAT) )

   While !Eof() .And. SPC->(PC_FILIAL+PC_MAT) = SRA->(RA_FILIAL+RA_MAT)

//   	  IncProc()
   	  
   	  If        SPC->PC_PD = cEveFalt .And.;
   	      Empty(SPC->PC_PDI) .And.;
   	      Empty(SPC->PC_ABONO) .And.;
   	     !Empty(SPC->PC_TPMARCA)
   	     
   	     If Posicione("SR6",1,xFilial("SR6")+SPC->PC_TURNO,"R6_APTPMAR") = "S"
   	     
   	        nRecMatris ++
   	     
            Aadd(aApont,{SPC->PC_FILIAL,;       //01 - Filial
                         SPC->PC_MAT,;          //02 - Matricula
                         SPC->PC_PD,;           //03 - Evento
                         SPC->( DTOS(PC_DATA)),;//04 - Data
                         SPC->( Recno() ),;     //05 - RECNO
                         nRecMatris,;           //06 - PosiÁ„o na Matriz
                         0,;                    //07 - Quantidade do Evento
                         cVerbFal})             //08 - Verba de Falta da Folha
   	     
   	        If SPC->PC_TPMARCA = "1E"
   	           dbSkip()
   	           
   	               nPosApont := Ascan( aApont,{ |x| x[1]+x[2]+x[3] =  SPC->(PC_FILIAL+PC_MAT+PC_PD) .And. x[4] = SPC->( DToS(PC_DATA))})
   	           If  nPosApont > 0 .And. SPC->PC_TPMARCA = "2E"
   	           
   	              //SPC->(PC_FILIAL+PC_MAT+PC_PD) = aApont[nRecMatris][01]+aApont[nRecMatris][02]+aApont[nRecMatris][03] .And.;
   	              //SPC->( DToS(PC_DATA))         = aApont[nRecMatris][04] .And.;
   	              //SPC->PC_TPMARCA = "2E"
   	              
   	              aApont[nPosApont][07] ++
   	           EndIf
   	        EndIf
   	     EndIf
   	  ElseIf SPC->PC_PD = cEveFalt
            Aadd(aApont,{SPC->PC_FILIAL,;       //01 - Filial
                         SPC->PC_MAT,;          //02 - Matricula
                         SPC->PC_PD,;           //03 - Evento
                         SPC->( DTOS(PC_DATA)),;//04 - Data
                         SPC->( Recno() ),;     //05 - RECNO
                         nRecMatris,;           //06 - PosiÁ„o na Matriz
                         1,;                    //07 - Quantidade do Evento
                         cVerbFal})             //08 - Verba de Falta da Folha

   	  EndIf
   	  
   	  SPC->( dbSkip() )
   EndDo 
EndIf


Return


User Function PNCLD02()
/*/f/
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
<Descricao> : PNCLD02() - Faz o Ajuste das Faltas Integrais nos Resultados.
<Autor> : Alexandre Alves da Silva
<Data> : 27/10/2011
<Parametros> : Nenhum
<Retorno> : ParamIxb
<Processo> : Intervem na totalizaÁ„o dos eventos contadores, dos eventos de Faltas Integrais.
<Tipo> (Menu,Trigger,Validacao,Ponto de Entrada,Genericas,Especificas) : M
<Obs> : Especifico cliente TAIFF.
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
*/
Local nX     := 0
Local aApTot := {}
Local nPosTot:= 0

/*
aApont[nX][01] - Filial
aApont[nX][02] - Matricula
aApont[nX][03] - Evento
aApont[nX][04] - Data
aApont[nX][05] - RECNO SPC
aApont[nX][06] - PosiÁ„o na Matriz
aApont[nX][07] - Quantidade do Evento
aApont[nX][08] - Verba de Falta da Folha
*/


If Empty(aApont)
   Return
EndIf


For nX:= 1 To Len(aApont)

    nPosTot := Ascan(aApTot,{|x| x[1]= aApont[nX][01] .And. x[2]= aApont[nX][02]} )
    
    If nPosTot = 0
       Aadd(aApTot, {aApont[nX][01],; //01 - Filial
                     aApont[nX][02],; //02 - Matricula
                     aApont[nX][07],; //03 - Quantidade do Evento de Falta Integral
                     aApont[nX][08];  //04 - Verba de Falta da Folha
                     })
    Else
       aApTot[nPosTot][03] += aApont[nX][07]
    EndIf
Next

dbSelectArea("SPB")
dbSetOrder(1) //PB_FILIAL+PB_MAT+PB_PD+PB_CC+PB_DEPTO+PB_POSTO+PB_CODFUNC
dbGoTop()

//ProcRegua(Len(aApTot))

For nX := 1 To Len(aApTot)

//    IncProc()
    
    If SPB->( dbSeek(aApTot[nX][01]+aApTot[nX][02]+aApTot[nX][04]))
       RecLock("SPB",.F.)
        If aApTot[nX][03] = 0
           dbDelete()
        Else
           SPB->PB_HORAS := aApTot[nX][03]
        EndIf
       MsUnLock()
    EndIf

Next


Return()
