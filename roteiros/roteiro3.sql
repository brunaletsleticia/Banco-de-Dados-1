
-- Questão 1:
CREATE TABLE farmacia(
    id Integer,
    bairro varchar(20),
    cidade varchar(20),
    estado varchar(20),
    tipo varchar(6),
    gerente char(11),
    CONSTRAINT farmacia_pkey PRIMARY KEY(id),
    --CONSTRAINT tipo_valido_chk CHECK (tipo  IN ('sede','filial'));
    CONSTRAINT tipo_valido_chk CHECK (tipo  IN ('s','f'));
    CONSTRAINT farmacia_gerente_unico UNIQUE (gerente),
    CONSTRAINT farmacia_gerente_fkey FOREIGN KEY (gerente) REFERENCES funcionario(cpf_funcionario)
);

CREATE TABLE funcionario(
    funcao varchar(15),
    farmacia_vinculada Integer,
    cpf_funcionario char(11),
    CONSTRAINT funcionario_pkey PRIMARY KEY(cpf_funcionario),
    CONSTRAINT funcionario_farmacia_vinculada_fkey FOREIGN KEY (farmacia_vinculada) REFERENCES farmacia(id),
   -- CONSTRAINT funcao_valido_chk CHECK (funcao = 'farmaceuticos' OR funcao = 'vendedores' OR  funcao = 'entregadores' OR funcao = 'caixas' OR funcao = 'administradores');
    CONSTRAINT funcao_valido_chk CHECK (funcao IN ('farmaceuticos', 'vendedores', 'entregadores', 'caixas', 'administradores')),

);

CREATE TABLE medicamentos(
    nome varchar(20),
    venda_receita boolean,
    
);

CREATE TABLE vendas(
    
);

CREATE TABLE entregas(
   
);

CREATE TABLE cliente(
    cpf_cliente char(11),
    nome varchar(30),
    idade integer,
    cadastrado boolean,
    CONSTRAINT cliente_pkey PRIMARY KEY(cpf_cliente),
    CONSTRAINT cadastro_valido CHECK (idade >= 18 OR idade < 18 AND cadastrado = FALSE),
    
);

CREATE TABLE endereco_cliente(
    cep char(8),
    cliente_cpf char(11),
    local_endereco varchar(10),
    CONSTRAINT local_endereco_valido_chk CHECK (local_endereco IN ('residencia', 'trabalho', 'outro')),
    CONSTRAINT endereco_cliente_cliente_cpf_fkey FOREIGN KEY (cliente_cpf) REFERENCES cliente (cpf_cliente),
    CONSTRAINT cep_valido CHECK(LENGTH(cep) = 8)
);



ALTER TABLE vendas ADD CONSTRAINT medicamento FOREIGN KEY (id_medicamento) REFERENCES medicamentos (id_medicamento) 
ON DELETE RESTRICT




CREATE TABLE pedidos(
    id integer PRIMARY KEY,
    descricao text,
    quantidade integer,
    local varchar(20) REFERENCES endereco(id_seguro),

    CONSTRAINT pedidos_pkey PRIMARY KEY(id)
    CONSTRAINT pedidos_local_fkey FOREIGN KEY (local) REFERENCES endereco(id_seguro) ON DELETE RESTRICT

)

ALTER TABLE pedidos ADD PRIMARY KEY (id);
ALTER TABLE tabela ADD CONSTRAINT nome_da_restricao FOREIGN KEY (local) REFERENCES endereco (id_seguro);


--PK, FK, CHECK, UNIQUE
CREATE TABLE tabela(
    atrib1 char(11) PRIMARY KEY,
    atrib2 varchar(10) REFERENCES outraTabela(atributoDela),
    atrib3 integer UNIQUE,
    atrib4 boolean,
    UNIQUE(atrib3),

    CONSTRAINT nome_da_restricao=tabela_pkey PRIMARY KEY(atrib1),
    CONSTRAINT nome_da_restricao=tabela_atrib2_fkey FOREIGN KEY (atrib2) REFERENCES outraTabela(atributoDela) ON DELETE CASCADE,
    CONSTRAINT atrib3_permitidos CHECK (atrib3 > 9 AND atrib3 < 20),
    CONSTRAINT atrib1_permitidos CHECK (LENGTH(atrib1 = 11)),
    CONSTRAINT atrib2_permitidos CHECK (atrib2 IN ('vjnjnvjn', 'njenovinoin'))

);


UPDATE tarefas SET status = 'P' WHERE status = 'A';
-- Adicionando a restrição que só permite que as função LIMPEZA tenha um supervisor 
-- (ao negar, so permite se o cpf do superior não seja null)
ALTER TABLE funcionario ADD CONSTRAINT limpeza_superior_obrigatorio CHECK (NOT (funcao = 'LIMPEZA' AND superior_cpf IS NULL));


CREATE TABLE pedidos (
    id SERIAL PRIMARY KEY,
    cliente_id INT
);

CREATE TABLE clientes (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(50),
    CONSTRAINT fk_cliente_pedido FOREIGN KEY (id) REFERENCES pedidos (id) ON DELETE RESTRICT
);
;
