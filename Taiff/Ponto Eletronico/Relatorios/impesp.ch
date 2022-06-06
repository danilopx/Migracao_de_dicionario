#ifdef SPANISH
	#define STR0001 "Registro del Reloj"
	#define STR0002 "Se imprimira de acuerdo con los parametros solicitados por el"
	#define STR0003 "usuario."
	#define STR0004 "Matricula"
	#define STR0005 "Centro de Costo"
	#define STR0006 "Nombre"
	#define STR0007 "Turno"
	#define STR0008 "A Rayas"
	#define STR0009 "Administracion"
	#define STR0013 "Firma del Empleado"
	#define STR0014 "T O T A L E S"
	#define STR0015 "Cod Descripcion              Calc.            Cod Descripcion              Calc.          "
	#define STR0016 "Cod Descripcion                       Infor.  Cod Descripcion                       Infor."
	#define STR0017 "Cod Descripcion              Calc.    Infor.  Cod Descripcion              Calc.    Infor."
	#define STR0018 "** Excepcion no Trabajada **"
	#define STR0019 "** Feriado **"
	#define STR0020 "** Ausente **"
	#define STR0021 "** D.S.R. **"
	#define STR0022 "** Compensado **"
	#define STR0023 "** No Trabajado **"
	#define STR0024 "Emp...: "
	#define STR0025 " Matr..: "
	#define STR0026 "  Placa : "
	#define STR0027 "Direc.: "
	#define STR0028 " Nombr.: "
	#define STR0029 "N�Contr:"
	#define STR0030 " Funcion:"
	#define STR0031 "C.C...: "
	#define STR0032 " Categ.: "
	#define STR0033 "Turno.: "
	#define STR0034 "   FECHA   DIA     "
	#define STR0035 "a E. "
	#define STR0036 "a S. "
	#define STR0037 "Motivo de Abono           Horas  Tipo da Marcacion"
	#define STR0038 "C.Costo + Nombre"
	#define STR0039 "Periodo de Apontamento Invalido."
	#define STR0040 "Consultar Marcaciones"
	#define STR0041 "Motivo de Abono"
	#define STR0042 "Fecha"
	#define STR0043 "Dia"
	#define STR0044 "&#170;E."
	#define STR0045 "&#170;S."
	#define STR0046 "Observaciones"
	#define STR0047 "Horas  Tipo de Marcacion"
	#define STR0048 "Turno "
	#define STR0049 "Turnos: "
	#define STR0050 "Proceso + Matricula"
	#define STR0051 "Depto.: "
	#define STR0052 "Seleccione la opcion de impresion: "
	#define STR0053 "Por Periodo"
	#define STR0054 "Por Fechas"
	#define STR0055 "Proceso: "
	#define STR0056 "Periodo"
	#define STR0057 "Procedimiento: "
	#define STR0058 "N� Pago: "
