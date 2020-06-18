class Paragraph {
  String styles;
  String content;
  String type;
  String caption;
 
  Paragraph({
    this.styles,
    this.content,
    this.type,
    this.caption,
  });
 
  factory Paragraph.fromJson(Map<String, dynamic> json){
    String content;
    String caption;
    if (json["type"] == 'image') {
      content = json["content"][0]["mobile"]["url"];
      caption = json["content"][0]["description"];
    } else if (json["type"] == 'header-two') {
      content = json["content"].join("\n");
      content = content.replaceAll(new RegExp(r'<.*?strong.*?>'), '');
    } else if (json["type"] == 'infobox') {
      content = json["content"][0]["title"] + "\n" + json["content"][0]["body"];
    } else if (json["type"] == 'embeddedcode') {
      content = json["content"][0]["embeddedCode"];
      print(content);
    } else {
      content = json["content"].join("\n");
    }
    
    return new Paragraph(
        type: json['type'],
        content: content,
        caption: caption,
    );
  }
}
 