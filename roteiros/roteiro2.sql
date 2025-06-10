-- Questão 1:
CREATE TABLE tarefas(
    cpf Integer,
    funcao TEXT,
    telefone char(11),
    numero char(1),
    realizado char(1)
);

-- para ver todos os valores das colunas: SELECT * FROM tarefas;

--INSERT corretos:
INSERT INTO tarefas VALUES (2147483646, 'limpar chão do corredor central', '98765432111', 0, 'F');

INSERT INTO tarefas VALUES (2147483647, 'limpar janelas da sala 203', '98765432122', 1, 'F');

INSERT INTO tarefas VALUES (null, null, null, null, null);

-- INSERT errados (não roda):

-- Ao colocar o insert abaixo aparece isso: ERROR: value too long for type character(11)
INSERT INTO tarefas VALUES (2147483644, 'limpar chão do corredor superior', '987654323211', 0, 'F');

-- Ao colocar o insert abaixo aparece isso: ERROR: value too long for type character(1)
INSERT INTO tarefas VALUES (2147483643, 'limpar chão do corredor superior', '98765432321', 0, 'FF');

-- Questão 2: 

-- Ao colocar o insert abaixo aparece isso: ERROR:  integer out of range
INSERT INTO tarefas VALUES (2147483648, 'limpar portas do térreo', '32323232955', 4, 'A');

-- Modifiquei para char (ou bigint) e o comando anterior foi adicionado: 
ALTER TABLE tarefas ALTER COLUMN cpf TYPE CHAR(10);

-- ficando assim: 
CREATE TABLE tarefas(
    cpf char(10),
    funcao TEXT,
    telefone char(11),
    numero char(1),
    realizado char(1)
);

-- Ao rodar o comando insert, foi adicionado com sucesso!

-- Questão 3: modificar para não permitir o adicionameto de inserts do atributo "numero" que sejam maiores que 32767

-- antes, modifiquei o atributo número de char para integer
ALTER TABLE tarefas ALTER COLUMN numero TYPE Integer USING numero::integer;

CREATE TABLE tarefas(
    cpf char(10),
    funcao TEXT,
    telefone char(11),
    numero Integer,
    realizado char(1)
);

ALTER TABLE tarefas ADD CONSTRAINT numero_chk_valido CHECK (numero < 32768);

-- INSERT errados (não roda):

-- aparece isso após executar o comando abaixo: ERROR: new row for relation "tarefas" violates check constraint "numero_chk_valido" DETAIL:  Failing row contains (2147483649, limpar portas da entrada principal, 32322525199, 32768, A).
INSERT INTO tarefas VALUES (2147483649, 'limpar portas da entrada principal','32322525199', 32768, 'A');

-- aparece isso após executar o comando abaixo: ERROR: new row for relation "tarefas" violates check constraint "numero_chk_valido" DETAIL:  Failing row contains (2147483650, limpar janelas da entrada principal, 32333233288, 32769, A)
INSERT INTO tarefas VALUES (2147483650, 'limpar janelas da entrada principal', '32333233288', 32769, 'A');

-- INSERT certos:

INSERT INTO tarefas VALUES (2147483651, 'limpar portas do 1o andar','32323232911', 32767, 'A');
INSERT INTO tarefas VALUES (2147483652, 'limpar portas do 2o andar', '32323232911', 32766, 'A');


-- Questão 4:

-- Não permitir valores null:

-- Ao colocar o comando abaixo aparece esse erro: ERROR: column "cpf" of relation "tarefas" contains null values
ALTER TABLE tarefas ALTER COLUMN cpf SET NOT NULL;

-- Apaguei a tupla que tinha o cpf null:
DELETE FROM tarefas WHERE cpf is null; 

-- Modifiquei as colunas para não permitir valores null:
ALTER TABLE tarefas ALTER COLUMN cpf SET NOT NULL;
ALTER TABLE tarefas ALTER COLUMN funcao SET NOT NULL;
ALTER TABLE tarefas ALTER COLUMN telefone SET NOT NULL;
ALTER TABLE tarefas ALTER COLUMN numero SET NOT NULL;
ALTER TABLE tarefas ALTER COLUMN realizado SET NOT NULL;

-- Modifiquei os nomes das colunas:

ALTER TABLE tarefas RENAME COLUMN cpf TO id;
ALTER TABLE tarefas RENAME COLUMN funcao TO descricao;
ALTER TABLE tarefas RENAME COLUMN telefone TO func_resp_cpf;
ALTER TABLE tarefas RENAME COLUMN numero TO prioridade;
ALTER TABLE tarefas RENAME COLUMN realizado TO status;

