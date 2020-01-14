<?php 
require('common.inc.php');

$regraUsuario = new Usuario();

if (count($_POST) > 0) {
    try {
        $usuario = $regraUsuario->pegarDoPost();
        $usuario->id_usuario = $regraUsuario->inserir($usuario);
        $regraUsuario->gravarSessao($usuario);
    }
    catch (Exception $e) {
        $msgerro = $e->getMessage();
    }
}

require('header.inc.php');
require('menu-principal.inc.php');
require('slideshow.inc.php');    
?>

<div class="container marketing">
    <div class="row">
        <div class="col-md-8">
            <?php if (isset($msgerro)) : ?>
            <div class="alert alert-danger alert-dismissible" role="alert">
                <button type="button" class="close" data-dismiss="alert" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <i class="icon icon-warning"></i> <strong>Erro!</strong> <?php echo $msgerro; ?>
            </div>
            <?php endif; ?>
            <?php require('usuario-form.inc.php'); ?>
        </div>
        <div class="col-md-4">
            <?php require('sidebar-home.inc.php'); ?>
        </div>
    </div>
</div>
<?php require('footer.inc.php'); ?>