class Territorium {
  String navn;
  Spiller ejer;
  int boendeArméer = 4;
  PShape outline;
  
  Territorium(PShape outline) {
    this.outline = outline;
  }

  void tilføjArméer() {
    
  }
  
  void fjernArméer() {
    
  }
  
  void skiftEjer(Spiller nyEjer) {
    ejer = nyEjer;
  }
  
  void vis() {
    shape(outline, 0, 0);
    PVector m = midt();
    fill(255); //ejer.farve
    rect(m.x,m.y,10,10);
    fill(0);
    textAlign(CENTER, CENTER);
    text(boendeArméer,m.x+5,m.y+4.5);
  }
  
  PVector midt(){
    PVector sum = new PVector(0, 0);
    for(int i = 0; i < outline.getVertexCount(); i++){
      sum.add(outline.getVertex(i));
    }
    return sum.div(outline.getVertexCount());
  }
}
