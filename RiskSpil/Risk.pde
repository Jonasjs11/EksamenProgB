class Risk {

  Raflebaeger rb;

  // VARIABLER TIL DATA
  Spiller[] spillere;
  Territorium[] territorier;
  boolean[][] naboMatrice;
  int[][] kontinenter;
  int[] kontinentBonuser;
  Terning[] terninger;
  final color[] spillerFarver = new color[]{#FF0000, #00FF00, #0000FF, #FFFF00, #00FFFF};
  final boolean F = true;
  final boolean N = false;

  String statusText;

  Spiller aktivSpiller;
  SpilTilstand spilTilstand;

  // VARIABLER TIL MODTAGELSE
  int antalArméerTilModtagelse;
  Territorium territoriumTilModtagelse;

  // VARIABLER TIL KRIG
  Territorium angribendeTerritorium;
  Territorium forsvarendeTerritorium;
  int antalAngribendeArméer = -1;
  int antalForsvarendeArméer = -1;
  
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
      spillere[i] = new Spiller(spillerFarver[i], str(i), new PVector(25+floor(i/2)*625+(i%2)*175, height), 150, 100);
    }

    // SETUP AF ANDET
    statusText = "Klar til start.";
    
    // SETUP AF NABOMATRICE
    naboMatrice = new boolean[][]{
      /*            00 01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41*/
      /*00-EaAu*/  {N, N, F, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, F, N}, /*00-EaAu*/
      /*01-Indo*/  {N, N, F, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, F, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, F, N}, /*01-Indo*/
      /*02-NeGu*/  {F, F, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, F, N}, /*02-NeGu*/
      /*03-Alas*/  {N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, F, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, F}, /*03-Alas*/
      /*04-Onta*/  {N, N, N, N, N, F, N, N, N, F, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, F, F, F, N, N, N, F}, /*04-Onta*/
      /*05-NoTe*/  {N, N, N, F, F, N, N, N, N, F, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, F}, /*05-NoTe*/
      /*06-Vene*/  {N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, F, F, N, N}, /*06-Vene*/
      /*07-Mada*/  {N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, F, N, F, N, N, N, N, N, N, N, N, N}, /*07-Mada*/
      /*08-NoAf*/  {N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, F, F, N, F, F, F, N, F, N, N, N, N, N, N, N, N}, /*08-NoAf*/
      /*09-Gree*/  {N, N, N, N, F, F, N, N, N, N, F, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, F, N, N, N, N}, /*09-Gree*/
      /*10-Icel*/  {N, N, N, N, N, N, N, N, N, F, N, F, F, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N}, /*10-Icel*/
      /*11-GrBr*/  {N, N, N, N, N, N, N, N, N, N, F, N, F, N, N, N, N, N, N, N, N, N, N, N, N, N, N, F, F, N, N, N, N, N, N, N, N, N, N, N, N, N}, /*11-GrBr*/
      /*12-Scan*/  {N, N, N, N, N, N, N, N, N, N, F, F, N, N, N, N, N, N, N, N, N, N, N, N, N, F, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N}, /*12-Scan*/
      /*13-Japa*/  {N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, F, N, N, N, N, N, N, N, F, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N}, /*13-Japa*/
      /*14-Yaku*/  {N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, F, F, N, N, N, N, N, N, N, F, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N}, /*14-Yaku*/
      /*15-Kamc*/  {N, N, N, F, N, N, N, N, N, N, N, N, N, F, F, N, N, N, N, N, N, N, N, F, F, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N}, /*15-Kamc*/
      /*16-Sibe*/  {N, N, N, N, N, N, N, N, N, N, N, N, N, N, F, N, N, F, N, N, N, N, F, F, F, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N}, /*16-Sibe*/
      /*17-Ural*/  {N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, F, N, N, N, F, N, N, F, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N}, /*17-Ural*/
      /*18-Afgh*/  {N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, F, N, F, F, N, F, N, N, F, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N}, /*18-Afgh*/
      /*19-MiEa*/  {N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, F, N, F, N, N, N, N, F, F, N, N, F, F, N, N, N, N, N, N, N, N, N, N, N}, /*19-MiEa*/
      /*20-Indi*/  {N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, F, F, N, F, F, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N}, /*20-Indi*/
      /*21-Siam*/  {N, F, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, F, N, F, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N}, /*21-Siam*/
      /*22-Chin*/  {N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, F, F, F, N, F, F, N, F, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N}, /*22-Chin*/
      /*23-Mong*/  {N, N, N, N, N, N, N, N, N, N, N, N, N, F, N, F, F, N, N, N, N, N, F, N, F, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N}, /*23-Mong*/
      /*24-Irkt*/  {N, N, N, N, N, N, N, N, N, N, N, N, N, N, F, F, F, N, N, N, N, N, N, F, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N}, /*24-Irkt*/
      /*25-Ukra*/  {N, N, N, N, N, N, N, N, N, N, N, N, F, N, N, N, N, F, F, F, N, N, N, N, N, N, F, N, F, N, N, N, N, N, N, N, N, N, N, N, N, N}, /*25-Ukra*/
      /*26-SoEu*/  {N, N, N, N, N, N, N, N, F, N, N, N, N, N, N, N, N, N, N, F, N, N, N, N, N, F, N, F, F, F, N, N, N, N, N, N, N, N, N, N, N, N}, /*26-SoEu*/
      /*27-WeEu*/  {N, N, N, N, N, N, N, N, F, N, N, F, N, N, N, N, N, N, N, N, N, N, N, N, N, N, F, N, F, N, N, N, N, N, N, N, N, N, N, N, N, N}, /*27-WeEu*/
      /*28-NoEu*/  {N, N, N, N, N, N, N, N, N, N, N, F, F, N, N, N, N, N, N, N, N, N, N, N, N, F, F, F, N, N, N, N, N, N, N, N, N, N, N, N, N, N}, /*28-NoEu*/
      /*29-Egyp*/  {N, N, N, N, N, N, N, N, F, N, N, N, N, N, N, N, N, N, N, F, N, N, N, N, N, N, F, N, N, N, F, N, N, N, N, N, N, N, N, N, N, N}, /*29-Egyp*/
      /*30-EaAf*/  {N, N, N, N, N, N, N, F, F, N, N, N, N, N, N, N, N, N, N, F, N, N, N, N, N, N, N, N, N, F, N, F, F, N, N, N, N, N, N, N, N, N}, /*30-EaAf*/
      /*31-Cong*/  {N, N, N, N, N, N, N, N, F, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, F, N, F, N, N, N, N, N, N, N, N, N}, /*31-Cong*/
      /*32-SoAf*/  {N, N, N, N, N, N, N, F, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, F, F, N, N, N, N, N, N, N, N, N, N}, /*32-SoAf*/
      /*33-Braz*/  {N, N, N, N, N, N, F, N, F, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, F, N, N, N, N, F, N, N}, /*33-Braz*/
      /*34-Arge*/  {N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, F, N, N, N, N, N, F, N, N}, /*34-Arge*/
      /*35-EaUS*/  {N, N, N, N, F, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, F, F, F, N, N, N}, /*35-EaUS*/
      /*36-WeUS*/  {N, N, N, N, F, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, F, N, N, F, N, N, F}, /*36-WeUS*/
      /*37-Queb*/  {N, N, N, N, F, N, N, N, N, F, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, F, N, N, N, N, N, N}, /*37-Queb*/
      /*38-CeAm*/  {N, N, N, N, N, N, F, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, F, F, N, N, N, N, N}, /*38-CeAm*/
      /*39-Peru*/  {N, N, N, N, N, N, F, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, F, F, N, N, N, N, N, N, N}, /*39-Peru*/
      /*40-WeAu*/  {F, F, F, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N}, /*40-WeAu*/
      /*41-Albe*/  {N, N, N, F, F, F, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, F, N, N, N, N, N}  /*41-Albe*/
      /*            00 01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41*/
    };
    
    kontinenter = new int[][]{
      {3, 5, 9, 41, 4, 37, 36, 35, 38}, // North America
      {6, 39, 33, 34}, // South America
      {10, 12, 25, 11, 28, 26, 27}, // Europe
      {8, 29, 31, 30, 32, 7}, // Africa
      {17, 16, 14, 15, 24, 23, 18, 22, 19, 20, 21, 13}, // Asia
      {1, 2, 40, 0}  // Oceania
    };
    
    kontinentBonuser = new int[]{5, 2, 5, 3, 7, 2};
    

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
      territorier[i] = new Territorium(kort.getChild(i+55), kort.getChild(i+55).getName().replace("_Outline", "").replace("_", " ")); // Fjern "_Outline" og erstat "_" med " "
    }

    // SETUP AF TERNINGER
    rb = new Raflebaeger();

    rb.addDice(new Terning(width/2,     height/7 * 5,      6, color(255, 0, 0)));
    rb.addDice(new Terning(width/2 -55, height/7 * 5 - 40, 6, color(255, 0, 0)));
    rb.addDice(new Terning(width/2 -55, height/7 * 5 + 40, 6, color(255, 0, 0)));
    rb.addDice(new Terning(width/2 +55, height/7 * 5 - 40, 6, color(0, 0, 255)));
    rb.addDice(new Terning(width/2 +55, height/7 * 5 + 40, 6, color(0, 0, 255)));
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
    antalArméerTilModtagelse += findSamletKontinentBonus(aktivSpiller);
  }
  
  int findSamletKontinentBonus(Spiller spiller){
    int bonus = 0;
    
    for (int i = 0; i < kontinenter.length; i++) {
      if (spillerEjerKontinent(i, spiller)) {
        bonus += kontinentBonuser[i];
      }
    }
    
    return bonus;
  }
  
  boolean spillerEjerKontinent(int kontinentIndex, Spiller spiller){
    for (int i = 0; i < kontinenter[kontinentIndex].length; i++) {
      if (territorier[kontinenter[kontinentIndex][i]].ejer() != spiller) {
        return false;
      }
    }
    return true;
  }
  
  void skiftTurTilNæsteSpiller(){
    int nuværendeSpillerIndex = 0;
    for (int i = 0; i < spillere.length; i++) {
      if (aktivSpiller == spillere[i]) {
        nuværendeSpillerIndex = i;
      }
    }
    nuværendeSpillerIndex++;
    if (nuværendeSpillerIndex >= spillere.length) { nuværendeSpillerIndex = 0; }
    skiftTurTil(spillere[nuværendeSpillerIndex]);
  }
  
  ArrayList<Territorium> findNaboLande(Territorium start){
    ArrayList<Territorium> naboLande = new ArrayList<Territorium>();
    
    int indexStart = -1;
    for (int i = 0; i < territorier.length; i++) {
      if (territorier[i] == start) {
        indexStart = i;
      }
    }
    
    for (int i = 0; i < territorier.length; i++) {
      if (naboMatrice[indexStart][i] == F) {
        naboLande.add(territorier[i]);
      }
    }
    
    return naboLande;
  }
  
  ArrayList<Territorium> findFjendtligeNaboLande(Territorium start, Spiller spiller){
    ArrayList<Territorium> fjendtligeNaboLande = new ArrayList<Territorium>();
    
    ArrayList<Territorium> naboLande = findNaboLande(start);
    for (int i = 0; i < naboLande.size(); i++) {
      if (naboLande.get(i).ejer() != spiller) {
        fjendtligeNaboLande.add(naboLande.get(i));
      }
    }
    
    return fjendtligeNaboLande;
  }
  
  ArrayList<Territorium> findTerritorierEjetAfSpiller(Spiller spiller){
    ArrayList<Territorium> ejedeTerritorier = new ArrayList<Territorium>();
    
    for (int i = 0; i < territorier.length; i++) {
      if (territorier[i].ejer() == spiller) {
        ejedeTerritorier.add(territorier[i]);
      }
    }
    
    return ejedeTerritorier;
  }
  
  ArrayList<Territorium> findAlleTerritorierMedFjendtligeNaboLande(Spiller spiller){
    ArrayList<Territorium> alleTerritorierMedFjendtligeNaboLande = new ArrayList<Territorium>();
    
    ArrayList<Territorium> ejedeTerritorier = findTerritorierEjetAfSpiller(spiller);
    for (int e = 0; e < ejedeTerritorier.size(); e++) {
      ArrayList<Territorium> fjendtligeNaboLande = findFjendtligeNaboLande(ejedeTerritorier.get(e), spiller);
      if (fjendtligeNaboLande.size() > 0) {
        alleTerritorierMedFjendtligeNaboLande.add(ejedeTerritorier.get(e));
      }
    }
    
    return alleTerritorierMedFjendtligeNaboLande;
  }
 
  
  ArrayList<Territorium> findAlleForbundneTerritorier(Territorium start, Spiller spiller){
    ArrayList<Territorium> alleForbundneTerritorier = new ArrayList<Territorium>();
    
    return findTerritorierEjetAfSpiller(spiller);
  }
  
  ArrayList<Territorium> findAlleTerritorierMedForbundneTerritorier(Spiller spiller){
    ArrayList<Territorium> alleTerritorierMedForbundneTerritorier = new ArrayList<Territorium>();
    
    return findTerritorierEjetAfSpiller(spiller);
  }
  
  int antalTerritorierEjetAfSpiller(Spiller spiller){
    int antal = 0;
    for (int i = 0; i < territorier.length; i++) {
      if (territorier[i].ejer() == spiller) {
        antal += 1;
      }
    }
    return antal;
  }

  void fordelTerritorierTilfældigt() {
    ArrayList<Territorium> TerritorieListe = new ArrayList<Territorium>(); // Liste med alle territorier
    for (int i = 0; i < territorier.length; i++) { 
      TerritorieListe.add(territorier[i]);
    }
    
    int spillerIndex = 0; // Nuværende spiller variabel tal
    
    for (int i = 0; i < territorier.length; i++) { // Loop igennem antallet af territorier
      int randomIndex = (int)random(0,TerritorieListe.size());
      Territorium tilfældigtTerritorium = TerritorieListe.get(randomIndex); // Vælg et tilfældigt territorie fra list
      
      tilfældigtTerritorium.skiftEjer(spillere[spillerIndex]); // Giv territoriet til spilleren
      TerritorieListe.remove(tilfældigtTerritorium); // Fjern territoriet fra listen
      
      spillerIndex = spillerIndex + 1; // Gå videre til den næste spillere, og kær næste iteration af loopet
      if (spillerIndex >= spillere.length) {
        spillerIndex = 0; 
      }
    }
  }

  void DEBUGCHILDREN(PShape kort) {
    println(kort.getChildCount());

    for (int i=0; i < kort.getChildCount(); i++) {
      println(i-55 + ": " + kort.getChild(i).getName());
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
    
    for (Spiller spiller : spillere) {
      spiller.vis();
    }
    
    
    fill(255);
    strokeWeight(1);
    stroke(0);
    int terningKasseBredde = 250;
    int terningKasseHøjde = 100;
    rect(width/2-terningKasseBredde/2, height-terningKasseHøjde, terningKasseBredde, terningKasseHøjde);


    int statusBredde = 200;
    int statusHøjde = 30;
    fill(255);
    stroke(0);
    strokeWeight(2);
    rect(width/2 - statusBredde/2, height-terningKasseHøjde-statusHøjde, statusBredde, statusHøjde);
    fill(0);
    strokeWeight(1);
    textSize(14);
    textAlign(CENTER, CENTER);
    text(statusText, width/2, height-terningKasseHøjde-statusHøjde/2);
  }

  void markerTerritorierMedCirkel(ArrayList<Territorium> territorierTiLMarkering){
    for (int i = 0; i < territorierTiLMarkering.size(); i++) {
      territorierTiLMarkering.get(i).markerTerritoriumMedCirkel(20, #FFE59D);
    }
  }

  final int radiusAfTrykOmråde = 30;
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
        statusText = "Vælg modtagende territorium";
        
        ArrayList<Territorium> alleTerritorierEjetAfSpiller = findTerritorierEjetAfSpiller(aktivSpiller);
        markerTerritorierMedCirkel(alleTerritorierEjetAfSpiller);
        
        Territorium t = territoriumTrykketPå();
        if (t != null) {
          if (t.ejer() == aktivSpiller) {
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
        statusText = "Vælg angribende territorium";
        
        fill(127);
        rect(width/2-75, height-50-25, 150, 50);
        textAlign(CENTER, CENTER);
        textSize(24);
        fill(0);
        text("Spring over", width/2, height-50);
        if (mouseReleased && areaHover(width/2-75, height-50-25, 150, 50)){
          spilTilstand = SpilTilstand.FLYT;
          return;
        }
        
        ArrayList<Territorium> alleTerritorierMedFjendtligeNaboLande = findAlleTerritorierMedFjendtligeNaboLande(aktivSpiller);
        markerTerritorierMedCirkel(alleTerritorierMedFjendtligeNaboLande);
        
        Territorium t = territoriumTrykketPå();
        if (t != null) {
          if (alleTerritorierMedFjendtligeNaboLande.contains(t) && t.boendeArméer() >= 2) {
            angribendeTerritorium = t;
            return;
          }
        }
      } else if (forsvarendeTerritorium == null) { // Den aktive spiller skal vælge hvilket territorium der skal kæmpes mod
        statusText = "Vælg territorium til angreb";
        angribendeTerritorium.markerTerritoriumMedCirkel(20, #97F5D9); // Marker det tidligere valgt angribende territorium

        ArrayList<Territorium> alleFjendtligeNaboLande = findFjendtligeNaboLande(angribendeTerritorium, aktivSpiller);
        markerTerritorierMedCirkel(alleFjendtligeNaboLande);

        Territorium t = territoriumTrykketPå();
        if (t != null) {
          if (alleFjendtligeNaboLande.contains(t)) {
            forsvarendeTerritorium = t;
            return;
          }
        }
      } else { // Territorierne er valgt
        angribendeTerritorium.markerTerritoriumMedCirkel(20, #97F5D9); // Marker det tidligere valgt angribende territorium
        forsvarendeTerritorium.markerTerritoriumMedCirkel(20, #97F5D9); // Marker det tidligere valgt forsvarende territorium
      
        if (antalAngribendeArméer == -1) { // Den aktive spiller skal vælge hvilket territorium der skal kæmpes mod
          statusText = "Vælg antal angribende arméer";
          
          if ((numberReleased >= 1 && numberReleased <= 3) && (angribendeTerritorium.boendeArméer() - numberReleased >= 1)) { // Man kan angribe med 1, 2 eller 3 arméer, og der skal være mindst én tilbage
            antalAngribendeArméer = numberReleased;
            return;
          }
        } else if (antalForsvarendeArméer == -1) { // Den forsvarende spiller skal vælge hvilket territorium der skal kæmpes mod
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
            
            antalAngribendeArméer = -1;
            antalForsvarendeArméer = -1;
            angribendeTerritorium = null;
            forsvarendeTerritorium = null;
            
            boolean kanAngribeIgen = false;
            ArrayList<Territorium> alleTerritorierMedFjendtligeNaboLande = findAlleTerritorierMedFjendtligeNaboLande(aktivSpiller);
            for (Territorium t : alleTerritorierMedFjendtligeNaboLande) {
              if (t.boendeArméer() >= 2) {
                kanAngribeIgen = true;
              }
            }
            if (kanAngribeIgen == false) {
              spilTilstand = SpilTilstand.FLYT;
            }
            
            return;
          }
        }
      }
    }

    if (spilTilstand == SpilTilstand.FLYT) { // Den aktive spiller har mulighed for at flytte arméer
      if (territoriumTilFraflytning == null) { // Den aktive spiller skal vælge territorium til at flytte arméer fra
        statusText = "Vælg fraflyttende territorium";
        
        ArrayList<Territorium> alleTerritorierMedForbundneTerritorier = findAlleTerritorierMedForbundneTerritorier(aktivSpiller);
        markerTerritorierMedCirkel(alleTerritorierMedForbundneTerritorier);
        
        Territorium t = territoriumTrykketPå();
        if (t != null) {
          if (alleTerritorierMedForbundneTerritorier.contains(t) && t.boendeArméer() >= 2) {
            territoriumTilFraflytning = t;
            return;
          }
        }
      } else if (territoriumTilTilflytning == null) { // Den aktive spiller skal vælge territorium til at flytte arméer til
        statusText = "Vælg tilflyttende territorium";
        
        territoriumTilFraflytning.markerTerritoriumMedCirkel(20, #97F5D9); // Marker det tidligere valgt fraflytning territorium
        
        ArrayList<Territorium> alleForbundneTerritorier = findAlleForbundneTerritorier(territoriumTilFraflytning, aktivSpiller);
        markerTerritorierMedCirkel(alleForbundneTerritorier);
        
        Territorium t = territoriumTrykketPå();
        if (t != null) {
          if (alleForbundneTerritorier.contains(t) && territorierErForbundede(territoriumTilFraflytning, t)) {
            territoriumTilTilflytning = t;
            return;
          }
        }
      } else { // Den aktive spiller har valgt begge territorier, og skal nu vælge antallet der skal flyttes
        statusText = "Vælg antal arméer der skal flyttes";
        
        territoriumTilFraflytning.markerTerritoriumMedCirkel(20, #97F5D9); // Marker det tidligere valgt fraflytning territorium
        territoriumTilTilflytning.markerTerritoriumMedCirkel(20, #97F5D9); // Marker det tidligere valgt tilflytning territorium
        
        if (numberReleased >= 1 && territoriumTilFraflytning.boendeArméer() - numberReleased >= 1) { // Der skal være mindst én armé tilbage
          territoriumTilFraflytning.fjernArméer(numberReleased);
          territoriumTilTilflytning.tilføjArméer(numberReleased);
          
          territoriumTilFraflytning = null;
          territoriumTilTilflytning = null;
          skiftTurTilNæsteSpiller();
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
    int[] angriber = new int[antalAngribendeArméer];
    int[] forsvarer = new int[antalForsvarendeArméer];
  
    // Henter værdierne
    for (int i = 0; i < angriber.length; i++) {
      angriber[i] = rb.terninger.get(i).getValue();
    }
  
    for (int i = 0; i < forsvarer.length; i++) {
      forsvarer[i] = rb.terninger.get(i + 3).getValue();
    }
  
    // Sorter lav til høj
    angriber = sort(angriber);
    forsvarer = sort(forsvarer);
    // length er hvor mange angriber og forsvare der er
    int fights = min(angriber.length, forsvarer.length);
  
    // Sammenlign højeste først
    for (int i = 0; i < fights; i++) {
  
      int a = angriber[angriber.length - 1 - i];
      int f = forsvarer[forsvarer.length - 1 - i];
  
      if (a > f) {
        forsvarendeTerritorium.fjernArméer(1);
      } else {
        angribendeTerritorium.fjernArméer(1);
      }
    }
  
    // Overtagelse
    if (forsvarendeTerritorium.boendeArméer() <= 0) {
      forsvarendeTerritorium.skiftEjer(aktivSpiller);
  
      angribendeTerritorium.fjernArméer(antalAngribendeArméer);
      forsvarendeTerritorium.tilføjArméer(antalAngribendeArméer);
    }
  }
}
