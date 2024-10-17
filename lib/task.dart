void main() {
  var dog = Breed("Toto", 50, "Labrador");
  dog.setSpeed(50);
  dog.setBreed("Labrador");

  dog.printAnimalInfo();
  dog.printBreedInfo();
  dog.run(); // استدعاء وظيفة الجري من الميكسن
}

abstract class Animal {
  String? _name;
  int? _speed;

  Animal(this._name, this._speed);

  void setName(String name) {
    _name = name;
  }

  void setSpeed(int speed) {
    _speed = speed;
  }

  String getName() {
    return _name!;
  }

  int getSpeed() {
    return _speed!;
  }

  void printAnimalInfo() {
    print("Animal Name: $_name");
    print("Speed: $_speed km/h");
  }
}

// mixin لاضافة ميزة الجري
mixin CanRun {
  void run() {
    print("This animal is running!");
  }
}

class Breed extends Animal with CanRun { // اضافة الميكسن CanRun هنا
  String? _breed;

  Breed(String name, int speed, String breed) : super(name, speed) {
    _breed = breed;
  }

  void setBreed(String breed) {
    _breed = breed;
  }

  void printBreedInfo() {
    print("Breed: $_breed");
  }
}
