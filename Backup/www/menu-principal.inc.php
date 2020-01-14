<?php 
$regraUsuario = new Usuario();
$usuario = $regraUsuario->pegarAtual();

$current = basename($_SERVER['SCRIPT_NAME'], '.php');
?>
<div class="navbar-wrapper">
    <div class="container"> 
        <nav class="navbar navbar-inverse navbar-fixed-top">
            <div class="container">
                <div class="navbar-header">
                    <button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#navbar" aria-expanded="false" aria-controls="navbar">
                        <span class="sr-only">Toggle navigation</span>
                        <span class="icon-bar"></span>
                        <span class="icon-bar"></span>
                        <span class="icon-bar"></span>
                    </button>
                    <a class="navbar-brand" href="/">Ladino Metatrader EA</a>
                </div>
                <div id="navbar" class="navbar-collapse collapse">
                    <ul class="nav navbar-nav">
                        <li class="<?php echo ($current == "index") ? 'active': ''; ?>"><a href="/"><i class="icon icon-home"></i> Home</a></li>
                        <li class="<?php echo ($current == "downloads") ? 'active': ''; ?>"><a href="downloads"><i class="icon icon-download"></i> Downloads</a></li>
                        <li class="<?php echo ($current == "faq") ? 'active': ''; ?>"><a href="faq"><i class="icon icon-question"></i> Dúvidas</a></li>
                        <li class="<?php echo ($current == "analises") ? 'active': ''; ?>"><a href="analises"><i class="icon icon-line-chart"></i> Analíse de Resultados</a></li>
                        <!--li class="<?php echo ($current == "fale-conosco") ? 'active': ''; ?>"><a href="fale-conosco"><i class="icon icon-envelope"></i> Contato</a></li-->
                    </ul>
                    <?php if (!is_null($usuario)) : ?>
                    <ul class="nav navbar-nav navbar-right">
                        <li class="<?php echo ($current == "analise-novo") ? 'active': ''; ?>"><a href="analise-novo"><i class="icon icon-plus"></i> Nova Analíse</a></li>
                        <li class="<?php echo ($current == "usuario-alterar") ? 'active': ''; ?>" class="dropdown">
                            <a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-haspopup="true" aria-expanded="false">
                                <i class="icon icon-user"></i> <?php echo $usuario->nome; ?> <span class="caret"></span>
                            </a>
                            <ul class="dropdown-menu">
                                <li><a href="usuario-alterar">Alterar dados</a></li>
                                <li role="separator" class="divider"></li>
                                <li><a href="logout">Sair</a></li>
                            </ul>
                        </li>
                    </ul>
                    <?php endif; ?>
                </div>
            </div>
        </nav>
    </div>
</div>