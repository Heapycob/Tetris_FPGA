module movement_controller(
    input up, // rotate
    input down, // speed up
    input left, // move left
    input right, // move right
    input [2:0] cur_shape_id,
    input ld_cur,
    input clk_50,
    input resetn,
    input [229:0] stacked_tiles,
    output reg cur_stacked,
    output reg [3:0] t0_x_out,
    output reg [3:0] t1_x_out,
    output reg [3:0] t2_x_out,
    output reg [3:0] t3_x_out,
    output reg [4:0] t0_y_out,
    output reg [4:0] t1_y_out,
    output reg [4:0] t2_y_out,
    output reg [4:0] t3_y_out
);
    reg [0:9] board_value [22:0];
    always@(posedge clk_50) begin: init_board_value
        integer j;
        for(j=0;j<23;j=j+1) begin
            board_value[j] <= stacked_tiles[j*10+:10];
        end
    end

    wire [3:0] t0_x;
    wire [3:0] t1_x;
    wire [3:0] t2_x;
    wire [3:0] t3_x;
    wire [4:0] t0_y;
    wire [4:0] t1_y;
    wire [4:0] t2_y;
    wire [4:0] t3_y;
    shape_recognisor sr(cur_shape_id, t0_x, t1_x, t2_x, t3_x, t0_y, t1_y, t2_y, t3_y);


    wire [3:0] r_t0_x;
    wire [3:0] r_t1_x;
    wire [3:0] r_t2_x;
    wire [3:0] r_t3_x;
    wire [4:0] r_t0_y;
    wire [4:0] r_t1_y;
    wire [4:0] r_t2_y;
    wire [4:0] r_t3_y;
    shape_rotator srt(cur_shape_id, t0_x_out, t1_x_out, t2_x_out, t3_x_out, t0_y_out, t1_y_out, t2_y_out, t3_y_out, r_t0_x, r_t1_x, r_t2_x, r_t3_x, r_t0_y, r_t1_y, r_t2_y, r_t3_y);

    reg [25:0] delay_cter;
    reg [25:0] speed;
    
    wire rotatable_tile = ~(board_value[r_t0_y][r_t0_x] || board_value[r_t1_y][r_t1_x] || board_value[r_t2_y][r_t2_x] || board_value[r_t3_y][r_t3_x]);
    wire rotatable_wall_left = r_t0_x >= 4'd0 && r_t1_x >= 4'd0 && r_t2_x >= 4'd0 && r_t3_x >= 4'd0;
    wire rotatable_wall_right = r_t0_x < 4'd10 && r_t1_x < 4'd10 && r_t2_x < 4'd10 && r_t3_x < 4'd10;
    wire rotatable_wall_up = r_t0_y >= 5'd0 && r_t1_y >= 5'd0 && r_t2_y >= 4'd0 && r_t3_y >= 5'd0;
    wire rotatable_wall_bottom = r_t0_y < 5'd23 && r_t1_y < 5'd23 && r_t2_y < 5'd23 && r_t3_y < 5'd23;

    wire left_wall = t0_x_out == 4'd0 || t1_x_out == 4'd0 || t2_x_out == 4'd0 || t3_x_out == 4'd0;
    wire right_wall = t0_x_out == 4'd9 || t1_x_out == 4'd9 || t2_x_out == 4'd9 || t3_x_out == 4'd9;
    wire bottom_wall = t0_y_out == 5'd22 || t1_y_out == 5'd22 || t2_y_out == 5'd22 || t3_y_out == 5'd22;
    wire left_tiles_collision = board_value[t0_y_out][t0_x_out-1] || board_value[t1_y_out][t1_x_out-1] || board_value[t2_y_out][t2_x_out-1] || board_value[t3_y_out][t3_x_out-1];
    wire right_tiles_collision = board_value[t0_y_out][t0_x_out+1] || board_value[t1_y_out][t1_x_out+1] || board_value[t2_y_out][t2_x_out+1] || board_value[t3_y_out][t3_x_out+1];
    wire bottom_tiles_collision = board_value[t0_y_out+1][t0_x_out] || board_value[t1_y_out+1][t1_x_out] || board_value[t2_y_out+1][t2_x_out] || board_value[t3_y_out+1][t3_x_out];
    

    always@(posedge clk_50) begin
        cur_stacked <= 1'd0;
        speed <= 26'd50000000;
        if (!resetn)
            delay_cter <= 26'd0;
        else if(delay_cter == 26'd49999999)
            delay_cter <= 26'd0;
        else
            delay_cter <= delay_cter + 26'd1;
        // whether current shape finish falling or not
        if (ld_cur) begin
            t0_x_out <= t0_x;
            t1_x_out <= t1_x;
            t2_x_out <= t2_x;
            t3_x_out <= t3_x;
            t0_y_out <= t0_y;
            t1_y_out <= t1_y;
            t2_y_out <= t2_y;
            t3_y_out <= t3_y;
        end
        // speed up motion
        if (down)
            speed <= 26'd6250000;

        if (delay_cter % speed == 26'd0) begin
            if (bottom_wall || bottom_tiles_collision) begin
                cur_stacked <= 1'd1;
            end
            else begin
                t0_y_out <= t0_y_out + 5'd1;
                t1_y_out <= t1_y_out + 5'd1;
                t2_y_out <= t2_y_out + 5'd1;
                t3_y_out <= t3_y_out + 5'd1;
            end
        end
        // rotation
        if (up) begin
            if (delay_cter % 26'd12500000 == 26'd0) begin
                if (rotatable_tile && rotatable_wall_up && rotatable_wall_bottom && rotatable_wall_left && rotatable_wall_right) begin
                    t0_x_out <= r_t0_x;
                    t1_x_out <= r_t1_x;
                    t2_x_out <= r_t2_x;
                    t3_x_out <= r_t3_x;
                    t0_y_out <= r_t0_y;
                    t1_y_out <= r_t1_y;
                    t2_y_out <= r_t2_y;
                    t3_y_out <= r_t3_y;
                end
            end
        end
        // left movement
        if (left && ~up) begin
            if (delay_cter % 26'd12500000 == 26'd0) begin
                if (left_wall || left_tiles_collision) begin
                    t0_x_out <= t0_x_out;
                    t1_x_out <= t1_x_out;
                    t2_x_out <= t2_x_out;
                    t3_x_out <= t3_x_out;
                end
                else begin
                    t0_x_out <= t0_x_out - 1'd1;
                    t1_x_out <= t1_x_out - 1'd1;
                    t2_x_out <= t2_x_out - 1'd1;
                    t3_x_out <= t3_x_out - 1'd1;
                end
            end
        end
        // right movement
        if (right && ~up) begin
            if (delay_cter % 26'd12500000 == 26'd0) begin
                if (right_wall || right_tiles_collision) begin
                    t0_x_out <= t0_x_out;
                    t1_x_out <= t1_x_out;
                    t2_x_out <= t2_x_out;
                    t3_x_out <= t3_x_out;
                end
                else begin
                    t0_x_out <= t0_x_out + 1'd1;
                    t1_x_out <= t1_x_out + 1'd1;
                    t2_x_out <= t2_x_out + 1'd1;
                    t3_x_out <= t3_x_out + 1'd1;
                end
            end
        end
    end
endmodule

module tetris(
    up, // rotate
    down, // speed up
    left, // move left
    right, // move right
    clk_50,
    resetn,
    start,
    board_value,
    to_nx_shape_display,
    t0_x_out,
    t1_x_out,
    t2_x_out,
    t3_x_out,
    t0_y_out,
    t1_y_out,
    t2_y_out,
    t3_y_out,
    gameover,
    score
);
    input start;
    input up; // rotate
    input down; // speed up
    input left; // move left
    input right; // move right
    input clk_50;
    input resetn;
    output [229:0] board_value;
    output [15:0] to_nx_shape_display;
    output [3:0] t0_x_out;
    output [3:0] t1_x_out;
    output [3:0] t2_x_out;
    output [3:0] t3_x_out;
    output [4:0] t0_y_out;
    output [4:0] t1_y_out;
    output [4:0] t2_y_out;
    output [4:0] t3_y_out;
    output gameover;
    output [9:0] score;

    reg [2:0] cur_state, nx_state;

    localparam  WAIT = 3'd0,
                INITIALIZE = 3'd1,
                TURN_ON_DISPLAY = 3'd2,
                GEN_FALLING_BLK = 3'd3,
                GEN_WAITING_BLK = 3'd4,
                USER_INPUT = 3'd5,
                FROM_WAITING = 3'd6,
                GAME_OVER = 3'd7;
    
    reg [2:0] cur_shape_id, nx_shape_id;
    reg clear_board;
    wire cur_stacked;

    reg ld_cur;

    movement_controller mvc(up, down, left, right, cur_shape_id, ld_cur, clk_50, resetn, board_value, cur_stacked, t0_x_out, t1_x_out, t2_x_out, t3_x_out, t0_y_out, t1_y_out, t2_y_out, t3_y_out);
    
    board_state_recorder bst(clk_50, resetn, clear_board, cur_stacked, t0_x_out, t1_x_out, t2_x_out, t3_x_out, t0_y_out, t1_y_out, t2_y_out, t3_y_out, gameover, board_value, score);
    
    wire [2:0] shape_gen;
    shape_generator sg(clk_50, resetn, shape_gen);
    
    shape_id_decoder sd(nx_shape_id, to_nx_shape_display);
    
    always@(*) begin
        case(cur_state)
            WAIT: nx_state = start ? WAIT : INITIALIZE;
            INITIALIZE: nx_state = TURN_ON_DISPLAY;
            TURN_ON_DISPLAY: nx_state = GEN_FALLING_BLK;
            GEN_FALLING_BLK: nx_state = GEN_WAITING_BLK;
            GEN_WAITING_BLK: nx_state = USER_INPUT;
            USER_INPUT: nx_state = cur_stacked ? FROM_WAITING : USER_INPUT;
            FROM_WAITING: nx_state = gameover ? GAME_OVER : GEN_WAITING_BLK;
            GAME_OVER: nx_state = resetn ? GAME_OVER : WAIT;
            default: nx_state = WAIT;
        endcase
    end

    always@(*) begin
        ld_cur <= 1'd0;
        clear_board <= 1'd0;
        case(cur_state)
            INITIALIZE: begin
                clear_board <= 1'd1;
            end
            GEN_FALLING_BLK: begin
                cur_shape_id <= shape_gen;
                ld_cur <= 1'd1;
            end
            GEN_WAITING_BLK: begin
                nx_shape_id <= shape_gen;
            end
            USER_INPUT: begin

            end
            FROM_WAITING: begin
                cur_shape_id <= nx_shape_id;
                ld_cur <= 1'd1;
            end
        endcase
    end

    always @(posedge clk_50) begin
        if(!resetn)
            cur_state = WAIT;
        else
            cur_state = nx_state;
    end

endmodule

module board_state_recorder(
    input clk,
    input resetn,
    input clear,
    input update,
    input [3:0] t0_x,
    input [3:0] t1_x,
    input [3:0] t2_x,
    input [3:0] t3_x,
    input [4:0] t0_y,
    input [4:0] t1_y,
    input [4:0] t2_y,
    input [4:0] t3_y,
    output reg gameover,
    output reg [229:0] board_value,
    output reg [9:0] score
);
    reg [0:9] stacked_tiles [22:0];
    // check line-removability
    always@(posedge clk) begin: removability
        integer i, j;
        for (j=0; j<23; j=j+1) begin
            if (stacked_tiles[j] == 10'b11111_11111) begin
                score <= score + 1'd1;
                // remove current line
                stacked_tiles[j] <= 10'd0;
                // shift uppter lines down
                for (i=j; i>0; i=i-1) begin
                    stacked_tiles[i] <= stacked_tiles[i-1];
                end
                // the moset top line gets empty line
                stacked_tiles[0] <= 10'd0;
            end
        end
        for (j=0; j<23; j=j+1) begin
            board_value[j*10+:10] <= stacked_tiles[j];
        end
        if (stacked_tiles[0] != 10'd0)
            gameover <= 1'd1;

        if (!resetn || clear) begin
            score <= 10'd0;
            gameover <= 1'd0;
            board_value <= 230'd0;
            for (j=0; j<23; j=j+1) begin
                stacked_tiles[j] <= 10'd0;
            end
        end
        else if (update) begin: update_board_value
            for (j=0; j<23; j=j+1) begin
                stacked_tiles[j] <= board_value[j*10+:10];
            end
            stacked_tiles[t0_y][t0_x] <= 1'd1;
            stacked_tiles[t1_y][t1_x] <= 1'd1;
            stacked_tiles[t2_y][t2_x] <= 1'd1;
            stacked_tiles[t3_y][t3_x] <= 1'd1;
        end
    end

endmodule