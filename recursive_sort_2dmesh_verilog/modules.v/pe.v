`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Matin Firoozbakht
// Module Name: pe
// Project Name: Parallel Processing Course
//////////////////////////////////////////////////////////////////////////////////
module pe #(
    parameter WIDTH = 8
) (
    input clk,
    input reset,
    input [WIDTH-1:0] in_value,
    input [WIDTH-1:0] neighbor_value,
    input compare_direction,  // 0 for ascending, 1 for descending
    output reg [WIDTH-1:0] out_value,
    output reg [WIDTH-1:0] pass_value
);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            out_value <= 0;
            pass_value <= 0;
        end else begin
            // Compare-Exchange logic
            if (compare_direction == 0) begin
                // Ascending
                if (in_value > neighbor_value) begin
                    out_value <= neighbor_value;
                    pass_value <= in_value;
                end else begin
                    out_value <= in_value;
                    pass_value <= neighbor_value;
                end
            end else begin
                // Descending
                if (in_value < neighbor_value) begin
                    out_value <= neighbor_value;
                    pass_value <= in_value;
                end else begin
                    out_value <= in_value;
                    pass_value <= neighbor_value;
                end
            end
        end
    end
endmodule
