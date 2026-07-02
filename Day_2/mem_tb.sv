parameter DEPTH = 16;
parameter WIDTH = 16;
parameter ADDR_WIDTH = $clog2(DEPTH);

class mem_tx;
	rand bit wr_rd;
	rand bit [ADDR_WIDTH-1:0]addr;
	rand bit [WIDTH-1:0]wdata;
	bit [WIDTH-1:0]rdata;

	function void print();
		$display("\t wr_rd = %0b",wr_rd);
		$display("\t address = %0d",addr);
		$display("\t wdata = %0b",wdata);
		$display("\t rdata = %0b",rdata);
	endfunction

endclass

//common file:



class mem_common;
	static string testcase = "test_nwr_nrd";
	static int count = 3;
	static int bfm_count;
	static int mon_count;
	static int num_matches;
	static int num_mismatches;
	static mailbox gen2bfm = new();
	static mailbox mon2sbd = new();
	static mailbox mon2cov = new();
endclass

//Generator:

class mem_gen;
	mem_tx tx;
  	bit [ADDR_WIDTH-1:0] wr_addr;
	task run();
		case(mem_common::testcase)
			"test_1wr": begin
							tx = new();
							tx.randomize() with {wr_rd == 1;};
							mem_common::gen2bfm.put(tx);
						end

			"test_5wr": begin
							repeat(5) begin
								tx = new();
								tx.randomize() with {wr_rd == 1;};
								mem_common::gen2bfm.put(tx);
							end
						end

			"test_nwr": begin
							repeat(mem_common::count) begin
								tx = new();
								tx.randomize() with {wr_rd == 1;};
								mem_common::gen2bfm.put(tx);
							end
						end

			"test_1wr_1rd": begin
								tx = new();
								tx.randomize() with {wr_rd == 1;addr == 12;};
								mem_common::gen2bfm.put(tx);

								tx = new();
              tx.randomize() with {wr_rd == 0;addr == 12;};
								mem_common::gen2bfm.put(tx);
							end

			"test_nwr_nrd": begin
								repeat(mem_common::count) begin
									tx = new();
									tx.randomize() with {wr_rd == 1;};
                                  	wr_addr = tx.addr;
									mem_common::gen2bfm.put(tx);

									tx = new();
                                  tx.randomize() with {wr_rd == 0;addr == wr_addr;};
									mem_common::gen2bfm.put(tx);
								end
							end
		endcase
	endtask
endclass

//Interface:

interface mem_intf(input reg clk_i,rst_i);
	logic wr_rd_i,valid_i;
	logic [ADDR_WIDTH-1:0] addr_i;
	logic [WIDTH-1:0]wdata_i;
	logic [WIDTH-1:0]rdata_o;
	logic ready_o;

	clocking bfm_cb@(posedge clk_i);
		default input #0 output #1;

		output wr_rd_i,valid_i,addr_i,wdata_i;
		input rdata_o,ready_o;
	endclocking

  clocking mon_cb@(posedge clk_i);
		default input #0;

		input wr_rd_i,valid_i,addr_i,wdata_i;
		input rdata_o,ready_o;
	endclocking
endinterface

/*bfm_cb: some s/gs are i/ps & some are o/ps.
mon_cb: Every s/g is input.

-> Physical interface can only access the interface signals.
-> Virtual interface, access the signals & convert the information from one form to other form.

BFM:*/

class mem_bfm;
	mem_tx tx;
	virtual mem_intf vif;

	function new();
		vif = top.pif;
	endfunction

	task run();
		forever begin
			mem_common::gen2bfm.get(tx);
			drive_tx(tx);
			mem_common::bfm_count++;
		end
	endtask

	task drive_tx(mem_tx tx);
		// Dynamic to static conversion
		@(vif.bfm_cb);
		vif.bfm_cb.valid_i <= 1;
		vif.bfm_cb.wr_rd_i <= tx.wr_rd;
		vif.bfm_cb.addr_i  <= tx.addr;
		if(tx.wr_rd == 1)
			vif.bfm_cb.wdata_i <= tx.wdata;
		else
			vif.bfm_cb.wdata_i <= 0;
      wait(vif.bfm_cb.ready_o == 1) begin
			if(tx.wr_rd == 0) begin
				tx.rdata = vif.bfm_cb.rdata_o;
				tx.wdata = 0;
			end
			else
				tx.rdata = 0;
				// resetting the signals of virtual interface
     			// @(vif.bfm_cb);
				vif.bfm_cb.wr_rd_i <= 0;
				vif.bfm_cb.addr_i  <= 0;
				vif.bfm_cb.wdata_i <= 0;
				vif.bfm_cb.valid_i  <= 0;
      end
	endtask
