# Tetris_FPGA
Tetris implemented using verilog for DE1_SOC.

# About
This is a term project for CSC258 at University of Toronto.

# Features
- Generate random shape based on LFSR.
- Time and score gets recorded once the game starts.
- Next shape gets viewed before current shape finish falling.
- collision, full line, gameover dectection.

# Input and Output
- Input: On board Keys(Undebounced buttons) and Switches.
  - SW[1]: start
  - SW[0]: active low sychoronous reset
  - KEY[3:0]: Left/Up/Dwon/Right
- Output: VGA Display (160x120, 60Hz).

# Brief Description for Each Module
- tetris: Contains basic game logic.
  - movement_controller: In charge of all the movements and collision detection.
  - board_state_recorder: Updates the current board, full line detection.
  
- control_top: Top control module contains basic fsms, vga modules and datapathes for drawing the game view.

- shape_generator: Randomly generates shapes(each shape has its unique id) based on linear feedback shift register.

- shape_id_decoder: Decodes the shape id to the code for displaying.

- shape_rotator: Detects the current shape position and rotates each 4 tiles by manipulating the x,y coordinates. 

- shape_recognisor: Generates the initial x,y coordinates for each 4 tiles of a given shape id.

- score_convertor: Converts the given score in hex to decimal.

- time_recorder: Records the time and outputs the digit for each time segments.

- digit_decoder: Decodes the digit to a display code to vga.

- alphabet_decoder: Decodes the letter to a display ocde to vga.

# Screenshots
- Find the screenshots in /screenshots folder
