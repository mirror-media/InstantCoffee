enum AuthorOccupation{
  writer,
  photographer,
  cameraMan,
  designer,
  engineer
}
extension AuthorOccupationExtension on AuthorOccupation {
  String displayText() {
    switch (this) {
      case AuthorOccupation.writer:
        return '記者';
      case AuthorOccupation.photographer:
        return '攝影';
      case AuthorOccupation.cameraMan:
        return '影音';
      case AuthorOccupation.designer:
        return '設計';
      case AuthorOccupation.engineer:
        return '工程';
      default:
        return ''; // 如果enum值未定義顯示內容，可以返回一個空字串或其他預設值
    }
  }
}


