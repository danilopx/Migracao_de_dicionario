#INCLUDE "rwmake.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � RM410LBN � Autor � Marcelo Cardoso    � Data �  26/09/13   ���
�������������������������������������������������������������������������͹��
���Descricao � Remocao do Vinculo de Bonificacao avulsa                   ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico Taiff-ProArt                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function RM410LBN

//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������
Local _lC5PVBon := AllTrim(GetSx3Cache("C5_X_PVBON", "X3_CAMPO")) == "C5_X_PVBON"
Local _lC5LiBon := AllTrim(GetSx3Cache("C5_X_LIBON", "X3_CAMPO")) == "C5_X_LIBON"
Local _lVincBnf := ExistBlock("VINCBNF")

If _lC5PVBon .and. _lC5LiBon .and. _lVincBnf
	
	If M->C5_X_LIBON == "L"
		
		If !Empty(AllTrim(M->C5_X_PVBON))
			
			If MsgYesNo("Deseja desvincular esta bonifica��? ","Atencao")
				
				U_VincBnf(M->C5_X_PVBON, M->C5_X_PVBON, 1)
				                         
				M->C5_X_PVBON := Space(TamSx3("C5_X_PVBON")[1])
				
			EndIf
			
		EndIf
		
	EndIf
	
EndIf

Return(.T.)
