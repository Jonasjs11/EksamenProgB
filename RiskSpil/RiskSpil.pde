Risk risk;
boolean mouseReleased = false;

void setup(){
  size(1000, 1000);
  
  risk = new Risk(4);
  risk.fordelTerritorierTilfældigt();
  risk.startGameLoop();
}

void draw(){
  risk.tick();
  risk.vis();

}

void mousePressed(){
  risk.kastTerninger();
}

void mouseReleased(){
  mouseReleased = true;
}
