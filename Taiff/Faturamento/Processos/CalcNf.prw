#Include "PROTHEUS.CH"

User Function CalcNf()
    Private _aRoma	:= {}

    cPerg	:= "CALNF"
    ValidPerg()
    Pergunte(cPerg,.T.)

    MsAguarde({|| fContinua()},"Efetuando Calculo do Frete")

Return

Static Function fContinua()
    Local _nElemRom := 0
    DbSelectArea("SF2")
    DbSeek(xFilial("SF2")+mv_par01+mv_par03,.F.) // Nota + Serie

    While ! Eof() .AND. xFilial("SF2") == SF2->F2_FILIAL .AND. SF2->F2_DOC <= mv_par02 .AND. SF2->F2_SERIE == MV_PAR03
        If SF2->F2_TIPROMA == "N"  .OR. EMPTY(SF2->F2_TIPROMA)
            U_ATUFREF2(SF2->F2_DOC,SF2->F2_DOC,"NOTA",SF2->F2_SERIE)
        Else
            _nPos := ASCAN(_aRoma,SF2->F2_ROMANEI)
            If _nPos > 0
                AADD(_aRoma,SF2->F2_ROMANEI)
            Endif
        Endif
        DbSelectArea("SF2")
        DbSkip()
    Enddo
// Efetua Calculo pelo Romaneio de Embarque para fretes especificos
    For _nElemRom	:= 1 to Len(_aRoma)
        _cNumRoma 	:= _aRoma[_nElemRom]
        U_ATUFREF2(_cNumRoma,_cNumRoma,"ROMANEIO"," ")
    Next _nElemRom

Return



/*/
    ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
    ±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
    ±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
    ±±³Fun‡…o    ³VALIDPERG ³ Autor ³  Fernando Bombardi    ³ Data ³ 05/05/03 ³±±
    ±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
    ±±³Descri‡…o ³ Verifica as perguntas incluindo-as caso nao existam		  ³±±
    ±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
    ±±³Uso       ³ Relatorio RFAT27                                           ³±±
    ±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
    ±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
    ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function VALIDPERG()

    cPerg := PADR(cPerg,6)

//Grupo/Ordem/Pergunta/Perg.Esp./Perg.English/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/DefEsp01/DefEng01/Cnt01/Var02/Def02/DefEsp02/DefEng02/Cnt02/Var03/Def03/DefEsp03/DefEng03/Cnt03/Var04/Def04/DefEsp04/DefEng04/Cnt04/Var05/Def05/DefEsp05/DefEng05/Cnt05/F3/GRPSXG
    PutSx1(cPerg,"01","Nota de          ?","","","mv_ch1","C",09,00,0,"G","","","","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","","")
    PutSx1(cPerg,"02","Nota Ate         ?","","","mv_ch2","C",09,00,0,"G","","","","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","","")
    PutSx1(cPerg,"03","Serie            ?","","","mv_ch3","C",03,00,0,"G","","","","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","","")

Return Nil
