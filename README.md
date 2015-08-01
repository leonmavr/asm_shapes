# asm_shapes


## Introduction
This is a project I wrote when I was teaching myself assembly. It is written in 8086  
processor 16-bit DOS assembler language and as the title suggests uses BIOS interrupts  
to draw 2D shapes.

## Motivation
* The project started when found out the interrupt routine that draws a single pixel.   
 With a nested loop I was able to draw a square, a rectangle, and more and more  
 shapes.    
* I then included these algorithms in my own functions, so I was able to draw a number  
 of shapes of a variety of size and colours.  
* Added some user interaction features. The user was then able to selet what shape  
 to draw and where exactly on the screen.

## Installation
* Clone the project.
* The source code is compiled and run on the emu8086 emulator, available here:
https://www.dropbox.com/sh/tvg7johwjqhqkkz/AADR9SXBoJdvlKJy-z9sVbyGa?dl=0
* Open the emulator and open main.asm. Click "emulate" on the menu and when it's  
finished compiling it will be ready to run.  
(img1)

## User Guide
* Once the project starts running, it's time to draw a shape. This is accomplished  
in 4 steps including keystrokes and clicks. Brief instructions are displayed when  
the program starts to run.
1. **[key]** Press a key to select shape. There are four available, selected by entering  
a number between 1 and 4. Any other key will cause the program to exit.  
2. **[key]** Press a key to select colour. Colours corresponding from 0 to 9 are documented,  
however more can be drawn with a litle bit knowledge of binary arithmetic and palettes.  
  0. Black
  1. Blue
  2. Green
  3. Aqua
  4. Red
  5. Fuschia
  6. Dark orange/ light brown
  7. Grey (light)
  8. Grey (dark)
  9. Steel Blue

*(skip this part if you're not interested in techinal details)*
   Drawing a colour not on this list is a bit trickier. Some explanation in the procedure to  
   capture a key from the user is needed.  
   Having pressed a key, an interrupt is called and it is saved as char in the al register.  
   '0' (or 048 in decimal) is subtracted from al to covert it to integer.  
   This integer is stored in a variable which stores the colour. Therefore to select a  
   desired colour:

```
key_pressed = colour + 048
```
   How do we select the colour, e.g. if we wish to draw in yellow?  
   The range of colours that can be used is from 0 to 0x0f, or 16 in decimal, or 1111 in binary.
   Therfore the colouris 4 bits wide. The foremost bit contains information about grey, and the  
   next three about RGB. 
```
MSB       LSB
 v         v       
+--+--+--+--+
|Gr|R |G |B |
+--+--+--+--+
```
Yellow consists of Grey, Red, and Green = 1110b = 14
Therefore the key we'd have to press is 14 + 48 = 62 = > in ASCII.
*(end of technical part)*  
3.  **[key]** The third key is a flag that takes effect only in case triangle has previously  
   been selected.  
   If it is 0, the triangle is drawn pointing upwards otherwis downwards.  
4.  **[click]** The program waits for **two clicks**. These will define the position and size of  
the shape. For the rectangle, these are the top left and bottom right verticles but for  
the other shapes this is not the shapes due to the difficulty of dealing with floats in  
this particular language or adding exessive complexity to the program. The definition  
points are illustrated below.  
(img2)

## Testing
An example output as it being synthesised is shown below.  
(img3.gif)

## Known bugs
1. When choosing to draw a circle, if the secold click is left of the first one, the program.

## Todo
1. Fix bug 1.
2. More colours.
3. Add a background randomiser option, which draws pixels or while shapes at random positions.
