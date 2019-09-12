module demoreg (
              output [15:0] per_dout,  // data output
              input         mclk,      // system clock
              input  [13:0] per_addr,  // address bus  
              input  [15:0] per_din,   // data input
              input         per_en,    // active bus cycle enable
              input [1:0]   per_we,    // write control
              input         puc_rst    // power-up clear reset 
             );

   reg [15:0] 		    r1;          // mapped to 0x110
   reg [15:0] 		    r1_next;     
   reg [ 7:0] 		    r2;          // mapped to 0x112
   reg [ 7:0] 		    r2_next;
   reg [ 7:0] 		    r3;          // mapped to 0x115
   reg [ 7:0] 		    r3_next;
   reg [15:0] 		    dmux;
   
   always @(posedge mclk or posedge puc_rst)
    begin
       r1 <= puc_rst ? 16'b0 : r1_next;
       r2 <= puc_rst ?  8'b0 : r2_next;
       r3 <= puc_rst ?  8'b0 : r3_next;

    end
   
   always @*
     begin	
	r1_next = r1;
	r2_next = r2;
	r3_next = r3;
	dmux    = 16'h0;	
	if (per_en)
	  begin
	     // write
	     case (per_addr)
	       14'h88 : r1_next = ( per_we[0] &  per_we[1] ) ? per_din : r1;
	       14'h89 : r2_next = ( per_we[0] & ~per_we[1] ) ? per_din : r2;
	       14'h8a : r3_next = (~per_we[0] &  per_we[1] ) ? per_din : r3;
	     endcase
	     // read
	     case (per_addr)
	       14'h88 : dmux = ( ~per_we[0] & ~per_we[1] ) ?       r1  : 16'h0;
	       14'h89 : dmux = ( ~per_we[0] & ~per_we[1] ) ? {8'h0,r2} : 16'h0;
	       14'h8a : dmux = ( ~per_we[0] & ~per_we[1] ) ? {r3,8'h0} : 16'h0;
	     endcase
	  end
     end
   
   assign per_dout = dmux;
 
endmodule
