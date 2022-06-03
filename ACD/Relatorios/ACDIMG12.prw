#include "protheus.ch"
#include "topconn.ch"
#DEFINE ENTER Chr(13)+Chr(10)

/*Padrao Eltron
ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³IMG12     ºAutor  ³Trade		        º Data ³  30/12/2019  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Ponto de entrada referente a imagem de identificacao do     º±±
±±º          ³dados pesagem - EMPRESA 0302- PROART                        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP5                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function Img12(_cVOLUME,_nPesoBruto,_nSeqVol,_nVoltot, _cCDestino )   // imagem de etiqueta de volume temporaria
	If _cCDestino="01"
	    MSCBBEGIN(1,6)
	    MSCBSAY(78,08,"CD "+ALLTRIM(_cCDestino),"N", "0", "040,050")
		MSCBSAY(15,12,"VOLUME","N","0","065,075")
		MSCBSAY(08,25, _cVolume, "N", "0", "065,075")    //0000000016
		MSCBSAY(68,25,alltrim(str(_nSeqVol))+"/"+alltrim(STR(_nVolTot)),"N", "0", "065,075")      //1/3
		MSCBSAY(12,45,"Peso Bruto: "+alltrim(TRANSFORM(_nPesoBruto,"@E 999,999.99"))+" Kg" ,"N", "0", "065,075")  //Peso Bruto: 99.999 Kg
		MSCBEND()
	ElseIf _cCDestino="02"
	    MSCBBEGIN(1,6)
	    MSCBSAY(78,08,"CD "+ALLTRIM(_cCDestino),"N", "0", "040,050")
		MSCBSAY(15,12,"VOLUME","N","0","065,075")
		MSCBSAY(08,25, _cVolume, "N", "0", "065,075")    //0000000016
		MSCBSAY(68,25,alltrim(str(_nSeqVol))+"/"+alltrim(STR(_nVolTot)),"N", "0", "065,075")      //1/3
		MSCBSAY(12,45,"Peso Bruto: "+alltrim(TRANSFORM(_nPesoBruto,"@E 999,999.99"))+" Kg" ,"N", "0", "065,075")  //Peso Bruto: 99.999 Kg
		MSCBEND()
		/*
			Dados do endereço do cliente se necessário
			cVar += "^FO005,160^A0N,25,25^FD"	+ALLTRIM((cAliasQry)->A1_NOME)+			"^FS"+ENTER
			cVar += "^FO005,190^A0N,25,25^FD"	+ALLTRIM((cAliasQry)->A1_LOGRE)+" "+ALLTRIM((cAliasQry)->A1_ENDENT)+", "+ALLTRIM((cAliasQry)->A1_NUME)+			"^FS"+ENTER
			cVar += "^FO005,220^A0N,25,25^FD"	+ALLTRIM((cAliasQry)->A1_BAIRRO)+		"^FS"+ENTER
			cVar += "^FO005,250^A0N,25,25^FD"	+ALLTRIM((cAliasQry)->A1_MUN)+" - "+AllTrim((cAliasQry)->A1_EST)+		"^FS"+ENTER
			cVar += "^FO005,280^A0N,25,25^FD"	+ALLTRIM(Substr((cAliasQry)->A1_CEP,1,5))+"-"+ALLTRIM(Substr((cAliasQry)->A1_CEP,6,3))+		"^FS"+ENTER
		*/
	EndIf
Return
