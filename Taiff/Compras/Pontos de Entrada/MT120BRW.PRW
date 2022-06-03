#include "rwmake.ch"  
#Include "Protheus.Ch"

User function MT120BRW()

//incluir novo botão no pedido de compras - SC7
aadd( aRotina, {"Elimina Residuos","U_ACOM001",0 , 1})
// aadd( aRotina, {"Estorna Elim.Res" ,"U_ACOM003",0 , 1}) 

//incluir novo botão no Pedido de Compras - SC7  (disparar workflow aprovador) 
// Comentado por Nilton Dias dia 22-05-2012. Está sendo homologado em ambiente de testes.
//If U_IsComprador()
//   aRotina:= U_ABMPcoRotC7()
//Endif

return