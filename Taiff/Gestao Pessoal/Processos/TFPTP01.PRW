#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"

User Function TFPTP01()
/*/f/
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
<Descricao> : Rotina de ajuste dos Apontamentos de Faltas Integrais
<Autor> : Alexandre Alves da Silva
<Data> : 27/10/2011
<Parametros> : Nenhum	 
<Retorno> : ParamIxb          
<Processo> : Intervem no apontamento realizado para eventos de Falta Integral, que tenham sido Abonados parcialmente.
<Tipo> (Menu,Trigger,Validacao,Ponto de Entrada,Genericas,Especificas) : M
<Obs> : Especifico cliente TAIFF. 

Essa rotina foi criada para inserir o evento de Falta 1/2 Periodo nos apontamentos de Faltas Integrais, cujo abono tenha sido parcial.

‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
*/

/* Regra para o calculo das horas.
1∫ - Separa Horas Inteiras da Parte dos Minutos
2∫ - Hora Inteira x 60 minutos = Total Horas em Minutis
3∫ - Total de Horas em Minutos + Parte dos Minutos = Total Geral em Minutos
4∫ - Faz a subtraÁ„o, soma e etc., com o outro valor de horas tambÈm transformado;
5∫ - O resultado da operaÁ„o ser· Total Resultante em Minutos;
6∫ - Total Resultante em Minutos / 60 = Parte Hora Inteira . Parte Minutos Centesimal;
7∫ - Separa Parte Hora Inteira;
8∫ - Parte Minutos Centesimal * 60 / 100 = Total em Minutos Sexagenal 
9∫ - Soma a Parte Hora Inteira ao Total em Minutos Sexagel = Hora a Considerar.
*/

Local aArea         := GetArea()
Local aSays         :={ }
Local aButtons      := { }
Local cCadastro
Local nOpca			:= 0

Private aParametros := array(09)
Private cPergCal    := "TFTP01" 
Private lAbortPrint := .F.
Private cEveFalt    := Posicione("SP9",2,xFilial("SP9")+"010A","P9_CODIGO")
Private cEveFtMe    := Posicione("SP9",2,xFilial("SP9")+"008A","P9_CODIGO")

aParametros[01] :=	""					       //	Filial De
aParametros[02] :=	""					       //	Filial Ate
aParametros[03] :=	""					       //	Centro de Custo De
aParametros[04] :=	""					       //	Centro de Custo Ate
aParametros[05] :=	""					       //	Matricula De
aParametros[06] :=	""					       //	Matricula Ate
aParametros[07] :=	Ctod("  /  /    ")         //	Data Processamento De
aParametros[08] :=	Ctod("  /  /    ")         //	Data Processamento AtÈ
aParametros[09] :=	""					       //	1 = GeraÁ„o / 2 = Limpeza

//Cria perguntas caso n„o existam.
TFPT1SX1(cPergCal)


cCadastro := OemToAnsi("Ajusta Apontamento de Faltas")

AADD(aSays,OemToAnsi("Este programa efetua a geraÁ„o/limpeza do evento de Falta 1/2 Periodo,"))
AADD(aSays,OemToAnsi(" para Faltas Integrais abonadas parcialmente."))
Pergunte(cPergCal,.F. )
AADD(aButtons, { 5,.T.,{|| Pergunte(cPergCal,.T. ) } } )
AADD(aButtons, { 1,.T.,{|o| nOpca := 1,IF(TFPT1Ok(),FechaBatch(),nOpca:=0) }} )
AADD(aButtons, { 2,.T.,{|o| FechaBatch() }} )

FormBatch( cCadastro, aSays, aButtons )

If nOpca = 1
   //Prepara o array aParametros com as perguntas para a rotina.
   aParametros[01] :=	mv_par01					//	Filial De
   aParametros[02] :=	mv_par02					//	Filial Ate
   aParametros[03] :=	mv_par03					//	Centro de Custo De
   aParametros[04] :=	mv_par04					//	Centro de Custo Ate
   aParametros[05] :=	mv_par05					//	Matricula De       ADVALEXANDRE
   aParametros[06] :=	mv_par06					//	Matricula Ate
   aParametros[07] :=	mv_par07					//	Data Apont. De
   aParametros[08] :=	mv_par08					//	Data Apont. Ate
   aParametros[09] :=	mv_par09					//	Gera / Limpa

   If aParametros[09] = 1
      Processa({|lEnd| TFPTP01Gera(aParametros)},"Gerando Faltas 1/2 Periodo...") 
   Else
      Processa({|lEnd| TFPTP01Limp(aParametros)},"Limpando apontamentos gerados...") 
   EndIf

   RestArea( aArea )
   
