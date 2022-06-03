//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ PREFEITURA MUNICIPAL DE INDAIATUBA                                                                                                   ³
//³ Secretaria da Fazenda / Departamento de Rendas Mobiliarias                                                                           ³
//³ Departamento de Informatica                                                                                                          ³
//³                                                                                                                                      ³
//³ Nota Fiscal de Servicos Eletronica NFS-e - DEISS                                                                                     ³
//³ Leiaute de Importacao e Exportacao de Dados para Emissao de NFS-e                                                                    ³
//³ Versao 2.0.0.7 - 03/07/2018                                                                                                          ³
//³                                                                                                                                      ³
//³ Os arquivos devem ser gerados no formato texto – TXT, padrão de codificacao UTF-8 (sem BOM), contendo apenas caracteres da tabela    ³
//³ ASCII com as informacoes sobre os servicos prestados, com no maximo 50 (cinquenta) registros por arquivo. Cada linha do arquivo deve ³
//³ conter um registro e todos os registros devem conter, no final de cada linha do arquivo digital, os caracteres "CR" (Carriage Return)³
//³ e "LF" (Line Feed) correspondentes a "retorno do carro" e "salto de linha".                                                          ³
//³ Os registros devem estrar ordenados pelo campo Data do RPS, por ordem crescente. Sera aceita apenas uma atividade por Nota Fiscal.   ³
//³ e obrigatorio indicar o numero do Recibo Provisorio de Serviços (RPS) para gerar as Notas Fiscais Eletronicas.                       ³
//³ Qualquer duvida referente ao codigo e ao enquadramento da atividade ou servico verifique a lista de serviços ISSQN no site da        ³
//³ Prefeitura Municipal de Indaiatuba: http://www.indaiatuba.sp.gov.br/fazenda/rendas-mobiliarias/listas/lista-de-servicos-issqn/       ³
//³                                                                                                                                      ³
//³ Antes do arquivo ser convertido em Notas Fiscais Eletronicas, verifique as seguintes regras:                                         ³
//³ 1) A data do Recibo Provisorio de Servicos - RPS nao pode ser menor do que a data de autorizacao para emissao de NFS-e requerida     ³
//³ junto a Prefeitura.                                                                                                                  ³
//³ 2) A substituicao do RPS pela NFS-e devera ser efetuada no prazo maximo de 5 (cinco) dias corridos apos a data de sua emissao.       ³
//³ 3) O campo "descriçao do serviço" pode conter ate 2000 caracteres; o sistema nao vai considerar tabulacoes. Quebras de linha devem   ³
//³ ser indicadas pela sequencia "\s\n".                                                                                                 ³
//³ 4) Caso o e-mail do tomador seja informado e valido, o sistema enviara automaticamente um e-mail informando o link para a visualiza  ³
//³ cao da Nota Fiscal emitida, tanto para o prestador como para o tomador do servico, se o e-mail do tomador nao for informado, o       ³
//³ prestador e o tomador não receberão o e-mail.                                                                                        ³
//³ 5) A linha do arquivo digital deve conter os campos na exata ordem em que estao listados no leiaute. Entre os campos deve ser        ³
//³ inserido o delimitador "|" (pipe). O caractere delimitador "|" nao deve ser incluido como parte integrante do conteudo de quaisquer  ³
//³ campos numericos ou alfanumericos. O caractere "|" nao deve ser usado como delimitador de inicio e de fim da linha. Todos os         ³
//³ caracteres de formatacao (mascaras) devem ser removidos.                                                                             ³
//³                                                                                                                                      ³
//³ Exemplo (campos da linha):                                                                                                           ³
//³ 11111111111111|2222222|3|20180319|201803|802|1500,00|0,00|1||3520509|3520509                                                         ³
//³                                                                                                                                      ³
//³ Na ausencia de informacao, o campo vazio (campo sem conteudo; nulo; null) devera ser iniciado com caractere "|" e imediatamente      ³
//³ encerrado com o mesmo caractere "|" delimitador de campo.                                                                            ³
//³ Exemplo (conteudo do campo):                                                                                                         ³
//³ . Campo alfanumerico: Eloa da Silva Ltda. -> |Eloa da Silva Ltda.|                                                                   ³
//³ . Campo numerico: 1234,56 -> |1234,56|                                                                                               ³
//³ Exemplo (campo vazio no meio da linha):                                                                                              ³
//³ . 123,00||1234567890                                                                                                                 ³
//³ 6) Regras de preenchimento dos campos com conteudo numerico nos quais ha indicacao de casas decimais:                                ³
//³  a) Deverao ser preenchidos sem os separadores de milhar, sinais ou quaisquer outros caracteres (tais como: ".", "-", "%"), devendo  ³
//³     a virgula ser utilizada como separador decimal;                                                                                  ³
//³  b) Nao ha limite de caracteres para os campos numericos;                                                                            ³
//³  c) Deve ser observada a quantidade de casas decimais que constar no respectivo registro;                                            ³
//³  d) Os valores percentuais devem ser preenchidos desprezando-se o simbolo (%), sem nenhuma convencao matematica.                     ³
//³ Exemplo (valores monetarios, quantidades, percentuais, etc.):                                                                        ³
//³ . $ 1.129.998,99 -> |1129998,99|                                                                                                     ³
//³ . 1.255,42 -> |1255,42|                                                                                                              ³
//³ . 234,567 -> |234,567|                                                                                                               ³
//³ . 10.000,00 -> |10000,00|                                                                                                            ³
//³ . 17,00 % -> |17,00|                                                                                                                 ³
//³ . 30 -> |30|                                                                                                                         ³
//³ . Campo vazio -> ||                                                                                                                  ³
//³ 7) Os arquivos serao validados pelo sistema DEISS antes de serem convertidos em Notas Fiscais, caso haja alguma inconsistencia,      ³
//³ o sistema vai informar a linha e o campo com problema, o arquivo so sera convertido em NFS-e se todos os campos de todos os          ³
//³ registros estiverem corretos.                                                                                                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Legenda do Leiaute de Importação de Dados para Emissão de NFS-e                    ³
//³ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ³
//³ Informacao              ³ Identificacao da Informacao                              ³
//³ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ³
//³ Tam       ³ Tamanho     ³ Quantidade maxima de caracteres ou precisao numerica,    ³
//³           ³             ³ dependendo do tipo de informacao                         ³
//³ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ³
//³ Tp        ³ Tipo        ³ C - Caracteres                                           ³
//³           ³             ³ D - Data                                                 ³
//³           ³             ³ N - Numerico                                             ³
//³ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ³
//³ Ob        ³ Obrigatorio ³ Obrigatoriedade de preenchimento                         ³
//³ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ³
//³ Descricao ³             ³ Breve descricao da informacao que devera conter o campo  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Leiaute de Importacao de Dados para Emissão de NFS-e                               ³
//³ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ³
//³ Campo ³ Descricao                                                  | Tam | Tp | Ob |
//³ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ³
//³ 1     | Numero da linha                                            | 002 | N  | S  |
//³ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ³
//³ 2     | CPF ou CNPJ do Prestador                                   | 014 | N  | S  |
//³ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ³
//³ 3     | CCM (Inscricao Municipal) do Prestador                     | 009 | C  | S  |
//³ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ³
//³ 4     | Numero do Recibo Provisorio (RPS), o numero deve ser unico | 009 | N  | S  |
//|       | para cada registro. Quanto ao cancelamento do RPS, a NFS-e |     |    |    |
//|       | gerada deve ser cancelada diretamente no sistema DEISS.    |     |    |    |
//|       | Quanto a substituicao de RPS, o numero do RPS substituido  |     |    |    |
//|       | deve ser mencionado no campo RPS substituido.              |     |    |    |
//³ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ³
//³ 5     | Data do RPS. Deve seguir o formato "aaaaMMdd" (anoMesDia). | 008 | D  | S  |
//|       | Exemplo: 20180319                                          |     |    |    |
//³ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ³
//³ 6     | Competencia da data do RPS. Deve seguir o formato "gaaaaMM"| 006 | D  | S  |
//|       | (anoMes). Exemplo: 201803                                  |     |    |    |
//³ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ³
//³ 7     | Codigo do servico prestado, conforme lista de servicos     | 004 | N  | S  |
//|       | sujeitos ao ISSQN. Exemplos: 1405, 702, 802.               |     |    |    |
//³ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ³
//³ 8     | Valor total do servico (no caso de nota conjugada,         | 14,2| N  | S  | 
//|       | informar apenas o valor do servico).                       |     |    |    |
//|       | Exemplos:                                                  |     |    |    |
//|       | R$ 3.124,80 -> 3124,80;                                    |     |    |    |
//|       | R$ 53,23 -> 53,23;                                         |     |    |    |
//|       | R$ 1,00 -> 1,00.                                           |     |    |    |
//³ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ³
//³ 9     | Valor total de deducoes (apenas para as atividades         | 14,2| N  | S  | 
//|       | previstas no Decreto Municipal N.o 13.185/2017).           |     |    |    |
//|       | Para as atividades 702 e 705, a empresa devera cumprir a   |     |    |    |
//|       | Instrucao Normativa 01/2013.                               |     |    |    |
//|       | Exemplos:                                                  |     |    |    |
//|       | R$ 12.000,00 -> 12000,00;                                  |     |    |    |
//|       | R$ 900,00 -> 900,00.                                       |     |    |    |
//|       | O valor desse campo nao pode ser negativo.                 |     |    |    |
//³ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ³
//³ 10    | Exigibilidade do ISS.                                      | 001 | N  | S  |
//|       | Opcoes:                                                    |     |    |    |
//|       | 1 -> Exigivel;                                             |     |    |    |
//|       | 2 -> Nao incidencia;                                       |     |    |    |
//|       | 3 -> Isencao;                                              |     |    |    |
//|       | 4 -> Exportacao;                                           |     |    |    |
//|       | 5 -> Imunidade;                                            |     |    |    |
//|       | 6 -> Exigibilidade Suspensa por Decisao Judicial;          |     |    |    |
//|       | 7 -> Exigibilidade Suspensa por Processo Administrativo.   |     |    |    |
//³ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ³
//³ 11    | Numero do processo judicial ou administrativo de suspensao | 030 | C  | N  |
//|       | da exigibilidade. Obrigatorio e informado somente quando   |     |    |    |
//|       | declarada a suspensao da exigibilidade do tributo.         |     |    |    |
//³ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ³
//³ 12    | Codigo do municipio onde e a incidencia do imposto,        | 007 | N  | S  |
//|       | conforme a Tabela do IBGE (Instituto Brasileiro de         |     |    |    |
//|       | Geografia e Estatistica).                                  |     |    |    |
//³ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ³
//³ 13    | Codigo do municipio onde foi realizado o servico, conforme | 007 | N  | S  |
//|       | a Tabela do IBGE. Se exterior, preencher com 9999999.      |     |    |    |
//³ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ³
//³ 14    | Codigo do pais onde foi realizado o servico, conforme a    | 004 | N  | N  |
//|       | Tabela do BACEN (Banco Central do Brasil). Preencher       |     |    |    |
//|       | somente se o codigo do municipio de realizacao do servico  |     |    |    |
//|       | for igual a 9999999.                                       |     |    |    |
//³ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ³
//³ 15    | Prestador optante pelo Simples Nacional.                   | 001 | N  | S  |
//|       | Opcoes:                                                    |     |    |    |
//|       | 1 -> Sim;                                                  |     |    |    |
//|       | 2 -> Nao.                                                  |     |    |    |
//³ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ³
//³ 16    | Incentivo Fiscal.                                          | 001 | N  | S  |
//|       | Opcoes:                                                    |     |    |    |
//|       | 1 -> Sim;                                                  |     |    |    |
//|       | 2 -> Nao.                                                  |     |    |    |
//³ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ³
//³ 17    |ISS retido.                                                 | 001 | N  | S  |
//|       | Opcoes:                                                    |     |    |    |
//|       | 1 -> Sim;                                                  |     |    |    |
//|       | 2 -> Nao.                                                  |     |    |    |
//³ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ³
//³ 18    | Regime Especial de Tributacao.                             | 001 | C  | N  |
//|       | Opcoes:                                                    |     |    |    |
//|       | 1 -> Microempresa Municipal;                               |     |    |    |
//|       | 2 -> Estimativa;                                           |     |    |    |
//|       | 3 -> Sociedade de Profissionais;                           |     |    |    |
//|       | 4 -> Cooperativa;                                          |     |    |    |
//|       | 5 -> Microempresario Individual (MEI);                     |     |    |    |
//|       | 6 -> Microempresario e Empresa de Pequeno Porte (ME EPP).  |     |    |    |
//|       | Preenchimento obrigatorio somente para contribuintes       |     |    |    |
//|       | optantes pelo Simples Nacional.                            |     |    |    |
//|       | Preencher somente se o campo 15 (Prestador optante pelo    |     |    |    |
//|       | Simples Nacional) for igual a 1 . Sim.                     |     |    |    |
//³ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ³
//³ 19    | INSS. Campo de responsabilidade do prestador; nao sera     | 14,2| N  | S  | 
//|       | calculado pelo sistema e nao pode ser negativo.            |     |    |    |
//³ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ³
//³ 20    | IR. Campo de responsabilidade do prestador; nao sera       | 14,2| N  | S  | 
//|       | calculado pelo sistema e nao pode ser negativo.            |     |    |    |
//³ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ³
//³ 21    | CSLL. Campo de responsabilidade do prestador; nao sera     | 14,2| N  | S  | 
//|       | calculado pelo sistema e nao pode ser negativo.            |     |    |    |
//³ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ³
//³ 22    | COFINS. Campo de responsabilidade do prestador; nao sera   | 14,2| N  | S  | 
//|       | calculado pelo sistema e nao pode ser negativo.            |     |    |    |
//³ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ³
//³ 23    | PIS. Campo de responsabilidade do prestador; nao sera      | 14,2| N  | S  | 
//|       | calculado pelo sistema e nao pode ser negativo.            |     |    |    |
//³ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ³
//³ 24    | ISS. Campo de responsabilidade do prestador; nao sera      | 14,2| N  | N  | 
//|       | calculado pelo sistema. Somente deve ser preenchido quando |     |    |    |
//|       | o campo ISS Retido for igual a "1 -> Sim".                 |     |    |    |
//³ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ³
//³ 25    | Outras retencoes. Campo de responsabilidade do prestador;  | 14,2| N  | S  | 
//|       | nao sera calculado pelo sistema e nao pode ser negativo.   |     |    |    |
//³ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ³
//³ 26    | Aliquota do servico prestado. Preenchimento obrigatorio    | 06,4| N  | S  |
//|       | quando o campo Municipio de Incidencia for diferente de    |     |    |    |
//|       | Indaiatuba e para prestadores enquadrados como Simples     |     |    |    |
//|       | Nacional ou Microempresario Individual.                    |     |    |    |
//³ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ³
//³ 27    | Numero do RPS substituido. Nos casos de substituicao de    | 008 | N  | N  |
//|       | notas fiscais, a nota fiscal substituida sera              |     |    |    |
//|       | automaticamente cancelada.                                 |     |    |    |
//³ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ³
//³ 28    | Texto continuo de descricao do servico. Nao exceda o       | 2000| C  | S  |
//|       | maximo de 2000 caracteres (sem quebra de linha) ou 20      |     |    |    |
//|       | quebras de linhas com no maximo 90 caracteres de largura   |     |    |    |
//|       | cada linha.                                                |     |    |    |
//³ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ³
//³ 29    | Texto de observacoes.                                      | 254 | C  | N  |
//³ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ³
//³ 30    | CPF ou CNPJ do Tomador. Utilizar 99999999999999 para       | 014 | N  | S  |
//|       | empresas no exterior e 99999999999 para identificar pessoa |     |    |    |
//|       | fisica no caso de regime especial de tributacao ou nota de |     |    |    |
//|       | consumidor.                                                |     |    |    |
//³ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ³
//³ 31    | CCM (Inscricao Municipal) do Tomador. So deve ser          | 009 | C  | N  |
//|       | preenchido para tomadores cadastrados no municipio de      |     |    |    |
//|       | Indaiatuba.                                                |     |    |    |
//³ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ³
//³ 32    | Nome ou Razao Social do Tomador; nome completo da empresa. | 100 | C  | S  |
//|       | Nomes com mais de 100 caracteres podem ser abreviados.     |     |    |    |
//|       | No caso de empresas no exterior, de regime especial de     |     |    |    |
//|       | tributacao ou nota de consumidor, o nome nao precisa ser   |     |    |    |
//|       | informado.                                                 |     |    |    |
//³ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ³
//³ 33    | Tipo de Logradouro (referente ao endereco do Tomador),     | 002 | C  | S  |
//|       | conforme o sistema DEISS:                                  |     |    |    |
//|       | Opcoes:                                                    |     |    |    |
//|       | A -> Area;                                                 |     |    |    |
//|       | AC -> Acesso;                                              |     |    |    |
//|       | AD -> Adro;                                                |     |    |    |
//|       | AE -> Area Especial;                                       |     |    |    |
//|       | AL -> Alameda;                                             |     |    |    |
//|       | AT -> Alto;                                                |     |    |    |
//|       | AV -> Avenida;                                             |     |    |    |
//|       | BC -> Beco;                                                |     |    |    |
//|       | BL -> Bloco;                                               |     |    |    |
//|       | BX -> Baixa;                                               |     |    |    |
//|       | C -> Cais;                                                 |     |    |    |
//|       | CA -> Caminho;                                             |     |    |    |
//|       | CH -> Chacara;                                             |     |    |    |
//|       | CJ -> Conjunto;                                            |     |    |    |
//|       | DT -> Distrito;                                            |     |    |    |
//|       | EQ -> Entre Quadra;                                        |     |    |    |
//|       | ET -> Estrada;                                             |     |    |    |
//|       | E -> Eixo;                                                 |     |    |    |
//|       | IA -> Ilha;                                                |     |    |    |
//|       | JD -> Jardim;                                              |     |    |    |
//|       | LD -> Ladeira;                                             |     |    |    |
//|       | LG -> Lago;                                                |     |    |    |
//|       | PC -> Praca;                                               |     |    |    |
//|       | PR -> Praia;                                               |     |    |    |
//|       | Q -> Quadra;                                               |     |    |    |
//|       | R -> Rua;                                                  |     |    |    |
//|       | RD -> Rodovia;                                             |     |    |    |
//|       | ST -> Setor;                                               |     |    |    |
//|       | TR -> Trecho;                                              |     |    |    |
//|       | TV -> Travessa;                                            |     |    |    |
//|       | VD -> Viaduto;                                             |     |    |    |
//|       | VI -> Via;                                                 |     |    |    |
//|       | VL -> Vila.                                                |     |    |    |
//|       | Para tomadores domiciliados no exterior, o Tipo de         |     |    |    |
//|       | Logradouro nao precisa ser informado, assim como no caso   |     |    |    |
//|       | de empresas no regime especial de tributacao e nota de     |     |    |    |
//|       | consumidor.                                                |     |    |    |
//³ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ³
//³ 34    | Logradouro (referente ao endereco do Tomador). Para        | 125 | C  | S  |
//|       | tomadores domiciliados no exterior, informe o endereco     |     |    |    |
//|       | integralmente nesse campo. No caso de empresas no regime   |     |    |    |
//|       | especial de tributacao ou nota de consumidor, o Logradouro |     |    |    |
//|       | nao precisa ser informado.                                 |     |    |    |
//³ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ³
//³ 35    | Numero (referente ao endereco do Tomador).                 | 006 | N  | N  |
//³ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ³
//³ 36    | Complemento (referente ao endereco do Tomador).            | 050 | C  | N  |
//³ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ³
//³ 37    | Tipo de Bairro (referente ao endereco do Tomador),         | 002 | C  | N  |
//|       | conforme o sistema DEISS:                                  |     |    |    |
//|       | Opcoes:                                                    |     |    |    |
//|       | BR -> Bairro;                                              |     |    |    |
//|       | CH -> Chacara;                                             |     |    |    |
//|       | CR -> Condominio Residencial;                              |     |    |    |
//|       | DI -> Distrito Industrial;                                 |     |    |    |
//|       | DM -> Desmembramento;                                      |     |    |    |
//|       | JD -> Jardim;                                              |     |    |    |
//|       | LT -> Loteamento;                                          |     |    |    |
//|       | NR -> Nucleo Residencial;                                  |     |    |    |
//|       | PQ -> Parque;                                              |     |    |    |
//|       | VL -> Vila.                                                |     |    |    |
//³ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ³
//³ 38    | Bairro (referente ao endereco do Tomador).                 | 050 | C  | N  |
//³ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ³
//³ 39    | Codigo do municipio do endereco do Tomador, conforme a     | 007 | N  | S  |
//|       | Tabela do IBGE. Se exterior, preencher com "9999999". No   |     |    |    |
//|       | caso de empresas no regime especial de tributacao ou nota  |     |    |    |
//|       | de consumidor, o municipio nao precisa ser informado.      |     |    |    |
//³ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ³
//³ 40    | UF (referente ao endereco do Tomador). Para tomadores      | 002 | C  | S  |
//|       | domiciliados no exterior, preencher a UF com "EX". No caso |     |    |    |
//|       | de empresas no regime especial de tributacao ou nota de    |     |    |    |
//|       | consumidor, a UF nao precisa ser informada.                |     |    |    |
//³ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ³
//³ 41    | Codigo do pais do endereco do Tomador, conforme a Tabela   | 004 | N  | N  |
//|       | do BACEN. Preencher somente se o codigo do municipio do    |     |    |    |
//|       | endereco do Tomador for igual a 9999999.                   |     |    |    |
//³ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ³
//³ 42    | CEP (referente ao endereco do Tomador).                    | 008 | N  | N  |
//³ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ³
//³ 43    | E-mail do Tomador.                                         | 060 | C  | N  |
//³ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ³
//³ 44    | Telefone do Tomador, sendo os dois primeiros digitos o DDD.| 020 | N  | N  |
//³ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ³
//³ 45    | CPF ou CNPJ do Intermediario.                              | 014 | C  | N  |
//³ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ³
//³ 46    | CCM (Inscricao Municipal) do Intermediario. So deve ser    | 009 | C  | N  |
//|       | preenchido para intermediarios cadastrados no municipio de |     |    |    |
//|       | Indaiatuba.                                                |     |    |    |
//³ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ³
//³ 47    | Razao Social do Intermediario; nome completo da empresa.   | 100 | C  | N  |
//|       | Nomes com mais de 100 caracteres podem ser abreviados.     |     |    |    |
//³ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ³
//³ 48    | Codigo do municipio de estabelecimento do Intermediario,   | 007 | N  | N  |
//|       | conforme a Tabela do IBGE.                                 |     |    |    |
//³ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ³
//³ 49    | Numero da matricula CEI da obra ou da empresa.             | 030 | C  | N  |
//³ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ³
//³ 50    | Numero da ART (Anotacao de Responsabilidade Tecnica).      | 030 | C  | N  |
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Definicoes e Includes                                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
#Include "Protheus.CH"

