#include <iostream>
#include <fstream>
#include "8080emuCPP.h"
#include "gtuos.h"
#include "memory.h"

	// This is just a sample main function, you should rewrite this file to handle problems 
	// with new multitasking and virtual memory additions.
int main (int argc, char**argv)
{
	if (argc != 3){
		std::cerr << "Usage: prog exeFile debugOption\n";
		exit(1); 
	}
	int DEBUG = atoi(argv[2]);

	memory mem;
	CPU8080 theCPU(&mem);
	GTUOS	theOS;
	std::ofstream outputfile;		

	outputfile.open("output.txt");	// Opened the output file

	theCPU.ReadFileIntoMemoryAt(argv[1], 0x0000);	
 
	do	
	{
		theCPU.Emulate8080p(DEBUG);
		if(theCPU.isSystemCall())
			theOS.handleCall(theCPU, outputfile);
	}	while (!theCPU.isHalted());

	outputfile.close();		// Closed the output file after CPU is halted


	return 0;
}