EndIf


Return

//==============================================


Static Function TFPTP01Limp(aParametros)
/*/f/
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
<Descricao> : Faz a Limpeza Eventos de Falta 1/2 Periodo.
<Autor> : Alexandre Alves da Silva
<Data> : 27/10/2011
<Parametros> : Nenhum	 
<Retorno> : ParamIxb          
<Processo> : Intervem no apontamento realizado para eventos de Falta Integral, que tenham sido Abonados parcialmente.
<Tipo> (Menu,Trigger,Validacao,Ponto de Entrada,Genericas,Especificas) : M
<Obs> : Especifico cliente TAIFF. 

Essa rotina foi criada para inserir o evento de Falta 1/2 Periodo nos apontamentos de Faltas Integrais, cujo abono tenha sido parcial.

‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
*/
Local cQuery := ""


cQuery := "UPDATE "+RetSqlName("SPC")+" "+CRLF
cQuery += "SET PC_PDI = '   ', PC_QUANTI = 0.00 "+CRLF
cQuery += "FROM "+RetSqlName("SPC")+" "+CRLF
cQuery += "WHERE PC_FILIAL BETWEEN '"+aParametro[01]+"' AND '"+aParametro[02]+"' "+CRLF
cQuery += "  AND PC_CC     BETWEEN '"+aParametro[03]+"' AND '"+aParametro[04]+"' "+CRLF
cQuery += "  AND PC_MAT    BETWEEN '"+aParametro[05]+"' AND '"+aParametro[06]+"' "+CRLF
cQuery += "  AND PC_DATA   BETWEEN '"+DtoS(aParametro[07])+"' AND '"+DtoS(aParametro[08])+"' "+CRLF
cQuery += "  AND PC_PDI = '"+cEveFtMe+"' "+CRLF

TCSQLEXEC(cQuery)

Return


Static Function TFPTP01Gera(aParametros)
/*/f/
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
<Descricao> : Gera Eventos de Falta 1/2 Periodo.
<Autor> : Alexandre Alves da Silva
<Data> : 27/10/2011
<Parametros> : Nenhum	 
<Retorno> : ParamIxb          
<Processo> : Intervem no apontamento realizado para eventos de Falta Integral, que tenham sido Abonados parcialmente.
<Tipo> (Menu,Trigger,Validacao,Ponto de Entrada,Genericas,Especificas) : M
<Obs> : Especifico cliente TAIFF. 

Essa rotina foi criada para inserir o evento de Falta 1/2 Periodo nos apontamentos de Faltas Integrais, cujo abono tenha sido parcial.

‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
*/
Local aArea := GetArea()
Local aApont:= {}

If Empty(cEveFalt)
   Return
EndIf

dbSelectArea("SPC")
dbSetOrder(2) //PC_FILIAL + PC_MAT + PC_PD + DTOS(PC_DATA) + PC_TPMARCA + PC_CC + PC_DEPTO + PC_POSTO + PC_CODFUNC
dbGoTop()
         
//dbSeek(aParametros[01]+aParametros[05])

ProcRegua(LastRec())