#Define _CRLF			Chr( 13 ) + Chr( 10 )
#Define _SEPARADOR	"|"
//#Define _MAXITENS		50

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³AMFATDEISS³ Autor ³ Celso Costa - TI9     ³ Data ³30.08.2018³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Gerar arquivo texto conforme lay-out definido pela prefei- ³±±
±±³          ³ tura de Indaiatuba para o programa DEISS, com a finalida-  ³±±
±±³          ³ de de gerar as notas fiscais.                              ³±±
±±³          ³ LAYOUT - Versao 2.0.0.7 - 03/07/2018                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function AMFATDEISS()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis Locais                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local _lOkParam		:= .F.
Local _aSays			:= {}
Local _aButtons		:= {}
Local _cCadastro		:= OemToansi( "Geracao de arquivo para Escrituracao DEISS - Municipio de Indaiatuba-SP" )
Local _cMens			:= OemToAnsi( "A opcao de Parametros desta rotina deve ser acessada antes de sua execucao!" )
Local _cPerg			:= Padr( "AMDEISS", 10 )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis Private                                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private _lMvDed	:= SuperGetMV( "MV_NFSEDED",,.T. )	// Habilita/Desabilita as Deducoes da NFSE
Private _aUF		:= {}
Private _MAXITENS	:= 50

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Preenchimento do Array de UF                                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aAdd( _aUF, { "  ", "00" } )
aAdd( _aUF, { "RO", "11" } )
aAdd( _aUF, { "AC", "12" } )
aAdd( _aUF, { "AM", "13" } )
aAdd( _aUF, { "RR", "14" } )
aAdd( _aUF, { "PA", "15" } )
aAdd( _aUF, { "AP", "16" } )
aAdd( _aUF, { "TO", "17" } )
aAdd( _aUF, { "MA", "21" } )
aAdd( _aUF, { "PI", "22" } )
aAdd( _aUF, { "CE", "23" } )
aAdd( _aUF, { "RN", "24" } )
aAdd( _aUF, { "PB", "25" } )
aAdd( _aUF, { "PE", "26" } )
aAdd( _aUF, { "AL", "27" } )
aAdd( _aUF, { "MG", "31" } )
aAdd( _aUF, { "ES", "32" } )
aAdd( _aUF, { "RJ", "33" } )
aAdd( _aUF, { "SP", "35" } )
aAdd( _aUF, { "PR", "41" } )
aAdd( _aUF, { "SC", "42" } )
aAdd( _aUF, { "RS", "43" } )
aAdd( _aUF, { "MS", "50" } )
aAdd( _aUF, { "MT", "51" } )
aAdd( _aUF, { "GO", "52" } )
aAdd( _aUF, { "DF", "53" } )
aAdd( _aUF, { "SE", "28" } )
aAdd( _aUF, { "BA", "29" } )
aAdd( _aUF, { "EX", "99" } )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Valida/cria Pergunte                                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
ValidPerg( _cPerg )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Interface                                                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aAdd( _aSays, OemToAnsi( "Este programa tem o objetivo de gerar o arquivo de Escrituracao DEISS"			) )
aAdd( _aSays, OemToAnsi( "para integracao ao municipio de Indaiatuba-SP."											) )
aAdd( _aSays, OemToAnsi( "O leiaute devera ser apresentado em dois arquivos no formato texto,"				) )
aAdd( _aSays, OemToAnsi( "com no maximo 50 (cinquenta) registros por arquivo. Um arquivo devera"			) )
aAdd( _aSays, OemToAnsi( "conter as informacoes sobre os servicos prestados, e o outro arquivo sobre"		) )
aAdd( _aSays, OemToAnsi( "os servicos tomados."																				) )
aAdd( _aSays, OemToAnsi( "As notas emitidas para pessoa juridica devem ser lancadas uma a uma."				) )

