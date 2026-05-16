class Raflebaeger {

  ArrayList<Terning> terninger;


  Raflebaeger() {
    terninger = new ArrayList<Terning>();
  }

  void addDice(Terning t) {
    terninger.add(t);
  }

  void setAktiveTerninger(int antal) {

    for (int i = 0; i < terninger.size(); i++) {

    if (i < antal) {
      terninger.get(i).aktiv = true;
    } else {
      terninger.get(i).aktiv = false;
    }
  }
}

  void ryst() {
    for (Terning t : terninger) {
      t.kast();
    }
  }

  void show() {
    for (Terning t : terninger) {
      t.show();
      
    }
  }
}
