////////////////////////////////////////////////////////////////////////////////
// Author: Kareem Waseem
// Course: Digital Verification using SV & UVM
//
// Description: FIFO Design 
// 
////////////////////////////////////////////////////////////////////////////////
module FIFO(fifo_interface.DUT intrf);
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
assign intrf.data_out    = data_out;
assign intrf.wr_ack      = wr_ack;
assign intrf.overflow    = overflow;
assign intrf.full        = full;
assign intrf.empty       = empty;
assign intrf.almostfull  = almostfull;
assign intrf.almostempty = almostempty;
assign intrf.underflow   = underflow;


localparam max_fifo_addr = $clog2(FIFO_DEPTH);

reg [FIFO_WIDTH-1:0] mem [FIFO_DEPTH-1:0];

reg [max_fifo_addr-1:0] wr_ptr, rd_ptr;
reg [max_fifo_addr:0] count;

always @(posedge clk or negedge rst_n) begin
	if (!rst_n) begin
		wr_ptr <= 0;
		overflow<=0;
		wr_ack<=0;
	end
	else if (wr_en && count < FIFO_DEPTH) begin
		mem[wr_ptr] <= data_in;
		wr_ack <= 1;
		wr_ptr <= wr_ptr + 1;
		overflow<=0;
	end
	else begin 
		wr_ack <= 0; 
		if (full && wr_en)
			overflow <= 1;
		else
			overflow <= 0;
	end
end

always @(posedge clk or negedge rst_n) begin
	if (!rst_n) begin
		rd_ptr <= 0;
		underflow<=0;
	end
	else if (rd_en && count != 0) begin
		data_out <= mem[rd_ptr];
		rd_ptr <= rd_ptr + 1;
		underflow<=0;
	end
	else begin
		if (empty & rd_en)
			underflow <= 1;
		else
			underflow <= 0;
	end
end

always @(posedge clk or negedge rst_n) begin
	if (!rst_n) begin
		count <= 0;
	end
	else begin
		if ( ({wr_en, rd_en} == 2'b11) && empty)
			count <= count +1;
		else if ( ({wr_en, rd_en} == 2'b11) && full)
			count <= count -1;
		else if	( ({wr_en, rd_en} == 2'b10) && !full) 
			count <= count + 1;
		else if ( ({wr_en, rd_en} == 2'b01) && !empty)
			count <= count - 1;
		 
		
	end

end
always@(posedge clk) begin

assert property (@(posedge clk) disable iff(!rst_n) (wr_en && count < FIFO_DEPTH) |=> wr_ack);
assert property (@(posedge clk) disable iff(!rst_n) (empty & rd_en) |=> underflow);
assert property (@(posedge clk) disable iff(!rst_n) (full & wr_en) |=> overflow);
assert property (@(posedge clk) disable iff(!rst_n) (count==0) |-> empty);
assert property (@(posedge clk) disable iff(!rst_n) (count == FIFO_DEPTH-1) |-> almostfull);
assert property (@(posedge clk) disable iff(!rst_n) (count == 1) |-> almostempty);
assert property (@(posedge clk) disable iff(!rst_n) (count == FIFO_DEPTH) |-> full);
//assert property (count);

end

assign full = (count == FIFO_DEPTH)? 1 : 0;
assign empty = (count == 0)? 1 : 0;
//assign underflow = (empty && rd_en)? 1 : 0; //bug should be sequntital 
assign almostfull = (count == FIFO_DEPTH-1)? 1 : 0;   //was -2 instead of -1 **bug**
assign almostempty = (count == 1)? 1 : 0;

endmodule