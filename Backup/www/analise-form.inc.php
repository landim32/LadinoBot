<?php 
$id_analise = intval($_GET['analise']);    
$regraAnalise = new Analise();
$analise = null;
if ($id_analise > 0)
    $analise = $regraAnalise->pegar($id_analise);
?>
<form class="form-horizontal" method="POST" enctype="multipart/form-data">    
<?php if (!is_null($analise)) : ?>
<input type="hidden" name="id_analise" value="<?php echo $analise->id_analise; ?>" />
<?php endif; ?>
<div class="row">
    <div class="col-md-8">
        <div class="panel panel-default">
            <div class="panel-heading">
                <h3 class="panel-title"><i class="icon icon-print"></i> Dados na Analíse</h3>
            </div>
            <div class="panel-body">
                <div class="form-group">
                    <label class="col-md-3 control-label">Descrição:</label>
                    <div class="col-md-9">
                        <input type="text" name="descricao" class="form-control" value="<?php echo (!is_null($analise)) ? $analise->descricao : ''; ?>" />
                    </div>
                </div>
                <div class="form-group">
                    <label class="col-md-3 control-label">Arquivo .SET:</label>
                    <div class="col-md-9">
                        <input type="file" name="arquivo_set" class="form-control" />
                        <span class="help-block">Arquivo de configuração da estratégia.</span>
                    </div>
                </div>
                <div class="form-group">
                    <label class="col-md-3 control-label">Arquivo .HTML:</label>
                    <div class="col-md-9">
                        <input type="file" name="arquivo_html" class="form-control" />
                        <span class="help-block">Arquivo HTML gerado pelo relatório.</span>
                    </div>
                </div>
                <div class="form-group">
                    <label class="col-md-3 control-label">Curva de Capital:</label>
                    <div class="col-md-9">
                        <input type="file" name="arquivo_capital" class="form-control" />
                        <span class="help-block">Imagem da curva de capital (ex: ReportTester-????.png).</span>
                    </div>
                </div>
                <!--div class="form-group">
                    <label class="col-md-3 control-label">Imagem Holding:</label>
                    <div class="col-md-9">
                        <input type="file" name="arquivo_holding" class="form-control" />
                        <span class="help-block">Imagem Holding (ex: ReportTester-????-holding.png).</span>
                    </div>
                </div>
                <div class="form-group">
                    <label class="col-md-3 control-label">Imagem hst:</label>
                    <div class="col-md-9">
                        <input type="file" name="arquivo_hst" class="form-control" />
                        <span class="help-block">Imagem hst (ex: ReportTester-????-hst.png).</span>
                    </div>
                </div>
                <div class="form-group">
                    <label class="col-md-3 control-label">Imagem mfemae:</label>
                    <div class="col-md-9">
                        <input type="file" name="arquivo_mfemae" class="form-control" />
                        <span class="help-block">Imagem mfemae (ex: ReportTester-????-mfemae.png).</span>
                    </div>
                </div-->
            </div>
        </div>
    </div>
    <div class="col-md-4">
        <div class="panel panel-default">
            <div class="panel-heading">
                <h3 class="panel-title"><i class="icon icon-print"></i> Opções</h3>
            </div>
            <div class="panel-body">
                <div class="form-group">
                    <label class="col-md-5 control-label">Ativo:</label>
                    <div class="col-md-7">
                        <input type="text" class="form-control" name="ativo" value="WINFUT" value="<?php echo (!is_null($analise)) ? $analise->ativo : ''; ?>" placeholder="Ex: WINFUT, WDOFUT" />
                    </div>
                </div>
                <div class="form-group">
                    <label class="col-md-5 control-label">Início:</label>
                    <div class="col-md-7">
                        <input type="text" class="form-control" name="data_inicio" value="<?php echo (!is_null($analise)) ? date('d/m/Y', strtotime($analise->data_inicio)) : date("d/m/Y"); ?>" placeholder="Começo da operação" />
                    </div>
                </div>
                <div class="form-group">
                    <label class="col-md-5 control-label">Término:</label>
                    <div class="col-md-7">
                        <input type="text" class="form-control" name="data_termino"value="<?php echo (!is_null($analise)) ? date('d/m/Y', strtotime($analise->data_termino)) : date("d/m/Y"); ?>" placeholder="Término da operação" />
                    </div>
                </div>
                <div class="form-group">
                    <label class="col-md-5 control-label">Valor Inicial:</label>
                    <div class="col-md-7">
                        <input type="text" class="form-control" name="deposito_inicial" value="<?php echo (!is_null($analise)) ? number_format($analise->deposito_inicial, 2, ',', '.') : '0,00'; ?>" placeholder="Término da operação" />
                    </div>
                </div>
                <div class="form-group">
                    <label class="col-md-5 control-label">Lucro Total:</label>
                    <div class="col-md-7">
                        <input type="text" class="form-control" name="ganho_total" value="<?php echo (!is_null($analise)) ? number_format($analise->ganho_total, 2, ',', '.') : '0,00'; ?>" placeholder="Lucro da operação" />
                    </div>
                </div>
                <div class="form-group">
                    <label class="col-md-5 control-label">Negociações:</label>
                    <div class="col-md-7">
                        <input type="text" class="form-control" name="negociacao_quantidade" value="<?php echo (!is_null($analise)) ? number_format($analise->negociacao_quantidade, 2, ',', '.') : '0,00'; ?>" placeholder="Gasto total com corretagem" />
                    </div>
                </div>
                <!--div class="form-group">
                    <label class="col-md-5 control-label">Vlr. Corretagem:</label>
                    <div class="col-md-7">
                        <input type="text" class="form-control" name="corretagem_valor" value="<?php echo (!is_null($analise)) ? number_format($analise->corretagem_valor, 2, ',', '.') : '0,00'; ?>" placeholder="Taxa de corretagem" />
                    </div>
                </div-->
                <div class="form-group">
                    <label class="col-md-5 control-label">Volume Máximo:</label>
                    <div class="col-md-7">
                        <input type="text" class="form-control" name="volume_maximo" value="<?php echo (!is_null($analise)) ? number_format($analise->volume_maximo, 2, ',', '.') : '0,00'; ?>" placeholder="Volume máximo operado" />
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
<div class="row">
    <div class="col-md-12 text-right">
        <button type="submit" class="btn btn-lg btn-primary">
            <i class="icon icon-line-chart"></i> <?php echo (!is_null($analise)) ? 'Alterar Analíse' : 'Criar Analíse'; ?>
        </button>
    </div>
</div>
</form>