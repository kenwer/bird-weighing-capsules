# Bird Weighing Capsules

Parametric OpenSCAD models for capsules to weigh birds during ringing and banding operations. A capsule holds the bird securely while it is placed on a scale, minimizing stress and movement. All parts are designed for FDM 3D printing.

**License:** [CC BY-SA 4.0](http://creativecommons.org/licenses/by-sa/4.0/)  
**Author:** Ken Werner

---

## Overview
The capsule is a tapered cone that narrows toward the bottom, keeping the bird calm and still in a natural head-down posture. It screws onto a threaded base stand that sits on a digital scale. Six size variants are provided, covering species from the Goldcrest (*Regulus regulus*, ~5 g) to the Mallard (*Anas platyrhynchos*, ~1000 g).

![Image](https://github.com/user-attachments/assets/f6e2e6af-6815-49ac-a95d-b1830141d006)

## Models
| Part | Description |
|---|---|
| Capsule | The main holding cone; six size variants (can be customized) |
| Base 1 | Cross-shaped stand with a threaded rod; general purpose |
| Base 2 | Rectangular stand that fits a pocket scale tray (76 × 64.6 mm); threaded socket |
| Connector | Double-ended threaded coupler for joining Base 2 to a capsule |

Base 1 and the capsule use a male/female threaded connection (17 mm diameter, 1.5 mm pitch). Base 2 has an internal thread and requires the connector piece.

## Size Variants
| Variant | Species | Common Name | German Name |
|---|---|---|---|
| 1 | *Lymnocryptes minimus* | Jack snipe | Zwergschnepfe |
| 2 | *Regulus regulus* – *Sylvia borin* | Goldcrest – Garden warbler | Wintergoldhähnchen – Gartengrasmücke |
| 3 | *Sylvia borin* – *Coccothraustes coccothraustes* | Garden warbler – Hawfinch | Gartengrasmücke – Kernbeißer |
| 4 | *Coccothraustes coccothraustes* – *Turdus merula*, *Dendrocopos major*, *Turdus philomelos* | Hawfinch – Blackbird, Great spotted woodpecker, Song thrush | Kernbeißer – Amsel, Buntspecht, Singdrossel |
| 5 | *Picus viridis*, *Gallinula chloropus* | European green woodpecker, Common moorhen | Grünspecht, Teichralle |
| 6 | *Columba palumbus*, *Anas platyrhynchos* | Wood pigeon, Mallard | Ringeltaube, Stockente |

## Requirements
- [OpenSCAD](https://openscad.org/) (any recent version)
- [BOSL2](https://github.com/BelfrySCAD/BOSL2) library — place it in your OpenSCAD library path

## Usage
Open `BirdWeighingCapsule.scad` in OpenSCAD. The file renders all variants and base stands side by side in the preview. To export a single part for printing, comment out the parts you do not need and export as STL (F6 to render, then File -> Export -> STL or 3mf).

### Key parameters
| Parameter | Default | Description |
|---|---|---|
| `wall_thickness` | 2 mm | Shell thickness throughout the capsule |
| `show_back_half` | `true` | Cuts the model in half for inspection; set to `false` before exporting |
| `threaded_rod_d` | 17 mm | Thread outer diameter (shared across all parts) |
| `threaded_rod_h` | 5 mm | Thread engagement depth |
| `slop` | 0.15 mm | Clearance added to mating threaded surfaces for print tolerance |

### Customizing capsule dimensions
`draw_capsule()` accepts explicit inner diameters (`id1`–`id4`) and section heights (`h1`–`h3`) for each of the three tapered sections. Adjust these values to fit additional species or scale platform sizes.

```
     |<---------- id4 ---------->|    ^
     |                           |    |
     |                           |    |
     |                           |    h3
     |                           |    |
     |                           |    |
     |                           |    |
      \<--------- id3 --------->/     v
       \                       /      ^
        \                     /       h2
         \<------ id2 ------>/        v
          \                 /         ^
           \               /          |
            \             /           h1
             \           /            |
              \<- id1 ->/             v
                | rod |
```

## Printing Notes
- Print capsules upright (open end up) without supports.
- Base 2 should be printed upside down, then no supports are needed.
- The threaded interfaces also print without supports due to the bevel geometry.
- Adjust `slop` if threads are too tight or too loose for your printer.
- PETG or ASA is recommended for outdoor use.
