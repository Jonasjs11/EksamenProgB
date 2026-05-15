class Kort  {
  
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
    
    text("", x+20, y+20);
    
  }
}
