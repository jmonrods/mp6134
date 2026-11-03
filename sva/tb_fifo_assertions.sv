module tb_fifo_assertions;

    logic clk = 0;
    logic rst_n = 0;
    logic wr_en;
    logic rd_en;
    logic full;
    logic empty;
    logic [7:0] data_in;
    logic [7:0] data_out;

    logic [3:0] fifo_count;

    // Instantiate assertion module
    fifo_assertions dut_assertions (
        .*
    );

    // Clock generation: 10 time units period
    always #5 clk = ~clk;

    // Simple FIFO counter model
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            fifo_count <= 0;
        end else begin
            case ({wr_en && !full, rd_en && !empty})
                2'b10: fifo_count <= fifo_count + 1; // Write only
                2'b01: fifo_count <= fifo_count - 1; // Read only
                default: fifo_count <= fifo_count;   // No-op or simultaneous
            endcase
        end
    end

    assign empty = (fifo_count == 0);
    assign full  = (fifo_count == 8);

    // Stimulus process
    initial begin
        wr_en   = 0;
        rd_en   = 0;
        data_in = 8'h00;

        // Release reset after 2 cycles
        @(posedge clk);
        @(posedge clk);
        rst_n = 1;
        @(posedge clk);

        // ---------------------------------------------------------
        // Scenario 1: Normal Operation (Write 3, Read 3 to empty out)
        // ---------------------------------------------------------
        repeat (3) begin
            @(posedge clk);
            wr_en   = 1;
            rd_en   = 0;
            data_in = data_in + 8'h11;
        end
        
        @(posedge clk);
        wr_en = 0;

        repeat (25) @(posedge clk);

        repeat (3) begin
            @(posedge clk);
            rd_en = 1;
        end

        @(posedge clk);
        rd_en = 0;
        @(posedge clk);

        // ---------------------------------------------------------
        // Scenario 2: Trigger Empty-Read Error
        // ---------------------------------------------------------
        // FIFO is now guaranteed empty, so this won't hang
        wait(empty);
        @(posedge clk);
        rd_en = 1; // Attempt read on empty FIFO
        wr_en = 0;
        @(posedge clk);
        rd_en = 0;

        // ---------------------------------------------------------
        // Scenario 3: Trigger Overflow Error
        // ---------------------------------------------------------
        // Fill FIFO to depth of 8
        repeat (8) begin
            @(posedge clk);
            wr_en   = 1;
            rd_en   = 0;
            data_in = data_in + 8'h55;
        end
        @(posedge clk); // Allow full flag to latch

        // Attempt write while full
        wr_en = 1;
        rd_en = 0;
        @(posedge clk);
        wr_en = 0;

        #20;
        $finish;
    end

endmodule