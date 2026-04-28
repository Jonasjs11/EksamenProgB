class Risk {
  Raflebaeger rb;
  Spiller[] spillere;
  Territorium[] territorier;
  boolean[][] naboMatrice;
  Terning[] terninger;
  
  PShape[] kystlinjer;
  PShape[] baggrunde;
  
 Risk() {
  PShape kort = loadShape("Bræt.svg");

  println(kort.getChildCount());

  for (int i=0; i<kort.getChildCount(); i++) {
    println(i + ": " + kort.getChild(i).getName());
  }


  kystlinjer = new PShape[24];
  for(int i = 0; i < kystlinjer.length; i++){
    kystlinjer[i] = kort.getChild(i);
  }

  baggrunde = new PShape[40-24+1];
  for(int i = 0; i < baggrunde.length; i++){
    baggrunde[i] = kort.getChild(i+24);
  }

  territorier = new Territorium[96-55+1];
  for(int i = 0; i < territorier.length; i++){
    territorier[i] = new Territorium(kort.getChild(i+55));
  }


  rb = new Raflebaeger();

  rb.addDice(new Terning(width/2, height/7 * 5 , 6, color(255, 0, 0)));
  rb.addDice(new Terning(width/2 - 55, height/7 * 5 - 40, 6,color(255, 0, 0)));
  rb.addDice(new Terning(width/2 +55, height/7 * 5 - 40, 6, color(0, 0, 255)));
  rb.addDice(new Terning(width/2 +55, height/7 * 5 + 40, 6 , color(0, 0, 255)));
  rb.addDice(new Terning(width/2 -55,  height/7 * 5 + 40, 6, color(255, 0, 0)));
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
     rb.show();
  }
 
 void kastTerninger(){
  rb.ryst();
}
}
