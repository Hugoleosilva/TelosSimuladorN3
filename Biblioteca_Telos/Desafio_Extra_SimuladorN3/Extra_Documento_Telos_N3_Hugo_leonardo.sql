CREATE DATABASE Biblioteca_Telos_Analytics;
GO

USE Biblioteca_Telos_Analytics;
GO

--Tabela User_Profile
CREATE TABLE User_Profile (
    profile_id INT IDENTITY PRIMARY KEY,
    user_id INT NOT NULL,
    user_category VARCHAR(20) CHECK (user_category IN ('Regular', 'Premium', 'Restrito')),
    created_at DATETIME DEFAULT GETDATE()
);

--Tabela Loan_History
CREATE TABLE Loan_History (
    history_id INT IDENTITY PRIMARY KEY,
    loan_id INT NOT NULL,
    loan_duration_days INT,
    was_late BIT,
    registered_at DATETIME DEFAULT GETDATE()
);

--Tabela Penalties
CREATE TABLE Penalties (
    penalty_id INT IDENTITY PRIMARY KEY,
    user_id INT NOT NULL,
    loan_id INT NOT NULL,
    penalty_amount DECIMAL(10,2),
    penalty_reason VARCHAR(255),
    generated_at DATETIME DEFAULT GETDATE(),
    paid_at DATETIME NULL
);

--Tabela Access_Stats
CREATE TABLE Access_Stats (
    stat_id INT IDENTITY PRIMARY KEY,
    book_id INT NOT NULL,
    year_month CHAR(7),
    total_loans INT
);

--Inserindo dados de testes
INSERT INTO Biblioteca_Telos_Analytics.dbo.User_Profile (user_id, user_category)
SELECT user_id,
       CASE 
           WHEN user_id IN (1,2) THEN 'Premium'
           ELSE 'Regular'
       END
FROM Biblioteca_Telos.dbo.Users;

--Testando categorias de usuários
SELECT * FROM User_Profile;

--Trigger de histórico (ficará na tabela principal)
USE Biblioteca_Telos;
GO

CREATE OR ALTER TRIGGER trg_LoanHistory
ON Loans
AFTER UPDATE
AS
BEGIN
    INSERT INTO Biblioteca_Telos_Analytics.dbo.Loan_History 
        (loan_id, loan_duration_days, was_late)
    SELECT 
        i.loan_id,
        DATEDIFF(DAY, i.loan_date, i.return_date),
        CASE 
            WHEN DATEDIFF(DAY, i.loan_date, i.return_date) > 14 THEN 1
            ELSE 0
        END
    FROM inserted i
    WHERE i.return_date IS NOT NULL;
END;
GO

--Trigger de multa (Ficará no banco analítico)
USE Biblioteca_Telos_Analytics;
GO

CREATE OR ALTER TRIGGER trg_GeneratePenalty
ON Loan_History
AFTER INSERT
AS
BEGIN
    INSERT INTO Penalties (user_id, loan_id, penalty_amount, penalty_reason)
    SELECT 
        L.user_id,
        i.loan_id,
        (i.loan_duration_days - 14) * 2.50,
        'Atraso na devolução'
    FROM inserted i
    JOIN Biblioteca_Telos.dbo.Loans L
        ON L.loan_id = i.loan_id
    WHERE i.was_late = 1;
END;
GO

--Testando devolução
USE Biblioteca_Telos;
GO

EXEC RegistrarDevolucao @loan_id = 9;

--consultando ela (>14 dias a multa aparecerá automaticamente)
USE Biblioteca_Telos_Analytics;
GO

SELECT * FROM Loan_History;
SELECT * FROM Penalties;

--Ranking de usuários
SELECT 
    U.name,
    COUNT(L.loan_id) AS total_emprestimos
FROM Biblioteca_Telos.dbo.Users U
JOIN Biblioteca_Telos.dbo.Loans L ON U.user_id = L.user_id
GROUP BY U.name
ORDER BY total_emprestimos DESC;

--Taxa atraso por usuário
SELECT 
    U.name,
    COUNT(CASE WHEN H.was_late = 1 THEN 1 END) * 100.0 / COUNT(*) AS taxa_atraso_percentual
FROM Biblioteca_Telos_Analytics.dbo.Loan_History H
JOIN Biblioteca_Telos.dbo.Loans L ON H.loan_id = L.loan_id
JOIN Biblioteca_Telos.dbo.Users U ON U.user_id = L.user_id
GROUP BY U.name;

--Usuários que mais pagaram multas
SELECT 
    U.name,
    SUM(P.penalty_amount) AS total_multas
FROM Biblioteca_Telos_Analytics.dbo.Penalties P
JOIN Biblioteca_Telos.dbo.Users U ON U.user_id = P.user_id
GROUP BY U.name
ORDER BY total_multas DESC;

--Categoria de usuário restrito
UPDATE UP
SET user_category = 'Restrito'
FROM Biblioteca_Telos_Analytics.dbo.User_Profile UP
JOIN (
    SELECT L.user_id
    FROM Biblioteca_Telos_Analytics.dbo.Loan_History H
    JOIN Biblioteca_Telos.dbo.Loans L ON L.loan_id = H.loan_id
    WHERE H.was_late = 1
    GROUP BY L.user_id
    HAVING COUNT(*) >= 3
) atrasos
ON UP.user_id = atrasos.user_id;

--Uso mensal de livros (populando a tabela)
INSERT INTO Biblioteca_Telos_Analytics.dbo.Access_Stats (book_id, year_month, total_loans)
SELECT 
    book_id,
    FORMAT(loan_date, 'yyyy-MM'),
    COUNT(*)
FROM Biblioteca_Telos.dbo.Loans
GROUP BY book_id, FORMAT(loan_date, 'yyyy-MM');

--Relatório crescimento / queda
SELECT *,
       total_loans - LAG(total_loans) OVER (PARTITION BY book_id ORDER BY year_month) AS variacao
FROM Biblioteca_Telos_Analytics.dbo.Access_Stats;

