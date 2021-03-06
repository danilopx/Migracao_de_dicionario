/******************************************************************************
* PROCEDURE : SP_REL_PCP_MAPA_DIARIO  		  								  *
* OBJETIVO  : Mapa do PCP para exportar para Excel							  *
* AUTOR     : Carlos Torres                                                   *
* DATA      : 29/07/2011                                                      *
* OBSERVACAO: Principais PRW que a utilizam PCPRELMAP			              * 
*                                                                             *
*---------------------------------ALTERACOES----------------------------------*
* DATA       AUTOR       OBJETIVO                                             *
*----------- ----------- -----------------------------------------------------*
*                                                                             *
******************************************************************************/
ALTER PROCEDURE [dbo].[SP_REL_PCP_MAPA_DIARIO]
	@DINICIO VARCHAR(10),
	@DFINAL VARCHAR(10),
	@CEMPANT VARCHAR(2),
	@CFILANT VARCHAR(2)
AS
BEGIN
    CREATE TABLE #TEMP_PCP_SC2
      (
		C2_PRODUTO	VARCHAR(15)		 NULL,
		B1_DESC		VARCHAR(50)		 NULL,
		C2_DATPRF	VARCHAR(10)		 NULL,
		C2_DTENTOR	VARCHAR(10)		 NULL,
		C2_QUANT	INT
      )

	--
	-- Carga com dados da DAIHATSU
	--
	INSERT INTO #TEMP_PCP_SC2
      (
		C2_PRODUTO	,
		B1_DESC		,
		C2_DATPRF	,
		C2_DTENTOR	,
		C2_QUANT	
	  )	SELECT  
			C2_PRODUTO	,
			B1_DESC		,
			C2_DATPRF	,
			C2_DTENTOR	,
			SUM(C2_QUANT) AS C2_QUANT
		FROM SC2010 SC2
			INNER JOIN SB1010 SB1 ON SB1.B1_COD=C2_PRODUTO 
		WHERE   
			SC2.D_E_L_E_T_ 	 	<> '*' 
			AND SB1.D_E_L_E_T_ 	<> '*' 
			AND SB1.B1_TIPO		= 'PA'
			AND SC2.C2_FILIAL	= @CFILANT
			AND SC2.C2_LOCAL	= '21'
--	Solicitado pelo Alan em 27/09 alteração do filtro pela data da OP atual 
--			AND SC2.C2_DTENTOR	>= @DINICIO  
--			AND SC2.C2_DTENTOR	<= @DFINAL 
			AND SC2.C2_DATPRF	>= @DINICIO  
			AND SC2.C2_DATPRF	<= @DFINAL 
			AND @CEMPANT		= '01'
		GROUP BY C2_PRODUTO, B1_DESC , C2_DATPRF, C2_DTENTOR

	--
	-- Carga com dados da ACTION - FILIAL
	--
	INSERT INTO #TEMP_PCP_SC2
      (
		C2_PRODUTO	,
		B1_DESC		,
		C2_DATPRF	,
		C2_DTENTOR	,
		C2_QUANT	
	  )	SELECT  
			C2_PRODUTO	,
			B1_DESC		,
			C2_DATPRF	,
			C2_DTENTOR	,
			SUM(C2_QUANT) AS C2_QUANT
		FROM SC2040 SC2
			INNER JOIN SB1040 SB1 ON SB1.B1_COD=C2_PRODUTO AND B1_FILIAL = @CFILANT
		WHERE   
			SC2.D_E_L_E_T_ 	 	<> '*' 
			AND SB1.D_E_L_E_T_ 	<> '*' 
			AND SB1.B1_TIPO		= 'PA'
			AND SC2.C2_FILIAL	= @CFILANT
			AND SC2.C2_LOCAL	= '21'
