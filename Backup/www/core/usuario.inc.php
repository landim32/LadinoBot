<?php

define("USUARIO_SITUACAO_ATIVO", 1);
define("USUARIO_SITUACAO_INATIVO", 2);

class Usuario {
    
    function query(){
        $query = "
            SELECT
                id_usuario,
                nome,
                email,
                senha,
                cod_situacao
            FROM usuario
        ";
        return $query;
    }
    
    function pegar($id_usuario) {
        $query = $this->query()."
            WHERE id_usuario = '".do_escape($id_usuario)."'
        ";
        return get_first_result($query);
    }
    
    function login($email, $senha) {
        $query = $this->query()."
            WHERE email = '".do_escape(strtolower($email))."'
            AND senha = '".do_escape($senha)."'
        ";
        return get_first_result($query);
    }
    
    function pegarDoPost() {
        $usuario = new stdClass();
        if (array_key_exists('email', $_POST))
            $usuario->email = $_POST['email'];
        if (array_key_exists('nome', $_POST))
            $usuario->nome = $_POST['nome'];
        if (array_key_exists('senha', $_POST))
            $usuario->senha = $_POST['senha'];
        if (array_key_exists('senha_confirma', $_POST))
            $usuario->senha_confirma = $_POST['senha_confirma'];
        return $usuario;
    }
    
    function validar($usuario) {
        if ($usuario == null)
            throw new Exception("Dados de usuário não informado!");
        if (isNullOrEmpty($usuario->email))
            throw new Exception("Preencha o email!");
        //die(validarEmail($usuario->email));
        //if (!validarEmail($usuario->email))
        //    throw new Exception("Email inválido!");
        if (isNullOrEmpty($usuario->nome))
            throw new Exception("Preencha o seu nome!");
        if (isNullOrEmpty($usuario->senha))
            throw new Exception("Preencha a senha!");
        if (isNullOrEmpty($usuario->senha_confirma))
            throw new Exception("Preencha a confirmação da senha!");
        if ($usuario->senha != $usuario->senha_confirma)
            throw new Exception("A senha não bate com a confirmação!");
        $usuario->email = strtolower($usuario->email);
        return $usuario;
    }
    
    function inserir($usuario) {
        $usuario = $this->validar($usuario);
        $query = "
            INSERT INTO usuario (
                nome,
                email,
                senha,
                cod_situacao
            ) VALUES (
                '".do_escape($usuario->nome)."',
                '".do_escape($usuario->email)."',
                '".do_escape($usuario->senha)."',
                '".do_escape(USUARIO_SITUACAO_ATIVO)."'
            )
        ";
        return do_insert($query);
    }
    
    function alterar($usuario) {
        $usuario = $this->validar($usuario);
        $query = "
            UPDATE usuario SET
                nome = '".do_escape($usuario->nome)."',
                email = '".do_escape($usuario->email)."',
                senha = '".do_escape($usuario->senha)."',
                cod_situacao = '".do_escape($usuario->cod_situacao)."'
            WHERE id_usuario = '".do_escape($usuario->id_usuario)."'
        ";
        do_update($query);
    }
    
    function excluir($id_usuario) {
        $query = "
            UPDATE usuario SET
                cod_situacao = '".do_escape(USUARIO_SITUACAO_INATIVO)."'
            WHERE id_usuario = '".do_escape($id_usuario)."'
        ";
        do_update($query);        
    }
    
    function pegarAtual() {
        return $_SESSION['usuario_atual'];
    }
    
    function gravarSessao($usuario) {
        define("ID_USUARIO", $usuario->id_usuario);
        $_SESSION['usuario_atual'] = $usuario;
    }
    
    function fecharSessao() {
        unset($_SESSION['usuario_atual']);
    }
}

