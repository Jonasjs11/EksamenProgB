class Territorium {
  String navn;
  Spiller ejer;
  int boendeArméer = 4;
  PShape outline;

  Territorium(PShape outline, String navn) {
    this.outline = outline;
    this.navn = navn;
  }

  void tilføjArméer(int antal) {
    boendeArméer += antal;
  }

  void fjernArméer(int antal) {
    boendeArméer -= antal;
  }

  void skiftEjer(Spiller nyEjer) {
    ejer = nyEjer;
  }

  void vis() {
    shape(outline, 0, 0);
    PVector m = midt();
    fill(255); //ejer.farve
    rect(m.x-5, m.y-5, 10, 10);
    fill(0);
    textAlign(CENTER, CENTER);
    text(boendeArméer, m.x, m.y);
  }

  PVector midt() {
    PVector sum = new PVector(0, 0);
    int amount = 1;
    
    PVector oldPoint = outline.getVertex(0);
    sum.add(outline.getVertex(0));
    
    for (int i = 0; i < outline.getVertexCount(); i++) {
      if (PVector.dist(oldPoint, outline.getVertex(i)) > 28) {
        sum.add(outline.getVertex(i));
        amount += 1;
        oldPoint = outline.getVertex(i);
      }
    }

    return sum.div(amount);
  }
  
  void markerTerritoriumMedCirkel(int radius, color farve){
    PVector m = midt();
    noStroke();
    fill(farve);
    circle(m.x, m.y, radius);
  }
}
