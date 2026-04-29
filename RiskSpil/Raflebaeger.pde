class Raflebaeger {

  ArrayList<Terning> terninger;

  Raflebaeger() {
    terninger = new ArrayList<Terning>();
  }

  void addDice(Terning t) {
    terninger.add(t);
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
