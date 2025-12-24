--BANCO DE DADOS

CREATE DATABASE Telos_Exercicios --criando Banco de Dados

USE DATABASE Telos_Exercicios --Ativa para uso o Banco de Dados

ALTER DATABASE Telos_Exercicios 
MODIFY NAME = Telos_Exercicios2 --Alterando nome Database

SELECT * FROM sys.databases --Listar todos os Databases (* traz tudo, se quiser específico, tem que colocar a coluna)

DROP DATABASE Telos_Exercicios --deletar o Database (Remove estruturas)

CREATE TABLE Teste (
ID INT PRIMARY KEY IDENTITY(1.1),
NOME VARCHAR(100),
IDADE INT,
CIDADE VARCHAR(50)
DataCadastro DATETIME2(3) DEFAULT SYSDATETIME() 
) --criando tabela

--OBS.: DATETIME2(3) = 3 casas decimais nos segundos (milissegundos) - SYSDATETIME() = função que retorna data/hora atual com alta precisão
           
INSERT INTO Teste (Nome, Idade, Cidade) 
VALUES ('Hugo Leonardo', 43, 'Recife') --Inserindo dados na tabela escolhida e suas respectivas colunas

UPDATE Teste 
SET Idade = 40 
WHERE Nome = 'Hugo Leonardo' --Atualizar dados existentes na tabela (Importante utilizar o WHERE para não atualizar a tabela toda!)

ALTER TABLE Teste 
ADD E-mail VARCHAR(100) --Adicionando coluna nova de e-mail

SELECT * FROM Teste WHERE Idade >= 40 --(where é condição)

SELECT * FROM Teste WHERE Idade >= 40 AND Cidade = 'Recife'; --(where + and variante da condição)

SELECT * FROM Teste WHERE Idade >= 40 OR Cidade = 'Recife'; --(where + or variante da condição)

SELECT * FROM Teste WHERE Idade >= 40 ORDER BY Idade --(ordenação por idade da condição >=40 USANDO O ORDER BY)

SELECT * FROM Teste WHERE Idade DESC >= 40 ORDER BY Idade --(ordenação DECRESCENTE por idade da condição >=40 USANDO O DESC)

SELECT TOP 2 * FROM Teste WHERE Idade >= 40 ORDER BY Idade DESC --(ordenação DECRESCENTE por idade da condição >=40 LIMITANDO A CONSULTA USANDO O TOP)

CREATE TABLE products (
id INT PRIMARY KEY IDENTITY(1,1), --PK não permite criar o mesmo ID, IDENTITY (1,1), incrementa automaticamente
name NVARCHAR(50),
price DECIMAL(10, 2)
)

INSERT INTO products (id, name, price) 
VALUES (1, 'Celular', 3000.00),
       (2, 'Teclado', 100.00);

INSERT INTO products (name, price) --Insere autoincrementando o ID... 1,2,3,4...
VALUES ('Celular', 3000.00),
       ('Teclado', 100.00);

INSERT INTO products (name) --Dessa forma vai inserir com o valor null
VALUES ('Celular')      

INSERT INTO products (name) --Criar campo default para não ocorrer isso
VALUES ('Celular') 

CREATE TABLE products (
id INT PRIMARY KEY IDENTITY(1,1), --Criando o valor DEFAULT
name NVARCHAR(50),
price DECIMAL(10, 2) DEFAULT 0.000
)

INSERT INTO products (price) --Dessa forma o name agora fica NULL
VALUES ('10.00')   

CREATE TABLE products (
id INT PRIMARY KEY IDENTITY(1,1), --Criando o NOT NULL
name NVARCHAR(50) NOT NULL,
price DECIMAL(10, 2) DEFAULT 0.000
)

INSERT INTO products (price) --Dessa forma o name passa a ser obrigatório
VALUES ('10.00')

CREATE TABLE products (
id INT PRIMARY KEY IDENTITY(1,1), 
name NVARCHAR(50) NOT NULL UNIQUE, --UNIQUE não permite duplicar as chaves no exemplo ele não permitiu adicionar 2 celulares e 2 teclados
price DECIMAL(10, 2) DEFAULT 0.000
)

USE Telos_Exercicios --Criando tabela de vendas

CREATE TABLE client ( --cliente
id INT PRIMARY KEY IDENTITY(1,1), 
name VARCHAR (100) NOT NULL,
city VARCHAR (100),
age INT,
email VARCHAR (100)
)

CREATE TABLE product ( --produto
id INT PRIMARY KEY IDENTITY(1,1), 
name VARCHAR (100) NOT NULL,
price DECIMAL(10,2) NOT NULL
)

CREATE TABLE [order] ( --venda
id INT PRIMARY KEY IDENTITY(1,1),
client_id INT NOT NULL, --criando id do cliente na tabela de venda FK
date DATETIME NOT NULL,
total DECIMAL (10,2) NOT NULL
FOREIGN KEY (client_id) REFERENCES client(id)
)

