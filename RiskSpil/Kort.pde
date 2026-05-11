class Kort  {
  
  int value = 1;
  int maxValue = 5;
  float x, y;
  color farve;
  int AntalSider;
 
  
  Kort(float x_,float y_,int antalSider) {
    x=x_;
    y=y_;
    AntalSider = antalSider;
      
      
    }
  void show() {
    fill(farve);
    rect(x,y,50,100);
    
    
  }
}
