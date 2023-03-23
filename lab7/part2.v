
// This is the template for Part 2 of Lab 7.

// Paul Chow
// November 2021


module part2(iResetn,iPlotBox,iBlack,iColour,iLoadX,iXY_Coord,iClock,oX,oY,oColour,oPlot,oDone);
   parameter X_SCREEN_PIXELS = 8'd160;
   parameter Y_SCREEN_PIXELS = 7'd120;

   input wire iResetn, iPlotBox, iBlack, iLoadX;
   input wire [2:0] iColour;
   input wire [6:0] iXY_Coord;
   input wire 	    iClock;
   output wire [7:0] oX;         // VGA pixel coordinates
   output wire [6:0] oY;

   output wire [2:0] oColour;     // VGA pixel colour (0-7)
   output wire 	   oPlot;       // Pixel draw enable
   output wire       oDone;       // goes high when finished drawing frame

   //
   // Your code goes here
   //


endmodule // part2

module fill
	(
		CLOCK_50,						//	On Board 50 MHz
		// Your inputs and outputs here
		KEY,							// On Board Keys
		// The ports below are for the VGA output.  Do not change.
		VGA_CLK,   						//	VGA Clock
		VGA_HS,							//	VGA H_SYNC
		VGA_VS,							//	VGA V_SYNC
		VGA_BLANK_N,						//	VGA BLANK
		VGA_SYNC_N,						//	VGA SYNC
		VGA_R,   						//	VGA Red[9:0]
		VGA_G,	 						//	VGA Green[9:0]
		VGA_B   						//	VGA Blue[9:0]
	);

	input			CLOCK_50;				//	50 MHz
	input	[3:0]	KEY;					
	// Declare your inputs and outputs here
	// Do not change the following outputs
	output			VGA_CLK;   				//	VGA Clock
	output			VGA_HS;					//	VGA H_SYNC
	output			VGA_VS;					//	VGA V_SYNC
	output			VGA_BLANK_N;				//	VGA BLANK
	output			VGA_SYNC_N;				//	VGA SYNC
	output	[7:0]	VGA_R;   				//	VGA Red[7:0] Changed from 10 to 8-bit DAC
	output	[7:0]	VGA_G;	 				//	VGA Green[7:0]
	output	[7:0]	VGA_B;   				//	VGA Blue[7:0]
	
	wire resetn;
	assign resetn = KEY[0];
	
	// Create the colour, x, y and writeEn wires that are inputs to the controller.

	wire [2:0] colour;
	wire [7:0] x;
	wire [6:0] y;
   // wire enable;
   wire [9:0] xy_input;
	assign xy_input = SW[9:0];
   wire black = !(KEY[2]);
	wire writeEn = !(KEY[1]);
	wire load = !(KEY[3]);

	// Create an Instance of a VGA controller - there can be only one!
	// Define the number of colours as well as the initial background
	// image file (.MIF) for the controller.
	vga_adapter VGA(
			.resetn(resetn),
			.clock(CLOCK_50),
			.colour(colour),
			.x(x),
			.y(y),
			.plot(writeEn),
			/* Signals for the DAC to drive the monitor. */
			.VGA_R(VGA_R),
			.VGA_G(VGA_G),
			.VGA_B(VGA_B),
			.VGA_HS(VGA_HS),
			.VGA_VS(VGA_VS),
			.VGA_BLANK(VGA_BLANK_N),
			.VGA_SYNC(VGA_SYNC_N),
			.VGA_CLK(VGA_CLK));
		defparam VGA.RESOLUTION = "160x120";
		defparam VGA.MONOCHROME = "FALSE";
		defparam VGA.BITS_PER_COLOUR_CHANNEL = 1;
		defparam VGA.BACKGROUND_IMAGE = "black.mif";
			
	// Put your code here. Your code should produce signals x,y,colour and writeEn
	// for the VGA controller, in addition to any other functionality your design may require.

   wire controlA, controlB, controlC, controlD;
	wire counterDone;
	

   part2 p0(resetn, writeEn, black, colour, load, xy_input, iClock, x, y, colour, );
	control c0(resetn, CLOCK_50, counterDone, load, writeEn, black, controlA, controlB, controlC, controlD);
	datapath d0(resetn, CLOCK_50, xy_input, black, controlA, controlB, controlC, controlD, colour, {x,y}, counterDone);
	