aAdd( _aButtons, { 05, .T., {|| fAcessaPar( _cPerg, @_lOkParam ) } } )
aAdd( _aButtons, { 01, .T., {|o| Iif( _lOkParam, ( Processa( {|lEnd| fProcDEISS()} ), o:oWnd:End() ), Aviso( OemToAnsi( "Atencao" ), _cMens, { "Ok" } ) ) } } )
aAdd( _aButtons, { 02, .T., {|o| o:oWnd:End()} } )

FormBatch( _cCadastro, _aSays, _aButtons,, 260, 430 )

Return ( Nil )

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³fProcDEISS³ Autor ³ Celso Costa - TI9     ³ Data ³30.08.2018³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Executa a geracao do arquivo Texto                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function fProcDEISS()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis Locais                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local _nLin			:= 00
Local _cMensagem	:= ""
Local _aLayOutImp	:= {}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define LayOut                                                ³
//³ Array,{Descricao,Tamanho,Decimais,Tipo,Obrigatorio,CodeBlock ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aAdd( _aLayOutImp, { "01", "Numero da linha"										, 0002, 00, "N", "S", "_nLin"																																										} )
aAdd( _aLayOutImp, { "02", "CPF ou CNPJ do Prestador"							, 0014, 00, "N", "S", "SM0->M0_CGC"																																								} )
aAdd( _aLayOutImp, { "03", "Inscricao Municipal do Prestador"				, 0009, 00, "C", "S", "SM0->M0_INSCM"																																							} )
aAdd( _aLayOutImp, { "04", "Numero do Recibo Provisorio (RPS)"				, 0009, 00, "N", "S", "F2_DOC"																																									} )
aAdd( _aLayOutImp, { "05", "Data do RPS no formato aaaaMMdd"				, 0008, 00, "D", "S", "F2_EMISSAO"																																								} )
aAdd( _aLayOutImp, { "06", "Competencia da data do RPS aaaaMM"				, 0006, 00, "D", "S", "StrTran( SubStr( DtoS( dDataBase ), 01, 07 ), '/', '' )"																									} )
aAdd( _aLayOutImp, { "07", "Codigo do servico prestado ISSQN"				, 0004, 00, "N", "S", "mv_par07"																																									} )
aAdd( _aLayOutImp, { "08", "Valor total do servico"							, 0014, 02, "N", "S", "F2_VALFAT"																																								} )
aAdd( _aLayOutImp, { "09", "Valor total de deducoes"							, 0014, 02, "N", "S", "Iif( _lMvDed, SF3->F3_ISSSUB + SF3->F3_ISSMAT + F2_DESCONT, 00 )"																						} )
aAdd( _aLayOutImp, { "10", "Exigibilidade do ISS."								, 0001, 00, "N", "S", "1"																																											} )
aAdd( _aLayOutImp, { "11", "Numero do processo judicial"						, 0030, 00, "C", "N", ""																																											} )
aAdd( _aLayOutImp, { "12", "Cod do mun. onde e a incidencia do imposto"	, 0007, 00, "N", "S", "SM0->M0_CODMUN"																																							} )
aAdd( _aLayOutImp, { "13", "Cod do mun. onde foi realizado o servico"	, 0007, 00, "N", "S", "SM0->M0_CODMUN"																																							} )
aAdd( _aLayOutImp, { "14", "Cod do pais onde foi realizado o servico"	, 0004, 00, "N", "N", "Iif(F2_EST=='EX',Iif( Empty( SA1->A1_PAIS ), '1058', Posicione('SYA',1,xFilial('SYA')+SA1->A1_PAIS,'YA_SISEXP')),'')"					} )
aAdd( _aLayOutImp, { "15", "Prestador optante pelo Simples Nacional"		, 0001, 00, "N", "S", "AllTrim( GetMV( 'MV_OPTSIMP',, '2' ) )"																															} )
aAdd( _aLayOutImp, { "16", "Incentivo Fiscal"									, 0001, 00, "N", "S", "'2'"																																										} )
aAdd( _aLayOutImp, { "17", "ISS retido"											, 0001, 00, "N", "S", "Iif( SF3->F3_RECISS $'1S', '1', '2' )"																															} )
aAdd( _aLayOutImp, { "18", "Regime Especial de Tributacao"					, 0001, 00, "C", "N", "AllTrim( SA1->A1_TPNFSE )"																																			} )
aAdd( _aLayOutImp, { "19", "INSS"													, 0014, 02, "N", "S", "F2_VALINSS"																																								} )
aAdd( _aLayOutImp, { "20", "IRRF"													, 0014, 02, "N", "S", "_nValIRRF"																																								} )
aAdd( _aLayOutImp, { "21", "CSLL"													, 0014, 02, "N", "S", "_nValCSLL"																																								} )
aAdd( _aLayOutImp, { "22", "COFINS"													, 0014, 02, "N", "S", "_nValCOFI"																																								} )
aAdd( _aLayOutImp, { "23", "PIS"														, 0014, 02, "N", "S", "_nValPIS"																																									} )
aAdd( _aLayOutImp, { "24", "ISS"														, 0014, 02, "N", "N", "F2_VALISS"																																								} )
aAdd( _aLayOutImp, { "25", "Outras retencoes"									, 0014, 02, "N", "S", "'0.00'"																																									} )
aAdd( _aLayOutImp, { "26", "Aliquota do servico prestado"					, 0006, 04, "N", "S", "Iif( aScan( _aRetCD2, { |x| x[ 01 ] == 'ISS' } ) > 00, _aRetCD2[ aScan( _aRetCD2, { |x| x[ 01 ] == 'ISS' } ) ][ 02 ], '0.00' )"	} )
aAdd( _aLayOutImp, { "27", "Numero do RPS substituido"						, 0008, 00, "N", "N", ""																																											} )
aAdd( _aLayOutImp, { "28", "Texto continuo de descricao do servico"		, 2000, 00, "C", "S", "_cDescrServ"																																								} )
aAdd( _aLayOutImp, { "29", "Texto de observacoes"								, 0254, 00, "C", "N", "F2_MENNOTA"																																								} )
aAdd( _aLayOutImp, { "30", "CPF ou CNPJ do Tomador"							, 0014, 00, "N", "S", "SA1->A1_CGC"																																								} )
aAdd( _aLayOutImp, { "31", "CCM (Inscricao Municipal) do Tomador"			, 0009, 00, "C", "N", "SA1->A1_INSCRM"																																							} )
aAdd( _aLayOutImp, { "32", "Nome ou Razao Social do Tomador"				, 0100, 00, "C", "S", "SA1->A1_NOME"																																							} )
aAdd( _aLayOutImp, { "33", "Tipo de Logradouro do Tomador"					, 0002, 00, "C", "S", "RetTipoLogr( AllTrim( SA1->A1_END ) )"																															} )
aAdd( _aLayOutImp, { "34", "Logradouro do Tomador"								, 0125, 00, "C", "S", "SA1->A1_END"																																								} )
aAdd( _aLayOutImp, { "35", "Numero do endereco do Tomador"					, 0006, 00, "N", "N", ""																																											} )
aAdd( _aLayOutImp, { "36", "Complemento do endereco do Tomador"			, 0050, 00, "C", "N", "SA1->A1_COMPLEM"																																						} )
aAdd( _aLayOutImp, { "37", "Tipo de Bairro do endereco do Tomador"		, 0002, 00, "C", "N", "'BR'"																																										} )
aAdd( _aLayOutImp, { "38", "Bairro do endereco do Tomador"					, 0050, 00, "C", "N", "SA1->A1_BAIRRO"																																							} )
aAdd( _aLayOutImp, { "39", "Cod do municipio do endereco do Tomador"		, 0007, 00, "N", "S", "_aUF[ aScan( _aUF, { |x| AllTrim( x[ 01 ] ) == AllTrim( SA1->A1_EST ) } ) ][ 02 ] + AllTrim( SA1->A1_COD_MUN )"							} )
aAdd( _aLayOutImp, { "40", "UF do Tomador"										, 0002, 00, "C", "S", "SA1->A1_EST"																																								} )
aAdd( _aLayOutImp, { "41", "Codigo do pais do endereco do Tomador"		, 0004, 00, "N", "N", "Iif(F2_EST=='EX',Iif( Empty( SA1->A1_PAIS ), '1058', Posicione( 'SYA', 01, xFilial( 'SYA' ) + SA1->A1_PAIS, 'YA_SISEXP' ) ),'')"	} )
aAdd( _aLayOutImp, { "42", "CEP do endereco do Tomador"						, 0008, 00, "N", "N", "SA1->A1_CEP"																																								} )
aAdd( _aLayOutImp, { "43", "E-mail do Tomador"									, 0060, 00, "C", "N", "SA1->A1_EMAIL"																																							} )
aAdd( _aLayOutImp, { "44", "Telefone do Tomador"								, 0020, 00, "N", "N", "SA1->A1_TEL"																																								} )
aAdd( _aLayOutImp, { "45", "CPF ou CNPJ do Intermediario"					, 0014, 00, "C", "N", ""																																											} )
aAdd( _aLayOutImp, { "46", "CCM (Inscricao Municipal) do Intermediario"	, 0009, 00, "C", "N", ""																																											} )
aAdd( _aLayOutImp, { "47", "Razao Social do Intermediario"					, 0100, 00, "C", "N", ""																																											} )
aAdd( _aLayOutImp, { "48", "Cod mun. de estabelec do Intermediario"		, 0007, 00, "N", "N", ""																																											} )
aAdd( _aLayOutImp, { "49", "Num da matricula CEI da obra ou da empresa"	, 0030, 00, "C", "N", ""																																											} )
aAdd( _aLayOutImp, { "50", "Numero da ART"										, 0030, 00, "C", "N", ""																																											} )

