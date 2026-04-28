class Terning {

  int value =1;
  int maxValue =6;
  float x, y;
  int antalSider;
  color farveT;

  //constructor
  Terning( float x_, float y_, int antSider, color f ) {
    x=x_;
    y=y_;
    maxValue = antSider;
    farveT = f; 
    if (antSider<=0) {
      maxValue=1;
      
    }
  }

  //funktioner

  void show() {
    //tegn terning
    fill(farveT);
    rect(x, y, 40, 40);
    fill(0);
    textAlign(CENTER, CENTER);
    textSize (30);
    text(""+value, x+20, y+20);
  }


  int getValue() {
    return value;
  }



  void kast() {
    //kast terning
    value = (int)random(1, maxValue +1);
  }
}
