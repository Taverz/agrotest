
class OnlyOneClick {
  static DateTime? lastClick;

  static bool oneClick(Function()? click){
    if(lastClick == null){
      lastClick = DateTime.now();
      if(click!=null) click();
      return true;
    }
    if(lastClick!.difference(DateTime.now()).inSeconds < 2){
      lastClick = DateTime.now();
      if(click!=null) click();
      return true;
    }else{
      return false;
    }
  }
}