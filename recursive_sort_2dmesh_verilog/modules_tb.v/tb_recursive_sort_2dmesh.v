`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Matin Firoozbakht
// Module Name: tb_recursive_sort_2dmesh
// Project Name: Parallel Processing Course
//////////////////////////////////////////////////////////////////////////////////
module tb_recursive_sort_2dmesh;

    // Parameters
    parameter N = 4;        // Mesh size (NxN)
    parameter WIDTH = 8;    // Data width

    // Inputs
    reg clk;
    reg reset;
    reg [N*N*WIDTH-1:0] matrix_in;

    // Outputs
    wire [N*N*WIDTH-1:0] sorted_matrix;

    // Instantiate the Unit Under Test (UUT)
    recursive_sort_2dmesh #(
        .N(N),
        .WIDTH(WIDTH)
    ) uut (
        .clk(clk),
        .reset(reset),
        .matrix_in(matrix_in),
        .sorted_matrix(sorted_matrix)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 10 time units clock period
    end

    // Testbench logic
    initial begin
        // Initialize inputs
        reset = 1;
        matrix_in = 0;

        // Wait for the clock to stabilize
        #20;

        // Apply reset
        reset = 1;
        #20;
        reset = 0;

       // Load test matrix
        matrix_in = {
            8'd16, 8'd13, 8'd11, 8'd13,   // Row 0
            8'd5,  8'd3,  8'd14, 8'd1,   // Row 1
            8'd8,  8'd1, 8'd2,  8'd8,   // Row 2
            8'd15, 8'd9,  8'd6, 8'd4    // Row 3
        };

//        matrix_in = {
//            8'd16, 8'd13, 8'd11, 8'd7,  8'd23, 8'd21, 8'd18, 8'd14,   // Row 0
//            8'd5,  8'd1,  8'd14, 8'd3,  8'd25, 8'd19, 8'd17, 8'd12,   // Row 1
//            8'd8,  8'd10, 8'd2,  8'd6,  8'd27, 8'd20, 8'd16, 8'd15,   // Row 2
//            8'd15, 8'd9,  8'd12, 8'd4,  8'd30, 8'd22, 8'd13, 8'd11,   // Row 3
//            8'd20, 8'd17, 8'd19, 8'd18, 8'd9,  8'd2,  8'd6,  8'd1,    // Row 4
//            8'd3,  8'd7,  8'd8,  8'd5,  8'd11, 8'd14, 8'd12, 8'd4,    // Row 5
//            8'd22, 8'd25, 8'd27, 8'd30, 8'd19, 8'd13, 8'd15, 8'd9,    // Row 6
//            8'd31, 8'd29, 8'd28, 8'd24, 8'd21, 8'd17, 8'd20, 8'd23    // Row 7
//        };

        // Wait for sorting to complete
        #100;

        // Display original matrix
        $display("Original Matrix:");
        display_matrix(matrix_in);

        // Wait for sorting to finish
        #100;

        // Display sorted matrix
        $display("Sorted Matrix:");
        display_matrix(sorted_matrix);

        // Finish simulation
        #50;
        $finish;
    end

    // Task to display the matrix
    task display_matrix;
        input [N*N*WIDTH-1:0] matrix;
        integer i, j;
        begin
            for (i = 0; i < N; i = i + 1) begin
                for (j = 0; j < N; j = j + 1) begin
                    $write("%d ", matrix[(i*N + j)*WIDTH +: WIDTH]);
                end
                $display("");
            end
            $display("--------------------");
        end
    endtask

endmodule
