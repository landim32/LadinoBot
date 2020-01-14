<?php 
$regraUsuario = new Usuario();
$usuario = $regraUsuario->pegarAtual();
?>
<?php if (is_null($usuario)) : ?>
<div class="panel panel-primary">
    <div class="panel-heading">
        <h3 class="panel-title"><i class="icon icon-user"></i> Login</h3>
    </div>
    <div class="panel-body">
        
        <form method="POST">
            <input type="hidden" name="ac" value="logar" />
            <div class="form-group">
                <div class="input-group">
                    <span class="input-group-addon"><i class="icon icon-envelope"></i></span>
                    <input type="text" class="form-control" name="email" placeholder="Email">
                </div>
            </div>
            <div class="form-group">
                <div class="input-group">
                    <span class="input-group-addon"><i class="icon icon-lock"></i></span>
                    <input type="password" class="form-control" name="senha" placeholder="Senha">
                </div>
            </div>
            <div class="row">
                <div class="col-md-6">
                    <a href="usuario-novo">Criar conta</a>
                </div>
                <div class="col-md-6 text-right">
                    <button type="submit" class="btn btn-primary"><i class="icon icon-user"></i> Entrar</button>
                </div>
            </div>
        </form>
    </div>
</div>
<?php endif; ?>