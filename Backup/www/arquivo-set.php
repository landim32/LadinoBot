<?php 
require('common.inc.php');

$id_analise = intval($_GET['analise']);
$regraAnalise = new Analise();
$analise = $regraAnalise->pegar($id_analise);

$filename = strtolower(sanitize_slug($analise->ativo.'-'.$analise->descricao)).".set";

header('Content-Description: File Transfer');
header('Content-Type: application/octet-stream');
header('Content-Disposition: attachment; filename='.$filename); 
header('Content-Transfer-Encoding: binary');
header('Connection: Keep-Alive');
header('Expires: 0');
header('Cache-Control: must-revalidate, post-check=0, pre-check=0');
header('Pragma: public');
header('Content-Length: ' . strlen($analise->dados_configuracao));
echo $analise->dados_configuracao;
