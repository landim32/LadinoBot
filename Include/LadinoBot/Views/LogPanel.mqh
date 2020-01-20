//+------------------------------------------------------------------+
//|                                                     LogPanel.mqh |
//|                                                   Rodrigo Landim |
//|                                        http://www.emagine.com.br |
//+------------------------------------------------------------------+
#property copyright "Rodrigo Landim"
#property link      "http://www.emagine.com.br"
#property version   "1.00"
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class LogPanel {
   private:
      string _logs[20];
      void criarLabel(const string nome, const string texto, const int y);
   public:
      LogPanel();
      ~LogPanel();
      void inicializar();
      void adicionarLog(const string texto);
};
  
LogPanel::LogPanel() {
}

LogPanel::~LogPanel() {
}
//+------------------------------------------------------------------+

void LogPanel::criarLabel(const string nome, const string texto, const int y) {
   ObjectCreate(0, nome, OBJ_LABEL,0,0,0);           
   ObjectSetInteger(0, nome, OBJPROP_XDISTANCE, 5);
   ObjectSetInteger(0, nome, OBJPROP_YDISTANCE, y);
   ObjectSetInteger(0, nome, OBJPROP_XSIZE, 700);
   ObjectSetInteger(0, nome, OBJPROP_COLOR, clrWhiteSmoke);
   ObjectSetString(0, nome, OBJPROP_TEXT, texto);
   ObjectSetString(0, nome, OBJPROP_FONT, "Tahoma");
   ObjectSetInteger(0, nome, OBJPROP_FONTSIZE, 7);
   ObjectSetInteger(0, nome, OBJPROP_SELECTABLE, false);   
}

void LogPanel::inicializar() {
   
   int i, y = 20;
   for (i = 1; i <= ArraySize(_logs); i++) {
      criarLabel("linha" + IntegerToString(i), ".", y);
      y += 12;
   }
   for (i = 0; i < ArraySize(_logs); i++)
      _logs[i] = ".";
}

void LogPanel::adicionarLog(const string texto) {
   MqlDateTime tempo;
   TimeToStruct(TimeCurrent(), tempo);
   string str = "";
   str += (tempo.hour > 9) ? IntegerToString(tempo.hour) : "0" + IntegerToString(tempo.hour);
   str += ":";
   str += (tempo.min > 9) ? IntegerToString(tempo.min) : "0" + IntegerToString(tempo.min);
   str += ". " + texto;
   Print(_logs[0]);
   string nome = "";
   int i;
   for (i = 2; i <= ArraySize(_logs); i++) {
      _logs[i-2] = _logs[i-1];
   }
   _logs[ArraySize(_logs) - 1] = str;
   
   for (i = 1; i <= ArraySize(_logs); i++) {
      nome = "linha" + IntegerToString(i);
      ObjectSetString(0, nome, OBJPROP_TEXT, _logs[i - 1]);
   }
   
   ChartRedraw(0);
}