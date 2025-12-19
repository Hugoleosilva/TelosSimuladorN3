BANCO DE DADOS

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
