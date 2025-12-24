--BASE DE DADOS:
USE Biblioteca_Telos;

--CRIANDO TABELAS:
CREATE TABLE Books (
    book_id INT PRIMARY KEY IDENTITY(1,1),
    title VARCHAR(200) NOT NULL,
    author VARCHAR(150) NOT NULL,
    genre VARCHAR(100),
    published_year INT
);

CREATE TABLE Users (
    user_id INT PRIMARY KEY IDENTITY(1,1),
    name VARCHAR(150) NOT NULL,
    email VARCHAR(200) UNIQUE NOT NULL
);

CREATE TABLE Loans (
    loan_id INT PRIMARY KEY IDENTITY(1,1),
    book_id INT NOT NULL,
    user_id INT NOT NULL,
    loan_date DATE NOT NULL DEFAULT GETDATE(),
    return_date DATE NULL,
    FOREIGN KEY (book_id) REFERENCES Books(book_id),
    FOREIGN KEY (user_id) REFERENCES Users(user_id)
);

--INSERÇÕES DOS DADOS:
INSERT INTO Books (title, author, genre, published_year) VALUES
('Dom Casmurro', 'Machado de Assis', 'Fiction', 1899),
('1984', 'George Orwell', 'Science Fiction', 1949),
('A Moreninha', 'Joaquim Manuel de Macedo', 'Romance', 1844),
('O Senhor dos Anéis', 'J.R.R. Tolkien', 'Fantasy', 1954),
('Harry Potter e a Pedra Filosofal', 'J.K. Rowling', 'Fantasy', 1997),
('Clean Code', 'Robert C. Martin', 'Technology', 2008),
('Sapiens', 'Yuval Noah Harari', 'History', 2011);

INSERT INTO Users (name, email) VALUES
('Ana Silva', 'ana.silva@email.com'),
('Carlos Santos', 'carlos.santos@email.com'),
('Maria Oliveira', 'maria.oliveira@email.com'),
('João Pereira', 'joao.pereira@email.com'),
('Fernanda Costa', 'fernanda.costa@email.com');

INSERT INTO Loans (book_id, user_id, loan_date, return_date) VALUES
(1, 1, '2025-01-10', '2025-01-20'),
(2, 1, '2025-02-15', '2025-02-25'),
(3, 1, '2025-03-01', NULL),
(4, 2, '2025-01-05', '2025-01-15'),
(2, 2, '2025-02-10', NULL),
(5, 3, '2025-03-05', '2025-03-10'),
(6, 3, '2025-03-12', NULL),
(7, 4, '2025-01-20', '2025-01-30'),
(1, 4, '2025-02-01', NULL),
(3, 5, '2025-03-03', '2025-03-08'),
(5, 5, '2025-03-10', NULL);

--INSERÇÃO DE NOVO LIVRO
INSERT INTO Books (title, author, genre, published_year) 
VALUES ('O Menino Maluquinho', 'Ziraldo', 'Infantil', 1980);

--VERIFICANDO A TABELA:
SELECT * FROM books


--ATUALIZAÇÃO
UPDATE Books 
SET genre = 'Infantil' 
WHERE title = 'O Menino Maluquinho';

--DELETAR USUÁRIO
DELETE FROM Users WHERE user_id = 1;

--CONSULTAS:
--POR GÊNERO:
SELECT * FROM Books WHERE genre = 'Fiction';

--TODOS OS LIVROS EMPRESTADOS:
SELECT 
    Books.title, 
    Users.name AS usuario, 
    Loans.loan_date
FROM Loans
JOIN Books ON Loans.book_id = Books.book_id
JOIN Users ON Loans.user_id = Users.user_id
WHERE Loans.return_date IS NULL;

--FUNÇÕES:
--USUÁRIOS COM MAIS DE 1 EMPRÉSTIMO:
SELECT Users.name
FROM Users
WHERE (
    SELECT COUNT(*) 
    FROM Loans 
    WHERE Loans.user_id = Users.user_id
) > 1;

CREATE FUNCTION TotalLoans (@user_id INT)
RETURNS INT
AS
BEGIN
    RETURN (
        SELECT COUNT(*) 
        FROM Loans 
        WHERE user_id = @user_id
    );
END;

--TESTE FUNÇÃO:
--TOTAL POR USUÁRIO
SELECT dbo.TotalLoans(1) AS Total_Emprestimos_Usuario_1;

--RELATÓRIO:
--EMPRESTADOS E DEVOLVIDOS
SELECT 
    Books.title,
    Users.name AS usuario,
    Loans.loan_date,
    Loans.return_date,
    CASE 
        WHEN Loans.return_date IS NULL THEN 'Emprestado'
        ELSE 'Devolvido'
    END AS status
