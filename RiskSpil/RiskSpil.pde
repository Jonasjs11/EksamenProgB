Risk risk;
boolean mouseReleased = false;
int numberReleased = -1;

void setup(){
  size(1000, 1000);
  
  risk = new Risk(4);
  risk.fordelTerritorierTilfældigt();
  risk.startGameLoop();
}

void draw(){
  risk.tick();
  risk.vis();
  
  mouseReleased = false;
  numberReleased = -1;
}

void mouseReleased(){
  mouseReleased = true;
}

void keyReleased(){
  try {
     numberReleased = Integer.parseInt(str(key));
  }
  catch (NumberFormatException e) {
     numberReleased = -1;
  }
}
