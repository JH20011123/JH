#include <iomanip>
#include <iostream>
#include "CPU.h"
#include "globals.h"

#define VERBOSE 0

using namespace std;

CPU::CPU() {}

// Reset stateful modules
void CPU::init(string inst_file) {
	// Initialize the register file
	rf.init(false);
	// Load the instructions from the memory
	mem.load(inst_file);
	// Reset the register
	PC = 0;
	IR = 0;
	MDR = 0;
	A = 0;
	B = 0;
	ALUOut = 0;
	SR = 0;

	// Set the debugging status
	status = CONTINUE;
}

// This is a cycle-accurate simulation
uint32_t CPU::tick() {
	// These are just one of the implementations ...

	// parsed & control signals (wire)
	CTRL::ParsedInst parsed_inst;
	CTRL::Controls controls;
	uint32_t ext_imm;

	// Default wires and control signals
	uint32_t rs_data, rt_data;
	uint32_t wr_addr;
	uint32_t wr_data;
	uint32_t operand1;
	uint32_t operand2;
	uint32_t alu_result;

	// PC_next
	uint32_t PC_next;

	// You can declare your own wires (if you want ...)
	uint32_t mem_data;
	uint32_t address;

	// Split the instruction
	ctrl.splitInst(IR, &parsed_inst);
	ctrl.controlSignal(SR, parsed_inst.opcode, parsed_inst.funct, &controls);
	ctrl.signExtend(parsed_inst.immi, controls.SignExtend, &ext_imm);
	if (status != CONTINUE) return 0;

	rf.read(parsed_inst.rs, parsed_inst.rt, &rs_data, &rt_data);
	if (status != CONTINUE) return 0;

	operand1 = 	controls.ALUSrcA 		? A : PC;
	operand2 = 	(controls.ALUSrcB == 0) ? B :
			   	(controls.ALUSrcB == 1) ? 4 :
			   	(controls.ALUSrcB == 2) ? ext_imm :
				ext_imm << 2;
	
	alu.compute(operand1, operand2, parsed_inst.shamt, controls.ALUOp, &alu_result);
	if (status != CONTINUE) return 0;

	// MEM
	address = controls.IorD ? ALUOut : PC;
	mem.memAccess(address, &mem_data, B, controls.MemRead, controls.MemWrite);
	if (status != CONTINUE) return 0;

	// Update the PC
	PC_next	= 	(controls.PCSource == 0) ? alu_result :
			   	(controls.PCSource == 1) ? ALUOut :
			   	(controls.PCSource == 3) ? rs_data :
				(PC & 0xF0000000) | (parsed_inst.immj << 2);

	// WB
	wr_addr = 	(controls.RegDst == 0) ? parsed_inst.rt :
				(controls.RegDst == 1) ? parsed_inst.rd :
 				31;
	wr_data = 	(controls.MemtoReg == 0) ? ALUOut :
				(controls.MemtoReg == 1) ? MDR :
			  	PC;

	rf.write(wr_addr, wr_data, controls.RegWrite);
	if (status != CONTINUE) return 0;

	// Update the registers last ...
	if (controls.PCWrite || (controls.PCWriteCond && alu_result))
		PC = PC_next;
	if (controls.IRWrite)
		IR = mem_data;
	MDR = mem_data;
	A = rs_data;
	B = rt_data;
	ALUOut = alu_result;
	SR = controls.State;

	if (!IR) status = TERMINATE;
	return 1;
}

