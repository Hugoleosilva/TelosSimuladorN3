### BANCO DE DADOS

### SGBD

#### O que é um SGBD?

É um software responsável por criar, gerenciar e manipular bancos de dados. Ele permite que usuários e aplicações armazenem, consultem, atualizem e controlem informações de forma segura e organizada.

#### O que o SGBD faz?

- Cria e organiza tabelas e estruturas de dados.
- Permite consultas (como o SQL).
- Controla acesso de usuários.
- Garante segurança, integridade e consistência dos dados.
- Faz backups e recuperações.
- Gerencia transações (ACID).

#### Exemplos de SGBDs

- MySQL
- PostgreSQL
- Oracle Database
- SQL Server
- SQLite
- MariaDB
- MongoDB (NoSQL)

#### Em resumo

Um SGBD é o programa que controla o banco de dados, garantindo que ele funcione corretamente, com segurança e eficiência.

#### O que é SQL

SQL (Structured Query Language) é uma linguagem para gerenciar e consultar bancos de dados relacionais (RDBMS).
Esses bancos utilizam tabelas com linhas e colunas, e as relações entre elas são definidas por chaves.

#### Características de bancos SQL:

- Estrutura rígida (schema fixo)
- Dados altamente estruturados
- Uso de tabelas relacionadas
- Suporte forte a transações ACID
- Ideal para aplicações que exigem alta integridade dos dados

#### Exemplos de softwares SQL (RDBMS):

- MySQL
- PostgreSQL
- MariaDB
- SQL Server
- Oracle Database
- SQLite

O que é NoSQL

NoSQL (Not Only SQL) é uma categoria de bancos projetados para lidar com grandes volumes de dados, dados sem estrutura fixa ou com necessidade de alta escalabilidade horizontal.

#### Características de bancos NoSQL:

- Estrutura flexível (schema-less)
- Escalabilidade horizontal facilitada (clusters)
- Desempenho otimizado para grandes volumes

#### Podem ser orientados a:

- Documentos (JSON-like)
- Chave–valor
- Grafos

Colunas largas

#### Exemplos de softwares NoSQL:

- MongoDB (documento)
- Cassandra (colunas largas)
- Redis (chave–valor)
- CouchDB (documento)
- Neo4j (grafo)
- DynamoDB (chave–valor/documento)

### Principais comandos SQL

#### (SQL é uma linguagem, então há comandos padronizados)

DDL – Definição de Dados

- CREATE -> Cria tabelas, bancos
- DROP	 -> Apaga objetos
- ALTER	 -> Altera estrutura das tabelas

DML – Manipulação de Dados

- INSERT ->	Insere dados
- UPDATE ->	Atualiza dados
- DELETE ->	Remove dados

DQL – Consulta de Dados

- SELECT ->	Consulta dados

DCL – Controle de Acesso

- GRANT	 -> Concede permissões
- REVOKE ->	Remove permissões

TCL – Controle de Transações

- COMMIT ->	Salva transações
- ROLLBACK -> Desfaz transações

### Principais "comandos" ou operações em NoSQL

#### (NoSQL não usa SQL tradicional, mas possui operações típicas)

### MongoDB (documentos)

- insertOne() -> Insere um único documento em uma coleção. Adiciona um novo registro (documento JSON).

 db.usuarios.insertOne({ nome: "Ana", idade: 30 })


- find() -> Busca documentos dentro de uma coleção. Retorna todos os documentos que atendem ao filtro (ou todos, se vazio).

 db.usuarios.find({ idade: 30 })

- updateOne() -> Atualiza um único documento que corresponde ao filtro. Modifica somente o primeiro documento encontrado.

 db.usuarios.updateOne(
  { nome: "Ana" },
  { $set: { idade: 31 } }
 )

- deleteOne() -> Apaga um único documento que corresponde ao filtro. Remove apenas um registro.

 db.usuarios.deleteOne({ nome: "Ana" })

### Redis (chave–valor)

- SET -> Armazena um valor associado a uma chave. Cria ou substitui o valor da chave.

 SET nome "Ana"

- GET -> Obtém o valor de uma chave. Retorna "Ana".

 GET nome

- DEL -> Remove uma ou mais chaves. Deleta a chave e seu valor associado.

 DEL nome

### Cassandra (CQL – Cassandra Query Language, similar ao SQL)

- INSERT INTO -> Insere um novo registro em uma tabela. Cria uma linha nova (e pode sobrescrever dependendo da chave primária).

 INSERT INTO usuarios (id, nome, idade)
 VALUES (1, 'Ana', 30); 

- SELECT -> Consulta dados de uma tabela. Recupera dados baseados em filtros (restrições de chave obrigatórias).

 SELECT nome, idade FROM usuarios WHERE id = 1;

- UPDATE -> Atualiza colunas de um registro existente. Atualiza valores em uma linha, identificada pela chave primária.

 UPDATE usuarios 
 SET idade = 31 
 WHERE id = 1;

- DELETE -> Remove colunas ou um registro inteiro. Apaga dados, respeitando restrições de chave.

 DELETE FROM usuarios WHERE id = 1;

