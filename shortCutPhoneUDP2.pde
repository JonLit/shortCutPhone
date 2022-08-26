import hypermedia.net.*;  // UDP Library
import ketai.net.*;  // only for getting IP Address :(

String state = "initialize";
Byte buttonsPressed;

String message = "";

StringList pcIP = new StringList();

UDP udp;

void setup() {
  fullScreen();
  orientation(LANDSCAPE);
  frameRate(240);

  initialize();
}

void draw() {
  background(255);
  switch (state)
  {
    case "initialize" : 
      textSize(50);
      textAlign(CENTER, CENTER);
      fill(0);
      text("Enter this on your PC \n" + KetaiNet.getIP(), width*0.5, height*0.5);
      //println(message);
      if (pcIP.size() > 0) {
        state = "running";
        //println(pcIP);
      }
      break;
    case "running" :
      line(0, height*0.5, width, height*0.5);  // horizontal middle line
      line(width*0.25, 0, width*0.25, height);  // vertical left line
      line(width*0.5, 0, width*0.5, height);  // vertical middle line
      line(width*0.75, 0, width*0.75, height);  // vertical right line
      
      if (buttonsPressed != getPressedButtons()) {
        buttonsPressed = getPressedButtons();
        for (int i = 0; i < pcIP.size(); i++) {
          udp.send(str(getPressedButtons()), pcIP.get(i), 6000);
        }
      }
      break;
  }
  
  if (message.contains("PC:") && !pcIP.hasValue(message.substring(3, message.length()))) {
    pcIP.append(message.substring(3, message.length()));
    udp.send("connected!", message.substring(3, message.length()), 6000);
    //println(pcIP);
  }
  println(frameRate);
}

Byte getPressedButtons() {
  String bt1 = "0";
  String bt2 = "0";
  String bt3 = "0";
  String bt4 = "0";
  String bt5 = "0";
  String bt6 = "0";
  String bt7 = "0";
  String bt8 = "0";
  for (int i = 0; i < touches.length; i++)
  {
    if (touches[i].x < width*0.25 && touches[i].y < height*0.5)
    {
      bt1 = "1";
      rect(0, 0, width*0.25, height*0.5);
    }
    if (touches[i].x > width*0.25 && touches[i].x < width*0.5 && touches[i].y < height*0.5)
    {
      bt2 = "1";
      rect(width*0.25, 0, width*0.25, height*0.5);
    }
    if (touches[i].x > width*0.5 && touches[i].x < width*0.75 && touches[i].y < height*0.5)
    {
      bt3 = "1";
      rect(width*0.5, 0, width*0.25, height*0.5);
    }
    if (touches[i].x > width*0.75 && touches[i].y < height*0.5)
    {
      bt4 = "1";
      rect(width*0.75, 0, width*0.25, height*0.5);
    }
    if (touches[i].x < width*0.25 && touches[i].y > height*0.5)
    {
      bt5 = "1";
      rect(0, height*0.5, width*0.25, height*0.5);
    }
    if (touches[i].x > width*0.25 && touches[i].x < width*0.5 && touches[i].y > height*0.5)
    {
      bt6 = "1";
      rect(width*0.25, height*0.5, width*0.25, height*0.5);
    }
    if (touches[i].x > width*0.5 && touches[i].x < width*0.75 && touches[i].y > height*0.5)
    {
      bt7 = "1";
      rect(width*0.5, height*0.5, width*0.25, height*0.5);
    }
    if (touches[i].x > width*0.75 && touches[i].y > height*0.5)
    {
      bt8 = "1";
      rect(width*0.75, height*0.5, width*0.25, height*0.5);
    }
  }
  String buttonsAsString = bt1 + bt2 + bt3 + bt4 + bt5 + bt6 + bt7 + bt8;
  //println("buttonsAsString: " + buttonsAsString);
  int buttonsAsInt = unbinary(buttonsAsString);
  //println("buttonsAsInt: " + buttonsAsInt);
  Byte buttonsAsByte = byte(buttonsAsInt);
  //println("buttonsAsByte: " + char(buttonsAsByte));
  return buttonsAsByte;
}

void receive(byte[] data/*, String ip, int port*/) {
  message = new String(data);
  //println("Smartphone: receive: \"" + message + "\" from " + ip + " on port " + port);
  
  if (message.equals("disconnect!")) {
    state = "initialize";
    pcIP = new StringList();
  }
}

void backPressed() {
  state = "initialize";
  initialize();
  pcIP = new StringList();
  message = "";
}

void initialize() {
  if (udp != null) {
    udp.dispose();
  }
  udp = new UDP(this, 6000);
  //udp.log(true);
  udp.listen(true);
  udp.send("test", "localhost", 6000);
}
