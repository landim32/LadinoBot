<?php
require('core/config.inc.php');
require('core/functions.inc.php');
require('core/mysql-parser.inc.php');
require('core/usuario.inc.php');
require('core/analise.inc.php');

$regraUsuario = new Usuario();
$usuario = $regraUsuario->pegarAtual();
if (!is_null($usuario))
    define("ID_USUARIO", $usuario->id_usuario);

if (count($_POST) > 0 && $_POST['ac'] == "logar") {
    $usuario = $regraUsuario->login($_POST['email'], $_POST['senha']);
    if (!is_null($usuario)) {
        $regraUsuario->gravarSessao($usuario);
        header("Location: /");
        exit();
    }
}


