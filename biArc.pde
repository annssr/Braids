/* Abdurrahmane */

int braidType = 0;
/* End Abdurrahmane */

/* Ruth */

float numOfPaths = 0;
boolean renderBarc = false;
float movement = 0.;
boolean showElbows = true;
boolean renderOriginalPath = false;
boolean showLatticeStructure = false;
boolean showRotatingK = false;
boolean showCenterLine = false;
/* End Ruth */

/* Linh */
int tangentway = 0;

ArrayList<biArc> createBiArc(pts P) {
  vec[] tangents;
  if (tangentway % 3 ==0 ) 
    tangents = spiralTang(P);
  else if (tangentway % 3 == 1)
    tangents = simpleTang(P);
   else tangents = pccTang(P);
  ArrayList<biArc> result = new ArrayList<biArc>();
  for (int i = 0; i < P.nv; i++) {
    vec S = V(P.G[i],P.G[(i + 1) % P.nv]);
    vec T = A(tangents[i], tangents[(i + 1) % P.nv]);
    float d,a;
    if( Float.compare(dot(T,T), 4.) == 0) {
      a = dot(S,S) / (4.*dot(S, tangents[i]));
    } else {
       d = (dot(S,T)*dot(S,T)) + dot(S,S)* (4. - dot(T,T));
       a = (sqrt(d) - dot (S,T)) / (4. - dot(T,T));
    }
    pt mid1 = P(P.G[i], a, tangents[i]);
    pt mid2 = P(P.G[(i + 1) % P.nv], -a, tangents[(i + 1) % P.nv]);
    pt mid3 = P(mid1, 0.5, mid2);
    result.add(new biArc(P.G[i], mid1, mid3));
    result.add(new biArc(mid3, mid2, P.G[(i + 1) % P.nv]));
  }
  return result;
}

// The global variables
float TWIST = 0.;
float Init_TWIST = 0.;

/* End Linh */

/* Ruth */
float P_TWIST = 0.;
float Init_TWIST_P = 0.;
vec rotatingK_P = V(0., 0., 0.); // The rotating vector, its value starts with 0's, but is updated depending on the rotation

/* End Ruth */

/* Linh & Abdurrahmabe */
float RADIUS = 20.0;
vec rotatingK = V(0., 0., 0.); // The rotating vector, its value starts with 0's, but is updated depending on the rotation


boolean firstElbow = true; // Temporary code to check if this thing even functions properly
vec Cu_Cu1; // The vector upon which we rotate rotatingK, defined as the displacement between points C(u) and C(u+EPSILON)

boolean RikliWay = true, LinhWay = false; // RikliWay is the one implementing rotatingK

static float EPSILON = 0.1;
/* End Linh & Abdurrahmane */

/* Ruth */
class biArc {
  //float twist = 0; This doesn't work, since I assume a new biArc is initialized each update, which turns it to zero
  float startAngle = 0;
  
  float x;
  float alpha; // Angle between pt A and C
  float delta; // Angle between old K and this normal
  vec I; // ORigin to A
  vec J; // Origin to C
  
  pt O; // origin
  pt ptA; // pt A on triangle
  pt ptB; // pt B on triangle
  pt ptC; // pt C on triangle
  
  float radius; // Radius of circle
  vec K; // axis 
  
