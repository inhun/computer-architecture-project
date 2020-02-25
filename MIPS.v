module MIPS(
	input CLK
	 );

reg [31:0] PC;

// IF
wire [31:0] next_PC_one;
wire [31:0] instruct_one;
wire [31:0] Branch_addr_four;
wire [31:0] Jump_addr_four;
wire [5:0] Opcode_one;
wire [5:0] Funct_one;

wire stall, stall_J, stall_B, stall_RAW;

// ID
wire [31:0] next_PC_two;
wire [31:0] instruct_two;
wire [4:0] Read1;
wire [4:0] Read2;
wire [31:0] Rdata1_two;
wire [31:0] Rdata2_two;
wire [4:0] Wreg_addr_two;
wire [31:0] Branch_or_offset_two;
wire [5:0] Opcode_two;
wire [5:0] Funct_two;
wire [31:0] Jump_addr_two;

wire RegWrite_two;
wire ALUSrc_two;
wire MemWrite_two;
wire MemRead_two;
wire MemToReg_two;
wire JToPC_two;
wire Branch_two;
wire [3:0] ALUOp_two;
wire RegDst_two;

// EX
wire [31:0] next_PC_three;
wire [31:0] Rdata1_three;
wire [31:0] Rdata2_three;
wire [31:0] ALU_result_three;
wire [31:0] Branch_or_offset_three;
wire [31:0] Branch_addr_three;
wire [31:0] Jump_addr_three;
wire [4:0] Wreg_addr_three;
wire [31:0] DM_Write_data_three;
wire zero_three;
wire [5:0] Opcode_three;
wire [31:0] Lw_Sw_offset_three;
wire [31:0] ALU_B;
wire [31:0] instruct_three;

wire RegWrite_three;
wire MemWrite_three;
wire MemRead_three;
wire MemToReg_three;
wire JToPC_three;
wire Branch_three;
// wire PCSrc_three;
wire ALUSrc_three;
wire [3:0] ALUOp_three;

// MEM
wire [31:0] ALU_result_four;
wire [4:0] Wreg_addr_four;
wire [31:0] MemRdata_four;
wire [31:0] Wdata_four;
wire [31:0] DM_Write_data_four;
wire zero_four;
wire [31:0] Branch_or_offset_four;
wire [31:0] next_PC_four;
wire [31:0] Read_or_Write_addr;

wire RegWrite_four;
wire JToPC_four;
wire PCSrc_four;
wire MemWrite_four;
wire MemRead_four;
wire MemToReg_four;
wire Branch_four;

// WB
wire [31:0] MemRdata_five;
wire [4:0] Wreg_addr_five;
wire RegWrite_five;
wire [31:0] ALU_result_five;
wire [31:0] Reg_Write_data_five;
wire MemToReg_five;
wire Branch_five;


