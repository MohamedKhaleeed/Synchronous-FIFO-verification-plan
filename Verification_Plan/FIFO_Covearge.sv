package FIFO_coverage_pkg;
import FIFO_transaction_pkg ::*;

FIFO_transaction F_cvg_txn;



class FIFO_coverage;

covergroup cvr_gp;

wr_en_cp: coverpoint F_cvg_txn.wr_en;
rd_en_cp: coverpoint F_cvg_txn.rd_en;

full_cp: coverpoint F_cvg_txn.full;
almostfull_cp: coverpoint F_cvg_txn.almostfull;
empty_cp: coverpoint F_cvg_txn.empty;
almostempty_cp: coverpoint F_cvg_txn.almostempty;
overflow_cp: coverpoint F_cvg_txn.overflow;
underflow_cp: coverpoint F_cvg_txn.underflow;
wr_ack_cp: coverpoint F_cvg_txn.wr_ack;

full_cp_cross: cross wr_en_cp,rd_en_cp,full_cp;
almostfull_cp_cross: cross wr_en_cp,rd_en_cp,almostfull_cp;
empty_cp_cross: cross wr_en_cp,rd_en_cp,empty_cp;
almostempty_cp_cross: cross wr_en_cp,rd_en_cp,almostempty_cp;
overflow_cp_cross: cross wr_en_cp,rd_en_cp,overflow_cp;
underflow_cp_cross: cross wr_en_cp,rd_en_cp,underflow_cp;
wr_ack_cp_cross: cross wr_en_cp,rd_en_cp,wr_ack_cp;

endgroup 

function sample_data(input FIFO_transaction F_txn);
	F_cvg_txn=F_txn;
	cvr_gp.sample();
endfunction 

function new();
		cvr_gp=new();
endfunction


endclass

endpackage