endclass

//monitor:

class mem_mon;
	mem_tx tx;
	virtual mem_intf vif;

	function new();
		vif = top.pif;
	endfunction

	task run();
		forever begin
			@(vif.mon_cb);
			if(vif.mon_cb.valid_i == 1 && vif.mon_cb.ready_o == 1) begin
				tx = new();
				tx.wr_rd = vif.mon_cb.wr_rd_i;
				tx.addr  = vif.mon_cb.addr_i;
				if(vif.mon_cb.wr_rd_i == 1)
					tx.wdata = vif.mon_cb.wdata_i;
				else
					tx.wdata = 0;
				if(vif.mon_cb.wr_rd_i == 0)
					tx.rdata = vif.mon_cb.rdata_o;
				else
					tx.rdata = 0;
				mem_common::mon2sbd.put(tx);
				mem_common::mon2cov.put(tx);
				mem_common::mon_count++;
			end
		end
	endtask
endclass

//coverage:

class mem_cov;
	mem_tx tx;
	covergroup cg;
		option.per_instance = 1;
		WR_RD: coverpoint tx.wr_rd
					{ bins WRITE = {1'b1};
					  bins READ  = {1'b0}; }
		ADDR_CP: coverpoint tx.addr
					{ option.auto_bin_max = 32; }

		WR_RDXADDR: cross WR_RD,ADDR_CP;

	endgroup

	function new();
		cg = new();
	endfunction

	task run();
		forever begin
			mem_common::mon2cov.get(tx);
			cg.sample();
		end
	endtask

endclass

//Scoreboard:

class mem_sbd;
	mem_tx tx;
	bit [WIDTH-1:0]mem[int];
	task run();
		forever begin
			tx = new();
			mem_common::mon2sbd.get(tx);
			if(tx.wr_rd == 1) begin
				mem[tx.addr] = tx.wdata;
              $display("addr = %0d,wdata = %0d",tx.addr,tx.wdata);
			end
			else begin
              if(tx.rdata == mem[tx.addr]) begin
					mem_common::num_matches++;
               $display("addr = %0d,rdata = %0d",tx.addr,tx.rdata);
              end
				else begin
					mem_common::num_mismatches++;
                 
                end
			end
		end
	endtask
endclass

//Agent:

class mem_agent;
	mem_gen g;
	mem_bfm b;
	mem_mon m;
	mem_cov c;
	task run();
		g = new();
		b = new();
		m = new();
		c = new();
		fork
			g.run();
			b.run();
			m.run();
			c.run();

        join
	endtask
endclass

//Environment:

class mem_env;
	mem_agent a;
	mem_sbd s;
	task run();
		a = new();
		s = new();
		fork
			a.run();
			s.run();
		join
	endtask
endclass

/*top module:

`include "memory.v"
`include "mem_common.sv"
`include "mem_tx.sv"
`include "mem_gen.sv"
`include "mem_intf.sv"
`include "mem_bfm.sv"
`include "mem_mon.sv"
`include "mem_cov.sv"
`include "mem_agent.sv"
`include "mem_scoreboard.sv"
`include "mem_env.sv"*/

module top;
	reg clk,rst;
	mem_intf pif(clk,rst);
	mem_env env;
	memory#(.DEPTH(DEPTH),.WIDTH(WIDTH)) dut(.clk_i(pif.clk_i), 
											 .rst_i(pif.rst_i),
											 .wr_rd_i(pif.wr_rd_i),
											 .addr_i(pif.addr_i),
											 .wdata_i(pif.wdata_i),
											 .rdata_o(pif.rdata_o),														  .valid_i(pif.valid_i),
											 .ready_o(pif.ready_o));

	// clk generation
	initial begin
		clk = 1'b0;
		forever #5 clk = ~clk;
	end

	// reset operation
	initial begin
		rst = 1;						// reset for design signals
		reset_signals();				// reset for TB signals
		repeat(2)@(posedge clk);
		rst = 0;
		env=new();
		env.run();
	end

	task reset_signals();
		pif.wr_rd_i = 0;
		pif.addr_i  = 0;
		pif.wdata_i = 0;
		pif.valid_i = 0;
	endtask

	initial begin
		#100;
     	wait(mem_common::mon_count == mem_common::count*2);
      	#100;
		$display("num_matches = %0d",mem_common::num_matches);
		$display("num_mismatches = %0d",mem_common::num_mismatches);
		$display("bfm_count = %0d",mem_common::bfm_count);
		$display("mon_count = %0d",mem_common::mon_count);
		#1000;
		$finish;
		
    end
endmodule
