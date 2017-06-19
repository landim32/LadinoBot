<?php 
require('common.inc.php');

if (count($_POST) > 0) {
    try {
        $regraAnalise = new Analise();
        $id_analise = intval($_GET['analise']); 
        $analise = $regraAnalise->pegarDoPost();
        if ($id_analise > 0) {
            $analise = $regraAnalise->pegar($id_analise);
            $analise = $regraAnalise->pegarDoPost($analise);
            $regraAnalise->alterar($analise);
        }
        else {
            $analise = $regraAnalise->pegarDoPost();
            $analise->id_analise = $regraAnalise->inserir($analise);
        }
    }
    catch (Exception $e) {
        $msgerro = $e->getMessage();
    }
}

require('header.inc.php');
require('menu-principal.inc.php');
//require('slideshow.inc.php');
?>

<div class="container marketing" style="margin-top: 80px">
    <?php if (isset($msgerro)) : ?>
    <div class="alert alert-danger alert-dismissible" role="alert">
        <button type="button" class="close" data-dismiss="alert" aria-label="Close"><span aria-hidden="true">&times;</span></button>
        <i class="icon icon-warning"></i> <strong>Erro!</strong> <?php echo $msgerro; ?>
    </div>
    <?php endif; ?>
    <?php require('analise-form.inc.php'); ?>
</div>
<?php require('footer.inc.php'); ?>