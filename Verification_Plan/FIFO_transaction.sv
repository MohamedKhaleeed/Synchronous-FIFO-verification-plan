package FIFO_transaction_pkg;
    class FIFO_transaction;
        bit clk;
        rand logic [15:0] data_in;
        rand logic  rst_n, wr_en, rd_en;
        logic [15:0] data_out;
        logic  wr_ack, overflow;
        logic full, empty, almostfull, almostempty, underflow;

        int WR_EN_ON_DIST = 70;
        int RD_EN_ON_DIST = 30;

        constraint wr_rd_rst_const {
            rst_n dist {1:= 95 , 0:= 5};
            wr_en dist {1:= WR_EN_ON_DIST , 0:= 100-WR_EN_ON_DIST};
            rd_en dist {1:= RD_EN_ON_DIST , 0:= 100-RD_EN_ON_DIST};
        }
    endclass //FIFO_transaction

    
endpackage