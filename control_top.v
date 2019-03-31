module control_top (
		CLOCK_50,						//	On Board 50 MHz
		// Your inputs and outputs here
        KEY,
        SW,
		// The ports below are for the VGA output.  Do not change.
		VGA_CLK,   						//	VGA Clock
		VGA_HS,							//	VGA H_SYNC
		VGA_VS,							//	VGA V_SYNC
		VGA_BLANK_N,						//	VGA BLANK
		VGA_SYNC_N,						//	VGA SYNC
		VGA_R,   						//	VGA Red[9:0]
		VGA_G,	 						//	VGA Green[9:0]
		VGA_B   						//	VGA Blue[9:0]
	);

    input			CLOCK_50;				//	50 MHz
	input   [9:0]   SW;
	input   [3:0]   KEY;

	// Declare your inputs and outputs here
	// Do not change the following outputs
	output			VGA_CLK;   				//	VGA Clock
	output			VGA_HS;					//	VGA H_SYNC
	output			VGA_VS;					//	VGA V_SYNC
	output			VGA_BLANK_N;				//	VGA BLANK
	output			VGA_SYNC_N;				//	VGA SYNC
	output	[9:0]	VGA_R;   				//	VGA Red[9:0]
	output	[9:0]	VGA_G;	 				//	VGA Green[9:0]
	output	[9:0]	VGA_B;   				//	VGA Blue[9:0]
	
	wire resetn;
	
	assign resetn = KEY[0];
	
	// Create the colour, x, y and writeEn wires that are inputs to the controller.
	wire [2:0] colour;
	wire [7:0] x;
	wire [6:0] y;
	wire writeEn;

	// Create an Instance of a VGA controller - there can be only one!
	// Define the number of colours as well as the initial background
	// image file (.MIF) for the controller.
	vga_adapter VGA(
			.resetn(resetn),
			.clock(CLOCK_50),
			.colour(colour),
			.x(x),
			.y(y),
			.plot(writeEn),
			/* Signals for the DAC to drive the monitor. */
			.VGA_R(VGA_R),
			.VGA_G(VGA_G),
			.VGA_B(VGA_B),
			.VGA_HS(VGA_HS),
			.VGA_VS(VGA_VS),
			.VGA_BLANK(VGA_BLANK_N),
			.VGA_SYNC(VGA_SYNC_N),
			.VGA_CLK(VGA_CLK));
		defparam VGA.RESOLUTION = "160x120";
		defparam VGA.MONOCHROME = "FALSE";
		defparam VGA.BITS_PER_COLOUR_CHANNEL = 1;
		defparam VGA.BACKGROUND_IMAGE = "black.mif";
			
    wire start;
    assign start = KEY[1];
    control c0(CLOCK_50, resetn, start, writeEn, x, y, colour);

endmodule

