#include <iostream>
#include <cstdlib>
#include <iomanip>
#include <fstream>
#include <bitset>
#include "globals.h"
#include "TOP.h"

using namespace std;

int main()
{
	//
	ofstream fout_rd_addr1;
	ofstream fout_rd_addr2;
	ofstream fout_wr_addr;
	ofstream fout_shamt;
	ofstream fout_funct;
	ofstream fout_regwr;
	ofstream fout_rd_data1;
	ofstream fout_rd_data2;
	ofstream fout_wr_data;

	fout_rd_addr1.open("rd_addr1.mem");
	fout_rd_addr2.open("rd_addr2.mem");
	fout_wr_addr.open("wr_addr.mem");
	fout_shamt.open("shamt.mem");
	fout_funct.open("funct.mem");
	fout_regwr.open("regwr.mem");
	fout_rd_data1.open("rd_data1.mem");
	fout_rd_data2.open("rd_data2.mem");
	fout_wr_data.open("wr_data.mem");

	srand(0);
	// Input
	uint32_t rd_addr1;
	uint32_t rd_addr2;
	uint32_t wr_addr;
	uint32_t shamt;
	uint32_t aluop;
	uint32_t RegWrite;

	// Output
	uint32_t rd_data1;
	uint32_t rd_data2;
	uint32_t wr_data;

	TOP top;

	// You should debug using various functions!
	std::srand(0);
	uint32_t operand1;
	uint32_t operand2;
	uint32_t alu_result_ref;

	// I'm providing 100 reference tests!
	ifstream fin_op1_ref;
	ifstream fin_op2_ref;
	ifstream fin_shamt_ref;
	ifstream fin_funct_ref;
	ifstream fin_result_ref;
	fin_op1_ref.open("operand1.ref");
	fin_op2_ref.open("operand2.ref");
	fin_shamt_ref.open("shamt.ref");
	fin_funct_ref.open("funct.ref");
	fin_result_ref.open("alu_result.ref");

	int PASSED = 0;
	int FAILED = 0;
	for (int cycle = 0; cycle < 100; cycle++)
	{
		rd_addr1 = rand() % (REGSIZE);
		rd_addr2 = rand() % (REGSIZE);
		wr_addr = rand() % (REGSIZE);

		fin_op1_ref >> operand1;
		top.rf.register_files[rd_addr1] = operand1;
		fin_op2_ref >> operand2;
		top.rf.register_files[rd_addr2] = operand2;
		fin_shamt_ref >> shamt;
		fin_funct_ref >> aluop;
		fin_result_ref >> alu_result_ref;

		top.tick(rd_addr1, rd_addr2, wr_addr, shamt, aluop, 1,
				 &rd_data1, &rd_data2, &wr_data);

		if (alu_result_ref == top.rf.register_files[wr_addr] &&
			operand1 == rd_data1 && operand2 == rd_data2)
			PASSED += 1;
		else {
			FAILED += 1;
			printf("%u %u\n%u %u\n%u %u %d\n", operand1, rd_data1, operand2, rd_data2,
				alu_result_ref, top.rf.register_files[wr_addr], cycle);
		}
	}
	cout << "PASSED: " << PASSED << ", FAILED: " << FAILED << endl;

	for (int cycle = 0; cycle < 10000; cycle++)
	{
		// Set random inputs
		rd_addr1 = rand() % (REGSIZE);
		rd_addr2 = rand() % (REGSIZE);
		wr_addr = rand() % (REGSIZE);
		shamt = rand() % 32;
		aluop = rand() % 14;
		RegWrite = rand() % 2;

		top.tick(rd_addr1, rd_addr2, wr_addr, shamt, aluop, RegWrite,
				 &rd_data1, &rd_data2, &wr_data);

		fout_rd_addr1 << bitset<5>(rd_addr1) << endl;
		fout_rd_addr2 << bitset<5>(rd_addr2) << endl;
		fout_wr_addr << bitset<5>(wr_addr) << endl;
		fout_shamt << std::bitset<5>(shamt) << endl;
		fout_funct << std::bitset<4>(aluop) << endl;
		fout_regwr << RegWrite << endl;
		fout_rd_data1 << setw(8) << setfill('0') << hex << rd_data1 << endl;
		fout_rd_data2 << setw(8) << setfill('0') << hex << rd_data2 << endl;
		fout_wr_data << setw(8) << setfill('0') << hex << wr_data << endl;
	}

	return 0;
}
