-- Questão 1 e questão 2:

-- Tabela automovel: contém dono, placa, modelo e ano de fabricação do veículo.
CREATE TABLE automovel(
	placa varchar(7),
	modelo varchar(30),
	ano integer,
    dono varchar(30)
);

-- Tabela segurado: contém nome, nascimento, cpf, enedereço, email e o automóvel do segurado 
CREATE TABLE segurado(
    nascimento date,
    nome varchar(30),
    cpf char(11) ,
    endereco varchar(30),
    email varchar(30),
    carro varchar(30)
);

-- Tabela mecânico: contém nome, nascimento, cpf, endereço, email, função e a oficina em que o perito trabalha
CREATE TABLE perito(
	nascimento date,
	nome varchar(30),
	cpf char(11) ,
	endereco varchar(30),
	email varchar(30),
	funcao varchar(30),
	local_de_trabalho varchar(30) 
);

-- Tabela oficina: contém nome, dono, cnpj, endereço da oficina 
CREATE TABLE oficina(
	nome varchar(30),
	cnpj  char(14),
	endereco varchar(30),
);

-- Tabela seguro: contém o nome e o cpf do segurado, bem como o id, o pagamento, o tipo do seguro e se ele cobre ou não a perda total do automóvel 
CREATE TABLE seguro(
    id_seguro integer,
    tipo varchar(20),
    pagamento numeric,
    nome_segurado varchar(20),
    cpf_segurado char(11),
    cobertura_pt boolean
	
);

-- Tabela sinistro: contém o nome e o cpf do segurado; o id do seguro; a placa e o tipo do automóvel; o tipo de ocorrẽncia do sinistro e o seu id
CREATE TABLE sinistro(
    evento varchar(20),
    placa varchar(7),
    tipo_do_automovel varchar(20),
    nome_segurado varchar(20),
    cpf_segurado char(11) ,
    id_seguro integer ,
    id_sinistro integer
	
);

-- Tabela pericia: contém a placa, o modelo do automóvel, o relatório e evento/ocorrência que causou os danos no veículo; o nome do perito e o seu cpf
CREATE TABLE pericia(
    evento varchar(20),
    placa varchar(7),
    modelo varchar(20),
    nome_perito varchar(20),
    cpf_perito char(11),
    relatorio text
	
);
-- Tabela reparo: contém a placa, o modelo do automóvel e o id do sinistro
CREATE TABLE reparo(
    placa varchar(7),
    modelo varchar(20),
    id_sinistro integer 
);

-- Questão 3: Definindo as chaves primárias:
ALTER TABLE automovel ADD PRIMARY KEY(placa);
ALTER TABLE segurado ADD PRIMARY KEY (cpf);
ALTER TABLE perito ADD PRIMARY KEY (cpf);
ALTER TABLE oficina ADD PRIMARY KEY (cnpj);
ALTER TABLE seguro ADD PRIMARY KEY (id_seguro);
ALTER TABLE sinistro ADD PRIMARY KEY (id_sinistro);


-- Questão 4: Definindo as chaves estrangeiras:
ALTER TABLE segurado ADD CONSTRAINT carro FOREIGN KEY (placa) 
REFERENCES automovel (placa);

ALTER TABLE perito ADD CONSTRAINT local_de_trabalho FOREIGN KEY (cnpj) 
REFERENCES oficina (cnpj);

ALTER TABLE sinistro
ADD CONSTRAINT fk_cpf_segurado FOREIGN KEY (cpf_segurado) REFERENCES segurado (cpf);


ALTER TABLE sinistro
ADD CONSTRAINT fk_id_seguro FOREIGN KEY (id_seguro) REFERENCES seguro (id_seguro);

ALTER TABLE pericia
ADD CONSTRAINT fk_cpf_perito FOREIGN KEY (cpf_perito) REFERENCES perito (cpf);

ALTER TABLE reparo
ADD CONSTRAINT fk_id_sinistro FOREIGN KEY (id_sinistro) REFERENCES sinistro (id_sinistro);

