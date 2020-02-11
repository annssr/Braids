void keyPressed() 
  {
//  if(key=='`') picking=true; 
  if(key=='?') scribeText=!scribeText;
  if(key=='!') snapPicture();
  if(key=='~') filming=!filming;
  if(key==']') showBalls=!showBalls;
  if(key=='f') {P.setPicekdLabel(key);}
  if(key=='s') {P.setPicekdLabel(key);}
  if(key=='b') {P.setPicekdLabel(key);}
  if(key=='c') {P.setPicekdLabel(key);}
  if(key=='F') {P.addPt(Of,'f');}
  if(key=='S') {P.addPt(Of,'s');}
  if(key=='B') {P.addPt(Of,'b');}
  if(key=='C') {P.addPt(Of,'c');}
  if(key=='m') {method=(method+1)%5;}
  if(key=='[') {showControl=!showControl;}
  if(key==']') {showQuads=!showQuads;}
  if(key=='{') {showCurve=!showCurve;}
  if(key=='\\') {showKeys=!showKeys;}
  if(key=='}') {showPath=!showPath;}
  if(key=='|') {showCorrectedKeys=!showCorrectedKeys;}
  if(key=='=') {showTube=!showTube;}
  /* Linh */
  if(key=='>') {ALL_TWIST += 2*PI; }
  if(key=='<') {ALL_TWIST -= 2*PI; }
  if(key=='/') {TWIST = 0;}
  if(key=='h') {tangentway ++;}
  //if(key=='k') {showElbows = !showElbows;}
  if(key=='y') {RADIUS = 5.;}
  if(key=='1') {if (EPSILON < 0.05) EPSILON = 0.1 ; else EPSILON = 0.01;}
  if(key=='-') {tightness++;} 
  /* End Linh */
  /* Abdurrahmane & Linh */
  if(key=='R') {RikliWay =! RikliWay; LinhWay =! LinhWay;}
  /* End Abdurrahmane & Linh */
  if(key=='3') {P.resetOnCircle(3,300); Q.copyFrom(P);}
  if(key=='4') {P.resetOnCircle(4,400); Q.copyFrom(P);}
  if(key=='5') {P.resetOnCircle(5,500); Q.copyFrom(P);}
  if(key=='^') track=!track;
  if(key=='q') Q.copyFrom(P);
  if(key=='p') P.copyFrom(Q);
  if(key==',') {level=max(level-1,0); f=0;}
  if(key=='.') {level++;f=0;}
  if(key=='e') {R.copyFrom(P); P.copyFrom(Q); Q.copyFrom(R);}
  if(key=='d') {P.set_pv_to_pp(); P.deletePicked();}
  if(key=='i') P.insertClosestProjection(Of); // Inserts new vertex in P that is the closeset projection of O
  if(key=='W') {P.savePts("data/pts"); Q.savePts("data/pts2");}  // save vertices to pts2
  if(key=='L') {P.loadPts("data/pts"); Q.loadPts("data/pts2");}   // loads saved model
  if(key=='w') P.savePts("data/pts");   // save vertices to pts
  if(key=='l') P.loadPts("data/pts"); 
  if(key=='a') {animating=!animating; P.setFifo();}// toggle animation
  if(key=='^') showVecs=!showVecs;
  if(key=='#') exit();
  /* Ruth */
  if(key=='[') { ALL_TWIST_P -= 2*PI; }
  if(key==']') { ALL_TWIST_P += 2*PI; }
  if(key=='2') {numOfPaths += 1;}
  if(key=='s') {numOfPaths -= 1;}
  if(key == 'g' ){renderOriginalPath = !renderOriginalPath;}
  if(key=='v') {
    if((braidType + 1) == 6) {
      braidType = 0;
    } else {
      braidType = braidType +=1;
    }
  }
  if(key =='j'){renderBarc = !renderBarc;}
  if(key ==';'){showLatticeStructure = !showLatticeStructure;}    
  if(key =='\''){showRotatingK = !showRotatingK;}
  if(key =='o'){showCenterLine = !showCenterLine;}
  /* End Ruth */
  change=true;   // to save a frame for the movie when user pressed a key 
  }

void mouseWheel(MouseEvent event) 
  {
  dz -= event.getAmount(); 
  change=true;
  }

