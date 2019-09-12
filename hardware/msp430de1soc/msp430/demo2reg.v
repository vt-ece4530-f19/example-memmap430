module demo2reg (output [15:0] per_dout, // data output
		 input 	       mclk,     // system clock
		 input [13:0]  per_addr, // address bus  
		 input 	       per_din,  // data input
		 input 	       per_en,   // active bus cycle enable
		 input [1:0]   per_we,   // write control
		 input 	       puc_rst,  // power-up clear reset
		 output        irq,      // interrupt request
		 input         irqacc    // interrupt acknowledge
		 );
   
   reg  [7:0] 		       sec;
   wire [7:0] 		       sec_next;
   reg  [27:0] 		       cnt50;
   wire [27:0] 		       cnt50_next;		       
   reg 			       pending;
   wire			       pending_next;   

   wire 		       valid_read;
   wire                        tick;
   
   always @(posedge mclk or posedge puc_rst)
     begin
	cnt50   <= puc_rst ? 16'b0 : cnt50_next;
	sec     <= puc_rst ? 16'b0 : sec_next;
	pending <= puc_rst ? 1'b0  : pending_next;	
     end

   // counting logic
   assign tick = (cnt50 == 28'h2FAF080);
   assign cnt50_next = tick ? 28'h0 : cnt50 + 28'b1;
   assign sec_next = tick ? sec + 1'b1 : sec;

   // interrupt logic
   assign pending_next = tick   ? 1'b1 :
			 irqacc ? 1'b0 :
			 pending;
   assign irq = pending;
   
   // memory mapped interface
   assign valid_read  = per_en & (per_addr == 14'h8b) & ~per_we[0] & ~per_we[1];
   assign per_dout    = valid_read  ? {8'b0,sec} : 16'h0; 
   
endmodule