CREATE TABLE order_product (
id INT PRIMARY KEY IDENTITY(1,1),
order_id INT NOT NULL, --criando id da venda na tabela de venda produto FK
product_id INT NOT NULL, --criando id do produto na tabela de venda produto FK
quantity INT NOT NULL,
FOREIGN KEY (order_id) REFERENCES [order](id),
FOREIGN KEY (product_id) REFERENCES product(id)
)

--EXERCÍCIOS JOIN

INSERT INTO client (name, city, email) VALUES
('Alice', 'New York', 'alice@example.com'),
('Bob', 'Los Angeles', 'bob@example.com'),
('Charlie', 'Chicago', 'charlie@example.com'),
('David', 'New York', 'david@example.com');

INSERT INTO product (name, price) VALUES
('Laptop', 1000.00),
('Smartphone', 500.00),
('Tablet', 300.00);

INSERT INTO [order] (client_id, date, total) VALUES
(1, '2024-07-01', 150.00),
(2, '2024-07-02', 200.00),
(1, '2024-07-03', 100.00),
(3, '2024-07-04', 250.00);

INSERT INTO order_product (order_id, product_id, quantity) VALUES
(1, 1, 1),
(1, 2, 2),
(2, 3, 1),
(3, 1, 1),
(4, 2, 3);

SELECT * FROM client
INNER JOIN [order] 

--inner join
SELECT * FROM client
INNER JOIN [order] ON client.id = [order].client_id

SELECT c.id as client_id, c.name, o.id as order_id, o.total FROM client as c
INNER JOIN [order] as o ON c.id = o.client_id 
--nesse caso utilizou as iniciais didaticamente para mostrar que 
--em caso de nomes de tabelas grande dá para substituir por outro nome ou letra

--left join (trazendo dados de clientes e pedidos, incluindo clientes sem pedidos)
SELECT c.id as client_id, c.name, o.id as order_id, o.total FROM client as c
LEFT JOIN [order] as o ON c.id = o.client_id

--right join (trazendo todos os produtos e pedidos associados, incluindo produtos sem pedidos)
SELECT p.id as product_id, p.name, p.price, o.id as pedido_id, o.total 
FROM product as p
RIGHT JOIN order_product as op ON p.id = op.product_id
RIGHT JOIN [order] as o ON o.id = op.order_id

--full join (obtendo todas as combinações de clientes e pedidos, 
--inclusive pedidos sem clientes e clientes sem pedidos)
SELECT c.id as client_id, c.name, o.id as order_id, o.total
FROM client c
FULL JOIN [order] o ON c.id = o.client_id 

--Procedure para buscar o id da tabela client
CREATE PROCEDURE get_client_details
@client_id INT
AS
BEGIN
        SELECT * FROM client WHERE id = @client_id
END

EXEC get_client_details @client_id = 1 
--EXEC, nesse caso solicitando o cliente id 1 da tabela 

--Procedure mais complexa
CREATE PROCEDURE get_order_details
@order_id INT,
@client_id INT
AS
BEGIN
        SELECT * FROM [order] 
        WHERE id = @order_id AND client_id = @client_id
END

EXEC get_order_details @order_id = 1, @client_id = 1
--EXEC, nesse caso solicitando o cliente id 1 e o pedido 1 da tabela 


--Procedure modificando dados
CREATE PROCEDURE add_new_order
@client_id INT,
@order_date DATE,
@total DECIMAL(10, 2)
AS
BEGIN
        INSERT INTO [order] (client_id, date, total)
        VALUES (@client_id, @order_date, @total)
END

EXEC add_new_order @client_id = 1, @order_date = '2025-07-07', @total = 100.00

SELECT * FROM [order]--consulta
--adicionou as informações na tabela de pedidos


--Criando uma função
CREATE FUNCTION get_client_name --declaração inicial: nome da declaração
(@client_id INT) --parâmetro de entrada
RETURNS VARCHAR(100) --tipo de retorno esperado: texto
AS
BEGIN--lógica de negócio: begin/end
    DECLARE @client_name VARCHAR(100); --
    SELECT @client_name = name FROM client WHERE id = @client_id; --
    RETURN @client_name --
END

SELECT dbo.get_client_name(1)--retorna o nome esperado para o id client


--valued function 
CREATE FUNCTION get_order_by_client --declaração inicial: nome da declaração
(@client_id INT) --parâmetro de entrada
RETURNS TABLE--tipo de retorno esperado: uma tabela
AS
RETURN
(
   SELECT * FROM [order] WHERE client_id = @client_id
)

END

SELECT * FROM dbo.get_order_by_client(1)--consulta table valued function 
--(nesse exemplo, retorna todos os pedidos de um cliente)