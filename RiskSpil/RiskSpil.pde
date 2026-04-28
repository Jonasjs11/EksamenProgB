Risk risk;

void setup(){
  size(1000, 1000);
  
  risk = new Risk(4);
  risk.fordelTerritorierTilfældigt();
}

void draw(){
  risk.tick();
  risk.vis();
}
