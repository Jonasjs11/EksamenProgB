class Risk {
  Spiller[] spillere;
  Territorium[] territorier;
  boolean[][] naboMatrice;
  Terning[] terninger;
  
  PShape kort;
  
  Risk() {
    kort = loadShape("Bræt.svg");
    //kort.disableStyle();
    
    println(kort.getChildCount());

    for (int i=0; i<kort.getChildCount(); i++) {
      println(i + ": " + kort.getChild(i).getName());
    }
  }
  
  void fordelTerritorierTilfældigt() {
    
  }
  
  void vis() {
    //shape(kort, 0, 0, width/2, height/2);
    shape(kort.getChild("great_britain"),0,0);
  }
}
