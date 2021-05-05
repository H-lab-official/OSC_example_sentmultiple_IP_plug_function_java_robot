/**
 * oscP5plug by andreas schlegel
 * example shows how to use the plug service with oscP5.
 * the concept of the plug service is, that you can
 * register methods in your sketch to which incoming 
 * osc messages will be forwareded automatically without 
 * having to parse them in the oscEvent method.
 * that a look at the example below to get an understanding
 * of how plug works.
 * oscP5 website at http://www.sojamo.de/oscP5
 */

import oscP5.*;
import netP5.*;
import java.awt.*;
import java.awt.event.*;

Robot robot;
PFont pfont;
Point save_p;
 


OscP5 oscP5;
NetAddress myRemoteLocation;
NetAddress myRemoteLocation2;
void setup() {
  size(400,400);
  frameRate(25);
  /* start oscP5, listening for incoming messages at port 12000 */
  oscP5 = new OscP5(this,12000);
  
  /* myRemoteLocation is a NetAddress. a NetAddress takes 2 parameters,
   * an ip address and a port number. myRemoteLocation is used as parameter in
   * oscP5.send() when sending osc packets to another computer, device, 
   * application. usage see below. for testing purposes the listening port
   * and the port of the remote location address are the same, hence you will
   * send messages back to this sketch.
   */
  myRemoteLocation = new NetAddress("192.168.1.112",12000);
  myRemoteLocation2 = new NetAddress("192.168.1.127",12000);
  
  /* osc plug service
   * osc messages with a specific address pattern can be automatically
   * forwarded to a specific method of an object. in this example 
   * a message with address pattern /test will be forwarded to a method
   * test(). below the method test takes 2 arguments - 2 ints. therefore each
   * message with address pattern /test and typetag ii will be forwarded to
   * the method test(int theA, int theB)
   */
  oscP5.plug(this,"test","/test");
  
    try { 
    robot = new Robot();
    robot.setAutoDelay(0);
  } 
  catch (Exception e) {
    e.printStackTrace();
  }
  
}

void mouseMove() {
  robot.mouseMove(0, 0);
  robot.mousePress(InputEvent.BUTTON1_DOWN_MASK);
  robot.mouseRelease(InputEvent.BUTTON1_DOWN_MASK);
  robot.waitForIdle();
}
void hry(){
    //robot.mouseMove(0, 0); 
    println("### plug event method. received a message /test.");
}
public void test(int theA, int theB) {
  mouseMove();
  println("### plug event method. received a message /test.");
  println(" 2 ints received: "+theA+", "+theB);  

 }


void draw() {
  background(0);
}


void mousePressed() {
  /* createan osc message with address pattern /test */
  OscMessage myMessage = new OscMessage("/test");
  int x= int(random(100));
  myMessage.add(x); /* add an int to the osc message */
  myMessage.add(x); /* add a second int to the osc message */

  /* send the message */
  oscP5.send(myMessage, myRemoteLocation); 
  oscP5.send(myMessage, myRemoteLocation2); 
}


/* incoming osc message are forwarded to the oscEvent method. */
void oscEvent(OscMessage theOscMessage) {
  /* with theOscMessage.isPlugged() you check if the osc message has already been
   * forwarded to a plugged method. if theOscMessage.isPlugged()==true, it has already 
   * been forwared to another method in your sketch. theOscMessage.isPlugged() can 
   * be used for double posting but is not required.
  */  
  if(theOscMessage.isPlugged()==false) {
  /* print the address pattern and the typetag of the received OscMessage */
  println("### received an osc message.");
  println("### addrpattern\t"+theOscMessage.addrPattern());
  println("### typetag\t"+theOscMessage.typetag());

  }
}