assign next_PC_one = PC + 32'd4;  // 확인
assign Branch_addr_three = {Branch_or_offset_three[29:0], 2'b00};  // 확인
assign PCSrc_four = (Branch_four && zero_four);  // 확인

assign Opcode_one = instruct_one[31:26];  // 확인
assign Funct_one = instruct_one[5:0]; //

assign Jump_addr_three = {next_PC_three[31:28], {instruct_three[25:0], 2'b00}};
// assign Jump_addr_two = {next_PC_two[31:28], {instruct_two[25:0], 2'b00}};
assign Read1 = instruct_two[25:21];
assign Read2 = instruct_two[20:16];
assign Wreg_addr_two = (RegDst_two) ? instruct_two[15:11] : instruct_two[20:16];
assign Branch_or_offset_two = (instruct_two[15] == 1) ? {16'hFFFF, instruct_two[15:0]} : {16'h0000, instruct_two[15:0]}; // sign extend.

assign Lw_Sw_offset_three = (Branch_or_offset_three[31] == 1) ? {2'b11, Branch_or_offset_three[31:2]} : {2'b00, Branch_or_offset_three[31:2]};
// if instruction is lw or sw, divide the offset by 4.
assign ALU_B = (Opcode_three == 6'b100011 || Opcode_three == 6'b101011) ? Lw_Sw_offset_three : ((ALUSrc_three) ? Branch_or_offset_three : Rdata2_three);
// if instruction is lw or sw, ALU_B is Lw_Sw_offset.

assign DM_Write_data_three = Rdata2_three;
assign Read_or_Write_addr = ALU_result_four;
assign Reg_Write_data_five = (MemToReg_five) ? MemRdata_five : ALU_result_five;

Instruction_Mem Instr_mem(PC[8:2], instruct_one); // Asynchronous module.
/*
	[8:0]         [8:2]
0	000 0000 00   000 0000 => 0
4	000 0001 00   000 0001 => 1
8	000 0010 00   000 0010 => 2
12	000 0011 00   000 0011 => 3
16	000 0100 00   000 0100 => 4
20	000 0101 00   000 0101 => 5
24	000 0110 00   000 0110 => 6
28	000 0111 00   000 0111 => 7

*/
Control control(Opcode_two, Funct_two, RegDst_two, RegWrite_two, ALUSrc_two, MemWrite_two, MemRead_two, MemToReg_two, JToPC_two, Branch_two, ALUOp_two); // Asynchronous module.
Register Reg(CLK, RegWrite_five, Read1, Read2, Wreg_addr_five, Reg_Write_data_five, Rdata1_two, Rdata2_two); // Synchronous module.
Staller sta (CLK, Opcode_two, Wreg_addr_two, Wreg_addr_three, Wreg_addr_four, Wreg_addr_five, Read1, Read2, Branch_two, Branch_three, Branch_four, Branch_five, JToPC_two, JToPC_three, stall, stall_J, stall_B, stall_RAW);
ALU alu(ALUOp_three, Rdata1_three, ALU_B, ALU_result_three, zero_three); // Asynchronous module.
Data_Mem DM(CLK, MemWrite_four, MemRead_four, Read_or_Write_addr[6:0], DM_Write_data_four, MemRdata_four); // Synchronous module.

always @(posedge stall_RAW)
begin
	PC <= PC-4;
end

always @(posedge stall_J)
begin
	PC <= PC - 4;
end

always @(posedge stall_B)
begin
	PC <= PC - 4;
end


always @(posedge CLK)
begin
	// PC <= (JToPC) ? Jump_addr : ((PCSrc) ? (Branch_addr + Next_PC) : Next_PC);
	// if (stall_J)
	//	PC <= next_PC_one - 32'd4;
	if (stall_B)
		PC <= next_PC_one - 32'd4;
	else if (stall_RAW)
		PC <= next_PC_one - 32'd4;

	else if (JToPC_three == 1)
		PC <= Jump_addr_three;
	else if (PCSrc_four == 1)
		PC <= Branch_addr_four + next_PC_four;
	else
		PC <= next_PC_one;

	// PC <= (stall==1) ? (next_PC_one - 32'd4) : ((JToPC_four==1) ? jump_addr_four : ((PCSrc_four==1) ? (Branch_addr_four + next_PC_four) : next_PC_one));
end

initial
begin
	PC = 32'b1111_1111_1111_1111_1111_1111_1111_1100;
end

pipe1 p1(CLK, next_PC_one, instruct_one, Opcode_one, Funct_one, next_PC_two, instruct_two, Opcode_two, Funct_two);
pipe2 p2(CLK, Rdata1_two, Rdata2_two, Wreg_addr_two, next_PC_two, Branch_or_offset_two, RegWrite_two, ALUSrc_two, MemWrite_two, MemRead_two, MemToReg_two, JToPC_two, Branch_two, ALUOp_two, Opcode_two, instruct_two, Rdata1_three, Rdata2_three, Wreg_addr_three, next_PC_three, Branch_or_offset_three, RegWrite_three, ALUSrc_three, MemWrite_three, MemRead_three, MemToReg_three, JToPC_three, Branch_three, ALUOp_three, Opcode_three, instruct_three);
pipe3 p3(CLK, ALU_result_three, Wreg_addr_three, RegWrite_three, MemWrite_three, MemRead_three, MemToReg_three, JToPC_three, Branch_three, PCSrc_three, Branch_or_offset_three, Branch_addr_three, Jump_addr_three, DM_Write_data_three, zero_three, next_PC_three, ALU_result_four, Wreg_addr_four, RegWrite_four, MemWrite_four, MemRead_four, MemToReg_four, JToPC_four, Branch_four, PCSrc_four, Branch_or_offset_four, Branch_addr_four, Jump_addr_four, DM_Write_data_four, zero_four, next_PC_four);
pipe4 p4(CLK, MemRdata_four, Wreg_addr_four, RegWrite_four, ALU_result_four, MemToReg_four, Branch_four, MemRdata_five, Wreg_addr_five, RegWrite_five, ALU_result_five, MemToReg_five, Branch_five);




endmodule
