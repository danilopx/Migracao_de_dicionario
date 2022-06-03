#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"

//--------------------------------------------------------------------------------------------------------------
// PROGRAMA: TFNfeSin                                    AUTOR: CARLOS TORRES                 DATA: 07/02/2011
// DESCRICAO: Limpa caracteres especiais e substitui serie E por 1 em SINTEG5_CT.INI
//--------------------------------------------------------------------------------------------------------------
User Function TFNfeSin( cNfeOriginal )
Local cNfeLimpa := cNfeOriginal

If At("/" , cNfeLimpa ) != 0
	cNfeLimpa := Substr( cNfeLimpa ,  1  ,  At("/" , cNfeLimpa ) - 1 )
EndIf
While At("," , cNfeLimpa ) != 0
	cNfeLimpa := Stuff( cNfeLimpa , At("'",cNfeLimpa)  ,  1 , "" )
End
While At("." , cNfeLimpa ) != 0
	cNfeLimpa := Stuff( cNfeLimpa , At(".",cNfeLimpa)  ,  1 , "" )
End
If Len( Alltrim(cNfeLimpa) ) > 6
	cNfeLimpa := Substr( cNfeLimpa ,  4  ,  6 )
EndIf
Return (cNfeLimpa)


User Function TFSerieE( cSerieOriginal )
Local cSerieE := cSerieOriginal

cSerieE := Iif( Alltrim(cSerieE) = 'E' , '1  ' , cSerieE )

Return (cSerieE)