  //Initialize the BiArc
  biArc (pt A, pt B, pt C) {
    ptA = A;
    ptB = B;
    ptC = C;
    
    // edgees of the triangle
    vec AB = V(A,B); 
    vec BA = V(B,A);
    vec BC = V(B,C);
    
    // calculate origin
    x = dot(AB, AB) / (dot(BA, BA) + dot(BA, BC));
    O = P(B, V(x, BA.add(BC))); 
    // show origin
    //fill(pink);
    //show(O,30);
    
    // I vector Origin to PT A
    I = V(O,A).normalize();
    J = V(O,C).normalize();
    // Get radius between OA and OC
    //radius = d(O, A);

    // Calculate Midpoint -- formulas in PCC Paper
    vec U = V(B,A); //<>//
    vec V = V(B,C);
    vec Y = V(A,C);
    
    float a = n(U); // Same distance isoceles triagle
    float h = n(Y)/2;      
    float m = a/(a+h);
    

    radius = d(O, A); 
    
    // Verifies Calculation of K Axis
    K = cross(V(O,A), V(O,C)).normalize();
    // Check if this is the first elbow, or if we should let K inherit the rotatingK's value
    //if(rotatingK.x != 0 || rotatingK.y != 0 || rotatingK.z != 0)
    //if(!firstElbow)//For some reason, this is causing only the first elbow to show?
    //  K = rotatingK;
    //else
    //  firstElbow = false;
    //fill(red);
    //arrow(O, K, 20);
    
    // Get angle between A and C
    alpha = angle(V(O, A), V(O, C));
    //angle = angle(V(O, A), V(O, Mid));
    J = V(O,C);
    IxK = cross(I, K).normalize().mul(-1);

  } //<>// //<>//
  
  vec IxK;
  /* End Ruth */
  
  /* Linh */
  float estimateInitTwist(vec d) {
    fill(black);
    vec n1 = V(IxK).mul(-1).normalize();
    vec proj = V(d).add(V(n1).mul(-dot(d, n1)));
    float dt = dot(proj, K);
    float de = dot(n1, cross(proj, K));
    return atan2(de, dt);
    
  }
  
  vec draw(float addedTwist, boolean fakedraw) {
    pushMatrix();
    translate(0,0,100);
    //println(addedTwist);
    vec d = render(addedTwist, fakedraw);
    popMatrix();
    return d;
  }
  
  /* Linh */
  
  /* Ruth */
  
  pt drawBiArc(float t){ //C(u)
   
    // Calculate C(u)
    //Normalize vectors
    //vec tempI = rotate(K, I, t * alpha + t * TWIST); This one caused the crazy rotation in the video on the Drive. Might have some value later

    float centerLineLeft = radius*cos(t*alpha);
    float centerLineRight = radius*sin(t*alpha);

    vec centerLineCalcLeft = V(centerLineLeft, I);
    vec centerLineCalcRight = V(IxK).mul(centerLineRight);
    vec centerLineVec = centerLineCalcLeft.add(centerLineCalcRight);
    //vec centerLineVec = rotate(I, centerLineCalcLeft.add(centerLineCalcRight), t*alpha + t * TWIST);
    pt centerLinePoint = P(O,centerLineVec);
    if(showCenterLine == true) {
      fill(green);
      show(centerLinePoint, 4);
    }

    return centerLinePoint;

  }
  
  /* End Ruth */
  
  /* Abdurrahmane & Linh */
   pt renderBiarc(float v, pt Cu, float a) {
            
       //S(u,v) = C(u) + r * cos(v * 2ℼ) * Io(u*alpha*2pi, K)  +  r * sin(v * 2ℼ) * K
       
       //r * sin(v * 2ℼ) * K
       //Rotate K a tad
       vec currentK; // To decide whether we follow Rikli's rotation, or Linh's
       if(RikliWay){
         currentK = rotatingK;
       }
       else
         currentK = K;
       vec vecK = V(currentK).normalize();
       //vecK = rotate(I, vecK, alpha + t * TWIST);
       vec rightSegment = vecK.mul(RADIUS*sin(v*2*PI));
       //r * cos(v * 2ℼ)
       vec CuO = V(Cu, O).normalize();
       //fill(red);
       //arrow(Cu, O, 5);
       if(RikliWay){
         CuO = lrot(CuO, Cu_Cu1, a);
       }
       vec leftSegment = CuO.mul(RADIUS*cos(v*2*PI));
             
       vec biarcQuad = rightSegment.add(leftSegment);
       return P(Cu, biarcQuad);

   }
   
