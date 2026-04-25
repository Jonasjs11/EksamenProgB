class Risk {
  Spiller[] spillere;
  Territorium[] territorier;
  boolean[][] naboMatrice;
  Terning[] terninger;
  
  PShape[] kystlinjer;
  PShape[] baggrunde;
  
  Risk() {
    PShape kort = loadShape("Bræt.svg");
    //kort.disableStyle();
    
    println(kort.getChildCount());

    for (int i=0; i<kort.getChildCount(); i++) {
      println(i + ": " + kort.getChild(i).getName());
    }
    
    kystlinjer = new PShape[24]; //0-23
    for(int i = 0; i < kystlinjer.length; i++){
      kystlinjer[i] = kort.getChild(i);
    }
    
    baggrunde = new PShape[40-24+1]; //24-40
    for(int i = 0; i < baggrunde.length; i++){
      baggrunde[i] = kort.getChild(i+24);
    }
    
    territorier = new Territorium[96-55+1]; //55-96
    for(int i = 0; i < territorier.length; i++){
      territorier[i] = new Territorium(kort.getChild(i+55));
    }
  }
  
  void fordelTerritorierTilfældigt() {
    
  }
  
  void vis() {
    background(#B9F4FF);
    
    for(PShape kystlinje : kystlinjer){
      shape(kystlinje, 0, 0);
    }
    
    for(PShape baggrund : baggrunde){
      shape(baggrund, 0, 0);
    }
    
    for(Territorium territorium : territorier){
      territorium.vis();
    }
  }
}
