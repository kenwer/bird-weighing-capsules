/*
3D models for weighing birds

Author: Ken Werner

Capsules for weighing birds during bird ringing/banding. The models are intended for 3D printing.

This work is licensed under the licensed under the CC BY-SA 4.0 license. The full text of the Creative Commons Attribution-ShareAlike 4.0 International License can be found at: http://creativecommons.org/licenses/by-sa/4.0/
*/

include <BOSL2/std.scad>
include <BOSL2/threading.scad>


$fn = $preview ? 60 : 120;
nothing = 0.01;
slop = 0.15;


// Toggles visibility of the back half for inspection
show_back_half = true;

// Default thickness of the base stands
stand_thickness = 4;

// Default thickness of the capsule walls (mainly the upper section)
wall_thickness = 2;

// Dimensions of the threaded rod that connects the base with the capsule
threaded_rod_d = 17;
threaded_rod_h = stand_thickness;


// Applies a clipping plane to reveal the rear half of the children.
// clip: if true, wraps children in `back_half()` otherwise it renders them as is.
module half(s=1000, clip=show_back_half) {
  if (clip)
    back_half(s=s)
      children();
  else
    children();
}


// Base 1 stand
module draw_base1(stand_x=100,
                 stand_y=100,
                 stand_thickness=4
                ) {
  // Initial cross
  linear_extrude(height=stand_thickness)
    offset(r=3) offset(delta=-3) // Exterior rounding
    offset(r=-40) offset(delta=40) // Interior rounding (negative rounds interior corners)
      union() {
        square([20, stand_x], center=true);
        square([stand_y, 20], center=true);
      }

  // Connector
  up(stand_thickness)
    threaded_rod(d=threaded_rod_d,
                 l=threaded_rod_h,
                 pitch=1.5,
                 bevel2=0.5,
                 blunt_start1=false,
                 $slop=slop,
                 anchor=BOT);
}


// Base 2, a different base stand (fits certain kind of pocket scales)
module draw_base2(stand_x=80,
                  stand_y=60,
                  stand_thickness=4,
                  border_h=2
                 ) {
  _wall_width = 2;
  _wall_rounding = 4.6;
  diff() {
    // base plate
    cuboid([stand_x+2*_wall_width, stand_y+2*_wall_width, stand_thickness], 
           rounding=_wall_rounding, edges="Z", anchor=BOT);
    // wall
    rect_tube(isize=[stand_x, stand_y], 
              wall=_wall_width, rounding=_wall_rounding, h=border_h, anchor=TOP);

    // Connector
    down(nothing)
      tag("remove") threaded_rod(d=threaded_rod_d,
                                 l=stand_thickness+2*nothing,
                                 pitch=1.5,
                                 internal=true,
                                 bevel1=false,
                                 bevel2=0.5,
                                 blunt_start=false,
                                 $slop=slop,
                                 anchor=BOT);
  }
}


// Connects the Base2 with a capsule
module draw_connector(connector_length=stand_thickness*2) {
  diff() {
    threaded_rod(d=threaded_rod_d,
                 l=connector_length,
                 pitch=1.5,
                 bevel=0.5,
                 blunt_start1=false,
                 $slop=slop);
    up(connector_length/2+nothing)
      tag("remove") cuboid([threaded_rod_d-6, 2, connector_length/2], anchor=TOP);
  }
  // A ring in the middle to prevent screwing in the connector too deep
  cyl(d=threaded_rod_d, l=1, chamfer=0.5);
}


// Main module that draws one capsule with the given dimensions.
//
//      |<---------- id4 ---------->|    ^
//      |                           |    |
//      |                           |    |
//      |                           |    h3
//      |                           |    |
//      |                           |    |
//      |                           |    |
//       \<--------- id3 --------->/     v
//        \                       /      ^
//         \                     /       h2
//          \<------ id2 ------>/        v
//           \                 /         ^
//            \               /          |
//             \             /           h1
//              \           /            |
//               \<- id1 ->/             v
//                 | rod |
//
module draw_capsule(
                    wall_thickness = wall_thickness,
                    id1 = 20, // inner diameter at lower section bottom (capsule base)
                    id2 = 40, // inner diameter at lower/mid section boundary
                    id3 = 60, // inner diameter at mid/upper section boundary
                    id4 = 65, // inner diameter at upper section top (capsule mouth)
                    od1 = undef, // outer diameter of lower+mid sections, default: id2 + 2*wall_thickness
                    h1 = 60, // height of lower section  (id1 -> id2)
                    h2 = 20, // height of mid section    (id2 -> id3)
                    h3 = 30, // height of upper section  (id3 -> id4)
                   ) {
  _od1 = default(od1, id2 + 2*wall_thickness);

  // lower section (bot)
  diff() {
    tube(id1=id1,
         id2=id2,
         h=h1,
         od1=_od1,
         od2=_od1,
         orounding1=-20,
         clip_angle=65,
         anchor=BOT);

    // Cylinder to carve out the threaded_rod
    _thread_clearance = 1; // extra depth so the rod doesn't bottom out
    up(nothing)
      cyl(d=id1 + 2*wall_thickness,
          h=threaded_rod_h+_thread_clearance-2*nothing,
          anchor=BOT);
    tag("remove") threaded_rod(d=threaded_rod_d,
                               l=threaded_rod_h+_thread_clearance,
                               pitch=1.5,
                               internal=true,
                               bevel=true,
                               blunt_start=false,
                               $slop=slop,
                               anchor=BOT);
  }

  // middle section (mid)
  up(h1)
    tube(id1=id2,
         id2=id3,
         h=h2,
         od1=_od1,
         od2=id3+2*wall_thickness,
         anchor=BOT);

  // upper section (top)
  up(h1+h2)
    tube(id1=id3,
         id2=id4,
         h=h3,
         od1=id3+2*wall_thickness,
         od2=id4+2*wall_thickness,
         irounding2=wall_thickness*0.8,
         orounding2=wall_thickness*0.2,
         anchor=BOT);
}