While !Eof() //.And. SPC->(PC_FILIAL+PC_MAT) = SRA->(RA_FILIAL+RA_MAT)

   	  IncProc()
   	  
   	  If !(SPC->PC_FILIAL >= aParametros[01] .Or. SPC->PC_FILIAL <= aParametros[02])
   	     dbSkip()
   	     Loop
   	  ElseIf !(SPC->PC_CC >= aParametros[03] .Or. SPC->PC_CC <= aParametros[04])
   	     dbSkip()
   	     Loop
      ElseIf !(SPC->PC_MAT >= aParametros[05] .Or. SPC->PC_MAT <= aParametros[06])
   	     dbSkip()
   	     Loop
   	  EndIf      

      If PC_PD = cEveFalt .And. !Empty(PC_ABONO) .And. (PC_DATA >= aParametro[07] .Or. PC_DATA <= aParametro[08])

         If PC_QUANTC <> PC_QTABONO
                  
            nMinTotCalc := fPrepHoras( AllTrim(Str(PC_QUANTC)), Len(AllTrim(Str(PC_QUANTC))) )
            nMinTotAbon := fPrepHoras( AllTrim(Str(PC_QTABONO)), Len(AllTrim(Str(PC_QTABONO))) )         
         
            nMinTotCalc := ((nMinTotCalc - nMinTotAbon) / 60)
         
            nHorLanc := fCalcHoras(nMinTotCalc)
         
            If nHorLanc > 0
               RecLock("SPC",.F.) 
                 SPC->PC_PDI    := cEveFtMe
                 SPC->PC_QUANTI := nHorLanc
               MsUnLock()
            EndIf
         EndIf

         Aadd(aApont,{SPC->PC_FILIAL,;
                      SPC->PC_MAT,;
                      SPC->PC_PD,;
                      SPC->( DTOS(PC_DATA)),;
                      SPC->( Recno() ),;
                      })

         If SPC->PC_TPMARCA ="1E"
            dbSkip()
         Else
            dbSkip(-1)
         EndIf
                       
         If SPC->(PC_FILIAL+PC_MAT+PC_PD+DTOS(PC_DATA)) = aApont[1][1]+aApont[1][2]+aApont[1][3]+aApont[1][4] .And. SPC->PC_QUANTC <> SPC->PC_QTABONO
                          
             nMinTotAbon := If(SPC->PC_QTABONO > 0, fPrepHoras( AllTrim(Str(PC_QTABONO)), Len(AllTrim(Str(PC_QTABONO))) ), SPC->PC_QTABONO)
                       
             nMinTotCalc := fPrepHoras( AllTrim(Str(PC_QUANTC)), Len(AllTrim(Str(PC_QUANTC))) )
         
             nMinTotCalc := If(nMinTotAbon>0, ((nMinTotCalc - nMinTotAbon) / 60), (nMinTotCalc / 60) )
         
             nHorLanc := fCalcHoras(nMinTotCalc)
             
             If nHorLanc > 0
               RecLock("SPC",.F.) 
                 SPC->PC_PDI    := cEveFtMe
                 SPC->PC_QUANTI := nHorLanc
               MsUnLock()
            EndIf
            
         EndIf
                       
         SPC->( dbGoTo(aApont[1][5]) )
         
         aApont := {}
                   
      EndIf

      dbSkip()
EndDo

RestArea(aArea)

Return

//======================================================

Static Function fPrepHoras(cHoras,nTam)
/*/f/
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
<Descricao> : Prepara as Horas para o Processamento.
<Autor> : Alexandre Alves da Silva
<Data> : 27/10/2011
<Parametros> : Nenhum	 
<Retorno> : ParamIxb          
<Processo> : Intervem no apontamento realizado para eventos de Falta Integral, que tenham sido Abonados parcialmente.
<Tipo> (Menu,Trigger,Validacao,Ponto de Entrada,Genericas,Especificas) : M
<Obs> : Especifico cliente TAIFF. 

Essa rotina foi criada para inserir o evento de Falta 1/2 Periodo nos apontamentos de Faltas Integrais, cujo abono tenha sido parcial.

‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
*/
Local nX := 0                                                         
Local cHrInt := ""
Local cMnInt := ""

For nX := 1 To nTam
         
    If Subst( cHoras,nX,1 ) <> "."
       cHrInt +=  Subs( cHoras,nX,1 )
    Else
       cMnInt += Subs( cHoras,nX, (Len(cHoras) - Len(cHrInt)) )
       cMnInt := AllTrim( Right( cMnInt,(Len(cMnInt)-1) ) )
       
       cMnInt := If(cMnInt $ "1|2|3|4|5|6|7|8|9", cMnInt+"0", cMnInt)
                
       nX := nTam
       
    EndIf
Next

Return(  (Val(cHrInt)*60) + Val(cMnInt) )

//======================================================

Static Function fCalcHoras(nMinTotal)
/*/f/
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
<Descricao> : Efetua o Calculo das Horas.
<Autor> : Alexandre Alves da Silva
<Data> : 27/10/2011
<Parametros> : Nenhum	 
<Retorno> : ParamIxb          
<Processo> : Intervem no apontamento realizado para eventos de Falta Integral, que tenham sido Abonados parcialmente.
<Tipo> (Menu,Trigger,Validacao,Ponto de Entrada,Genericas,Especificas) : M
<Obs> : Especifico cliente TAIFF. 

Essa rotina foi criada para inserir o evento de Falta 1/2 Periodo nos apontamentos de Faltas Integrais, cujo abono tenha sido parcial.

‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
*/
Local nX := 0
Local cHora, cMinut := ""

