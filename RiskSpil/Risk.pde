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
  
  // VARIABLER TIL FLYTTELSE
  Territorium territoriumTilFraflytning;
  Territorium territoriumTilTilflytning;


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
  
  /*
  StartGameLoop() må kaldes når alle territorierne har en ejer.
  */
  void startGameLoop(){
    skiftTurTil(spillere[0]);
  }

  void skiftTurTil(Spiller nyAktivSpiller){
    aktivSpiller = nyAktivSpiller;
    
    spilTilstand = SpilTilstand.TILFØJ;
    antalArméerTilModtagelse = max(floor(antalTerritorierEjetAfSpiller(aktivSpiller) / 3), 3); // Antal territorier man ejer divideret med 3, men altid minimum 3 nye arméer
    //DER SKAL TILFØJES KONTINENT-BONUS HER
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

  final int radiusAfTrykOmråde = 30;
  Territorium territoriumTrykketPå(Spiller markeringsSpiller, boolean alleEksklusivSpilleren) {
    for (int i = 0; i < territorier.length; i++) {
      if (markeringsSpiller == null || (alleEksklusivSpilleren == false && territorier[i].ejer == markeringsSpiller) || (alleEksklusivSpilleren == true && territorier[i].ejer != markeringsSpiller)) {
        territorier[i].markerTerritoriumMedCirkel(radiusAfTrykOmråde, #F5CF97);
      }
    }
    
    return territoriumTrykketPå();
  }
  Territorium territoriumTrykketPå() {
    if (mouseReleased == false) { return null; }

    Territorium t = null;
    
    for (int i = 0; i < territorier.length; i++) {
      if (PVector.dist(new PVector(mouseX, mouseY), territorier[i].midt()) < radiusAfTrykOmråde) {
        t = territorier[i];
        return t;
      }
    }

    return null;
  }


  /*
  Tick() skal kaldes hver frame i draw().
  Metoden lytter efter spillerinput og reagerer på det i de tre faser, som findes ved hver tur.
  */
  void tick() {
    if (spilTilstand == SpilTilstand.TILFØJ) { // Den aktive spiller skal tiljøje arméer til territorierne
      if (territoriumTilModtagelse == null) {
        statusText = "Vælg territorium som skal modtage arméer";
        
        Territorium t = territoriumTrykketPå(aktivSpiller, false);
        if (t != null) {
          if (t.ejer == aktivSpiller) {
            territoriumTilModtagelse = t;
            return;
          }
        }
      } else { // Den aktive spiller har valgt et territorium, nu skal arméerne tilføjes
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

        Territorium t = territoriumTrykketPå(aktivSpiller, false);
        if (t != null) {
          if (t.ejer == aktivSpiller && t.boendeArméer >= 2) {
            angribendeTerritorium = t;
            return;
          }
        }
      } else if (forsvarendeTerritorium == null) { // Den aktive spiller skal vælge hvilket territorium der skal kæmpes mod
        statusText = "Vælg territorium som skal angribes";
        angribendeTerritorium.markerTerritoriumMedCirkel(20, #97F5D9); // Marker det tidligere valgt angribende territorium

        Territorium t = territoriumTrykketPå(aktivSpiller, true);
        if (t != null) {
          if (t.ejer != aktivSpiller) {
            forsvarendeTerritorium = t;
            return;
          }
        }
      } else { // Territorierne er valgt
        angribendeTerritorium.markerTerritoriumMedCirkel(20, #97F5D9); // Marker det tidligere valgt angribende territorium
        forsvarendeTerritorium.markerTerritoriumMedCirkel(20, #97F5D9); // Marker det tidligere valgt forsvarende territorium
      
        if (antalAngribendeArméer == -1) { // Den aktive spiller skal vælge hvilket territorium der skal kæmpes mod
          statusText = "Vælg antal angribende arméer";
          
          if ((numberReleased >= 1 && numberReleased <= 3) && (angribendeTerritorium.boendeArméer - numberReleased >= 1)) { // Man kan angribe med 1, 2 eller 3 arméer, og der skal være mindst én tilbage
            antalAngribendeArméer = numberReleased;
            return;
          }
        }
        if (antalForsvarendeArméer == -1) { // Den forsvarende spiller skal vælge hvilket territorium der skal kæmpes mod
          statusText = "Vælg antal forsvarende arméer";
          
          if (numberReleased >= 1 && numberReleased <= 2) {
            antalForsvarendeArméer = numberReleased;
            return;
          }
        }
        if (antalAngribendeArméer != -1 && antalForsvarendeArméer != -1) { // Alt er valgt, terningerne skal kastes
          statusText = "Kast terningerne!";
          
          if (mouseReleased) {
            kastTerninger();
            
            sammenlignTerningerOgLavKrig();
            
            antalAngribendeArméer = 0;
            antalForsvarendeArméer = 0;
            angribendeTerritorium = null;
            forsvarendeTerritorium = null;
            spilTilstand = SpilTilstand.FLYT;
            return;
          }
        }
      }
    }

    if (spilTilstand == SpilTilstand.FLYT) { // Den aktive spiller har mulighed for at flytte arméer
      if (territoriumTilFraflytning == null) { // Den aktive spiller skal vælge territorium til at flytte arméer fra
        statusText = "Vælg territorium som skal flyttes arméer fra";
        
        Territorium t = territoriumTrykketPå(aktivSpiller, false);
        if (t != null) {
          if (t.ejer == aktivSpiller && t.boendeArméer >= 2) {
            territoriumTilFraflytning = t;
            return;
          }
        }
      } else if (territoriumTilTilflytning == null) { // Den aktive spiller skal vælge territorium til at flytte arméer til
        statusText = "Vælg territorium som skal flyttes arméer til";
        
        territoriumTilFraflytning.markerTerritoriumMedCirkel(20, #97F5D9); // Marker det tidligere valgt fraflytning territorium
        
        Territorium t = territoriumTrykketPå(aktivSpiller, false);
        if (t != null) {
          if (t.ejer == aktivSpiller && territorierErForbundede(territoriumTilFraflytning, t)) {
            territoriumTilTilflytning = t;
            return;
          }
        }
      } else { // Den aktive spiller har valgt begge territorier, og skal nu vælge antallet der skal flyttes
        statusText = "Vælg antal arméer der skal flyttes";
        
        territoriumTilFraflytning.markerTerritoriumMedCirkel(20, #97F5D9); // Marker det tidligere valgt fraflytning territorium
        territoriumTilTilflytning.markerTerritoriumMedCirkel(20, #97F5D9); // Marker det tidligere valgt tilflytning territorium
        
        if (numberReleased >= 1 && territoriumTilFraflytning.boendeArméer - numberReleased >= 1) { // Der skal være mindst én armé tilbage
          territoriumTilFraflytning.fjernArméer(numberReleased);
          territoriumTilTilflytning.tilføjArméer(numberReleased);
        }
      }
    }
  }

  void kastTerninger() {
    rb.ryst();
  }
  
  boolean territorierErForbundede(Territorium start, Territorium slut){
    return true;
  }
  
  void sammenlignTerningerOgLavKrig() {
    
  }
}
