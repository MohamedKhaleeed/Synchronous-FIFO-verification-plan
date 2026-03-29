module TOP();
    bit clk=1;
    always #5 clk = ~clk;
    fifo_interface intrf(clk);
    FIFO_tb tb(intrf);
	monitor Mon(intrf);
    FIFO dut(intrf);
endmodule