For nX := 1 To Len(AllTrim(Str(nMinTotal)))
         
    If Subs( AllTrim(Str(nMinTotal)), nX, 1) <> "."
             
       cHora := Subs( AllTrim(Str(nMinTotal)), nX, 1)
    Else
       cMinut:= Subs( AllTrim(Str(nMinTotal)), nX, Len(AllTrim(Str(nMinTotal))) - Len(AllTrim(cHora)) )
       //cMinut:= Right( cMinut,(Len(cMinut)-1) )
                
       nX := Len(AllTrim(Str(nMinTotCalc)))
    EndIf
Next
         
cMinut := Round(((Val(AllTrim(cMinut)) * 60) / 100),2)
//cMinut := Left(AllTrim(Str(cMinut)),4)
         
cHora := Val(cHora) + cMinut 


Return( cHora )



Static Function TFPT1SX1(cPergCal)
/*/f/
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
<Descricao> : Prepara SX1 com o grupo de perguntas dessa rotina.
<Autor> : Alexandre Alves da Silva
<Data> : 03/09/2008
<Parametros> : Nenhum	 
<Retorno> : Nenhum          
<Processo> : Nenhum
<Tipo> (Menu,Trigger,Validacao,Ponto de Entrada,Genericas,Especificas) : M
<Obs> : 
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
*/
Local nx,ny
Local aRegs  	:= {}
Local nSX1Order	:= SX1->(IndexOrd())
Local nTam      := 10

cPergCal		:= Left(cPergCal,6)

SX1->(dbSetOrder(1))

