<?php
error_reporting(E_ALL ^ E_NOTICE ^ E_DEPRECATED);
setlocale(LC_ALL, 'pt_BR', 'pt_BR.utf-8', 'pt_BR.utf-8', 'portuguese');
date_default_timezone_set('America/Sao_Paulo');

define('DB_HOST', 'localhost');
define('DB_USER', 'root');
define('DB_PASS', 'eaa69cpxy2');
define('DB_NAME', 'ladinobot');

session_start();