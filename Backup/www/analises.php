<?php 
require('common.inc.php'); 

define("PAGE_COUNT", 20);

$regraAnalise = new Analise();
$analises = $regraAnalise->listar();

$pg = intval($_GET['pg']);
$paginacao = admin_pagination(ceil(count($analises) / PAGE_COUNT));
$tabela = array_slice($analises, $pg * PAGE_COUNT, PAGE_COUNT);

require('header.inc.php');
require('menu-principal.inc.php');
//require('slideshow.inc.php'); 

?>
<div class="container" style="margin-top: 80px">
    <div class="row">
        <div class="col-md-9">
            <h2>Analíse de Resultados</h2><br />
            <div class="row">
                <?php $i = 0; ?>
                <?php foreach ($tabela as $analise) : ?>
                <?php $imagem = str_replace("\r\n", "", $analise->imagem_capital); ?>
                <div class="col-md-6" style="font-size: 80%">
                    <!--pre><?php //print_r($analise->configuracoes); ?></pre-->
                    <div class="panel panel-default">
                        <div class="panel-heading">
                            <span class="panel-title">
                                <a href="analise?analise=<?php echo $analise->id_analise; ?>">
                                    <i class="icon icon-line-chart"></i> <?php echo $analise->descricao; ?> (<?php echo $analise->ativo; ?>)
                                </a>
                            </span>
                        </div>
                        <div class="panel-body">
                            <a href="analise?analise=<?php echo $analise->id_analise; ?>">
                                <img src="data:image/png;base64,<?php echo $imagem; ?>" class="img-responsive" />
                            </a>
                            <div class="row">
                                <div class="col-md-3 text-right">Período:</div>
                                <div class="col-md-9" style="font-weight: bold">
                                    <?php echo date("d/m/Y", strtotime($analise->data_inicio)); ?> até
                                    <?php echo date("d/m/Y", strtotime($analise->data_termino)); ?>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-md-3 text-right">Inicial:</div>
                                <div class="col-md-3 text-right" style="font-weight: bold">
                                    <?php echo number_format($analise->deposito_inicial, 2, ",", "."); ?>
                                </div>
                                <div class="col-md-3 text-right">
                                    <?php if ($analise->total >= 0) : ?>
                                    <span class="text-success">Lucro:</span>
                                    <?php else : ?>
                                    <span class="text-danger">Prejuízo:</span>
                                    <?php endif; ?>
                                </div>
                                <div class="col-md-3 text-right" style="font-weight: bold">
                                    <?php if ($analise->total >= 0) : ?>
                                    <span class="text-success"><?php echo number_format($analise->total, 2, ",", "."); ?></span>
                                    <?php else : ?>
                                    <span class="text-danger"><?php echo number_format($analise->total, 2, ",", "."); ?></span>
                                    <?php endif; ?>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-md-3 text-right">Negociações:</div>
                                <div class="col-md-3 text-right" style="font-weight: bold">
                                    <?php echo number_format($analise->negociacao_quantidade, 0, ",", "."); ?>
                                </div>
                                <div class="col-md-3 text-right">Corretagem:</div>
                                <div class="col-md-3 text-right" style="font-weight: bold">
                                    <?php echo number_format($analise->corretagem_valor, 2, ",", "."); ?>
                                </div>
                            </div>
                            <div class="text-right" style="font-size: 80%">por <a href="analises?usuario=<?php echo $analise->id_usuario; ?>"><?php echo $analise->usuario_nome; ?></a></div>
                        </div>
                    </div>
                </div>
                <?php $i++; ?>
                <?php if ($i % 2 == 0) : ?>
            </div><div class="row">
                <?php endif; ?>
                <?php endforeach; ?>
            </div>
            <div class="text-right">
                <?php echo $paginacao; ?>
            </div>
        </div>
        <div class="col-md-3">
            <div class="list-group">
                <?php $ativos = $regraAnalise->listarAtivo(); ?>
                <?php foreach ($ativos as $ativo) : ?>
                <a href="analises?ativo=<?php echo urlencode($ativo->ativo); ?>" class="list-group-item<?php echo ($_GET['ativo'] == $ativo->ativo) ? " active"  : ""; ?>">
                    <span class="badge"><?php echo $ativo->quantidade; ?></span>
                    <?php echo $ativo->ativo; ?>
                </a>
                <?php endforeach; ?>
            </div>
        </div>
    </div>
</div>
<?php require('footer.inc.php'); ?>