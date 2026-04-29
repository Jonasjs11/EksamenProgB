class Risk {
  // VARIABLER TIL DATA
  Spiller[] spillere;
  Territorium[] territorier;
  boolean[][] naboMatrice;
  Terning[] terninger;
  final color[] spillerFarver = new color[]{#FF0000, #00FF00, #0000FF, #FFFF00, #00FFFF};


  String statusText;

  Spiller aktivSpiller;
  SpilTilstand spilTilstand;

  // VARIABLER TIL KRIG
  Territorium angribendeTerritorium;
  Territorium forsvarendeTerritorium;
  int antalAngribendeArméer;
  int antalForsvarendeArméer;


  PShape[] kystlinjer;
  PShape[] baggrunde;

  Risk(int antalSpillere) {
    // SETUP AF SPILLERE
    if (antalSpillere < 2 || antalSpillere > 5) {
      println("Mærkeligt antal spillere: " + antalSpillere);
    }
    spillere = new Spiller[antalSpillere];
    for (int i = 0; i < spillere.length; i++) {
      spillere[i] = new Spiller(spillerFarver[i]);
    }

    // SETUP AF KORT
    PShape kort = loadShape("Bræt.svg");
    //kort.disableStyle();

    println(kort.getChildCount());

    for (int i=0; i<kort.getChildCount(); i++) {
      println(i + ": " + kort.getChild(i).getName());
    }

    kystlinjer = new PShape[24]; //0-23
    for (int i = 0; i < kystlinjer.length; i++) {
      kystlinjer[i] = kort.getChild(i);
    }

    baggrunde = new PShape[40-24+1]; //24-40
    for (int i = 0; i < baggrunde.length; i++) {
      baggrunde[i] = kort.getChild(i+24);
    }

    territorier = new Territorium[96-55+1]; //55-96
    for (int i = 0; i < territorier.length; i++) {
      territorier[i] = new Territorium(kort.getChild(i+55));
    }
  }

  void fordelTerritorierTilfældigt() {
    ArrayList<Territorium> TerritorieListe = new ArrayList<Territorium>();
    for (int i = 0; i < territorier.length; i++) { 
      TerritorieListe.add(territorier[i]);
    }
    int spillerIndex = 0;
    for (int i = 0; i < territorier.length; i++) { 
      int randomIndex = (int)random(0,TerritorieListe.size());
      Territorium tilfældigtTerritorium = TerritorieListe.get(randomIndex);
      tilfældigtTerritorium.skiftEjer(spillere[spillerIndex]);
      TerritorieListe.remove(tilfældigtTerritorium);
      spillerIndex = spillerIndex + 1;
      if (spillerIndex >= spillere.length) {
        spillerIndex = 0; 
      }
    }
    //liste med alle territorier
    //nuværende spiller variabel tal
    //loop igennem antallet af territorier
    //Vælg et tilfældigt territorie fra list
    //giv territoriet til spilleren
    //fjern territoriet fra listen
    //gå videre til den næste spillere, og kær næste iteration af loopet
  }

  void vis() {
    background(#B9F4FF);

    for (PShape kystlinje : kystlinjer) {
      shape(kystlinje, 0, 0);
    }

    for (PShape baggrund : baggrunde) {
      shape(baggrund, 0, 0);
    }

    for (Territorium territorium : territorier) {
      territorium.vis();
    }

    text(statusText, width/2, 0);
  }

  Territorium territoriumTrykketPå() {
    if (mouseReleased == false) {
      return null;
    }

    Territorium t = null;

    for (int i = 0; i < territorier.length; i++) {
      if (PVector.dist(new PVector(mouseX, mouseY), territorier[i].midt()) < 50) {
        t = territorier[i];
        return t;
      }
    }

    return null;
  }

  void tick() {
    if (spilTilstand == SpilTilstand.TILFØJ) { // Den aktive spiller skal tiljøje arméer til territorierne
    }


    if (spilTilstand == SpilTilstand.ANGRIB) { // Den aktive spiller har mulighed for at angribe
      if (angribendeTerritorium == null) { // Den aktive spiller skal vælge hvilket territorium der skal angribe
        statusText = "Vælg territorium som skal angribe";

        Territorium t = territoriumTrykketPå();
        if (t != null) {
        }
      } else if (forsvarendeTerritorium == null) { // Den aktive spiller skal vælge hvilket territorium der skal kæmpes mod
        statusText = "Vælg territorium som skal angribes";

        Territorium t = territoriumTrykketPå();
        if (t != null) {
        }
      } else {// Territorierne er valgt
        if (antalAngribendeArméer == -1) { // Den aktive spiller skal vælge hvilket territorium der skal kæmpes mod
          statusText = "Vælg antal angribende arméer";
        }
        if (antalForsvarendeArméer == -1) { // Den forsvarende spiller skal vælge hvilket territorium der skal kæmpes mod
          statusText = "Vælg antal forsvarende arméer";
        }
        if (antalAngribendeArméer != -1 && antalForsvarendeArméer != -1) { // Alt er valgt, terningerne skal kastes
          statusText = "Kast terningerne!";
        }
      }
    }

    if (spilTilstand == SpilTilstand.FLYT) { //Den aktive spiller har mulighed for at flytte arméer
    }
  }
}
