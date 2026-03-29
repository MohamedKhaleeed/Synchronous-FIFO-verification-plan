//importing
//**************************************************
package FIFO_scoreboard_pkg;
	import FIFO_transaction_pkg::*;
	import shared_pkg::*;
	class FIFO_scoreboard;
		logic [15:0] data_out_ref;
		logic wr_ack_ref, overflow_ref, underflow_ref;
		logic full_ref, empty_ref, almostfull_ref, almostempty_ref; 
		FIFO_transaction tr;
		logic [15:0] fifo [$];


		function new (input FIFO_transaction tr_in);  
			tr = tr_in;
		endfunction




		function check_data();
			reference_model();
			if(tr.data_out !== data_out_ref || tr.full !== full_ref|| tr.empty !== empty_ref || tr.almostfull !== almostfull_ref || tr.almostempty !== almostempty_ref || tr.overflow !== overflow_ref || tr.underflow !== underflow_ref || tr.wr_ack !== wr_ack_ref)begin
				$display("%t: tr.overflow : %0h ,tr.overflow _ref: %0h ,  full: %b , tr.almostfull ref = %b",$time,tr.overflow ,overflow_ref ,tr.underflow,underflow_ref);
				error_count = error_count + 1;
			end
			else
				correct_count = correct_count + 1;
		endfunction
		
		function reference_model();
			fork 
				begin
					if(!tr.rst_n)begin
						fifo.delete();
						overflow_ref = 1'b0;
						wr_ack_ref = 1'b0;
					end
					else if(tr.wr_en)begin
						if(!full_ref)begin
							fifo.push_back(tr.data_in);
							overflow_ref = 1'b0;
							wr_ack_ref = 1'b1;
						end
						else begin
							overflow_ref = 1'b1;
							wr_ack_ref = 1'b0;
						end
					end
					else begin
						overflow_ref = 1'b0;
						wr_ack_ref = 1'b0;
					end
				end
				
				begin						
					if(!tr.rst_n)begin
						underflow_ref = 1'b0;
					end	
					else if(tr.rd_en) begin
						if(!empty_ref)begin
							data_out_ref = fifo.pop_front;
							underflow_ref = 1'b0;
						end
						else
							underflow_ref = 1'b1;
					end
					else begin
						underflow_ref = 1'b0;
					end
				end
			join
			
			full_ref = (fifo.size() == 8);
			empty_ref = (fifo.size() == 0);
			almostfull_ref = (fifo.size() == 7);
			almostempty_ref = (fifo.size() == 1);
			
		endfunction
	endclass
endpackage