#else
	#ifdef ENGLISH
		#define STR0001 "Time Attendance Mirror"
		#define STR0002 "It will be printed according to the parameters selected "
		#define STR0003 "by the User."
		#define STR0004 "Registr."
		#define STR0005 "Cost Center"
		#define STR0006 "Name"
		#define STR0007 "Shift"
		#define STR0008 "Z.Form"
		#define STR0009 "Management"
		#define STR0013 "Employee signature"
		#define STR0014 "T O T A L S"
		#define STR0015 "Cod Descript.                Calc.            Cod Descript.                Calc.          "
		#define STR0016 "Cod Descript.                         Infor.  Cod Descript.                         Infor."
		#define STR0017 "Cod Descript.                Calc.    Infor.  Cod Descript.                Calc.    Infor."
		#define STR0018 "** Except. not Worked **"
		#define STR0019 "** Holiday **"
		#define STR0020 "** Absent **"
		#define STR0021 "** D.S.R. **"
		#define STR0022 "** Compensat. **"
		#define STR0023 "** Not Worked **"
		#define STR0024 "Comp..: "
		#define STR0025 " Reg..: "
		#define STR0026 "  Plate : "
		#define STR0027 "Add...: "
		#define STR0028 " Name..: "
		#define STR0029 "CGC...: "
		#define STR0030 " Funct.: "
		#define STR0031 "C.C...: "
		#define STR0032 " Categ.: "
		#define STR0033 "Shift.: "
		#define STR0034 "   DATE    DAY     "
		#define STR0035 "to I. "
		#define STR0036 "to O. "
		#define STR0037 "Remarks                   Hours  Type of Marking"
		#define STR0038 "C.Cent. + Name"
		#define STR0039 "Notice Period Invalid."
		#define STR0040 "Browse Anotations"
		#define STR0041 "Bonus Reason"
		#define STR0042 "Date"
		#define STR0043 "Day"
		#define STR0044 "&#170;I."
		#define STR0045 "&#170;O."
		#define STR0046 "Observations"
		#define STR0047 "Hours  Mark Type"
		#define STR0048 "Shift "
		#define STR0049 "Shifts: "
		#define STR0050 "Process + Registration"
		#define STR0051 "Dept.: "
		#define STR0052 "Select print option: "
		#define STR0053 "By period"
		#define STR0054 "By dates"
		#define STR0055 "Process: "
		#define STR0056 "Period"
		#define STR0057 "Schedule: "
		#define STR0058 "Paym. Nr.: "
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", "Espelho Do Ponto", "Espelho do Ponto" )
		#define STR0002 If( cPaisLoc $ "ANG|PTG", "Sera impresso de acordo com os par�metro s solicitados pelo", "Ser� impresso de acordo com os parametros solicitados pelo" )
		#define STR0003 If( cPaisLoc $ "ANG|PTG", "Utilizador.", "usuario." )
		#define STR0004 If( cPaisLoc $ "ANG|PTG", "Matr�cula", "Matricula" )
		#define STR0005 If( cPaisLoc $ "ANG|PTG", "Centro De Custo", "Centro de Custo" )
		#define STR0006 "Nome"
		#define STR0007 "Turno"
		#define STR0008 If( cPaisLoc $ "ANG|PTG", "C�digo de barras", "Zebrado" )
		#define STR0009 If( cPaisLoc $ "ANG|PTG", "Administra��o", "Administra��o" )
		#define STR0013 If( cPaisLoc $ "ANG|PTG", "Assinatura Do Funcion�rio", "Assinatura do Funcionario" )
		#define STR0014 "T O T A I S"
		#define STR0015 If( cPaisLoc $ "ANG|PTG", "C�d descri��o                c�lc.            c�d descri��o                c�lc.          ", "Cod Descricao                Calc.            Cod Descricao                Calc.          " )
		#define STR0016 If( cPaisLoc $ "ANG|PTG", "C�d Descri��o                         Infor.  C�d Descri��o                         Infor.", "Cod Descricao                         Infor.  Cod Descricao                         Infor." )
		#define STR0017 If( cPaisLoc $ "ANG|PTG", "C�d Descri��o                C�lc.    Infor.  C�d Descri��o                C�lc.    Infor.", "Cod Descricao                Calc.    Infor.  Cod Descricao                Calc.    Infor." )
		#define STR0018 If( cPaisLoc $ "ANG|PTG", "** excep��o n�o trabalhada **", "** Excecao nao Trabalhada **" )
		#define STR0019 If( cPaisLoc $ "ANG|PTG", "** feriado **", "** Feriado **" )
		#define STR0020 If( cPaisLoc $ "ANG|PTG", "** ausente **", "** Ausente **" )
		#define STR0021 If( cPaisLoc $ "ANG|PTG", "** d.s.r. **", "** D.S.R. **" )
		#define STR0022 If( cPaisLoc $ "ANG|PTG", "** Compensado", "** Compensado **" )
		#define STR0023 If( cPaisLoc $ "ANG|PTG", "** n�o trabalhado **", "** Nao Trabalhado **" )
		#define STR0024 If( cPaisLoc $ "ANG|PTG", "Emp.:", "Emp...: " )
		#define STR0025 If( cPaisLoc $ "ANG|PTG", "Reg.:", " Matr..: " )
		#define STR0026 If( cPaisLoc $ "ANG|PTG", "  CArt�o: ", "  Chapa : " )
		#define STR0027 If( cPaisLoc $ "ANG|PTG", "E.n.d.:", "End...: " )
		#define STR0028 " Nome..: "
		#define STR0029 If( cPaisLoc $ "ANG|PTG", "N.� contribuinte", "CGC...: " )
		#define STR0030 If( cPaisLoc $ "ANG|PTG", " fun��o: ", " Funcao: " )
		#define STR0031 If( cPaisLoc $ "ANG|PTG", "C.c.:", "C.C...: " )
		#define STR0032 " Categ.: "
		#define STR0033 If( cPaisLoc $ "ANG|PTG", "Turno:", "Turno.: " )
		#define STR0034 If( cPaisLoc $ "ANG|PTG", "DAta     Dia     ", "   DATA    DIA     " )
		#define STR0035 If( cPaisLoc $ "ANG|PTG", "A.e.", "a E. " )
		#define STR0036 If( cPaisLoc $ "ANG|PTG", "A s. ", "a S. " )
		#define STR0037 If( cPaisLoc $ "ANG|PTG", "Observa��o  Horas  Tipo Da Marca��o", "Observacao                Horas  Tipo da Marcacao" )
		#define STR0038 If( cPaisLoc $ "ANG|PTG", "C.custo + Nome", "C.Custo + Nome" )
		#define STR0039 If( cPaisLoc $ "ANG|PTG", "Per�odo De Apontamento Inv�lido.", "Periodo de Apontamento Invalido." )
		#define STR0040 If( cPaisLoc $ "ANG|PTG", "Consultar Marca��es", "Consultar Marca&ccedil;&otilde;es" )
		#define STR0041 If( cPaisLoc $ "ANG|PTG", "Motivo De Autoriza��o", "Motivo de Abono" )
		#define STR0042 "Data"
		#define STR0043 "Dia"
		#define STR0044 If( cPaisLoc $ "ANG|PTG", "&#170;e.", "&#170;E." )
		#define STR0045 If( cPaisLoc $ "ANG|PTG", "&#170;s.", "&#170;S." )
		#define STR0046 If( cPaisLoc $ "ANG|PTG", "Observa&��e&s", "Observa&ccedil;&otilde;es" )
		#define STR0047 If( cPaisLoc $ "ANG|PTG", "Horas   Tipo Da Marca&��&o", "Horas  Tipo da Marca&ccedil;&atilde;o" )
		#define STR0048 If( cPaisLoc $ "ANG|PTG", "Turno", "Turno " )
		#define STR0049 If( cPaisLoc $ "ANG|PTG", "Turnos:", "Turnos: " )
		#define STR0050 If( cPaisLoc $ "ANG|PTG", "Processo + registo", "Processo + Matr�cula" )
		#define STR0051 "Depto.: "
		#define STR0052 If( cPaisLoc $ "ANG|PTG", "Seleccionar a op��o  de impressao: ", "Selecione a op��o de impress�o: " )
		#define STR0053 If( cPaisLoc $ "ANG|PTG", "Por per�odo", "Por Per�odo" )
		#define STR0054 "Por Datas"
		#define STR0055 "Processo: "
		#define STR0056 If( cPaisLoc $ "ANG|PTG", "Per�odo", "Periodo" )
		#define STR0057 If( cPaisLoc $ "ANG|PTG", "Mapa: ", "Roteiro: " )
		#define STR0058 If( cPaisLoc $ "ANG|PTG", "Num. pgt: ", "Num. Pagto: " )
		#define STR0059 "Informado                 Horas"
		#define STR0060 "Departamento"
		#define STR0061 "Departamento + Nome"
		#define STR0062 "Abono"
		#define STR0063 "Observa��o"
		#define STR0064 "C�digo"
		#define STR0065 "Descri��o"
		#define STR0066 "Calc."
		#define STR0067 "Infor."
		#define STR0068 "H.E."
		#define STR0069 "Absent."
		#define STR0070 "Ad. Not."
		#define STR0071 "Empresa: "
		#define STR0072 "Matr�cula: "
		#define STR0073 "Chapa: "
		#define STR0074 "Nome: "
		#define STR0075 "CNPJ: "
		#define STR0076 "Fun��o: "
		#define STR0077 "C.C.: "
		#define STR0078 "Categoria: "
		#define STR0079 "Turno: "
		#define STR0080 "Para esse relat�rio o parametro MV_COLMARC deve ser menor ou igual a 5."
		#define STR0081 "Banco de Horas"
		#define STR0082 "Saldo Anterior"
		#define STR0083 "D�bito"
		#define STR0084 "Cr�dito"
		#define STR0085 "Saldo Atual"
		#define STR0086 "Aten��o"
		#define STR0087 "O per�odo informado n�o corresponde com o do per�odo corrente. Deseja continuar mesmo assim?"
		#define STR0088 "Sit...: "
		#define STR0089 "Per�odo: "
		#define STR0090 "AFASTADO"
		#define STR0091 "FERIAS"
		#define STR0092 "TRANSFERIDO"
		#define STR0093 "DEMITIDO"
		#define STR0094 "NORMAL"
		#define STR0095 "CEI: "
		#define STR0096 "CPF: "
	#endif
#endif