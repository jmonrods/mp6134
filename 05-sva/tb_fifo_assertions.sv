module tb_fifo_assertions;

    logic clk = 0;
    logic rst_n = 0;
    logic wr_en;
    logic rd_en;
    logic full;
    logic empty;
    logic [7:0] data_in;
    logic [7:0] data_out;

    // Instantiate the actual FIFO memory Design Under Test (DUT)
    fifo dut_fifo (
        .clk(clk),
        .rst_n(rst_n),
        .wr_en(wr_en),
        .rd_en(rd_en),
        .full(full),
        .empty(empty),
        .data_in(data_in),
        .data_out(data_out)
    );

    // Instantiate the assertion checker module
    bind dut_fifo fifo_assertions fifo_checker_inst (.*);

    // Clock generation
    always #5 clk = ~clk;

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
        // FIFO is empty
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

        @(posedge clk);

        // ---------------------------------------------------------
        // Scenario 4: Written data not read within 20 cycles
        // ---------------------------------------------------------

        // First we empty the FIFO
        repeat (8) begin
            @(posedge clk);
            wr_en   = 0;
            rd_en   = 1;
        end
        
        // Then we write 3 new entries
        repeat (3) begin
            @(posedge clk);
            wr_en   = 1;
            rd_en   = 0;
            data_in = data_in + 8'h11;
        end
        
        @(posedge clk);
        wr_en = 0;

        // Wait for 25 cycles without reading
        repeat (25) @(posedge clk); 

        // Read 3 entries to clear the FIFO
        repeat (3) begin
            @(posedge clk);
            rd_en = 1;
        end

        @(posedge clk);
        rd_en = 0;
        @(posedge clk);

        $finish;
    end

endmodule