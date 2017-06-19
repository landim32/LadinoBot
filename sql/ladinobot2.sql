create table usuario (
id_usuario int not null auto_increment,
nome varchar(60) not null,
email varchar(120) not null,
senha varchar(60) not null,
cod_situacao int not null default 1,
primary key(id_usuario)
);

create table analise (
id_analise int not null auto_increment,
id_usuario int not null,
descricao varchar(160) not null,
data_inicio datetime not null,
data_termino datetime not null,
ativo varchar(10) not null,
deposito_inicial double not null,
lucro_total double not null,
corretagem_total double not null,
corretagem_valor double not null,
volume_maximo double not null,
cod_situacao int not null,
dados_configuracao MEDIUMTEXT,
dados_analise MEDIUMTEXT,
primary key(id_analise),
foreign key(id_usuario) references usuario(id_usuario)
);

alter table analise add column imagem_capital MEDIUMTEXT after cod_situacao;

ALTER TABLE analise MODIFY COLUMN imagem_capital MEDIUMTEXT CHARACTER SET utf8 COLLATE utf8_general_ci;

ALTER TABLE analise MODIFY COLUMN lucro_total ganho_total double not null;
alter table analise add column negociacao_quantidade int not null after lucro_total;
alter table analise drop column corretagem_total;
