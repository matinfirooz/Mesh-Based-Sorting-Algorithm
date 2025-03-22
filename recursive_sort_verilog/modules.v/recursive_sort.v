`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Matin Firoozbakht
// Module Name: recursive_sort
// Project Name: Parallel Processing Course
//////////////////////////////////////////////////////////////////////////////////
module recursive_sort #(parameter N = 8, WIDTH = 8) (
    input clk,
    input reset,
    input [N*N*WIDTH-1:0] matrix_in,
    output reg [N*N*WIDTH-1:0] sorted_matrix
);

    // Internal Registers
    reg [WIDTH-1:0] matrix [0:N-1][0:N-1];
    integer i, j, k;

    // Load matrix into 2D structure
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

    // Sorting logic
    // Step 1: Sort quadrants (snakelike order)
    task sort_quadrant;
        input integer start_row;
        input integer start_col;
        input integer size;
        integer row, col;
        begin
            for (row = start_row; row < start_row + size; row = row + 1) begin
                if ((row - start_row) % 2 == 0) begin // Left-to-right for even rows
                    for (col = start_col; col < start_col + size - 1; col = col + 1) begin
                        for (k = start_col; k < start_col + size - 1; k = k + 1) begin
                            if (matrix[row][k] > matrix[row][k + 1]) begin
                                {matrix[row][k], matrix[row][k + 1]} = {matrix[row][k + 1], matrix[row][k]};
                            end
                        end
                    end
                end else begin // Right-to-left for odd rows
                    for (col = start_col + size - 1; col > start_col; col = col - 1) begin
                        for (k = start_col + size - 1; k > start_col; k = k - 1) begin
                            if (matrix[row][k - 1] < matrix[row][k]) begin
                                {matrix[row][k - 1], matrix[row][k]} = {matrix[row][k], matrix[row][k - 1]};
                            end
                        end
                    end
                end
            end
        end
    endtask

    // Step 2: Sort rows in snakelike order
    task sort_rows;
        begin
            for (i = 0; i < N; i = i + 1) begin
                if (i % 2 == 0) begin
                    for (j = 0; j < N - 1; j = j + 1) begin
                        for (k = 0; k < N - 1; k = k + 1) begin
                            if (matrix[i][k] > matrix[i][k + 1]) begin
                                {matrix[i][k], matrix[i][k + 1]} = {matrix[i][k + 1], matrix[i][k]};
                            end
                        end
                    end
                end else begin
                    for (j = N - 1; j > 0; j = j - 1) begin
                        for (k = N - 1; k > 0; k = k - 1) begin
                            if (matrix[i][k - 1] < matrix[i][k]) begin
                                {matrix[i][k - 1], matrix[i][k]} = {matrix[i][k], matrix[i][k - 1]};
                            end
                        end
                    end
                end
            end
        end
    endtask

    // Step 3: Sort columns
    task sort_columns;
        begin
            for (j = 0; j < N; j = j + 1) begin
                for (i = 0; i < N - 1; i = i + 1) begin
                    for (k = 0; k < N - 1; k = k + 1) begin
                        if (matrix[k][j] > matrix[k + 1][j]) begin
                            {matrix[k][j], matrix[k + 1][j]} = {matrix[k + 1][j], matrix[k][j]};
                        end
                    end
                end
            end
        end
    endtask

    // Step 4: Flatten and apply odd-even transposition
    task odd_even_transposition;
        reg [WIDTH-1:0] linear_array [0:N*N-1];
        integer m;
        begin
            // Flatten matrix
            for (i = 0; i < N; i = i + 1) begin
                for (j = 0; j < N; j = j + 1) begin
                    linear_array[i*N + j] = matrix[i][j];
                end
            end

            // Odd-even transposition sort
            for (m = 0; m < N*N; m = m + 1) begin
                for (k = (m % 2); k < N*N - 1; k = k + 2) begin
                    if (linear_array[k] > linear_array[k + 1]) begin
                        {linear_array[k], linear_array[k + 1]} = {linear_array[k + 1], linear_array[k]};
                    end
                end
            end

            // Rebuild matrix
            for (i = 0; i < N; i = i + 1) begin
                for (j = 0; j < N; j = j + 1) begin
                    matrix[i][j] = linear_array[i*N + j];
                end
            end
        end
    endtask

    // Main process
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            sorted_matrix <= 0;
        end else begin
            // Apply sorting steps
            $display("Original Matrix:");
            display_matrix();

            sort_quadrant(0, 0, N/2);
            sort_quadrant(0, N/2, N/2);
            sort_quadrant(N/2, 0, N/2);
            sort_quadrant(N/2, N/2, N/2);
            $display("After Sorting Quadrants:");
            display_matrix();

            sort_rows();
            $display("After Sorting Rows:");
            display_matrix();

            sort_columns();
            $display("After Sorting Columns:");
            display_matrix();

            odd_even_transposition();
            $display("After Odd-Even Transposition:");
            display_matrix();

            // Output sorted matrix
            for (i = 0; i < N; i = i + 1) begin
                for (j = 0; j < N; j = j + 1) begin
                    sorted_matrix[(i*N + j)*WIDTH +: WIDTH] <= matrix[i][j];
                end
            end
        end
    end

    // Display matrix
    task display_matrix;
        integer x, y;
        begin
            for (x = 0; x < N; x = x + 1) begin
                for (y = 0; y < N; y = y + 1) begin
                   $write("%d ", matrix[x][y]);
                end
               $display("");
            end
            $display("-----------------");
        end
    endtask
endmodule
