module fifo_assertions (
    input logic clk,
    input logic rst_n,
    input logic wr_en,
    input logic rd_en,
    input logic full,
    input logic empty,
    input logic [7:0] data_in,
    input logic [7:0] data_out
);

    // ---------------------------------------------------------
    // 1. Immediate Assertion (Combinational / Procedural)
    // ---------------------------------------------------------
    always_ff @(posedge clk) begin
        if (rst_n) begin
            // Immediate check: empty FIFO cannot service a read without a write
            assert (!(empty && rd_en && !wr_en))
                else $error("Assertion Failed: Read attempted on empty FIFO!");
        end
    end

    // ---------------------------------------------------------
    // 2. Concurrent Assertions (Temporal / Sequence-based)
    // ---------------------------------------------------------
    
    // Property A: Safety property - Writing when the FIFO is full is illegal.
    property p_no_overflow;
        @(posedge clk) disable iff (!rst_n)
        !(full && wr_en && !rd_en);
    endproperty
    assert property (p_no_overflow) 
        else $error("Assertion Failed: Overflow condition violated (Write while full)!");

    // Property B: Liveness property - Written data should eventually be read.
    sequence s_write;
        (wr_en && !full);
    endsequence

    sequence s_read;
        (rd_en && !empty);
    endsequence

    property p_data_flow;
        @(posedge clk) disable iff (!rst_n)
        s_write |-> ##[1:20] s_read;
    endproperty
    assert property (p_data_flow)
        else $warning("Assertion Warning: Written data was not read within 20 cycles.");

endmodule