-- ficou assim: 

CREATE TABLE tarefas(
    id char(10),
    descricao TEXT,
    func_resp_cpf char(11),
    prioridade Integer,
    status char(1)
);

-- Questão 5:
-- execução do primeiro INSERT mas não permitir a execução do segundo.

INSERT INTO tarefas VALUES (2147483653, 'limpar portas do 1o andar','32323232911', 2, 'A');

-- para o segundo insert nao funcionar, precisarei modificar o id para uma chave primária:
ALTER TABLE tarefas ADD PRIMARY KEY (id);

-- aparece isso para o segundo insert: ERROR:  duplicate key value violates unique constraint "tarefas_pkey" DETAIL:  Key (id)=(2147483653) already exists.
INSERT INTO tarefas VALUES (2147483653, 'aparar a grama da área frontal', '32323232911', 3, 'A');

-- Questão 6: 
-- 6.A) coluna func_resp_cpf deve ter exatamente 11 caracteres 

ALTER TABLE tarefas ADD CONSTRAINT func_resp_cpf_valido CHECK (char_length(func_resp_cpf) = 11);

-- testar para que não passe:
-- menor: ERROR:  ERROR:  new row for relation "tarefas" violates check constraint "func_resp_cpf_valido" DETAIL:  Failing row contains (1010101010, limpar telhado, 1111111111 , 2, A).
INSERT INTO tarefas VALUES (1010101010, 'limpar telhado', '1111111111', 2, 'A');

-- maior: ERROR:  value too long for type character(11)
INSERT INTO tarefas VALUES (1023456789, 'limpar telhado', '123456789012', 2, 'A');

-- 6.B) mudanças nos valores para status: 
-- de Aguardando - 'A' para Planejada - 'P' (realizar UPDATE:); 
UPDATE tarefas SET status = 'P' WHERE status = 'A';
-- de Realizando - 'R' para Executando - 'E'; 
UPDATE tarefas SET status = 'E' WHERE status = 'R';
-- de Finalizada - 'F' para Concluída - 'C'.
UPDATE tarefas SET status = 'C' WHERE status = 'F';


ALTER TABLE tarefas ADD CONSTRAINT status_permitidos CHECK (status = 'P' OR status = 'E' OR status = 'C');

-- Questão 7: Adicione outra constraint que restrinja os possíveis valores da coluna prioridade para 0,1,2,3,4,5.

-- para aquelas tuplas em que a prioridade é maior que 5:

UPDATE tarefas SET prioridade = 5 WHERE prioridade > 5;

ALTER TABLE tarefas ADD CONSTRAINT prioridade_permitidas CHECK(prioridade >= 0 AND prioridade <=5);

-- Questão 8: Criar a tabela Funcionario com cpf (chave primária), data de nascimento, nome, função, nível e o cpf do supervisor(chave estrangeira)

CREATE TABLE funcionario(
    cpf char(11),
    data_nasc date NOT NULL,
    nome varchar(30) NOT NULL,
    funcao varchar(11) NOT NULL,
    nivel char(1) NOT NULL,
    superior_cpf char(11),
    CONSTRAINT funcionario_pkey PRIMARY KEY(cpf),
    CONSTRAINT funcionario_superior_cpf_fkey FOREIGN KEY(superior_cpf) REFERENCES funcionario(cpf)
)

-- Adicionando a restrição que só permite que o nível seja Junior (J), Pleno (P) ou Sênior(s)
ALTER TABLE funcionario ADD CONSTRAINT niveis_permitidos CHECK (nivel = 'J' OR nivel = 'P' OR nivel = 'S');

-- Adicionando a restrição que só permite que as funções permitidas sejam LIMPEZA ou SUP_LIMPEZA
ALTER TABLE funcionario ADD CONSTRAINT funcoes_permitidas CHECK (funcao = 'LIMPEZA' OR funcao = 'SUP_LIMPEZA');

-- Adicionando a restrição que só permite que as função LIMPEZA tenha um supervisor 
-- (ao negar, so permite se o cpf do superior não seja null)
ALTER TABLE funcionario ADD CONSTRAINT limpeza_superior_obrigatorio CHECK (NOT (funcao = 'LIMPEZA' AND superior_cpf IS NULL));

