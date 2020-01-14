<?php

define('ANALISE_SITUACAO_ATIVO', 1);
define('ANALISE_SITUACAO_INATIVO', 2);

class Analise {
    
    function query() {
        return "
            SELECT
                analise.id_analise,
                analise.id_usuario,
                analise.descricao,
                analise.data_inicio,
                analise.data_termino,
                analise.ativo,
                analise.imagem_capital,
                analise.dados_configuracao,
                analise.dados_analise,
                analise.deposito_inicial,
                analise.ganho_total,
                analise.negociacao_quantidade,
                analise.volume_maximo,
                analise.cod_situacao,
                usuario.nome as 'usuario_nome'
            FROM analise
            INNER JOIN usuario ON usuario.id_usuario = analise.id_usuario
        ";
    }

    function atualizar($analise) {
        if (!is_null($analise)) {
            $configuracoes = array();
            $vetor = explode("\n", $analise->dados_configuracao);
            foreach ($vetor as $linha) {
                $item = explode("=", $linha);
                $configuracoes[strtolower($item[0])] = $item[1];
            }
            $analise->configuracoes = $configuracoes;
            $analise->corretagem_valor = floatval($configuracoes['corretagem']);
            $analise->corretagem_total = $analise->corretagem_valor * $analise->negociacao_quantidade;
            $analise->total = $analise->ganho_total - $analise->corretagem_total;
        }
        return $analise;
    }
    
    function listarAtivo() {
        $query = "
            SELECT 
                analise.ativo,
                COUNT(analise.id_analise) AS 'quantidade'
            FROM analise
            WHERE analise.cod_situacao = '".do_escape(ANALISE_SITUACAO_ATIVO)."'
            GROUP BY 
                analise.ativo
            ORDER BY 
                COUNT(analise.id_analise)
        ";
        return get_result($query);
    }
    
    function listar($id_usuario = null) {
        $query = $this->query();
        $query .= " WHERE analise.cod_situacao = '".do_escape(ANALISE_SITUACAO_ATIVO)."'";
        if (!is_null($id_usuario))
            $query .= " AND analise.id_usuario = '".do_escape($id_usuario)."'";
        $retorno = array();
        $result = get_result_db($query);
        while ($row = get_object($result))
            $retorno[] = $this->atualizar($row);
        free_result($result);
        return $retorno;
    }
    
    function pegar($id_analise) {
        $query = $this->query();
        $query .= " WHERE analise.id_analise = '".do_escape($id_analise)."'";
        return $this->atualizar(get_first_result($query));
    }
    
    function pegarDoPost($analise = null) {
        if (is_null($analise))
            $analise = new stdClass();
        if (array_key_exists("descricao", $_POST))
            $analise->descricao = $_POST['descricao'];
        if (array_key_exists("data_inicio", $_POST))
            $analise->data_inicio = $_POST['data_inicio'];
        if (array_key_exists("data_termino", $_POST))
            $analise->data_termino = $_POST['data_termino'];
        if (array_key_exists("ativo", $_POST))
            $analise->ativo = $_POST['ativo'];
        if (array_key_exists("deposito_inicial", $_POST))
            $analise->deposito_inicial = $_POST['deposito_inicial'];
        if (array_key_exists("negociacao_quantidade", $_POST))
            $analise->negociacao_quantidade = $_POST['negociacao_quantidade'];
        if (array_key_exists("ganho_total", $_POST))
            $analise->ganho_total = $_POST['ganho_total'];
        if (array_key_exists("volume_maximo", $_POST))
            $analise->volume_maximo = $_POST['volume_maximo'];
        if (array_key_exists("cod_situacao", $_POST))
            $analise->cod_situacao = $_POST['cod_situacao'];
        
        if ($_FILES['arquivo_set']['error'] == UPLOAD_ERR_OK) {
            $tmpFile = $_FILES['arquivo_set']["tmp_name"];
            $analise->dados_configuracao = file_get_contents($tmpFile);
        }
        if ($_FILES['arquivo_html']['error'] == UPLOAD_ERR_OK) {
            $tmpFile = $_FILES['arquivo_html']["tmp_name"];
            $analise->dados_analise = file_get_contents($tmpFile);
        }
        if ($_FILES['arquivo_capital']['error'] == UPLOAD_ERR_OK) {
            $tmpFile = $_FILES['arquivo_capital']["tmp_name"];
            $nome_arquivo = basename($_FILES['arquivo_capital']["name"]);
            $imagem_capital = file_get_contents($tmpFile);
            $imagem_capital = base64_encode($imagem_capital);
            $analise->imagem_capital = chunk_split($imagem_capital, 76, "\r\n");
        }
        return $analise;
    }
    
