<div class="panel panel-default">
    <div class="panel-heading">
        <h3 class="panel-title"><i class="icon icon-user"></i> Nova Conta</h3>
    </div>
    <div class="panel-body">
        <form class="form-horizontal" method="POST">
            <div class="form-group form-group-lg">
                <label for="email" class="col-sm-3 control-label">Email:</label>
                <div class="col-sm-9">
                    <input type="email" name="email" id="email" class="form-control" placeholder="Seu email" value="<?php echo $usuario->email; ?>">
                </div>
            </div>
            <div class="form-group form-group-lg">
                <label for="nome" class="col-sm-3 control-label">Nome:</label>
                <div class="col-sm-9">
                    <input type="nome" name="nome" id="nome" class="form-control" placeholder="Seu nome" value="<?php echo $usuario->nome; ?>">
                </div>
            </div>
            <div class="form-group form-group-lg">
                <label for="senha" class="col-sm-3 control-label">Senha:</label>
                <div class="col-sm-9">
                    <input type="password" name="senha" class="form-control" placeholder="Sua senha">
                </div>
            </div>
            <div class="form-group form-group-lg">
                <label for="senha_confirma" class="col-sm-3 control-label">Confirmar:</label>
                <div class="col-sm-9">
                    <input type="password" name="senha_confirma" class="form-control" placeholder="Confirmar senha">
                </div>
            </div>
            <div class="form-group">
                <div class="col-sm-offset-3 col-sm-9 text-right">
                    <button type="submit" class="btn btn-lg btn-primary"><i class="icon icon-user"></i> Criar Conta</button>
                </div>
            </div>
        </form>
    </div>
</div>
    