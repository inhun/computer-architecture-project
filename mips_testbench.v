`timescale 1ns/1ns

module mips_testbench;

reg CLK;

MIPS mips(CLK);

initial
begin
	CLK = 1'b0;
end

always
begin
	#50 CLK = ~CLK;
end
endmodule