-- Questão 5: os atributos que se configuram como "NOT NULL" serão as chaves primárias e as chaves estrangérias 

-- Questao 6: remover as tabelas

DROP TABLE pericia;
DROP TABLE reparo;
DROP TABLE sinistro;
DROP TABLE seguro;
DROP TABLE segurado;
DROP TABLE perito;
DROP TABLE oficina;
DROP TABLE automovel;

-- Questão 7 e 8: 

-- Tabela automovel: contém dono, placa, modelo, ano de fabricação do veículo.
CREATE TABLE automovel(
	placa varchar(7) NOT NULL PRIMARY KEY,
	modelo varchar(20),
	ano integer,
    dono varchar(20)
);

-- Tabela segurado: contém nome, nascimento, cpf, enedereço, email e o automóvel do segurado 
CREATE TABLE segurado(
    nascimento date,
    nome varchar(20),
    cpf char(11) NOT NULL PRIMARY KEY,
    endereco varchar(20),
    email varchar(20),
    carro varchar(30) NOT NULL REFERENCES automovel(placa)
);

-- Tabela mecanico: contém nome, nascimento, cpf, enedereço, email, função e a oficina em que o perito trabalha
CREATE TABLE perito(
	nascimento date,
	nome varchar(20),
	cpf char(11) NOT NULL PRIMARY KEY,
	endereco varchar(20),
	email varchar(20),
	funcao varchar(20),
	local_de_trabalho varchar(30) NOT NULL REFERENCES oficina(cnpj)
);

-- Tabela oficina: contém nome, dono, cnpj, endereço e a quantidade de funcionarios da oficina 
CREATE TABLE oficina(
	nome varchar(20),
	cnpj  char(14) NOT NULL PRIMARY KEY,
	endereco varchar(20),
    dono varchar(20),
    funcionarios integer
);

-- Tabela seguro: contém o nome e o cpf do segurado, bem como o id, o pagamento, o tipo do seguro e se ele cobre ou não a perda total do automóvel 
CREATE TABLE seguro(
    id_seguro integer NOT NULL PRIMARY KEY,
    tipo varchar(20),
    pagamento numeric,
    nome_segurado varchar(20),
    cpf_segurado char(11) NOT NULL REFERENCES segurado(cpf),
    cobertura_pt boolean	
);


-- Tabela sinistro: contém o nome e o cpf do segurado; o id do seguro; a placa e o tipo do automóvel; o tipo de ocorrẽncia do sinistro e o seu id
CREATE TABLE sinistro(
    evento varchar(20),
    placa varchar(7),
    tipo_do_automovel varchar(20),
    nome_segurado varchar(20),
    cpf_segurado char(11) NOT NULL REFERENCES segurado(cpf),
    id_seguro integer NOT NULL REFERENCES seguro(id_seguro),
    id_sinistro integer NOT NULL PRIMARY KEY
);

-- Tabela pericia: contém a placa, o modelo do automóvel, o relatório e evento/ocorrência que causou os danos no veículo; o nome do perito e o seu cpf
CREATE TABLE pericia(
    evento varchar(20),
    placa varchar(7),
    modelo varchar(20),
    nome_perito varchar(20),
    cpf_perito char(11) NOT NULL REFERENCES perito(cpf),
    relatorio text
);
-- Tabela reparo: contém a placa, o modelo do automóvel e o id do sinistro
CREATE TABLE reparo(
    placa varchar(7),
    modelo varchar(20),
    id_sinistro integer NOT NULL REFERENCES sinistro(id_sinistro)
);

-- Questão 9: Remover as tabelas novamente
DROP TABLE reparo;
DROP TABLE pericia;
DROP TABLE sinistro;
DROP TABLE seguro;
DROP TABLE perito;
DROP TABLE oficina;
DROP TABLE segurado;
DROP TABLE automovel;

-- 10: Não faria mais tabelas