Processa( {|| fRunProc( _aLayOutImp, @_nLin ) }, "Processando..." )

If _nLin <= 00
	_cMensagem	:= "O arquivo " + AllTrim( mv_par09 ) + " nao foi gerado, nao foram encontrados registros para execucao do processamento."
Else
	_cMensagem	+= "Arquivo " + AllTrim( mv_par09 ) + " gerado com sucesso em " + AllTrim( mv_par08 ) + "." + _CRLF + _CRLF + AllTrim( StrZero( _nLin, 02 ) ) + " registro(s) processado(s)."
EndIf

Aviso( OemToAnsi( "Informacao" ), OemToAnsi( _cMensagem ), { "Ok" } )

Return ( Nil )

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³fRunProc  ³ Autor ³ Celso Costa - TI9     ³ Data ³11.10.2013³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Processamento                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function fRunProc( _aLayOutImp, _nLin )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis Locais                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local _nX			:= 00
Local _nHdl			:= 00
Local _cCpo			:= ""
Local _cLinha		:= ""
Local _cDir			:= ""
Local _cDescrServ	:= ""
Local _aRetCD2		:= {}
Local _cNomArq1	:= Iif( At( ".", mv_par09 ) > 00, AllTrim( SubStr( AllTrim( mv_par09 ), 01, At( ".", mv_par09 ) ) ) + "TXT", AllTrim( mv_par09 ) + ".TXT" )
Local _cAlias		:= GetNextAlias()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis Private                                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private _nValIRRF	:= 00
Private _nValPIS	:= 00
Private _nValCOFI	:= 00
Private _nValCSLL	:= 00

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Efetua contagem dos registros                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
BeginSQL Alias _cAlias
	Select Count( SF2.F2_DOC ) As TotRegs
	From
	%Table:SF2% SF2
	Where SF2.F2_EMISSAO BetWeen %Exp:DtoS( mv_par01 )% And %Exp:DtoS( mv_par02 )%
	And SF2.F2_DOC BetWeen %Exp:AllTrim( mv_par03 )% And %Exp:AllTrim( mv_par04 )%
	And SF2.F2_SERIE BetWeen %Exp:AllTrim( mv_par05 )% And %Exp:AllTrim( mv_par06 )%
	And SF2.F2_BASEISS > %Exp:00%
	And SF2.F2_TIPO = 'N'
	And SF2.F2_ESPECIE = 'RPS'
	And SF2.F2_FILIAL = %xFilial:SF2%
	And SF2.%NotDel%