//           Grupo   Ordem   Perg. Portugues         Perg. Espanhol           Perg. Ingles            Variavel Tipo Tamanho  Decimal Presel  GSC   Valid         Var01         Def01      DefSPA1     DefEng1          Cnt01                             Var02  Def02      DefSpa2      DefEng2     Cnt02 Var03 Def03  DefSpa3  DefEng3  Cnt03 Var04 Def04 DefSpa4 DefEng4 Cnt04  Var05  Def05  DefSpa5 DefEng5 Cnt05  XF3  GrgSxg//
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Aadd(aRegs,{cPergCal,"01"    ,"Filial De ?"          ,"øDe sucursal ?"        ,"From Branch ?"        ,"MV_CH1","C" ,02      ,0      ,0     ,"G"   ,""             ,"mv_par01", ""    ,     ""      ,     ""        ,    "01"                            ,""     ,""         ,""          ,""        ,""  ,""   ,""    ,""      ,""      ,""   ,""   ,""   ,""     ,""     ,""    ,""    ,""    ,""     ,""     ,""  ,"XM0" ,"" })
Aadd(aRegs,{cPergCal,"02"    ,"Filial Ate ?"         ,"øA sucursal ?"         ,"To Branch ?"          ,"MV_CH2","C" ,02      ,0      ,0     ,"G"   ,"naovazio"     ,"mv_par02", ""    ,     ""      ,     ""        ,    "99"                            ,""     ,""         ,""          ,""        ,""  ,""   ,""    ,""      ,""      ,""   ,""   ,""   ,""     ,""     ,""    ,""    ,""    ,""     ,""     ,""  ,"XM0" ,"" })
Aadd(aRegs,{cPergCal,"03"    ,"Centro de Custo De ?" ,"øDe Centro de Costo ?" ,"From Cost Center ?"   ,"MV_CH3","C" ,09      ,0      ,0     ,"G"   ,""             ,"mv_par03", ""    ,     ""      ,     ""        ,    ""                              ,""     ,""         ,""          ,""        ,""  ,""   ,""    ,""      ,""      ,""   ,""   ,""   ,""     ,""     ,""    ,""    ,""    ,""     ,""     ,""  ,"CTT" ,"" })
Aadd(aRegs,{cPergCal,"04"    ,"Centro de Custo Ate ?","øA Centro de Costo ?"  ,"To Cost Center ?"     ,"MV_CH4","C" ,09      ,0      ,0     ,"G"   ,"naovazio"     ,"mv_par04", ""    ,     ""      ,     ""        ,    "ZZZZZZZZZ"                     ,""     ,""         ,""          ,""        ,""  ,""   ,""    ,""      ,""      ,""   ,""   ,""   ,""     ,""     ,""    ,""    ,""    ,""     ,""     ,""  ,"CTT" ,"" })
Aadd(aRegs,{cPergCal,"05"    ,"Matricula De ?"       ,"øDe Matricula ?"       ,"From Registration ?"  ,"MV_CH5","C" ,06      ,0      ,0     ,"G"   ,""             ,"mv_par05", ""    ,     ""      ,     ""        ,    "0"                             ,""     ,""         ,""          ,""        ,""  ,""   ,""    ,""      ,""      ,""   ,""   ,""   ,""     ,""     ,""    ,""    ,""    ,""     ,""     ,""  ,"SRA" ,"" })
Aadd(aRegs,{cPergCal,"06"    ,"Matricula Ate ?"      ,"øA Matricula ?"        ,"To Registration ?"    ,"MV_CH6","C" ,06      ,0      ,0     ,"G"   ,"naovazio"     ,"mv_par06", ""    ,     ""      ,     ""        ,    "999999"                        ,""     ,""         ,""          ,""        ,""  ,""   ,""    ,""      ,""      ,""   ,""   ,""   ,""     ,""     ,""    ,""    ,""    ,""     ,""     ,""  ,"SRA" ,"" })
Aadd(aRegs,{cPergCal,"07"    ,"Data Apont.De. ?"     ,"øFecha Apont.De ?"     ,"Date Start Note ?"    ,"MV_CH7","D" ,08      ,0      ,0     ,"G"   ,"naovazio"     ,"mv_par07", ""    ,     ""      ,     ""        ,    ""                              ,""     ,""         ,""          ,""        ,""  ,""   ,""    ,""      ,""      ,""   ,""   ,""   ,""     ,""     ,""    ,""    ,""    ,""     ,""     ,""  ,""    ,"" })
Aadd(aRegs,{cPergCal,"08"    ,"Data Apont.Ate ?"     ,"øFecha Apont.Ate ?"    ,"Date End Note?"       ,"MV_CH8","D" ,08      ,0      ,0     ,"G"   ,"naovazio"     ,"mv_par08", ""    ,     ""      ,     ""        ,    ""                              ,""     ,""         ,""          ,""        ,""  ,""   ,""    ,""      ,""      ,""   ,""   ,""   ,""     ,""     ,""    ,""    ,""    ,""     ,""     ,""  ,""    ,"" })
Aadd(aRegs,{cPergCal,"09"    ,"Gera / Limpa ? "      ,"øGenera / Limpia "     ,"Prop. Admission "     ,"MV_CH9","N" ,01      ,0      ,2     ,"C"   ,""             ,"mv_par09", "Gera",     "Genera",     "Generate",    ""                              ,""     ,"Limpa"    ,"Limpia"    ,"Clean"   ,""  ,""   ,""    ,""      ,""      ,""   ,""   ,""   ,""     ,""     ,""    ,""    ,""    ,""     ,""     ,""  ,""    ,"" })


For nX := 1 to Len(aRegs)
	If !SX1->(dbSeek(Padr(cPergCal,nTam)+aRegs[nX,2]))
		RecLock('SX1',.T.)
		For nY:=1 to FCount()
			If nY <= Len(aRegs[nX])
				SX1->(FieldPut(nY,aRegs[nX,nY]))
			Endif
		Next nY
		MsUnlock()
	Endif
Next nX

SX1->(dbSetOrder(nSX1Order))

Return


Static Function TFPT1Ok()
/*/f/
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
<Descricao> : Prepara SX1 com o grupo de perguntas dessa rotina.
<Autor> : Alexandre Alves da Silva
<Data> : 03/09/2008
<Parametros> : Nenhum	 
<Retorno> : Nenhum          
<Processo> : Nenhum
<Tipo> (Menu,Trigger,Validacao,Ponto de Entrada,Genericas,Especificas) : M
<Obs> : 
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
*/
Return (MsgYesNo(OemToAnsi("Confirma configuraÁ„o dos parametros?"),OemToAnsi("AtenÁ„o!")))
