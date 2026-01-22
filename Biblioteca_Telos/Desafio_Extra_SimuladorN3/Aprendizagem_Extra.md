### BANCO DE DADOS

Nesse projeto eu implementei duas triggers, como foi pedido no enunciado.

A primeira trigger roda na tabela principal (Biblioteca_Telos) de empréstimos e, quando um livro é devolvido, ela automaticamente grava um histórico no banco analítico, já calculando quantos dias durou o empréstimo e se houve atraso.

A segunda trigger roda sobre esse histórico (Biblioteca_Telos_Analytics) e, quando identifica que o empréstimo foi entregue com atraso, ela gera automaticamente uma multa na tabela de penalidades.

Com isso, eu consegui automatizar regras de negócio importantes sem precisar de processos manuais.

É como se o banco estivesse se fiscalizando sozinho.

Quando alguém devolve um livro, a trigger registra automaticamente o histórico.

Se esse histórico indicar atraso, outra trigger cria a multa automaticamente.

Assim, o sistema não depende de ninguém rodar comando manual: tudo acontece sozinho.