EndSQL

_nCtRegs := ( _cAlias )->( TotRegs )

( _cAlias )->( dbCloseArea() )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Valida quantidade de itens permitida por arquivo             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If _nCtRegs > _MAXITENS
	Aviso( OemToAnsi( "Atencao" ), "Quantidade MAXIMA de registros permitida por arquivos excedida, sao permitidos " + StrZero( _MAXITENS, 02 ) + " registros por arquivo.", { "Ok" } )
	Return ( Nil )
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Seleciona registros                                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea( "SF3" )
SF3->( dbSetOrder( 04 ) )

dbSelectArea( "SA1" )
SA1->( dbSetorder( 01 ) )

BeginSQL Alias _cAlias
	Select *
	From
	%Table:SF2% SF2
	Where SF2.F2_EMISSAO BetWeen %Exp:DtoS( mv_par01 )% And %Exp:DtoS( mv_par02 )%
	And SF2.F2_DOC BetWeen %Exp:AllTrim( mv_par03 )% And %Exp:AllTrim( mv_par04 )%
	And SF2.F2_SERIE BetWeen %Exp:AllTrim( mv_par05 )% And %Exp:AllTrim( mv_par06 )%
	And SF2.F2_BASEISS > %Exp:00%
	And SF2.F2_TIPO = 'N'
	And SF2.F2_ESPECIE = 'RPS'
	And SF2.F2_FILIAL = %xFilial:SF2%
	And SF2.%NotDel%
	Order By SF2.F2_FILIAL, Sf2.F2_EMISSAO, SF2.F2_DOC, SF2.F2_SERIE