  vec render(float addedTwist, boolean fakedraw){
    //float i = 0;
    
    Dif rdiff = new Dif(0., 0.25);
    Dif ydiff = new Dif(0.25, .5);
    Dif odiff = new Dif(.5, 0.75);

    float temp_twist = 0;
    
    /* Ruth */
    float temp_twist_p = 0;
    /* Ennd Ruth */

    for(float i = 0; i < 1; i += EPSILON){
      pt Cu = drawBiArc(i);
      pt Cu1 = drawBiArc(i + EPSILON);
      // Get CuO
      if(RikliWay){
        Cu_Cu1 = V(Cu, Cu1);

        temp_twist = (TWIST + addedTwist)*i;
        
        /* Ruth */
        temp_twist_p = (P_TWIST + addedTwist)*i;
        /* End Ruth */

        rotatingK = lrot(K, Cu_Cu1, Init_TWIST + temp_twist);
        
        /* Ruth */
        rotatingK_P = lrot(K, Cu_Cu1, Init_TWIST_P + temp_twist_p ); // Add twists to Path P so that it twists regardless if independent or dependent on stripes // + Init_TWIST + temp_twist
        /* End Ruth */

      } else {
          rdiff.twist(TWIST / 100.);
          ydiff.twist(TWIST / 100.);
          odiff.twist(TWIST / 100.);
          
      }
      beginShape(QUAD);

        for (float j = 0; j < 1 - EPSILON; j += EPSILON) {
          float jTemp = j;
          if(RikliWay){
            if (jTemp < 0.25) {
              fill(yellow);
            } else if (jTemp < 0.5) {

              fill(red);
            } else if (jTemp < 0.75) {

              fill(orange);
            } else fill(pink);
          }
          else if(LinhWay){
         
            if (rdiff.inDif(j)) {
              fill(red);
            } else if (ydiff.inDif(j)) {

              fill(yellow);
            } else if (odiff.inDif(j)) {
              fill(orange);
            } else fill(pink);
          }
          if (!fakedraw && showElbows == true) {
            if(renderBarc == true) {
              if(showLatticeStructure == true) {
                v(renderBiarc(j,Cu, Init_TWIST+ temp_twist));
                v(renderBiarc(j + EPSILON,Cu, Init_TWIST+ temp_twist));
                v(renderBiarc(j + EPSILON,Cu1, Init_TWIST+ temp_twist));
                v(renderBiarc(j,Cu1, Init_TWIST+ temp_twist));
              }
              /* Ruth */

              if(showRotatingK == true) {
                if(j == 0) {
                  fill (red);
                  arrow(Cu, renderBiarc(j,Cu1, Init_TWIST+ temp_twist), 4);
                }
              }
              /* End Ruth */

            } else {
              /* Ruth */

              if(renderBarc == true) {
                if(showLatticeStructure == true) {

              /* End Ruth */

                  renderBiarc(j,Cu, Init_TWIST+ temp_twist);
                  renderBiarc(j + EPSILON,Cu, Init_TWIST+ temp_twist);
                  renderBiarc(j + EPSILON,Cu1, Init_TWIST+ temp_twist);
                  renderBiarc(j,Cu1, Init_TWIST+ temp_twist); 
                }
              }
              /* Ruth */
              if(showRotatingK == true) {
                if(j == 0) {
                  fill (red);
                  arrow(Cu, renderBiarc(j,Cu1, Init_TWIST+ temp_twist), 4);
                }
              }
              /* End Ruth */
            }
          }
  
        }
      endShape();
      
        /* Ruth */
        if(renderOriginalPath == true) {
          if(!fakedraw){
            renderPathP(20.00, Cu, (Init_TWIST_P + temp_twist_p), black, 0.);
            //renderPathP(20.00, Cu.add(index, rotatingK), (randomNumberList.get(y)+ temp_twist_p), colorList.get(y));
          }
        /* Ruth */
        
        /* Abdurrahmane & Ruth */
        } else {
         if (!fakedraw) {
          //pt pathCu = Cu.add(movement,rotatingK);
           pt[] p = braid(Cu, V(20* (1/tightness), rotatingK), V(20, cross(rotatingK, Cu_Cu1)), Cu_Cu1, (int)numOfPaths, i, braidType);
           //pt[] braid(pt origin, vec reference, vec referenceOrthogonal, vec axis, int numOfThreads, float period, int method){

          for(int rr = 0; rr < p.length; rr++){
            fill(colorList.get(rr));
            show(p[rr], 3);
          }
         }
      }
      /* Abdurahmane & Ruth */
      
    }
    
    Init_TWIST += temp_twist;
    
    /* Ruth */
    Init_TWIST_P += temp_twist_p ;
    /* End Ruth */
    
    return V(rotatingK);

  }
  /* End Abdurrahmane & Linh */
  
  
  /* Ruth */
  void renderPathP(float p, pt C, float a, color fillColor, float random) {
       
       float r = 20.0;
       //Rotate K a tad
       vec currentK_P; // To decide whether we follow Rikli's rotation, or Linh's
       if(RikliWay)
           currentK_P = rotatingK_P;
       else
         currentK_P = K;
       vec vecK = V(currentK_P).normalize();
       vec rightSegment = vecK.mul(r*sin(p*2*PI));
       vec CuO = V(C, O).normalize();

       if(RikliWay){
         if((int)random % 2 == 0) {
           CuO = lrot(CuO, Cu_Cu1, a+random);
         } else {
           a = a*-1;
           CuO = lrot(CuO, Cu_Cu1, (a-random));
         }
       }

       vec leftSegment = CuO.mul(r*cos(p*2*PI));
       vec biarcQuad = rightSegment.add(leftSegment).mul(-1);
       fill(fillColor);
       show(P(C, biarcQuad), 3);       

  }
 
}
/* End Ruth */

