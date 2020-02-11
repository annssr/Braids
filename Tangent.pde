/*Linh*/

vec[] simpleTang(pts P) {
  fill(red);
  vec[] p = new vec[P.nv];
  for (int i = 0; i < P.nv;i++) {
    int j = i == 0 ? P.nv - 1 : i - 1;
    p[i] = U(P.G[j], P.G[(i + 1) % P.nv]);
  }
 
  return p;
}

vec[] pccTang(pts P) {
  if (P.nv < 5) return simpleTang(P);
  vec[] p = new vec[P.nv];

  for (int i = 0; i < P.nv; i++) {
    pt P1 = P.G[i];
    pt P2 = P.G[(i + 1) % P.nv];
    pt P3 = P.G[(i + 2) % P.nv];
    pt P4 = P.G[(i + 3) % P.nv];
    pt P5 = P.G[(i + 4) % P.nv];
    
    TangentInfo ti1 = new TangentInfo(P1, P2, P3);
    TangentInfo ti2 = new TangentInfo(P2, P3, P4);
    TangentInfo ti3 = new TangentInfo(P3, P4, P5);
    p[(i + 2) % P.nv] = ti1.weighted(ti2, ti3);

  }
  return p;
}

vec[] spiralTang(pts P) {
  if (P.nv < 5) return simpleTang(P);
  vec[] p = new vec[P.nv];
  vec[] le = new vec[P.nv];
  
  vec K = cross(V(P.G[0], P.G[1]), V(P.G[1], P.G[2]));

  for (int i = 0; i < P.nv; i++) {
    int j = i == 0 ? P.nv - 1 : i - 1;
    p[i] = U(P.G[j], P.G[(i + 1) % P.nv]);
  }
  for (int i = 0; i < P.nv; i++) {
    int j = i == 0 ? P.nv - 1 : i - 1;
    le[i] = LPM(0,1, p[j], 0.5, p[(i+1) % P.nv], K);
  }
  return le;
}
  


class TangentInfo {
  vec v;
  vec w;
  vec n;
  vec R;
  pt o;
  float r;
  vec t;
  TangentInfo(pt p1, pt p2, pt p3) {
    v = V(p2, p1);
    w = V(p2, p3);
    n = U(N(v, w));
    R = V(dot(v,v) / 2, N(w, n)).add(V(dot(w,w) / 2, N(n, v)));
    o = P(p2,R);
    r = R.norm();
    t = N(n, V(o, p2));
  }
  
  vec weighted(TangentInfo ti2, TangentInfo ti3) {
    vec s = V(r, t).add(ti2.r, ti2.t).add(ti3.r, ti3.t);
    return V(1./(r+ ti2.r+ti3.r), s).normalize();
  }
  
}
/*End Linh*/

  vec LPM(float a, float b, float c, vec P1, float t, vec Q1, vec E1, vec K) // LPM iteration two
  {
  //Abdurrahmane*
  vec S = LPM(a, b , P1, t, Q1,K);
  vec F = LPM(b, c , Q1, t, E1,K);
  return LPM(a, c, S, t, F, K);
  //*Abdurrahmane
  }
  
 vec LPM(float a, float b, vec P1, float t, vec Q1, vec K) // LPM iteration one
  {
  //Abdurrahmane*
  pt O = P(0,0,0);
  Similarity s = new Similarity(O, P(O,P1), O, P(O, Q1), K);
  pt At = s.apply((t - a) / (b - a), O);
  pt Bt = s.apply((t - a) / (b - a), P(O,P1));
  return V(At,Bt);
  //*Abdurrahmane
  }
