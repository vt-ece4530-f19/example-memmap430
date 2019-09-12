module msp430de0nano(
	CLOCK_50,
	LED,
	KEY,
	SW,
	HDR,
	HDR_IN 
);
input 		          		CLOCK_50;
output		     [7:0]		LED;
input 		     [1:0]		KEY;
input 		     [3:0]		SW;
inout 		    [33:0]		HDR;
input 		     [1:0]		HDR_IN;


   reg [23:0] 	      heartbeat;

	// heartbeat indicator
   always @(posedge CLOCK_50, negedge KEY[0])
     if (KEY[0] == 1'b0)
       heartbeat <= 24'b0;
     else
       heartbeat <= heartbeat + 1'b1;
	assign LED[0] = heartbeat[23];

	// uart indicator
	wire rs232_0_txd;
	wire rs232_1_txd;	
	wire rs232_0_rxd;
	wire rs232_1_rxd;	
	reg [20:0] uartled_dly;	
	always @(posedge CLOCK_50, negedge KEY[0])
	  if (~KEY[0])  uartled_dly <= 21'h0;
	  else          uartled_dly <= ~(rs232_0_txd & rs232_1_rxd) ?    21'h1 :
	                               (uartled_dly > 0) ? uartled_dly + 21'h1 :
											 21'h0;
   assign LED[1] = (uartled_dly > 0) ? 1'b1 : 1'b0;

	// header pin definition
	assign HDR[0] = rs232_0_rxd; // debug uart tx
	assign HDR[2] = rs232_0_txd; // debug uart rx	
	assign HDR[1] = rs232_1_rxd; // debug uart tx
	assign HDR[3] = rs232_1_txd; // debug uart rx

		// core instantiation
	wire              debug_uart_rx;
	wire              debug_uart_tx;
	wire              user_uart_rx;
	wire              user_uart_tx;	
   wire [7:0] 	      p1_din;
   wire [7:0] 	      p1_dout;
   wire [7:0] 	      p1_dout_en;   
   wire [7:0] 	      p2_din;
   wire [7:0] 	      p2_dout;
   wire [7:0] 	      p2_dout_en;   
   wire [7:0] 	      p3_din;
   wire [7:0] 	      p3_dout;
   wire [7:0] 	      p3_dout_en;   
   wire [7:0] 	      p4_din;
   wire [7:0] 	      p4_dout;
   wire [7:0] 	      p4_dout_en;   
   wire [7:0] 	      p5_din;
   wire [7:0] 	      p5_dout;
   wire [7:0] 	      p5_dout_en;   
   wire [7:0] 	      p6_din;
   wire [7:0] 	      p6_dout;
   wire [7:0] 	      p6_dout_en;
   
   mspconnect theconnector(
	                   .clk_clk(CLOCK_50),
	                   .reset_reset_n(KEY[0]),
	                   .rs232_0_external_interface_RXD(rs232_0_rxd),
	                   .rs232_0_external_interface_TXD(rs232_0_txd),
						    .rs232_1_external_interface_RXD(rs232_1_rxd),
	                   .rs232_1_external_interface_TXD(rs232_1_txd));
	
   toplevel t0(
	       .clk_sys(CLOCK_50),
	       .reset_n(KEY[0]),
	       .p1_din(p1_din),
	       .p1_dout_en(p1_dout_en),
	       .p1_dout(p1_dout),
	       .p2_din(p2_din),
	       .p2_dout_en(p2_dout_en),
	       .p2_dout(p2_dout),
	       .p3_din(p3_din),
	       .p3_dout_en(p3_dout_en),
	       .p3_dout(p3_dout),
	       .p4_din(),
	       .p4_dout_en(p4_dout_en),
	       .p4_dout(p4_dout),
	       .p5_din(),
	       .p5_dout_en(p5_dout_en),
	       .p5_dout(p5_dout),
	       .p6_din(),
	       .p6_dout_en(p6_dout_en),
	       .p6_dout(p6_dout),
	       .debug_uart_rx(debug_uart_rx),
	       .debug_uart_tx(debug_uart_tx),
	       .user_uart_rx(user_uart_rx),
	       .user_uart_tx(user_uart_tx));
	
	assign debug_uart_rx = rs232_0_txd;
	assign user_uart_rx  = rs232_1_txd;
	assign rs232_0_rxd   = debug_uart_tx;
	assign rs232_1_rxd   = user_uart_tx;
	
   assign p1_din      = {7'b0,KEY[1]};
   assign p2_din      = {4'b0, SW[ 3:0]};
   assign p3_din      = {8'b0};

   assign LED[7:2]   = p1_dout[5:0] & p1_dout_en[5:0];

	assign HDR[11: 4]  = p3_dout[7:0] & p3_dout_en[7:0];
	assign HDR[19:12]  = p4_dout[7:0] & p4_dout_en[7:0];
	assign HDR[27:20]  = p5_dout[7:0] & p5_dout_en[7:0];
	assign HDR[33:28]  = p5_dout[5:0] & p5_dout_en[5:0];
	
endmodule
