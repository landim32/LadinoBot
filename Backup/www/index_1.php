<!DOCTYPE html>
<html lang="pt-BR">
  <head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="description" content="">
    <meta name="author" content="">
    <link rel="icon" href="images/favicon.ico">

    <title>Ladino Metatrader Robot</title>

    <!-- Bootstrap core CSS -->
    <link href="css/ladinobot.min.css" rel="stylesheet">

    <!-- IE10 viewport hack for Surface/desktop Windows 8 bug -->
    <link href="css/ie10-viewport-bug-workaround.css" rel="stylesheet">

    <!-- Just for debugging purposes. Don't actually copy these 2 lines! -->
    <!--[if lt IE 9]><script src="../../assets/js/ie8-responsive-file-warning.js"></script><![endif]-->
    <script src="js/ie-emulation-modes-warning.js"></script>

    <!-- HTML5 shim and Respond.js for IE8 support of HTML5 elements and media queries -->
    <!--[if lt IE 9]>
      <script src="https://oss.maxcdn.com/html5shiv/3.7.2/html5shiv.min.js"></script>
      <script src="https://oss.maxcdn.com/respond/1.4.2/respond.min.js"></script>
    <![endif]-->

    <!-- Custom styles for this template -->
    <link href="css/carousel.css" rel="stylesheet">
</head>
<body>
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
                    <a class="navbar-brand" href="#">Ladino Metatrader EA</a>
                </div>
                <div id="navbar" class="navbar-collapse collapse">
                    <ul class="nav navbar-nav">
                        <li class="active"><a href="#">Home</a></li>
                        <li><a href="#about">Downloads</a></li>
                        <li><a href="#contact">Dúvidas</a></li>
                        <li><a href="#contact">Contato</a></li>
                <!--li class="dropdown">
                  <a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-haspopup="true" aria-expanded="false">Dropdown <span class="caret"></span></a>
                  <ul class="dropdown-menu">
                    <li><a href="#">Action</a></li>
                    <li><a href="#">Another action</a></li>
                    <li><a href="#">Something else here</a></li>
                    <li role="separator" class="divider"></li>
                    <li class="dropdown-header">Nav header</li>
                    <li><a href="#">Separated link</a></li>
                    <li><a href="#">One more separated link</a></li>
                  </ul>
                </li-->
                    </ul>
                </div>
            </div>
        </nav>
    </div>
</div>
    
<div id="myCarousel" class="carousel slide" data-ride="carousel">
    <ol class="carousel-indicators">
        <li data-target="#myCarousel" data-slide-to="0" class="active"></li>
        <!--li data-target="#myCarousel" data-slide-to="1"></li>
        <li data-target="#myCarousel" data-slide-to="2"></li-->
    </ol>
    <div class="carousel-inner" role="listbox">
        <div class="item active">
            <img class="first-slide" src="images/forex2.jpg" alt="First slide">
            <div class="container">
                <div class="carousel-caption">
                    <div class="row">
                        <div class="col-md-6">
                            <h1>LadinoBot 1.0</h1>
                            <p>Baixe gratuitamente e use à vontade!</p>
                            <p><a class="btn btn-lg btn-success" href="#" role="button">Baixe aqui!</a></p>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <!--div class="item">
          <img class="second-slide" src="data:image/gif;base64,R0lGODlhAQABAIAAAHd3dwAAACH5BAAAAAAALAAAAAABAAEAAAICRAEAOw==" alt="Second slide">
          <div class="container">
            <div class="carousel-caption">
              <h1>Another example headline.</h1>
              <p>Cras justo odio, dapibus ac facilisis in, egestas eget quam. Donec id elit non mi porta gravida at eget metus. Nullam id dolor id nibh ultricies vehicula ut id elit.</p>
              <p><a class="btn btn-lg btn-primary" href="#" role="button">Learn more</a></p>
            </div>
          </div>
        </div>
        <div class="item">
          <img class="third-slide" src="data:image/gif;base64,R0lGODlhAQABAIAAAHd3dwAAACH5BAAAAAAALAAAAAABAAEAAAICRAEAOw==" alt="Third slide">
          <div class="container">
            <div class="carousel-caption">
              <h1>One more for good measure.</h1>
              <p>Cras justo odio, dapibus ac facilisis in, egestas eget quam. Donec id elit non mi porta gravida at eget metus. Nullam id dolor id nibh ultricies vehicula ut id elit.</p>
              <p><a class="btn btn-lg btn-primary" href="#" role="button">Browse gallery</a></p>
            </div>
          </div>
        </div-->
    </div>
    <a class="left carousel-control" href="#myCarousel" role="button" data-slide="prev">
        <span class="glyphicon glyphicon-chevron-left" aria-hidden="true"></span>
        <span class="sr-only">Anterior</span>
    </a>
    <a class="right carousel-control" href="#myCarousel" role="button" data-slide="next">
        <span class="glyphicon glyphicon-chevron-right" aria-hidden="true"></span>
        <span class="sr-only">Prôximo</span>
    </a>
