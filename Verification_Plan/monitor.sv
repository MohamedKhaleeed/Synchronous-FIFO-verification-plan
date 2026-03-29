module monitor(fifo_interface.Monitor intrf);     
	import      FIFO_transaction_pkg ::*;
	import      FIFO_coverage_pkg ::*;
	import      FIFO_scoreboard_pkg ::*;
	import      shared_pkg::*;

	FIFO_transaction obj1=new;
	FIFO_coverage obj2=new;
	FIFO_scoreboard obj3=new(obj1);
	parameter FIFO_WIDTH = 16;
	parameter FIFO_DEPTH = 8;
	logic [FIFO_WIDTH-1:0] data_in;
	logic clk, rst_n, wr_en, rd_en;
	logic [FIFO_WIDTH-1:0] data_out;
	logic wr_ack, overflow;
	logic full, empty, almostfull, almostempty, underflow;

	assign data_in     = intrf.data_in;
	assign clk         = intrf.clk;
	assign rst_n       = intrf.rst_n;
	assign wr_en       = intrf.wr_en;
	assign rd_en       = intrf.rd_en;
	assign data_out    = intrf.data_out;
	assign wr_ack      = intrf.wr_ack;
	assign overflow    = intrf.overflow;
	assign full        = intrf.full;
	assign empty       = intrf.empty;
	assign almostfull  = intrf.almostfull;
	assign almostempty = intrf.almostempty;
	assign underflow   = intrf.underflow;

	initial begin
		#5;
		forever  begin
			@(negedge clk);
			
			obj1.data_in    =  data_in      ;
			obj1.clk        =  clk          ;
			obj1.rst_n      =  rst_n        ;
			obj1.wr_en      =  wr_en        ;
			obj1.rd_en      =  rd_en        ;
			obj1.data_out   =  data_out     ;
			obj1.wr_ack     =  wr_ack       ;
			obj1.overflow   =  overflow     ;
			obj1.full       =  full         ;
			obj1.empty      =  empty        ;
			obj1.almostfull =  almostfull   ;
			obj1.almostempty=  almostempty  ;
			obj1.underflow  =  underflow    ;
				
			fork 
				//sampling_data
				begin
					obj2.sample_data(obj1);
				end
				//scoreboard
				
				begin
					obj3.check_data();
				end
			join

			if(test_finished) begin
				$display("# of correct counts=  %0d ,# of incorrect counts= %0d ",correct_count,error_count );
				$stop;
			end
		end
	end

endmodule 