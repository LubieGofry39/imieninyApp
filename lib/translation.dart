
class Transation{
  

  String miesiac(number){
       List<String> months = [
      "stycznia",
      'lutego',
      'marca',
      'kwietnia',
      'maja',
      'czerwca',
      'lipca',
      'sierpnia',
      'wrzesnia',
      'pazdziernika',
      'listopada',
      'grudnia'
    ];

    return months[number];
  }

  String dzienTyg(int number){
    List<String> dayOfWeek = [
      "poniedziałek",
      "wtorek",
      "środa",
      'czwartek',
      'piątek',
      'sobota',
      'niedziela'
    ];

    return dayOfWeek[number];
  }

}