endmodule

// State diagram - control module
module control(resetn, clk, done, load, GO, black, ldA, ldB, ldC, ldD);
	input resetn;
	input clk;
	input done;
	input load;
	input GO;
	input black;
	output reg ldA;
	output reg ldB;
	output reg ldC;
	output reg ldD;

	reg [2:0] current, next;

	localparam 	A = 2'b00,
							B = 2'b01,
							C = 2'b10,
							D = 2'b11;


	// State Table
	always@(*) begin
		case (current)
			A: begin
				if (black)
					next = D;
				else if (!load)			// Stay at A until Load X is pressed (KEY 3)
					next = A;
				else
					next = B;
			end
			B: begin
				if (black)
					next = D;
				else if (!GO)			// Stay at B until GO is pressed (GO is writeEn)
					next = B;
				else
					next = C;
			end
			C: begin
				if (black)
					next = D;
				else if (!done)			// Stay at C until counter is finished
					next = C;
				else
					next = A;
			end
			D: begin
				if (!done)			// Stay at black until finished
					next = D;
				else
					next = A;
			end
			default: next = A;
		endcase
	end

	// Datapath controls
	always@(*) begin
		// Setting all signals to 0 at first
		ldA = 1'b0;
		ldB = 1'b0;
		ldC = 1'b0;
		ldD = 1'b0;

		case (current)
			A: ldA = 1'b1;
			B: ldB = 1'b1;
			C: ldC = 1'b1;
			D: ldD = 1'b1;
		endcase
	end

	always@(posedge clk) begin
		if (!resetn)
			current <= A;
		else
			current <= next;
	end
endmodule


// Datapath module
module datapath(resetn, clk, xy_input, black, cnA, cnB, cnC, cnD, colour, coordinates, done);
	input resetn;
	input clk;
	input [9:0] xy_input;
	input black;
	input cnA;
	input cnB;
	input cnC;
	input cnD;
	output reg [2:0] colour;
	output reg [14:0] coordinates;
	output reg done;

	reg [7:0] xtemp;
	reg [6:0] ytemp;
	reg [4:0] counter;

	//rows
	reg [6:0] ytemp1;
	reg [6:0] ytemp2;
	reg [6:0] ytemp3;

	always@(posedge clk) begin

		if (!resetn) begin
			xtemp <= 0;
			ytemp <= 0;
			colour <= 0;
			coordinates <= {xtemp, ytemp};

			counter <= 0;
			done <= 0;
		end

		else begin
			if (cnA) begin
				done <= 0;

				xtemp <= {1'b0, xy_input[6:0]};
			end

			if (cnB) begin
				ytemp <= xy_input[6:0];
				coordinates <= {xtemp, ytemp};
				
				if (black)					// If black is true, make all colours black
					colour <= 0;

				else
					colour <= xy_input[9:7];
			end

			if (cnC) begin
				counter <= counter + 1;
				ytemp1 = ytemp + 1;
				ytemp2 = ytemp1 + 1;
				ytemp3 = ytemp2 + 1;

				if (counter < 4) //first row of square
					coordinates <= {xtemp + counter, ytemp};
				else if (counter < 8) //second row of square
					coordinates <= {xtemp + (counter - 4), ytemp1};
				else if (counter < 12) // third row of square
					coordinates <= {xtemp + (counter - 8), ytemp2};
				else if (counter < 16) // fourth row of square
					coordinates <= {xtemp + (counter - 12), ytemp3};
				else
					done <= 1'b1;
			end

			if (cnD) begin
				colour <= 0;
				coordinates <= coordinates + 1;
				if (coordinates >= 15'b100111111111111)
					done <= 1'b1;
			end
		end

		if (done)
			counter <= 0;
	end

endmodule