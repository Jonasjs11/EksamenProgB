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
    fill(0);
    PVector m = midt();
    circle(m.x, m.y, 10);
  }
  
  PVector midt(){
    PVector sum = new PVector(0, 0);
    for(int i = 0; i < outline.getVertexCount(); i++){
      sum.add(outline.getVertex(i));
    }
    return sum.div(outline.getVertexCount());
  }
}
