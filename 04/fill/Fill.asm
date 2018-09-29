// This file is part of www.nand2tetris.org
// and the book "The Elements of Computing Systems"
// by Nisan and Schocken, MIT Press.
// File name: projects/04/Fill.asm

// Runs an infinite loop that listens to the keyboard input.
// When a key is pressed (any key), the program blackens the screen,
// i.e. writes "black" in every pixel;
// the screen should remain fully black as long as the key is pressed. 
// When no key is pressed, the program clears the screen, i.e. writes
// "white" in every pixel;
// the screen should remain fully clear as long as no key is pressed.

// Put your code here.
(LOOP)
@KBD
D=M // D = current key
@currkey
M=D // store current key
@R1
M=0 // default fill is 000000000000000
@currkey
D=M // D = current key
@DOFILL
D;JEQ // if no key goto DOFILL
@R1
M=-1 // set fill to 1111111111111111
(DOFILL)
@SCREEN
D=A
@offsetptr
M=D // init offsetptr to screen address
(FILLLOOP)
@KBD
D=A // keyboard offset (end of screen memory)
@offsetptr
D=D-M // distance from offset to end of screen memory
@NEXT
D;JEQ // exit to keyboard loop at end of screen memory
@R1
D=M // load fill
@offsetptr
A=M // dereference offsetptr
M=D // set fill at offset in screen memory
@offsetptr
M=M+1 // increment offsetptr
@FILLLOOP
0;JMP
(NEXT)
@LOOP
0;JMP
