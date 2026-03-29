 
module FIFO_tb(fifo_interface.TB intrf);
	import      FIFO_transaction_pkg ::*;
	import      FIFO_coverage_pkg ::*;
	import      FIFO_scoreboard_pkg ::*;
	import      shared_pkg::*;
    FIFO_transaction inputs = new;
	
    
    initial begin
        test_finished =0;
        intrf.rst_n = 0;
        #10;
        intrf.rst_n = 1;
		
        repeat(TEST) begin
            @(negedge intrf.clk);
			
            assert(inputs.randomize());
            intrf.data_in = inputs.data_in;
            intrf.rst_n = inputs.rst_n;
            intrf.wr_en = inputs.wr_en;
            intrf.rd_en = inputs.rd_en;
            inputs.data_out = intrf.data_out;
            inputs.wr_ack = intrf.wr_ack;
            inputs.full = intrf.full;
            inputs.empty = intrf.empty;
            inputs.overflow = inputs.overflow;
            inputs.almostfull = inputs.almostfull;
            inputs.almostempty = inputs.almostempty;
            inputs.underflow = inputs.underflow;
        end
        test_finished =1;
    end
endmodule