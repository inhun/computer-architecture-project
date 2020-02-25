// `define DEBUG_CPU_REG 0
module Register(
		input wire CLK,
		input wire RegWrite, // control signal
		input wire [4:0] read1, read2,
		input wire [4:0] wrreg,
		input wire [31:0] wrdata,
		output reg [31:0] data1, data2 );

reg [31:0] mem [0:31];  // 32-bit memory with 32 entries

initial
begin
	// $display("$v0, $v1, $t0, $t1, $t2, $t3, $t4, $t5, $t6, $t7");
	//$monitor("%b, %b, %b, %b, %b, %b, %b, %b, %b, %b",
		//mem[0][31:0],		/* $zero */
		//mem[16][31:0],	/* $s0 */
		//mem[17][31:0],	/* $s1 */
		//mem[18][31:0],	/* $s2 */
		//mem[19][31:0],	/* $s3 */
		//mem[20][31:0],	/* $s4 */
		//mem[21][31:0],	/* $s5 */
		//mem[22][31:0],	/* $s6 */
		//mem[23][31:0]		/* $s7 */
		//);
	mem[0] = 32'd0; // $zero = 0;
end

always @(*)
begin
	if (read1 == 5'd0) // $zero
		data1 = 32'd0;
	// else if ((read1 == wrreg) && RegWrite)
	//	data1 = wrdata;
	else
		data1 = mem[read1][31:0];
end

always @(*)
begin
	if (read2 == 5'd0) // $zero
		data2 = 32'd0;
	// else if ((read2 == wrreg) && RegWrite)
	//	data2 = wrdata;
	else
		data2 = mem[read2][31:0];
end

always @(posedge CLK)
begin
	if (RegWrite && wrreg != 5'd0) // $zero can not be changed.
	begin
		// write a non $zero register
		mem[wrreg] <= wrdata;
	end
end
endmodule
