//以上就是我们面临的五种冒险的分析，简单总结如下：
//a.在一个周期开始，EX 阶段要使用上一条处在 EX 阶段指令的执行结果，此时我们将 EX/MEM 寄存器的数据前递。
//b.在一个周期开始，EX 阶段要使用上一条处在 MEM 阶段指令的执行结果，此时我们将 MEM/WB 寄存器的数据前递。
//c.在一个周期开始，EX 阶段要使用上一条处在 WB 阶段指令的执行结果，此时不需要前递（寄存器堆前递机制）
//d.在第一种情况下，如果是上一条是访存指令，即发生加载—使用型冒险。则需要停顿一个周期。
//e.在发生加载——使用型冒险的时候，如果是load后跟着store指令，并且load指令的rd与store指令的rs1 不同而与rs2相同，则不需要停顿，只需要将MEM/WB 寄存器的数据前递到MEM阶段。
`include "define.v"
module forward_unit(
	
	input	wire	[`REG_ADDR]			rs1_id_ex_o_i_			, //来自rs1_id_ex_o_i的输出
	input 	wire	[`REG_ADDR]			rs2_id_ex_o_i			,
	input 	wire	[`REG_ADDR]			rd_ex_mem_o_i			,
	input 	wire	[`REG_ADDR]			rd_mem_wb_o_i			,
	input 	wire 						reg_w_ena_ex_mem_o_i	,
	input 	wire 						reg_w_ena_mem_wb_o_i	,
	input 	wire 						memwrite_id_ex_o_i		,
    input 	wire 						ram_w_ena_id_ex_o_i		,
	input 	wire 						ram_r_ex_mem_o_i		,

	output  wire	[1:0]				forwardA_o				,
	output  wire	[1:0]				forwardB_o				,
	output 	wire						forwardC_o				,
	output	wire						hazard_hold_o
	
    );

	assign forwardA[1] = (reg_w_ena_ex_mem_o_i && (rd_ex_mem_o_i != 5'b0) && (rd_ex_mem_o_i == rs1_id_ex_o_i));	
	assign forwardA[0] = (reg_w_ena_mem_wb_o_i && (rd_mem_wb_o_i != 5'd0) && (rd_mem_wb_o_i == rs1_id_ex_o_i));
	assign forwardB[1] = (reg_w_ena_ex_mem_o_i && (rd_ex_mem_o_i != 5'b0) && (rd_ex_mem_o_i == rs2_id_ex_o_i));
	assign forwardB[0] = (reg_w_ena_mem_wb_o_i && (rd_mem_wb_o_i != 5'd0) && (rd_mem_wb_o_i == rs2_id_ex_o_i));
	assign forwardC    = (reg_w_ena_ex_mem_o_i && (rd_ex_mem_o_i != 5'd0) && (rd_ex_mem_o_i != rs1_id_ex_o_i)&& (rd_ex_mem_o_i == rs2_id_ex_o_i)&& ram_w_ena_id_ex_o_i && ram_r_ex_mem_o_i );

	//load-use load后紧跟sw且需要停顿
	assign hazard_hold = 	MemRead_id_ex_o_i & RegWrite_id_ex_o_i & (Rd_id_ex_o_i!=5'd0)   //load
							&(!MemWrite_id_ex_i)     //非store
							& ((Rd_id_ex_o_i ==Rs1_id_ex_i) | (Rd_id_ex_o_i ==Rs2_id_ex_i))
							|
							MemRead_id_ex_o_i & RegWrite_id_ex_o_i & (Rd_id_ex_o_i!=5'd0)     //load
							&(MemWrite_id_ex_i)     //store
							& (Rd_id_ex_o_i ==Rs1_id_ex_i);


endmodule




