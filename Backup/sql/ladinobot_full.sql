CREATE TABLE `analise` (
  `id_analise` int(11) NOT NULL AUTO_INCREMENT,
  `id_usuario` int(11) NOT NULL,
  `descricao` varchar(160) NOT NULL,
  `data_inicio` datetime NOT NULL,
  `data_termino` datetime NOT NULL,
  `ativo` varchar(10) NOT NULL,
  `deposito_inicial` double NOT NULL,
  `ganho_total` double NOT NULL,
  `negociacao_quantidade` int(11) NOT NULL,
  `volume_maximo` double NOT NULL,
  `cod_situacao` int(11) NOT NULL,
  `imagem_capital` mediumtext CHARACTER SET utf8,
  `dados_configuracao` mediumtext,
  `dados_analise` mediumtext,
  PRIMARY KEY (`id_analise`),
  KEY `id_usuario` (`id_usuario`)
) ENGINE=MyISAM AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;

CREATE TABLE `usuario` (
  `id_usuario` int(11) NOT NULL AUTO_INCREMENT,
  `nome` varchar(60) NOT NULL,
  `email` varchar(120) NOT NULL,
  `senha` varchar(60) NOT NULL,
  `cod_situacao` int(11) NOT NULL DEFAULT '1',
  PRIMARY KEY (`id_usuario`)
) ENGINE=MyISAM AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;