FROM Loans
JOIN Books ON Loans.book_id = Books.book_id
JOIN Users ON Loans.user_id = Users.user_id;


--RANKING USUÁRIOS
SELECT 
    Users.name,
    COUNT(Loans.loan_id) AS total_emprestimos
FROM Users
LEFT JOIN Loans ON Users.user_id = Loans.user_id
GROUP BY Users.name
ORDER BY total_emprestimos DESC;

--PROCEDURES:
--REGISTRAR EMPRÉSTIMO
CREATE PROCEDURE RegistrarEmprestimo
    @book_id INT,
    @user_id INT
AS
BEGIN
    IF EXISTS (
        SELECT 1 
        FROM Loans 
        WHERE book_id = @book_id 
        AND return_date IS NULL
    )
    BEGIN
        PRINT 'Livro não disponível para empréstimo.';
        RETURN;
    END
    
    INSERT INTO Loans (book_id, user_id, loan_date)
    VALUES (@book_id, @user_id, GETDATE());
    
    PRINT 'Empréstimo registrado com sucesso!';
END;

--REGISTRAR DEVOLUÇÃO
CREATE PROCEDURE RegistrarDevolucao
    @loan_id INT
AS
BEGIN
    UPDATE Loans
    SET return_date = GETDATE()
    WHERE loan_id = @loan_id AND return_date IS NULL;
    
    IF @@ROWCOUNT > 0
        PRINT 'Devolução registrada com sucesso!';
    ELSE
        PRINT 'Empréstimo não encontrado ou já devolvido.';
END;

--TESTES:
--NOVO EMPRÉSTIMO
EXEC RegistrarEmprestimo @book_id = 4, @user_id = 3;

--LIVRO JÁ EMPRESTADO
EXEC RegistrarEmprestimo @book_id = 2, @user_id = 4; --TEM QUE FALHAR (MSG: LIVRO NÃO DISPONÍVEL)

--DEVOLUÇÃO
EXEC RegistrarDevolucao @loan_id = 3;

--DISPONIBILIDADE:
SELECT 
    Books.title,
    CASE 
        WHEN EXISTS (
            SELECT 1 
            FROM Loans 
            WHERE book_id = Books.book_id 
            AND return_date IS NULL
        ) THEN 'Indisponível'
        ELSE 'Disponível'
    END AS status
FROM Books
WHERE book_id = 1;

--VIEWS:
--RELATÓRIO DE LIVROS EMPRESTADOS E DEVOLVIDOS
SELECT 
    Books.title,
    Books.author,
    Users.name AS usuario,
    Loans.loan_date AS data_emprestimo,
    Loans.return_date AS data_devolucao,
    CASE 
        WHEN Loans.return_date IS NULL THEN 'Emprestado'
        ELSE 'Devolvido'
    END AS status
FROM Loans
JOIN Books ON Loans.book_id = Books.book_id
JOIN Users ON Loans.user_id = Users.user_id
ORDER BY Loans.loan_date DESC;

--ATUALMENTE EMPRESTADOS
SELECT 
    Books.title,
    Books.author,
    Books.genre,
    Users.name AS usuario_emprestado,
    Users.email,
    Loans.loan_date,
    DATEDIFF(day, Loans.loan_date, GETDATE()) AS dias_emprestado
FROM Loans
JOIN Books ON Loans.book_id = Books.book_id
JOIN Users ON Loans.user_id = Users.user_id
WHERE Loans.return_date IS NULL
ORDER BY Loans.loan_date;

--QUEM TEM MAIS EMPRÉSTIMO
SELECT 
    Users.user_id,
    Users.name,
    Users.email,
    COUNT(Loans.loan_id) AS total_emprestimos,
    COUNT(CASE WHEN Loans.return_date IS NULL THEN 1 END) AS emprestimos_ativos
FROM Users
LEFT JOIN Loans ON Users.user_id = Loans.user_id
GROUP BY Users.user_id, Users.name, Users.email
ORDER BY total_emprestimos DESC;

--PENDENTE HÁ MAIS DE 30 DIAS
SELECT 
    Users.user_id,
    Users.name AS usuario,
    Users.email,
    Books.title AS livro_emprestado,
    Books.author,
    Loans.loan_date AS data_emprestimo,
    DATEDIFF(day, Loans.loan_date, GETDATE()) AS dias_em_atraso,
    Loans.loan_id
FROM Loans
JOIN Books ON Loans.book_id = Books.book_id
JOIN Users ON Loans.user_id = Users.user_id
WHERE 
    Loans.return_date IS NULL  -- Empréstimo ainda não devolvido
    AND DATEDIFF(day, Loans.loan_date, GETDATE()) > 30  -- Mais de 30 dias
ORDER BY dias_em_atraso DESC;