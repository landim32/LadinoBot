<?php 
require('common.inc.php'); 

$id_analise = intval($_GET['analise']);
$regraAnalise = new Analise();
$analise = $regraAnalise->pegar($id_analise);

require('header.inc.php');
require('menu-principal.inc.php');
//require('slideshow.inc.php'); 

?>
<style type="text/css">
    .dados-analise {
        font-size: 80%;
        text-align: center;
    }
    .dados-analise table {
        width: 100%;
    }
    .dados-analise img {
        margin: 0 auto;
        display: block;
    }
</style>
<div class="container dados-analise" style="margin-top: 80px">
    <div class="pull-right">
        <div class="btn-group" role="group">
            <a href="arquivo-set?analise=<?php echo $analise->id_analise; ?>" class="btn btn-primary"><i class="icon icon-download"></i> Baixar .SET</a>
            <?php if ($analise->id_usuario == ID_USUARIO) : ?>
            <a href="analise-alterar?analise=<?php echo $analise->id_analise; ?>" class="btn btn-default"><i class="icon icon-pencil"></i> Alterar</a>
            <?php endif; ?>
        </div>
    </div>
    <?php echo $analise->dados_analise; ?>
</div>
<?php require('footer.inc.php'); ?>