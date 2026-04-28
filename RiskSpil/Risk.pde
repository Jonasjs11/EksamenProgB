class Risk {

  Raflebaeger rb;

  // VARIABLER TIL DATA
  Spiller[] spillere;
  Territorium[] territorier;
  boolean[][] naboMatrice;
  Terning[] terninger;
  final color[] spillerFarver = new color[]{#FF0000, #00FF00, #0000FF, #FFFF00, #00FFFF};


  String statusText;

  Spiller aktivSpiller;
  SpilTilstand spilTilstand;

  // VARIABLER TIL MODTAGELSE
  int antalArméerTilModtagelse;
  Territorium territoriumTilModtagelse;

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

    // SETUP AF ANDET
    statusText = "Klar til start.";

    // SETUP AF KORT
    PShape kort = loadShape("Bræt.svg");

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
      territorier[i] = new Territorium(kort.getChild(i+55), kort.getChild(i+55).getName());
    }

    // SETUP AF TERNINGER
    rb = new Raflebaeger();

    rb.addDice(new Terning(width/2, height/7 * 5, 6, color(255, 0, 0)));
    rb.addDice(new Terning(width/2 - 55, height/7 * 5 - 40, 6, color(255, 0, 0)));
    rb.addDice(new Terning(width/2 +55, height/7 * 5 - 40, 6, color(0, 0, 255)));
    rb.addDice(new Terning(width/2 +55, height/7 * 5 + 40, 6, color(0, 0, 255)));
    rb.addDice(new Terning(width/2 -55, height/7 * 5 + 40, 6, color(255, 0, 0)));
  }
  
  void startGameLoop(){
    skiftTurTil(spillere[0]);
  }

  void skiftTurTil(Spiller nyAktivSpiller){
    aktivSpiller = nyAktivSpiller;
    
    spilTilstand = SpilTilstand.TILFØJ;
    antalArméerTilModtagelse = floor(antalTerritorierEjetAfSpiller(aktivSpiller) / 3);
  }
  
  int antalTerritorierEjetAfSpiller(Spiller spiller){
    int antal = 0;
    for (int i = 0; i < territorier.length; i++) {
      if (territorier[i].ejer == spiller) {
        antal += 1;
      }
    }
    return antal;
  }

  void fordelTerritorierTilfældigt() {
    //liste med alle territorier
    //nuværende spiller variabel
    //loop igennem antallet af territorier
    //Vælg et tilfældigt territorie fra list
    //giv territoriet til spilleren
    //fjern territoriet fra listen
    //gå videre til den næste spillere, og kær næste iteration af loopet
  }

  void DEBUGCHILDREN(PShape kort) {
    println(kort.getChildCount());

    for (int i=0; i < kort.getChildCount(); i++) {
      println(i + ": " + kort.getChild(i).getName());
    }
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

    rb.show();


    int statusWidth = 200;
    int statusHeight = 50;
    fill(255);
    stroke(0);
    strokeWeight(2);
    rect(width/2 - statusWidth/2, height-statusHeight, statusWidth, statusHeight);
    fill(0);
    strokeWeight(1);
    textSize(24);
    textAlign(CENTER, CENTER);
    text(statusText, width/2, height-statusHeight/2);
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
      if (territoriumTilModtagelse == null) {
        statusText = "Vælg territorium som skal tilføjes arméer";
        
        Territorium t = territoriumTrykketPå();
        if (t != null) {
          if (t.ejer == aktivSpiller) {
            territoriumTilModtagelse = t;
            return;
          }
        }
      } else {
        territoriumTilModtagelse.tilføjArméer(antalArméerTilModtagelse);
        
        antalArméerTilModtagelse = 0;
        territoriumTilModtagelse = null;
        spilTilstand = SpilTilstand.ANGRIB;
        return;
      }
    }


    if (spilTilstand == SpilTilstand.ANGRIB) { // Den aktive spiller har mulighed for at angribe
      if (angribendeTerritorium == null) { // Den aktive spiller skal vælge hvilket territorium der skal angribe
        statusText = "Vælg territorium som skal angribe";

        Territorium t = territoriumTrykketPå();
        if (t != null) {
          angribendeTerritorium = t;
          return;
        }
      } else if (forsvarendeTerritorium == null) { // Den aktive spiller skal vælge hvilket territorium der skal kæmpes mod
        statusText = "Vælg territorium som skal angribes";

        Territorium t = territoriumTrykketPå();
        if (t != null) {
          forsvarendeTerritorium = t;
          return;
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
      statusText = "Vælg territorium som skal flyttes arméer";
    }
  }

  void kastTerninger() {
    rb.ryst();
  }
}
