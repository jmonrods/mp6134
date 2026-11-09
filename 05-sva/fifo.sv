module fifo (
    input  logic        clk,
    input  logic        rst_n,
    input  logic        wr_en,
    input  logic        rd_en,
    output logic        full,
    output logic        empty,
    input  logic [7:0]  data_in,
    output logic [7:0]  data_out
);

    // Parameters
    localparam int DEPTH      = 8;
    localparam int ADDR_WIDTH = 3; // $clog2(8)

    // Memory array and pointers
    logic [7:0]            mem [0:DEPTH-1];
    logic [ADDR_WIDTH-1:0] wr_ptr, rd_ptr;
    logic [3:0]            fifo_count;

    // Status flags
    assign empty = (fifo_count == 0);
    assign full  = (fifo_count == DEPTH);

    // Sequential logic for memory operations, pointers, and count
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            wr_ptr     <= '0;
            rd_ptr     <= '0;
            fifo_count <= '0;
            data_out   <= '0;
        end else begin
            // Write operation
            if (wr_en && !full) begin
                mem[wr_ptr] <= data_in;
                wr_ptr      <= wr_ptr + 1;
            end

            // Read operation
            if (rd_en && !empty) begin
                data_out <= mem[rd_ptr];
                rd_ptr   <= rd_ptr + 1;
            end

            // Count tracking for simultaneous or individual actions
            case ({wr_en && !full, rd_en && !empty})
                2'b10:   fifo_count <= fifo_count + 1; // Write only
                2'b01:   fifo_count <= fifo_count - 1; // Read only
                default: fifo_count <= fifo_count;   // Both or neither
            endcase
        end
    end

endmodule