    function pegarArquivo($nomeCampo) {
        $retorno = null;
        if ($_FILES[$nomeCampo]['error'] == UPLOAD_ERR_OK) {
            $tmpFile = $_FILES[$nomeCampo]["tmp_name"];
            $retorno = file_get_contents($tmpFile);
        }
        return $retorno;
    }
    
    function validar($analise) {
        if (!defined("ID_USUARIO"))
            throw new Exception("ID_USUARIO não definido!");
        $analise->id_usuario = ID_USUARIO;
        return $analise;
    }
    
    function inserir($analise) {
        $analise = $this->validar($analise);
        
        /*
        echo "<pre>";
        var_dump($analise);
        echo "</pre>";
        exit();
         */
        
        $query = "
            INSERT INTO analise (
                id_usuario,
                descricao,
                data_inicio,
                data_termino,
                ativo,
                deposito_inicial,
                ganho_total,
                negociacao_quantidade,
                volume_maximo,
                cod_situacao,
                imagem_capital,
                dados_configuracao,
                dados_analise
            ) VALUES (
                '".do_escape($analise->id_usuario)."',
                '".do_escape($analise->descricao)."',
                '".do_escape(dateToSql($analise->data_inicio))."',
                '".do_escape(dateToSql($analise->data_termino))."',
                '".do_escape($analise->ativo)."',
                '".do_escape_number($analise->deposito_inicial)."',
                '".do_escape_number($analise->ganho_total)."',
                '".do_escape_number($analise->negociacao_quantidade)."',
                '".do_escape_number($analise->volume_maximo)."',
                '".do_escape(ANALISE_SITUACAO_ATIVO)."',
                '".do_escape($analise->imagem_capital)."',
                '".do_escape($analise->dados_configuracao)."',
                '".do_escape($analise->dados_analise)."'
            )
        ";
        return do_insert($query);
    }
    
    function alterar($analise) {
        $analise = $this->validar($analise);
        $query = "
            UPDATE analise SET
                descricao = '".do_escape($analise->descricao)."',
                data_inicio = '".do_escape(dateToSql($analise->data_inicio))."',
                data_termino = '".do_escape(dateToSql($analise->data_termino))."',
                ativo = '".do_escape($analise->ativo)."',
                deposito_inicial = '".do_escape_number($analise->deposito_inicial)."',
                ganho_total = '".do_escape_number($analise->ganho_total)."',
                negociacao_quantidade = '".do_escape_number($analise->negociacao_quantidade)."',
                volume_maximo = '".do_escape_number($analise->volume_maximo)."',
                cod_situacao = '".do_escape($analise->cod_situacao)."',
                imagem_capital = '".do_escape($analise->imagem_capital)."',
                dados_configuracao = '".do_escape($analise->dados_configuracao)."',
                dados_analise = '".do_escape($analise->dados_analise)."'
            WHERE id_analise = '".do_escape($analise->id_analise)."'
        ";
        do_update($query);
    }
    
    function excluir($id_analise) {
        $query = "
            UPDATE analise SET
                cod_situacao = '".do_escape(ANALISE_SITUACAO_INATIVO)."'
            WHERE id_analise = '".do_escape($id_analise)."'
        ";
        do_update($query);
    }
    
}