module control(
    clk,
    resetn,
    start,
    plot,
    x_to_vga,
    y_to_vga,
    color_to_vga
);

    input clk;
    input resetn;
    input start;
    output plot;
    output [7:0] x_to_vga;
    output [6:0] y_to_vga;
    output [2:0] color_to_vga;

    reg [3:0] cur_state, nx_state;
    localparam  WAIT = 4'd0,
                UPDATE_MAP = 4'd1,
                UPDATE_WAIT_SHAPE = 4'd2,
                UPDATE_TIME_SEG1 = 4'd3,
                UPDATE_TIME_SEG2 = 4'd4,
                UPDATE_TIME_COL = 4'd5,
                UPDATE_TIME_SEG3 = 4'd6,
                UPDATE_TIME_SEG4 = 4'd7,
                UPDATE_SCORE_SEG1 = 4'd8,
                UPDATE_SCORE_SEG2 = 4'd9,
                UPDATE_SCORE_SEG3 = 4'd10,
                WAIT_1_FRAME = 4'd11,
                GAME_OVER = 4'd12,
                FINISH = 4'd13;
    wire finish;
    ///
    wire [229:0] board_value;
    reg update_game, update_nx_shape, update_digit, draw;
    reg [7:0] x_origin;
    reg [6:0] y_origin;
    reg [2:0] color_in;
    ///
    reg [20:0] digit_seg_value;
    ///
    ///
    wire [15:0]shape_id;// = 16'b0000_0110_0110_0000; // BLOCK_O
    //wire [15:0]shape_id = 16'b0000_0000_0100_1110; // BLOCK_T
    ///
    wire [3:0] t0_x, t1_x, t2_x, t3_x;
    wire [4:0] t0_y, t1_y, t2_y, t3_y;
    datapath d0(t0_x, t1_x, t2_x, t3_x, t0_y, t1_y, t2_y, t3_y, board_value, update_game, update_nx_shape, update_digit, draw, resetn, x_origin, y_origin, color_in, clk, shape_id, digit_seg_value, finish, plot, x_to_vga, y_to_vga, color_to_vga);
    //////
    
    wire up, down, left, right;
    wire gameover;
    tetris tet0 (up, down, left, right, clk, resetn, start, board_value, shape_id, t0_x, t1_x, t2_x, t3_x, t0_y, t1_y, t2_y, t3_y, gameover);
    /////////

    // initialize time recorder.
    reg enable_time_recorder; // *
    wire [15:0] time_value;
    time_recorder ti0 (clk, resetn, enable_time_recorder, time_value);
    // initialize digit decoder for each digit of time.
    wire [20:0] decoder_out3;
    wire [20:0] decoder_out2;
    wire [20:0] decoder_out1;
    wire [20:0] decoder_out0;
    digit_decoder di3(time_value[15:12], decoder_out3);
    digit_decoder di2(time_value[11:8], decoder_out2);
    digit_decoder di1(time_value[7:4], decoder_out1);
    digit_decoder di0(time_value[3:0], decoder_out0);
    wire finish_wait;

    always @(*) begin
        case(cur_state)
            WAIT: nx_state = start ? WAIT : UPDATE_MAP;
            UPDATE_MAP: nx_state = finish ? UPDATE_WAIT_SHAPE : UPDATE_MAP;
            UPDATE_WAIT_SHAPE: nx_state = finish ? UPDATE_TIME_SEG1 : UPDATE_WAIT_SHAPE;
            UPDATE_TIME_SEG1: nx_state = finish ? UPDATE_TIME_SEG2 : UPDATE_TIME_SEG1;
            UPDATE_TIME_SEG2: nx_state = finish ? UPDATE_TIME_COL : UPDATE_TIME_SEG2;
            UPDATE_TIME_COL: nx_state = finish ? UPDATE_TIME_SEG3 : UPDATE_TIME_COL;
            UPDATE_TIME_SEG3: nx_state = finish ? UPDATE_TIME_SEG4 : UPDATE_TIME_SEG3;
            UPDATE_TIME_SEG4: nx_state = finish ? UPDATE_SCORE_SEG1 : UPDATE_TIME_SEG4;
            UPDATE_SCORE_SEG1: nx_state = finish ? UPDATE_SCORE_SEG2 : UPDATE_SCORE_SEG1;
            UPDATE_SCORE_SEG2: nx_state = finish ? UPDATE_SCORE_SEG3 : UPDATE_SCORE_SEG2;
            UPDATE_SCORE_SEG3: nx_state = finish ? WAIT_1_FRAME : UPDATE_SCORE_SEG3; // ***
            WAIT_1_FRAME: nx_state = finish_wait ? UPDATE_MAP : WAIT_1_FRAME;
            GAME_OVER: nx_state = gameover ? FINISH : GAME_OVER;
            FINISH: nx_state = WAIT;
            default: nx_state = WAIT;
        endcase
    end

    // frame counter
    reg [19:0] frame_counter;
    assign finish_wait = (frame_counter == 20'd833333);
    always @(posedge clk) begin
        if (!resetn)
            frame_counter <= 20'd0;
        else if (cur_state == UPDATE_SCORE_SEG3)
            frame_counter <= 20'd0;
        else
            frame_counter <= frame_counter + 1'd1;
    end

    always @(*) begin
        enable_time_recorder <= 1'd1;
        update_game = 1'd0;
        update_nx_shape = 1'd0;
        update_digit = 1'd0;
        digit_seg_value = 21'd0;
        draw = 1'd0;
        x_origin = 8'd0;
        y_origin = 7'd0;
        color_in = 3'b100;
        case(cur_state)
            WAIT:
                enable_time_recorder <= 1'd0;
            UPDATE_MAP: begin
                draw = 1'd1;
                update_game = 1'd1;
                x_origin = 8'd0;
                y_origin = 7'd0;
            end
            UPDATE_WAIT_SHAPE: begin
                draw = 1'd1;
                update_nx_shape = 1'd1;
                x_origin = 8'd64;
                y_origin = 7'd6;
            end
            UPDATE_TIME_SEG1: begin
                digit_seg_value = decoder_out3; // digit 8
                draw = 1'd1;
                update_digit = 1'd1;
                x_origin = 8'd67;
                y_origin = 7'd52;
            end
            UPDATE_TIME_SEG2: begin
                digit_seg_value = decoder_out2; // digit 7
                draw = 1'd1;
                update_digit = 1'd1;
                x_origin = 8'd72;
                y_origin = 7'd52;
            end
            UPDATE_TIME_COL: begin
                digit_seg_value = 21'b000_000_100_000_100_000_000; // ":"
                draw = 1'd1;
                update_digit = 1'd1;
                x_origin = 8'd78;
                y_origin = 7'd52;
            end
            UPDATE_TIME_SEG3: begin
                digit_seg_value = decoder_out1;// digit 6
                draw = 1'd1;
                update_digit = 1'd1;
                x_origin = 8'd82;
                y_origin = 7'd 52;
            end
            UPDATE_TIME_SEG4: begin
                digit_seg_value = decoder_out0; // digit 5
                draw = 1'd1;
                update_digit = 1'd1;
                x_origin = 8'd87;
                y_origin = 7'd 52;
            end
            UPDATE_SCORE_SEG1: begin
                digit_seg_value = 21'b001_001_001_111_101_101_101; // digit 1
                draw = 1'd1;
                update_digit = 1'd1;
                x_origin = 8'd67;
                y_origin = 7'd70;
            end
            UPDATE_SCORE_SEG2: begin
                digit_seg_value = 21'b111_100_100_111_001_001_111; // digit 2
                draw = 1'd1;
                update_digit = 1'd1;
                x_origin = 8'd72;
                y_origin = 7'd70;
            end
            UPDATE_SCORE_SEG3: begin
                digit_seg_value = 21'b111_001_001_111_001_001_111; // digit 3
                draw = 1'd1;
                update_digit = 1'd1;
                x_origin = 8'd77;
                y_origin = 7'd70;
            end

        endcase
    end

    always @(posedge clk) begin
        if(!resetn)
            cur_state = WAIT;
        else
            cur_state = nx_state;
    end

endmodule


// 10 x 23 & 4 x 4
module datapath(
    input [3:0] t0_x,
    input [3:0] t1_x,
    input [3:0] t2_x,
    input [3:0] t3_x,
    input [4:0] t0_y,
    input [4:0] t1_y,
    input [4:0] t2_y,
    input [4:0] t3_y,
    input [229:0] map_value,
    input update_game,
    input update_nx_shape,
    input update_digit,
    input draw,
    input resetn,
    input [7:0] x_origin,
    input [6:0] y_origin,
    input [2:0] color_in,
    input clk,
    input [15:0] shape_id,
    input [20:0] digit_seg_value,
    //finish state for control
    output finish,
    //out to vga
    output plot,
    output reg [7:0] x_to_vga,
    output reg [6:0] y_to_vga,
    output reg [2:0] color_to_vga
);
    // initialize game map and display the falling piece(the falling piece is not stacked yet, so it is just a view for player.)
    // (Why not just passing a 2D register? since we don't want to manipulate the original data, we create a 2D register copy of the input data)
    reg [0:9] stacked_tiles[22:0];
    integer j;
	always@(posedge clk) begin
		for (j=0; j<23; j=j+1) begin
			stacked_tiles[j] <= map_value[j*10+:10];
		end
        stacked_tiles[t0_y][t0_x] <= 1'd1;
        stacked_tiles[t1_y][t1_x] <= 1'd1;
        stacked_tiles[t2_y][t2_x] <= 1'd1;
        stacked_tiles[t3_y][t3_x] <= 1'd1;
	end
    // initialize waiting shape
    reg [0:3] wait_shape[3:0];
    integer i;
    always@(posedge clk) begin
        for (i=0; i<4; i=i+1) begin
            wait_shape[i] <= shape_id[4*i +: 4];
        end
    end
    // initialize digit seg value(digit for score and time displaying)
    reg [0:2] digit_seg[6:0];
    integer s;
    always@(posedge clk) begin
        for (s=0; s<7; s=s+1) begin
            digit_seg[s] <= digit_seg_value[3*s +: 3];
        end
    end
    // declare counters for drawing
    reg [12:0] map_cter_value;
    reg [9:0] wait_shape_cter_vlaue;
    reg [5:0] digit_cter_value;
    assign finish = map_cter_value == 13'b1_1111_1111_1111 || wait_shape_cter_vlaue == 10'b11_1111_1111 || digit_cter_value == 6'b11_1111;
    assign plot = draw;

    // all drawing counters
    always @(posedge clk) begin
        if (!resetn) begin
            map_cter_value <= 13'd0;
            wait_shape_cter_vlaue <= 10'd0;
            digit_cter_value <= 6'd0;
        end
        else if(update_game) begin // update main game board
            map_cter_value <= map_cter_value + 13'd1;
            if (map_cter_value[5:0] < 8 || map_cter_value[5:0] > 55 || map_cter_value[12:6] < 10 || map_cter_value[12:6] > 109)
                color_to_vga <= 3'd0;
            else if (map_cter_value[5:0] < 12 || map_cter_value[5:0] > 51 || map_cter_value[12:6] < 14 || map_cter_value[12:6] > 105)
                color_to_vga <= 3'b011;
            else
                color_to_vga = (stacked_tiles[(map_cter_value[12:6]-4'd14)/3'd4][(map_cter_value[5:0]-4'd12)/3'd4]) ? color_in: 3'b111;
        end
        else if(update_nx_shape) begin // update wait shape board
            wait_shape_cter_vlaue <= wait_shape_cter_vlaue + 10'd1;
            if (wait_shape_cter_vlaue[4:0] < 5'd4 || wait_shape_cter_vlaue[4:0] > 5'd27 || wait_shape_cter_vlaue[9:5] < 5'd4 || wait_shape_cter_vlaue[9:5] > 5'd27)
                color_to_vga <= 3'd0;
            else if (wait_shape_cter_vlaue[4:0] < 5'd8 || wait_shape_cter_vlaue[4:0] > 5'd23 || wait_shape_cter_vlaue[9:5] < 5'd8 || wait_shape_cter_vlaue[9:5] > 5'd23)
                color_to_vga <= 3'b011;
            else
                color_to_vga <= (wait_shape[(wait_shape_cter_vlaue[9:5]-4'd8)/3'd4][(wait_shape_cter_vlaue[4:0]-4'd8)/3'd4]) ? color_in : 3'b111;
        end
        else if(update_digit) begin // update digit
            digit_cter_value <= digit_cter_value + 6'd1;
            if (digit_cter_value[2:0] < 1'd1 || digit_cter_value[2:0] > 2'd3 || digit_cter_value[5:3] > 3'd6)
                color_to_vga <= 3'd0;
            else
                color_to_vga <= (digit_seg[(digit_cter_value[5:3])][(digit_cter_value[2:0]) - 1'd1]) ? color_in : 3'd0;
        end
        else begin
            map_cter_value <= 13'd0;
            wait_shape_cter_vlaue <= 10'd0;
            digit_cter_value <= 6'd0;
        end
    end

    // drawing x_y movement
    always @(posedge clk) begin
        if (!resetn) begin
            x_to_vga <= 8'd0;
            y_to_vga <= 7'd0;
        end
        else if(update_game) begin
            x_to_vga <= x_origin + map_cter_value[5:0];
            y_to_vga <= y_origin + map_cter_value[12:6];
        end
        else if(update_nx_shape) begin
            x_to_vga <= x_origin + wait_shape_cter_vlaue[4:0];
            y_to_vga <= y_origin + wait_shape_cter_vlaue[9:5];
        end
        else if(update_digit) begin
            x_to_vga <= x_origin + digit_cter_value[2:0];
            y_to_vga <= y_origin + digit_cter_value[5:3];
        end
    end
    
endmodule
