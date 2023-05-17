/*
Dielectric Resonator Geometry & Meshing
April 26, 2023
Jackson Cunniff

Updated: 5/12/23
*/

//Using built in GMSH geometry kernel

mm = 1e-06; b = 50*mm;
lc1 = 1e-05; lc2 = 1e-9; 
ycenter = 15.5*mm; r = 15*mm; theta = Pi/4; //obselete
x = Cos(theta)*r; y = Sin(theta)*r;
cp = 1; cl = 1; //current point and current line indices
Point(cp++) = {-b, -b, 0, lc1}; Point(cp++) = {-b, b, 0, lc1};
Point(cp++) = {b, b, 0, lc1}; Point(cp++) = {b, -b, 0, lc1};
Line(cl++) = {1,2}; Line(cl++) = {2, 3}; Line(cl++) = {3, 4}; Line(cl++) = {4, 1};


Point(cp++) = {0, ycenter, 0, lc1}; //top circle center
Point(cp++) = {-r, ycenter, 0, lc1}; //top circle left
Point(cp++) = {r, ycenter, 0, lc1}; //top circle right
Point(cp++) = {0, ycenter + r, 0, lc1}; // top top 
Point(cp++) = {0, ycenter - r, 0, lc2}; // top bottom 
//Point(cp++) = {-x, -y + ycenter, lc2};
//Point(cp++) = {x, -y + ycenter, lc2};
Circle(cl++) = {(cp-4), 5, (cp-1)};
Circle(cl++) = {(cp-3), 5, (cp-1)};
Circle(cl++) = {7, 5, 6};


Point(cp++) = {0, -ycenter, 0, lc1}; //bottom center
Point(cp++) = {-r, -ycenter, 0, lc1}; //bottom left
Point(cp++) = {r, -ycenter, 0, lc1}; //bottom right
Point(cp++) = {0, -ycenter + r, 0, lc1}; //bottom top
Point(cp++) = {0, -ycenter - r, 0, lc1}; //bottom bottom
Circle(cl++) = {(cp-4), 10, (cp-2)};
Circle(cl++) = {(cp-3), 10, (cp-2)};
Circle(cl++) = {11, 10, 12};

//Point(cp++) = {-x, y - ycenter, lc2};
//Point(cp++) = {x, y - ycenter, lc2};

Curve Loop(cl++) = {1:4};
Curve Loop(cl++) = {5, 7, -6};
Curve Loop(cl++) = {-8, 9, 10}; //cl == 13
Plane Surface(14) = {11, 12, 13}; //gas surface - resonator holes

//Comment out the following 3 lines to create a resonator negative mesh
Plane Surface(15) = {12}; //top resonator surface
Plane Surface(16) = {13}; // bottom resonator surface
Physical Surface("Resonators") = {15, 16}


Physical Surface("Plasma Domain") = {14};
Physical Curve("Inlet") = {1};
Physical Curve("Outlet") = {3};
Physical Curve("Boundary Top") = {2};
Physical Curve("Boundary Bottom") = {4};

/* *** Mesh Settings ***
    
    Transfinite commands will define the mesh density along specified curves
    Progression will determine the spacing / clustering
    Currently entry region is has a desner mesh than exit

*/

//Mesh.Algorithm = 8;
Transfinite Curve{5, 8} = 80; //entrance region for resonators
Transfinite Curve{6, 9} = 50; //exit region for resonators
Transfinite Curve{7, 10} = 10;
Transfinite Curve{1} = 10 Progression 3;

Mesh 2;
RecombineMesh;
Mesh.SubdivisionAlgorithm = 2;
RefineMesh;



