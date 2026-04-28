class Territorium {
  String navn;
  Spiller ejer;
  int boendeArméer = 4;
  PShape outline;
  
  Territorium(PShape outline, String navn) {
    this.outline = outline;
    this.navn = navn;
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
    fill(255); //ejer.farve
    rect(m.x,m.y,10,10);
    fill(0);
    textAlign(CENTER, CENTER);
    text(boendeArméer,m.x+5,m.y+4.5);
  }
  
  PVector midt(){
    PVector sum = new PVector(0, 0);
    int amount = 1;
    
    PVector oldPoint = outline.getVertex(0);
    sum.add(oldPoint);
    
    for(int i = 0; i < outline.getVertexCount(); i++){
      if(PVector.dist(oldPoint, outline.getVertex(i)) > 50){
        sum.add(outline.getVertex(i));
        oldPoint = outline.getVertex(i);
        amount += 1;
      }
    }
    
    println(navn + " " + amount);
    return sum.div(amount);
  }
}