--	Solicitado pelo Alan em 27/09 alteração do filtro pela data da OP atual 
--			AND SC2.C2_DTENTOR	>= @DINICIO  
--			AND SC2.C2_DTENTOR	<= @DFINAL 
			AND SC2.C2_DATPRF	>= @DINICIO  
			AND SC2.C2_DATPRF	<= @DFINAL 
			AND @CEMPANT		= '04'
		GROUP BY C2_PRODUTO, B1_DESC , C2_DATPRF, C2_DTENTOR
	--
	-- PRODUCAO LOCAL
	--
    CREATE TABLE #TEMP_PCP_SD3_LOCAL
      (
		C2_PRODUTO	VARCHAR(15)		 NULL,
		B1_DESC		VARCHAR(50)		 NULL,
		C2_DATPRF	VARCHAR(10)		 NULL,
		D3_QUANT	INT
      )

	--
	-- Carga com dados da DAIHATSU
	--
	INSERT INTO #TEMP_PCP_SD3_LOCAL
      (
		C2_PRODUTO	,
		B1_DESC		,
		C2_DATPRF	,
		D3_QUANT	
	  )	SELECT
			D3_COD AS C2_PRODUTO	,
			B1_DESC					,
			D3_EMISSAO AS C2_DATPRF	,
			SUM(D3_QUANT) AS D3_QUANT
		FROM SD3010 SD3
			INNER JOIN SB1010 SB1 ON SB1.B1_COD=D3_COD
		WHERE   
			SD3.D_E_L_E_T_ 	 	<> '*' 
			AND SB1.D_E_L_E_T_ 	<> '*' 
			AND SB1.B1_TIPO		= 'PA'
			AND SD3.D3_FILIAL	= @CFILANT
			AND SD3.D3_LOCAL	= '01'
			AND SD3.D3_TM		= '01'
			AND D3_ESTORNO		<> 'S'
			AND D3_OP			<> ''
			AND SD3.D3_EMISSAO	>= @DINICIO
			AND SD3.D3_EMISSAO	<= @DFINAL 
			AND @CEMPANT		= '01'
		GROUP BY D3_COD, B1_DESC , D3_EMISSAO

	--
	-- Carga com dados da ACTION - FILIAL
	--
	INSERT INTO #TEMP_PCP_SD3_LOCAL
      (
		C2_PRODUTO	,
		B1_DESC		,
		C2_DATPRF	,
		D3_QUANT	
	  )	SELECT
			D3_COD AS C2_PRODUTO	,
			B1_DESC					,
			D3_EMISSAO AS C2_DATPRF	,
			SUM(D3_QUANT) AS D3_QUANT
		FROM SD3040 SD3
			INNER JOIN SB1040 SB1 ON SB1.B1_COD=D3_COD AND B1_FILIAL = @CFILANT
		WHERE   
			SD3.D_E_L_E_T_ 	 	<> '*' 
			AND SB1.D_E_L_E_T_ 	<> '*' 
			AND SB1.B1_TIPO		= 'PA'
			AND SD3.D3_FILIAL	= @CFILANT
			AND SD3.D3_LOCAL	= '01'
			AND SD3.D3_TM		= '01'
			AND D3_ESTORNO		<> 'S'
			AND D3_OP			<> ''
			AND SD3.D3_EMISSAO	>= @DINICIO
			AND SD3.D3_EMISSAO	<= @DFINAL 
			AND @CEMPANT		= '04'
		GROUP BY D3_COD, B1_DESC , D3_EMISSAO
	--
	-- PRODUCAO TERCERO
	--
    CREATE TABLE #TEMP_PCP_SD3_TERCE
      (
		C2_PRODUTO	VARCHAR(15)		 NULL,
		B1_DESC		VARCHAR(50)		 NULL,
		C2_DATPRF	VARCHAR(10)		 NULL,
		D3_QUANT	INT
      )

	--
	-- Carga com dados da DAIHATSU
	--
	INSERT INTO #TEMP_PCP_SD3_TERCE
      (
		C2_PRODUTO	,
		B1_DESC		,
		C2_DATPRF	,
		D3_QUANT	
	  )	SELECT
			D3_COD AS C2_PRODUTO	,
			B1_DESC					,
			D3_EMISSAO AS C2_DATPRF	,
			SUM(D3_QUANT) AS D3_QUANT
		FROM SD3010 SD3
			INNER JOIN SB1010 SB1 ON SB1.B1_COD=D3_COD
		WHERE   
			SD3.D_E_L_E_T_ 	 	<> '*' 
			AND SB1.D_E_L_E_T_ 	<> '*' 
			AND SB1.B1_TIPO		= 'PA'
			AND SD3.D3_FILIAL	= @CFILANT
			AND SD3.D3_LOCAL	= '21'
			AND SD3.D3_TM		= '03'
			AND D3_ESTORNO		<> 'S'
			AND D3_OP			<> ''
			AND SD3.D3_EMISSAO	>= @DINICIO
			AND SD3.D3_EMISSAO	<= @DFINAL 
			AND @CEMPANT		= '01'
		GROUP BY D3_COD, B1_DESC , D3_EMISSAO

	--
	-- Carga com dados da ACTION - FILIAL
	--
	INSERT INTO #TEMP_PCP_SD3_TERCE
      (
		C2_PRODUTO	,
		B1_DESC		,
		C2_DATPRF	,
		D3_QUANT	
	  )	SELECT
			D3_COD AS C2_PRODUTO	,
			B1_DESC					,
			D3_EMISSAO AS C2_DATPRF	,
			SUM(D3_QUANT) AS D3_QUANT
		FROM SD3040 SD3
			INNER JOIN SB1040 SB1 ON SB1.B1_COD=D3_COD AND B1_FILIAL = @CFILANT
		WHERE   
			SD3.D_E_L_E_T_ 	 	<> '*' 
			AND SB1.D_E_L_E_T_ 	<> '*' 
			AND SB1.B1_TIPO		= 'PA'
			AND SD3.D3_FILIAL	= @CFILANT
			AND SD3.D3_LOCAL	= '21'
			AND SD3.D3_TM		= '03'
			AND D3_ESTORNO		<> 'S'
			AND D3_OP			<> ''
			AND SD3.D3_EMISSAO	>= @DINICIO
			AND SD3.D3_EMISSAO	<= @DFINAL 
			AND @CEMPANT		= '04'
		GROUP BY D3_COD, B1_DESC , D3_EMISSAO

	--
	-- EXPEDICAO
	--
    CREATE TABLE #TEMP_PCP_SD7_EXPED
      (
		C2_PRODUTO	VARCHAR(15)		 NULL,
		B1_DESC		VARCHAR(50)		 NULL,
		C2_DATPRF	VARCHAR(10)		 NULL,
		D7_QUANT	INT
      )

	--
	-- Carga com dados da DAIHATSU
	--
	INSERT INTO #TEMP_PCP_SD7_EXPED
      (
		C2_PRODUTO	,
		B1_DESC		,
		C2_DATPRF	,
		D7_QUANT	
	  )	SELECT 
			D7_PRODUTO AS C2_PRODUTO,
			B1_DESC					,
			D7_DATA AS C2_DATPRF	,
			SUM(D7_QTDE) AS D7_QUANT
		FROM SD7010 SD7
			INNER JOIN SB1010 SB1 ON SB1.B1_COD=D7_PRODUTO
		WHERE   
			SD7.D_E_L_E_T_ 	 	<> '*' 
			AND SB1.D_E_L_E_T_ 	<> '*' 
			AND SB1.B1_TIPO		= 'PA'
			AND SD7.D7_FILIAL	= @CFILANT
			AND SD7.D7_TIPO		= 1
			AND SD7.D7_DATA	>= @DINICIO
			AND SD7.D7_DATA	<= @DFINAL 
			AND D7_ESTORNO		<> 'S' 
			AND @CEMPANT		= '01'
		GROUP BY D7_PRODUTO, B1_DESC , D7_DATA

	--
	-- Carga com dados da ACTION - FILIAL
	--
	INSERT INTO #TEMP_PCP_SD7_EXPED
      (
		C2_PRODUTO	,
		B1_DESC		,
		C2_DATPRF	,
		D7_QUANT	
	  )	SELECT 
			D7_PRODUTO AS C2_PRODUTO,
			B1_DESC					,
			D7_DATA AS C2_DATPRF	,
			SUM(D7_QTDE) AS D7_QUANT
		FROM SD7040 SD7
			INNER JOIN SB1040 SB1 ON SB1.B1_COD=D7_PRODUTO AND B1_FILIAL = @CFILANT
		WHERE   
			SD7.D_E_L_E_T_ 	 	<> '*' 
			AND SB1.D_E_L_E_T_ 	<> '*' 
			AND SB1.B1_TIPO		= 'PA'
			AND SD7.D7_FILIAL	= @CFILANT
			AND SD7.D7_TIPO		= 1
			AND SD7.D7_DATA		>= @DINICIO
			AND SD7.D7_DATA		<= @DFINAL 
			AND D7_ESTORNO		<> 'S' 
			AND @CEMPANT		= '04'
		GROUP BY D7_PRODUTO, B1_DESC , D7_DATA
	
	SELECT 
		C2_PRODUTO	,
		B1_DESC		,
		C2_DATPRF	,
		C2_DTENTOR	,
		SUM(C2_QUANT) AS C2_QUANT	,
		SUM(D3_LOCAL) AS D3_LOCAL	,
		SUM(D3_TERCE) AS D3_TERCE	,
		SUM(D7_EXPED) AS D7_EXPED
	FROM (
			SELECT 
				C2_PRODUTO	,
				B1_DESC		,
				C2_DATPRF	,
				C2_DTENTOR	,
				C2_QUANT	,
				0	AS	D3_LOCAL	,
				0	AS	D3_TERCE	,
				0	AS	D7_EXPED
			FROM #TEMP_PCP_SC2
		UNION ALL
			SELECT 
				C2_PRODUTO	,
				B1_DESC		,
				C2_DATPRF	,
				C2_DATPRF AS C2_DTENTOR	,
				0	AS	C2_QUANT	,
				D3_QUANT	AS	D3_LOCAL,
				0	AS	D3_TERCE	,
				0	AS	D7_EXPED
			FROM #TEMP_PCP_SD3_LOCAL
		UNION ALL
			SELECT 
				C2_PRODUTO	,
				B1_DESC		,
				C2_DATPRF	,
				C2_DATPRF AS C2_DTENTOR	,
				0	AS	C2_QUANT	,
				0	AS	D3_LOCAL	,
				D3_QUANT	AS	D3_TERCE,
				0	AS	D7_EXPED
			FROM #TEMP_PCP_SD3_TERCE
		UNION ALL
			SELECT 
				C2_PRODUTO	,
				B1_DESC		,
				C2_DATPRF	,
				C2_DATPRF AS C2_DTENTOR	,
				0	AS	C2_QUANT	,
				0	AS	D3_LOCAL	,
				0	AS	D3_TERCE	,
				D7_QUANT	AS	D7_EXPED
			FROM #TEMP_PCP_SD7_EXPED
		  ) TMP
	GROUP BY C2_PRODUTO, B1_DESC, C2_DATPRF, C2_DTENTOR
	ORDER BY C2_PRODUTO  , C2_DATPRF

END
