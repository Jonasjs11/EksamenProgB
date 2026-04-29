class Spiller {
  color farve;
  String navn;
  int arméTilRådighed;
  PVector nedersteVenstreHjørne;
  int bredde, højde;
  
  Spiller(color spillerFarve, String navn, PVector nedersteVenstreHjørne, int bredde, int højde) {
    farve = spillerFarve;
    this.navn = navn;
    this.nedersteVenstreHjørne = nedersteVenstreHjørne;
    this.bredde = bredde;
    this.højde = højde;
  }
  
  void vis(){
    stroke(0);
    strokeWeight(1);
    fill(farve);
    rect(nedersteVenstreHjørne.x, nedersteVenstreHjørne.y-højde, bredde, højde);
    fill(0);
    textAlign(CENTER, TOP);
    textSize(20);
    text(navn, nedersteVenstreHjørne.x+bredde/2, nedersteVenstreHjørne.y-højde);
  }

  void modtagArmé() {
    
  }

  void flytArmé() {
    
  }

  void angrib() {
    
  }

  void sætArme() {
    
  }
}
