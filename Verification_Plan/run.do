vlib work
vlog FIFO.sv FIFO_tb.sv FIFO_Covearge.sv FIFO_scoreboard.sv FIFO_transaction.sv Interface.sv monitor.sv shared_pkg.sv tb_TOP.sv +cover
vsim -voptargs=+acc work.TOP -cover
add wave *
coverage save TOP.ucdb -du work.FIFO -onexit
run -all
quit -sim
vcover report TOP.ucdb -details -annotate -all -output coverage_rpt.txt