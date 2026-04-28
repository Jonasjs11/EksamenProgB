class Territorium {
  String navn;
  Spiller ejer;
  int boendeArméer;
  PShape outline;
  
  Territorium(PShape outline) {
    this.outline = outline;
  }

  void tilføjArméer() {
    
  }
  
  void fjernArméer() {
    
  }
  
  void skiftEjer() {
    
  }
  
  void vis() {
    shape(outline, 0, 0);
    PVector m = midt();
    fill(ejer.farve);
    rect(m.x-5,m.y-5,10,10);
    fill(255);
    textAlign(CENTER, CENTER);
    text("X",m.x,m.y);
  }
  
  PVector midt(){
    PVector sum = new PVector(0, 0);
    for(int i = 0; i < outline.getVertexCount(); i++){
      sum.add(outline.getVertex(i));
    }
    return sum.div(outline.getVertexCount());
  }
}
