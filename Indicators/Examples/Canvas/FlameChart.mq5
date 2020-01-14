//+------------------------------------------------------------------+
//|                                                   FlameChart.mq5 |
//|                   Copyright 2009-2017, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright   "2009-2017, MetaQuotes Software Corp."
#property link        "http://www.mql5.com"
#include <Canvas\FlameCanvas.mqh>
//+------------------------------------------------------------------+
//| Indicator properties                                             |
//+------------------------------------------------------------------+
#property indicator_chart_window
#property indicator_buffers 0
#property indicator_plots   0
//+------------------------------------------------------------------+
//| Input parameters                                                 |
//+------------------------------------------------------------------+
input  int        InpFuturefBars     =50;
//+------------------------------------------------------------------+
//| global variables                                                 |
//+------------------------------------------------------------------+
CFlameCanvas      ExtCanvas;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
   if(!ExtCanvas.FlameCreate("FlameChart",TimeCurrent(),InpFuturefBars,0))
      return(INIT_FAILED);
//--- succeed
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int OnCalculate(const int      rates_total,
                const int      prev_calculated,
                const datetime &time[],
                const double   &open[],
                const double   &high[],
                const double   &low[],
                const double   &close[],
                const long     &tick_volume[],
                const long     &volume[],
                const int      &spread[])
  {
   datetime xb1=time[rates_total-1];
   double   yb1=high[rates_total-1];
   datetime xe1=xb1+InpFuturefBars*PeriodSeconds();
   double   ye1=ChartGetDouble(0,CHART_PRICE_MAX);
   datetime xb2=xb1;
   double   yb2=low[rates_total-1];
   datetime xe2=xe1;
   double   ye2=ChartGetDouble(0,CHART_PRICE_MIN);
//--- "nozzle" is defined using two lines: ((xb1,yb1),(xe1,ye1)) and ((xb2,yb2),(xe2,ye2))
   ExtCanvas.FlameSet(xb1,yb1,xe1,ye1,xb2,yb2,xe2,ye2);
//--- result
   return(rates_total);
  }
//+------------------------------------------------------------------+
//| Custom indicator chart's event handler                           |
//+------------------------------------------------------------------+
void OnChartEvent(const int id,const long& lparam,const double& dparam,const string& sparam)
  {
   ExtCanvas.ChartEventHandler(id,lparam,dparam,sparam);
  }
//+------------------------------------------------------------------+
