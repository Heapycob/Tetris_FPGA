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
			
	// Put your code here. Your code should produce signals x,y,colour and writeEn/plot
	// for the VGA controller, in addition to any other functionality your design may require.

    // wire [2:0] color_in;
    // wire [229:0] map_value;
    // wire [15:0] shape_value;
    // wire update_game, ld;
    // wire done;
    // assign color_in = SW[9:7];
    // assign ld = KEY[1];
    // assign update_game = KEY[2];
    // reg finish;

    //display_empty_map d0(1'd1, resetn, 8'd18, 7'd0, color_in, CLOCK_50, colour, writeEn, x, y);
    // assign map_value = 230'd1023;
    //display_empty_map d0(map_value, 1'd1, resetn, 8'd18, 7'd0, color_in, CLOCK_50, writeEn, x, y, colour);
    // datapath(map_value, 1'd0, 1'd1, 1'd1, resetn, 8'd72, 7'd0, color_in, CLOCK_50, writeEn, x, y, colour);
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
                FINISH = 4'd3;
    wire finish;
    ///
    wire [229:0] map_value;
    reg update_game, update_nx_shape, draw;
    reg [7:0] x_origin;
    reg [6:0] y_origin;
    reg [2:0] color_in;
    assign map_value = 230'd1023;
    ///
    datapath d0(map_value, update_game, update_nx_shape, draw, resetn, x_origin, y_origin, color_in, clk, finish, plot, x_to_vga, y_to_vga, color_to_vga);

    always @(*) begin
        case(cur_state)
            WAIT: nx_state = start ? WAIT : UPDATE_MAP;
            UPDATE_MAP: nx_state = finish ? UPDATE_WAIT_SHAPE : UPDATE_MAP;
            UPDATE_WAIT_SHAPE: nx_state = finish ? FINISH : UPDATE_WAIT_SHAPE;
            FINISH: nx_state = WAIT;
            default: nx_state = WAIT;
        endcase
    end

    always @(*) begin
        update_game = 1'd0;
        update_nx_shape = 1'd0;
        draw = 1'd0;
        x_origin = 8'd0;
        y_origin = 7'd0;
        color_in = 3'b100;
        case(cur_state)
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
    input [229:0] map_value,
    input update_game,
    input update_nx_shape,
    input draw,
    input resetn,
    input [7:0] x_origin,
    input [6:0] y_origin,
    input [2:0] color_in,
    input clk,
    output finish,
    output plot,
    output reg [7:0] x_to_vga,
    output reg [6:0] y_to_vga,
    output reg [2:0] color_to_vga
);

    reg [0:9] stacked_tiles[22:0];
    integer j;
	always@(posedge clk) begin
		for (j=0; j<23; j=j+1) begin
			stacked_tiles[j] <= map_value[10*j +: 10];
		end
	end

    reg [12:0] map_cter_value;
    reg [9:0] wait_shape_cter_vlaue;
    assign finish = map_cter_value == 13'b1_1111_1111_1111 || wait_shape_cter_vlaue == 10'b11_1111_1111;
    // main game board counter and wait shape counter
    always @(posedge clk) begin
        if (!resetn) begin
            map_cter_value <= 13'd0;
            wait_shape_cter_vlaue <= 10'd0;
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
                color_to_vga <= 3'b111;
        end
        else begin
            map_cter_value <= 13'd0;
            wait_shape_cter_vlaue <= 10'd0;
        end
    end

    // x y movement
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
    end
    assign plot = draw;
    
endmodule
