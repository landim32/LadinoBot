<?php

global $cnn;

$cnn = mysql_connect(DB_HOST, DB_USER, DB_PASS);
if (!$cnn)
    die('N&#227;o foi poss&#237;vel conectar: ' . mysql_error());
mysql_set_charset('utf8',$cnn);
mysql_select_db(DB_NAME);

if (EM_DESENVOLVIMENTO) {
    $GLOBALS['_SQL'] = array();
}

function write_db_log($query, $time) {
    if (EM_DESENVOLVIMENTO) {
        $log = new stdClass();
        $log->query = $query;
        $log->time = microtime(true) - $time;
        $GLOBALS['_SQL'][] = $log;
    }
}

function toUTF8($text) {
    $current_encoding = mb_detect_encoding($text, 'auto');
    $text = iconv($current_encoding, 'UTF-8', $text);
    return $text;
}

function get_result_db($query) {
    $result = mysql_query($query);
    if (!$result)
        die('A consulta falhou: ' . mysql_error().'<br />'.$query);
    return $result;
}

function get_object($result) {
    return mysql_fetch_object($result);
}

function free_result($result) {
    mysql_free_result($result);
}

function get_result($query) {
    $time = microtime(true);
    $retorno = array();
    $result = mysql_query($query);
    if (!$result)
        die('A consulta falhou: ' . mysql_error().'<br />'.$query);
    while ($row = mysql_fetch_object($result)) {
        $retorno[] = $row;
    }
    mysql_free_result($result);
    write_db_log($query, $time);
    return $retorno;
}

function get_result_with_id($query, $id) {
    $time = microtime(true);
    $retorno = array();
    $result = mysql_query($query);
    if (!$result)
        die('A consulta falhou: ' . mysql_error().'<br />'.$query);
    while ($row = mysql_fetch_object($result)) {
        $array = get_object_vars($row);
        $retorno[$array[$id]] = $row;
    }
    mysql_free_result($result);
    write_db_log($query, $time);
    return $retorno;
}

function get_result_as_list($query, $key, $field) {
    $time = microtime(true);
    $retorno = array();
    $result = mysql_query($query);
    if (!$result)
        die('A consulta falhou: ' . mysql_error().'<br />'.$query);
    while ($row = mysql_fetch_array($result)) {
        $retorno[$row[$key]] = $row[$field];
    }
    mysql_free_result($result);
    write_db_log($query, $time);
    return $retorno;
}

function get_result_as_string($query,$field) {
    $time = microtime(true);
    $retorno = array();
    $result = mysql_query($query);
    if (!$result)
        die('A consulta falhou: ' . mysql_error().'<br />'.$query);
    while ($row = mysql_fetch_array($result)) {
        $retorno[] = $row[$field];
    }
    mysql_free_result($result);
    write_db_log($query, $time);
    return $retorno;
}

function get_value($query,$field) {
    $time = microtime(true);
    $retorno = null;
    $result = mysql_query($query);
    if (!$result)
        die('A consulta falhou: ' . mysql_error().'<br />'.$query);
    if ($row = mysql_fetch_array($result))
        $retorno = $row[$field];
    mysql_free_result($result);
    write_db_log($query, $time);
    return $retorno;
}

function get_first_result($query) {
    $time = microtime(true);
    $retorno = null;
    $result = mysql_query($query);
    if (!$result)
        die('A consulta falhou: ' . mysql_error().'<br />'.$query);
    if ($row = mysql_fetch_object($result))
        $retorno = $row;
    mysql_free_result($result);
    write_db_log($query, $time);
    return $retorno;
}

function do_query($query) {
    $time = microtime(true);
    mysql_query($query);
    write_db_log($query, $time);
    if (mysql_errno())
        die('A consulta falhou: ' . mysql_error().'<br />'.$query);
}

function do_insert($query) {
    $time = microtime(true);
    mysql_query($query);
    write_db_log($query, $time);
    if (mysql_errno())
        die('A consulta falhou: ' . mysql_error().'<br />'.$query);
    return mysql_insert_id();
}

function do_update($query) {
    do_query($query);
}

function get_affected_rows() {
    return mysql_affected_rows();
}

function do_delete($query) {
    do_query($query);
}

function do_escape($texto) {
    //return mysql_real_escape_string(toUTF8($texto));
    return mysql_real_escape_string($texto);
}

function do_full_escape($texto) {
    //return mysql_real_escape_string(toUTF8($texto));
    if (isNullOrEmpty($texto))
        return 'NULL';
    else
        return "'".mysql_real_escape_string($texto)."'";
}

function do_escape_date($texto, $full = true) {
    if (isNullOrEmpty($texto))
        return 'NULL';
    else {
        $str = "";
        if ($full === true)
            $str .= "'";
        $str .= mysql_real_escape_string(date('Y-m-d 00:00:00', strtotime($texto)));
        if ($full === true)
            $str .= "'";
        return $str;
    }
}

function do_escape_number($texto) {
    $str = str_replace('.', '', $texto);
    $str = str_replace(',', '.', $str);
    $str = number_format(floatval($str), 2, '.', '');
    return mysql_real_escape_string($str);
}

function do_escape_datetime($texto, $full = true) {
    if (isNullOrEmpty($texto))
        return 'NULL';
    else {
        $str = "";
        if ($full === true)
            $str .= "'";
        $str .= mysql_real_escape_string(date('Y-m-d h:i:s', strtotime($texto)));
        if ($full === true)
            $str .= "'";
        return $str;
    }
}

function do_escape_bool($texto) {
    if (is_bool($texto))
        return ($texto) ? '1' : '0';
    else
        return (trim($texto) == '1' || trim(strtolower($texto)) == 'true') ? '1' : '0';
}

function do_bool($texto) {
    return do_escape_bool($texto);
}

?>