/* Linh */
  
  vec lrot(vec tempI, vec tempK, float alpha /*alpha in radian*/ ){ //C(u)

    // Calculate C(u)
    //Normalize vectors
    vec IxK = cross(tempI,tempK).normalize().mul(-1);
    float length = tempI.norm();
    vec normalizeI = V(tempI).normalize();
    float centerLineLeft = length*cos(alpha);
    float centerLineRight = length*sin(alpha);

    vec centerLineCalcLeft = V(centerLineLeft, normalizeI);
    vec centerLineCalcRight = IxK.mul(centerLineRight);
    return centerLineCalcLeft.add(centerLineCalcRight);
  }
  
  /* Linh */
  
/* Abdurrahmane */

//For twisting the paths
static final int DOUBLE_HELIX = 0, SINE = 1, COSINE = 2, SINECOSINESINGLE = 3, SINECOSINESERIES = 4, SINEALT = 5;
static float tightness = 1;
pt[] braid(pt origin, vec reference, vec referenceOrthogonal, vec axis, int numOfThreads, float period, int method){
    //Need to set a magnitude for each vector used here... //<>//
    pt[] points = new pt[numOfThreads];
    float delta = 2 * PI / numOfThreads;
    vec vector_displace = V(reference);
    pt point_displaced = new pt(); point_displaced.setTo(origin);
    vec angle;
     //<>//
    switch(method){
      case DOUBLE_HELIX: // The twist is what makes this
        for(int i = 0; i < numOfThreads; i++){
          //vector_displace.rotate(i * delta, reference, referenceOrthogonal);
          vector_displace = lrot(reference, axis, i * delta);
          point_displaced.add(vector_displace);
          points[i] = P(point_displaced);
          vector_displace = V(reference);
          point_displaced = point_displaced.setTo(origin);
        }
        break;
      case SINE:
        for(int i = 0; i < numOfThreads; i++){
          vector_displace = lrot(vector_displace, axis, i * delta); // Vector to start point
          angle = vector_displace;
          vector_displace = lrot(vector_displace, axis, delta); // Vector to end point (and next sector's start point)
          point_displaced.add(angle); // Move point to start point
          vector_displace.sub(angle); // Vector for point to oscillate on
          point_displaced.add(vector_displace.mul(sin(period * 2 * PI ))); // Displace point by oscillated value
          points[i] = P(point_displaced);
          vector_displace = V(reference); // Reset vector
          point_displaced = point_displaced.setTo(origin); // Reset point
        }
        break;
      case COSINE:
        for(int i = 0; i < numOfThreads; i++){
          vector_displace = lrot(vector_displace, axis, i * delta); // Vector to start point
          angle = vector_displace;
          vector_displace = lrot(vector_displace, axis, delta); // Vector to end point
          point_displaced.add(angle); // Move point to start point
          vector_displace.sub(angle); // Vector for point to oscillate on
          point_displaced.add(vector_displace.mul(cos(period * 2 * PI))); // Displace point by oscillated value
          points[i] = P(point_displaced);
          vector_displace = V(reference); // Reset vector
          point_displaced = point_displaced.setTo(origin); // Reset point
          ////angle = vector_displace.rotate(i * delta, reference, referenceOrthogonal); // Vector to start point
          //angle = vector_displace;

          //vector_displace.rotate(delta, reference, referenceOrthogonal); // Vector to end point (and next sector's start point)
          //point_displaced.add(angle); // Move point to start point
          //vector_displace.sub(angle); // Vector for point to oscillate on
          //point_displaced.add(vector_displace.mul(cos(period * 2 * PI))); // Displace point by oscillated value
          //points[i] = point_displaced;
          //vector_displace = V(reference); // Reset vector
          //point_displaced = point_displaced.setTo(origin); // Reset point
        }
        break;
      case SINECOSINESINGLE: // Assuming we want a single pair of sinecosine
        points = new pt[2];
        points[0] = P(point_displaced.add(reference.mul(sin(period * 2 * PI))));
        point_displaced = point_displaced.setTo(origin);
        points[1] = P(point_displaced.add(referenceOrthogonal.mul(cos(period * 2 * PI))));
        break;
      case SINECOSINESERIES: // Assuming we want alternating pairs
        points = new pt[numOfThreads * 2];
        delta = PI / numOfThreads; // Redistribute the delta for half the circle instead
        for(int i = 0; i < numOfThreads*2; i+=2){
          // Sine sector
          vector_displace = lrot(vector_displace, axis, i * delta); // Vector to start point
          angle = vector_displace;
          vector_displace = lrot(vector_displace, axis, numOfThreads * delta); // Vector to end point
          point_displaced.add(angle); // Move point to start point
          vector_displace.sub(angle); // Vector for point to oscillate on
          point_displaced.add(vector_displace.mul(sin(period * 2 * PI))); // Displace point by oscillated value
          points[i] = P(point_displaced);
          vector_displace = V(reference); // Reset vector
          point_displaced = point_displaced.setTo(origin); // Reset point
          // Cosine sector
          vector_displace = lrot(vector_displace, axis, (i+1) * delta); // Vector to start point
          angle = vector_displace;
          vector_displace = lrot(vector_displace, axis, numOfThreads * delta); // Vector to end point
          point_displaced.add(angle); // Move point to start point
          vector_displace.sub(angle); // Vector for point to oscillate on
          point_displaced.add(vector_displace.mul(cos(period * 2 * PI))); // Displace point by oscillated value
          points[i+1] = P(point_displaced);
          vector_displace = V(reference); // Reset vector
          point_displaced = point_displaced.setTo(origin); // Reset point
        }
        break;
      case SINEALT:
        points = new pt[8];
        for(int i = 0; i < 8; i+=2){
          vector_displace = lrot(reference, axis, (i * PI / 2) + sin(period * 2 * PI) * PI);
          points[i] = P(point_displaced.add(vector_displace));
          point_displaced = point_displaced.setTo(origin); // Reset point
          vector_displace = V(reference); // Reset vector
          vector_displace = lrot(reference, axis, PI / 6);
          point_displaced.add(vector_displace);
          angle = lrot(reference, axis, (i * PI / 2) * 4 * PI / 6);
          angle.sub(vector_displace);
          points[i+1] = P(point_displaced.add(angle.mul(cos(period * 2 * PI))));
        }
        break;
      default:
        break;
    }
    return points;
  }
  /* End Abdurrahmane */

/* Linh */

class Dif {
  float ming = 0;
  float maxg = 0;
  Dif(float min, float max) {
    ming = min;
    maxg = max;
  }
  
  boolean inDif(float d) {
    if (maxg < ming) {
       return d <=maxg || d >= ming;
    }
    return d <=maxg && d >= ming;
  } 
  
  void twist(float a) {
    maxg = (maxg + a) % 1.;
    if (maxg == 0)  maxg = 1;
    ming = (ming + a) % 1.;
  }
  
}

/* End Linh */
