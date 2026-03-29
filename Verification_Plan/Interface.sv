interface fifo_interface(clk);
    input bit clk;
    logic [15:0] data_in;
    logic  rst_n, wr_en, rd_en;
    logic [15:0] data_out;
    logic  overflow;
    logic full, empty, almostfull, almostempty, underflow,wr_ack;

    modport TB (output data_in,rst_n,wr_en,rd_en,
                input clk,data_out,wr_ack,overflow,full, empty, almostfull, almostempty, underflow);
    modport DUT (input clk,data_in,rst_n,wr_en,rd_en,
                output data_out,wr_ack,overflow,full, empty, almostfull, almostempty, underflow);

    modport Monitor (input clk,data_in,rst_n,wr_en,rd_en,data_out,wr_ack,overflow,full, empty, almostfull, almostempty, underflow);
    
endinterface //fifo_interface