*Obs.: Cada NoSQL tem sua própria linguagem.*

### O que é ACID

#### ACID é um conjunto de propriedades que garantem confiabilidade em transações de banco de dados.

A — Atomicity (Atomicidade) A transação acontece toda ou nada.
- Exemplo: transferência bancária — ou os dois saldos são atualizados, ou nenhum é.

C — Consistency (Consistência)
- O banco deve sempre estar em um estado válido, respeitando regras (constraints, tipos, chaves).

I — Isolation (Isolamento)
- Transações simultâneas não devem interferir uma na outra de forma incorreta.

D — Durability (Durabilidade)
- Depois de confirmada, a transação não se perde, mesmo após queda de energia ou falha.

#### Importância do ACID

- Garante integridade e segurança dos dados
- Evita perdas e inconsistências
- Crucial para sistemas financeiros, e-commerce, estoques etc.
- Facilita desenvolvimento ao garantir previsibilidade

*SQL normalmente é totalmente ACID, NoSQL pode ser parcialmente ACID ou focado em BASE (mais flexível e distribuído).*

### MODELAGEM DE DADOS

#### O que é Modelagem de Dados?

Modelagem de dados é o processo de organizar, estruturar e representar os dados de uma organização ou sistema. Ela define como os dados serão armazenados, relacionados e acessados, servindo como base para a criação de bancos de dados eficientes e confiáveis. É como um mapa que nos ajuda a entender como os dados estão interligados e como eles podem ser usados.

### Objetivos da Modelagem de Dados
- Garantir clareza sobre as informações do sistema.
- Reduzir redundâncias e evitar inconsistências.
- Facilitar a compreensão por analistas, desenvolvedores e usuários.
- Apoiar a criação de bancos de dados estruturados e bem planejados.
- Melhorar a qualidade e integridade dos dados.

### Níveis da Modelagem

#### 1. Modelo Conceitual
- Visão geral do sistema (o “que” será armazenado).
- Representa entidades e relacionamentos.
- Não tem detalhes técnicos.
- Ferramenta mais comum: Diagrama Entidade-Relacionamento (DER).

#### 2. Modelo Lógico
- Detalha atributos, chaves e tipos de relacionamento.
- Independente de tecnologia, mas mais técnico.
- Usa normalização.

#### 3. Modelo Físico
- Descreve como será implementado no banco de dados escolhido.
- Inclui tipos de dados, índices, restrições, tabelas e performance.

### Principais Elementos
- Entidades: Objetos do mundo real (Cliente, Pedido).
- Atributos: Informações sobre as entidades (nome, preço).
- Relacionamentos: Como as entidades se conectam (1:N, N:N).

#### Chaves:
- Primária (identifica um registro).
- Estrangeira (liga tabelas).

### Benefícios
- Melhor compreensão do sistema.
- Base sólida para desenvolvimento.
- Banco de dados mais eficiente e seguro.
- Facilita manutenção e evolução do sistema.

### RELACIONAMENTOS

#### O que são Relacionamentos em Banco de Dados?

Relacionamentos são ligações entre tabelas que mostram como os dados estão conectados.
Eles permitem organizar as informações de forma estruturada, evitando redundâncias e mantendo a integridade dos dados.
Essas ligações são feitas principalmente usando chaves primárias (PK) e chaves estrangeiras (FK).

#### Tipos de Relacionamentos
1. Relacionamento 1 para 1 (1:1)

Uma linha de uma tabela está relacionada a no máximo uma linha de outra tabela.

#### Exemplo:
- Uma pessoa → um RG
- Tabela PESSOA (PK: id_pessoa)
- Tabela RG (PK/FK: id_pessoa)

*Usado quando há informações específicas que não precisam ficar na mesma tabela.*

2. Relacionamento 1 para Muitos (1:N)

Uma linha da tabela A pode se relacionar com várias linhas da tabela B, mas cada linha de B se relaciona com uma só linha de A.

#### Exemplo:
- Um cliente → vários pedidos
- Tabela CLIENTE (PK: id_cliente)
- Tabela PEDIDO (FK: id_cliente)

*Este é o tipo de relacionamento mais comum.*

3. Relacionamento Muitos para Muitos (N:N)

Uma linha da tabela A pode se relacionar com várias da tabela B e vice-versa.

#### Exemplo:

- Alunos ↔ Disciplinas
- Um aluno pode cursar várias disciplinas, e cada disciplina pode ter vários alunos.

Como é implementado?
Criando uma tabela intermediária, chamada Tabela Associativa:

 ALUNO
 DISCIPLINA
 ALUNO_DISCIPLINA (com PK formada por: id_aluno + id_disciplina)

#### Chaves e Integridade

- Chave Primária (PK): identifica unicamente um registro.
- Chave Estrangeira (FK): cria a ligação entre tabelas.
- Integridade Referencial: garante que não existam relações inválidas (ex: pedido sem cliente cadastrado).

#### Por que os relacionamentos são importantes?

- Reduzem redundância (não repetir dados).
- Garantem consistência.
- Facilitam consultas complexas.
- Mantêm a integridade da informação.

