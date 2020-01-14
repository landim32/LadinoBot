<?php 
require('common.inc.php'); 
$regraUsuario = new Usuario();
$regraUsuario->fecharSessao();
header("Location: /");
exit();