EndSQL
                      
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Criacao diretorio/arquivo texto                              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
_cBarra	:= Right( AllTrim( mv_par08 ), 01 )
_cDir		:= AllTrim( mv_par08 ) + Iif( _cBarra != "\", "\", "" )

If _nCtRegs > 00

	MontaDir( _cDir )

	_nHdl := fCreate( _cDir + _cNomArq1 )

	If _nHdl == -01
		MsgAlert( OemToAnsi( "Erro na criacao do arquivo " + AllTrim( _cNomArq1 ) + ". Verifique os parametros." ), OemToAnsi( "Atencao" ) )
		Return ( Nil )
	EndIf

EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Processamento                                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
ProcRegua( _nCtRegs )

While ( _cAlias )->( !Eof() )
	
	SA1->( dbSeek( xFilial( "SA1" ) + ( _cAlias )->F2_CLIENTE + ( _cAlias )->F2_LOJA ) )
	SF3->( dbSeek( xFilial( "SF3" ) + ( _cALias )->F2_CLIENTE + ( _cAlias )->F2_LOJA + ( _cAlias )->F2_DOC + ( _cAlias )->F2_SERIE ) )

	fRetDeducoes( _cAlias )
	
	_cDescrServ := fRetDServ()
	
	IncProc( OemToAnsi( "Montando arquivo, NFSe " + AllTrim( F2_DOC ) + "-" + AllTrim( F2_SERIE ) + " ..." ) )
	
	_nLin			+= 01
	_cLinha		:= ""

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Retorna impostos CD2                                         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	_aRetCD2	:= fRetCD2( ( _cAlias )->F2_DOC, ( _cAlias )->F2_SERIE, ( _cAlias )->F2_CLIENTE, ( _cAlias )->F2_LOJA )

	For _nX := 01 To Len( _aLayOutImp )
	
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Formata informacao                                           ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If Len( _aLayOutImp[ _nX ] ) >= 07

			_cCpo := &( _aLayOutImp[ _nX ][ 07 ] )
			_cCpo	:= Iif( _cCpo == Nil, "", _cCpo )
		
			Do Case
				Case AllTrim( _aLayOutImp[ _nX ][ 05 ] ) == "N"
					_cCpo	:= Iif( ValType( _cCpo ) == "N", AllTrim( Str( _cCpo ) ), _cCpo )
				Case AllTrim( _aLayOutImp[ _nX ][ 05 ] ) == "D"
					_cCpo	:= Iif( ValType( _cCpo ) == "D", StrTran( DtoS( _cCpo ), "/", "" ), StrTran( _cCpo, "/", "" ) )
			EndCase

		Else
			_cCpo	:= ""
		EndIf
				
		_cCpo := AllTrim( SubStr( _cCpo, 01, _aLayOutImp[ _nX ][ 03 ] ) )
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Atualiza linha do arquivo                                    ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		_cLinha += Iif( !Empty( _cLinha ), _SEPARADOR, "" ) + _cCpo
				
	Next _nX
	
//	_cLinha	:= SubStr( _cLinha, 01, Len( _cLinha ) - 01 ) + _CRLF
	_cLinha	+= _CRLF
	
	If fWrite( _nHdl, _cLinha, Len( _cLinha ) ) != Len( _cLinha )

		If !( Iw_MsgBox( OemToansi( "Ocorreu um erro na gravacao do arquivo. Continua?" ), OemToAnsi( "Atencao" ), "YESNO" ) )
			fClose( _nHdl )
			_lCont := .F.
		EndIf

	EndIf

	dbSelectArea( _cAlias )
	( _cAlias )->( dbSkip() )

EndDo

fClose( _nHdl )

( _cAlias )->( dbCloseArea() )

Return ( Nil )

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³fRetAliqISS³ Autor ³ Celso Costa - TI9    ³ Data ³06.09.2018³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Retorna aliquota ISSQN                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function fRetAliqISS()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis Locais                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local _aArea		:= GetArea()
Local _cISSQN		:= GetNextAlias()
Local _nAliqISSQN	:= 00

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Seleciona registros                                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
BeginSQL Alias _cISSQN
	Select
		Top 01 CD2.CD2_ALIQ As AliqISSQN
	From
		%Table:CD2% CD2
	Where CD2.CD2_DOC = %Exp:AllTrim( F2_DOC )%
		And CD2.CD2_SERIE = %Exp:AllTrim( F2_SERIE )%
		And CD2.CD2_CODCLI = %Exp:AllTrim( F2_CLIENTE )%
		And CD2.CD2_LOJCLI = %Exp:AllTrim( F2_LOJA )%
		And CD2.CD2_IMP = 'ISS'
		And CD2.CD2_FILIAL = %xFilial:SD2%
		And CD2.%NotDel%		
EndSQL

_nAliqISSQN := ( _cISSQN )->AliqISSQN

( _cISSQN )->( dbCloseArea() )

RestArea( _aArea )

Return ( _nAliqISSQN )

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³fRetValISSQN³ Autor ³ Celso Costa - TI9   ³ Data ³06.09.2018³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Retorna valor ISSQN                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function fRetValISSQN()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis Locais                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local _aArea		:= GetArea()
Local _cISSQN		:= GetNextAlias()
Local _nValISSQN	:= 00

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Seleciona registros                                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
BeginSQL Alias _cISSQN
	Select
		Top 01 CD2.CD2_VLTRIB As ValorISSQN
	From
		%Table:CD2% CD2
	Where CD2.CD2_DOC = %Exp:AllTrim( F2_DOC )%
		And CD2.CD2_SERIE = %Exp:AllTrim( F2_SERIE )%
		And CD2.CD2_CODCLI = %Exp:AllTrim( F2_CLIENTE )%
		And CD2.CD2_LOJCLI = %Exp:AllTrim( F2_LOJA )%
		And CD2.CD2_IMP = 'ISS'
		And CD2.CD2_FILIAL = %xFilial:SD2%
		And CD2.%NotDel%		
EndSQL

_nValISSQN := ( _cISSQN )->ValorISSQN

( _cISSQN )->( dbCloseArea() )

RestArea( _aArea )

Return ( _nValISSQN )

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³fRetDeducoes³ Autor ³ Celso Costa - TI9   ³ Data ³06.09.2018³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Retorna valor total das deducoes                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function fRetDeducoes( _cAlias )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis Locais                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local _aArea		:= GetArea()
Local _nDeducoes	:= 00

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Deducoes - somatoria dos valores dos impostos                |
//³ ISS/IRRF/INSS/PIS/COFINS/CSLL                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
_nValIRRF	:= 00
_nValPIS		:= 00
_nValCOFI	:= 00
_nValCSLL	:= 00

dbSelectArea( "SE1" )
SE1->( dbSetOrder( 02 ) )
SE1->( dbSeek( xFilial( "SE1" ) + ( _cAlias )->( F2_CLIENTE + F2_LOJA + F2_SERIE + F2_DOC ) ) )

While SE1->( !Eof() ) .And. SE1->E1_FILIAL == xFilial( "SE1" ) .And. SE1->( E1_CLIENTE + E1_LOJA + E1_PREFIXO + E1_NUM ) == ( _cAlias )->( F2_CLIENTE + F2_LOJA + F2_SERIE + F2_DOC )

	If AllTrim( SE1->E1_TIPO ) == "IR-"
		_nValIRRF += SE1->E1_VALOR
	ElseIf AllTrim( SE1->E1_TIPO ) == "PI-" 
		_nValPIS += SE1->E1_VALOR
	ElseIf AllTrim( SE1->E1_TIPO ) == "CF-" 
		_nValCOFI += SE1->E1_VALOR
	ElseIf AllTrim( SE1->E1_TIPO ) == "CS-" 
		_nValCSLL += SE1->E1_VALOR
	EndIf
	
	SE1->( dbSkip() )

EndDo
			
_nDeducoes	:= _nValIRRF + _nValPIS + _nValCOFI + _nValCSLL

RestArea( _aArea )

Return ( _nDeducoes )

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ fRetCD2    ³ Autor ³ Celso Costa - TI9   ³ Data ³04.10.2018³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Retorna informacoes CD2                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function fRetCD2( _cDoc, _cSerie, _cCliente, _cLoja )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis Locais                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local _aArea		:= GetArea()
Local _cAliasCD2	:= GetNextAlias()
Local _aRetCD2		:= {}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Seleciona registros CD2                                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
BeginSQL Alias _cAliasCD2
	Select
		CD2.CD2_IMP As Imposto,
		CD2.CD2_ALIQ As Aliquota,
		CD2.CD2_VLTRIB As VlrTrib
	From
		%Table:CD2% CD2
	Where CD2.CD2_DOC = %Exp:AllTrim( _cDoc )%
		And CD2.CD2_SERIE = %Exp:AllTrim( _cSerie )%
		And CD2.CD2_CODCLI = %Exp:AllTrim( _cCliente )%
		And CD2.CD2_LOJCLI = %Exp:AllTrim( _cLoja )%
		And CD2.CD2_FILIAL = %xFilial:CD2%
		And %NotDel%
EndSQL

While ( _cAliasCD2 )->( !Eof() )

	aAdd( _aRetCD2, { AllTrim( ( _cAliasCD2 )->Imposto ), ( _cAliasCD2 )->Aliquota, ( _cAliasCD2 )->VlrTrib } )

	( _cAliasCD2 )->( dbSkip() )

EndDo
	
( _cAliasCD2 )->( dbCloseArea() )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Restaura ponterios                                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
RestArea( _aArea )

If Len( _aRetCD2 ) <= 00
	aAdd( _aRetCD2, { "", 00, 00 } )
EndIf

Return ( _aRetCD2 )

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ RetTipoLogr³ Autor ³ Celso Costa - TI9   ³ Data ³04.10.2018³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Retorna os tipos de logradouro do prestador/tomador        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function RetTipoLogr( _cTexto )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis Locais                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local _nX			:= 00
Local _nAt			:= 00
Local _cTipoLogr	:= ""
Local _cAbrev		:= ""
Local _aMsg			:= {}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Tipos de logradouro definidos no layout                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aAdd( _aMsg, { "A"	, "Area"				} )
aAdd( _aMsg, { "AC"	, "Acesso"			} )
aAdd( _aMsg, { "AD"	, "Adro"				} )
aAdd( _aMsg, { "AE"	, "Area Especial"	} )
aAdd( _aMsg, { "AL"	, "Alameda"			} )
aAdd( _aMsg, { "AT"	, "Alto"				} )
aAdd( _aMsg, { "AV"	, "Avenida"			} )
aAdd( _aMsg, { "BC"	, "Beco"				} )
aAdd( _aMsg, { "BL"	, "Bloco"			} )
aAdd( _aMsg, { "BX"	, "Baixa"			} )
aAdd( _aMsg, { "C"	, "Cais"				} )
aAdd( _aMsg, { "CA"	, "Caminho"			} )
aAdd( _aMsg, { "CH"	, "Chacara"			} )
aAdd( _aMsg, { "CJ"	, "Conjunto"		} )
aAdd( _aMsg, { "DT"	, "Distrito"		} )
aAdd( _aMsg, { "EQ"	, "Entre Quadra"	} )
aAdd( _aMsg, { "ET"	, "Estrada"			} )
aAdd( _aMsg, { "E"	, "Eixo"				} )
aAdd( _aMsg, { "IA"	, "Ilha"				} )
aAdd( _aMsg, { "JD"	, "Jardim"			} )
aAdd( _aMsg, { "LD"	, "Ladeira"			} )
aAdd( _aMsg, { "LG"	, "Lago"				} )
aAdd( _aMsg, { "PC"	, "Praca"			} )
aAdd( _aMsg, { "PR"	, "Praia"			} )
aAdd( _aMsg, { "Q"	, "Quadra"			} )
aAdd( _aMsg, { "R"	, "Rua"				} )
aAdd( _aMsg, { "RD"	, "Rodovia"			} )
aAdd( _aMsg, { "ST"	, "Setor"			} )
aAdd( _aMsg, { "TR"	, "Trecho"			} )
aAdd( _aMsg, { "TV"	, "Travessa"		} )
aAdd( _aMsg, { "VD"	, "Viaduto"			} )
aAdd( _aMsg, { "VI"	, "Via"				} )
aAdd( _aMsg, { "VL"	, "Vila"				} )

_nAt		:= At( " ", Upper( _cTexto ) )
_cAbrev	:= SubStr( Upper( _cTexto ), 01, _nAt - 01 )
_nX		:= aScan( _aMsg, {|x| Upper( x[ 02 ] ) $ _cAbrev } )

If _nX == 00
	_cTipoLogr := "R"
Else
	_cTipoLogr := _aMsg[ _nX ][ 01 ]
EndIf

Return ( _cTipoLogr )

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³fAcessaPar³ Autor ³ Celso Costa - TI9     ³ Data ³30.08.2018³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Acessa/define o grupo de perguntas                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function fAcessaPar( _cPerg, _lOkParam )

_lOkParam := .T.

Return( Pergunte( _cPerg ) )

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³fRetDServ ³ Autor ³ Celso Costa - TI9     ³ Data ³30.08.2018³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Retorna String contendo Descricao dos servicos             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function fRetDServ()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis Locais                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local _aArea		:= GetArea()
Local _cAliasSrv	:= GetNextAlias()
Local _cDescrServ	:= ""

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Seleciona registros e formata string retorno                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
BeginSQL Alias _cAliasSrv
	Select
		SD2.D2_ITEM,
		SD2.D2_COD,
		SB1.B1_DESC
	From
		%Table:SD2% SD2,
		%Table:SB1% SB1
	Where SD2.D2_DOC = %Exp:AllTrim( F2_DOC )%
		And SD2.D2_SERIE = %Exp:AllTrim( F2_SERIE )%
		And SD2.D2_CLIENTE = %Exp:AllTrim( F2_CLIENTE )%
		And SD2.D2_LOJA = %Exp:AllTrim( F2_LOJA )%
		And SD2.D2_FILIAL = %xFilial:SD2%
		And SD2.%NotDel%
		And SB1.B1_COD = SD2.D2_COD
		And SB1.B1_FILIAL = %xFilial:SB1%
		And SB1.%NotDel%
EndSQL

While ( _cAliasSrv )->( !Eof() )

	_cDescrServ	+= Iif( Empty( _cDescrServ ), "", " / " ) + "IT:" + AllTrim( ( _cAliasSrv )->D2_ITEM ) + "- COD:" + AllTrim( ( _cAliasSrv )->D2_COD ) + "- DESCR:" + AllTrim( ( _cAliasSrv )->B1_DESC )

	( _cAliasSrv )->( dbSkip() )
	
EndDo

_cDescrServ := Iif( Empty( _cDescrServ ), "SEM DESCRICAO", _cDescrServ )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Restaura ponterios                                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
( _cAliasSrv )->( dbCloseArea() )

RestArea( _aArea )

Return ( _cDescrServ )

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ValidPerg ³ Autor ³ Celso Costa - TI9     ³ Data ³30.08.2018³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Valida/Cria Pergunte                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ValidPerg( _cPerg )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis Locais                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local	_aArea		:= GetArea()
Local i				:= 00
Local j				:= 00
Local _aRegs		:= {}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Organiza grupo de perguntas                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aAdd( _aRegs, { _cPerg, "01", "Data de"			,"" ,"" ,"mv_ch1", "D", 08, 0, 0, "G", "", "mv_par01", 	"", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""		})
aAdd( _aRegs, { _cPerg, "02", "Data ate"			,"" ,"" ,"mv_ch2", "D", 08, 0, 0, "G", "", "mv_par02", 	"", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""		})
aAdd( _aRegs, { _cPerg, "03", "Nota Fiscal de"	,"" ,"" ,"mv_ch3", "C", 09, 0, 0, "G", "", "mv_par03", 	"", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "SF2"	})
aAdd( _aRegs, { _cPerg, "04", "Nota Fiscal ate"	,"" ,"" ,"mv_ch4", "C", 09, 0, 0, "G", "", "mv_par04", 	"", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "SF2"	})
aAdd( _aRegs, { _cPerg, "05", "Serie de"			,"" ,"" ,"mv_ch5", "C", 03, 0, 0, "G", "", "mv_par05", 	"", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""		})
aAdd( _aRegs, { _cPerg, "06", "Serie ate"			,"" ,"" ,"mv_ch6", "C", 03, 0, 0, "G", "", "mv_par06", 	"", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""		})
aAdd( _aRegs, { _cPerg, "07", "Cod. do Servico"	,"" ,"" ,"mv_ch7", "C", 04, 0, 0, "G", "", "mv_par07", 	"", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""		})
aAdd( _aRegs, { _cPerg, "08", "Diretorio"			,"" ,"" ,"mv_ch8", "C", 30, 0, 0, "G", "", "mv_par08", 	"", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""		})
aAdd( _aRegs, { _cPerg, "09", "Arquivo"			,"" ,"" ,"mv_ch9", "C", 20, 0, 0, "G", "", "mv_par09", 	"", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""		})

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Valida/Cria perguntes                                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea( "SX1" )
Sx1->( dbSetOrder( 01 ) )

_cPerg := PadR( _cPerg, Len( SX1->X1_GRUPO ) )

For i := 01 To Len( _aRegs )

	If !dbSeek( _cPerg + _aRegs[ i ][ 02 ] )

		RecLock( "SX1", .T. )
		For j := 01 To FCount()
			If j <= Len( _aRegs[ i ] )
				FieldPut( j, _aRegs[ i ][ j ] )
			Endif
		Next
		SX1->( MsUnlock() )

	EndIf

Next i

RestArea( _aArea )

Return ( Nil )
