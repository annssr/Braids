//Linh*
class Similarity {
  float scale;
  float angle;
  pt fixed;
   pt a;
   pt b;
   pt c;
   pt d;
   vec K;
  Similarity(pt a0, pt b0, pt a1, pt b1, vec K) {
    a =a0;
    this.K = K;
    b = b0;
    c = a1;
    d = b1;
    vec a0b0 = V(a0, b0);
    vec a1b1= V(a1, b1);
    scale = a1b1.norm() /  a0b0.norm();
    angle = angle(a0b0, a1b1);
    //here
    //if (angle < 0) {
    //  angle += 2*PI;
    //}
    vec a1a0 = V(a1, a0);
    vec w = V(scale * cos(angle) - 1, scale * sin(angle), a0.z);
    vec wL = cross(w, K).normalize().mul(w.norm());
    vec combined = V(dot(w, a1a0), dot(wL, a1a0), a0.z);
    fixed = P(a0, 1/(sq(w.x)+sq(w.y)), combined);
  }
  

  
  pt apply(float t, pt p) {
    vec fp0 = V(fixed, p);
    vec rotated = lrot(fp0, K,t * angle);
    float sc = pow(scale, t);
    return P(fixed, 1, rotated.mul(sc)); 
  }
  
}
//*Linh
