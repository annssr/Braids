import java.util.*;

//  ******************* Basecode for P2 ***********************
Boolean 
  animating=true, 
  PickedFocus=false, 
  center=true, 
  track=false, 
  showViewer=false, 
  showBalls=false, 
  showControl=true, 
  showCurve=true, 
  showPath=true, 
  showKeys=true, 
  showSkater=false, 
  scene1=false,
  solidBalls=false,
  showCorrectedKeys=true,
  showQuads=true,
  showVecs=true,
  showTube=false;
float 
  t=0, 
  s=0;
int
  f=0, maxf=2*30, level=4, method=5;
String SDA = "angle";
float defectAngle=0;
pts P = new pts(); // polyloop in 3D
pts Q = new pts(); // second polyloop in 3D
pts R = new pts(); // inbetweening polyloop L(P,t,Q);

/*Linh*/
biArc biArc;
/*End Linh*/

/*Ruth*/
List<Integer> colorList = new ArrayList<Integer>();
ArrayList<Float> randomNumberList = new ArrayList<Float>();

void setup() {
  studentFace1 = loadImage("data/student1.jpg");  // load image from file pic.jpg in folder data *** replace that file with your pic of your own face
  studentFace2 = loadImage("data/student2.jpg");  // load image from file pic.jpg in folder data *** replace that file with your pic of your own face
  studentFace3 = loadImage("data/student3.jpg");  // load image from file pic.jpg in folder data *** replace that file with your pic of your own face
/*End Ruth*/

  textureMode(NORMAL);          
  //size(900, 900, P3D); // P3D means that we will do 3D graphics
  size(1000, 1000, P3D); // P3D means that we will do 3D graphics
  P.declare(); Q.declare(); R.declare(); // P is a polyloop in 3D: declared in pts
  
  
  //P.resetOnCircle(6,100); Q.copyFrom(P); // use this to get started if no model exists on file: move points, save to file, comment this line
  P.loadPts("data/pts");  Q.loadPts("data/pts2"); // loads saved models from file (comment out if they do not exist yet)

  noSmooth();
  frameRate(30);
  }
/*Linh*/

float ALL_TWIST = 0;
/*End Linh*/

/*Ruth*/
float ALL_TWIST_P = 0;
/*End Ruth*/

void draw() {
  background(255);
  hint(ENABLE_DEPTH_TEST); 
  pushMatrix();   // to ensure that we can restore the standard view before writing on the canvas
  setView();  // see pick tab
  showFloor(); // draws dance floor as yellow mat
  doPick(); // sets Of and axes for 3D GUI (see pick Tab)
  P.SETppToIDofVertexWithClosestScreenProjectionTo(Mouse()); // for picking (does not set P.pv)
 
  R.copyFrom(P); 
  for(int i=0; i<level; i++) 
    {
    Q.copyFrom(R); 
    if(method==5) {Q.subdivideDemoInto(R);}
    //if(method==4) {Q.subdivideQuinticInto(R);}
    //if(method==3) {Q.subdivideCubicInto(R); }
    //if(method==2) {Q.subdivideJarekInto(R); }
    //if(method==1) {Q.subdivideFourPointInto(R);}
    //if(method==0) {Q.subdivideQuadraticInto(R); }
    }
  R.displaySkater();
  
  fill(blue); if(showCurve) Q.drawClosedCurve(6);
  if(showControl) {fill(grey); P.drawClosedCurve(3);}  // draw control polygon 
  fill(yellow,100); P.showPicked(); 
  /*Linh*/

  TWIST = ALL_TWIST / ( P.nv * 2.);
  /*End Linh*/
  /*Ruth*/

  P_TWIST = ALL_TWIST_P+ALL_TWIST / (P.nv * 2.);
  for(int i = 0 ; i < 100; i++){
    colorList.add(color(random(255),random(255),random(255)));
    randomNumberList.add(random(-1.5,3));
  }
  /*End Ruth*/

  /*Linh*/

  ArrayList<biArc> arr = createBiArc(P);
  vec d = null;
  for (biArc g: arr) {
    
    if (d != null) {
      Init_TWIST = g.estimateInitTwist(d);
      /*Ruth*/
      Init_TWIST_P = Init_TWIST;
      /*End Ruth*/

      if (Float.isNaN(Init_TWIST)) {
        Init_TWIST = 0;
        /*Ruth*/
        Init_TWIST_P = 0;
        /*End Ruth*/
      }
    }
    
    d = g.draw(0,true);
  }
  float b = (-arr.get(0).estimateInitTwist(d)) / arr.size();
  //float c = (-arr.get(0).estimateInitTwist(d)) / arr.size();

  for (biArc g: arr) {
    if (d != null) {
      Init_TWIST = g.estimateInitTwist(d);
      /*Ruth*/
      Init_TWIST_P = Init_TWIST;
      /*End Ruth*/
      if (Float.isNaN(Init_TWIST)) {
        Init_TWIST = 0;
        /*Ruth*/
        Init_TWIST_P = 0;
        /*End Abdurrahmane*/

      }
    }
    d = g.draw(b,  false);
  }
  
  rotatingK = V(0., 0., 0.);
  /*Abdurrahmane*/
  firstElbow = true;
  /*End Abdurrahmane*/

  Init_TWIST = 0.;
  
  /*Ruth*/
  Init_TWIST_P = 0.;
  /*End Ruth*/

  /*End Linh*/

  //if(animating)  
  //  {
  //  f++; // advance frame counter
  //  if (f>maxf) // if end of step
  //    {
  //    P.next();     // advance dv in P to next vertex
 ////     animating=true;  
  //    f=0;
  //    }
  //  }
  //t=(1.-cos(PI*f/maxf))/2; //t=(float)f/maxf;

  //if(track) F=_LookAtPt.move(X(t)); // lookAt point tracks point X(t) filtering for smooth camera motion (press'.' to activate)
 
  popMatrix(); // done with 3D drawing. Restore front view for writing text on canvas
  hint(DISABLE_DEPTH_TEST); // no z-buffer test to ensure that help text is visible
    if(method==4) scribeHeader("Quintic UBS",2);
    if(method==3) scribeHeader("Cubic UBS",2);
    if(method==2) scribeHeader("Jarek J-spline",2);
    if(method==1) scribeHeader("Four Points",2);
    if(method==0) scribeHeader("Quadratic UBS",2);

  // used for demos to show red circle when mouse/key is pressed and what key (disk may be hidden by the 3D model)
  if(mousePressed) {stroke(cyan); strokeWeight(3); noFill(); ellipse(mouseX,mouseY,20,20); strokeWeight(1);}
  if(keyPressed) {stroke(red); fill(white); ellipse(mouseX+14,mouseY+20,26,26); fill(red); text(key,mouseX-5+14,mouseY+4+20); strokeWeight(1); }
  if(scribeText) {fill(black); displayHeader();} // dispalys header on canvas, including my face
  if(scribeText && !filming) displayFooter(); // shows menu at bottom, only if not filming
  if(filming && (animating || change)) saveFrame("FRAMES/F"+nf(frameCounter++,4)+".tif");  // save next frame to make a movie
  change=false; // to avoid capturing frames when nothing happens (change is set uppn action)
  change=true;
 
  }