void mousePressed() 
  {
  //if (!keyPressed) picking=true;
  if (!keyPressed) {P.set_pv_to_pp(); println("picked vertex "+P.pp);}
  if(keyPressed && key=='a') {P.addPt(Of);}
//  if(keyPressed && (key=='f' || key=='s' || key=='b' || key=='c')) {P.addPt(Of,key);}

 // if (!keyPressed) P.setPicked();
  change=true;
  }
  
void mouseMoved() 
  {
  //if (!keyPressed) 
  if (keyPressed && key==' ') {rx-=PI*(mouseY-pmouseY)/height; ry+=PI*(mouseX-pmouseX)/width;};
  if (keyPressed && key=='`') dz+=(float)(mouseY-pmouseY); // approach view (same as wheel)
  change=true;
  }
  
void mouseDragged() 
  {
  if (!keyPressed) P.setPickedTo(Of); 
//  if (!keyPressed) {Of.add(ToIJ(V((float)(mouseX-pmouseX),(float)(mouseY-pmouseY),0))); }
  if (keyPressed && key==CODED && keyCode==SHIFT) {Of.add(ToK(V((float)(mouseX-pmouseX),(float)(mouseY-pmouseY),0)));};
  if (keyPressed && key=='x') P.movePicked(ToIJ(V((float)(mouseX-pmouseX),(float)(mouseY-pmouseY),0))); 
  if (keyPressed && key=='z') P.movePicked(ToK(V((float)(mouseX-pmouseX),(float)(mouseY-pmouseY),0))); 
  if (keyPressed && key=='X') P.moveAll(ToIJ(V((float)(mouseX-pmouseX),(float)(mouseY-pmouseY),0))); 
  if (keyPressed && key=='Z') P.moveAll(ToK(V((float)(mouseX-pmouseX),(float)(mouseY-pmouseY),0))); 
  if (keyPressed && key=='t')  // move focus point on plane
    {
    if(center) F.sub(ToIJ(V((float)(mouseX-pmouseX),(float)(mouseY-pmouseY),0))); 
    else F.add(ToIJ(V((float)(mouseX-pmouseX),(float)(mouseY-pmouseY),0))); 
    }
  if (keyPressed && key=='T')  // move focus point vertically
    {
    if(center) F.sub(ToK(V((float)(mouseX-pmouseX),(float)(mouseY-pmouseY),0))); 
    else F.add(ToK(V((float)(mouseX-pmouseX),(float)(mouseY-pmouseY),0))); 
    }
  /* Ruth */
  if (keyPressed && key=='u')  // move focus point vertically
    {
      if((float)mouseY-pmouseY < 0) {
        movement += .10;

      } else if((float)mouseY-pmouseY > 0) {
        movement -= .10;

      }
    }
   /* End Ruth */
  change=true;
  }  

// **** Header, footer, help text on canvas
void displayHeader()  // Displays title and authors face on screen
    {
    scribeHeader(title,0); scribeHeaderRight(name); 
    fill(white); 
    //image(myFace, width-myFace.width/2,25,myFace.width/2,myFace.height/2); 
    /* Ruth */

    image(studentFace1, width-studentFace1.width/2 , 0, studentFace1.width/2 , studentFace1.height/2); 
    image(studentFace2, width-studentFace2.width/2 , 120, studentFace2.width/2 , studentFace2.height/2); 
    image(studentFace3, width-studentFace3.width/2 , 300, studentFace3.width/2 , studentFace3.height/2);
    /* End Ruth */


    }
void displayFooter()  // Displays help text at the bottom
    {
    scribeFooter(guide,1); 
    scribeFooter(menu,0); 
    }
/* Ruth */
String title ="3D curve editor", name =" Abdurrahmane Rikli (Mid) \n Linh Hoàng (First) \n Ruth Petit - Bois (Third)", /* End Ruth */
       menu="?:help, !:picture, ~:(start/stop)capture, space:rotate, `/wheel:closer, t/T:target, a:anim, #:quit",
       guide="click&drag:pick&slide on floor, xz/XZ:move/ALL, e:exchange, q/p:copy, l/L:load, w/W:write, m:subdivide method"; // user's guide