// Draw Base 1
fwd(80)
  draw_base1(stand_x=100,
             stand_y=100,
             stand_thickness=4
            );

// Draw Base 2
fwd(80) left(110)
  draw_base2(stand_x=76.2,
             stand_y=64.8,
             stand_thickness=4,
             border_h=3
            );

// Draw Connector for Base 2
fwd(30) left(110)
  draw_connector(connector_length=stand_thickness*2-0.4);

// Variant 1
// For Lymnocryptes minimus (Jack snipe, Zwergschnepfe)
half()
  draw_capsule(
    wall_thickness = wall_thickness,
    id1 = 16, // inner diameter at lower section bottom (capsule base)
    id2 = 37, // inner diameter at lower/mid section boundary
    id3 = 57, // inner diameter at mid/upper section boundary
    id4 = 65, // inner diameter at upper section top (capsule mouth)
    //od1 = 37+2*wall_thickness, // outer diameter of lower+mid sections (same as default, no need to set)
    h1 = 100, // height of lower section  (id1 -> id2)
    h2 = 20,  // height of mid section    (id2 -> id3)
    h3 = 45,  // height of upper section  (id3 -> id4)
  );

// Variant 2
// From Regulus regulus (Goldcrest, Wintergoldhähnchen)
//   to Sylvia borin (Garden warbler, Gartengrasmücke)
left(80) half()
  draw_capsule(
    wall_thickness = wall_thickness,
    id1 = 10, // inner diameter at lower section bottom (capsule base)
    id2 = 16, // inner diameter at lower/mid section boundary
    id3 = 30, // inner diameter at mid/upper section boundary
    id4 = 33, // inner diameter at upper section top (capsule mouth)
    od1 = 30+2*wall_thickness, // outer diameter of lower+mid sections (= id3 + 2*wall_thickness)
    h1 = 28,  // height of lower section  (id1 -> id2)
    h2 = 12,  // height of mid section    (id2 -> id3)
    h3 = 35,  // height of upper section  (id3 -> id4)
  );

// Variant 3
// From Sylvia borin (Garden warbler, Gartengrasmücke)
//   to Coccothraustes coccothraustes (Hawfinch, Kernbeißer)
left(140) half()
  draw_capsule(
    wall_thickness = wall_thickness,
    id1 = 16, // inner diameter at lower section bottom (capsule base)
    id2 = 22, // inner diameter at lower/mid section boundary
    id3 = 34, // inner diameter at mid/upper section boundary
    id4 = 36, // inner diameter at upper section top (capsule mouth)
    od1 = 34+2*wall_thickness, // outer diameter of lower+mid sections (= id3 + 2*wall_thickness)
    h1 = 28,  // height of lower section  (id1 -> id2)
    h2 = 12,  // height of mid section    (id2 -> id3)
    h3 = 45,  // height of upper section  (id3 -> id4)
  );

// Variant 4
// From Coccothraustes coccothraustes (Hawfinch, Kernbeißer)
//   to
//      Dendrocopos major (Great spotted woodpecker, Buntspecht)
//      Turdus philomelos (Song thrush, Singdrossel)
//      Turdus merula (Common blackbird, Amsel)
left(210) half()
  draw_capsule(
    wall_thickness = wall_thickness,
    id1 = 16, // inner diameter at lower section bottom (capsule base)
    id2 = 34, // inner diameter at lower/mid section boundary
    id3 = 50, // inner diameter at mid/upper section boundary
    id4 = 52, // inner diameter at upper section top (capsule mouth)
    od1 = 50+2*wall_thickness, // outer diameter of lower+mid sections (= id3 + 2*wall_thickness)
    h1 = 41,  // height of lower section  (id1 -> id2)
    h2 = 13,  // height of mid section    (id2 -> id3)
    h3 = 53,  // height of upper section  (id3 -> id4)
  );

// Variant 5
// Picus viridis (European green woodpecker, Grünspecht)
// Gallinula chloropus (Common moorhen, Teichralle)
left(300) half()
  draw_capsule(
    wall_thickness = wall_thickness,
    id1 = 16, // inner diameter at lower section bottom (capsule base)
    id2 = 45, // inner diameter at lower/mid section boundary
    id3 = 65, // inner diameter at mid/upper section boundary
    id4 = 70, // inner diameter at upper section top (capsule mouth)
    od1 = 50+2*wall_thickness, // outer diameter of lower+mid sections (custom, default: id2 + 2*wall_thickness)
    h1 = 52,  // height of lower section  (id1 -> id2)
    h2 = 15,  // height of mid section    (id2 -> id3)
    h3 = 70,  // height of upper section  (id3 -> id4)
  );

// Variant 6
// Columba palumbus (Common wood pigeon, Ringeltaube)
// Anas platyrhynchos (Mallard, Stockente)
left(410) half()
  draw_capsule(
    wall_thickness = wall_thickness,
    id1 = 45,  // inner diameter at lower section bottom (capsule base)
    id2 = 60,  // inner diameter at lower/mid section boundary
    id3 = 95,  // inner diameter at mid/upper section boundary
    id4 = 100, // inner diameter at upper section top (capsule mouth)
    h1 = 52,   // height of lower section  (id1 -> id2)
    h2 = 25,   // height of mid section    (id2 -> id3)
    h3 = 100,  // height of upper section  (id3 -> id4)
  );
