`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Matin Firoozbakht
// Module Name: recursive_sort_2dmesh
// Project Name: Parallel Processing Course
//////////////////////////////////////////////////////////////////////////////////
module recursive_sort_2dmesh #(
    parameter N = 4,        // Mesh size (NxN)
    parameter WIDTH = 8     // Data width
) (
    input clk,
    input reset,
    input [N*N*WIDTH-1:0] matrix_in,
    output reg [N*N*WIDTH-1:0] sorted_matrix
);

    // Internal Registers
    reg [WIDTH-1:0] matrix [0:N-1][0:N-1];
    wire [WIDTH-1:0] pe_out [0:N-1][0:N-1];
    wire [WIDTH-1:0] pe_pass [0:N-1][0:N-1];

    // Load Input Matrix
    integer i, j;
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            for (i = 0; i < N; i = i + 1) begin
                for (j = 0; j < N; j = j + 1) begin
                    matrix[i][j] <= 0;
                end
            end
        end else begin
            for (i = 0; i < N; i = i + 1) begin
                for (j = 0; j < N; j = j + 1) begin
                    matrix[i][j] <= matrix_in[(i*N + j)*WIDTH +: WIDTH];
                end
            end
        end
    end

    // Instantiate Processing Elements (PEs)
    genvar row, col;
    generate
        for (row = 0; row < N; row = row + 1) begin : pe_row
            for (col = 0; col < N; col = col + 1) begin : pe_col
                pe #(.WIDTH(WIDTH)) PE (
                    .clk(clk),
                    .reset(reset),
                    .in_value(matrix[row][col]),
                    .neighbor_value((col > 0) ? matrix[row][col-1] : {WIDTH{1'b0}}),
                    .compare_direction((row % 2 == 0) ? 0 : 1),  // Ascending for even rows, descending for odd rows
                    .out_value(pe_out[row][col]),
                    .pass_value(pe_pass[row][col])
                );
            end
        end
    endgenerate

    // Sorting Tasks
    task sort_quadrant;
        input integer start_row;
        input integer start_col;
        input integer size;
        integer r, c, k;
        begin
            for (r = start_row; r < start_row + size; r = r + 1) begin
                if ((r - start_row) % 2 == 0) begin // Left-to-right for even rows
                    for (k = start_col; k < start_col + size - 1; k = k + 1) begin
                        for (c = start_col; c < start_col + size - 1; c = c + 1) begin
                            if (matrix[r][c] > matrix[r][c + 1]) begin
                                {matrix[r][c], matrix[r][c + 1]} = {matrix[r][c + 1], matrix[r][c]};
                            end
                        end
                    end
                end else begin // Right-to-left for odd rows
                    for (k = start_col + size - 1; k > start_col; k = k - 1) begin
                        for (c = start_col + size - 1; c > start_col; c = c - 1) begin
                            if (matrix[r][c - 1] < matrix[r][c]) begin
                                {matrix[r][c - 1], matrix[r][c]} = {matrix[r][c], matrix[r][c - 1]};
                            end
                        end
                    end
                end
            end
        end
    endtask

    task sort_rows;
        integer r, c, k;
        begin
            for (r = 0; r < N; r = r + 1) begin
                if (r % 2 == 0) begin
                    // Left-to-right for even rows
                    for (k = 0; k < N-1; k = k + 1) begin
                        for (c = 0; c < N-1; c = c + 1) begin
                            if (matrix[r][c] > matrix[r][c+1]) begin
                                {matrix[r][c], matrix[r][c+1]} = {matrix[r][c+1], matrix[r][c]};
                            end
                        end
                    end
                end else begin
                    // Right-to-left for odd rows
                    for (k = 0; k < N-1; k = k + 1) begin
                        for (c = N-1; c > 0; c = c - 1) begin
                            if (matrix[r][c-1] < matrix[r][c]) begin
                                {matrix[r][c-1], matrix[r][c]} = {matrix[r][c], matrix[r][c-1]};
                            end
                        end
                    end
                end
            end
        end
    endtask

    task sort_columns;
        integer c, r, k;
        begin
            for (c = 0; c < N; c = c + 1) begin
                for (k = 0; k < N-1; k = k + 1) begin
                    for (r = 0; r < N-1; r = r + 1) begin
                        if (matrix[r][c] > matrix[r+1][c]) begin
                            {matrix[r][c], matrix[r+1][c]} = {matrix[r+1][c], matrix[r][c]};
                        end
                    end
                end
            end
        end
    endtask

    // Odd-Even Transposition
    task odd_even_transposition;
        reg [WIDTH-1:0] linear_array [0:N*N-1];
        integer idx, pass;
        begin
            // Flatten matrix
            for (idx = 0; idx < N*N; idx = idx + 1) begin
                linear_array[idx] = matrix[idx / N][idx % N];
            end

            // Perform odd-even transposition
            for (pass = 0; pass < N*N; pass = pass + 1) begin
                for (idx = (pass % 2); idx < N*N - 1; idx = idx + 2) begin
                    if (linear_array[idx] > linear_array[idx + 1]) begin
                        {linear_array[idx], linear_array[idx + 1]} = {linear_array[idx + 1], linear_array[idx]};
                    end
                end
            end

            // Rebuild matrix
            for (idx = 0; idx < N*N; idx = idx + 1) begin
                matrix[idx / N][idx % N] = linear_array[idx];
            end
        end
    endtask

    // Task to Display Matrix
    task display_matrix;
        integer r, c;
        begin
            for (r = 0; r < N; r = r + 1) begin
                for (c = 0; c < N; c = c + 1) begin
                    $write("%d ", matrix[r][c]);
                end
                $display("");
            end
            $display("--------------------");
        end
    endtask

    // Main Sorting Process
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            sorted_matrix <= 0;
        end else begin
            // Quadrant Sorting
            sort_quadrant(0, 0, N/2);
            sort_quadrant(0, N/2, N/2);
            sort_quadrant(N/2, 0, N/2);
            sort_quadrant(N/2, N/2, N/2);
            $display("Step 1: Quadrant Sorting (Snake Like):");
            display_matrix();

            // Row Sorting
            sort_rows();
            $display("Step 2: Row Sorting (Snake Like):");
            display_matrix();

            // Column Sorting
            sort_columns();
            $display("Step 3: Column Sorting (Snake Like):");
            display_matrix();

            // Odd-Even Transposition
            odd_even_transposition();
            $display("Step 4: Odd-Even Transposition (Snake Like):");
            display_matrix();

            // Output sorted matrix
            for (i = 0; i < N; i = i + 1) begin
                for (j = 0; j < N; j = j + 1) begin
                    sorted_matrix[(i*N + j)*WIDTH +: WIDTH] <= matrix[i][j];
                end
            end
        end
    end
endmodule