-- devem funcionar:
INSERT INTO funcionario (cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES ('12345678911', '1980-05-07', 'Pedro da Silva', 'SUP_LIMPEZA', 'S', null);
INSERT INTO funcionario(cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES ('12345678912', '1980-03-08', 'Jose da Silva', 'LIMPEZA', 'J', '12345678911');

-- não deve funcionar: aparece isso: ERROR:  new row for relation "funcionario" violates check constraint "limpeza_superior_obrigatorio" DETAIL:  Failing row contains (12345678913, 1980-04-09, joao da Silva, LIMPEZA, J, null).
INSERT INTO funcionario(cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES ('12345678913', '1980-04-09', 'joao da Silva', 'LIMPEZA', 'J', null);


-- Questão 9:

-- Insert que funcionam:
INSERT INTO funcionario VALUES ('12345678914', '2002-08-16', 'Bruna Letícia', 'SUP_LIMPEZA', 'S', null);
INSERT INTO funcionario VALUES ('12345678915', '2020-01-03', 'Snow Brown', 'SUP_LIMPEZA', 'P', null);
INSERT INTO funcionario VALUES ('12345678916', '1999-01-10', 'Celaena Sardothien', 'LIMPEZA', 'J', '12345678914');
INSERT INTO funcionario VALUES ('12345678917', '1998-11-13', 'Aelin Galathynius ', 'SUP_LIMPEZA', 'S', null);
INSERT INTO funcionario VALUES ('12345678918', '1001-10-10', 'Daenerys Targaryen', 'LIMPEZA', 'J', '12345678915');
INSERT INTO funcionario VALUES ('12345678919', '1500-08-16', 'Rowan Whitethorn', 'LIMPEZA', 'S', '12345678914');
INSERT INTO funcionario VALUES ('12345678921', '1998-09-29', 'Dorian Havilliard', 'LIMPEZA', 'P', '12345678917');
INSERT INTO funcionario VALUES ('12345678922', '2001-11-30', 'Arya Stark', 'LIMPEZA', 'J', '12345678914');
INSERT INTO funcionario VALUES ('12345678923', '1998-03-19', 'Maxon Schreave', 'LIMPEZA', 'S', '12345678917');
INSERT INTO funcionario VALUES ('12345678920', '2000-08-15', 'Emília, Marquesa de Rabicó', 'SUP_LIMPEZA', 'P', null);


-- Insert que não funcionaram:

-- restrição do nível: A
INSERT INTO funcionario VALUES ('12345678921', '1998-10-24', 'Chaol Westfall', 'LIMPEZA', 'A', '12345678920');

-- restrição no cpf: 12345678911111
INSERT INTO funcionario VALUES ('12345678911111', '1888-09-14', 'Legolas', 'SUP_LIMPEZA', 'J', null);

-- restrição no nome:
INSERT INTO funcionario VALUES ('12345678926', '1999-01-22', null, 'SUP_LIMPEZA', 'P', null);

-- restrição da função: null
INSERT INTO funcionario VALUES ('12345678927', '1998-04-29', 'Manon Bico Negro', null , 'J', '12345678915');

-- restrição da função Limpeza sem supervisao: null
INSERT INTO funcionario VALUES ('12345678924', '1001-02-22', 'Cersei Lannister', 'LIMPEZA', 'J', null);

-- restrição no cpf do supervisor não está na tabela: 111111111
INSERT INTO funcionario VALUES ('12345678928', '1994-08-19', 'Aedion Ashryver', 'SUP_LIMPEZA', 'J', '111111111');

-- restrição no cpf/chave primária: null
INSERT INTO funcionario VALUES (null, '1825-12-02', 'Dom Pedro Segundo', 'SUP_LIMPEZA', 'J', null);

-- restrição do nível: null
INSERT INTO funcionario VALUES ('12345678930', '1998-07-11', 'Sam Cortland', 'SUP_LIMPEZA', null, null);

-- restrção data de nascimento: null 
INSERT INTO funcionario VALUES ('12345678931', null, 'Sheldon Cooper', 'SUP_LIMPEZA', 'S', null);

-- restrição da função: MARAVILHOSA
INSERT INTO funcionario VALUES ('12345678925', '1998-03-19', 'Powder Jinx', 'MARAVILHOSA', 'S', '12345678923');

-- restrição do cpf: chave primária ja existente 
INSERT INTO funcionario VALUES ('12345678914', '1970-01-01', 'Chandler Bing', 'SUP_LIMPEZA', 'J', null);
