#include <iostream>
#include <fstream>
#include <string>
#include "8080emuCPP.h"
#include "gtuos.h"

uint64_t GTUOS::handleCall(const CPU8080 & cpu, std::ofstream & outputfile){
	uint8_t registerA = cpu.state->a;		// Assign the registerA value
	if(registerA == 4){			// PRINT_B
		outputfile << (int) cpu.state->b;	//Prints the contents of Reg B to the output file.
	}
	else if(registerA == 3){	// PRINT_MEM
		uint16_t address = cpu.state->b << 8 | cpu.state->c;	// Combine the register B and C by shifting B register to 8 bits left
		outputfile <<(int)cpu.memory->at(address);	// Prints the of contents of memory pointed by Reg B and C to the output file.
	}
	else if(registerA == 7){	// READ_B
		std::string value = " ";
		std::ifstream inputfile;
		inputfile.open("input.txt");	// Input file opened
		std::getline(inputfile, value);	// Get the first line of the input file
		cpu.state->b = std::atoi(value.c_str());	// Convert string to the integer
		inputfile.close();	// Close the input file
	}
	else if(registerA == 2){	// READ_MEM
		std::string value = " ";
		uint16_t address = cpu.state->b << 8 | cpu.state->c;	// Combine the register B and C by shifting B register to 8 bits left
		std::ifstream inputfile;
		inputfile.open("input.txt");   // Input file opened
		std::getline(inputfile, value);   // Get the first line of the input file
		cpu.memory->at(address) = std::atoi(value.c_str());  // Convert string to the integer
		inputfile.close();	// Close the input file
	}
	else if(registerA == 1){	// PRINT_STR
		uint8_t i = 0;
		uint16_t address = cpu.state->b << 8 | cpu.state->c;	// Combine the register B and C by shifting B register to 8 bits left
		while(cpu.memory->at((address+i) )!= '\0'){		// Loop till null character
			outputfile<<cpu.memory->at(address+i);
			i++;
		}
	}
	else if(registerA == 8){	// READ_STR
			std::string str = " ";
			std::ifstream inputfile;
			inputfile.open("input.txt");	// Open the input file
			std::getline(inputfile, str);	// Get the first line of the input file
			int size = str.size();	// Assign the size
			uint16_t address = cpu.state->b << 8 | cpu.state->c;	// Combine the register B and C by shifting B register to 8 bits left
			int i = 0;
			for( ; i < size ; i++)
				cpu.memory->at(address + i) = str[i];
			cpu.memory->at(address + i) = '\0';		// Add the null character to the end
			inputfile.close();		// Close the input file
	}
	return 0;
}
