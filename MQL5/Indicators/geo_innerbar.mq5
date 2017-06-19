//+------------------------------------------------------------------+
//|                                                 Geo_InnerBar.mq5 |
//|                                  Copyright © 2012, Geokom FX Lab |
//|                                             geokom2004@yandex.ru |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2012, Geokom"
#property link      "geokom2004@yandex.ru"
//--- номер версии индикатора
#property version   "1.00"
//--- отрисовка индикатора в отдельном окне
#property indicator_separate_window 
//--- количество индикаторных буферов 1
#property indicator_buffers 1 
//--- использовано одно графическое построение
#property indicator_plots   1
//--- нижнее и верхнее ограничения шкалы отдельного окна индикатора
#property indicator_maximum +1.1
#property indicator_minimum +0.0
//+-----------------------------------+
//| Параметры отрисовки индикатора    |
//+-----------------------------------+
//--- отрисовка индикатора в виде гистограммы
#property indicator_type1   DRAW_HISTOGRAM
//--- в качестве цвета линии индикатора использован Coral цвет
#property indicator_color1 clrCoral
//--- линия индикатора - непрерывная кривая
#property indicator_style1  STYLE_SOLID
//--- толщина линии индикатора равна 3
#property indicator_width1  3
//--- отображение метки индикатора
#property indicator_label1  "Geo_InnerBar"
//+-----------------------------------+
//| объявление констант               |
//+-----------------------------------+
#define RESET 0 // Константа для возврата терминалу команды на пересчет индикатора
//+-----------------------------------+
//--- объявление динамических массивов, которые будут
//--- в дальнейшем использованы в качестве индикаторных буферов
double ExtBuffer[];
//--- Объявление целочисленных переменных начала отсчета данных
int  min_rates_total;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- инициализация переменных начала отсчета данных
   min_rates_total=int(2);
//--- превращение динамического массива в индикаторный буфер
   SetIndexBuffer(0,ExtBuffer,INDICATOR_DATA);
//--- индексация элементов в буфере как в таймсерии
   ArraySetAsSeries(ExtBuffer,true);
//--- осуществление сдвига начала отсчета отрисовки индикатора
   PlotIndexSetInteger(0,PLOT_DRAW_BEGIN,min_rates_total);
//--- установка значений индикатора, которые не будут видимы на графике
   PlotIndexSetDouble(0,PLOT_EMPTY_VALUE,0.0);
//--- создание имени для отображения в отдельном подокне и во всплывающей подсказке
   IndicatorSetString(INDICATOR_SHORTNAME,"Geo_InnerBar");
//--- определение точности отображения значений индикатора
   IndicatorSetInteger(INDICATOR_DIGITS,0);
//--- завершение инициализации
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+  
//| Custom indicator iteration function                              | 
//+------------------------------------------------------------------+  
int OnCalculate(const int rates_total,    // количество истории в барах на текущем тике
                const int prev_calculated,// количество истории в барах на предыдущем тике
                const datetime &time[],
                const double &open[],
                const double &high[],
                const double &low[],
                const double &close[],
                const long &tick_volume[],
                const long &volume[],
                const int &spread[])
  {
//--- проверка количества баров на достаточность для расчета
   if(rates_total<min_rates_total) return(RESET);
//--- объявления локальных переменных 
   int limit,bar;
//--- индексация элементов в массивах как в таймсериях  
   ArraySetAsSeries(high,true);
   ArraySetAsSeries(low,true);
//--- расчеты необходимого количества копируемых данных
//--- и стартового номера limit для цикла пересчета баров
   if(prev_calculated>rates_total || prev_calculated<=0)// проверка на первый старт расчета индикатора
     {
      limit=rates_total-min_rates_total-1; // стартовый номер для расчета всех баров
     }
   else limit=rates_total-prev_calculated; // стартовый номер для расчета новых баров
//--- первый цикл расчета индикатора
   for(bar=limit; bar>=0 && !IsStopped(); bar--)
     {
      if(high[bar]<high[bar+1] && low[bar]>low[bar+1]) ExtBuffer[bar]=1;
      else ExtBuffer[bar]=0.0;
     }
//---    
   return(rates_total);
  }
//+------------------------------------------------------------------+
