`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Matin Firoozbakht
// Module Name: tb_recursive_sort_2d_mesh
// Project Name: Parallel Processing Course
//////////////////////////////////////////////////////////////////////////////////
module tb_recursive_sort_2d_mesh();
    parameter N = 4;
    parameter WIDTH = 8;

    // Inputs
    reg clk;
    reg reset;
    reg [N*N*WIDTH-1:0] matrix_in;

    // Outputs
    wire [N*N*WIDTH-1:0] sorted_matrix;

    // Instantiate the module
    recursive_sort_2d_mesh #(N, WIDTH) uut (
        .clk(clk),
        .reset(reset),
        .matrix_in(matrix_in),
        .sorted_matrix(sorted_matrix)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 10ns clock period
    end

    // Test input matrix (4x4 example)
    initial begin
        // Reset the system
        reset = 1;
        #10;
        reset = 0;

        // Initialize matrix with values
        matrix_in = {
            8'd8,  8'd3,  8'd10, 8'd2,
            8'd12, 8'd6,  8'd5,  8'd1,
            8'd15, 8'd7,  8'd4,  8'd11,
            8'd14, 8'd9,  8'd13, 8'd16
        };

        $display("Original Matrix:");
        display_matrix(matrix_in);

        // Wait for sorting to complete
        #100;

        // Display the sorted matrix
        $display("Sorted Matrix:");
        display_matrix(sorted_matrix);

        // Finish simulation
        #10;
        $stop;
    end

    // Display matrix task
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
            $display("-----------------");
        end
    endtask
endmodule