</div><!-- /.carousel -->

<div class="container marketing">
    <div class="row">
        <div class="col-lg-4">
            <img class="img-circle" src="data:image/gif;base64,R0lGODlhAQABAIAAAHd3dwAAACH5BAAAAAAALAAAAAABAAEAAAICRAEAOw==" alt="Generic placeholder image" width="140" height="140">
            <h2>Heading</h2>
            <p>Donec sed odio dui. Etiam porta sem malesuada magna mollis euismod. Nullam id dolor id nibh ultricies vehicula ut id elit. Morbi leo risus, porta ac consectetur ac, vestibulum at eros. Praesent commodo cursus magna.</p>
            <p><a class="btn btn-default" href="#" role="button">View details &raquo;</a></p>
        </div><!-- /.col-lg-4 -->
        <div class="col-lg-4">
            <img class="img-circle" src="data:image/gif;base64,R0lGODlhAQABAIAAAHd3dwAAACH5BAAAAAAALAAAAAABAAEAAAICRAEAOw==" alt="Generic placeholder image" width="140" height="140">
            <h2>Heading</h2>
            <p>Duis mollis, est non commodo luctus, nisi erat porttitor ligula, eget lacinia odio sem nec elit. Cras mattis consectetur purus sit amet fermentum. Fusce dapibus, tellus ac cursus commodo, tortor mauris condimentum nibh.</p>
            <p><a class="btn btn-default" href="#" role="button">View details &raquo;</a></p>
        </div><!-- /.col-lg-4 -->
        <div class="col-lg-4">
            <img class="img-circle" src="data:image/gif;base64,R0lGODlhAQABAIAAAHd3dwAAACH5BAAAAAAALAAAAAABAAEAAAICRAEAOw==" alt="Generic placeholder image" width="140" height="140">
            <h2>Heading</h2>
            <p>Donec sed odio dui. Cras justo odio, dapibus ac facilisis in, egestas eget quam. Vestibulum id ligula porta felis euismod semper. Fusce dapibus, tellus ac cursus commodo, tortor mauris condimentum nibh, ut fermentum massa justo sit amet risus.</p>
            <p><a class="btn btn-default" href="#" role="button">View details &raquo;</a></p>
        </div><!-- /.col-lg-4 -->
    </div><!-- /.row -->

    <hr class="featurette-divider" />

    <div class="row">
        <div class="col-md-9">
            <p>
                LadinoBot é um Expert Advisor (Robô) para Metatrader 5. Com ele você pode ter uma ferramenta trabalhando 
                para você.
            </p>
            <p>
                LadinoHiLo make entries using the HiLo and a configurable moving average. In short, when the HiLo changes 
                and candle crosses the moving average operation is started.
            </p>
            <p>
                Other conditions can be included to initialize the operation. LadinoHiLo can wait for break of a
                trendline on a chart less time to start operation.
            </p>
            <p>
                The stop can be configured in different ways to go watching the HiLo go following new tops / funds, 
                candles previous, current candles, etc. Including using different graphics times.
            </p>
            <p>You can set a Break Even by putting a value to be added.</p>
            <p>
                You can also select up to three financial goals that can be configured for fixed or through 
                fibonnachi retraction. Financial volumes and different types of stop can be configured individually 
                for each goal.
            </p>
            <ul>
                <li>Start Time - Start time of operations;</li>
                <li>Closing Time - Time where no new operation will be initialized. Operations that are still open, still open;</li>
                <li>Exit Time - completion schedule of operations. All open positions will be finalized in the market price;</li>
                <li>Operation type - Types of supported operations: Buy and Sell; Only Buy: Sell or only;</li>
                <li>Asset type - asset type to be negotiated, it is an Index or Stock. If Index, the brokerage fee for contact. If Stock, the brokerage will be charged only way, regardless of the volume;</li>
                <li>Brokerage value - Value brokerage bought. If the asset type is Index, the brokerage fee for contact. If Stock, the brokerage will be charged only way, regardless of the volume;</li>
                <li>Value per point - Financial value per point won or lost;</li>
                <li>T2 Graph Extra - Use extra Graph T2. Yes or no;</li>
                <li>T2 Time Graph - Graphic Time T2. Default: 15 minutes;</li>
                <li>T2 HiLo Periods - Number of periods used in the T2 chart HiLo;</li>
                <li>T2 HiLo define trend - only comes into operation if the T2 HiLo is favorable;</li>
                <li>T2 Moving average - periods Amount of the moving average used in the T2 chart;</li>
                <li>T3 Graph Options - The same options T2 chart are also available for T3;</li>
                <li>Stop Loss Min - Minimum value of input price difference to Stop Home;</li>
                <li>Stop Loss Max - Maximum value of input price difference to Stop Home. If Force entry is idle and the maximum value is not reached, the operation is not initialized;</li>
                <li>Stop Extra - extra value added to the Stop Loss;</li>
                <li>Initial Stop - Stop type using initially. Types of Stop Loss Mobile are Fixed stop, HiLo, tops / funds, previous and current candles;</li>
                <li>Stop fixed value - Fixed value Initial Stop Loss if the initial Stop is marked Stop Fixed;</li>
                <li>Force entry - If you are active, the operation will be initialized even if the Stop Loss be greater than the Max Stop Loss. But the stop value will not pass the Stop Loss Max;</li>
                <li>Trendline Extra - Extra Value added the trend line to start operation;</li>
                <li>Daily Max Gain - Maximum amount of daily financial gain;</li>
                <li>Daily Max Loss - Maximum amount of daily financial loss;</li>
                <li>Operation Max Gain - Maximum amount of financial gain in a single operation;</li>
                <li>Run Position Increase - Use the increase position. Each increase will be set on the objectives;</li>
                <li>Run Position Stop Extra - Extra Value added in the movement of Stop Loss (just in case of increasing the position);</li>
                <li>Run Position Increase Minimal - Minimum value that the price should go for the position is increased;</li>
                <li>Break Even Position - Value in which the Stop Loss is taken to Break Even (price + Break Even Value);</li>
                <li>Break Even Value - Value added to the price where the Break Even is moved;</li>
                <li>Break Even Volume - Volume which is held or increased when the atinguir Break Even;</li>
                <li>Initial Volume - Volume to start operation;</li>
                <li>Max Volume - Maximum volume of the operation. If the Run Position Increase is enabled, the volume may not pass this value;</li>
                <li>Objective 1 Condition - condition for the objective 1 is achieved. The options are Fixed Position, Trendline Break, etc;</li>
                <li>Objective 1 Volume - If positive, the position will be increased to atinguir this goal. If negative, the position will be held;</li>
                <li>Objective 1 Position - If the condition is marked as Fixed Position, this amount plus the price is the position where the goal is atinguido;</li>
                <li>Objective 1 Stop - Stop type used starting point that atinguir the goal. See the Stop Home;</li>
                <li>Objective 2 and 3 Options - The same options are also available for the Goals 2 and 3;</li>
                <li>Risk management - Defines risk management. The options are Normal and Progressive;</li>
                <li>Input condition - Here you define the conditions of entry. The options are HiLo / MM T2, T3, Tick or/and Close.</li>
            </ul>
        </div>
        <div class="col-md-3">
            
        </div>
    </div>
    
    <hr class="featurette-divider" />

    <div class="row featurette">
        <div class="col-md-7">
            <h2 class="featurette-heading">First featurette heading. <span class="text-muted">It'll blow your mind.</span></h2>
            <p class="lead">Donec ullamcorper nulla non metus auctor fringilla. Vestibulum id ligula porta felis euismod semper. Praesent commodo cursus magna, vel scelerisque nisl consectetur. Fusce dapibus, tellus ac cursus commodo.</p>
        </div>
        <div class="col-md-5">
            <img class="featurette-image img-responsive center-block" data-src="holder.js/500x500/auto" alt="Generic placeholder image">
        </div>
    </div>

    <hr class="featurette-divider" />

    <div class="row featurette">
        <div class="col-md-7 col-md-push-5">
            <h2 class="featurette-heading">Oh yeah, it's that good. <span class="text-muted">See for yourself.</span></h2>
            <p class="lead">Donec ullamcorper nulla non metus auctor fringilla. Vestibulum id ligula porta felis euismod semper. Praesent commodo cursus magna, vel scelerisque nisl consectetur. Fusce dapibus, tellus ac cursus commodo.</p>
        </div>
        <div class="col-md-5 col-md-pull-7">
            <img class="featurette-image img-responsive center-block" data-src="holder.js/500x500/auto" alt="Generic placeholder image">
        </div>
    </div>

    <hr class="featurette-divider">

    <div class="row featurette">
        <div class="col-md-7">
            <h2 class="featurette-heading">And lastly, this one. <span class="text-muted">Checkmate.</span></h2>
            <p class="lead">Donec ullamcorper nulla non metus auctor fringilla. Vestibulum id ligula porta felis euismod semper. Praesent commodo cursus magna, vel scelerisque nisl consectetur. Fusce dapibus, tellus ac cursus commodo.</p>
        </div>
        <div class="col-md-5">
            <img class="featurette-image img-responsive center-block" data-src="holder.js/500x500/auto" alt="Generic placeholder image">
        </div>
    </div>

    <hr class="featurette-divider">

    <footer>
        <p class="pull-right"><a href="#">Back to top</a></p>
        <p>&copy; 2016 Company, Inc. &middot; <a href="#">Privacy</a> &middot; <a href="#">Terms</a></p>
    </footer>

</div><!-- /.container -->
<script src="js/jquery.min.js"></script>
<script src="js/bootstrap.min.js"></script>
<script src="js/holder.min.js"></script>
<script src="js/ie10-viewport-bug-workaround.js"></script>
</body>
</html>
