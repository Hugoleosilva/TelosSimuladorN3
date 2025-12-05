### BANCO DE DADOS

#### O que é SQL

SQL (Structured Query Language) é uma linguagem para gerenciar e consultar bancos de dados relacionais (RDBMS).
Esses bancos utilizam tabelas com linhas e colunas, e as relações entre elas são definidas por chaves.

#### ✔ Características de bancos SQL:

- Estrutura rígida (schema fixo)
- Dados altamente estruturados
- Uso de tabelas relacionadas
- Suporte forte a transações ACID
- Ideal para aplicações que exigem alta integridade dos dados

#### ✔ Exemplos de softwares SQL (RDBMS):

- MySQL
- PostgreSQL
- MariaDB
- SQL Server
- Oracle Database
- SQLite

O que é NoSQL

NoSQL (Not Only SQL) é uma categoria de bancos projetados para lidar com grandes volumes de dados, dados sem estrutura fixa ou com necessidade de alta escalabilidade horizontal.

✔ Características de bancos NoSQL:

- Estrutura flexível (schema-less)
- Escalabilidade horizontal facilitada (clusters)
- Desempenho otimizado para grandes volumes

#### Podem ser orientados a:

- Documentos (JSON-like)
- Chave–valor
- Grafos

Colunas largas

#### ✔ Exemplos de softwares NoSQL:

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

SQL normalmente é totalmente ACID, NoSQL pode ser parcialmente ACID ou focado em BASE (mais flexível e distribuído).